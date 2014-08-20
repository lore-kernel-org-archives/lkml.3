Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaHTP7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:59:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:53125 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbaHTP7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:59:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,903,1400050800"; 
   d="scan'208";a="579379993"
Date: Wed, 20 Aug 2014 23:58:45 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: [sched/numa] 0132c3e1777: -6.4% vm-scalability.throughput
Message-ID: <20140820155845.GA7241@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Rik,

FYI, we noticed the below changes on commit

0132c3e1777ceabc24c7d209b7cbe78c28c03c09 ("sched/numa: Examine a task move when examining a task swap")

test case: brickland3/vm-scalability/300s-1T-anon-cow-seq

1c5d3eb3759013b  0132c3e1777ceabc24c7d209b 
---------------  ------------------------- 
  36496955 ± 0%      -6.4%   34158456 ± 0%  TOTAL vm-scalability.throughput
      0.82 ±24%    +239.4%       2.79 ±10%  TOTAL turbostat.%pc2
  3.83e+08 ± 4%     -55.8%  1.693e+08 ±10%  TOTAL cpuidle.C1-IVT-4S.time
    103637 ± 3%     +32.8%     137617 ± 1%  TOTAL cpuidle.C6-IVT-4S.usage
     14451 ±12%     +28.1%      18508 ± 4%  TOTAL proc-vmstat.numa_pages_migrated
     14451 ±12%     +28.1%      18508 ± 4%  TOTAL proc-vmstat.pgmigrate_success
  4.13e+09 ± 1%     +18.2%  4.882e+09 ± 0%  TOTAL cpuidle.C6-IVT-4S.time
      5858 ± 6%     -16.1%       4915 ± 1%  TOTAL proc-vmstat.nr_mapped
       786 ± 7%     +14.1%        897 ± 6%  TOTAL numa-vmstat.node0.nr_alloc_batch
      9.62 ± 2%     -13.2%       8.35 ± 2%  TOTAL turbostat.%c1
     14.64 ± 3%     +16.1%      17.00 ± 1%  TOTAL turbostat.%c6
    123533 ± 5%      -9.3%     112004 ± 0%  TOTAL proc-vmstat.pgactivate
     21982 ± 4%     -11.0%      19567 ± 1%  TOTAL meminfo.Mapped
      5037 ± 4%      -8.1%       4630 ± 4%  TOTAL numa-meminfo.node0.Mapped
     45737 ±10%     -28.6%      32671 ± 9%  TOTAL time.voluntary_context_switches
      3124 ± 7%     -15.6%       2637 ± 2%  TOTAL vmstat.system.cs
     10226 ± 0%      +7.4%      10978 ± 0%  TOTAL time.system_time
       154 ± 0%      +7.1%        165 ± 0%  TOTAL time.elapsed_time
    153975 ± 3%      -6.2%     144429 ± 0%  TOTAL vmstat.system.in
       168 ± 0%      -3.2%        163 ± 0%  TOTAL turbostat.RAM_W
       374 ± 0%      -1.6%        368 ± 0%  TOTAL turbostat.Cor_W
       458 ± 0%      -1.5%        451 ± 0%  TOTAL turbostat.Pkg_W
      9092 ± 0%      -1.5%       8953 ± 0%  TOTAL time.percent_of_cpu_this_job_got
     75.72 ± 0%      -1.5%      74.61 ± 0%  TOTAL turbostat.%c0

The test box configuration is

brickland3: Brickland Ivy Bridge-EX
Memory: 512G
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                120
On-line CPU(s) list:   0-119
Thread(s) per core:    2
Core(s) per socket:    15
Socket(s):             4
NUMA node(s):          4
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 62
Stepping:              7
CPU MHz:               3192.875
BogoMIPS:              5593.49
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              38400K
NUMA node0 CPU(s):     0-14,60-74
NUMA node1 CPU(s):     15-29,75-89
NUMA node2 CPU(s):     30-44,90-104
NUMA node3 CPU(s):     45-59,105-119


                                  time.system_time

  11500 ++------------------------------------------------------------------+
        |                                                                   |
        |       O  O       O  O       O  O O  O  O    O  O  O O             |
  11000 O+ O O        O O       O  O                O            O  O  O O  O
        |                                                                   |
        |                                                                   |
  10500 ++                                                                  |
        |                      .*..*..*.. .*..  .*.. .*..*..*.              |
  10000 ++                    *          *    *.    *         *             |
        |                    +                                              |
        |       *           +                                               |
   9500 ++    .. :    *.  .*                                                |
        | .*.*    :  +  *.                                                  |
        *.        : +                                                       |
   9000 ++---------*--------------------------------------------------------+


                                 time.elapsed_time

  170 ++--------------------------------------------------------------------+
      |       O             O        O  O       O       O     O             |
      O  O  O    O  O  O  O    O  O       O  O     O  O    O     O  O       O
  165 ++                                                              O  O  |
      |                                                                     |
      |                                                                     |
  160 ++                                                                    |
      |                                                                     |
  155 ++                      .*..             .*..    .*..*..              |
      |                     *.    *..*..*.*..*.      .*       *             |
      |       *            +                       *.                       |
  150 ++     + +    *..*..*                                                 |
      *..*..*   + ..                                                        |
      |          *                                                          |
  145 ++--------------------------------------------------------------------+


                               vm-scalability.throughput

    4e+07 ++---------*------------------------------------------------------+
          *..       : :                                                     |
  3.9e+07 ++ *.*..  : :  .*.                                                |
          |        :   *.   *                                               |
  3.8e+07 ++      *          :                                              |
          |                   :                                             |
  3.7e+07 ++                  :               .*.. .*..                     |
          |                    *..*.*..*..*.*.    *      .*.*..*            |
  3.6e+07 ++                                           *.                   |
          |                                                                 |
  3.5e+07 ++                                                                |
          |                                                              O  |
  3.4e+07 O+ O O     O O  O O     O O       O       O  O  O O  O O  O  O    O
          |       O            O       O  O    O  O                         |
  3.3e+07 ++----------------------------------------------------------------+


                                  turbostat.RAM_W

  173 ++--------------------------------------------------------------------+
  172 *+.        *..                                                        |
      |    .*   +                                                           |
  171 ++ *.  + +    *..*..*.                                                |
  170 ++      *             *..*..                 *..                      |
  169 ++                          *..       .*.. ..       .*..*             |
  168 ++                             *..*.*.    *     *.*.                  |
      |                                                                     |
  167 ++                                                                    |
  166 ++                                                                    |
  165 ++                                                                    |
  164 ++            O                                                    O  |
      O  O    O        O                                         O  O O     O
  163 ++    O    O        O O  O  O  O    O  O  O  O  O O  O  O             |
  162 ++--------------------------------O-----------------------------------+


	[*] bisect-good sample
	[O] bisect-bad  sample


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Fengguang

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu10/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu100/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu101/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu102/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu103/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu104/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu105/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu106/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu107/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu108/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu109/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu11/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu110/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu111/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu112/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu113/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu114/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu115/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu116/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu117/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu118/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu119/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu12/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu13/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu14/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu15/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu16/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu17/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu18/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu19/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu20/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu21/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu22/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu23/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu24/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu25/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu26/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu27/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu28/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu29/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu30/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu31/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu32/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu33/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu34/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu35/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu36/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu37/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu38/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu39/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu40/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu41/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu42/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu43/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu44/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu45/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu46/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu47/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu48/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu49/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu50/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu51/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu52/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu53/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu54/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu55/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu56/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu57/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu58/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu59/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu60/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu61/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu62/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu63/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu64/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu65/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu66/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu67/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu68/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu69/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu70/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu71/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu72/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu73/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu74/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu75/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu76/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu77/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu78/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu79/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu80/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu81/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu82/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu83/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu84/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu85/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu86/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu87/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu88/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu89/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu90/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu91/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu92/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu93/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu94/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu95/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu96/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu97/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu98/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu99/cpufreq/scaling_governor
mount -t tmpfs -o size=100% vm-scalability-tmp /tmp/vm-scalability-tmp
truncate -s 540952072192 /tmp/vm-scalability.img
mkfs.xfs -q /tmp/vm-scalability.img
mount -o loop /tmp/vm-scalability.img /tmp/vm-scalability
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
./case-anon-cow-seq
./usemem --runtime 300 -n 120 --prealloc --prefault 2253966967
umount /tmp/vm-scalability-tmp
umount /tmp/vm-scalability
rm /tmp/vm-scalability.img

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--W/nzBZO5zC0uMSeA--
