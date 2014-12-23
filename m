Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750909AbaLWFGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 00:06:22 -0500
Received: from mga03.intel.com ([134.134.136.65]:64204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbaLWFGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 00:06:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="432426417"
Message-ID: <1419311149.26403.49.camel@intel.com>
Subject: [LKP] [mm/rmap] 3dec0ba0be6: +19.7% vm-scalability.throughput
 +25.7% turbostat.Pkg_W
From: Huang Ying <ying.huang@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Date: Tue, 23 Dec 2014 13:05:49 +0800
Content-Type: multipart/mixed; boundary="=-ZKO6uki1KEJ8APgjM/81"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZKO6uki1KEJ8APgjM/81
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 3dec0ba0be6a532cac949e02b853021bf6d57dad ("mm/rmap: share the i_mmap_rwsem")


testbox/testcase/testparams: ivb43/vm-scalability/performance-300s-mmap-xread-seq-mt

c8c06efa8b552608  3dec0ba0be6a532cac949e02b8  
----------------  --------------------------  
         %stddev     %change         %stddev
             \          |                \  
  41518023 ±  0%     +19.7%   49689052 ±  1%  vm-scalability.throughput
      1.03 ±  1%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.call_rwsem_wake.rmap_walk.page_referenced.shrink_page_list.shrink_inactive_list
      1.16 ±  2%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.rwsem_down_write_failed.call_rwsem_down_write_failed.rmap_walk.try_to_unmap.shrink_page_list
      1.17 ±  2%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.call_rwsem_down_write_failed.rmap_walk.try_to_unmap.shrink_page_list.shrink_inactive_list
      1.22 ±  0%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.try_to_wake_up.wake_up_process.__rwsem_do_wake.rwsem_wake.call_rwsem_wake
      1.28 ±  0%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.__rwsem_do_wake.rwsem_wake.call_rwsem_wake.rmap_walk.try_to_unmap
      1.34 ±  1%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.intel_idle.cpuidle_enter_state.cpuidle_enter.cpu_startup_entry.start_secondary
      1.39 ±  1%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.wake_up_process.__rwsem_do_wake.rwsem_wake.call_rwsem_wake.rmap_walk
     11289 ±  0%     -81.3%       2110 ±  3%  uptime.idle
      0.04 ± 45%    -100.0%       0.00 ±  0%  turbostat.%c3
      1.44 ±  0%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.cpuidle_enter_state.cpuidle_enter.cpu_startup_entry.start_secondary
      1.49 ±  0%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.rwsem_wake.call_rwsem_wake.rmap_walk.try_to_unmap.shrink_page_list
      1.49 ±  0%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.call_rwsem_wake.rmap_walk.try_to_unmap.shrink_page_list.shrink_inactive_list
      3.18 ±  2%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.rwsem_spin_on_owner.rwsem_down_write_failed.call_rwsem_down_write_failed.rmap_walk.page_referenced
      4.15 ±  2%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.rwsem_down_write_failed.call_rwsem_down_write_failed.rmap_walk.page_referenced.shrink_page_list
      4.16 ±  2%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.call_rwsem_down_write_failed.rmap_walk.page_referenced.shrink_page_list.shrink_inactive_list
       605 ±  9%   +1185.9%       7779 ± 22%  numa-vmstat.node1.nr_pages_scanned
     11220 ±  4%    +404.9%      56653 ±  5%  numa-vmstat.node1.nr_active_anon
      5751 ±  6%    +600.4%      40283 ±  6%  sched_debug.cfs_rq[47]:/.avg->runnable_avg_sum
       124 ±  6%    +604.8%        877 ±  6%  sched_debug.cfs_rq[47]:/.tg_runnable_contrib
     71630 ± 45%     -90.1%       7098 ± 48%  sched_debug.cpu#47.ttwu_count
     63466 ± 46%     -90.6%       5941 ± 42%  sched_debug.cpu#47.sched_goidle
      6.23 ±  0%    +394.5%      30.79 ±  6%  perf-profile.cpu-cycles.try_to_unmap_one.rmap_walk.try_to_unmap.shrink_page_list.shrink_inactive_list
      5.07 ±  9%    +456.9%      28.22 ±  5%  perf-profile.cpu-cycles.__do_page_cache_readahead.filemap_fault.__do_fault.do_read_fault.handle_mm_fault
      5.05 ±  9%    +458.3%      28.22 ±  5%  perf-profile.cpu-cycles.__page_cache_alloc.__do_page_cache_readahead.filemap_fault.__do_fault.do_read_fault
      5.05 ±  9%    +458.2%      28.22 ±  5%  perf-profile.cpu-cycles.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.__do_page_cache_readahead.filemap_fault
      5.06 ±  9%    +457.9%      28.22 ±  5%  perf-profile.cpu-cycles.alloc_pages_current.__page_cache_alloc.__do_page_cache_readahead.filemap_fault.__do_fault
      5.59 ±  1%    +384.7%      27.09 ±  9%  perf-profile.cpu-cycles.page_referenced.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_zone
      5.53 ±  1%    +389.3%      27.07 ±  9%  perf-profile.cpu-cycles.rmap_walk.page_referenced.shrink_page_list.shrink_inactive_list.shrink_lruvec
      0.20 ±  2%  +13530.4%      26.92 ±  9%  perf-profile.cpu-cycles.page_referenced_one.rmap_walk.page_referenced.shrink_page_list.shrink_inactive_list
      0.09 ±  4%  +28973.0%      26.89 ±  9%  perf-profile.cpu-cycles.__page_check_address.page_referenced_one.rmap_walk.page_referenced.shrink_page_list
      0.04 ± 17%  +60475.0%      24.23 ±  9%  perf-profile.cpu-cycles._raw_spin_lock.__page_check_address.page_referenced_one.rmap_walk.page_referenced
    128298 ± 45%     -88.8%      14312 ± 33%  sched_debug.cpu#47.nr_switches
      6624 ± 11%    +517.8%      40925 ± 11%  sched_debug.cfs_rq[46]:/.avg->runnable_avg_sum
      0.06 ±  7%  +37773.9%      21.78 ± 14%  perf-profile.cpu-cycles.__page_check_address.try_to_unmap_one.rmap_walk.try_to_unmap.shrink_page_list
      0.04 ±  0%  +49050.0%      19.66 ± 14%  perf-profile.cpu-cycles._raw_spin_lock.__page_check_address.try_to_unmap_one.rmap_walk.try_to_unmap
       144 ± 11%    +518.8%        891 ± 11%  sched_debug.cfs_rq[46]:/.tg_runnable_contrib
   1130490 ±  6%     -94.5%      61989 ± 39%  sched_debug.cpu#21.sched_count
       607 ± 18%    +420.6%       3160 ± 18%  sched_debug.cpu#46.curr->pid
      0.83 ±  2%    +429.3%       4.42 ±  2%  perf-profile.cpu-cycles.kthread.ret_from_fork
      0.83 ±  2%    +429.3%       4.42 ±  2%  perf-profile.cpu-cycles.ret_from_fork
      0.73 ±  3%    +502.4%       4.38 ±  2%  perf-profile.cpu-cycles.kswapd_shrink_zone.kswapd.kthread.ret_from_fork
      0.72 ±  3%    +508.0%       4.38 ±  2%  perf-profile.cpu-cycles.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_zone.kswapd_shrink_zone
      0.73 ±  3%    +502.4%       4.38 ±  2%  perf-profile.cpu-cycles.kswapd.kthread.ret_from_fork
      0.73 ±  3%    +502.1%       4.38 ±  2%  perf-profile.cpu-cycles.shrink_lruvec.shrink_zone.kswapd_shrink_zone.kswapd.kthread
      0.73 ±  3%    +502.1%       4.38 ±  2%  perf-profile.cpu-cycles.shrink_inactive_list.shrink_lruvec.shrink_zone.kswapd_shrink_zone.kswapd
      0.73 ±  3%    +502.4%       4.38 ±  2%  perf-profile.cpu-cycles.shrink_zone.kswapd_shrink_zone.kswapd.kthread.ret_from_fork
      5602 ±  3%    +660.0%      42577 ±  1%  sched_debug.cfs_rq[45]:/.avg->runnable_avg_sum
       122 ±  2%    +659.3%        928 ±  1%  sched_debug.cfs_rq[45]:/.tg_runnable_contrib
      0.00 ±  0%      +Inf%       2.47 ±  2%  perf-profile.cpu-cycles.call_function_interrupt.__page_check_address.page_referenced_one.rmap_walk.page_referenced
      0.00 ±  0%      +Inf%       2.24 ±  4%  perf-profile.cpu-cycles.flush_smp_call_function_queue.generic_smp_call_function_single_interrupt.smp_call_function_interrupt.call_function_interrupt.__page_check_address
      0.00 ±  0%      +Inf%       1.97 ±  7%  perf-profile.cpu-cycles.call_function_interrupt.__page_check_address.try_to_unmap_one.rmap_walk.try_to_unmap
     46823 ± 14%     -88.2%       5508 ± 33%  sched_debug.cpu#45.ttwu_count
     43527 ± 17%     -88.4%       5031 ± 36%  sched_debug.cpu#45.sched_goidle
      0.00 ±  0%      +Inf%       1.64 ±  2%  perf-profile.cpu-cycles.smp_call_function_interrupt.call_function_interrupt.__page_check_address.page_referenced_one.rmap_walk
      0.00 ±  0%      +Inf%       1.40 ±  2%  perf-profile.cpu-cycles.generic_smp_call_function_single_interrupt.smp_call_function_interrupt.call_function_interrupt.__page_check_address.page_referenced_one
      0.00 ±  0%      +Inf%       1.33 ±  7%  perf-profile.cpu-cycles.smp_call_function_interrupt.call_function_interrupt.__page_check_address.try_to_unmap_one.rmap_walk
      0.00 ±  0%      +Inf%       1.13 ±  7%  perf-profile.cpu-cycles.generic_smp_call_function_single_interrupt.smp_call_function_interrupt.call_function_interrupt.__page_check_address.try_to_unmap_one
     87628 ± 17%     -86.3%      11995 ± 31%  sched_debug.cpu#45.nr_switches
      5697 ±  3%    +644.0%      42388 ±  3%  sched_debug.cfs_rq[44]:/.avg->runnable_avg_sum
       123 ±  3%    +647.4%        923 ±  3%  sched_debug.cfs_rq[44]:/.tg_runnable_contrib
      4.59 ±  1%     -99.5%       0.03 ± 34%  perf-profile.cpu-cycles.start_secondary
      4.57 ±  1%     -99.5%       0.03 ± 34%  perf-profile.cpu-cycles.cpu_startup_entry.start_secondary
      1.95 ±  3%     -99.1%       0.02 ± 24%  perf-profile.cpu-cycles.cpuidle_enter.cpu_startup_entry.start_secondary
 4.119e+09 ±  2%     -95.5%  1.863e+08 ± 12%  cpuidle.C1-IVT.time
   5728564 ± 36%     -82.1%    1026116 ± 14%  cpuidle.C3-IVT.time
     25186 ± 18%     -93.2%       1711 ± 26%  cpuidle.C3-IVT.usage
 6.121e+09 ±  1%     -83.7%  9.959e+08 ±  6%  cpuidle.C6-IVT.time
   1218282 ±  1%     -85.6%     175991 ± 11%  cpuidle.C6-IVT.usage
     54958 ±  8%     -89.8%       5581 ± 40%  sched_debug.cpu#44.ttwu_count
     60.80 ±  0%     -89.5%       6.39 ±  7%  turbostat.%c1
     52291 ± 13%     -91.0%       4695 ± 49%  sched_debug.cpu#44.sched_goidle
    105251 ± 13%     -88.6%      11972 ± 38%  sched_debug.cpu#44.nr_switches
      5477 ±  8%    +584.9%      37517 ±  8%  sched_debug.cfs_rq[43]:/.avg->runnable_avg_sum
       119 ±  8%    +585.1%        817 ±  8%  sched_debug.cfs_rq[43]:/.tg_runnable_contrib
       347 ± 38%    +624.6%       2518 ± 11%  sched_debug.cpu#43.ttwu_local
      5608 ±  9%    +647.2%      41904 ±  0%  sched_debug.cfs_rq[42]:/.avg->runnable_avg_sum
       122 ±  9%    +648.6%        913 ±  0%  sched_debug.cfs_rq[42]:/.tg_runnable_contrib
       341 ± 31%    +558.7%       2251 ± 34%  sched_debug.cpu#42.ttwu_local
      5692 ±  8%    +602.5%      39991 ±  4%  sched_debug.cfs_rq[41]:/.avg->runnable_avg_sum
       124 ±  8%    +602.8%        871 ±  4%  sched_debug.cfs_rq[41]:/.tg_runnable_contrib
    632720 ±  3%     -97.6%      15185 ± 36%  sched_debug.cpu#18.ttwu_count
    546610 ±  4%     -98.1%      10221 ± 35%  sched_debug.cpu#18.sched_goidle
    159155 ±  7%    +672.0%    1228632 ± 16%  proc-vmstat.pgscan_kswapd_dma32
   3270184 ±  2%    +556.5%   21468949 ± 25%  proc-vmstat.pgscan_kswapd_normal
   1220265 ±  1%     -94.3%      70114 ± 36%  sched_debug.cpu#20.sched_count
      6468 ± 10%    +540.2%      41413 ±  3%  sched_debug.cfs_rq[40]:/.avg->runnable_avg_sum
       140 ± 10%    +542.3%        902 ±  3%  sched_debug.cfs_rq[40]:/.tg_runnable_contrib
     67924 ± 39%     -88.8%       7600 ± 42%  sched_debug.cpu#40.ttwu_count
     61532 ± 40%     -89.4%       6528 ± 43%  sched_debug.cpu#40.sched_goidle
    128701 ± 36%     -80.9%      24561 ± 44%  sched_debug.cpu#40.sched_count
     45332 ±  4%    +401.3%     227237 ±  5%  numa-meminfo.node1.Active(anon)
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#0.nr_running
    123794 ± 40%     -86.9%      16202 ± 42%  sched_debug.cpu#40.nr_switches
      6446 ± 14%    +518.6%      39877 ±  6%  sched_debug.cfs_rq[39]:/.avg->runnable_avg_sum
       140 ± 13%    +517.6%        869 ±  6%  sched_debug.cfs_rq[39]:/.tg_runnable_contrib
   1096298 ±  4%     -97.5%      27591 ± 28%  sched_debug.cpu#18.nr_switches
       411 ± 11%    +632.1%       3008 ± 28%  sched_debug.cpu#39.ttwu_local
      6036 ±  9%    +583.5%      41261 ±  6%  sched_debug.cfs_rq[38]:/.avg->runnable_avg_sum
        26 ± 23%   +1544.3%        435 ± 19%  sched_debug.cpu#1.load
       130 ±  9%    +588.1%        899 ±  6%  sched_debug.cfs_rq[38]:/.tg_runnable_contrib
        22 ± 21%   +1898.9%        439 ± 18%  sched_debug.cpu#1.cpu_load[0]
        22 ± 26%   +1898.9%        439 ± 18%  sched_debug.cpu#1.cpu_load[1]
        21 ± 26%   +1921.8%        439 ± 18%  sched_debug.cpu#1.cpu_load[2]
        21 ± 26%   +1919.5%        439 ± 18%  sched_debug.cpu#1.cpu_load[3]
        21 ± 30%   +1941.9%        439 ± 18%  sched_debug.cpu#1.cpu_load[4]
   1102216 ±  1%     -94.3%      62385 ± 35%  sched_debug.cpu#23.sched_count
        35 ± 26%   +1118.9%        435 ± 19%  sched_debug.cfs_rq[1]:/.load
        19 ± 26%   +2161.0%        435 ± 19%  sched_debug.cfs_rq[1]:/.runnable_load_avg
       337 ± 16%    +450.9%       1860 ± 22%  sched_debug.cpu#38.ttwu_local
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#2.nr_running
   1129044 ±  3%     -94.1%      66651 ± 46%  sched_debug.cpu#2.nr_switches
       602 ± 30%    +475.4%       3467 ±  5%  sched_debug.cpu#38.curr->pid
      7234 ± 21%    +473.3%      41477 ±  3%  sched_debug.cfs_rq[37]:/.avg->runnable_avg_sum
       157 ± 21%    +474.7%        903 ±  2%  sched_debug.cfs_rq[37]:/.tg_runnable_contrib
   1152534 ±  1%     -93.9%      69989 ± 44%  sched_debug.cpu#2.sched_count
    563500 ±  2%     -94.6%      30610 ± 49%  sched_debug.cpu#2.sched_goidle
         4 ± 42%    +382.4%         20 ±  5%  sched_debug.cpu#24.cpu_load[4]
    628526 ±  3%     -98.0%      12750 ± 37%  sched_debug.cpu#17.ttwu_count
      5451 ±  9%    +678.7%      42448 ±  4%  sched_debug.cfs_rq[36]:/.avg->runnable_avg_sum
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#3.nr_running
       118 ±  9%    +679.6%        925 ±  4%  sched_debug.cfs_rq[36]:/.tg_runnable_contrib
   1257445 ±  2%     -94.6%      67414 ± 45%  sched_debug.cpu#3.nr_switches
    587137 ±  2%     -98.3%       9903 ± 43%  sched_debug.cpu#17.sched_goidle
   1221394 ±  3%     -95.2%      59133 ± 30%  sched_debug.cpu#17.sched_count
   1308463 ±  6%     -94.7%      69557 ± 44%  sched_debug.cpu#3.sched_count
    627757 ±  2%     -95.1%      31029 ± 48%  sched_debug.cpu#3.sched_goidle
    579966 ±  1%     -93.9%      35154 ± 47%  sched_debug.cpu#3.ttwu_count
       282 ± 20%    +391.1%       1386 ± 15%  sched_debug.cpu#24.ttwu_local
   1176269 ±  2%     -97.8%      26163 ± 35%  sched_debug.cpu#17.nr_switches
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#4.nr_running
       647 ± 37%    +446.4%       3537 ±  4%  sched_debug.cpu#36.curr->pid
      5553 ±  9%    +692.0%      43986 ±  1%  sched_debug.cfs_rq[35]:/.avg->runnable_avg_sum
       120 ±  9%    +695.4%        958 ±  1%  sched_debug.cfs_rq[35]:/.tg_runnable_contrib
         4 ± 34%    +588.2%         29 ± 17%  sched_debug.cfs_rq[35]:/.runnable_load_avg
       137 ± 14%    +590.4%        949 ±  0%  sched_debug.cfs_rq[24]:/.tg_runnable_contrib
         2 ± 30%   +1045.5%         31 ± 23%  sched_debug.cpu#35.cpu_load[4]
         2 ± 30%   +1009.1%         30 ± 17%  sched_debug.cpu#35.cpu_load[3]
         3 ± 14%    +757.1%         30 ± 15%  sched_debug.cpu#35.cpu_load[2]
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#5.nr_running
         4 ± 25%    +617.6%         30 ± 15%  sched_debug.cpu#35.cpu_load[1]
         5 ± 14%    +515.0%         30 ± 16%  sched_debug.cpu#35.cpu_load[0]
       631 ± 46%    +462.6%       3551 ±  3%  sched_debug.cpu#35.curr->pid
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#35.nr_running
      6305 ± 14%    +591.7%      43620 ±  0%  sched_debug.cfs_rq[24]:/.avg->runnable_avg_sum
      5920 ±  9%    +637.1%      43638 ±  0%  sched_debug.cfs_rq[34]:/.avg->runnable_avg_sum
       128 ±  9%    +639.1%        949 ±  0%  sched_debug.cfs_rq[34]:/.tg_runnable_contrib
         5 ± 45%   +7104.8%        378 ± 25%  sched_debug.cpu#25.cpu_load[0]
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#6.nr_running
       214 ± 12%    +569.0%       1433 ± 26%  sched_debug.cpu#34.ttwu_local
         3 ± 29%    +500.0%         22 ±  6%  sched_debug.cpu#34.cpu_load[4]
   1193134 ±  2%     -94.4%      67300 ± 44%  sched_debug.cpu#16.sched_count
         5 ± 45%   +7104.8%        378 ± 25%  sched_debug.cpu#25.cpu_load[1]
         5 ± 42%   +7465.0%        378 ± 25%  sched_debug.cpu#25.cpu_load[2]
         4 ± 40%   +7873.7%        378 ± 25%  sched_debug.cpu#25.cpu_load[3]
      1.03 ±  0%    -100.0%       0.00 ±  0%  perf-profile.cpu-cycles.rwsem_wake.call_rwsem_wake.rmap_walk.page_referenced.shrink_page_list
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#34.nr_running
      6355 ± 18%    +587.5%      43698 ±  0%  sched_debug.cfs_rq[33]:/.avg->runnable_avg_sum
       138 ± 18%    +588.4%        951 ±  0%  sched_debug.cfs_rq[33]:/.tg_runnable_contrib
         4 ± 36%   +8316.7%        378 ± 25%  sched_debug.cpu#25.cpu_load[4]
         4 ± 35%    +450.0%         22 ±  5%  sched_debug.cpu#33.cpu_load[4]
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#33.nr_running
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#7.nr_running
      7290 ± 23%    +498.9%      43659 ±  0%  sched_debug.cfs_rq[32]:/.avg->runnable_avg_sum
       158 ± 23%    +500.9%        951 ±  0%  sched_debug.cfs_rq[32]:/.tg_runnable_contrib
         5 ± 45%   +7104.8%        378 ± 25%  sched_debug.cfs_rq[25]:/.runnable_load_avg
    667825 ±  2%     -97.4%      17292 ± 30%  sched_debug.cpu#15.ttwu_count
       610 ± 15%    +470.6%       3483 ±  0%  sched_debug.cpu#26.curr->pid
    534622 ±  3%     -97.3%      14624 ± 30%  sched_debug.cpu#15.sched_goidle
   1135582 ±  6%     -94.9%      57656 ± 14%  sched_debug.cpu#15.sched_count
         4 ± 46%    +431.2%         21 ±  3%  sched_debug.cpu#26.cpu_load[0]
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#8.nr_running
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#32.nr_running
      6181 ± 11%    +595.1%      42962 ±  2%  sched_debug.cfs_rq[31]:/.avg->runnable_avg_sum
    136964 ± 45%    +307.3%     557871 ± 18%  sched_debug.cpu#8.avg_idle
       134 ± 11%    +595.2%        935 ±  2%  sched_debug.cfs_rq[31]:/.tg_runnable_contrib
         4 ± 46%    +431.2%         21 ±  3%  sched_debug.cpu#26.cpu_load[1]
   1074159 ±  3%     -96.6%      36206 ± 24%  sched_debug.cpu#15.nr_switches
         3 ± 42%    +507.1%         21 ±  3%  sched_debug.cpu#26.cpu_load[2]
         3 ± 33%    +561.5%         21 ±  2%  sched_debug.cpu#26.cpu_load[3]
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#9.nr_running
      5844 ±  9%    +644.5%      43512 ±  0%  sched_debug.cfs_rq[30]:/.avg->runnable_avg_sum
       126 ±  9%    +649.5%        950 ±  0%  sched_debug.cfs_rq[30]:/.tg_runnable_contrib
         2 ± 47%    +681.8%         21 ±  2%  sched_debug.cpu#26.cpu_load[4]
         3 ± 39%    +584.6%         22 ±  5%  sched_debug.cpu#30.cpu_load[4]
    652232 ±  1%     -97.4%      17219 ± 29%  sched_debug.cpu#14.ttwu_count
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#10.nr_running
   1112495 ±  5%     -94.6%      59865 ± 34%  sched_debug.cpu#14.sched_count
       623 ± 43%    +462.3%       3507 ±  1%  sched_debug.cpu#30.curr->pid
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#30.nr_running
      5996 ±  8%    +630.9%      43826 ±  1%  sched_debug.cfs_rq[29]:/.avg->runnable_avg_sum
       130 ±  8%    +636.7%        957 ±  1%  sched_debug.cfs_rq[29]:/.tg_runnable_contrib
         4 ± 46%    +431.2%         21 ±  3%  sched_debug.cfs_rq[26]:/.runnable_load_avg
   1042659 ±  2%     -96.6%      35462 ± 26%  sched_debug.cpu#14.nr_switches
       126 ±  8%    +654.0%        950 ±  0%  sched_debug.cfs_rq[26]:/.tg_runnable_contrib
         3 ± 23%    +708.3%         24 ± 16%  sched_debug.cpu#29.cpu_load[4]
         3 ± 31%    +592.9%         24 ± 16%  sched_debug.cpu#29.cpu_load[3]
      5797 ±  8%    +652.4%      43621 ±  0%  sched_debug.cfs_rq[26]:/.avg->runnable_avg_sum
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#11.nr_running
       495 ± 24%    +618.1%       3560 ±  3%  sched_debug.cpu#29.curr->pid
        61 ± 43%    +520.5%        378 ± 22%  sched_debug.cfs_rq[13]:/.tg_load_contrib
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#29.nr_running
      6354 ± 20%    +585.7%      43575 ±  0%  sched_debug.cfs_rq[28]:/.avg->runnable_avg_sum
       138 ± 19%    +587.2%        950 ±  0%  sched_debug.cfs_rq[28]:/.tg_runnable_contrib
    823802 ±  4%     -96.4%      29781 ± 32%  sched_debug.cpu#12.nr_switches
         5 ± 24%    +380.0%         24 ±  4%  sched_debug.cfs_rq[28]:/.load
       568 ± 30%    +512.9%       3486 ±  2%  sched_debug.cpu#27.curr->pid
         4 ± 48%    +427.8%         23 ±  3%  sched_debug.cpu#28.cpu_load[2]
    850130 ±  4%     -93.5%      55426 ± 15%  sched_debug.cpu#12.sched_count
    410142 ±  4%     -97.3%      10879 ± 38%  sched_debug.cpu#12.sched_goidle
    486755 ±  3%     -96.8%      15412 ± 29%  sched_debug.cpu#12.ttwu_count
       621 ±  9%    +461.7%       3488 ±  0%  sched_debug.cpu#28.curr->pid
         5 ± 24%    +380.0%         24 ±  4%  sched_debug.cpu#28.load
         0 ±  0%      +Inf%          1 ±  0%  sched_debug.cpu#28.nr_running
      5868 ± 11%    +641.9%      43534 ±  0%  sched_debug.cfs_rq[27]:/.avg->runnable_avg_sum
       127 ± 11%    +644.7%        949 ±  0%  sched_debug.cfs_rq[27]:/.tg_runnable_contrib
   1057793 ±  4%     -91.2%      92598 ± 27%  sched_debug.cpu#13.sched_count
      8.34 ±  2%     -81.2%       1.57 ± 16%  turbostat.%c6
    109484 ± 10%     -80.7%      21109 ± 34%  sched_debug.cpu#44.sched_count
    153208 ± 30%    +420.2%     796994 ±  5%  sched_debug.cpu#17.avg_idle
       636 ± 35%    +364.9%       2960 ± 14%  sched_debug.cpu#39.curr->pid
         5 ± 45%    +486.4%         32 ± 41%  sched_debug.cpu#34.load
         5 ± 39%    +313.6%         22 ±  8%  sched_debug.cpu#32.cpu_load[3]
         4 ± 40%    +422.2%         23 ±  4%  sched_debug.cfs_rq[28]:/.runnable_load_avg
         5 ± 37%    +313.6%         22 ±  8%  sched_debug.cpu#32.cpu_load[4]
         3 ± 47%    +560.0%         24 ± 17%  sched_debug.cpu#29.cpu_load[2]
    177657 ± 18%    +331.3%     766210 ±  6%  sched_debug.cpu#1.avg_idle
       230 ± 14%    +421.0%       1202 ± 34%  sched_debug.cpu#35.ttwu_local
       143 ± 12%    +430.1%        758 ±  4%  sched_debug.cfs_rq[25]:/.tg_runnable_contrib
         3 ± 24%    +435.7%         18 ±  2%  sched_debug.cpu#45.cpu_load[4]
       644 ± 44%    +444.3%       3508 ±  1%  sched_debug.cpu#24.curr->pid
      6578 ± 12%    +428.8%      34785 ±  4%  sched_debug.cfs_rq[25]:/.avg->runnable_avg_sum
       638 ± 23%    +436.5%       3423 ±  3%  sched_debug.cpu#31.curr->pid
    162114 ± 13%    +375.4%     770667 ±  2%  sched_debug.cpu#19.avg_idle
       330 ± 20%    +347.0%       1477 ± 25%  sched_debug.cpu#44.ttwu_local
         4 ± 37%    +373.7%         22 ±  6%  sched_debug.cpu#34.cpu_load[2]
         4 ± 34%    +429.4%         22 ±  6%  sched_debug.cpu#34.cpu_load[3]
         3 ± 42%    +528.6%         22 ±  4%  sched_debug.cpu#30.cpu_load[3]
         5 ± 43%    +323.8%         22 ±  8%  sched_debug.cpu#27.cpu_load[2]
         3 ± 47%    +500.0%         22 ±  7%  sched_debug.cpu#30.cpu_load[2]
         5 ± 47%    +323.8%         22 ±  6%  sched_debug.cfs_rq[34]:/.runnable_load_avg
         5 ± 47%    +323.8%         22 ±  6%  sched_debug.cpu#34.cpu_load[1]
       614 ± 26%    +466.0%       3478 ±  0%  sched_debug.cpu#32.curr->pid
         3 ± 22%    +360.0%         17 ±  7%  sched_debug.cpu#47.cpu_load[4]
    159962 ± 16%    +373.1%     756714 ±  8%  sched_debug.cpu#21.avg_idle
      1654 ± 13%    +288.0%       6418 ± 36%  sched_debug.cpu#14.ttwu_local
   1675576 ±  2%    +315.4%    6959706 ±  5%  sched_debug.cfs_rq[47]:/.min_vruntime
         6 ± 50%    +266.7%         22 ±  8%  sched_debug.cpu#27.cpu_load[1]
       635 ± 29%    +450.0%       3494 ±  1%  sched_debug.cpu#34.curr->pid
       811 ± 30%    +303.2%       3273 ±  4%  sched_debug.cpu#47.curr->pid
   1665872 ±  1%    +327.4%    7119702 ±  3%  sched_debug.cfs_rq[44]:/.min_vruntime
   1672016 ±  2%    +329.0%    7172304 ±  1%  sched_debug.cfs_rq[37]:/.min_vruntime
   1673355 ±  2%    +334.7%    7274885 ±  0%  sched_debug.cfs_rq[45]:/.min_vruntime
   1669565 ±  1%    +328.2%    7149228 ±  1%  sched_debug.cfs_rq[42]:/.min_vruntime
   1662238 ±  1%    +329.3%    7136184 ±  2%  sched_debug.cfs_rq[36]:/.min_vruntime
   1675770 ±  2%    +275.8%    6297738 ± 26%  sched_debug.cfs_rq[46]:/.min_vruntime
    154299 ± 24%    +383.7%     746413 ±  2%  sched_debug.cpu#22.avg_idle
    148790 ± 25%    +280.7%     566507 ± 10%  sched_debug.cpu#3.avg_idle
   1691609 ±  1%    +324.7%    7184532 ±  1%  sched_debug.cfs_rq[38]:/.min_vruntime
   1659081 ±  2%    +295.5%    6561192 ±  8%  sched_debug.cfs_rq[41]:/.min_vruntime
   1690936 ±  2%    +315.2%    7021530 ±  4%  sched_debug.cfs_rq[40]:/.min_vruntime
         4 ± 45%    +331.6%         20 ±  5%  sched_debug.cpu#24.cpu_load[3]
         4 ± 39%    +418.8%         20 ±  7%  sched_debug.cpu#31.cpu_load[4]
    134665 ± 19%    +315.5%     559570 ± 14%  sched_debug.cpu#10.avg_idle
     36278 ±  3%    +316.1%     150965 ±  0%  sched_debug.cfs_rq[35]:/.exec_clock
   1671691 ±  1%    +264.8%    6098101 ± 19%  sched_debug.cfs_rq[39]:/.min_vruntime
    160859 ± 21%    +328.9%     689951 ±  2%  sched_debug.cpu#16.avg_idle
     35934 ±  4%    +314.3%     148869 ±  0%  sched_debug.cfs_rq[36]:/.exec_clock
     36012 ±  1%    +309.5%     147485 ±  2%  sched_debug.cfs_rq[44]:/.exec_clock
   1672621 ±  1%    +313.2%    6911022 ±  0%  sched_debug.cfs_rq[31]:/.min_vruntime
   1670950 ±  1%    +312.6%    6894963 ±  0%  sched_debug.cfs_rq[24]:/.min_vruntime
   1675674 ±  1%    +313.9%    6935105 ±  1%  sched_debug.cfs_rq[26]:/.min_vruntime
   1675498 ±  1%    +313.2%    6922328 ±  1%  sched_debug.cfs_rq[29]:/.min_vruntime
   1671750 ±  2%    +313.9%    6918915 ±  1%  sched_debug.cfs_rq[28]:/.min_vruntime
   1681305 ±  2%    +311.1%    6912416 ±  0%  sched_debug.cfs_rq[33]:/.min_vruntime
   1671122 ±  2%    +314.4%    6925435 ±  1%  sched_debug.cfs_rq[30]:/.min_vruntime
     37126 ±  1%    +305.6%     150578 ±  0%  sched_debug.cfs_rq[31]:/.exec_clock
   1676302 ±  2%    +312.9%    6920808 ±  1%  sched_debug.cfs_rq[27]:/.min_vruntime
     36526 ±  1%    +311.9%     150450 ±  0%  sched_debug.cfs_rq[24]:/.exec_clock
    190213 ± 29%    +282.4%     727280 ±  6%  sched_debug.cpu#18.avg_idle
   1677834 ±  2%    +310.1%    6880038 ±  0%  sched_debug.cfs_rq[34]:/.min_vruntime
     36707 ±  3%    +301.8%     147479 ±  1%  sched_debug.cfs_rq[37]:/.exec_clock
   1680208 ±  2%    +310.5%    6898014 ±  1%  sched_debug.cfs_rq[32]:/.min_vruntime
     36375 ±  3%    +310.5%     149316 ±  0%  sched_debug.cfs_rq[45]:/.exec_clock
     37332 ±  6%    +303.5%     150640 ±  0%  sched_debug.cfs_rq[27]:/.exec_clock
     37105 ±  2%    +306.0%     150656 ±  0%  sched_debug.cfs_rq[29]:/.exec_clock
     36747 ±  3%    +284.0%     141091 ±  5%  sched_debug.cfs_rq[39]:/.exec_clock
    140546 ± 14%    +296.0%     556577 ± 17%  sched_debug.cpu#5.avg_idle
       723 ± 21%    +362.8%       3346 ±  2%  sched_debug.cpu#42.curr->pid
         5 ± 37%    +300.0%         23 ±  9%  sched_debug.cpu#32.cpu_load[2]
         5 ± 49%    +352.4%         23 ±  3%  sched_debug.cpu#28.cpu_load[1]
         5 ± 45%    +336.4%         24 ± 12%  sched_debug.cfs_rq[34]:/.load
     36691 ±  4%    +311.2%     150869 ±  0%  sched_debug.cfs_rq[30]:/.exec_clock
     37240 ±  1%    +304.9%     150792 ±  0%  sched_debug.cfs_rq[26]:/.exec_clock
     36242 ±  2%    +305.1%     146809 ±  0%  sched_debug.cfs_rq[42]:/.exec_clock
     37225 ±  4%    +304.1%     150447 ±  0%  sched_debug.cfs_rq[34]:/.exec_clock
     37530 ±  5%    +301.9%     150817 ±  0%  sched_debug.cfs_rq[32]:/.exec_clock
     37382 ±  3%    +303.3%     150763 ±  0%  sched_debug.cfs_rq[33]:/.exec_clock
     38883 ±  5%    +272.1%     144701 ±  5%  sched_debug.cfs_rq[47]:/.exec_clock
       222 ±  8%    +384.2%       1077 ± 43%  sched_debug.cpu#33.ttwu_local
     37068 ±  4%    +306.6%     150734 ±  0%  sched_debug.cfs_rq[28]:/.exec_clock
   1665943 ±  2%    +249.9%    5829140 ± 19%  sched_debug.cfs_rq[43]:/.min_vruntime
       789 ± 31%    +349.7%       3549 ±  8%  sched_debug.cpu#37.curr->pid
       693 ± 33%    +316.4%       2886 ± 24%  sched_debug.cpu#43.curr->pid
     60242 ±  2%    +302.6%     242548 ±  5%  proc-vmstat.pgsteal_kswapd_dma32
     36196 ±  3%    +288.5%     140621 ±  3%  sched_debug.cfs_rq[41]:/.exec_clock
     66025 ±  1%    +283.4%     253141 ±  4%  meminfo.Active(anon)
     16551 ±  1%    +282.6%      63321 ±  4%  proc-vmstat.nr_active_anon
     37897 ±  1%    +289.8%     147708 ±  1%  sched_debug.cfs_rq[38]:/.exec_clock
     37045 ±  4%    +279.4%     140545 ± 10%  sched_debug.cfs_rq[46]:/.exec_clock
         4 ± 45%    +394.4%         22 ±  8%  sched_debug.cpu#27.cpu_load[3]
         4 ± 50%    +456.2%         22 ±  8%  sched_debug.cpu#27.cpu_load[4]
         5 ± 45%    +300.0%         22 ±  7%  sched_debug.cpu#34.cpu_load[0]
    174487 ± 18%    +313.0%     720633 ±  6%  sched_debug.cpu#20.avg_idle
   1659387 ±  2%    +276.8%    6252203 ±  3%  sched_debug.cfs_rq[35]:/.min_vruntime
     38114 ±  4%    +281.2%     145306 ±  3%  sched_debug.cfs_rq[40]:/.exec_clock
         4 ± 33%    +316.7%         18 ±  2%  sched_debug.cpu#45.cpu_load[3]
         5 ± 48%    +425.0%         26 ± 47%  sched_debug.cpu#38.cpu_load[4]
     36165 ±  4%    +272.9%     134847 ±  7%  sched_debug.cfs_rq[43]:/.exec_clock
     67261 ±  6%    +279.8%     255426 ±  5%  numa-meminfo.node1.Shmem
     15.17 ±  0%    +256.7%      54.11 ±  8%  perf-profile.cpu-cycles.shrink_zones.do_try_to_free_pages.try_to_free_pages.__alloc_pages_nodemask.alloc_pages_current
     15.25 ±  0%    +256.2%      54.32 ±  8%  perf-profile.cpu-cycles.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_zone.shrink_zones
     15.35 ±  0%    +254.2%      54.37 ±  8%  perf-profile.cpu-cycles.shrink_inactive_list.shrink_lruvec.shrink_zone.shrink_zones.do_try_to_free_pages
     15.36 ±  0%    +254.0%      54.38 ±  8%  perf-profile.cpu-cycles.shrink_lruvec.shrink_zone.shrink_zones.do_try_to_free_pages.try_to_free_pages
     14.74 ±  1%    +254.4%      52.24 ±  7%  perf-profile.cpu-cycles.do_try_to_free_pages.try_to_free_pages.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc
     15.37 ±  0%    +253.9%      54.38 ±  8%  perf-profile.cpu-cycles.shrink_zone.shrink_zones.do_try_to_free_pages.try_to_free_pages.__alloc_pages_nodemask
     14.74 ±  1%    +254.0%      52.19 ±  7%  perf-profile.cpu-cycles.try_to_free_pages.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.__do_page_cache_readahead
     16716 ±  6%    +281.4%      63761 ±  5%  numa-vmstat.node1.nr_shmem
       256 ± 12%    +281.2%        977 ± 18%  sched_debug.cpu#29.ttwu_local
     18541 ±  1%    +258.3%      66434 ±  3%  proc-vmstat.nr_shmem
     73987 ±  0%    +259.2%     265752 ±  4%  meminfo.Shmem
         5 ± 37%    +345.0%         22 ±  7%  sched_debug.cpu#33.cpu_load[3]
       281 ± 22%    +248.2%        978 ± 14%  sched_debug.cpu#31.ttwu_local
    200388 ± 30%    +269.9%     741252 ±  6%  sched_debug.cpu#14.avg_idle
     98405 ± 11%     -68.4%      31130 ± 44%  sched_debug.cpu#37.sched_count
         4 ± 31%    +268.4%         17 ±  6%  sched_debug.cpu#47.cpu_load[3]
    164156 ± 18%    +289.9%     640109 ±  6%  sched_debug.cpu#11.avg_idle
    237933 ± 36%    +234.1%     794983 ±  4%  sched_debug.cpu#12.avg_idle
         5 ± 36%    +290.5%         20 ±  5%  sched_debug.cfs_rq[31]:/.runnable_load_avg
         4 ± 40%    +336.8%         20 ±  7%  sched_debug.cpu#31.cpu_load[3]
      9.27 ±  0%    +234.3%      30.99 ±  6%  perf-profile.cpu-cycles.rmap_walk.try_to_unmap.shrink_page_list.shrink_inactive_list.shrink_lruvec
       828 ± 39%    +328.4%       3550 ±  3%  sched_debug.cpu#33.curr->pid
      9.33 ±  0%    +232.6%      31.02 ±  6%  perf-profile.cpu-cycles.try_to_unmap.shrink_page_list.shrink_inactive_list.shrink_lruvec.shrink_zone
       865 ± 26%    +286.5%       3344 ±  3%  sched_debug.cpu#40.curr->pid
        13 ±  3%    +255.6%         48 ±  0%  vmstat.procs.r
         5 ± 45%    +347.6%         23 ±  4%  sched_debug.cpu#28.cpu_load[0]
    164431 ± 27%    +311.8%     677119 ±  5%  sched_debug.cpu#13.avg_idle
    156159 ± 12%    +268.7%     575780 ±  7%  sched_debug.cpu#4.avg_idle
     37144 ±  2%    +234.3%     124184 ±  2%  sched_debug.cfs_rq[25]:/.exec_clock
    188347 ± 16%    +270.0%     696976 ±  9%  sched_debug.cpu#23.avg_idle
         6 ± 31%    +345.8%         26 ± 48%  sched_debug.cpu#38.cpu_load[3]
   2091338 ±  1%    +214.2%    6571428 ±  5%  sched_debug.cfs_rq[23]:/.min_vruntime
   2081331 ±  2%    +221.6%    6694159 ±  4%  sched_debug.cfs_rq[20]:/.min_vruntime
       964 ± 36%    +256.6%       3439 ±  1%  sched_debug.cpu#45.curr->pid
   2104190 ±  1%    +223.7%    6810365 ±  2%  sched_debug.cfs_rq[21]:/.min_vruntime
   2102936 ±  2%    +183.8%    5967402 ± 25%  sched_debug.cfs_rq[22]:/.min_vruntime
      1587 ±  7%    +166.7%       4234 ± 25%  sched_debug.cpu#17.ttwu_local
   2119533 ±  1%    +217.7%    6734748 ±  1%  sched_debug.cfs_rq[18]:/.min_vruntime
   2142059 ±  3%    +214.5%    6735988 ±  3%  sched_debug.cfs_rq[14]:/.min_vruntime
   2104927 ±  2%    +219.2%    6719055 ±  2%  sched_debug.cfs_rq[16]:/.min_vruntime
   2157455 ±  1%    +218.2%    6865520 ±  1%  sched_debug.cfs_rq[9]:/.min_vruntime
     17.78 ±  0%    +202.2%      53.73 ±  7%  perf-profile.cpu-cycles.__do_fault.do_read_fault.handle_mm_fault.__do_page_fault.do_page_fault
     17.78 ±  0%    +202.2%      53.73 ±  7%  perf-profile.cpu-cycles.filemap_fault.__do_fault.do_read_fault.handle_mm_fault.__do_page_fault
   2171180 ±  1%    +214.9%    6837517 ±  1%  sched_debug.cfs_rq[6]:/.min_vruntime
   2167333 ±  0%    +217.0%    6871145 ±  0%  sched_debug.cfs_rq[4]:/.min_vruntime
   2151871 ±  0%    +216.2%    6805044 ±  1%  sched_debug.cfs_rq[8]:/.min_vruntime
     18.31 ±  0%    +201.3%      55.17 ±  7%  perf-profile.cpu-cycles.handle_mm_fault.__do_page_fault.do_page_fault.page_fault.do_unit
     18.34 ±  0%    +200.9%      55.19 ±  7%  perf-profile.cpu-cycles.__do_page_fault.do_page_fault.page_fault.do_unit
   2120576 ±  2%    +172.0%    5767593 ± 18%  sched_debug.cfs_rq[15]:/.min_vruntime
     18.34 ±  0%    +200.9%      55.20 ±  7%  perf-profile.cpu-cycles.do_page_fault.page_fault.do_unit
   2168304 ±  0%    +216.3%    6858145 ±  1%  sched_debug.cfs_rq[3]:/.min_vruntime
     18.37 ±  0%    +200.6%      55.20 ±  7%  perf-profile.cpu-cycles.page_fault.do_unit
   2163595 ±  2%    +211.7%    6744152 ±  3%  sched_debug.cfs_rq[13]:/.min_vruntime
   2188471 ±  1%    +213.8%    6867858 ±  1%  sched_debug.cfs_rq[2]:/.min_vruntime
     17.96 ±  0%    +199.8%      53.84 ±  7%  perf-profile.cpu-cycles.do_read_fault.isra.58.handle_mm_fault.__do_page_fault.do_page_fault.page_fault
     86248 ±  3%    +211.5%     268661 ±  5%  numa-meminfo.node1.Active
   2177359 ±  1%    +213.7%    6829757 ±  0%  sched_debug.cfs_rq[7]:/.min_vruntime
   2178979 ±  0%    +213.4%    6829270 ±  1%  sched_debug.cfs_rq[5]:/.min_vruntime
      1533 ±  8%    +179.4%       4286 ± 36%  sched_debug.cpu#19.ttwu_local
   2100626 ±  1%    +193.6%    6167391 ± 10%  sched_debug.cfs_rq[17]:/.min_vruntime
   2171243 ±  1%    +215.0%    6839755 ±  0%  sched_debug.cfs_rq[10]:/.min_vruntime
   2228081 ±  2%    +199.0%    6662896 ±  4%  sched_debug.cfs_rq[12]:/.min_vruntime
        17 ± 19%    +148.6%         43 ± 34%  sched_debug.cpu#16.cpu_load[3]
     14120 ±  2%    +207.3%      43389 ±  0%  sched_debug.cfs_rq[7]:/.tg->runnable_avg
     14123 ±  2%    +207.2%      43391 ±  0%  sched_debug.cfs_rq[8]:/.tg->runnable_avg
     14125 ±  2%    +207.2%      43394 ±  0%  sched_debug.cfs_rq[9]:/.tg->runnable_avg
     14127 ±  2%    +207.2%      43395 ±  0%  sched_debug.cfs_rq[10]:/.tg->runnable_avg
     14130 ±  2%    +207.1%      43397 ±  0%  sched_debug.cfs_rq[11]:/.tg->runnable_avg
       318 ± 28%    +217.3%       1010 ± 18%  sched_debug.cpu#30.ttwu_local
   2254798 ±  1%    +203.6%    6845073 ±  0%  sched_debug.cfs_rq[0]:/.min_vruntime
     14114 ±  2%    +207.3%      43374 ±  0%  sched_debug.cfs_rq[0]:/.tg->runnable_avg
     14125 ±  2%    +207.1%      43376 ±  0%  sched_debug.cfs_rq[1]:/.tg->runnable_avg
     14131 ±  2%    +207.0%      43378 ±  0%  sched_debug.cfs_rq[2]:/.tg->runnable_avg
       915 ± 22%    +245.3%       3160 ±  9%  sched_debug.cpu#41.curr->pid
     14147 ±  2%    +206.6%      43380 ±  0%  sched_debug.cfs_rq[3]:/.tg->runnable_avg
     14151 ±  2%    +206.6%      43385 ±  0%  sched_debug.cfs_rq[4]:/.tg->runnable_avg
     14155 ±  2%    +206.5%      43384 ±  0%  sched_debug.cfs_rq[5]:/.tg->runnable_avg
     14158 ±  2%    +206.5%      43388 ±  0%  sched_debug.cfs_rq[6]:/.tg->runnable_avg
         6 ± 38%    +159.3%         17 ±  6%  sched_debug.cpu#47.cpu_load[1]
         6 ± 20%    +345.8%         26 ± 48%  sched_debug.cpu#38.cpu_load[2]
         6 ± 31%    +191.7%         17 ±  6%  sched_debug.cpu#47.cpu_load[2]
         6 ± 45%    +283.3%         23 ±  9%  sched_debug.cpu#32.cpu_load[1]
         6 ± 45%    +230.8%         21 ± 12%  sched_debug.cpu#31.cpu_load[1]
         5 ± 48%    +281.8%         21 ±  8%  sched_debug.cpu#31.cpu_load[2]
     14209 ±  2%    +205.7%      43436 ±  0%  sched_debug.cfs_rq[14]:/.tg->runnable_avg
     14220 ±  2%    +205.5%      43443 ±  0%  sched_debug.cfs_rq[16]:/.tg->runnable_avg
     14194 ±  2%    +205.7%      43399 ±  0%  sched_debug.cfs_rq[12]:/.tg->runnable_avg
     14220 ±  2%    +205.5%      43440 ±  0%  sched_debug.cfs_rq[15]:/.tg->runnable_avg
     14200 ±  2%    +205.6%      43403 ±  0%  sched_debug.cfs_rq[13]:/.tg->runnable_avg
     14223 ±  2%    +205.4%      43445 ±  0%  sched_debug.cfs_rq[17]:/.tg->runnable_avg
     14241 ±  2%    +205.0%      43429 ±  0%  sched_debug.cfs_rq[18]:/.tg->runnable_avg
     14228 ±  2%    +205.2%      43431 ±  0%  sched_debug.cfs_rq[19]:/.tg->runnable_avg
     14231 ±  2%    +205.2%      43433 ±  0%  sched_debug.cfs_rq[20]:/.tg->runnable_avg
     14275 ±  3%    +204.3%      43437 ±  0%  sched_debug.cfs_rq[22]:/.tg->runnable_avg
     14280 ±  3%    +204.2%      43439 ±  0%  sched_debug.cfs_rq[23]:/.tg->runnable_avg
     14235 ±  2%    +205.1%      43433 ±  0%  sched_debug.cfs_rq[21]:/.tg->runnable_avg
     14308 ±  3%    +203.8%      43470 ±  0%  sched_debug.cfs_rq[30]:/.tg->runnable_avg
     14231 ±  3%    +205.4%      43467 ±  0%  sched_debug.cfs_rq[29]:/.tg->runnable_avg
     14310 ±  3%    +203.8%      43478 ±  0%  sched_debug.cfs_rq[32]:/.tg->runnable_avg
     14313 ±  3%    +203.8%      43487 ±  0%  sched_debug.cfs_rq[33]:/.tg->runnable_avg
     14310 ±  3%    +203.8%      43473 ±  0%  sched_debug.cfs_rq[31]:/.tg->runnable_avg
     14223 ±  3%    +205.5%      43457 ±  0%  sched_debug.cfs_rq[24]:/.tg->runnable_avg
    164683 ± 34%    +267.0%     604322 ±  9%  sched_debug.cpu#6.avg_idle
     14230 ±  3%    +205.4%      43461 ±  0%  sched_debug.cfs_rq[28]:/.tg->runnable_avg
     14223 ±  3%    +205.5%      43459 ±  0%  sched_debug.cfs_rq[25]:/.tg->runnable_avg
     14228 ±  3%    +205.5%      43462 ±  0%  sched_debug.cfs_rq[27]:/.tg->runnable_avg
     14228 ±  3%    +205.5%      43461 ±  0%  sched_debug.cfs_rq[26]:/.tg->runnable_avg
     14485 ±  1%    +200.2%      43488 ±  0%  sched_debug.cfs_rq[34]:/.tg->runnable_avg
     14491 ±  1%    +200.1%      43491 ±  0%  sched_debug.cfs_rq[35]:/.tg->runnable_avg
     14494 ±  1%    +200.1%      43496 ±  0%  sched_debug.cfs_rq[36]:/.tg->runnable_avg
     14492 ±  1%    +200.2%      43510 ±  0%  sched_debug.cfs_rq[43]:/.tg->runnable_avg
     14489 ±  1%    +200.3%      43508 ±  0%  sched_debug.cfs_rq[41]:/.tg->runnable_avg
     14498 ±  1%    +200.0%      43499 ±  0%  sched_debug.cfs_rq[37]:/.tg->runnable_avg
     14490 ±  1%    +200.2%      43508 ±  0%  sched_debug.cfs_rq[42]:/.tg->runnable_avg
     14487 ±  1%    +200.3%      43503 ±  0%  sched_debug.cfs_rq[40]:/.tg->runnable_avg
     14499 ±  1%    +200.0%      43501 ±  0%  sched_debug.cfs_rq[38]:/.tg->runnable_avg
     14501 ±  1%    +200.0%      43503 ±  0%  sched_debug.cfs_rq[39]:/.tg->runnable_avg
     14496 ±  1%    +200.2%      43514 ±  0%  sched_debug.cfs_rq[44]:/.tg->runnable_avg
     14497 ±  1%    +200.2%      43516 ±  0%  sched_debug.cfs_rq[45]:/.tg->runnable_avg
     14501 ±  1%    +200.2%      43532 ±  0%  sched_debug.cfs_rq[46]:/.tg->runnable_avg
     14503 ±  1%    +200.2%      43533 ±  0%  sched_debug.cfs_rq[47]:/.tg->runnable_avg
   2358220 ±  0%    +195.6%    6971659 ±  0%  softirqs.TIMER
   2118082 ±  1%    +162.2%    5553970 ± 17%  sched_debug.cfs_rq[19]:/.min_vruntime
   1551541 ±  1%    +203.3%    4706141 ±  7%  proc-vmstat.pgsteal_kswapd_normal
     10941 ±  3%    +200.2%      32847 ± 10%  proc-vmstat.pgmajfault
   2186689 ±  1%    +187.1%    6277475 ±  2%  sched_debug.cfs_rq[11]:/.min_vruntime
       483 ± 20%    +266.3%       1770 ± 34%  sched_debug.cpu#46.ttwu_local
       895 ± 42%    +281.4%       3415 ±  4%  sched_debug.cpu#44.curr->pid
        99 ± 25%    +195.0%        293 ± 40%  sched_debug.cfs_rq[19]:/.tg_load_contrib
       334 ± 19%    +183.5%        947 ± 36%  sched_debug.cpu#28.ttwu_local
    200188 ± 36%    +258.5%     717771 ±  8%  sched_debug.cpu#15.avg_idle
         6 ± 40%    +354.2%         27 ± 48%  sched_debug.cpu#38.cpu_load[0]
         6 ± 42%    +264.0%         22 ± 10%  sched_debug.cpu#33.cpu_load[2]
      2253 ± 48%     +89.6%       4272 ± 25%  sched_debug.cpu#21.ttwu_local
    183368 ± 22%    +179.6%     512782 ± 11%  sched_debug.cpu#9.avg_idle
         6 ± 41%    +204.0%         19 ±  3%  sched_debug.cpu#45.cpu_load[2]
    161758 ± 25%    +224.3%     524588 ±  6%  sched_debug.cpu#7.avg_idle
         6 ± 45%    +345.8%         26 ± 48%  sched_debug.cpu#38.cpu_load[1]
         6 ± 19%    +207.4%         20 ±  5%  sched_debug.cpu#26.load
         6 ± 19%    +207.4%         20 ±  5%  sched_debug.cfs_rq[26]:/.load
         6 ± 41%    +211.5%         20 ±  6%  sched_debug.cfs_rq[31]:/.load
         6 ± 41%    +211.5%         20 ±  6%  sched_debug.cpu#31.load
         8 ± 38%    +181.2%         22 ± 19%  sched_debug.cpu#31.cpu_load[0]
      1261 ± 15%    +151.4%       3171 ± 48%  sched_debug.cpu#8.ttwu_local
         6 ± 47%    +264.0%         22 ±  7%  sched_debug.cpu#32.cpu_load[0]
         6 ± 47%    +264.0%         22 ±  6%  sched_debug.cfs_rq[32]:/.load
         6 ± 47%    +264.0%         22 ±  6%  sched_debug.cpu#32.load
         6 ± 47%    +264.0%         22 ±  7%  sched_debug.cfs_rq[32]:/.runnable_load_avg
    788292 ±  2%     -59.3%     321110 ± 23%  sched_debug.cpu#45.avg_idle
       318 ± 40%    +168.9%        857 ± 19%  sched_debug.cpu#25.ttwu_local
      1890 ± 18%    +140.5%       4547 ± 17%  sched_debug.cpu#16.ttwu_local
    252557 ± 15%    +129.2%     578898 ±  4%  sched_debug.cpu#0.avg_idle
     10.10 ±  3%    +139.5%      24.18 ± 13%  perf-profile.cpu-cycles.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.__do_page_cache_readahead.ondemand_readahead
     10.12 ±  3%    +139.0%      24.20 ± 13%  perf-profile.cpu-cycles.alloc_pages_current.__page_cache_alloc.__do_page_cache_readahead.ondemand_readahead.page_cache_async_readahead
     10.13 ±  3%    +138.8%      24.20 ± 13%  perf-profile.cpu-cycles.__page_cache_alloc.__do_page_cache_readahead.ondemand_readahead.page_cache_async_readahead.filemap_fault
      1.74 ±  0%     -58.1%       0.73 ± 12%  perf-profile.cpu-cycles.do_mpage_readpage.mpage_readpages.xfs_vm_readpages.__do_page_cache_readahead.ondemand_readahead
         7 ± 48%    +210.0%         23 ± 17%  sched_debug.cpu#33.cpu_load[1]
         8 ± 49%    +175.0%         22 ± 22%  sched_debug.cfs_rq[37]:/.runnable_load_avg
    217222 ± 18%    +163.9%     573282 ±  8%  sched_debug.cpu#2.avg_idle
       620 ± 33%    +148.3%       1541 ± 17%  sched_debug.cpu#25.curr->pid
        40 ± 11%     -54.7%         18 ±  5%  sched_debug.cfs_rq[12]:/.load
       365 ± 25%    +169.9%        986 ± 14%  sched_debug.cpu#45.ttwu_local
         6 ± 45%    +258.3%         21 ± 25%  sched_debug.cpu#37.cpu_load[4]
        44 ± 16%     -52.3%         21 ±  3%  sched_debug.cfs_rq[0]:/.load
         8 ± 40%    +168.8%         21 ± 21%  sched_debug.cpu#37.cpu_load[2]
      2265 ± 38%    +114.1%       4849 ± 19%  sched_debug.cpu#13.ttwu_local
        75 ± 30%    +125.8%        170 ± 35%  sched_debug.cfs_rq[17]:/.tg_load_contrib
      1502 ± 12%    +138.6%       3583 ±  7%  sched_debug.cpu#21.curr->pid
    148390 ±  1%    +166.2%     394977 ± 26%  meminfo.Active
       400 ± 14%    +118.5%        874 ±  1%  sched_debug.cfs_rq[17]:/.tg_runnable_contrib
     18355 ± 14%    +118.5%      40115 ±  1%  sched_debug.cfs_rq[17]:/.avg->runnable_avg_sum
         8 ± 49%    +151.4%         22 ± 20%  sched_debug.cpu#37.cpu_load[1]
         8 ± 49%    +154.3%         22 ± 22%  sched_debug.cpu#37.cpu_load[0]
      2190 ± 25%    +129.2%       5019 ± 19%  sched_debug.cpu#12.ttwu_local
     17021 ±  4%    +137.9%      40492 ±  2%  sched_debug.cfs_rq[23]:/.avg->runnable_avg_sum
       372 ±  4%    +137.4%        883 ±  2%  sched_debug.cfs_rq[23]:/.tg_runnable_contrib
      1854 ± 17%    +121.7%       4110 ±  9%  sched_debug.cpu#23.ttwu_local
      1647 ± 14%     +95.9%       3227 ± 21%  sched_debug.cpu#22.curr->pid
        40 ±  8%     -53.4%         19 ±  3%  sched_debug.cpu#12.load
     18508 ± 19%    +107.9%      38480 ±  8%  sched_debug.cfs_rq[22]:/.avg->runnable_avg_sum
       403 ± 19%    +108.3%        839 ±  8%  sched_debug.cfs_rq[22]:/.tg_runnable_contrib
     68362 ±  3%    +122.8%     152343 ±  0%  sched_debug.cpu#36.nr_load_updates
    837729 ±  5%     -58.3%     349382 ± 12%  sched_debug.cpu#36.avg_idle
     68719 ±  2%    +124.4%     154206 ±  0%  sched_debug.cpu#28.nr_load_updates
     68621 ±  2%    +120.3%     151189 ±  1%  sched_debug.cpu#37.nr_load_updates
     68547 ±  2%    +124.8%     154067 ±  0%  sched_debug.cpu#35.nr_load_updates
         7 ± 39%    +203.6%         21 ± 21%  sched_debug.cpu#37.cpu_load[3]
         7 ± 44%    +151.6%         19 ±  2%  sched_debug.cfs_rq[45]:/.runnable_load_avg
         8 ± 48%    +160.6%         21 ± 23%  sched_debug.cfs_rq[37]:/.load
      1693 ± 14%    +103.8%       3451 ±  3%  sched_debug.cpu#23.curr->pid
     68759 ±  2%    +121.3%     152166 ±  0%  sched_debug.cpu#45.nr_load_updates
    761149 ±  6%     -56.1%     333944 ± 23%  sched_debug.cpu#37.avg_idle
     69825 ±  3%    +110.9%     147248 ±  3%  sched_debug.cpu#47.nr_load_updates
     69531 ±  2%    +111.1%     146783 ±  3%  sched_debug.cpu#39.nr_load_updates
     70889 ±  2%    +117.5%     154171 ±  0%  sched_debug.cpu#32.nr_load_updates
     69385 ±  2%    +109.8%     145552 ±  7%  sched_debug.cpu#46.nr_load_updates
     68910 ±  1%    +118.6%     150646 ±  0%  sched_debug.cpu#42.nr_load_updates
     69228 ±  1%    +117.9%     150880 ±  1%  sched_debug.cpu#44.nr_load_updates
     69905 ±  2%    +120.5%     154159 ±  0%  sched_debug.cpu#31.nr_load_updates
     69919 ±  3%    +120.3%     154058 ±  0%  sched_debug.cpu#34.nr_load_updates
     69867 ±  2%    +120.0%     153690 ±  0%  sched_debug.cpu#33.nr_load_updates
       406 ±  3%    +117.5%        883 ±  4%  sched_debug.cfs_rq[20]:/.tg_runnable_contrib
     70681 ±  1%    +118.5%     154417 ±  0%  sched_debug.cpu#26.nr_load_updates
     70118 ±  2%    +119.8%     154112 ±  0%  sched_debug.cpu#24.nr_load_updates
     18638 ±  3%    +117.6%      40561 ±  4%  sched_debug.cfs_rq[20]:/.avg->runnable_avg_sum
     70009 ±  2%    +120.4%     154304 ±  0%  sched_debug.cpu#30.nr_load_updates
     70727 ±  3%    +117.8%     154075 ±  0%  sched_debug.cpu#27.nr_load_updates
     70583 ±  1%    +118.4%     154123 ±  0%  sched_debug.cpu#29.nr_load_updates
     71045 ±  1%    +113.0%     151331 ±  0%  sched_debug.cpu#38.nr_load_updates
      1658 ±  5%     +85.3%       3073 ± 14%  sched_debug.cpu#15.curr->pid
     20638 ±  9%    +111.4%      43619 ±  0%  sched_debug.cfs_rq[3]:/.avg->runnable_avg_sum
         7 ± 44%    +156.7%         19 ±  5%  sched_debug.cpu#45.cpu_load[1]
         7 ± 44%    +145.2%         19 ±  3%  sched_debug.cpu#45.cpu_load[0]
       450 ±  9%    +110.8%        950 ±  0%  sched_debug.cfs_rq[3]:/.tg_runnable_contrib
     70631 ±  2%    +112.2%     149899 ±  2%  sched_debug.cpu#40.nr_load_updates
     69640 ±  2%    +109.3%     145741 ±  3%  sched_debug.cpu#41.nr_load_updates
      1.79 ±  0%    +123.6%       4.00 ± 13%  perf-profile.cpu-cycles.physflat_send_IPI_mask.native_send_call_func_ipi.smp_call_function_many.native_flush_tlb_others.flush_tlb_page
        44 ± 12%     -52.0%         21 ±  5%  sched_debug.cpu#0.load
     18721 ±  7%     +99.1%      37280 ±  9%  sched_debug.cfs_rq[15]:/.avg->runnable_avg_sum
      1545 ± 10%    +117.9%       3367 ±  3%  sched_debug.cpu#20.curr->pid
     12.70 ±  2%    +100.7%      25.50 ± 12%  perf-profile.cpu-cycles.ondemand_readahead.page_cache_async_readahead.filemap_fault.__do_fault.do_read_fault
     12.70 ±  2%    +100.7%      25.50 ± 12%  perf-profile.cpu-cycles.__do_page_cache_readahead.ondemand_readahead.page_cache_async_readahead.filemap_fault.__do_fault
     12.71 ±  2%    +100.6%      25.50 ± 12%  perf-profile.cpu-cycles.page_cache_async_readahead.filemap_fault.__do_fault.do_read_fault.handle_mm_fault
       408 ±  7%     +98.7%        812 ±  9%  sched_debug.cfs_rq[15]:/.tg_runnable_contrib
   1676888 ±  1%    +110.2%    3524754 ±  8%  sched_debug.cfs_rq[25]:/.min_vruntime
     69275 ±  1%    +104.2%     141459 ±  5%  sched_debug.cpu#43.nr_load_updates
      2212 ± 32%     +84.7%       4087 ± 26%  sched_debug.cpu#18.ttwu_local
     18484 ± 14%    +115.8%      39898 ±  3%  sched_debug.cfs_rq[16]:/.avg->runnable_avg_sum
       404 ± 14%    +115.0%        868 ±  3%  sched_debug.cfs_rq[16]:/.tg_runnable_contrib
    779856 ±  5%     -47.0%     413230 ± 16%  sched_debug.cpu#42.avg_idle
    732398 ±  8%     -53.1%     343652 ±  9%  sched_debug.cpu#38.avg_idle
      2367 ± 34%     +56.9%       3714 ± 22%  sched_debug.cpu#22.ttwu_local
      1.91 ±  0%    +113.8%       4.08 ± 12%  perf-profile.cpu-cycles.native_send_call_func_ipi.smp_call_function_many.native_flush_tlb_others.flush_tlb_page.ptep_clear_flush
       464 ± 11%    +105.1%        952 ±  0%  sched_debug.cfs_rq[9]:/.tg_runnable_contrib
     21302 ± 11%    +105.2%      43704 ±  0%  sched_debug.cfs_rq[9]:/.avg->runnable_avg_sum
      1764 ±  5%     +95.7%       3453 ±  1%  sched_debug.cpu#3.curr->pid
    745315 ±  4%     -54.6%     338521 ± 23%  sched_debug.cpu#47.avg_idle
      3307 ± 44%     +82.2%       6027 ± 28%  sched_debug.cpu#15.ttwu_local
       474 ±  3%     +99.3%        945 ±  0%  sched_debug.cfs_rq[6]:/.tg_runnable_contrib
     21516 ±  9%    +102.2%      43513 ±  0%  sched_debug.cfs_rq[8]:/.avg->runnable_avg_sum
     21759 ±  3%     +99.2%      43352 ±  0%  sched_debug.cfs_rq[6]:/.avg->runnable_avg_sum
       468 ±  9%    +102.1%        947 ±  0%  sched_debug.cfs_rq[8]:/.tg_runnable_contrib
      3.82 ±  0%     -46.4%       2.04 ± 16%  perf-profile.cpu-cycles.generic_smp_call_function_single_interrupt.smp_call_function_interrupt.call_function_interrupt.do_unit
       412 ±  6%     +93.7%        798 ± 12%  sched_debug.cfs_rq[19]:/.tg_runnable_contrib
     18883 ±  6%     +94.0%      36628 ± 11%  sched_debug.cfs_rq[19]:/.avg->runnable_avg_sum
      2041 ± 13%    +100.6%       4094 ± 21%  sched_debug.cpu#20.ttwu_local
     21938 ±  4%     +98.8%      43612 ±  0%  sched_debug.cfs_rq[5]:/.avg->runnable_avg_sum
       478 ±  4%     +98.7%        950 ±  0%  sched_debug.cfs_rq[5]:/.tg_runnable_contrib
       438 ±  9%    +100.1%        878 ±  1%  sched_debug.cfs_rq[21]:/.tg_runnable_contrib
     20117 ±  8%    +100.3%      40292 ±  1%  sched_debug.cfs_rq[21]:/.avg->runnable_avg_sum
      1760 ±  6%     +95.8%       3446 ±  1%  sched_debug.cpu#6.curr->pid
     20035 ± 17%    +117.8%      43642 ±  0%  sched_debug.cfs_rq[4]:/.avg->runnable_avg_sum
     75092 ±  3%     +88.8%     141756 ±  2%  sched_debug.cfs_rq[16]:/.exec_clock
      2.46 ±  0%     -49.3%       1.25 ±  9%  perf-profile.cpu-cycles.mpage_readpages.xfs_vm_readpages.__do_page_cache_readahead.ondemand_readahead.page_cache_async_readahead
     74589 ±  1%     +90.9%     142362 ±  1%  sched_debug.cfs_rq[23]:/.exec_clock
      1922 ± 12%     +89.3%       3638 ±  3%  sched_debug.cpu#8.curr->pid
       436 ± 17%    +117.6%        950 ±  0%  sched_debug.cfs_rq[4]:/.tg_runnable_contrib
     73560 ±  3%     +90.5%     140133 ±  2%  sched_debug.cfs_rq[20]:/.exec_clock
       446 ±  8%     +96.4%        875 ±  3%  sched_debug.cfs_rq[18]:/.tg_runnable_contrib
      1737 ± 13%    +100.0%       3473 ±  0%  sched_debug.cpu#4.curr->pid
     22692 ±  3%     +92.1%      43592 ±  0%  sched_debug.cfs_rq[7]:/.avg->runnable_avg_sum
     20408 ±  8%     +96.8%      40160 ±  3%  sched_debug.cfs_rq[18]:/.avg->runnable_avg_sum
      2.47 ±  0%     -49.2%       1.25 ±  8%  perf-profile.cpu-cycles.xfs_vm_readpages.__do_page_cache_readahead.ondemand_readahead.page_cache_async_readahead.filemap_fault
      1.77 ±  0%    +103.7%       3.62 ± 12%  perf-profile.cpu-cycles.default_send_IPI_mask_sequence_phys.physflat_send_IPI_mask.native_send_call_func_ipi.smp_call_function_many.native_flush_tlb_others
       496 ±  3%     +91.5%        950 ±  0%  sched_debug.cfs_rq[7]:/.tg_runnable_contrib
      1857 ± 14%     +84.7%       3431 ±  7%  sched_debug.cpu#14.curr->pid
     69586 ±  1%     +90.6%     132645 ±  2%  sched_debug.cpu#25.nr_load_updates
      1795 ± 10%     +93.8%       3480 ±  6%  sched_debug.cpu#16.curr->pid
      1676 ± 10%     +70.4%       2856 ± 25%  sched_debug.cpu#19.curr->pid
     79742 ±  2%     +88.0%     149936 ±  0%  sched_debug.cfs_rq[9]:/.exec_clock
     80832 ±  1%     +86.1%     150448 ±  0%  sched_debug.cfs_rq[10]:/.exec_clock
      3.27 ±  0%     -44.1%       1.83 ± 16%  perf-profile.cpu-cycles.flush_smp_call_function_queue.generic_smp_call_function_single_interrupt.smp_call_function_interrupt.call_function_interrupt.do_unit
     76161 ±  2%     +86.3%     141887 ±  2%  sched_debug.cfs_rq[21]:/.exec_clock
      4.24 ±  0%     -43.9%       2.38 ± 16%  perf-profile.cpu-cycles.smp_call_function_interrupt.call_function_interrupt.do_unit
     78456 ±  3%     +80.5%     141631 ±  1%  sched_debug.cfs_rq[14]:/.exec_clock
     76808 ±  1%     +83.1%     140617 ±  1%  sched_debug.cfs_rq[18]:/.exec_clock
     79415 ±  2%     +89.1%     150169 ±  0%  sched_debug.cfs_rq[8]:/.exec_clock
     75965 ±  4%     +75.1%     132983 ± 10%  sched_debug.cfs_rq[22]:/.exec_clock
     81273 ±  1%     +85.4%     150714 ±  0%  sched_debug.cfs_rq[4]:/.exec_clock
     80964 ±  2%     +85.6%     150255 ±  0%  sched_debug.cfs_rq[6]:/.exec_clock
     74779 ±  1%     +81.3%     135601 ±  4%  sched_debug.cfs_rq[17]:/.exec_clock
     14155 ± 10%     +81.2%      25650 ±  4%  proc-vmstat.numa_hint_faults_local
        31 ± 10%     -43.7%         17 ±  4%  sched_debug.cpu#12.cpu_load[2]
        31 ± 11%     -45.2%         17 ±  4%  sched_debug.cpu#12.cpu_load[3]
     81823 ±  0%     +83.9%     150451 ±  0%  sched_debug.cfs_rq[5]:/.exec_clock
     80901 ±  1%     +86.1%     150580 ±  0%  sched_debug.cfs_rq[3]:/.exec_clock
     24085 ±  4%     +81.0%      43593 ±  0%  sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum
     82971 ±  2%     +82.0%     150991 ±  0%  sched_debug.cfs_rq[2]:/.exec_clock
        45 ± 40%     -51.7%         21 ±  3%  sched_debug.cfs_rq[6]:/.load
     82487 ±  3%     +82.4%     150434 ±  0%  sched_debug.cfs_rq[11]:/.exec_clock
     82063 ±  1%     +83.3%     150460 ±  0%  sched_debug.cfs_rq[7]:/.exec_clock
       526 ±  4%     +80.3%        948 ±  0%  sched_debug.cfs_rq[0]:/.tg_runnable_contrib
     23134 ±  6%     +88.6%      43640 ±  0%  sched_debug.cfs_rq[11]:/.avg->runnable_avg_sum
      1723 ± 19%    +102.6%       3491 ±  1%  sched_debug.cpu#9.curr->pid
       505 ±  6%     +88.2%        951 ±  0%  sched_debug.cfs_rq[11]:/.tg_runnable_contrib
        31 ± 14%     -45.7%         17 ±  4%  sched_debug.cpu#12.cpu_load[4]
        41 ± 27%     -45.5%         22 ±  8%  sched_debug.cpu#5.load
     78675 ±  1%     +62.2%     127602 ± 11%  sched_debug.cfs_rq[15]:/.exec_clock
      1893 ± 14%     +83.2%       3469 ±  2%  sched_debug.cpu#5.curr->pid
    781765 ±  4%     -50.5%     387205 ± 25%  sched_debug.cpu#44.avg_idle
     24615 ±  5%     +77.2%      43616 ±  0%  sched_debug.cfs_rq[10]:/.avg->runnable_avg_sum
      1680 ± 16%     +91.0%       3209 ±  7%  sched_debug.cpu#17.curr->pid
       535 ±  5%     +77.2%        949 ±  0%  sched_debug.cfs_rq[10]:/.tg_runnable_contrib
      2058 ±  6%     +81.2%       3728 ± 12%  sched_debug.cpu#13.curr->pid
    778833 ± 10%     -44.6%     431847 ± 12%  sched_debug.cpu#46.avg_idle
     16875 ± 14%     +62.8%      27480 ±  4%  proc-vmstat.numa_hint_faults
    754350 ±  6%     -36.0%     482553 ± 11%  sched_debug.cpu#31.avg_idle
        30 ±  9%     -40.7%         18 ±  4%  sched_debug.cpu#12.cpu_load[1]
    755856 ±  5%     -48.3%     390625 ± 28%  sched_debug.cpu#39.avg_idle
     81073 ±  3%     +73.4%     140569 ±  1%  sched_debug.cfs_rq[13]:/.exec_clock
     77245 ±  2%     +66.8%     128866 ±  8%  sched_debug.cfs_rq[19]:/.exec_clock
    751381 ±  7%     -42.3%     433890 ± 14%  sched_debug.cpu#40.avg_idle
   2993815 ±  3%    +103.2%    6083494 ± 36%  numa-vmstat.node0.numa_foreign
   2994243 ±  3%    +103.2%    6083807 ± 36%  numa-vmstat.node1.numa_miss
        28 ±  9%     -36.5%         18 ±  5%  sched_debug.cfs_rq[12]:/.runnable_load_avg
   3009812 ±  3%    +102.6%    6097503 ± 36%  numa-vmstat.node1.numa_other
      1959 ± 15%     +78.1%       3490 ±  4%  sched_debug.cpu#7.curr->pid
     20347 ± 16%     +71.9%      34978 ±  2%  sched_debug.cfs_rq[1]:/.avg->runnable_avg_sum
       443 ± 16%     +72.2%        762 ±  2%  sched_debug.cfs_rq[1]:/.tg_runnable_contrib
       485 ±  5%     +72.8%        838 ±  4%  sched_debug.cfs_rq[13]:/.tg_runnable_contrib
      1988 ± 11%     +75.2%       3484 ±  0%  sched_debug.cpu#2.curr->pid
     22268 ±  5%     +72.7%      38457 ±  4%  sched_debug.cfs_rq[13]:/.avg->runnable_avg_sum
      2031 ±  8%     +76.3%       3579 ±  1%  sched_debug.cpu#18.curr->pid
        30 ±  8%     -38.0%         18 ±  4%  sched_debug.cpu#12.cpu_load[0]
        42 ± 32%     -48.2%         21 ±  3%  sched_debug.cpu#6.load
        37 ± 19%     -40.5%         22 ±  3%  sched_debug.cfs_rq[2]:/.load
      6.74 ±  0%     -37.3%       4.22 ± 16%  perf-profile.cpu-cycles.call_function_interrupt.do_unit.runtime_exceeded
   6669287 ±  3%     +79.8%   11990538 ± 20%  numa-numastat.node0.numa_foreign
   6669289 ±  3%     +79.8%   11990544 ± 20%  numa-numastat.node1.numa_miss
   6669577 ±  3%     +79.7%   11987745 ± 20%  numa-numastat.node1.other_node
     93969 ±  1%     +66.4%     156357 ±  0%  sched_debug.cfs_rq[0]:/.exec_clock
     25064 ±  6%     +74.1%      43635 ±  0%  sched_debug.cfs_rq[2]:/.avg->runnable_avg_sum
       547 ±  6%     +73.8%        950 ±  0%  sched_debug.cfs_rq[2]:/.tg_runnable_contrib
        32 ± 14%     -31.8%         22 ±  3%  sched_debug.cpu#2.cpu_load[4]
      2007 ± 11%     +78.1%       3575 ±  5%  sched_debug.cpu#12.curr->pid
     87646 ±  3%     +57.4%     137997 ±  4%  sched_debug.cfs_rq[12]:/.exec_clock
        31 ±  9%     -30.7%         22 ± 13%  sched_debug.cpu#0.cpu_load[1]
        34 ± 19%     -38.7%         21 ±  3%  sched_debug.cpu#0.cpu_load[3]
        33 ± 13%     -34.8%         21 ±  6%  sched_debug.cpu#0.cpu_load[2]
     21815 ± 16%     +83.5%      40027 ±  5%  sched_debug.cfs_rq[14]:/.avg->runnable_avg_sum
      2106 ± 22%     +65.4%       3484 ±  0%  sched_debug.cpu#11.curr->pid
     15847 ±  5%     +64.6%      26082 ±  2%  proc-vmstat.numa_pte_updates
       476 ± 16%     +83.0%        871 ±  4%  sched_debug.cfs_rq[14]:/.tg_runnable_contrib
        31 ± 13%     -29.8%         21 ±  5%  sched_debug.cpu#2.cpu_load[2]
        31 ± 13%     -30.2%         22 ±  3%  sched_debug.cpu#2.cpu_load[3]
    799827 ±  7%     -38.0%     496159 ±  6%  sched_debug.cpu#41.avg_idle
     25015 ±  9%     +55.2%      38832 ±  4%  sched_debug.cfs_rq[12]:/.avg->runnable_avg_sum
       545 ±  9%     +54.9%        845 ±  5%  sched_debug.cfs_rq[12]:/.tg_runnable_contrib
        31 ± 13%     -29.8%         21 ±  3%  sched_debug.cpu#4.load
        31 ±  9%     -24.2%         23 ± 21%  sched_debug.cpu#0.cpu_load[0]
        30 ± 12%     -28.5%         22 ±  3%  sched_debug.cpu#2.cpu_load[1]
        34 ± 20%     -38.0%         21 ±  2%  sched_debug.cpu#0.cpu_load[4]
        33 ± 12%     -32.8%         22 ±  4%  sched_debug.cpu#10.cpu_load[3]
        38 ± 40%     -40.0%         23 ±  7%  sched_debug.cfs_rq[3]:/.load
        33 ± 12%     -34.8%         22 ±  4%  sched_debug.cpu#10.cpu_load[4]
      5.44 ±  0%     +60.3%       8.71 ± 10%  perf-profile.cpu-cycles.native_flush_tlb_others.flush_tlb_page.ptep_clear_flush.try_to_unmap_one.rmap_walk
    768520 ±  2%     -32.7%     517068 ± 19%  sched_debug.cpu#43.avg_idle
      2161 ± 12%     +62.3%       3507 ±  1%  sched_debug.cpu#0.curr->pid
   2209313 ±  1%     +50.6%    3327328 ±  7%  sched_debug.cfs_rq[1]:/.min_vruntime
      2088 ± 16%     +68.7%       3524 ±  1%  sched_debug.cpu#10.curr->pid
     85481 ±  0%     +47.4%     126019 ±  4%  sched_debug.cfs_rq[1]:/.exec_clock
      5.56 ±  0%     +57.7%       8.77 ± 10%  perf-profile.cpu-cycles.flush_tlb_page.ptep_clear_flush.try_to_unmap_one.rmap_walk.try_to_unmap
      5.39 ±  0%     +58.0%       8.52 ± 10%  perf-profile.cpu-cycles.smp_call_function_many.native_flush_tlb_others.flush_tlb_page.ptep_clear_flush.try_to_unmap_one
      5.59 ±  0%     +57.1%       8.79 ± 10%  perf-profile.cpu-cycles.ptep_clear_flush.try_to_unmap_one.rmap_walk.try_to_unmap.shrink_page_list
        39 ± 39%     -41.1%         23 ±  7%  sched_debug.cpu#3.load
        33 ± 10%     -31.8%         22 ±  4%  sched_debug.cpu#10.cpu_load[2]
  17183605 ±  0%     +47.0%   25256577 ±  3%  numa-numastat.node0.numa_hit
  17179579 ±  0%     +47.0%   25252790 ±  3%  numa-numastat.node0.local_node
      1.33 ±  1%     +52.5%       2.02 ±  7%  perf-profile.cpu-cycles.llist_add_batch.smp_call_function_many.native_flush_tlb_others.flush_tlb_page.ptep_clear_flush
    751528 ±  3%     -31.6%     513885 ±  7%  sched_debug.cpu#29.avg_idle
        32 ± 12%     -32.6%         21 ±  3%  sched_debug.cfs_rq[4]:/.load
        30 ±  8%     -28.7%         21 ±  3%  sched_debug.cpu#2.cpu_load[0]
    511740 ±  0%     +42.7%     730218 ±  1%  meminfo.Committed_AS
        30 ±  9%     -27.6%         22 ±  5%  sched_debug.cfs_rq[10]:/.runnable_load_avg
        31 ±  9%     -29.1%         22 ±  6%  sched_debug.cpu#10.cpu_load[1]
      1160 ± 10%     +43.7%       1667 ± 20%  sched_debug.cpu#9.ttwu_local
    666835 ± 10%     -25.0%     500027 ± 10%  sched_debug.cpu#24.avg_idle
    112589 ±  1%     +38.6%     156027 ±  0%  sched_debug.cpu#0.nr_load_updates
    736481 ±  9%     -26.2%     543278 ±  9%  sched_debug.cpu#33.avg_idle
       105 ±  8%     -37.4%         66 ± 19%  sched_debug.cfs_rq[5]:/.tg_load_contrib
  11461506 ±  0%     +33.2%   15264391 ±  5%  numa-vmstat.node0.numa_local
  11521591 ±  0%     +33.0%   15324492 ±  5%  numa-vmstat.node0.numa_hit
    730554 ±  5%     -29.0%     518492 ±  6%  sched_debug.cpu#28.avg_idle
    710604 ± 10%     -23.4%     543997 ±  7%  sched_debug.cpu#32.avg_idle
        31 ±  8%     -25.8%         23 ±  8%  sched_debug.cpu#10.cpu_load[0]
      5262 ±  8%     +24.3%       6539 ± 12%  numa-vmstat.node0.nr_active_anon
    725624 ±  5%     -26.4%     534319 ± 10%  sched_debug.cpu#30.avg_idle
       475 ±  1%     -25.0%        357 ±  2%  numa-vmstat.node1.nr_isolated_file
    118072 ±  0%     +32.0%     155832 ±  0%  sched_debug.cpu#2.nr_load_updates
    112552 ±  1%     +31.4%     147843 ±  0%  sched_debug.cpu#23.nr_load_updates
    715220 ±  9%     -23.7%     545873 ±  3%  sched_debug.cpu#27.avg_idle
  29397725 ±  0%     +31.4%   38636906 ±  2%  proc-vmstat.pgsteal_direct_normal
    114141 ±  1%     +29.1%     147312 ±  1%  sched_debug.cpu#16.nr_load_updates
    118519 ±  1%     +30.1%     154152 ±  0%  sched_debug.cpu#9.nr_load_updates
    708259 ±  2%     -23.0%     545446 ±  4%  sched_debug.cpu#26.avg_idle
    118513 ±  0%     +30.7%     154849 ±  0%  sched_debug.cpu#3.nr_load_updates
   1343336 ±  0%     +30.3%    1749718 ±  2%  proc-vmstat.pgsteal_direct_dma32
    112745 ±  1%     +29.6%     146100 ±  1%  sched_debug.cpu#20.nr_load_updates
    113863 ±  1%     +29.3%     147271 ±  1%  sched_debug.cpu#21.nr_load_updates
    118674 ±  0%     +30.4%     154737 ±  0%  sched_debug.cpu#10.nr_load_updates
    118912 ±  0%     +30.1%     154712 ±  0%  sched_debug.cpu#7.nr_load_updates
      8324 ±  0%     +30.0%      10817 ±  2%  proc-vmstat.allocstall
    113529 ±  2%     +23.5%     140212 ±  8%  sched_debug.cpu#22.nr_load_updates
    119777 ±  1%     +29.1%     154678 ±  0%  sched_debug.cpu#11.nr_load_updates
    119420 ±  0%     +29.5%     154631 ±  0%  sched_debug.cpu#5.nr_load_updates
    115387 ±  1%     +27.4%     146972 ±  1%  sched_debug.cpu#14.nr_load_updates
    118945 ±  0%     +30.1%     154739 ±  0%  sched_debug.cpu#6.nr_load_updates
      0.92 ±  0%     +32.5%       1.21 ±  6%  perf-profile.cpu-cycles.llist_reverse_order.flush_smp_call_function_queue.generic_smp_call_function_single_interrupt.smp_call_function_interrupt.call_function_interrupt
    118543 ±  0%     +30.6%     154779 ±  0%  sched_debug.cpu#8.nr_load_updates
        27 ±  9%     -24.5%         20 ±  3%  sched_debug.cfs_rq[0]:/.runnable_load_avg
    119654 ±  0%     +29.6%     155021 ±  0%  sched_debug.cpu#4.nr_load_updates
    114818 ±  0%     +27.6%     146531 ±  1%  sched_debug.cpu#18.nr_load_updates
   3374967 ±  4%     -17.5%    2783882 ±  9%  numa-vmstat.node1.numa_foreign
   3374519 ±  4%     -17.5%    2783688 ±  9%  numa-vmstat.node0.numa_miss
  35249529 ±  0%     +26.2%   44474806 ±  6%  proc-vmstat.numa_local
  35253840 ±  0%     +26.2%   44475794 ±  6%  proc-vmstat.numa_hit
    113894 ±  1%     +25.0%     142393 ±  3%  sched_debug.cpu#17.nr_load_updates
   3434605 ±  4%     -17.2%    2843790 ±  8%  numa-vmstat.node0.numa_other
  47137444 ±  0%     +27.0%   59863418 ±  2%  proc-vmstat.pgalloc_normal
  49289036 ±  0%     +26.9%   62530835 ±  2%  proc-vmstat.pgfree
   2166230 ±  0%     +27.1%    2754154 ±  1%  proc-vmstat.pgalloc_dma32
    116049 ±  0%     +17.1%     135915 ±  8%  sched_debug.cpu#15.nr_load_updates
      1.40 ±  1%     +30.8%       1.83 ±  7%  perf-profile.cpu-cycles.flush_tlb_func.flush_smp_call_function_queue.generic_smp_call_function_single_interrupt.smp_call_function_interrupt.call_function_interrupt
   7258791 ±  2%     -17.3%    6002381 ±  5%  numa-numastat.node0.other_node
   7254765 ±  2%     -17.3%    5998595 ±  5%  numa-numastat.node0.numa_miss
   7254765 ±  2%     -17.3%    5998593 ±  5%  numa-numastat.node1.numa_foreign
        12 ± 45%     +64.6%         19 ±  4%  sched_debug.cpu#45.load
        12 ± 45%     +62.5%         19 ±  2%  sched_debug.cfs_rq[45]:/.load
    117121 ±  1%     +24.7%     146078 ±  1%  sched_debug.cpu#13.nr_load_updates
    120017 ±  1%     +19.8%     143779 ±  3%  sched_debug.cpu#12.nr_load_updates
    108877 ±  1%     +20.9%     131646 ±  3%  numa-meminfo.node0.PageTables
    114515 ±  1%     +19.6%     136960 ±  6%  sched_debug.cpu#19.nr_load_updates
        26 ± 10%     -17.0%         22 ±  3%  sched_debug.cpu#5.cpu_load[4]
        26 ±  7%     -18.1%         21 ±  2%  sched_debug.cpu#6.cpu_load[4]
        25 ±  7%     -13.9%         21 ±  3%  sched_debug.cpu#6.cpu_load[0]
       873 ±  2%     -20.0%        698 ±  3%  proc-vmstat.nr_isolated_file
        40 ± 10%     -30.4%         28 ± 16%  sched_debug.cpu#8.load
     27111 ±  0%     +21.6%      32968 ±  3%  numa-vmstat.node0.nr_page_table_pages
    461214 ±  0%     +19.1%     549395 ±  3%  slabinfo.radix_tree_node.active_objs
    461392 ±  0%     +19.1%     549569 ±  3%  slabinfo.radix_tree_node.num_objs
      8238 ±  0%     +19.1%       9813 ±  3%  slabinfo.radix_tree_node.active_slabs
      8238 ±  0%     +19.1%       9813 ±  3%  slabinfo.radix_tree_node.num_slabs
    222174 ±  0%     +19.3%     264946 ±  3%  meminfo.PageTables
  13924052 ±  1%     +29.2%   17989098 ± 12%  proc-vmstat.numa_foreign
  13924054 ±  1%     +29.2%   17989094 ± 12%  proc-vmstat.numa_miss
  13928365 ±  1%     +29.2%   17990081 ± 12%  proc-vmstat.numa_other
    707663 ±  5%     -18.7%     575122 ±  9%  sched_debug.cpu#34.avg_idle
     55729 ±  0%     +18.9%      66260 ±  3%  proc-vmstat.nr_page_table_pages
    148406 ±  1%     +16.2%     172374 ±  3%  numa-meminfo.node0.SReclaimable
        25 ±  4%     -14.7%         21 ±  3%  sched_debug.cpu#6.cpu_load[1]
        27 ± 13%     -20.7%         22 ±  3%  sched_debug.cpu#5.cpu_load[3]
        26 ±  2%     -15.4%         22 ±  3%  sched_debug.cpu#6.cpu_load[3]
        25 ±  3%     -14.6%         22 ±  3%  sched_debug.cpu#6.cpu_load[2]
     36962 ±  1%     +16.6%      43112 ±  3%  numa-vmstat.node0.nr_slab_reclaimable
    297997 ±  0%     +17.2%     349194 ±  2%  meminfo.SReclaimable
     74632 ±  0%     +17.0%      87301 ±  2%  proc-vmstat.nr_slab_reclaimable
     37510 ±  1%     +17.6%      44106 ±  3%  numa-vmstat.node1.nr_slab_reclaimable
    114501 ±  1%     +15.6%     132390 ±  3%  numa-meminfo.node1.PageTables
       386 ±  3%     -14.6%        330 ±  3%  numa-vmstat.node0.nr_isolated_file
  16655255 ±  9%     +15.8%   19284310 ±  4%  proc-vmstat.pgfault
    150600 ±  1%     +17.1%     176358 ±  2%  numa-meminfo.node1.SReclaimable
        23 ±  2%      -8.5%         21 ±  4%  sched_debug.cfs_rq[6]:/.runnable_load_avg
     28515 ±  1%     +16.3%      33150 ±  2%  numa-vmstat.node1.nr_page_table_pages
    385903 ±  0%     +13.5%     438016 ±  2%  meminfo.Slab
      1596 ±  3%     -12.7%       1393 ±  3%  numa-vmstat.node0.nr_alloc_batch
    192730 ±  1%     +14.2%     220027 ±  1%  numa-meminfo.node1.Slab
    381928 ±  4%     +15.6%     441483 ±  1%  softirqs.RCU
    117674 ±  0%     +11.4%     131032 ±  3%  sched_debug.cpu#1.nr_load_updates
        28 ± 19%     -21.9%         22 ±  3%  sched_debug.cpu#5.cpu_load[2]
      7157 ±  4%     +15.4%       8261 ±  2%  sched_debug.cfs_rq[0]:/.tg_load_avg
    194173 ±  1%     +12.0%     217520 ±  3%  numa-meminfo.node0.Slab
   3342651 ±  0%     -14.2%    2869010 ±  8%  proc-vmstat.pgscan_direct_dma32
    306106 ±  6%     -15.0%     260093 ±  3%  softirqs.SCHED
      7186 ±  4%     +15.2%       8281 ±  2%  sched_debug.cfs_rq[1]:/.tg_load_avg
      7208 ±  4%     +14.6%       8263 ±  2%  sched_debug.cfs_rq[2]:/.tg_load_avg
      7172 ±  5%     +15.0%       8246 ±  1%  sched_debug.cfs_rq[3]:/.tg_load_avg
      7190 ±  5%     +14.0%       8200 ±  2%  sched_debug.cfs_rq[4]:/.tg_load_avg
      7212 ±  5%     +13.1%       8159 ±  3%  sched_debug.cfs_rq[5]:/.tg_load_avg
      8673 ±  9%     +20.1%      10417 ±  0%  numa-vmstat.node1.nr_inactive_anon
      7193 ±  4%     +12.3%       8079 ±  3%  sched_debug.cfs_rq[9]:/.tg_load_avg
      7248 ±  5%     +12.6%       8162 ±  3%  sched_debug.cfs_rq[6]:/.tg_load_avg
     34632 ±  9%     +19.6%      41415 ±  0%  numa-meminfo.node1.Inactive(anon)
       710 ±  6%    +804.1%       6421 ±  1%  time.system_time
   1044202 ±  0%    +450.5%    5748331 ±  2%  vmstat.system.in
     43925 ±  5%    +388.2%     214457 ±  1%  time.involuntary_context_switches
     30.82 ±  0%    +198.7%      92.05 ±  0%  turbostat.%c0
      1437 ±  0%    +193.4%       4218 ±  0%  time.percent_of_cpu_this_job_got
     10941 ±  3%    +200.2%      32847 ± 10%  time.major_page_faults
      3717 ±  0%     +78.2%       6623 ±  1%  time.user_time
       125 ±  0%     +31.9%        165 ±  0%  turbostat.Cor_W
       159 ±  0%     +25.7%        199 ±  0%  turbostat.Pkg_W
     14.30 ±  0%     +19.6%      17.10 ±  0%  turbostat.RAM_W

ivb43: Ivytown Ivy Bridge-EP
Memory: 64G




                                  time.system_time

  18000 O+--------------------O---O---------------------O-------------------+
        | O O OO O O O O OO O   O   OO O O O O OO O O O   OO                |
  16000 ++                                                                  |
  14000 ++   .**.*.                                .*.   .*                 |
        *.*.*      *.*.*.**.*.*.*.*.**.*.*.*.*.**.*   *.*  *.*.*.*.*.*      |
  12000 ++                                                           :      |
  10000 ++                                                           :      |
        |                                                            :      |
   8000 ++                                                           :      |
   6000 ++                                                            :     |
        |                                                             :     |
   4000 ++                                                            :     |
   2000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                         time.percent_of_cpu_this_job_got

  5500 ++-------------------------------------------------------------------+
  5000 O+O O OO O O O O O O OO O O O O O OO O O O O O OO O O                |
       |                                                                    |
  4500 ++                                                                   |
  4000 *+*.*.**.*.*.*.*.*.*.**.*.*.*.*.*.**.*.*.*.*.*.**.*.*.*.*.*.*.*      |
  3500 ++                                                            :      |
  3000 ++                                                            :      |
       |                                                             :      |
  2500 ++                                                            :      |
  2000 ++                                                             :     |
  1500 ++                                                             :     |
  1000 ++                                                             :     |
       |                                                              :     |
   500 ++                                                             *.*.*.*
     0 ++-------------------------------------------------------------------+


                               time.major_page_faults

  1e+07 ++------------------------------------------------------------------+
        |                                                                   |
  9e+06 O+                    O   O    O O        O     O                   |
  8e+06 ++O O OO O O O O OO O   O   OO     O O OO   O O   OO                |
        |                                                                   |
  7e+06 ++                                                                  |
        |                                                                   |
  6e+06 ++                                                                  |
        |                                                                   |
  5e+06 ++                                                                  |
  4e+06 ++                                                                  |
        |                                                             *.*.*.*
  3e+06 *+*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
        |                                                                   |
  2e+06 ++------------------------------------------------------------------+


                                time.minor_page_faults

    2e+07 O+----------------------------------------------------------------+
          |      O   O         O   O    O O        O    O                   |
  1.8e+07 ++O  O   O  O O   O O  O   O O      O  O   O O  O O               |
  1.6e+07 ++  O           O                 O  O                            |
          |                                                                 |
  1.4e+07 ++                                                                |
          |                                                                 |
  1.2e+07 ++                                                                |
          |                                                                 |
    1e+07 ++                                                                |
    8e+06 ++                                                                |
          |                                                                 |
    6e+06 ++                                                           **.*.*
          |                                                           +     |
    4e+06 *+*-**-*-*-**-*-*-*-**-*-*-*-**-*-*-**-*-*-*-**-*-*-*-**-*-*------+


                           time.voluntary_context_switches

  7e+07 ++------------------------------------------------------------*---*-+
        |                                                             : *   *
  6e+07 ++                                                            :     |
        |                                                             :     |
  5e+07 ++                                                            :     |
        |                                                             :     |
  4e+07 ++                                                           :      |
        |                                                            :      |
  3e+07 ++                                                           :      |
        |      *.                  .*                                :      |
  2e+07 *+*.*.*  *.*.*.*.**.*.*.*.*  *.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
        |                                                                   |
  1e+07 ++                                                                  |
        |                                                                   |
      0 O+O-O-OO-O-O-O-O-OO-O-O-O-O-OO-O-O-O-O-OO-O-O-O-O-OO----------------+


                          time.involuntary_context_switches

  500000 ++-----------------------------------------------------------------+
         O                                                                  |
  450000 ++     O   O OO     O O OO O O O O  O   O OO   O O O               |
  400000 ++O OO   O      O O               O   O      O                     |
         |                                                                  |
  350000 ++                                                                 |
  300000 ++                                                                 |
         |                                                                  |
  250000 ++                                                                 |
  200000 *+*.**.*.*.*.**.*.*.*.*.**.*.*.*.**.*.*.*.**.*.*.*.*.**.*.*.*      |
         |                                                            :     |
  150000 ++                                                           :     |
  100000 ++                                                            :    |
         |                                                             **.*.*
   50000 ++-----------------------------------------------------------------+


                                   softirqs.SCHED

  350000 ++-----------------------------------------------------------------+
         |                                                             * .*.|
         |                                                            : *   *
  300000 ++    .*.                                                    :     |
         *.*.**   *.*.**. .*.*.*.*   .*.*.**.*.*.*.**.*.*.*.*.**.*.*.*      |
         |               *        *.*                                       |
  250000 ++                                                                 |
         |                                                                  |
  200000 ++                                                                 |
         |                                                                  |
         |                                                                  |
  150000 ++         O                                                       |
         |                   O O OO     O               O                   |
         O O OO O O   OO O O        O O   OO O O O OO O   O O               |
  100000 ++-----------------------------------------------------------------+


                                     uptime.idle

  25000 ++------------------------------------------------------------------+
        |                                                             *.*.*.*
        |                                                             :     |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  15000 ++                                                            :     |
        |                                                            :      |
  10000 ++                                                           :      |
        |                                                            :      |
        |      *.                                                    :      |
   5000 *+*.*.*  *.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
        |                                                                   |
        O O O OO O O O O OO O O O O OO O O O O OO O O O O OO                |
      0 ++------------------------------------------------------------------+


                                   turbostat.%c0

  100 O+--O------------O------------------O---O-----------------------------+
   90 ++O   O OO O O O   O O O OO O O O O   O   O OO O O O O                |
      |                                                                     |
   80 *+*.*.*.**.*.*.*.*.*.*.*.**.*.*.*.*.*.*.*.*.**.*.*.*.*.*.*.*.**       |
   70 ++                                                            :       |
      |                                                             :       |
   60 ++                                                             :      |
   50 ++                                                             :      |
   40 ++                                                             :      |
      |                                                              :      |
   30 ++                                                             :      |
   20 ++                                                              :     |
      |                                                               :     |
   10 ++                                                              *.*.*.*
    0 ++--------------------------------------------------------------------+


                                  turbostat.%c1

  90 ++---------------------------------------------------------------------+
     |                                                                *.    |
  80 ++                                                               : *.*.*
  70 ++                                                               :     |
     |                                                               :      |
  60 ++                                                              :      |
  50 ++                                                              :      |
     |                                                               :      |
  40 ++                                                              :      |
  30 ++                                                             :       |
     |                                                              :       |
  20 *+*.*.*.*.*.**.*.*.*.*.*.*.*.*.*.*.**.*.*.*.*.*.*.*.*.*.*.**.*.*       |
  10 ++                                                                     |
     |                                O                                     |
   0 O+O-O-O-O-O-OO-O-O-O-O-O-O-O-O-O---OO-O-O-O-O-O-O-O-O-O----------------+


                            numa-numastat.node0.numa_hit

  7e+07 O+--------------------O---O---------------------O-------------------+
        |      O     O O    O   O   OO O O   O  O O O     OO                |
  6e+07 ++O O O  O O     OO                O   O      O                     |
        |                                                                   |
        |                                                                   |
  5e+07 ++                                                                  |
        |                                                                   |
  4e+07 ++                                                                  |
        |                                                                   |
  3e+07 ++                                                                  |
        |                                                                   |
        |                                                                   |
  2e+07 ++                                                            *.*.*.*
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  1e+07 ++------------------------------------------------------------------+


                           numa-numastat.node0.local_node

  7e+07 O+--------------------O---O---------------------O-------------------+
        |      O     O O    O   O   OO O O   O  O O O     OO                |
  6e+07 ++O O O  O O     OO                O   O      O                     |
        |                                                                   |
        |                                                                   |
  5e+07 ++                                                                  |
        |                                                                   |
  4e+07 ++                                                                  |
        |                                                                   |
  3e+07 ++                                                                  |
        |                                                                   |
        |                                                                   |
  2e+07 ++                                                            *.*.*.*
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  1e+07 ++------------------------------------------------------------------+


                            numa-numastat.node1.numa_hit

  7e+07 O+--------------------O---O---------------------O-------------------+
        |          O                   O          O                         |
  6e+07 ++O O OO O   O O OO O   O   OO   O O O OO   O O   OO                |
        |                                                                   |
        |                                                                   |
  5e+07 ++                                                                  |
        |                                                                   |
  4e+07 ++                                                                  |
        |                                                                   |
  3e+07 ++                                                                  |
        |                                                                   |
        |                                                                   |
  2e+07 ++                                                            *.*.*.*
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  1e+07 ++------------------------------------------------------------------+


                           numa-numastat.node1.local_node

  7e+07 O+--------------------O---O---------------------O-------------------+
        |          O                   O          O                         |
  6e+07 ++O O OO O   O O OO O   O   OO   O O O OO   O O   OO                |
        |                                                                   |
        |                                                                   |
  5e+07 ++                                                                  |
        |                                                                   |
  4e+07 ++                                                                  |
        |                                                                   |
  3e+07 ++                                                                  |
        |                                                                   |
        |                                                                   |
  2e+07 ++                                                            *.*.*.*
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  1e+07 ++------------------------------------------------------------------+


                                 vmstat.procs.r

  60 ++---------------------------------------------------------------------+
     O O O O O O OO O O O O O O O O O O OO O O O O O O O O O                |
  50 ++                                                                     |
     |                         .*                     .*.                   |
     *.*.*.*.*.*.**.*.*.*.*.*.*  + .*.*.**.*.*.*.*.*.*   *. .*.**.*.*       |
  40 ++                           *                        *        :       |
     |                                                              :       |
  30 ++                                                              :      |
     |                                                               :      |
  20 ++                                                              :      |
     |                                                               :      |
     |                                                                :     |
  10 ++                                                               :     |
     |                                                                *.*.*.*
   0 ++---------------------------------------------------------------------+


                                  vmstat.system.in

  700000 O+-------------------------------O-------------O-------------------+
         | O OO O O O OO O O O O OO O O O  O O O O OO O   O O               |
  600000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
         |                                                                  |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                                                                 |
         |                                                                  |
  200000 ++                                                                 |
         |                                                                  |
  100000 *+*.**.*.*.*.**.*.*.*.*.**.*.*.*.**.*.*.*.**.*.*.*.*.**.*.*.*      |
         |                                                            +     |
       0 ++------------------------------------------------------------**-*-*


                                  vmstat.system.cs

  400000 ++-----------------------------------------------------------------+
         |                                                             **.*.*
  350000 ++                                                            :    |
         |                                                             :    |
  300000 ++                                                           :     |
  250000 ++                                                           :     |
         |                                                            :     |
  200000 ++                                                           :     |
         |                                                           :      |
  150000 *+*.**.*.*. .**.*.*.*.*.**.*.*.*.**.*.*.*.* .*.*.*.*.**.*.*.:      |
  100000 ++         *                               *                *      |
         |                                                                  |
   50000 ++                                                                 |
         |                                                                  |
       0 O+O-OO-O-O-O-OO-O-O-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-O-O---------------+


                             proc-vmstat.nr_active_anon

  100000 ++-----------------------------------------------------------------+
   90000 O+  O  O   O OO     O O OO O   O    O   O OO O O O O               |
         | O  O   O      O O          O   OO   O                            |
   80000 ++                                                                 |
   70000 ++                                                                 |
         |                                                                  |
   60000 ++                                                                 |
   50000 ++                                                                 |
   40000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
   20000 ++                      *                                          |
         |       .*. .*   .*.*. + :.*.*.*.                        .*. .*    |
   10000 *+*.**.*   *  *.*     *  *       **.*.*.*.**.*.*.*.*.**.*   *  *.*.*
       0 ++-----------------------------------------------------------------+


                           proc-vmstat.nr_isolated_file

  1600 ++-------------------------------------------------------------------+
       |                                                              *.*.*.*
  1400 ++*.*.**.*.*.*.*.*.*.**. .*. .*.*.**.     .*.*.**.*.*.*.*.*. .*      |
       *                       *   *        *.*.*                  *        |
  1200 ++                                                                   |
       |                                                                    |
  1000 ++                                                                   |
       |                                                                    |
   800 ++                                                                   |
       |                                                                    |
   600 ++                                                                   |
       |                                                                    |
   400 ++                                                                   |
       O O O OO O O O O O O OO O O O O O OO O O O O O OO O O                |
   200 ++-------------------------------------------------------------------+


                                proc-vmstat.nr_shmem

  100000 ++-----------------------------------------------------------------+
         O O OO O O O OO O O O O OO O O O OO O O O OO O O O O               |
   90000 ++                                                                 |
   80000 ++                                                                 |
         |                                                                  |
   70000 ++                                                                 |
   60000 ++                                                                 |
         |                                                                  |
   50000 ++                                                                 |
   40000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
   20000 ++                *.    *                                          |
         |       .*. .*   +  *. + :.*.*.*.                        .*.       |
   10000 *+*-**-*---*--*-*-----*--*-------**-*-*-*-**-*-*-*-*-**-*---*-**-*-*


                                 proc-vmstat.numa_hit

  1.4e+08 O+-------------------O---O--------------------O-------------------+
          |      O   OO O     O  O   O OO O        O      O                 |
  1.2e+08 ++O OO   O      O O               O OO O   O O    O               |
          |                                                                 |
          |                                                                 |
    1e+08 ++                                                                |
          |                                                                 |
    8e+07 ++                                                                |
          |                                                                 |
    6e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
    4e+07 ++                                                          .**.*.*
          *.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
    2e+07 ++----------------------------------------------------------------+


                                proc-vmstat.numa_local

  1.4e+08 O+-------------------O---O--------------------O-------------------+
          |      O   OO O     O  O   O OO O        O      O                 |
  1.2e+08 ++O OO   O      O O               O OO O   O O    O               |
          |                                                                 |
          |                                                                 |
    1e+08 ++                                                                |
          |                                                                 |
    8e+07 ++                                                                |
          |                                                                 |
    6e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
    4e+07 ++                                                          .**.*.*
          *.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
    2e+07 ++----------------------------------------------------------------+


                           proc-vmstat.workingset_refault

  7e+07 ++------------------------------------------------------------------+
        O                                                                   |
  6e+07 ++         O O      O O O O O  O O        O     O                   |
        | O O OO O     O OO          O     O O OO   O O   OO                |
  5e+07 ++                                                                  |
        |                                                                   |
  4e+07 ++                                                                  |
        |                                                                   |
  3e+07 ++                                                                  |
        |                                                                   |
  2e+07 ++                                                                  |
        |                                                             *.*.*.*
  1e+07 *+*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
        |                                                                   |
      0 ++------------------------------------------------------------------+


                            proc-vmstat.workingset_activate

    4e+07 ++----------------------------------------------------------------+
          O                                             O                   |
  3.5e+07 ++     O   OO O     OO O O O  O O   O  O O      O                 |
          | O OO   O      O O          O    O  O     O O    O               |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++                                                                |
          |                                                                 |
    1e+07 ++                                                           **.*.*
          |                                                           +     |
    5e+06 *+*-**-*-*-**-*-*-*-**-*-*-*-**-*-*-**-*-*-*-**-*-*-*-**-*-*------+


                               proc-vmstat.pgalloc_dma32

  4.5e+06 ++----------------------------------------------------------------+
          |                                                                 |
    4e+06 O+                   O   O                    O                   |
          |      O   OO O     O  O   O OO O   O  O O O    O O               |
  3.5e+06 ++O OO   O      O O               O  O       O                    |
          |                                                                 |
    3e+06 ++                                                                |
          |                                                                 |
  2.5e+06 ++                                                                |
          |                                                                 |
    2e+06 ++                                                                |
          |                                                                 |
  1.5e+06 ++                                                           **.*.*
          *.*.**.*.*.**.*.*.*.*                     .*.*              +     |
    1e+06 ++-------------------*-*-*-*-**-*-*-**-*-*----*-*-*-*-**-*-*------+


                              proc-vmstat.pgalloc_normal

  1.6e+08 ++----------------------------------------------------------------+
          O                    O   O                    O                   |
  1.4e+08 ++     O   OO O   O O  O   O OO O   O  O O O O  O O               |
          | O OO   O      O                 O  O                            |
  1.2e+08 ++                                                                |
          |                                                                 |
    1e+08 ++                                                                |
          |                                                                 |
    8e+07 ++                                                                |
          |                                                                 |
    6e+07 ++                                                           **.*.*
          |                                                           +     |
    4e+07 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
    2e+07 ++----------------------------------------------------------------+


                                  proc-vmstat.pgfree

  1.6e+08 ++----------------------------------------------------------------+
          O                    O   O                    O                   |
  1.4e+08 ++     O   OO O     O  O   O OO O   O  O O O O  O O               |
          | O OO   O      O O               O  O                            |
          |                                                                 |
  1.2e+08 ++                                                                |
          |                                                                 |
    1e+08 ++                                                                |
          |                                                                 |
    8e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
    6e+07 ++                                                           **.*.*
          |                                                           +     |
    4e+07 *+*-**-*-*-**-*-*-*-**-*-*-*-**-*-*-**-*-*-*-**-*-*-*-**-*-*------+


                               proc-vmstat.pgactivate

  8e+07 ++------------------------------------------------------------------+
        O                                               O                   |
  7e+07 ++     O   O O O    O O O O OO O O   O  O O O     OO                |
        | O O O  O       OO                O   O      O                     |
  6e+07 ++                                                                  |
        |                                                                   |
  5e+07 ++                                                                  |
        |                                                                   |
  4e+07 ++                                                                  |
        |                                                                   |
  3e+07 ++                                                               .*.|
        |                                                             *.*   *
  2e+07 *+*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
        |                                                                   |
  1e+07 ++------------------------------------------------------------------+


                               proc-vmstat.pgdeactivate

  1.6e+08 ++----------------------------------------------------------------+
          |                                                                 |
  1.4e+08 O+                   O   O                    O                   |
          |      O   OO O     O  O   O OO O   O  O O O O  O O               |
  1.2e+08 ++O OO   O      O O               O  O                            |
          |                                                                 |
    1e+08 ++                                                                |
          |                                                                 |
    8e+07 ++                                                                |
          |                                                                 |
    6e+07 ++                                                                |
          |                                                                 |
    4e+07 ++                                                           **.*.*
          |                                                           +     |
    2e+07 *+*-**-*-*-**-*-*-*-**-*-*-*-**-*-*-**-*-*-*-**-*-*-*-**-*-*------+


                                  proc-vmstat.pgfault

    3e+07 O+--------------------------------------------O-------------------+
          |      O   OO O     OO O O O OO O   O  O O      O                 |
          | O OO   O      O O               O  O     O O    O               |
  2.5e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++                                                                |
          |                                                                 |
          |                                                            **.*.*
    1e+07 ++                                                          +     |
          *.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
    5e+06 ++----------------------------------------------------------------+


                               proc-vmstat.pgmajfault

  1e+07 ++------------------------------------------------------------------+
        |                                                                   |
  9e+06 O+                    O   O    O O        O     O                   |
  8e+06 ++O O OO O O O O OO O   O   OO     O O OO   O O   OO                |
        |                                                                   |
  7e+06 ++                                                                  |
        |                                                                   |
  6e+06 ++                                                                  |
        |                                                                   |
  5e+06 ++                                                                  |
  4e+06 ++                                                                  |
        |                                                             *.*.*.*
  3e+06 *+*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
        |                                                                   |
  2e+06 ++------------------------------------------------------------------+


                              proc-vmstat.pgrefill_dma32

    4e+06 ++----------------------------------------------------------------+
          O                                             O                   |
  3.5e+06 ++     O   OO O     OO O O   OO O        O      O                 |
          | O OO   O      O O        O      O OO O   O O    O               |
    3e+06 ++                                                                |
          |                                                                 |
  2.5e+06 ++                                                                |
          |                                                                 |
    2e+06 ++                                                                |
          |                                                                 |
  1.5e+06 ++                                                                |
          |                                                                 |
    1e+06 ++                                                           **.*.*
          *.*.**.*.*.**.*.*.*.*                     .*.*              +     |
   500000 ++-------------------*-*-*-*-**-*-*-**-*-*----*-*-*-*-**-*-*------+


                              proc-vmstat.pgrefill_normal

  1.4e+08 O+----------------------------------------------------------------+
          |          O         O   O    O O        O    O                   |
  1.2e+08 ++O  O O O  O O   O O  O   O O      O  O   O O  O O               |
          |   O           O                 O  O                            |
          |                                                                 |
    1e+08 ++                                                                |
          |                                                                 |
    8e+07 ++                                                                |
          |                                                                 |
    6e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
    4e+07 ++                                                           **.*.*
          |                                                           +     |
    2e+07 *+*-**-*-*-**-*-*-*-**-*-*-*-**-*-*-**-*-*-*-**-*-*-*-**-*-*------+


                          proc-vmstat.pgsteal_kswapd_dma32

  160000 ++-----------------------------------------------------------------+
         |      O      O       O  O                O    O O O               |
  140000 O+O  O     O O    O O   O  O O O O  O   O  O O                     |
  120000 ++  O    O      O                 O   O                            |
         |                                                                  |
  100000 ++                                                                 |
         |                                                                  |
   80000 ++                                                                 |
         |                                                                  |
   60000 ++                                                                 |
   40000 ++                                                                 |
         |                                                            .**.*.*
   20000 *+*.**.*.*.*.**.*.*.*.*.**.*.*.*.**.*.*.*.**.*.*.*.*.**.*.*.*      |
         |                                                                  |
       0 ++-----------------------------------------------------------------+


                          proc-vmstat.pgsteal_kswapd_normal

  7e+06 ++------------------------------------------------------------------+
        |                                                                   |
  6e+06 ++                    O   O    O          O     O OO                |
        O O   OO O O O O  O O   O   OO   O   O  O   O O                     |
  5e+06 ++  O            O                 O   O                            |
        |                                                                   |
  4e+06 ++                                                                  |
        |                                                                   |
  3e+06 ++                                                                  |
        |                                                                   |
  2e+06 ++                                                                  |
        |                                                             *.*.*.*
  1e+06 *+*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
        |                                                                   |
      0 ++------------------------------------------------------------------+


                           proc-vmstat.pgsteal_direct_dma32

  3.5e+06 O+----------------------------------------------------------------+
          |                    O   O                    O                   |
    3e+06 ++     O   OO O     O  O   O OO O   O  O O O O  O O               |
          | O OO   O      O O               O  O                            |
          |                                                                 |
  2.5e+06 ++                                                                |
          |                                                                 |
    2e+06 ++                                                                |
          |                                                                 |
  1.5e+06 ++                                                                |
          |                                                                 |
          |                                                                 |
    1e+06 ++                                                           **.*.*
          *.*.**.*.*.**.*.*.*.*                     .*.*              +     |
   500000 ++-------------------*-*-*-*-**-*-*-**-*-*----*-*-*-*-**-*-*------+


                           proc-vmstat.pgsteal_direct_normal

  1.4e+08 ++----------------------------------------------------------------+
          O                                                                 |
  1.2e+08 ++                   O   O               O    O                   |
          | O  O O O OO O   O O  O   O OO O   O  O   O O  O O               |
          |   O           O                 O  O                            |
    1e+08 ++                                                                |
          |                                                                 |
    8e+07 ++                                                                |
          |                                                                 |
    6e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
    4e+07 ++                                                           **.*.*
          |                                                           +     |
    2e+07 *+*-**-*-*-**-*-*-*-**-*-*-*-**-*-*-**-*-*-*-**-*-*-*-**-*-*------+


                           proc-vmstat.pgscan_kswapd_dma32

  300000 ++-----------------------------------------------------------------+
         |      O     OO       O  O     O    O   O O    O O O               |
  250000 O+O  O     O      O O   O  O O   O         O O                     |
         |   O    O      O                 O   O                            |
         |                                                                  |
  200000 ++                                                                 |
         |                                                                  |
  150000 ++                                                                 |
         |                                                                  |
  100000 ++                                                                 |
         |                                                                  |
         |                      .*                                    .**.*.*
   50000 *+*.**.*.*.*.**.*.*.*.*  *.*.*.*.**.*.*.*.**.*.*.*.*.**.*.*.*      |
         |                                                                  |
       0 ++-----------------------------------------------------------------+


                           proc-vmstat.pgscan_kswapd_normal

  1.2e+07 ++----------------------------------------------------------------+
  1.1e+07 ++                   O   O    O          O    O O O               |
          O O  O O   OO O   O O  O   O O  O   O  O   O O                    |
    1e+07 ++       O      O                 O  O                            |
    9e+06 ++  O                                                             |
    8e+06 ++                                                                |
    7e+06 ++                                                                |
          |                                                                 |
    6e+06 ++                                                                |
    5e+06 ++                                                                |
    4e+06 ++                                                                |
    3e+06 ++                                                                |
          |                                                           .**.*.*
    2e+06 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
    1e+06 ++----------------------------------------------------------------+


                           proc-vmstat.pgscan_direct_dma32

  7e+06 ++------------------------------------------------------------------+
        O                                                                   |
  6e+06 ++                    O   O      O              O                   |
        | O O OO O O O O  O O   O   OO O     O  O O O O   OO                |
        |                O                 O   O                            |
  5e+06 ++                                                                  |
        |                                                                   |
  4e+06 ++                                                                  |
        |                                                                   |
  3e+06 ++                                                                  |
        |                                                                   |
        |                                                                   |
  2e+06 ++                                                            *.*.*.*
        *.*.*.**.*.*.*.*.**.*.     .*   .*. .*.  .*.*.*. .**.   .*.*. :     |
  1e+06 ++--------------------*-*-*--*-*---*---**-------*----*-*-----*------+


                           proc-vmstat.pgscan_direct_normal

  2.4e+08 O+--------------------------------------------O-------------------+
  2.2e+08 ++     O   OO O     OO O O O OO O        O      O                 |
          | O OO   O      O O               O OO O   O O    O               |
    2e+08 ++                                                                |
  1.8e+08 ++                                                                |
          |                                                                 |
  1.6e+08 ++                                                                |
  1.4e+08 ++                                                                |
  1.2e+08 ++                                                                |
          |                                                                 |
    1e+08 ++                                                                |
    8e+07 ++                                                             .*.*
          |                                                            **   |
    6e+07 ++                                                          +     |
    4e+07 *+*-**-*-*-**-*-*-*-**-*-*-*-**-*-*-**-*-*-*-**-*-*-*-**-*-*------+


                     proc-vmstat.kswapd_low_wmark_hit_quickly

  3000 ++-------------------------------------------------------------------+
       O      O              O   O   O   O        O    O                    |
  2500 ++  O O  O O O O   O O  O   O      O   O     O O  O O                |
       | O              O              O    O   O                           |
       |                                                                    |
  2000 ++                                                                   |
       |                                                                    |
  1500 ++                                                                   |
       |                                                                    |
  1000 ++                                                                   |
       |                                                                    |
       |                                                                    |
   500 ++                                                                   |
       |                                                                    |
     0 *+*-*-**-*-*-*-*-*-*-**-*-*-*-*-*-**-*-*-*-*-*-**-*-*-*-*-*-*-**-*-*-*


                              proc-vmstat.pageoutrun

  4000 ++-------------------------------------------------------------------+
       O                                                                    |
  3500 ++     O     O        O   O O O   O          O  O   O                |
  3000 ++  O O  O O   O   O O  O       O  O O O O O   O  O                  |
       | O              O                                                   |
  2500 ++                                                                   |
       |                                                                    |
  2000 ++                                                                   |
       |                                                                    |
  1500 ++                                                                   |
  1000 ++                                                                   |
       |                                                                    |
   500 ++                                                                   |
       |                                                                    |
     0 *+*-*-**-*-*-*-*-*-*-**-*-*-*-*-*-**-*-*-*-*-*-**-*-*-*-*-*-*-**-*-*-*


                               proc-vmstat.allocstall

  160000 ++-----------------------------------------------------------------+
         |                                                                  |
  140000 O+                    O  O                     O                   |
         |      O   O OO     O   O  O O O O  O   O OO     O O               |
  120000 ++O OO   O      O O               O   O      O                     |
         |                                                                  |
  100000 ++                                                                 |
         |                                                                  |
   80000 ++                                                                 |
         |                                                                  |
   60000 ++                                                                 |
         |                                                                  |
   40000 ++                                                            **.*.*
         |                                                            +     |
   20000 *+*-**-*-*-*-**-*-*-*-*-**-*-*-*-**-*-*-*-**-*-*-*-*-**-*-*-*------+


                            proc-vmstat.pgmigrate_success

  50000 ++------------------------------------------------------------------+
  45000 ++     O       O             O O                                    |
        | O   O               O   O      O        O     O                   |
  40000 ++                          O      O   O          OO                |
  35000 ++  O        O    O                         O                       |
        |                O  O   O            O  O     O                     |
  30000 ++       O                                                          |
  25000 O+         O                                                        |
  20000 ++                                                                  |
        |                                                                   |
  15000 ++                                                                  |
  10000 ++                                                                  |
        |                                                                   |
   5000 ++                                                                  |
      0 *+*-*-**-*-*-*-*-**-*-*-*-*-**-*-*-*-*-**-*-*-*-*-**-*-*-*-*-**-*-*-*


                         proc-vmstat.compact_migrate_scanned

  300000 ++-----------------------------------------------------------------+
         | O           O                                                    |
  250000 ++                                        O                        |
         |      O              O  O                                         |
         |                          O O                 O                   |
  200000 ++  OO   O          O   O      O OO   O    O O   O                 |
         |               O O                                O               |
  150000 ++         O O                                                     |
         O                                   O   O                          |
  100000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   50000 ++                                                                 |
         |                    .*.                                          .*
       0 *+*-**-*-*-*-**-*-*-*---**-*-*-*-**-*-*-*-**-*-*-*-*-**-*-*-*-**-*-+


                            proc-vmstat.compact_isolated

  140000 ++-----------------------------------------------------------------+
         |                                                                  |
  120000 ++            O       O  O   O                                     |
         | O    O                       O          O                        |
  100000 ++   O                           O             O O O               |
         |   O             O        O      O   O    O                       |
   80000 ++           O  O   O   O                    O                     |
         |        O                          O   O                          |
   60000 ++         O                                                       |
         O                                                                  |
   40000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
       0 *+*-**-*-*-*-**-*-*-*-*-**-*-*-*-**-*-*-*-**-*-*-*-*-**-*-*-*-**-*-*


                                meminfo.Active(anon)

  400000 ++-----------------------------------------------------------------+
         O   O  O   O O      O O OO O   O  O O O O OO O O O O               |
  350000 ++O  O   O    O O O          O   O                                 |
         |                                                                  |
  300000 ++                                                                 |
  250000 ++                                                                 |
         |                                                                  |
  200000 ++                                                                 |
         |                                                                  |
  150000 ++                                                                 |
  100000 ++                                                                 |
         |                       *                                          |
   50000 ++      .*. .*   .*.*. + :.*.*.*.                        .*. .*    |
         *.*.**.*   *  *.*     *  *       **.*.*.*.**.*.*.*.*.**.*   *  *.*.*
       0 ++-----------------------------------------------------------------+


                                    meminfo.Shmem

  400000 ++-----------------------------------------------------------------+
         O O OO O O O OO O O O O OO O O O OO O O O OO O O O O               |
  350000 ++                                                                 |
         |                                                                  |
  300000 ++                                                                 |
  250000 ++                                                                 |
         |                                                                  |
  200000 ++                                                                 |
         |                                                                  |
  150000 ++                                                                 |
  100000 ++                                                                 |
         |       .*       .*.    *     .*.                                  |
   50000 ++ .**.*  + .* .*   *. + :.*.*   * .*. .*. *.*.*.*.*.**.*.*. .**.  |
         *.*        *  *       *  *        *   *   *                 *    *.*
       0 ++-----------------------------------------------------------------+


                                meminfo.Committed_AS

  450000 O+-------O-O-OO------------O---O--O-O-O-O-OO-O---O-O---------------+
         | O OO O        O O O O OO   O   O             O                   |
  400000 ++                                                                 |
         |                                                                  |
  350000 ++                                                                 |
         |                                                                  |
  300000 ++                                                                 |
         |                                                                  |
  250000 ++                                                                 |
         |                                                                  |
  200000 ++                                                                 |
         |                                                                  |
  150000 ++      .*.      .*.*. .* .*. .*.                 .*.              |
         |.*.**.*   *.**.*     *  *   *   **.*.*. .**.*.*.*   **.*.*.*.**.*.*
  100000 *+--------------------------------------*--------------------------+


                       slabinfo.proc_inode_cache.active_objs

  8000 ++-------------------------------------------------------------------+
       |                           O                                        |
  7500 ++                                                                   |
       |                                                                    |
  7000 O+O O O  O   O     O OO O O   O   O  O   O   O O  O                  |
       |      O   O   O O              O  O   O            O                |
  6500 ++                                         O    O                    |
       |                                                                    |
  6000 ++                                                             *.    |
       |    .*                .*.*.*.*    *.             *.*.*.*.     : *.  |
  5500 *+*.*  *.*.*.*.*.*. .**        :  *  *. .*.*   * +        *.*.*    *.*
       |                  *           : :     *    + + *                    |
  5000 ++                              ::           *                       |
       |                               *                                    |
  4500 ++-------------------------------------------------------------------+


                             sched_debug.cpu#0.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                            *.*.*
          |                                                            *    |
          |                                                            :    |
    2e+06 ++                                                           :    |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                           :     |
          |                                                          :      |
   500000 *+*.**.*.*. *. .*.*.**. .*.*.**.*.*.* .*.*.*.**.*.*.*.* .*.:      |
          |          *  *        *             *                 *   *      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#0.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**. .*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |             *                                                   |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#0.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                             *.*.*
  1.2e+06 ++                                                           *    |
          |                                                            :    |
    1e+06 ++                                                           :    |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.* .*.*      |
          |                                                      *          |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#0.avg_idle

   1e+06 O+---O-O------O-O-----O--O-O-O-O-OO-O-O-O--O-O-O-O-O---------------+
         | O O    O O O    O O   O                 O                        |
  900000 ++                                                                 |
  800000 ++                                                                 |
         |                                                                  |
  700000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                             **.  |
  300000 ++                                                           +   *.|
  200000 ++        .*.               .*.             .*.*.*.     *.*.*      *
         *.*.* .*.*   **.*.*.*.*.**.*   *.**.*.*.*.**       *.* +           |
  100000 ++---*------------------------------------------------*------------+


                             sched_debug.cpu#0.ttwu_count

  1.4e+06 ++----------------------------------------------------------------*
          |                                                            **.* |
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |     .*.                 .*.                              :      |
   200000 *+*.**   *.**.*.*.*.**.*.*   **.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[0]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                     .*                            |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*  *.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                             sched_debug.cpu#1.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                            *.*.*
          |                                                            *    |
          |                                                            :    |
    2e+06 ++                                                           :    |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*. *.*.*.*.**. .*.*.**.*.*.**.*.*.*.**.*.*.*.* .*.*      |
          |          *           *                               *          |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#1.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*. *.*.*.*.**. .*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |          *           *                                          |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#1.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                             *.*.*
  1.2e+06 ++                                                           *    |
          |                                                            :    |
    1e+06 ++                                                           :    |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*. *.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |          *                                                      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#1.avg_idle

   1e+06 O+O-OO---O---OO-O-O--------O-O-O-OO-O-O-O-OO-O-O-O-O---------------+
         |      O   O        O O OO                                         |
  900000 ++                                                                 |
  800000 ++                                                                 |
         |                                                                  |
  700000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                                                            **   |
  200000 ++                   .*. *. .*.*.     *.              *.*.*. +  + .*
         *.*.**.*. .*.**.*.*.*   *  *     **. +  *. *.*. .*. .*      *    * |
  100000 ++-------*--------------------------*-----*----*---*---------------+


                             sched_debug.cpu#1.ttwu_count

  1.4e+06 ++----------------------------------------------------------------+
          |                                                             *.*.*
  1.2e+06 ++                                                           *    |
          |                                                            :    |
    1e+06 ++                                                           :    |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |     .*.                                                  :      |
   200000 *+*.**   *.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[1]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                     .*                            |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*  *.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                             sched_debug.cpu#2.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                              .*.                         :      |
   500000 *+*.**.*.*.**. .*.*.**.*.*.*.**   *.**.*.*.*.**.*.*.*.* .*.*      |
          |             *                                        *          |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#2.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                             *. .*
  2.5e+06 ++                                                           *  * |
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                              .*.                         :      |
   500000 *+*.**.*.*.**. .*.*.**.*.*.*.**   *.**.*.*.*.**.*.*.*.**.*.*      |
          |             *                                                   |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#2.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            **. .*
  1.2e+06 ++                                                           :  * |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                              .*.                         :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**   *.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#2.avg_idle

   1e+06 O+O-OO-O-O-O-OO-O-O-O-O-OO---O-O--O-O-O-O-OO-O-O-O-O---------------+
         |                                O                                 |
  900000 ++                         O                                       |
  800000 ++                                                                 |
         |                                                                  |
  700000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++         *                                                   *.  |
  200000 ++*.      + +         *         .*         *.         *.*. .*. : *.*
         *   **.*.*   *   .*. + + *.*.*.*  *. .*.*.*  *.*.*.*.*    *   *    |
  100000 ++------------*-*---*---*-----------*------------------------------+


                             sched_debug.cpu#2.ttwu_count

  1.4e+06 ++-----------------------------------------------------------*----*
          |                                                            :*. +|
  1.2e+06 ++                                                           :  * |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |     .*.                                                  :      |
   200000 *+*.**   *.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[2]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                     .*                            |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*  *.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                             sched_debug.cpu#3.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                              .*.|
  2.5e+06 ++                                                           **   *
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                           :     |
          |                             *.                           :      |
   500000 *+*.**.*.*. *.*.*.*.**. .*.*.*  *.*.* .*.*.*.**.*.*.*.**.*.:      |
          |          *           *             *                     *      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#3.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                             *.*.|
  2.5e+06 ++                                                           *    *
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |    *.*.                     *.                           :      |
   500000 *+*.*    *.**.*.*.*.**. .*.*.*  *.*.**.*.*.*.**.*.*.*.**.*.*      |
          |        O             *                                          |
        0 O+O-OO-O---OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#3.sched_goidle

  1.4e+06 ++--------------------------------------------------------------*-+
          |                                                            **   *
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                             *.                           :      |
   200000 *+*.**.*.*.**.*.*.*.**. .*.*.*  *.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                      *                                          |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#3.avg_idle

   1e+06 O+O-OO-O-O-O-O--------O--O-O-O-O-OO-O-O-O-OO-O-O---O---------------+
  900000 ++              O O O   O                        O                 |
         |             O                                                    |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++      .*                              *                       .*.*
  200000 ++   *.*  +   *. .*.*.*.    .*.   *.*  : + *.*        *.*. .*.**   |
         *.*.*      *.*  *       **.*   *.*   + :  *   + .*.*.*    *        |
  100000 ++                                    *        *                   |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#3.ttwu_count

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            **.*.*
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |     .*.                                                  :      |
   200000 *+*.**   *.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                        sched_debug.cfs_rq[3]:/.min_vruntime

  1e+07 ++------------------------------------------------------------------+
  9e+06 O+     O   O O O    O O O O O  O O   O  O O     O OO                |
        | O O O  O       OO          O     O   O    O                       |
  8e+06 ++                                            O                     |
  7e+06 ++                                                                  |
        |  .*.**.*.   .*.    .*.     *.     .*. *. .*.   .**.       .*      |
  6e+06 *+*        *.*   **.*   *.*.*  *.*.*   *  *   *.*    *.*.*.* :      |
  5e+06 ++                                                           :      |
  4e+06 ++                                                           :      |
        |                                                             :     |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[3]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                     .*                            |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*  *.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                             sched_debug.cpu#4.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                           :     |
          |                                                          :      |
   500000 *+*.**.*.*. *.*.*.*.**.*.*.*.**.*.*.**.*.*.*. *.*.*.*.* .*.:      |
          |          *                                 *         *   *      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#4.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                           :     |
          |                                                          :      |
   500000 *+*.**.*.*. *.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.:      |
          |          *                                               *      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#4.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            **.*.*
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*. *.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |          *                                                      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#4.avg_idle

   1e+06 ++O----O-O-O-OO-O-O---O--O---O-O-OO-O-O-O--O---O---O---------------+
         O   OO              O   O  O              O      O                 |
  900000 ++                                           O                     |
  800000 ++                                                                 |
         |                                                                  |
  700000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                               .*.|
  300000 ++                                          .*                 *   *
  200000 ++ .*         *.*.*. .*.  .*               *  :  *.   *.       :   |
         |.*  *.*. .*.*      *   **  +   .*   .*.*.*   : +  *.*  *.*.*.*    |
  100000 *+-------*-------------------*-*--*-*----------*-------------------+


                             sched_debug.cpu#4.ttwu_count

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            * .*.*
  1.2e+06 ++                                                           :*   |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                        sched_debug.cfs_rq[4]:/.min_vruntime

  1e+07 ++------------------------------------------------------------------+
  9e+06 O+     O   O O O      O   O OO O          O     O  O                |
        | O O O  O       OO O   O        O O O OO   O O   O                 |
  8e+06 ++                                                                  |
  7e+06 ++                                                                  |
        *.   .* .*.   .*  *.          .*. .*.   *. .*.   .* .*. .*. .*      |
  6e+06 ++*.*  *   *.*  + : *.*.*.*.**   *   *.*  *   *.*  *   *   * :      |
  5e+06 ++               *                                           :      |
  4e+06 ++                                                           :      |
        |                                                             :     |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[4]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                             sched_debug.cpu#5.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                              .*.|
  2.5e+06 ++                                                           **   *
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*. *. .*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |          *  *                                                   |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#5.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            **.*.*
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*. *.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |          *                                                      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#5.avg_idle

   1e+06 O+O-O--O-O-O-O------O---O--O-O-O-OO-O-O-O-OO-O-O---O---------------+
         |    O        O O O   O  O                       O                 |
  900000 ++                                                                 |
  800000 ++                                                                 |
         |                                                                  |
  700000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                                  *                          *.*.|
  200000 *+      .*.*   .*.     .*      *.  + +      .*.*. .*. *.*.*.*.*    *
         | *.**.*    + *   *.*.*  *.*. +  **   *.*. *     *   *             |
  100000 ++-----------*---------------*------------*------------------------+


                             sched_debug.cpu#5.ttwu_count

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            **.*.*
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                        sched_debug.cfs_rq[5]:/.min_vruntime

  1e+07 ++------------------------------------------------------------------+
  9e+06 O+    OO   O O O  O   O   O OO O          O   O O  O                |
        | O O    O       O  O   O                   O     O                 |
  8e+06 ++                               O O O OO                           |
  7e+06 ++                                                                  |
        *.      .*.   .*. *.         *.         *. .*.   .* .*. .*. .*      |
  6e+06 ++*.*.**   *.*   *  *.*.*.*.*  *.*.*.*.*  *   *.*  *   *   * :      |
  5e+06 ++                                                           :      |
  4e+06 ++                                                           :      |
        |                                                             :     |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[5]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                             sched_debug.cpu#6.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                              .*.|
  2.5e+06 ++                                                           **   *
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**. .*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                      *                                          |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#6.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                              .*.|
  2.5e+06 ++                                                           **   *
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**. .*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                      *                                          |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#6.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            **.*.*
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**. .*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                      *                                          |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#6.avg_idle

   1e+06 O+--OO---O-O--O-O-O-O-O-OO-O-O----O-O-O-O-O----O-O-O---------------+
  900000 ++O    O     O                 O O         O O                     |
         |                                                                  |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                                           *                     |
  200000 ++*. *.*. .*  *.*. .*.    .*.*.   *.        + + .*.    .*.   .**. .*
         *   *    *  + :   *   *.**     *.*  *.*.*.**   *   *.**   *.*    * |
  100000 ++           *                                                     |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#6.ttwu_count

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            * .*.*
  1.2e+06 ++                                                           :*   |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                        sched_debug.cfs_rq[6]:/.min_vruntime

  1e+07 ++------------------------------------------------------------------+
  9e+06 O+     O   O O O  O O O O O OO O   O   O  O O   O  O                |
        | O O O  O       O               O   O  O     O   O                 |
  8e+06 ++                                                                  |
  7e+06 ++                                                                  |
        *.     *.*.       *.*.       *.*.*.        .*.   .* .*. .*.         |
  6e+06 ++*.*.*    *.*.*.*    *.*.*.*      *.*.**.*   *.*  *   *   *.*      |
  5e+06 ++                                                           :      |
  4e+06 ++                                                           :      |
        |                                                            :      |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[6]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                             sched_debug.cpu#7.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                           :     |
          |                                                          :      |
   500000 *+*.**.*.*. *.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.:      |
          |          *                                               *      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#7.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                              .*.|
  2.5e+06 ++                                                           **   *
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                           :     |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.:      |
          |               O             O              O             *      |
        0 O+O-OO-O-O-OO-O---O-OO-O-O-O-O--O-O-OO-O-O-O--O-O-O---------------+


                            sched_debug.cpu#7.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                              .*.*
  1.2e+06 ++                                                           **   |
          |                                                            :    |
    1e+06 ++                                                           :    |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                          :     |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.:      |
          |                                                          *      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#7.avg_idle

   1e+06 ++O-OO---O-O--O-O-O-O-O-OO-O-O-O-OO-O-O-O-OO---O---O---------------+
  900000 O+     O     O                               O   O                 |
         |                                                                  |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                                                          *.* .*.*
  200000 ++    .*.*.   *. .*.*.*     .*.*.* .*.*.*. *.*. .*     .*. +   *   |
         *.*.**     *.*  *      + *.*      *       *    *  + .**   *        |
  100000 ++                      *                          *               |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#7.ttwu_count

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            * .*.*
  1.2e+06 ++                                                           :*   |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                        sched_debug.cfs_rq[7]:/.min_vruntime

  1e+07 ++------------------------------------------------------------------+
  9e+06 O+    OO     O O  O   O   O OO O O   O  O O O O O OO                |
        | O O    O O     O  O   O          O   O                            |
  8e+06 ++                                                                  |
  7e+06 ++                                                                  |
        *.*. .* .*.       *.*.                     .*. .*.* .*. .*.         |
  6e+06 ++  *  *   *.*.*.*    *.*.*.**.*.*.*.*.**.*   *    *   *   *.*      |
  5e+06 ++                                                           :      |
  4e+06 ++                                                           :      |
        |                                                            :      |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[7]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                             sched_debug.cpu#8.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#8.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                 O  O                            |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O---O--O-O-O-OO-O-O---------------+


                            sched_debug.cpu#8.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            **.*.|
  1.2e+06 ++                                                           :    *
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#8.avg_idle

   1e+06 O+O-OO-O-O-O--O-O-O-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-------------------+
  900000 ++                                                 O               |
         |            O                                   O                 |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                              *.  |
  300000 ++                                       .*                    : *.|
  200000 ++ .*   .*.*.      .*.      .*.   *    .*  :    .*.*  *.*.*.*.*    *
         *.*  *.*     **.*.*   *.* .*   *.* + .*    *.*.*    + :            |
  100000 ++                       *          *                *             |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#8.ttwu_count

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            * .*.*
  1.2e+06 ++                                                           :*   |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                        sched_debug.cfs_rq[8]:/.min_vruntime

  1e+07 ++------------------------------------------------------------------+
  9e+06 O+    OO   O O O      O   O OO O O O   O  O O O O OO                |
        | O O    O       OO O   O            O  O                           |
  8e+06 ++                                                                  |
  7e+06 ++                                                                  |
        *. .*.**.*.       *.*.        .*.*.     *. .*. .*.*     .*. .*      |
  6e+06 ++*        *.*.*.*    *.*.*.**     *.*.*  *   *    *.*.*   * :      |
  5e+06 ++                                                           :      |
  4e+06 ++                                                           :      |
        |                                                             :     |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[8]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                             sched_debug.cpu#9.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*. *.*.*.*.**.*.*.*.**.*.*.**.*.*. .**.*.*.*.**.*.*      |
          |          *                               *                      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#9.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          *.                                                         :      |
   500000 ++*.**.*.*. *.*.*.*.**.*.*.*.**.*.*.**.*.*. .**.*.*.*.**.*.*      |
          |          *                               *                      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#9.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            **.*.*
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*. *.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |          *                                                      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#9.avg_idle

   1e+06 O+O-O----O--------O-O-O-OO-O-O-O--O-O-O-O-OO-O---O-O---------------+
  900000 ++   O O   O OO O                O             O                   |
         |                                                                  |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 *+                                *                                |
  200000 ++            *. .*.*.     *.*. .* +   .*.*     .*. .**.   .*.**.*.*
         | *.**.*.*.*.*  *     *.* +    *    *.*    *.*.*   *    *.*        |
  100000 ++                       *                                         |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#9.ttwu_count

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            * .*.*
  1.2e+06 ++                                                           :*   |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                        sched_debug.cfs_rq[9]:/.min_vruntime

  1e+07 ++------------------------------------------------------------------+
  9e+06 O+     O   O O O    O O O O OO O O   O  O O O   O OO                |
        | O O O  O       OO                O   O      O                     |
  8e+06 ++                                                                  |
  7e+06 ++                                                                  |
        |    .**.*.       *.*.       *.     .*. *.       .* .*.     .*      |
  6e+06 *+*.*      *.*.*.*    *.*.*.*  *.*.*   *  *.*.*.*  *   *.*.* :      |
  5e+06 ++                                                           :      |
  4e+06 ++                                                           :      |
        |                                                             :     |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[9]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#10.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                              .*.|
  2.5e+06 ++                                                           **   *
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*. *.*.*.*.**. .*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |          *           *                                          |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#10.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                             *.*.|
  2.5e+06 ++                                                           *    *
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*. *.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |          *                                                      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#10.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            **.*.*
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#10.avg_idle

   1e+06 ++O-OO-O-O---OO------------O-O-O-OO-O-O-O-OO-O-----O---------------+
  900000 ++         O    O O   O  O                     O                   |
         O                   O   O                        O                 |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                             *                             .*    |
  200000 ++*.**    .*.**. .*.*.        + + *.     .**.*    .*.  .*. .*  *.*.|
         *     + .*      *     *.* .*.*   *  *.*.*     + .*   **   *        *
  100000 ++     *                 *                     *                   |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#10.ttwu_count

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            * .*.*
  1.2e+06 ++                                                           :*   |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[10]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#11.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                            *.*.|
          |                                                            *    *
          |                                                            :    |
    2e+06 ++                                                           :    |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#11.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                            *.*.|
          |                                                            *    *
          |                                                            :    |
    2e+06 ++                                                           :    |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |    O                                                            |
        0 O+O-O--O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#11.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                             *.*.|
  1.2e+06 ++                                                           *    *
          |                                                            :    |
    1e+06 ++                                                           :    |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#11.avg_idle

   1e+06 O+O-OO-O-O----O-O-O---O--O-O-O-O-OO-O-O-O--O---O-O-O---------------+
  900000 ++         O O                               O                     |
         |                   O   O                                          |
  800000 ++                                        O                        |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++               .*.              *                           *    |
  200000 ++*.  .*.      .*   *.*.  .*.     :+     .**.*.*. .*   .*.   + *.*.*
         *   **   *.*.**         **   *.*.*  *.*.*        *  + *   *.*      |
  100000 ++                                                   *             |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#11.ttwu_count

  1.4e+06 ++--------------------------------------------------------------*-+
          |                                                            **   *
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |     .*.                                                  :      |
   200000 *+*.**   *.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[11]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#12.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                            *.*.|
          |                                                            *    *
          |                                                            :    |
    2e+06 ++                                                           :    |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |     .*.                                                  :      |
   500000 *+*.**   *. *.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |          *                                                      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#12.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                              .* |
  2.5e+06 ++                                                           **  +|
          |                                                            :    *
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |     .*.                                                  :      |
   500000 *+*.**   *.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#12.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                             *.*.|
  1.2e+06 ++                                                           *    *
          |                                                            :    |
    1e+06 ++                                                           :    |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |     .*.                                                  :      |
   200000 *+*.**   *.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#12.avg_idle

   1e+06 O+O-OO-O---O-OO-O-O-O-O-OO-O-O-O-O--------O--O-O-O-O---------------+
  900000 ++                                O O O O  O                       |
         |        O                                                         |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++          .*                                               .*   .*
  200000 ++*. *.*.*.*  :  .*.*.   *. .*.*.*       .*   .*.        .*.*  *.* |
         *   *         *.*     *.*  *      *. .*.*  *.*   *.*.* .*          |
  100000 ++                                  *                 *            |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#12.ttwu_count

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            **.*.*
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[12]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#13.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*. *.*.*.*.**.*.*.*.**.*.*      |
          |                                   *                             |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#13.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                              .*.|
  2.5e+06 ++                                                           **   *
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*. *.*.*.*.**.*.*.*.**.*.*      |
          |                                   *                             |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#13.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                             *.*.|
  1.2e+06 ++                                                           *    *
          |                                                            :    |
    1e+06 ++                                                           :    |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#13.ttwu_count

  1.4e+06 ++-----------------------------------------------------------*--*-+
          |                                                            :*   *
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[13]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                     .*                            |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*  *.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#14.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                             .* |
          |                                                            **   |
          |                                                            :    |
    2e+06 ++                                                           :    |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                  .*                                .*    :      |
   500000 *+*.**.*.*.**.*. .*  *.*.*.*.**.*.*.**.*.*.*.**.*.*.*  *.*.*      |
          |               *                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#14.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           **.* |
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                     *    :      |
          |                  .*                 .*.     *.     + :   :      |
   500000 *+*.**.*.*.**.*. .*  *.*.*.*.**.*.*.**   *.*.*  *.*.*  *.*.*      |
          |               *                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#14.sched_goidle

  1.4e+06 ++----------------------------------------------------------------*
          |                                                                +|
  1.2e+06 ++                                                           **.* |
          |                                                            :    |
    1e+06 ++                                                           :    |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                  .*                                .*    :      |
   200000 *+*.**.*.*.**.*.*.*  *.*.*.*.**.*.*.**.*.*.*.**.*.*.*  *.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#14.avg_idle

   1e+06 O+O-OO-O-O---OO---O-O-O-OO-----O-OO-O-O-O----O-O-O-O---------------+
         |          O    O          O O            O                        |
  900000 ++                                         O                       |
  800000 ++                                                                 |
         |                                                                  |
  700000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                             *    |
  300000 ++                      *                                    +:    |
  200000 ++ .*         *.       : :        *.*       .*             .*  :.*.*
         |.*  :.*. .*.*  *.     : *.*. .*.*   + .*.**  +     .* .*.*    *   |
  100000 *+---*---*--------*-*-*------*--------*--------*-*-*--*------------+


                             sched_debug.cpu#14.ttwu_count

  1.4e+06 ++--------------------------------------------------------------*-*
          |                                                            **   |
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[14]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                     .*                            |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*  *.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#15.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           * .* |
          |                                                            :*   |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                .*.                             .*.   *.  :      |
   500000 *+*.**.*.*.**.*.*   **.*.*.*.**.*.*.**.*.*.*.**.*   *.*  *.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#15.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                            *   .*
  2.5e+06 ++                                                           :*.* |
          |                                                            :    |
          |                                                           :     |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                .*.                             .*.   *.  :      |
   500000 *+*.**.*.*.**.*.*   **.*.*.*.**.*.*.**.*.*.*.**.*   *.*  *.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#15.sched_goidle

  1.4e+06 ++----------------------------------------------------------------*
          |                                                            * .* |
  1.2e+06 ++                                                           :*   |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                .*.                             .*.   *.  :      |
   200000 *+*.**.*.*.**.*.*   **.*.*.*.**.*.*.**.*.*.*.**.*   *.*  *.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#15.avg_idle

   1e+06 O+-----O-O----O-O-O--------O-O---OO-O-O-O--O-O-O-O-O---------------+
  900000 ++O OO     O O      O O OO     O          O                        |
         |                                                                  |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 *+                *.                                               |
  200000 ++*. *. .*.*.*   +  *.*. *.*. .*. *                   *.*.*.   *.*.*
         |   *  *      *.*       *    *   * + .*.*.**.*.*.*.*.*      *.*    |
  100000 ++                                  *                              |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#15.ttwu_count

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                 |
  1.4e+06 ++                                                           **.*.*
          |                                                            :    |
  1.2e+06 ++                                                           :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[15]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                     .*                            |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*  *.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#16.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                            *   .*
  2.5e+06 ++                                                           :*.* |
          |                                                            :    |
          |                                                           :     |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |           *.                                             :      |
   500000 *+*.**.*.*.*  *. .*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |               *                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#16.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                            *   .*
  2.5e+06 ++                                                           :*.* |
          |                                                            :    |
          |                                                           :     |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |           *.*                    .*                      :      |
   500000 *+*.**.*.*.*   + .*.**.*.*.*.**.*.*  *.*.*.*.**.*.*.*.**.*.*      |
          |               *                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#16.sched_goidle

  1.4e+06 ++-----------------------------------------------------------*----*
          |                                                            :*.* |
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |           *.*.                                           :      |
   200000 *+*.**.*.*.*    *.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#16.avg_idle

   1e+06 O+O----O-O---OO-O-O-O-O-OO-O-O-O-OO-O-O-O-OO---O-O-O---------------+
  900000 ++  OO     O                                 O                     |
         |                                                                  |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                          .*                                     |
  200000 ++ .**.       *.          .*  +   *.             *.*   .*.*. .**.*.|
         *.*    *.*.*.*  *.*.*.*.**     *.*  *. .*. *.*. +   + *     *      *
  100000 ++                                    *   *    *     *             |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#16.ttwu_count

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                 |
  1.4e+06 ++                                                           **.*.*
          |                                                            :    |
  1.2e+06 ++                                                           :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[16]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                     .*                            |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*  *.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#17.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           * .* |
          |                                                            :*   |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#17.sched_count

    3e+06 ++----------------------------------------------------------------*
          |                                                            *   +|
  2.5e+06 ++                                                           ::.* |
          |                                                            :*   |
          |                                                           :     |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#17.sched_goidle

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                 |
  1.4e+06 ++                                                           *   .*
          |                                                            ::.* |
  1.2e+06 ++                                                           :*   |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*. .*.**.*.*.*.**.*.*.* .*.*.*.**.*.*.*.**.*.*      |
          |               *                    *                            |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#17.avg_idle

   1e+06 O+O-O----O---OO-O-O---O--O-O-O-O-OO-O-O-O--O-O---O-O---------------+
  900000 ++   O     O        O   O                 O    O                   |
         |      O                                                           |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                                                              .*.|
  200000 ++      .*     .*. .*.   *. .*.              *.   .*.**.     .**   *
         *.*.**.*  + .**   *   *.*  *   *. *.*.*. .* +  *.*      *.*.*      |
  100000 ++         *                     *      *  *                       |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#17.ttwu_count

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                .*
  1.4e+06 ++                                                           **.* |
          |                                                            :    |
  1.2e+06 ++                                                           :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[17]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#18.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           **.* |
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                    *.          .*.          *.           :      |
   500000 *+*.**.*.*.**.*.*.*.*  *.*.*.**.*   **.*.*.*.*  *.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#18.sched_goidle

  1.4e+06 ++----------------------------------------------------------------*
          |                                                            **. +|
  1.2e+06 ++                                                           :  * |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                    *.          .*.          *.           :      |
   200000 *+*.**.*.*.**.*.*.*.*  *.*.*.**.*   **.*.*.*.*  *.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#18.avg_idle

   1e+06 O+O-OO-O-O---OO---O-O-O-OO---O-O-OO---O---OO---O-------------------+
  900000 ++         O                                 O   O O               |
         |               O          O        O   O                          |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                              *.                  |
  300000 ++  *                      *                  +  *                 |
  200000 ++ : :             .*. .* + +     *.*.   .*  *    +    .*. .*. *.*.|
         *. : *.*.*.   *.*.*   *  *   *.*.*    *.*  :+      *.**   *   *    *
  100000 ++*        *.*                             *                       |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#18.ttwu_count

  1.4e+06 ++----------------------------------------------------------------*
          |                                                            **.* |
  1.2e+06 ++                                                           :    |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[18]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#19.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 *
  2.5e+06 ++                                                           *   +|
          |                                                            :*.* |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |    *.                                                    :      |
   500000 *+*.*  *.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#19.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           * .* |
          |                                                            :*   |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |    *.                                                    :      |
   500000 *+*.*  *.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#19.sched_goidle

  1.4e+06 ++----------------------------------------------------------------*
          |                                                            *   +|
  1.2e+06 ++                                                           :*.* |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |    *.                                                    :      |
   200000 *+*.*  *.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#19.avg_idle

   1e+06 O+O-O--O-O-O-OO---O-O---O--O-O---OO-O-O-O--O-----O-O---------------+
  900000 ++   O          O     O  O     O          O  O O                   |
         |                                                                  |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                                                                 |
  200000 ++  **    .*. *.*.*.        .*.*. *.   .*.**.*. .*.    .*.   .**.*.*
         *. +  + .*   *      *.*.* .*     *  *.*        *   *.**   *.*      |
  100000 ++*    *                 *                                         |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#19.ttwu_count

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                 |
  1.4e+06 ++                                                           * .*.*
          |                                                            :*   |
  1.2e+06 ++                                                           :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*. *.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |          *                                                      |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[19]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#20.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           * .* |
          |                                                            :*   |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                  .*              .*.     :      |
   500000 *+*.**.*.*.**.*. .*.**.*.*.*.**.*.*  *.*.*.*.**.*.*   **.*.*      |
          |               *                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#20.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           **.* |
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                  .*              .*.     :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*  *.*.*.*.**.*.*   **.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#20.sched_goidle

  1.4e+06 ++----------------------------------------------------------------*
          |                                                            * .* |
  1.2e+06 ++                                                           :*   |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                  .*              .*.     :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*  *.*.*.*.**.*.*   **.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#20.avg_idle

   1e+06 O+O-OO-O---O--O-O-O---O--O-O-----OO-O-O-O-O----O-O-O---------------+
         |        O   O      O   O    O O           O O                     |
  900000 ++                                                                 |
  800000 ++                                                                 |
         |                                                                  |
  700000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                                                     .*          *
  200000 *+*.      .*     .*   *.     *.*.  .*.*.*.            *  :   .**. +|
         |   **.*.*  + *.*  + +  **. +    **       **.*.*.*.*.*   : .*    * |
  100000 ++-----------*------*------*------------------------------*--------+


                             sched_debug.cpu#20.ttwu_count

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                .*
  1.4e+06 ++                                                            *.* |
          |                                                            *    |
  1.2e+06 ++                                                           :    |
    1e+06 ++                                                           :    |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.* .*.*.*.**.*.*.*.**.*.*      |
          |                                    *                            |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[20]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#21.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           * .* |
          |                                                            :*   |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                     .*.                  :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**   *.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#21.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                            *   .*
  2.5e+06 ++                                                           :*.* |
          |                                                            :    |
          |                                                           :     |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                     .*.                  :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**   *.*.**.*.*.*.**.*.*      |
          |          O                                                      |
        0 O+O-OO-O-O--O-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#21.sched_goidle

  1.4e+06 ++----------------------------------------------------------------*
          |                                                            *   +|
  1.2e+06 ++                                                           :*.* |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                                     .*.                  :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**   *.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#21.avg_idle

   1e+06 ++--OO-O-O---OO-O-O-O-O-OO-O-O-O--O---O----O---O-O-----------------+
         |          O                     O  O   O O  O     O               |
  900000 O+                                                                 |
  800000 ++O                                                                |
         |                                                                  |
  700000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                                                             *.  |
  200000 ++   *    .*.  .*.                     .*.                 .*.*  *.*
         *.*.* + .*   **   *.*. .**.*.*. .**.*.*   **.   .*.   *.*.*        |
  100000 ++-----*--------------*--------*-------------*-*---*-*-------------+


                             sched_debug.cpu#21.ttwu_count

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                 |
  1.4e+06 ++                                                           **.*.*
          |                                                            :    |
  1.2e+06 ++                                                           :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[21]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#22.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           * .*.*
          |                                                            :*   |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |       .*.                                                :      |
   500000 *+*.**.*   **.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#22.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           **.* |
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |       .*.                                                :      |
   500000 *+*.**.*   **.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#22.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            * .*.*
  1.2e+06 ++                                                           :*   |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |       .*.                                                :      |
   200000 *+*.**.*   **.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#22.avg_idle

   1e+06 O+O------O-O-OO-----O-O-OO-O---O-OO-O-O-O-OO-O---O-----------------+
  900000 ++  OO O          O          O                 O   O               |
         |               O                                                  |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                                                      *      *. .*
  200000 ++*.*  *.   .**. .*.              *.     .**.   .*.*.* + +   .*  * |
         *    :+  *.*    *   *.*.**.*.*.*.*  *.*.*    *.*      *   *.*      |
  100000 ++   *                                                             |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#22.ttwu_count

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                 |
  1.4e+06 ++                                                           **.*.*
          |                                                            :    |
  1.2e+06 ++                                                           :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**. .*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                      *                                          |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[22]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#23.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           * .* |
          |                                                            :*   |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                       .*.                :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*   *.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#23.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           * .* |
          |                                                            :*   |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                       .*.                :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*   *.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#23.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            * .*.*
  1.2e+06 ++                                                           :*   |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |                     .*.               .*.                :      |
   200000 *+*.**.*.*.**.*.*.*.**   *.*.**.*.*.**.*   *.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#23.avg_idle

   1e+06 O+O-OO-O-O---OO-O-O-O-O-OO-O-O-O-OO-O-O-O-OO---O-------------------+
         |          O                                 O   O O               |
  900000 ++                                                                 |
  800000 ++                                                                 |
         |                                                                  |
  700000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                 .*
  300000 ++                                                              .* |
  200000 ++   *. .*     .*.      *   .*.*.                 .*.      .*. *   |
         *. .*  *  + .**   *.   + :.*     **. .*.*.**.*. .*   **.*.*   *    |
  100000 ++*--------*--------*-*--*----------*----------*-------------------+


                             sched_debug.cpu#23.ttwu_count

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                .*
  1.4e+06 ++                                                           * .* |
          |                                                            :*   |
  1.2e+06 ++                                                           :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                        sched_debug.cfs_rq[23]:/.min_vruntime

  1e+07 ++------------------------------------------------------------------+
  9e+06 O+    OO   O O O  O O O O O OO O O O O OO O O O O OO                |
        | O O    O       O                                                  |
  8e+06 ++                                                                  |
  7e+06 ++                                                                  |
        *.   .**.*.       *.          .*.                .*         .*      |
  6e+06 ++*.*      *.*.*.*  *.*.*.*.**   *.*.*.**.*.*.*.*  :.*.*.*.* :      |
  5e+06 ++                                                 *         :      |
  4e+06 ++                                                           :      |
        |                                                             :     |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[23]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                     .*                            |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*  *.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#24.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           * .*.*
          |                                                            :*   |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#24.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |                                                          :      |
   500000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#24.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            * .*.*
  1.2e+06 ++                                                           :*   |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |     .*.                        .*.                       :      |
   200000 *+*.**   *.**.*.*.*.**.*.*.*.**.*   **.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#24.avg_idle

   1e+06 O+O-OO-O-O---OO-O-O-O---O--O-O---OO-O-O-O--O-O-O-------------------+
  900000 ++         O          O  O     O          O      O O               |
         |                                                                  |
  800000 ++                                                                 |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++     *                    .*.     *.           *.             .*.|
  200000 ++    + + .*.*   .*. .*.   *   *.* +  *.*. *.*. +  *. *.*.     *   *
         *.*.**   *    *.*   *   * +       *       *    *     *    *.*.*    |
  100000 ++                       *                                         |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#24.ttwu_count

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                .*
  1.4e+06 ++                                                           **.* |
          |                                                            :    |
  1.2e+06 ++                                                           :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[24]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                        .*.                                        |
        *.*.*.**.*.*.*.*.**.*.*.*   **.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#25.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           * .* |
          |                                                            :*   |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |  .*                                          .*.         :      |
   500000 *+*  *.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**   *.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#25.sched_goidle

  1.4e+06 ++----------------------------------------------------------------*
          |                                                              .* |
  1.2e+06 ++                                                           **   |
          |                                                            :    |
    1e+06 ++                                                           :    |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |  .*                                          .*.         :      |
   200000 *+*  *.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**   *.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#25.avg_idle

   1e+06 O+O-OO-O-O---OO-------O--O---O-O-OO-O-O-O-OO-O-O-O-O---------------+
  900000 ++         O    O O        O                                       |
         |                                                                  |
  800000 ++                  O   O                                          |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++ .*                                                         * .*.|
  200000 ++* :  *.                *. .*.*. *. .*.*.             .*.   + *   *
         *    :+  *.*.**.*.*.*.*.*  *     *  *     **.*.*.*.*.**   *.*      |
  100000 ++   *                                                             |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#25.ttwu_count

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                .*
  1.4e+06 ++                                                           * .* |
          |                                                            :*   |
  1.2e+06 ++                                                           :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[25]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                        .*.                                        |
        *.*.*.**.*.*.*.*.**.*.*.*   **.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#26.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           * .*.*
          |                                                            :*   |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |     .*.                   .*                          .*.:      |
   500000 *+*.**   *.**.*.*.*.**.*.*.*  *.*.*.**.*.*.*.**.*.*.*.**   *      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#26.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                               *.*
  2.5e+06 ++                                                           * +  |
          |                                                            :*   |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          |     .*.                   .*                          .*.:      |
   500000 *+*.**   *.**.*.*.*.**.*.*.*  *.*.*.**.*.*.*.**.*.*.*.**   *      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#26.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                              .*.*
  1.2e+06 ++                                                           **   |
          |                                                            :    |
    1e+06 ++                                                           :    |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          |     .*.                   .*                          .*.:      |
   200000 *+*.**   *.**.*.*.*.**.*.*.*  *.*.*.**.*.*.*.**.*.*.*.**   *      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#26.avg_idle

   1e+06 O+--OO-O--------O-O-O-O-OO-O-O-O-OO-O-O-O-O--O-O-O-O---------------+
         | O      O O O                             O                       |
  900000 ++            O                                                    |
  800000 ++                                                                 |
         |                                                                  |
  700000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                  |
  300000 ++                                                                 |
  200000 *+    .*.*       .*   *.      .*.**.*.                     .*.* .*.|
         | *.**    + .**.*  + +  **. .*        *.   *.*.*.*.*.**.*.*    *   *
  100000 ++---------*--------*------*------------*-*------------------------+


                             sched_debug.cpu#26.ttwu_count

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                .*
  1.4e+06 ++                                                           * .* |
          |                                                            :*   |
  1.2e+06 ++                                                           :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+ .**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          | *                                                               |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[26]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                        .*.                                        |
        *.*.*.**.*.*.*.*.**.*.*.*   **.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                            sched_debug.cpu#27.nr_switches

    3e+06 ++----------------------------------------------------------------+
          |                                                                 |
  2.5e+06 ++                                                           **.*.*
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          *.                      .*.                 .*             :      |
   500000 ++*.**.*.*.**.*.*.*.**.*   *.**.*.*.**.*.*.*  *.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#27.sched_count

    3e+06 ++----------------------------------------------------------------+
          |                                                                .*
  2.5e+06 ++                                                           **.* |
          |                                                            :    |
          |                                                            :    |
    2e+06 ++                                                          :     |
          |                                                           :     |
  1.5e+06 ++                                                          :     |
          |                                                           :     |
    1e+06 ++                                                          :     |
          |                                                          :      |
          *.                      .*.   *.            .*             :      |
   500000 ++*.**.*.*.**.*.*.*.**.*   *.*  *.*.**.*.*.*  *.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                            sched_debug.cpu#27.sched_goidle

  1.4e+06 ++----------------------------------------------------------------+
          |                                                            * .*.*
  1.2e+06 ++                                                           :*   |
          |                                                            :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
          |                                                           :     |
   400000 ++                                                         :      |
          *.                      .*.                 .*             :      |
   200000 ++*.**.*.*.**.*.*.*.**.*   *.**.*.*.**.*.*.*  *.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                             sched_debug.cpu#27.avg_idle

   1e+06 O+O-OO-O-O---OO-O-O-O-O-OO-O-O---OO-O-O-O-OO-O-O-O-O---------------+
  900000 ++                             O                                   |
         |                                                                  |
  800000 ++         O                                                       |
  700000 ++                                                                 |
         |                                                                  |
  600000 ++                                                                 |
  500000 ++                                                                 |
  400000 ++                                                                 |
         |                                                                *.|
  300000 ++    .*                                                *       +  *
  200000 ++*. *  +          .*.*.    .*.     *.*.*.* .*.    *.  + +   .**   |
         *   *    *.*.**.*.*     * .*   *.* +       *   *. +  **   *.*      |
  100000 ++                       *        *              *                 |
       0 ++-----------------------------------------------------------------+


                             sched_debug.cpu#27.ttwu_count

  1.6e+06 ++----------------------------------------------------------------+
          |                                                                .*
  1.4e+06 ++                                                           **.* |
          |                                                            :    |
  1.2e+06 ++                                                           :    |
    1e+06 ++                                                          :     |
          |                                                           :     |
   800000 ++                                                          :     |
          |                                                           :     |
   600000 ++                                                          :     |
   400000 ++                                                         :      |
          |                                                          :      |
   200000 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 O+O-OO-O-O-OO-O-O-O-OO-O-O-O-OO-O-O-OO-O-O-O-OO-O-O---------------+


                      sched_debug.cfs_rq[27]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                        .*.                                        |
        *.*.*.**.*.*.*.*.**.*.*.*   **.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[28]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                         sched_debug.cfs_rq[29]:/.exec_clock

  180000 ++-----------------------------------------------------------------+
         O            OO       O  O O O O    O   O O    O   O               |
  160000 ++O OO O O O    O O O   O        OO   O    O O   O                 |
  140000 *+    .*.*.   *. .*.                   .*. *.   .*.        .*      |
         | *.**     *.*  *   *.*.**.*.*.*.**.*.*   *  *.*   *.**.*.* :      |
  120000 ++                                                          :      |
  100000 ++                                                           :     |
         |                                                            :     |
   80000 ++                                                           :     |
   60000 ++                                                           :     |
         |                                                            :     |
   40000 ++                                                            :    |
   20000 ++                                                            :    |
         |                                                             **.*.*
       0 ++-----------------------------------------------------------------+


                      sched_debug.cfs_rq[29]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[30]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                        sched_debug.cfs_rq[31]:/.min_vruntime

  1e+07 ++------------------------------------------------------------------+
  9e+06 O+    OO   O O O  O O O O O OO O O O O OO O O   O OO                |
        | O O    O       O                                                  |
  8e+06 ++                                            O                     |
  7e+06 ++                                                                  |
        |                                                                   |
  6e+06 *+ .*.**.*.*.*.*.    .*.*.   *.*. .*.*.**.*.*.   .**. .*.*.*.*      |
  5e+06 ++*              **.*     *.*    *            *.*    *       :      |
  4e+06 ++                                                           :      |
        |                                                            :      |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[31]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                        sched_debug.cfs_rq[32]:/.min_vruntime

  1e+07 ++--------------------O---O-----------------------------------------+
  9e+06 O+    OO   O O O  O         OO O O O   O  O   O O OO                |
        | O O    O       O  O   O            O  O   O                       |
  8e+06 ++                                                                  |
  7e+06 ++                                                                  |
        |                                                                   |
  6e+06 *+*. .**.*.   .*. *.*.*.*.*.**.*. .*.   *.*.*. .*.**.*. .*. .*      |
  5e+06 ++  *      *.*   *               *   *.*      *        *   * :      |
  4e+06 ++                                                           :      |
        |                                                            :      |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[32]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                         sched_debug.cfs_rq[33]:/.exec_clock

  180000 ++-----------------------------------------------------------------+
         O      O   O OO       O  O O O O          O    O   O               |
  160000 ++O OO   O      O O O   O        OO O O O  O O   O                 |
  140000 *+   *.*.*.      .*.          .*.      .*. *.   .*. .* .*. .*      |
         | *.*      *.**.*   *.*.**.*.*   **.*.*   *  *.*   *  *   * :      |
  120000 ++                                                          :      |
  100000 ++                                                           :     |
         |                                                            :     |
   80000 ++                                                           :     |
   60000 ++                                                           :     |
         |                                                            :     |
   40000 ++                                                            :    |
   20000 ++                                                            :    |
         |                                                             **.*.*
       0 ++-----------------------------------------------------------------+


                        sched_debug.cfs_rq[33]:/.min_vruntime

  1e+07 ++--------------------O---O-----------------------------------------+
  9e+06 O+    OO   O O O  O O   O   OO O          O O O O OO                |
        | O O    O       O               O O   O                            |
  8e+06 ++                                   O  O                           |
  7e+06 ++                                                                  |
        |                                                                   |
  6e+06 *+*.*.**.*. .*.*. *. .*.*.*. *.   .*.*.**. .*.*.*.**.*.*.*. .*      |
  5e+06 ++         *     *  *       *  *.*        *                * :      |
  4e+06 ++                                                           :      |
        |                                                            :      |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[33]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                         sched_debug.cfs_rq[34]:/.exec_clock

  180000 ++-----------------------------------------------------------------+
         O      O   O OO       O  O O O O          O    O   O               |
  160000 ++O OO   O      O O O   O        OO O O O  O O   O                 |
  140000 *+      .*.      .*.*.      .*.*.      .*. *.   .*. .* .*. .*      |
         | *.**.*   *.**.*     *.**.*     **.*.*   *  *.*   *  *   * :      |
  120000 ++                                                          :      |
  100000 ++                                                           :     |
         |                                                            :     |
   80000 ++                                                           :     |
   60000 ++                                                           :     |
         |                                                            :     |
   40000 ++                                                            :    |
   20000 ++                                                            :    |
         |                                                             **.*.*
       0 ++-----------------------------------------------------------------+


                        sched_debug.cfs_rq[34]:/.min_vruntime

  1e+07 ++--------------------O---O-----------------------------------------+
  9e+06 O+    OO   O O O  O O   O   OO O O O   O  O O O O OO                |
        | O O    O       O                                                  |
  8e+06 ++                                   O  O                           |
  7e+06 ++                                                                  |
        |                                                                   |
  6e+06 *+*.*.**.*.*.*.   *.*.*.     *.*.*. .*.**.*.*.   .**.*.*.*.*.       |
  5e+06 ++             *.*      *.*.*      *          *.*            *      |
  4e+06 ++                                                           :      |
        |                                                            :      |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[34]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                         sched_debug.cfs_rq[35]:/.exec_clock

  180000 ++-----------------------------------------------------------------+
         O      O     OO       O  O O O O    O   O O    O   O               |
  160000 ++O OO   O O    O O O   O        OO   O    O O   O                 |
  140000 *+   *.*.*.      .*.*.      .*.*.          *.   .*. .* .*. .*      |
         | *.*      *.**.*     *.**.*     **.*.*.*.*  *.*   *  *   * :      |
  120000 ++                                                          :      |
  100000 ++                                                           :     |
         |                                                            :     |
   80000 ++                                                           :     |
   60000 ++                                                           :     |
         |                                                            :     |
   40000 ++                                                            :    |
   20000 ++                                                            :    |
         |                                                             **.*.*
       0 ++-----------------------------------------------------------------+


                        sched_debug.cfs_rq[35]:/.min_vruntime

  1e+07 ++------------------------------------------------------------------+
  9e+06 O+    OO     O O  O O O O O OO O O O O OO O O O O OO                |
        | O O    O O     O                                                  |
  8e+06 ++                                                                  |
  7e+06 ++                                                                  |
        |                                                .*                 |
  6e+06 *+*. .**.*.*.*.*. *.*. .*.*.  .*.   .*. *. .*.*.*  :.*. .*. .*      |
  5e+06 ++  *            *    *     **   *.*   *  *        *   *   * :      |
  4e+06 ++                                                           :      |
        |                                                            :      |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[35]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                        .*.                                        |
        *.*.*.**.*.*.*.*.**.*.*.*   **.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                         sched_debug.cfs_rq[36]:/.exec_clock

  180000 ++-----------------------------------------------------------------+
         O      O   O OO       O  O O O O          O    O   O               |
  160000 ++O OO   O      O O O   O        OO O O O  O O   O                 |
  140000 *+   *.*.*.      .*.*.      .*.*. *.   .*. *.   .*.    .*. .*      |
         | *.*      *.**.*     *.**.*     *  *.*   *  *.*   *.**   * :      |
  120000 ++                                                          :      |
  100000 ++                                                           :     |
         |                                                            :     |
   80000 ++                                                           :     |
   60000 ++                                                           :     |
         |                                                            :     |
   40000 ++                                                            :    |
   20000 ++                                                            :    |
         |                                                             **.*.*
       0 ++-----------------------------------------------------------------+


                        sched_debug.cfs_rq[36]:/.min_vruntime

  1e+07 ++--------------------O---O-----------------------------------------+
  9e+06 O+    OO   O O O  O         OO O O O   O  O O O O OO                |
        | O O    O       O  O   O            O  O                           |
  8e+06 ++                                                                  |
  7e+06 ++                                                                  |
        |                                                           .*      |
  6e+06 *+ .*.**.*.*.     *.*.*.     *.*.*. .*.**. .*.*.*.**.*. .*.* :      |
  5e+06 ++*          *.*.*      *.*.*      *      *            *     :      |
  4e+06 ++                                                           :      |
        |                                                             :     |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[36]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                        .*.                                        |
        *.*.*.**.*.*.*.*.**.*.*.*   **.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                        sched_debug.cfs_rq[37]:/.min_vruntime

  1e+07 ++--------------------O---O-----------------------------------------+
  9e+06 O+    OO   O O O  O O   O   OO O O O O OO O O O O OO                |
        | O O    O       O                                                  |
  8e+06 ++                                                                  |
  7e+06 ++                                                                  |
        |                                                                   |
  6e+06 ++*.*.**.*.*.*.*. *.*.*. .*. *.   .*.*.**.*.   .*.**.*. .*. .*      |
  5e+06 *+               *      *   *  *.*          *.*        *   * :      |
  4e+06 ++                                                           :      |
        |                                                            :      |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[37]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                        .*.                                        |
        *.*.*.**.*.*.*.*.**.*.*.*   **.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[38]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[39]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[40]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[41]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                                                                   |
        *.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[42]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[43]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                         sched_debug.cfs_rq[44]:/.exec_clock

  180000 ++-----------------------------------------------------------------+
         O      O              O  O O O O          O    O   O               |
  160000 ++O OO   O O OO O O O   O        OO O O O  O O   O                 |
  140000 ++      .*.                                                        |
         *.*.**.*   *.**.*.*.*.*.**.*.*.*.**.*.*.*.**.*.*.*.*.**.*.*.*      |
  120000 ++                                                          :      |
  100000 ++                                                          :      |
         |                                                            :     |
   80000 ++                                                           :     |
   60000 ++                                                           :     |
         |                                                            :     |
   40000 ++                                                            :    |
   20000 ++                                                            :    |
         |                                                             **.*.*
       0 ++-----------------------------------------------------------------+


                      sched_debug.cfs_rq[44]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[45]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[46]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[47]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[48]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                         sched_debug.cfs_rq[49]:/.exec_clock

  180000 ++-----------------------------------------------------------------+
         O      O   O O        O  O O O O    O   O O    O   O               |
  160000 ++O OO   O    O O O O   O        OO   O    O O   O                 |
  140000 ++                                                                 |
         *.*.**.*.*.*.**.*.*.*.*.**.*.*.*.**.*.*.*.**.*.*.*.*.**.*.*.*      |
  120000 ++                                                          :      |
  100000 ++                                                          :      |
         |                                                            :     |
   80000 ++                                                           :     |
   60000 ++                                                           :     |
         |                                                            :     |
   40000 ++                                                            :    |
   20000 ++                                                            :    |
         |                                                             **.*.*
       0 ++-----------------------------------------------------------------+


                      sched_debug.cfs_rq[49]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[50]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                         sched_debug.cfs_rq[51]:/.exec_clock

  180000 ++-----------------------------------------------------------------+
         O      O   O OO       O  O O O O    O   O O    O   O               |
  160000 ++O OO   O      O O O   O        OO   O    O O   O                 |
  140000 ++                                         *.                      |
         *.*.**.*.*.*.**.*.*.*.*.**.*.*.*.**.*.*.*.*  *.*.*.*.**.*.*.*      |
  120000 ++                                                          :      |
  100000 ++                                                          :      |
         |                                                            :     |
   80000 ++                                                           :     |
   60000 ++                                                           :     |
         |                                                            :     |
   40000 ++                                                            :    |
   20000 ++                                                            :    |
         |                                                             **.*.*
       0 ++-----------------------------------------------------------------+


                        sched_debug.cfs_rq[51]:/.min_vruntime

  1e+07 O+--------------------O---O-----------------------------------------+
  9e+06 ++    OO   O O O  O O   O   OO O O O O OO O O O O OO                |
        | O O    O       O                                                  |
  8e+06 ++                                                                  |
  7e+06 ++                                                                  |
        |                                                                   |
  6e+06 *+*.*.**.*.       *. .*.*.*. *.*.*.     *. .*.   .*   .*.   .*      |
  5e+06 ++         *.*.*.*  *       *      *.*.*  *   *.*  :.*   *.* :      |
  4e+06 ++                                                 *         :      |
        |                                                            :      |
  3e+06 ++                                                            :     |
  2e+06 ++                                                            :     |
        |                                                             :     |
  1e+06 ++                                                            *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[51]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                      sched_debug.cfs_rq[52]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                         sched_debug.cfs_rq[53]:/.exec_clock

  180000 ++-----------------------------------------------------------------+
         O      O   O OO       O  O O   O    O   O O    O   O               |
  160000 ++O OO   O      O O O   O    O   OO   O    O O   O                 |
  140000 ++                                                                 |
         *.*.**.*.*.*.**.*.*.*.*.**.*.*.*.**.*.*.*.**.*.*.*.*.**.*.*.*      |
  120000 ++                                                          :      |
  100000 ++                                                          :      |
         |                                                            :     |
   80000 ++                                                           :     |
   60000 ++                                                           :     |
         |                                                            :     |
   40000 ++                                                            :    |
   20000 ++                                                            :    |
         |                                                             **.*.*
       0 ++-----------------------------------------------------------------+


                      sched_debug.cfs_rq[53]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                         sched_debug.cfs_rq[54]:/.exec_clock

  180000 ++-----------------------------------------------------------------+
         O      O   O OO       O  O   O O    O   O O    O   O               |
  160000 ++O OO   O      O O O   O  O     OO   O    O O   O                 |
  140000 ++                                                                 |
         *.*.**.*.*.*.**.*.*.*.*.**.*.*.*.**.*.*.*.**.*.*.*.*.**.*.*.*      |
  120000 ++                                                          :      |
  100000 ++                                                          :      |
         |                                                            :     |
   80000 ++                                                           :     |
   60000 ++                                                           :     |
         |                                                            :     |
   40000 ++                                                            :    |
   20000 ++                                                            :    |
         |                                                             **.*.*
       0 ++-----------------------------------------------------------------+


                   sched_debug.cfs_rq[54]:/.tg_runnable_contrib

  1000 ++---------------O----O---O------------------------------------------+
   900 O+O O OO O O O O   O O  O   O O O OO O O O O O OO O O                |
       |            *                                                       |
   800 ++ .*.*     + :     .* .*.*.         *. .*   *.**.*.                 |
   700 *+*    :.*.*  :   .*  *     *.*.*.* +  *  + +       *.*.*.*.*.*      |
       |      *       *.*                 *       *                  :      |
   600 ++                                                            :      |
   500 ++                                                            :      |
   400 ++                                                            :      |
       |                                                              :     |
   300 ++                                                             :     |
   200 ++                                                             :     |
       |                                                              :     |
   100 ++                                                             :     |
     0 ++-------------------------------------------------------------*-*-*-*


                      sched_debug.cfs_rq[54]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                   sched_debug.cfs_rq[54]:/.avg->runnable_avg_sum

  50000 ++------------------------------------------------------------------+
  45000 ++               O    O   O                                         |
        O O O OO O O O O  O O   O   OO O O O O OO O O O O OO                |
  40000 ++          .*                                                      |
  35000 ++ .*.*   .*  +    .*. .*.*.        .*. *. .*.*.*.*                 |
        *.*    *.*     *. *   *     **.*.*.*   *  *        *.*.*.*.*.*      |
  30000 ++               *                                           :      |
  25000 ++                                                           :      |
  20000 ++                                                           :      |
        |                                                            :      |
  15000 ++                                                            :     |
  10000 ++                                                            :     |
        |                                                             :     |
   5000 ++                                                            :     |
      0 ++------------------------------------------------------------*-*-*-*


                      sched_debug.cfs_rq[55]:/.tg->runnable_avg

  60000 ++------------------------------------------------------------------+
        |                O  O   O                   O     O                 |
  50000 O+O O OO O O O O  O   O   O OO O O O O OO O   O O  O                |
        |                      .*.                                          |
        *.*.*.**.*.*.*.*.**.*.*   *.**.*.*.*.*.**.*.*.*.*.**.*.*.*.*.*      |
  40000 ++                                                           :      |
        |                                                            :      |
  30000 ++                                                           :      |
        |                                                            :      |
  20000 ++                                                            :     |
        |                                                             :     |
        |                                                             :     |
  10000 ++                                                            :     |
        |                                                             *.*.*.*
      0 ++------------------------------------------------------------------+


                        numa-vmstat.node0.nr_isolated_file

  800 ++--------------------------------------------------------------------+
      |                                                              .*.*.*.*
  700 *+            .*.   .*.   *.     .*.*.   .*.* .*.*. .*.*.*. .**       |
      | *.*.*.**.*.*   *.*   *.*  *.*.*     *.*    *     *       *          |
  600 ++                                                                    |
      |                                                                     |
  500 ++                                                                    |
      |                                                                     |
  400 ++                                                                    |
      |                                                                     |
  300 ++                                                                    |
      |                                                                     |
  200 ++O   O  O O     O O          O     O O O O  O     O                  |
      O   O   O    O O     O O OO O   O O         O  O O   O                |
  100 ++--------------------------------------------------------------------+


                              numa-vmstat.node0.numa_hit

    4e+07 ++----------------------------------------------------------------+
          O                   OO O O      O             O                   |
  3.5e+07 ++   O O   OO O   O        O OO     O  O O O O  O O               |
          | O O    O      O                 O  O                            |
          |                                                                 |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
  1.5e+07 ++                                                          .**.*.*
          *.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
    1e+07 ++----------------------------------------------------------------+


                             numa-vmstat.node0.numa_local

    4e+07 ++----------------------------------------------------------------+
          O                   OO O O                    O                   |
  3.5e+07 ++   O O   OO O   O        O OO O   O  O O O O  O O               |
          | O O    O      O                 O  O                            |
          |                                                                 |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
  1.5e+07 ++                                                            *.*.*
          *.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.*    |
    1e+07 ++----------------------------------------------------------------+


                         numa-vmstat.node0.workingset_refault

  3.5e+07 ++----------------------------------------------------------------+
          O                                                                 |
    3e+07 ++         O        OO O O    O O             O                   |
          | O OO O O  O O O O        O O    O OO O O O O  O O               |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++                                                                |
          |                                                                 |
    1e+07 ++                                                                |
          |                                                           .**.*.*
    5e+06 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 ++----------------------------------------------------------------+


                         numa-vmstat.node0.workingset_activate

    2e+07 ++----------------------------------------------------------------+
          O                                             O                   |
  1.8e+07 ++     O   OO O     OO O O O OO O   O  O O      O O               |
  1.6e+07 ++O OO   O      O O               O  O     O O                    |
          |                                                                 |
  1.4e+07 ++                                                                |
  1.2e+07 ++                                                                |
          |                                                                 |
    1e+07 ++                                                                |
    8e+06 ++                                                                |
          |                                                                 |
    6e+06 ++                                                            *.*.*
    4e+06 ++                                                          .*    |
          *.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
    2e+06 ++----------------------------------------------------------------+


                        numa-vmstat.node1.nr_isolated_file

  800 ++--------------------------------------------------------------------+
      |                                               .*.     .*.      .*.*.*
  700 ++   .*. *.*. .*. .*.*.*. *.*.*.*.*.*.*.*.*.* .*   *.*.*   *.**.*     |
      *.*.*   *    *   *       *                   *                        |
  600 ++                                                                    |
      |                                                                     |
  500 ++                                                                    |
      |                                                                     |
  400 ++                                                                    |
      |                                                                     |
  300 ++                                                                    |
      |                                           O                         |
  200 ++  O O  O O   O O                O          O       O                |
      O O     O    O     O O O OO O O O   O O O O    O O O                  |
  100 ++--------------------------------------------------------------------+


                              numa-vmstat.node1.numa_hit

    4e+07 ++----------------------------------------------------------------+
          O          O         O   O    O               O                   |
  3.5e+07 ++   O O O  O O   O O  O   O O  O   O  O O O O  O O               |
          | O O           O                 O  O                            |
          |                                                                 |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
  1.5e+07 ++                                                          .**.*.*
          *.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
    1e+07 ++----------------------------------------------------------------+


                             numa-vmstat.node1.numa_local

    4e+07 ++----------------------------------------------------------------+
          O                    O   O    O               O                   |
  3.5e+07 ++   O O O OO O   O O  O   O O  O   O  O O O O  O O               |
          | O O           O                 O  O                            |
          |                                                                 |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
  1.5e+07 ++                                                           **.*.*
          *.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*. +     |
    1e+07 ++---------------------------------------------------------*------+


                         numa-vmstat.node1.workingset_refault

  3.5e+07 ++----------------------------------------------------------------+
          O                                                                 |
    3e+07 ++     O   OO       OO O O O  O O        O    O O                 |
          | O OO   O    O O O          O    O OO O   O O    O               |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++                                                                |
          |                                                                 |
    1e+07 ++                                                                |
          |                                                           .**.*.*
    5e+06 *+*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
          |                                                                 |
        0 ++----------------------------------------------------------------+


                         numa-vmstat.node1.workingset_activate

    2e+07 ++----------------------------------------------------------------+
          O                    O   O                    O                   |
  1.8e+07 ++     O   OO O     O  O   O OO O   O  O O O    O O               |
  1.6e+07 ++O OO   O      O O               O  O       O                    |
          |                                                                 |
  1.4e+07 ++                                                                |
  1.2e+07 ++                                                                |
          |                                                                 |
    1e+07 ++                                                                |
    8e+06 ++                                                                |
          |                                                                 |
    6e+06 ++                                                           **.*.*
    4e+06 ++                                                          +     |
          *.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*.**.*.*.*.**.*.*.*.**.*.*      |
    2e+06 ++----------------------------------------------------------------+


                                cpuidle.POLL.usage

  3000 ++-----------------*-------------------------------------------------+
       |      *.          :+              *            *.               *   |
  2500 *+  *. : *        :  *   .*.       :+           : *              ::  |
       |+ +  *   + .*.   :   *.*   *     :  *. .*.*.   :  + .*.*   *   : :  |
       | *        *   *.*           + .*.*    *     *.:    *    + + +  :  : |
  2000 ++                            *                *          *   * :  * |
       |                                                              :    +|
  1500 ++                                                             *     *
       |                                                                    |
  1000 ++                                                                   |
       |                                                                    |
       |                                                                    |
   500 ++                                                                   |
       |                                                                    |
     0 O+O-O-OO-O-O-O-O-O-O-OO-O-O-O-O-O-OO-O-O-O-O-O-OO-O-O----------------+


                     perf-profile.cpu-cycles.start_secondary

  20 ++---------------------------------------------------------------------+
  18 ++                                                               *     |
     |                                                                :+    |
  16 ++                                                               : *   |
  14 ++                                                               : :   |
     |                                                               :  :   |
  12 ++                                                              :   :  |
  10 ++                                                              :   :  |
   8 ++                                                              :   :  |
     |                                                               :   :  |
   6 ++                                                              :    : |
   4 ++                                                             :     :.*
     |                                                              :     * |
   2 ++         .*                                                  :       |
   0 O+O-O-O-O-O-OO-O-O-O-O-O-O-O-O-O-O-OO-O-O-O-O-O-O-O-O-O-*-**-*-*-------+


            perf-profile.cpu-cycles.cpu_startup_entry.start_secondary

  20 ++---------------------------------------------------------------------+
  18 ++                                                               *     |
     |                                                                :+    |
  16 ++                                                               : *   |
  14 ++                                                               : :   |
     |                                                               :  :   |
  12 ++                                                              :   :  |
  10 ++                                                              :   :  |
   8 ++                                                              :   :  |
     |                                                               :   :  |
   6 ++                                                              :    : |
   4 ++                                                             :     :.*
     |                                                              :     * |
   2 ++         .*                                                  :       |
   0 O+O-O-O-O-O-OO-O-O-O-O-O-O-O-O-O-O-OO-O-O-O-O-O-O-O-O-O-*-**-*-*-------+


     perf-profile.cpu-cycles.cpuidle_enter.cpu_startup_entry.start_secondary

  9 ++----------------------------------------------------------------------+
    |                                                                 *.    |
  8 ++                                                                : *   |
  7 ++                                                                : :   |
    |                                                                 : :   |
  6 ++                                                               :   :  |
  5 ++                                                               :   :  |
    |                                                                :   :  |
  4 ++                                                               :   :  |
  3 ++                                                               :    : |
    |                                                                :    :.*
  2 ++                                                              :     * |
  1 ++                                                              :       |
    *.*.       .*. .*.        .*.       .*.     .*.                .*       |
  0 O+O-O-O-O-O-O-O-O-OO-O-O-O-O-O-O-O-O-O-O-O-O-O-O-O-O-OO-*-*-*-*---------+


 	[*] bisect-good sample
	[O] bisect-bad  sample

To reproduce:

	apt-get install ruby ruby-oj
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
	cd lkp-tests
	bin/setup-local job.yaml # the job file attached in this email
	bin/run-local   job.yaml


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


Thanks,
Huang, Ying


--=-ZKO6uki1KEJ8APgjM/81
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"
Content-Transfer-Encoding: 7bit

---
testcase: vm-scalability
default_monitors:
  wait: pre-test
  uptime: 
  iostat: 
  vmstat: 
  numa-numastat: 
  numa-vmstat: 
  numa-meminfo: 
  proc-vmstat: 
  proc-stat: 
  meminfo: 
  slabinfo: 
  interrupts: 
  lock_stat: 
  latency_stats: 
  softirqs: 
  bdi_dev_mapping: 
  diskstats: 
  cpuidle: 
  cpufreq: 
  turbostat: 
  sched_debug:
    interval: 10
  pmeter: 
default_watchdogs:
  watch-oom: 
  watchdog: 
cpufreq_governor:
- performance
commit: 043256d059c2305637e18fe796ae6b0facc8be42
model: Grantley Haswell-EP
nr_cpu: 56
memory: 64G
hdd_partitions: 
swap_partitions: 
rootfs_partition: 
perf-profile: 
runtime: 300s
size: 
vm-scalability:
  test:
  - mmap-pread-rand
testbox: lkp-hsw01
tbox_group: lkp-hsw01
kconfig: x86_64-rhel
enqueue_time: 2014-12-19 22:00:31.103149663 +08:00
head_commit: 043256d059c2305637e18fe796ae6b0facc8be42
base_commit: b2776bf7149bddd1f4161f14f79520f17fc1d71d
branch: linux-devel/devel-hourly-2014121923
kernel: "/kernel/x86_64-rhel/043256d059c2305637e18fe796ae6b0facc8be42/vmlinuz-3.18.0-g043256d"
user: lkp
queue: cyclic
rootfs: debian-x86_64.cgz
result_root: "/result/lkp-hsw01/vm-scalability/performance-300s-mmap-pread-rand/debian-x86_64.cgz/x86_64-rhel/043256d059c2305637e18fe796ae6b0facc8be42/0"
job_file: "/lkp/scheduled/lkp-hsw01/cyclic_vm-scalability-performance-300s-mmap-pread-rand-x86_64-rhel-HEAD-043256d059c2305637e18fe796ae6b0facc8be42-0.yaml"
dequeue_time: 2014-12-20 00:04:59.188291064 +08:00
job_state: finished
loadavg: 29.90 33.82 16.51 1/451 10945
start_time: '1419005149'
end_time: '1419005486'
version: "/lkp/lkp/.src-20141219-090914"

--=-ZKO6uki1KEJ8APgjM/81
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce"
Content-Transfer-Encoding: 7bit

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu10/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu11/cpufreq/scaling_governor
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
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
mount -t tmpfs -o size=100% vm-scalability-tmp /tmp/vm-scalability-tmp
truncate -s 67406929920 /tmp/vm-scalability.img
mkfs.xfs -q /tmp/vm-scalability.img
mount -o loop /tmp/vm-scalability.img /tmp/vm-scalability
./case-mmap-pread-rand
truncate /tmp/vm-scalability/sparse-mmap-pread-rand -s 78536544841
./usemem --runtime 300 -n 56 -f /tmp/vm-scalability/sparse-mmap-pread-rand --readonly --random 78536544841
umount /tmp/vm-scalability-tmp
umount /tmp/vm-scalability
rm /tmp/vm-scalability.img

--=-ZKO6uki1KEJ8APgjM/81
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

_______________________________________________
LKP mailing list
LKP@linux.intel.com
=0D
--=-ZKO6uki1KEJ8APgjM/81--

