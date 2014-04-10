Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030857AbaDJNHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:07:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:58905 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030583AbaDJNHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:07:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,834,1389772800"; 
   d="scan'208";a="510886846"
Date: Thu, 10 Apr 2014 21:05:52 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        lkp@01.org
Subject: Re: [writeback] 6903673566d: +2.5% fileio.requests_per_sec
Message-ID: <20140410130552.GA17871@localhost>
References: <20140410124137.GA17720@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410124137.GA17720@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 08:41:37PM +0800, Fengguang Wu wrote:
> Hi Jan,
> 
> I tried your writeback dirty list patchset and noticed some ups/downs.
> The main performance changes are
> 
> 1) +2.5% fileio.requests_per_sec
> 2) -7.1% iostat.md0.wkB/s
> 
> git://bee.sh.intel.com/git/wfg/linux-devel.git jan-dirty-list
> commit 6903673566d0289680e593dac088c787d119b067 ("writeback: Replace several writeback lists with inode tagging")
> 
> 836ecc5f024669e  6903673566d0289680e593dac  
> ---------------  -------------------------  
>       6526 ~ 0%      +3.2%       6736 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
>       6441 ~ 0%      +1.8%       6558 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
>      12968 ~ 0%      +2.5%      13295 ~ 0%  TOTAL fileio.requests_per_sec
> 
> 836ecc5f024669e  6903673566d0289680e593dac  
> ---------------  -------------------------  
>     398147 ~ 0%      -7.1%     369866 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
>     398147 ~ 0%      -7.1%     369866 ~ 0%  TOTAL iostat.md0.wkB/s
> 

Here are the changed stats before/after the patchset:

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     58.98 ~102%     -73.2%      15.78       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
   2215.64 ~61%     -69.2%     682.57       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqrewr-sync
    185.22 ~132%     -93.6%      11.80       snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-rndwr-sync
   2459.84 ~67%     -71.1%     710.15       TOTAL fileio.request_latency_max_ms

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      6251 ~ 0%      +4.0%       6503       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqrewr-sync
      6532 ~ 0%      +3.2%       6737 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
      6444 ~ 0%      +1.7%       6554 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
     19227 ~ 0%      +3.0%      19795       TOTAL fileio.requests_per_sec

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    106344 ~ 0%  +19150.1%   20471397 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
    106344 ~ 0%  +19150.1%   20471397 ~ 0%  TOTAL proc-vmstat.numa_local

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
         0 ~ 0%      +Inf%          5       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-1dd
         0 ~ 0%      +Inf%          5       TOTAL ftrace.balance_dirty_pages.md0.period

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       301 ~ 0%     -95.4%         14       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-10dd
       299 ~ 0%     -95.0%         15       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       600 ~ 0%     -95.2%         29       TOTAL ftrace.writeback_single_inode.md0.age

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     11335 ~24%   +1627.5%     195821       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
     11335 ~24%   +1627.5%     195821       TOTAL numa-vmstat.node1.numa_other

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    126591 ~ 4%     -88.2%      14928       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
    126591 ~ 4%     -88.2%      14928       TOTAL numa-vmstat.node0.numa_other

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
         6 ~37%  +4.5e+08%   28490268       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
         6 ~37%  +4.5e+08%   28490268       TOTAL ftrace.balance_dirty_pages.sdj.think

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        27 ~ 8%    -1e+08%  -28490233       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
        27 ~ 8%    -1e+08%  -28490233       TOTAL ftrace.balance_dirty_pages.sdj.pause

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        60 ~24%  +15775.8%       9541 ~ 4%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
        60 ~24%  +15775.8%       9541 ~ 4%  TOTAL numa-vmstat.node1.nr_vmscan_immediate_reclaim

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        38 ~27%  +19600.4%       7584 ~ 3%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
        38 ~27%  +19600.4%       7584 ~ 3%  TOTAL numa-vmstat.node0.nr_vmscan_immediate_reclaim

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       113 ~12%  +45711.4%      51812 ~ 7%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       398 ~38%   +4145.0%      16912       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-1dd
       511 ~32%  +13335.9%      68724       TOTAL proc-vmstat.nr_vmscan_immediate_reclaim

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
         0 ~ 0%      +Inf%          7       brickland1/micro/will-it-scale/eventfd1
         0 ~ 0%      +Inf%          8       brickland1/micro/will-it-scale/malloc1
         0 ~ 0%      +Inf%         15       TOTAL numa-numastat.node3.other_node

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     43206 ~ 3%   +1379.5%     639229 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
     43206 ~ 3%   +1379.5%     639229 ~ 0%  TOTAL meminfo.Committed_AS

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       336 ~ 8%  +79377.7%     267363 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
       336 ~ 8%  +79377.7%     267363 ~ 0%  TOTAL meminfo.Shmem

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     19923 ~ 1%    +853.4%     189946 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
     19923 ~ 1%    +853.4%     189946 ~ 0%  TOTAL meminfo.AnonPages

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       113 ~14%  +18974.6%      21726 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
       113 ~14%  +18974.6%      21726 ~ 0%  TOTAL meminfo.Inactive(anon)

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     19815 ~ 0%   +2095.6%     435053 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
     19815 ~ 0%   +2095.6%     435053 ~ 0%  TOTAL meminfo.Active(anon)

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    139663 ~ 0%  +15894.2%   22338086 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
    139663 ~ 0%  +15894.2%   22338086 ~ 0%  TOTAL proc-vmstat.pgfault

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     42303 ~ 0%  +48170.1%   20419931 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
     42303 ~ 0%  +48170.1%   20419931 ~ 0%  TOTAL proc-vmstat.pgfree

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     53623 ~ 1%  +19416.6%   10465479 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
     53623 ~ 1%  +19416.6%   10465479 ~ 0%  TOTAL proc-vmstat.pgalloc_normal

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    106344 ~ 0%  +19150.1%   20471397 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
    106344 ~ 0%  +19150.1%   20471397 ~ 0%  TOTAL proc-vmstat.numa_hit

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        21 ~12%    +415.6%        112 ~ 2%  nhm-white/sysbench/oltp/600s-100%-1000000
        21 ~12%    +415.6%        112 ~ 2%  TOTAL proc-vmstat.nr_written

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        83 ~ 8%  +79558.4%      66833 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
        83 ~ 8%  +79558.4%      66833 ~ 0%  TOTAL proc-vmstat.nr_shmem

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      4962 ~ 1%    +856.9%      47485 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      4962 ~ 1%    +856.9%      47485 ~ 0%  TOTAL proc-vmstat.nr_anon_pages

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      0.19 ~ 0%    -100.0%       0.00       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
      0.19 ~ 0%    -100.0%       0.00       TOTAL turbostat.GFX_W

(note: some turbostat stats are missing due to unreliable MSR reading)

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      4916 ~ 0%   +2112.4%     108762 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      4916 ~ 0%   +2112.4%     108762 ~ 0%  TOTAL proc-vmstat.nr_active_anon

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        28 ~15%  +19204.6%       5424 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
        28 ~15%  +19204.6%       5424 ~ 0%  TOTAL proc-vmstat.nr_inactive_anon

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
         0 ~ 0%      +Inf%          8 ~ 5%  nhm-white/sysbench/oltp/600s-100%-1000000
         0 ~ 0%      +Inf%          8 ~ 5%  TOTAL vmstat.procs.r

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
         6 ~41%  +7.1e+08%   43733639 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
         6 ~41%  +7.1e+08%   43733639 ~ 0%  TOTAL interrupts.TLB

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        54 ~ 9%  +6.4e+10%  3.436e+10 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
        54 ~ 9%  +6.4e+10%  3.436e+10 ~ 0%  TOTAL interrupts.CAL

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        82 ~15%  +5.5e+05%     454099 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
        82 ~15%  +5.5e+05%     454099 ~ 0%  TOTAL interrupts.LOC

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        25 ~39%    +6e+05%     151016 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
        25 ~39%    +6e+05%     151016 ~ 0%  TOTAL interrupts.44:HPET_MSI-edge.hpet6

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        35 ~42%  +4.3e+05%     151755 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
        35 ~42%  +4.3e+05%     151755 ~ 0%  TOTAL interrupts.43:HPET_MSI-edge.hpet5

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
         0 ~282%    -100.0%          0       lkp-a04/micro/netperf/300s-200%-UDP_RR
         0 ~282%    -100.0%          0       TOTAL last_state.is_incomplete_run

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        28 ~33%  +5.3e+05%     151455 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
        28 ~33%  +5.3e+05%     151455 ~ 0%  TOTAL interrupts.41:HPET_MSI-edge.hpet3

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        26 ~49%  +5.7e+05%     151608 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
        26 ~49%  +5.7e+05%     151608 ~ 0%  TOTAL interrupts.40:HPET_MSI-edge.hpet2

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1113 ~ 3%   +1427.7%      17015 ~15%  nhm-white/sysbench/oltp/600s-100%-1000000
      1113 ~ 3%   +1427.7%      17015 ~15%  TOTAL cpuidle.C6-NHM.usage

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   7250695 ~ 3%   +1121.2%   88543500 ~ 5%  nhm-white/sysbench/oltp/600s-100%-1000000
   7250695 ~ 3%   +1121.2%   88543500 ~ 5%  TOTAL cpuidle.C6-NHM.time

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       462 ~13%  +16780.7%      78140 ~ 8%  nhm-white/sysbench/oltp/600s-100%-1000000
       462 ~13%  +16780.7%      78140 ~ 8%  TOTAL cpuidle.C3-NHM.usage

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    353107 ~24%   +1136.1%    4364750 ~ 6%  nhm-white/sysbench/oltp/600s-100%-1000000
    353107 ~24%   +1136.1%    4364750 ~ 6%  TOTAL cpuidle.C3-NHM.time

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1.61 ~ 0%    -100.0%       0.00       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
      1.61 ~ 0%    -100.0%       0.00       TOTAL turbostat.GHz

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      3.31 ~ 0%    -100.0%       0.00       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
      3.31 ~ 0%    -100.0%       0.00       TOTAL turbostat.TSC

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      5.51 ~24%     -99.3%       0.04 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      2.54 ~ 4%    -100.0%       0.00       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
      8.05 ~17%     -99.5%       0.04       TOTAL turbostat.%c3

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     79.94 ~ 7%     -98.2%       1.40 ~ 7%  nhm-white/sysbench/oltp/600s-100%-1000000
     87.61 ~ 0%    -100.0%       0.00       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
    167.55 ~ 3%     -99.2%       1.40       TOTAL turbostat.%c6

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      7.01 ~ 4%    -100.0%       0.00       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
      7.01 ~ 4%    -100.0%       0.00       TOTAL turbostat.%pc3

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     57.83 ~ 1%    -100.0%       0.00       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
     57.83 ~ 1%    -100.0%       0.00       TOTAL turbostat.%pc6

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     18.12 ~15%   +3374.7%     629.51 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
     18.12 ~15%   +3374.7%     629.51 ~ 0%  TOTAL uptime.boot

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      4629 ~15%  +12872.8%     600509 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      4629 ~15%  +12872.8%     600509 ~ 0%  TOTAL softirqs.TIMER

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   1142757 ~33%   +2328.9%   27756867       grantley/micro/kbuild/200%
   1142757 ~33%   +2328.9%   27756867       TOTAL cpuidle.C1E-HSW.time

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     13345 ~ 0%     -59.6%       5397 ~ 9%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      4117 ~ 2%     -89.9%        416       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-1dd
     17462 ~ 0%     -66.7%       5813       TOTAL proc-vmstat.pgpgin

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      4.05 ~ 0%     +17.7%       4.77       lkp-snb01/micro/hackbench/50%-process-socket
      7.83 ~36%     -89.0%       0.86 ~ 7%  nhm-white/sysbench/oltp/600s-100%-1000000
      8.13 ~ 2%    -100.0%       0.00       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
     20.01 ~15%     -71.9%       5.63       TOTAL turbostat.%c1

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    289344 ~ 0%     -28.0%     208207       brickland1/micro/will-it-scale/malloc1
      1935 ~34%   +1407.6%      29173 ~ 1%  nhm-white/sysbench/oltp/600s-100%-1000000
    291279 ~ 1%     -18.5%     237380       TOTAL softirqs.SCHED

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     10714 ~ 2%     +35.8%      14547       lkp-snb01/micro/hackbench/50%-threads-socket
     10714 ~ 2%     +35.8%      14547       TOTAL cpuidle.POLL.time

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1458 ~ 0%    +245.6%       5041 ~ 5%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       964 ~ 6%    +181.8%       2717       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-1dd
      2423 ~ 2%    +220.2%       7758       TOTAL meminfo.Buffers

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1464 ~ 0%    +243.8%       5033 ~ 5%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       963 ~ 6%    +181.9%       2715       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-1dd
      2427 ~ 2%    +219.2%       7748       TOTAL vmstat.memory.buff

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   1678626 ~ 1%     -16.8%    1396961       lkp-snb01/micro/hackbench/50%-threads-socket
     53471 ~ 1%  +18655.2%   10028644 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
   1732097 ~ 1%    +559.6%   11425605       TOTAL proc-vmstat.pgalloc_dma32

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    276111 ~ 0%    +189.1%     798315 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
    276111 ~ 0%    +189.1%     798315 ~ 0%  TOTAL meminfo.Active

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        40 ~13%    +199.8%        121 ~ 4%  nhm-white/sysbench/oltp/600s-100%-1000000
        40 ~13%    +199.8%        121 ~ 4%  TOTAL proc-vmstat.nr_dirtied

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1444 ~ 4%     -64.6%        512       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
      1444 ~ 4%     -64.6%        512       TOTAL proc-vmstat.slabs_scanned

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   3433682 ~ 3%     +76.1%    6047439       brickland1/micro/will-it-scale/context_switch1
 2.281e+08 ~ 0%     -26.5%  1.676e+08       lkp-snb01/micro/hackbench/50%-process-socket
        42 ~42%  +5.9e+05%     250922 ~ 8%  nhm-white/sysbench/oltp/600s-100%-1000000
 2.315e+08 ~ 0%     -24.9%  1.739e+08       TOTAL interrupts.RES

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      6509 ~ 1%    +122.8%      14502 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      6509 ~ 1%    +122.8%      14502 ~ 0%  TOTAL meminfo.Mapped

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1624 ~ 1%    +123.0%       3622 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      1624 ~ 1%    +123.0%       3622 ~ 0%  TOTAL proc-vmstat.nr_mapped

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     60148 ~ 0%    +119.0%     131746 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
     60148 ~ 0%    +119.0%     131746 ~ 0%  TOTAL proc-vmstat.pgactivate

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1299 ~ 0%    +113.1%       2770       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
      1299 ~ 0%    +113.1%       2770       TOTAL slabinfo.inode_cache.num_slabs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1299 ~ 0%    +113.1%       2770       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
      1299 ~ 0%    +113.1%       2770       TOTAL slabinfo.inode_cache.active_slabs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     36400 ~ 0%    +113.1%      77568       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
     36400 ~ 0%    +113.1%      77568       TOTAL slabinfo.inode_cache.active_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     36400 ~ 0%    +113.1%      77568       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
     36400 ~ 0%    +113.1%      77568       TOTAL slabinfo.inode_cache.num_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       871 ~ 3%    +111.9%       1847 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       871 ~ 3%    +111.9%       1847 ~ 1%  TOTAL slabinfo.journal_head.num_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       871 ~ 3%    +111.9%       1847 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       871 ~ 3%    +111.9%       1847 ~ 1%  TOTAL slabinfo.journal_head.active_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1004 ~ 1%     +98.2%       1992       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
      1004 ~ 1%     +98.2%       1992       TOTAL slabinfo.blkdev_ioc.active_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1004 ~ 1%     +98.2%       1992       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
      1004 ~ 1%     +98.2%       1992       TOTAL slabinfo.blkdev_ioc.num_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     52985 ~ 1%     +78.1%      94356       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
     52985 ~ 1%     +78.1%      94356       TOTAL slabinfo.dentry.active_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1310 ~ 2%     +74.6%       2288       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
      1310 ~ 2%     +74.6%       2288       TOTAL slabinfo.dentry.num_slabs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1310 ~ 2%     +74.6%       2288       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
      1310 ~ 2%     +74.6%       2288       TOTAL slabinfo.dentry.active_slabs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     55053 ~ 2%     +74.6%      96103       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
     55053 ~ 2%     +74.6%      96103       TOTAL slabinfo.dentry.num_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     77560 ~ 0%     +57.2%     121943       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
     77560 ~ 0%     +57.2%     121943       TOTAL numa-vmstat.node0.numa_interleave

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    443786 ~ 1%     +56.2%     693171       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
    443786 ~ 1%     +56.2%     693171       TOTAL numa-meminfo.node0.Unevictable

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    110946 ~ 1%     +56.2%     173293       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
    110946 ~ 1%     +56.2%     173293       TOTAL numa-vmstat.node0.nr_unevictable

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    888585 ~ 0%     +56.9%    1394516       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
    888585 ~ 0%     +56.9%    1394516       TOTAL meminfo.Unevictable

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    222138 ~ 0%     +56.9%     348629       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
    222138 ~ 0%     +56.9%     348629       TOTAL proc-vmstat.nr_unevictable

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    111193 ~ 1%     +57.7%     175319       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
    111193 ~ 1%     +57.7%     175319       TOTAL numa-vmstat.node1.nr_unevictable

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    444788 ~ 1%     +57.7%     701278       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
    444788 ~ 1%     +57.7%     701278       TOTAL numa-meminfo.node1.Unevictable

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    228867 ~ 0%     +56.8%     358782       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
    228867 ~ 0%     +56.8%     358782       TOTAL proc-vmstat.unevictable_pgs_culled

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    118645 ~ 0%     +56.0%     185035       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
    118645 ~ 0%     +56.0%     185035       TOTAL numa-vmstat.node1.numa_interleave

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    806025 ~ 0%     -32.0%     548209 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
    806025 ~ 0%     -32.0%     548209 ~ 0%  TOTAL meminfo.Inactive(file)

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    201314 ~ 0%     -31.9%     137056 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
    201314 ~ 0%     -31.9%     137056 ~ 0%  TOTAL proc-vmstat.nr_inactive_file

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     62735 ~ 0%     +44.8%      90811 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
     62735 ~ 0%     +44.8%      90811 ~ 0%  TOTAL proc-vmstat.nr_active_file

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    256295 ~ 0%     +41.7%     363261 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
    256295 ~ 0%     +41.7%     363261 ~ 0%  TOTAL meminfo.Active(file)

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    806139 ~ 0%     -29.3%     569936 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
    806139 ~ 0%     -29.3%     569936 ~ 0%  TOTAL meminfo.Inactive

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    501575 ~ 1%     +34.8%     676169       lkp-snb01/micro/hackbench/50%-process-socket
    501575 ~ 1%     +34.8%     676169       TOTAL cpuidle.C7-SNB.usage

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      7712 ~ 0%     -25.4%       5753       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
      7712 ~ 0%     -25.4%       5753       TOTAL ftrace.writeback_single_inode.sdh.wrote

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      7721 ~ 1%     -25.6%       5746       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
      7721 ~ 1%     -25.6%       5746       TOTAL ftrace.writeback_single_inode.sdn.wrote

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      7669 ~ 0%     -24.2%       5817       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
      7669 ~ 0%     -24.2%       5817       TOTAL ftrace.writeback_single_inode.sdk.wrote

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      7732 ~ 1%     -23.9%       5885       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
      7732 ~ 1%     -23.9%       5885       TOTAL ftrace.writeback_single_inode.sdd.wrote

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       735 ~ 2%     +33.6%        982 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       735 ~ 2%     +33.6%        982 ~ 2%  TOTAL slabinfo.dquot.active_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       735 ~ 2%     +33.6%        982 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       735 ~ 2%     +33.6%        982 ~ 2%  TOTAL slabinfo.dquot.num_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1258 ~ 7%     +34.6%       1693 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      1258 ~ 7%     +34.6%       1693 ~ 0%  TOTAL meminfo.KernelStack

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      6582 ~ 0%     -23.1%       5061       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
      6582 ~ 0%     -23.1%       5061       TOTAL ftrace.writeback_single_inode.sdf.wrote

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      6573 ~ 0%     -22.9%       5067       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
      6573 ~ 0%     -22.9%       5067       TOTAL ftrace.writeback_single_inode.sde.wrote

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
  79778955 ~ 0%     +11.3%   88774228       lkp-snb01/micro/hackbench/50%-process-pipe
  7.14e+08 ~ 0%     +18.3%  8.445e+08       lkp-snb01/micro/hackbench/50%-process-socket
 2.796e+08 ~ 4%     +53.7%  4.299e+08       lkp-snb01/micro/hackbench/50%-threads-socket
 1.073e+09 ~ 1%     +27.0%  1.363e+09       TOTAL cpuidle.C1-SNB.time

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      7710 ~ 0%     -22.8%       5952       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
      7710 ~ 0%     -22.8%       5952       TOTAL ftrace.writeback_single_inode.sdg.wrote

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      6937 ~ 1%     -22.5%       5376       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
      6937 ~ 1%     -22.5%       5376       TOTAL slabinfo.kmalloc-32.num_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      6937 ~ 1%     -22.5%       5376       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
      6937 ~ 1%     -22.5%       5376       TOTAL slabinfo.kmalloc-32.active_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      6584 ~ 1%     -21.9%       5146       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
      6584 ~ 1%     -21.9%       5146       TOTAL ftrace.writeback_single_inode.sdl.wrote

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     50448 ~ 0%     -20.6%      40041       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     50448 ~ 0%     -20.6%      40041       TOTAL ftrace.writeback_single_inode.md0.wrote

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      7808 ~ 0%     -14.8%       6654       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      7695 ~ 1%     -25.5%       5735       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
     15503 ~ 0%     -20.1%      12389       TOTAL ftrace.writeback_single_inode.sdj.wrote

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
  88970623 ~ 0%     +11.6%   99315909       lkp-snb01/micro/hackbench/50%-process-socket
   7645226 ~ 0%     +13.0%    8638062       lkp-snb01/micro/hackbench/50%-threads-pipe
  41232102 ~ 3%     +49.6%   61702366       lkp-snb01/micro/hackbench/50%-threads-socket
 137847952 ~ 1%     +23.1%  169656337       TOTAL cpuidle.C1-SNB.usage

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     68788 ~ 0%     +25.6%      86413       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
     68788 ~ 0%     +25.6%      86413       TOTAL slabinfo.radix_tree_node.active_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   5193355 ~ 0%     -20.2%    4145155       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-100dd
   5193355 ~ 0%     -20.2%    4145155       TOTAL meminfo.DirectMap2M

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      2525 ~ 0%     +25.0%       3156       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
      2525 ~ 0%     +25.0%       3156       TOTAL slabinfo.radix_tree_node.num_slabs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      2525 ~ 0%     +25.0%       3156       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
      2525 ~ 0%     +25.0%       3156       TOTAL slabinfo.radix_tree_node.active_slabs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     70733 ~ 0%     +24.9%      88377       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-100dd
     70733 ~ 0%     +24.9%      88377       TOTAL slabinfo.radix_tree_node.num_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      9212 ~ 0%     +22.2%      11259       lkp-snb01/micro/hackbench/50%-threads-socket
      9212 ~ 0%     +22.2%      11259       TOTAL slabinfo.anon_vma.num_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      9212 ~ 0%     +22.2%      11259       lkp-snb01/micro/hackbench/50%-threads-socket
      9212 ~ 0%     +22.2%      11259       TOTAL slabinfo.anon_vma.active_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   2938608 ~ 0%     -11.3%    2606174       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-10dd
   3037554 ~ 0%     -19.1%    2457633       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
   5976162 ~ 0%     -15.3%    5063807       TOTAL ftrace.writeback_single_inode.md0.index

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1696 ~ 0%     +17.8%       1999       lkp-snb01/micro/hackbench/50%-process-pipe
      1696 ~ 0%     +17.8%       1999       TOTAL numa-meminfo.node0.KernelStack

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     18537 ~ 1%     +16.1%      21522       lkp-snb01/micro/hackbench/50%-threads-socket
     18537 ~ 1%     +16.1%      21522       TOTAL slabinfo.kmalloc-512.num_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      3290 ~ 1%     +16.9%       3848       lkp-snb01/micro/hackbench/50%-threads-pipe
      3290 ~ 1%     +16.9%       3848       TOTAL numa-vmstat.node0.nr_active_anon

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     13163 ~ 1%     +16.9%      15393       lkp-snb01/micro/hackbench/50%-threads-pipe
     13163 ~ 1%     +16.9%      15393       TOTAL numa-meminfo.node0.Active(anon)

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     19720 ~ 1%     +15.3%      22730       lkp-snb01/micro/hackbench/50%-threads-socket
     19720 ~ 1%     +15.3%      22730       TOTAL slabinfo.kmalloc-256.num_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   3393952 ~ 0%     -14.0%    2917652       lkp-snb01/micro/hackbench/50%-threads-socket
   3393952 ~ 0%     -14.0%    2917652       TOTAL numa-numastat.node0.local_node

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   3396723 ~ 0%     -14.0%    2921810       lkp-snb01/micro/hackbench/50%-threads-socket
   3396723 ~ 0%     -14.0%    2921810       TOTAL numa-numastat.node0.numa_hit

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     13388 ~ 0%     +14.3%      15306       lkp-snb01/micro/hackbench/50%-threads-socket
     13388 ~ 0%     +14.3%      15306       TOTAL slabinfo.kmalloc-512.active_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   1033631 ~ 0%     +14.2%    1180789 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
   1033631 ~ 0%     +14.2%    1180789 ~ 0%  TOTAL vmstat.memory.cache

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1.00 ~ 0%     +13.6%       1.14       lkp-snb01/micro/hackbench/50%-process-pipe
      1.00 ~ 0%     +13.6%       1.14       TOTAL perf-profile.cpu-cycles._raw_spin_lock_irq.__schedule.schedule.pipe_wait.pipe_read

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     14401 ~ 0%     +13.2%      16307       lkp-snb01/micro/hackbench/50%-threads-socket
     14401 ~ 0%     +13.2%      16307       TOTAL slabinfo.kmalloc-256.active_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    264650 ~ 0%     +11.6%     295224 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
    264650 ~ 0%     +11.6%     295224 ~ 0%  TOTAL proc-vmstat.nr_file_pages

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   1064719 ~ 0%     +10.9%    1180924 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
   1064719 ~ 0%     +10.9%    1180924 ~ 0%  TOTAL meminfo.Cached

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1812 ~ 0%     +10.8%       2008       lkp-snb01/micro/hackbench/50%-threads-pipe
      1812 ~ 0%     +10.8%       2008       TOTAL slabinfo.shmem_inode_cache.num_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1812 ~ 0%     +10.8%       2008       lkp-snb01/micro/hackbench/50%-threads-pipe
      1812 ~ 0%     +10.8%       2008       TOTAL slabinfo.shmem_inode_cache.active_objs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    160064 ~ 0%      -9.6%     144705       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
    160064 ~ 0%      -9.6%     144705       TOTAL ftrace.global_dirty_state.writeback

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    636193 ~ 0%      -9.3%     577223       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
    636193 ~ 0%      -9.3%     577223       TOTAL meminfo.Writeback

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    159052 ~ 0%      -9.3%     144320       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
    159052 ~ 0%      -9.3%     144320       TOTAL proc-vmstat.nr_writeback

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     22706 ~ 0%     +10.0%      24983       lkp-snb01/micro/hackbench/50%-process-pipe
     22706 ~ 0%     +10.0%      24983       TOTAL numa-meminfo.node0.SUnreclaim

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      0.12 ~ 2%    +3e+05%     357.41 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      0.12 ~ 2%    +3e+05%     357.41 ~ 0%  TOTAL time.system_time

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      5.17 ~ 1%    -100.0%       0.00       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
      5.17 ~ 1%    -100.0%       0.00       TOTAL turbostat.Pkg_W

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1.30 ~ 1%    -100.0%       0.00       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
      1.30 ~ 1%    -100.0%       0.00       TOTAL turbostat.Cor_W

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    845987 ~24%  +1.5e+05%  1.281e+09       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-xfs-10dd
    845987 ~24%  +1.5e+05%  1.281e+09       TOTAL perf-stat.L1-dcache-prefetch-misses

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      0.18 ~ 0%  +3.4e+05%     612.05 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      0.18 ~ 0%  +3.4e+05%     612.05 ~ 0%  TOTAL time.elapsed_time

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      6.72 ~42%   +1353.6%      97.70 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
      1.73 ~ 0%    -100.0%       0.00       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
      8.45 ~34%   +1056.6%      97.70       TOTAL turbostat.%c0

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     23955 ~ 0%     -66.3%       8066 ~13%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
     23955 ~ 0%     -66.3%       8066 ~13%  TOTAL time.file_system_inputs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   2426126 ~ 0%     -20.0%    1941432       lkp-snb01/micro/hackbench/50%-process-socket
      1874 ~ 0%  +15303.7%     288711 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
   2428000 ~ 0%      -8.1%    2230143       TOTAL vmstat.system.cs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   1331.09 ~ 0%      -5.7%    1255.69       lkp-snb01/micro/hackbench/50%-threads-pipe
      0.01 ~35%  +3.7e+06%     476.24 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
   1331.10 ~ 0%     +30.1%    1731.93       TOTAL time.user_time

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
 1.059e+09 ~ 0%     -20.5%  8.416e+08       lkp-snb01/micro/hackbench/50%-process-socket
 3.665e+09 ~ 0%      -5.3%  3.469e+09       lkp-snb01/micro/hackbench/50%-threads-pipe
      3313 ~ 1%     -60.9%       1295 ~ 6%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      1044 ~ 2%     -88.4%        121       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-1dd
       158 ~ 1%  +5.5e+07%   86532136 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
 4.724e+09 ~ 0%      -6.9%  4.397e+09       TOTAL time.voluntary_context_switches

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    389237 ~ 1%     -25.8%     288888       lkp-snb01/micro/hackbench/50%-process-socket
    799364 ~ 1%     -20.1%     638935       lkp-snb01/micro/hackbench/50%-threads-socket
       301 ~12%  +24385.9%      73727 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
   1188902 ~ 1%     -15.8%    1001550       TOTAL vmstat.system.in

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       542 ~ 1%     +88.6%       1023 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       542 ~ 1%     +88.6%       1023 ~ 1%  TOTAL iostat.sdc.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       128 ~ 1%     +88.5%        242 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       128 ~ 1%     +88.5%        242 ~ 1%  TOTAL iostat.sdc.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       129 ~ 3%     +86.3%        240 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       129 ~ 3%     +86.3%        240 ~ 1%  TOTAL iostat.sdb.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       544 ~ 3%     +86.4%       1015 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       544 ~ 3%     +86.4%       1015 ~ 1%  TOTAL iostat.sdb.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       556 ~ 2%     +83.0%       1018 ~ 3%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       556 ~ 2%     +83.0%       1018 ~ 3%  TOTAL iostat.sdi.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       131 ~ 2%     +82.7%        241 ~ 3%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       131 ~ 2%     +82.7%        241 ~ 3%  TOTAL iostat.sdi.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
        76 ~ 1%     +78.4%        135 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
        76 ~ 1%     +78.4%        135 ~ 0%  TOTAL time.percent_of_cpu_this_job_got

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       129 ~ 2%     +87.0%        241 ~ 2%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       152 ~ 1%     +44.2%        219       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       281 ~ 2%     +63.8%        460       TOTAL iostat.sdf.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       545 ~ 2%     +87.0%       1020 ~ 2%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       650 ~ 1%     +43.7%        935       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      1196 ~ 2%     +63.4%       1955       TOTAL iostat.sdf.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       551 ~ 2%     +89.1%       1042 ~ 2%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      1359 ~ 0%     +29.5%       1760       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      1910 ~ 1%     +46.7%       2803       TOTAL iostat.sdk.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       130 ~ 2%     +89.0%        246 ~ 2%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       321 ~ 0%     +29.7%        416       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       451 ~ 1%     +46.8%        663       TOTAL iostat.sdk.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       129 ~ 3%     +86.6%        240 ~ 2%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       320 ~ 1%     +29.6%        415       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       449 ~ 1%     +46.0%        656       TOTAL iostat.sdl.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       544 ~ 3%     +86.8%       1018 ~ 2%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      1357 ~ 1%     +29.4%       1756       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      1902 ~ 1%     +45.9%       2774       TOTAL iostat.sdl.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       126 ~ 2%     +90.0%        240 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       316 ~ 1%     +33.6%        422       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       151 ~ 1%     +46.5%        221       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       594 ~ 1%     +48.9%        884       TOTAL iostat.sde.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       535 ~ 2%     +90.1%       1017 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      1339 ~ 1%     +33.4%       1786       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       647 ~ 1%     +45.9%        943       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      2521 ~ 1%     +48.6%       3747       TOTAL iostat.sde.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       127 ~ 1%     +90.7%        243 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       318 ~ 1%     +30.1%        414       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       155 ~ 2%     +45.2%        225       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       601 ~ 1%     +46.9%        882       TOTAL iostat.sdd.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       131 ~ 2%     +88.6%        247 ~ 3%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       318 ~ 1%     +31.0%        416       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       156 ~ 2%     +43.7%        224       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       605 ~ 1%     +46.7%        888       TOTAL iostat.sdj.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       538 ~ 2%     +90.7%       1028 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      1348 ~ 1%     +29.9%       1752       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       663 ~ 2%     +44.6%        959       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      2551 ~ 1%     +46.6%       3739       TOTAL iostat.sdd.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       553 ~ 2%     +88.8%       1044 ~ 3%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      1346 ~ 1%     +30.8%       1762       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       666 ~ 2%     +43.1%        953       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      2566 ~ 1%     +46.5%       3760       TOTAL iostat.sdj.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       131 ~ 3%     +83.3%        241 ~ 3%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       317 ~ 1%     +32.7%        420       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       154 ~ 1%     +44.2%        222       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       602 ~ 2%     +46.7%        884       TOTAL iostat.sdg.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       555 ~ 3%     +83.4%       1018 ~ 3%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      1343 ~ 1%     +32.5%       1779       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       658 ~ 1%     +43.8%        946       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      2557 ~ 1%     +46.4%       3744       TOTAL iostat.sdg.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       132 ~ 1%     +82.1%        240 ~ 3%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       317 ~ 1%     +29.6%        411       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       152 ~ 1%     +44.4%        220       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       602 ~ 1%     +44.9%        872       TOTAL iostat.sdh.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       558 ~ 1%     +82.2%       1017 ~ 3%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      1343 ~ 1%     +29.4%       1738       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       652 ~ 1%     +43.9%        939       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      2554 ~ 1%     +44.6%       3695       TOTAL iostat.sdh.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     32.15 ~ 0%     +35.0%      43.39       brickland2/fake/boot/1
     32.15 ~ 0%     +35.0%      43.39       TOTAL boottime.dhcp

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       319 ~ 1%     +30.8%        418       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       319 ~ 1%     +30.8%        418       TOTAL iostat.sdm.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1354 ~ 1%     +30.6%       1768       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      1354 ~ 1%     +30.6%       1768       TOTAL iostat.sdm.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
       320 ~ 1%     +27.5%        408       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
       320 ~ 1%     +27.5%        408       TOTAL iostat.sdn.rrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      1357 ~ 1%     +27.3%       1728       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      1357 ~ 1%     +27.3%       1728       TOTAL iostat.sdn.rkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
 2.908e+08 ~ 0%     -30.6%  2.019e+08       lkp-snb01/micro/hackbench/50%-process-socket
  1.73e+09 ~ 0%      -6.1%  1.625e+09       lkp-snb01/micro/hackbench/50%-threads-pipe
 2.021e+09 ~ 0%      -9.6%  1.827e+09       TOTAL time.involuntary_context_switches

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   1143516 ~ 0%      -3.8%    1099560       lkp-snb01/micro/hackbench/1600%-threads-socket
   1043709 ~ 0%      +4.7%    1092509       lkp-snb01/micro/hackbench/50%-process-socket
     60606 ~ 0%      -4.3%      58016       lkp-snb01/micro/hackbench/50%-threads-pipe
     49922 ~ 0%      +5.3%      52557       lkp-snb01/micro/hackbench/50%-threads-socket
     21482 ~ 0%     +94.7%      41821 ~ 0%  nhm-white/sysbench/oltp/600s-100%-1000000
   2319237 ~ 0%      +1.1%    2344463       TOTAL time.minor_page_faults

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      4964 ~ 0%     +33.0%       6600       brickland2/fake/boot/1
      1135 ~ 0%     +11.8%       1269       lkp-ws02/fake/boot/1
       110 ~ 0%     +16.5%        128       xps2/fake/boot/1
      6210 ~ 0%     +28.8%       7998       TOTAL boottime.idle

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     52.02 ~ 1%     +28.7%      66.93       brickland2/fake/boot/1
     51.53 ~ 0%     +11.7%      57.55       lkp-ws02/fake/boot/1
     14.92 ~ 0%     +14.1%      17.02       xps2/fake/boot/1
    118.48 ~ 0%     +19.4%     141.50       TOTAL boottime.boot

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
 1.692e+10 ~ 0%     -14.2%  1.453e+10       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 1.247e+10 ~ 4%     -17.5%  1.029e+10 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 2.939e+10 ~ 2%     -15.6%  2.482e+10       TOTAL perf-stat.branch-misses

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      9650 ~ 0%      -6.7%       8999 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9650 ~ 0%      -6.7%       8999 ~ 0%  TOTAL iostat.sdb.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      9649 ~ 0%      -6.8%       8997 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9649 ~ 0%      -6.8%       8997 ~ 0%  TOTAL iostat.sdc.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     39847 ~ 0%      -6.7%      37194 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     39847 ~ 0%      -6.7%      37194 ~ 0%  TOTAL iostat.sdb.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     39846 ~ 0%      -6.7%      37185 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     39846 ~ 0%      -6.7%      37185 ~ 0%  TOTAL iostat.sdc.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
  1.06e+12 ~ 0%      -6.4%  9.925e+11       lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
  1.06e+12 ~ 0%      -6.4%  9.925e+11       TOTAL perf-stat.branch-load-misses

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
 7.979e+10 ~ 0%      -6.1%  7.492e+10 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 7.979e+10 ~ 0%      -6.1%  7.492e+10 ~ 0%  TOTAL perf-stat.L1-dcache-store-misses

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      9651 ~ 0%      -6.8%       8995 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      8707 ~ 0%      -5.1%       8263       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
     18359 ~ 0%      -6.0%      17259       TOTAL iostat.sdj.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      3107 ~ 0%      -6.5%       2904 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      2823 ~ 0%      -5.3%       2675       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      5931 ~ 0%      -5.9%       5580       TOTAL iostat.md0.w/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     39855 ~ 0%      -6.7%      37178 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     36125 ~ 0%      -5.1%      34294       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
     75980 ~ 0%      -5.9%      71473       TOTAL iostat.sdj.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     39851 ~ 0%      -6.7%      37188 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     36130 ~ 0%      -5.1%      34287       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
     75982 ~ 0%      -5.9%      71475       TOTAL iostat.sdh.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     39855 ~ 0%      -6.7%      37186 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     36123 ~ 0%      -5.1%      34297       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
     75979 ~ 0%      -5.9%      71483       TOTAL iostat.sdi.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     39847 ~ 0%      -6.7%      37182 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     36133 ~ 0%      -5.0%      34321       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
     75981 ~ 0%      -5.9%      71504       TOTAL iostat.sde.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    397285 ~ 0%      -6.9%     369872 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
    359312 ~ 0%      -5.5%     339685       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
    404981 ~ 0%      -4.5%     386775       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
   1161579 ~ 0%      -5.6%    1096334       TOTAL iostat.md0.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      9651 ~ 0%      -6.8%       8998 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      8708 ~ 0%      -5.1%       8262       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      9790 ~ 0%      -4.4%       9357       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     28150 ~ 0%      -5.4%      26617       TOTAL iostat.sdh.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      9652 ~ 0%      -6.8%       8997 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      8707 ~ 0%      -5.1%       8264       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      9790 ~ 0%      -4.4%       9359       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     28149 ~ 0%      -5.4%      26621       TOTAL iostat.sdi.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      9649 ~ 0%      -6.8%       8997 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      8707 ~ 0%      -5.1%       8266       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      9790 ~ 0%      -4.4%       9358       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     28147 ~ 0%      -5.4%      26622       TOTAL iostat.sdg.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      9649 ~ 0%      -6.8%       8996 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      8709 ~ 0%      -5.0%       8269       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      9792 ~ 0%      -4.4%       9359       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     28151 ~ 0%      -5.4%      26625       TOTAL iostat.sde.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      9651 ~ 0%      -6.8%       8999 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      8709 ~ 0%      -5.0%       8270       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      9792 ~ 0%      -4.5%       9355       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     28152 ~ 0%      -5.4%      26625       TOTAL iostat.sdk.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     39852 ~ 0%      -6.7%      37195 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     36133 ~ 0%      -5.0%      34322       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
     40587 ~ 0%      -4.4%      38798       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
    116573 ~ 0%      -5.4%     110316       TOTAL iostat.sdk.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     36126 ~ 0%      -5.1%      34289       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
     36126 ~ 0%      -5.1%      34289       TOTAL iostat.sdd.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     36124 ~ 0%      -5.1%      34289       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
     36124 ~ 0%      -5.1%      34289       TOTAL iostat.sdf.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     36124 ~ 0%      -5.0%      34306       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
     36124 ~ 0%      -5.0%      34306       TOTAL iostat.sdg.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     36139 ~ 0%      -5.0%      34321       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
     36139 ~ 0%      -5.0%      34321       TOTAL iostat.sdm.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      8707 ~ 0%      -5.1%       8262       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      9791 ~ 0%      -4.4%       9359       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     18499 ~ 0%      -4.7%      17621       TOTAL iostat.sdn.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      8707 ~ 0%      -5.1%       8262       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      9790 ~ 0%      -4.4%       9357       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     18497 ~ 0%      -4.7%      17619       TOTAL iostat.sdf.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      8707 ~ 0%      -5.1%       8262       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      9790 ~ 0%      -4.4%       9357       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     18498 ~ 0%      -4.7%      17619       TOTAL iostat.sdd.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      8710 ~ 0%      -5.1%       8263       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      9792 ~ 0%      -4.4%       9360       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     18503 ~ 0%      -4.8%      17624       TOTAL iostat.sdl.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
      8710 ~ 0%      -5.1%       8269       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
      9794 ~ 0%      -4.4%       9362       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     18504 ~ 0%      -4.7%      17632       TOTAL iostat.sdm.wrqm/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     36128 ~ 0%      -5.1%      34290       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
     40587 ~ 0%      -4.4%      38816       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     76715 ~ 0%      -4.7%      73106       TOTAL iostat.sdn.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     36139 ~ 0%      -5.1%      34298       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
     40592 ~ 0%      -4.4%      38819       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     76731 ~ 0%      -4.7%      73118       TOTAL iostat.sdl.wkB/s

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
    397303 ~ 0%      -6.7%     370499 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
    359368 ~ 0%      -5.5%     339681       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-100dd
    404985 ~ 0%      -4.5%     386784       lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     99302 ~ 0%      +3.7%     103019       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqrewr-sync
     97805 ~ 0%      +1.4%      99128       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
    102108 ~ 0%      +3.1%     105297 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
    100717 ~ 0%      +1.7%     102428 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
   1561591 ~ 0%      -3.5%    1506837       TOTAL vmstat.io.bo

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
   1.2e+08 ~ 0%      +4.0%  1.249e+08       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqrewr-sync
 1.254e+08 ~ 0%      +3.1%  1.294e+08 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
 1.237e+08 ~ 0%      +1.7%  1.259e+08 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
 3.692e+08 ~ 0%      +3.0%  3.801e+08       TOTAL time.file_system_outputs

      v3.14-rc8  ea87e2e7e0905325c58cf5643
---------------  -------------------------
     99175 ~ 0%      +3.7%     102883       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqrewr-sync
     97657 ~ 0%      +1.4%      98984       snb-drag/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-seqwr-sync
    101962 ~ 0%      +3.1%     105146 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
    100573 ~ 0%      +1.7%     102280 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
    399369 ~ 0%      +2.5%     409294       TOTAL iostat.sda.wkB/s

w
