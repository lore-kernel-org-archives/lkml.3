Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196AbaCOBqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 21:46:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:48237 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbaCOBqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 21:46:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,658,1389772800"; 
   d="scan'208";a="492408982"
Date: Sat, 15 Mar 2014 09:46:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [sched/balance] BUG: unable to handle kernel paging request at
 ffffffff00000058
Message-ID: <20140315014643.GB19456@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Alex, we noticed the below changes in

https://github.com/alexshi/power-scheduling.git single-balance
commit e1f728f230025ba2f2ed71e19b156291f53b68fe ("sched/balance: replace idle_balance")

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
         0           +Inf%          1       brickland2/fake/boot/1
         0           +Inf%          1       TOTAL dmesg.BUG:unable_to_haPROGRESS_CODE:V3020003_I0

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
         0           +Inf%          1       brickland2/fake/boot/1
         0           +Inf%          1       TOTAL dmesg.Kernel_panic-not_syncing:Fatal_exception_in_interrupt

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
         0           +Inf%          0 ~81%  brickland2/fake/boot/1
         0           +Inf%          0 ~81%  TOTAL dmesg.BUG:unable_to_handle_kernel_NULL_pointer_dereference

[    3.814901] PM: Registering ACPI NVS region [mem 0x650a0000-0x65375fff] (2973696 bytes)
[    3.816130] PM: Registering ACPI NVS region [mem 0x65df8000-0x66df7fff] (16777216 bytes)
[    3.820540] PM: Registering ACPI NVS region [mem 0x7accf000-0x7b6fefff] (10682368 bytes)
[    3.824649] BUG: unable to handle kernel paging request at ffffffff00000058
[    3.828000] IP: [<ffffffff810f6389>] wq_worker_waking_up+0x14/0x5b
[    3.828000] PGD 220d067 PUD 0 
[    3.828000] Oops: 0000 [#1] SMP 
[    3.828000] Modules linked in:
[    3.828000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc6-00009-ge1f728f #1
[    3.828000] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BKLDSDP1.86B.0031.R01.1304221600 04/22/2013
[    3.828000] task: ffff8808541f8000 ti: ffff8808541e6000 task.ti: ffff8808541e6000
[    3.828000] RIP: 0010:[<ffffffff810f6389>]  [<ffffffff810f6389>] wq_worker_waking_up+0x14/0x5b
[    3.828000] RSP: 0000:ffff8808541e7cf0  EFLAGS: 00010002
[    3.828000] RAX: ffffffff00000000 RBX: ffff8808543b0910 RCX: ffffffff824ee1c0
[    3.828000] RDX: 00000005811058a8 RSI: 0000000000000001 RDI: ffff8808543b0910
[    3.828000] RBP: ffff8808541e7d00 R08: 000000000000064d R09: 000000000000b7f9
[    3.828000] R10: 0000000000000027 R11: 0000000000006bd9 R12: 0000000000000001
[    3.828000] R13: 0000000000013000 R14: 0000000000000001 R15: 0000000000000001
[    3.828000] FS:  0000000000000000(0000) GS:ffff88085f800000(0000) knlGS:0000000000000000
[    3.828000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.828000] CR2: ffffffff00000058 CR3: 000000000220c000 CR4: 00000000001407f0
[    3.828000] Stack:
[    3.828000]  ffff8808543b0910 ffff88085f833000 ffff8808541e7d20 ffffffff81105a04
[    3.828000]  ffff8808543b0910 ffff88085f833000 ffff8808541e7d68 ffffffff81108259
[    3.828000]  0000000000000046 ffff8808543b0f24 ffff8808543b0910 ffff88085f838560
[    3.828000] Call Trace:
[    3.828000]  [<ffffffff81105a04>] ttwu_do_activate.constprop.88+0x4f/0x61
[    3.828000]  [<ffffffff81108259>] try_to_wake_up+0x1f7/0x228
[    3.828000]  [<ffffffff811082be>] wake_up_process+0x34/0x37
[    3.828000]  [<ffffffff810f43c0>] wake_up_worker+0x24/0x26
[    3.828000]  [<ffffffff810f4e4f>] pwq_adjust_max_active+0x7f/0xaa
[    3.828000]  [<ffffffff810f4ea9>] link_pwq+0x2f/0x4a
[    3.828000]  [<ffffffff810f7a4b>] __alloc_workqueue_key+0x29c/0x459
[    3.828000]  [<ffffffff8236ece1>] ? pm_debugfs_init+0x24/0x24
[    3.828000]  [<ffffffff8236ecff>] pm_init+0x1e/0x7b
[    3.828000]  [<ffffffff810002d2>] do_one_initcall+0xa4/0x13a
[    3.828000]  [<ffffffff810f9a0e>] ? parse_args+0x25f/0x33d
[    3.828000]  [<ffffffff8234ff94>] kernel_init_freeable+0x1a9/0x22e
[    3.828000]  [<ffffffff8234f78f>] ? do_early_param+0x88/0x88
[    3.828000]  [<ffffffff81a31495>] ? rest_init+0x89/0x89
[    3.828000]  [<ffffffff81a314a3>] kernel_init+0xe/0xdf
[    3.828000]  [<ffffffff81a4e3bc>] ret_from_fork+0x7c/0xb0
[    3.828000]  [<ffffffff81a31495>] ? rest_init+0x89/0x89
[    3.828000] Code: 46 40 83 60 14 df 48 83 c4 28 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 55 48 89 e5 41 54 41 89 f4 53 e8 c6 53 00 00 <f7> 40 58 c8 01 00 00 48 89 c3 75 36 48 8b 40 48 44 39 60 04 74 
[    3.828000] RIP  [<ffffffff810f6389>] wq_worker_waking_up+0x14/0x5b
[    3.828000]  RSP <ffff8808541e7cf0>
[    3.828000] CR2: ffffffff00000058
[    3.828000] ---[ end trace 5d87af0bad79b4cd ]---
[    3.828000] Kernel panic - not syncing: Fatal exception

Full dmesg is attached.

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     45357 ~ 2%    +254.8%     160914 ~19%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     45357 ~ 2%    +254.8%     160914 ~19%  TOTAL proc-vmstat.kswapd_low_wmark_hit_quickly

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     45379 ~ 2%    +254.7%     160970 ~19%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     45379 ~ 2%    +254.7%     160970 ~19%  TOTAL proc-vmstat.pageoutrun

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      5174 ~33%    +148.9%      12880 ~15%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      5174 ~33%    +148.9%      12880 ~15%  TOTAL proc-vmstat.numa_foreign

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      5174 ~33%    +148.9%      12880 ~15%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      5174 ~33%    +148.9%      12880 ~15%  TOTAL proc-vmstat.numa_miss

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      4821 ~38%    +138.9%      11515 ~20%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      4821 ~38%    +138.9%      11515 ~20%  TOTAL numa-numastat.node0.numa_miss

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      4821 ~38%    +138.9%      11515 ~20%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      4821 ~38%    +138.9%      11515 ~20%  TOTAL numa-numastat.node1.numa_foreign

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      5442 ~43%    +134.3%      12750 ~29%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      5442 ~43%    +134.3%      12750 ~29%  TOTAL numa-numastat.node0.other_node

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
        47 ~15%    +139.1%        113 ~35%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
        47 ~15%    +139.1%        113 ~35%  TOTAL numa-vmstat.node1.nr_vmscan_immediate_reclaim

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      4663 ~39%    +103.4%       9487 ~22%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      4663 ~39%    +103.4%       9487 ~22%  TOTAL numa-vmstat.node1.numa_foreign

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      4664 ~39%    +103.4%       9488 ~22%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      4664 ~39%    +103.4%       9488 ~22%  TOTAL numa-vmstat.node0.numa_miss

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      8267 ~21%     +93.1%      15967 ~12%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      8267 ~21%     +93.1%      15967 ~12%  TOTAL proc-vmstat.numa_other

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 8.622e+08 ~13%     +85.4%  1.599e+09 ~13%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 8.622e+08 ~13%     +85.4%  1.599e+09 ~13%  TOTAL cpuidle.C6-NHM.time

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
    316455 ~ 8%     +69.9%     537599 ~11%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
    316455 ~ 8%     +69.9%     537599 ~11%  TOTAL cpuidle.C6-NHM.usage

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      1.03 ~ 6%     -38.3%       0.64 ~ 7%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      1.03 ~ 6%     -38.3%       0.64 ~ 7%  TOTAL perf-profile.cpu-cycles._raw_read_lock.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_da_write_begin

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      1543 ~ 2%     +47.3%       2273 ~12%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      1543 ~ 2%     +47.3%       2273 ~12%  TOTAL numa-vmstat.node1.nr_alloc_batch

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
    345613 ~22%     -25.9%     256152 ~ 5%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
    345613 ~22%     -25.9%     256152 ~ 5%  TOTAL ftrace.writeback_single_inode.sdk.index

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      2.09 ~ 2%     -22.7%       1.62 ~ 7%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      2.09 ~ 2%     -22.7%       1.62 ~ 7%  TOTAL perf-profile.cpu-cycles.jbd2_journal_add_journal_head.jbd2_journal_get_write_access.__ext4_journal_get_write_access.ext4_reserve_inode_write.ext4_mark_inode_dirty

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
        10 ~ 6%     +40.7%         15 ~ 6%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
        10 ~ 6%     +40.7%         15 ~ 6%  TOTAL ftrace.writeback_single_inode.sdf.age

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
    238248 ~ 5%     +27.0%     302589 ~17%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
    238248 ~ 5%     +27.0%     302589 ~17%  TOTAL ftrace.writeback_single_inode.sdm.index

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      1.05 ~ 3%     -20.3%       0.84 ~ 7%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      1.05 ~ 3%     -20.3%       0.84 ~ 7%  TOTAL perf-profile.cpu-cycles.jbd2_journal_put_journal_head.__ext4_handle_dirty_metadata.ext4_mark_iloc_dirty.ext4_mark_inode_dirty.ext4_dirty_inode

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
        10 ~ 9%     +30.8%         13 ~12%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
        10 ~ 9%     +30.8%         13 ~12%  TOTAL ftrace.writeback_single_inode.sdl.age

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
    237566 ~ 5%     +24.0%     294617 ~ 4%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
    237566 ~ 5%     +24.0%     294617 ~ 4%  TOTAL ftrace.writeback_single_inode.sdl.index

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 6.384e+08 ~18%     +38.3%  8.829e+08 ~20%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 6.384e+08 ~18%     +38.3%  8.829e+08 ~20%  TOTAL cpuidle.C1-NHM.time

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      3094 ~ 2%     +26.4%       3909 ~ 4%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      3094 ~ 2%     +26.4%       3909 ~ 4%  TOTAL proc-vmstat.nr_alloc_batch

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
    243876 ~ 6%     +18.1%     288069 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
    243876 ~ 6%     +18.1%     288069 ~ 2%  TOTAL ftrace.writeback_single_inode.sde.index

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      1.00 ~ 3%     -15.0%       0.85 ~ 4%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      1.00 ~ 3%     -15.0%       0.85 ~ 4%  TOTAL perf-profile.cpu-cycles.jbd2_journal_put_journal_head.__ext4_journal_get_write_access.ext4_reserve_inode_write.ext4_mark_inode_dirty.ext4_dirty_inode

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     40090 ~ 0%     -14.5%      34267 ~ 7%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     40090 ~ 0%     -14.5%      34267 ~ 7%  TOTAL numa-vmstat.node0.nr_writeback

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
    160446 ~ 0%     -14.5%     137210 ~ 7%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
    160446 ~ 0%     -14.5%     137210 ~ 7%  TOTAL numa-meminfo.node0.Writeback

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      1.33 ~ 2%     -17.7%       1.10 ~ 3%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      1.33 ~ 2%     -17.7%       1.10 ~ 3%  TOTAL perf-profile.cpu-cycles.jbd2_journal_grab_journal_head.jbd2_journal_dirty_metadata.__ext4_handle_dirty_metadata.ext4_mark_iloc_dirty.ext4_mark_inode_dirty

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
  17914134 ~ 1%     -12.7%   15634924 ~ 8%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
  17914134 ~ 1%     -12.7%   15634924 ~ 8%  TOTAL proc-vmstat.pgsteal_kswapd_dma32

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
  17948005 ~ 1%     -12.7%   15670164 ~ 8%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
  17948005 ~ 1%     -12.7%   15670164 ~ 8%  TOTAL proc-vmstat.pgscan_kswapd_dma32

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
  18253751 ~ 1%     -12.5%   15974544 ~ 7%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
  18253751 ~ 1%     -12.5%   15974544 ~ 7%  TOTAL proc-vmstat.pgrefill_dma32

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
  18948889 ~ 1%     -12.2%   16635311 ~ 7%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
  18948889 ~ 1%     -12.2%   16635311 ~ 7%  TOTAL proc-vmstat.pgalloc_dma32

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      1.32 ~ 2%     -15.9%       1.11 ~ 5%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      1.32 ~ 2%     -15.9%       1.11 ~ 5%  TOTAL perf-profile.cpu-cycles.jbd2_journal_dirty_metadata.__ext4_handle_dirty_metadata.ext4_mark_iloc_dirty.ext4_mark_inode_dirty.ext4_dirty_inode

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      1.57 ~ 3%     -14.3%       1.34 ~ 5%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      1.57 ~ 3%     -14.3%       1.34 ~ 5%  TOTAL perf-profile.cpu-cycles.__find_get_block.__getblk.__ext4_get_inode_loc.ext4_get_inode_loc.ext4_reserve_inode_write

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 7.404e+09 ~ 5%     -15.1%  6.283e+09 ~ 5%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 7.404e+09 ~ 5%     -15.1%  6.283e+09 ~ 5%  TOTAL cpuidle.C3-NHM.time

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      1917 ~ 2%     +15.2%       2208 ~ 5%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      1917 ~ 2%     +15.2%       2208 ~ 5%  TOTAL uptime.idle

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      2.90 ~ 2%     -11.5%       2.56 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      2.90 ~ 2%     -11.5%       2.56 ~ 2%  TOTAL perf-profile.cpu-cycles.start_this_handle.jbd2__journal_start.__ext4_journal_start_sb.ext4_da_write_begin.generic_file_buffered_write

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      2.14 ~ 1%      -9.0%       1.95 ~ 3%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      2.14 ~ 1%      -9.0%       1.95 ~ 3%  TOTAL perf-profile.cpu-cycles.do_get_write_access.jbd2_journal_get_write_access.__ext4_journal_get_write_access.ext4_reserve_inode_write.ext4_mark_inode_dirty

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     79600 ~ 1%     +10.9%      88306 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     79600 ~ 1%     +10.9%      88306 ~ 2%  TOTAL interrupts.IWI

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 3.092e+09 ~ 6%     -59.9%  1.241e+09 ~ 4%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 3.092e+09 ~ 6%     -59.9%  1.241e+09 ~ 4%  TOTAL perf-stat.node-prefetches

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 3.096e+09 ~ 7%     -59.4%  1.257e+09 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 3.096e+09 ~ 7%     -59.4%  1.257e+09 ~ 1%  TOTAL perf-stat.LLC-prefetch-misses

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 5.024e+08 ~ 6%     -57.9%  2.114e+08 ~ 7%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 5.024e+08 ~ 6%     -57.9%  2.114e+08 ~ 7%  TOTAL perf-stat.node-prefetch-misses

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 4.226e+08 ~ 3%     -58.7%  1.747e+08 ~ 7%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 4.226e+08 ~ 3%     -58.7%  1.747e+08 ~ 7%  TOTAL perf-stat.node-store-misses

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 7.559e+08 ~ 0%     -38.6%  4.642e+08 ~15%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 7.559e+08 ~ 0%     -38.6%  4.642e+08 ~15%  TOTAL perf-stat.node-load-misses

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     88.85 ~ 1%     -31.0%      61.32 ~20%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     88.85 ~ 1%     -31.0%      61.32 ~20%  TOTAL iostat.sdi.wrqm/s

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     88.42 ~ 0%     -34.1%      58.26 ~ 8%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     88.42 ~ 0%     -34.1%      58.26 ~ 8%  TOTAL iostat.sdk.wrqm/s

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     78.01 ~ 1%     -31.1%      53.74 ~13%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     78.01 ~ 1%     -31.1%      53.74 ~13%  TOTAL iostat.sdm.wrqm/s

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     88.02 ~ 1%     -28.3%      63.08 ~15%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     88.02 ~ 1%     -28.3%      63.08 ~15%  TOTAL iostat.sdj.wrqm/s

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 3.044e+08 ~ 1%     +42.9%  4.351e+08 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 3.044e+08 ~ 1%     +42.9%  4.351e+08 ~ 1%  TOTAL perf-stat.iTLB-load-misses

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 3.286e+09 ~ 0%     -26.8%  2.406e+09 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 3.286e+09 ~ 0%     -26.8%  2.406e+09 ~ 1%  TOTAL perf-stat.node-loads

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 3.284e+09 ~ 0%     -26.5%  2.414e+09 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 3.284e+09 ~ 0%     -26.5%  2.414e+09 ~ 1%  TOTAL perf-stat.LLC-load-misses

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 1.339e+10 ~ 1%     -26.0%  9.912e+09 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 1.339e+10 ~ 1%     -26.0%  9.912e+09 ~ 1%  TOTAL perf-stat.cache-misses

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     79.24 ~ 0%     -26.4%      58.35 ~12%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     79.24 ~ 0%     -26.4%      58.35 ~12%  TOTAL iostat.sdl.wrqm/s

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     87.96 ~ 1%     -21.8%      68.81 ~13%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     87.96 ~ 1%     -21.8%      68.81 ~13%  TOTAL iostat.sdh.wrqm/s

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     77.99 ~ 1%     -20.3%      62.17 ~ 9%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     77.99 ~ 1%     -20.3%      62.17 ~ 9%  TOTAL iostat.sdf.wrqm/s

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
    758476 ~ 3%     -15.1%     643811 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
    758476 ~ 3%     -15.1%     643811 ~ 2%  TOTAL perf-stat.cpu-migrations

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 7.433e+09 ~ 5%     -15.1%  6.308e+09 ~ 3%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 7.433e+09 ~ 5%     -15.1%  6.308e+09 ~ 3%  TOTAL perf-stat.LLC-prefetches

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 7.494e+09 ~ 2%     -12.4%  6.567e+09 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 7.494e+09 ~ 2%     -12.4%  6.567e+09 ~ 1%  TOTAL perf-stat.LLC-store-misses

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     88.60 ~ 1%     -17.0%      73.58 ~18%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     88.60 ~ 1%     -17.0%      73.58 ~18%  TOTAL iostat.sdg.wrqm/s

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 7.545e+09 ~ 1%     -10.1%  6.785e+09 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 7.545e+09 ~ 1%     -10.1%  6.785e+09 ~ 2%  TOTAL perf-stat.node-stores

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 3.198e+10 ~ 1%      -8.1%  2.939e+10 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 3.198e+10 ~ 1%      -8.1%  2.939e+10 ~ 1%  TOTAL perf-stat.cache-references

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
       519 ~ 0%      -8.4%        475 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
       519 ~ 0%      -8.4%        475 ~ 1%  TOTAL iostat.sdm.w_await

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
       519 ~ 0%      -8.4%        475 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
       519 ~ 0%      -8.4%        475 ~ 1%  TOTAL iostat.sdm.await

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
       520 ~ 0%      -8.4%        477 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
       520 ~ 0%      -8.4%        477 ~ 1%  TOTAL iostat.sdl.await

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
       520 ~ 0%      -8.3%        477 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
       520 ~ 0%      -8.3%        477 ~ 1%  TOTAL iostat.sdl.w_await

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
       520 ~ 0%      -6.9%        484 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
       520 ~ 0%      -6.9%        484 ~ 1%  TOTAL iostat.sdf.await

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
       521 ~ 0%      -6.7%        486 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
       521 ~ 0%      -6.7%        486 ~ 1%  TOTAL iostat.sdf.w_await

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
       463 ~ 0%      -5.3%        439 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
       463 ~ 0%      -5.3%        439 ~ 1%  TOTAL iostat.sdj.await

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
       464 ~ 0%      -5.3%        439 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
       464 ~ 0%      -5.3%        439 ~ 1%  TOTAL iostat.sdj.w_await

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
       523 ~ 0%      -5.5%        495 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
       523 ~ 0%      -5.5%        495 ~ 2%  TOTAL iostat.sde.w_await

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
       521 ~ 0%      -5.8%        491 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
       521 ~ 0%      -5.8%        491 ~ 2%  TOTAL iostat.sde.await

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 1.373e+13 ~ 1%      -4.9%  1.306e+13 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 1.373e+13 ~ 1%      -4.9%  1.306e+13 ~ 1%  TOTAL perf-stat.ref-cycles

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 7.895e+12 ~ 0%      -4.7%  7.526e+12 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 7.895e+12 ~ 0%      -4.7%  7.526e+12 ~ 0%  TOTAL perf-stat.cpu-cycles

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 1.018e+10 ~ 1%      -3.9%  9.791e+09 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 1.018e+10 ~ 1%      -3.9%  9.791e+09 ~ 1%  TOTAL perf-stat.LLC-loads

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     33.74 ~ 0%      -4.3%      32.27 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     33.74 ~ 0%      -4.3%      32.27 ~ 0%  TOTAL turbostat.%c0

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 3.196e+11 ~ 0%      +4.2%   3.33e+11 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 3.196e+11 ~ 0%      +4.2%   3.33e+11 ~ 1%  TOTAL perf-stat.L1-icache-load-misses

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
      9443 ~ 0%      +3.3%       9753 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      9443 ~ 0%      +3.3%       9753 ~ 1%  TOTAL vmstat.system.cs

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
   5898082 ~ 0%      +3.2%    6084896 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
   5898082 ~ 0%      +3.2%    6084896 ~ 1%  TOTAL perf-stat.context-switches

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 1.554e+10 ~ 1%      -2.3%  1.517e+10 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 1.554e+10 ~ 1%      -2.3%  1.517e+10 ~ 1%  TOTAL perf-stat.L1-dcache-store-misses

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 2.048e+10 ~ 1%      -2.4%  1.998e+10 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 2.048e+10 ~ 1%      -2.4%  1.998e+10 ~ 1%  TOTAL perf-stat.LLC-stores

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     54766 ~ 0%      +2.0%      55878 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     54766 ~ 0%      +2.0%      55878 ~ 1%  TOTAL iostat.sdl.wkB/s

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     61776 ~ 0%      -2.2%      60405 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     61776 ~ 0%      -2.2%      60405 ~ 1%  TOTAL iostat.sdk.wkB/s

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
     54820 ~ 0%      +1.8%      55805 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     54820 ~ 0%      +1.8%      55805 ~ 1%  TOTAL iostat.sde.wkB/s

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 1.022e+12 ~ 0%      -1.9%  1.003e+12 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 1.022e+12 ~ 0%      -1.9%  1.003e+12 ~ 0%  TOTAL perf-stat.branch-load-misses

75921b535f3391b  e1f728f230025ba2f2ed71e19  
---------------  -------------------------  
 1.065e+12 ~ 0%      +0.9%  1.075e+12 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 1.065e+12 ~ 0%      +0.9%  1.075e+12 ~ 0%  TOTAL perf-stat.branch-loads

Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


                                 perf-stat.cache-misses

    1.4e+10 ++--------------------------------------------------------------+
   1.35e+10 *+.                 .*..        ..*..         *..               |
            |  *..*..*..*..  .*.      .*..*.            ..   *..*..*..*     |
    1.3e+10 ++             *.       *.           *..*..*                    |
   1.25e+10 ++                                                              |
            |                                                               |
    1.2e+10 ++                                                              |
   1.15e+10 ++                                                              |
    1.1e+10 ++                                                              |
            |                                                               |
   1.05e+10 ++                                                              |
      1e+10 ++                   O  O               O        O        O  O  O
            |                          O  O   O  O     O  O     O  O        |
    9.5e+09 O+ O  O  O  O  O  O                                             |
      9e+09 ++--------------------------------------------------------------+


                               perf-stat.LLC-load-misses

   3.4e+09 ++---------------------------------------------------------------+
           |          .*..                               *...*..*..*..      |
   3.2e+09 *+.*..  .*.                                 ..             *     |
           |     *.       *...*..*..*..*..*..*..  .*..*                     |
           |                                    *.                          |
     3e+09 ++                                                               |
           |                                                                |
   2.8e+09 ++                                                               |
           |                                                                |
   2.6e+09 ++                                                               |
           |                        O                                       |
           |                                                             O  O
   2.4e+09 ++ O     O     O   O  O     O  O  O  O  O  O  O   O  O  O  O     |
           O           O                                                    |
   2.2e+09 ++----O----------------------------------------------------------+


                                 perf-stat.node-loads

   3.4e+09 ++---------------------------------------------------------------+
           |                                             *...*..*..         |
   3.2e+09 *+.*..  .*..*..  ..*..*..                   ..          *..*     |
           |     *.       *.        *..*..*..*..   *..*                     |
           |                                     ..                         |
     3e+09 ++                                   *                           |
           |                                                                |
   2.8e+09 ++                                                               |
           |                                                                |
   2.6e+09 ++                       O                                       |
           |                                                                |
           |                           O                                 O  O
   2.4e+09 ++ O     O     O      O        O  O  O  O  O  O   O  O  O  O     |
           |           O      O                                             |
   2.2e+09 O+----O----------------------------------------------------------+


                               perf-stat.node-prefetches

   3.5e+09 ++------------------------------------------------*--------------+
           *..*..                                        *.                 |
     3e+09 ++    *..  .*..      .*..                   ..       *..         |
           |        *.      ..*.    *..*..*..*..  .*..*            *..*     |
           |              *.                    *.                          |
   2.5e+09 ++                                                               |
           |                                                                |
     2e+09 ++                                                               |
           |                                                                |
   1.5e+09 ++                                                               |
           |                                                                O
           |                     O  O  O  O  O  O  O  O  O   O  O  O  O  O  |
     1e+09 O+ O  O  O  O  O   O                                             |
           |                                                                |
     5e+08 ++---------------------------------------------------------------+

	[*] bisect-good sample
	[O] bisect-bad  sample

Thanks,
Fengguang

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

mkfs -t ext4 -q /dev/sde1
mkfs -t ext4 -q /dev/sdd1
mkfs -t ext4 -q /dev/sdf1
mkfs -t ext4 -q /dev/sdg1
mkfs -t ext4 -q /dev/sdi1
mkfs -t ext4 -q /dev/sdh1
mkfs -t ext4 -q /dev/sdj1
mkfs -t ext4 -q /dev/sdk1
mkfs -t ext4 -q /dev/sdl1
mkfs -t ext4 -q /dev/sdm1
mkfs -t ext4 -q /dev/sdn1
echo 1 > /sys/kernel/debug/tracing/events/writeback/balance_dirty_pages/enable
echo 1 > /sys/kernel/debug/tracing/events/writeback/bdi_dirty_ratelimit/enable
echo 1 > /sys/kernel/debug/tracing/events/writeback/global_dirty_state/enable
echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_single_inode/enable
mount -t ext4 /dev/sdd1 /fs/sdd1
mount -t ext4 /dev/sde1 /fs/sde1
mount -t ext4 /dev/sdf1 /fs/sdf1
mount -t ext4 /dev/sdg1 /fs/sdg1
mount -t ext4 /dev/sdh1 /fs/sdh1
mount -t ext4 /dev/sdi1 /fs/sdi1
mount -t ext4 /dev/sdj1 /fs/sdj1
mount -t ext4 /dev/sdk1 /fs/sdk1
mount -t ext4 /dev/sdl1 /fs/sdl1
mount -t ext4 /dev/sdm1 /fs/sdm1
mount -t ext4 /dev/sdn1 /fs/sdn1
dd  if=/dev/zero of=/fs/sdd1/zero-1 status=none &
dd  if=/dev/zero of=/fs/sde1/zero-1 status=none &
dd  if=/dev/zero of=/fs/sdf1/zero-1 status=none &
dd  if=/dev/zero of=/fs/sdg1/zero-1 status=none &
dd  if=/dev/zero of=/fs/sdh1/zero-1 status=none &
dd  if=/dev/zero of=/fs/sdi1/zero-1 status=none &
dd  if=/dev/zero of=/fs/sdj1/zero-1 status=none &
dd  if=/dev/zero of=/fs/sdk1/zero-1 status=none &
dd  if=/dev/zero of=/fs/sdl1/zero-1 status=none &
dd  if=/dev/zero of=/fs/sdm1/zero-1 status=none &
dd  if=/dev/zero of=/fs/sdn1/zero-1 status=none &
dd  if=/dev/zero of=/fs/sdd1/zero-2 status=none &
dd  if=/dev/zero of=/fs/sde1/zero-2 status=none &
dd  if=/dev/zero of=/fs/sdf1/zero-2 status=none &
dd  if=/dev/zero of=/fs/sdg1/zero-2 status=none &
dd  if=/dev/zero of=/fs/sdh1/zero-2 status=none &
dd  if=/dev/zero of=/fs/sdi1/zero-2 status=none &
dd  if=/dev/zero of=/fs/sdj1/zero-2 status=none &
dd  if=/dev/zero of=/fs/sdk1/zero-2 status=none &
dd  if=/dev/zero of=/fs/sdl1/zero-2 status=none &
dd  if=/dev/zero of=/fs/sdm1/zero-2 status=none &
dd  if=/dev/zero of=/fs/sdn1/zero-2 status=none &
dd  if=/dev/zero of=/fs/sdd1/zero-3 status=none &
dd  if=/dev/zero of=/fs/sde1/zero-3 status=none &
dd  if=/dev/zero of=/fs/sdf1/zero-3 status=none &
dd  if=/dev/zero of=/fs/sdg1/zero-3 status=none &
dd  if=/dev/zero of=/fs/sdh1/zero-3 status=none &
dd  if=/dev/zero of=/fs/sdi1/zero-3 status=none &
dd  if=/dev/zero of=/fs/sdj1/zero-3 status=none &
dd  if=/dev/zero of=/fs/sdk1/zero-3 status=none &
dd  if=/dev/zero of=/fs/sdl1/zero-3 status=none &
dd  if=/dev/zero of=/fs/sdm1/zero-3 status=none &
dd  if=/dev/zero of=/fs/sdn1/zero-3 status=none &
dd  if=/dev/zero of=/fs/sdd1/zero-4 status=none &
dd  if=/dev/zero of=/fs/sde1/zero-4 status=none &
dd  if=/dev/zero of=/fs/sdf1/zero-4 status=none &
dd  if=/dev/zero of=/fs/sdg1/zero-4 status=none &
dd  if=/dev/zero of=/fs/sdh1/zero-4 status=none &
dd  if=/dev/zero of=/fs/sdi1/zero-4 status=none &
dd  if=/dev/zero of=/fs/sdj1/zero-4 status=none &
dd  if=/dev/zero of=/fs/sdk1/zero-4 status=none &
dd  if=/dev/zero of=/fs/sdl1/zero-4 status=none &
dd  if=/dev/zero of=/fs/sdm1/zero-4 status=none &
dd  if=/dev/zero of=/fs/sdn1/zero-4 status=none &
dd  if=/dev/zero of=/fs/sdd1/zero-5 status=none &
dd  if=/dev/zero of=/fs/sde1/zero-5 status=none &
dd  if=/dev/zero of=/fs/sdf1/zero-5 status=none &
dd  if=/dev/zero of=/fs/sdg1/zero-5 status=none &
dd  if=/dev/zero of=/fs/sdh1/zero-5 status=none &
dd  if=/dev/zero of=/fs/sdi1/zero-5 status=none &
dd  if=/dev/zero of=/fs/sdj1/zero-5 status=none &
dd  if=/dev/zero of=/fs/sdk1/zero-5 status=none &
dd  if=/dev/zero of=/fs/sdl1/zero-5 status=none &
dd  if=/dev/zero of=/fs/sdm1/zero-5 status=none &
dd  if=/dev/zero of=/fs/sdn1/zero-5 status=none &
dd  if=/dev/zero of=/fs/sdd1/zero-6 status=none &
dd  if=/dev/zero of=/fs/sde1/zero-6 status=none &
dd  if=/dev/zero of=/fs/sdf1/zero-6 status=none &
dd  if=/dev/zero of=/fs/sdg1/zero-6 status=none &
dd  if=/dev/zero of=/fs/sdh1/zero-6 status=none &
dd  if=/dev/zero of=/fs/sdi1/zero-6 status=none &
dd  if=/dev/zero of=/fs/sdj1/zero-6 status=none &
dd  if=/dev/zero of=/fs/sdk1/zero-6 status=none &
dd  if=/dev/zero of=/fs/sdl1/zero-6 status=none &
dd  if=/dev/zero of=/fs/sdm1/zero-6 status=none &
dd  if=/dev/zero of=/fs/sdn1/zero-6 status=none &
dd  if=/dev/zero of=/fs/sdd1/zero-7 status=none &
dd  if=/dev/zero of=/fs/sde1/zero-7 status=none &
dd  if=/dev/zero of=/fs/sdf1/zero-7 status=none &
dd  if=/dev/zero of=/fs/sdg1/zero-7 status=none &
dd  if=/dev/zero of=/fs/sdh1/zero-7 status=none &
dd  if=/dev/zero of=/fs/sdi1/zero-7 status=none &
dd  if=/dev/zero of=/fs/sdj1/zero-7 status=none &
dd  if=/dev/zero of=/fs/sdk1/zero-7 status=none &
dd  if=/dev/zero of=/fs/sdl1/zero-7 status=none &
dd  if=/dev/zero of=/fs/sdm1/zero-7 status=none &
dd  if=/dev/zero of=/fs/sdn1/zero-7 status=none &
dd  if=/dev/zero of=/fs/sdd1/zero-8 status=none &
dd  if=/dev/zero of=/fs/sde1/zero-8 status=none &
dd  if=/dev/zero of=/fs/sdf1/zero-8 status=none &
dd  if=/dev/zero of=/fs/sdg1/zero-8 status=none &
dd  if=/dev/zero of=/fs/sdh1/zero-8 status=none &
dd  if=/dev/zero of=/fs/sdi1/zero-8 status=none &
dd  if=/dev/zero of=/fs/sdj1/zero-8 status=none &
dd  if=/dev/zero of=/fs/sdk1/zero-8 status=none &
dd  if=/dev/zero of=/fs/sdl1/zero-8 status=none &
dd  if=/dev/zero of=/fs/sdm1/zero-8 status=none &
dd  if=/dev/zero of=/fs/sdn1/zero-8 status=none &
dd  if=/dev/zero of=/fs/sdd1/zero-9 status=none &
dd  if=/dev/zero of=/fs/sde1/zero-9 status=none &
dd  if=/dev/zero of=/fs/sdf1/zero-9 status=none &
dd  if=/dev/zero of=/fs/sdg1/zero-9 status=none &
dd  if=/dev/zero of=/fs/sdh1/zero-9 status=none &
dd  if=/dev/zero of=/fs/sdi1/zero-9 status=none &
dd  if=/dev/zero of=/fs/sdj1/zero-9 status=none &
dd  if=/dev/zero of=/fs/sdk1/zero-9 status=none &
dd  if=/dev/zero of=/fs/sdl1/zero-9 status=none &
dd  if=/dev/zero of=/fs/sdm1/zero-9 status=none &
dd  if=/dev/zero of=/fs/sdn1/zero-9 status=none &
dd  if=/dev/zero of=/fs/sdd1/zero-10 status=none &
dd  if=/dev/zero of=/fs/sde1/zero-10 status=none &
dd  if=/dev/zero of=/fs/sdf1/zero-10 status=none &
dd  if=/dev/zero of=/fs/sdg1/zero-10 status=none &
dd  if=/dev/zero of=/fs/sdh1/zero-10 status=none &
dd  if=/dev/zero of=/fs/sdi1/zero-10 status=none &
dd  if=/dev/zero of=/fs/sdj1/zero-10 status=none &
dd  if=/dev/zero of=/fs/sdk1/zero-10 status=none &
dd  if=/dev/zero of=/fs/sdl1/zero-10 status=none &
dd  if=/dev/zero of=/fs/sdm1/zero-10 status=none &
dd  if=/dev/zero of=/fs/sdn1/zero-10 status=none &
sleep 598
killall -9 dd

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc6-00009-ge1f728f (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-16) ) #1 SMP Sat Mar 15 00:21:07 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/brickland2/bisect_boot-1-x86_64-lkp-e1f728f230025ba2f2ed71e19b156291f53b68fe-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/e1f728f230025ba2f2ed71e19b156291f53b68fe/vmlinuz-3.14.0-rc6-00009-ge1f728f kconfig=x86_64-lkp commit=e1f728f230025ba2f2ed71e19b156291f53b68fe modules_initrd=/kernel/x86_64-lkp/e1f728f230025ba2f2ed71e19b156291f53b68fe/modules.cgz RESULT_ROOT=/lkp/result/brickland2/fake/boot/1/x86_64-lkp/e1f728f230025ba2f2ed71e19b156291f53b68fe/4 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::brickland2::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006509ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000650a0000-0x0000000065375fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000065376000-0x0000000065a6afff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065a6b000-0x0000000065b29fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000065b2a000-0x0000000065df7fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065df8000-0x0000000066df7fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000066df8000-0x000000007abcefff] usable
[    0.000000] BIOS-e820: [mem 0x000000007abcf000-0x000000007accefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007accf000-0x000000007b6fefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b6ff000-0x000000007b7ebfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b7ec000-0x000000007b7fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Intel Corporation BRICKLAND/BRICKLAND, BIOS BKLDSDP1.86B.0031.R01.1304221600 04/22/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x2080000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000080000000 mask 3FFF80000000 uncachable
[    0.000000]   1 base 380000000000 mask 3F8000000000 uncachable
[    0.000000]   2 base 00007C000000 mask 3FFFFC000000 uncachable
[    0.000000]   3 base 00007FC00000 mask 3FFFFFC00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x7b800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009d000-0x0009d3ff]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02669000, 0x02669fff] PGTABLE
[    0.000000] BRK [0x0266a000, 0x0266afff] PGTABLE
[    0.000000] BRK [0x0266b000, 0x0266bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x207fe00000-0x207fffffff]
[    0.000000]  [mem 0x207fe00000-0x207fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x207c000000-0x207fdfffff]
[    0.000000]  [mem 0x207c000000-0x207fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x2000000000-0x207bffffff]
[    0.000000]  [mem 0x2000000000-0x207bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x1fffffffff]
[    0.000000]  [mem 0x1000000000-0x1fffffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6509ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x64ffffff] page 2M
[    0.000000]  [mem 0x65000000-0x6509ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x65376000-0x65a6afff]
[    0.000000]  [mem 0x65376000-0x653fffff] page 4k
[    0.000000]  [mem 0x65400000-0x659fffff] page 2M
[    0.000000]  [mem 0x65a00000-0x65a6afff] page 4k
[    0.000000] BRK [0x0266c000, 0x0266cfff] PGTABLE
[    0.000000] BRK [0x0266d000, 0x0266dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x65b2a000-0x65df7fff]
[    0.000000]  [mem 0x65b2a000-0x65df7fff] page 4k
[    0.000000] BRK [0x0266e000, 0x0266efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x66df8000-0x7abcefff]
[    0.000000]  [mem 0x66df8000-0x66dfffff] page 4k
[    0.000000]  [mem 0x66e00000-0x7a9fffff] page 2M
[    0.000000]  [mem 0x7aa00000-0x7abcefff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7b7ec000-0x7b7fffff]
[    0.000000]  [mem 0x7b7ec000-0x7b7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x6dbe3000-0x7abcefff]
[    0.000000] ACPI: RSDP 00000000000f0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 000000007b7ea0e8 0000AC (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: FACP 000000007b7e7000 0000F4 (v04 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000007b7b9000 022FFB (v02 INTEL  TIANO    00000003 MSFT 01000013)
[    0.000000] ACPI: FACS 000000007ae78000 000040
[    0.000000] ACPI: TCPA 000000007b7e9000 000064 (v02 INTEL  BRICKLAN 06222004 INTL 20121004)
[    0.000000] ACPI: BDAT 000000007b7e8000 000030 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: HPET 000000007b7e6000 000038 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 000000007b7e5000 00085C (v03 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000007b7e4000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: MSCT 000000007b7e3000 000090 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: PCCT 000000007b7e2000 0000AC (v01 INTEL  TIANO    00000002 MSFT 01000013)
[    0.000000] ACPI: PMCT 000000007b7e1000 000060 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: RASF 000000007b7e0000 000030 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SLIT 000000007b7df000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SRAT 000000007b7de000 000E30 (v03 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SVOS 000000007b7dd000 000032 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: WDDT 000000007b7dc000 000040 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: SSDT 0000000065a6b000 0BEF1B (v02  INTEL SSDT  PM 00004000 INTL 20090521)
[    0.000000] ACPI: SSDT 000000007b7b8000 00008B (v02  INTEL SpsNvs   00000002 INTL 20090521)
[    0.000000] ACPI: SPCR 000000007b7b7000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x18 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1c -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2c -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2e -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x38 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3c -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x48 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4c -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4e -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x58 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5c -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x68 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6c -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6e -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x78 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7c -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0f -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x19 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1d -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2d -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2f -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x39 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3d -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x49 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4d -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4f -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x59 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5d -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x69 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6d -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6f -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x79 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7d -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x87fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x880000000-0x107fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x1080000000-0x187fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x1880000000-0x207fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x87fffffff] -> [mem 0x00000000-0x87fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x87fffffff]
[    0.000000]   NODE_DATA [mem 0x87fffb000-0x87fffffff]
[    0.000000] Initmem setup node 1 [mem 0x880000000-0x107fffffff]
[    0.000000]   NODE_DATA [mem 0x107fffb000-0x107fffffff]
[    0.000000] Initmem setup node 2 [mem 0x1080000000-0x187fffffff]
[    0.000000]   NODE_DATA [mem 0x187fffb000-0x187fffffff]
[    0.000000] Initmem setup node 3 [mem 0x1880000000-0x207fffffff]
[    0.000000]   NODE_DATA [mem 0x207fff5000-0x207fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0021ffffff] PMD -> [ffff88085fe00000-ffff88087fdfffff] on node 0
[    0.000000]  [ffffea0022000000-ffffea0041ffffff] PMD -> [ffff88105fe00000-ffff88107fdfffff] on node 1
[    0.000000]  [ffffea0042000000-ffffea0061ffffff] PMD -> [ffff88185fe00000-ffff88187fdfffff] on node 2
[    0.000000]  [ffffea0062000000-ffffea0081ffffff] PMD -> [ffff88205f600000-ffff88207f5fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x207fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x6509ffff]
[    0.000000]   node   0: [mem 0x65376000-0x65a6afff]
[    0.000000]   node   0: [mem 0x65b2a000-0x65df7fff]
[    0.000000]   node   0: [mem 0x66df8000-0x7abcefff]
[    0.000000]   node   0: [mem 0x7b7ec000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
[    0.000000]   node   1: [mem 0x880000000-0x107fffffff]
[    0.000000]   node   2: [mem 0x1080000000-0x187fffffff]
[    0.000000]   node   3: [mem 0x1880000000-0x207fffffff]
[    0.000000] On node 0 totalpages: 8361963
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7714 pages used for memmap
[    0.000000]   DMA32 zone: 493646 pages, LIFO batch:31
[    0.000000]   Normal zone: 122880 pages used for memmap
[    0.000000]   Normal zone: 7864320 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0x2a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0x2c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0x2e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x50] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x52] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x54] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x56] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x58] lapic_id[0x38] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5a] lapic_id[0x3a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5c] lapic_id[0x3c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x80] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x82] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x84] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x86] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x88] lapic_id[0x48] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8a] lapic_id[0x4a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8c] lapic_id[0x4c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8e] lapic_id[0x4e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x90] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x92] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x94] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x96] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x98] lapic_id[0x58] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9a] lapic_id[0x5a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9c] lapic_id[0x5c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc0] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc2] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc4] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc6] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc8] lapic_id[0x68] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xca] lapic_id[0x6a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcc] lapic_id[0x6c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xce] lapic_id[0x6e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd0] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd2] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd4] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd6] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd8] lapic_id[0x78] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xda] lapic_id[0x7a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdc] lapic_id[0x7c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0x2b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0x2d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0x2f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x53] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x55] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x59] lapic_id[0x39] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5b] lapic_id[0x3b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5d] lapic_id[0x3d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x81] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x83] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x85] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x87] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x89] lapic_id[0x49] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8b] lapic_id[0x4b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8d] lapic_id[0x4d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8f] lapic_id[0x4f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x91] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x93] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x95] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x97] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x99] lapic_id[0x59] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9b] lapic_id[0x5b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9d] lapic_id[0x5d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc1] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc3] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc5] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc7] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc9] lapic_id[0x69] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcb] lapic_id[0x6b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcd] lapic_id[0x6d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcf] lapic_id[0x6f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd1] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd3] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd5] lapic_id[0x75] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd7] lapic_id[0x77] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd9] lapic_id[0x79] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdb] lapic_id[0x7b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdd] lapic_id[0x7d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x22] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x23] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x24] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x25] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x28] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x29] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x32] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x33] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x34] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x35] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x38] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x39] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x40] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x41] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x42] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x43] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x44] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x45] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x46] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x47] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x48] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x49] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x50] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x51] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x52] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x53] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x54] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x55] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x56] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x57] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x58] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x59] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x60] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x61] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x62] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x63] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x64] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x65] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x66] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x67] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x68] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x69] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x70] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x71] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x72] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x73] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x74] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x75] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x76] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x77] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x78] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x79] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x80] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x81] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x82] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x83] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x84] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x85] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x86] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x87] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x88] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x89] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8f] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec40000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec40000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x0b] address[0xfec80000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 11, version 32, address 0xfec80000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x0c] address[0xfecc0000] gsi_base[96])
[    0.000000] IOAPIC[4]: apic_id 12, version 32, address 0xfecc0000, GSI 96-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 144 CPUs, 24 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec40000)
[    0.000000] mapped IOAPIC to ffffffffff5ef000 (fec80000)
[    0.000000] mapped IOAPIC to ffffffffff5ee000 (fecc0000)
[    0.000000] nr_irqs_gsi: 136
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x650a0000-0x65375fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65a6b000-0x65b29fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65df8000-0x66df7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7abcf000-0x7accefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7accf000-0x7b6fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b6ff000-0x7b7ebfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b800000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:144 nr_node_ids:4
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88085f800000 s81088 r8192 d21312 u131072
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 008 009 010 011 012 013 014 060 
[    0.000000] pcpu-alloc: [0] 061 062 063 064 065 066 067 068 069 070 071 072 073 074 120 124 
[    0.000000] pcpu-alloc: [0] 128 132 136 140 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [1] 015 016 017 018 019 020 021 022 023 024 025 026 027 028 029 075 
[    0.000000] pcpu-alloc: [1] 076 077 078 079 080 081 082 083 084 085 086 087 088 089 121 125 
[    0.000000] pcpu-alloc: [1] 129 133 137 141 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [2] 030 031 032 033 034 035 036 037 038 039 040 041 042 043 044 090 
[    0.000000] pcpu-alloc: [2] 091 092 093 094 095 096 097 098 099 100 101 102 103 104 122 126 
[    0.000000] pcpu-alloc: [2] 130 134 138 142 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [3] 045 046 047 048 049 050 051 052 053 054 055 056 057 058 059 105 
[    0.000000] pcpu-alloc: [3] 106 107 108 109 110 111 112 113 114 115 116 117 118 119 123 127 
[    0.000000] pcpu-alloc: [3] 131 135 139 143 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 33003890
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/brickland2/bisect_boot-1-x86_64-lkp-e1f728f230025ba2f2ed71e19b156291f53b68fe-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/e1f728f230025ba2f2ed71e19b156291f53b68fe/vmlinuz-3.14.0-rc6-00009-ge1f728f kconfig=x86_64-lkp commit=e1f728f230025ba2f2ed71e19b156291f53b68fe modules_initrd=/kernel/x86_64-lkp/e1f728f230025ba2f2ed71e19b156291f53b68fe/modules.cgz RESULT_ROOT=/lkp/result/brickland2/fake/boot/1/x86_64-lkp/e1f728f230025ba2f2ed71e19b156291f53b68fe/4 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::brickland2::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 131695700K/134111148K available (10574K kernel code, 1252K rwdata, 4272K rodata, 1440K init, 1760K bss, 2415448K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=144, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=144.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=144
[    0.000000] NR_IRQS:33024 nr_irqs:3464 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc6-00009-ge1f728f (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-16) ) #1 SMP Sat Mar 15 00:21:07 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/brickland2/bisect_boot-1-x86_64-lkp-e1f728f230025ba2f2ed71e19b156291f53b68fe-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/e1f728f230025ba2f2ed71e19b156291f53b68fe/vmlinuz-3.14.0-rc6-00009-ge1f728f kconfig=x86_64-lkp commit=e1f728f230025ba2f2ed71e19b156291f53b68fe modules_initrd=/kernel/x86_64-lkp/e1f728f230025ba2f2ed71e19b156291f53b68fe/modules.cgz RESULT_ROOT=/lkp/result/brickland2/fake/boot/1/x86_64-lkp/e1f728f230025ba2f2ed71e19b156291f53b68fe/4 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::brickland2::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006509ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000650a0000-0x0000000065375fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000065376000-0x0000000065a6afff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065a6b000-0x0000000065b29fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000065b2a000-0x0000000065df7fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065df8000-0x0000000066df7fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000066df8000-0x000000007abcefff] usable
[    0.000000] BIOS-e820: [mem 0x000000007abcf000-0x000000007accefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007accf000-0x000000007b6fefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b6ff000-0x000000007b7ebfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b7ec000-0x000000007b7fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Intel Corporation BRICKLAND/BRICKLAND, BIOS BKLDSDP1.86B.0031.R01.1304221600 04/22/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x2080000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000080000000 mask 3FFF80000000 uncachable
[    0.000000]   1 base 380000000000 mask 3F8000000000 uncachable
[    0.000000]   2 base 00007C000000 mask 3FFFFC000000 uncachable
[    0.000000]   3 base 00007FC00000 mask 3FFFFFC00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x7b800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009d000-0x0009d3ff]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02669000, 0x02669fff] PGTABLE
[    0.000000] BRK [0x0266a000, 0x0266afff] PGTABLE
[    0.000000] BRK [0x0266b000, 0x0266bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x207fe00000-0x207fffffff]
[    0.000000]  [mem 0x207fe00000-0x207fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x207c000000-0x207fdfffff]
[    0.000000]  [mem 0x207c000000-0x207fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x2000000000-0x207bffffff]
[    0.000000]  [mem 0x2000000000-0x207bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x1fffffffff]
[    0.000000]  [mem 0x1000000000-0x1fffffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6509ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x64ffffff] page 2M
[    0.000000]  [mem 0x65000000-0x6509ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x65376000-0x65a6afff]
[    0.000000]  [mem 0x65376000-0x653fffff] page 4k
[    0.000000]  [mem 0x65400000-0x659fffff] page 2M
[    0.000000]  [mem 0x65a00000-0x65a6afff] page 4k
[    0.000000] BRK [0x0266c000, 0x0266cfff] PGTABLE
[    0.000000] BRK [0x0266d000, 0x0266dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x65b2a000-0x65df7fff]
[    0.000000]  [mem 0x65b2a000-0x65df7fff] page 4k
[    0.000000] BRK [0x0266e000, 0x0266efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x66df8000-0x7abcefff]
[    0.000000]  [mem 0x66df8000-0x66dfffff] page 4k
[    0.000000]  [mem 0x66e00000-0x7a9fffff] page 2M
[    0.000000]  [mem 0x7aa00000-0x7abcefff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7b7ec000-0x7b7fffff]
[    0.000000]  [mem 0x7b7ec000-0x7b7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x6dbe3000-0x7abcefff]
[    0.000000] ACPI: RSDP 00000000000f0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 000000007b7ea0e8 0000AC (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: FACP 000000007b7e7000 0000F4 (v04 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000007b7b9000 022FFB (v02 INTEL  TIANO    00000003 MSFT 01000013)
[    0.000000] ACPI: FACS 000000007ae78000 000040
[    0.000000] ACPI: TCPA 000000007b7e9000 000064 (v02 INTEL  BRICKLAN 06222004 INTL 20121004)
[    0.000000] ACPI: BDAT 000000007b7e8000 000030 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: HPET 000000007b7e6000 000038 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 000000007b7e5000 00085C (v03 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000007b7e4000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: MSCT 000000007b7e3000 000090 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: PCCT 000000007b7e2000 0000AC (v01 INTEL  TIANO    00000002 MSFT 01000013)
[    0.000000] ACPI: PMCT 000000007b7e1000 000060 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: RASF 000000007b7e0000 000030 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SLIT 000000007b7df000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SRAT 000000007b7de000 000E30 (v03 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SVOS 000000007b7dd000 000032 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: WDDT 000000007b7dc000 000040 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: SSDT 0000000065a6b000 0BEF1B (v02  INTEL SSDT  PM 00004000 INTL 20090521)
[    0.000000] ACPI: SSDT 000000007b7b8000 00008B (v02  INTEL SpsNvs   00000002 INTL 20090521)
[    0.000000] ACPI: SPCR 000000007b7b7000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x18 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1c -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2c -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2e -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x38 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3c -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x48 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4c -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4e -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x58 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5c -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x68 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6c -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6e -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x78 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7c -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0f -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x19 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1d -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2d -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2f -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x39 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3d -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x49 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4d -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4f -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x59 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5d -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x69 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6d -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6f -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x79 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7d -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x87fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x880000000-0x107fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x1080000000-0x187fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x1880000000-0x207fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x87fffffff] -> [mem 0x00000000-0x87fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x87fffffff]
[    0.000000]   NODE_DATA [mem 0x87fffb000-0x87fffffff]
[    0.000000] Initmem setup node 1 [mem 0x880000000-0x107fffffff]
[    0.000000]   NODE_DATA [mem 0x107fffb000-0x107fffffff]
[    0.000000] Initmem setup node 2 [mem 0x1080000000-0x187fffffff]
[    0.000000]   NODE_DATA [mem 0x187fffb000-0x187fffffff]
[    0.000000] Initmem setup node 3 [mem 0x1880000000-0x207fffffff]
[    0.000000]   NODE_DATA [mem 0x207fff5000-0x207fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0021ffffff] PMD -> [ffff88085fe00000-ffff88087fdfffff] on node 0
[    0.000000]  [ffffea0022000000-ffffea0041ffffff] PMD -> [ffff88105fe00000-ffff88107fdfffff] on node 1
[    0.000000]  [ffffea0042000000-ffffea0061ffffff] PMD -> [ffff88185fe00000-ffff88187fdfffff] on node 2
[    0.000000]  [ffffea0062000000-ffffea0081ffffff] PMD -> [ffff88205f600000-ffff88207f5fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x207fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x6509ffff]
[    0.000000]   node   0: [mem 0x65376000-0x65a6afff]
[    0.000000]   node   0: [mem 0x65b2a000-0x65df7fff]
[    0.000000]   node   0: [mem 0x66df8000-0x7abcefff]
[    0.000000]   node   0: [mem 0x7b7ec000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
[    0.000000]   node   1: [mem 0x880000000-0x107fffffff]
[    0.000000]   node   2: [mem 0x1080000000-0x187fffffff]
[    0.000000]   node   3: [mem 0x1880000000-0x207fffffff]
[    0.000000] On node 0 totalpages: 8361963
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7714 pages used for memmap
[    0.000000]   DMA32 zone: 493646 pages, LIFO batch:31
[    0.000000]   Normal zone: 122880 pages used for memmap
[    0.000000]   Normal zone: 7864320 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0x2a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0x2c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0x2e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x50] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x52] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x54] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x56] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x58] lapic_id[0x38] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5a] lapic_id[0x3a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5c] lapic_id[0x3c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x80] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x82] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x84] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x86] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x88] lapic_id[0x48] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8a] lapic_id[0x4a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8c] lapic_id[0x4c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8e] lapic_id[0x4e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x90] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x92] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x94] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x96] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x98] lapic_id[0x58] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9a] lapic_id[0x5a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9c] lapic_id[0x5c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc0] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc2] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc4] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc6] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc8] lapic_id[0x68] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xca] lapic_id[0x6a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcc] lapic_id[0x6c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xce] lapic_id[0x6e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd0] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd2] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd4] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd6] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd8] lapic_id[0x78] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xda] lapic_id[0x7a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdc] lapic_id[0x7c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0x2b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0x2d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0x2f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x53] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x55] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x59] lapic_id[0x39] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5b] lapic_id[0x3b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5d] lapic_id[0x3d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x81] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x83] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x85] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x87] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x89] lapic_id[0x49] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8b] lapic_id[0x4b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8d] lapic_id[0x4d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8f] lapic_id[0x4f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x91] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x93] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x95] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x97] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x99] lapic_id[0x59] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9b] lapic_id[0x5b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9d] lapic_id[0x5d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc1] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc3] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc5] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc7] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc9] lapic_id[0x69] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcb] lapic_id[0x6b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcd] lapic_id[0x6d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcf] lapic_id[0x6f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd1] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd3] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd5] lapic_id[0x75] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd7] lapic_id[0x77] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd9] lapic_id[0x79] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdb] lapic_id[0x7b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdd] lapic_id[0x7d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x22] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x23] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x24] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x25] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x28] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x29] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x32] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x33] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x34] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x35] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x38] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x39] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x40] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x41] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x42] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x43] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x44] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x45] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x46] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x47] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x48] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x49] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x50] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x51] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x52] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x53] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x54] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x55] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x56] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x57] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x58] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x59] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x60] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x61] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x62] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x63] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x64] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x65] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x66] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x67] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x68] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x69] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x70] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x71] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x72] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x73] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x74] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x75] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x76] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x77] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x78] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x79] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x80] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x81] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x82] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x83] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x84] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x85] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x86] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x87] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x88] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x89] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8f] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec40000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec40000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x0b] address[0xfec80000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 11, version 32, address 0xfec80000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x0c] address[0xfecc0000] gsi_base[96])
[    0.000000] IOAPIC[4]: apic_id 12, version 32, address 0xfecc0000, GSI 96-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 144 CPUs, 24 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec40000)
[    0.000000] mapped IOAPIC to ffffffffff5ef000 (fec80000)
[    0.000000] mapped IOAPIC to ffffffffff5ee000 (fecc0000)
[    0.000000] nr_irqs_gsi: 136
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x650a0000-0x65375fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65a6b000-0x65b29fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65df8000-0x66df7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7abcf000-0x7accefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7accf000-0x7b6fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b6ff000-0x7b7ebfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b800000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:144 nr_node_ids:4
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88085f800000 s81088 r8192 d21312 u131072
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 008 009 010 011 012 013 014 060 
[    0.000000] pcpu-alloc: [0] 061 062 063 064 065 066 067 068 069 070 071 072 073 074 120 124 
[    0.000000] pcpu-alloc: [0] 128 132 136 140 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [1] 015 016 017 018 019 020 021 022 023 024 025 026 027 028 029 075 
[    0.000000] pcpu-alloc: [1] 076 077 078 079 080 081 082 083 084 085 086 087 088 089 121 125 
[    0.000000] pcpu-alloc: [1] 129 133 137 141 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [2] 030 031 032 033 034 035 036 037 038 039 040 041 042 043 044 090 
[    0.000000] pcpu-alloc: [2] 091 092 093 094 095 096 097 098 099 100 101 102 103 104 122 126 
[    0.000000] pcpu-alloc: [2] 130 134 138 142 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [3] 045 046 047 048 049 050 051 052 053 054 055 056 057 058 059 105 
[    0.000000] pcpu-alloc: [3] 106 107 108 109 110 111 112 113 114 115 116 117 118 119 123 127 
[    0.000000] pcpu-alloc: [3] 131 135 139 143 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 33003890
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/brickland2/bisect_boot-1-x86_64-lkp-e1f728f230025ba2f2ed71e19b156291f53b68fe-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/e1f728f230025ba2f2ed71e19b156291f53b68fe/vmlinuz-3.14.0-rc6-00009-ge1f728f kconfig=x86_64-lkp commit=e1f728f230025ba2f2ed71e19b156291f53b68fe modules_initrd=/kernel/x86_64-lkp/e1f728f230025ba2f2ed71e19b156291f53b68fe/modules.cgz RESULT_ROOT=/lkp/result/brickland2/fake/boot/1/x86_64-lkp/e1f728f230025ba2f2ed71e19b156291f53b68fe/4 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::brickland2::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 131695700K/134111148K available (10574K kernel code, 1252K rwdata, 4272K rodata, 1440K init, 1760K bss, 2415448K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=144, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=144.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=144
[    0.000000] NR_IRQS:33024 nr_irqs:3464 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 536870912 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Disabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 2799.803 MHz processor
[    0.000183] Calibrating delay loop (skipped), value calculated using timer frequency.. 5599.60 BogoMIPS (lpj=11199212)
[    0.012552] pid_max: default: 147456 minimum: 1152
[    0.057620] Dentry cache hash table entries: 16777216 (order: 15, 134217728 bytes)
[    0.213808] Inode-cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.286491] Mount-cache hash table entries: 256
[    0.294652] Initializing cgroup subsys memory
[    0.300665] Initializing cgroup subsys devices
[    0.306632] Initializing cgroup subsys freezer
[    0.312574] Initializing cgroup subsys blkio
[    0.318319] Initializing cgroup subsys perf_event
[    0.324589] Initializing cgroup subsys hugetlb
[    0.330957] CPU: Physical Processor ID: 0
[    0.336414] CPU: Processor Core ID: 0
[    0.344777] mce: CPU supports 32 MCE banks
[    0.350554] CPU0: Thermal LVT vector (0xfa) already installed
[    0.358033] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.358033] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.358033] tlb_flushall_shift: 6
[    0.378190] Freeing SMP alternatives memory: 44K (ffffffff824a3000 - ffffffff824ae000)
[    0.395829] ftrace: allocating 40435 entries in 158 pages
[    0.483256] Getting VERSION: 1060015
[    0.488242] Getting VERSION: 1060015
[    0.493230] Getting ID: 0
[    0.497146] Getting ID: 0
[    0.501064] Switched APIC routing to physical flat.
[    0.507496] masked ExtINT on CPU#0
[    0.514115] ENABLING IO-APIC IRQs
[    0.518796] init IO_APIC IRQs
[    0.523104]  apic 8 pin 0 not connected
[    0.528389] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.539076] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.549749] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.560435] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.571086] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.581761] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.592445] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.603133] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.613814] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    0.624496] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.635395] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.646287] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.657181] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.668069] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    0.678945] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.689841]  apic 8 pin 16 not connected
[    0.695200]  apic 8 pin 17 not connected
[    0.700563]  apic 8 pin 18 not connected
[    0.705932]  apic 8 pin 19 not connected
[    0.711295]  apic 8 pin 20 not connected
[    0.716658]  apic 8 pin 21 not connected
[    0.722020]  apic 8 pin 22 not connected
[    0.727378]  apic 8 pin 23 not connected
[    0.732734]  apic 9 pin 0 not connected
[    0.738015]  apic 9 pin 1 not connected
[    0.743296]  apic 9 pin 2 not connected
[    0.748571]  apic 9 pin 3 not connected
[    0.753843]  apic 9 pin 4 not connected
[    0.759124]  apic 9 pin 5 not connected
[    0.764403]  apic 9 pin 6 not connected
[    0.769680]  apic 9 pin 7 not connected
[    0.774962]  apic 9 pin 8 not connected
[    0.780244]  apic 9 pin 9 not connected
[    0.785519]  apic 9 pin 10 not connected
[    0.790884]  apic 9 pin 11 not connected
[    0.796244]  apic 9 pin 12 not connected
[    0.801600]  apic 9 pin 13 not connected
[    0.806960]  apic 9 pin 14 not connected
[    0.812323]  apic 9 pin 15 not connected
[    0.817690]  apic 9 pin 16 not connected
[    0.823053]  apic 9 pin 17 not connected
[    0.828420]  apic 9 pin 18 not connected
[    0.833784]  apic 9 pin 19 not connected
[    0.839144]  apic 9 pin 20 not connected
[    0.844504]  apic 9 pin 21 not connected
[    0.849867]  apic 9 pin 22 not connected
[    0.855226]  apic 9 pin 23 not connected
[    0.860591]  apic 10 pin 0 not connected
[    0.865956]  apic 10 pin 1 not connected
[    0.871320]  apic 10 pin 2 not connected
[    0.876679]  apic 10 pin 3 not connected
[    0.882044]  apic 10 pin 4 not connected
[    0.887410]  apic 10 pin 5 not connected
[    0.892775]  apic 10 pin 6 not connected
[    0.898142]  apic 10 pin 7 not connected
[    0.903503]  apic 10 pin 8 not connected
[    0.908864]  apic 10 pin 9 not connected
[    0.914222]  apic 10 pin 10 not connected
[    0.919702]  apic 10 pin 11 not connected
[    0.925165]  apic 10 pin 12 not connected
[    0.930643]  apic 10 pin 13 not connected
[    0.936100]  apic 10 pin 14 not connected
[    0.941582]  apic 10 pin 15 not connected
[    0.947040]  apic 10 pin 16 not connected
[    0.952519]  apic 10 pin 17 not connected
[    0.957977]  apic 10 pin 18 not connected
[    0.963434]  apic 10 pin 19 not connected
[    0.968911]  apic 10 pin 20 not connected
[    0.974372]  apic 10 pin 21 not connected
[    0.979851]  apic 10 pin 22 not connected
[    0.985309]  apic 10 pin 23 not connected
[    0.990789]  apic 11 pin 0 not connected
[    0.996155]  apic 11 pin 1 not connected
[    1.001518]  apic 11 pin 2 not connected
[    1.006882]  apic 11 pin 3 not connected
[    1.012245]  apic 11 pin 4 not connected
[    1.017609]  apic 11 pin 5 not connected
[    1.022968]  apic 11 pin 6 not connected
[    1.028332]  apic 11 pin 7 not connected
[    1.033694]  apic 11 pin 8 not connected
[    1.039058]  apic 11 pin 9 not connected
[    1.044425]  apic 11 pin 10 not connected
[    1.049908]  apic 11 pin 11 not connected
[    1.055367]  apic 11 pin 12 not connected
[    1.060844]  apic 11 pin 13 not connected
[    1.066300]  apic 11 pin 14 not connected
[    1.071759]  apic 11 pin 15 not connected
[    1.077240]  apic 11 pin 16 not connected
[    1.082699]  apic 11 pin 17 not connected
[    1.088180]  apic 11 pin 18 not connected
[    1.093637]  apic 11 pin 19 not connected
[    1.099116]  apic 11 pin 20 not connected
[    1.104575]  apic 11 pin 21 not connected
[    1.110055]  apic 11 pin 22 not connected
[    1.115513]  apic 11 pin 23 not connected
[    1.120974]  apic 12 pin 0 not connected
[    1.126333]  apic 12 pin 1 not connected
[    1.131697]  apic 12 pin 2 not connected
[    1.137059]  apic 12 pin 3 not connected
[    1.142422]  apic 12 pin 4 not connected
[    1.147780]  apic 12 pin 5 not connected
[    1.153147]  apic 12 pin 6 not connected
[    1.158511]  apic 12 pin 7 not connected
[    1.163875]  apic 12 pin 8 not connected
[    1.169236]  apic 12 pin 9 not connected
[    1.174598]  apic 12 pin 10 not connected
[    1.180058]  apic 12 pin 11 not connected
[    1.185520]  apic 12 pin 12 not connected
[    1.191001]  apic 12 pin 13 not connected
[    1.196458]  apic 12 pin 14 not connected
[    1.201933]  apic 12 pin 15 not connected
[    1.207390]  apic 12 pin 16 not connected
[    1.212870]  apic 12 pin 17 not connected
[    1.218328]  apic 12 pin 18 not connected
[    1.223804]  apic 12 pin 19 not connected
[    1.229261]  apic 12 pin 20 not connected
[    1.234720]  apic 12 pin 21 not connected
[    1.240201]  apic 12 pin 22 not connected
[    1.245659]  apic 12 pin 23 not connected
[    1.251302] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    1.298939] smpboot: CPU0: Intel(R) Xeon(R) CPU E7-4890 V2 @ 2.80GHz (fam: 06, model: 3e, stepping: 07)
[    1.311796] TSC deadline timer enabled
[    1.317109] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    1.331347] ... version:                3
[    1.336828] ... bit width:              48
[    1.342404] ... generic registers:      4
[    1.347864] ... value mask:             0000ffffffffffff
[    1.354829] ... max period:             0000ffffffffffff
[    1.361766] ... fixed-purpose events:   3
[    1.367249] ... event mask:             000000070000000f
[    1.389043] x86: Booting SMP configuration:
[    1.394721] .... node  #0, CPUs:          #1
[    1.422099] masked ExtINT on CPU#1
[    1.429734] CPU1: Thermal LVT vector (0xfa) already installed
[    1.439349]    #2
[    1.454631] masked ExtINT on CPU#2
[    1.462334] CPU2: Thermal LVT vector (0xfa) already installed
[    1.471735]    #3
[    1.487781] masked ExtINT on CPU#3
[    1.495487] CPU3: Thermal LVT vector (0xfa) already installed
[    1.505065]    #4
[    1.520320] masked ExtINT on CPU#4
[    1.528060] CPU4: Thermal LVT vector (0xfa) already installed
[    1.537532]    #5
[    1.552853] masked ExtINT on CPU#5
[    1.560854] CPU5: Thermal LVT vector (0xfa) already installed
[    1.570300]    #6
[    1.585634] masked ExtINT on CPU#6
[    1.593421] CPU6: Thermal LVT vector (0xfa) already installed
[    1.603077]    #7
[    1.619170] masked ExtINT on CPU#7
[    1.626961] CPU7: Thermal LVT vector (0xfa) already installed
[    1.636490]    #8
[    1.651803] masked ExtINT on CPU#8
[    1.659524] CPU8: Thermal LVT vector (0xfa) already installed
[    1.669007]    #9
[    1.684283] masked ExtINT on CPU#9
[    1.692016] CPU9: Thermal LVT vector (0xfa) already installed
[    1.701568]   #10
[    1.716745] masked ExtINT on CPU#10
[    1.724610] CPU10: Thermal LVT vector (0xfa) already installed
[    1.734297]   #11
[    1.750261] masked ExtINT on CPU#11
[    1.757981] CPU11: Thermal LVT vector (0xfa) already installed
[    1.767462]   #12
[    1.782604] masked ExtINT on CPU#12
[    1.790312] CPU12: Thermal LVT vector (0xfa) already installed
[    1.799973]   #13
[    1.815098] masked ExtINT on CPU#13
[    1.822734] CPU13: Thermal LVT vector (0xfa) already installed
[    1.832424]   #14
[    1.847587] masked ExtINT on CPU#14
[    1.855225] CPU14: Thermal LVT vector (0xfa) already installed
[    1.864999] 
[    1.868479] .... node  #1, CPUs:    #15
[    1.891480] masked ExtINT on CPU#15
[    1.899153] CPU15: Thermal LVT vector (0xfa) already installed
[    2.005523] TSC synchronization [CPU#0 -> CPU#15]:
[    2.032747] Measured 23614 cycles TSC warp between CPUs, turning off TSC clock.
[    2.042710] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    0.004000]   #16
[    0.004000] masked ExtINT on CPU#16
[    0.004000] CPU16: Thermal LVT vector (0xfa) already installed
[    1.186825]   #17
[    0.004000] masked ExtINT on CPU#17
[    0.004000] CPU17: Thermal LVT vector (0xfa) already installed
[    1.216088]   #18
[    0.004000] masked ExtINT on CPU#18
[    0.004000] CPU18: Thermal LVT vector (0xfa) already installed
[    1.246324]   #19
[    0.004000] masked ExtINT on CPU#19
[    0.004000] CPU19: Thermal LVT vector (0xfa) already installed
[    1.276082]   #20
[    0.004000] masked ExtINT on CPU#20
[    0.004000] CPU20: Thermal LVT vector (0xfa) already installed
[    1.307486]   #21
[    0.004000] masked ExtINT on CPU#21
[    0.004000] CPU21: Thermal LVT vector (0xfa) already installed
[    1.336159]   #22
[    0.004000] masked ExtINT on CPU#22
[    0.004000] CPU22: Thermal LVT vector (0xfa) already installed
[    1.366539]   #23
[    0.004000] masked ExtINT on CPU#23
[    0.004000] CPU23: Thermal LVT vector (0xfa) already installed
[    1.396204]   #24
[    0.004000] masked ExtINT on CPU#24
[    0.004000] CPU24: Thermal LVT vector (0xfa) already installed
[    1.427255]   #25
[    0.004000] masked ExtINT on CPU#25
[    0.004000] CPU25: Thermal LVT vector (0xfa) already installed
[    1.456045]   #26
[    0.004000] masked ExtINT on CPU#26
[    0.004000] CPU26: Thermal LVT vector (0xfa) already installed
[    1.486039]   #27
[    0.004000] masked ExtINT on CPU#27
[    0.004000] CPU27: Thermal LVT vector (0xfa) already installed
[    1.515798]   #28
[    0.004000] masked ExtINT on CPU#28
[    0.004000] CPU28: Thermal LVT vector (0xfa) already installed
[    1.543789]   #29
[    0.004000] masked ExtINT on CPU#29
[    0.004000] CPU29: Thermal LVT vector (0xfa) already installed
[    1.571870] 
[    1.572003] .... node  #2, CPUs:    #30
[    0.004000] masked ExtINT on CPU#30
[    0.004000] CPU30: Thermal LVT vector (0xfa) already installed
[    1.684792]   #31
[    0.004000] masked ExtINT on CPU#31
[    0.004000] CPU31: Thermal LVT vector (0xfa) already installed
[    1.714933]   #32
[    0.004000] masked ExtINT on CPU#32
[    0.004000] CPU32: Thermal LVT vector (0xfa) already installed
[    1.743993]   #33
[    0.004000] masked ExtINT on CPU#33
[    0.004000] CPU33: Thermal LVT vector (0xfa) already installed
[    1.772123]   #34
[    0.004000] masked ExtINT on CPU#34
[    0.004000] CPU34: Thermal LVT vector (0xfa) already installed
[    1.802427]   #35
[    0.004000] masked ExtINT on CPU#35
[    0.004000] CPU35: Thermal LVT vector (0xfa) already installed
[    1.832426]   #36
[    0.004000] masked ExtINT on CPU#36
[    0.004000] CPU36: Thermal LVT vector (0xfa) already installed
[    1.863667]   #37
[    0.004000] masked ExtINT on CPU#37
[    0.004000] CPU37: Thermal LVT vector (0xfa) already installed
[    1.892113]   #38
[    0.004000] masked ExtINT on CPU#38
[    0.004000] CPU38: Thermal LVT vector (0xfa) already installed
[    1.922419]   #39
[    0.004000] masked ExtINT on CPU#39
[    0.004000] CPU39: Thermal LVT vector (0xfa) already installed
[    1.952241]   #40
[    0.004000] masked ExtINT on CPU#40
[    0.004000] CPU40: Thermal LVT vector (0xfa) already installed
[    1.983170]   #41
[    0.004000] masked ExtINT on CPU#41
[    0.004000] CPU41: Thermal LVT vector (0xfa) already installed
[    2.011827]   #42
[    0.004000] masked ExtINT on CPU#42
[    0.004000] CPU42: Thermal LVT vector (0xfa) already installed
[    2.039961]   #43
[    0.004000] masked ExtINT on CPU#43
[    0.004000] CPU43: Thermal LVT vector (0xfa) already installed
[    2.067723]   #44
[    0.004000] masked ExtINT on CPU#44
[    0.004000] CPU44: Thermal LVT vector (0xfa) already installed
[    2.095960] 
[    2.096003] .... node  #3, CPUs:    #45
[    0.004000] masked ExtINT on CPU#45
[    0.004000] CPU45: Thermal LVT vector (0xfa) already installed
[    2.212727]   #46
[    0.004000] masked ExtINT on CPU#46
[    0.004000] CPU46: Thermal LVT vector (0xfa) already installed
[    2.242887]   #47
[    0.004000] masked ExtINT on CPU#47
[    0.004000] CPU47: Thermal LVT vector (0xfa) already installed
[    2.272114]   #48
[    0.004000] masked ExtINT on CPU#48
[    0.004000] CPU48: Thermal LVT vector (0xfa) already installed
[    2.302329]   #49
[    0.004000] masked ExtINT on CPU#49
[    0.004000] CPU49: Thermal LVT vector (0xfa) already installed
[    2.332115]   #50
[    0.004000] masked ExtINT on CPU#50
[    0.004000] CPU50: Thermal LVT vector (0xfa) already installed
[    2.362705]   #51
[    0.004000] masked ExtINT on CPU#51
[    0.004000] CPU51: Thermal LVT vector (0xfa) already installed
[    2.392166]   #52
[    0.004000] masked ExtINT on CPU#52
[    0.004000] CPU52: Thermal LVT vector (0xfa) already installed
[    2.422500]   #53
[    0.004000] masked ExtINT on CPU#53
[    0.004000] CPU53: Thermal LVT vector (0xfa) already installed
[    2.452123]   #54
[    0.004000] masked ExtINT on CPU#54
[    0.004000] CPU54: Thermal LVT vector (0xfa) already installed
[    2.482421]   #55
[    0.004000] masked ExtINT on CPU#55
[    0.004000] CPU55: Thermal LVT vector (0xfa) already installed
[    2.512036]   #56
[    0.004000] masked ExtINT on CPU#56
[    0.004000] CPU56: Thermal LVT vector (0xfa) already installed
[    2.542036]   #57
[    0.004000] masked ExtINT on CPU#57
[    0.004000] CPU57: Thermal LVT vector (0xfa) already installed
[    2.571909]   #58
[    0.004000] masked ExtINT on CPU#58
[    0.004000] CPU58: Thermal LVT vector (0xfa) already installed
[    2.599843]   #59
[    0.004000] masked ExtINT on CPU#59
[    0.004000] CPU59: Thermal LVT vector (0xfa) already installed
[    2.627830] 
[    2.628003] .... node  #0, CPUs:    #60
[    0.004000] masked ExtINT on CPU#60
[    0.004000] CPU60: Thermal LVT vector (0xfa) already installed
[    2.659954]   #61
[    0.004000] masked ExtINT on CPU#61
[    0.004000] CPU61: Thermal LVT vector (0xfa) already installed
[    2.688329]   #62
[    0.004000] masked ExtINT on CPU#62
[    0.004000] CPU62: Thermal LVT vector (0xfa) already installed
[    2.719660]   #63
[    0.004000] masked ExtINT on CPU#63
[    0.004000] CPU63: Thermal LVT vector (0xfa) already installed
[    2.748383]   #64
[    0.004000] masked ExtINT on CPU#64
[    0.004000] CPU64: Thermal LVT vector (0xfa) already installed
[    2.778882]   #65
[    0.004000] masked ExtINT on CPU#65
[    0.004000] CPU65: Thermal LVT vector (0xfa) already installed
[    2.808792]   #66
[    0.004000] masked ExtINT on CPU#66
[    0.004000] CPU66: Thermal LVT vector (0xfa) already installed
[    2.840295]   #67
[    0.004000] masked ExtINT on CPU#67
[    0.004000] CPU67: Thermal LVT vector (0xfa) already installed
[    2.870952]   #68
[    0.004000] masked ExtINT on CPU#68
[    0.004000] CPU68: Thermal LVT vector (0xfa) already installed
[    2.900615]   #69
[    0.004000] masked ExtINT on CPU#69
[    0.004000] CPU69: Thermal LVT vector (0xfa) already installed
[    2.931197]   #70
[    0.004000] masked ExtINT on CPU#70
[    0.004000] CPU70: Thermal LVT vector (0xfa) already installed
[    2.960413]   #71
[    0.004000] masked ExtINT on CPU#71
[    0.004000] CPU71: Thermal LVT vector (0xfa) already installed
[    2.990793]   #72
[    0.004000] masked ExtINT on CPU#72
[    0.004000] CPU72: Thermal LVT vector (0xfa) already installed
[    3.020130]   #73
[    0.004000] masked ExtINT on CPU#73
[    0.004000] CPU73: Thermal LVT vector (0xfa) already installed
[    3.050348]   #74
[    0.004000] masked ExtINT on CPU#74
[    0.004000] CPU74: Thermal LVT vector (0xfa) already installed
[    3.080184] 
[    3.082851] .... node  #1, CPUs:    #75
[    0.004000] masked ExtINT on CPU#75
[    0.004000] CPU75: Thermal LVT vector (0xfa) already installed
[    3.112666]   #76
[    0.004000] masked ExtINT on CPU#76
[    0.004000] CPU76: Thermal LVT vector (0xfa) already installed
[    3.142812]   #77
[    0.004000] masked ExtINT on CPU#77
[    0.004000] CPU77: Thermal LVT vector (0xfa) already installed
[    3.172017]   #78
[    0.004000] masked ExtINT on CPU#78
[    0.004000] CPU78: Thermal LVT vector (0xfa) already installed
[    3.202261]   #79
[    0.004000] masked ExtINT on CPU#79
[    0.004000] CPU79: Thermal LVT vector (0xfa) already installed
[    3.232164]   #80
[    0.004000] masked ExtINT on CPU#80
[    0.004000] CPU80: Thermal LVT vector (0xfa) already installed
[    3.262668]   #81
[    0.004000] masked ExtINT on CPU#81
[    0.004000] CPU81: Thermal LVT vector (0xfa) already installed
[    3.292248]   #82
[    0.004000] masked ExtINT on CPU#82
[    0.004000] CPU82: Thermal LVT vector (0xfa) already installed
[    3.322554]   #83
[    0.004000] masked ExtINT on CPU#83
[    0.004000] CPU83: Thermal LVT vector (0xfa) already installed
[    3.352112]   #84
[    0.004000] masked ExtINT on CPU#84
[    0.004000] CPU84: Thermal LVT vector (0xfa) already installed
[    3.382349]   #85
[    0.004000] masked ExtINT on CPU#85
[    0.004000] CPU85: Thermal LVT vector (0xfa) already installed
[    3.411962]   #86
[    0.004000] masked ExtINT on CPU#86
[    0.004000] CPU86: Thermal LVT vector (0xfa) already installed
[    3.439932]   #87
[    0.004000] masked ExtINT on CPU#87
[    0.004000] CPU87: Thermal LVT vector (0xfa) already installed
[    3.467880]   #88
[    0.004000] masked ExtINT on CPU#88
[    0.004000] CPU88: Thermal LVT vector (0xfa) already installed
[    3.495785]   #89
[    0.004000] masked ExtINT on CPU#89
[    0.004000] CPU89: Thermal LVT vector (0xfa) already installed
[    3.523835] 
[    3.524003] .... node  #2, CPUs:    #90
[    0.004000] masked ExtINT on CPU#90
[    0.004000] CPU90: Thermal LVT vector (0xfa) already installed
[    3.556041]   #91
[    0.004000] masked ExtINT on CPU#91
[    0.004000] CPU91: Thermal LVT vector (0xfa) already installed
[    3.586131]   #92
[    0.004000] masked ExtINT on CPU#92
[    0.004000] CPU92: Thermal LVT vector (0xfa) already installed
[    3.616077]   #93
[    0.004000] masked ExtINT on CPU#93
[    0.004000] CPU93: Thermal LVT vector (0xfa) already installed
[    3.646286]   #94
[    0.004000] masked ExtINT on CPU#94
[    0.004000] CPU94: Thermal LVT vector (0xfa) already installed
[    3.676163]   #95
[    0.004000] masked ExtINT on CPU#95
[    0.004000] CPU95: Thermal LVT vector (0xfa) already installed
[    3.706791]   #96
[    0.004000] masked ExtINT on CPU#96
[    0.004000] CPU96: Thermal LVT vector (0xfa) already installed
[    3.736198]   #97
[    0.004000] masked ExtINT on CPU#97
[    0.004000] CPU97: Thermal LVT vector (0xfa) already installed
[    3.766563]   #98
[    0.004000] masked ExtINT on CPU#98
[    0.004000] CPU98: Thermal LVT vector (0xfa) already installed
[    3.796290]   #99
[    0.004000] masked ExtINT on CPU#99
[    0.004000] CPU99: Thermal LVT vector (0xfa) already installed
[    3.826457]  #100
[    0.004000] masked ExtINT on CPU#100
[    0.004000] CPU100: Thermal LVT vector (0xfa) already installed
[    3.856371]  #101
[    0.004000] masked ExtINT on CPU#101
[    0.004000] CPU101: Thermal LVT vector (0xfa) already installed
[    3.886593]  #102
[    0.004000] masked ExtINT on CPU#102
[    0.004000] CPU102: Thermal LVT vector (0xfa) already installed
[    3.916157]  #103
[    0.004000] masked ExtINT on CPU#103
[    0.004000] CPU103: Thermal LVT vector (0xfa) already installed
[    3.946340]  #104
[    0.004000] masked ExtINT on CPU#104
[    0.004000] CPU104: Thermal LVT vector (0xfa) already installed
[    3.976044] 
[    3.978683] .... node  #3, CPUs:   #105
[    0.004000] masked ExtINT on CPU#105
[    0.004000] CPU105: Thermal LVT vector (0xfa) already installed
[    4.008867]  #106
[    0.004000] masked ExtINT on CPU#106
[    0.004000] CPU106: Thermal LVT vector (0xfa) already installed
[    4.039226]  #107
[    0.004000] masked ExtINT on CPU#107
[    0.004000] CPU107: Thermal LVT vector (0xfa) already installed
[    4.068258]  #108
[    0.004000] masked ExtINT on CPU#108
[    0.004000] CPU108: Thermal LVT vector (0xfa) already installed
[    4.098781]  #109
[    0.004000] masked ExtINT on CPU#109
[    0.004000] CPU109: Thermal LVT vector (0xfa) already installed
[    4.128292]  #110
[    0.004000] masked ExtINT on CPU#110
[    0.004000] CPU110: Thermal LVT vector (0xfa) already installed
[    4.159084]  #111
[    0.004000] masked ExtINT on CPU#111
[    0.004000] CPU111: Thermal LVT vector (0xfa) already installed
[    4.188532]  #112
[    0.004000] masked ExtINT on CPU#112
[    0.004000] CPU112: Thermal LVT vector (0xfa) already installed
[    4.219000]  #113
[    0.004000] masked ExtINT on CPU#113
[    0.004000] CPU113: Thermal LVT vector (0xfa) already installed
[    4.248528]  #114
[    0.004000] masked ExtINT on CPU#114
[    0.004000] CPU114: Thermal LVT vector (0xfa) already installed
[    4.279051]  #115
[    0.004000] masked ExtINT on CPU#115
[    0.004000] CPU115: Thermal LVT vector (0xfa) already installed
[    4.308171]  #116
[    0.004000] masked ExtINT on CPU#116
[    0.004000] CPU116: Thermal LVT vector (0xfa) already installed
[    4.338452]  #117
[    0.004000] masked ExtINT on CPU#117
[    0.004000] CPU117: Thermal LVT vector (0xfa) already installed
[    4.368084]  #118
[    0.004000] masked ExtINT on CPU#118
[    0.004000] CPU118: Thermal LVT vector (0xfa) already installed
[    4.398254]  #119
[    0.004000] masked ExtINT on CPU#119
[    0.004000] CPU119: Thermal LVT vector (0xfa) already installed
[    4.427668] x86: Booted up 4 nodes, 120 CPUs
[    4.428030] smpboot: Total of 120 processors activated (674554.15 BogoMIPS)
[    4.449734] BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
[    4.452000] IP: [<ffffffff810f6389>] wq_worker_waking_up+0x14/0x5b
[    4.452000] PGD 0 
[    4.452000] Oops: 0000 [#1] SMP 
[    4.452000] Modules linked in:
[    4.452000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc6-00009-ge1f728f #1
[    4.452000] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BKLDSDP1.86B.0031.R01.1304221600 04/22/2013
[    4.452000] task: ffff880854280000 ti: ffff880854288000 task.ti: ffff880854288000
[    4.452000] RIP: 0010:[<ffffffff810f6389>]  [<ffffffff810f6389>] wq_worker_waking_up+0x14/0x5b
[    4.452000] RSP: 0000:ffff880854289cf8  EFLAGS: 00010002
[    4.452000] RAX: 0000000000000000 RBX: ffff880854283660 RCX: ffffffff824ee1c0
[    4.452000] RDX: 000000055f41501b RSI: 0000000000000001 RDI: ffff880854283660
[    4.452000] RBP: ffff880854289d08 R08: 0000000000000bd1 R09: 000000000000bc9a
[    4.452000] R10: 0000000000000b53 R11: 0000000000000c00 R12: 0000000000000001
[    4.452000] R13: 0000000000013000 R14: 0000000000000001 R15: 0000000000000001
[    4.452000] FS:  0000000000000000(0000) GS:ffff88085f800000(0000) knlGS:0000000000000000
[    4.452000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.452000] CR2: 0000000000000058 CR3: 000000000220c000 CR4: 00000000001407f0
[    4.452000] Stack:
[    4.452000]  ffff880854283660 ffff88085f833000 ffff880854289d28 ffffffff81105a04
[    4.452000]  ffff880854283660 ffff88085f833000 ffff880854289d70 ffffffff81108259
[    4.452000]  0000000000000046 ffff880854283c74 ffff880854283660 ffff8808538fa760
[    4.452000] Call Trace:
[    4.452000]  [<ffffffff81105a04>] ttwu_do_activate.constprop.88+0x4f/0x61
[    4.452000]  [<ffffffff81108259>] try_to_wake_up+0x1f7/0x228
[    4.452000]  [<ffffffff811082be>] wake_up_process+0x34/0x37
[    4.452000]  [<ffffffff810f43c0>] wake_up_worker+0x24/0x26
[    4.452000]  [<ffffffff810f4e4f>] pwq_adjust_max_active+0x7f/0xaa
[    4.452000]  [<ffffffff810f4ea9>] link_pwq+0x2f/0x4a
[    4.452000]  [<ffffffff810f74a0>] apply_workqueue_attrs+0x232/0x393
[    4.452000]  [<ffffffff810f7aaf>] __alloc_workqueue_key+0x300/0x459
[    4.452000]  [<ffffffff81115967>] ? init_sched_dl_class+0x2a/0x52
[    4.452000]  [<ffffffff8236e812>] ? sched_init_smp+0x43b/0x44a
[    4.452000]  [<ffffffff8236c256>] usermodehelper_init+0x28/0x38
[    4.452000]  [<ffffffff8234ff04>] kernel_init_freeable+0x119/0x22e
[    4.452000]  [<ffffffff81a31495>] ? rest_init+0x89/0x89
[    4.452000]  [<ffffffff81a314a3>] kernel_init+0xe/0xdf
[    4.452000]  [<ffffffff81a4e3bc>] ret_from_fork+0x7c/0xb0
[    4.452000]  [<ffffffff81a31495>] ? rest_init+0x89/0x89
[    4.452000] Code: 46 40 83 60 14 df 48 83 c4 28 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 55 48 89 e5 41 54 41 89 f4 53 e8 c6 53 00 00 <f7> 40 58 c8 01 00 00 48 89 c3 75 36 48 8b 40 48 44 39 60 04 74 
[    4.452000] RIP  [<ffffffff810f6389>] wq_worker_waking_up+0x14/0x5b
[    4.452000]  RSP <ffff880854289cf8>
[    4.452000] CR2: 0000000000000058
[    4.452000] ---[ end trace f7c7478439082837 ]---
[    4.452000] Kernel panic - not syncing: Fatal exception
[    4.452000] Shutting down cpus with NMI
[    4.452000] Rebooting in 10 seconds..
[    4.452000] ACPI MEMORY or I/O RESET_REG.

--SUOF0GtieIMvvwua--
