Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030610AbaDJMmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:42:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:21769 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030279AbaDJMmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:42:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,834,1389772800"; 
   d="scan'208";a="510874977"
Date: Thu, 10 Apr 2014 20:41:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        lkp@01.org
Subject: [writeback] 6903673566d: +2.5% fileio.requests_per_sec
Message-ID: <20140410124137.GA17720@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

I tried your writeback dirty list patchset and noticed some ups/downs.
The main performance changes are

1) +2.5% fileio.requests_per_sec
2) -7.1% iostat.md0.wkB/s

git://bee.sh.intel.com/git/wfg/linux-devel.git jan-dirty-list
commit 6903673566d0289680e593dac088c787d119b067 ("writeback: Replace several writeback lists with inode tagging")

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      6526 ~ 0%      +3.2%       6736 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
      6441 ~ 0%      +1.8%       6558 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
     12968 ~ 0%      +2.5%      13295 ~ 0%  TOTAL fileio.requests_per_sec

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
    398147 ~ 0%      -7.1%     369866 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
    398147 ~ 0%      -7.1%     369866 ~ 0%  TOTAL iostat.md0.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       861 ~30%     -78.7%        183 ~33%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
       464 ~48%     -91.7%         38 ~27%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       109 ~18%  +54509.0%      59960 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      1436 ~35%   +4089.8%      60182 ~ 2%  TOTAL proc-vmstat.nr_vmscan_immediate_reclaim

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       123 ~29%     -94.3%          7 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       123 ~29%     -94.3%          7 ~ 0%  TOTAL ftrace.writeback_single_inode.md0.age

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
        55 ~19%  +19305.5%      10750 ~17%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
        55 ~19%  +19305.5%      10750 ~17%  TOTAL numa-vmstat.node1.nr_vmscan_immediate_reclaim

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
        38 ~26%  +22737.7%       8815 ~17%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
        38 ~26%  +22737.7%       8815 ~17%  TOTAL numa-vmstat.node0.nr_vmscan_immediate_reclaim

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       145 ~16%    +668.1%       1115 ~17%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       145 ~16%    +668.1%       1115 ~17%  TOTAL proc-vmstat.pgrotated

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      1477 ~ 0%    +275.0%       5541 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      1477 ~ 0%    +275.0%       5541 ~ 1%  TOTAL meminfo.Buffers

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      1486 ~ 0%    +273.3%       5546 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      1486 ~ 0%    +273.3%       5546 ~ 1%  TOTAL vmstat.memory.buff

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     13328 ~ 0%     -68.6%       4180 ~ 7%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
     13328 ~ 0%     -68.6%       4180 ~ 7%  TOTAL proc-vmstat.pgpgin

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      0.36 ~11%     -78.9%       0.08 ~16%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      0.12 ~ 6%     -22.0%       0.09 ~ 8%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
      0.48 ~10%     -65.0%       0.17 ~11%  TOTAL turbostat.%pc3

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
         2 ~ 0%     +50.0%          3 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
         1 ~ 0%    +300.0%          4 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
         3 ~ 0%    +133.3%          7 ~ 0%  TOTAL ftrace.writeback_single_inode.sda.age

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       105 ~11%    +125.9%        237 ~ 9%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
       105 ~11%    +125.9%        237 ~ 9%  TOTAL slabinfo.xfs_trans.active_objs

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       105 ~11%    +125.9%        237 ~ 9%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
       105 ~11%    +125.9%        237 ~ 9%  TOTAL slabinfo.xfs_trans.num_objs

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       868 ~ 2%    +124.1%       1946 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       868 ~ 2%    +124.1%       1946 ~ 1%  TOTAL slabinfo.journal_head.active_objs

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       868 ~ 2%    +124.1%       1946 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       868 ~ 2%    +124.1%       1946 ~ 1%  TOTAL slabinfo.journal_head.num_objs

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       725 ~ 9%    +119.1%       1589 ~ 6%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
       194 ~ 0%     +56.2%        303 ~13%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
       919 ~ 7%    +105.8%       1892 ~ 7%  TOTAL slabinfo.blkdev_ioc.num_objs

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       725 ~ 9%    +118.5%       1584 ~ 6%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
       194 ~ 0%     +56.2%        303 ~13%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
       919 ~ 7%    +105.3%       1887 ~ 7%  TOTAL slabinfo.blkdev_ioc.active_objs

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     13970 ~20%     -35.8%       8963 ~12%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
     13970 ~20%     -35.8%       8963 ~12%  TOTAL numa-vmstat.node1.nr_anon_pages

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     55871 ~20%     -35.8%      35844 ~12%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
     55871 ~20%     -35.8%      35844 ~12%  TOTAL numa-meminfo.node1.AnonPages

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     55793 ~20%     -35.9%      35791 ~12%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
     55793 ~20%     -35.9%      35791 ~12%  TOTAL numa-meminfo.node1.Active(anon)

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     13949 ~20%     -35.8%       8950 ~12%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
     13949 ~20%     -35.8%       8950 ~12%  TOTAL numa-vmstat.node1.nr_active_anon

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      0.64 ~ 8%     +53.1%       0.98 ~ 3%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      0.64 ~ 8%     +53.1%       0.98 ~ 3%  TOTAL perf-profile.cpu-cycles.sys_write.system_call_fastpath.write

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       727 ~ 1%     +41.3%       1027 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       727 ~ 1%     +41.3%       1027 ~ 1%  TOTAL slabinfo.dquot.num_objs

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       727 ~ 1%     +41.3%       1027 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       727 ~ 1%     +41.3%       1027 ~ 1%  TOTAL slabinfo.dquot.active_objs

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
        17 ~ 4%     -17.6%         14 ~13%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
        17 ~ 4%     -17.6%         14 ~13%  TOTAL ftrace.balance_dirty_pages.sdj.think

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     41483 ~ 1%     -25.4%      30966 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     41483 ~ 1%     -25.4%      30966 ~ 0%  TOTAL ftrace.writeback_single_inode.md0.wrote

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      0.42 ~26%     -35.4%       0.27 ~ 9%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
      0.42 ~26%     -35.4%       0.27 ~ 9%  TOTAL turbostat.%pc6

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      1.00 ~ 3%     +33.3%       1.33 ~ 5%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      1.00 ~ 3%     +33.3%       1.33 ~ 5%  TOTAL perf-profile.cpu-cycles.__generic_file_aio_write.generic_file_aio_write.ext4_file_write.do_sync_write.vfs_write

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      0.52 ~24%     +66.5%       0.87 ~25%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
      0.52 ~24%     +66.5%       0.87 ~25%  TOTAL perf-profile.cpu-cycles.do_sync_write.vfs_write.sys_write.system_call_fastpath.write

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     17614 ~ 0%     -18.5%      14355 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     39820 ~ 2%     -20.9%      31511 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     57435 ~ 1%     -20.1%      45866 ~ 0%  TOTAL proc-vmstat.nr_writeback

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     70430 ~ 0%     -18.5%      57410 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
    159175 ~ 2%     -21.0%     125784 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
    229605 ~ 1%     -20.2%     183195 ~ 0%  TOTAL meminfo.Writeback

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      8.14 ~ 8%     -16.0%       6.83 ~ 8%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
      8.14 ~ 8%     -16.0%       6.83 ~ 8%  TOTAL perf-profile.cpu-cycles.__block_write_begin.xfs_vm_write_begin.generic_file_buffered_write.xfs_file_buffered_aio_write.xfs_file_aio_write

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     17680 ~ 0%     -18.2%      14463 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     39997 ~ 1%     -20.6%      31757 ~ 2%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     57677 ~ 1%     -19.9%      46220 ~ 1%  TOTAL ftrace.global_dirty_state.writeback

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     31031 ~ 5%     -23.4%      23763 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
    439570 ~ 3%     +11.8%     491310 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
    470602 ~ 3%      +9.4%     515073 ~ 1%  TOTAL ftrace.writeback_single_inode.sda.index

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
   2239375 ~ 5%     -20.2%    1787786 ~ 3%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
   2239375 ~ 5%     -20.2%    1787786 ~ 3%  TOTAL ftrace.writeback_single_inode.md0.index

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      0.89 ~ 9%     -20.0%       0.71 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      0.89 ~ 9%     -20.0%       0.71 ~ 1%  TOTAL perf-profile.cpu-cycles.vfs_read.sys_read.system_call_fastpath.read

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       518 ~ 1%     +21.7%        630 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
      4406 ~ 0%     -17.6%       3629 ~ 2%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
      4924 ~ 0%     -13.5%       4260 ~ 2%  TOTAL ftrace.writeback_single_inode.sda.wrote

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      2.46 ~10%     -16.8%       2.05 ~ 5%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
      2.46 ~10%     -16.8%       2.05 ~ 5%  TOTAL perf-profile.cpu-cycles.__clear_user.read_zero.read_zero.vfs_read.sys_read

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      0.77 ~ 7%     -14.5%       0.66 ~ 7%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
      0.77 ~ 7%     -14.5%       0.66 ~ 7%  TOTAL turbostat.%pc2

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       753 ~ 6%     -17.2%        623 ~ 4%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
       753 ~ 6%     -17.2%        623 ~ 4%  TOTAL ftrace.bdi_dirty_ratelimit.sda.task_ratelimit

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      1.45 ~ 7%     -18.5%       1.18 ~14%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
      1.45 ~ 7%     -18.5%       1.18 ~14%  TOTAL perf-profile.cpu-cycles.xfs_file_aio_write.do_sync_write.vfs_write.sys_write.system_call_fastpath

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     67019 ~ 5%     -15.5%      56616 ~ 3%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
     67019 ~ 5%     -15.5%      56616 ~ 3%  TOTAL numa-vmstat.node1.nr_free_pages

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
    268013 ~ 5%     -15.6%     226330 ~ 3%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
    268013 ~ 5%     -15.6%     226330 ~ 3%  TOTAL numa-meminfo.node1.MemFree

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 2.716e+08 ~ 7%     -10.2%  2.438e+08 ~ 8%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 2.716e+08 ~ 7%     -10.2%  2.438e+08 ~ 8%  TOTAL cpuidle.C1-NHM.time

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      1.30 ~ 6%     +15.0%       1.49 ~ 3%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      1.30 ~ 6%     +15.0%       1.49 ~ 3%  TOTAL perf-profile.cpu-cycles.jbd2_journal_stop.__ext4_journal_stop.ext4_da_write_end.generic_file_buffered_write.__generic_file_aio_write

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
   5624475 ~ 0%     -14.3%    4817546 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
   5624475 ~ 0%     -14.3%    4817546 ~ 0%  TOTAL ftrace.global_dirty_state.written

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
   5665317 ~ 0%     -14.2%    4858497 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
   5665317 ~ 0%     -14.2%    4858497 ~ 0%  TOTAL ftrace.global_dirty_state.dirtied

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
    284093 ~ 0%     -14.3%     243524 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
    284093 ~ 0%     -14.3%     243524 ~ 1%  TOTAL softirqs.TIMER

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
    144616 ~ 2%     -13.1%     125601 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
    144616 ~ 2%     -13.1%     125601 ~ 0%  TOTAL interrupts.RES

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  10513311 ~ 1%     -14.2%    9018488 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  10513311 ~ 1%     -14.2%    9018488 ~ 0%  TOTAL proc-vmstat.pgsteal_kswapd_dma32

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  10616278 ~ 1%     -14.1%    9120337 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  10616278 ~ 1%     -14.1%    9120337 ~ 0%  TOTAL proc-vmstat.pgdeactivate

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  10646283 ~ 1%     -14.1%    9150342 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  10646283 ~ 1%     -14.1%    9150342 ~ 0%  TOTAL proc-vmstat.pgrefill_dma32

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  10700780 ~ 1%     -13.9%    9213386 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  10700780 ~ 1%     -13.9%    9213386 ~ 0%  TOTAL proc-vmstat.pgscan_kswapd_dma32

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     97209 ~ 0%     +16.0%     112763 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     97209 ~ 0%     +16.0%     112763 ~ 0%  TOTAL interrupts.46:PCI-MSI-edge.ahci

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     48817 ~ 0%     +15.8%      56548 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     48817 ~ 0%     +15.8%      56548 ~ 0%  TOTAL interrupts.CAL

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
        32 ~ 2%     +13.7%         36 ~ 2%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
        32 ~ 2%     +13.7%         36 ~ 2%  TOTAL ftrace.balance_dirty_pages.sda.pause

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  42947776 ~ 1%     -13.8%   37036031 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  42947776 ~ 1%     -13.8%   37036031 ~ 0%  TOTAL proc-vmstat.pgpgout

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  10738479 ~ 1%     -13.8%    9260807 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  10738479 ~ 1%     -13.8%    9260807 ~ 0%  TOTAL proc-vmstat.nr_written

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  10756692 ~ 1%     -13.7%    9282691 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  10756692 ~ 1%     -13.7%    9282691 ~ 0%  TOTAL proc-vmstat.nr_dirtied

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     71616 ~ 1%     -13.6%      61867 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     71616 ~ 1%     -13.6%      61867 ~ 0%  TOTAL ftrace.bdi_dirty_ratelimit.sda.write_bw

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     72368 ~ 1%     -13.7%      62469 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     72368 ~ 1%     -13.7%      62469 ~ 0%  TOTAL ftrace.bdi_dirty_ratelimit.sda.dirty_rate

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     50797 ~ 0%     +15.3%      58562 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     50797 ~ 0%     +15.3%      58562 ~ 0%  TOTAL softirqs.BLOCK

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     71851 ~ 1%     -13.5%      62185 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     71851 ~ 1%     -13.5%      62185 ~ 0%  TOTAL ftrace.bdi_dirty_ratelimit.sda.awrite_bw

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  11603962 ~ 1%     -12.9%   10106747 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  11603962 ~ 1%     -12.9%   10106747 ~ 0%  TOTAL proc-vmstat.pgfree

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  11598185 ~ 1%     -12.9%   10103278 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  11598185 ~ 1%     -12.9%   10103278 ~ 0%  TOTAL proc-vmstat.numa_local

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  11598185 ~ 1%     -12.9%   10103278 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  11598185 ~ 1%     -12.9%   10103278 ~ 0%  TOTAL proc-vmstat.numa_hit

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  11615252 ~ 1%     -12.9%   10119889 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  11615252 ~ 1%     -12.9%   10119889 ~ 0%  TOTAL proc-vmstat.pgalloc_dma32

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     23008 ~ 1%     +14.2%      26276 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     23008 ~ 1%     +14.2%      26276 ~ 0%  TOTAL proc-vmstat.nr_dirty

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     92088 ~ 1%     +14.2%     105124 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     92088 ~ 1%     +14.2%     105124 ~ 0%  TOTAL meminfo.Dirty

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     23126 ~ 1%     +14.3%      26444 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     23126 ~ 1%     +14.3%      26444 ~ 0%  TOTAL ftrace.global_dirty_state.dirty

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      1.78 ~17%     -30.2%       1.24 ~14%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
      1.78 ~17%     -30.2%       1.24 ~14%  TOTAL perf-profile.cpu-cycles.generic_file_buffered_write.xfs_file_buffered_aio_write.xfs_file_aio_write.do_sync_write.vfs_write

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
    541298 ~ 1%     -11.9%     476647 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
    541298 ~ 1%     -11.9%     476647 ~ 0%  TOTAL meminfo.MemFree

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
    135390 ~ 1%     -11.9%     119229 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
    135390 ~ 1%     -11.9%     119229 ~ 0%  TOTAL proc-vmstat.nr_free_pages

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
        32 ~ 2%     +12.2%         36 ~ 2%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
        32 ~ 2%     +12.2%         36 ~ 2%  TOTAL ftrace.balance_dirty_pages.sda.period

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
    550275 ~ 1%     -11.1%     489385 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
    550275 ~ 1%     -11.1%     489385 ~ 0%  TOTAL vmstat.memory.free

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
    362273 ~ 1%     -11.0%     322470 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
    362273 ~ 1%     -11.0%     322470 ~ 0%  TOTAL proc-vmstat.pgactivate

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      4191 ~ 1%     -10.0%       3772 ~ 2%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
      4191 ~ 1%     -10.0%       3772 ~ 2%  TOTAL proc-vmstat.kswapd_high_wmark_hit_quickly

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       516 ~ 5%     +13.4%        585 ~ 5%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       516 ~ 5%     +13.4%        585 ~ 5%  TOTAL numa-vmstat.node0.nr_page_table_pages

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      1085 ~ 5%     +10.0%       1194 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      1085 ~ 5%     +10.0%       1194 ~ 2%  TOTAL slabinfo.task_struct.num_objs

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
        31 ~ 1%      -8.2%         29 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
        31 ~ 1%      -8.2%         29 ~ 0%  TOTAL ftrace.balance_dirty_pages.sda.dirtied_pause

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
    227121 ~ 0%      -9.4%     205850 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
    227121 ~ 0%      -9.4%     205850 ~ 1%  TOTAL softirqs.RCU

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      2055 ~ 5%     +13.5%       2332 ~ 5%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      2055 ~ 5%     +13.5%       2332 ~ 5%  TOTAL numa-meminfo.node0.PageTables

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      1069 ~ 3%     -10.8%        954 ~ 4%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
      1069 ~ 3%     -10.8%        954 ~ 4%  TOTAL ftrace.balance_dirty_pages.sda.task_ratelimit

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     23923 ~ 0%     -76.5%       5626 ~11%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
     23923 ~ 0%     -76.5%       5626 ~11%  TOTAL time.file_system_inputs

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      4.79 ~ 2%    +806.0%      43.40 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
      1.64 ~ 0%      +3.8%       1.71 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
      6.43 ~ 2%    +601.0%      45.11 ~ 1%  TOTAL iostat.sda.wrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       546 ~ 2%     +91.7%       1047 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       546 ~ 2%     +91.7%       1047 ~ 0%  TOTAL iostat.sdj.rkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       129 ~ 2%     +91.6%        248 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       129 ~ 2%     +91.6%        248 ~ 0%  TOTAL iostat.sdj.rrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       538 ~ 1%     +92.4%       1035 ~ 2%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       538 ~ 1%     +92.4%       1035 ~ 2%  TOTAL iostat.sde.rkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       127 ~ 1%     +92.2%        244 ~ 2%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       127 ~ 1%     +92.2%        244 ~ 2%  TOTAL iostat.sde.rrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       535 ~ 1%     +91.6%       1026 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       535 ~ 1%     +91.6%       1026 ~ 1%  TOTAL iostat.sdd.rkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       126 ~ 1%     +91.5%        242 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       126 ~ 1%     +91.5%        242 ~ 1%  TOTAL iostat.sdd.rrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       551 ~ 2%     +89.5%       1045 ~ 2%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       551 ~ 2%     +89.5%       1045 ~ 2%  TOTAL iostat.sdf.rkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       130 ~ 2%     +89.3%        247 ~ 2%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       130 ~ 2%     +89.3%        247 ~ 2%  TOTAL iostat.sdf.rrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       538 ~ 1%     +92.2%       1034 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       538 ~ 1%     +92.2%       1034 ~ 0%  TOTAL iostat.sdc.rkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       127 ~ 1%     +92.0%        244 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       127 ~ 1%     +92.0%        244 ~ 0%  TOTAL iostat.sdc.rrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       543 ~ 1%     +91.8%       1041 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       543 ~ 1%     +91.8%       1041 ~ 1%  TOTAL iostat.sdi.rkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       128 ~ 1%     +91.6%        246 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       128 ~ 1%     +91.6%        246 ~ 1%  TOTAL iostat.sdi.rrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       129 ~ 1%     +91.2%        247 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       129 ~ 1%     +91.2%        247 ~ 1%  TOTAL iostat.sdb.rrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       545 ~ 1%     +91.3%       1043 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       545 ~ 1%     +91.3%       1043 ~ 1%  TOTAL iostat.sdb.rkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       546 ~ 2%     +91.1%       1045 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       546 ~ 2%     +91.1%       1045 ~ 1%  TOTAL iostat.sdh.rkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       129 ~ 2%     +91.1%        247 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       129 ~ 2%     +91.1%        247 ~ 1%  TOTAL iostat.sdh.rrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       552 ~ 2%     +88.6%       1041 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       552 ~ 2%     +88.6%       1041 ~ 1%  TOTAL iostat.sdl.rkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       130 ~ 2%     +88.6%        246 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       130 ~ 2%     +88.6%        246 ~ 1%  TOTAL iostat.sdl.rrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       556 ~ 2%     +88.5%       1048 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       556 ~ 2%     +88.5%       1048 ~ 1%  TOTAL iostat.sdg.rkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       131 ~ 2%     +88.4%        248 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       131 ~ 2%     +88.4%        248 ~ 1%  TOTAL iostat.sdg.rrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       555 ~ 3%     +88.2%       1044 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       555 ~ 3%     +88.2%       1044 ~ 1%  TOTAL iostat.sdk.rkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       131 ~ 3%     +88.1%        247 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
       131 ~ 3%     +88.1%        247 ~ 1%  TOTAL iostat.sdk.rrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      3290 ~ 1%     -69.0%       1019 ~ 7%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
   3596794 ~ 0%      +3.3%    3714366 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
   3546724 ~ 0%      +1.9%    3614254 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
   7146809 ~ 0%      +2.6%    7329639 ~ 0%  TOTAL time.voluntary_context_switches

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       879 ~ 1%     -25.2%        657 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
       879 ~ 1%     -25.2%        657 ~ 0%  TOTAL iostat.sda.avgrq-sz

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  48923640 ~ 7%     +33.4%   65269752 ~ 7%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
  48923640 ~ 7%     +33.4%   65269752 ~ 7%  TOTAL perf-stat.dTLB-store-misses

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 1.478e+10 ~13%     +18.6%  1.753e+10 ~ 5%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 1.478e+10 ~13%     +18.6%  1.753e+10 ~ 5%  TOTAL perf-stat.dTLB-load-misses

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       161 ~ 0%     +16.0%        186 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
       161 ~ 0%     +16.0%        186 ~ 0%  TOTAL iostat.sda.w/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       877 ~ 0%     -12.9%        763 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
       877 ~ 0%     -12.9%        763 ~ 0%  TOTAL iostat.sda.await

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       877 ~ 0%     -12.9%        763 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
       877 ~ 0%     -12.9%        763 ~ 0%  TOTAL iostat.sda.w_await

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 9.069e+08 ~ 1%      +6.2%  9.628e+08 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 3.994e+09 ~ 1%      +8.0%  4.312e+09 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 1.377e+10 ~ 0%     -18.7%   1.12e+10 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 1.867e+10 ~ 1%     -11.8%  1.648e+10 ~ 0%  TOTAL perf-stat.branch-misses

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 3.005e+08 ~ 2%     -11.1%   2.67e+08 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 3.005e+08 ~ 2%     -11.1%   2.67e+08 ~ 0%  TOTAL perf-stat.LLC-stores

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 1.477e+11 ~ 0%     -14.4%  1.265e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 2.034e+11 ~ 0%      -7.9%  1.874e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 9.544e+11 ~ 0%      -8.2%  8.766e+11 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 1.306e+12 ~ 0%      -8.8%  1.191e+12 ~ 0%  TOTAL perf-stat.dTLB-loads

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  4.27e+11 ~ 2%     -14.2%  3.664e+11 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 5.714e+11 ~ 1%      -7.1%  5.306e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 3.604e+12 ~ 0%      -7.3%  3.341e+12 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 4.603e+12 ~ 0%      -7.9%  4.238e+12 ~ 0%  TOTAL perf-stat.L1-icache-loads

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  93487860 ~ 2%     -16.4%   78168769 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  1.09e+08 ~ 0%      -4.3%  1.044e+08 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 1.792e+09 ~ 0%      -7.1%  1.665e+09 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 1.995e+09 ~ 0%      -7.4%  1.847e+09 ~ 0%  TOTAL perf-stat.LLC-store-misses

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 1.484e+11 ~ 1%     -14.5%  1.269e+11 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 2.041e+11 ~ 0%      -7.6%  1.886e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 9.549e+11 ~ 0%      -8.1%  8.778e+11 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 1.489e+12 ~ 0%      +3.0%  1.534e+12 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 2.797e+12 ~ 0%      -2.5%  2.728e+12 ~ 1%  TOTAL perf-stat.L1-dcache-loads

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 7.739e+10 ~ 2%     -12.1%  6.799e+10 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 1.104e+11 ~ 0%      -6.6%  1.031e+11 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 4.741e+11 ~ 0%      -6.5%  4.432e+11 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 6.618e+11 ~ 0%      -7.2%  6.143e+11 ~ 0%  TOTAL perf-stat.branch-loads

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 3.927e+11 ~ 2%     -11.8%  3.465e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 5.519e+11 ~ 1%      -5.8%  5.198e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 2.415e+12 ~ 0%      -6.9%   2.25e+12 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
  3.36e+12 ~ 0%      -7.3%  3.116e+12 ~ 0%  TOTAL perf-stat.instructions

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 9.313e+10 ~ 1%     -12.4%  8.163e+10 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 1.283e+11 ~ 0%      -5.2%  1.217e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 5.998e+11 ~ 0%      -7.0%  5.576e+11 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 8.213e+11 ~ 0%      -7.3%  7.609e+11 ~ 0%  TOTAL perf-stat.L1-dcache-stores

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 9.304e+10 ~ 1%     -12.2%  8.167e+10 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 1.284e+11 ~ 1%      -5.7%  1.211e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 5.981e+11 ~ 0%      -6.3%  5.603e+11 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 8.196e+11 ~ 0%      -6.9%  7.631e+11 ~ 0%  TOTAL perf-stat.dTLB-stores

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 7.728e+10 ~ 1%     -11.9%  6.808e+10 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 1.096e+11 ~ 0%      -6.2%  1.028e+11 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 4.747e+11 ~ 0%      -6.7%   4.43e+11 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 6.615e+11 ~ 0%      -7.2%  6.139e+11 ~ 0%  TOTAL perf-stat.branch-instructions

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 3.934e+11 ~ 1%     -11.9%  3.466e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
  5.51e+11 ~ 1%      -6.1%  5.174e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 2.417e+12 ~ 0%      -6.5%  2.261e+12 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 3.362e+12 ~ 0%      -7.0%  3.125e+12 ~ 0%  TOTAL perf-stat.iTLB-loads

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 6.663e+08 ~ 3%      +7.5%  7.164e+08 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 6.663e+08 ~ 3%      +7.5%  7.164e+08 ~ 1%  TOTAL perf-stat.LLC-prefetch-misses

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 6.128e+10 ~ 1%     -11.2%  5.441e+10 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 7.652e+10 ~ 0%      -5.6%  7.222e+10 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 5.005e+11 ~ 0%      -6.6%  4.677e+11 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 6.383e+11 ~ 0%      -6.9%  5.944e+11 ~ 0%  TOTAL perf-stat.bus-cycles

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
    100757 ~ 7%     -17.1%      83525 ~ 2%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     75328 ~ 2%      -4.8%      71699 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
    229589 ~ 0%      +1.8%     233703 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
    405674 ~ 2%      -4.1%     388927 ~ 1%  TOTAL perf-stat.cpu-migrations

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 1.753e+09 ~ 2%      -6.7%  1.635e+09 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 3.862e+10 ~ 0%      -6.5%  3.609e+10 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 4.037e+10 ~ 0%      -6.5%  3.773e+10 ~ 1%  TOTAL perf-stat.L1-dcache-load-misses

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      9670 ~ 0%      -7.0%       8996 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9670 ~ 0%      -7.0%       8996 ~ 0%  TOTAL iostat.sdd.wrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      9671 ~ 0%      -7.0%       8996 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9671 ~ 0%      -7.0%       8996 ~ 0%  TOTAL iostat.sdl.wrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      9670 ~ 0%      -7.0%       8997 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9670 ~ 0%      -7.0%       8997 ~ 0%  TOTAL iostat.sdg.wrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      9672 ~ 0%      -7.0%       8997 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9672 ~ 0%      -7.0%       8997 ~ 0%  TOTAL iostat.sdj.wrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      9671 ~ 0%      -7.0%       8996 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9671 ~ 0%      -7.0%       8996 ~ 0%  TOTAL iostat.sdk.wrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      9670 ~ 0%      -7.0%       8996 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9670 ~ 0%      -7.0%       8996 ~ 0%  TOTAL iostat.sdf.wrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      9671 ~ 0%      -7.0%       8996 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9671 ~ 0%      -7.0%       8996 ~ 0%  TOTAL iostat.sdb.wrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      9671 ~ 0%      -7.0%       8996 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9671 ~ 0%      -7.0%       8996 ~ 0%  TOTAL iostat.sdc.wrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      9670 ~ 0%      -6.9%       8998 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9670 ~ 0%      -6.9%       8998 ~ 0%  TOTAL iostat.sdh.wrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     39934 ~ 0%      -6.9%      37184 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     39934 ~ 0%      -6.9%      37184 ~ 0%  TOTAL iostat.sdd.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      9670 ~ 0%      -7.0%       8998 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9670 ~ 0%      -7.0%       8998 ~ 0%  TOTAL iostat.sde.wrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      9672 ~ 0%      -7.0%       9000 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      9672 ~ 0%      -7.0%       9000 ~ 0%  TOTAL iostat.sdi.wrqm/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     39938 ~ 0%      -6.9%      37180 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     39938 ~ 0%      -6.9%      37180 ~ 0%  TOTAL iostat.sdl.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     39932 ~ 0%      -6.9%      37188 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     39932 ~ 0%      -6.9%      37188 ~ 0%  TOTAL iostat.sdg.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     39943 ~ 0%      -6.9%      37188 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     39943 ~ 0%      -6.9%      37188 ~ 0%  TOTAL iostat.sdj.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     39938 ~ 0%      -6.9%      37184 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     39938 ~ 0%      -6.9%      37184 ~ 0%  TOTAL iostat.sdk.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 5.549e+11 ~ 1%     -11.4%  4.915e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 6.897e+11 ~ 0%      -5.5%  6.517e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 4.012e+12 ~ 0%      -6.7%  3.745e+12 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 5.776e+12 ~ 1%      +5.4%  6.087e+12 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 1.103e+13 ~ 0%      -0.5%  1.098e+13 ~ 1%  TOTAL perf-stat.ref-cycles

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     39933 ~ 0%      -6.9%      37182 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     39933 ~ 0%      -6.9%      37182 ~ 0%  TOTAL iostat.sdf.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     39935 ~ 0%      -6.9%      37181 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     39935 ~ 0%      -6.9%      37181 ~ 0%  TOTAL iostat.sdb.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     39937 ~ 0%      -6.9%      37183 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     39937 ~ 0%      -6.9%      37183 ~ 0%  TOTAL iostat.sdc.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     39932 ~ 0%      -6.9%      37189 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     39932 ~ 0%      -6.9%      37189 ~ 0%  TOTAL iostat.sde.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     39940 ~ 0%      -6.9%      37198 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     39940 ~ 0%      -6.9%      37198 ~ 0%  TOTAL iostat.sdi.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 4.924e+11 ~ 1%     -12.1%  4.326e+11 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 6.465e+11 ~ 0%      -5.1%  6.136e+11 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 4.012e+12 ~ 0%      -6.7%  3.744e+12 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 5.844e+12 ~ 1%      +4.0%  6.078e+12 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
   1.1e+13 ~ 0%      -1.2%  1.087e+13 ~ 1%  TOTAL perf-stat.cpu-cycles

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      3114 ~ 0%      -6.7%       2904 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
      3114 ~ 0%      -6.7%       2904 ~ 0%  TOTAL iostat.md0.w/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 7.507e+09 ~ 1%     -11.4%  6.648e+09 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 9.442e+09 ~ 1%      -2.7%  9.183e+09 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 7.953e+10 ~ 0%      -6.2%  7.464e+10 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 1.016e+10 ~ 1%      +6.2%   1.08e+10 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 1.066e+11 ~ 0%      -5.0%  1.013e+11 ~ 0%  TOTAL perf-stat.L1-dcache-store-misses

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 1.429e+08 ~ 3%      +6.7%  1.524e+08 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 1.429e+08 ~ 3%      +6.7%  1.524e+08 ~ 1%  TOTAL perf-stat.node-prefetch-misses

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 3.414e+08 ~ 1%     -10.2%  3.064e+08 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 3.344e+08 ~ 0%      -5.7%  3.153e+08 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 4.325e+09 ~ 0%      -6.5%  4.045e+09 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 7.883e+09 ~ 2%      +4.2%   8.21e+09 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 1.288e+10 ~ 2%      -0.0%  1.288e+10 ~ 1%  TOTAL perf-stat.cache-misses

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
  2.17e+08 ~ 1%      -9.4%  1.965e+08 ~ 2%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
   1.8e+08 ~ 1%      -3.2%  1.741e+08 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 1.902e+09 ~ 0%      -6.6%  1.776e+09 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 2.298e+09 ~ 0%      -6.6%  2.146e+09 ~ 0%  TOTAL perf-stat.LLC-load-misses

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
        15 ~ 0%      +6.7%         16 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
        15 ~ 0%      +6.7%         16 ~ 0%  TOTAL time.percent_of_cpu_this_job_got

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     71087 ~ 1%     -13.7%      61323 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     96152 ~ 0%      -4.6%      91690 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
    398295 ~ 0%      -7.1%     369881 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
    101932 ~ 0%      +3.3%     105271 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
    100595 ~ 0%      +1.9%     102504 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
    768062 ~ 0%      -4.9%     730670 ~ 0%  TOTAL vmstat.io.bo

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     71101 ~ 1%     -13.7%      61338 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
     96102 ~ 0%      -4.6%      91674 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
    101782 ~ 0%      +3.3%     105125 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
    100447 ~ 0%      +1.9%     102354 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
    369434 ~ 0%      -2.4%     360491 ~ 0%  TOTAL iostat.sda.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 6.563e+08 ~ 5%      +7.1%   7.03e+08 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 6.563e+08 ~ 5%      +7.1%   7.03e+08 ~ 0%  TOTAL perf-stat.node-prefetches

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 3.096e+09 ~ 0%      +8.9%  3.373e+09 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 1.218e+10 ~ 0%      +8.2%  1.318e+10 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 3.118e+11 ~ 0%      +1.9%  3.177e+11 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 3.271e+11 ~ 0%      +2.2%  3.342e+11 ~ 1%  TOTAL perf-stat.L1-icache-load-misses

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
   1144176 ~ 2%      -6.4%    1071004 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
    844745 ~ 0%      -5.9%     795214 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
   1988921 ~ 1%      -6.2%    1866219 ~ 0%  TOTAL perf-stat.context-switches

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 1.193e+09 ~ 1%      -4.4%  1.141e+09 ~ 1%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 1.705e+10 ~ 1%      -6.2%  1.599e+10 ~ 2%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 1.824e+10 ~ 1%      -6.1%  1.713e+10 ~ 2%  TOTAL perf-stat.LLC-loads

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 9.048e+08 ~ 1%      +6.4%  9.628e+08 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 4.005e+09 ~ 1%      +7.6%  4.309e+09 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 9.552e+11 ~ 0%      -2.5%  9.314e+11 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
 9.601e+11 ~ 0%      -2.4%  9.367e+11 ~ 0%  TOTAL perf-stat.branch-load-misses

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     39933 ~ 0%      -6.9%      37192 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
     63184 ~ 0%      +1.8%      64293 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
    103117 ~ 0%      -1.6%     101486 ~ 0%  TOTAL iostat.sdh.wkB/s

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
      1887 ~ 2%      -6.4%       1766 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
      1394 ~ 0%      -5.9%       1311 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
     12273 ~ 0%      +3.2%      12672 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
     12106 ~ 0%      +2.0%      12349 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
     27661 ~ 0%      +1.6%      28099 ~ 0%  TOTAL vmstat.system.cs

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 7.941e+09 ~ 0%      +6.4%  8.451e+09 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
 4.571e+10 ~ 0%      +2.1%  4.666e+10 ~ 1%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
 5.365e+10 ~ 0%      +2.7%  5.511e+10 ~ 0%  TOTAL perf-stat.cache-references

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 1.779e+08 ~ 0%      -4.5%  1.698e+08 ~ 2%  bay/micro/dd-write/1HDD-cfq-xfs-100dd
 2.702e+09 ~ 0%      -2.5%  2.634e+09 ~ 0%  lkp-st02/micro/dd-write/11HDD-RAID5-cfq-xfs-10dd
  2.88e+09 ~ 0%      -2.6%  2.804e+09 ~ 1%  TOTAL perf-stat.L1-dcache-prefetches

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
     15.16 ~ 1%      +2.5%      15.54 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
      6.83 ~ 0%      +3.4%       7.07 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
      7.43 ~ 0%      +1.8%       7.56 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
     29.42 ~ 0%      +2.5%      30.17 ~ 0%  TOTAL turbostat.%c0

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
 1.253e+08 ~ 0%      +3.2%  1.294e+08 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
 1.237e+08 ~ 0%      +1.8%  1.259e+08 ~ 0%  snb-drag/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
  2.49e+08 ~ 0%      +2.5%  2.553e+08 ~ 0%  TOTAL time.file_system_outputs

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       135 ~ 0%      +1.5%        137 ~ 0%  bay/micro/dd-write/1HDD-cfq-xfs-10dd
       135 ~ 0%      +1.5%        137 ~ 0%  TOTAL iostat.sda.avgqu-sz

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       139 ~ 0%      +1.1%        141 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       139 ~ 0%      +1.1%        141 ~ 0%  TOTAL iostat.sdg.avgqu-sz

836ecc5f024669e  6903673566d0289680e593dac  
---------------  -------------------------  
       139 ~ 0%      +0.9%        141 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-1dd
       139 ~ 0%      +0.9%        141 ~ 0%  TOTAL iostat.sdj.avgqu-sz


Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


                           time.voluntary_context_switches

   3500 ++----------------------------------------*-------------------------+
        *...*...*..*...*...*...*..*...*...*...*.     *...*...*...*..*...*...*
   3000 ++                                                                  |
        |                                                                   |
        |                                                                   |
   2500 ++                                                                  |
        |                  O                                                |
   2000 ++                                                                  |
        |                         O                                         |
   1500 ++                                                                  |
        |       O              O      O              O       O              |
        |          O   O                      O   O      O       O      O   |
   1000 O+                                O                         O       |
        |   O                                                               |
    500 ++------------------------------------------------------------------+


	[*] bisect-good sample
	[O] bisect-bad  sample

Thanks,
Fengguang
