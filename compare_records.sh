#!/bin/bash

CANDIDATE1=Warren
CANDIDATE2=Sanders

rm SAME
rm DIFFERENT

for YEAR in 2013 2014 2015 2016 2017 2018 2019
do

case $YEAR in
	2013)
		CONGRESS=113
		SESSION=1
		VOTES=00291
		;;
	2014)
		CONGRESS=113
		SESSION=2
		VOTES=00366
		;;
	2015)
		CONGRESS=114
		SESSION=1
		VOTES=00339
		;;
	2016)
		CONGRESS=114
		SESSION=2
		VOTES=00163
		;;
	2017)
		CONGRESS=115
		SESSION=1
		VOTES=00325
		;;
	2018)
		CONGRESS=115
		SESSION=2
		VOTES=00274
		;;
	2019)
		CONGRESS=116
		SESSION=1
		VOTES=00026
		;;
esac
		
echo "#################################"
echo "$YEAR ${CONGRESS}-${SESSION}"
echo "#################################"
for VOTE in $(seq -w 00001 ${VOTES})
do echo 
echo "Roll Call Vote #${VOTE}"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
wget -O- https://www.senate.gov/legislative/LIS/roll_call_lists/roll_call_vote_cfm.cfm?congress=$CONGRESS\&session=$SESSION\&vote=$VOTE 2>/dev/null 1>tmp1
cat tmp1 | grep -E "$CANDIDATE1" | grep div | awk -F">" '{print $2 $3}' | sed -e 's/<b//g' | sed -e 's/<\/b//g' > tmp2
cat tmp1 | grep -E "$CANDIDATE2" | grep div | awk -F">" '{print $2 $3}' | sed -e 's/<b//g' | sed -e 's/<\/b//g' > tmp3
cat tmp2 > tmp4
cat tmp3 >> tmp4
cat tmp2
cat tmp3
if [[ $(cat tmp4 | grep Yea | wc -l) -eq 2 ]]; then 
	echo "$YEAR $CONGRESS $SESSION $VOTE" >> SAME
elif [[ $(cat tmp4 | grep Nay | wc -l) -eq 2 ]]; then
	echo "$YEAR $CONGRESS $SESSION $VOTE" >> SAME
elif [[ $(cat tmp4 | grep "Not Voting" | wc -l) -gt 0 ]]; then
	echo
else
	echo "$YEAR $CONGRESS $SESSION $VOTE" >> DIFFERENT
fi
done
done

echo "#######################################"
echo "VOTES THAT WERE DIFFERENT $(cat DIFFERENT | wc -l)"
echo "#######################################"

cat DIFFERENT
