Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaJ0CSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:18:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:7600 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaJ0CSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:18:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,792,1406617200"; 
   d="yaml'?scan'208";a="621098965"
Date: Mon, 27 Oct 2014 10:18:22 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [futex] 76835b0ebf8: -12.1% will-it-scale.per_process_ops
Message-ID: <20141027021822.GH27038@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="924gEkU1VlJlwnwX"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--924gEkU1VlJlwnwX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

FYI, we noticed the below changes on

commit 76835b0ebf8a7fe85beb03c75121419a7dec52f0 ("futex: Ensure get_futex_key_refs() always implies a barrier")


0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  testbox/testcase/testparams
----------------  --------------------------  ---------------------------
         %stddev     %change         %stddev
             \          |                \  
   9204866 ±  0%     -10.2%    8266680 ±  0%  lkp-wsx01/will-it-scale/performance-futex3
  11271283 ±  0%     -12.1%    9911001 ±  0%  nhm4/will-it-scale/performance-futex3
  10185806           -11.1%    9051578        GEO-MEAN will-it-scale.per_process_ops

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
   9211097 ±  0%     -10.2%    8268370 ±  0%  lkp-wsx01/will-it-scale/performance-futex3
  11324367 ±  0%     -12.0%    9969101 ±  0%  nhm4/will-it-scale/performance-futex3
  10213219           -11.1%    9078999        GEO-MEAN will-it-scale.per_thread_ops

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      0.63 ±  0%      +6.3%       0.66 ±  0%  lkp-wsx01/will-it-scale/performance-futex3
      0.66 ±  0%      +9.6%       0.72 ±  0%  nhm4/will-it-scale/performance-futex3
      0.64            +7.9%       0.69        GEO-MEAN will-it-scale.scalability

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      2.01 ±  1%    +365.3%       9.35 ±  1%  lkp-wsx01/will-it-scale/performance-futex3
      1.67 ±  1%    +509.7%      10.17 ±  3%  nhm4/will-it-scale/performance-futex3
      1.83          +432.6%       9.75        GEO-MEAN perf-profile.cpu-cycles.get_futex_key_refs.isra.11.futex_wake.do_futex.sys_futex.system_call_fastpath

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
         1 ± 34%    +200.0%          4 ± 17%  lkp-wsx01/will-it-scale/performance-futex3
         1          +200.0%          4        GEO-MEAN sched_debug.cpu#63.nr_uninterruptible

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       161 ± 27%    +159.0%        418 ± 29%  lkp-wsx01/will-it-scale/performance-futex3
       161          +159.0%        418        GEO-MEAN sched_debug.cpu#48.sched_goidle

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       395 ± 23%    +146.2%        972 ± 27%  lkp-wsx01/will-it-scale/performance-futex3
       395          +146.2%        972        GEO-MEAN sched_debug.cpu#48.nr_switches

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       404 ± 23%    +143.3%        984 ± 27%  lkp-wsx01/will-it-scale/performance-futex3
       404          +143.3%        984        GEO-MEAN sched_debug.cpu#48.sched_count

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       434 ± 32%     -68.0%        139 ± 20%  lkp-wsx01/will-it-scale/performance-futex3
       434           -68.0%        138        GEO-MEAN sched_debug.cpu#61.ttwu_local

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      5335 ± 48%     -54.4%       2433 ± 43%  lkp-wsx01/will-it-scale/performance-futex3
      5335           -54.4%       2433        GEO-MEAN sched_debug.cpu#20.sched_goidle

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       498 ± 23%     -54.4%        227 ± 25%  lkp-wsx01/will-it-scale/performance-futex3
       498           -54.4%        227        GEO-MEAN sched_debug.cpu#55.sched_goidle

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       576 ± 26%     -46.8%        306 ± 34%  lkp-wsx01/will-it-scale/performance-futex3
       576           -46.8%        306        GEO-MEAN sched_debug.cpu#55.ttwu_count

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      0.47 ±  7%    +119.7%       1.02 ±  5%  nhm4/will-it-scale/performance-futex3
      0.47          +119.7%       1.02        GEO-MEAN perf-profile.cpu-cycles.ret_from_sys_call.syscall

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     11216 ± 46%     -49.6%       5648 ± 38%  lkp-wsx01/will-it-scale/performance-futex3
     11216           -49.6%       5648        GEO-MEAN sched_debug.cpu#20.nr_switches

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     11237 ± 46%     -49.5%       5669 ± 38%  lkp-wsx01/will-it-scale/performance-futex3
     11237           -49.5%       5669        GEO-MEAN sched_debug.cpu#20.sched_count

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      1232 ± 27%     -52.8%        581 ± 21%  lkp-wsx01/will-it-scale/performance-futex3
      1232           -52.8%        581        GEO-MEAN sched_debug.cpu#55.nr_switches

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       155 ± 36%    +182.5%        438 ± 40%  lkp-wsx01/will-it-scale/performance-futex3
       155          +182.5%        438        GEO-MEAN sched_debug.cpu#48.ttwu_count

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      1245 ± 27%     -52.5%        591 ± 21%  lkp-wsx01/will-it-scale/performance-futex3
      1245           -52.5%        591        GEO-MEAN sched_debug.cpu#55.sched_count

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      1461 ± 31%     -46.9%        776 ± 23%  lkp-wsx01/will-it-scale/performance-futex3
      1461           -46.9%        776        GEO-MEAN sched_debug.cpu#42.ttwu_local

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       856 ± 34%     -50.2%        426 ± 31%  lkp-wsx01/will-it-scale/performance-futex3
       855           -50.2%        426        GEO-MEAN sched_debug.cpu#58.ttwu_count

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       926 ± 19%     -41.0%        546 ± 24%  lkp-wsx01/will-it-scale/performance-futex3
       926           -41.0%        546        GEO-MEAN sched_debug.cpu#61.ttwu_count

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      1593 ± 17%     -45.1%        875 ± 20%  lkp-wsx01/will-it-scale/performance-futex3
      1593           -45.1%        875        GEO-MEAN sched_debug.cpu#61.nr_switches

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      3667 ± 25%     -38.3%       2263 ± 18%  lkp-wsx01/will-it-scale/performance-futex3
      3667           -38.3%       2262        GEO-MEAN sched_debug.cpu#42.nr_switches

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      1604 ± 17%     -44.8%        885 ± 20%  lkp-wsx01/will-it-scale/performance-futex3
      1604           -44.8%        885        GEO-MEAN sched_debug.cpu#61.sched_count

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      3680 ± 25%     -38.1%       2279 ± 18%  lkp-wsx01/will-it-scale/performance-futex3
      3680           -38.1%       2279        GEO-MEAN sched_debug.cpu#42.sched_count

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       402 ± 22%     +45.4%        585 ± 29%  lkp-wsx01/will-it-scale/performance-futex3
       402           +45.4%        585        GEO-MEAN sched_debug.cpu#70.sched_goidle

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       153 ± 13%     -35.3%         99 ± 22%  nhm4/will-it-scale/performance-futex3
       153           -35.3%         99        GEO-MEAN sched_debug.cpu#6.load

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       595 ± 21%    +108.8%       1242 ± 40%  lkp-wsx01/will-it-scale/performance-futex3
       595          +108.8%       1242        GEO-MEAN sched_debug.cpu#70.ttwu_count

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      1127 ± 31%     -42.3%        651 ±  8%  nhm4/will-it-scale/performance-futex3
      1127           -42.3%        650        GEO-MEAN sched_debug.cfs_rq[3]:/.blocked_load_avg

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     16.48 ±  1%     +56.0%      25.71 ±  2%  nhm4/will-it-scale/performance-futex3
     16.48           +56.0%      25.71        GEO-MEAN perf-profile.cpu-cycles.futex_wake.do_futex.sys_futex.system_call_fastpath.syscall

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       575 ± 24%     -39.7%        346 ± 21%  lkp-wsx01/will-it-scale/performance-futex3
       575           -39.7%        346        GEO-MEAN sched_debug.cpu#61.sched_goidle

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       534 ± 11%     +63.0%        871 ± 35%  lkp-wsx01/will-it-scale/performance-futex3
       534           +63.0%        871        GEO-MEAN sched_debug.cpu#45.nr_switches

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       545 ± 11%     +62.0%        883 ± 35%  lkp-wsx01/will-it-scale/performance-futex3
       545           +62.0%        882        GEO-MEAN sched_debug.cpu#45.sched_count

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
        10 ± 26%     -44.0%          5 ± 18%  lkp-wsx01/will-it-scale/performance-futex3
        10           -44.0%          5        GEO-MEAN sched_debug.cpu#72.cpu_load[0]

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       827 ± 26%     +55.5%       1286 ± 23%  nhm4/will-it-scale/performance-futex3
       826           +55.5%       1285        GEO-MEAN sched_debug.cfs_rq[4]:/.blocked_load_avg

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      1245 ± 28%     -38.8%        762 ±  8%  nhm4/will-it-scale/performance-futex3
      1245           -38.8%        762        GEO-MEAN sched_debug.cfs_rq[3]:/.tg_load_contrib

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       969 ± 22%     +48.4%       1438 ± 20%  nhm4/will-it-scale/performance-futex3
       969           +48.4%       1438        GEO-MEAN sched_debug.cfs_rq[4]:/.tg_load_contrib

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       133 ± 11%     -28.7%         95 ± 22%  nhm4/will-it-scale/performance-futex3
       133           -28.7%         95        GEO-MEAN sched_debug.cfs_rq[6]:/.load

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       799 ± 19%     -34.8%        521 ± 26%  nhm4/will-it-scale/performance-futex3
       799           -34.8%        521        GEO-MEAN sched_debug.cfs_rq[2]:/.blocked_load_avg

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       906 ± 17%     -30.8%        627 ± 21%  nhm4/will-it-scale/performance-futex3
       906           -30.8%        627        GEO-MEAN sched_debug.cfs_rq[2]:/.tg_load_contrib

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
        70 ± 10%     +21.7%         85 ±  9%  nhm4/will-it-scale/performance-futex3
        70           +21.7%         85        GEO-MEAN sched_debug.cpu#2.cpu_load[3]

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      3149 ± 11%     -15.0%       2677 ± 10%  lkp-wsx01/will-it-scale/performance-futex3
      3149           -15.0%       2676        GEO-MEAN sched_debug.cpu#71.curr->pid

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
        68 ± 12%     +23.5%         84 ±  9%  nhm4/will-it-scale/performance-futex3
        68           +23.5%         83        GEO-MEAN sched_debug.cpu#2.cpu_load[4]

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
    214345 ± 13%     +31.5%     281773 ± 13%  nhm4/will-it-scale/performance-futex3
    214345           +31.5%     281773        GEO-MEAN sched_debug.cfs_rq[2]:/.min_vruntime

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     38234 ±  5%     -17.6%      31518 ±  1%  nhm4/will-it-scale/performance-futex3
     38234           -17.6%      31518        GEO-MEAN softirqs.RCU

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     37071 ± 15%     +36.8%      50702 ± 15%  nhm4/will-it-scale/performance-futex3
     37071           +36.8%      50702        GEO-MEAN sched_debug.cfs_rq[2]:/.exec_clock

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
    324067 ±  8%     -18.2%     265084 ± 14%  nhm4/will-it-scale/performance-futex3
    324067           -18.2%     265084        GEO-MEAN sched_debug.cfs_rq[6]:/.min_vruntime

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       103 ±  5%     -21.8%         81 ±  9%  nhm4/will-it-scale/performance-futex3
       103           -21.8%         81        GEO-MEAN sched_debug.cpu#6.cpu_load[2]

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       114 ±  4%     -21.6%         89 ± 12%  nhm4/will-it-scale/performance-futex3
       114           -21.6%         89        GEO-MEAN sched_debug.cpu#6.cpu_load[1]

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     58381 ± 10%     -23.2%      44812 ± 18%  nhm4/will-it-scale/performance-futex3
     58381           -23.2%      44812        GEO-MEAN sched_debug.cfs_rq[6]:/.exec_clock

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     82318 ± 11%     -20.7%      65237 ± 13%  nhm4/will-it-scale/performance-futex3
     82318           -20.7%      65237        GEO-MEAN sched_debug.cpu#1.nr_load_updates

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
        95 ±  7%     -19.9%         76 ±  8%  nhm4/will-it-scale/performance-futex3
        95           -19.9%         76        GEO-MEAN sched_debug.cpu#6.cpu_load[4]

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      7.76 ±  0%     +15.3%       8.95 ±  0%  lkp-wsx01/will-it-scale/performance-futex3
      6.55 ±  3%     +22.3%       8.01 ±  1%  nhm4/will-it-scale/performance-futex3
      7.13           +18.8%       8.47        GEO-MEAN perf-profile.cpu-cycles.get_futex_key.futex_wake.do_futex.sys_futex.system_call_fastpath

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
        98 ±  7%     -20.5%         78 ±  8%  nhm4/will-it-scale/performance-futex3
        98           -20.5%         78        GEO-MEAN sched_debug.cpu#6.cpu_load[3]

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      1.22 ±  4%     -15.5%       1.03 ±  9%  nhm4/will-it-scale/performance-futex3
      1.22           -15.5%       1.03        GEO-MEAN perf-profile.cpu-cycles.drop_futex_key_refs.isra.12.do_futex.sys_futex.system_call_fastpath.syscall

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      3.76 ±  0%     -13.5%       3.25 ±  0%  lkp-wsx01/will-it-scale/performance-futex3
      3.23 ±  2%     -15.0%       2.75 ±  2%  nhm4/will-it-scale/performance-futex3
      3.49           -14.3%       2.99        GEO-MEAN perf-profile.cpu-cycles.sysret_check.syscall

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      3053 ±  8%     -18.2%       2499 ± 13%  nhm4/will-it-scale/performance-futex3
      3053           -18.2%       2499        GEO-MEAN sched_debug.cpu#6.curr->pid

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     11.31 ±  0%     -11.2%      10.05 ±  0%  lkp-wsx01/will-it-scale/performance-futex3
     11.27 ±  1%     -16.4%       9.43 ±  1%  nhm4/will-it-scale/performance-futex3
     11.29           -13.8%       9.73        GEO-MEAN perf-profile.cpu-cycles.system_call.syscall

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     18.21 ±  1%     -13.6%      15.74 ±  2%  nhm4/will-it-scale/performance-futex3
     18.21           -13.6%      15.74        GEO-MEAN perf-profile.cpu-cycles.hash_futex.do_futex.sys_futex.system_call_fastpath.syscall

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     12.56 ±  0%     -12.2%      11.03 ±  1%  lkp-wsx01/will-it-scale/performance-futex3
     12.54 ±  1%     -14.4%      10.73 ±  3%  nhm4/will-it-scale/performance-futex3
     12.55           -13.3%      10.88        GEO-MEAN perf-profile.cpu-cycles.system_call_after_swapgs.syscall

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     21140 ±  9%     +17.5%      24849 ±  8%  nhm4/will-it-scale/performance-futex3
     21140           +17.5%      24849        GEO-MEAN sched_debug.cfs_rq[2]:/.avg->runnable_avg_sum

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      4.52 ±  2%     -11.5%       4.00 ±  1%  lkp-wsx01/will-it-scale/performance-futex3
     42.44 ±  0%     +13.8%      48.30 ±  2%  nhm4/will-it-scale/performance-futex3
     13.85            +0.4%      13.90        GEO-MEAN perf-profile.cpu-cycles.do_futex.sys_futex.system_call_fastpath.syscall

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      1.21 ±  1%     -11.4%       1.08 ±  1%  lkp-wsx01/will-it-scale/performance-futex3
      1.21           -11.4%       1.08        GEO-MEAN perf-profile.cpu-cycles.drop_futex_key_refs.isra.12.futex_wake.do_futex.sys_futex.system_call_fastpath

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     50.65 ±  0%     +11.9%      56.69 ±  2%  nhm4/will-it-scale/performance-futex3
     50.65           +11.9%      56.69        GEO-MEAN perf-profile.cpu-cycles.system_call_fastpath.syscall

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     20.50 ±  0%     -10.9%      18.25 ±  0%  lkp-wsx01/will-it-scale/performance-futex3
     20.50           -10.9%      18.25        GEO-MEAN perf-profile.cpu-cycles.syscall

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     27368 ±  7%     -13.6%      23638 ±  8%  nhm4/will-it-scale/performance-futex3
     27368           -13.6%      23638        GEO-MEAN sched_debug.cfs_rq[6]:/.avg->runnable_avg_sum

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      4.92 ±  0%     -11.5%       4.36 ±  1%  lkp-wsx01/will-it-scale/performance-futex3
     48.57 ±  0%     +11.3%      54.04 ±  2%  nhm4/will-it-scale/performance-futex3
     15.46            -0.7%      15.34        GEO-MEAN perf-profile.cpu-cycles.sys_futex.system_call_fastpath.syscall

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
       596 ±  7%     -13.6%        515 ±  8%  nhm4/will-it-scale/performance-futex3
       596           -13.6%        515        GEO-MEAN sched_debug.cfs_rq[6]:/.tg_runnable_contrib

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      3007 ±  6%     -11.8%       2654 ± 13%  lkp-wsx01/will-it-scale/performance-futex3
      3007           -11.8%       2653        GEO-MEAN sched_debug.cpu#38.curr->pid

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
     39113 ±  2%     +10.7%      43292 ±  4%  nhm4/will-it-scale/performance-futex3
     39113           +10.7%      43292        GEO-MEAN cpuidle.C6-NHM.usage

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      1401 ±  0%     -10.1%       1260 ±  0%  lkp-wsx01/will-it-scale/performance-futex3
       199 ±  0%     -21.5%        156 ±  2%  nhm4/will-it-scale/performance-futex3
       528           -16.0%        443        GEO-MEAN time.user_time

0429fbc0bdc297d6  76835b0ebf8a7fe85beb03c751  
----------------  --------------------------  
      3901 ±  0%      +3.6%       4041 ±  0%  lkp-wsx01/will-it-scale/performance-futex3
       522 ±  0%      +8.2%        565 ±  0%  nhm4/will-it-scale/performance-futex3
      1428            +5.9%       1511        GEO-MEAN time.system_time

lkp-wsx01: Westmere-EX
Memory: 128G

nhm4: Nehalem
Memory: 4G




                             will-it-scale.scalability

  0.73 ++----------------------------------------O--------------------------+
       O    O     O    O    O     O    O    O          O    O    O     O    O
  0.72 ++                                                                   |
  0.71 ++                                                                   |
       |                                                                    |
   0.7 ++                                                                   |
       |                                                                    |
  0.69 ++                                                                   |
       |                                                                    |
  0.68 ++                                                                   |
  0.67 ++                                                                   |
       |                                                                    |
  0.66 *+...*.....*....*....         ..*....   ..*.....*....*               |
       |                    *.....*..       *..                             |
  0.65 ++-------------------------------------------------------------------+


                             will-it-scale.per_process_ops

  1.14e+07 ++---------------------------------------------------------------+
           *....*....*....*....   ..*....*....*....*....*....*              |
  1.12e+07 ++                  *..                                          |
           |                                                                |
   1.1e+07 ++                                                               |
  1.08e+07 ++                                                               |
           |                                                                |
  1.06e+07 ++                                                               |
           |                                                                |
  1.04e+07 ++                                                               |
  1.02e+07 ++                                                               |
           |                                                                |
     1e+07 ++                                                               |
           O    O    O    O    O    O    O    O    O    O    O    O    O    O
   9.8e+06 ++---------------------------------------------------------------+


                             will-it-scale.per_thread_ops

  1.14e+07 ++---------------------------------------------------------------+
           *....*....*....*....*....*....*....*....*....*....*              |
  1.12e+07 ++                                                               |
           |                                                                |
   1.1e+07 ++                                                               |
  1.08e+07 ++                                                               |
           |                                                                |
  1.06e+07 ++                                                               |
           |                                                                |
  1.04e+07 ++                                                               |
  1.02e+07 ++                                                               |
           |                                                                |
     1e+07 O+   O    O    O    O    O    O    O    O         O              O
           |                                            O         O    O    |
   9.8e+06 ++---------------------------------------------------------------+




  28 ++---------------------------------------------------------------------+
     |                                                      O               |
  26 O+   O     O    O     O    O     O    O     O    O                     O
     |                                                           O     O    |
  24 ++                                                                     |
     |                                                                      |
  22 ++                                                                     |
     |                                                                      |
  20 ++                                                                     |
     |                                                                      |
  18 ++                                                                     |
     |       ...*....*.....   ..*.....*....   ...*....*.....                |
  16 *+...*..              *..             *..              *               |
     |                                                                      |
  14 ++---------------------------------------------------------------------+




  11 ++---------------------------------------------------------------------+
  10 O+   O     O    O          O     O    O     O    O     O          O    O
     |                     O                                     O          |
   9 ++                                                                     |
   8 ++                                                                     |
     |                                                                      |
   7 ++                                                                     |
   6 ++                                                                     |
   5 ++                                                                     |
     |                                                                      |
   4 ++                                                                     |
   3 ++                                                                     |
     |                                                                      |
   2 *+...*.....*....*.....*....*.....*....*.....*....*.....*               |
   1 ++---------------------------------------------------------------------+




    9 ++--------------------------------------------------------------------+
      |                                                                     |
  8.5 ++   O                                                                |
      |                     O                                               |
      O          O                    O               O     O               O
    8 ++              O          O          O    O               O     O    |
      |                                                                     |
  7.5 ++                                                                    |
      |                                                                     |
    7 ++                                                                    |
      |          *....                                                      |
      |        ..     *.....   ..*....*....     .*....*.....                |
  6.5 ++      .             *..            .  ..            *               |
      |     ..                              *.                              |
    6 *+---*----------------------------------------------------------------+

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
Fengguang

--924gEkU1VlJlwnwX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: will-it-scale
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
  energy: 
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
commit: f114040e3ea6e07372334ade75d1ee0775c355e1
model: Nehalem
nr_cpu: 8
memory: 4G
hdd_partitions: "/dev/disk/by-id/ata-WDC_WD1003FBYZ-010FB0_WD-WCAW36812041-part1"
swap_partitions: "/dev/disk/by-id/ata-WDC_WD1003FBYZ-010FB0_WD-WCAW36812041-part2"
rootfs_partition: "/dev/disk/by-id/ata-WDC_WD1003FBYZ-010FB0_WD-WCAW36812041-part3"
perf-profile:
  freq: 800
will-it-scale:
  test:
  - futex3
enqueue_time: 2014-10-21 00:33:51.358472551 +08:00
testbox: nhm4
tbox_group: nhm4
kconfig: x86_64-rhel
head_commit: f564618c89f952e9171278ed936c4740364b33a0
base_commit: f114040e3ea6e07372334ade75d1ee0775c355e1
branch: linux-devel/devel-hourly-2014102100
kernel: "/kernel/x86_64-rhel/f114040e3ea6e07372334ade75d1ee0775c355e1/vmlinuz-3.18.0-rc1-gf114040"
user: lkp
queue: cyclic
result_root: "/result/nhm4/will-it-scale/performance-futex3/debian-x86_64.cgz/x86_64-rhel/f114040e3ea6e07372334ade75d1ee0775c355e1/0"
job_file: "/lkp/scheduled/nhm4/cyclic_will-it-scale-performance-futex3-x86_64-rhel-BASE-f114040e3ea6e07372334ade75d1ee0775c355e1-0.yaml"
dequeue_time: 2014-10-21 01:03:14.201992054 +08:00
job_state: finished
loadavg: 6.64 3.40 1.37 1/127 5618
start_time: '1413824625'
end_time: '1413824930'
version: "/lkp/lkp/.src-20141020-230438"

--924gEkU1VlJlwnwX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
./runtest.py futex3 32 1 4 6 8

--924gEkU1VlJlwnwX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--924gEkU1VlJlwnwX--
