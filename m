Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaAPBfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:35:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:41246 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaAPBfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:35:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="459552129"
Date: Thu, 16 Jan 2014 09:35:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@linux.intel.com
Subject: [sched] b75e43bb77d: +87% hackbench.throughput
Message-ID: <20140116013508.GB13621@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

We noticed that commit b75e43bb77d ("sched: find the latest idle cpu")
increased hackbench throughput by +87% in test case hackbench
1600%-threads-pipe on a 2S SNB server.

      v3.13-rc7  b75e43bb77df14e2209532c1e
---------------  -------------------------
    171792 ~ 0%     +87.0%     321176 ~ 0%  hackbench.throughput
   4677274 ~29%    +706.1%   37705344 ~ 1%  proc-vmstat.pgalloc_dma32
  12718244 ~34%    +700.6%  1.018e+08 ~ 3%  numa-vmstat.node0.numa_local
  12741758 ~34%    +699.3%  1.019e+08 ~ 3%  numa-vmstat.node0.numa_hit
    275020 ~16%    +535.4%    1747494 ~ 3%  proc-vmstat.nr_tlb_remote_flush_received
  24343551 ~30%    +745.7%  2.059e+08 ~ 1%  numa-numastat.node0.local_node
    578758 ~13%    +507.2%    3514489 ~ 2%  interrupts.TLB
 8.696e+08 ~ 1%     -85.7%  1.246e+08 ~11%  interrupts.RES
  24343552 ~30%    +745.7%  2.059e+08 ~ 1%  numa-numastat.node0.numa_hit
     24275 ~12%    +296.2%      96175 ~ 4%  proc-vmstat.nr_tlb_remote_flush
     16816 ~ 1%     -60.8%       6596 ~ 3%  proc-vmstat.nr_tlb_local_flush_all
 1.807e+08 ~ 1%    +135.8%   4.26e+08 ~ 1%  proc-vmstat.numa_local
 1.807e+08 ~ 1%    +135.8%   4.26e+08 ~ 1%  proc-vmstat.numa_hit
 1.818e+08 ~ 1%    +135.4%   4.28e+08 ~ 1%  proc-vmstat.pgfree
 1.771e+08 ~ 1%    +120.3%  3.903e+08 ~ 1%  proc-vmstat.pgalloc_normal
       270 ~14%    +149.1%        673 ~ 5%  slabinfo.mnt_cache.active_objs
       270 ~14%    +149.1%        673 ~ 5%  slabinfo.mnt_cache.num_objs
       378 ~ 2%     -45.5%        206 ~ 5%  proc-vmstat.nr_dirtied
   1284432 ~ 2%     -42.0%     744640 ~ 2%  softirqs.RCU
   4821300 ~ 1%     -40.6%    2863710 ~ 1%  proc-vmstat.pgfault
 1.564e+08 ~ 4%     +40.8%  2.202e+08 ~ 1%  numa-numastat.node1.local_node
 1.564e+08 ~ 4%     +40.8%  2.202e+08 ~ 1%  numa-numastat.node1.numa_hit
  78523323 ~ 5%     +39.2%  1.093e+08 ~ 3%  numa-vmstat.node1.numa_local
  78615652 ~ 5%     +39.2%  1.094e+08 ~ 3%  numa-vmstat.node1.numa_hit
      7878 ~ 0%     +16.4%       9168 ~ 1%  vmstat.procs.r
   1413677 ~ 0%     -84.6%     218164 ~10%  vmstat.system.in
 2.386e+09 ~ 0%     -76.1%  5.709e+08 ~ 6%  time.voluntary_context_switches
   5575434 ~ 0%     -75.6%    1359735 ~ 5%  vmstat.system.cs
 9.359e+08 ~ 1%     -73.2%  2.508e+08 ~ 6%  time.involuntary_context_switches
   1229364 ~ 1%     +76.9%    2174598 ~ 0%  time.minor_page_faults
      1638 ~ 1%     +60.0%       2622 ~ 1%  time.user_time
     17188 ~ 0%      -8.4%      15749 ~ 0%  time.system_time


                                 hackbench.throughput

   340000 ++----------------------------------------------------------------+
          |                  O   O   O   O       O   O   O  O       O   O   |
   320000 ++                                 O                  O           |
   300000 ++                                                                |
          |                                                                 |
   280000 ++                                                                |
   260000 O+  O   O   O   O                                                 |
          |                                                                 |
   240000 ++                                                                |
   220000 ++                                                                |
          |                                                                 |
   200000 ++                                                                |
   180000 ++                                                                |
          *...*...*...*...*..*...*...*...*...*...*...*...*..*...*...*...*...*
   160000 ++----------------------------------------------------------------+


                          time.involuntary_context_switches

   1e+09 ++-----------------------------------------------------------------+
         *...*...*...*...      ..*...*...*..*...                  ..*...    |
   9e+08 ++              *...*.                 *...*...*...*...*.      *...*
   8e+08 ++                                                                 |
         |                                                                  |
   7e+08 ++                                                                 |
         |                                                                  |
   6e+08 ++                                                                 |
         |                                                                  |
   5e+08 ++                                                                 |
   4e+08 ++                                                                 |
         |                                                                  |
   3e+08 ++                                                                 |
         O   O   O   O   O   O   O   O   O  O   O   O   O   O   O   O   O   |
   2e+08 ++-----------------------------------------------------------------+

Thanks,
Fengguang
