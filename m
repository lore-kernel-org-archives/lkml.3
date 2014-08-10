Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbaHJEle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 00:41:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:34357 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbaHJEld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 00:41:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,834,1400050800"; 
   d="scan'208";a="574453717"
Date: Sun, 10 Aug 2014 12:41:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Ingo Molnar <mingo@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [sched] 143e1e28cb4: +17.9% aim7.jobs-per-min, -9.7%
 hackbench.throughput
Message-ID: <20140810044127.GB11810@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

FYI, we noticed some performance ups/downs on

commit 143e1e28cb40bed836b0a06567208bd7347c9672 ("sched: Rework sched_domain topology definition")

107437febd495a5  143e1e28cb40bed836b0a0656  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
      0.09 ± 3%     +88.2%       0.17 ± 1%  nhm4/ebizzy/200%-100x-10s
      0.09 ± 3%     +88.2%       0.17 ± 1%  TOTAL ebizzy.throughput.per_thread.stddev_percent

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    128529 ± 1%     +17.9%     151594 ± 0%  brickland1/aim7/6000-page_test
    128529 ± 1%     +17.9%     151594 ± 0%  TOTAL aim7.jobs-per-min

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    156539 ± 1%      -4.3%     149885 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
    116465 ± 1%     -17.1%      96542 ± 1%  wsm/hackbench/1600%-process-pipe
    273004 ± 1%      -9.7%     246428 ± 0%  TOTAL hackbench.throughput

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
  12451869 ± 0%      -2.9%   12087560 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  12451869 ± 0%      -2.9%   12087560 ± 0%  TOTAL vm-scalability.throughput

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      1980 ± 0%      -2.4%       1933 ± 0%  nhm4/ebizzy/200%-100x-10s
      1980 ± 0%      -2.4%       1933 ± 0%  TOTAL ebizzy.throughput.per_thread.min

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
 4.446e+08 ± 0%      -1.9%  4.364e+08 ± 0%  lkp-nex04/pigz/100%-128K
 4.446e+08 ± 0%      -1.9%  4.364e+08 ± 0%  TOTAL pigz.throughput

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     27.18 ± 0%      -1.5%      26.78 ± 0%  nhm4/ebizzy/200%-100x-10s
     27.18 ± 0%      -1.5%      26.78 ± 0%  TOTAL ebizzy.time.user

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2083 ± 0%      +1.3%       2110 ± 0%  nhm4/ebizzy/200%-100x-10s
      2083 ± 0%      +1.3%       2110 ± 0%  TOTAL ebizzy.throughput.per_thread.max

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     32335 ± 0%      -1.0%      32012 ± 0%  nhm4/ebizzy/200%-100x-10s
     32335 ± 0%      -1.0%      32012 ± 0%  TOTAL ebizzy.throughput

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      6626 ± 5%     -88.7%        751 ±36%  brickland3/vm-scalability/300s-lru-file-readonce
      6626 ± 5%     -88.7%        751 ±36%  TOTAL cpuidle.C3-IVT.usage

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
  14204402 ±19%     -71.5%    4050186 ±34%  brickland3/vm-scalability/300s-lru-file-readonce
  14204402 ±19%     -71.5%    4050186 ±34%  TOTAL cpuidle.C3-IVT.time

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      0.38 ±32%    +218.1%       1.20 ± 4%  wsm/hackbench/1600%-process-pipe
      0.38 ±32%    +218.1%       1.20 ± 4%  TOTAL perf-profile.cpu-cycles.__schedule.schedule.pipe_wait.pipe_read.do_sync_read

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     76064 ± 3%     -32.2%      51572 ± 6%  brickland1/aim7/6000-page_test
    269053 ± 1%     -57.9%     113386 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
    345117 ± 1%     -52.2%     164959 ± 2%  TOTAL cpuidle.C6-IVT.usage

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
  59366697 ± 3%     -46.1%   32017187 ± 7%  brickland1/aim7/6000-page_test
  59366697 ± 3%     -46.1%   32017187 ± 7%  TOTAL cpuidle.C1-IVT.time

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
  26666815 ± 2%     +83.3%   48893253 ± 2%  lkp-nex04/pigz/100%-128K
  26666815 ± 2%     +83.3%   48893253 ± 2%  TOTAL cpuidle.C1E-NHM.time

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2561 ± 7%     -42.9%       1463 ± 9%  brickland1/aim7/6000-page_test
      2561 ± 7%     -42.9%       1463 ± 9%  TOTAL numa-numastat.node2.other_node

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    116864 ± 2%     +77.4%     207322 ± 2%  lkp-nex04/pigz/100%-128K
    116864 ± 2%     +77.4%     207322 ± 2%  TOTAL cpuidle.C1E-NHM.usage

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      0.65 ±22%     +55.4%       1.02 ± 5%  lkp-nex04/pigz/100%-128K
      0.65 ±22%     +55.4%       1.02 ± 5%  TOTAL perf-profile.cpu-cycles.intel_idle.cpuidle_enter_state.cpuidle_enter.cpu_startup_entry.start_secondary

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      9926 ± 2%     -43.8%       5577 ± 4%  brickland1/aim7/6000-page_test
      9926 ± 2%     -43.8%       5577 ± 4%  TOTAL proc-vmstat.numa_other

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2627 ±12%     -49.1%       1337 ±12%  brickland1/aim7/6000-page_test
      2627 ±12%     -49.1%       1337 ±12%  TOTAL numa-numastat.node1.other_node

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      0.88 ± 6%     +65.8%       1.46 ± 4%  lkp-nex04/pigz/100%-128K
      0.88 ± 6%     +65.8%       1.46 ± 4%  TOTAL turbostat.%c3

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     19542 ± 9%     -38.3%      12057 ± 4%  brickland1/aim7/6000-page_test
     19542 ± 9%     -38.3%      12057 ± 4%  TOTAL cpuidle.C1E-IVT.usage

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      1357 ± 8%     -39.0%        827 ±16%  brickland3/vm-scalability/300s-lru-file-readonce
      1357 ± 8%     -39.0%        827 ±16%  TOTAL slabinfo.nfs_write_data.num_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      1357 ± 8%     -39.0%        827 ±16%  brickland3/vm-scalability/300s-lru-file-readonce
      1357 ± 8%     -39.0%        827 ±16%  TOTAL slabinfo.nfs_write_data.active_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    993654 ± 2%     -19.9%     795962 ± 3%  brickland1/aim7/6000-page_test
    343162 ± 6%     -59.1%     140462 ± 5%  brickland3/vm-scalability/300s-lru-file-readonce
    315034 ± 3%     +34.5%     423784 ± 1%  wsm/hackbench/1600%-process-pipe
   1651850 ± 3%     -17.7%    1360209 ± 2%  TOTAL softirqs.RCU

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2455 ±10%     -41.0%       1448 ± 9%  brickland1/aim7/6000-page_test
      2455 ±10%     -41.0%       1448 ± 9%  TOTAL numa-numastat.node0.other_node

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    582269 ±14%     -55.6%     258617 ±16%  brickland1/aim7/6000-page_test
    441740 ±18%     -49.2%     224389 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
    219830 ± 1%     -29.9%     154078 ± 0%  lkp-nex04/pigz/100%-128K
    156140 ± 8%     -12.1%     137250 ± 5%  lkp-snb01/hackbench/1600%-process-pipe
     47877 ± 1%     -10.3%      42941 ± 1%  wsm/hackbench/1600%-process-pipe
   1447857 ±12%     -43.6%     817277 ± 6%  TOTAL softirqs.SCHED

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    892836 ± 1%     +58.0%    1410897 ± 0%  lkp-nex04/pigz/100%-128K
    892836 ± 1%     +58.0%    1410897 ± 0%  TOTAL cpuidle.C3-NHM.usage

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    471304 ±11%     -31.4%     323251 ± 8%  brickland1/aim7/6000-page_test
    471304 ±11%     -31.4%     323251 ± 8%  TOTAL numa-vmstat.node1.nr_anon_pages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
 4.875e+08 ± 2%     +57.7%  7.688e+08 ± 2%  lkp-nex04/pigz/100%-128K
 4.875e+08 ± 2%     +57.7%  7.688e+08 ± 2%  TOTAL cpuidle.C3-NHM.time

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2281 ±12%     -41.8%       1327 ±16%  brickland1/aim7/6000-page_test
      2281 ±12%     -41.8%       1327 ±16%  TOTAL numa-numastat.node3.other_node

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   1903446 ±11%     -30.7%    1318156 ± 7%  brickland1/aim7/6000-page_test
   1903446 ±11%     -30.7%    1318156 ± 7%  TOTAL numa-meminfo.node1.AnonPages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      1.64 ± 3%     -44.8%       0.90 ± 4%  brickland3/vm-scalability/300s-lru-file-readonce
      1.83 ± 1%     +54.8%       2.84 ± 0%  lkp-nex04/pigz/100%-128K
      1.26 ± 2%     -21.9%       0.99 ± 6%  wsm/hackbench/1600%-process-pipe
      4.73 ± 2%      -0.1%       4.73 ± 2%  TOTAL turbostat.%c1

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    518274 ±11%     -30.4%     360742 ± 8%  brickland1/aim7/6000-page_test
    518274 ±11%     -30.4%     360742 ± 8%  TOTAL numa-vmstat.node1.nr_active_anon

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   2097138 ±10%     -30.0%    1469003 ± 8%  brickland1/aim7/6000-page_test
   2097138 ±10%     -30.0%    1469003 ± 8%  TOTAL numa-meminfo.node1.Active(anon)

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
  49527464 ± 6%     -32.4%   33488833 ± 4%  brickland1/aim7/6000-page_test
  49527464 ± 6%     -32.4%   33488833 ± 4%  TOTAL cpuidle.C1E-IVT.time

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2084 ±10%     +31.6%       2743 ± 6%  lkp-snb01/hackbench/1600%-process-pipe
       235 ± 8%     -35.7%        151 ± 8%  wsm/hackbench/1600%-process-pipe
      2319 ±10%     +24.8%       2894 ± 6%  TOTAL cpuidle.POLL.usage

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     54543 ±11%     -37.2%      34252 ±16%  brickland1/aim7/6000-page_test
      4542 ± 4%     -14.3%       3891 ± 6%  brickland3/vm-scalability/300s-lru-file-readonce
     59085 ±10%     -35.4%      38143 ±15%  TOTAL cpuidle.C1-IVT.usage

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    188938 ±33%     -41.3%     110966 ±16%  brickland1/aim7/6000-page_test
    188938 ±33%     -41.3%     110966 ±16%  TOTAL numa-meminfo.node2.PageTables

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     47262 ±35%     -42.3%      27273 ±16%  brickland1/aim7/6000-page_test
     47262 ±35%     -42.3%      27273 ±16%  TOTAL numa-vmstat.node2.nr_page_table_pages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   1944687 ±10%     -25.8%    1443923 ±16%  brickland1/aim7/6000-page_test
   1944687 ±10%     -25.8%    1443923 ±16%  TOTAL numa-meminfo.node3.Active(anon)

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   1754763 ±11%     -26.6%    1288713 ±16%  brickland1/aim7/6000-page_test
   1754763 ±11%     -26.6%    1288713 ±16%  TOTAL numa-meminfo.node3.AnonPages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   1964722 ±10%     -25.5%    1464696 ±16%  brickland1/aim7/6000-page_test
   1964722 ±10%     -25.5%    1464696 ±16%  TOTAL numa-meminfo.node3.Active

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
  17100655 ± 7%     +44.6%   24731604 ± 2%  lkp-nex04/pigz/100%-128K
  37335977 ± 6%     -28.6%   26654124 ± 7%  wsm/hackbench/1600%-process-pipe
  54436632 ± 6%      -5.6%   51385728 ± 5%  TOTAL cpuidle.C1-NHM.time

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    432109 ± 9%     -26.2%     318886 ±14%  brickland1/aim7/6000-page_test
    432109 ± 9%     -26.2%     318886 ±14%  TOTAL numa-vmstat.node3.nr_anon_pages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    479527 ± 9%     -25.3%     358029 ±14%  brickland1/aim7/6000-page_test
    479527 ± 9%     -25.3%     358029 ±14%  TOTAL numa-vmstat.node3.nr_active_anon

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   3157742 ±16%     -26.5%    2320253 ±10%  brickland1/aim7/6000-page_test
   3157742 ±16%     -26.5%    2320253 ±10%  TOTAL numa-meminfo.node1.MemUsed

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2.00 ±39%     -34.4%       1.31 ±10%  lkp-nex04/pigz/100%-128K
      2.00 ±39%     -34.4%       1.31 ±10%  TOTAL perf-profile.cpu-cycles.update_cfs_shares.task_tick_fair.scheduler_tick.update_process_times.tick_sched_handle

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      9869 ±15%     +21.8%      12025 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
      9869 ±15%     +21.8%      12025 ± 1%  TOTAL numa-vmstat.node1.numa_other

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     61500 ± 2%     +24.6%      76639 ± 2%  lkp-nex04/pigz/100%-128K
   1206181 ± 3%     -30.5%     838619 ± 2%  wsm/hackbench/1600%-process-pipe
   1267682 ± 3%     -27.8%     915259 ± 2%  TOTAL cpuidle.C1-NHM.usage

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   2118206 ±10%     -29.7%    1488874 ± 7%  brickland1/aim7/6000-page_test
    593077 ± 4%      -9.9%     534490 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
   2711283 ± 9%     -25.4%    2023365 ± 6%  TOTAL numa-meminfo.node1.Active

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    227935 ±13%     -30.2%     159051 ±16%  brickland3/vm-scalability/300s-lru-file-readonce
    227935 ±13%     -30.2%     159051 ±16%  TOTAL numa-vmstat.node0.workingset_nodereclaim

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   7303589 ± 2%     -24.8%    5495829 ± 3%  brickland1/aim7/6000-page_test
    202793 ± 3%     +20.0%     243307 ± 2%  wsm/hackbench/1600%-process-pipe
   7506382 ± 2%     -23.5%    5739136 ± 3%  TOTAL meminfo.AnonPages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   2064106 ± 7%     -23.3%    1582792 ± 8%  brickland1/aim7/6000-page_test
   2064106 ± 7%     -23.3%    1582792 ± 8%  TOTAL numa-meminfo.node0.Active

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      8189 ± 9%     -18.6%       6669 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
      8189 ± 9%     -18.6%       6669 ± 3%  TOTAL slabinfo.proc_inode_cache.active_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   8064024 ± 2%     -24.0%    6132677 ± 3%  brickland1/aim7/6000-page_test
    203300 ± 3%     +19.6%     243236 ± 2%  wsm/hackbench/1600%-process-pipe
   8267324 ± 2%     -22.9%    6375914 ± 3%  TOTAL meminfo.Active(anon)

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2815 ± 3%      -8.3%       2581 ± 6%  brickland3/vm-scalability/300s-lru-file-readonce
      1076 ±15%     +19.6%       1287 ±12%  nhm4/ebizzy/200%-100x-10s
      3892 ± 6%      -0.6%       3868 ± 8%  TOTAL slabinfo.buffer_head.num_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
 6.567e+11 ± 3%     -21.4%   5.16e+11 ± 4%  brickland1/aim7/6000-page_test
   1872397 ± 3%     +22.2%    2288513 ± 2%  wsm/hackbench/1600%-process-pipe
 6.567e+11 ± 3%     -21.4%   5.16e+11 ± 4%  TOTAL meminfo.Committed_AS

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    235358 ± 5%     -19.8%     188793 ± 3%  brickland1/aim7/6000-page_test
    235358 ± 5%     -19.8%     188793 ± 3%  TOTAL proc-vmstat.pgmigrate_success

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    235358 ± 5%     -19.8%     188793 ± 3%  brickland1/aim7/6000-page_test
    235358 ± 5%     -19.8%     188793 ± 3%  TOTAL proc-vmstat.numa_pages_migrated

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    433235 ± 4%     -18.1%     354845 ± 5%  brickland1/aim7/6000-page_test
    433235 ± 4%     -18.1%     354845 ± 5%  TOTAL numa-vmstat.node2.nr_anon_pages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
  90514624 ± 2%     -21.6%   70928192 ± 1%  wsm/hackbench/1600%-process-pipe
  90514624 ± 2%     -21.6%   70928192 ± 1%  TOTAL proc-vmstat.pgalloc_dma32

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    463719 ± 8%     -24.7%     349388 ± 7%  brickland1/aim7/6000-page_test
     71979 ± 2%     -11.7%      63550 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
    535698 ± 7%     -22.9%     412938 ± 7%  TOTAL numa-vmstat.node0.nr_anon_pages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   1818612 ± 2%     -24.9%    1365670 ± 3%  brickland1/aim7/6000-page_test
     51594 ± 2%     +16.9%      60313 ± 1%  wsm/hackbench/1600%-process-pipe
   1870207 ± 2%     -23.8%    1425983 ± 3%  TOTAL proc-vmstat.nr_anon_pages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      3187 ± 5%     -18.5%       2599 ± 6%  brickland1/aim7/6000-page_test
      3187 ± 5%     -18.5%       2599 ± 6%  TOTAL numa-vmstat.node0.numa_other

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   2007155 ± 2%     -24.3%    1518688 ± 3%  brickland1/aim7/6000-page_test
     51734 ± 2%     +16.6%      60298 ± 1%  wsm/hackbench/1600%-process-pipe
   2058889 ± 2%     -23.3%    1578987 ± 3%  TOTAL proc-vmstat.nr_active_anon

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   1395062 ± 6%     -19.0%    1130108 ± 3%  brickland1/aim7/6000-page_test
   1395062 ± 6%     -19.0%    1130108 ± 3%  TOTAL proc-vmstat.numa_hint_faults

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2501 ± 9%     +25.0%       3126 ±11%  brickland3/vm-scalability/300s-lru-file-readonce
      2501 ± 9%     +25.0%       3126 ±11%  TOTAL proc-vmstat.compact_stall

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    477037 ± 4%     -17.2%     394983 ± 5%  brickland1/aim7/6000-page_test
    477037 ± 4%     -17.2%     394983 ± 5%  TOTAL numa-vmstat.node2.nr_active_anon

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    511455 ± 8%     -23.9%     389447 ± 7%  brickland1/aim7/6000-page_test
     71970 ± 2%     -11.7%      63552 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
    583426 ± 7%     -22.4%     452999 ± 7%  TOTAL numa-vmstat.node0.nr_active_anon

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    796281 ±23%     -27.7%     575352 ± 3%  brickland1/aim7/6000-page_test
    157314 ± 2%     +22.7%     193026 ± 2%  wsm/hackbench/1600%-process-pipe
    953596 ±19%     -19.4%     768378 ± 3%  TOTAL meminfo.PageTables

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2829 ±10%     +18.7%       3357 ± 3%  brickland1/aim7/6000-page_test
      2829 ±10%     +18.7%       3357 ± 3%  TOTAL numa-vmstat.node2.nr_alloc_batch

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   1850230 ± 8%     -24.1%    1405061 ± 8%  brickland1/aim7/6000-page_test
    289636 ± 2%     -12.3%     254041 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
   2139866 ± 7%     -22.5%    1659103 ± 8%  TOTAL numa-meminfo.node0.AnonPages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   8145316 ± 2%     -23.7%    6213832 ± 3%  brickland1/aim7/6000-page_test
    353534 ± 2%     +11.3%     393604 ± 1%  wsm/hackbench/1600%-process-pipe
   8498851 ± 2%     -22.3%    6607437 ± 3%  TOTAL meminfo.Active

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2706 ± 4%     +26.1%       3411 ± 5%  brickland1/aim7/6000-page_test
      2706 ± 4%     +26.1%       3411 ± 5%  TOTAL numa-vmstat.node1.nr_alloc_batch

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
 1.392e+08 ± 5%     -15.5%  1.176e+08 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
 1.392e+08 ± 5%     -15.5%  1.176e+08 ± 2%  TOTAL numa-numastat.node1.local_node

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
 1.392e+08 ± 5%     -15.5%  1.176e+08 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
 1.392e+08 ± 5%     -15.5%  1.176e+08 ± 2%  TOTAL numa-numastat.node1.numa_hit

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   2044097 ± 7%     -23.5%    1562809 ± 8%  brickland1/aim7/6000-page_test
    289613 ± 2%     -12.3%     254058 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
   2333711 ± 7%     -22.1%    1816867 ± 7%  TOTAL numa-meminfo.node0.Active(anon)

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    198747 ±23%     -28.0%     143034 ± 3%  brickland1/aim7/6000-page_test
     40081 ± 2%     +19.1%      47725 ± 1%  wsm/hackbench/1600%-process-pipe
    238828 ±19%     -20.1%     190760 ± 2%  TOTAL proc-vmstat.nr_page_table_pages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
  1.65e+08 ± 2%     -11.3%  1.463e+08 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
  82216748 ± 2%     -23.6%   62851371 ± 1%  wsm/hackbench/1600%-process-pipe
 2.472e+08 ± 2%     -15.4%  2.092e+08 ± 2%  TOTAL proc-vmstat.pgalloc_normal

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   2725835 ± 4%     -17.5%    2247537 ± 4%  brickland1/aim7/6000-page_test
   2725835 ± 4%     -17.5%    2247537 ± 4%  TOTAL numa-meminfo.node2.MemUsed

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    393637 ± 6%     -15.3%     333296 ± 2%  brickland1/aim7/6000-page_test
    393637 ± 6%     -15.3%     333296 ± 2%  TOTAL proc-vmstat.numa_hint_faults_local

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
 1.681e+08 ± 2%     -10.6%  1.504e+08 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
 1.709e+08 ± 2%     -22.6%  1.323e+08 ± 1%  wsm/hackbench/1600%-process-pipe
 3.391e+08 ± 2%     -16.6%  2.827e+08 ± 2%  TOTAL proc-vmstat.numa_local

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
 1.681e+08 ± 2%     -10.6%  1.504e+08 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
 1.709e+08 ± 2%     -22.6%  1.323e+08 ± 1%  wsm/hackbench/1600%-process-pipe
 3.391e+08 ± 2%     -16.6%  2.827e+08 ± 2%  TOTAL proc-vmstat.numa_hit

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    109532 ± 1%     +20.5%     132015 ± 2%  wsm/hackbench/1600%-process-pipe
    109532 ± 1%     +20.5%     132015 ± 2%  TOTAL slabinfo.vm_area_struct.active_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
 1.706e+08 ± 2%     -10.5%  1.527e+08 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
 1.727e+08 ± 2%     -22.6%  1.338e+08 ± 1%  wsm/hackbench/1600%-process-pipe
 3.433e+08 ± 2%     -16.5%  2.865e+08 ± 2%  TOTAL proc-vmstat.pgfree

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2.82 ± 3%     +21.9%       3.43 ± 4%  brickland1/aim7/6000-page_test
      2.82 ± 3%     +21.9%       3.43 ± 4%  TOTAL turbostat.%pc2

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   1045052 ± 1%     -15.9%     878536 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
   1045052 ± 1%     -15.9%     878536 ± 3%  TOTAL proc-vmstat.workingset_nodereclaim

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    148761 ± 1%     +19.9%     178354 ± 2%  wsm/hackbench/1600%-process-pipe
    148761 ± 1%     +19.9%     178354 ± 2%  TOTAL slabinfo.kmalloc-64.active_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   3023001 ± 1%     -15.1%    2565273 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
   3023001 ± 1%     -15.1%    2565273 ± 3%  TOTAL proc-vmstat.slabs_scanned

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     74702 ± 1%     +19.2%      89026 ± 2%  wsm/hackbench/1600%-process-pipe
     74702 ± 1%     +19.2%      89026 ± 2%  TOTAL slabinfo.anon_vma.active_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
  14041931 ± 2%     -16.0%   11788641 ± 1%  wsm/hackbench/1600%-process-pipe
  14041931 ± 2%     -16.0%   11788641 ± 1%  TOTAL proc-vmstat.pgfault

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   1742111 ± 4%     -16.9%    1447181 ± 5%  brickland1/aim7/6000-page_test
   1742111 ± 4%     -16.9%    1447181 ± 5%  TOTAL numa-meminfo.node2.AnonPages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
  15865125 ± 1%     -15.0%   13485882 ± 1%  brickland1/aim7/6000-page_test
  15865125 ± 1%     -15.0%   13485882 ± 1%  TOTAL softirqs.TIMER

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   1923000 ± 4%     -16.4%    1608509 ± 5%  brickland1/aim7/6000-page_test
   1923000 ± 4%     -16.4%    1608509 ± 5%  TOTAL numa-meminfo.node2.Active(anon)

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   1943185 ± 4%     -16.2%    1629057 ± 5%  brickland1/aim7/6000-page_test
   1943185 ± 4%     -16.2%    1629057 ± 5%  TOTAL numa-meminfo.node2.Active

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
 1.659e+08 ± 2%     -13.8%  1.429e+08 ± 1%  wsm/hackbench/1600%-process-pipe
 1.659e+08 ± 2%     -13.8%  1.429e+08 ± 1%  TOTAL cpuidle.C6-NHM.time

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2744 ± 1%     +16.7%       3202 ± 2%  wsm/hackbench/1600%-process-pipe
      2744 ± 1%     +16.7%       3202 ± 2%  TOTAL slabinfo.vm_area_struct.active_slabs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2744 ± 1%     +16.7%       3202 ± 2%  wsm/hackbench/1600%-process-pipe
      2744 ± 1%     +16.7%       3202 ± 2%  TOTAL slabinfo.vm_area_struct.num_slabs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    120778 ± 1%     +16.7%     140916 ± 2%  wsm/hackbench/1600%-process-pipe
    120778 ± 1%     +16.7%     140916 ± 2%  TOTAL slabinfo.vm_area_struct.num_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2107 ± 7%     +14.9%       2420 ± 8%  brickland3/vm-scalability/300s-lru-file-readonce
      2107 ± 7%     +14.9%       2420 ± 8%  TOTAL proc-vmstat.compact_success

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2591 ± 1%     +16.0%       3007 ± 2%  wsm/hackbench/1600%-process-pipe
      2591 ± 1%     +16.0%       3007 ± 2%  TOTAL slabinfo.kmalloc-64.active_slabs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2591 ± 1%     +16.0%       3007 ± 2%  wsm/hackbench/1600%-process-pipe
      2591 ± 1%     +16.0%       3007 ± 2%  TOTAL slabinfo.kmalloc-64.num_slabs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    165897 ± 1%     +16.0%     192484 ± 2%  wsm/hackbench/1600%-process-pipe
    165897 ± 1%     +16.0%     192484 ± 2%  TOTAL slabinfo.kmalloc-64.num_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      4.40 ± 2%     +22.0%       5.37 ± 4%  brickland1/aim7/6000-page_test
      1.54 ± 2%     -12.0%       1.35 ± 3%  wsm/hackbench/1600%-process-pipe
      5.94 ± 2%     +13.2%       6.73 ± 4%  TOTAL turbostat.%c6

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      1683 ± 5%     -11.0%       1497 ± 9%  brickland3/vm-scalability/300s-lru-file-readonce
      1683 ± 5%     -11.0%       1497 ± 9%  TOTAL slabinfo.xfs_inode.num_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      1683 ± 5%     -11.0%       1497 ± 9%  brickland3/vm-scalability/300s-lru-file-readonce
      1683 ± 5%     -11.0%       1497 ± 9%  TOTAL slabinfo.xfs_inode.active_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
       329 ± 1%     -13.3%        285 ± 0%  brickland1/aim7/6000-page_test
       329 ± 1%     -13.3%        285 ± 0%  TOTAL uptime.boot

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     43214 ± 6%     -15.2%      36648 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
     43214 ± 6%     -15.2%      36648 ± 4%  TOTAL numa-vmstat.node0.nr_page_table_pages

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    175030 ± 7%     -16.1%     146779 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
    175030 ± 7%     -16.1%     146779 ± 4%  TOTAL numa-meminfo.node0.PageTables

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     47374 ± 1%     -10.4%      42459 ± 4%  wsm/hackbench/1600%-process-pipe
     47374 ± 1%     -10.4%      42459 ± 4%  TOTAL meminfo.DirectMap4k

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
    205471 ± 7%     +18.5%     243577 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
    205471 ± 7%     +18.5%     243577 ± 3%  TOTAL cpuidle.C1E-SNB.usage

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     86033 ± 1%     +14.0%      98061 ± 2%  wsm/hackbench/1600%-process-pipe
     86033 ± 1%     +14.0%      98061 ± 2%  TOTAL slabinfo.anon_vma.num_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     10692 ± 1%     -12.7%       9334 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
     10692 ± 1%     -12.7%       9334 ± 3%  TOTAL proc-vmstat.pageoutrun

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      1343 ± 1%     +14.0%       1531 ± 2%  wsm/hackbench/1600%-process-pipe
      1343 ± 1%     +14.0%       1531 ± 2%  TOTAL slabinfo.anon_vma.active_slabs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      1343 ± 1%     +14.0%       1531 ± 2%  wsm/hackbench/1600%-process-pipe
      1343 ± 1%     +14.0%       1531 ± 2%  TOTAL slabinfo.anon_vma.num_slabs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     18554 ± 0%      -9.2%      16845 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
      4687 ± 1%     +19.1%       5582 ± 2%  wsm/hackbench/1600%-process-pipe
     23241 ± 0%      -3.5%      22427 ± 1%  TOTAL slabinfo.mm_struct.active_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      8281 ± 0%     -14.7%       7062 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
      3737 ± 0%      -9.8%       3371 ± 1%  wsm/hackbench/1600%-process-pipe
     12018 ± 0%     -13.2%      10433 ± 1%  TOTAL vmstat.procs.r

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     26179 ± 0%     -10.1%      23527 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
      5556 ± 1%     +16.6%       6479 ± 2%  wsm/hackbench/1600%-process-pipe
     31736 ± 0%      -5.4%      30006 ± 1%  TOTAL slabinfo.files_cache.active_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      3077 ± 1%     +14.5%       3523 ± 0%  brickland1/aim7/6000-page_test
    181562 ± 3%     +13.5%     206096 ± 5%  brickland3/vm-scalability/300s-lru-file-readonce
    184639 ± 3%     +13.5%     209619 ± 5%  TOTAL proc-vmstat.pgactivate

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      6012 ± 1%     +13.1%       6797 ± 1%  wsm/hackbench/1600%-process-pipe
      6012 ± 1%     +13.1%       6797 ± 1%  TOTAL slabinfo.mm_struct.num_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     13158 ±13%     -14.4%      11261 ± 4%  brickland1/aim7/6000-page_test
     13158 ±13%     -14.4%      11261 ± 4%  TOTAL numa-meminfo.node3.SReclaimable

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      3289 ±13%     -14.4%       2815 ± 4%  brickland1/aim7/6000-page_test
      3289 ±13%     -14.4%       2815 ± 4%  TOTAL numa-vmstat.node3.nr_slab_reclaimable

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      6722 ± 1%     +12.5%       7562 ± 2%  wsm/hackbench/1600%-process-pipe
      6722 ± 1%     +12.5%       7562 ± 2%  TOTAL slabinfo.files_cache.num_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      9663 ± 0%     -11.6%       8546 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
      9663 ± 0%     -11.6%       8546 ± 2%  TOTAL proc-vmstat.kswapd_low_wmark_hit_quickly

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     60059 ± 5%     +12.2%      67416 ± 3%  lkp-snb01/hackbench/1600%-process-pipe
     60059 ± 5%     +12.2%      67416 ± 3%  TOTAL cpuidle.C7-SNB.usage

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2815 ± 3%      -8.3%       2581 ± 6%  brickland3/vm-scalability/300s-lru-file-readonce
      2815 ± 3%      -8.3%       2581 ± 6%  TOTAL slabinfo.buffer_head.active_objs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   4529818 ± 1%      -8.8%    4129398 ± 1%  brickland1/aim7/6000-page_test
    237630 ± 0%     -13.1%     206405 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 8.785e+08 ± 1%     +51.3%  1.329e+09 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
  89463167 ± 9%    +250.9%   3.14e+08 ± 1%  wsm/hackbench/1600%-process-pipe
 9.727e+08 ± 2%     +69.3%  1.647e+09 ± 1%  TOTAL time.involuntary_context_switches

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
      2175 ± 1%      -8.8%       1984 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
     23054 ± 1%     +12.2%      25876 ± 0%  lkp-nex04/pigz/100%-128K
   4619649 ± 0%     +30.1%    6008008 ± 2%  lkp-snb01/hackbench/1600%-process-pipe
    529899 ± 5%    +167.6%    1418080 ± 0%  wsm/hackbench/1600%-process-pipe
   5174778 ± 1%     +44.0%    7453950 ± 2%  TOTAL vmstat.system.cs

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   3150464 ± 2%     -24.2%    2387551 ± 3%  brickland1/aim7/6000-page_test
   3890218 ± 1%      +7.6%    4184429 ± 0%  lkp-nex04/pigz/100%-128K
 1.926e+09 ± 1%     +21.0%  2.331e+09 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
 2.322e+08 ± 3%    +136.4%  5.489e+08 ± 0%  wsm/hackbench/1600%-process-pipe
 2.166e+09 ± 1%     +33.3%  2.887e+09 ± 1%  TOTAL time.voluntary_context_switches

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
   1067968 ± 1%     -36.5%     677985 ± 4%  lkp-snb01/hackbench/1600%-process-pipe
    231933 ± 0%      -1.2%     229082 ± 0%  nhm4/ebizzy/200%-100x-10s
     16014 ± 1%     +59.3%      25511 ± 0%  wsm/hackbench/1600%-process-pipe
   1315917 ± 0%     -29.1%     932579 ± 2%  TOTAL vmstat.system.in

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
       281 ± 1%     -15.1%        238 ± 0%  brickland1/aim7/6000-page_test
       281 ± 1%     -15.1%        238 ± 0%  TOTAL time.elapsed_time

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     29294 ± 1%     -14.3%      25093 ± 0%  brickland1/aim7/6000-page_test
     33619 ± 0%      +1.2%      34032 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
     62914 ± 0%      -6.0%      59125 ± 0%  TOTAL time.system_time

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
  18258004 ± 1%      -3.8%   17557683 ± 1%  lkp-snb01/hackbench/1600%-process-pipe
 3.104e+09 ± 0%      -1.0%  3.073e+09 ± 0%  nhm4/ebizzy/200%-100x-10s
  13852545 ± 2%     -16.7%   11538015 ± 1%  wsm/hackbench/1600%-process-pipe
 3.137e+09 ± 0%      -1.1%  3.103e+09 ± 0%  TOTAL time.minor_page_faults

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     18531 ± 0%      -1.8%      18206 ± 0%  lkp-nex04/pigz/100%-128K
      1388 ± 0%     +11.2%       1543 ± 0%  lkp-snb01/hackbench/1600%-process-pipe
      2718 ± 0%      -1.5%       2678 ± 0%  nhm4/ebizzy/200%-100x-10s
     22638 ± 0%      -0.9%      22428 ± 0%  TOTAL time.user_time

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
           ± 1%      -3.4%            ± 0%  brickland1/aim7/6000-page_test
           ± 1%      -3.4%            ± 0%  TOTAL turbostat.RAM_W

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
           ± 0%      +1.8%            ± 0%  lkp-snb01/hackbench/1600%-process-pipe
           ± 0%      +1.8%            ± 0%  TOTAL turbostat.Cor_W

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     10655 ± 0%      +1.4%      10802 ± 0%  brickland1/aim7/6000-page_test
      8224 ± 0%      +1.4%       8341 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
      6230 ± 0%      -1.7%       6125 ± 0%  lkp-nex04/pigz/100%-128K
     25110 ± 0%      +0.6%      25269 ± 0%  TOTAL time.percent_of_cpu_this_job_got

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
     72.35 ± 0%      +1.2%      73.20 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
     97.29 ± 0%      -1.6%      95.71 ± 0%  lkp-nex04/pigz/100%-128K
    169.63 ± 0%      -0.4%     168.91 ± 0%  TOTAL turbostat.%c0

107437febd495a5  143e1e28cb40bed836b0a0656  
---------------  -------------------------  
           ± 0%      +1.2%            ± 0%  lkp-snb01/hackbench/1600%-process-pipe
           ± 0%      +1.2%            ± 0%  TOTAL turbostat.Pkg_W


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Fengguang
