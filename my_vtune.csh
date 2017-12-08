#!/bin/csh
#COBALT -n 64
#COBALT -t 30
#COBALT -q default
#COBALT -A ATPESC2017

# -- Set working directory
# cd /home/mjdmello/vtune-example
source /opt/intel/vtune_amplifier_xe_2017.3.0.510739/amplxe-vars.csh

# -- Initialization
set NUM_NODES = ${COBALT_JOBSIZE}
set NUM_RANKS_PER_NODE = 64
set NUM_TOTAL_RANKS = `expr ${NUM_RANKS_PER_NODE} \* ${NUM_NODES}`
set HWTHR = 1

case=${1}

echo ${case}     >  SESSION.NAME
echo `pwd`'/' >>  SESSION.NAME
touch ${case}.rea
rm -f ioinfo
mv -f ${case}.his ${case}.his1
mv -f ${case}.sch ${case}.sch1

aprun --env LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/intel/vtune_amplifier_xe_2017.3.0.510739/lib64 \
 --env PATH=${PATH}:/opt/intel/vtune_amplifier_xe_2017.3.0.510739/bin64 \
 --env PMI_NO_FORK=1 \
-n ${NUM_TOTAL_RANKS} \
-N ${NUM_RANKS_PER_NODE} \
-cc depth \
-d 1 \
-j ${HWTHR}  \
 amplxe-cl -finalization-mode=none -collect advanced-hotspots -r xyz ./nek5000  
# amplxe-cl -finalization-mode=none -collect advanced-hotspots -knob collection-detail=stack-and-callcount -r xyz ./abc < hh2.d > out-1
