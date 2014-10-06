Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaJFFui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:50:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:26949 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbaJFFuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:50:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="395889396"
Date: Mon, 6 Oct 2014 13:50:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: [rcu] 5057f55e543:  dmesg.BUG:soft_lockup-CPU_stuck_for_s
Message-ID: <20141006055024.GD28732@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/unnNtmY43mpUSKx"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Paul,

FYI, we noticed a number of ups and downs for commit

5057f55e543b7859cfd26bc281291795eac93f8a ("rcu: Bind RCU grace-period kthreads if NO_HZ_FULL")

testbox/testcase/testparams: lkp-a04/netperf/300s-200%-SCTP_RR

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     %stddev        %change               %stddev
            \          |                 /
         3 ±12%    +145.5%          9 ±32%  sched_debug.cfs_rq[0]:/.nr_spread_over
      2438 ± 1%     +10.3%       2689 ± 2%  sched_debug.cpu#2.curr->pid
     21560 ± 5%     -24.1%      16358 ±14%  sched_debug.cpu#2.sched_goidle
     10790 ± 9%     +64.7%      17776 ± 8%  sched_debug.cpu#1.sched_goidle
     20210 ±20%     -25.9%      14968 ±11%  sched_debug.cpu#0.sched_goidle
     88244 ± 6%     -51.1%      43188 ± 6%  meminfo.DirectMap4k
      1689 ± 4%     +68.5%       2847 ±14%  cpuidle.C1E-ATM.usage
      2610 ± 3%      -9.9%       2353 ± 4%  sched_debug.cpu#3.curr->pid
     19071 ± 4%     -17.9%      15661 ± 1%  softirqs.SCHED

testbox/testcase/testparams: lkp-a04/netperf/300s-200%-SCTP_STREAM

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     21897 ±18%     -34.0%      14445 ± 4%  sched_debug.cfs_rq[2]:/.exec_clock
       115 ±10%     -14.1%         99 ± 9%  sched_debug.cfs_rq[2]:/.tg_runnable_contrib
     20231 ±13%     -16.2%      16951 ± 3%  sched_debug.cfs_rq[3]:/.exec_clock
      1.19 ±37%     -53.6%       0.55 ±30%  perf-profile.cpu-cycles.filemap_map_pages.do_read_fault.handle_mm_fault.__do_page_fault.do_page_fault
      5346 ±10%     -13.8%       4607 ± 9%  sched_debug.cfs_rq[2]:/.avg->runnable_avg_sum
       291 ±24%     -38.5%        179 ± 9%  sched_debug.cfs_rq[2]:/.load
      1.74 ±39%     -54.1%       0.80 ± 4%  perf-profile.cpu-cycles.__ctype_get_mb_cur_max
      0.81 ±39%     -43.4%       0.46 ±26%  perf-profile.cpu-cycles.unmap_page_range.unmap_single_vma.unmap_vmas.exit_mmap.mmput
        18 ± 5%     -18.2%         15 ±14%  sched_debug.cpu#0.cpu_load[4]
      0.89 ±33%     -51.5%       0.43 ±27%  perf-profile.cpu-cycles.menu_select.cpuidle_select.cpu_startup_entry.start_secondary
      1.29 ±23%     -47.0%       0.68 ±13%  perf-profile.cpu-cycles.intel_idle.cpuidle_enter_state.cpuidle_enter.cpu_startup_entry.rest_init
       314 ± 5%     -23.3%        241 ± 8%  sched_debug.cpu#2.load
   1119966 ±19%     -33.1%     748978 ± 7%  sched_debug.cpu#2.sched_count
       262 ±22%     -28.0%        189 ±34%  sched_debug.cfs_rq[0]:/.tg_load_contrib
       115 ± 7%     -15.6%         97 ± 4%  sched_debug.cfs_rq[0]:/.tg_runnable_contrib
      5341 ± 7%     -15.7%       4505 ± 4%  sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum
       488 ±13%     +16.7%        569 ±12%  sched_debug.cfs_rq[1]:/.load
        15 ±21%     +26.1%         19 ±19%  sched_debug.cfs_rq[3]:/.nr_spread_over
       472 ± 9%     +18.2%        558 ±12%  sched_debug.cpu#1.load
      1917 ± 9%     +19.1%       2284 ± 2%  sched_debug.cpu#1.curr->pid
     93022 ±12%     -47.0%      49332 ±12%  meminfo.DirectMap4k
        39 ±33%     -40.7%         23 ±27%  sched_debug.cfs_rq[2]:/.runnable_load_avg
    671451 ±14%     +52.9%    1026958 ±10%  sched_debug.cpu#1.sched_count
     43745 ± 3%     +16.6%      51000 ± 6%  sched_debug.cpu#1.nr_load_updates
      0.96 ±31%     -49.3%       0.49 ±34%  perf-profile.cpu-cycles.find_busiest_group.load_balance.pick_next_task_fair.__schedule.schedule
     64360 ±17%     +80.9%     116399 ±15%  sched_debug.cfs_rq[1]:/.min_vruntime
     36171 ± 6%     -27.8%      26101 ± 1%  softirqs.RCU
      1537 ± 0%     -20.1%       1228 ± 7%  cpuidle.C2-ATM.usage
     16404 ± 4%     +20.9%      19837 ± 2%  sched_debug.cfs_rq[0]:/.exec_clock
    143516 ±23%     -34.7%      93764 ±12%  sched_debug.cfs_rq[2]:/.min_vruntime
      1198 ± 3%     -14.8%       1021 ± 7%  cpuidle.C4-ATM.usage
     42206 ± 2%     -17.8%      34709 ± 3%  sched_debug.cpu#3.nr_load_updates
        10 ± 4%     +41.9%         14 ± 8%  sched_debug.cfs_rq[2]:/.nr_spread_over
      1788 ± 8%     -21.7%       1399 ±19%  sched_debug.cpu#3.curr->pid
     43004 ±10%     -25.3%      32112 ± 5%  sched_debug.cpu#2.nr_load_updates
     28737 ± 1%     -18.2%      23511 ± 3%  softirqs.SCHED
       881 ± 0%     +14.3%       1007 ± 8%  slabinfo.kmalloc-96.active_objs
       881 ± 0%     +14.3%       1007 ± 8%  slabinfo.kmalloc-96.num_objs
      1.10 ±10%     -24.3%       0.83 ±18%  perf-profile.cpu-cycles.copy_user_generic_string.skb_copy_datagram_iovec.sctp_recvmsg.sock_common_recvmsg.sock_recvmsg
      2717 ±18%     +27.9%       3474 ± 7%  slabinfo.anon_vma.active_objs
      2862 ±10%     +21.4%       3474 ± 7%  slabinfo.anon_vma.num_objs

testbox/testcase/testparams: lkp-a04/netperf/900s-200%-TCP_STREAM

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
         7 ±11%     +47.6%         10 ±12%  sched_debug.cfs_rq[1]:/.nr_spread_over
      2830 ± 7%     +11.0%       3142 ± 2%  sched_debug.cpu#0.curr->pid
    511581 ±12%     +28.0%     654949 ± 4%  sched_debug.cpu#0.avg_idle
       309 ± 7%     +20.3%        372 ±10%  sched_debug.cfs_rq[3]:/.blocked_load_avg
    669223 ±10%     +20.7%     808043 ±12%  sched_debug.cfs_rq[1]:/.MIN_vruntime
    669224 ±10%     +20.7%     808044 ±12%  sched_debug.cfs_rq[1]:/.max_vruntime
   1005242 ± 7%     -23.6%     767543 ±17%  sched_debug.cpu#0.sched_count
    187491 ± 8%     -15.6%     158259 ±10%  cpuidle.C1E-ATM.time
    476437 ± 4%     -38.5%     293130 ±23%  sched_debug.cpu#0.ttwu_local
       507 ± 7%     -11.0%        451 ± 3%  sched_debug.cpu#2.load
    667256 ±11%     +39.5%     931026 ±21%  sched_debug.cpu#2.sched_count
    939243 ± 3%     -31.0%     648447 ±16%  sched_debug.cpu#0.nr_switches
    311196 ± 2%     +39.4%     433868 ±20%  sched_debug.cpu#3.ttwu_count
    599407 ± 4%     +38.6%     830893 ±16%  sched_debug.cpu#3.sched_count
    569241 ± 0%     +38.8%     789955 ±19%  sched_debug.cpu#2.nr_switches
     14160 ± 9%     +31.6%      18630 ± 3%  sched_debug.cpu#2.sched_goidle
      2007 ± 0%     +90.3%       3820 ± 7%  meminfo.AnonHugePages
    544571 ± 4%     -31.9%     370869 ±17%  sched_debug.cpu#0.ttwu_count
      3536 ± 8%     -14.8%       3013 ± 6%  sched_debug.cpu#1.curr->pid
     26536 ± 2%     -38.5%      16313 ± 8%  sched_debug.cpu#0.sched_goidle
     59574 ±27%     -39.0%      36314 ±27%  cpuidle.C2-ATM.time
    951369 ± 6%     -17.7%     782526 ±18%  sched_debug.cpu#1.sched_count
       162 ±30%     -43.4%         92 ±23%  cpuidle.C2-ATM.usage
        10 ± 8%     +20.0%         12 ± 6%  sched_debug.cfs_rq[2]:/.nr_spread_over
       858 ± 3%     +10.6%        949 ± 3%  slabinfo.buffer_head.active_objs
       858 ± 3%     +10.6%        949 ± 3%  slabinfo.buffer_head.num_objs
       868 ± 4%     +16.1%       1008 ± 3%  slabinfo.kmalloc-96.active_objs
       868 ± 4%     +16.1%       1008 ± 3%  slabinfo.kmalloc-96.num_objs
   1209498 ± 1%      -6.5%    1131376 ± 1%  time.involuntary_context_switches
      5138 ± 1%      -2.5%       5011 ± 0%  vmstat.system.cs

testbox/testcase/testparams: lkp-a04/netperf/900s-200%-TCP_MAERTS

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    665275 ± 5%     -14.5%     569138 ± 9%  sched_debug.cpu#3.avg_idle
     20642 ± 6%     -56.4%       9003 ±40%  sched_debug.cpu#3.sched_goidle
    195414 ± 1%     -31.4%     134127 ±33%  cpuidle.C1E-ATM.time
     23091 ±16%     -40.2%      13807 ±30%  sched_debug.cpu#2.sched_goidle
     11208 ± 6%     +77.5%      19895 ±14%  sched_debug.cpu#1.sched_goidle
      3459 ± 5%     -11.9%       3047 ± 4%  sched_debug.cpu#1.curr->pid
     13303 ±18%     +56.5%      20817 ±26%  sched_debug.cpu#0.sched_goidle
      4409 ± 1%     -32.9%       2958 ±31%  cpuidle.C1E-ATM.usage
     32560 ±43%     +91.7%      62409 ± 3%  cpuidle.C4-ATM.time
        45 ±25%     +92.7%         88 ±17%  cpuidle.C4-ATM.usage
      3125 ± 1%     +20.9%       3779 ± 7%  sched_debug.cpu#3.curr->pid
      1716 ± 3%     +10.8%       1901 ± 7%  slabinfo.kmalloc-192.active_objs
    306953 ± 4%     -23.3%     235502 ±20%  cpuidle.C6-ATM.time
      1.97 ± 1%     +10.1%       2.17 ± 1%  perf-profile.cpu-cycles.tcp_sendmsg.inet_sendmsg.sock_sendmsg.SYSC_sendto.sys_sendto

testbox/testcase/testparams: lkp-a04/netperf/300s-200%-10K-SCTP_STREAM_MANY

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
      0.90 ±27%     +67.8%       1.51 ±31%  sched_debug.cfs_rq[3]:/.spread
       395 ± 9%     +24.2%        491 ± 3%  sched_debug.cfs_rq[3]:/.runnable_load_avg
      2.00 ±28%     -48.7%       1.03 ±17%  sched_debug.cfs_rq[0]:/.spread
       866 ± 8%     -20.1%        692 ±12%  sched_debug.cpu#2.load
    346856 ± 5%     +36.3%     472836 ±13%  sched_debug.cpu#1.avg_idle
     76913 ±19%     -30.7%      53329 ±12%  sched_debug.cpu#0.sched_goidle
     87561 ±33%     -44.4%      48649 ±22%  meminfo.DirectMap4k
    825954 ± 2%     +14.6%     946706 ± 8%  sched_debug.cpu#1.sched_count
    327181 ± 1%      +9.7%     358887 ± 2%  sched_debug.cfs_rq[1]:/.min_vruntime
    335128 ± 3%      +9.1%     365583 ± 4%  sched_debug.cfs_rq[0]:/.min_vruntime
     77300 ±37%     +50.5%     116358 ±18%  sched_debug.cfs_rq[3]:/.MIN_vruntime
     77301 ±37%     +50.5%     116359 ±18%  sched_debug.cfs_rq[3]:/.max_vruntime
       572 ± 9%     +31.3%        751 ± 4%  sched_debug.cfs_rq[3]:/.load
     16994 ± 0%      -1.7%      16710 ± 1%  vmstat.system.cs

testbox/testcase/testparams: lkp-snb01/hackbench/1600%-process-pipe

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    156776 ± 1%      +2.9%     161328 ± 0%  hackbench.throughput
2333181.35 ±11%    -100.0%       0.00 ± 0%  sched_debug.cfs_rq[20]:/.max_vruntime
2333181.35 ±11%    -100.0%       0.00 ± 0%  sched_debug.cfs_rq[20]:/.MIN_vruntime
      1852 ±34%     -47.3%        977 ±40%  numa-vmstat.node1.nr_inactive_anon
      7403 ±34%     -46.5%       3958 ±39%  numa-meminfo.node1.Inactive(anon)
      1134 ±27%     +93.9%       2199 ±39%  sched_debug.cfs_rq[21]:/.nr_spread_over
     12900 ±20%     +25.5%      16194 ± 9%  numa-meminfo.node0.Inactive(anon)
      3230 ±20%     +24.1%       4008 ± 8%  numa-vmstat.node0.nr_inactive_anon
        58 ±14%     -38.1%         36 ±16%  sched_debug.cpu#12.load
        51 ± 0%     -24.7%         38 ±19%  sched_debug.cpu#12.cpu_load[1]
        52 ± 2%     -23.7%         39 ±18%  sched_debug.cpu#12.cpu_load[2]
        43 ± 3%     -19.4%         34 ±18%  sched_debug.cfs_rq[12]:/.runnable_load_avg
        57 ±19%     -37.6%         36 ±21%  sched_debug.cpu#26.load
        17 ±13%     +81.1%         32 ±24%  sched_debug.cfs_rq[4]:/.load
       863 ± 3%     +16.3%       1004 ± 7%  sched_debug.cfs_rq[5]:/.tg_load_contrib
        31 ±13%     +87.2%         58 ± 9%  sched_debug.cpu#17.cpu_load[1]
        30 ±12%     +67.0%         50 ± 9%  sched_debug.cpu#17.cpu_load[2]
       834 ± 8%     +22.7%       1023 ±14%  sched_debug.cfs_rq[25]:/.blocked_load_avg
        51 ± 9%     -14.8%         44 ± 8%  sched_debug.cpu#27.cpu_load[1]
        52 ± 3%     -14.6%         44 ±12%  sched_debug.cpu#14.cpu_load[2]
        51 ± 3%     -20.9%         40 ±17%  sched_debug.cpu#12.cpu_load[3]
        53 ± 3%     -20.6%         42 ±10%  sched_debug.cpu#27.cpu_load[4]
        49 ± 3%     -18.4%         40 ±16%  sched_debug.cpu#12.cpu_load[4]
        43 ± 2%     -19.2%         35 ±16%  sched_debug.cfs_rq[14]:/.runnable_load_avg
       878 ± 8%     +21.7%       1069 ±12%  sched_debug.cfs_rq[25]:/.tg_load_contrib
        58 ±14%     -31.0%         40 ±14%  sched_debug.cpu#14.load
        56 ±23%     -36.1%         36 ±19%  sched_debug.cfs_rq[26]:/.load
       825 ±10%     +25.1%       1032 ±10%  sched_debug.cfs_rq[4]:/.tg_load_contrib
        18 ± 5%    +134.5%         43 ±21%  sched_debug.cfs_rq[17]:/.runnable_load_avg
       846 ± 3%     +15.8%        979 ± 7%  sched_debug.cfs_rq[5]:/.blocked_load_avg
        17 ± 9%     +45.1%         24 ±26%  sched_debug.cfs_rq[0]:/.load
        52 ± 2%     -19.6%         42 ±13%  sched_debug.cpu#27.cpu_load[2]
        16 ± 5%     +43.8%         23 ±28%  sched_debug.cfs_rq[3]:/.runnable_load_avg
        54 ± 1%     -22.2%         42 ±11%  sched_debug.cpu#27.cpu_load[3]
        50 ± 3%     -20.4%         40 ±16%  sched_debug.cfs_rq[14]:/.load
        44 ± 2%     -21.6%         35 ±16%  sched_debug.cfs_rq[11]:/.runnable_load_avg
     20084 ± 4%     -10.7%      17926 ± 6%  sched_debug.cpu#5.curr->pid
      1013 ±13%     +22.7%       1242 ±10%  sched_debug.cfs_rq[7]:/.tg_load_contrib
        47 ±21%     -32.2%         32 ±22%  sched_debug.cpu#27.load
        28 ±11%     +60.5%         46 ± 9%  sched_debug.cpu#17.cpu_load[3]
        19 ±37%     +42.1%         27 ±26%  sched_debug.cpu#0.cpu_load[2]
        16 ± 8%     +60.4%         25 ±25%  sched_debug.cpu#1.cpu_load[2]
  39420050 ± 4%     -12.6%   34437873 ± 5%  sched_debug.cpu#9.ttwu_count
        15 ± 9%     +46.7%         22 ±29%  sched_debug.cfs_rq[0]:/.runnable_load_avg
     21495 ± 6%     -15.4%      18194 ± 5%  sched_debug.cpu#10.curr->pid
        18 ±24%     +44.4%         26 ±23%  sched_debug.cpu#0.cpu_load[3]
      1118 ± 7%     +22.3%       1367 ± 9%  sched_debug.cfs_rq[20]:/.blocked_load_avg
        47 ± 6%     -27.7%         34 ±26%  sched_debug.cpu#25.load
      4513 ±10%     +63.0%       7356 ±40%  numa-vmstat.node0.nr_kernel_stack
        16 ± 8%     +43.8%         23 ±28%  sched_debug.cfs_rq[5]:/.runnable_load_avg
        37 ± 8%     -23.2%         28 ±14%  sched_debug.cfs_rq[30]:/.runnable_load_avg
      2002 ± 4%     -92.2%        157 ± 8%  cpuidle.POLL.usage
    286004 ±22%     +91.0%     546269 ±29%  sched_debug.cpu#2.avg_idle
    266606 ± 8%     +57.9%     421009 ±31%  sched_debug.cpu#3.avg_idle
        16 ±10%     +48.0%         24 ±26%  sched_debug.cpu#1.cpu_load[3]
     10084 ± 1%     -12.5%       8827 ± 1%  proc-vmstat.pgactivate
       993 ±13%     +22.6%       1217 ±10%  sched_debug.cfs_rq[7]:/.blocked_load_avg
  33083232 ± 2%      -6.6%   30915131 ± 4%  sched_debug.cpu#11.ttwu_count
        44 ± 5%     -22.4%         34 ±15%  sched_debug.cfs_rq[10]:/.runnable_load_avg
        27 ±20%     +36.6%         37 ±12%  sched_debug.cpu#18.cpu_load[2]
   9531695 ±11%     +43.5%   13678188 ±28%  proc-vmstat.pgalloc_dma32
        39 ± 3%     -24.8%         29 ±19%  sched_debug.cfs_rq[26]:/.runnable_load_avg
    937152 ±12%     +66.6%    1561391 ± 6%  cpuidle.C3-SNB.time
        17 ±17%     +49.0%         25 ±22%  sched_debug.cpu#0.cpu_load[4]
        16 ±11%     +49.0%         24 ±25%  sched_debug.cpu#5.cpu_load[0]
        15 ±10%     +63.8%         25 ±25%  sched_debug.cpu#1.cpu_load[1]
        17 ± 8%     +43.1%         24 ±28%  sched_debug.cpu#1.cpu_load[4]
        46 ± 8%     -27.3%         33 ±28%  sched_debug.cfs_rq[25]:/.load
        71 ±10%     -27.1%         52 ±29%  sched_debug.cpu#15.cpu_load[0]
     17408 ± 3%     -14.0%      14970 ± 2%  sched_debug.cpu#28.curr->pid
        41 ± 9%     -22.8%         31 ±15%  sched_debug.cfs_rq[28]:/.runnable_load_avg
        16 ±11%     +65.3%         27 ±37%  sched_debug.cpu#5.cpu_load[1]
        45 ±11%     -26.7%         33 ± 7%  sched_debug.cfs_rq[28]:/.load
        51 ± 5%     -23.2%         39 ±19%  sched_debug.cfs_rq[10]:/.load
        53 ±10%     -21.1%         42 ± 6%  sched_debug.cpu#10.cpu_load[3]
        49 ±10%     +34.0%         65 ±16%  sched_debug.cpu#25.cpu_load[0]
        45 ±11%     -27.2%         33 ± 9%  sched_debug.cpu#28.load
        54 ±18%     -33.1%         36 ±16%  sched_debug.cpu#9.load
        50 ± 7%     -19.7%         40 ± 9%  sched_debug.cpu#10.cpu_load[4]
      1153 ± 8%     +21.0%       1396 ± 9%  sched_debug.cfs_rq[20]:/.tg_load_contrib
        42 ± 5%     -20.5%         33 ±16%  sched_debug.cfs_rq[15]:/.runnable_load_avg
     17980 ± 5%     -18.3%      14689 ±10%  sched_debug.cpu#26.curr->pid
        15 ± 9%     +53.3%         23 ±22%  sched_debug.cfs_rq[21]:/.load
        17 ± 8%     +56.9%         26 ±38%  sched_debug.cpu#5.cpu_load[2]
        15 ±10%     +44.7%         22 ±29%  sched_debug.cpu#1.cpu_load[0]
         1 ± 0%    +133.3%          2 ±20%  sched_debug.cfs_rq[11]:/.nr_spread_over
        56 ± 6%     -14.3%         48 ±12%  sched_debug.cpu#15.cpu_load[3]
        18 ± 7%     +46.3%         26 ±36%  sched_debug.cpu#5.cpu_load[3]
        16 ± 2%     +42.0%         23 ±24%  sched_debug.cpu#3.cpu_load[0]
        65 ± 2%     -19.8%         52 ±14%  sched_debug.cpu#15.cpu_load[1]
        52 ± 6%     -14.6%         45 ±12%  sched_debug.cpu#15.cpu_load[4]
        55 ± 2%     -12.1%         48 ± 7%  sched_debug.cpu#11.load
        18 ± 7%     +42.6%         25 ±34%  sched_debug.cpu#5.cpu_load[4]
      0.47 ± 8%    +101.4%       0.95 ±17%  perf-profile.cpu-cycles._raw_spin_lock.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common
        15 ±10%     +44.7%         22 ±29%  sched_debug.cfs_rq[1]:/.runnable_load_avg
        50 ± 6%     -21.1%         40 ±17%  sched_debug.cpu#10.load
        26 ± 9%     +57.5%         42 ±10%  sched_debug.cpu#17.cpu_load[4]
        60 ± 3%     -14.9%         51 ± 8%  sched_debug.cpu#15.cpu_load[2]
      1170 ± 7%     -21.7%        916 ±21%  sched_debug.cfs_rq[28]:/.blocked_load_avg
        18 ±12%     +88.9%         34 ±43%  sched_debug.cpu#6.load
        18 ±10%     +34.5%         24 ±21%  sched_debug.cpu#3.cpu_load[3]
        25 ± 9%     +34.7%         33 ±19%  sched_debug.cpu#18.cpu_load[4]
      1216 ± 7%     -21.8%        950 ±20%  sched_debug.cfs_rq[28]:/.tg_load_contrib
        26 ±12%     +35.4%         35 ±14%  sched_debug.cpu#18.cpu_load[3]
  48104532 ±11%     +45.0%   69756781 ±28%  numa-numastat.node0.local_node
  48104551 ±11%     +45.0%   69758195 ±28%  numa-numastat.node0.numa_hit
        20 ±33%     +54.1%         31 ±22%  sched_debug.cpu#6.cpu_load[1]
       808 ±10%     +24.6%       1007 ±12%  sched_debug.cfs_rq[4]:/.blocked_load_avg
        48 ± 2%     -14.4%         41 ± 9%  sched_debug.cpu#8.cpu_load[4]
        14 ±17%     +51.2%         21 ±27%  sched_debug.cfs_rq[16]:/.runnable_load_avg
        27 ±26%    +165.9%         72 ±16%  sched_debug.cpu#17.cpu_load[0]
      3.41 ± 0%     +12.9%       3.85 ± 2%  turbostat.%c7
     15630 ± 2%     -18.4%      12759 ±23%  numa-vmstat.node1.nr_kernel_stack
    267232 ± 8%    +105.7%     549732 ±37%  sched_debug.cpu#6.avg_idle
    247641 ±18%     +56.4%     387298 ±22%  sched_debug.cpu#5.avg_idle
 1.685e+08 ± 6%     -14.4%  1.442e+08 ± 4%  cpuidle.C1-SNB.time
      0.79 ± 4%     +54.4%       1.22 ±13%  perf-profile.cpu-cycles._raw_spin_lock_irqsave.__wake_up_sync_key.pipe_write.do_sync_write.vfs_write
        18 ± 6%     +34.5%         24 ±24%  sched_debug.cpu#3.cpu_load[4]
        44 ± 4%     -16.7%         36 ± 9%  sched_debug.cfs_rq[8]:/.runnable_load_avg
        47 ± 4%     -14.0%         41 ± 8%  sched_debug.cpu#9.cpu_load[4]
      0.98 ± 3%     -43.9%       0.55 ±33%  perf-profile.cpu-cycles.llist_add_batch.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common
        45 ± 3%     -22.8%         35 ±12%  sched_debug.cfs_rq[9]:/.runnable_load_avg
        19 ±20%     +50.0%         29 ±25%  sched_debug.cpu#6.cpu_load[2]
    270052 ±19%    +109.1%     564602 ±40%  sched_debug.cpu#7.avg_idle
        16 ±10%     +50.0%         25 ±24%  sched_debug.cfs_rq[6]:/.runnable_load_avg
        18 ±13%     +42.9%         26 ±22%  sched_debug.cfs_rq[6]:/.load
      1.27 ± 3%     -43.5%       0.72 ±35%  perf-profile.cpu-cycles.enqueue_task_fair.enqueue_task.activate_task.ttwu_do_activate.sched_ttwu_pending
        79 ±13%     +50.6%        119 ±34%  sched_debug.cpu#0.nr_running
    316918 ±22%     +46.5%     464434 ±19%  sched_debug.cpu#18.avg_idle
        17 ±10%     +48.1%         25 ±17%  sched_debug.cpu#3.cpu_load[1]
       284 ± 5%     -29.3%        200 ±23%  sched_debug.cpu#11.nr_running
       271 ± 5%     -30.1%        189 ±19%  sched_debug.cpu#15.nr_running
        51 ±23%     -38.7%         31 ± 6%  sched_debug.cfs_rq[31]:/.load
        51 ±22%     -38.6%         31 ±13%  sched_debug.cpu#31.load
    274345 ± 8%     +44.0%     395193 ±18%  sched_debug.cpu#19.avg_idle
        19 ±10%     +39.7%         27 ±26%  sched_debug.cpu#6.cpu_load[4]
       232 ± 9%     -22.6%        180 ±20%  sched_debug.cpu#31.nr_running
       362 ± 8%     +35.3%        490 ± 6%  slabinfo.kmem_cache.active_objs
       362 ± 8%     +35.3%        490 ± 6%  slabinfo.kmem_cache.num_objs
       230 ± 5%     -23.8%        175 ±19%  sched_debug.cpu#28.nr_running
     16860 ± 1%     -21.6%      13224 ± 8%  sched_debug.cpu#23.curr->pid
        19 ±12%     +42.4%         28 ±25%  sched_debug.cpu#6.cpu_load[3]
    297114 ± 8%     +44.6%     429601 ±16%  sched_debug.cpu#16.avg_idle
       673 ± 7%     -21.3%        530 ±10%  slabinfo.blkdev_requests.active_objs
       673 ± 7%     -21.3%        530 ±10%  slabinfo.blkdev_requests.num_objs
       277 ± 6%     -32.1%        188 ±21%  sched_debug.cpu#10.nr_running
       362 ±34%     -43.9%        203 ±19%  sched_debug.cpu#13.nr_running
       249 ± 3%     -34.7%        162 ±22%  sched_debug.cpu#25.nr_running
        18 ±12%     +40.7%         25 ±18%  sched_debug.cpu#3.cpu_load[2]
       236 ± 5%     -26.1%        174 ±24%  sched_debug.cpu#27.nr_running
       234 ± 7%     -25.0%        176 ±22%  sched_debug.cpu#24.nr_running
        51 ±16%     -42.5%         29 ±17%  sched_debug.cpu#29.load
      1.00 ± 4%     -36.0%       0.64 ±29%  perf-profile.cpu-cycles.mutex_lock.pipe_wait.pipe_read.do_sync_read.vfs_read
    882415 ±14%     -27.3%     641860 ±21%  sched_debug.cpu#9.avg_idle
      1.93 ± 5%     -34.0%       1.28 ±24%  perf-profile.cpu-cycles.effective_load.isra.38.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function
      2.21 ± 5%     -11.3%       1.96 ± 4%  turbostat.%c1
        60 ±16%     -34.8%         39 ±18%  sched_debug.cfs_rq[11]:/.load
        57 ±14%     -32.2%         38 ±17%  sched_debug.cfs_rq[13]:/.load
       281 ± 1%     -31.4%        192 ±18%  sched_debug.cpu#12.nr_running
      3.91 ± 3%     -30.0%       2.73 ±20%  perf-profile.cpu-cycles.idle_cpu.select_task_rq_fair.try_to_wake_up.default_wake_function.autoremove_wake_function
    101299 ± 2%     -17.5%      83592 ±20%  numa-vmstat.node1.nr_slab_unreclaimable
       471 ± 6%     +27.1%        599 ± 5%  slabinfo.kmem_cache_node.active_objs
       742 ± 7%     -20.8%        588 ±10%  slabinfo.xfs_buf.num_objs
       742 ± 7%     -20.8%        588 ±10%  slabinfo.xfs_buf.active_objs
       280 ± 7%     -26.4%        206 ±20%  sched_debug.cpu#14.nr_running
       490 ± 6%     +26.1%        618 ± 4%  slabinfo.kmem_cache_node.num_objs
       235 ± 6%     -27.4%        171 ±21%  sched_debug.cpu#26.nr_running
        64 ± 7%     +58.8%        102 ±38%  sched_debug.cpu#23.nr_running
     17597 ± 5%     -21.9%      13742 ± 5%  sched_debug.cpu#29.curr->pid
      1.53 ± 3%     +36.5%       2.09 ±15%  perf-profile.cpu-cycles.copy_user_generic_string.pipe_write.do_sync_write.vfs_write.sys_write
        43 ± 9%     -31.0%         29 ±20%  sched_debug.cfs_rq[29]:/.load
      0.79 ± 5%     +34.2%       1.06 ±12%  perf-profile.cpu-cycles.vfs_read.sys_read.system_call_fastpath.__read_nocancel
      1.61 ± 2%     -33.3%       1.08 ±23%  perf-profile.cpu-cycles.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
        39 ± 5%     -29.9%         27 ±22%  sched_debug.cfs_rq[29]:/.runnable_load_avg
      0.77 ± 8%     +28.3%       0.98 ±13%  perf-profile.cpu-cycles.selinux_file_permission.security_file_permission.rw_verify_area.vfs_read.sys_read
        48 ±20%     -34.9%         31 ±14%  sched_debug.cfs_rq[24]:/.runnable_load_avg
    155404 ± 0%     +18.9%     184780 ± 0%  softirqs.SCHED
      3.37 ± 1%     -20.6%       2.68 ± 6%  perf-profile.cpu-cycles.mutex_unlock.do_sync_write.vfs_write.sys_write.system_call_fastpath
      0.71 ±10%     +41.3%       1.00 ±18%  perf-profile.cpu-cycles.selinux_file_permission.security_file_permission.rw_verify_area.vfs_write.sys_write
       288 ± 7%     -27.1%        210 ±19%  sched_debug.cpu#8.nr_running
      1.03 ± 8%     -32.0%       0.70 ±24%  perf-profile.cpu-cycles._raw_spin_unlock_irqrestore.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common
      0.95 ± 5%     +34.3%       1.28 ±15%  perf-profile.cpu-cycles._raw_spin_unlock_irqrestore.__wake_up_sync_key.pipe_write.do_sync_write.vfs_write
    829183 ±18%     -23.4%     635360 ±12%  sched_debug.cpu#24.avg_idle
     33066 ± 7%     +50.4%      49736 ±35%  numa-vmstat.node0.nr_slab_unreclaimable
        50 ± 6%     -19.2%         40 ±13%  sched_debug.cpu#31.cpu_load[2]
       233 ± 6%     -24.5%        176 ±21%  sched_debug.cpu#29.nr_running
       245 ± 6%     -24.7%        185 ±20%  sched_debug.cpu#9.nr_running
        49 ± 4%     -18.1%         40 ±13%  sched_debug.cpu#31.cpu_load[3]
     18064 ± 1%     -21.3%      14220 ± 4%  sched_debug.cpu#31.curr->pid
        39 ±11%     -27.4%         28 ±15%  sched_debug.cfs_rq[31]:/.runnable_load_avg
        44 ± 5%     -19.4%         36 ±14%  sched_debug.cfs_rq[13]:/.runnable_load_avg
      0.98 ± 2%     -20.7%       0.78 ±12%  perf-profile.cpu-cycles.__wake_up_common.__wake_up_sync_key.pipe_write.do_sync_write.vfs_write
     49911 ± 8%     +32.5%      66126 ±27%  numa-vmstat.node0.nr_page_table_pages
      0.91 ± 6%     +30.9%       1.19 ±13%  perf-profile.cpu-cycles.__srcu_read_lock.fsnotify.vfs_write.sys_write.system_call_fastpath
      0.85 ± 7%     +24.4%       1.05 ±14%  perf-profile.cpu-cycles.__sb_start_write.pipe_write.do_sync_write.vfs_write.sys_write
      4.09 ± 1%     -25.4%       3.05 ±17%  perf-profile.cpu-cycles.__schedule.schedule.pipe_wait.pipe_read.do_sync_read
      1.24 ± 2%     +22.5%       1.52 ±11%  perf-profile.cpu-cycles.avc_has_perm.inode_has_perm.file_has_perm.selinux_file_permission.security_file_permission
        45 ±27%     -35.0%         29 ±18%  sched_debug.cpu#30.load
    697427 ± 2%     -22.7%     539034 ±20%  sched_debug.cpu#29.avg_idle
      1.59 ±10%     +31.9%       2.09 ±15%  perf-profile.cpu-cycles.pipe_write.do_sync_write.vfs_write.sys_write.system_call_fastpath
      0.75 ±10%     +31.9%       0.99 ±13%  perf-profile.cpu-cycles.__fget_light.sys_write.system_call_fastpath.__write_nocancel
      0.78 ± 4%     +29.1%       1.01 ±16%  perf-profile.cpu-cycles.__srcu_read_unlock.fsnotify.vfs_write.sys_write.system_call_fastpath
        49 ± 3%     -16.9%         41 ±15%  sched_debug.cpu#31.cpu_load[4]
      0.65 ± 7%     +33.0%       0.86 ±15%  perf-profile.cpu-cycles.__sb_end_write.pipe_write.do_sync_write.vfs_write.sys_write
      0.69 ± 1%     +23.1%       0.85 ±13%  perf-profile.cpu-cycles.__write_nocancel
      1.06 ± 3%     -19.8%       0.85 ±15%  perf-profile.cpu-cycles.enqueue_entity.enqueue_task_fair.enqueue_task.activate_task.ttwu_do_activate
     41260 ± 4%      -4.9%      39232 ± 5%  sched_debug.cfs_rq[17]:/.tg_load_avg
      1106 ±12%     -11.2%        982 ± 5%  numa-meminfo.node1.Unevictable
      1103 ±12%     -11.2%        979 ± 5%  numa-meminfo.node1.Mlocked
       228 ± 6%     -21.4%        179 ±21%  sched_debug.cpu#30.nr_running
      2.41 ± 2%     +18.0%       2.84 ±10%  perf-profile.cpu-cycles.copy_user_generic_string.pipe_read.do_sync_read.vfs_read.sys_read
      9444 ± 3%      -6.5%       8831 ± 5%  slabinfo.proc_inode_cache.active_objs
 1.928e+09 ± 0%      -2.6%  1.878e+09 ± 0%  time.voluntary_context_switches
  18293607 ± 1%      +3.6%   18950807 ± 0%  time.minor_page_faults
   4628480 ± 1%      -1.9%    4541031 ± 0%  vmstat.system.cs
   1057268 ± 0%      -4.4%    1010922 ± 0%  vmstat.system.in

testbox/testcase/testparams: lkp-snb01/hackbench/1600%-process-socket

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    136352 ± 1%      +5.3%     143641 ± 0%  hackbench.throughput
      3768 ±12%     -27.4%       2735 ± 5%  sched_debug.cfs_rq[27]:/.blocked_load_avg
        29 ±26%     +51.7%         45 ±11%  sched_debug.cpu#24.cpu_load[3]
      2752 ±22%     -48.4%       1418 ±37%  sched_debug.cfs_rq[14]:/.tg_load_contrib
     18318 ± 9%     -15.1%      15561 ± 1%  sched_debug.cpu#25.curr->pid
        25 ±35%    +101.3%         51 ±32%  sched_debug.cpu#2.cpu_load[1]
        27 ±32%     +53.0%         42 ±20%  sched_debug.cpu#2.cpu_load[2]
      1196 ±44%     +92.2%       2299 ±30%  sched_debug.cfs_rq[2]:/.blocked_load_avg
      3822 ±11%     -27.4%       2777 ± 5%  sched_debug.cfs_rq[27]:/.tg_load_contrib
        17 ±42%     -55.8%          7 ±49%  sched_debug.cpu#0.cpu_load[2]
        62 ±42%     -50.3%         31 ±17%  sched_debug.cpu#10.cpu_load[0]
        18 ±45%     -58.2%          7 ±49%  sched_debug.cpu#0.cpu_load[3]
      2980 ±15%     -56.5%       1296 ±30%  sched_debug.cfs_rq[6]:/.tg_load_contrib
      3104 ±26%     -40.9%       1834 ±16%  sched_debug.cfs_rq[20]:/.blocked_load_avg
     14604 ±21%     +25.8%      18369 ± 9%  sched_debug.cpu#21.curr->pid
    604711 ±26%     +81.6%    1098097 ±19%  sched_debug.cpu#2.avg_idle
      1223 ±43%     +94.5%       2379 ±29%  sched_debug.cfs_rq[2]:/.tg_load_contrib
        14 ±40%     -46.5%          7 ±49%  sched_debug.cpu#0.cpu_load[1]
      2901 ±15%     -57.6%       1230 ±32%  sched_debug.cfs_rq[6]:/.blocked_load_avg
     22133 ± 1%     -26.0%      16387 ±20%  sched_debug.cpu#11.curr->pid
   1774944 ± 7%     -25.7%    1319004 ±16%  cpuidle.C3-SNB.time
        17 ±42%     -55.8%          7 ±49%  sched_debug.cpu#0.cpu_load[4]
        32 ±16%    +319.6%        135 ±28%  sched_debug.cpu#9.load
      3173 ±26%     -40.7%       1880 ±15%  sched_debug.cfs_rq[20]:/.tg_load_contrib
        29 ±48%     +90.8%         55 ± 9%  sched_debug.cpu#5.cpu_load[2]
    122294 ± 3%     +14.2%     139679 ± 4%  numa-vmstat.node1.nr_active_anon
      2719 ±22%     -49.1%       1385 ±38%  sched_debug.cfs_rq[14]:/.blocked_load_avg
        26 ±36%     +68.4%         44 ±28%  sched_debug.cfs_rq[20]:/.runnable_load_avg
         2 ±40%    +133.3%          4 ±36%  sched_debug.cfs_rq[29]:/.nr_spread_over
        28 ±40%     +71.4%         48 ± 6%  sched_debug.cpu#5.cpu_load[3]
        22 ±24%    +126.9%         50 ±44%  sched_debug.cfs_rq[24]:/.load
        27 ±34%     +55.6%         42 ±10%  sched_debug.cpu#5.cpu_load[4]
        57 ±16%     -23.3%         44 ± 6%  sched_debug.cpu#15.cpu_load[2]
      3698 ±17%     -44.1%       2066 ±36%  sched_debug.cfs_rq[8]:/.blocked_load_avg
      3736 ±17%     -43.0%       2131 ±35%  sched_debug.cfs_rq[8]:/.tg_load_contrib
      1137 ±21%     -38.1%        704 ± 1%  slabinfo.kmalloc-192.num_slabs
      1137 ±21%     -38.1%        704 ± 1%  slabinfo.kmalloc-192.active_slabs
        26 ±44%     +72.5%         46 ±30%  sched_debug.cpu#24.cpu_load[1]
    585607 ±37%     +66.8%     976862 ±17%  sched_debug.cpu#1.avg_idle
     34949 ±26%     -45.1%      19186 ± 1%  slabinfo.task_struct.active_objs
     34958 ±26%     -45.1%      19205 ± 1%  slabinfo.task_struct.num_objs
      8739 ±26%     -45.1%       4801 ± 1%  slabinfo.task_struct.num_slabs
      8739 ±26%     -45.1%       4801 ± 1%  slabinfo.task_struct.active_slabs
 1.755e+08 ± 1%     -38.7%  1.077e+08 ±14%  cpuidle.C1E-SNB.time
     17413 ± 9%     +20.3%      20940 ± 2%  sched_debug.cpu#1.curr->pid
      1215 ±25%     -42.3%        701 ± 0%  slabinfo.signal_cache.num_slabs
      1215 ±25%     -42.3%        701 ± 0%  slabinfo.signal_cache.active_slabs
     36961 ±25%     -40.4%      22031 ± 2%  slabinfo.task_xstate.active_objs
       948 ±25%     -40.3%        566 ± 2%  slabinfo.task_xstate.active_slabs
       948 ±25%     -40.3%        566 ± 2%  slabinfo.task_xstate.num_slabs
     36988 ±25%     -40.2%      22106 ± 2%  slabinfo.task_xstate.num_objs
     67514 ±16%     -19.2%      54578 ± 5%  numa-vmstat.node0.nr_active_anon
        28 ±42%     +57.1%         44 ±14%  sched_debug.cpu#24.cpu_load[2]
     40258 ±24%     -32.2%      27293 ±10%  slabinfo.kmalloc-128.active_objs
       629 ±24%     -31.9%        428 ±10%  slabinfo.kmalloc-128.active_slabs
       629 ±24%     -31.9%        428 ±10%  slabinfo.kmalloc-128.num_slabs
     40288 ±24%     -31.9%      27449 ±10%  slabinfo.kmalloc-128.num_objs
        65 ±48%     -63.6%         23 ±49%  sched_debug.cpu#22.cpu_load[0]
     38175 ±12%     -57.3%      16317 ± 4%  numa-vmstat.node1.nr_kernel_stack
        31 ±11%     +41.5%         44 ±14%  sched_debug.cpu#24.cpu_load[4]
    894920 ±37%     +52.0%    1360209 ±13%  sched_debug.cpu#5.avg_idle
 3.965e+08 ±10%     -44.7%  2.194e+08 ±10%  cpuidle.C1-SNB.time
        28 ± 5%     +57.0%         45 ±16%  sched_debug.cpu#9.cpu_load[0]
    213890 ±28%     -44.9%     117926 ±14%  numa-meminfo.node1.KernelStack
     93234 ±18%     +79.4%     167249 ±18%  slabinfo.kmalloc-512.active_objs
        30 ±38%     +50.0%         46 ±11%  sched_debug.cpu#7.cpu_load[2]
     36480 ±25%     -42.3%      21059 ± 0%  slabinfo.signal_cache.num_objs
     36396 ±25%     -42.3%      20991 ± 0%  slabinfo.signal_cache.active_objs
   2477866 ±23%     -42.3%    1429384 ±25%  sched_debug.cpu#23.avg_idle
        20 ±22%     +50.0%         31 ±13%  sched_debug.cpu#11.nr_running
        18 ± 7%     +38.9%         25 ± 3%  sched_debug.cpu#15.nr_running
        15 ±29%     +41.3%         21 ± 5%  sched_debug.cpu#31.nr_running
       298 ±10%     +50.0%        448 ±11%  slabinfo.kmem_cache.active_objs
       298 ±10%     +50.0%        448 ±11%  slabinfo.kmem_cache.num_objs
 5.746e+08 ±15%     +49.7%  8.602e+08 ± 7%  cpuidle.C7-SNB.time
        29 ±42%     +79.3%         52 ±28%  sched_debug.cpu#7.cpu_load[1]
     47797 ±21%     -38.1%      29598 ± 1%  slabinfo.kmalloc-192.num_objs
     14154 ±42%     +45.2%      20558 ± 3%  sched_debug.cpu#3.curr->pid
        14 ±26%     +59.5%         22 ±28%  sched_debug.cpu#19.nr_running
     15030 ±11%     +42.4%      21408 ± 2%  sched_debug.cpu#18.curr->pid
    121150 ± 3%     +13.8%     137836 ± 4%  numa-vmstat.node1.nr_anon_pages
        18 ±25%     +33.3%         24 ± 9%  sched_debug.cpu#27.nr_running
        17 ±14%     +46.2%         25 ±11%  sched_debug.cpu#24.nr_running
        20 ±10%     +23.0%         25 ±13%  sched_debug.cpu#20.nr_running
    148903 ± 4%     +26.4%     188145 ± 9%  cpuidle.C7-SNB.usage
    253536 ±19%     +52.7%     387249 ± 9%  slabinfo.kmalloc-512.num_objs
      3961 ±19%     +52.7%       6050 ± 9%  slabinfo.kmalloc-512.num_slabs
      3961 ±19%     +52.7%       6050 ± 9%  slabinfo.kmalloc-512.active_slabs
        17 ±29%     +57.7%         27 ± 1%  sched_debug.cpu#7.nr_running
    207838 ±11%     -37.8%     129252 ± 4%  numa-vmstat.node1.nr_slab_unreclaimable
       407 ± 7%     +36.6%        557 ± 9%  slabinfo.kmem_cache_node.active_objs
        32 ±45%     +60.2%         52 ± 5%  sched_debug.cpu#31.cpu_load[1]
       426 ± 7%     +35.0%        576 ± 9%  slabinfo.kmem_cache_node.num_objs
     47738 ±21%     -38.2%      29494 ± 1%  slabinfo.kmalloc-192.active_objs
   1956305 ± 7%     -15.0%    1661919 ± 8%  sched_debug.cpu#20.avg_idle
     75011 ±12%     -19.6%      60311 ± 1%  slabinfo.kernfs_node_cache.active_objs
     75036 ±12%     -19.6%      60361 ± 1%  slabinfo.kernfs_node_cache.num_objs
      2084 ±13%     -19.6%       1676 ± 1%  slabinfo.kernfs_node_cache.active_slabs
      2084 ±13%     -19.6%       1676 ± 1%  slabinfo.kernfs_node_cache.num_slabs
   4049841 ± 2%     +32.0%    5343918 ±14%  cpuidle.C1-SNB.usage
    293311 ± 3%     +12.1%     328716 ± 1%  softirqs.SCHED
    683095 ±15%     -31.3%     469359 ±15%  numa-meminfo.node1.SUnreclaim
    129912 ±21%     +49.2%     193826 ± 9%  slabinfo.kmalloc-256.active_objs
    719915 ±15%     -29.8%     505238 ±14%  numa-meminfo.node1.Slab
     94716 ±14%     -19.5%      76235 ±19%  sched_debug.cfs_rq[22]:/.tg_load_avg
      4553 ±20%     +39.9%       6370 ± 8%  slabinfo.kmalloc-256.active_slabs
      4553 ±20%     +39.9%       6370 ± 8%  slabinfo.kmalloc-256.num_slabs
     66028 ±14%     -17.7%      54316 ± 5%  numa-vmstat.node0.nr_anon_pages
     81070 ± 4%     -17.4%      66948 ±11%  sched_debug.cfs_rq[5]:/.tg_load_avg
    291472 ±20%     +39.9%     407746 ± 8%  slabinfo.kmalloc-256.num_objs
     71814 ±10%     -17.8%      59021 ±10%  sched_debug.cfs_rq[3]:/.tg_load_avg
     78608 ± 2%     -15.3%      66578 ±11%  sched_debug.cfs_rq[4]:/.tg_load_avg
    757843 ± 9%      +9.1%     827114 ± 5%  meminfo.AnonPages

testbox/testcase/testparams: lkp-sb03/nepim/300s-100%-udp6

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
   -327409 ± 0%      +1.3%    -331788 ± 0%  sched_debug.cfs_rq[20]:/.spread0
      1651 ±23%     -81.4%        308 ±15%  sched_debug.cpu#5.ttwu_local
      1977 ±21%     -86.5%        266 ±13%  sched_debug.cpu#7.ttwu_local
      2233 ±35%     -75.3%        551 ±21%  sched_debug.cpu#12.ttwu_local
        -2 ±-20%    +136.1%         -5 ±-16%  sched_debug.cpu#9.nr_uninterruptible
      2279 ±11%     -83.8%        368 ± 5%  sched_debug.cpu#4.ttwu_local
      1253 ±28%     -73.0%        338 ± 4%  sched_debug.cpu#6.ttwu_local
      3305 ±19%     -81.3%        616 ±34%  sched_debug.cpu#10.ttwu_local
      4201 ±27%     -68.6%       1319 ± 7%  sched_debug.cpu#12.ttwu_count
      4965 ±40%     -70.6%       1461 ±40%  sched_debug.cpu#15.ttwu_count
   -294566 ±-14%     +13.0%    -332791 ± 0%  sched_debug.cfs_rq[8]:/.spread0
      3498 ±24%     -75.9%        844 ± 5%  sched_debug.cpu#5.ttwu_count
      2721 ±26%     -89.2%        293 ±18%  sched_debug.cpu#1.ttwu_local
      3949 ±33%     -78.7%        842 ±13%  sched_debug.cpu#7.ttwu_count
      2237 ±40%     -80.0%        447 ±44%  sched_debug.cpu#8.ttwu_local
      4376 ± 9%     -75.7%       1063 ± 5%  sched_debug.cpu#4.ttwu_count
       336 ±40%     -38.3%        207 ±19%  sched_debug.cfs_rq[27]:/.exec_clock
     11571 ±26%     -54.2%       5295 ±18%  sched_debug.cpu#15.nr_switches
        39 ± 7%     +41.4%         56 ± 6%  sched_debug.cpu#23.ttwu_local
      5760 ±26%     -54.8%       2603 ±18%  sched_debug.cpu#15.sched_goidle
      3848 ±38%     -73.8%       1007 ±43%  sched_debug.cpu#8.ttwu_count
      2663 ±24%     -57.5%       1133 ±38%  sched_debug.cpu#6.ttwu_count
      3354 ±23%     -68.6%       1054 ± 8%  sched_debug.cpu#11.ttwu_local
       292 ±43%     +99.5%        582 ±23%  sched_debug.cpu#23.sched_goidle
      6044 ±40%     +65.4%       9999 ±24%  sched_debug.cfs_rq[5]:/.min_vruntime
      5173 ±26%     -49.5%       2610 ±23%  sched_debug.cpu#10.sched_goidle
      5064 ±24%     -69.1%       1562 ±27%  sched_debug.cpu#1.ttwu_count
     13939 ±17%     -60.7%       5484 ±21%  sched_debug.cpu#10.nr_switches
      8052 ±21%     -48.1%       4181 ±30%  sched_debug.cpu#8.nr_switches
      6978 ±11%     -33.3%       4656 ± 9%  sched_debug.cpu#6.nr_switches
      4072 ± 9%     -43.6%       2296 ± 7%  sched_debug.cpu#5.sched_goidle
      6458 ±14%     -37.9%       4008 ± 5%  sched_debug.cpu#12.sched_goidle
     11124 ± 5%     -19.5%       8960 ± 6%  sched_debug.cpu#3.sched_goidle
     90.84 ± 4%     +95.6%     177.72 ±47%  sched_debug.cfs_rq[30]:/.exec_clock
       605 ±41%     +99.8%       1210 ±22%  sched_debug.cpu#23.nr_switches
      3465 ±11%     -34.0%       2286 ±10%  sched_debug.cpu#6.sched_goidle
      8984 ±14%     -30.0%       6290 ±26%  sched_debug.cpu#13.nr_switches
      3925 ±21%     -47.5%       2060 ±30%  sched_debug.cpu#8.sched_goidle
      7184 ±15%     -40.3%       4290 ± 7%  sched_debug.cpu#11.ttwu_count
       886 ± 4%     +17.7%       1043 ± 9%  sched_debug.cpu#11.curr->pid
    423855 ±49%    +139.1%    1013399 ±19%  cpuidle.C3-SNB.time
      8204 ± 9%     -42.9%       4688 ± 8%  sched_debug.cpu#5.nr_switches
     10570 ±24%     +42.3%      15043 ± 5%  sched_debug.cfs_rq[3]:/.min_vruntime
      4455 ±14%     -30.5%       3094 ±26%  sched_debug.cpu#13.sched_goidle
      6062 ± 3%     -37.4%       3796 ± 8%  sched_debug.cpu#4.sched_goidle
     12202 ± 3%     -37.0%       7686 ± 8%  sched_debug.cpu#4.nr_switches
     23602 ± 9%     -24.6%      17787 ± 7%  sched_debug.cpu#11.nr_switches
      1614 ± 4%     +27.9%       2064 ±25%  sched_debug.cpu#28.sched_goidle
      2634 ± 4%    +106.3%       5435 ± 6%  sched_debug.cpu#17.ttwu_count
     22391 ± 5%     -18.7%      18206 ± 6%  sched_debug.cpu#3.nr_switches
      1933 ±13%     -17.0%       1605 ± 1%  sched_debug.cpu#20.sched_goidle
     31292 ±39%     -37.3%      19629 ±14%  sched_debug.cpu#11.sched_count
      6957 ± 6%     -41.0%       4101 ± 3%  sched_debug.cpu#3.ttwu_count
     13015 ±14%     -35.8%       8358 ± 5%  sched_debug.cpu#12.nr_switches
     11715 ± 9%     -25.5%       8728 ± 7%  sched_debug.cpu#11.sched_goidle
       745 ± 4%     +57.6%       1174 ±41%  sched_debug.cpu#28.ttwu_local
      8103 ± 9%     -41.0%       4780 ±21%  sched_debug.cpu#7.nr_switches
      5644 ±24%     -37.9%       3502 ± 7%  sched_debug.cpu#2.sched_goidle
      4009 ± 8%     -41.2%       2355 ±21%  sched_debug.cpu#7.sched_goidle
      5472 ±22%     -43.5%       3089 ±18%  sched_debug.cpu#1.sched_goidle
      3223 ±13%     -57.2%       1378 ± 7%  sched_debug.cpu#3.ttwu_local
      4652 ±16%     -36.9%       2934 ±23%  sched_debug.cfs_rq[27]:/.min_vruntime
        69 ±19%    +101.1%        140 ±10%  sched_debug.cpu#29.ttwu_local
     11110 ±21%     -43.7%       6260 ±18%  sched_debug.cpu#1.nr_switches
       832 ±13%     +97.3%       1641 ± 7%  sched_debug.cpu#17.ttwu_local
      5188 ± 6%     +35.6%       7038 ± 3%  sched_debug.cpu#17.nr_switches
      4689 ±10%     -13.7%       4045 ± 0%  sched_debug.cpu#20.sched_count
      5220 ±15%     -19.4%       4209 ±10%  sched_debug.cfs_rq[28]:/.min_vruntime
       249 ±18%     +35.0%        337 ±21%  sched_debug.cpu#18.ttwu_local
        53 ±17%     +49.3%         80 ± 9%  sched_debug.cpu#31.ttwu_local
       455 ± 8%     -30.5%        316 ±21%  cpuidle.C3-SNB.usage
      5275 ±32%     -34.8%       3440 ±18%  sched_debug.cfs_rq[20]:/.min_vruntime
      3474 ± 7%     -12.0%       3058 ± 6%  cpuidle.C1E-SNB.usage
      2169 ± 6%     +15.7%       2510 ± 4%  sched_debug.cpu#18.ttwu_count
    139702 ± 1%     -33.8%      92508 ± 1%  cpuidle.C7-SNB.usage
       406 ± 9%     -18.6%        330 ±16%  numa-vmstat.node1.nr_page_table_pages
      4676 ±10%     -13.8%       4033 ± 0%  sched_debug.cpu#20.nr_switches
      5780 ± 6%     -18.1%       4736 ± 4%  cpuidle.C1-SNB.usage
     47898 ± 5%     +32.0%      63244 ± 3%  softirqs.SCHED
    989252 ± 1%      -9.3%     897324 ± 6%  sched_debug.cpu#14.avg_idle
    399538 ± 1%     +11.7%     446206 ± 0%  softirqs.TIMER
       343 ±18%  +12507.6%      43294 ± 2%  time.involuntary_context_switches
      2506 ± 0%      -5.0%       2382 ± 0%  vmstat.system.in

testbox/testcase/testparams: lkp-snb01/will-it-scale/open2

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    253013 ± 0%      -1.2%     249916 ± 0%  will-it-scale.per_thread_ops
      4354 ±41%     -84.1%        692 ±20%  sched_debug.cpu#13.ttwu_local
      5296 ±18%     -83.9%        853 ±13%  sched_debug.cpu#12.ttwu_local
      7641 ±38%     -77.3%       1735 ±18%  sched_debug.cpu#13.ttwu_count
      9118 ±18%     -77.2%       2074 ±11%  sched_debug.cpu#12.ttwu_count
      9904 ± 6%     -48.4%       5115 ±34%  sched_debug.cpu#10.ttwu_count
      8839 ±27%     -79.3%       1833 ±29%  sched_debug.cpu#8.ttwu_local
    101354 ±18%     -27.7%      73268 ±19%  sched_debug.cfs_rq[16]:/.exec_clock
     24061 ±28%     -61.1%       9371 ±29%  sched_debug.cpu#15.nr_switches
     11419 ±29%     -73.9%       2977 ± 5%  sched_debug.cpu#15.sched_goidle
     14046 ±22%     -78.0%       3091 ±19%  sched_debug.cpu#8.ttwu_count
     32344 ±20%     -38.7%      19821 ±23%  sched_debug.cpu#13.sched_count
      5788 ±13%     -77.0%       1331 ± 9%  sched_debug.cpu#11.ttwu_local
     10055 ±15%     -40.7%       5957 ±21%  sched_debug.cpu#10.sched_goidle
     20203 ±18%     -40.0%      12127 ±24%  sched_debug.cpu#14.nr_switches
     24515 ± 7%     -30.7%      16990 ±21%  sched_debug.cpu#10.nr_switches
     27297 ±20%     -59.1%      11172 ±16%  sched_debug.cpu#8.nr_switches
        75 ±30%     -45.6%         41 ±48%  sched_debug.cpu#16.cpu_load[1]
      9222 ±21%     -61.1%       3586 ± 7%  sched_debug.cpu#14.sched_goidle
        74 ±30%     -45.1%         40 ±48%  sched_debug.cpu#16.cpu_load[0]
     10894 ±10%     -49.7%       5474 ± 8%  sched_debug.cpu#12.sched_goidle
        71 ±31%     -44.7%         39 ±31%  sched_debug.cfs_rq[6]:/.blocked_load_avg
      3515 ±19%     -32.0%       2390 ±12%  sched_debug.cpu#6.sched_goidle
     20866 ±16%     -58.6%       8634 ±10%  sched_debug.cpu#13.nr_switches
     11007 ±18%     -64.8%       3878 ±17%  sched_debug.cpu#8.sched_goidle
     10057 ±11%     -57.8%       4240 ±17%  sched_debug.cpu#11.ttwu_count
     37414 ±26%    +186.5%     107204 ±15%  sched_debug.cpu#0.sched_count
        18 ±16%     +34.4%         24 ±23%  sched_debug.cfs_rq[26]:/.runnable_load_avg
   1384240 ±40%     -67.3%     452908 ±22%  cpuidle.C3-SNB.time
      9831 ±17%     -62.7%       3666 ±12%  sched_debug.cpu#13.sched_goidle
      7050 ±19%     -50.0%       3527 ±11%  sched_debug.cpu#9.sched_goidle
     27447 ±13%     -32.1%      18629 ±13%  sched_debug.cpu#11.nr_switches
      5961 ±19%    +315.5%      24768 ±24%  sched_debug.cpu#0.ttwu_local
      4277 ±13%    +132.7%       9953 ±26%  sched_debug.cpu#17.ttwu_count
     17147 ±14%    +387.7%      83620 ±21%  sched_debug.cpu#0.nr_switches
     23029 ±10%     -45.8%      12486 ± 8%  sched_debug.cpu#12.nr_switches
     11920 ±11%     -29.5%       8400 ±15%  sched_debug.cpu#11.sched_goidle
        80 ±12%     -51.0%         39 ±44%  sched_debug.cfs_rq[16]:/.load
        61 ±37%     -47.7%         32 ±42%  sched_debug.cpu#10.load
     13026 ±18%    +265.2%      47568 ±22%  sched_debug.cpu#0.ttwu_count
        80 ±13%     -49.6%         40 ±43%  sched_debug.cpu#16.load
      1445 ±31%     +98.2%       2863 ±39%  sched_debug.cpu#17.ttwu_local
      7763 ±17%     +76.4%      13693 ±35%  sched_debug.cpu#17.nr_switches
    810769 ± 3%     +12.5%     912189 ± 2%  sched_debug.cpu#1.avg_idle
        74 ±30%     -46.8%         39 ±44%  sched_debug.cfs_rq[16]:/.runnable_load_avg
      1120 ±16%     -41.9%        651 ±18%  cpuidle.C3-SNB.usage
     92087 ±20%     +30.7%     120342 ±10%  sched_debug.cpu#0.nr_load_updates
    914687 ± 4%     -10.4%     819316 ± 5%  sched_debug.cpu#17.avg_idle
      2080 ± 2%      -9.8%       1877 ± 1%  slabinfo.signal_cache.num_objs
      2050 ± 4%      -8.4%       1877 ± 1%  slabinfo.signal_cache.active_objs
      2175 ±13%     +71.2%       3725 ±26%  sched_debug.cpu#18.ttwu_count
    335319 ± 0%     -21.0%     265024 ± 0%  cpuidle.C7-SNB.usage
     18870 ± 0%    +265.8%      69025 ± 0%  time.involuntary_context_switches
      1981 ± 0%      +7.1%       2122 ± 0%  vmstat.system.cs
     18240 ± 0%      -1.3%      18004 ± 0%  vmstat.system.in

testbox/testcase/testparams: lkp-sb03/nuttcp/300s

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
   3883.97 ±35%    -100.0%       0.00 ± 0%  sched_debug.cfs_rq[5]:/.max_vruntime
   3883.97 ±35%    -100.0%       0.00 ± 0%  sched_debug.cfs_rq[5]:/.MIN_vruntime
      8618 ±29%     -74.5%       2195 ±28%  sched_debug.cpu#14.ttwu_count
      2971 ±48%     -88.0%        357 ±39%  sched_debug.cpu#5.ttwu_local
       549 ±22%    +442.9%       2984 ±33%  sched_debug.cpu#21.nr_switches
      1789 ±46%     -75.4%        440 ±49%  sched_debug.cpu#4.ttwu_local
      7097 ±30%     -71.8%       2000 ±33%  sched_debug.cpu#15.ttwu_local
      5737 ±10%     -92.0%        458 ±25%  sched_debug.cpu#10.ttwu_local
      8862 ±26%     -66.2%       2994 ±12%  sched_debug.cpu#15.ttwu_count
     63.34 ±10%    +391.1%     311.04 ±43%  sched_debug.cfs_rq[23]:/.exec_clock
        10 ±12%     -38.7%          6 ±37%  sched_debug.cfs_rq[17]:/.nr_spread_over
      1828 ±22%     -38.2%       1130 ±36%  sched_debug.cfs_rq[11]:/.exec_clock
       562 ±22%    +433.1%       2997 ±33%  sched_debug.cpu#21.sched_count
        63 ±38%     -66.7%         21 ±43%  sched_debug.cfs_rq[2]:/.tg_runnable_contrib
      1523 ±29%     -58.6%        630 ±30%  sched_debug.cpu#2.ttwu_local
        46 ±20%    +344.6%        206 ±26%  sched_debug.cpu#23.ttwu_local
        11 ±44%    -100.0%          0 ± 0%  sched_debug.cpu#29.cpu_load[4]
       444 ±10%    +511.9%       2722 ±48%  sched_debug.cfs_rq[3]:/.exec_clock
      3428 ± 4%     +43.4%       4917 ± 5%  sched_debug.cpu#25.ttwu_count
        10 ± 0%    -100.0%          0 ± 0%  sched_debug.cfs_rq[5]:/.blocked_load_avg
        60 ±26%    +637.6%        445 ±21%  sched_debug.cpu#21.ttwu_local
      1044 ±19%     +57.7%       1647 ± 7%  sched_debug.cpu#25.ttwu_local
      2923 ±37%     -65.6%       1006 ±40%  sched_debug.cfs_rq[2]:/.avg->runnable_avg_sum
         9 ±39%    +159.3%         23 ±30%  sched_debug.cpu#0.cpu_load[3]
       193 ±34%    -100.0%          0 ± 0%  sched_debug.cpu#28.cpu_load[0]
        11 ±16%     -52.9%          5 ±23%  sched_debug.cfs_rq[26]:/.tg_runnable_contrib
         2 ±40%    -100.0%          0 ± 0%  sched_debug.cfs_rq[9]:/.tg_runnable_contrib
       114 ±31%     -83.3%         19 ±17%  sched_debug.cfs_rq[9]:/.avg->runnable_avg_sum
       550 ±13%     -54.9%        248 ±22%  sched_debug.cfs_rq[26]:/.avg->runnable_avg_sum
        10 ±22%    +140.6%         25 ±45%  sched_debug.cpu#0.cpu_load[4]
      4891 ±33%     -54.9%       2206 ±49%  sched_debug.cfs_rq[10]:/.exec_clock
      3279 ±40%    -100.0%          0 ± 0%  sched_debug.cpu#28.curr->pid
       196 ±35%    -100.0%          0 ± 0%  sched_debug.cfs_rq[28]:/.runnable_load_avg
      2481 ± 5%     -43.3%       1406 ±32%  sched_debug.cfs_rq[31]:/.exec_clock
       196 ±35%    -100.0%          0 ± 0%  sched_debug.cfs_rq[28]:/.load
  3.55e+08 ± 0%      +8.9%  3.865e+08 ± 5%  proc-vmstat.pgalloc_normal
      2357 ± 7%    +103.2%       4790 ± 2%  sched_debug.cpu#17.ttwu_count
       196 ±35%    -100.0%          0 ± 0%  sched_debug.cpu#28.load
      2705 ±20%     -42.9%       1544 ±49%  sched_debug.cpu#31.nr_switches
       175 ±37%     +89.2%        332 ±48%  sched_debug.cfs_rq[21]:/.avg->runnable_avg_sum
      1186 ±19%     -43.7%        668 ±46%  sched_debug.cpu#31.sched_goidle
      3161 ±27%     -38.0%       1959 ± 0%  meminfo.AnonHugePages
       349 ±42%    +131.2%        808 ±37%  sched_debug.cpu#3.ttwu_local
      6468 ± 9%     +30.4%       8433 ±19%  sched_debug.cpu#0.ttwu_count
       866 ±13%     +91.2%       1656 ± 4%  sched_debug.cpu#17.ttwu_local
      6038 ± 7%     -34.0%       3986 ±30%  sched_debug.cfs_rq[28]:/.min_vruntime
      5313 ± 9%     -40.4%       3169 ±36%  sched_debug.cfs_rq[31]:/.min_vruntime
      1862 ± 4%     +54.5%       2878 ±21%  sched_debug.cfs_rq[23]:/.min_vruntime
      5098 ± 4%     -33.3%       3402 ± 6%  sched_debug.cfs_rq[29]:/.min_vruntime
    126798 ±15%     -28.1%      91178 ± 0%  sched_debug.cpu#4.nr_load_updates
    112718 ±10%     -19.7%      90480 ± 1%  sched_debug.cpu#5.nr_load_updates
    470584 ±47%    +101.6%     948801 ± 2%  sched_debug.cpu#5.avg_idle
     26143 ± 2%     +66.8%      43614 ± 7%  softirqs.RCU
    959521 ± 4%     -35.0%     623768 ±41%  sched_debug.cpu#13.avg_idle
    967558 ± 2%     -19.5%     778607 ±19%  sched_debug.cpu#15.avg_idle
    325196 ± 0%     -26.0%     240605 ± 0%  cpuidle.C7-SNB.usage
    662043 ±14%     +46.9%     972290 ± 2%  sched_debug.cpu#4.avg_idle
        31 ±34%     -32.3%         21 ±14%  sched_debug.cfs_rq[25]:/.tg_runnable_contrib
      1466 ±33%     -32.1%        995 ±14%  sched_debug.cfs_rq[25]:/.avg->runnable_avg_sum
     10900 ± 3%     +18.2%      12884 ± 7%  slabinfo.kmalloc-256.num_objs
       308 ± 0%   +6197.7%      19418 ± 0%  time.involuntary_context_switches
      0.00 ± 0%      +4.9%       0.00 ± 3%  energy.energy-cores
     41.80 ± 0%      +4.9%      43.85 ± 3%  turbostat.Cor_W
     69.29 ± 0%      +3.0%      71.34 ± 1%  turbostat.Pkg_W
      0.00 ± 0%      +3.0%       0.00 ± 1%  energy.energy-pkg

testbox/testcase/testparams: xps2/pigz/100%-512K

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
       797 ±19%     +73.4%       1382 ± 7%  sched_debug.cfs_rq[6]:/.tg_load_contrib
       679 ±24%     +83.1%       1244 ± 7%  sched_debug.cfs_rq[6]:/.blocked_load_avg
       135 ± 9%     -10.6%        121 ±10%  sched_debug.cpu#7.load
       421 ± 3%     -30.3%        294 ± 7%  sched_debug.cfs_rq[1]:/.tg_load_contrib
       306 ± 5%     -51.2%        149 ±20%  sched_debug.cfs_rq[1]:/.blocked_load_avg
      2002 ± 4%     +36.3%       2729 ±11%  sched_debug.cpu#7.sched_goidle
    503763 ±15%     +24.2%     625908 ±13%  sched_debug.cpu#5.avg_idle
     22573 ±23%     +30.5%      29451 ±14%  cpuidle.C1-NHM.time
       101 ± 8%     +25.3%        127 ± 3%  cpuidle.C1-NHM.usage
      5399 ± 1%     +19.8%       6469 ± 9%  sched_debug.cfs_rq[0]:/.tg_load_avg
       980 ± 2%     +12.9%       1106 ± 3%  slabinfo.kmalloc-96.active_objs
       980 ± 2%     +12.9%       1106 ± 3%  slabinfo.kmalloc-96.num_objs
      5425 ± 1%     +19.8%       6500 ± 9%  sched_debug.cfs_rq[1]:/.tg_load_avg
      5422 ± 1%     +19.4%       6474 ± 9%  sched_debug.cfs_rq[5]:/.tg_load_avg
      2151 ± 1%     -10.1%       1935 ± 4%  slabinfo.kmalloc-256.num_objs
      5416 ± 1%     +19.6%       6479 ± 8%  sched_debug.cfs_rq[3]:/.tg_load_avg
      5431 ± 1%     +19.4%       6486 ± 9%  sched_debug.cfs_rq[6]:/.tg_load_avg
      5402 ± 2%     +19.7%       6464 ± 8%  sched_debug.cfs_rq[2]:/.tg_load_avg
      5423 ± 0%     +19.5%       6478 ± 9%  sched_debug.cfs_rq[7]:/.tg_load_avg
      5429 ± 1%     +19.6%       6495 ± 8%  sched_debug.cfs_rq[4]:/.tg_load_avg

testbox/testcase/testparams: xps/ftrace_onoff/5m

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
      0.00 ± 0%  +8.1e+10%     813.10 ±32%  sched_debug.cfs_rq[0]:/.MIN_vruntime
      0.00 ± 0%  +8.1e+10%     813.23 ±32%  sched_debug.cfs_rq[0]:/.max_vruntime
       -21 ±-48%    +130.8%        -50 ±-17%  sched_debug.cpu#3.nr_uninterruptible
      1754 ± 5%     +88.5%       3308 ± 9%  sched_debug.cfs_rq[5]:/.spread0
      2504 ±25%    +100.0%       5009 ± 6%  sched_debug.cfs_rq[6]:/.spread0
     11853 ±25%    +113.3%      25277 ± 5%  sched_debug.cpu#5.ttwu_local
      2544 ± 6%    +126.2%       5753 ± 8%  sched_debug.cfs_rq[4]:/.spread0
      1809 ±33%     +86.1%       3367 ±15%  sched_debug.cfs_rq[7]:/.spread0
     14455 ± 2%    +111.4%      30556 ± 7%  sched_debug.cpu#7.ttwu_local
     -1841 ± 0%     +60.0%      -2945 ± 0%  sched_debug.cpu#2.nr_uninterruptible
       -11 ±-21%    +282.9%        -44 ±-14%  sched_debug.cpu#1.nr_uninterruptible
       532 ±10%     +78.4%        949 ± 4%  sched_debug.cpu#4.nr_uninterruptible
     29707 ±10%     +47.3%      43756 ±12%  sched_debug.cpu#4.ttwu_local
     24165 ±11%     +39.9%      33805 ±13%  sched_debug.cpu#6.ttwu_local
        60 ±10%     +55.5%         94 ±17%  sched_debug.cfs_rq[3]:/.tg_runnable_contrib
      2840 ± 9%     +54.2%       4380 ±16%  sched_debug.cfs_rq[3]:/.avg->runnable_avg_sum
        28 ±46%    +101.2%         57 ±16%  sched_debug.cpu#4.cpu_load[4]
         3 ±14%     -70.0%          1 ± 0%  sched_debug.cfs_rq[7]:/.nr_spread_over
     74392 ± 8%     +45.5%     108276 ± 7%  sched_debug.cpu#6.sched_count
       553 ± 5%     +60.1%        886 ± 3%  sched_debug.cpu#5.nr_uninterruptible
     21753 ±12%    +105.0%      44597 ± 4%  sched_debug.cpu#5.ttwu_count
     25413 ± 0%    +107.6%      52755 ± 5%  sched_debug.cpu#7.ttwu_count
      5262 ± 4%     +37.6%       7243 ± 2%  sched_debug.cfs_rq[5]:/.exec_clock
      4733 ± 7%     +25.4%       5936 ± 3%  sched_debug.cfs_rq[6]:/.avg->runnable_avg_sum
        85 ±29%     +56.8%        134 ±15%  sched_debug.cfs_rq[4]:/.tg_runnable_contrib
      3972 ±29%     +56.2%       6203 ±15%  sched_debug.cfs_rq[4]:/.avg->runnable_avg_sum
     11046 ± 1%     +38.8%      15330 ± 1%  sched_debug.cfs_rq[4]:/.min_vruntime
     41713 ± 7%     +71.2%      71395 ± 8%  sched_debug.cpu#4.ttwu_count
   1550134 ± 0%     +47.4%    2285060 ± 0%  proc-vmstat.numa_local
   1550134 ± 0%     +47.4%    2285060 ± 0%  proc-vmstat.numa_hit
   1561481 ± 0%     +47.3%    2300370 ± 0%  proc-vmstat.pgfree
     58.66 ± 0%     -26.2%      43.29 ± 0%  turbostat.%c6
    137258 ± 5%     -21.6%     107598 ± 0%  sched_debug.cpu#2.ttwu_local
       102 ± 8%     +25.1%        128 ± 3%  sched_debug.cfs_rq[6]:/.tg_runnable_contrib
         9 ±48%     -65.5%          3 ±14%  sched_debug.cfs_rq[5]:/.nr_spread_over
         3 ±14%     -60.0%          1 ±35%  sched_debug.cfs_rq[1]:/.nr_spread_over
         0 ± 0%      +Inf%          1 ± 0%  vmstat.procs.r
     52586 ±27%    +179.8%     147141 ±44%  cpuidle.POLL.time
   1617673 ± 0%     +41.4%    2288012 ± 0%  proc-vmstat.pgfault
      5885 ± 2%     +49.6%       8807 ± 1%  sched_debug.cfs_rq[4]:/.exec_clock
     34481 ± 9%     +71.3%      59084 ± 7%  sched_debug.cpu#6.ttwu_count
      1213 ±10%     +28.5%       1559 ±11%  sched_debug.cfs_rq[4]:/.tg_load_contrib
     10257 ± 0%     +25.6%      12885 ± 1%  sched_debug.cfs_rq[5]:/.min_vruntime
     48767 ±12%     +72.0%      83904 ± 3%  sched_debug.cpu#5.sched_count
     83323 ± 7%     +46.5%     122037 ± 8%  sched_debug.cpu#4.sched_count
       471 ± 6%     +71.7%        810 ± 6%  sched_debug.cpu#6.nr_uninterruptible
    168963 ± 4%     -23.4%     129367 ± 0%  sched_debug.cpu#2.ttwu_count
     74340 ± 8%     +45.6%     108231 ± 7%  sched_debug.cpu#6.nr_switches
         1 ±28%   +1560.0%         27 ±49%  sched_debug.cpu#1.cpu_load[2]
     21505 ±13%     +67.3%      35987 ± 4%  sched_debug.cpu#5.sched_goidle
        55 ±28%    +143.6%        134 ±14%  sched_debug.cfs_rq[0]:/.blocked_load_avg
      2987 ± 0%     +49.9%       4477 ± 0%  cpuidle.POLL.usage
    216974 ± 1%     -16.2%     181870 ± 9%  sched_debug.cpu#3.sched_goidle
     34261 ± 8%     +39.4%      47774 ± 8%  sched_debug.cpu#6.sched_goidle
       286 ±13%     +32.8%        380 ± 1%  sched_debug.cpu#7.nr_uninterruptible
      3.98 ± 1%     +49.0%       5.92 ± 1%  turbostat.%c3
   1164419 ± 0%     +47.6%    1718674 ± 0%  proc-vmstat.pgalloc_dma32
     48716 ±12%     +72.1%      83860 ± 3%  sched_debug.cpu#5.nr_switches
      5676 ± 5%     +12.8%       6401 ± 3%  sched_debug.cfs_rq[3]:/.min_vruntime
     37862 ± 8%     +40.1%      53053 ±10%  sched_debug.cpu#4.sched_goidle
     83271 ± 7%     +46.5%     121990 ± 8%  sched_debug.cpu#4.nr_switches
    398812 ± 0%     +46.4%     583757 ± 0%  proc-vmstat.pgalloc_normal
    334712 ± 4%     -18.3%     273483 ± 0%  sched_debug.cpu#2.sched_count
    437235 ± 1%     -15.5%     369670 ± 8%  sched_debug.cpu#3.nr_switches
     11007 ± 5%     +32.5%      14585 ± 2%  sched_debug.cfs_rq[6]:/.min_vruntime
        45 ±11%     +92.6%         87 ± 9%  sched_debug.cfs_rq[1]:/.tg_runnable_contrib
      2133 ±10%     +89.3%       4039 ± 9%  sched_debug.cfs_rq[1]:/.avg->runnable_avg_sum
      5686 ± 5%     +45.1%       8248 ± 2%  sched_debug.cfs_rq[6]:/.exec_clock
        59 ±16%    +169.8%        161 ±13%  sched_debug.cfs_rq[0]:/.tg_load_contrib
    217819 ± 1%     -18.2%     178157 ± 9%  sched_debug.cpu#3.ttwu_count
    437287 ± 1%     -15.4%     369733 ± 8%  sched_debug.cpu#3.sched_count
     30.42 ± 1%     -50.3%      15.11 ± 2%  turbostat.%pc6
    115697 ± 0%    +100.0%     231357 ± 1%  cpuidle.C3-NHM.usage
        73 ±23%    +133.3%        170 ±25%  sched_debug.cfs_rq[1]:/.tg_load_contrib
        68 ±22%    +127.0%        154 ±29%  sched_debug.cfs_rq[1]:/.blocked_load_avg
        40 ±26%     +59.5%         64 ±17%  sched_debug.cpu#5.cpu_load[3]
     54634 ± 1%     +79.7%      98153 ± 5%  sched_debug.cpu#7.nr_switches
    334661 ± 4%     -18.3%     273419 ± 0%  sched_debug.cpu#2.nr_switches
    165837 ± 4%     -19.2%     134051 ± 0%  sched_debug.cpu#2.sched_goidle
     24575 ± 1%     +75.9%      43216 ± 5%  sched_debug.cpu#7.sched_goidle
        27 ±13%     +65.9%         45 ±20%  sched_debug.cpu#5.cpu_load[4]
    189542 ± 1%     -16.6%     158027 ±10%  sched_debug.cpu#3.ttwu_local
     54684 ± 1%     +79.6%      98192 ± 5%  sched_debug.cpu#7.sched_count
     31471 ± 0%     +66.7%      52466 ± 0%  sched_debug.cpu#7.nr_load_updates
      1120 ±19%     +28.5%       1439 ±11%  sched_debug.cfs_rq[4]:/.blocked_load_avg
     32395 ± 1%     +71.5%      55564 ± 0%  sched_debug.cpu#6.nr_load_updates
      3844 ± 0%     +58.3%       6085 ± 0%  proc-vmstat.nr_written
      5966 ± 0%     +14.8%       6851 ± 5%  sched_debug.cfs_rq[1]:/.min_vruntime
     34252 ± 1%     +68.6%      57744 ± 0%  sched_debug.cpu#4.nr_load_updates
     30594 ± 2%     +64.6%      50355 ± 1%  sched_debug.cpu#5.nr_load_updates
      3839 ± 0%     +58.5%       6085 ± 0%  proc-vmstat.nr_dirtied
  96594258 ± 0%     +48.5%  1.434e+08 ± 1%  cpuidle.C3-NHM.time
      8501 ± 1%     +12.6%       9575 ± 2%  sched_debug.cfs_rq[0]:/.min_vruntime
      5973 ± 5%     +19.1%       7112 ± 0%  sched_debug.cfs_rq[2]:/.min_vruntime
     10312 ± 6%     +25.5%      12945 ± 2%  sched_debug.cfs_rq[7]:/.min_vruntime
 4.016e+08 ± 0%     +58.7%  6.375e+08 ± 0%  cpuidle.C1-NHM.time
   1074730 ± 0%     +58.5%    1702978 ± 0%  cpuidle.C1-NHM.usage
        35 ± 2%     +55.7%         55 ±24%  sched_debug.cpu#6.cpu_load[4]
      5205 ± 4%     +32.0%       6872 ± 2%  sched_debug.cfs_rq[7]:/.exec_clock
     11362 ± 5%     +38.1%      15693 ± 2%  softirqs.NET_RX
     30.76 ± 0%     +35.7%      41.76 ± 0%  turbostat.%c1
      6215 ± 4%     +18.2%       7347 ± 5%  sched_debug.cfs_rq[0]:/.tg_load_avg
       559 ± 4%     +37.5%        769 ±10%  sched_debug.cfs_rq[0]:/.tg->runnable_avg
       579 ± 4%     +37.1%        794 ± 9%  sched_debug.cfs_rq[1]:/.tg->runnable_avg
       588 ± 3%     +36.9%        806 ±10%  sched_debug.cfs_rq[2]:/.tg->runnable_avg
       622 ± 3%     +36.2%        848 ±10%  sched_debug.cfs_rq[5]:/.tg->runnable_avg
 1.714e+09 ± 0%     -20.2%  1.368e+09 ± 0%  cpuidle.C6-NHM.time
       599 ± 3%     +36.0%        815 ±10%  sched_debug.cfs_rq[3]:/.tg->runnable_avg
       615 ± 3%     +35.7%        835 ±10%  sched_debug.cfs_rq[4]:/.tg->runnable_avg
       635 ± 2%     +36.0%        863 ± 9%  sched_debug.cfs_rq[6]:/.tg->runnable_avg
       646 ± 2%     +35.3%        874 ± 9%  sched_debug.cfs_rq[7]:/.tg->runnable_avg
      6295 ± 4%     +16.7%       7347 ± 4%  sched_debug.cfs_rq[1]:/.tg_load_avg
      6407 ± 4%     +17.1%       7501 ± 4%  sched_debug.cfs_rq[5]:/.tg_load_avg
      6323 ± 4%     +18.1%       7465 ± 4%  sched_debug.cfs_rq[3]:/.tg_load_avg
      6425 ± 4%     +16.5%       7487 ± 3%  sched_debug.cfs_rq[6]:/.tg_load_avg
      6332 ± 4%     +17.2%       7418 ± 5%  sched_debug.cfs_rq[2]:/.tg_load_avg
      6417 ± 4%     +16.1%       7452 ± 4%  sched_debug.cfs_rq[7]:/.tg_load_avg
      4.23 ± 2%     +15.9%       4.91 ± 3%  turbostat.%pc3
      6378 ± 4%     +17.3%       7480 ± 5%  sched_debug.cfs_rq[4]:/.tg_load_avg
  56450565 ± 0%     +13.2%   63882668 ± 1%  cpuidle.C1E-NHM.time
    101678 ± 0%     +12.9%     114794 ± 0%  softirqs.TIMER
        47 ± 3%      +8.5%         51 ± 4%  turbostat.CTMP
     20813 ± 0%     +95.2%      40618 ± 0%  time.involuntary_context_switches
     30496 ± 0%     +58.7%      48386 ± 0%  time.file_system_outputs
     55307 ± 0%     +58.9%      87877 ± 0%  time.voluntary_context_switches
   1155035 ± 0%     +58.7%    1833059 ± 0%  time.minor_page_faults
      6.60 ± 0%     +36.9%       9.03 ± 0%  turbostat.%c0
        11 ± 0%     +45.5%         16 ± 0%  time.percent_of_cpu_this_job_got
     31.28 ± 0%     +39.9%      43.76 ± 0%  time.system_time
      8112 ± 0%      +3.3%       8378 ± 0%  vmstat.system.cs
      7738 ± 0%     +36.5%      10566 ± 0%  vmstat.system.in

testbox/testcase/testparams: lkp-a06/qperf/600s

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     75582 ± 2%      -3.1%      73228 ± 0%  qperf.sctp.latency
 6.479e+08 ± 0%      -0.9%   6.42e+08 ± 0%  qperf.udp.recv_bw
 6.561e+08 ± 0%      -1.3%  6.477e+08 ± 0%  qperf.udp.send_bw
   -148722 ±-11%     +44.8%    -215280 ±-15%  sched_debug.cfs_rq[3]:/.spread0
    196852 ±31%     -30.1%     137556 ± 4%  sched_debug.cpu#1.ttwu_local
     16973 ± 4%      -9.2%      15414 ± 3%  cpuidle.POLL.time
      3.30 ±39%     -61.6%       1.27 ±17%  perf-profile.cpu-cycles.copy_user_generic_string.skb_copy_datagram_iovec.tcp_recvmsg.inet_recvmsg.sock_aio_read
       197 ± 1%      -6.9%        183 ± 6%  sched_debug.cpu#2.cpu_load[3]
       329 ± 5%     -13.2%        285 ± 9%  sched_debug.cfs_rq[2]:/.load
       422 ±18%     -23.4%        323 ±20%  sched_debug.cfs_rq[3]:/.blocked_load_avg
       624 ±13%     -16.3%        522 ±10%  sched_debug.cfs_rq[3]:/.tg_load_contrib
   3715157 ± 2%     +11.7%    4149477 ± 0%  sched_debug.cpu#0.sched_count
       323 ± 3%     -13.4%        280 ± 6%  sched_debug.cpu#2.load
       186 ± 8%     +12.4%        209 ± 6%  sched_debug.cpu#0.cpu_load[0]
       353 ± 7%     -20.4%        281 ± 9%  sched_debug.cfs_rq[1]:/.load
    457483 ± 9%     +20.2%     549887 ± 8%  sched_debug.cpu#1.avg_idle
    100532 ±18%     -40.7%      59572 ±17%  meminfo.DirectMap4k
       246 ± 7%     -12.2%        216 ± 2%  sched_debug.cfs_rq[2]:/.runnable_load_avg
     84774 ± 4%     -23.5%      64863 ± 4%  softirqs.RCU
     16026 ± 5%     -16.3%      13414 ± 4%  cpuidle.C2-ATM.usage
   9358028 ± 6%     -17.8%    7692487 ± 6%  cpuidle.C4-ATM.time
      5313 ± 7%     -25.2%       3972 ±10%  cpuidle.C4-ATM.usage
      1769 ± 2%     +14.6%       2027 ± 6%  slabinfo.kmalloc-192.active_objs
     85994 ± 1%     -14.2%      73762 ± 1%  softirqs.SCHED
    150630 ± 3%     -16.0%     126496 ± 4%  cpuidle.C6-ATM.usage
    116081 ± 0%     +12.5%     130610 ± 1%  time.involuntary_context_switches

testbox/testcase/testparams: lkp-sb03/nepim/300s-100%-tcp

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
      2499 ± 2%      -6.1%       2347 ± 2%  nepim.tcp.avg.snd_s
    655257 ± 2%      -6.1%     615397 ± 2%  nepim.tcp.avg.kbps_out
    654746 ± 2%      -6.0%     615555 ± 2%  nepim.tcp.avg.kbps_in
      2497 ± 2%      -6.0%       2348 ± 2%  nepim.tcp.avg.rcv_s
   -163648 ±-14%     -33.4%    -108977 ±-9%  sched_debug.cfs_rq[24]:/.spread0
   -162978 ±-14%     -34.9%    -106150 ±-9%  sched_debug.cfs_rq[21]:/.spread0
   -163786 ±-14%     -33.3%    -109304 ±-10%  sched_debug.cfs_rq[30]:/.spread0
   -161694 ±-15%     -47.6%     -84805 ±-32%  sched_debug.cfs_rq[14]:/.spread0
   -154868 ±-18%     -37.2%     -97180 ±-4%  sched_debug.cfs_rq[12]:/.spread0
      2705 ±29%     -83.0%        461 ±38%  sched_debug.cpu#9.ttwu_local
   -145997 ±-22%     -37.5%     -91304 ±-11%  sched_debug.cfs_rq[11]:/.spread0
   -163278 ±-15%     -44.7%     -90304 ±-20%  sched_debug.cfs_rq[15]:/.spread0
   -156828 ±-16%     -35.9%    -100544 ±-12%  sched_debug.cfs_rq[17]:/.spread0
   -163188 ±-15%     -33.9%    -107948 ±-9%  sched_debug.cfs_rq[23]:/.spread0
   -161060 ±-14%     -36.7%    -102013 ±-8%  sched_debug.cfs_rq[18]:/.spread0
   -156604 ±-15%     -35.2%    -101557 ±-11%  sched_debug.cfs_rq[25]:/.spread0
   -162125 ±-13%     -34.2%    -106729 ±-9%  sched_debug.cfs_rq[29]:/.spread0
   -162791 ±-15%     -34.5%    -106675 ±-10%  sched_debug.cfs_rq[31]:/.spread0
   -163378 ±-15%     -36.0%    -104576 ±-10%  sched_debug.cfs_rq[22]:/.spread0
    -81764 ±-12%     -42.8%     -46748 ±-22%  sched_debug.cfs_rq[1]:/.spread0
   -152211 ±-18%     -51.6%     -73594 ±-41%  sched_debug.cfs_rq[5]:/.spread0
   -158111 ±-15%     -31.9%    -107656 ±-10%  sched_debug.cfs_rq[19]:/.spread0
   -161454 ±-14%     -34.5%    -105758 ±-10%  sched_debug.cfs_rq[20]:/.spread0
   -157597 ±-18%     -32.7%    -106088 ±-9%  sched_debug.cfs_rq[26]:/.spread0
   -157783 ±-10%     -31.7%    -107791 ±-9%  sched_debug.cfs_rq[16]:/.spread0
   -163864 ±-14%     -34.5%    -107286 ±-9%  sched_debug.cfs_rq[27]:/.spread0
   -160294 ±-16%     -43.2%     -91021 ±-21%  sched_debug.cfs_rq[13]:/.spread0
   -154265 ±-17%     -57.9%     -64949 ±-48%  sched_debug.cfs_rq[4]:/.spread0
   -156174 ±-13%     -56.0%     -68677 ±-46%  sched_debug.cfs_rq[7]:/.spread0
   -163039 ±-14%     -35.4%    -105312 ±-9%  sched_debug.cfs_rq[28]:/.spread0
      2648 ±17%     -70.4%        784 ±37%  sched_debug.cpu#12.ttwu_local
      3794 ±13%     -71.5%       1082 ±43%  sched_debug.cpu#4.ttwu_local
      4710 ±28%     -83.9%        756 ±38%  sched_debug.cpu#1.ttwu_local
     39796 ±46%     -68.5%      12541 ±17%  cpuidle.C6-SNB.time
       293 ± 2%     +49.7%        439 ±22%  sched_debug.cpu#31.ttwu_count
      2434 ±41%     +57.1%       3824 ±10%  sched_debug.cpu#8.ttwu_local
  54924.58 ±23%     -64.4%   19562.82 ±36%  sched_debug.cfs_rq[9]:/.exec_clock
       190 ± 4%     -44.6%        105 ±12%  sched_debug.cpu#0.load
    453881 ±15%     -67.5%     147391 ±30%  sched_debug.cpu#9.sched_count
        10 ±36%     -43.8%          6 ±23%  sched_debug.cpu#18.nr_uninterruptible
    209867 ±24%     -57.2%      89799 ±21%  sched_debug.cpu#8.ttwu_count
        23 ±43%     +77.5%         42 ±16%  numa-numastat.node0.other_node
      3549 ± 6%     +67.4%       5941 ± 1%  sched_debug.cpu#25.ttwu_count
         1 ± 0%    +166.7%          2 ±17%  sched_debug.cfs_rq[18]:/.nr_spread_over
       665 ±13%    +145.1%       1631 ±42%  sched_debug.cfs_rq[28]:/.exec_clock
       588 ±36%     +38.8%        816 ± 4%  sched_debug.cpu#27.ttwu_count
      2526 ± 3%     -48.9%       1291 ±31%  sched_debug.cpu#11.ttwu_local
       626 ±11%     -52.8%        296 ±20%  sched_debug.cpu#23.sched_goidle
       192 ± 4%     -49.0%         98 ±12%  sched_debug.cfs_rq[0]:/.load
     24.72 ± 6%     -18.7%      20.10 ± 6%  turbostat.%pc2
      1763 ± 1%     -50.5%        872 ±10%  sched_debug.cpu#0.curr->pid
     58263 ±29%    +106.5%     120293 ±32%  sched_debug.cpu#4.sched_count
      1176 ± 9%     +63.0%       1916 ± 6%  sched_debug.cpu#25.ttwu_local
         3 ±27%    +122.2%          6 ±46%  sched_debug.cfs_rq[11]:/.runnable_load_avg
       242 ± 7%     -42.5%        139 ± 9%  sched_debug.cpu#0.cpu_load[2]
       128 ±15%     -41.6%         75 ±19%  sched_debug.cpu#1.cpu_load[2]
       471 ±26%    +133.4%       1101 ±38%  sched_debug.cfs_rq[21]:/.exec_clock
       192 ± 3%     -49.7%         97 ±12%  sched_debug.cfs_rq[0]:/.runnable_load_avg
       263 ± 8%     -41.3%        154 ± 8%  sched_debug.cpu#0.cpu_load[3]
        22 ±14%     +64.7%         37 ±15%  sched_debug.cfs_rq[11]:/.tg_runnable_contrib
    451167 ±15%     -67.8%     145407 ±30%  sched_debug.cpu#9.nr_switches
      1076 ±13%     +64.1%       1766 ±14%  sched_debug.cfs_rq[11]:/.avg->runnable_avg_sum
    923811 ± 3%      -8.6%     844463 ± 7%  sched_debug.cpu#2.avg_idle
       348 ±13%     -33.5%        231 ±29%  sched_debug.cfs_rq[18]:/.tg_load_contrib
       141 ±16%     -43.5%         79 ±18%  sched_debug.cpu#1.cpu_load[3]
      1350 ±21%    +192.3%       3946 ±30%  sched_debug.cpu#21.ttwu_count
      1334 ±10%     -52.4%        635 ±17%  sched_debug.cpu#23.nr_switches
       346 ±20%     -65.6%        119 ±48%  sched_debug.cfs_rq[9]:/.tg_runnable_contrib
     15865 ±20%     -65.6%       5457 ±47%  sched_debug.cfs_rq[9]:/.avg->runnable_avg_sum
       216 ± 6%     -43.9%        121 ± 9%  sched_debug.cpu#0.cpu_load[1]
       344 ±15%     -33.8%        228 ±32%  sched_debug.cfs_rq[18]:/.blocked_load_avg
      0.94 ±12%     -46.6%       0.50 ±29%  turbostat.%c3
     53828 ±17%    +138.4%     128330 ±38%  sched_debug.cpu#0.sched_count
       276 ± 8%     -39.9%        166 ± 6%  sched_debug.cpu#0.cpu_load[4]
       115 ±14%     -39.2%         70 ±23%  sched_debug.cpu#1.cpu_load[1]
       150 ±14%     -44.8%         83 ±17%  sched_debug.cpu#1.cpu_load[4]
       117 ±21%     -62.7%         43 ±38%  sched_debug.cpu#9.cpu_load[2]
       104 ±18%     -60.7%         41 ±32%  sched_debug.cpu#9.cpu_load[1]
    224950 ±14%     -67.8%      72354 ±30%  sched_debug.cpu#9.sched_goidle
        95 ±17%     -56.1%         42 ±24%  sched_debug.cfs_rq[9]:/.load
 3.634e+08 ± 3%      -8.0%  3.343e+08 ± 5%  proc-vmstat.pgalloc_normal
     38481 ±14%     -27.7%      27816 ± 0%  sched_debug.cfs_rq[1]:/.exec_clock
      3095 ± 9%    +114.8%       6648 ± 6%  sched_debug.cpu#17.ttwu_count
       101 ±28%     -62.2%         38 ±29%  sched_debug.cpu#9.load
    116290 ±21%     -63.1%      42940 ±35%  sched_debug.cfs_rq[9]:/.min_vruntime
       318 ± 6%     -53.0%        149 ± 7%  sched_debug.cfs_rq[1]:/.tg_runnable_contrib
       195 ± 3%     -47.7%        102 ±10%  sched_debug.cpu#0.cpu_load[0]
     14526 ± 7%     -52.8%       6853 ± 7%  sched_debug.cfs_rq[1]:/.avg->runnable_avg_sum
       195 ± 4%     -50.0%         97 ±13%  sched_debug.cfs_rq[0]:/.tg_load_contrib
      4452 ±16%    +104.1%       9084 ±15%  sched_debug.cpu#28.ttwu_count
       109 ±11%     -39.4%         66 ±31%  sched_debug.cpu#1.cpu_load[0]
      5937 ± 8%     +45.3%       8626 ± 7%  sched_debug.cpu#17.sched_count
      2727 ±29%     -39.7%       1644 ±15%  sched_debug.cfs_rq[30]:/.min_vruntime
        93 ±14%     +47.3%        137 ±12%  sched_debug.cpu#27.ttwu_local
       110 ±14%     -53.3%         51 ±15%  sched_debug.cfs_rq[1]:/.tg_load_contrib
       509 ±20%     +57.1%        799 ±18%  sched_debug.cpu#28.ttwu_local
    180930 ±17%     -48.4%      93315 ± 8%  sched_debug.cpu#1.sched_goidle
       529 ± 7%     -47.8%        276 ±12%  sched_debug.cfs_rq[0]:/.tg_runnable_contrib
       106 ±17%     -58.0%         44 ±10%  sched_debug.cfs_rq[1]:/.runnable_load_avg
     24335 ± 7%     -47.9%      12681 ±12%  sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum
       116 ±16%     -59.6%         47 ±10%  sched_debug.cfs_rq[1]:/.load
      1050 ±28%     -61.4%        405 ±24%  sched_debug.cpu#9.curr->pid
     81635 ± 5%      -7.0%      75959 ± 4%  sched_debug.cpu#19.nr_load_updates
      2611 ± 7%     -29.7%       1834 ±19%  sched_debug.cpu#3.ttwu_local
      2454 ±10%     +20.0%       2944 ± 1%  sched_debug.cpu#17.sched_goidle
    201182 ±17%     -48.1%     104439 ±10%  sched_debug.cpu#0.ttwu_count
       997 ±22%     +34.2%       1338 ±20%  proc-vmstat.numa_hint_faults_local
    362192 ±17%     -48.1%     187835 ± 8%  sched_debug.cpu#1.nr_switches
      1093 ± 8%     +72.8%       1889 ± 7%  sched_debug.cpu#17.ttwu_local
       105 ± 9%     -51.9%         50 ± 9%  sched_debug.cpu#1.load
      5926 ± 8%     +35.7%       8040 ± 2%  sched_debug.cpu#17.nr_switches
    566873 ±13%     +29.7%     735000 ± 8%  sched_debug.cpu#1.avg_idle
       112 ±21%     -62.5%         42 ±26%  sched_debug.cfs_rq[9]:/.tg_load_contrib
      3534 ±15%     +35.8%       4798 ± 9%  sched_debug.cfs_rq[21]:/.min_vruntime
      1085 ± 8%     -55.1%        487 ± 7%  sched_debug.cpu#1.curr->pid
    105312 ± 9%     -17.5%      86874 ± 5%  sched_debug.cpu#9.nr_load_updates
      3473 ±11%     +62.3%       5636 ±14%  sched_debug.cfs_rq[28]:/.min_vruntime
       822 ± 8%     +74.0%       1430 ±19%  sched_debug.cpu#19.ttwu_count
    380149 ±18%     -47.1%     201060 ± 7%  sched_debug.cpu#1.sched_count
       134 ±23%     -64.9%         47 ±43%  sched_debug.cpu#9.cpu_load[3]
     97430 ± 3%     -10.0%      87706 ± 6%  sched_debug.cpu#1.nr_load_updates
     84743 ±16%     -24.2%      64197 ± 1%  sched_debug.cfs_rq[1]:/.min_vruntime
        65 ± 9%     +62.9%        107 ±30%  sched_debug.cpu#31.ttwu_local
     93974 ± 9%     -13.1%      81632 ± 7%  sched_debug.cpu#10.nr_load_updates
    970168 ± 4%      -4.7%     925055 ± 5%  sched_debug.cpu#6.avg_idle
  99271909 ±11%     +46.2%  1.451e+08 ± 5%  cpuidle.C1-SNB.time
       101 ±15%     -58.7%         42 ±26%  sched_debug.cpu#9.cpu_load[0]
     82245 ±14%     -37.9%      51114 ±14%  sched_debug.cpu#0.nr_load_updates
     34310 ± 3%     +24.7%      42799 ± 8%  softirqs.RCU
       149 ±24%     -65.8%         51 ±45%  sched_debug.cpu#9.cpu_load[4]
     79674 ±14%     -41.6%      46569 ±14%  sched_debug.cfs_rq[0]:/.exec_clock
    166507 ±14%     -33.4%     110946 ± 9%  sched_debug.cfs_rq[0]:/.min_vruntime
        88 ±16%     -56.4%         38 ±25%  sched_debug.cfs_rq[9]:/.runnable_load_avg
     87747 ± 7%      -8.1%      80678 ± 6%  sched_debug.cpu#11.nr_load_updates
      1185 ±32%     -41.6%        693 ± 6%  sched_debug.cpu#18.sched_goidle
     85483 ± 6%      -6.9%      79608 ± 4%  sched_debug.cpu#12.nr_load_updates
       731 ± 0%     +25.5%        917 ± 9%  slabinfo.blkdev_requests.active_objs
       731 ± 0%     +25.5%        917 ± 9%  slabinfo.blkdev_requests.num_objs
       748 ±18%     +26.9%        950 ± 7%  sched_debug.cpu#26.sched_goidle
     58322 ±13%     +22.4%      71395 ± 6%  sched_debug.cpu#2.nr_load_updates
    300852 ± 3%     -22.5%     233044 ± 2%  cpuidle.C7-SNB.usage
    571714 ± 5%     +24.2%     710013 ± 9%  sched_debug.cpu#9.avg_idle
     10.29 ± 5%      +9.3%      11.25 ± 2%  turbostat.%c1
       742 ± 2%     +22.6%        910 ± 7%  slabinfo.xfs_buf.num_objs
       742 ± 2%     +22.6%        910 ± 7%  slabinfo.xfs_buf.active_objs
       383 ± 5%     +14.9%        441 ± 5%  numa-vmstat.node1.nr_page_table_pages
      1533 ± 4%     +15.4%       1769 ± 6%  numa-meminfo.node1.PageTables
       524 ± 3%     -14.4%        448 ± 9%  numa-vmstat.node0.nr_page_table_pages
      2081 ± 3%     -13.8%       1794 ± 9%  numa-meminfo.node0.PageTables
     12203 ± 4%      +6.3%      12970 ± 2%  slabinfo.kmalloc-256.num_objs
       546 ±24%   +2329.3%      13280 ± 8%  time.involuntary_context_switches
      1827 ± 5%     +23.9%       2263 ±14%  time.minor_page_faults
      3166 ± 0%      -5.8%       2984 ± 0%  vmstat.system.in

testbox/testcase/testparams: xps2/pigz/100%-128K

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
         3 ±27%    +500.0%         18 ±16%  sched_debug.cfs_rq[7]:/.nr_spread_over
        10 ± 4%     -71.0%          3 ±27%  sched_debug.cfs_rq[4]:/.nr_spread_over
       575 ±44%     +75.4%       1009 ±14%  sched_debug.cfs_rq[5]:/.tg_load_contrib
         2 ± 0%    +116.7%          4 ±10%  sched_debug.cfs_rq[0]:/.nr_spread_over
       116 ± 5%     +19.4%        139 ± 6%  sched_debug.cfs_rq[7]:/.load
         8 ±30%     +50.0%         13 ±16%  sched_debug.cfs_rq[5]:/.nr_spread_over
       114 ± 2%     +11.4%        127 ± 3%  sched_debug.cfs_rq[7]:/.runnable_load_avg
        10 ± 4%     +18.8%         12 ± 3%  cpuidle.POLL.usage
       115 ± 3%     +24.1%        142 ± 4%  sched_debug.cpu#7.load
       111 ± 4%      +9.9%        122 ± 1%  sched_debug.cpu#5.cpu_load[1]
       109 ± 4%     +11.6%        122 ± 1%  sched_debug.cpu#5.cpu_load[2]
       303 ±14%     -31.0%        209 ±26%  sched_debug.cfs_rq[1]:/.blocked_load_avg
       109 ± 3%     +10.7%        120 ± 1%  sched_debug.cpu#5.cpu_load[3]
     11242 ±39%     -46.6%       6002 ±27%  sched_debug.cpu#2.sched_goidle
       109 ± 3%      +8.6%        118 ± 1%  sched_debug.cpu#5.cpu_load[4]
      5622 ±24%     +78.6%      10041 ±16%  sched_debug.cpu#0.sched_goidle
       113 ± 1%     +12.6%        128 ± 6%  sched_debug.cpu#7.cpu_load[1]
      2051 ± 2%     -21.3%       1614 ±16%  slabinfo.kmalloc-256.active_objs
      1428 ±11%     -20.1%       1140 ± 4%  cpuidle.C6-NHM.usage
       966 ± 3%     +23.2%       1190 ± 4%  slabinfo.kmalloc-96.active_objs
       966 ± 3%     +23.2%       1190 ± 4%  slabinfo.kmalloc-96.num_objs
       112 ± 0%     +16.0%        130 ± 5%  sched_debug.cpu#7.cpu_load[0]
      2244 ± 3%     -12.3%       1969 ± 6%  slabinfo.kmalloc-256.num_objs

testbox/testcase/testparams: lkp-a05/iperf/300s-tcp

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
      8639 ± 6%     -55.0%       3890 ±11%  cpuidle.POLL.time
       324 ±12%     +23.4%        400 ± 1%  sched_debug.cfs_rq[3]:/.blocked_load_avg
       351 ± 5%     -34.7%        229 ± 6%  cpuidle.POLL.usage
       538 ±11%     +21.3%        653 ± 4%  sched_debug.cfs_rq[3]:/.tg_load_contrib
       188 ± 8%     +17.2%        221 ± 8%  sched_debug.cpu#3.cpu_load[3]
      2271 ± 5%     +15.9%       2632 ± 7%  sched_debug.cpu#1.curr->pid
      6143 ± 6%     -20.8%       4864 ± 5%  cpuidle.C2-ATM.usage
       168 ± 9%     +23.0%        207 ± 7%  sched_debug.cpu#3.cpu_load[4]
   4822666 ± 6%     -20.7%    3824022 ± 5%  cpuidle.C4-ATM.time
      2978 ± 1%     -25.4%       2221 ± 4%  cpuidle.C4-ATM.usage
    135546 ± 4%      -7.4%     125521 ± 1%  sched_debug.cpu#2.nr_load_updates
     44960 ± 5%     -24.3%      34026 ± 2%  softirqs.SCHED
     59568 ± 1%     -22.3%      46262 ± 4%  cpuidle.C6-ATM.usage
     31677 ± 0%     +42.5%      45147 ± 1%  time.involuntary_context_switches

testbox/testcase/testparams: lkp-sb03/nepim/300s-100%-tcp6

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
   -175469 ±-9%     -45.6%     -95473 ±-2%  sched_debug.cfs_rq[24]:/.spread0
   -171833 ±-9%     -45.1%     -94396 ±-3%  sched_debug.cfs_rq[21]:/.spread0
   -175185 ±-9%     -46.3%     -94082 ±-4%  sched_debug.cfs_rq[30]:/.spread0
      9641 ±29%    +510.9%      58903 ±13%  sched_debug.cfs_rq[12]:/.min_vruntime
      2277 ±28%   +1040.1%      25970 ±15%  sched_debug.cfs_rq[12]:/.exec_clock
   -167372 ±-10%     -60.2%     -66538 ±-5%  sched_debug.cfs_rq[14]:/.spread0
   -167598 ±-11%     -75.7%     -40731 ±-14%  sched_debug.cfs_rq[12]:/.spread0
      7439 ±14%    +635.8%      54741 ±21%  sched_debug.cfs_rq[15]:/.min_vruntime
   -169801 ±-9%     -73.6%     -44894 ±-31%  sched_debug.cfs_rq[15]:/.spread0
   -168310 ±-9%     -46.6%     -89926 ±-2%  sched_debug.cfs_rq[17]:/.spread0
   -174844 ±-9%     -44.5%     -96979 ±-3%  sched_debug.cfs_rq[23]:/.spread0
   -173449 ±-9%     -45.2%     -95119 ±-2%  sched_debug.cfs_rq[18]:/.spread0
   -167940 ±-9%     -47.1%     -88900 ±-2%  sched_debug.cfs_rq[25]:/.spread0
   -174120 ±-9%     -44.6%     -96498 ±-2%  sched_debug.cfs_rq[29]:/.spread0
   -173030 ±-8%     -44.8%     -95548 ±-2%  sched_debug.cfs_rq[31]:/.spread0
     90.71 ±47%   +1113.5%    1100.77 ± 7%  sched_debug.cfs_rq[24]:/.exec_clock
   -172929 ±-9%     -44.0%     -96907 ±-3%  sched_debug.cfs_rq[22]:/.spread0
    -79197 ±-12%     -25.9%     -58693 ±-10%  sched_debug.cfs_rq[1]:/.spread0
   -152042 ±-8%     -38.2%     -93998 ±-3%  sched_debug.cfs_rq[5]:/.spread0
   -160250 ±-10%     -50.3%     -79621 ±-4%  sched_debug.cfs_rq[3]:/.spread0
   -173703 ±-9%     -44.5%     -96326 ±-2%  sched_debug.cfs_rq[19]:/.spread0
   -161707 ±-6%     -46.3%     -86771 ±-1%  sched_debug.cfs_rq[2]:/.spread0
   -170621 ±-10%     -47.6%     -89343 ±-3%  sched_debug.cfs_rq[20]:/.spread0
   -167504 ±-10%     -42.7%     -95923 ±-2%  sched_debug.cfs_rq[6]:/.spread0
   -171102 ±-8%     -51.3%     -83293 ±-13%  sched_debug.cfs_rq[26]:/.spread0
   -172487 ±-10%     -44.0%     -96550 ±-1%  sched_debug.cfs_rq[16]:/.spread0
   -172553 ±-9%     -46.1%     -92991 ±-2%  sched_debug.cfs_rq[27]:/.spread0
   -162867 ±-7%     -74.9%     -40947 ±-16%  sched_debug.cfs_rq[13]:/.spread0
      3582 ±24%     -92.2%        277 ±45%  sched_debug.cpu#5.ttwu_local
         1 ±35%    +825.0%         12 ± 7%  sched_debug.cpu#26.cpu_load[1]
   -166730 ±-11%     -45.7%     -90466 ±-1%  sched_debug.cfs_rq[4]:/.spread0
   -170615 ±-9%     -45.1%     -93612 ±-1%  sched_debug.cfs_rq[7]:/.spread0
   -170862 ±-10%     -45.6%     -92877 ±-3%  sched_debug.cfs_rq[28]:/.spread0
      2409 ± 7%     -93.0%        169 ±24%  sched_debug.cpu#7.ttwu_local
      2923 ±29%     -66.4%        983 ±37%  sched_debug.cpu#12.ttwu_local
        -6 ±-18%     -70.0%         -2 ±-40%  sched_debug.cpu#9.nr_uninterruptible
      3067 ±38%     -68.0%        982 ±30%  sched_debug.cpu#14.ttwu_local
      2931 ± 7%     -81.3%        547 ±40%  sched_debug.cpu#4.ttwu_local
      4447 ±15%     -37.3%       2790 ±19%  sched_debug.cpu#15.ttwu_local
    -77693 ±-33%     -68.9%     -24161 ±-39%  sched_debug.cfs_rq[9]:/.spread0
   -154541 ±-17%     -73.6%     -40812 ±-16%  sched_debug.cfs_rq[10]:/.spread0
         2 ±40%   +7216.7%        146 ±13%  sched_debug.cfs_rq[13]:/.tg_runnable_contrib
        38 ±39%     -55.3%         17 ±29%  sched_debug.cfs_rq[3]:/.tg_runnable_contrib
      1771 ±38%     -53.8%        818 ±26%  sched_debug.cfs_rq[3]:/.avg->runnable_avg_sum
      5503 ±14%    +988.7%      59913 ±43%  sched_debug.cpu#15.ttwu_count
        30 ±12%     -31.9%         20 ±18%  sched_debug.cpu#25.nr_uninterruptible
        15 ± 6%     +42.6%         22 ±16%  sched_debug.cpu#17.nr_uninterruptible
         0 ± 0%      +Inf%         62 ±11%  sched_debug.cpu#13.cpu_load[4]
         0 ± 0%      +Inf%         56 ±10%  sched_debug.cpu#13.cpu_load[3]
         1 ± 0%    +133.3%          2 ±20%  sched_debug.cfs_rq[20]:/.nr_spread_over
      7389 ±12%     +26.6%       9356 ± 7%  sched_debug.cpu#25.nr_switches
      7939 ±23%     -87.0%       1036 ±11%  sched_debug.cpu#5.ttwu_count
      3883 ±19%     -80.8%        745 ±11%  sched_debug.cpu#7.ttwu_count
       423 ± 6%    +151.3%       1063 ±42%  sched_debug.cpu#31.ttwu_count
       131 ±35%   +5024.7%       6713 ±13%  sched_debug.cfs_rq[13]:/.avg->runnable_avg_sum
         5 ± 8%    +150.0%         13 ±15%  sched_debug.cpu#26.cpu_load[2]
      6749 ± 7%     -94.9%        342 ± 8%  sched_debug.cfs_rq[5]:/.exec_clock
  46851.02 ±10%     -25.0%   35154.20 ±15%  sched_debug.cfs_rq[9]:/.exec_clock
      9868 ±24%    +235.4%      33097 ± 9%  sched_debug.cfs_rq[14]:/.min_vruntime
     14373 ±34%    +308.3%      58688 ±11%  sched_debug.cfs_rq[13]:/.min_vruntime
         3 ±12%    +318.2%         15 ±11%  sched_debug.cpu#26.cpu_load[4]
      7007 ±23%    +296.6%      27792 ±33%  sched_debug.cfs_rq[11]:/.exec_clock
     33105 ±34%    +116.4%      71634 ±15%  sched_debug.cpu#14.sched_count
      5012 ±23%     -65.6%       1725 ±13%  sched_debug.cpu#4.ttwu_count
     21902 ±23%    +520.5%     135902 ±48%  sched_debug.cpu#8.sched_count
      1941 ±32%     +89.7%       3683 ±36%  sched_debug.cpu#21.sched_count
        28 ±41%     -77.9%          6 ±14%  sched_debug.cfs_rq[2]:/.tg_runnable_contrib
         0 ± 0%      +Inf%         76 ±31%  sched_debug.cpu#11.cpu_load[4]
     27194 ±44%    +219.6%      86905 ± 7%  sched_debug.cpu#15.nr_switches
        60 ± 8%    +229.7%        200 ±31%  sched_debug.cpu#30.ttwu_local
      3322 ± 7%     -27.6%       2404 ±30%  sched_debug.cpu#28.sched_count
       174 ±16%     -53.2%         81 ±18%  sched_debug.cpu#0.load
    497648 ± 8%     -49.7%     250454 ±10%  sched_debug.cpu#9.sched_count
      3023 ±15%     -84.8%        459 ±19%  sched_debug.cpu#2.ttwu_local
         5 ± 8%    +158.8%         14 ±14%  sched_debug.cpu#26.cpu_load[3]
     13564 ±44%    +210.7%      42148 ± 8%  sched_debug.cpu#15.sched_goidle
      1158 ±13%     -53.9%        534 ±11%  sched_debug.cpu#29.ttwu_count
    278319 ±11%     -55.5%     123957 ± 8%  sched_debug.cpu#8.ttwu_count
        70 ±33%     +74.8%        122 ± 7%  sched_debug.cpu#24.ttwu_local
      3732 ± 5%     +72.0%       6419 ± 7%  sched_debug.cpu#25.ttwu_count
       760 ± 5%    +134.8%       1784 ±43%  sched_debug.cpu#27.nr_switches
        25 ±19%    -100.0%          0 ± 0%  sched_debug.cfs_rq[9]:/.blocked_load_avg
      1546 ±17%     -28.4%       1107 ±30%  sched_debug.cpu#29.sched_count
       138 ± 3%     -60.5%         54 ±15%  sched_debug.cpu#28.cpu_load[2]
        94 ± 2%     -53.9%         43 ± 9%  sched_debug.cpu#28.cpu_load[3]
       174 ±16%     -53.2%         81 ±18%  sched_debug.cfs_rq[0]:/.load
      1652 ±12%     -52.8%        779 ±20%  sched_debug.cpu#0.curr->pid
      1315 ±11%     +52.1%       2000 ± 3%  sched_debug.cpu#25.ttwu_local
       164 ±32%   +2186.6%       3757 ±13%  sched_debug.cpu#24.ttwu_count
     35074 ±16%    +169.1%      94384 ± 8%  sched_debug.cpu#15.sched_count
      6458 ±41%     -66.4%       2172 ±33%  sched_debug.cpu#1.ttwu_count
         3 ±12%   +1509.1%         59 ±36%  sched_debug.cfs_rq[11]:/.runnable_load_avg
     84863 ± 5%     -44.2%      47316 ± 6%  sched_debug.cfs_rq[8]:/.exec_clock
  11542079 ± 8%     -63.6%    4201723 ± 7%  numa-vmstat.node0.numa_local
        55 ± 2%     -37.3%         34 ± 3%  sched_debug.cpu#28.cpu_load[4]
  11597631 ± 8%     -63.3%    4257210 ± 7%  numa-vmstat.node0.numa_hit
     20087 ±26%    +532.6%     127072 ±42%  sched_debug.cpu#8.nr_switches
      6826 ±22%     -73.1%       1837 ±11%  sched_debug.cpu#2.ttwu_count
     14685 ±23%     -57.7%       6217 ± 9%  sched_debug.cpu#6.nr_switches
    181370 ± 5%     -44.3%     100933 ±10%  sched_debug.cfs_rq[8]:/.min_vruntime
       166 ± 4%     -61.2%         64 ±15%  sched_debug.cpu#28.cpu_load[1]
       246 ±15%     -43.2%        140 ±13%  sched_debug.cpu#0.cpu_load[2]
      1333 ±40%     -76.4%        314 ±12%  sched_debug.cfs_rq[2]:/.avg->runnable_avg_sum
       171 ±14%     -52.8%         80 ±19%  sched_debug.cfs_rq[0]:/.runnable_load_avg
      3309 ± 7%     -27.7%       2392 ±30%  sched_debug.cpu#28.nr_switches
       271 ±13%     -39.1%        165 ±12%  sched_debug.cpu#0.cpu_load[3]
       136 ±12%    +138.0%        325 ±28%  sched_debug.cfs_rq[20]:/.blocked_load_avg
      9301 ± 8%     +15.4%      10734 ±12%  sched_debug.cfs_rq[25]:/.min_vruntime
         0 ± 0%      +Inf%         71 ±31%  sched_debug.cpu#11.cpu_load[3]
        26 ± 8%    +556.4%        170 ±30%  sched_debug.cfs_rq[11]:/.tg_runnable_contrib
    489684 ± 7%     -50.7%     241248 ±13%  sched_debug.cpu#9.nr_switches
      1243 ± 8%    +532.9%       7868 ±30%  sched_debug.cfs_rq[11]:/.avg->runnable_avg_sum
      8102 ±17%     -63.3%       2974 ± 8%  sched_debug.cpu#5.sched_goidle
       168 ± 5%     -60.1%         67 ±12%  sched_debug.cpu#28.cpu_load[0]
      8079 ±12%    +912.4%      81796 ± 9%  sched_debug.cpu#12.sched_goidle
        11 ± 7%    +248.5%         38 ± 7%  sched_debug.cfs_rq[26]:/.tg_runnable_contrib
        67 ±15%     +93.0%        129 ±30%  sched_debug.cpu#22.ttwu_local
       525 ± 7%    +244.4%       1809 ± 7%  sched_debug.cfs_rq[26]:/.avg->runnable_avg_sum
       217 ±17%     -48.2%        112 ±15%  sched_debug.cpu#0.cpu_load[1]
      7318 ±23%     -58.1%       3069 ± 9%  sched_debug.cpu#6.sched_goidle
     20346 ±41%    +576.0%     137537 ±13%  sched_debug.cpu#13.nr_switches
      9915 ±26%    +506.6%      60151 ±46%  sched_debug.cpu#8.sched_goidle
      7317 ±23%    +925.4%      75030 ±49%  sched_debug.cpu#11.ttwu_count
         7 ±23%    +228.6%         23 ±32%  sched_debug.cfs_rq[21]:/.tg_runnable_contrib
      3075 ±13%     +16.2%       3572 ±10%  sched_debug.cpu#25.sched_goidle
       239 ± 8%     -71.4%         68 ±41%  sched_debug.cfs_rq[29]:/.blocked_load_avg
  17742699 ± 8%     -62.8%    6609108 ± 4%  proc-vmstat.pgalloc_dma32
       240 ± 9%     -71.6%         68 ±41%  sched_debug.cfs_rq[29]:/.tg_load_contrib
       185 ± 3%     -51.7%         89 ±26%  sched_debug.cfs_rq[8]:/.load
       289 ±13%     -35.1%        187 ±13%  sched_debug.cpu#0.cpu_load[4]
       185 ± 3%     -51.7%         89 ±17%  sched_debug.cpu#8.load
     16302 ±17%     -63.0%       6038 ± 8%  sched_debug.cpu#5.nr_switches
       108 ±18%     -27.9%         78 ±25%  sched_debug.cpu#9.cpu_load[2]
      1230 ±21%     -45.9%        665 ±16%  sched_debug.cpu#31.sched_count
     10134 ±41%    +569.8%      67883 ±13%  sched_debug.cpu#13.sched_goidle
       100 ±17%     -31.6%         68 ±24%  sched_debug.cpu#9.cpu_load[1]
    244283 ± 7%     -51.0%     119587 ±13%  sched_debug.cpu#9.sched_goidle
      3263 ± 7%     -58.9%       1342 ±24%  sched_debug.cpu#28.curr->pid
       168 ± 5%     -60.1%         67 ±12%  sched_debug.cfs_rq[28]:/.runnable_load_avg
       168 ± 5%     -59.6%         68 ±14%  sched_debug.cfs_rq[28]:/.load
      1378 ± 7%     -32.4%        931 ±31%  sched_debug.cpu#28.sched_goidle
     45204 ± 7%     -62.7%      16868 ±13%  sched_debug.cfs_rq[1]:/.exec_clock
      3177 ± 6%     +77.9%       5650 ± 5%  sched_debug.cpu#17.ttwu_count
       168 ± 5%     -59.6%         68 ±14%  sched_debug.cpu#28.load
      1592 ± 4%     +44.3%       2298 ± 4%  sched_debug.cpu#20.sched_goidle
      1217 ±21%     -46.4%        653 ±16%  sched_debug.cpu#31.nr_switches
       282 ± 8%     +68.1%        474 ± 9%  sched_debug.cfs_rq[20]:/.tg_load_contrib
     99546 ±10%     -24.2%      75473 ±12%  sched_debug.cfs_rq[9]:/.min_vruntime
      9735 ±43%     -61.9%       3711 ±13%  sched_debug.cfs_rq[6]:/.min_vruntime
       355 ±22%    +209.9%       1101 ±30%  sched_debug.cfs_rq[21]:/.avg->runnable_avg_sum
       260 ±26%     +41.7%        368 ±22%  sched_debug.cfs_rq[21]:/.tg_load_contrib
     56733 ±44%     +84.8%     104825 ±32%  sched_debug.cpu#11.sched_count
       193 ±19%     -50.0%         96 ±19%  sched_debug.cpu#0.cpu_load[0]
     29282 ±17%     -28.6%      20906 ± 8%  sched_debug.cpu#0.nr_switches
      1022 ±13%     -67.3%        333 ±10%  sched_debug.cfs_rq[6]:/.exec_clock
       177 ±14%     -49.9%         88 ±12%  sched_debug.cfs_rq[0]:/.tg_load_contrib
       567 ±23%     -49.5%        286 ±19%  sched_debug.cpu#31.sched_goidle
      6500 ±13%     -19.3%       5245 ± 3%  sched_debug.cpu#3.ttwu_count
     16269 ±12%    +916.1%     165305 ± 8%  sched_debug.cpu#12.nr_switches
      1772 ±14%    +134.8%       4162 ± 3%  sched_debug.cfs_rq[24]:/.min_vruntime
      5866 ± 4%     +28.6%       7544 ± 5%  sched_debug.cpu#17.sched_count
     79126 ± 2%      +6.8%      84535 ± 3%  sched_debug.cpu#24.nr_load_updates
      2058 ±18%    +169.8%       5553 ±42%  sched_debug.cfs_rq[30]:/.min_vruntime
       127 ± 7%     -50.3%         63 ±29%  sched_debug.cfs_rq[1]:/.tg_load_contrib
       536 ± 8%     -32.8%        360 ±21%  sched_debug.cpu#28.ttwu_local
     11834 ±25%     -58.5%       4905 ± 7%  sched_debug.cpu#7.nr_switches
     32497 ±38%     -40.8%      19232 ±30%  sched_debug.cpu#2.nr_switches
     16058 ±39%     -40.9%       9484 ±31%  sched_debug.cpu#2.sched_goidle
      5899 ±26%     -58.9%       2424 ± 7%  sched_debug.cpu#7.sched_goidle
    230137 ± 3%     -66.7%      76736 ± 9%  sched_debug.cpu#1.sched_goidle
       507 ±12%     -49.9%        254 ±18%  sched_debug.cfs_rq[0]:/.tg_runnable_contrib
      3627 ±10%     -45.4%       1980 ± 0%  meminfo.AnonHugePages
     23190 ±12%     -49.7%      11664 ±18%  sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum
      2954 ± 8%     -47.8%       1543 ±11%  sched_debug.cpu#3.ttwu_local
     79091 ± 2%      +7.2%      84785 ± 2%  sched_debug.cpu#27.nr_load_updates
      2474 ±38%     -44.2%       1381 ±11%  proc-vmstat.numa_hint_faults
    244948 ± 7%     -61.7%      93754 ± 4%  sched_debug.cpu#0.ttwu_count
     24408 ± 2%    +154.6%      62149 ±31%  sched_debug.cfs_rq[11]:/.min_vruntime
      2521 ±37%     -43.6%       1422 ±10%  proc-vmstat.numa_pte_updates
       186 ± 4%     -49.5%         94 ±23%  sched_debug.cfs_rq[8]:/.tg_load_contrib
       535 ± 6%     +76.0%        941 ± 0%  sched_debug.cpu#20.ttwu_local
       387 ± 8%     +70.8%        661 ±31%  sched_debug.cpu#22.sched_goidle
    460655 ± 3%     -66.6%     153819 ± 9%  sched_debug.cpu#1.nr_switches
      1533 ±18%     -38.6%        940 ±19%  sched_debug.cpu#29.nr_switches
      1055 ±15%     +68.2%       1775 ± 7%  sched_debug.cpu#17.ttwu_local
      5854 ± 4%     +28.6%       7532 ± 5%  sched_debug.cpu#17.nr_switches
    518944 ± 5%     +46.1%     758059 ±18%  sched_debug.cpu#1.avg_idle
     21065 ± 9%     +10.8%      23341 ±10%  numa-meminfo.node0.Active(anon)
       186 ± 4%     -51.3%         90 ±23%  sched_debug.cpu#8.cpu_load[0]
       240 ± 3%     -53.2%        112 ±28%  sched_debug.cpu#8.cpu_load[3]
       215 ± 3%     -52.5%        102 ±26%  sched_debug.cpu#8.cpu_load[2]
       450 ±26%     -44.7%        249 ±32%  sched_debug.cfs_rq[28]:/.tg_load_contrib
      3760 ± 3%     +52.8%       5744 ± 1%  sched_debug.cpu#20.sched_count
     12799 ±19%     -45.6%       6960 ± 7%  sched_debug.cpu#0.sched_goidle
  23771309 ± 8%     -62.1%    9017612 ± 3%  numa-numastat.node0.local_node
  23771332 ± 8%     -62.1%    9017635 ± 3%  numa-numastat.node0.numa_hit
       531 ± 0%     -49.2%        270 ±25%  sched_debug.cfs_rq[8]:/.tg_runnable_contrib
       193 ± 3%     -51.5%         94 ±24%  sched_debug.cpu#8.cpu_load[1]
     24361 ± 0%     -49.2%      12377 ±25%  sched_debug.cfs_rq[8]:/.avg->runnable_avg_sum
      2525 ± 8%     -19.6%       2030 ± 4%  sched_debug.cpu#18.sched_count
       358 ± 3%     -45.5%        195 ±32%  sched_debug.cfs_rq[26]:/.blocked_load_avg
       358 ± 3%     -42.8%        205 ±31%  sched_debug.cfs_rq[26]:/.tg_load_contrib
      5268 ± 9%     +10.8%       5836 ±10%  numa-vmstat.node0.nr_active_anon
       257 ± 2%     -52.8%        121 ±28%  sched_debug.cpu#8.cpu_load[4]
       836 ± 8%     +75.8%       1471 ±28%  sched_debug.cpu#22.nr_switches
    467556 ± 3%     -63.2%     172089 ±15%  sched_debug.cpu#1.sched_count
    100306 ± 2%      -8.2%      92129 ± 1%  sched_debug.cpu#1.nr_load_updates
  13406964 ± 9%     +54.8%   20753143 ± 3%  numa-vmstat.node1.numa_local
  13421601 ± 9%     +54.7%   20768222 ± 3%  numa-vmstat.node1.numa_hit
       201 ± 8%     +50.4%        303 ± 5%  sched_debug.cpu#18.ttwu_local
     98041 ± 7%     -58.2%      40940 ±17%  sched_debug.cfs_rq[1]:/.min_vruntime
    968087 ± 3%     -13.4%     838650 ± 3%  sched_debug.cpu#12.avg_idle
     85296 ± 3%     +13.9%      97133 ± 1%  sched_debug.cpu#10.nr_load_updates
      1822 ± 7%     -52.6%        863 ±17%  sched_debug.cpu#8.curr->pid
     84101 ± 1%     +16.2%      97746 ± 3%  sched_debug.cpu#15.nr_load_updates
       100 ±15%     -34.9%         65 ±22%  sched_debug.cpu#9.cpu_load[0]
     87101 ±10%     -44.4%      48461 ± 3%  sched_debug.cpu#0.nr_load_updates
     82841 ± 2%     +10.4%      91426 ± 1%  sched_debug.cpu#14.nr_load_updates
       186 ± 4%     -53.2%         87 ±26%  sched_debug.cfs_rq[8]:/.runnable_load_avg
     83538 ± 2%     +16.0%      96885 ± 3%  sched_debug.cpu#13.nr_load_updates
     84391 ± 8%     -48.3%      43669 ± 4%  sched_debug.cfs_rq[0]:/.exec_clock
    987037 ± 1%     -14.2%     846398 ± 8%  sched_debug.cpu#13.avg_idle
    177237 ± 9%     -43.8%      99634 ± 2%  sched_debug.cfs_rq[0]:/.min_vruntime
     86370 ± 4%     +13.7%      98170 ± 6%  sched_debug.cpu#11.nr_load_updates
      1085 ±12%     -21.0%        856 ± 4%  sched_debug.cpu#18.sched_goidle
     82842 ± 1%     +16.7%      96690 ± 0%  sched_debug.cpu#12.nr_load_updates
    128898 ± 0%     -15.0%     109598 ± 2%  sched_debug.cpu#8.nr_load_updates
    678775 ± 1%     +23.3%     836906 ± 7%  sched_debug.cpu#11.avg_idle
    997365 ± 0%     -16.3%     834655 ± 6%  sched_debug.cpu#8.avg_idle
  25575328 ±10%     +56.4%   39987543 ± 2%  numa-numastat.node1.numa_hit
  25575276 ±10%     +56.4%   39987507 ± 2%  numa-numastat.node1.local_node
       679 ±19%     -39.1%        414 ±21%  sched_debug.cpu#29.sched_goidle
      3791 ±10%     +19.1%       4515 ± 2%  sched_debug.cfs_rq[18]:/.min_vruntime
      1263 ± 4%     +13.0%       1427 ± 5%  sched_debug.cpu#18.ttwu_count
     53498 ± 8%     +42.0%      75956 ± 4%  sched_debug.cpu#2.nr_load_updates
    939453 ± 4%     -12.6%     821265 ± 2%  sched_debug.cpu#10.avg_idle
    295153 ± 2%     -15.6%     249216 ± 1%  cpuidle.C7-SNB.usage
    583842 ±12%     +32.4%     773272 ± 2%  sched_debug.cpu#9.avg_idle
      3748 ± 3%     +49.5%       5605 ± 4%  sched_debug.cpu#20.nr_switches
      2420 ±11%     -16.7%       2017 ± 4%  sched_debug.cpu#18.nr_switches
     11077 ± 8%     +19.1%      13188 ± 3%  slabinfo.kmalloc-256.active_objs
       507 ±12%     +25.6%        637 ±10%  slabinfo.buffer_head.active_objs
       507 ±12%     +25.6%        637 ±10%  slabinfo.buffer_head.num_objs
     16697 ± 9%     -11.4%      14793 ±10%  slabinfo.vm_area_struct.num_objs
     16525 ±10%     -11.8%      14577 ± 9%  slabinfo.vm_area_struct.active_objs
     11616 ± 9%     +17.4%      13637 ± 6%  slabinfo.kmalloc-256.num_objs
      1410 ± 6%     +10.8%       1563 ± 3%  slabinfo.sock_inode_cache.active_objs
      1410 ± 6%     +10.8%       1563 ± 3%  slabinfo.sock_inode_cache.num_objs
       863 ±45%   +1260.1%      11737 ±12%  time.involuntary_context_switches
      3167 ± 0%      -4.9%       3011 ± 0%  vmstat.system.in

testbox/testcase/testparams: lkp-a05/iperf/300s-udp

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
        21 ± 7%     -28.1%         15 ±26%  sched_debug.cpu#2.cpu_load[4]
      3045 ±11%     -21.1%       2402 ±14%  cpuidle.POLL.time
        41 ±14%     -41.6%         24 ±46%  sched_debug.cpu#2.cpu_load[2]
       219 ±19%     -35.3%        142 ±23%  sched_debug.cfs_rq[2]:/.blocked_load_avg
        31 ±11%     -36.6%         19 ±37%  sched_debug.cpu#2.cpu_load[3]
       256 ±22%     -36.9%        162 ±27%  sched_debug.cfs_rq[2]:/.tg_load_contrib
       841 ± 7%     -13.0%        731 ± 7%  sched_debug.cfs_rq[1]:/.tg_load_contrib
       699 ±10%     -16.2%        586 ±11%  sched_debug.cfs_rq[1]:/.blocked_load_avg
    518031 ± 4%     +14.6%     593471 ± 7%  cpuidle.C2-ATM.time
    126580 ±11%     -28.2%      90853 ±12%  sched_debug.cfs_rq[1]:/.min_vruntime
     42977 ± 6%      -8.3%      39399 ± 8%  sched_debug.cpu#0.nr_load_updates
     37026 ±13%     -31.0%      25539 ± 4%  softirqs.RCU
      1286 ± 2%     -26.1%        950 ± 7%  cpuidle.C2-ATM.usage
     25472 ± 7%     -23.7%      19445 ± 2%  softirqs.SCHED
      2017 ± 5%     -11.5%       1785 ± 1%  sched_debug.cfs_rq[2]:/.tg_load_avg
     87377 ± 8%     -10.7%      77993 ± 2%  softirqs.TIMER

testbox/testcase/testparams: lkp-sb03/nepim/300s-25%-udp6

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
   -317754 ±-1%      -4.0%    -305106 ±-2%  sched_debug.cfs_rq[11]:/.spread0
        14 ±45%    -100.0%          0 ± 0%  sched_debug.cpu#18.cpu_load[0]
   -320520 ±-1%      -3.2%    -310228 ±-1%  sched_debug.cfs_rq[19]:/.spread0
      2408 ±36%     -79.9%        484 ±13%  sched_debug.cpu#14.ttwu_count
   -317961 ±-1%      -3.7%    -306068 ±-2%  sched_debug.cfs_rq[13]:/.spread0
      1377 ± 9%     -71.7%        389 ±30%  sched_debug.cpu#5.ttwu_local
   -315516 ±-1%      -4.5%    -301211 ±-1%  sched_debug.cfs_rq[7]:/.spread0
      1644 ±33%     -80.3%        324 ±31%  sched_debug.cpu#7.ttwu_local
        -3 ±-35%     +86.3%         -6 ±-7%  sched_debug.cpu#14.nr_uninterruptible
      2011 ±28%     -92.0%        160 ±27%  sched_debug.cpu#12.ttwu_local
      1042 ±41%     -93.0%         73 ±41%  sched_debug.cpu#14.ttwu_local
      6624 ±20%    +427.9%      34970 ±49%  sched_debug.cpu#25.sched_count
      2004 ±18%     -81.8%        364 ±24%  sched_debug.cpu#4.ttwu_local
       828 ±20%    +274.7%       3104 ± 1%  sched_debug.cfs_rq[2]:/.exec_clock
      1346 ±15%     -82.0%        242 ± 4%  sched_debug.cpu#6.ttwu_local
      2859 ±33%     -76.8%        662 ±36%  sched_debug.cpu#13.ttwu_count
      3677 ±20%     -72.4%       1016 ±27%  sched_debug.cpu#12.ttwu_count
      2745 ± 6%     +90.3%       5223 ± 2%  sched_debug.cpu#16.ttwu_count
      6117 ± 7%    +471.5%      34961 ±49%  sched_debug.cpu#25.nr_switches
      2999 ±13%     -69.9%        902 ±12%  sched_debug.cpu#5.ttwu_count
      3415 ±26%     -75.8%        827 ±26%  sched_debug.cpu#7.ttwu_count
      4872 ± 5%     +43.1%       6971 ± 1%  sched_debug.cpu#16.nr_switches
      3900 ±20%     -74.8%        984 ±14%  sched_debug.cpu#4.ttwu_count
      8394 ±15%     -35.2%       5441 ±24%  sched_debug.cpu#8.sched_count
        58 ±22%     +61.0%         94 ±18%  sched_debug.cpu#30.ttwu_local
      2669 ±20%     -81.5%        492 ±14%  sched_debug.cpu#2.ttwu_local
       807 ±18%     +93.7%       1563 ± 0%  sched_debug.cpu#16.ttwu_local
      1278 ± 9%     -15.0%       1087 ± 1%  sched_debug.cfs_rq[3]:/.exec_clock
      5841 ±10%    +305.6%      23695 ±45%  sched_debug.cpu#25.ttwu_count
      8530 ±30%     -49.4%       4317 ± 8%  sched_debug.cpu#13.sched_count
      3003 ±25%     -76.9%        693 ±12%  sched_debug.cpu#6.ttwu_count
       161 ±23%     +55.5%        251 ±18%  sched_debug.cpu#22.ttwu_count
      6519 ±18%     +90.7%      12431 ±19%  sched_debug.cpu#30.nr_load_updates
      3305 ±20%     -60.5%       1304 ±18%  sched_debug.cpu#11.ttwu_local
      4883 ± 5%     +43.0%       6982 ± 1%  sched_debug.cpu#16.sched_count
      0.13 ± 8%     +56.1%       0.20 ±23%  turbostat.%pc2
      2086 ± 4%     +21.1%       2527 ± 3%  sched_debug.cpu#16.sched_goidle
      5017 ±21%     -61.6%       1927 ±37%  sched_debug.cpu#2.ttwu_count
      6689 ±11%     -44.2%       3735 ±19%  sched_debug.cpu#6.nr_switches
        19 ±39%     -59.2%          8 ±17%  sched_debug.cpu#18.cpu_load[1]
      1924 ±32%     +50.9%       2904 ±11%  sched_debug.cpu#9.nr_switches
      3912 ± 6%     -42.5%       2251 ± 3%  sched_debug.cpu#5.sched_goidle
      5781 ±13%     -36.9%       3649 ± 4%  sched_debug.cpu#12.sched_goidle
     11126 ± 7%     -23.4%       8520 ± 1%  sched_debug.cpu#3.sched_goidle
      3323 ±11%     -45.1%       1825 ±19%  sched_debug.cpu#6.sched_goidle
      7285 ±14%     -40.9%       4305 ± 8%  sched_debug.cpu#13.nr_switches
      3566 ±16%     -45.0%       1963 ±25%  sched_debug.cpu#8.sched_goidle
      7022 ±11%     -41.2%       4132 ± 6%  sched_debug.cpu#11.ttwu_count
     14533 ±22%     +43.8%      20896 ± 5%  sched_debug.cpu#0.sched_count
     13253 ±12%     -43.9%       7439 ± 4%  sched_debug.cpu#12.sched_count
      2426 ± 7%     +24.2%       3014 ±11%  sched_debug.cpu#25.sched_goidle
    797026 ±37%     -43.9%     446843 ±10%  cpuidle.C3-SNB.time
      7893 ± 6%     -41.8%       4591 ± 4%  sched_debug.cpu#5.nr_switches
      7392 ±16%     +74.9%      12931 ±24%  sched_debug.cpu#28.nr_load_updates
      3612 ±14%     -42.2%       2086 ± 8%  sched_debug.cpu#13.sched_goidle
       937 ±34%     +53.1%       1435 ±11%  sched_debug.cpu#9.sched_goidle
      5792 ± 6%     -39.9%       3479 ± 1%  sched_debug.cpu#4.sched_goidle
     11646 ± 7%     -39.3%       7073 ± 1%  sched_debug.cpu#4.nr_switches
      1794 ±17%     -23.1%       1380 ±17%  sched_debug.cfs_rq[31]:/.exec_clock
     22924 ± 7%     -23.6%      17516 ± 4%  sched_debug.cpu#11.nr_switches
      2633 ±19%     +64.0%       4319 ±30%  sched_debug.cfs_rq[19]:/.min_vruntime
     59079 ±32%     -47.8%      30837 ±22%  sched_debug.cpu#2.sched_count
      9835 ±12%     +55.6%      15307 ±19%  sched_debug.cpu#16.nr_load_updates
     22381 ± 7%     -22.4%      17362 ± 1%  sched_debug.cpu#3.nr_switches
         2 ±42%     +94.4%          4 ±10%  sched_debug.cfs_rq[10]:/.nr_spread_over
      6781 ±17%     +81.3%      12296 ±23%  sched_debug.cpu#22.nr_load_updates
     24758 ±14%     -28.0%      17837 ± 5%  sched_debug.cpu#11.sched_count
      7096 ± 2%     +14.7%       8136 ± 5%  sched_debug.cpu#0.nr_switches
      6661 ±17%     +78.0%      11853 ±24%  sched_debug.cpu#29.nr_load_updates
      6785 ±18%     +78.1%      12082 ±24%  sched_debug.cpu#21.nr_load_updates
      6854 ±12%     -38.8%       4194 ± 4%  sched_debug.cpu#3.ttwu_count
      7612 ±15%     +70.9%      13007 ±23%  sched_debug.cpu#20.nr_load_updates
     11659 ±12%     -36.3%       7426 ± 4%  sched_debug.cpu#12.nr_switches
     11402 ± 7%     -24.8%       8571 ± 4%  sched_debug.cpu#11.sched_goidle
      7111 ±15%     +77.7%      12637 ±23%  sched_debug.cpu#17.nr_load_updates
      6973 ±16%     +75.0%      12203 ±24%  sched_debug.cpu#31.nr_load_updates
      6809 ±17%     +78.1%      12129 ±25%  sched_debug.cpu#24.nr_load_updates
      7591 ±15%     +72.5%      13093 ±22%  sched_debug.cpu#18.nr_load_updates
      7391 ±19%     -50.8%       3634 ±16%  sched_debug.cpu#7.nr_switches
     12020 ±12%     -39.8%       7242 ±14%  sched_debug.cpu#2.nr_switches
      5974 ±13%     -41.0%       3522 ±14%  sched_debug.cpu#2.sched_goidle
      3666 ±20%     -51.8%       1768 ±16%  sched_debug.cpu#7.sched_goidle
      5384 ±25%     -58.7%       2223 ±14%  sched_debug.cpu#1.sched_goidle
      6942 ±16%     +87.4%      13011 ±22%  sched_debug.cpu#19.nr_load_updates
      3090 ±16%     -52.0%       1483 ±13%  sched_debug.cpu#3.ttwu_local
      6633 ±18%     +85.6%      12313 ±23%  sched_debug.cpu#27.nr_load_updates
      6347 ± 2%     +38.2%       8770 ± 2%  sched_debug.cpu#0.ttwu_count
      5397 ±17%     +74.9%       9439 ±44%  sched_debug.cfs_rq[11]:/.min_vruntime
      4066 ±24%     -23.3%       3117 ±14%  sched_debug.cfs_rq[27]:/.min_vruntime
      6801 ±16%     +77.5%      12071 ±24%  sched_debug.cpu#23.nr_load_updates
      7568 ±14%     +77.7%      13450 ±22%  sched_debug.cpu#9.nr_load_updates
        59 ±31%    +104.4%        121 ±43%  sched_debug.cfs_rq[30]:/.avg->runnable_avg_sum
       466 ±14%     +90.9%        890 ±24%  sched_debug.cpu#19.ttwu_count
      9801 ±13%     +41.9%      13906 ±21%  sched_debug.cpu#6.nr_load_updates
      8128 ±25%     +58.3%      12867 ±26%  sched_debug.cpu#1.nr_load_updates
       238 ±12%     +84.9%        440 ±31%  sched_debug.cpu#18.ttwu_local
      6744 ±27%     +46.1%       9853 ±10%  sched_debug.cfs_rq[1]:/.min_vruntime
     10030 ±12%     +40.0%      14044 ±21%  sched_debug.cpu#5.nr_load_updates
       445 ±12%     -41.6%        260 ±10%  cpuidle.C3-SNB.usage
     11607 ± 6%     +34.9%      15655 ±15%  sched_debug.cpu#15.nr_load_updates
  30852509 ±20%     +59.8%   49301317 ±13%  cpuidle.C1-SNB.time
      9340 ± 9%     +46.6%      13688 ±19%  sched_debug.cpu#14.nr_load_updates
      9843 ±13%     +45.2%      14288 ±20%  sched_debug.cpu#13.nr_load_updates
     10191 ±14%     +41.5%      14420 ±20%  sched_debug.cpu#8.nr_load_updates
     12555 ± 8%     +26.9%      15934 ±18%  sched_debug.cpu#3.nr_load_updates
    125011 ± 1%     -33.4%      83286 ± 4%  cpuidle.C7-SNB.usage
      4440 ± 9%     +15.2%       5114 ± 2%  numa-vmstat.node1.nr_slab_reclaimable
     17765 ± 9%     +15.2%      20459 ± 2%  numa-meminfo.node1.SReclaimable
     20407 ± 7%     -14.5%      17450 ± 3%  numa-meminfo.node0.SReclaimable
      5101 ± 7%     -14.5%       4362 ± 3%  numa-vmstat.node0.nr_slab_reclaimable
     39288 ± 0%     +48.6%      58382 ± 5%  softirqs.SCHED
    385696 ± 0%     +12.4%     433713 ± 1%  softirqs.TIMER
       312 ± 0%  +12223.0%      38521 ± 1%  time.involuntary_context_switches
      2333 ± 0%      -4.2%       2234 ± 0%  vmstat.system.in

testbox/testcase/testparams: brickland1/boot/1

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
         0           +Inf%          1       dmesg.BUG:soft_lockup-CPU_stuck_for_s
         0           +Inf%          1       dmesg.Kernel_panic-not_syncing:softlockup:hung_tasks
         0           +Inf%          1       last_state.is_incomplete_run
         0           +Inf%          1       last_state.booting

testbox/testcase/testparams: lkp-sb03/nepim/300s-100%-udp

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
   -332412 ±-2%     -31.4%    -228062 ±-41%  sched_debug.cfs_rq[24]:/.spread0
   -332189 ±-1%     -29.6%    -233944 ±-42%  sched_debug.cfs_rq[21]:/.spread0
   -333098 ±-1%     -29.6%    -234545 ±-42%  sched_debug.cfs_rq[30]:/.spread0
   -331878 ±-2%     -31.4%    -227531 ±-45%  sched_debug.cfs_rq[14]:/.spread0
   -320408 ±-6%     -29.2%    -226996 ±-42%  sched_debug.cfs_rq[12]:/.spread0
   -329173 ±-2%     -30.6%    -228514 ±-42%  sched_debug.cfs_rq[11]:/.spread0
   -328417 ±-3%     -29.4%    -231861 ±-42%  sched_debug.cfs_rq[15]:/.spread0
   -326879 ±-1%     -30.2%    -228116 ±-43%  sched_debug.cfs_rq[17]:/.spread0
   -333639 ±-1%     -30.3%    -232642 ±-42%  sched_debug.cfs_rq[23]:/.spread0
   -330937 ±-1%     -30.5%    -230138 ±-43%  sched_debug.cfs_rq[18]:/.spread0
   -333169 ±-1%     -29.8%    -233884 ±-42%  sched_debug.cfs_rq[29]:/.spread0
   -332021 ±-1%     -29.9%    -232732 ±-43%  sched_debug.cfs_rq[31]:/.spread0
   -332316 ±-1%     -29.6%    -233922 ±-43%  sched_debug.cfs_rq[22]:/.spread0
   -329709 ± 0%     -32.1%    -223771 ±-43%  sched_debug.cfs_rq[5]:/.spread0
   -324925 ±-1%     -33.7%    -215479 ±-46%  sched_debug.cfs_rq[3]:/.spread0
   -331383 ±-1%     -30.0%    -231988 ±-43%  sched_debug.cfs_rq[19]:/.spread0
   -328445 ± 0%     -31.3%    -225649 ±-43%  sched_debug.cfs_rq[2]:/.spread0
   -330852 ±-1%     -29.9%    -231837 ±-43%  sched_debug.cfs_rq[20]:/.spread0
   -330882 ±-1%     -31.1%    -227986 ±-43%  sched_debug.cfs_rq[6]:/.spread0
   -331089 ±-2%     -37.4%    -207235 ±-41%  sched_debug.cfs_rq[26]:/.spread0
   -332707 ±-1%     -35.2%    -215441 ±-41%  sched_debug.cfs_rq[16]:/.spread0
      2896 ±32%     -73.8%        758 ±28%  sched_debug.cpu#14.ttwu_count
   -329983 ±-1%     -30.9%    -227891 ±-46%  sched_debug.cfs_rq[27]:/.spread0
   -321000 ±-3%     -28.5%    -229602 ±-43%  sched_debug.cfs_rq[13]:/.spread0
   -327709 ± 0%     -32.5%    -221267 ±-45%  sched_debug.cfs_rq[4]:/.spread0
   -328881 ±-1%     -31.1%    -226445 ±-47%  sched_debug.cfs_rq[7]:/.spread0
      1859 ±29%     -86.7%        247 ±38%  sched_debug.cpu#12.ttwu_local
      6731 ± 6%     +32.5%       8916 ±10%  sched_debug.cpu#25.sched_count
       661 ±17%    +493.7%       3925 ±24%  sched_debug.cfs_rq[2]:/.exec_clock
   -334661 ±-1%     -30.6%    -232419 ±-42%  sched_debug.cfs_rq[9]:/.spread0
      1379 ± 6%     -85.7%        197 ±32%  sched_debug.cpu#6.ttwu_local
      2949 ±18%     -54.7%       1337 ±38%  sched_debug.cpu#13.ttwu_count
      3358 ±32%     -64.7%       1184 ±40%  sched_debug.cpu#12.ttwu_count
      6723 ± 6%     +25.2%       8419 ± 6%  sched_debug.cpu#25.nr_switches
      3130 ± 2%     -70.6%        920 ±37%  sched_debug.cpu#5.ttwu_count
      2865 ±21%     -71.7%        810 ±16%  sched_debug.cpu#7.ttwu_count
        95 ±38%     -48.1%         49 ±34%  sched_debug.cfs_rq[13]:/.avg->runnable_avg_sum
         0 ± 0%      +Inf%          1 ± 0%  sched_debug.cpu#29.cpu_load[3]
    118.77 ±47%    +320.1%     498.91 ±34%  sched_debug.cfs_rq[9]:/.exec_clock
     12507 ± 3%    +184.0%      35517 ±42%  sched_debug.cpu#26.nr_load_updates
        59 ±10%     +34.1%         80 ±18%  sched_debug.cpu#30.ttwu_local
      2042 ±32%     -80.2%        404 ±35%  sched_debug.cpu#2.ttwu_local
        52 ± 9%     +51.0%         79 ±24%  sched_debug.cpu#23.ttwu_local
      4980 ±27%     -46.4%       2670 ±22%  sched_debug.cpu#15.sched_goidle
      5708 ± 3%     -12.7%       4983 ± 9%  sched_debug.cpu#20.ttwu_count
      3175 ±16%     -67.7%       1025 ±45%  sched_debug.cpu#6.ttwu_count
      2500 ±11%     -47.5%       1313 ±14%  sched_debug.cpu#11.ttwu_local
      8413 ±22%     -60.3%       3343 ±26%  sched_debug.cpu#10.sched_goidle
      7474 ± 7%     -28.7%       5329 ± 2%  sched_debug.cpu#14.nr_switches
      1275 ± 3%     +44.5%       1843 ± 4%  sched_debug.cpu#25.ttwu_local
      3774 ±25%     -60.1%       1506 ±27%  sched_debug.cpu#2.ttwu_count
      7163 ± 2%     -51.5%       3473 ±18%  sched_debug.cpu#6.nr_switches
      3206 ± 7%     -37.0%       2020 ±27%  sched_debug.cpu#20.curr->pid
         7 ±25%     +86.4%         13 ±29%  sched_debug.cfs_rq[25]:/.nr_spread_over
      3709 ± 7%     -29.5%       2615 ± 2%  sched_debug.cpu#14.sched_goidle
        10 ±29%    +116.7%         21 ±43%  sched_debug.cfs_rq[11]:/.tg_runnable_contrib
       490 ±27%    +110.7%       1032 ±41%  sched_debug.cfs_rq[11]:/.avg->runnable_avg_sum
      3762 ± 0%     -34.3%       2470 ± 6%  sched_debug.cpu#5.sched_goidle
      5345 ±20%     -29.4%       3775 ±15%  sched_debug.cpu#12.sched_goidle
       599 ±12%     -23.7%        457 ± 7%  sched_debug.cfs_rq[18]:/.tg_load_contrib
     10630 ± 3%     -23.4%       8143 ± 9%  sched_debug.cpu#3.sched_goidle
    139.20 ±49%     -42.5%      80.00 ± 6%  sched_debug.cfs_rq[30]:/.exec_clock
       584 ±33%     -41.1%        344 ±12%  sched_debug.cpu#21.ttwu_count
       595 ±11%     -25.5%        444 ± 8%  sched_debug.cfs_rq[18]:/.blocked_load_avg
        41 ± 9%     -37.9%         25 ±20%  sched_debug.cpu#20.cpu_load[3]
      3561 ± 2%     -52.4%       1693 ±20%  sched_debug.cpu#6.sched_goidle
      7825 ±12%     -35.1%       5081 ±20%  sched_debug.cpu#13.nr_switches
      6110 ±10%     -32.5%       4123 ± 4%  sched_debug.cpu#11.ttwu_count
       121 ± 7%     -32.9%         81 ±18%  sched_debug.cpu#20.cpu_load[1]
       539 ±49%    +111.1%       1139 ±11%  sched_debug.cpu#11.curr->pid
     28969 ± 6%     -11.8%      25554 ± 6%  proc-vmstat.pgalloc_dma32
        21 ± 9%     -38.5%         13 ±24%  sched_debug.cpu#20.cpu_load[4]
    364837 ±28%     +80.5%     658376 ±39%  cpuidle.C3-SNB.time
      7578 ± 1%     -33.2%       5062 ± 7%  sched_debug.cpu#5.nr_switches
       161 ± 7%     -30.8%        111 ±17%  sched_debug.cpu#20.cpu_load[0]
      3866 ±12%     -35.5%       2493 ±20%  sched_debug.cpu#13.sched_goidle
      2670 ± 2%     +96.8%       5255 ± 1%  sched_debug.cpu#17.ttwu_count
     12432 ± 5%    +168.0%      33312 ±27%  sched_debug.cpu#16.nr_load_updates
     21409 ± 3%     -22.4%      16617 ± 9%  sched_debug.cpu#3.nr_switches
       418 ±37%     -46.1%        225 ±37%  sched_debug.cfs_rq[20]:/.tg_load_contrib
        10 ± 4%     +45.2%         15 ±23%  sched_debug.cfs_rq[17]:/.tg_runnable_contrib
      6560 ± 5%     -40.9%       3876 ± 4%  sched_debug.cpu#3.ttwu_count
     10781 ±21%     -28.5%       7712 ±15%  sched_debug.cpu#12.nr_switches
     15101 ± 5%     +89.1%      28556 ±49%  sched_debug.cpu#17.nr_load_updates
       492 ± 5%     +45.8%        718 ±22%  sched_debug.cfs_rq[17]:/.avg->runnable_avg_sum
     12110 ± 5%    +131.6%      28045 ±45%  sched_debug.cpu#24.nr_load_updates
      3021 ±44%     -52.8%       1426 ±28%  sched_debug.cfs_rq[30]:/.min_vruntime
       163 ± 6%     -33.9%        108 ±20%  sched_debug.cfs_rq[20]:/.runnable_load_avg
      7318 ± 9%     -33.1%       4898 ±15%  sched_debug.cpu#7.nr_switches
     10903 ±14%     -25.7%       8103 ± 1%  sched_debug.cpu#2.nr_switches
      5414 ±14%     -27.2%       3943 ± 1%  sched_debug.cpu#2.sched_goidle
      3639 ± 9%     -33.4%       2423 ±15%  sched_debug.cpu#7.sched_goidle
        84 ±43%     +51.2%        128 ± 2%  sched_debug.cpu#11.load
      5531 ± 4%     -62.4%       2080 ±26%  sched_debug.cpu#1.sched_goidle
      2894 ± 7%     -57.2%       1239 ±17%  sched_debug.cpu#3.ttwu_local
      2128 ± 6%     +20.7%       2569 ± 5%  sched_debug.cpu#17.sched_goidle
      7757 ±10%    +109.8%      16272 ±42%  sched_debug.cpu#0.ttwu_count
      3802 ±16%     -46.1%       2048 ±28%  sched_debug.cfs_rq[22]:/.min_vruntime
       162 ± 6%     -33.5%        108 ±20%  sched_debug.cfs_rq[20]:/.load
       750 ±14%    +122.9%       1671 ± 1%  sched_debug.cpu#17.ttwu_local
      4961 ± 5%     +42.8%       7085 ± 3%  sched_debug.cpu#17.nr_switches
       162 ± 6%     -33.5%        108 ±20%  sched_debug.cpu#20.load
        74 ± 8%     -35.1%         48 ±19%  sched_debug.cpu#20.cpu_load[2]
      3929 ±38%     -48.4%       2026 ±23%  sched_debug.cfs_rq[21]:/.min_vruntime
    283094 ± 7%     -12.0%     249151 ± 3%  numa-numastat.node0.local_node
    283099 ± 7%     -12.0%     249158 ± 3%  numa-numastat.node0.numa_hit
     89434 ± 7%     -13.0%      77829 ± 3%  meminfo.DirectMap4k
       525 ±30%     +57.0%        824 ±22%  sched_debug.cpu#19.ttwu_count
       557 ± 9%     +40.7%        785 ±17%  sched_debug.cfs_rq[18]:/.exec_clock
     16533 ± 4%     +77.6%      29359 ±43%  sched_debug.cpu#4.nr_load_updates
     15325 ± 4%     +83.0%      28049 ±47%  sched_debug.cpu#5.nr_load_updates
    153651 ± 0%     -29.4%     108464 ±44%  sched_debug.cpu#0.nr_load_updates
    154973 ± 0%     -32.2%     105144 ±46%  sched_debug.cfs_rq[0]:/.exec_clock
    336114 ± 1%     -29.8%     235968 ±42%  sched_debug.cfs_rq[0]:/.min_vruntime
     17101 ± 2%     +67.3%      28611 ±49%  sched_debug.cpu#11.nr_load_updates
     16749 ± 8%     +65.9%      27795 ±48%  sched_debug.cpu#12.nr_load_updates
     18016 ± 6%     +67.5%      30176 ±46%  sched_debug.cpu#3.nr_load_updates
    267383 ± 7%     +12.9%     301747 ± 2%  numa-numastat.node1.numa_hit
    267353 ± 7%     +12.9%     301717 ± 2%  numa-numastat.node1.local_node
      9873 ± 4%     -11.7%       8721 ± 1%  slabinfo.kmalloc-192.num_objs
      7870 ± 4%      -9.5%       7121 ± 6%  numa-vmstat.node1.nr_slab_unreclaimable
      9873 ± 4%     -11.7%       8721 ± 1%  slabinfo.kmalloc-192.active_objs
      4392 ± 5%     -10.4%       3933 ± 7%  sched_debug.cpu#20.nr_switches
      5151 ± 1%     -11.8%       4542 ± 5%  numa-vmstat.node1.nr_slab_reclaimable
     20608 ± 1%     -11.8%      18170 ± 5%  numa-meminfo.node1.SReclaimable
     45893 ± 2%     +43.5%      65872 ±12%  softirqs.SCHED
     31483 ± 4%      -9.5%      28488 ± 6%  numa-meminfo.node1.SUnreclaim
        27 ±36%     -41.0%         16 ±20%  sched_debug.cfs_rq[20]:/.tg_runnable_contrib
      1310 ±36%     -40.6%        778 ±20%  sched_debug.cfs_rq[20]:/.avg->runnable_avg_sum
     52092 ± 3%     -10.4%      46658 ± 5%  numa-meminfo.node1.Slab
     17004 ± 7%     -13.8%      14657 ± 6%  slabinfo.vm_area_struct.num_objs
     16843 ± 8%     -14.1%      14468 ± 4%  slabinfo.vm_area_struct.active_objs
    395985 ± 1%     +10.1%     436060 ± 0%  softirqs.TIMER

testbox/testcase/testparams: lkp-sb03/nepim/300s-25%-tcp

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     10695 ± 0%      -2.1%      10467 ± 1%  nepim.tcp.avg.snd_s
   2803859 ± 0%      -2.1%    2743881 ± 1%  nepim.tcp.avg.kbps_out
   2804100 ± 0%      -2.2%    2743293 ± 1%  nepim.tcp.avg.kbps_in
     10698 ± 0%      -2.2%      10467 ± 1%  nepim.tcp.avg.rcv_s
   -121719 ±-8%     -25.3%     -90877 ±-22%  sched_debug.cfs_rq[24]:/.spread0
   -121918 ±-7%     -23.1%     -93789 ±-26%  sched_debug.cfs_rq[30]:/.spread0
   -120019 ±-7%     -34.1%     -79077 ±-44%  sched_debug.cfs_rq[14]:/.spread0
   -111279 ±-3%     -26.7%     -81532 ±-45%  sched_debug.cfs_rq[12]:/.spread0
   -116127 ±-7%     -24.5%     -87649 ±-26%  sched_debug.cfs_rq[17]:/.spread0
   -120630 ±-7%     -23.7%     -92046 ±-22%  sched_debug.cfs_rq[23]:/.spread0
   -120159 ±-6%     -22.6%     -93007 ±-25%  sched_debug.cfs_rq[18]:/.spread0
   -115146 ±-8%     -27.5%     -83505 ±-29%  sched_debug.cfs_rq[25]:/.spread0
   -120796 ±-6%     -21.9%     -94345 ±-23%  sched_debug.cfs_rq[29]:/.spread0
   -120845 ±-7%     -24.7%     -91044 ±-28%  sched_debug.cfs_rq[31]:/.spread0
    -42392 ±-14%     -34.3%     -27870 ±-8%  sched_debug.cfs_rq[1]:/.spread0
   -114000 ±-8%     -32.0%     -77568 ±-27%  sched_debug.cfs_rq[5]:/.spread0
   -104612 ±-9%     -31.4%     -71780 ±-27%  sched_debug.cfs_rq[3]:/.spread0
   -109295 ±-10%     -43.2%     -62052 ±-49%  sched_debug.cfs_rq[2]:/.spread0
   -113348 ±-4%     -32.0%     -77037 ±-22%  sched_debug.cfs_rq[6]:/.spread0
      1399 ± 3%    +293.1%       5501 ±48%  sched_debug.cpu#26.sched_count
   -120334 ±-6%     -23.7%     -91799 ±-25%  sched_debug.cfs_rq[26]:/.spread0
   -122092 ±-7%     -22.2%     -94988 ±-23%  sched_debug.cfs_rq[16]:/.spread0
   -119413 ±-6%     -20.7%     -94724 ±-24%  sched_debug.cfs_rq[27]:/.spread0
      4257 ± 8%     -90.8%        391 ±48%  sched_debug.cpu#5.ttwu_local
   -112177 ±-8%     -29.2%     -79394 ±-24%  sched_debug.cfs_rq[4]:/.spread0
   -114081 ±-5%     -31.0%     -78750 ±-25%  sched_debug.cfs_rq[7]:/.spread0
   -118923 ±-6%     -26.3%     -87677 ±-31%  sched_debug.cfs_rq[28]:/.spread0
      1611 ±14%     -39.2%        979 ±43%  sched_debug.cpu#13.ttwu_local
      1403 ±20%     -68.4%        444 ±42%  sched_debug.cpu#12.ttwu_local
         8 ±17%     -45.8%          4 ±28%  sched_debug.cpu#19.nr_uninterruptible
     10328 ±24%    +393.1%      50927 ± 9%  sched_debug.cpu#25.sched_count
        29 ± 9%     -34.8%         19 ± 4%  sched_debug.cpu#25.nr_uninterruptible
       892 ±23%     -75.7%        216 ±21%  sched_debug.cfs_rq[19]:/.exec_clock
     10284 ±24%    +394.0%      50801 ± 9%  sched_debug.cpu#25.nr_switches
      1386 ± 3%    +296.0%       5489 ±48%  sched_debug.cpu#26.nr_switches
        53 ±15%     +44.0%         76 ±23%  sched_debug.cpu#16.ttwu_local
        14 ±15%     +83.3%         25 ±30%  numa-numastat.node0.other_node
       954 ± 8%    +408.1%       4849 ±44%  sched_debug.cpu#26.ttwu_count
      3148 ± 7%     +87.6%       5907 ±12%  sched_debug.cpu#25.ttwu_count
    185.51 ±26%     -30.6%     128.82 ± 6%  sched_debug.cfs_rq[22]:/.exec_clock
      1169 ±16%     +81.6%       2124 ±17%  sched_debug.cpu#25.ttwu_local
     90119 ±11%     -42.8%      51537 ±32%  sched_debug.cfs_rq[8]:/.exec_clock
    176077 ±10%     -40.2%     105252 ±29%  sched_debug.cfs_rq[8]:/.min_vruntime
       176 ± 2%     -42.5%        101 ±42%  sched_debug.cpu#0.cpu_load[3]
      9192 ±17%     +59.2%      14633 ±10%  sched_debug.cfs_rq[25]:/.min_vruntime
      1159 ± 9%     -19.8%        929 ±15%  sched_debug.cpu#22.sched_count
       427 ± 6%     -34.1%        281 ±42%  sched_debug.cfs_rq[9]:/.tg_runnable_contrib
     19503 ± 6%     -34.1%      12843 ±42%  sched_debug.cfs_rq[9]:/.avg->runnable_avg_sum
       839 ± 5%     +24.5%       1045 ±20%  sched_debug.cpu#11.curr->pid
        14 ±18%     +69.8%         24 ±32%  sched_debug.cfs_rq[21]:/.tg_runnable_contrib
      4588 ±27%    +432.3%      24425 ±10%  sched_debug.cpu#25.sched_goidle
       205 ± 7%     -43.6%        115 ±44%  sched_debug.cfs_rq[8]:/.load
      2524 ±41%     -58.1%       1056 ±14%  sched_debug.cpu#19.sched_count
       185 ± 2%     -38.1%        115 ±32%  sched_debug.cpu#0.cpu_load[4]
       205 ± 7%     -43.6%        115 ±43%  sched_debug.cpu#8.load
   2248.86 ± 5%     +30.0%    2922.92 ±25%  sched_debug.cfs_rq[17]:/.exec_clock
       139 ± 7%     -35.2%         90 ±42%  sched_debug.cpu#9.cpu_load[2]
       875 ±26%    +100.7%       1757 ±18%  sched_debug.cpu#31.sched_count
       123 ± 8%     -35.0%         80 ±42%  sched_debug.cpu#9.cpu_load[1]
      1195 ±28%    +207.3%       3674 ±43%  sched_debug.cfs_rq[31]:/.exec_clock
      5340 ±21%     -56.6%       2318 ±17%  sched_debug.cfs_rq[19]:/.min_vruntime
       791 ±25%     -38.1%        490 ±11%  sched_debug.cpu#30.nr_switches
       827 ± 8%     -45.4%        451 ±16%  sched_debug.cpu#19.sched_goidle
       140 ± 6%     -39.1%         85 ±47%  sched_debug.cpu#9.load
       863 ±27%    +102.1%       1745 ±18%  sched_debug.cpu#31.nr_switches
       701 ±17%     +62.8%       1141 ±31%  sched_debug.cfs_rq[21]:/.avg->runnable_avg_sum
         7 ±42%     +76.2%         12 ±26%  sched_debug.cpu#21.cpu_load[4]
       359 ±26%     -42.1%        208 ±12%  sched_debug.cpu#30.sched_goidle
      5844 ± 8%     +35.5%       7918 ± 6%  sched_debug.cpu#17.sched_count
       803 ±25%     -37.4%        502 ±11%  sched_debug.cpu#30.sched_count
      2421 ±36%     +79.6%       4348 ±40%  sched_debug.cfs_rq[30]:/.min_vruntime
       257 ±43%     -42.6%        147 ±25%  sched_debug.cpu#27.ttwu_local
      3419 ±27%     -63.2%       1256 ±12%  sched_debug.cpu#3.ttwu_local
      1867 ±34%     -57.2%        799 ± 7%  proc-vmstat.numa_hint_faults
    512960 ±12%     -31.0%     354196 ±26%  sched_debug.cpu#0.ttwu_count
      1094 ±34%     -45.8%        592 ±13%  proc-vmstat.numa_hint_faults_local
      1908 ±33%     -55.7%        845 ± 6%  proc-vmstat.numa_pte_updates
       205 ± 8%     -42.4%        118 ±44%  sched_debug.cfs_rq[8]:/.tg_load_contrib
        97 ± 6%     +30.6%        126 ±20%  sched_debug.cpu#29.ttwu_local
       502 ±10%     -19.4%        404 ±18%  sched_debug.cpu#22.sched_goidle
       935 ± 7%    +101.6%       1885 ± 7%  sched_debug.cpu#17.ttwu_local
      1793 ± 6%     -41.8%       1044 ±14%  sched_debug.cpu#19.nr_switches
      5832 ± 9%     +35.5%       7906 ± 6%  sched_debug.cpu#17.nr_switches
      4005 ±19%     +58.2%       6338 ±14%  sched_debug.cfs_rq[26]:/.min_vruntime
       204 ± 8%     -43.8%        115 ±44%  sched_debug.cpu#8.cpu_load[0]
       261 ± 7%     -42.7%        149 ±44%  sched_debug.cpu#8.cpu_load[3]
       232 ± 8%     -42.6%        133 ±44%  sched_debug.cpu#8.cpu_load[2]
       595 ± 8%     -40.3%        355 ±42%  sched_debug.cfs_rq[8]:/.tg_runnable_contrib
       210 ± 8%     -43.0%        119 ±44%  sched_debug.cpu#8.cpu_load[1]
      5415 ±35%     +93.2%      10461 ±45%  sched_debug.cfs_rq[28]:/.min_vruntime
     27308 ± 8%     -40.3%      16304 ±41%  sched_debug.cfs_rq[8]:/.avg->runnable_avg_sum
       331 ±20%     -55.4%        147 ±41%  sched_debug.cfs_rq[26]:/.blocked_load_avg
       333 ±19%     -55.7%        147 ±41%  sched_debug.cfs_rq[26]:/.tg_load_contrib
      3494 ±20%    +103.0%       7094 ±41%  sched_debug.cfs_rq[31]:/.min_vruntime
       283 ± 7%     -42.3%        163 ±44%  sched_debug.cpu#8.cpu_load[4]
      1146 ± 9%     -19.9%        918 ±15%  sched_debug.cpu#22.nr_switches
       157 ± 7%     -34.5%        103 ±41%  sched_debug.cpu#9.cpu_load[3]
      1885 ± 4%     -41.0%       1112 ±42%  sched_debug.cpu#8.curr->pid
       803 ±16%     -31.3%        551 ±11%  cpuidle.C3-SNB.usage
  1.39e+08 ± 2%     +41.2%  1.963e+08 ±19%  cpuidle.C1-SNB.time
       115 ± 7%     -34.2%         75 ±43%  sched_debug.cpu#9.cpu_load[0]
     34157 ± 2%     +50.0%      51248 ± 7%  softirqs.RCU
       204 ± 8%     -43.8%        115 ±44%  sched_debug.cfs_rq[8]:/.runnable_load_avg
       172 ± 6%     -33.7%        114 ±42%  sched_debug.cpu#9.cpu_load[4]
     60313 ± 8%     -23.5%      46115 ±23%  sched_debug.cfs_rq[0]:/.exec_clock
      7005 ±16%     -20.0%       5600 ± 8%  sched_debug.cfs_rq[20]:/.min_vruntime
    131677 ± 2%      -8.8%     120031 ± 5%  sched_debug.cpu#8.nr_load_updates
   1000000 ± 0%      -7.8%     921845 ± 3%  sched_debug.cpu#8.avg_idle
    305943 ± 0%     -14.9%     260489 ± 1%  cpuidle.C7-SNB.usage
    447676 ± 8%     +39.2%     623231 ±12%  sched_debug.cpu#9.avg_idle
    136899 ± 0%     +10.9%     151875 ± 2%  softirqs.SCHED
     10246 ± 5%     +13.2%      11600 ± 8%  slabinfo.kmalloc-256.active_objs
      3693 ±10%      -8.4%       3383 ± 8%  sched_debug.cfs_rq[30]:/.tg_load_avg
      3701 ± 9%      -8.4%       3389 ± 8%  sched_debug.cfs_rq[31]:/.tg_load_avg
      3682 ± 9%      -8.4%       3371 ± 8%  sched_debug.cfs_rq[29]:/.tg_load_avg
      3667 ± 9%      -9.0%       3338 ± 8%  sched_debug.cfs_rq[28]:/.tg_load_avg
      3660 ±10%      -9.0%       3331 ± 7%  sched_debug.cfs_rq[27]:/.tg_load_avg
    378073 ± 0%     +17.8%     445472 ± 6%  softirqs.TIMER
       633 ±23%   +1292.7%       8816 ±15%  time.involuntary_context_switches
   2298705 ±11%     -17.8%    1889948 ±14%  time.voluntary_context_switches
      1947 ±12%     -23.5%       1490 ± 1%  time.minor_page_faults
    256.98 ± 1%      +2.0%     262.20 ± 1%  time.system_time
     21901 ± 1%      -5.2%      20756 ± 3%  vmstat.system.cs
      3707 ± 1%      -4.6%       3538 ± 0%  vmstat.system.in

testbox/testcase/testparams: lkp-sb03/nepim/300s-25%-tcp6

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
      9863 ± 0%      -2.9%       9577 ± 1%  nepim.tcp.avg.snd_s
   2585647 ± 0%      -2.9%    2510718 ± 1%  nepim.tcp.avg.kbps_out
   2585813 ± 0%      -2.9%    2510916 ± 1%  nepim.tcp.avg.kbps_in
      9866 ± 0%      -2.9%       9584 ± 1%  nepim.tcp.avg.rcv_s
   -134976 ±-16%     -40.4%     -80425 ±-36%  sched_debug.cfs_rq[24]:/.spread0
   -132063 ±-16%     -43.2%     -74963 ±-37%  sched_debug.cfs_rq[21]:/.spread0
   -133375 ±-15%     -39.8%     -80283 ±-35%  sched_debug.cfs_rq[30]:/.spread0
        -6 ±-28%     -50.0%         -3 ±-37%  sched_debug.cpu#12.nr_uninterruptible
   -128176 ±-14%     -40.9%     -75751 ±-38%  sched_debug.cfs_rq[17]:/.spread0
   -133880 ±-15%     -42.4%     -77048 ±-33%  sched_debug.cfs_rq[23]:/.spread0
   -132298 ±-16%     -40.7%     -78493 ±-37%  sched_debug.cfs_rq[18]:/.spread0
   -126650 ±-16%     -42.8%     -72400 ±-38%  sched_debug.cfs_rq[25]:/.spread0
   -133032 ±-15%     -42.0%     -77124 ±-32%  sched_debug.cfs_rq[29]:/.spread0
   -131725 ±-17%     -39.8%     -79248 ±-36%  sched_debug.cfs_rq[31]:/.spread0
   -133654 ±-16%     -41.6%     -78031 ±-36%  sched_debug.cfs_rq[22]:/.spread0
   -124091 ±-18%     -60.9%     -48524 ±-20%  sched_debug.cfs_rq[5]:/.spread0
   -122612 ±-21%     -67.6%     -39778 ±-35%  sched_debug.cfs_rq[3]:/.spread0
   -130477 ±-17%     -40.8%     -77255 ±-36%  sched_debug.cfs_rq[19]:/.spread0
   -108967 ±-27%     -61.8%     -41596 ±-35%  sched_debug.cfs_rq[2]:/.spread0
   -129246 ±-17%     -44.3%     -72006 ±-36%  sched_debug.cfs_rq[20]:/.spread0
   -132670 ±-16%     -41.1%     -78095 ±-36%  sched_debug.cfs_rq[26]:/.spread0
   -130968 ±-19%     -44.9%     -72217 ±-38%  sched_debug.cfs_rq[16]:/.spread0
   -133731 ±-16%     -42.8%     -76524 ±-33%  sched_debug.cfs_rq[27]:/.spread0
      4116 ±32%     -83.3%        686 ±40%  sched_debug.cpu#5.ttwu_local
   -126780 ±-13%     -64.4%     -45152 ±-26%  sched_debug.cfs_rq[4]:/.spread0
   -128099 ±-16%     -60.8%     -50243 ±-43%  sched_debug.cfs_rq[7]:/.spread0
   -132645 ±-15%     -42.4%     -76383 ±-36%  sched_debug.cfs_rq[28]:/.spread0
      2271 ±26%     -65.7%        780 ±20%  sched_debug.cpu#4.ttwu_local
      8273 ± 9%     -45.1%       4538 ±48%  cpuidle.C6-SNB.time
         5 ± 8%     -50.0%          2 ±35%  sched_debug.cpu#26.cpu_load[2]
      9944 ±42%    +275.2%      37311 ±45%  sched_debug.cfs_rq[4]:/.min_vruntime
         5 ±16%     -46.7%          2 ±35%  sched_debug.cpu#26.cpu_load[3]
      3686 ±16%     +66.2%       6129 ± 1%  sched_debug.cpu#25.ttwu_count
      1411 ±14%     -42.3%        813 ±15%  sched_debug.cpu#24.nr_switches
      1423 ±14%     -42.0%        825 ±15%  sched_debug.cpu#24.sched_count
       791 ±17%     +87.4%       1483 ± 4%  sched_debug.cfs_rq[28]:/.exec_clock
       375 ±16%     +74.3%        654 ±22%  sched_debug.cpu#27.ttwu_count
      2514 ±18%     -49.1%       1281 ± 9%  sched_debug.cpu#11.ttwu_local
       166 ±14%     +90.2%        316 ±16%  sched_debug.cpu#21.ttwu_local
     22218 ±48%    +910.3%     224477 ±48%  sched_debug.cpu#4.sched_count
    192.76 ±48%    +437.1%    1035.32 ±48%  sched_debug.cfs_rq[22]:/.exec_clock
     72170 ±18%     -53.8%      33348 ±46%  sched_debug.cfs_rq[8]:/.exec_clock
    141319 ±16%     -51.4%      68708 ±42%  sched_debug.cfs_rq[8]:/.min_vruntime
       675 ±17%     -46.2%        363 ±18%  sched_debug.cpu#24.sched_goidle
       223 ± 4%     -55.6%         99 ±43%  sched_debug.cpu#0.cpu_load[2]
      3102 ± 9%     -67.4%       1010 ±24%  sched_debug.cpu#20.curr->pid
         8 ± 5%     -34.6%          5 ±22%  sched_debug.cfs_rq[25]:/.nr_spread_over
       243 ± 5%     -53.7%        112 ±40%  sched_debug.cpu#0.cpu_load[3]
    943654 ± 0%      -7.9%     869181 ± 5%  sched_debug.cpu#3.avg_idle
       375 ±25%     -56.2%        164 ±27%  sched_debug.cfs_rq[18]:/.tg_load_contrib
       200 ± 3%     -57.8%         84 ±49%  sched_debug.cpu#0.cpu_load[1]
       375 ±25%     -56.2%        164 ±27%  sched_debug.cfs_rq[18]:/.blocked_load_avg
        82 ± 8%     -66.8%         27 ±36%  sched_debug.cpu#20.cpu_load[3]
      0.64 ±22%     -64.1%       0.23 ±14%  turbostat.%c3
       161 ± 7%     -70.4%         47 ±26%  sched_debug.cpu#20.cpu_load[1]
       327 ±15%     -26.4%        241 ±16%  sched_debug.cpu#26.ttwu_local
        47 ± 8%     -60.8%         18 ±45%  sched_debug.cpu#20.cpu_load[4]
       151 ± 2%     -40.7%         89 ±48%  sched_debug.cfs_rq[8]:/.load
       257 ± 5%     -52.1%        123 ±39%  sched_debug.cpu#0.cpu_load[4]
       151 ± 2%     -39.0%         92 ±44%  sched_debug.cpu#8.load
       165 ± 7%     -69.2%         51 ±23%  sched_debug.cpu#20.cpu_load[0]
      7874 ± 9%     -33.1%       5264 ±23%  sched_debug.cpu#0.ttwu_local
     14892 ± 1%    +242.6%      51016 ±49%  numa-vmstat.node1.numa_other
       310 ± 2%     -37.6%        194 ±45%  sched_debug.cfs_rq[20]:/.tg_load_contrib
      4812 ±16%    +144.7%      11778 ±24%  sched_debug.cpu#28.ttwu_count
        88 ± 0%     -41.3%         51 ±48%  sched_debug.cpu#1.cpu_load[0]
        84 ±14%     +43.3%        121 ±21%  sched_debug.cpu#27.ttwu_local
       165 ± 7%     -70.2%         49 ±21%  sched_debug.cfs_rq[20]:/.runnable_load_avg
       120 ± 9%     -44.2%         67 ±21%  sched_debug.cfs_rq[1]:/.tg_load_contrib
       125 ±24%     -39.9%         75 ± 4%  sched_debug.cpu#11.load
    556084 ±26%     -46.6%     296758 ±42%  sched_debug.cpu#1.sched_goidle
      2211 ±14%     -29.4%       1560 ±11%  sched_debug.cpu#3.ttwu_local
      1410 ±32%     -45.0%        775 ±26%  proc-vmstat.numa_hint_faults
      1822 ±45%     -84.2%        287 ± 4%  sched_debug.cpu#17.sched_goidle
    701369 ±16%     -58.8%     289218 ±44%  sched_debug.cpu#0.ttwu_count
      1451 ±31%     -43.7%        816 ±24%  proc-vmstat.numa_pte_updates
   1112623 ±26%     -46.3%     597441 ±42%  sched_debug.cpu#1.nr_switches
       167 ± 7%     -70.5%         49 ±21%  sched_debug.cfs_rq[20]:/.load
       167 ± 7%     -70.5%         49 ±21%  sched_debug.cpu#20.load
    550128 ± 9%     +44.6%     795580 ±15%  sched_debug.cpu#1.avg_idle
       127 ± 8%     -69.9%         38 ±30%  sched_debug.cpu#20.cpu_load[2]
         3 ±12%     -45.5%          2 ±40%  sched_debug.cpu#18.cpu_load[4]
      4664 ±10%     +60.8%       7501 ±20%  sched_debug.cfs_rq[21]:/.min_vruntime
    118108 ± 2%      -9.1%     107394 ± 5%  sched_debug.cpu#9.nr_load_updates
      4084 ±15%     +48.9%       6082 ±16%  sched_debug.cfs_rq[28]:/.min_vruntime
      1506 ±10%     +28.5%       1934 ±14%  sched_debug.cpu#18.sched_count
       282 ± 8%     -59.0%        116 ±43%  sched_debug.cfs_rq[26]:/.blocked_load_avg
       285 ± 9%     -58.7%        117 ±40%  sched_debug.cfs_rq[26]:/.tg_load_contrib
      5004 ±25%     -35.7%       3217 ±16%  sched_debug.cfs_rq[31]:/.min_vruntime
   1131632 ±25%     -45.5%     616403 ±42%  sched_debug.cpu#1.sched_count
       459 ±12%     -30.7%        318 ±19%  sched_debug.cfs_rq[18]:/.avg->runnable_avg_sum
       128 ± 3%     -43.8%         72 ±28%  sched_debug.cpu#3.load
      1466 ± 3%     -41.8%        854 ±46%  sched_debug.cpu#8.curr->pid
    996199 ± 0%     -11.1%     885680 ± 8%  sched_debug.cpu#6.avg_idle
       743 ±16%     -32.9%        498 ±10%  cpuidle.C3-SNB.usage
 1.416e+08 ±11%     +34.5%  1.905e+08 ±17%  cpuidle.C1-SNB.time
     74056 ±16%     -45.2%      40609 ±38%  sched_debug.cpu#0.nr_load_updates
     33054 ± 3%     +41.9%      46916 ± 3%  softirqs.RCU
     70652 ±17%     -49.4%      35731 ±41%  sched_debug.cfs_rq[0]:/.exec_clock
    136723 ±15%     -39.7%      82462 ±34%  sched_debug.cfs_rq[0]:/.min_vruntime
       654 ±10%     +27.7%        836 ±17%  sched_debug.cpu#18.sched_goidle
    125106 ± 4%     -11.0%     111302 ± 4%  sched_debug.cpu#8.nr_load_updates
       122 ± 6%     -44.1%         68 ±27%  sched_debug.cfs_rq[3]:/.load
         9 ±12%     -34.5%          6 ±19%  sched_debug.cfs_rq[18]:/.tg_runnable_contrib
    660329 ±11%     +16.4%     768895 ± 4%  sched_debug.cpu#11.avg_idle
       405 ± 7%     +21.1%        490 ± 6%  slabinfo.kmem_cache.active_objs
       405 ± 7%     +21.1%        490 ± 6%  slabinfo.kmem_cache.num_objs
      1513 ± 5%     -49.0%        771 ±25%  sched_debug.cpu#3.curr->pid
     69624 ±14%     +26.2%      87837 ± 3%  sched_debug.cpu#2.nr_load_updates
    308728 ± 1%     -16.1%     258979 ± 0%  cpuidle.C7-SNB.usage
    988675 ± 0%      -9.8%     891351 ± 4%  sched_debug.cpu#4.avg_idle
       514 ± 5%     +16.6%        599 ± 5%  slabinfo.kmem_cache_node.active_objs
       533 ± 5%     +16.0%        618 ± 4%  slabinfo.kmem_cache_node.num_objs
      1492 ±10%     +28.8%       1921 ±14%  sched_debug.cpu#18.nr_switches
     11153 ± 9%     +17.4%      13091 ± 4%  slabinfo.kmalloc-256.active_objs
      3919 ± 5%     -11.6%       3463 ± 7%  sched_debug.cfs_rq[24]:/.tg_load_avg
      3902 ± 4%     -11.3%       3460 ± 7%  sched_debug.cfs_rq[15]:/.tg_load_avg
      3918 ± 6%     -11.7%       3462 ± 6%  sched_debug.cfs_rq[19]:/.tg_load_avg
      3915 ± 5%     -11.8%       3451 ± 8%  sched_debug.cfs_rq[25]:/.tg_load_avg
      3920 ± 6%     -11.8%       3459 ± 6%  sched_debug.cfs_rq[20]:/.tg_load_avg
      3929 ± 5%     -11.4%       3479 ± 6%  sched_debug.cfs_rq[21]:/.tg_load_avg
      3919 ± 5%     -11.1%       3483 ± 7%  sched_debug.cfs_rq[18]:/.tg_load_avg
      3887 ± 5%     -11.4%       3442 ± 7%  sched_debug.cfs_rq[9]:/.tg_load_avg
      3907 ± 5%     -10.6%       3494 ± 7%  sched_debug.cfs_rq[23]:/.tg_load_avg
      3897 ± 4%     -11.1%       3464 ± 7%  sched_debug.cfs_rq[12]:/.tg_load_avg
      3890 ± 6%     -10.8%       3469 ± 8%  sched_debug.cfs_rq[30]:/.tg_load_avg
      3881 ± 6%     -11.2%       3447 ± 7%  sched_debug.cfs_rq[31]:/.tg_load_avg
      3892 ± 5%     -11.4%       3449 ± 7%  sched_debug.cfs_rq[8]:/.tg_load_avg
      3920 ± 5%     -11.1%       3486 ± 6%  sched_debug.cfs_rq[22]:/.tg_load_avg
      3940 ± 4%     -11.5%       3485 ± 6%  sched_debug.cfs_rq[1]:/.tg_load_avg
      3891 ± 5%     -11.3%       3449 ± 7%  sched_debug.cfs_rq[26]:/.tg_load_avg
      3904 ± 4%     -11.2%       3469 ± 7%  sched_debug.cfs_rq[11]:/.tg_load_avg
      3906 ± 5%     -10.7%       3489 ± 6%  sched_debug.cfs_rq[16]:/.tg_load_avg
      3908 ± 4%     -11.7%       3452 ± 7%  sched_debug.cfs_rq[10]:/.tg_load_avg
      3875 ± 5%      -9.9%       3492 ± 8%  sched_debug.cfs_rq[29]:/.tg_load_avg
       499 ± 4%     -11.7%        440 ± 6%  numa-vmstat.node0.nr_page_table_pages
      3878 ± 4%     -10.5%       3472 ± 7%  sched_debug.cfs_rq[13]:/.tg_load_avg
      3899 ± 6%     -10.8%       3479 ± 7%  sched_debug.cfs_rq[27]:/.tg_load_avg
      3873 ± 5%     -10.5%       3466 ± 7%  sched_debug.cfs_rq[14]:/.tg_load_avg
      3909 ± 4%     -10.5%       3498 ± 6%  sched_debug.cfs_rq[5]:/.tg_load_avg
      1992 ± 4%     -11.6%       1761 ± 6%  numa-meminfo.node0.PageTables
     11313 ± 9%     +17.2%      13260 ± 2%  slabinfo.kmalloc-256.num_objs
      3904 ± 5%     -11.6%       3452 ± 6%  sched_debug.cfs_rq[3]:/.tg_load_avg
      3903 ± 4%     -10.5%       3493 ± 6%  sched_debug.cfs_rq[6]:/.tg_load_avg
      3913 ± 5%     -11.6%       3461 ± 6%  sched_debug.cfs_rq[2]:/.tg_load_avg
      3896 ± 5%     -11.1%       3461 ± 7%  sched_debug.cfs_rq[7]:/.tg_load_avg
      3912 ± 4%     -10.9%       3486 ± 6%  sched_debug.cfs_rq[4]:/.tg_load_avg
      3915 ± 5%     -10.9%       3489 ± 6%  sched_debug.cfs_rq[17]:/.tg_load_avg
       417 ± 5%   +1714.5%       7572 ±11%  time.involuntary_context_switches
   1545546 ±14%     +46.1%    2257840 ± 8%  time.voluntary_context_switches
        92 ± 0%      -4.0%         88 ± 1%  time.percent_of_cpu_this_job_got
    266.95 ± 1%      -4.7%     254.49 ± 1%  time.system_time
     70.07 ± 0%      -1.7%      68.85 ± 1%  turbostat.Pkg_W
      0.00 ± 0%      -1.7%       0.00 ± 1%  energy.energy-pkg

testbox/testcase/testparams: lkp-a04/netperf/300s-200%-TCP_SENDFILE

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
       357 ±14%     +48.2%        529 ± 5%  sched_debug.cfs_rq[2]:/.blocked_load_avg
    273340 ± 1%     +12.5%     307586 ± 8%  sched_debug.cfs_rq[1]:/.MIN_vruntime
    273341 ± 1%     +12.5%     307587 ± 8%  sched_debug.cfs_rq[1]:/.max_vruntime
       834 ± 7%     +22.7%       1024 ± 6%  sched_debug.cfs_rq[2]:/.tg_load_contrib
       422 ± 6%      +7.0%        451 ± 5%  sched_debug.cpu#1.cpu_load[0]
     17997 ±13%     -37.6%      11222 ±19%  sched_debug.cpu#0.sched_goidle
     58206 ±16%     -35.2%      37726 ± 5%  meminfo.DirectMap4k
     73342 ± 3%      -7.3%      67960 ± 4%  softirqs.RCU
        50 ±40%     -60.3%         20 ±41%  cpuidle.C2-ATM.usage
     19996 ± 2%     -12.4%      17512 ± 1%  softirqs.SCHED
       234 ± 9%     -11.5%        207 ± 9%  cpuidle.C6-ATM.usage
       143 ± 0%      -1.2%        141 ± 0%  time.percent_of_cpu_this_job_got
    415.97 ± 0%      -1.1%     411.58 ± 0%  time.system_time

testbox/testcase/testparams: lkp-sb03/nepim/300s-25%-udp

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    613815 ± 1%      +7.4%     659052 ± 0%  nepim.udp.avg.kbps_out
     18732 ± 1%      +7.4%      20112 ± 0%  nepim.udp.avg.snd_s
   -320497 ± 0%      -7.2%    -297493 ±-2%  sched_debug.cfs_rq[24]:/.spread0
   -321084 ± 0%      -7.2%    -297847 ±-2%  sched_debug.cfs_rq[21]:/.spread0
   -320898 ± 0%      -7.1%    -298153 ±-2%  sched_debug.cfs_rq[30]:/.spread0
   -322176 ± 0%      -8.2%    -295627 ±-2%  sched_debug.cfs_rq[14]:/.spread0
   -317520 ±-1%     -10.0%    -285795 ±-6%  sched_debug.cfs_rq[12]:/.spread0
   -314487 ±-1%      -6.1%    -295166 ±-1%  sched_debug.cfs_rq[11]:/.spread0
   -321530 ± 0%      -7.6%    -296947 ±-2%  sched_debug.cfs_rq[15]:/.spread0
   -321302 ± 0%      -7.2%    -298254 ±-2%  sched_debug.cfs_rq[17]:/.spread0
   -321475 ± 0%      -7.5%    -297494 ±-1%  sched_debug.cfs_rq[23]:/.spread0
   -317814 ± 0%      -7.3%    -294474 ±-2%  sched_debug.cfs_rq[18]:/.spread0
   -321687 ± 0%      -7.7%    -296916 ±-2%  sched_debug.cfs_rq[29]:/.spread0
   -320368 ± 0%      -7.3%    -296887 ±-2%  sched_debug.cfs_rq[31]:/.spread0
   -322274 ± 0%      -7.5%    -298025 ±-1%  sched_debug.cfs_rq[22]:/.spread0
   -318704 ± 0%      -7.9%    -293419 ±-2%  sched_debug.cfs_rq[1]:/.spread0
   -317100 ± 0%      -8.0%    -291706 ±-1%  sched_debug.cfs_rq[5]:/.spread0
   -310371 ±-1%      -7.8%    -286235 ±-1%  sched_debug.cfs_rq[3]:/.spread0
   -320602 ± 0%      -7.6%    -296275 ±-1%  sched_debug.cfs_rq[19]:/.spread0
   -314944 ±-1%      -8.4%    -288396 ±-2%  sched_debug.cfs_rq[2]:/.spread0
   -320652 ± 0%      -7.6%    -296167 ±-2%  sched_debug.cfs_rq[20]:/.spread0
   -317734 ± 0%      -8.1%    -292103 ±-2%  sched_debug.cfs_rq[6]:/.spread0
   -320529 ± 0%      -8.3%    -293841 ±-2%  sched_debug.cfs_rq[26]:/.spread0
   -314699 ± 0%      -7.1%    -292485 ±-2%  sched_debug.cfs_rq[16]:/.spread0
      2163 ±12%     -79.7%        438 ±29%  sched_debug.cpu#14.ttwu_count
   -321151 ± 0%      -8.0%    -295420 ±-1%  sched_debug.cfs_rq[27]:/.spread0
   -319401 ±-1%      -7.5%    -295562 ±-1%  sched_debug.cfs_rq[13]:/.spread0
      1421 ±16%     -76.9%        329 ±20%  sched_debug.cpu#5.ttwu_local
   -315126 ± 0%      -7.8%    -290630 ±-1%  sched_debug.cfs_rq[4]:/.spread0
   -313540 ± 0%      -7.0%    -291520 ±-2%  sched_debug.cfs_rq[7]:/.spread0
   -320276 ± 0%      -7.6%    -295808 ±-2%  sched_debug.cfs_rq[28]:/.spread0
      1719 ± 3%     -83.4%        284 ±22%  sched_debug.cpu#7.ttwu_local
      1383 ±31%     -87.7%        170 ±35%  sched_debug.cpu#13.ttwu_local
         3 ±28%     -60.0%          1 ±35%  sched_debug.cpu#16.cpu_load[3]
       947 ±13%     -89.0%        104 ±19%  sched_debug.cpu#14.ttwu_local
      7606 ±14%    +498.2%      45499 ± 1%  sched_debug.cpu#25.sched_count
      2230 ±11%     -84.7%        340 ±12%  sched_debug.cpu#4.ttwu_local
       616 ± 5%    +618.8%       4432 ±37%  sched_debug.cfs_rq[2]:/.exec_clock
   -321906 ± 0%      -8.0%    -296005 ±-2%  sched_debug.cfs_rq[9]:/.spread0
      1487 ± 7%     -79.2%        310 ± 4%  sched_debug.cpu#6.ttwu_local
      3778 ±21%     -89.7%        387 ±15%  sched_debug.cpu#10.ttwu_local
      2539 ±13%     -79.4%        522 ±20%  sched_debug.cpu#13.ttwu_count
      3463 ±14%     -58.5%       1436 ±37%  sched_debug.cpu#12.ttwu_count
      3554 ±48%     -80.3%        699 ±38%  sched_debug.cpu#15.ttwu_count
      2673 ± 6%     +88.2%       5031 ± 4%  sched_debug.cpu#16.ttwu_count
   -320748 ± 0%      -8.5%    -293620 ±-2%  sched_debug.cfs_rq[8]:/.spread0
      6636 ± 3%    +585.6%      45494 ± 1%  sched_debug.cpu#25.nr_switches
      6495 ±13%     -75.6%       1584 ± 9%  sched_debug.cpu#10.ttwu_count
      3089 ±12%     -73.1%        829 ±10%  sched_debug.cpu#5.ttwu_count
      2309 ±21%     -86.4%        313 ± 5%  sched_debug.cpu#1.ttwu_local
      3199 ± 4%     -77.4%        723 ±22%  sched_debug.cpu#7.ttwu_count
      4826 ± 6%     +42.5%       6875 ± 3%  sched_debug.cpu#16.nr_switches
      6572 ± 3%    +199.1%      19657 ±19%  sched_debug.cpu#26.nr_load_updates
      4409 ±13%     -75.4%       1086 ± 5%  sched_debug.cpu#4.ttwu_count
      9187 ±33%     -59.8%       3693 ±38%  sched_debug.cpu#15.nr_switches
      4413 ± 4%      -9.5%       3994 ± 2%  sched_debug.cpu#28.sched_count
       941 ±19%     -32.8%        632 ±20%  sched_debug.cfs_rq[11]:/.max_vruntime
       941 ±19%     -32.8%        632 ±20%  sched_debug.cfs_rq[11]:/.MIN_vruntime
      6219 ±19%     -75.8%       1502 ±15%  sched_debug.cpu#9.sched_count
       776 ±15%    +107.5%       1610 ± 5%  sched_debug.cpu#16.ttwu_local
      4564 ±33%     -60.3%       1813 ±39%  sched_debug.cpu#15.sched_goidle
      1128 ± 4%     +15.3%       1300 ± 8%  sched_debug.cfs_rq[3]:/.exec_clock
      1795 ±38%    +132.6%       4177 ±49%  sched_debug.cpu#26.ttwu_count
      5520 ±10%    +454.6%      30617 ± 2%  sched_debug.cpu#25.ttwu_count
     11528 ±37%     -52.6%       5467 ±34%  sched_debug.cpu#13.sched_count
       433 ±37%    +385.1%       2100 ±33%  sched_debug.cpu#24.nr_switches
       445 ±36%    +374.1%       2113 ±33%  sched_debug.cpu#24.sched_count
      3728 ± 6%     -48.6%       1917 ±33%  sched_debug.cpu#6.ttwu_count
       186 ±22%     +87.8%        350 ±16%  sched_debug.cpu#22.ttwu_count
      5998 ± 2%    +197.5%      17846 ±17%  sched_debug.cpu#30.nr_load_updates
      9644 ± 9%     -23.3%       7395 ± 4%  sched_debug.cfs_rq[16]:/.min_vruntime
      2692 ± 5%     -58.6%       1115 ± 5%  sched_debug.cpu#11.ttwu_local
      4838 ± 6%     +42.4%       6888 ± 3%  sched_debug.cpu#16.sched_count
      6623 ± 7%     -59.4%       2689 ±45%  sched_debug.cpu#14.nr_switches
      0.13 ± 3%    +268.4%       0.47 ± 2%  turbostat.%pc2
      2065 ± 6%     +18.2%       2441 ± 4%  sched_debug.cpu#16.sched_goidle
      1167 ±17%   +1248.5%      15736 ± 2%  sched_debug.cpu#25.ttwu_local
      9982 ±38%     -51.2%       4866 ±21%  sched_debug.cpu#15.sched_count
      4218 ±21%     -78.8%        892 ± 3%  sched_debug.cpu#1.ttwu_count
     12688 ±17%     -63.2%       4669 ± 8%  sched_debug.cpu#10.nr_switches
         0 ± 0%      +Inf%          1 ± 0%  sched_debug.cfs_rq[11]:/.runnable_load_avg
      7783 ± 3%     -41.9%       4521 ± 6%  sched_debug.cpu#6.nr_switches
       191 ±33%    +437.2%       1029 ±33%  sched_debug.cpu#24.sched_goidle
       174 ±20%     +37.1%        239 ±16%  sched_debug.cfs_rq[2]:/.avg->runnable_avg_sum
      4400 ± 4%      -9.5%       3983 ± 2%  sched_debug.cpu#28.nr_switches
      3289 ± 7%     -60.1%       1312 ±47%  sched_debug.cpu#14.sched_goidle
       113 ±28%     +56.6%        177 ±14%  sched_debug.cpu#19.ttwu_local
      4013 ± 6%     -42.4%       2311 ± 7%  sched_debug.cpu#5.sched_goidle
      5240 ± 3%     -30.9%       3623 ±18%  sched_debug.cpu#12.sched_goidle
       746 ±23%     +33.2%        994 ±20%  sched_debug.cpu#22.sched_count
     10760 ± 3%     -18.3%       8796 ± 4%  sched_debug.cpu#3.sched_goidle
         7 ±25%     +50.0%         11 ± 0%  sched_debug.cfs_rq[26]:/.tg_runnable_contrib
       353 ± 7%     +45.1%        513 ± 3%  sched_debug.cpu#21.ttwu_count
       369 ±22%     +48.7%        548 ± 2%  sched_debug.cfs_rq[26]:/.avg->runnable_avg_sum
      3879 ± 3%     -43.2%       2204 ± 6%  sched_debug.cpu#6.sched_goidle
      8154 ± 9%     -50.3%       4056 ± 7%  sched_debug.cpu#13.nr_switches
      6518 ± 8%     -37.8%       4055 ±10%  sched_debug.cpu#11.ttwu_count
     12545 ±19%     +94.3%      24380 ±17%  sched_debug.cpu#0.sched_count
     12125 ± 7%     -35.9%       7767 ±22%  sched_debug.cpu#12.sched_count
       874 ±16%     +27.0%       1110 ± 2%  sched_debug.cpu#19.sched_count
     15301 ±23%     -55.3%       6839 ±44%  sched_debug.cpu#10.sched_count
      8071 ± 6%     -41.6%       4710 ± 6%  sched_debug.cpu#5.nr_switches
      6935 ± 1%    +164.2%      18321 ±15%  sched_debug.cpu#28.nr_load_updates
    160.08 ±21%     -57.4%      68.24 ±17%  sched_debug.cfs_rq[17]:/.exec_clock
      4035 ±10%     -51.2%       1968 ± 8%  sched_debug.cpu#13.sched_goidle
      6166 ± 4%     -36.1%       3938 ± 1%  sched_debug.cpu#4.sched_goidle
     12390 ± 4%     -35.6%       7979 ± 1%  sched_debug.cpu#4.nr_switches
      2013 ±13%     -40.4%       1199 ±22%  sched_debug.cfs_rq[31]:/.exec_clock
     21917 ± 3%     -23.4%      16789 ± 3%  sched_debug.cpu#11.nr_switches
      2889 ±11%     +38.8%       4009 ± 4%  sched_debug.cpu#0.ttwu_local
      1770 ± 4%      -9.9%       1595 ± 3%  sched_debug.cpu#28.sched_goidle
      9373 ± 1%    +122.2%      20825 ±13%  sched_debug.cpu#16.nr_load_updates
     21640 ± 3%     -17.4%      17875 ± 4%  sched_debug.cpu#3.nr_switches
      2436 ±27%     +59.0%       3874 ± 8%  sched_debug.cfs_rq[9]:/.min_vruntime
       141 ±42%     +78.5%        251 ±31%  sched_debug.cfs_rq[21]:/.avg->runnable_avg_sum
         5 ± 8%     -25.0%          4 ± 0%  sched_debug.cfs_rq[10]:/.nr_spread_over
      6297 ± 1%    +180.9%      17692 ±16%  sched_debug.cpu#22.nr_load_updates
     23813 ± 5%     -26.3%      17540 ± 9%  sched_debug.cpu#11.sched_count
      7203 ±10%     +51.3%      10901 ± 6%  sched_debug.cpu#0.nr_switches
      6103 ± 0%    +184.8%      17380 ±16%  sched_debug.cpu#29.nr_load_updates
      6345 ± 1%    +179.0%      17704 ±16%  sched_debug.cpu#21.nr_load_updates
      6778 ±13%     -38.3%       4182 ± 1%  sched_debug.cpu#3.ttwu_count
      7185 ± 2%    +158.0%      18540 ±14%  sched_debug.cpu#20.nr_load_updates
     10557 ± 3%     -30.0%       7389 ±17%  sched_debug.cpu#12.nr_switches
     10861 ± 3%     -24.2%       8234 ± 3%  sched_debug.cpu#11.sched_goidle
      6415 ± 1%    +185.0%      18284 ±17%  sched_debug.cpu#17.nr_load_updates
      6453 ± 2%    +183.8%      18311 ±10%  sched_debug.cpu#31.nr_load_updates
      6222 ± 2%    +193.1%      18237 ±17%  sched_debug.cpu#24.nr_load_updates
        92 ± 6%    +170.3%        248 ±45%  sched_debug.cpu#27.ttwu_local
      7028 ± 3%    +162.9%      18480 ±15%  sched_debug.cpu#18.nr_load_updates
      7966 ± 5%     -51.4%       3869 ±13%  sched_debug.cpu#7.nr_switches
      5522 ±12%     -30.6%       3833 ±10%  sched_debug.cpu#2.sched_goidle
      3962 ± 5%     -52.1%       1899 ±13%  sched_debug.cpu#7.sched_goidle
      4947 ±18%     -53.5%       2300 ±12%  sched_debug.cpu#1.sched_goidle
      6343 ± 0%    +182.5%      17920 ±15%  sched_debug.cpu#19.nr_load_updates
      2816 ±10%     -50.2%       1402 ± 3%  sched_debug.cpu#3.ttwu_local
      6187 ± 1%    +198.2%      18452 ±16%  sched_debug.cpu#27.nr_load_updates
      6690 ± 8%     +45.0%       9701 ± 4%  sched_debug.cpu#0.ttwu_count
      6420 ± 1%    +183.9%      18227 ±18%  sched_debug.cpu#23.nr_load_updates
       341 ±24%     +34.7%        460 ±20%  sched_debug.cpu#22.sched_goidle
     10009 ±17%     -53.0%       4701 ±12%  sched_debug.cpu#1.nr_switches
       862 ±16%     +27.3%       1097 ± 2%  sched_debug.cpu#19.nr_switches
      3816 ±21%     +58.3%       6040 ±18%  sched_debug.cfs_rq[26]:/.min_vruntime
      3259 ±22%     -37.6%       2033 ±10%  sched_debug.cfs_rq[21]:/.min_vruntime
      7691 ±16%    +137.7%      18283 ±15%  sched_debug.cpu#9.nr_load_updates
      2017 ±14%     +53.7%       3101 ± 2%  sched_debug.cpu#0.sched_goidle
      9970 ± 0%     +94.2%      19358 ±13%  sched_debug.cpu#7.nr_load_updates
      3040 ±15%     -46.5%       1626 ±12%  sched_debug.cfs_rq[17]:/.min_vruntime
       404 ±13%    +118.1%        881 ±21%  sched_debug.cpu#19.ttwu_count
       735 ±23%     +33.6%        982 ±20%  sched_debug.cpu#22.nr_switches
      9707 ± 1%    +102.0%      19613 ±14%  sched_debug.cpu#6.nr_load_updates
      7028 ± 7%    +138.5%      16759 ±15%  sched_debug.cpu#1.nr_load_updates
     11006 ± 2%     +83.2%      20160 ±13%  sched_debug.cpu#4.nr_load_updates
      9640 ± 3%    +101.9%      19466 ±14%  sched_debug.cpu#5.nr_load_updates
     10343 ±14%     +86.3%      19265 ±18%  sched_debug.cpu#15.nr_load_updates
      8734 ± 1%    +115.3%      18805 ±14%  sched_debug.cpu#14.nr_load_updates
      9591 ± 4%    +100.4%      19225 ±12%  sched_debug.cpu#13.nr_load_updates
    154763 ± 0%      -8.9%     141064 ± 2%  sched_debug.cfs_rq[0]:/.exec_clock
     12025 ± 6%     +73.6%      20879 ±12%  sched_debug.cpu#11.nr_load_updates
     10341 ± 4%    +102.2%      20906 ±14%  sched_debug.cpu#12.nr_load_updates
       934 ± 1%     -32.0%        635 ±10%  cpuidle.C1E-SNB.usage
     10712 ±10%    +104.0%      21852 ±20%  sched_debug.cpu#8.nr_load_updates
     11875 ± 3%     +80.8%      21468 ±13%  sched_debug.cpu#3.nr_load_updates
       465 ± 7%     -35.5%        300 ±33%  sched_debug.cfs_rq[7]:/.exec_clock
       645 ±14%     +40.0%        903 ±15%  slabinfo.blkdev_requests.active_objs
       645 ±14%     +40.0%        903 ±15%  slabinfo.blkdev_requests.num_objs
    956772 ± 5%     -10.1%     859962 ± 5%  sched_debug.cpu#25.avg_idle
     10958 ± 3%     +79.7%      19689 ± 4%  sched_debug.cpu#2.nr_load_updates
    122784 ± 0%     -27.0%      89589 ± 3%  cpuidle.C7-SNB.usage
       672 ±13%     +35.4%        910 ±13%  slabinfo.xfs_buf.num_objs
       672 ±13%     +35.4%        910 ±13%  slabinfo.xfs_buf.active_objs
      4671 ±10%     -18.2%       3821 ± 6%  cpuidle.C1-SNB.usage
     37764 ± 2%     +60.0%      60411 ± 3%  softirqs.SCHED
     11061 ± 5%     +11.5%      12334 ± 4%  slabinfo.kmalloc-256.active_objs
   5821781 ± 8%     -18.0%    4773888 ±10%  meminfo.DirectMap2M
    384047 ± 0%     +12.2%     430996 ± 1%  softirqs.TIMER
      1445 ± 1%     -12.4%       1266 ± 5%  slabinfo.sock_inode_cache.active_objs
      1445 ± 1%     -12.4%       1266 ± 5%  slabinfo.sock_inode_cache.num_objs
       364 ±20%   +9569.9%      35198 ± 7%  time.involuntary_context_switches
      2331 ± 0%      -3.5%       2250 ± 0%  vmstat.system.in

testbox/testcase/testparams: lkp-a04/netperf/300s-200%-TCP_RR

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
       549 ± 6%     -11.5%        486 ± 2%  sched_debug.cfs_rq[0]:/.load
       244 ±22%     +68.3%        411 ±22%  sched_debug.cfs_rq[3]:/.blocked_load_avg
       705 ± 7%     +20.1%        846 ±10%  sched_debug.cfs_rq[3]:/.tg_load_contrib
       836 ± 8%      +7.8%        901 ± 7%  sched_debug.cfs_rq[2]:/.tg_load_contrib
   3057027 ± 0%      +9.5%    3346840 ± 1%  sched_debug.cpu#3.nr_switches
       909 ± 9%     -15.6%        767 ± 1%  sched_debug.cfs_rq[0]:/.tg_load_contrib
   3113873 ± 3%      +8.1%    3365443 ± 0%  sched_debug.cpu#3.sched_count
   3055925 ± 0%     +10.9%    3389777 ± 2%  sched_debug.cpu#2.nr_switches
        21 ±15%     -25.4%         15 ±15%  sched_debug.cfs_rq[3]:/.nr_spread_over
       554 ± 1%     -12.8%        483 ± 3%  sched_debug.cpu#1.load
     14437 ±45%     +83.7%      26517 ±12%  cpuidle.C2-ATM.time
        27 ±21%     +61.7%         43 ±20%  cpuidle.C2-ATM.usage
    232546 ± 9%     -14.0%     200000 ±12%  sched_debug.cfs_rq[3]:/.MIN_vruntime
    232546 ± 9%     -14.0%     200000 ±12%  sched_debug.cfs_rq[3]:/.max_vruntime
        13 ± 9%     -29.3%          9 ± 4%  sched_debug.cfs_rq[2]:/.nr_spread_over
      0.93 ± 6%     -13.6%       0.81 ± 4%  perf-profile.cpu-cycles.try_to_wake_up.default_wake_function.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
     17732 ± 1%     -16.7%      14766 ± 4%  softirqs.SCHED
       128 ± 3%      +5.2%        135 ± 4%  uptime.idle
      8424 ± 6%     -10.2%       7561 ± 3%  slabinfo.kmalloc-64.num_objs
      1.49 ± 4%      -8.3%       1.37 ± 2%  perf-profile.cpu-cycles.tcp_recvmsg.inet_recvmsg.sock_recvmsg.SYSC_recvfrom.sys_recvfrom

testbox/testcase/testparams: lkp-nex04/ebizzy/200%-100x-10s

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
        83 ± 0%      -2.0%         81 ± 0%  ebizzy.throughput.per_thread.min
     12681 ± 0%      -1.4%      12503 ± 0%  ebizzy.throughput
     41.83 ± 0%      +1.2%      42.33 ± 0%  ebizzy.time.user
    115275 ±39%    -255.1%    -178796 ±-14%  sched_debug.cfs_rq[1]:/.spread0
       -20 ±-20%    +109.7%        -43 ±-16%  sched_debug.cpu#31.nr_uninterruptible
       -12 ±-45%    +171.1%        -34 ±-36%  sched_debug.cpu#15.nr_uninterruptible
       413 ±41%     +59.7%        660 ±13%  sched_debug.cfs_rq[19]:/.blocked_load_avg
    207474 ±34%    +204.1%     630866 ±32%  sched_debug.cpu#40.sched_count
        56 ±18%    +112.5%        119 ±13%  sched_debug.cpu#49.nr_uninterruptible
        17 ±15%     +38.5%         24 ±12%  sched_debug.cpu#14.cpu_load[1]
    149203 ±21%    +181.6%     420151 ±24%  sched_debug.cpu#54.sched_count
        37 ±23%     -45.9%         20 ±44%  sched_debug.cpu#4.load
    252107 ±40%    +120.5%     556018 ±34%  sched_debug.cpu#23.sched_count
    210263 ±34%    +184.3%     597868 ±44%  sched_debug.cpu#21.sched_count
    990810 ±12%     +18.7%    1175867 ±10%  sched_debug.cfs_rq[39]:/.spread0
       401 ±38%     +50.2%        602 ± 8%  sched_debug.cfs_rq[25]:/.blocked_load_avg
        18 ±11%     +29.1%         23 ± 7%  sched_debug.cpu#14.cpu_load[2]
        17 ± 7%     +20.8%         21 ± 5%  sched_debug.cpu#14.cpu_load[3]
       415 ±37%     +47.6%        613 ± 8%  sched_debug.cfs_rq[25]:/.tg_load_contrib
        25 ± 4%     -28.6%         18 ±26%  numa-numastat.node0.other_node
       426 ±40%     +57.4%        671 ±13%  sched_debug.cfs_rq[19]:/.tg_load_contrib
       457 ±44%     +50.3%        687 ± 4%  sched_debug.cfs_rq[10]:/.blocked_load_avg
        12 ±26%    +127.0%         28 ±35%  sched_debug.cfs_rq[58]:/.load
        12 ±26%    +154.1%         31 ±44%  sched_debug.cpu#58.load
       471 ±43%     +48.6%        700 ± 4%  sched_debug.cfs_rq[10]:/.tg_load_contrib
    198896 ±40%    +164.2%     525570 ±49%  sched_debug.cpu#24.sched_count
        23 ±12%     -34.8%         15 ±23%  sched_debug.cfs_rq[26]:/.load
      2373 ± 0%     -14.8%       2021 ± 2%  sched_debug.cpu#21.sched_goidle
       367 ±45%     +56.2%        574 ±16%  sched_debug.cfs_rq[2]:/.blocked_load_avg
        17 ±10%     +17.3%         20 ±12%  sched_debug.cpu#27.cpu_load[2]
      2371 ± 2%     -12.9%       2064 ± 1%  sched_debug.cpu#16.sched_goidle
        17 ± 9%     +17.0%         20 ± 9%  sched_debug.cpu#27.cpu_load[3]
        14 ± 5%     -19.0%         11 ±11%  sched_debug.cfs_rq[11]:/.runnable_load_avg
        18 ±16%     -46.3%          9 ± 9%  sched_debug.cpu#26.cpu_load[0]
       402 ±44%     +63.3%        657 ±11%  sched_debug.cfs_rq[7]:/.tg_load_contrib
    262964 ±46%     +78.4%     469186 ±44%  sched_debug.cpu#47.sched_count
        39 ± 8%     -31.4%         27 ±29%  sched_debug.cfs_rq[2]:/.load
        12 ±26%    +102.7%         25 ±37%  sched_debug.cpu#58.cpu_load[0]
        12 ±26%     +81.1%         22 ±29%  sched_debug.cfs_rq[58]:/.runnable_load_avg
       440 ±45%     +58.7%        698 ±16%  sched_debug.cfs_rq[20]:/.blocked_load_avg
      2555 ± 2%     -18.0%       2096 ± 4%  sched_debug.cpu#14.sched_goidle
         6 ±25%     -50.0%          3 ±28%  cpuidle.POLL.usage
        16 ±10%     +28.0%         21 ± 2%  sched_debug.cpu#1.cpu_load[3]
    186638 ±30%    +122.1%     414470 ±43%  sched_debug.cpu#53.sched_count
       391 ±44%     +51.4%        592 ±15%  sched_debug.cfs_rq[2]:/.tg_load_contrib
        27 ±47%     +96.3%         53 ±38%  sched_debug.cpu#41.cpu_load[0]
        14 ±31%     +84.1%         27 ±20%  sched_debug.cpu#60.load
        21 ±30%     -52.3%         10 ±12%  sched_debug.cpu#21.cpu_load[0]
       390 ±46%     +65.6%        645 ±11%  sched_debug.cfs_rq[7]:/.blocked_load_avg
     66283 ± 3%      +8.5%      71886 ± 2%  sched_debug.cpu#11.ttwu_count
        27 ±47%     +85.4%         50 ±35%  sched_debug.cfs_rq[41]:/.runnable_load_avg
       389 ±43%     +64.2%        640 ± 8%  sched_debug.cfs_rq[29]:/.blocked_load_avg
        14 ±22%     -34.1%          9 ± 9%  sched_debug.cfs_rq[26]:/.runnable_load_avg
       402 ±41%     +62.3%        653 ± 7%  sched_debug.cfs_rq[29]:/.tg_load_contrib
    382891 ±41%     +64.4%     629385 ±23%  sched_debug.cpu#10.sched_count
        16 ± 5%     +20.8%         19 ± 2%  sched_debug.cpu#1.cpu_load[4]
      3299 ± 9%     -27.3%       2398 ± 3%  sched_debug.cpu#4.sched_goidle
        21 ±34%     -45.3%         11 ±38%  sched_debug.cpu#53.load
    135693 ± 3%      +7.3%     145636 ± 2%  sched_debug.cpu#11.nr_switches
        20 ± 7%     -30.0%         14 ± 5%  sched_debug.cpu#21.cpu_load[1]
        17 ±16%     +67.3%         29 ±23%  sched_debug.cpu#28.load
        15 ±26%     +48.9%         23 ±22%  sched_debug.cpu#9.load
       454 ±44%     +56.6%        711 ±15%  sched_debug.cfs_rq[20]:/.tg_load_contrib
       426 ±47%     +56.8%        669 ±10%  sched_debug.cfs_rq[21]:/.blocked_load_avg
        12 ±10%     -21.6%          9 ± 4%  sched_debug.cfs_rq[19]:/.runnable_load_avg
        19 ± 4%     -17.5%         15 ± 6%  sched_debug.cpu#21.cpu_load[2]
       442 ±46%     +54.6%        683 ±10%  sched_debug.cfs_rq[21]:/.tg_load_contrib
        16 ± 2%      -8.0%         15 ± 3%  sched_debug.cpu#21.cpu_load[4]
        13 ±22%     +89.7%         24 ±34%  sched_debug.cpu#58.cpu_load[1]
        17 ± 2%      -9.4%         16 ± 5%  sched_debug.cpu#21.cpu_load[3]
      4281 ±32%     -36.6%       2713 ± 5%  sched_debug.cpu#11.sched_goidle
    145077 ±20%     +90.1%     275727 ±41%  sched_debug.cpu#52.sched_count
        28 ±44%     +75.0%         49 ±32%  sched_debug.cpu#41.cpu_load[1]
        11 ± 8%    +114.3%         25 ±25%  sched_debug.cfs_rq[59]:/.load
        13 ± 6%    +170.7%         37 ±45%  sched_debug.cpu#3.cpu_load[0]
      3270 ±18%     -24.3%       2474 ± 6%  sched_debug.cpu#1.sched_goidle
        12 ± 7%     +71.1%         21 ± 4%  sched_debug.cfs_rq[1]:/.runnable_load_avg
        22 ±31%     +52.2%         34 ±24%  sched_debug.cpu#10.load
        12 ± 7%    +100.0%         25 ± 6%  sched_debug.cfs_rq[1]:/.load
    160297 ±30%     +44.2%     231073 ±24%  sched_debug.cpu#35.sched_count
      2223 ± 0%     -12.5%       1946 ± 2%  sched_debug.cpu#17.sched_goidle
        18 ±11%     +80.4%         33 ±21%  sched_debug.cfs_rq[18]:/.load
      2379 ± 8%     -12.3%       2085 ± 7%  sched_debug.cpu#22.sched_goidle
        42 ± 6%     -35.2%         27 ±27%  sched_debug.cfs_rq[20]:/.load
        20 ±34%     -43.5%         11 ±26%  sched_debug.cfs_rq[54]:/.load
        20 ±34%     -43.5%         11 ±26%  sched_debug.cpu#54.load
    202074 ±26%     +85.4%     374733 ±40%  sched_debug.cpu#49.sched_count
        24 ±23%     -49.3%         12 ±21%  sched_debug.cpu#6.load
        13 ±18%    +132.5%         31 ±18%  sched_debug.cpu#43.load
    203456 ±24%    +157.7%     524260 ±41%  sched_debug.cpu#20.sched_count
    200838 ±21%    +129.5%     460986 ±18%  sched_debug.cpu#18.sched_count
       400 ±45%     +49.9%        600 ±11%  sched_debug.cfs_rq[26]:/.blocked_load_avg
       415 ±44%     +46.7%        609 ±10%  sched_debug.cfs_rq[26]:/.tg_load_contrib
       368 ±46%     +78.1%        656 ±14%  sched_debug.cfs_rq[22]:/.blocked_load_avg
        12 ± 7%     -23.7%          9 ± 9%  sched_debug.cfs_rq[16]:/.runnable_load_avg
       380 ±44%     +75.2%        666 ±13%  sched_debug.cfs_rq[22]:/.tg_load_contrib
        16 ±15%     -44.0%          9 ± 5%  sched_debug.cpu#45.cpu_load[0]
        16 ±15%     -44.0%          9 ±13%  sched_debug.cfs_rq[45]:/.runnable_load_avg
        28 ±17%     +89.5%         54 ±41%  sched_debug.cpu#45.nr_uninterruptible
        15 ±30%     -40.0%          9 ± 9%  sched_debug.cfs_rq[37]:/.runnable_load_avg
       208 ± 0%     -28.2%        149 ±10%  proc-vmstat.nr_dirtied
        17 ±19%     -42.3%         10 ± 8%  sched_debug.cpu#45.cpu_load[1]
        14 ±28%     +61.4%         23 ±28%  sched_debug.cfs_rq[48]:/.load
        20 ±27%     +62.9%         33 ±28%  sched_debug.cpu#62.load
    123063 ± 5%     +82.2%     224204 ±45%  sched_debug.cpu#60.sched_count
        16 ±23%     +96.0%         32 ±41%  sched_debug.cpu#6.cpu_load[0]
        15 ±16%     -26.1%         11 ±11%  sched_debug.cpu#38.cpu_load[1]
       432 ±44%     +60.5%        694 ± 8%  sched_debug.cfs_rq[23]:/.blocked_load_avg
    252685 ±38%     +40.9%     356018 ±10%  sched_debug.cpu#55.sched_count
       445 ±42%     +58.1%        704 ± 8%  sched_debug.cfs_rq[23]:/.tg_load_contrib
        13 ±13%     +73.2%         23 ±10%  sched_debug.cfs_rq[3]:/.load
        18 ± 6%     +65.5%         30 ±24%  sched_debug.cpu#3.cpu_load[1]
        13 ±15%     +75.6%         24 ±10%  sched_debug.cfs_rq[31]:/.load
        17 ±17%     +60.8%         27 ±10%  sched_debug.cpu#31.load
      2674 ±14%     +31.3%       3512 ± 9%  cpuidle.C1-NHM.usage
        18 ±20%     -32.7%         12 ±10%  sched_debug.cpu#45.cpu_load[2]
        19 ±10%     +29.3%         25 ±13%  sched_debug.cpu#3.cpu_load[2]
        12 ±16%     -21.6%          9 ± 9%  sched_debug.cpu#61.cpu_load[0]
        12 ±16%     -21.6%          9 ± 9%  sched_debug.cpu#61.cpu_load[1]
       371 ±46%     +55.2%        575 ±12%  sched_debug.cfs_rq[39]:/.blocked_load_avg
       385 ±44%     +52.9%        589 ±13%  sched_debug.cfs_rq[39]:/.tg_load_contrib
        18 ±17%     -25.0%         14 ±10%  sched_debug.cpu#45.cpu_load[3]
        14 ± 3%     +23.3%         17 ±10%  sched_debug.cpu#60.cpu_load[3]
        13 ±10%     +38.5%         18 ±25%  sched_debug.cpu#31.cpu_load[1]
        63 ±37%     +68.9%        107 ±22%  sched_debug.cfs_rq[49]:/.nr_spread_over
       365 ±46%     +63.5%        596 ±14%  sched_debug.cfs_rq[62]:/.blocked_load_avg
        27 ±33%     -38.6%         17 ±14%  sched_debug.cfs_rq[30]:/.load
       378 ±44%     +61.0%        609 ±14%  sched_debug.cfs_rq[62]:/.tg_load_contrib
        42 ±22%     +56.3%         66 ±24%  sched_debug.cfs_rq[57]:/.load
        14 ±11%     +15.9%         17 ± 8%  sched_debug.cpu#47.cpu_load[2]
      1881 ±10%     -14.2%       1614 ± 6%  sched_debug.cpu#39.sched_goidle
     12305 ± 5%      -9.9%      11081 ± 3%  numa-meminfo.node0.SReclaimable
      3075 ± 5%      -9.9%       2770 ± 3%  numa-vmstat.node0.nr_slab_reclaimable
     24141 ± 2%     +10.0%      26545 ± 3%  numa-meminfo.node1.SUnreclaim
        11 ±11%     -17.6%          9 ± 5%  sched_debug.cpu#44.cpu_load[0]
        11 ±11%     -17.6%          9 ± 5%  sched_debug.cfs_rq[44]:/.runnable_load_avg
     12214 ± 1%      -8.9%      11131 ± 3%  slabinfo.kmalloc-256.active_objs
        15 ± 6%     +28.3%         19 ±12%  sched_debug.cpu#31.cpu_load[2]
        16 ± 5%     +18.0%         19 ± 6%  sched_debug.cpu#31.cpu_load[3]
        15 ± 3%     +21.7%         18 ±13%  sched_debug.cpu#58.cpu_load[4]
        14 ± 3%     +18.2%         17 ± 5%  sched_debug.cpu#60.cpu_load[4]
       639 ± 5%      -8.9%        582 ± 1%  numa-vmstat.node3.nr_mapped
      2558 ± 5%      -8.9%       2331 ± 1%  numa-meminfo.node3.Mapped
     16791 ±14%     -19.0%      13605 ±10%  sched_debug.cpu#49.curr->pid
     39715 ± 3%     -11.4%      35185 ± 3%  numa-meminfo.node0.Slab
      3039 ± 5%     +15.2%       3500 ± 6%  sched_debug.cpu#57.sched_goidle
        16 ± 2%     +10.2%         18 ± 4%  sched_debug.cpu#31.cpu_load[4]
        14 ± 3%     +11.6%         16 ± 5%  sched_debug.cpu#59.cpu_load[3]
      2350 ±22%     -22.7%       1817 ± 5%  sched_debug.cpu#42.sched_goidle
       407 ±45%     +50.0%        610 ± 9%  sched_debug.cfs_rq[56]:/.tg_load_contrib
      2567 ± 4%      -8.4%       2352 ± 0%  numa-meminfo.node0.Mapped
       641 ± 4%      -8.4%        587 ± 0%  numa-vmstat.node0.nr_mapped
       393 ±47%     +51.7%        596 ± 9%  sched_debug.cfs_rq[56]:/.blocked_load_avg
      2549 ± 4%      -8.1%       2342 ± 0%  proc-vmstat.nr_mapped
     10198 ± 4%      -8.1%       9369 ± 0%  meminfo.Mapped
       636 ± 5%      -7.8%        587 ± 0%  numa-vmstat.node2.nr_mapped
      2547 ± 5%      -7.8%       2349 ± 0%  numa-meminfo.node2.Mapped
       631 ± 4%      -7.5%        583 ± 0%  numa-vmstat.node1.nr_mapped
      2525 ± 4%      -7.5%       2336 ± 0%  numa-meminfo.node1.Mapped
 1.219e+09 ± 0%      -1.4%  1.202e+09 ± 0%  time.minor_page_faults
    793360 ± 0%      -1.6%     780981 ± 0%  vmstat.system.in
      4198 ± 0%      +1.2%       4247 ± 0%  time.user_time

testbox/testcase/testparams: lkp-a04/netperf/300s-200%-TCP_CRR

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    915757 ± 2%     -12.1%     804961 ±11%  sched_debug.cpu#1.ttwu_local
    707963 ± 1%     +17.3%     830122 ± 8%  sched_debug.cpu#2.ttwu_local
    952710 ± 2%     -13.4%     825293 ±11%  sched_debug.cpu#1.ttwu_count
    740153 ± 0%     +16.2%     860125 ± 7%  sched_debug.cpu#2.ttwu_count
       970 ± 6%     -10.9%        864 ± 7%  sched_debug.cfs_rq[2]:/.tg_load_contrib
       411 ±10%     +17.2%        482 ± 3%  sched_debug.cpu#2.load
   1048586 ± 3%     +32.5%    1389065 ± 7%  sched_debug.cpu#2.sched_count
   1027759 ± 4%     +26.3%    1298423 ± 7%  sched_debug.cpu#3.sched_count
   1028957 ± 1%     +14.7%    1180449 ± 9%  sched_debug.cpu#2.nr_switches
   1321054 ± 2%     -13.9%    1137448 ±11%  sched_debug.cpu#1.nr_switches
     80734 ±11%     -44.8%      44553 ± 9%  meminfo.DirectMap4k
     70255 ±27%     +66.1%     116714 ±14%  sched_debug.cfs_rq[3]:/.MIN_vruntime
     70255 ±27%     +66.1%     116714 ±14%  sched_debug.cfs_rq[3]:/.max_vruntime
       367 ± 6%     +16.7%        428 ± 4%  sched_debug.cfs_rq[3]:/.load
        13 ±16%     -35.9%          8 ±11%  sched_debug.cfs_rq[2]:/.nr_spread_over
     18981 ± 2%     -17.7%      15623 ± 3%  softirqs.SCHED
      3707 ± 4%     -13.8%       3197 ± 6%  slabinfo.anon_vma.active_objs
      3707 ± 4%     -13.8%       3197 ± 6%  slabinfo.anon_vma.num_objs
      6203 ± 0%      -4.5%       5925 ± 0%  vmstat.system.in

testbox/testcase/testparams: lkp-sb03/thrulay/300s

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     47828 ± 1%      -5.5%      45180 ± 0%  thrulay.throughput
      0.10 ± 1%      +5.9%       0.10 ± 0%  thrulay.RTT
    -59302 ±-17%     -50.1%     -29575 ±-35%  sched_debug.cfs_rq[24]:/.spread0
    -60291 ±-15%     -50.7%     -29694 ±-31%  sched_debug.cfs_rq[21]:/.spread0
    -60819 ±-14%     -47.2%     -32107 ±-24%  sched_debug.cfs_rq[30]:/.spread0
    -54873 ±-16%     -45.3%     -30027 ±-34%  sched_debug.cfs_rq[17]:/.spread0
    -59850 ±-17%     -47.2%     -31624 ±-30%  sched_debug.cfs_rq[23]:/.spread0
    -55261 ±-20%     -45.9%     -29906 ±-24%  sched_debug.cfs_rq[18]:/.spread0
    -41785 ±-16%     -41.5%     -24458 ±-43%  sched_debug.cfs_rq[25]:/.spread0
    -57365 ±-17%     -47.7%     -30005 ±-32%  sched_debug.cfs_rq[29]:/.spread0
    -60492 ±-14%     -51.2%     -29536 ±-30%  sched_debug.cfs_rq[31]:/.spread0
    -61193 ±-14%     -47.0%     -32461 ±-27%  sched_debug.cfs_rq[22]:/.spread0
    -54660 ±-11%     -62.3%     -20582 ±-29%  sched_debug.cfs_rq[5]:/.spread0
    -48402 ±-25%     -64.3%     -17293 ±-9%  sched_debug.cfs_rq[3]:/.spread0
    -60044 ±-15%     -48.8%     -30734 ±-28%  sched_debug.cfs_rq[19]:/.spread0
    -47533 ±-5%     -69.0%     -14740 ±-22%  sched_debug.cfs_rq[2]:/.spread0
    -55735 ±-19%     -47.5%     -29282 ±-35%  sched_debug.cfs_rq[20]:/.spread0
    -55307 ±-22%     -54.9%     -24958 ±-2%  sched_debug.cfs_rq[6]:/.spread0
    -56973 ±-18%     -47.7%     -29790 ±-28%  sched_debug.cfs_rq[26]:/.spread0
    -62112 ±-15%     -54.6%     -28195 ±-27%  sched_debug.cfs_rq[16]:/.spread0
    -59783 ±-15%     -55.3%     -26706 ±-44%  sched_debug.cfs_rq[27]:/.spread0
    -50405 ±-2%     -62.5%     -18877 ±-24%  sched_debug.cfs_rq[4]:/.spread0
    -56951 ±-14%     -56.5%     -24767 ±-7%  sched_debug.cfs_rq[7]:/.spread0
    -58540 ±-16%     -46.1%     -31550 ±-28%  sched_debug.cfs_rq[28]:/.spread0
         0 ± 0%      +Inf%          9 ±41%  sched_debug.cpu#16.cpu_load[4]
      2027 ±14%     -47.4%       1067 ±10%  sched_debug.cpu#1.ttwu_local
    278405 ±41%     +46.1%     406808 ± 9%  cpuidle.C6-SNB.time
  51182.86 ±25%     -50.9%   25142.66 ±24%  sched_debug.cfs_rq[9]:/.exec_clock
         4 ± 0%    +758.3%         34 ±35%  sched_debug.cfs_rq[27]:/.tg_runnable_contrib
       215 ± 1%    +643.7%       1604 ±33%  sched_debug.cfs_rq[27]:/.avg->runnable_avg_sum
      1889 ± 6%     -44.9%       1041 ±34%  sched_debug.cpu#2.ttwu_local
        12 ±23%    +219.4%         38 ±37%  numa-numastat.node0.other_node
       969 ±30%    +156.7%       2489 ±43%  sched_debug.cfs_rq[29]:/.exec_clock
      1777 ±20%    +306.5%       7227 ±45%  sched_debug.cfs_rq[16]:/.min_vruntime
      2059 ± 5%     -20.0%       1647 ±15%  sched_debug.cpu#11.ttwu_local
       148 ±11%     +35.1%        200 ±19%  sched_debug.cpu#21.ttwu_local
      1206 ± 6%     +72.1%       2077 ±11%  sched_debug.cpu#25.ttwu_local
    601215 ±12%     -54.4%     274002 ± 7%  sched_debug.cpu#1.ttwu_count
     55669 ±23%     -43.1%      31676 ±19%  sched_debug.cfs_rq[8]:/.exec_clock
     58901 ±22%     -34.9%      38328 ±27%  sched_debug.cfs_rq[8]:/.min_vruntime
       693 ±24%    +122.2%       1541 ±49%  sched_debug.cfs_rq[21]:/.exec_clock
       388 ±37%    +141.9%        938 ±18%  sched_debug.cpu#10.curr->pid
     22104 ±48%     -50.4%      10965 ±22%  sched_debug.cfs_rq[25]:/.min_vruntime
     56292 ± 2%      -8.1%      51711 ± 6%  numa-meminfo.node1.Active
       122 ± 9%    +127.6%        277 ±22%  sched_debug.cpu#19.ttwu_local
       330 ± 8%     -52.9%        155 ±40%  sched_debug.cfs_rq[18]:/.tg_load_contrib
       305 ± 6%     -57.4%        130 ±48%  sched_debug.cpu#1.cpu_load[3]
        94 ±24%     +61.0%        151 ±14%  sched_debug.cpu#22.ttwu_local
       312 ±12%     -50.3%        155 ±40%  sched_debug.cfs_rq[18]:/.blocked_load_avg
   1092563 ±12%     -41.6%     637743 ±23%  sched_debug.cpu#0.sched_count
       186 ± 5%     +89.1%        351 ±30%  sched_debug.cpu#26.ttwu_local
       334 ± 7%     -57.4%        142 ±43%  sched_debug.cpu#1.cpu_load[4]
     13942 ± 8%     -28.0%      10036 ±24%  numa-meminfo.node1.Active(anon)
      8994 ±24%     -56.4%       3922 ± 4%  sched_debug.cpu#0.ttwu_local
      3845 ±11%     +21.9%       4688 ± 7%  sched_debug.cfs_rq[19]:/.min_vruntime
     53930 ±13%     -59.1%      22080 ±16%  sched_debug.cfs_rq[1]:/.exec_clock
     56331 ±27%     -45.3%      30809 ±30%  sched_debug.cfs_rq[9]:/.min_vruntime
       380 ± 8%     -64.1%        136 ±45%  sched_debug.cfs_rq[1]:/.tg_runnable_contrib
   1027661 ±11%     -40.8%     608510 ±26%  sched_debug.cpu#0.nr_switches
     17471 ± 8%     -64.1%       6277 ±45%  sched_debug.cfs_rq[1]:/.avg->runnable_avg_sum
      3486 ± 8%     -28.0%       2510 ±24%  numa-vmstat.node1.nr_active_anon
        72 ±27%     +94.0%        139 ± 8%  sched_debug.cpu#10.load
      1958 ± 9%     -25.1%       1466 ± 7%  sched_debug.cpu#3.ttwu_local
      4107 ±15%    +112.2%       8717 ±34%  sched_debug.cfs_rq[27]:/.min_vruntime
       157 ±40%     +77.0%        279 ±20%  sched_debug.cpu#29.ttwu_local
    542656 ± 5%     +45.1%     787416 ±11%  sched_debug.cpu#1.avg_idle
      3598 ± 5%     +59.2%       5728 ±19%  sched_debug.cfs_rq[21]:/.min_vruntime
    511646 ±11%     -41.0%     301664 ±26%  sched_debug.cpu#0.sched_goidle
      3398 ±14%     +73.2%       5886 ±13%  sched_debug.cfs_rq[31]:/.min_vruntime
       200 ± 4%     +34.7%        270 ±27%  sched_debug.cpu#18.ttwu_local
     59922 ±13%     -50.7%      29522 ±19%  sched_debug.cfs_rq[1]:/.min_vruntime
    993453 ± 0%     -11.1%     882755 ±10%  sched_debug.cpu#6.avg_idle
 1.757e+08 ±21%    +115.7%   3.79e+08 ±11%  cpuidle.C1-SNB.time
     60986 ± 9%     -42.8%      34903 ±27%  sched_debug.cpu#0.nr_load_updates
     39546 ± 2%     +15.5%      45657 ± 3%  softirqs.RCU
     55041 ±12%     -46.7%      29348 ±34%  sched_debug.cfs_rq[0]:/.exec_clock
     63888 ±14%     -44.6%      35422 ±25%  sched_debug.cfs_rq[0]:/.min_vruntime
     13748 ± 3%     -28.2%       9867 ±28%  numa-meminfo.node1.AnonPages
      3195 ± 3%     +55.3%       4960 ± 6%  cpuidle.C1E-SNB.usage
       341 ± 8%     +37.5%        469 ± 6%  slabinfo.kmem_cache.active_objs
       341 ± 8%     +37.5%        469 ± 6%  slabinfo.kmem_cache.num_objs
    996850 ± 0%     -16.5%     832771 ±10%  sched_debug.cpu#15.avg_idle
      3441 ± 4%     -28.3%       2469 ±28%  numa-vmstat.node1.nr_anon_pages
     83332 ± 8%     +20.7%     100608 ± 2%  sched_debug.cpu#2.nr_load_updates
    862076 ± 6%     -12.5%     754527 ± 7%  sched_debug.cpu#10.avg_idle
    319014 ± 1%     -13.3%     276514 ± 0%  cpuidle.C7-SNB.usage
     11.66 ± 8%     +28.0%      14.93 ± 6%  turbostat.%c1
       453 ± 7%     +35.0%        612 ± 9%  slabinfo.dnotify_mark.active_objs
       453 ± 7%     +35.0%        612 ± 9%  slabinfo.dnotify_mark.num_objs
       450 ± 6%     +23.7%        557 ± 0%  slabinfo.kmem_cache_node.active_objs
       469 ± 6%     +22.7%        576 ± 0%  slabinfo.kmem_cache_node.num_objs
       443 ± 6%     -14.8%        377 ± 6%  numa-vmstat.node1.nr_page_table_pages
    139086 ± 1%     +15.0%     160011 ± 1%  softirqs.SCHED
     11164 ± 2%     +15.2%      12864 ±10%  slabinfo.kmalloc-256.active_objs
      1772 ± 6%     -15.0%       1506 ± 6%  numa-meminfo.node1.PageTables
     11412 ± 1%     +16.0%      13237 ± 8%  slabinfo.kmalloc-256.num_objs
    989992 ± 1%     -14.4%     846954 ± 4%  sched_debug.cpu#14.avg_idle
    386658 ± 2%      +9.5%     423490 ± 1%  softirqs.TIMER
       418 ± 4%   +4948.2%      21101 ± 1%  time.involuntary_context_switches
      6.42 ± 0%      +1.9%       6.54 ± 0%  turbostat.%c0
     29456 ± 7%     +40.8%      41487 ± 5%  vmstat.system.cs
      8227 ±10%     +34.8%      11087 ± 3%  vmstat.system.in
      0.00 ± 1%      +4.4%       0.00 ± 0%  energy.energy-cores
     43.93 ± 1%      +4.4%      45.86 ± 0%  turbostat.Cor_W
     71.43 ± 0%      +2.7%      73.35 ± 0%  turbostat.Pkg_W
      0.00 ± 0%      +2.7%       0.00 ± 0%  energy.energy-pkg

testbox/testcase/testparams: lkp-a04/netperf/300s-200%-UDP_RR

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
     17781 ±22%     -39.7%      10718 ±28%  sched_debug.cpu#3.sched_goidle
       426 ± 6%      +8.4%        461 ± 4%  sched_debug.cpu#0.cpu_load[1]
       410 ± 8%     +11.6%        458 ± 3%  sched_debug.cpu#0.cpu_load[0]
     12459 ±25%     +26.1%      15711 ± 8%  sched_debug.cpu#1.sched_goidle
       565 ± 5%     +15.9%        655 ±10%  slabinfo.kmalloc-512.active_objs
     27181 ±14%     -37.6%      16948 ±43%  cpuidle.C4-ATM.time
     18120 ± 1%     -16.4%      15156 ± 1%  softirqs.SCHED
       882 ± 6%     +14.3%       1008 ± 0%  slabinfo.kmalloc-96.active_objs
       882 ± 6%     +14.3%       1008 ± 0%  slabinfo.kmalloc-96.num_objs
      0.99 ± 5%     -13.4%       0.86 ± 6%  perf-profile.cpu-cycles.ip_rcv.__netif_receive_skb_core.__netif_receive_skb.process_backlog.net_rx_action
      1.00 ± 4%      -7.3%       0.93 ± 2%  perf-profile.cpu-cycles.__skb_recv_datagram.udp_recvmsg.inet_recvmsg.sock_recvmsg.SYSC_recvfrom
      1.24 ± 1%     -10.5%       1.11 ± 4%  perf-profile.cpu-cycles.recv_omni.process_requests.spawn_child.accept_connection.accept_connections

testbox/testcase/testparams: lkp-snb01/hackbench/1600%-threads-pipe

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
         0           +Inf%          0 ±141%  last_state.is_incomplete_run
         0           +Inf%          0 ±141%  last_state.booting

testbox/testcase/testparams: lkp-snb01/hackbench/1600%-threads-socket

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
    144955 ± 0%      +3.5%     149992 ± 0%  hackbench.throughput
    469607 ±36%    +127.0%    1065815 ±37%  sched_debug.cfs_rq[6]:/.spread0
        43 ±27%    +138.5%        103 ±25%  sched_debug.cpu#30.nr_uninterruptible
        46 ±22%    +122.3%        103 ±24%  sched_debug.cpu#20.nr_uninterruptible
      8591 ±26%     +95.9%      16831 ±48%  numa-meminfo.node1.Shmem
   1350481 ±37%     +50.8%    2036091 ±16%  sched_debug.cpu#6.ttwu_local
   1369653 ±34%     +52.0%    2081643 ±18%  sched_debug.cpu#10.ttwu_local
   1591125 ±39%     +53.3%    2438849 ±18%  sched_debug.cpu#13.ttwu_count
        40 ±41%    +140.0%         96 ±39%  numa-vmstat.node0.nr_inactive_anon
        29 ±20%     +48.3%         44 ±26%  sched_debug.cfs_rq[12]:/.load
   1692456 ±41%     +61.6%    2735455 ±17%  sched_debug.cpu#6.sched_count
      2398 ±24%     +69.8%       4071 ±27%  sched_debug.cfs_rq[31]:/.tg_load_contrib
        13 ±46%    +241.5%         46 ±43%  sched_debug.cpu#5.nr_uninterruptible
   1633856 ±35%     +47.0%    2400982 ±19%  sched_debug.cpu#10.ttwu_count
   1412831 ±37%     +59.2%    2249726 ±17%  sched_debug.cpu#7.ttwu_count
   1639820 ±37%     +53.6%    2518680 ±17%  sched_debug.cpu#30.ttwu_count
      2284 ±26%     +95.8%       4471 ±23%  sched_debug.cfs_rq[30]:/.blocked_load_avg
   8517470 ±34%     +49.5%   12735720 ±20%  sched_debug.cfs_rq[14]:/.min_vruntime
        41 ±18%    +102.4%         83 ±34%  sched_debug.cpu#4.load
   7998814 ±37%     +51.5%   12121260 ±18%  sched_debug.cfs_rq[4]:/.min_vruntime
   9075023 ±34%     +42.9%   12971768 ±20%  sched_debug.cfs_rq[13]:/.min_vruntime
        49 ±14%     -36.9%         31 ±13%  sched_debug.cfs_rq[22]:/.load
        37 ±15%    +120.4%         83 ±34%  sched_debug.cfs_rq[4]:/.load
        49 ±14%     -35.8%         31 ±14%  sched_debug.cpu#22.load
   1770212 ±34%     +52.6%    2701111 ±15%  sched_debug.cpu#23.sched_count
   1740470 ±37%     +53.9%    2678976 ±20%  sched_debug.cpu#14.sched_count
        25 ±17%     +70.7%         42 ±23%  sched_debug.cpu#13.cpu_load[1]
      2318 ±19%     +51.0%       3500 ±22%  sched_debug.cfs_rq[24]:/.blocked_load_avg
        27 ± 6%     +34.1%         36 ±13%  sched_debug.cpu#11.cpu_load[4]
      1398 ±17%    +176.5%       3867 ±21%  sched_debug.cfs_rq[14]:/.tg_load_contrib
      2365 ±24%     +69.8%       4014 ±28%  sched_debug.cfs_rq[31]:/.blocked_load_avg
      2345 ±25%     +92.5%       4513 ±23%  sched_debug.cfs_rq[30]:/.tg_load_contrib
   1629777 ±35%     +61.5%    2631445 ±19%  sched_debug.cpu#29.ttwu_count
   1402021 ±37%     +61.0%    2256755 ±12%  sched_debug.cpu#24.ttwu_local
         1 ± 0%    +233.3%          3 ±37%  sched_debug.cfs_rq[13]:/.nr_spread_over
    344797 ±40%    +200.2%    1035150 ±36%  proc-vmstat.pgfault
   1875924 ±36%     +67.9%    3149828 ±17%  sched_debug.cpu#24.nr_switches
   1875929 ±36%     +67.9%    3149836 ±17%  sched_debug.cpu#24.sched_count
   1526264 ±37%     +51.3%    2308860 ±16%  sched_debug.cpu#6.ttwu_count
      4153 ±23%     -31.6%       2839 ±27%  sched_debug.cfs_rq[15]:/.tg_load_contrib
      2465 ±21%     +53.8%       3791 ±23%  sched_debug.cfs_rq[9]:/.blocked_load_avg
   2091990 ±34%     +48.7%    3110913 ±21%  sched_debug.cpu#29.sched_count
     27940 ±41%    +108.4%      58221 ±16%  sched_debug.cpu#23.sched_goidle
   7730782 ±34%     +54.0%   11906817 ±17%  sched_debug.cfs_rq[5]:/.min_vruntime
        21 ± 5%     +71.9%         36 ±21%  sched_debug.cpu#28.cpu_load[2]
        21 ± 7%     +63.1%         35 ±19%  sched_debug.cpu#28.cpu_load[3]
      2436 ±21%     +66.9%       4068 ±29%  sched_debug.cfs_rq[13]:/.tg_load_contrib
   1605358 ±37%     +63.4%    2623281 ±18%  sched_debug.cpu#5.sched_count
   1739895 ±37%     +53.7%    2675024 ±20%  sched_debug.cpu#14.nr_switches
   1696861 ±41%     +58.0%    2680333 ±14%  sched_debug.cpu#24.ttwu_count
   1935125 ±38%     +44.9%    2803150 ±20%  sched_debug.cpu#10.nr_switches
        22 ± 9%     +56.1%         34 ± 5%  sched_debug.cfs_rq[11]:/.runnable_load_avg
        21 ±13%     +56.3%         33 ±18%  sched_debug.cpu#28.cpu_load[4]
        66 ±45%     -54.0%         30 ±34%  sched_debug.cpu#6.nr_uninterruptible
   1421075 ±39%     +61.3%    2292004 ±17%  sched_debug.cpu#2.ttwu_count
   1675341 ±41%     +61.3%    2701696 ±16%  sched_debug.cpu#6.nr_switches
        21 ± 5%     +64.6%         35 ±20%  sched_debug.cpu#28.cpu_load[1]
   1589299 ±34%     +49.4%    2374588 ±19%  sched_debug.cpu#9.ttwu_count
        11 ±19%    +118.2%         24 ±20%  sched_debug.cfs_rq[25]:/.nr_spread_over
      2366 ±24%    +169.5%       6378 ±36%  proc-vmstat.nr_shmem
        28 ± 3%     +33.7%         38 ±10%  sched_debug.cpu#11.cpu_load[3]
      2348 ±19%     +50.6%       3537 ±21%  sched_debug.cfs_rq[24]:/.tg_load_contrib
        30 ±18%     +23.9%         38 ±13%  sched_debug.cpu#11.cpu_load[1]
        29 ± 8%     +29.2%         38 ±11%  sched_debug.cpu#11.cpu_load[2]
        33 ± 9%     -16.2%         27 ±11%  sched_debug.cfs_rq[7]:/.runnable_load_avg
        20 ±16%     +56.7%         31 ±10%  sched_debug.cpu#28.cpu_load[0]
        57 ±47%    +111.7%        120 ±10%  cpuidle.POLL.usage
   1164777 ± 9%     -18.9%     945177 ±15%  sched_debug.cpu#2.avg_idle
   1124134 ± 5%     -31.5%     769685 ±30%  sched_debug.cpu#3.avg_idle
   1722266 ±37%     +61.5%    2781561 ±17%  sched_debug.cpu#22.sched_count
        38 ±20%     +62.6%         62 ±38%  sched_debug.cpu#19.cpu_load[0]
   1765711 ±34%     +52.6%    2693739 ±15%  sched_debug.cpu#23.nr_switches
     18664 ± 3%     -14.0%      16047 ± 7%  sched_debug.cpu#17.curr->pid
        43 ±30%     -36.2%         27 ±11%  sched_debug.cpu#21.cpu_load[0]
        24 ± 8%     +27.4%         31 ± 5%  sched_debug.cfs_rq[10]:/.runnable_load_avg
      2885 ± 7%     +17.7%       3394 ± 7%  sched_debug.cfs_rq[29]:/.blocked_load_avg
      2914 ± 7%     +17.6%       3427 ± 7%  sched_debug.cfs_rq[29]:/.tg_load_contrib
   1939082 ±38%     +44.7%    2806802 ±20%  sched_debug.cpu#10.sched_count
   1601460 ±37%     +63.3%    2615545 ±18%  sched_debug.cpu#5.nr_switches
        27 ± 3%     +22.9%         34 ± 4%  sched_debug.cpu#5.cpu_load[0]
   7789960 ±35%     +53.1%   11926079 ±17%  sched_debug.cfs_rq[3]:/.min_vruntime
   2017783 ±38%     +45.5%    2934975 ±20%  sched_debug.cpu#31.sched_count
     14307 ±15%     +45.4%      20799 ± 3%  sched_debug.cpu#28.curr->pid
        18 ±27%     +67.9%         31 ± 9%  sched_debug.cfs_rq[28]:/.runnable_load_avg
        23 ±21%     +61.4%         37 ±27%  sched_debug.cpu#13.cpu_load[0]
        43 ±27%     -40.5%         26 ±16%  sched_debug.cfs_rq[21]:/.runnable_load_avg
        21 ±20%     +65.1%         34 ± 1%  sched_debug.cfs_rq[28]:/.load
        22 ±46%     +67.2%         37 ± 8%  sched_debug.cfs_rq[9]:/.load
   8190727 ±36%     +52.5%   12487628 ±19%  sched_debug.cfs_rq[19]:/.min_vruntime
   2015494 ±34%     +45.1%    2924514 ±21%  sched_debug.cpu#30.nr_switches
        20 ±18%    +154.1%         51 ±46%  sched_debug.cpu#28.load
   2015322 ±38%     +45.5%    2932466 ±20%  sched_debug.cpu#31.nr_switches
   7652403 ±34%     +59.9%   12239590 ±16%  sched_debug.cfs_rq[6]:/.min_vruntime
      2255 ±34%     +41.1%       3181 ±12%  sched_debug.cfs_rq[21]:/.blocked_load_avg
        15 ±18%     -55.6%          6 ±46%  sched_debug.cfs_rq[10]:/.nr_spread_over
        23 ±23%     -30.0%         16 ±11%  sched_debug.cpu#0.cpu_load[0]
     90586 ±21%    +133.3%     211300 ±18%  sched_debug.cpu#20.nr_load_updates
     46776 ±36%     +53.4%      71746 ±34%  sched_debug.cpu#11.sched_goidle
   8541800 ±32%     +54.3%   13181879 ±19%  sched_debug.cfs_rq[24]:/.min_vruntime
   2017977 ±34%     +45.1%    2927629 ±21%  sched_debug.cpu#30.sched_count
   8808565 ±34%     +44.7%   12746465 ±20%  sched_debug.cfs_rq[10]:/.min_vruntime
      1366 ±18%    +180.9%       3838 ±21%  sched_debug.cfs_rq[14]:/.blocked_load_avg
      2241 ±45%     -60.1%        895 ±16%  sched_debug.cfs_rq[1]:/.tg_load_contrib
        25 ±28%     +48.0%         37 ± 4%  sched_debug.cpu#15.cpu_load[3]
      2209 ±46%     -60.9%        863 ±16%  sched_debug.cfs_rq[1]:/.blocked_load_avg
        42 ± 2%     -28.1%         30 ± 4%  sched_debug.cpu#3.cpu_load[0]
   1597804 ±37%     +62.3%    2593330 ±17%  sched_debug.cpu#7.nr_switches
        25 ±32%     +40.3%         36 ± 4%  sched_debug.cpu#15.cpu_load[1]
     28687 ±44%    +120.7%      63303 ±20%  sched_debug.cpu#7.sched_goidle
        25 ±26%     +40.8%         35 ± 4%  sched_debug.cpu#15.cpu_load[4]
        24 ±30%     +51.4%         37 ± 2%  sched_debug.cpu#15.cpu_load[2]
   8082735 ±35%     +55.5%   12567911 ±16%  sched_debug.cfs_rq[22]:/.min_vruntime
   9052400 ±33%     +39.9%   12660242 ±19%  sched_debug.cfs_rq[11]:/.min_vruntime
      8894 ±16%    +146.7%      21946 ±34%  meminfo.Shmem
   1412482 ±33%     +60.2%    2262381 ±19%  sched_debug.cpu#29.ttwu_local
   2091479 ±34%     +48.7%    3110611 ±21%  sched_debug.cpu#29.nr_switches
      2403 ±22%     +67.5%       4024 ±29%  sched_debug.cfs_rq[13]:/.blocked_load_avg
   1603334 ±38%     +62.1%    2599754 ±17%  sched_debug.cpu#7.sched_count
   8734614 ±35%     +42.6%   12456632 ±21%  sched_debug.cfs_rq[26]:/.min_vruntime
   5482284 ±22%     -33.8%    3626939 ±17%  sched_debug.cpu#31.max_idle_balance_cost
        38 ±11%     -20.0%         30 ± 4%  sched_debug.cpu#3.cpu_load[3]
      2513 ±21%     +52.7%       3838 ±23%  sched_debug.cfs_rq[9]:/.tg_load_contrib
  58410910 ±12%     -30.0%   40912772 ±28%  cpuidle.C1E-SNB.time
   7962719 ±38%     +54.2%   12276900 ±16%  sched_debug.cfs_rq[21]:/.min_vruntime
     16966 ± 3%     +12.4%      19071 ± 6%  sched_debug.cpu#1.curr->pid
   8896468 ±34%     +45.4%   12938806 ±19%  sched_debug.cfs_rq[28]:/.min_vruntime
      4055 ±28%     -35.9%       2598 ± 7%  sched_debug.cfs_rq[22]:/.blocked_load_avg
   8798874 ±33%     +46.1%   12851935 ±19%  sched_debug.cfs_rq[31]:/.min_vruntime
   8162157 ±31%     +48.5%   12122503 ±20%  sched_debug.cfs_rq[23]:/.min_vruntime
   5167674 ±28%     -37.4%    3233547 ± 3%  sched_debug.cpu#24.max_idle_balance_cost
   8545579 ±32%     +47.5%   12602337 ±19%  sched_debug.cfs_rq[17]:/.min_vruntime
   1716393 ±38%     +62.0%    2780327 ±17%  sched_debug.cpu#22.nr_switches
      4096 ±28%     -34.9%       2668 ± 7%  sched_debug.cfs_rq[22]:/.tg_load_contrib
        38 ±13%     -40.4%         22 ±33%  sched_debug.cpu#17.cpu_load[0]
   6670497 ±32%     -39.0%    4071219 ±16%  sched_debug.cpu#25.max_idle_balance_cost
      0.46 ± 9%    +104.3%       0.95 ±18%  turbostat.%c7
   7671602 ±37%     +56.7%   12020919 ±16%  sched_debug.cfs_rq[1]:/.min_vruntime
     16699 ± 8%     +12.0%      18695 ± 6%  sched_debug.cpu#8.curr->pid
      3340 ± 9%     +69.6%       5665 ± 3%  cpuidle.C3-SNB.usage
      4119 ±23%     -32.2%       2794 ±27%  sched_debug.cfs_rq[15]:/.blocked_load_avg
 2.328e+08 ± 8%     -22.9%  1.796e+08 ± 6%  cpuidle.C1-SNB.time
    102235 ±10%     +40.9%     144065 ±15%  sched_debug.cpu#0.nr_load_updates
   3930107 ±49%     -52.5%    1866005 ±25%  sched_debug.cpu#22.avg_idle
        36 ±12%     -16.4%         30 ± 5%  sched_debug.cpu#3.cpu_load[4]
   7631893 ±29%     +61.4%   12317261 ±18%  sched_debug.cfs_rq[20]:/.min_vruntime
   7077210 ±34%     +55.2%   10981933 ±16%  sched_debug.cfs_rq[0]:/.min_vruntime
    130538 ±30%     +60.3%     209286 ±17%  sched_debug.cpu#11.nr_load_updates
   7732046 ±35%     +53.2%   11845661 ±18%  sched_debug.cfs_rq[2]:/.min_vruntime
   7742195 ±35%     +54.5%   11959035 ±17%  sched_debug.cfs_rq[7]:/.min_vruntime
        46 ±21%     -31.7%         31 ± 6%  sched_debug.cpu#3.cpu_load[1]
   1134823 ±12%     -33.2%     758329 ±22%  sched_debug.cpu#11.avg_idle
        13 ±16%     +41.0%         18 ±20%  sched_debug.cpu#28.nr_running
    770906 ±48%     +95.8%    1509648 ±29%  numa-numastat.node1.numa_hit
    769508 ±48%     +96.0%    1508250 ±29%  numa-numastat.node1.local_node
 3.254e+08 ± 3%     +35.0%  4.392e+08 ±10%  cpuidle.C7-SNB.time
   7873970 ±37%     +53.7%   12100093 ±18%  sched_debug.cfs_rq[18]:/.min_vruntime
      9908 ± 4%      -8.6%       9052 ± 2%  slabinfo.kmalloc-192.num_objs
        42 ±16%     -25.4%         31 ± 5%  sched_debug.cpu#3.cpu_load[2]
        25 ± 5%     -21.3%         19 ±11%  sched_debug.cpu#22.nr_running
        23 ±19%     +58.6%         37 ± 3%  sched_debug.cfs_rq[11]:/.load
        18 ±32%     +35.2%         24 ± 3%  sched_debug.cpu#12.nr_running
     33978 ±16%     -51.3%      16531 ± 8%  sched_debug.cfs_rq[0]:/.tg_load_avg
      9908 ± 4%      -8.6%       9052 ± 2%  slabinfo.kmalloc-192.active_objs
     17065 ±13%     +17.7%      20090 ± 2%  sched_debug.cpu#29.curr->pid
        24 ±41%     +47.2%         35 ±16%  sched_debug.cfs_rq[29]:/.load
      1509 ± 2%     +16.3%       1754 ±10%  proc-vmstat.nr_inactive_anon
    275899 ± 2%     +12.3%     309911 ± 1%  softirqs.SCHED
    331858 ± 6%     +14.1%     378649 ± 6%  numa-meminfo.node1.SUnreclaim
    365515 ± 5%     +13.8%     416065 ± 6%  numa-meminfo.node1.Slab
     58244 ±17%     -34.6%      38103 ± 1%  sched_debug.cfs_rq[1]:/.tg_load_avg
    101161 ± 2%      +7.2%     108412 ± 4%  sched_debug.cfs_rq[26]:/.tg_load_avg
    101605 ± 3%      +7.2%     108920 ± 3%  sched_debug.cfs_rq[29]:/.tg_load_avg
      0.93 ± 5%     +11.1%       1.04 ± 5%  perf-profile.cpu-cycles.__srcu_read_lock.fsnotify.vfs_write.sys_write.system_call_fastpath
    101319 ± 3%      +7.3%     108756 ± 4%  sched_debug.cfs_rq[28]:/.tg_load_avg
    102248 ± 2%      +6.5%     108895 ± 4%  sched_debug.cfs_rq[27]:/.tg_load_avg
      0.82 ± 4%     +14.2%       0.94 ± 4%  perf-profile.cpu-cycles.__kmalloc_node_track_caller.__kmalloc_reserve.__alloc_skb.sock_alloc_send_pskb.unix_stream_sendmsg
     13729 ± 3%     +10.6%      15183 ± 5%  proc-vmstat.nr_slab_reclaimable
     48264 ± 4%     +12.6%      54361 ± 6%  proc-vmstat.nr_active_anon
      1.07 ± 5%     +14.0%       1.22 ± 5%  perf-profile.cpu-cycles.kmem_cache_free.kfree_skbmem.consume_skb.unix_stream_recvmsg.sock_aio_read
      6025 ± 2%     +12.7%       6788 ± 6%  meminfo.Inactive(anon)
      1065 ± 9%     -11.3%        945 ± 0%  numa-meminfo.node1.Unevictable
      1065 ± 9%     -11.5%        942 ± 0%  numa-meminfo.node1.Mlocked
    138913 ± 5%      +7.5%     149308 ± 2%  proc-vmstat.nr_slab_unreclaimable
   1095284 ± 4%     -10.1%     984542 ± 1%  time.minor_page_faults

testbox/testcase/testparams: lkp-snb01/hackbench/50%-process-pipe

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
      -745 ±-5%     -19.6%       -598 ±-10%  sched_debug.cpu#27.nr_uninterruptible
       376 ± 4%   +1543.5%       6185 ±46%  numa-vmstat.node0.nr_shmem
      -586 ±-11%     -24.9%       -440 ±-20%  sched_debug.cpu#21.nr_uninterruptible
   2734514 ± 7%     -14.6%    2334144 ± 6%  sched_debug.cfs_rq[16]:/.spread0
      -383 ±-27%     +45.3%       -557 ±-10%  sched_debug.cpu#22.nr_uninterruptible
      1506 ± 4%   +1544.1%      24759 ±46%  numa-meminfo.node0.Shmem
      -727 ±-11%     -17.7%       -598 ±-7%  sched_debug.cpu#19.nr_uninterruptible
       707 ± 3%     -27.4%        513 ±14%  sched_debug.cpu#2.nr_uninterruptible
       222 ±17%     +67.2%        371 ± 2%  sched_debug.cpu#15.nr_uninterruptible
      -442 ±-9%     -19.7%       -355 ±-10%  sched_debug.cpu#25.nr_uninterruptible
        71 ±21%     +43.5%        102 ±22%  sched_debug.cfs_rq[14]:/.tg_load_contrib
        78 ±36%    +119.2%        171 ±22%  sched_debug.cfs_rq[30]:/.tg_load_contrib
        26 ± 6%     +16.2%         31 ± 6%  sched_debug.cfs_rq[19]:/.load
        33 ± 7%     -13.0%         29 ± 5%  sched_debug.cpu#5.load
       234 ±46%     -57.5%         99 ±26%  sched_debug.cfs_rq[19]:/.tg_load_contrib
        34 ± 5%     -16.3%         29 ±12%  sched_debug.cfs_rq[14]:/.load
        60 ±19%    +109.9%        126 ±18%  sched_debug.cfs_rq[7]:/.tg_load_contrib
        68 ±25%    +155.3%        175 ±26%  sched_debug.cfs_rq[20]:/.blocked_load_avg
        32 ± 5%     -12.5%         28 ± 5%  sched_debug.cfs_rq[5]:/.runnable_load_avg
        36 ±15%    +107.3%         75 ± 4%  sched_debug.cfs_rq[0]:/.blocked_load_avg
      2660 ± 6%     -64.0%        956 ± 3%  cpuidle.POLL.usage
     28999 ±28%     +44.7%      41951 ±15%  sched_debug.cpu#2.avg_idle
       317 ± 9%     +18.7%        376 ±10%  sched_debug.cpu#7.nr_uninterruptible
        29 ± 6%     -14.6%         25 ± 4%  sched_debug.cpu#21.cpu_load[0]
        28 ±45%    +236.0%         96 ±26%  sched_debug.cfs_rq[7]:/.blocked_load_avg
        32 ± 5%     -17.3%         27 ± 0%  sched_debug.cpu#5.cpu_load[0]
     62112 ± 3%     -28.2%      44609 ±27%  numa-meminfo.node1.Active(anon)
        32 ± 5%     -16.5%         27 ± 0%  sched_debug.cpu#5.cpu_load[1]
        30 ± 8%     -14.4%         25 ± 1%  sched_debug.cfs_rq[21]:/.runnable_load_avg
      8439 ± 0%     +28.9%      10875 ±14%  numa-vmstat.node1.numa_other
        29 ± 8%     -12.4%         26 ± 3%  sched_debug.cpu#21.cpu_load[1]
        97 ±16%    +111.6%        206 ±21%  sched_debug.cfs_rq[20]:/.tg_load_contrib
        27 ± 4%     +14.6%         31 ± 6%  sched_debug.cfs_rq[19]:/.runnable_load_avg
        30 ± 1%      -6.5%         28 ± 3%  sched_debug.cpu#25.cpu_load[3]
        32 ± 3%     -15.3%         27 ± 1%  sched_debug.cpu#5.cpu_load[2]
        29 ± 8%     -12.4%         26 ± 3%  sched_debug.cpu#21.cpu_load[2]
        30 ± 5%     -11.1%         26 ± 1%  sched_debug.cpu#21.cpu_load[4]
        30 ± 5%     -11.1%         26 ± 1%  sched_debug.cpu#21.cpu_load[3]
        71 ± 6%     +51.2%        107 ± 3%  sched_debug.cfs_rq[0]:/.tg_load_contrib
        29 ± 8%     -13.5%         25 ± 4%  sched_debug.cpu#21.load
     15527 ± 2%     -28.1%      11157 ±27%  numa-vmstat.node1.nr_active_anon
        39 ±38%     +82.2%         71 ±34%  sched_debug.cfs_rq[14]:/.blocked_load_avg
        32 ± 3%     -15.3%         27 ± 1%  sched_debug.cpu#5.cpu_load[3]
        32 ± 2%     -13.4%         28 ± 2%  sched_debug.cpu#5.cpu_load[4]
        36 ±13%     -17.3%         30 ± 4%  sched_debug.cpu#10.load
        24 ±12%     +24.3%         30 ± 8%  sched_debug.cfs_rq[20]:/.load
        66 ±11%     +93.5%        129 ±20%  sched_debug.cfs_rq[28]:/.blocked_load_avg
        24 ± 7%     +24.7%         30 ± 8%  sched_debug.cpu#20.load
     30668 ± 8%     +55.0%      47545 ±27%  numa-meminfo.node0.Active(anon)
        95 ± 8%     +66.6%        159 ±16%  sched_debug.cfs_rq[28]:/.tg_load_contrib
      7667 ± 8%     +55.0%      11885 ±27%  numa-vmstat.node0.nr_active_anon
     57027 ±24%     -35.3%      36872 ±19%  sched_debug.cpu#6.avg_idle
     41749 ±20%     +37.6%      57439 ±10%  sched_debug.cpu#13.avg_idle
     61077 ±19%     -43.3%      34602 ±12%  sched_debug.cpu#7.avg_idle
     56966 ± 8%     -24.7%      42880 ±19%  sched_debug.cpu#11.avg_idle
        24 ±10%     +17.6%         29 ± 7%  sched_debug.cfs_rq[31]:/.load
        25 ±11%     +17.1%         29 ± 6%  sched_debug.cpu#31.load
     62174 ±24%     -35.0%      40444 ±23%  sched_debug.cpu#19.avg_idle
     55229 ± 0%     -32.6%      37224 ±14%  sched_debug.cpu#16.avg_idle
         8 ± 5%     +28.0%         10 ±11%  sched_debug.cpu#20.nr_running
    211665 ± 0%     +12.1%     237174 ± 5%  numa-meminfo.node0.FilePages
     52916 ± 0%     +12.0%      59289 ± 5%  numa-vmstat.node0.nr_file_pages
     48377 ±11%     -37.3%      30344 ±20%  sched_debug.cpu#4.avg_idle
      3814 ± 3%      +7.1%       4086 ± 5%  sched_debug.cfs_rq[0]:/.tg_load_avg
        12 ± 3%     -18.4%         10 ±12%  sched_debug.cpu#14.nr_running
      6477 ± 6%     -16.3%       5419 ±11%  numa-vmstat.node1.nr_slab_reclaimable
     25905 ± 6%     -16.3%      21676 ±11%  numa-meminfo.node1.SReclaimable
     17880 ± 9%     +24.3%      22230 ±10%  numa-meminfo.node0.SReclaimable
      4469 ± 9%     +24.3%       5557 ±10%  numa-vmstat.node0.nr_slab_reclaimable
      1.11 ± 2%     -14.1%       0.95 ± 3%  perf-profile.cpu-cycles.selinux_file_permission.security_file_permission.rw_verify_area.vfs_write.sys_write
      8769 ± 4%     +11.2%       9751 ± 1%  numa-vmstat.node0.nr_slab_unreclaimable
        12 ± 6%     -13.9%         10 ± 4%  sched_debug.cpu#5.nr_running
     97815 ± 3%      -8.4%      89618 ± 3%  numa-meminfo.node1.Slab
     52957 ± 5%     +15.7%      61254 ± 3%  numa-meminfo.node0.Slab
        31 ± 3%      -8.5%         28 ± 3%  sched_debug.cpu#25.cpu_load[4]
    252921 ± 0%     -10.1%     227367 ± 5%  numa-meminfo.node1.FilePages
     63234 ± 0%     -10.1%      56843 ± 5%  numa-vmstat.node1.nr_file_pages
     35077 ± 4%     +11.2%      39023 ± 1%  numa-meminfo.node0.SUnreclaim
   5759109 ± 0%      -1.5%    5672917 ± 0%  vmstat.system.cs
    865590 ± 0%      -1.2%     855126 ± 0%  vmstat.system.in
      1254 ± 0%      -1.3%       1238 ± 0%  time.user_time

testbox/testcase/testparams: lkp-snb01/hackbench/50%-process-socket

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
 813898.55 ±45%    -100.0%       0.00 ± 0%  sched_debug.cfs_rq[25]:/.MIN_vruntime
 813898.55 ±45%    -100.0%       0.00 ± 0%  sched_debug.cfs_rq[25]:/.max_vruntime
   2841487 ± 3%     +14.1%    3241106 ± 3%  sched_debug.cfs_rq[13]:/.spread0
   2533569 ± 4%     +17.2%    2968494 ± 9%  sched_debug.cfs_rq[10]:/.spread0
   2047785 ± 9%     +20.0%    2456470 ± 9%  sched_debug.cfs_rq[8]:/.spread0
     13370 ± 6%      -7.8%      12327 ± 5%  sched_debug.cpu#27.curr->pid
    468040 ±45%     +92.8%     902473 ±33%  sched_debug.cfs_rq[17]:/.MIN_vruntime
    468040 ±45%     +92.8%     902473 ±33%  sched_debug.cfs_rq[17]:/.max_vruntime
        26 ± 0%     +10.3%         28 ± 1%  sched_debug.cpu#26.cpu_load[4]
       104 ±14%     -31.5%         71 ± 9%  sched_debug.cfs_rq[12]:/.tg_load_contrib
        74 ±18%     -40.4%         44 ±17%  sched_debug.cfs_rq[12]:/.blocked_load_avg
        26 ± 0%     +10.3%         28 ± 1%  sched_debug.cpu#26.cpu_load[3]
        31 ± 7%     +12.9%         35 ± 4%  sched_debug.cfs_rq[5]:/.load
        32 ± 3%     -12.4%         28 ± 5%  sched_debug.cfs_rq[14]:/.runnable_load_avg
        29 ± 4%     +14.9%         33 ± 5%  sched_debug.cfs_rq[4]:/.runnable_load_avg
      4208 ± 0%     -99.8%          7 ±34%  numa-numastat.node0.other_node
        47 ±26%     +99.3%         93 ±27%  sched_debug.cfs_rq[9]:/.blocked_load_avg
       126 ± 9%     -32.2%         85 ±19%  sched_debug.cfs_rq[4]:/.tg_load_contrib
        25 ± 0%     +14.7%         28 ± 7%  sched_debug.cpu#26.cpu_load[0]
       176 ±21%     -68.2%         56 ±47%  sched_debug.cfs_rq[20]:/.blocked_load_avg
    110715 ± 6%     -29.6%      77907 ± 0%  numa-meminfo.node1.Active
      2546 ± 1%     -46.8%       1355 ± 4%  cpuidle.POLL.usage
        99 ± 9%     -35.4%         64 ±25%  sched_debug.cfs_rq[3]:/.tg_load_contrib
     69536 ± 9%     -48.0%      36187 ± 2%  numa-meminfo.node1.Active(anon)
     13151 ± 5%      -8.4%      12052 ± 4%  sched_debug.cpu#28.curr->pid
        30 ± 2%      -8.9%         27 ± 1%  sched_debug.cpu#13.cpu_load[0]
        24 ± 9%     +17.6%         29 ± 4%  sched_debug.cfs_rq[21]:/.runnable_load_avg
        27 ±14%     -17.1%         22 ±13%  sched_debug.cfs_rq[28]:/.load
      8305 ± 0%     +43.7%      11938 ± 2%  numa-vmstat.node1.numa_other
        24 ± 7%     +12.3%         27 ± 3%  sched_debug.cpu#21.cpu_load[1]
        26 ±12%     -15.0%         22 ±13%  sched_debug.cpu#28.load
       210 ±16%     -60.6%         83 ±32%  sched_debug.cfs_rq[20]:/.tg_load_contrib
     13282 ± 1%     -10.5%      11888 ± 1%  sched_debug.cpu#26.curr->pid
        24 ±13%     +19.2%         29 ± 4%  sched_debug.cfs_rq[21]:/.load
        24 ± 5%     +13.7%         27 ± 4%  sched_debug.cpu#21.cpu_load[2]
        25 ± 3%     +13.3%         28 ± 4%  sched_debug.cpu#21.cpu_load[4]
        24 ± 3%     +13.5%         28 ± 2%  sched_debug.cpu#21.cpu_load[3]
        24 ±15%     +19.2%         29 ± 4%  sched_debug.cpu#21.load
     17376 ± 9%     -48.0%       9038 ± 2%  numa-vmstat.node1.nr_active_anon
        34 ±17%     -22.5%         26 ± 6%  sched_debug.cfs_rq[20]:/.runnable_load_avg
        34 ±22%     -26.5%         25 ±11%  sched_debug.cfs_rq[20]:/.load
        29 ± 3%     -15.9%         24 ±13%  sched_debug.cpu#20.load
     24649 ±26%    +134.5%      57798 ± 1%  numa-meminfo.node0.Active(anon)
        28 ± 3%     -12.8%         25 ± 6%  sched_debug.cpu#20.cpu_load[2]
        77 ±16%     +60.8%        124 ±20%  sched_debug.cfs_rq[9]:/.tg_load_contrib
      6158 ±26%    +134.7%      14451 ± 1%  numa-vmstat.node0.nr_active_anon
        97 ±13%     -46.7%         51 ±29%  sched_debug.cfs_rq[4]:/.blocked_load_avg
     67282 ±10%     +47.8%      99432 ± 1%  numa-meminfo.node0.Active
        31 ± 6%     +12.8%         35 ± 3%  sched_debug.cpu#3.load
     32887 ±31%     +45.2%      47767 ± 6%  sched_debug.cpu#5.avg_idle
     40530 ±17%     +44.0%      58353 ±13%  sched_debug.cpu#21.avg_idle
     49686 ±22%     -35.8%      31895 ±10%  sched_debug.cpu#22.avg_idle
        30 ± 3%      -9.8%         27 ± 3%  sched_debug.cfs_rq[8]:/.runnable_load_avg
     35312 ± 7%     +36.8%      48309 ±13%  sched_debug.cpu#18.avg_idle
     39897 ± 7%     -25.4%      29761 ± 5%  sched_debug.cpu#8.avg_idle
     40180 ± 5%     +19.0%      47800 ± 3%  sched_debug.cpu#16.avg_idle
    216166 ± 1%     +16.7%     252197 ± 1%  numa-meminfo.node0.FilePages
     54041 ± 1%     +16.7%      63050 ± 1%  numa-vmstat.node0.nr_file_pages
        11 ± 7%     -21.2%          8 ±14%  sched_debug.cpu#14.nr_running
     37603 ±22%     +25.8%      47317 ± 7%  sched_debug.cpu#20.avg_idle
        31 ± 7%     -13.8%         27 ± 8%  sched_debug.cpu#23.load
    293929 ± 4%      +6.2%     312221 ± 2%  softirqs.SCHED
       741 ± 8%     -14.0%        637 ± 7%  slabinfo.buffer_head.active_objs
       741 ± 8%     -14.0%        637 ± 7%  slabinfo.buffer_head.num_objs
        31 ±10%     -12.9%         27 ± 8%  sched_debug.cfs_rq[23]:/.load
    249967 ± 1%     -14.5%     213710 ± 1%  numa-meminfo.node1.FilePages
     62493 ± 1%     -14.5%      53427 ± 1%  numa-vmstat.node1.nr_file_pages
   3231743 ± 0%      +1.0%    3264953 ± 0%  vmstat.system.cs
    559279 ± 0%      +1.2%     566102 ± 0%  vmstat.system.in

testbox/testcase/testparams: lkp-snb01/hackbench/50%-threads-pipe

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
      -231 ±-42%     +66.1%       -383 ± 0%  sched_debug.cpu#29.nr_uninterruptible
    352987 ±34%     -62.6%     132004 ±49%  sched_debug.cfs_rq[1]:/.spread0
   2000694 ±10%     -14.8%    1703642 ± 6%  sched_debug.cfs_rq[20]:/.spread0
   2669321 ± 7%     -25.5%    1987489 ± 9%  sched_debug.cfs_rq[26]:/.spread0
   2218008 ± 5%     -11.1%    1972491 ± 8%  sched_debug.cfs_rq[27]:/.spread0
    429280 ±32%     +76.9%     759410 ±10%  sched_debug.cfs_rq[7]:/.spread0
   2416889 ± 2%     -12.2%    2121635 ± 5%  sched_debug.cfs_rq[28]:/.spread0
      -388 ±-20%     -32.8%       -261 ±-3%  sched_debug.cpu#30.nr_uninterruptible
       353 ± 2%     +13.4%        400 ± 6%  sched_debug.cpu#9.nr_uninterruptible
      -264 ±-11%     -20.7%       -209 ±-4%  sched_debug.cpu#31.nr_uninterruptible
    795535 ±27%     -38.8%     486872 ±18%  sched_debug.cfs_rq[9]:/.spread0
       143 ±20%     +24.0%        177 ± 8%  sched_debug.cpu#15.nr_uninterruptible
       197 ±22%     -40.4%        117 ±34%  sched_debug.cfs_rq[19]:/.blocked_load_avg
    888413 ±18%     -52.4%     422792 ± 4%  sched_debug.cfs_rq[8]:/.spread0
      -317 ±-14%     -33.3%       -211 ±-47%  sched_debug.cpu#25.nr_uninterruptible
       157 ±29%     +63.7%        257 ±29%  sched_debug.cfs_rq[27]:/.blocked_load_avg
        96 ±28%     -34.3%         63 ±24%  sched_debug.cfs_rq[12]:/.tg_load_contrib
        87 ±19%     -54.6%         39 ±16%  sched_debug.cfs_rq[24]:/.blocked_load_avg
       411 ±41%     -80.0%         82 ±48%  sched_debug.cfs_rq[25]:/.blocked_load_avg
       106 ±13%     -38.1%         65 ±30%  sched_debug.cfs_rq[30]:/.tg_load_contrib
        26 ± 6%     +17.5%         31 ± 3%  sched_debug.cpu#25.cpu_load[1]
        31 ± 6%     -10.5%         28 ± 6%  sched_debug.cfs_rq[27]:/.runnable_load_avg
        31 ± 5%     -14.0%         26 ± 9%  sched_debug.cfs_rq[27]:/.load
       439 ±39%     -74.2%        113 ±36%  sched_debug.cfs_rq[25]:/.tg_load_contrib
       227 ±17%     -34.5%        148 ±27%  sched_debug.cfs_rq[19]:/.tg_load_contrib
   1056797 ± 4%     +13.7%    1201745 ± 6%  sched_debug.cpu#21.sched_goidle
       189 ±23%     +50.8%        286 ±26%  sched_debug.cfs_rq[27]:/.tg_load_contrib
        31 ± 3%     -14.9%         26 ± 9%  sched_debug.cpu#27.load
   1130048 ± 3%     +10.5%    1248905 ± 2%  sched_debug.cpu#24.sched_goidle
    902294 ± 2%     +11.2%    1003068 ± 5%  sched_debug.cpu#14.sched_goidle
       116 ±13%     -41.0%         68 ± 9%  sched_debug.cfs_rq[24]:/.tg_load_contrib
        27 ± 3%     +12.0%         31 ± 4%  sched_debug.cpu#25.cpu_load[2]
      1783 ± 3%     -68.9%        555 ± 3%  cpuidle.POLL.usage
     78441 ±32%     -40.5%      46653 ±15%  sched_debug.cpu#3.avg_idle
    765606 ± 7%     +11.7%     855212 ± 4%  sched_debug.cpu#8.sched_goidle
        31 ± 9%     -13.7%         27 ± 7%  sched_debug.cpu#17.load
    555616 ± 7%     +14.5%     636021 ± 8%  cpuidle.C3-SNB.time
    877042 ± 5%     +17.4%    1029798 ± 2%  sched_debug.cpu#13.sched_goidle
     47197 ± 2%     -27.6%      34170 ±37%  numa-meminfo.node1.Active(anon)
        25 ± 3%     +34.7%         33 ±10%  sched_debug.cfs_rq[25]:/.load
        26 ± 6%     +20.0%         32 ± 2%  sched_debug.cpu#25.cpu_load[0]
        26 ± 6%     +16.2%         31 ± 6%  sched_debug.cfs_rq[25]:/.runnable_load_avg
        30 ± 4%     -13.2%         26 ± 3%  sched_debug.cfs_rq[21]:/.load
        28 ± 5%      +9.5%         30 ± 4%  sched_debug.cpu#25.cpu_load[3]
        64 ±27%    +104.2%        130 ±18%  sched_debug.cfs_rq[0]:/.tg_load_contrib
   1137850 ± 3%     +16.6%    1326788 ± 5%  sched_debug.cpu#31.sched_goidle
        30 ± 3%     -14.1%         26 ± 1%  sched_debug.cpu#21.load
     11804 ± 2%     -27.6%       8548 ±37%  numa-vmstat.node1.nr_active_anon
    844857 ± 4%     +11.3%     940540 ± 2%  sched_debug.cpu#11.sched_goidle
   1181283 ± 3%     +10.3%    1302776 ± 4%  sched_debug.cpu#30.sched_goidle
     56347 ±23%     -32.8%      37850 ±16%  sched_debug.cpu#1.avg_idle
     21182 ± 5%     +59.6%      33804 ±37%  numa-meminfo.node0.Active(anon)
        31 ± 5%      -7.5%         28 ± 3%  sched_debug.cpu#20.cpu_load[2]
     79877 ± 7%     +13.7%      90800 ± 3%  meminfo.DirectMap4k
      5294 ± 5%     +59.7%       8452 ±37%  numa-vmstat.node0.nr_active_anon
     69161 ±25%     -28.5%      49469 ±26%  sched_debug.cpu#28.avg_idle
     70975 ± 9%     -44.3%      39542 ±25%  sched_debug.cpu#6.avg_idle
     81808 ±18%     -20.6%      64989 ±23%  sched_debug.cpu#21.avg_idle
     71797 ±13%     -15.9%      60409 ±11%  sched_debug.cpu#22.avg_idle
     74546 ±19%     -32.3%      50439 ±21%  sched_debug.cpu#17.avg_idle
     16769 ± 4%     -15.6%      14155 ±13%  numa-meminfo.node1.AnonPages
     93643 ±19%     -47.8%      48884 ±11%  sched_debug.cpu#8.avg_idle
        31 ± 9%     -15.8%         26 ± 4%  sched_debug.cfs_rq[31]:/.load
        31 ±10%     -17.0%         26 ± 5%  sched_debug.cpu#31.load
   1184850 ± 2%     +10.1%    1304822 ± 1%  sched_debug.cpu#29.sched_goidle
  19014825 ± 4%     +12.5%   21391786 ± 4%  cpuidle.C7-SNB.time
         8 ± 5%     +38.5%         12 ±13%  sched_debug.cpu#25.nr_running
     65471 ±10%     -33.0%      43881 ±13%  sched_debug.cpu#15.avg_idle
      4192 ± 4%     -15.7%       3534 ±13%  numa-vmstat.node1.nr_anon_pages
        32 ± 6%     -14.6%         27 ± 6%  sched_debug.cpu#29.load
      4066 ± 6%     -13.9%       3502 ± 8%  sched_debug.cfs_rq[0]:/.tg_load_avg
     84719 ± 6%     -36.5%      53778 ±32%  sched_debug.cpu#20.avg_idle
        27 ± 1%      -9.6%         25 ± 3%  sched_debug.cfs_rq[30]:/.load
        32 ± 6%     -17.7%         26 ± 7%  sched_debug.cfs_rq[29]:/.load
    225864 ± 0%     +15.1%     259863 ± 1%  softirqs.SCHED
        11 ± 4%     -17.6%          9 ± 5%  sched_debug.cpu#21.nr_running
        11 ± 8%     -20.0%          9 ± 5%  sched_debug.cpu#29.nr_running
      3817 ± 8%     -13.6%       3298 ± 2%  sched_debug.cfs_rq[24]:/.tg_load_avg
      3864 ± 9%     -10.6%       3455 ± 5%  sched_debug.cfs_rq[15]:/.tg_load_avg
      3845 ± 9%     -12.8%       3353 ± 3%  sched_debug.cfs_rq[19]:/.tg_load_avg
      3800 ± 7%     -13.6%       3284 ± 1%  sched_debug.cfs_rq[25]:/.tg_load_avg
      3830 ± 9%     -13.1%       3329 ± 2%  sched_debug.cfs_rq[20]:/.tg_load_avg
      3819 ± 8%     -12.8%       3330 ± 2%  sched_debug.cfs_rq[21]:/.tg_load_avg
      3829 ± 9%     -11.7%       3382 ± 4%  sched_debug.cfs_rq[18]:/.tg_load_avg
      3816 ± 8%     -10.2%       3428 ± 8%  sched_debug.cfs_rq[9]:/.tg_load_avg
      3806 ± 8%     -13.1%       3307 ± 2%  sched_debug.cfs_rq[23]:/.tg_load_avg
      3852 ± 8%     -11.3%       3417 ± 7%  sched_debug.cfs_rq[12]:/.tg_load_avg
      3783 ± 9%     -14.2%       3247 ± 2%  sched_debug.cfs_rq[30]:/.tg_load_avg
      3790 ± 9%     -14.6%       3238 ± 2%  sched_debug.cfs_rq[31]:/.tg_load_avg
      3893 ± 5%     -12.0%       3426 ± 9%  sched_debug.cfs_rq[8]:/.tg_load_avg
      3813 ± 8%     -12.7%       3330 ± 2%  sched_debug.cfs_rq[22]:/.tg_load_avg
      3992 ± 5%     -13.7%       3446 ± 9%  sched_debug.cfs_rq[1]:/.tg_load_avg
      3787 ± 9%     -13.9%       3259 ± 1%  sched_debug.cfs_rq[26]:/.tg_load_avg
      1233 ± 1%      +9.6%       1351 ± 2%  uptime.idle
      3822 ± 8%     -10.1%       3436 ± 7%  sched_debug.cfs_rq[11]:/.tg_load_avg
      5103 ± 3%     +11.2%       5673 ± 8%  numa-vmstat.node0.nr_anon_pages
      3830 ± 8%      -9.8%       3453 ± 7%  sched_debug.cfs_rq[10]:/.tg_load_avg
      3790 ± 8%     -14.1%       3258 ± 2%  sched_debug.cfs_rq[29]:/.tg_load_avg
      3800 ± 8%     -14.1%       3263 ± 2%  sched_debug.cfs_rq[28]:/.tg_load_avg
      3873 ± 8%     -10.7%       3457 ± 7%  sched_debug.cfs_rq[13]:/.tg_load_avg
      3880 ± 8%     -10.0%       3493 ± 6%  sched_debug.cfs_rq[14]:/.tg_load_avg
      1.76 ± 3%      -9.1%       1.60 ± 2%  perf-profile.cpu-cycles.__schedule.schedule.pipe_wait.pipe_read.do_sync_read
      1.33 ± 9%     -14.8%       1.13 ± 2%  perf-profile.cpu-cycles.avc_has_perm.inode_has_perm.file_has_perm.selinux_file_permission.security_file_permission
        28 ± 7%     -12.9%         24 ± 5%  sched_debug.cpu#30.load
      3914 ± 5%     -11.9%       3448 ± 9%  sched_debug.cfs_rq[6]:/.tg_load_avg
      3908 ± 5%     -11.6%       3455 ± 9%  sched_debug.cfs_rq[7]:/.tg_load_avg
     20420 ± 3%     +11.1%      22683 ± 8%  numa-meminfo.node0.AnonPages
        10 ± 4%     -16.1%          8 ± 5%  sched_debug.cpu#30.nr_running
 1.062e+09 ± 0%      -2.9%  1.031e+09 ± 0%  time.involuntary_context_switches
 2.994e+09 ± 0%      -1.4%  2.951e+09 ± 0%  time.voluntary_context_switches
   6679284 ± 0%      -2.0%    6547702 ± 0%  vmstat.system.cs
    986879 ± 0%      -1.2%     975385 ± 0%  vmstat.system.in
       828 ± 0%      -1.6%        815 ± 0%  time.user_time

testbox/testcase/testparams: lkp-snb01/hackbench/50%-threads-socket

71a9b26963f8c2d  5057f55e543b7859cfd26bc28
---------------  -------------------------
   1170822 ± 5%     +17.2%    1371820 ± 7%  sched_debug.cfs_rq[3]:/.spread0
    819914 ±12%     +19.2%     977633 ± 6%  sched_debug.cfs_rq[2]:/.spread0
        28 ± 2%      -9.5%         25 ± 1%  sched_debug.cpu#16.cpu_load[2]
       122 ±12%     -32.8%         82 ±14%  sched_debug.cfs_rq[11]:/.tg_load_contrib
       118 ±36%    +332.2%        510 ±41%  sched_debug.cfs_rq[1]:/.nr_spread_over
        65 ±16%     +43.1%         93 ± 9%  sched_debug.cfs_rq[15]:/.tg_load_contrib
        33 ± 5%     -16.8%         28 ± 8%  sched_debug.cfs_rq[3]:/.runnable_load_avg
        80 ±18%     -32.6%         54 ±32%  sched_debug.cfs_rq[7]:/.tg_load_contrib
        37 ± 5%     -17.7%         31 ± 5%  sched_debug.cfs_rq[2]:/.load
        28 ± 3%     -11.8%         25 ± 3%  sched_debug.cpu#16.cpu_load[1]
        28 ± 1%     -12.9%         24 ± 3%  sched_debug.cpu#16.cpu_load[0]
        70 ±34%     +67.1%        117 ±17%  sched_debug.cfs_rq[24]:/.tg_load_contrib
        26 ± 7%     +34.2%         35 ± 3%  sched_debug.cfs_rq[15]:/.load
        26 ± 7%     +33.7%         35 ± 5%  sched_debug.cpu#15.load
       616 ± 3%      +9.3%        674 ± 7%  numa-vmstat.node0.nr_kernel_stack
        26 ± 4%     +15.2%         30 ± 8%  sched_debug.cpu#10.cpu_load[1]
      2259 ± 2%     -47.9%       1178 ± 3%  cpuidle.POLL.usage
        27 ± 4%      -8.4%         25 ± 1%  sched_debug.cpu#19.cpu_load[0]
        83 ±29%     +46.2%        121 ±23%  sched_debug.cfs_rq[29]:/.blocked_load_avg
       110 ±23%     +36.0%        150 ±22%  sched_debug.cfs_rq[29]:/.tg_load_contrib
        29 ± 1%     +10.2%         32 ± 2%  sched_debug.cpu#15.cpu_load[0]
        24 ± 8%     +15.1%         28 ± 5%  sched_debug.cfs_rq[28]:/.runnable_load_avg
        26 ±12%     +22.8%         32 ± 5%  sched_debug.cfs_rq[10]:/.load
        27 ± 1%     +13.4%         31 ± 7%  sched_debug.cpu#10.cpu_load[3]
        37 ± 6%     -17.7%         31 ± 5%  sched_debug.cpu#2.load
        27 ± 3%     +10.8%         30 ± 8%  sched_debug.cpu#10.cpu_load[4]
        25 ± 1%     +11.8%         28 ± 7%  sched_debug.cfs_rq[25]:/.runnable_load_avg
        28 ± 1%     +16.3%         33 ± 1%  sched_debug.cfs_rq[15]:/.runnable_load_avg
        27 ± 3%      -7.3%         25 ± 1%  sched_debug.cfs_rq[19]:/.runnable_load_avg
        35 ± 1%     -10.3%         32 ± 0%  sched_debug.cpu#1.cpu_load[0]
        65 ±16%     +64.8%        107 ±18%  sched_debug.cfs_rq[1]:/.tg_load_contrib
        29 ± 2%     +14.9%         33 ± 7%  sched_debug.cpu#15.cpu_load[3]
        29 ±37%    +158.6%         75 ±26%  sched_debug.cfs_rq[1]:/.blocked_load_avg
        29 ± 4%     +11.4%         32 ± 3%  sched_debug.cpu#15.cpu_load[1]
        28 ± 1%     +16.3%         33 ± 7%  sched_debug.cpu#15.cpu_load[4]
        32 ± 3%     -19.4%         26 ± 7%  sched_debug.cpu#11.load
        35 ± 2%      -9.4%         32 ± 0%  sched_debug.cfs_rq[1]:/.runnable_load_avg
        26 ±12%     +20.3%         31 ± 3%  sched_debug.cpu#10.load
       317 ±34%     -45.6%        172 ±43%  sched_debug.cfs_rq[17]:/.tg_load_contrib
        29 ± 4%     +12.5%         33 ± 4%  sched_debug.cpu#15.cpu_load[2]
        74 ±20%     -46.9%         39 ±24%  sched_debug.cfs_rq[8]:/.blocked_load_avg
       107 ±13%     -35.6%         69 ±16%  sched_debug.cfs_rq[8]:/.tg_load_contrib
        89 ±16%     -40.5%         53 ±25%  sched_debug.cfs_rq[11]:/.blocked_load_avg
     67243 ±10%     -40.5%      39981 ±13%  sched_debug.cpu#28.avg_idle
     53609 ±22%     -33.5%      35652 ±17%  sched_debug.cpu#12.avg_idle
       695 ± 2%      -8.1%        638 ± 7%  numa-vmstat.node1.nr_kernel_stack
     45204 ±15%     -35.6%      29093 ±13%  sched_debug.cpu#5.avg_idle
        35 ±31%     +67.9%         59 ±15%  sched_debug.cfs_rq[15]:/.blocked_load_avg
      5559 ± 3%      -7.9%       5118 ± 7%  numa-meminfo.node1.KernelStack
     64428 ±12%     -38.1%      39863 ± 9%  sched_debug.cpu#18.avg_idle
        43 ±22%     -30.2%         30 ± 9%  sched_debug.cfs_rq[3]:/.load
        33 ± 6%     -11.1%         29 ± 4%  sched_debug.cpu#3.cpu_load[1]
         8 ±10%     +38.5%         12 ± 6%  sched_debug.cpu#15.nr_running
     62466 ±19%     -34.7%      40779 ± 8%  sched_debug.cpu#19.avg_idle
     56228 ±15%     -24.7%      42343 ± 7%  sched_debug.cpu#16.avg_idle
         8 ± 0%     +29.2%         10 ± 9%  sched_debug.cpu#10.nr_running
     54061 ±16%     -34.5%      35393 ±22%  sched_debug.cpu#15.avg_idle
     39436 ±22%     -27.7%      28510 ±17%  sched_debug.cpu#10.avg_idle
        32 ± 3%     -17.5%         26 ± 9%  sched_debug.cfs_rq[11]:/.load
        24 ± 5%     +15.1%         28 ± 7%  sched_debug.cpu#31.cpu_load[1]
    274999 ± 0%     +11.6%     306774 ± 0%  softirqs.SCHED
        24 ± 3%     +17.6%         29 ± 5%  sched_debug.cpu#31.cpu_load[2]
        24 ± 3%     +17.6%         29 ± 5%  sched_debug.cpu#31.cpu_load[3]
        25 ± 4%     +13.2%         28 ± 6%  sched_debug.cfs_rq[31]:/.runnable_load_avg
      4050 ± 9%     -10.0%       3646 ± 3%  sched_debug.cfs_rq[1]:/.tg_load_avg
      3914 ± 8%     -10.6%       3499 ± 5%  sched_debug.cfs_rq[13]:/.tg_load_avg
      3915 ± 8%     -10.7%       3494 ± 4%  sched_debug.cfs_rq[14]:/.tg_load_avg
        29 ± 8%     -13.6%         25 ± 1%  sched_debug.cpu#30.load
        25 ± 1%     +17.1%         29 ± 5%  sched_debug.cpu#31.cpu_load[4]
      4064 ± 8%     -12.2%       3569 ± 5%  sched_debug.cfs_rq[4]:/.tg_load_avg
      4937 ± 3%      +9.2%       5392 ± 6%  numa-meminfo.node0.KernelStack
    692520 ± 0%      +0.9%     698981 ± 0%  vmstat.system.in
       680 ± 0%      -1.6%        669 ± 0%  time.user_time

The testbox configurations are:

brickland1: Brickland Ivy Bridge-EX
Memory: 128G

lkp-sb03: Sandy Bridge-EP
Memory: 64G

lkp-snb01: Sandy Bridge-EP
Memory: 32G

lkp-nex04: Nehalem-EX
Memory: 256G

lkp-a06: Atom
Memory: 8G

xps: Nehalem
Memory: 4G

lkp-a04: Atom
Memory: 8G

xps2: Nehalem
Memory: 4G

lkp-a05: Atom
Memory: 8G


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
Fengguang

--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: will-it-scale
default_monitors:
  watch-oom: 
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
  energy: 
  cpuidle: 
  cpufreq: 
  turbostat: 
  sched_debug:
    interval: 10
  pmeter: 
model: Sandy Bridge-EP
memory: 32G
hdd_partitions: "/dev/sda2"
swap_partitions: 
perf-profile:
  freq: 800
will-it-scale:
  test:
  - open2
branch: linus/master
commit: 19583ca584d6f574384e17fe7613dfaeadcdc4a6
repeat_to: 3
enqueue_time: 2014-09-25 21:49:55.795426801 +08:00
testbox: lkp-snb01
kconfig: x86_64-rhel
kernel: "/kernel/x86_64-rhel/19583ca584d6f574384e17fe7613dfaeadcdc4a6/vmlinuz-3.16.0"
user: lkp
queue: wfg
result_root: "/result/lkp-snb01/will-it-scale/open2/debian-x86_64.cgz/x86_64-rhel/19583ca584d6f574384e17fe7613dfaeadcdc4a6/0"
job_file: "/lkp/scheduled/lkp-snb01/wfg_will-it-scale-open2-x86_64-rhel-19583ca584d6f574384e17fe7613dfaeadcdc4a6-2.yaml"
dequeue_time: 2014-09-28 03:05:58.335268061 +08:00
history_time: 300
job_state: finished
loadavg: 22.58 12.50 5.05 1/495 10394
start_time: '1411844801'
end_time: '1411845111'
version: "/lkp/lkp/.src-20140927-200334"

--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

./runtest.py open2 25 1 8 16 24 32

--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--/unnNtmY43mpUSKx--
