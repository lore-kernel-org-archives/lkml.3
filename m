Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaHSMQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:16:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:28911 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaHSMQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:16:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="578713547"
Date: Tue, 19 Aug 2014 20:12:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Hansen <dave.hansen@intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [memcontrol] 05b84301233: +129.9% vm-scalability.throughput, -12.6%
 turbostat.Pkg_W
Message-ID: <20140819121230.GD18960@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Johannes,

We find interesting multi-thread mmap rand read performance gain and
power reduction on

commit 05b8430123359886ef6a4146fba384e30d771b3f ("mm: memcontrol: use root_mem_cgroup res_counter")

test case: brickland3/vm-scalability/300s-mmap-pread-rand-mt

The test box "brickland3" is Brickland Ivy Bridge-EX with 512G memory,
120 logical CPUs.

692e7c45d95ad10  05b8430123359886ef6a4146f 
---------------  ------------------------- 
      0.03 ±100%  +12170.5%       3.13 ±50%  TOTAL vm-scalability.stddev
   1282439 ±10%    +129.9%    2947754 ±22%  TOTAL vm-scalability.throughput
     24056 ±17%   +1619.6%     413661 ±40%  TOTAL numa-vmstat.node0.nr_active_file
    374762 ±13%    +403.4%    1886450 ±33%  TOTAL numa-vmstat.node3.nr_mapped
     26019 ±20%   +1798.6%     494013 ±40%  TOTAL numa-vmstat.node3.nr_active_file
    352052 ±13%    +352.0%    1591441 ±33%  TOTAL numa-vmstat.node0.nr_mapped
   1499575 ±13%    +403.4%    7549434 ±33%  TOTAL numa-meminfo.node3.Mapped
      0.01 ± 0%  +6.2e+05%      62.16 ±49%  TOTAL perf-profile.cpu-cycles.do_unit
   1488742 ±20%    +377.0%    7101311 ±33%  TOTAL numa-meminfo.node2.Mapped
    102414 ±20%   +1723.4%    1867451 ±40%  TOTAL numa-meminfo.node2.Active(file)
      2.37 ±27%    +636.7%      17.46 ±35%  TOTAL turbostat.%c6
    143698 ±16%   +1205.1%    1875367 ±36%  TOTAL numa-meminfo.node1.Active(file)
    151914 ±16%   +1273.9%    2087141 ±30%  TOTAL numa-meminfo.node1.Active
    103946 ±20%   +1803.3%    1978406 ±40%  TOTAL numa-meminfo.node3.Active(file)
   1408602 ±13%    +352.1%    6368584 ±33%  TOTAL numa-meminfo.node0.Mapped
     96122 ±17%   +1623.5%    1656668 ±40%  TOTAL numa-meminfo.node0.Active(file)
    372146 ±20%    +376.8%    1774356 ±33%  TOTAL numa-vmstat.node2.nr_mapped
     35970 ±16%   +1201.8%     468251 ±36%  TOTAL numa-vmstat.node1.nr_active_file
    441937 ±17%   +1561.9%    7344724 ±39%  TOTAL meminfo.Active(file)
    110544 ±17%   +1560.6%    1835659 ±39%  TOTAL proc-vmstat.nr_active_file
   1120643 ± 5%    +590.6%    7739311 ±35%  TOTAL meminfo.Active
  18371498 ± 3%    +453.4%  1.017e+08 ±35%  TOTAL proc-vmstat.pgfault
     25633 ±20%   +1719.1%     466289 ±40%  TOTAL numa-vmstat.node2.nr_active_file
   6658192 ±11%    +324.6%   28272474 ±31%  TOTAL meminfo.Mapped
   1665171 ±11%    +324.2%    7063886 ±31%  TOTAL proc-vmstat.nr_mapped
   2428188 ± 9%    +227.6%    7953909 ±30%  TOTAL numa-meminfo.node3.FilePages
    606895 ± 9%    +227.5%    1987651 ±30%  TOTAL numa-vmstat.node3.nr_file_pages
    569759 ± 5%    +219.4%    1819531 ±26%  TOTAL numa-vmstat.node1.nr_mapped
   2279554 ± 5%    +219.4%    7281938 ±26%  TOTAL numa-meminfo.node1.Mapped
    556008 ±25%    +232.5%    1848486 ±32%  TOTAL numa-vmstat.node2.nr_file_pages
   2224676 ±25%    +232.5%    7397397 ±32%  TOTAL numa-meminfo.node2.FilePages
    533395 ±27%    +209.0%    1648097 ±32%  TOTAL numa-vmstat.node0.nr_file_pages
   2134139 ±27%    +209.0%    6594790 ±32%  TOTAL numa-meminfo.node0.FilePages
  10069745 ±18%    +196.2%   29824943 ±28%  TOTAL vmstat.memory.cache
  10095876 ±18%    +195.9%   29875905 ±28%  TOTAL meminfo.Cached
   2525023 ±18%    +195.6%    7464604 ±28%  TOTAL proc-vmstat.nr_file_pages
   1969114 ±20%    +195.7%    5823012 ±28%  TOTAL numa-meminfo.node3.Inactive
   1962869 ±20%    +196.5%    5820705 ±28%  TOTAL numa-meminfo.node3.Inactive(file)
    490557 ±20%    +196.6%    1454975 ±28%  TOTAL numa-vmstat.node3.nr_inactive_file
   1790247 ±19%    +175.7%    4935454 ±29%  TOTAL numa-meminfo.node0.Inactive(file)
    447375 ±19%    +175.8%    1233766 ±29%  TOTAL numa-vmstat.node0.nr_inactive_file
   1794406 ±19%    +175.1%    4936742 ±29%  TOTAL numa-meminfo.node0.Inactive
       117 ±10%     -48.4%         60 ±49%  TOTAL proc-vmstat.nr_dirtied
   3371503 ± 9%    +143.2%    8198318 ±20%  TOTAL proc-vmstat.pgactivate
   2184713 ±20%    +150.4%    5470979 ±26%  TOTAL proc-vmstat.nr_inactive_file
   8735108 ±20%    +150.7%   21899817 ±26%  TOTAL meminfo.Inactive(file)
   3337503 ±17%    +138.4%    7957665 ±22%  TOTAL numa-meminfo.node1.FilePages
    834094 ±17%    +138.4%    1988537 ±22%  TOTAL numa-vmstat.node1.nr_file_pages
   9002304 ±19%    +146.2%   22163923 ±26%  TOTAL meminfo.Inactive
   5007211 ± 4%    +116.0%   10818062 ±22%  TOTAL numa-meminfo.node3.MemUsed
   4817372 ±11%    +112.8%   10252314 ±23%  TOTAL numa-meminfo.node2.MemUsed
   4748497 ±11%     +99.7%    9482674 ±22%  TOTAL numa-meminfo.node0.MemUsed
    678705 ± 3%     -41.9%     394587 ±31%  TOTAL meminfo.Active(anon)
    169636 ± 3%     -41.8%      98684 ±31%  TOTAL proc-vmstat.nr_active_anon
   3037702 ±18%     +86.6%    5666857 ±20%  TOTAL numa-meminfo.node1.Inactive(file)
    759113 ±18%     +86.6%    1416427 ±20%  TOTAL numa-vmstat.node1.nr_inactive_file
      3.06 ±12%     +88.8%       5.77 ±12%  TOTAL turbostat.%c1
   3191174 ±18%     +84.1%    5875267 ±19%  TOTAL numa-meminfo.node1.Inactive
   6070097 ± 9%     +80.0%   10923602 ±16%  TOTAL numa-meminfo.node1.MemUsed
       162 ± 6%     -34.6%        106 ±28%  TOTAL proc-vmstat.nr_written
      8361 ± 2%     +61.1%      13473 ±15%  TOTAL uptime.idle
    914728 ± 2%     -31.3%     628385 ±20%  TOTAL meminfo.Shmem
    228644 ± 2%     -31.3%     157110 ±20%  TOTAL proc-vmstat.nr_shmem
     93589 ±12%     +54.2%     144291 ±12%  TOTAL slabinfo.radix_tree_node.num_objs
      1670 ±12%     +54.2%       2576 ±12%  TOTAL slabinfo.radix_tree_node.num_slabs
      1670 ±12%     +54.2%       2576 ±12%  TOTAL slabinfo.radix_tree_node.active_slabs
     93251 ±12%     +54.0%     143616 ±12%  TOTAL slabinfo.radix_tree_node.active_objs
      5789 ± 9%     +37.5%       7958 ± 4%  TOTAL numa-vmstat.node3.nr_slab_reclaimable
     23161 ± 9%     +37.5%      31844 ± 4%  TOTAL numa-meminfo.node3.SReclaimable
   2014435 ± 2%     -23.4%    1542102 ± 9%  TOTAL meminfo.Committed_AS
  25777315 ±10%     -26.9%   18834186 ± 3%  TOTAL softirqs.TIMER
     98593 ± 6%     +29.1%     127310 ± 8%  TOTAL meminfo.SReclaimable
     24651 ± 6%     +29.1%      31817 ± 8%  TOTAL proc-vmstat.nr_slab_reclaimable
       114 ± 0%     -19.2%         92 ± 8%  TOTAL vmstat.procs.r
     54218 ± 6%     +17.0%      63418 ± 6%  TOTAL numa-meminfo.node2.Slab
    432162 ± 1%     +17.4%     507299 ± 4%  TOTAL numa-vmstat.node3.nr_page_table_pages
   1729816 ± 1%     +17.3%    2029692 ± 4%  TOTAL numa-meminfo.node3.PageTables
   6918899 ± 1%     +16.4%    8056526 ± 3%  TOTAL meminfo.PageTables
   1730406 ± 1%     +16.3%    2012726 ± 3%  TOTAL proc-vmstat.nr_page_table_pages
   1732736 ± 1%     +17.2%    2030910 ± 3%  TOTAL numa-meminfo.node0.PageTables
   1735229 ± 1%     +15.9%    2011761 ± 3%  TOTAL numa-meminfo.node2.PageTables
    432880 ± 1%     +17.2%     507504 ± 3%  TOTAL numa-vmstat.node0.nr_page_table_pages
    433466 ± 1%     +16.0%     502747 ± 3%  TOTAL numa-vmstat.node2.nr_page_table_pages
    433015 ± 1%     +14.5%     495963 ± 3%  TOTAL numa-vmstat.node1.nr_page_table_pages
   1733140 ± 1%     +14.5%    1984694 ± 3%  TOTAL numa-meminfo.node1.PageTables
     55586 ± 4%     +14.6%      63699 ± 5%  TOTAL numa-meminfo.node3.Slab
    235040 ± 2%     +12.0%     263152 ± 3%  TOTAL meminfo.Slab
    129349 ± 4%     -10.5%     115832 ± 7%  TOTAL meminfo.DirectMap4k
   4428414 ±23%   +2068.0%   96008011 ±40%  TOTAL time.minor_page_faults
     94.57 ± 0%     -18.8%      76.76 ± 8%  TOTAL turbostat.%c0
     11277 ± 0%     -18.5%       9191 ± 7%  TOTAL time.percent_of_cpu_this_job_got
       391 ± 0%     -15.1%        332 ± 6%  TOTAL turbostat.Cor_W
       461 ± 0%     -12.6%        403 ± 5%  TOTAL turbostat.Pkg_W
    208054 ±15%     -19.3%     167943 ± 4%  TOTAL time.involuntary_context_switches

Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Fengguang

--WhfpMioaduB5tiZL
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
./case-mmap-pread-rand-mt
truncate /tmp/vm-scalability/sparse-mmap-pread-rand-mt -s 36650387592
./usemem --runtime 300 -t 120 -f /tmp/vm-scalability/sparse-mmap-pread-rand-mt --readonly --random 36650387592
umount /tmp/vm-scalability-tmp
umount /tmp/vm-scalability
rm /tmp/vm-scalability.img

--WhfpMioaduB5tiZL--
