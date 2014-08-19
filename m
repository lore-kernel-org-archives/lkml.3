Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaHSEcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 00:32:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:16593 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbaHSEcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 00:32:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,891,1400050800"; 
   d="scan'208";a="578546536"
Date: Tue, 19 Aug 2014 12:32:52 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [mm] 3484b2de949: -56.2% vm-scalability.throughput, +9.3%
 turbostat.Pkg_W
Message-ID: <20140819043252.GA8798@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Mel,

We noticed the below vm-scalability performance/power regressions on
commit 3484b2de9499df23c4604a513b36f96326ae81ad ("mm: rearrange zone
fields into read-only, page alloc, statistics and page reclaim lines").

24b7e5819ad5cbe  3484b2de9499df23c4604a513  testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     %stddev        %change               %stddev
            \          |                 /
      9.95 ± 2%     +69.1%      16.83 ± 5%  brickland3/vm-scalability/300s-lru-file-mmap-read
      2.32 ± 6%    +229.4%       7.63 ± 5%  brickland3/vm-scalability/300s-lru-file-readonce
     12.27 ± 3%     +99.4%      24.46 ± 5%  TOTAL vm-scalability.stddev

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  13882598 ± 0%     -35.8%    8915310 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
  36379953 ± 1%     -64.0%   13093373 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  50262551 ± 0%     -56.2%   22008683 ± 0%  TOTAL vm-scalability.throughput

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1138 ±46%     -94.7%         60 ±23%  brickland3/vm-scalability/300s-lru-file-mmap-read
      1138 ±46%     -94.7%         60 ±23%  TOTAL proc-vmstat.compact_success

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      0.95 ±20%     -87.5%       0.12 ±12%  brickland3/vm-scalability/300s-lru-file-readonce
      0.95 ±20%     -87.5%       0.12 ±12%  TOTAL perf-profile.cpu-cycles.read_hpet.ktime_get.clockevents_program_event.tick_program_event.hrtimer_interrupt

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1.40 ±17%     -96.1%       0.05 ±27%  brickland3/vm-scalability/300s-lru-file-mmap-read
      2.70 ±36%     -95.0%       0.13 ± 8%  brickland3/vm-scalability/300s-lru-file-readonce
      4.10 ±29%     -95.4%       0.19 ±14%  TOTAL perf-profile.cpu-cycles._raw_spin_lock_irqsave.pagevec_lru_move_fn.__lru_cache_add.lru_cache_add.add_to_page_cache_lru

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1.46 ±12%     -89.1%       0.16 ±18%  brickland3/vm-scalability/300s-lru-file-readonce
      1.46 ±12%     -89.1%       0.16 ±18%  TOTAL perf-profile.cpu-cycles.read_hpet.ktime_get.tick_sched_timer.__run_hrtimer.hrtimer_interrupt

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1.18 ±23%     -82.5%       0.21 ±22%  brickland3/vm-scalability/300s-lru-file-readonce
      1.18 ±23%     -82.5%       0.21 ±22%  TOTAL perf-profile.cpu-cycles.read_hpet.ktime_get_update_offsets_now.hrtimer_interrupt.local_apic_timer_interrupt.smp_apic_timer_interrupt

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
       763 ±31%     -84.5%        118 ±11%  brickland3/vm-scalability/300s-lru-file-mmap-read
       763 ±31%     -84.5%        118 ±11%  TOTAL proc-vmstat.kswapd_low_wmark_hit_quickly

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1.59 ±12%     -85.1%       0.24 ±19%  brickland3/vm-scalability/300s-lru-file-mmap-read
      1.59 ±12%     -85.1%       0.24 ±19%  TOTAL perf-profile.cpu-cycles.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.__do_page_cache_readahead

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     19972 ±45%     -71.3%       5725 ±16%  brickland3/vm-scalability/300s-lru-file-mmap-read
     19972 ±45%     -71.3%       5725 ±16%  TOTAL proc-vmstat.pgmigrate_success

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
       543 ±28%     -62.1%        205 ±14%  brickland3/vm-scalability/300s-lru-file-mmap-read
        47 ±16%    +828.5%        443 ± 7%  brickland3/vm-scalability/300s-lru-file-readonce
       590 ±27%     +10.0%        649 ± 9%  TOTAL proc-vmstat.kswapd_high_wmark_hit_quickly

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    518176 ± 5%    -100.0%          0 ± 0%  brickland3/vm-scalability/300s-lru-file-mmap-read
    687557 ± 0%     -53.8%     317522 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
   1205734 ± 2%     -73.7%     317522 ± 2%  TOTAL numa-vmstat.node1.workingset_nodereclaim

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      2.61 ± 5%     -52.7%       1.24 ±25%  brickland3/vm-scalability/300s-lru-file-mmap-read
      1.29 ±10%     -91.0%       0.12 ±15%  brickland3/vm-scalability/300s-lru-file-readonce
      3.91 ± 7%     -65.4%       1.35 ±24%  TOTAL perf-profile.cpu-cycles.read_hpet.ktime_get.sched_clock_tick.scheduler_tick.update_process_times

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.652e+08 ± 5%     -47.7%   86319616 ± 7%  brickland3/vm-scalability/300s-lru-file-mmap-read
  16732078 ± 7%    +894.1%  1.663e+08 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
 1.819e+08 ± 5%     +38.9%  2.527e+08 ± 5%  TOTAL proc-vmstat.pgscan_kswapd_normal

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   1565973 ± 2%    -100.0%          0 ± 0%  brickland3/vm-scalability/300s-lru-file-mmap-read
   2720970 ± 0%     -47.2%    1437269 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
   4286943 ± 1%     -66.5%    1437269 ± 1%  TOTAL proc-vmstat.workingset_nodereclaim

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  34449272 ± 5%     -48.1%   17892413 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
  16725742 ± 7%    +894.4%  1.663e+08 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
  51175014 ± 5%    +260.0%  1.842e+08 ± 3%  TOTAL proc-vmstat.pgsteal_kswapd_normal

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    579964 ± 7%    -100.0%          0 ± 0%  brickland3/vm-scalability/300s-lru-file-mmap-read
    689893 ± 0%     -44.1%     385678 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
   1269857 ± 3%     -69.6%     385678 ± 2%  TOTAL numa-vmstat.node3.workingset_nodereclaim

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     27.49 ± 3%     -45.8%      14.91 ±17%  brickland3/vm-scalability/300s-lru-file-readonce
     27.49 ± 3%     -45.8%      14.91 ±17%  TOTAL turbostat.%pc2

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    178797 ± 8%     -42.0%     103621 ± 6%  brickland3/vm-scalability/300s-lru-file-mmap-read
     47255 ±12%    +930.2%     486833 ±10%  brickland3/vm-scalability/300s-lru-file-readonce
    226052 ± 9%    +161.2%     590454 ± 9%  TOTAL proc-vmstat.pgsteal_kswapd_dma32

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    468136 ± 7%    -100.0%          0 ± 0%  brickland3/vm-scalability/300s-lru-file-mmap-read
    693085 ± 1%     -39.9%     416491 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
   1161222 ± 4%     -64.1%     416491 ± 2%  TOTAL numa-vmstat.node2.workingset_nodereclaim

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   4318208 ± 1%     -99.7%      11627 ± 9%  brickland3/vm-scalability/300s-lru-file-mmap-read
   6822297 ± 0%     -40.1%    4084812 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
  11140505 ± 1%     -63.2%    4096440 ± 1%  TOTAL proc-vmstat.slabs_scanned

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    395581 ±14%     -32.1%     268687 ±15%  brickland3/vm-scalability/300s-lru-file-mmap-read
     47338 ±12%    +928.6%     486919 ±10%  brickland3/vm-scalability/300s-lru-file-readonce
    442920 ±14%     +70.6%     755607 ±12%  TOTAL proc-vmstat.pgscan_kswapd_dma32

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      4.37 ± 7%     -61.2%       1.70 ±24%  brickland3/vm-scalability/300s-lru-file-mmap-read
      6.75 ± 5%     -64.9%       2.37 ± 6%  brickland3/vm-scalability/300s-lru-file-readonce
     11.13 ± 6%     -63.5%       4.06 ±14%  TOTAL perf-profile.cpu-cycles.memset.mpage_readpages.xfs_vm_readpages.__do_page_cache_readahead.ondemand_readahead

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1.37 ± 8%     -62.2%       0.52 ±23%  brickland3/vm-scalability/300s-lru-file-mmap-read
      1.59 ± 5%     -65.7%       0.55 ± 7%  brickland3/vm-scalability/300s-lru-file-readonce
      2.96 ± 6%     -64.1%       1.06 ±15%  TOTAL perf-profile.cpu-cycles.do_mpage_readpage.mpage_readpages.xfs_vm_readpages.__do_page_cache_readahead.ondemand_readahead

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1911 ±12%     -62.2%        722 ±25%  brickland3/vm-scalability/300s-lru-file-readonce
      1911 ±12%     -62.2%        722 ±25%  TOTAL proc-vmstat.pgscan_direct_throttle

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      3.37 ± 9%    +232.0%      11.18 ±25%  brickland3/vm-scalability/300s-lru-file-mmap-read
     26.57 ± 4%     +73.3%      46.04 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
     29.93 ± 5%     +91.2%      57.22 ± 6%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.free_pcppages_bulk.free_hot_cold_page.free_hot_cold_page_list.shrink_page_list

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    292141 ± 4%    +165.3%     775139 ± 4%  brickland3/vm-scalability/300s-lru-file-readonce
    292141 ± 4%    +165.3%     775139 ± 4%  TOTAL softirqs.RCU

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  61899502 ± 1%     -53.7%   28663774 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
  11490237 ± 7%    +204.7%   35005345 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  73389740 ± 2%     -13.2%   63669120 ± 2%  TOTAL numa-numastat.node3.other_node

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  61894563 ± 1%     -53.7%   28660170 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
  11487385 ± 7%    +204.7%   35000524 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  73381949 ± 2%     -13.2%   63660694 ± 2%  TOTAL numa-numastat.node3.numa_miss

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  37543259 ± 2%     -54.3%   17139747 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   7768241 ± 8%    +181.3%   21853872 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  45311501 ± 3%     -13.9%   38993620 ± 2%  TOTAL numa-vmstat.node3.numa_miss

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  37628483 ± 2%     -54.2%   17224017 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   7851378 ± 8%    +179.4%   21938991 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  45479862 ± 3%     -13.9%   39163008 ± 2%  TOTAL numa-vmstat.node3.numa_other

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.599e+08 ± 1%     -49.9%   80094895 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
  11422480 ± 2%    +194.8%   33675826 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
 1.713e+08 ± 1%     -33.6%  1.138e+08 ± 2%  TOTAL numa-numastat.node0.numa_foreign

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  96263262 ± 2%     -53.1%   45191652 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
   7622035 ± 2%    +178.4%   21217541 ± 4%  brickland3/vm-scalability/300s-lru-file-readonce
 103885297 ± 2%     -36.1%   66409193 ± 3%  TOTAL numa-vmstat.node0.numa_foreign

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  85346466 ± 2%     -40.8%   50525376 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
  12056858 ± 3%    +215.0%   37973604 ± 6%  brickland3/vm-scalability/300s-lru-file-readonce
  97403324 ± 2%      -9.1%   88498980 ± 4%  TOTAL numa-numastat.node1.numa_miss

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  85350581 ± 2%     -40.8%   50532008 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
  12061005 ± 3%    +214.9%   37979653 ± 6%  brickland3/vm-scalability/300s-lru-file-readonce
  97411587 ± 2%      -9.1%   88511661 ± 4%  TOTAL numa-numastat.node1.other_node

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  53719356 ± 3%     -43.9%   30133382 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
   8183737 ± 3%    +192.7%   23954479 ± 6%  brickland3/vm-scalability/300s-lru-file-readonce
  61903093 ± 3%     -12.6%   54087861 ± 5%  TOTAL numa-vmstat.node1.numa_miss

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  53802537 ± 3%     -43.8%   30218405 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
   8266017 ± 3%    +190.8%   24038964 ± 6%  brickland3/vm-scalability/300s-lru-file-readonce
  62068554 ± 3%     -12.6%   54257370 ± 5%  TOTAL numa-vmstat.node1.numa_other

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  14319949 ± 7%    +146.5%   35300490 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  14319949 ± 7%    +146.5%   35300490 ± 2%  TOTAL numa-numastat.node0.numa_miss

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  14327584 ± 7%    +146.4%   35303342 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  14327584 ± 7%    +146.4%   35303342 ± 2%  TOTAL numa-numastat.node0.other_node

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  41804307 ± 1%     -54.4%   19081241 ± 5%  brickland3/vm-scalability/300s-lru-file-mmap-read
   7633990 ± 8%    +151.7%   19214179 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  49438297 ± 2%     -22.5%   38295420 ± 3%  TOTAL numa-vmstat.node2.numa_miss

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 2.228e+08 ± 1%     -46.6%   1.19e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
  49195780 ± 4%    +182.4%  1.389e+08 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  2.72e+08 ± 2%      -5.2%  2.579e+08 ± 1%  TOTAL proc-vmstat.numa_miss

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 2.228e+08 ± 1%     -46.6%   1.19e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
  49196215 ± 4%    +182.3%  1.389e+08 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  2.72e+08 ± 2%      -5.2%  2.579e+08 ± 1%  TOTAL proc-vmstat.numa_foreign

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 2.228e+08 ± 1%     -46.6%   1.19e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
  49217751 ± 4%    +182.3%  1.389e+08 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
 2.721e+08 ± 2%      -5.2%   2.58e+08 ± 1%  TOTAL proc-vmstat.numa_other

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  41884224 ± 1%     -54.2%   19165553 ± 5%  brickland3/vm-scalability/300s-lru-file-mmap-read
   7719489 ± 8%    +150.0%   19299287 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  49603713 ± 2%     -22.5%   38464840 ± 3%  TOTAL numa-vmstat.node2.numa_other

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  69206605 ± 3%     -51.7%   33399613 ± 4%  brickland3/vm-scalability/300s-lru-file-mmap-read
  11331586 ± 8%    +170.3%   30629759 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  80538191 ± 4%     -20.5%   64029372 ± 3%  TOTAL numa-numastat.node2.numa_miss

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  69211755 ± 3%     -51.7%   33403393 ± 4%  brickland3/vm-scalability/300s-lru-file-mmap-read
  11338920 ± 8%    +170.2%   30634435 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  80550676 ± 4%     -20.5%   64037828 ± 3%  TOTAL numa-numastat.node2.other_node

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  26095298 ± 2%     -51.2%   12728144 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
  12262186 ± 6%    +153.2%   31042313 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  38357485 ± 4%     +14.1%   43770458 ± 3%  TOTAL numa-numastat.node1.numa_foreign

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      5.57 ±11%    +142.5%      13.50 ±22%  brickland3/vm-scalability/300s-lru-file-mmap-read
     20.89 ± 2%     +85.3%      38.71 ± 7%  brickland3/vm-scalability/300s-lru-file-readonce
     26.45 ± 4%     +97.4%      52.21 ±11%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  22081863 ± 1%     -29.2%   15627383 ± 4%  brickland3/vm-scalability/300s-lru-file-mmap-read
  12674153 ± 5%    +205.0%   38656866 ± 4%  brickland3/vm-scalability/300s-lru-file-readonce
  34756017 ± 3%     +56.2%   54284249 ± 4%  TOTAL numa-numastat.node2.numa_foreign

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   3835243 ± 1%     -54.0%    1766055 ± 4%  brickland3/vm-scalability/300s-lru-file-mmap-read
   3835243 ± 1%     -54.0%    1766055 ± 4%  TOTAL cpuidle.C1-IVT-4S.usage

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  10024520 ± 6%    +121.8%   22237848 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  10024520 ± 6%    +121.8%   22237848 ± 2%  TOTAL numa-vmstat.node0.numa_miss

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  10030708 ± 6%    +121.7%   22241976 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  10030708 ± 6%    +121.7%   22241976 ± 2%  TOTAL numa-vmstat.node0.numa_other

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  16713245 ± 2%     -50.6%    8251655 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
   8357488 ± 5%    +133.0%   19470522 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  25070733 ± 3%     +10.6%   27722177 ± 2%  TOTAL numa-vmstat.node1.numa_foreign

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  14762027 ± 3%     -28.5%   10559627 ± 9%  brickland3/vm-scalability/300s-lru-file-mmap-read
  12837395 ± 5%    +176.8%   35529663 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
  27599422 ± 4%     +67.0%   46089291 ± 4%  TOTAL numa-numastat.node3.numa_foreign

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  14597660 ± 4%     -28.9%   10375013 ± 4%  brickland3/vm-scalability/300s-lru-file-mmap-read
   8755827 ± 6%    +175.9%   24156475 ± 4%  brickland3/vm-scalability/300s-lru-file-readonce
  23353488 ± 5%     +47.9%   34531489 ± 4%  TOTAL numa-vmstat.node2.numa_foreign

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1.90 ± 2%     -45.2%       1.04 ±16%  brickland3/vm-scalability/300s-lru-file-readonce
      1.90 ± 2%     -45.2%       1.04 ±16%  TOTAL turbostat.%c1

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   9870153 ± 2%     -29.6%    6943700 ± 9%  brickland3/vm-scalability/300s-lru-file-mmap-read
   8877090 ± 6%    +152.5%   22416811 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  18747244 ± 4%     +56.6%   29360512 ± 4%  TOTAL numa-vmstat.node3.numa_foreign

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      6004 ±26%     -36.2%       3829 ±14%  brickland3/vm-scalability/300s-lru-file-readonce
      6004 ±26%     -36.2%       3829 ±14%  TOTAL numa-meminfo.node3.Mapped

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    678225 ± 1%     -48.8%     347400 ± 5%  brickland3/vm-scalability/300s-lru-file-readonce
    678225 ± 1%     -48.8%     347400 ± 5%  TOTAL numa-vmstat.node0.workingset_nodereclaim

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   7744496 ± 2%     +85.2%   14345340 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
   7744496 ± 2%     +85.2%   14345340 ± 0%  TOTAL softirqs.TIMER

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     29388 ± 0%     -44.4%      16352 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
     29388 ± 0%     -44.4%      16352 ± 3%  TOTAL softirqs.HRTIMER

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1500 ±29%     -38.1%        928 ±12%  brickland3/vm-scalability/300s-lru-file-readonce
      1500 ±29%     -38.1%        928 ±12%  TOTAL numa-vmstat.node3.nr_mapped

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     28488 ± 2%     -52.2%      13618 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
     28548 ± 0%     -28.1%      20530 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
     57037 ± 1%     -40.1%      34149 ± 1%  TOTAL proc-vmstat.allocstall

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      2916 ±12%     -54.4%       1331 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
      1664 ± 2%     +25.5%       2089 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
      4580 ± 9%     -25.3%       3420 ± 2%  TOTAL proc-vmstat.pageoutrun

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
       267 ± 1%     +71.7%        458 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
       267 ± 1%     +71.7%        458 ± 0%  TOTAL uptime.boot

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   1832198 ± 0%     -47.5%     962411 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
   2535964 ± 0%     -31.9%    1726203 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
   4368163 ± 0%     -38.4%    2688615 ± 1%  TOTAL proc-vmstat.pgsteal_direct_dma32

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   9.1e+08 ± 0%     -40.7%  5.398e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   9.1e+08 ± 0%     -40.7%  5.398e+08 ± 1%  TOTAL proc-vmstat.pgfree

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 9.078e+08 ± 0%     -40.7%  5.386e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
 9.078e+08 ± 0%     -40.7%  5.386e+08 ± 1%  TOTAL proc-vmstat.pgalloc_normal

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   3787073 ± 2%     -43.4%    2143931 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
   2536168 ± 0%     -31.9%    1726413 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
   6323242 ± 1%     -38.8%    3870345 ± 2%  TOTAL proc-vmstat.pgscan_direct_dma32

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 7.411e+08 ± 0%     -47.4%  3.898e+08 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
 9.256e+08 ± 0%     -26.3%  6.822e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
 1.667e+09 ± 0%     -35.7%  1.072e+09 ± 1%  TOTAL proc-vmstat.pgsteal_direct_normal

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      2.94 ± 4%     +56.4%       4.60 ± 9%  brickland3/vm-scalability/300s-lru-file-mmap-read
      2.94 ± 4%     +56.4%       4.60 ± 9%  TOTAL perf-profile.cpu-cycles.mutex_spin_on_owner.__mutex_lock_slowpath.mutex_lock.rmap_walk.page_referenced

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
       511 ± 4%     -35.2%        331 ± 9%  brickland3/vm-scalability/300s-lru-file-readonce
       511 ± 4%     -35.2%        331 ± 9%  TOTAL numa-vmstat.node2.nr_isolated_file

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    773646 ± 1%     -35.7%     497235 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
    773646 ± 1%     -35.7%     497235 ± 1%  TOTAL numa-meminfo.node1.PageTables

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    193034 ± 1%     -35.3%     124819 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
    193034 ± 1%     -35.3%     124819 ± 1%  TOTAL numa-vmstat.node1.nr_page_table_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     24.83 ± 3%     -27.1%      18.11 ±10%  brickland3/vm-scalability/300s-lru-file-mmap-read
     42.78 ± 1%     -41.6%      25.00 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
     67.61 ± 2%     -36.2%      43.11 ± 5%  TOTAL turbostat.%c6

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.449e+09 ± 1%     -42.2%  8.376e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
 9.257e+08 ± 0%     -26.3%  6.823e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
 2.375e+09 ± 0%     -36.0%   1.52e+09 ± 1%  TOTAL proc-vmstat.pgscan_direct_normal

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.625e+08 ± 1%     -41.8%   94564115 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.886e+08 ± 0%     -25.0%  1.415e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
 3.511e+08 ± 1%     -32.8%   2.36e+08 ± 1%  TOTAL numa-vmstat.node0.numa_local

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.625e+08 ± 1%     -41.8%   94575783 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.886e+08 ± 0%     -25.0%  1.415e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
 3.511e+08 ± 1%     -32.8%  2.361e+08 ± 1%  TOTAL numa-vmstat.node0.numa_hit

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.129e+08 ± 1%     -39.9%   67808889 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.911e+08 ± 0%     -27.9%  1.378e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
  3.04e+08 ± 1%     -32.4%  2.056e+08 ± 1%  TOTAL numa-vmstat.node1.numa_local

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  1.13e+08 ± 1%     -39.9%   67893910 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.911e+08 ± 0%     -27.9%  1.379e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
 3.041e+08 ± 1%     -32.3%  2.058e+08 ± 1%  TOTAL numa-vmstat.node1.numa_hit

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     16950 ± 5%     -34.4%      11111 ± 8%  brickland3/vm-scalability/300s-lru-file-mmap-read
     16950 ± 5%     -34.4%      11111 ± 8%  TOTAL cpuidle.C3-IVT-4S.usage

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    292183 ± 1%     -34.2%     192394 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
    292183 ± 1%     -34.2%     192394 ± 1%  TOTAL numa-vmstat.node3.nr_slab_reclaimable

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  72128917 ± 0%     -40.4%   42986804 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
   1160192 ± 3%     +39.9%    1622852 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
  73289109 ± 0%     -39.1%   44609656 ± 2%  TOTAL proc-vmstat.pgfault

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   1170427 ± 1%     -34.5%     766302 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   1170427 ± 1%     -34.5%     766302 ± 1%  TOTAL numa-meminfo.node3.SReclaimable

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      5.15 ± 5%     +44.3%       7.43 ± 9%  brickland3/vm-scalability/300s-lru-file-mmap-read
      5.15 ± 5%     +44.3%       7.43 ± 9%  TOTAL perf-profile.cpu-cycles.generic_exec_single.smp_call_function_single.smp_call_function_many.native_flush_tlb_others.flush_tlb_page

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  21722028 ±14%     -27.4%   15765961 ±13%  brickland3/vm-scalability/300s-lru-file-mmap-read
  21722028 ±14%     -27.4%   15765961 ±13%  TOTAL cpuidle.C3-IVT-4S.time

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    295382 ± 1%     -32.4%     199692 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
    295382 ± 1%     -32.4%     199692 ± 2%  TOTAL numa-vmstat.node1.nr_slab_reclaimable

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   1202511 ± 1%     -33.4%     800394 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   1202511 ± 1%     -33.4%     800394 ± 1%  TOTAL numa-meminfo.node3.Slab

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    135163 ± 0%     -31.6%      92402 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
    135163 ± 0%     -31.6%      92402 ± 1%  TOTAL slabinfo.radix_tree_node.active_slabs

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    135163 ± 0%     -31.6%      92402 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
    135163 ± 0%     -31.6%      92402 ± 1%  TOTAL slabinfo.radix_tree_node.num_slabs

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   7569136 ± 0%     -31.6%    5174561 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   7569136 ± 0%     -31.6%    5174561 ± 1%  TOTAL slabinfo.radix_tree_node.num_objs

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.412e+08 ± 1%     -40.4%   84248525 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
 2.568e+08 ± 0%     -21.7%  2.011e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
  3.98e+08 ± 0%     -28.3%  2.853e+08 ± 1%  TOTAL numa-numastat.node1.local_node

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.412e+08 ± 1%     -40.3%   84255157 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
 2.568e+08 ± 0%     -21.7%  2.011e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
  3.98e+08 ± 0%     -28.3%  2.853e+08 ± 1%  TOTAL numa-numastat.node1.numa_hit

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   1183239 ± 1%     -32.7%     795729 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
   1183239 ± 1%     -32.7%     795729 ± 3%  TOTAL numa-meminfo.node1.SReclaimable

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.289e+08 ± 1%     -37.7%   80278779 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.916e+08 ± 0%     -24.3%  1.451e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 3.206e+08 ± 0%     -29.7%  2.254e+08 ± 1%  TOTAL numa-vmstat.node3.numa_local

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  1.29e+08 ± 1%     -37.7%   80363047 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.917e+08 ± 0%     -24.2%  1.452e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 3.207e+08 ± 0%     -29.7%  2.256e+08 ± 1%  TOTAL numa-vmstat.node3.numa_hit

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   1144645 ± 2%     -32.8%     768993 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
   1144645 ± 2%     -32.8%     768993 ± 2%  TOTAL numa-meminfo.node2.SReclaimable

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   5830125 ± 3%     -17.3%    4821835 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   8557468 ± 2%     -41.0%    5045624 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
  14387594 ± 2%     -31.4%    9867460 ± 1%  TOTAL numa-vmstat.node0.nr_free_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   1093892 ± 0%     -31.4%     750954 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   1093892 ± 0%     -31.4%     750954 ± 1%  TOTAL proc-vmstat.nr_slab_reclaimable

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   5785378 ± 4%     -18.1%    4737611 ± 4%  brickland3/vm-scalability/300s-lru-file-mmap-read
   8191876 ± 2%     -39.0%    4994945 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
  13977254 ± 3%     -30.4%    9732556 ± 2%  TOTAL numa-vmstat.node3.nr_free_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 2.198e+08 ± 0%     -40.8%  1.302e+08 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
 2.537e+08 ± 0%     -18.4%  2.069e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
 4.735e+08 ± 0%     -28.8%  3.371e+08 ± 1%  TOTAL numa-numastat.node0.local_node

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 2.199e+08 ± 0%     -40.8%  1.302e+08 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
 2.537e+08 ± 0%     -18.4%  2.069e+08 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
 4.736e+08 ± 0%     -28.8%  3.371e+08 ± 1%  TOTAL numa-numastat.node0.numa_hit

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    285717 ± 2%     -32.4%     193014 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
    285717 ± 2%     -32.4%     193014 ± 1%  TOTAL numa-vmstat.node2.nr_slab_reclaimable

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  23302752 ± 3%     -17.5%   19233230 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
  34168164 ± 2%     -41.0%   20160695 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  57470916 ± 2%     -31.5%   39393925 ± 2%  TOTAL numa-meminfo.node0.MemFree

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  22464606 ± 4%     -15.9%   18899287 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
  33409387 ± 1%     -39.7%   20144973 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
  55873993 ± 2%     -30.1%   39044260 ± 2%  TOTAL numa-meminfo.node1.MemFree

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  22596612 ± 2%     -17.3%   18690112 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
  32888379 ± 1%     -40.5%   19557960 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
  55484992 ± 1%     -31.1%   38248073 ± 1%  TOTAL proc-vmstat.nr_free_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   1219306 ± 1%     -31.9%     830492 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
   1219306 ± 1%     -31.9%     830492 ± 3%  TOTAL numa-meminfo.node1.Slab

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   1176783 ± 2%     -31.8%     801979 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   1176783 ± 2%     -31.8%     801979 ± 1%  TOTAL numa-meminfo.node2.Slab

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   7255253 ± 0%     -30.2%    5061846 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   7255253 ± 0%     -30.2%    5061846 ± 1%  TOTAL slabinfo.radix_tree_node.active_objs

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   4354231 ± 0%     -30.7%    3016317 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   4354231 ± 0%     -30.7%    3016317 ± 1%  TOTAL meminfo.SReclaimable

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  89793802 ± 2%     -17.5%   74083099 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.314e+08 ± 1%     -40.3%   78477271 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
 2.212e+08 ± 1%     -31.0%  1.526e+08 ± 2%  TOTAL meminfo.MemFree

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.248e+08 ± 3%     -37.2%   78416804 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.918e+08 ± 0%     -21.7%  1.503e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 3.166e+08 ± 1%     -27.8%  2.287e+08 ± 1%  TOTAL numa-vmstat.node2.numa_local

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.249e+08 ± 3%     -37.1%   78501114 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.919e+08 ± 0%     -21.6%  1.504e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 3.168e+08 ± 1%     -27.8%  2.289e+08 ± 1%  TOTAL numa-vmstat.node2.numa_hit

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  76888271 ± 2%     -14.1%   66010304 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.305e+08 ± 1%     -41.3%   76594029 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
 2.074e+08 ± 1%     -31.2%  1.426e+08 ± 1%  TOTAL vmstat.memory.free

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
       473 ± 7%     -23.5%        362 ±13%  brickland3/vm-scalability/300s-lru-file-readonce
       473 ± 7%     -23.5%        362 ±13%  TOTAL numa-vmstat.node3.nr_isolated_file

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   1559898 ± 0%     -30.0%    1092289 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
    211875 ±20%     +56.4%     331443 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
   1771773 ± 2%     -19.6%    1423732 ± 1%  TOTAL softirqs.SCHED

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  23128109 ± 5%     -18.2%   18910364 ± 6%  brickland3/vm-scalability/300s-lru-file-mmap-read
  32678604 ± 2%     -38.9%   19957620 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
  55806713 ± 3%     -30.4%   38867985 ± 3%  TOTAL numa-meminfo.node3.MemFree

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   2363418 ± 0%     -40.7%    1402609 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   2920077 ± 0%     -12.7%    2547859 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
   5283495 ± 0%     -25.2%    3950468 ± 1%  TOTAL proc-vmstat.pgalloc_dma32

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     21290 ± 5%     -29.3%      15054 ± 4%  brickland3/vm-scalability/300s-lru-file-readonce
     21290 ± 5%     -29.3%      15054 ± 4%  TOTAL meminfo.Mapped

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    755935 ± 1%     -34.5%     495084 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
      1892 ± 8%     +29.4%       2447 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
    757827 ± 1%     -34.3%     497532 ± 1%  TOTAL numa-meminfo.node3.PageTables

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   4496625 ± 0%     -29.7%    3159080 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   4496625 ± 0%     -29.7%    3159080 ± 1%  TOTAL meminfo.Slab

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  22503656 ± 5%     -15.3%   19052501 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
  32274836 ± 3%     -37.7%   20119596 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
  54778492 ± 4%     -28.5%   39172098 ± 2%  TOTAL numa-meminfo.node2.MemFree

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 6.858e+08 ± 0%     -38.8%  4.199e+08 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.026e+09 ± 0%     -17.9%  8.422e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 1.712e+09 ± 0%     -26.3%  1.262e+09 ± 1%  TOTAL proc-vmstat.numa_local

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 6.858e+08 ± 0%     -38.8%  4.199e+08 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.026e+09 ± 0%     -17.9%  8.422e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 1.712e+09 ± 0%     -26.3%  1.262e+09 ± 1%  TOTAL proc-vmstat.numa_hit

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   5619854 ± 4%     -15.7%    4738362 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   8370497 ± 1%     -39.8%    5040037 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
  13990351 ± 2%     -30.1%    9778399 ± 1%  TOTAL numa-vmstat.node1.nr_free_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   8022752 ± 5%     +38.1%   11079276 ± 8%  brickland3/vm-scalability/300s-lru-file-mmap-read
   8022752 ± 5%     +38.1%   11079276 ± 8%  TOTAL time.maximum_resident_set_size

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      7933 ± 6%     -30.8%       5487 ± 9%  brickland3/vm-scalability/300s-lru-file-mmap-read
      7933 ± 6%     -30.8%       5487 ± 9%  TOTAL cpuidle.C1E-IVT-4S.usage

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    188691 ± 1%     -34.1%     124329 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
       471 ± 7%     +29.9%        612 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
    189162 ± 1%     -34.0%     124941 ± 1%  TOTAL numa-vmstat.node3.nr_page_table_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    138389 ± 9%     -32.5%      93430 ±18%  brickland3/vm-scalability/300s-lru-file-readonce
    138389 ± 9%     -32.5%      93430 ±18%  TOTAL proc-vmstat.pgactivate

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   5626193 ± 5%     -15.1%    4778409 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
   8083183 ± 3%     -37.7%    5035365 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
  13709376 ± 4%     -28.4%    9813775 ± 2%  TOTAL numa-vmstat.node2.nr_free_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.662e+08 ± 0%     -36.8%   1.05e+08 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
 2.575e+08 ± 0%     -17.4%  2.128e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 4.237e+08 ± 0%     -25.0%  3.178e+08 ± 1%  TOTAL numa-numastat.node3.numa_hit

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.662e+08 ± 0%     -36.8%   1.05e+08 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
 2.575e+08 ± 0%     -17.4%  2.128e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 4.237e+08 ± 0%     -25.0%  3.178e+08 ± 1%  TOTAL numa-numastat.node3.local_node

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
        66 ± 1%     +35.3%         89 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
        66 ± 1%     +35.3%         89 ± 0%  TOTAL vmstat.procs.r

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.585e+08 ± 1%     -36.6%  1.005e+08 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
 2.578e+08 ± 0%     -14.1%  2.215e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 4.163e+08 ± 0%     -22.7%  3.219e+08 ± 1%  TOTAL numa-numastat.node2.local_node

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.585e+08 ± 1%     -36.6%  1.005e+08 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
 2.578e+08 ± 0%     -14.1%  2.215e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 4.163e+08 ± 0%     -22.7%   3.22e+08 ± 1%  TOTAL numa-numastat.node2.numa_hit

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    759826 ± 1%     -34.8%     495074 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
      2057 ± 3%     +17.8%       2423 ± 6%  brickland3/vm-scalability/300s-lru-file-readonce
    761884 ± 1%     -34.7%     497497 ± 1%  TOTAL numa-meminfo.node2.PageTables

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    759680 ± 1%     -34.5%     497889 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
      2045 ± 1%     +17.9%       2413 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
    761726 ± 1%     -34.3%     500302 ± 1%  TOTAL proc-vmstat.nr_page_table_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    741326 ± 1%     -32.7%     499221 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
      2029 ±10%     +19.4%       2422 ± 8%  brickland3/vm-scalability/300s-lru-file-readonce
    743355 ± 1%     -32.5%     501644 ± 1%  TOTAL numa-meminfo.node0.PageTables

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    184996 ± 1%     -32.3%     125326 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
       505 ±10%     +19.5%        603 ± 8%  brickland3/vm-scalability/300s-lru-file-readonce
    185501 ± 1%     -32.1%     125930 ± 1%  TOTAL numa-vmstat.node0.nr_page_table_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    189703 ± 0%     -34.5%     124276 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
       516 ± 3%     +17.3%        605 ± 6%  brickland3/vm-scalability/300s-lru-file-readonce
    190219 ± 0%     -34.3%     124882 ± 1%  TOTAL numa-vmstat.node2.nr_page_table_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   3022193 ± 1%     -33.6%    2007941 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
      8169 ± 1%     +18.3%       9660 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
   3030362 ± 1%     -33.4%    2017601 ± 1%  TOTAL meminfo.PageTables

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      4969 ±12%     -23.7%       3792 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
      4969 ±12%     -23.7%       3792 ± 3%  TOTAL proc-vmstat.nr_mapped

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    885165 ± 2%     -23.0%     681778 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
    885165 ± 2%     -23.0%     681778 ± 3%  TOTAL numa-meminfo.node0.SReclaimable

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    221025 ± 2%     -22.6%     171160 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
    221025 ± 2%     -22.6%     171160 ± 3%  TOTAL numa-vmstat.node0.nr_slab_reclaimable

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1970 ± 3%     -22.7%       1522 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
      1970 ± 3%     -22.7%       1522 ± 3%  TOTAL proc-vmstat.nr_isolated_file

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    927295 ± 2%     -22.1%     722698 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
    927295 ± 2%     -22.1%     722698 ± 3%  TOTAL numa-meminfo.node0.Slab

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1862 ± 9%     +26.1%       2349 ± 8%  brickland3/vm-scalability/300s-lru-file-mmap-read
      1862 ± 9%     +26.1%       2349 ± 8%  TOTAL proc-vmstat.workingset_refault

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      9529 ± 3%     +29.1%      12300 ± 4%  brickland3/vm-scalability/300s-lru-file-readonce
      9529 ± 3%     +29.1%      12300 ± 4%  TOTAL proc-vmstat.numa_hint_faults_local

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    274122 ± 1%     -13.2%     237877 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
     10426 ± 3%     +36.4%      14223 ± 6%  brickland3/vm-scalability/300s-lru-file-readonce
    284549 ± 1%     -11.4%     252101 ± 2%  TOTAL proc-vmstat.numa_pte_updates

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1070 ± 3%     -19.7%        859 ± 5%  brickland3/vm-scalability/300s-lru-file-readonce
      1070 ± 3%     -19.7%        859 ± 5%  TOTAL numa-vmstat.node2.nr_mapped

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     21.64 ± 2%     +26.3%      27.33 ±10%  brickland3/vm-scalability/300s-lru-file-mmap-read
     21.64 ± 2%     +26.3%      27.33 ±10%  TOTAL perf-profile.cpu-cycles.osq_lock.__mutex_lock_slowpath.mutex_lock.rmap_walk.page_referenced

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      4577 ± 7%     -18.7%       3723 ± 8%  brickland3/vm-scalability/300s-lru-file-readonce
      4577 ± 7%     -18.7%       3723 ± 8%  TOTAL numa-meminfo.node0.Mapped

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    272410 ± 1%     -12.8%     237556 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
      9802 ± 3%     +30.2%      12761 ± 5%  brickland3/vm-scalability/300s-lru-file-readonce
    282212 ± 1%     -11.3%     250317 ± 1%  TOTAL proc-vmstat.numa_hint_faults

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   2299504 ± 0%     -19.8%    1844020 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
    106698 ± 1%      +9.9%     117221 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
   2406202 ± 0%     -18.5%    1961242 ± 2%  TOTAL cpuidle.C6-IVT-4S.usage

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 1.697e+10 ± 2%     -15.3%  1.438e+10 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
 1.697e+10 ± 2%     -15.3%  1.438e+10 ± 3%  TOTAL cpuidle.C6-IVT-4S.time

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
       467 ± 4%     -13.9%        402 ± 7%  brickland3/vm-scalability/300s-lru-file-readonce
       467 ± 4%     -13.9%        402 ± 7%  TOTAL numa-vmstat.node1.nr_isolated_file

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  23927853 ± 0%     +14.7%   27436111 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  23927853 ± 0%     +14.7%   27436111 ± 0%  TOTAL numa-vmstat.node0.nr_file_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  23897222 ± 0%     +14.5%   27361810 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  23897222 ± 0%     +14.5%   27361810 ± 0%  TOTAL numa-vmstat.node0.nr_inactive_file

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  95772318 ± 0%     +14.6%  1.098e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  95772318 ± 0%     +14.6%  1.098e+08 ± 0%  TOTAL numa-meminfo.node0.FilePages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      6248 ±42%     -41.2%       3672 ± 2%  brickland3/vm-scalability/300s-lru-file-readonce
      6248 ±42%     -41.2%       3672 ± 2%  TOTAL numa-meminfo.node1.Mapped

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  95649623 ± 0%     +14.4%  1.095e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  95649623 ± 0%     +14.4%  1.095e+08 ± 0%  TOTAL numa-meminfo.node0.Inactive(file)

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  95650669 ± 0%     +14.4%  1.095e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  95650669 ± 0%     +14.4%  1.095e+08 ± 0%  TOTAL numa-meminfo.node0.Inactive

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  97759674 ± 0%     +14.3%  1.118e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  97759674 ± 0%     +14.3%  1.118e+08 ± 0%  TOTAL numa-meminfo.node0.MemUsed

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      1637 ±46%     -43.7%        922 ± 3%  brickland3/vm-scalability/300s-lru-file-readonce
      1637 ±46%     -43.7%        922 ± 3%  TOTAL numa-vmstat.node1.nr_mapped

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  24013796 ± 0%     +14.1%   27392772 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  24013796 ± 0%     +14.1%   27392772 ± 0%  TOTAL numa-vmstat.node1.nr_inactive_file

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 3.899e+08 ± 0%     +13.8%  4.437e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 3.899e+08 ± 0%     +13.8%  4.437e+08 ± 0%  TOTAL vmstat.memory.cache

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  96127542 ± 0%     +14.0%  1.096e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  96127542 ± 0%     +14.0%  1.096e+08 ± 0%  TOTAL numa-meminfo.node1.Inactive(file)

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  96339092 ± 0%     +14.0%  1.098e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  96339092 ± 0%     +14.0%  1.098e+08 ± 0%  TOTAL numa-meminfo.node1.Inactive

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  96655792 ± 0%     +13.7%  1.099e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  96655792 ± 0%     +13.7%  1.099e+08 ± 0%  TOTAL numa-meminfo.node1.FilePages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 3.878e+08 ± 0%     +13.6%  4.406e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 3.878e+08 ± 0%     +13.6%  4.406e+08 ± 0%  TOTAL meminfo.Inactive(file)

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
 3.881e+08 ± 0%     +13.6%  4.409e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
 3.881e+08 ± 0%     +13.6%  4.409e+08 ± 0%  TOTAL meminfo.Inactive

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  3.89e+08 ± 0%     +13.6%  4.418e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  3.89e+08 ± 0%     +13.6%  4.418e+08 ± 0%  TOTAL meminfo.Cached

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  96912081 ± 0%     +13.7%  1.102e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  96912081 ± 0%     +13.7%  1.102e+08 ± 0%  TOTAL proc-vmstat.nr_inactive_file

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  97216175 ± 0%     +13.7%  1.105e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  97216175 ± 0%     +13.7%  1.105e+08 ± 0%  TOTAL proc-vmstat.nr_file_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  24145923 ± 0%     +13.8%   27478127 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  24145923 ± 0%     +13.8%   27478127 ± 0%  TOTAL numa-vmstat.node1.nr_file_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     11086 ± 1%     +12.7%      12491 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
     11086 ± 1%     +12.7%      12491 ± 1%  TOTAL proc-vmstat.nr_anon_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     44374 ± 1%     +12.6%      49965 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
     44374 ± 1%     +12.6%      49965 ± 1%  TOTAL meminfo.AnonPages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  98706688 ± 0%     +13.4%   1.12e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  98706688 ± 0%     +13.4%   1.12e+08 ± 0%  TOTAL numa-meminfo.node1.MemUsed

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      9.40 ± 2%     +12.3%      10.56 ± 9%  brickland3/vm-scalability/300s-lru-file-mmap-read
      9.40 ± 2%     +12.3%      10.56 ± 9%  TOTAL perf-profile.cpu-cycles.osq_lock.__mutex_lock_slowpath.mutex_lock.rmap_walk.try_to_unmap

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  24256827 ± 0%     +13.2%   27466497 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  24256827 ± 0%     +13.2%   27466497 ± 0%  TOTAL numa-vmstat.node3.nr_inactive_file

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     15468 ± 1%     +12.3%      17364 ± 5%  brickland3/vm-scalability/300s-lru-file-readonce
     15468 ± 1%     +12.3%      17364 ± 5%  TOTAL numa-meminfo.node2.AnonPages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  24358756 ± 0%     +13.1%   27549191 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  24358756 ± 0%     +13.1%   27549191 ± 0%  TOTAL numa-vmstat.node3.nr_file_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      3869 ± 1%     +12.2%       4340 ± 5%  brickland3/vm-scalability/300s-lru-file-readonce
      3869 ± 1%     +12.2%       4340 ± 5%  TOTAL numa-vmstat.node2.nr_anon_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  97523828 ± 0%     +13.0%  1.102e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  97523828 ± 0%     +13.0%  1.102e+08 ± 0%  TOTAL numa-meminfo.node3.FilePages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  97115503 ± 0%     +13.2%  1.099e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  97115503 ± 0%     +13.2%  1.099e+08 ± 0%  TOTAL numa-meminfo.node3.Inactive(file)

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  97126862 ± 0%     +13.1%  1.099e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  97126862 ± 0%     +13.1%  1.099e+08 ± 0%  TOTAL numa-meminfo.node3.Inactive

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  99437010 ± 0%     +12.8%  1.122e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  99437010 ± 0%     +12.8%  1.122e+08 ± 0%  TOTAL numa-meminfo.node3.MemUsed

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  97930450 ± 1%     +12.4%    1.1e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  97930450 ± 1%     +12.4%    1.1e+08 ± 0%  TOTAL numa-meminfo.node2.FilePages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  99841238 ± 1%     +12.2%   1.12e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  99841238 ± 1%     +12.2%   1.12e+08 ± 0%  TOTAL numa-meminfo.node2.MemUsed

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
       480 ± 4%     -12.8%        418 ±11%  brickland3/vm-scalability/300s-lru-file-readonce
       480 ± 4%     -12.8%        418 ±11%  TOTAL numa-vmstat.node0.nr_isolated_file

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  24468312 ± 1%     +12.4%   27504476 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  24468312 ± 1%     +12.4%   27504476 ± 0%  TOTAL numa-vmstat.node2.nr_file_pages

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  97818315 ± 1%     +12.3%  1.098e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  97818315 ± 1%     +12.3%  1.098e+08 ± 0%  TOTAL numa-meminfo.node2.Inactive

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  97767272 ± 1%     +12.3%  1.098e+08 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  97767272 ± 1%     +12.3%  1.098e+08 ± 0%  TOTAL numa-meminfo.node2.Inactive(file)

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  24427538 ± 1%     +12.3%   27435973 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  24427538 ± 1%     +12.3%   27435973 ± 0%  TOTAL numa-vmstat.node2.nr_inactive_file

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     22711 ± 3%      -9.1%      20641 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
     13218 ± 3%      +8.2%      14303 ± 1%  brickland3/vm-scalability/300s-lru-file-readonce
     35929 ± 3%      -2.7%      34945 ± 2%  TOTAL uptime.idle

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     25195 ± 0%      +6.4%      26807 ± 0%  brickland3/vm-scalability/300s-lru-file-mmap-read
     14015 ± 1%    +151.8%      35296 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
     39211 ± 0%     +58.4%      62103 ± 0%  TOTAL time.system_time

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  24713087 ± 0%     -41.3%   14517140 ± 3%  brickland3/vm-scalability/300s-lru-file-mmap-read
      4189 ± 5%     -26.0%       3099 ± 5%  brickland3/vm-scalability/300s-lru-file-readonce
  24717276 ± 0%     -41.3%   14520239 ± 3%  TOTAL time.voluntary_context_switches

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    539861 ± 1%     -23.3%     413999 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
    169833 ± 1%     +68.8%     286660 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
    709694 ± 1%      -1.3%     700660 ± 1%  TOTAL time.involuntary_context_switches

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
       403 ± 0%      -4.7%        384 ± 0%  brickland3/vm-scalability/300s-lru-file-mmap-read
       213 ± 0%     +89.5%        404 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
       616 ± 0%     +27.9%        788 ± 0%  TOTAL time.elapsed_time

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
    126881 ± 0%     -37.6%      79236 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
      2749 ± 1%     -23.8%       2095 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
    129631 ± 0%     -37.3%      81331 ± 2%  TOTAL vmstat.system.cs

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   1243406 ± 1%     -37.0%     783419 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
    114271 ± 0%     -26.0%      84537 ± 4%  brickland3/vm-scalability/300s-lru-file-readonce
   1357678 ± 1%     -36.1%     867957 ± 1%  TOTAL vmstat.system.in

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
   1620.48 ± 0%     -42.3%     935.48 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
     84.49 ± 0%     +15.3%      97.39 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
   1704.96 ± 0%     -39.4%    1032.87 ± 1%  TOTAL time.user_time

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
  70740442 ± 1%     -41.2%   41615768 ± 2%  brickland3/vm-scalability/300s-lru-file-mmap-read
    121780 ± 0%      +2.0%     124226 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
  70862223 ± 1%     -41.1%   41739994 ± 2%  TOTAL time.minor_page_faults

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
      6645 ± 0%      +8.5%       7212 ± 0%  brickland3/vm-scalability/300s-lru-file-mmap-read
      6607 ± 0%     +32.5%       8754 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
     13253 ± 0%     +20.5%      15967 ± 0%  TOTAL time.percent_of_cpu_this_job_got

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     58.13 ± 0%      +7.1%      62.24 ± 0%  brickland3/vm-scalability/300s-lru-file-mmap-read
     55.30 ± 0%     +33.7%      73.95 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
    113.43 ± 0%     +20.1%     136.19 ± 0%  TOTAL turbostat.%c0

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
       334 ± 1%      +5.4%        353 ± 0%  brickland3/vm-scalability/300s-lru-file-mmap-read
       280 ± 0%     +19.6%        335 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
       615 ± 1%     +11.9%        688 ± 0%  TOTAL turbostat.Cor_W

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
     89.53 ± 0%     -10.2%      80.43 ± 0%  brickland3/vm-scalability/300s-lru-file-mmap-read
     95.97 ± 0%     -11.2%      85.22 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
    185.50 ± 0%     -10.7%     165.64 ± 0%  TOTAL turbostat.RAM_W

24b7e5819ad5cbe  3484b2de9499df23c4604a513  
---------------  -------------------------  
       407 ± 1%      +4.2%        424 ± 0%  brickland3/vm-scalability/300s-lru-file-mmap-read
       353 ± 0%     +15.3%        407 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
       760 ± 0%      +9.3%        831 ± 0%  TOTAL turbostat.Pkg_W


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Fengguang

--PNTmBPCT7hxwcZjr
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
./case-lru-file-mmap-read
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-1 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-1 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-2 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-2 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-3 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-3 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-4 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-5 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-4 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-5 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-6 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-6 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-7 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-7 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-8 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-9 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-8 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-9 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-10 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-11 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-10 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-11 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-12 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-13 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-12 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-13 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-14 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-15 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-14 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-15 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-16 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-16 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-17 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-18 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-17 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-18 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-19 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-19 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-20 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-20 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-21 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-21 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-22 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-22 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-23 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-23 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-24 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-24 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-25 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-25 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-26 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-26 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-27 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-27 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-28 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-28 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-29 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-29 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-30 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-30 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-31 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-31 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-32 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-32 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-33 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-33 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-34 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-35 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-34 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-35 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-36 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-36 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-37 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-37 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-38 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-38 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-39 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-39 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-40 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-41 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-40 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-41 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-42 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-42 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-43 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-43 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-44 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-44 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-45 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-45 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-46 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-47 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-46 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-47 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-48 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-48 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-49 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-49 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-50 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-50 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-51 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-51 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-52 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-52 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-53 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-53 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-54 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-54 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-55 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-55 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-56 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-56 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-57 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-57 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-58 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-58 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-59 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-60 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-59 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-60 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-61 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-61 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-62 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-62 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-63 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-64 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-63 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-64 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-65 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-66 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-65 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-66 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-67 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-67 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-68 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-68 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-69 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-69 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-70 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-70 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-71 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-71 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-72 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-73 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-72 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-74 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-73 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-75 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-74 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-75 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-76 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-76 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-77 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-78 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-77 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-78 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-79 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-79 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-80 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-80 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-81 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-81 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-82 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-82 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-83 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-84 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-83 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-84 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-85 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-86 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-85 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-86 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-87 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-88 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-87 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-89 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-88 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-89 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-90 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-91 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-90 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-91 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-92 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-92 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-93 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-93 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-94 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-95 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-94 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-95 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-96 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-96 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-97 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-97 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-98 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-98 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-99 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-100 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-99 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-100 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-101 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-101 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-102 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-102 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-103 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-104 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-103 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-105 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-104 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-105 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-106 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-106 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-107 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-108 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-107 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-108 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-109 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-109 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-110 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-110 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-111 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-112 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-111 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-112 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-113 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-113 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-114 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-114 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-115 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-115 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-116 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-116 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-117 -s 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-118 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-117 --readonly 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-118 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-119 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-119 --readonly 36650387592
truncate /tmp/vm-scalability/sparse-lru-file-mmap-read-120 -s 36650387592
./usemem --runtime 300 -f /tmp/vm-scalability/sparse-lru-file-mmap-read-120 --readonly 36650387592
umount /tmp/vm-scalability-tmp
umount /tmp/vm-scalability
rm /tmp/vm-scalability.img

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--PNTmBPCT7hxwcZjr--
