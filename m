Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaBSNMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:12:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:18083 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbaBSNMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:12:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,505,1389772800"; 
   d="scan'208";a="477640687"
Date: Wed, 19 Feb 2014 21:12:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [vfs] 73c12e50a: +13349.5% softirqs.RCU
Message-ID: <20140219131235.GA8731@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

FYI, we noticed the below changes on commit 73c12e50af3a756137071c1e1c1e99cffcbaa835
("vfs: Lazily remove mounts on unlinked files and directories."):
    
test case: dbench

5c39777e797e7ba  73c12e50af3a756137071c1e1  
---------------  -------------------------  
      6.22 ~ 0%    +195.3%      18.36 ~18%  TOTAL dbench.max_latency

Note: the "~ XX%" numbers are stddev percent.

test case: will-it-scale/unlink2

5c39777e797e7ba  73c12e50af3a756137071c1e1  
---------------  -------------------------  
     57178 ~ 2%     -83.9%       9188 ~ 3%  TOTAL numa-vmstat.node1.nr_slab_unreclaimable
     97777 ~ 1%     -85.3%      14413 ~ 6%  TOTAL numa-vmstat.node0.nr_slab_unreclaimable
    227271 ~ 2%     -83.9%      36567 ~ 4%  TOTAL numa-meminfo.node1.SUnreclaim
     78384 ~ 2%  +13349.5%   10542303 ~11%  TOTAL softirqs.RCU
    202419 ~15%  +48738.0%   98857773 ~ 4%  TOTAL cpuidle.C1-SNB.time
    955612 ~31%   +2561.5%   25433795 ~10%  TOTAL cpuidle.C1E-SNB.time
      1278 ~20%   +8648.3%     111872 ~11%  TOTAL cpuidle.C1E-SNB.usage
    364333 ~11%    +786.3%    3229011 ~17%  TOTAL cpuidle.C3-SNB.time
       793 ~ 5%    +568.6%       5305 ~12%  TOTAL cpuidle.C3-SNB.usage
     10882 ~15%   +1943.2%     222341 ~18%  TOTAL cpuidle.C6-SNB.time
         8 ~27%   +4702.4%        403 ~17%  TOTAL cpuidle.C6-SNB.usage
    389688 ~ 2%     -85.3%      57320 ~ 5%  TOTAL numa-meminfo.node0.SUnreclaim
    485651 ~ 2%     -82.5%      84770 ~ 5%  TOTAL numa-meminfo.node0.Slab
     19822 ~ 4%     -91.7%       1649 ~ 7%  TOTAL slabinfo.kmalloc-256.num_slabs
     19822 ~ 4%     -91.7%       1649 ~ 7%  TOTAL slabinfo.kmalloc-256.active_slabs
    634311 ~ 4%     -91.7%      52792 ~ 7%  TOTAL slabinfo.kmalloc-256.num_objs
    768494 ~ 3%     -81.0%     146268 ~ 2%  TOTAL meminfo.Slab
    634179 ~ 4%     -91.7%      52517 ~ 7%  TOTAL slabinfo.kmalloc-256.active_objs
     16094 ~ 3%     -85.4%       2343 ~ 3%  TOTAL slabinfo.dentry.num_slabs
     16094 ~ 3%     -85.4%       2343 ~ 3%  TOTAL slabinfo.dentry.active_slabs
    675979 ~ 3%     -85.4%      98427 ~ 3%  TOTAL slabinfo.dentry.num_objs
    675739 ~ 3%     -85.5%      98065 ~ 3%  TOTAL slabinfo.dentry.active_objs
     12925 ~ 4%     -91.6%       1081 ~ 7%  TOTAL slabinfo.shmem_inode_cache.num_slabs
     12925 ~ 4%     -91.6%       1081 ~ 7%  TOTAL slabinfo.shmem_inode_cache.active_slabs
    153617 ~ 3%     -84.5%      23851 ~ 3%  TOTAL proc-vmstat.nr_slab_unreclaimable
    633368 ~ 4%     -91.6%      53034 ~ 7%  TOTAL slabinfo.shmem_inode_cache.num_objs
    633182 ~ 4%     -91.7%      52584 ~ 7%  TOTAL slabinfo.shmem_inode_cache.active_objs
    611608 ~ 3%     -84.4%      95315 ~ 3%  TOTAL meminfo.SUnreclaim
     56626 ~ 0%    +977.2%     609963 ~ 4%  TOTAL interrupts.RES
    289471 ~ 1%     -79.4%      59729 ~ 4%  TOTAL numa-meminfo.node1.Slab
     95962 ~ 3%     -71.4%      27449 ~ 7%  TOTAL numa-meminfo.node0.SReclaimable
     24059 ~ 3%     -71.4%       6870 ~ 7%  TOTAL numa-vmstat.node0.nr_slab_reclaimable
     39360 ~ 2%     -67.6%      12741 ~ 1%  TOTAL proc-vmstat.nr_slab_reclaimable
    156885 ~ 2%     -67.5%      50952 ~ 1%  TOTAL meminfo.SReclaimable
     62199 ~ 1%     -62.8%      23161 ~ 7%  TOTAL numa-meminfo.node1.SReclaimable
     15622 ~ 1%     -62.9%       5795 ~ 7%  TOTAL numa-vmstat.node1.nr_slab_reclaimable
     40507 ~39%    +153.7%     102749 ~19%  TOTAL cpuidle.C1-NHM.time
     23068 ~ 2%    +135.2%      54252 ~ 9%  TOTAL interrupts.IWI
       357 ~27%    +116.4%        774 ~15%  TOTAL cpuidle.C3-NHM.usage
   4834003 ~ 3%     -47.6%    2534625 ~ 4%  TOTAL numa-numastat.node1.local_node
   4834003 ~ 3%     -47.6%    2534625 ~ 4%  TOTAL numa-numastat.node1.numa_hit
      2167 ~23%     -28.0%       1560 ~ 6%  TOTAL proc-vmstat.nr_tlb_remote_flush_received
  58685570 ~ 2%     -38.5%   36079286 ~ 2%  TOTAL proc-vmstat.pgalloc_normal
  68325712 ~ 1%     -37.7%   42551512 ~ 2%  TOTAL proc-vmstat.pgfree
   1079369 ~ 0%     -36.9%     681261 ~ 0%  TOTAL numa-meminfo.node0.MemUsed
    140248 ~ 2%     -35.2%      90832 ~ 5%  TOTAL softirqs.SCHED
  19460075 ~ 1%     -36.5%   12353959 ~ 2%  TOTAL proc-vmstat.numa_local
  19460075 ~ 1%     -36.5%   12353960 ~ 2%  TOTAL proc-vmstat.numa_hit
     53926 ~24%     -33.4%      35902 ~ 2%  TOTAL meminfo.DirectMap4k
        85 ~31%     +79.6%        153 ~28%  TOTAL cpuidle.C1-NHM.usage
   9675753 ~ 1%     -33.1%    6474766 ~ 1%  TOTAL proc-vmstat.pgalloc_dma32
  14654234 ~ 1%     -32.9%    9829336 ~ 1%  TOTAL numa-numastat.node0.local_node
  14654234 ~ 1%     -32.9%    9829336 ~ 1%  TOTAL numa-numastat.node0.numa_hit
   1878635 ~ 1%     -31.6%    1284774 ~ 2%  TOTAL numa-vmstat.node1.numa_local
   1886571 ~ 1%     -31.5%    1292725 ~ 2%  TOTAL numa-vmstat.node1.numa_hit
      1425 ~ 7%     -20.0%       1140 ~10%  TOTAL numa-meminfo.node1.Mlocked
       356 ~ 7%     -20.0%        285 ~10%  TOTAL numa-vmstat.node1.nr_mlock
       287 ~ 9%     +24.8%        358 ~ 8%  TOTAL numa-vmstat.node0.nr_mlock
      1150 ~ 9%     +24.8%       1435 ~ 8%  TOTAL numa-meminfo.node0.Mlocked
      1441 ~ 7%     -19.8%       1156 ~10%  TOTAL numa-meminfo.node1.Unevictable
       360 ~ 7%     -19.8%        289 ~10%  TOTAL numa-vmstat.node1.nr_unevictable
      1166 ~ 9%     +24.4%       1451 ~ 8%  TOTAL numa-meminfo.node0.Unevictable
       291 ~ 9%     +24.4%        362 ~ 8%  TOTAL numa-vmstat.node0.nr_unevictable
    871951 ~ 0%     -25.9%     645735 ~ 0%  TOTAL numa-meminfo.node1.MemUsed
   8508242 ~ 0%     -24.4%    6432405 ~ 1%  TOTAL numa-vmstat.node0.numa_local
    225490 ~ 2%     -24.1%     171244 ~ 2%  TOTAL cpuidle.C7-SNB.usage
   8623332 ~ 0%     -24.1%    6547495 ~ 1%  TOTAL numa-vmstat.node0.numa_hit
       313 ~28%     -30.7%        217 ~21%  TOTAL cpuidle.C1E-NHM.usage
      1943 ~ 0%   +7380.4%     145404 ~11%  TOTAL time.voluntary_context_switches
      1001 ~ 0%   +1015.5%      11173 ~ 4%  TOTAL vmstat.system.cs
      4815 ~ 0%     +34.0%       6452 ~ 1%  TOTAL vmstat.system.in
      1480 ~ 0%      -1.7%       1454 ~ 0%  TOTAL time.system_time
       485 ~ 0%      -1.6%        477 ~ 0%  TOTAL time.percent_of_cpu_this_job_got
     50.66 ~ 0%      -1.4%      49.97 ~ 0%  TOTAL turbostat.%c0
      7.69 ~ 0%      +1.1%       7.78 ~ 0%  TOTAL boottime.dhcp
       106 ~ 0%      -0.5%        106 ~ 0%  TOTAL turbostat.Cor_W
       134 ~ 0%      -0.4%        133 ~ 0%  TOTAL turbostat.Pkg_W

                           time.voluntary_context_switches

   20000 ++-----------------------------------------------------------------+
   18000 ++                             O    O          O                   |
         |                                                       O          |
   16000 ++                                                O                |
   14000 ++ O                        O                                      |
         O     O                  O        O    O                   O       |
   12000 ++                                                   O             |
   10000 ++                                        O  O                     |
    8000 ++                                                                 |
         |       O  O  O  O  O O                                            |
    6000 ++                                                                 |
    4000 ++                                                                 |
         |                                                                  |
    2000 *+.*..*.*..*..*..*..*.*..*..*..*..*.*..*..*..*.*..*..*..*..*.*..*..*
       0 ++-----------------------------------------------------------------+

