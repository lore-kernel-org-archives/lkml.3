Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3KLPSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:18:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:10494 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab3KLPSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:18:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,685,1378882800"; 
   d="scan'208";a="426266379"
Date: Tue, 12 Nov 2013 23:18:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [seqcount] INFO: trying to register non-static key.
Message-ID: <20131112151808.GA8138@localhost>
References: <20131111012927.GA404@localhost>
 <20131111154551.GJ19203@twins.programming.kicks-ass.net>
 <20131112094147.GA32441@localhost>
 <20131112100140.GM5056@laptop.programming.kicks-ass.net>
 <20131112150355.GA7054@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112150355.GA7054@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 11:03:55PM +0800, Fengguang Wu wrote:
> On Tue, Nov 12, 2013 at 11:01:40AM +0100, Peter Zijlstra wrote:
> > On Tue, Nov 12, 2013 at 05:41:47PM +0800, Fengguang Wu wrote:
> > > On Mon, Nov 11, 2013 at 04:45:51PM +0100, Peter Zijlstra wrote:
> > > > On Mon, Nov 11, 2013 at 09:29:27AM +0800, Fengguang Wu wrote:
> > > > > Greetings,
> > > > > 
> > > > > I got the below dmesg and the first bad commit is
> > > > > 
> > > > > commit 1ca7d67cf5d5a2aef26a8d9afd789006fa098347
> > > > > Author: John Stultz <john.stultz@linaro.org>
> > > > > Date:   Mon Oct 7 15:51:59 2013 -0700
> > > > > 
> > > > >     seqcount: Add lockdep functionality to seqcount/seqlock structures
> > > > >
> > > > 
> > > > > [    4.124336] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
> > > > > [    4.128027] Call Trace:
> > > > > [    4.128027]  [<7908e744>] ? console_unlock+0x353/0x380
> > > > > [    4.128027]  [<79dc7cf2>] dump_stack+0x48/0x60
> > > > > [    4.128027]  [<7908953e>] __lock_acquire.isra.26+0x7e3/0xceb
> > > > > [    4.128027]  [<7908a1c5>] lock_acquire+0x71/0x9a
> > > > > [    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
> > > > > [    4.128027]  [<7940658b>] throtl_update_dispatch_stats+0x7c/0x153
> > > > 
> > > > The below seems to compile with i386-defconfig + CONFIG_CFQ_GROUP_IOSCHED=y
> > > > 
> > > > No idea if it runs properly or not; I seem to have misplaced my i386
> > > > root filesystem.
> > > > 
> > > > ---
> > > > Subject: block: Employ u64_stats_init()
> > > > 
> > > > Now that seqcounts are lockdep tracked thingies, we need to properly
> > > > initialize them, otherwise bad stuff happens.
> > > 
> > > FYI the warning is still there:
> > > 
> > > /kernel/i386-randconfig-j7-11082318/d3516a7318f8e22f5462888fdf9edc8f0f128024
> > > 
> > > +-------------------------------------------------+-------+--------------+--------------+
> > > |                                                 | v3.12 | 838cc7b488f8 | d3516a7318f8 |
> > > +-------------------------------------------------+-------+--------------+--------------+
> > > | boot_successes                                  | 129   | 0            | 0            |
> > > | boot_failures                                   | 1     | 100          | 100          |
> > > | BUG:kernel_early_hang_without_any_printk_output | 1     |              |              |
> > > | INFO:trying_to_register_non-static_key          | 0     | 100          | 100          |
> > > +-------------------------------------------------+-------+--------------+--------------+
> > 
> > Is that from the exact same spot as before
> > (throtl_update_dispatch_stats) or did we hit another one?
> 
> It's exact the same spot. Attached is one dmesg from d3516a7318f8,
> which is the commit for patch "block: Employ u64_stats_init()" based
> on 838cc7b488f8 ("lockdep/proc: Fix lock-time avg computation").

Peter, here are all the 100 call traces.

dmesg-quantal-ant-14:20131113002717:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[  140.700939] Scanning device for bad blocks
[  144.571910] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[  144.575897] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[  144.683223] INFO: trying to register non-static key.
[  144.683450] the code is fine but needs lockdep annotation.
[  144.683450] turning off the locking correctness validator.
[  144.683450] CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 3.12.0-00186-gd3516a7 #2
[  144.683450] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  144.683450] Workqueue: events_unbound async_run_entry_fn
[  144.683450]  7828d55b 00000000 854fd968 78fa76a8 799d7a3c 854fd9a0 78288323 7938b281
[  144.683450]  7938b2db 7938b2b1 00000000 00000000 7825ef31 854fd9a0 7822c7a0 854f80b0
[  144.683450]  854f80b0 85bf3540 00000000 854fd9cc 78288faa 00000000 00000001 00000000
[  144.683450] Call Trace:
[  144.683450]  [<7828d55b>] ? console_unlock+0x353/0x380
[  144.683450]  [<78fa76a8>] dump_stack+0x48/0x60
[  144.683450]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[  144.683450]  [<7825ef31>] ? irq_exit+0x50/0x52
[  144.683450]  [<7822c7a0>] ? do_IRQ+0x7a/0x8e
[  144.683450]  [<78288faa>] lock_acquire+0x71/0x9a
[  144.683450]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[  144.683450]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[  144.683450]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[  144.683450]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[  144.683450]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[  144.683450]  [<78607548>] ? radix_tree_lookup+0xa/0xc
[  144.683450]  [<7828eed0>] ? irq_to_desc+0xf/0x11
[  144.683450]  [<7825ef31>] ? irq_exit+0x50/0x52
[  144.683450]  [<7822c7a0>] ? do_IRQ+0x7a/0x8e
[  144.683450]  [<78fbb0e9>] ? common_interrupt+0x29/0x2e
[  144.683450]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[  144.683450]  [<78fbb0e9>] ? common_interrupt+0x29/0x2e
[  144.683450]  [<785ec187>] generic_make_request+0xf/0xb5
[  144.683450]  [<785ec292>] submit_bio+0x65/0xd2
[  144.683450]  [<78313f8d>] _submit_bh+0x226/0x243
[  144.683450]  [<78313fb4>] submit_bh+0xa/0xc
[  144.683450]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[  144.683450]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[  144.683450]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[  144.683450]  [<78317ec3>] blkdev_readpage+0xf/0x11
[  144.683450]  [<782be517>] do_read_cache_page+0x6e/0x11b
[  144.683450]  [<782bf225>] read_cache_page_async+0x19/0x1e
[  144.683450]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[  144.683450]  [<782bf256>] read_cache_page+0xb/0x12
[  144.683450]  [<785f61b2>] read_dev_sector+0x26/0x61
[  144.683450]  [<785f6c00>] read_lba+0xae/0xf9
[  144.683450]  [<785f7130>] efi_partition+0x17a/0x9c0
[  144.683450]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[  144.683450]  [<78607548>] ? radix_tree_lookup+0xa/0xc
[  144.683450]  [<7825ef31>] ? irq_exit+0x50/0x52
[  144.683450]  [<7822c7a0>] ? do_IRQ+0x7a/0x8e
[  144.683450]  [<78fbb0e9>] ? common_interrupt+0x29/0x2e
[  144.683450]  [<785f6fb6>] ? is_gpt_valid+0x36b/0x36b
[  144.683450]  [<785f62e9>] check_partition+0xe4/0x178
[  144.683450]  [<785f62e9>] ? check_partition+0xe4/0x178
[  144.683450]  [<785f5f3b>] rescan_partitions+0x89/0x267
[  144.683450]  [<78fbb0e9>] ? common_interrupt+0x29/0x2e
[  144.683450]  [<78318d5f>] __blkdev_get+0x173/0x363
[  144.683450]  [<78318f9a>] blkdev_get+0x4b/0x23d
[  144.683450]  [<78318658>] ? bdget+0xf8/0x105
[  144.683450]  [<788acee0>] ? put_device+0xf/0x11
[  144.683450]  [<785f3f90>] add_disk+0x26b/0x3b5
[  144.683450]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[  144.683450]  [<789d1acd>] sd_probe_async+0x111/0x198
[  144.683450]  [<78274964>] async_run_entry_fn+0x59/0xff
[  144.683450]  [<7826bae8>] process_one_work+0x1ef/0x349
[  144.683450]  [<7826ba8f>] ? process_one_work+0x196/0x349
[  144.683450]  [<7826c039>] worker_thread+0x1a3/0x274
[  144.683450]  [<7826be96>] ? rescuer_thread+0x233/0x233
[  144.683450]  [<78270649>] kthread+0x8a/0x8f
[  144.683450]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[  144.683450]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[  144.683450]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[  144.763468]  sda: unknown partition table
[  144.858926] sd 0:0:0:0: [sda] Attached SCSI disk
[  144.877555] parport0: cannot grant exclusive access for device spi-lm70llp

dmesg-quantal-ant-9:20131113003855:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[  201.228505] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[  201.231672] e1000: Copyright (c) 1999-2006 Intel Corporation.
[  201.483672] e1000 0000:00:03.0: setting latency timer to 64
[  201.583255] INFO: trying to register non-static key.
[  201.583255] the code is fine but needs lockdep annotation.
[  201.583255] turning off the locking correctness validator.
[  201.583255] CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 3.12.0-00186-gd3516a7 #2
[  201.583255] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  201.583255] Workqueue: events_unbound async_run_entry_fn
[  201.583255]  7828d55b 00000000 854fd968 78fa76a8 799d7a3c 854fd9a0 78288323 7938b281
[  201.583255]  7938b2db 7938b2b1 00000000 00000000 7825ef31 854fd9a0 7822c7a0 854f80b0
[  201.583255]  854f80b0 85bf3540 00000000 854fd9cc 78288faa 00000000 00000001 00000000
[  201.583255] Call Trace:
[  201.583255]  [<7828d55b>] ? console_unlock+0x353/0x380
[  201.583255]  [<78fa76a8>] dump_stack+0x48/0x60
[  201.583255]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[  201.583255]  [<7825ef31>] ? irq_exit+0x50/0x52
[  201.583255]  [<7822c7a0>] ? do_IRQ+0x7a/0x8e
[  201.583255]  [<78288faa>] lock_acquire+0x71/0x9a
[  201.583255]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[  201.583255]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[  201.583255]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[  201.583255]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[  201.583255]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[  201.583255]  [<78607548>] ? radix_tree_lookup+0xa/0xc
[  201.583255]  [<7828eed0>] ? irq_to_desc+0xf/0x11
[  201.583255]  [<7825ef31>] ? irq_exit+0x50/0x52
[  201.583255]  [<7822c7a0>] ? do_IRQ+0x7a/0x8e
[  201.583255]  [<78fbb0e9>] ? common_interrupt+0x29/0x2e
[  201.583255]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[  201.583255]  [<78fbb0e9>] ? common_interrupt+0x29/0x2e
[  201.583255]  [<785ec187>] generic_make_request+0xf/0xb5
[  201.583255]  [<785ec292>] submit_bio+0x65/0xd2
[  201.583255]  [<78313f8d>] _submit_bh+0x226/0x243
[  201.583255]  [<78313fb4>] submit_bh+0xa/0xc
[  201.583255]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[  201.583255]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[  201.583255]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[  201.583255]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[  201.583255]  [<78317ec3>] blkdev_readpage+0xf/0x11
[  201.583255]  [<782be517>] do_read_cache_page+0x6e/0x11b
[  201.583255]  [<782bf225>] read_cache_page_async+0x19/0x1e
[  201.583255]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[  201.583255]  [<782bf256>] read_cache_page+0xb/0x12
[  201.583255]  [<785f61b2>] read_dev_sector+0x26/0x61
[  201.583255]  [<785f6c00>] read_lba+0xae/0xf9
[  201.583255]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[  201.583255]  [<785f7130>] efi_partition+0x17a/0x9c0
[  201.583255]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[  201.583255]  [<78607548>] ? radix_tree_lookup+0xa/0xc
[  201.583255]  [<7828eed0>] ? irq_to_desc+0xf/0x11
[  201.583255]  [<78607548>] ? radix_tree_lookup+0xa/0xc
[  201.583255]  [<7825ef31>] ? irq_exit+0x50/0x52
[  201.583255]  [<7822c7a0>] ? do_IRQ+0x7a/0x8e
[  201.583255]  [<78fbb0e9>] ? common_interrupt+0x29/0x2e
[  201.583255]  [<785f6fb6>] ? is_gpt_valid+0x36b/0x36b
[  201.583255]  [<785f62e9>] check_partition+0xe4/0x178
[  201.583255]  [<785f62e9>] ? check_partition+0xe4/0x178
[  201.583255]  [<785f5f3b>] rescan_partitions+0x89/0x267
[  201.583255]  [<78fbb0e9>] ? common_interrupt+0x29/0x2e
[  201.583255]  [<78318d5f>] __blkdev_get+0x173/0x363
[  201.583255]  [<78318f9a>] blkdev_get+0x4b/0x23d
[  201.583255]  [<788acee0>] ? put_device+0xf/0x11
[  201.583255]  [<785f3f90>] add_disk+0x26b/0x3b5
[  201.583255]  [<789d1acd>] sd_probe_async+0x111/0x198
[  201.583255]  [<78274964>] async_run_entry_fn+0x59/0xff
[  201.583255]  [<7826bae8>] process_one_work+0x1ef/0x349
[  201.583255]  [<7826ba8f>] ? process_one_work+0x196/0x349
[  201.583255]  [<7826c039>] worker_thread+0x1a3/0x274
[  201.583255]  [<7826be96>] ? rescuer_thread+0x233/0x233
[  201.583255]  [<78270649>] kthread+0x8a/0x8f
[  201.583255]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[  201.583255]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[  201.583255]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[  201.742584]  sda: unknown partition table
[  202.638807] sd 0:0:0:0: [sda] Attached SCSI disk
[  202.755092] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56

dmesg-quantal-athens-10:20131112165837:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.865856] device id = 24c0
[    2.866360] device id = 24d0
[    2.866815] device id = 25a1
[    2.867266] INFO: trying to register non-static key.
[    2.867267] the code is fine but needs lockdep annotation.
[    2.867268] turning off the locking correctness validator.
[    2.867272] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.867273] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.867280] Workqueue: events_unbound async_run_entry_fn
[    2.867286]  7828d9ae 00000000 78093968 78fa76a8 799d7a3c 780939a0 78288323 7938b281
[    2.867292]  7938b2db 7938b2b1 7f3fd308 00000000 00000011 4834c011 0000a885 7f3fce20
[    2.867296]  7f3fce20 85bf3540 00000000 780939cc 78288faa 00000000 00000001 00000000
[    2.867297] Call Trace:
[    2.867303]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    2.867308]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.867311]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.867314]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.867318]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.867321]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.867324]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.867327]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.867330]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.867333]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.867339]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.867341]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.867344]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.867346]  [<785ec292>] submit_bio+0x65/0xd2
[    2.867350]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.867352]  [<78313fb4>] submit_bh+0xa/0xc
[    2.867355]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.867358]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.867363]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.867366]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.867369]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.867371]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.867374]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.867377]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.867380]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.867383]  [<782bf256>] read_cache_page+0xb/0x12
[    2.867385]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.867387]  [<785f6c00>] read_lba+0xae/0xf9
[    2.867390]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.867392]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.867395]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.867399]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.867402]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.867405]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.867408]  [<7860b627>] ? snprintf+0x15/0x17
[    2.867411]  [<785f62e9>] check_partition+0xe4/0x178
[    2.867413]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.867415]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.867418]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.867421]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.867424]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.867427]  [<78318658>] ? bdget+0xf8/0x105
[    2.867431]  [<788acee0>] ? put_device+0xf/0x11
[    2.867433]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.867437]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.867441]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.867444]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.867448]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.867451]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.867455]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.867458]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.867460]  [<78270649>] kthread+0x8a/0x8f
[    2.867463]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.867467]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.867470]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.869044]  sda: unknown partition table
[    2.873104] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.921513] device id = 2670

dmesg-quantal-athens-20:20131112165720:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.783984] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    2.785659] pmc551: not detected
[    2.789491] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.792237] INFO: trying to register non-static key.
[    2.793025] the code is fine but needs lockdep annotation.
[    2.793025] turning off the locking correctness validator.
[    2.793025] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.793025] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.793025] Workqueue: events_unbound async_run_entry_fn
[    2.793025]  7828d55b 00000000 7f3a7968 78fa76a8 799d624c 7f3a79a0 78288323 7938b281
[    2.793025]  7938b2db 7938b2b1 87817708 00000000 00000011 40352011 0000a785 87817220
[    2.793025]  87817220 85d3e540 00000000 7f3a79cc 78288faa 00000000 00000001 00000000
[    2.793025] Call Trace:
[    2.793025]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.793025]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.793025]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.793025]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.793025]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.793025]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.793025]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.793025]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.793025]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.793025]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.793025]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.793025]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.793025]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.793025]  [<785ec292>] submit_bio+0x65/0xd2
[    2.793025]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.793025]  [<78313fb4>] submit_bh+0xa/0xc
[    2.793025]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.793025]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.793025]  [<782c78b6>] ? __pagevec_lru_add+0xf/0x11
[    2.793025]  [<782c78fd>] ? __lru_cache_add+0x45/0x5b
[    2.793025]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.793025]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.793025]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.793025]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.793025]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.793025]  [<782bf256>] read_cache_page+0xb/0x12
[    2.793025]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.793025]  [<785f6c00>] read_lba+0xae/0xf9
[    2.793025]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.793025]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.828652] No valid DiskOnChip devices found
[    2.828684] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.828686] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-athens-37:20131112165615:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    3.052462] pmc551: not detected
[    3.059072] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    3.059560] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    3.066307] INFO: trying to register non-static key.
[    3.067025] the code is fine but needs lockdep annotation.
[    3.067025] turning off the locking correctness validator.
[    3.067025] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    3.067025] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.067025] Workqueue: events_unbound async_run_entry_fn
[    3.067025]  7828d55b 00000000 7f3e1968 78fa76a8 799d624c 7f3e19a0 78288323 7938b281
[    3.067025]  7938b2db 7938b2b1 7f3b1588 00000000 00000011 4035a011 0000a785 7f3b10a0
[    3.067025]  7f3b10a0 85d3e540 00000000 7f3e19cc 78288faa 00000000 00000001 00000000
[    3.067025] Call Trace:
[    3.067025]  [<7828d55b>] ? console_unlock+0x353/0x380
[    3.067025]  [<78fa76a8>] dump_stack+0x48/0x60
[    3.067025]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    3.067025]  [<78288faa>] lock_acquire+0x71/0x9a
[    3.067025]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.067025]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    3.067025]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.067025]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    3.067025]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    3.067025]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.067025]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    3.067025]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.067025]  [<785ec187>] generic_make_request+0xf/0xb5
[    3.067025]  [<785ec292>] submit_bio+0x65/0xd2
[    3.067025]  [<78313f8d>] _submit_bh+0x226/0x243
[    3.067025]  [<78313fb4>] submit_bh+0xa/0xc
[    3.067025]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    3.067025]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    3.067025]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    3.067025]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.067025]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.067025]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    3.067025]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    3.067025]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    3.067025]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.067025]  [<782bf256>] read_cache_page+0xb/0x12
[    3.067025]  [<785f61b2>] read_dev_sector+0x26/0x61
[    3.067025]  [<785f6c00>] read_lba+0xae/0xf9
[    3.097808] No valid DiskOnChip devices found
[    3.097852] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.097853] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-athens-45:20131112155123:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.779687] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.780709] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.781863] pmc551: not detected
[    2.784262] INFO: trying to register non-static key.
[    2.784424] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.785022] the code is fine but needs lockdep annotation.
[    2.785022] turning off the locking correctness validator.
[    2.785022] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.785022] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.785022] Workqueue: events_unbound async_run_entry_fn
[    2.785022]  7828d55b 00000000 7f3d3968 78fa76a8 799d7a3c 7f3d39a0 78288323 7938b281
[    2.785022]  7938b2db 7938b2b1 7f3a5588 00000000 00000011 3c350011 0000a705 7f3a50a0
[    2.785022]  7f3a50a0 85bf3540 00000000 7f3d39cc 78288faa 00000000 00000001 00000000
[    2.785022] Call Trace:
[    2.785022]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.785022]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.785022]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.785022]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.785022]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.785022]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.785022]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.785022]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.785022]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.785022]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.785022]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.785022]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.785022]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.785022]  [<785ec292>] submit_bio+0x65/0xd2
[    2.785022]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.785022]  [<78313fb4>] submit_bh+0xa/0xc
[    2.785022]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.785022]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.785022]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.785022]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.785022]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.785022]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.785022]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.785022]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.785022]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.785022]  [<782bf256>] read_cache_page+0xb/0x12
[    2.785022]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.785022]  [<785f6c00>] read_lba+0xae/0xf9
[    2.785022]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.785022]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.785022]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.785022]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.785022]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.785022]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.785022]  [<7860b627>] ? snprintf+0x15/0x17
[    2.785022]  [<785f62e9>] check_partition+0xe4/0x178
[    2.785022]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.785022]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.785022]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.785022]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.785022]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.785022]  [<78318658>] ? bdget+0xf8/0x105
[    2.785022]  [<788acee0>] ? put_device+0xf/0x11
[    2.785022]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.823236] No valid DiskOnChip devices found
[    2.823267] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.823268] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-bens-2:20131112165558:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    5.011490] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    5.014107] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    5.015384] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    5.076252] INFO: trying to register non-static key.
[    5.077017] the code is fine but needs lockdep annotation.
[    5.077017] turning off the locking correctness validator.
[    5.077017] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    5.077017] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.077017] Workqueue: events_unbound async_run_entry_fn
[    5.077017]  7828d55b 00000000 7f399968 78fa76a8
[    5.082400] No valid DiskOnChip devices found

dmesg-quantal-bens-4:20131112153446:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    5.293926] pmc551: not detected
[    5.305382] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    5.310447] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    5.321352] INFO: trying to register non-static key.
[    5.322019] the code is fine but needs lockdep annotation.
[    5.322019] turning off the locking correctness validator.
[    5.322019] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    5.322019] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.322019] Workqueue: events_unbound async_run_entry_fn
[    5.322019]  7828d55b 00000000 7f3d7968 78fa76a8 799d7a3c 7f3d79a0 78288323 7938b281
[    5.322019]  7938b2db 7938b2b1 7f15e598 00000000 00000011 40360011 0000a785 7f15e0b0
[    5.322019]  7f15e0b0 85bf3540 00000000 7f3d79cc 78288faa 00000000 00000001 00000000
[    5.322019] Call Trace:
[    5.322019]  [<7828d55b>] ? console_unlock+0x353/0x380
[    5.322019]  [<78fa76a8>] dump_stack+0x48/0x60
[    5.322019]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    5.322019]  [<78288faa>] lock_acquire+0x71/0x9a
[    5.322019]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    5.322019]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    5.322019]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    5.322019]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    5.322019]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    5.322019]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    5.322019]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    5.322019]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    5.322019]  [<785ec187>] generic_make_request+0xf/0xb5
[    5.322019]  [<785ec292>] submit_bio+0x65/0xd2
[    5.322019]  [<78313f8d>] _submit_bh+0x226/0x243
[    5.322019]  [<78313fb4>] submit_bh+0xa/0xc
[    5.322019]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    5.322019]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    5.322019]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    5.322019]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    5.322019]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    5.322019]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    5.322019]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    5.322019]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    5.322019]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    5.322019]  [<782bf256>] read_cache_page+0xb/0x12
[    5.322019]  [<785f61b2>] read_dev_sector+0x26/0x61
[    5.322019]  [<785f6c00>] read_lba+0xae/0xf9
[    5.384386] No valid DiskOnChip devices found
[    5.384442] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    5.384443] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-cairo-16:20131112165821:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.568261] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    2.569425] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.572556] e1000 0000:00:03.0: setting latency timer to 64
[    2.575263] INFO: trying to register non-static key.
[    2.576036] the code is fine but needs lockdep annotation.
[    2.576036] turning off the locking correctness validator.
[    2.576036] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.576036] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.576036] Workqueue: events_unbound async_run_entry_fn
[    2.576036]  7828d55b 00000000 7f3bb968 78fa76a8 799d7a3c 7f3bb9a0 78288323 7938b281
[    2.576036]  7938b2db 7938b2b1 7f39d608 00000000 00000011 48362011 0000a885 7f39d120
[    2.576036]  7f39d120 85bf3540 00000000 7f3bb9cc 78288faa 00000000 00000001 00000000
[    2.576036] Call Trace:
[    2.576036]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.576036]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.576036]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.576036]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.576036]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.576036]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.576036]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.576036]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.576036]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.576036]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.576036]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.576036]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.576036]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.576036]  [<785ec292>] submit_bio+0x65/0xd2
[    2.576036]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.576036]  [<78313fb4>] submit_bh+0xa/0xc
[    2.576036]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.576036]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.576036]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.576036]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.576036]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.576036]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.576036]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.576036]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.576036]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.576036]  [<782bf256>] read_cache_page+0xb/0x12
[    2.576036]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.576036]  [<785f6c00>] read_lba+0xae/0xf9
[    2.576036]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.576036]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.576036]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.576036]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.576036]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.576036]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.576036]  [<7860b627>] ? snprintf+0x15/0x17
[    2.576036]  [<785f62e9>] check_partition+0xe4/0x178
[    2.576036]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.576036]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.576036]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.576036]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.576036]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.576036]  [<78318658>] ? bdget+0xf8/0x105
[    2.576036]  [<788acee0>] ? put_device+0xf/0x11
[    2.576036]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.576036]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.576036]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.576036]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.576036]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.576036]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.576036]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.576036]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.576036]  [<78270649>] kthread+0x8a/0x8f
[    2.576036]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.576036]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.576036]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.633065]  sda: unknown partition table
[    2.640179] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.780109] tsc: Refined TSC clocksource calibration: 2892.982 MHz

dmesg-quantal-cairo-3:20131112161820:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.707549] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.708566] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.709675] pmc551: not detected
[    2.711247] INFO: trying to register non-static key.
[    2.712004] the code is fine but needs lockdep annotation.
[    2.712027] turning off the locking correctness validator.
[    2.712027] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.712027] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.712027] Workqueue: events_unbound async_run_entry_fn
[    2.712027]  7828d55b 00000000 7f393968 78fa76a8 799d7a3c 7f3939a0 78288323 7938b281
[    2.712027]  7938b2db 7938b2b1 7f3c6618 00000000 00000011 3c350011 0000a705 7f3c6130
[    2.712027]  7f3c6130 85bf3540 00000000 7f3939cc 78288faa 00000000 00000001 00000000
[    2.712027] Call Trace:
[    2.712027]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.712027]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.712027]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.712027]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.712027]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.712027]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.712027]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.712027]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.712027]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.712027]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.712027]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.712027]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.712027]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.712027]  [<785ec292>] submit_bio+0x65/0xd2
[    2.712027]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.712027]  [<78313fb4>] submit_bh+0xa/0xc
[    2.712027]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.712027]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.712027]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.712027]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.712027]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.712027]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.712027]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.712027]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.712027]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.712027]  [<782bf256>] read_cache_page+0xb/0x12
[    2.712027]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.712027]  [<785f6c00>] read_lba+0xae/0xf9
[    2.712027]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.712027]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.712027]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.712027]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.712027]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.712027]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.712027]  [<7860b627>] ? snprintf+0x15/0x17
[    2.712027]  [<785f62e9>] check_partition+0xe4/0x178
[    2.712027]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.712027]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.712027]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.712027]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.712027]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.712027]  [<78318658>] ? bdget+0xf8/0x105
[    2.712027]  [<788acee0>] ? put_device+0xf/0x11
[    2.712027]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.712027]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.712027]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.712027]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.712027]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.712027]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.712027]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.712027]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.712027]  [<78270649>] kthread+0x8a/0x8f
[    2.712027]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.712027]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.712027]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.762488] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.763058]  sda: unknown partition table
[    2.767118] sd 0:0:0:0: [sda] Attached SCSI disk

dmesg-quantal-inn-44:20131112165437:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    3.008097] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    3.012940] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    3.013936] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    3.024911] INFO: trying to register non-static key.
[    3.025635] the code is fine but needs lockdep annotation.
[    3.025682] turning off the locking correctness validator.
[    3.025682] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    3.025682] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.025682] Workqueue: events_unbound async_run_entry_fn
[    3.025682]  7828d55b 00000000 7f3b9968 78fa76a8 799d624c 7f3b99a0 78288323 7938b281
[    3.025682]  7938b2db 7938b2b1 7f3ad708 00000000 00000011 4035c011 0000a785 7f3ad220
[    3.025682]  7f3ad220 85d3e540 00000000 7f3b99cc 78288faa 00000000 00000001 00000000
[    3.025682] Call Trace:
[    3.025682]  [<7828d55b>] ? console_unlock+0x353/0x380
[    3.025682]  [<78fa76a8>] dump_stack+0x48/0x60
[    3.025682]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    3.025682]  [<78288faa>] lock_acquire+0x71/0x9a
[    3.025682]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.025682]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    3.025682]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.025682]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    3.025682]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    3.025682]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.025682]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    3.025682]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.025682]  [<785ec187>] generic_make_request+0xf/0xb5
[    3.025682]  [<785ec292>] submit_bio+0x65/0xd2
[    3.025682]  [<78313f8d>] _submit_bh+0x226/0x243
[    3.025682]  [<78313fb4>] submit_bh+0xa/0xc
[    3.025682]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    3.025682]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    3.025682]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    3.025682]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.025682]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.025682]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    3.025682]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    3.025682]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    3.025682]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.025682]  [<782bf256>] read_cache_page+0xb/0x12
[    3.025682]  [<785f61b2>] read_dev_sector+0x26/0x61
[    3.025682]  [<785f6c00>] read_lba+0xae/0xf9
[    3.025682]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    3.025682]  [<785f7130>] efi_partition+0x17a/0x9c0
[    3.025682]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    3.025682]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.025682]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.025682]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    3.025682]  [<7860b627>] ? snprintf+0x15/0x17
[    3.025682]  [<785f62e9>] check_partition+0xe4/0x178
[    3.025682]  [<785f62e9>] ? check_partition+0xe4/0x178
[    3.025682]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    3.025682]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    3.025682]  [<78318d5f>] __blkdev_get+0x173/0x363
[    3.025682]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    3.025682]  [<78318658>] ? bdget+0xf8/0x105
[    3.066891] No valid DiskOnChip devices found
[    3.066919] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.066920] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-jaketown-12:20131112153852:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    6.297163] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.299158] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.313370] SSFDC read-only Flash Translation layer
[    6.313516] INFO: trying to register non-static key.
[    6.313519] the code is fine but needs lockdep annotation.
[    6.313521] turning off the locking correctness validator.
[    6.313529] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    6.313532] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.313547] Workqueue: events_unbound async_run_entry_fn
[    6.313561]  7828d9ae 00000000 7f3ad968 78fa76a8 799d7a3c 7f3ad9a0 78288323 7938b281
[    6.313574]  7938b2db 7938b2b1 7f3bb308 00000000 00000011 40346011 0000a785 7f3bae20
[    6.313586]  7f3bae20 85bf3540 00000000 7f3ad9cc 78288faa 00000000 00000001 00000000
[    6.313588] Call Trace:
[    6.313601]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    6.313610]  [<78fa76a8>] dump_stack+0x48/0x60
[    6.313617]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    6.313624]  [<78288faa>] lock_acquire+0x71/0x9a
[    6.313633]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    6.313640]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    6.313647]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    6.313653]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    6.313662]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    6.313672]  [<78508611>] ? btrfs_run_delayed_refs+0x1a1/0x3f8
[    6.313679]  [<7850844f>] ? btrfs_create_pending_block_groups+0xff/0x120
[    6.313685]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    6.313695]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    6.313701]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    6.313708]  [<785ec187>] generic_make_request+0xf/0xb5
[    6.313713]  [<785ec292>] submit_bio+0x65/0xd2
[    6.313721]  [<78313f8d>] _submit_bh+0x226/0x243
[    6.313727]  [<78313fb4>] submit_bh+0xa/0xc
[    6.313734]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    6.313740]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    6.313751]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    6.313758]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.313765]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.313771]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    6.313779]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    6.313787]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    6.313793]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.313800]  [<782bf256>] read_cache_page+0xb/0x12
[    6.313806]  [<785f61b2>] read_dev_sector+0x26/0x61
[    6.313812]  [<785f6c00>] read_lba+0xae/0xf9
[    6.313819]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    6.313825]  [<785f7130>] efi_partition+0x17a/0x9c0
[    6.313832]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    6.313841]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    6.313848]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    6.313856]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    6.313863]  [<7860b627>] ? snprintf+0x15/0x17
[    6.313869]  [<785f62e9>] check_partition+0xe4/0x178
[    6.313874]  [<785f62e9>] ? check_partition+0xe4/0x178
[    6.313880]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    6.313887]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    6.313895]  [<78318d5f>] __blkdev_get+0x173/0x363
[    6.313901]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    6.313908]  [<78318658>] ? bdget+0xf8/0x105
[    6.313916]  [<788acee0>] ? put_device+0xf/0x11
[    6.313922]  [<785f3f90>] add_disk+0x26b/0x3b5
[    6.313930]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    6.313937]  [<789d1acd>] sd_probe_async+0x111/0x198
[    6.313944]  [<78274964>] async_run_entry_fn+0x59/0xff
[    6.313952]  [<7826bae8>] process_one_work+0x1ef/0x349
[    6.313979]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    6.313987]  [<7826c039>] worker_thread+0x1a3/0x274
[    6.313996]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    6.314001]  [<78270649>] kthread+0x8a/0x8f
[    6.314009]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    6.314029]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    6.314036]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    6.316148]  sda: unknown partition table
[    6.320256] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.467155] device id = 2440

dmesg-quantal-jaketown-17:20131112153642:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    5.340827] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    5.343688] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    5.346905] pmc551: not detected
[    5.349516] INFO: trying to register non-static key.
[    5.350059] the code is fine but needs lockdep annotation.
[    5.352292] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    5.350059] turning off the locking correctness validator.
[    5.350059] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    5.350059] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.350059] Workqueue: events_unbound async_run_entry_fn
[    5.350059]  7828d55b 00000000 7f3a9968 78fa76a8 799d624c 7f3a99a0 78288323 7938b281
[    5.350059]  7938b2db 7938b2b1 7f3c3388 00000000 00000011 40350011 0000a785 7f3c2ea0
[    5.350059]  7f3c2ea0 85d3e540 00000000 7f3a99cc 78288faa 00000000 00000001 00000000
[    5.350059] Call Trace:
[    5.350059]  [<7828d55b>] ? console_unlock+0x353/0x380
[    5.350059]  [<78fa76a8>] dump_stack+0x48/0x60
[    5.350059]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    5.350059]  [<78288faa>] lock_acquire+0x71/0x9a
[    5.350059]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    5.350059]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    5.350059]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    5.390689] No valid DiskOnChip devices found
[    5.390743] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    5.390747] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-jaketown-29:20131112153709:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.978075] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    4.981128] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    4.984549] pmc551: not detected
[    4.986483] INFO: trying to register non-static key.
[    4.987048] the code is fine but needs lockdep annotation.
[    4.987048] turning off the locking correctness validator.
[    4.987048] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.987048] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.987048] Workqueue: events_unbound async_run_entry_fn
[    4.987048]  7828d55b 00000000 7f3a7968 78fa76a8 799d624c 7f3a79a0 78288323 7938b281
[    4.987048]  7938b2db 7938b2b1 7f399508 00000000 00000011 40350011 0000a785 7f399020
[    4.987048]  7f399020 85d3e540 00000000 7f3a79cc 78288faa 00000000 00000001 00000000
[    4.987048] Call Trace:
[    4.987048]  [<7828d55b>] ? console_unlock+0x353/0x380
[    4.987048]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.987048]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.987048]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.987048]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.987048]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.987048]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.987048]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.987048]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.987048]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.987048]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.987048]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.987048]  [<785ec187>] generic_make_request+0xf/0xb5
[    4.987048]  [<785ec292>] submit_bio+0x65/0xd2
[    4.987048]  [<78313f8d>] _submit_bh+0x226/0x243
[    4.987048]  [<78313fb4>] submit_bh+0xa/0xc
[    4.987048]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    4.987048]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    4.987048]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.987048]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.987048]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.987048]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    4.987048]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    4.987048]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    4.987048]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.987048]  [<782bf256>] read_cache_page+0xb/0x12
[    4.987048]  [<785f61b2>] read_dev_sector+0x26/0x61
[    4.987048]  [<785f6c00>] read_lba+0xae/0xf9
[    4.987048]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    4.987048]  [<785f7130>] efi_partition+0x17a/0x9c0
[    4.987048]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    4.987048]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.987048]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.987048]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    4.987048]  [<7860b627>] ? snprintf+0x15/0x17
[    4.987048]  [<785f62e9>] check_partition+0xe4/0x178
[    4.987048]  [<785f62e9>] ? check_partition+0xe4/0x178
[    4.987048]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    4.987048]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    4.987048]  [<78318d5f>] __blkdev_get+0x173/0x363
[    4.987048]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    4.987048]  [<78318658>] ? bdget+0xf8/0x105
[    4.987048]  [<788acee0>] ? put_device+0xf/0x11
[    4.987048]  [<785f3f90>] add_disk+0x26b/0x3b5
[    4.987048]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    4.987048]  [<789d1acd>] sd_probe_async+0x111/0x198
[    4.987048]  [<78274964>] async_run_entry_fn+0x59/0xff
[    4.987048]  [<7826bae8>] process_one_work+0x1ef/0x349
[    4.987048]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    4.987048]  [<7826c039>] worker_thread+0x1a3/0x274
[    4.987048]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    4.987048]  [<78270649>] kthread+0x8a/0x8f
[    4.987048]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    4.987048]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    4.987048]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    5.135115]  sda: unknown partition table
[    5.136647] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    5.145244] sd 0:0:0:0: [sda] Attached SCSI disk

dmesg-quantal-jaketown-41:20131112153715:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    5.494159] sd 0:0:0:0: [sda] Write Protect is off
[    5.494166] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    5.496149] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    5.502461] INFO: trying to register non-static key.
[    5.502463] the code is fine but needs lockdep annotation.
[    5.502465] turning off the locking correctness validator.
[    5.502473] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    5.502475] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.502488] Workqueue: events_unbound async_run_entry_fn
[    5.502500]  7828d9ae 00000000 7f3db968 78fa76a8 799d7a3c 7f3db9a0 78288323 7938b281
[    5.502512]  7938b2db 7938b2b1 7f39d588 00000000 00000011 40344011 0000a785 7f39d0a0
[    5.502522]  7f39d0a0 85bf3540 00000000 7f3db9cc 78288faa 00000000 00000001 00000000
[    5.502524] Call Trace:
[    5.502535]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    5.502542]  [<78fa76a8>] dump_stack+0x48/0x60
[    5.502548]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    5.502553]  [<78288faa>] lock_acquire+0x71/0x9a
[    5.502562]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    5.502568]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    5.502574]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    5.502579]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    5.502586]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    5.502592]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    5.502601]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    5.502605]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    5.502611]  [<785ec187>] generic_make_request+0xf/0xb5
[    5.502616]  [<785ec292>] submit_bio+0x65/0xd2
[    5.502623]  [<78313f8d>] _submit_bh+0x226/0x243
[    5.502628]  [<78313fb4>] submit_bh+0xa/0xc
[    5.502634]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    5.502641]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    5.502651]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    5.502658]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    5.502664]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    5.502671]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    5.502678]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    5.502685]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    5.502691]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    5.502696]  [<782bf256>] read_cache_page+0xb/0x12
[    5.502701]  [<785f61b2>] read_dev_sector+0x26/0x61
[    5.502706]  [<785f6c00>] read_lba+0xae/0xf9
[    5.502711]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    5.502716]  [<785f7130>] efi_partition+0x17a/0x9c0
[    5.502722]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    5.502729]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    5.502735]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    5.502741]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    5.502747]  [<7860b627>] ? snprintf+0x15/0x17
[    5.502752]  [<785f62e9>] check_partition+0xe4/0x178
[    5.502756]  [<785f62e9>] ? check_partition+0xe4/0x178
[    5.502761]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    5.502767]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    5.502773]  [<78318d5f>] __blkdev_get+0x173/0x363
[    5.502778]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    5.502784]  [<78318658>] ? bdget+0xf8/0x105
[    5.502791]  [<788acee0>] ? put_device+0xf/0x11
[    5.502796]  [<785f3f90>] add_disk+0x26b/0x3b5
[    5.502804]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    5.502810]  [<789d1acd>] sd_probe_async+0x111/0x198
[    5.502816]  [<78274964>] async_run_entry_fn+0x59/0xff
[    5.502823]  [<7826bae8>] process_one_work+0x1ef/0x349
[    5.502829]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    5.502836]  [<7826c039>] worker_thread+0x1a3/0x274
[    5.502842]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    5.502848]  [<78270649>] kthread+0x8a/0x8f
[    5.502853]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    5.502860]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    5.502866]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    5.504119]  sda: unknown partition table
[    5.508257] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.626251] SSFDC read-only Flash Translation layer

dmesg-quantal-jaketown-42:20131112153520:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    6.387856] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    6.390497] pmc551: not detected
[    6.392140] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.419558] INFO: trying to register non-static key.
[    6.419902] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    6.420053] the code is fine but needs lockdep annotation.
[    6.420053] turning off the locking correctness validator.
[    6.420053] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    6.420053] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.420053] Workqueue: events_unbound async_run_entry_fn
[    6.420053]  7828d55b 00000000 7f3b7968 78fa76a8 799d624c 7f3b79a0 78288323 7938b281
[    6.420053]  7938b2db 7938b2b1 7f391488 00000000 00000011 40350011 0000a785 7f390fa0
[    6.420053]  7f390fa0 85d3e540 00000000 7f3b79cc 78288faa 00000000 00000001 00000000
[    6.420053] Call Trace:
[    6.420053]  [<7828d55b>] ? console_unlock+0x353/0x380
[    6.420053]  [<78fa76a8>] dump_stack+0x48/0x60
[    6.420053]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    6.420053]  [<78288faa>] lock_acquire+0x71/0x9a
[    6.420053]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    6.420053]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    6.420053]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    6.420053]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    6.420053]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    6.420053]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    6.420053]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    6.420053]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    6.420053]  [<785ec187>] generic_make_request+0xf/0xb5
[    6.420053]  [<785ec292>] submit_bio+0x65/0xd2
[    6.420053]  [<78313f8d>] _submit_bh+0x226/0x243
[    6.420053]  [<78313fb4>] submit_bh+0xa/0xc
[    6.420053]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    6.420053]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    6.475172] No valid DiskOnChip devices found
[    6.475237] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    6.475241] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-jaketown-43:20131112154004:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    6.880776] device id = 2670
[    6.882746] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    6.886237] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    6.886534] INFO: trying to register non-static key.
[    6.886536] the code is fine but needs lockdep annotation.
[    6.886539] turning off the locking correctness validator.
[    6.886547] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    6.886550] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.886567] Workqueue: events_unbound async_run_entry_fn
[    6.886582]  7828d9ae 00000000 7f39b968 78fa76a8 799d624c 7f39b9a0 78288323 7938b281
[    6.886595]  7938b2db 7938b2b1 7f387308 00000000 00000011 40350011 0000a785 7f386e20
[    6.886608]  7f386e20 85d3e540 00000000 7f39b9cc 78288faa 00000000 00000001 00000000
[    6.886610] Call Trace:
[    6.886624]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    6.886635]  [<78fa76a8>] dump_stack+0x48/0x60
[    6.886642]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    6.886648]  [<78288faa>] lock_acquire+0x71/0x9a
[    6.886659]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    6.886667]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    6.886673]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    6.886680]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    6.886689]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    6.886696]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    6.886709]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    6.886715]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    6.886721]  [<785ec187>] generic_make_request+0xf/0xb5
[    6.886727]  [<785ec292>] submit_bio+0x65/0xd2
[    6.886736]  [<78313f8d>] _submit_bh+0x226/0x243
[    6.886742]  [<78313fb4>] submit_bh+0xa/0xc
[    6.886748]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    6.886755]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    6.886768]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    6.886775]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.886782]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.886789]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    6.886796]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    6.886804]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    6.886811]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.886817]  [<782bf256>] read_cache_page+0xb/0x12
[    6.886823]  [<785f61b2>] read_dev_sector+0x26/0x61
[    6.886829]  [<785f6c00>] read_lba+0xae/0xf9
[    6.886838]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    6.886844]  [<785f7130>] efi_partition+0x17a/0x9c0
[    6.886851]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    6.886861]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    6.886868]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    6.886877]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    6.886884]  [<7860b627>] ? snprintf+0x15/0x17
[    6.886890]  [<785f62e9>] check_partition+0xe4/0x178
[    6.886896]  [<785f62e9>] ? check_partition+0xe4/0x178
[    6.886902]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    6.886909]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    6.886916]  [<78318d5f>] __blkdev_get+0x173/0x363
[    6.886923]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    6.886930]  [<78318658>] ? bdget+0xf8/0x105
[    6.886940]  [<788acee0>] ? put_device+0xf/0x11
[    6.886946]  [<785f3f90>] add_disk+0x26b/0x3b5
[    6.886956]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    6.886966]  [<789d1acd>] sd_probe_async+0x111/0x198
[    6.886973]  [<78274964>] async_run_entry_fn+0x59/0xff
[    6.887003]  [<7826bae8>] process_one_work+0x1ef/0x349
[    6.887011]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    6.887029]  [<7826c039>] worker_thread+0x1a3/0x274
[    6.887037]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    6.887043]  [<78270649>] kthread+0x8a/0x8f
[    6.887050]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    6.887050]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    6.887050]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    7.085319] pmc551: not detected
[    7.087114]  sda: unknown partition table
[    7.088002] tsc: Refined TSC clocksource calibration: 1599.928 MHz

dmesg-quantal-jaketown-4:20131112153536:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    5.927159] sd 0:0:0:0: [sda] Write Protect is off
[    5.927166] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    5.929148] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    5.935604] INFO: trying to register non-static key.
[    5.935606] the code is fine but needs lockdep annotation.
[    5.935609] turning off the locking correctness validator.
[    5.935617] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    5.935620] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.935635] Workqueue: events_unbound async_run_entry_fn
[    5.935650]  7828d9ae 00000000 7f3d9968 78fa76a8 799d7a3c 7f3d99a0 78288323 7938b281
[    5.935663]  7938b2db 7938b2b1 7f3b1488 00000000 00000011 44344011 0000a805 7f3b0fa0
[    5.935675]  7f3b0fa0 85bf3540 00000000 7f3d99cc 78288faa 00000000 00000001 00000000
[    5.935677] Call Trace:
[    5.935691]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    5.935703]  [<78fa76a8>] dump_stack+0x48/0x60
[    5.935729]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    5.935737]  [<78288faa>] lock_acquire+0x71/0x9a
[    5.935747]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    5.935754]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    5.935761]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    5.935767]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    5.935776]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    5.935783]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    5.935795]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    5.935801]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    5.935808]  [<785ec187>] generic_make_request+0xf/0xb5
[    5.935814]  [<785ec292>] submit_bio+0x65/0xd2
[    5.935823]  [<78313f8d>] _submit_bh+0x226/0x243
[    5.935829]  [<78313fb4>] submit_bh+0xa/0xc
[    5.935836]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    5.935843]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    5.935852]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    5.935859]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    5.935866]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    5.935872]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    5.935879]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    5.935887]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    5.935893]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    5.935901]  [<782bf256>] read_cache_page+0xb/0x12
[    5.935907]  [<785f61b2>] read_dev_sector+0x26/0x61
[    5.935913]  [<785f6c00>] read_lba+0xae/0xf9
[    5.935920]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    5.935926]  [<785f7130>] efi_partition+0x17a/0x9c0
[    5.935933]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    5.935942]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    5.935949]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    5.935957]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    5.935965]  [<7860b627>] ? snprintf+0x15/0x17
[    5.935970]  [<785f62e9>] check_partition+0xe4/0x178
[    5.935976]  [<785f62e9>] ? check_partition+0xe4/0x178
[    5.935981]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    5.935988]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    5.935996]  [<78318d5f>] __blkdev_get+0x173/0x363
[    5.936003]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    5.936010]  [<78318658>] ? bdget+0xf8/0x105
[    5.936031]  [<788acee0>] ? put_device+0xf/0x11
[    5.936037]  [<785f3f90>] add_disk+0x26b/0x3b5
[    5.936049]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    5.936056]  [<789d1acd>] sd_probe_async+0x111/0x198
[    5.936056]  [<78274964>] async_run_entry_fn+0x59/0xff
[    5.936056]  [<7826bae8>] process_one_work+0x1ef/0x349
[    5.936056]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    5.936056]  [<7826c039>] worker_thread+0x1a3/0x274
[    5.936056]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    5.936056]  [<78270649>] kthread+0x8a/0x8f
[    5.936056]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    5.936056]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    5.936056]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    5.938122]  sda: unknown partition table
[    5.942267] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.062788] SSFDC read-only Flash Translation layer

dmesg-quantal-lkp-st01-10:20131113004829:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    6.365356] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.367516] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    6.369253] pmc551: not detected
[    6.380678] INFO: trying to register non-static key.
[    6.381350] the code is fine but needs lockdep annotation.
[    6.381350] turning off the locking correctness validator.
[    6.381350] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    6.384755] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    6.381350] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.381350] Workqueue: events_unbound async_run_entry_fn
[    6.381350]  7828d55b 00000000 7f3cb968 78fa76a8 799d624c 7f3cb9a0 78288323 7938b281
[    6.381350]  7938b2db 7938b2b1 7f3db408 00000000 00000011 50358011 0000a985 7f3daf20
[    6.381350]  7f3daf20 85d3e540 00000000 7f3cb9cc 78288faa 00000000 00000001 00000000
[    6.381350] Call Trace:
[    6.381350]  [<7828d55b>] ? console_unlock+0x353/0x380
[    6.381350]  [<78fa76a8>] dump_stack+0x48/0x60
[    6.381350]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    6.381350]  [<78288faa>] lock_acquire+0x71/0x9a
[    6.381350]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    6.381350]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    6.381350]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    6.381350]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    6.381350]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    6.381350]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    6.381350]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    6.381350]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    6.381350]  [<785ec187>] generic_make_request+0xf/0xb5
[    6.381350]  [<785ec292>] submit_bio+0x65/0xd2
[    6.381350]  [<78313f8d>] _submit_bh+0x226/0x243
[    6.381350]  [<78313fb4>] submit_bh+0xa/0xc
[    6.381350]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    6.381350]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    6.381350]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    6.381350]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.381350]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.381350]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    6.381350]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    6.381350]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    6.381350]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.381350]  [<782bf256>] read_cache_page+0xb/0x12
[    6.381350]  [<785f61b2>] read_dev_sector+0x26/0x61
[    6.381350]  [<785f6c00>] read_lba+0xae/0xf9
[    6.381350]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    6.381350]  [<785f7130>] efi_partition+0x17a/0x9c0
[    6.381350]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    6.381350]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    6.381350]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    6.381350]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    6.381350]  [<7860b627>] ? snprintf+0x15/0x17
[    6.381350]  [<785f62e9>] check_partition+0xe4/0x178
[    6.381350]  [<785f62e9>] ? check_partition+0xe4/0x178
[    6.381350]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    6.460331] No valid DiskOnChip devices found
[    6.460353] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    6.460354] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-lkp-st01-11:20131113000319:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.971053] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.974044] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    4.977287] pmc551: not detected
[    4.982269] INFO: trying to register non-static key.
[    4.983017] the code is fine but needs lockdep annotation.
[    4.983017] turning off the locking correctness validator.
[    4.983017] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.983017] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.986426] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    4.983017] Workqueue: events_unbound async_run_entry_fn
[    4.983017]  7828d55b 00000000 7f3a5968 78fa76a8 799d624c 7f3a59a0 78288323 7938b281
[    4.983017]  7938b2db 7938b2b1 7f398798 00000000 00000011 40358011 0000a785 7f3982b0
[    4.983017]  7f3982b0 85d3e540 00000000 7f3a59cc 78288faa 00000000 00000001 00000000
[    4.983017] Call Trace:
[    4.983017]  [<7828d55b>] ? console_unlock+0x353/0x380
[    4.983017]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.983017]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.983017]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.983017]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.983017]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.983017]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.983017]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.983017]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.983017]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.983017]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.983017]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.983017]  [<785ec187>] generic_make_request+0xf/0xb5
[    4.983017]  [<785ec292>] submit_bio+0x65/0xd2
[    4.983017]  [<78313f8d>] _submit_bh+0x226/0x243
[    4.983017]  [<78313fb4>] submit_bh+0xa/0xc
[    4.983017]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    4.983017]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    4.983017]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.983017]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.983017]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.983017]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    4.983017]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    4.983017]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    4.983017]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.983017]  [<782bf256>] read_cache_page+0xb/0x12
[    4.983017]  [<785f61b2>] read_dev_sector+0x26/0x61
[    4.983017]  [<785f6c00>] read_lba+0xae/0xf9
[    4.983017]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    4.983017]  [<785f7130>] efi_partition+0x17a/0x9c0
[    4.983017]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    5.062202] No valid DiskOnChip devices found
[    5.062243] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    5.062244] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-lkp-st01-2:20131113001437:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    3.437525] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    3.439583] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    3.441254] pmc551: not detected
[    3.449232] INFO: trying to register non-static key.
[    3.450014] the code is fine but needs lockdep annotation.
[    3.450216] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    3.450014] turning off the locking correctness validator.
[    3.450014] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    3.450014] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.450014] Workqueue: events_unbound async_run_entry_fn
[    3.450014]  7828d55b 00000000 7f391968 78fa76a8 799d624c 7f3919a0 78288323 7938b281
[    3.450014]  7938b2db 7938b2b1 7f39d688 00000000 00000011 50352011 0000a985 7f39d1a0
[    3.450014]  7f39d1a0 85d3e540 00000000 7f3919cc 78288faa 00000000 00000001 00000000
[    3.450014] Call Trace:
[    3.450014]  [<7828d55b>] ? console_unlock+0x353/0x380
[    3.450014]  [<78fa76a8>] dump_stack+0x48/0x60
[    3.450014]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    3.450014]  [<78288faa>] lock_acquire+0x71/0x9a
[    3.450014]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.450014]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    3.450014]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.450014]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    3.450014]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    3.450014]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.450014]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    3.450014]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.450014]  [<785ec187>] generic_make_request+0xf/0xb5
[    3.450014]  [<785ec292>] submit_bio+0x65/0xd2
[    3.450014]  [<78313f8d>] _submit_bh+0x226/0x243
[    3.450014]  [<78313fb4>] submit_bh+0xa/0xc
[    3.450014]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    3.450014]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    3.450014]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    3.450014]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.450014]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.450014]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    3.450014]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    3.450014]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    3.450014]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.450014]  [<782bf256>] read_cache_page+0xb/0x12
[    3.450014]  [<785f61b2>] read_dev_sector+0x26/0x61
[    3.450014]  [<785f6c00>] read_lba+0xae/0xf9
[    3.450014]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    3.450014]  [<785f7130>] efi_partition+0x17a/0x9c0
[    3.450014]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    3.450014]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.450014]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.450014]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    3.450014]  [<7860b627>] ? snprintf+0x15/0x17
[    3.450014]  [<785f62e9>] check_partition+0xe4/0x178
[    3.488321] No valid DiskOnChip devices found
[    3.488344] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.488345] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-lkp-st01-3:20131112233024:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.174138] sector address bytes: 3
[    4.174667] options: 0x42
[    4.178069] Scanning device for bad blocks
[    4.216274] INFO: trying to register non-static key.
[    4.217017] the code is fine but needs lockdep annotation.
[    4.217017] turning off the locking correctness validator.
[    4.217017] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.217017] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.217017] Workqueue: events_unbound async_run_entry_fn
[    4.217017]  7828d55b 00000000 7f3b3968 78fa76a8 799d7a3c 7f3b39a0 78288323 7938b281
[    4.217017]  7938b2db 7938b2b1 7f3d6618 00000000 00000011 40364011 0000a785 7f3d6130
[    4.217017]  7f3d6130 85bf3540 00000000 7f3b39cc 78288faa 00000000 00000001 00000000
[    4.217017] Call Trace:
[    4.217017]  [<7828d55b>] ? console_unlock+0x353/0x380
[    4.217017]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.217017]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.217017]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.217017]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.217017]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.217017]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.217017]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.217017]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.217017]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.217017]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.217017]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.217017]  [<785ec187>] generic_make_request+0xf/0xb5
[    4.217017]  [<785ec292>] submit_bio+0x65/0xd2
[    4.217017]  [<78313f8d>] _submit_bh+0x226/0x243
[    4.217017]  [<78313fb4>] submit_bh+0xa/0xc
[    4.217017]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    4.217017]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    4.217017]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.217017]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.217017]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.217017]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    4.262614] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    4.262627] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    4.262840]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    4.262840]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    4.262840]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.262840]  [<782bf256>] read_cache_page+0xb/0x12
[    4.262840]  [<785f61b2>] read_dev_sector+0x26/0x61
[    4.262840]  [<785f6c00>] read_lba+0xae/0xf9
[    4.262840]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    4.262840]  [<785f7130>] efi_partition+0x17a/0x9c0
[    4.262840]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    4.262840]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.262840]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.262840]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    4.262840]  [<7860b627>] ? snprintf+0x15/0x17
[    4.262840]  [<785f62e9>] check_partition+0xe4/0x178
[    4.262840]  [<785f62e9>] ? check_partition+0xe4/0x178
[    4.262840]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    4.262840]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    4.262840]  [<78318d5f>] __blkdev_get+0x173/0x363
[    4.262840]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    4.262840]  [<78318658>] ? bdget+0xf8/0x105
[    4.262840]  [<788acee0>] ? put_device+0xf/0x11
[    4.262840]  [<785f3f90>] add_disk+0x26b/0x3b5
[    4.262840]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    4.262840]  [<789d1acd>] sd_probe_async+0x111/0x198
[    4.262840]  [<78274964>] async_run_entry_fn+0x59/0xff
[    4.262840]  [<7826bae8>] process_one_work+0x1ef/0x349
[    4.262840]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    4.262840]  [<7826c039>] worker_thread+0x1a3/0x274
[    4.262840]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    4.262840]  [<78270649>] kthread+0x8a/0x8f
[    4.262840]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    4.262840]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    4.262840]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    4.351038]  sda: unknown partition table
[    4.378782] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.388041] parport0: cannot grant exclusive access for device spi-lm70llp

dmesg-quantal-lkp-st01-4:20131112232946:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.209057] sd 0:0:0:0: [sda] Write Protect is off
[    4.209060] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    4.211048] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.222261] INFO: trying to register non-static key.
[    4.223017] the code is fine but needs lockdep annotation.
[    4.223017] turning off the locking correctness validator.
[    4.223017] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.223017] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.223017] Workqueue: events_unbound async_run_entry_fn
[    4.223017]  7828d55b 00000000 7f3ab968 78fa76a8 799d7a3c 7f3ab9a0 78288323 7938b281
[    4.223017]  7938b2db 7938b2b1 8781c598 00000000 00000011 5035c011 0000a985 8781c0b0
[    4.223017]  8781c0b0 85bf3540 00000000 7f3ab9cc 78288faa 00000000 00000001 00000000
[    4.223017] Call Trace:
[    4.223017]  [<7828d55b>] ? console_unlock+0x353/0x380
[    4.223017]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.223017]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.223017]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.223017]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.223017]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.223017]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.223017]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.223017]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.223017]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.223017]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.223017]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.223017]  [<785ec187>] generic_make_request+0xf/0xb5
[    4.223017]  [<785ec292>] submit_bio+0x65/0xd2
[    4.223017]  [<78313f8d>] _submit_bh+0x226/0x243
[    4.223017]  [<78313fb4>] submit_bh+0xa/0xc
[    4.223017]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    4.223017]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    4.223017]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.223017]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.223017]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.223017]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    4.223017]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    4.223017]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    4.223017]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.223017]  [<782bf256>] read_cache_page+0xb/0x12
[    4.223017]  [<785f61b2>] read_dev_sector+0x26/0x61
[    4.223017]  [<785f6c00>] read_lba+0xae/0xf9
[    4.223017]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    4.223017]  [<785f7130>] efi_partition+0x17a/0x9c0
[    4.223017]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    4.223017]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.223017]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.223017]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    4.223017]  [<7860b627>] ? snprintf+0x15/0x17
[    4.223017]  [<785f62e9>] check_partition+0xe4/0x178
[    4.223017]  [<785f62e9>] ? check_partition+0xe4/0x178
[    4.223017]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    4.289737] No valid DiskOnChip devices found
[    4.289764] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    4.289765] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-lkp-st01-4:20131112235226:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.630595] bits in OOB size: 4
[    4.632152] flash size with OOB: 135168 KiB
[    4.632774] page address bytes: 4
[    4.633258] INFO: trying to register non-static key.
[    4.633258] the code is fine but needs lockdep annotation.
[    4.633259] turning off the locking correctness validator.
[    4.633262] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.633263] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.633271] Workqueue: events_unbound async_run_entry_fn
[    4.633275]  7828d9ae 00000000 7f3e5968 78fa76a8 799d7a3c 7f3e59a0 78288323 7938b281
[    4.633279]  7938b2db 7938b2b1 7f3a4818 00000000 00000011 4035c011 0000a785 7f3a4330
[    4.633282]  7f3a4330 85bf3540 00000000 7f3e59cc 78288faa 00000000 00000001 00000000
[    4.633283] Call Trace:
[    4.633288]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    4.633292]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.633294]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.633296]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.633300]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.633302]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.633305]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.633307]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.633309]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.633311]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.633316]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.633318]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.633320]  [<785ec187>] generic_make_request+0xf/0xb5
[    4.633322]  [<785ec292>] submit_bio+0x65/0xd2
[    4.633325]  [<78313f8d>] _submit_bh+0x226/0x243
[    4.633327]  [<78313fb4>] submit_bh+0xa/0xc
[    4.633329]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    4.633331]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    4.633335]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.633337]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.633339]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.633341]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    4.633344]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    4.633346]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    4.633348]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.633350]  [<782bf256>] read_cache_page+0xb/0x12
[    4.633352]  [<785f61b2>] read_dev_sector+0x26/0x61
[    4.633354]  [<785f6c00>] read_lba+0xae/0xf9
[    4.633357]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    4.633359]  [<785f7130>] efi_partition+0x17a/0x9c0
[    4.633362]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    4.633365]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.633368]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.633370]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    4.633372]  [<7860b627>] ? snprintf+0x15/0x17
[    4.633374]  [<785f62e9>] check_partition+0xe4/0x178
[    4.633376]  [<785f62e9>] ? check_partition+0xe4/0x178
[    4.633378]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    4.633380]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    4.633383]  [<78318d5f>] __blkdev_get+0x173/0x363
[    4.633385]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    4.633387]  [<78318658>] ? bdget+0xf8/0x105
[    4.633391]  [<788acee0>] ? put_device+0xf/0x11
[    4.633392]  [<785f3f90>] add_disk+0x26b/0x3b5
[    4.633396]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    4.633400]  [<789d1acd>] sd_probe_async+0x111/0x198
[    4.633402]  [<78274964>] async_run_entry_fn+0x59/0xff
[    4.633406]  [<7826bae8>] process_one_work+0x1ef/0x349
[    4.633408]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    4.633410]  [<7826c039>] worker_thread+0x1a3/0x274
[    4.633412]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    4.633415]  [<78270649>] kthread+0x8a/0x8f
[    4.633417]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    4.633421]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    4.633423]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    4.635047]  sda: unknown partition table
[    4.639089] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.742760] sector address bytes: 3

dmesg-quantal-lkp-st01-4:20131113005050:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.801677] device id = 2670
[    4.802265] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    4.803265] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    4.804218] INFO: trying to register non-static key.
[    4.804218] the code is fine but needs lockdep annotation.
[    4.804219] turning off the locking correctness validator.
[    4.804222] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.804223] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.804230] Workqueue: events_unbound async_run_entry_fn
[    4.804235]  7828d9ae 00000000 7f3b5968 78fa76a8 799d7a3c 7f3b59a0 78288323 7938b281
[    4.804238]  7938b2db 7938b2b1 7f33e598 00000000 00000011 50358011 0000a985 7f33e0b0
[    4.804242]  7f33e0b0 85bf3540 00000000 7f3b59cc 78288faa 00000000 00000001 00000000
[    4.804243] Call Trace:
[    4.804247]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    4.804251]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.804253]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.804255]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.804260]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.804262]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.804264]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.804266]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.804269]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.804271]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.804275]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.804277]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.804279]  [<785ec187>] generic_make_request+0xf/0xb5
[    4.804281]  [<785ec292>] submit_bio+0x65/0xd2
[    4.804284]  [<78313f8d>] _submit_bh+0x226/0x243
[    4.804286]  [<78313fb4>] submit_bh+0xa/0xc
[    4.804288]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    4.804291]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    4.804295]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.804297]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.804299]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.804301]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    4.804304]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    4.804306]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    4.804308]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.804310]  [<782bf256>] read_cache_page+0xb/0x12
[    4.804312]  [<785f61b2>] read_dev_sector+0x26/0x61
[    4.804314]  [<785f6c00>] read_lba+0xae/0xf9
[    4.804317]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    4.804319]  [<785f7130>] efi_partition+0x17a/0x9c0
[    4.804323]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.804325]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.804328]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    4.804330]  [<7860b627>] ? snprintf+0x15/0x17
[    4.804332]  [<785f62e9>] check_partition+0xe4/0x178
[    4.804334]  [<785f62e9>] ? check_partition+0xe4/0x178
[    4.804336]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    4.804338]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    4.804340]  [<78318d5f>] __blkdev_get+0x173/0x363
[    4.804342]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    4.804344]  [<78318658>] ? bdget+0xf8/0x105
[    4.804348]  [<788acee0>] ? put_device+0xf/0x11
[    4.804350]  [<785f3f90>] add_disk+0x26b/0x3b5
[    4.804354]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    4.804357]  [<789d1acd>] sd_probe_async+0x111/0x198
[    4.804359]  [<78274964>] async_run_entry_fn+0x59/0xff
[    4.804363]  [<7826bae8>] process_one_work+0x1ef/0x349
[    4.804365]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    4.804368]  [<7826c039>] worker_thread+0x1a3/0x274
[    4.804370]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    4.804372]  [<78270649>] kthread+0x8a/0x8f
[    4.804374]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    4.804378]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    4.804380]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    4.806037]  sda: unknown partition table
[    4.810077] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.906146] pmc551: not detected

dmesg-quantal-lkp-st01-5:20131113004242:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.418840] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    4.420538] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    4.421767] pmc551: not detected
[    4.423231] INFO: trying to register non-static key.
[    4.423994] the code is fine but needs lockdep annotation.
[    4.424018] turning off the locking correctness validator.
[    4.424018] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.424018] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.424018] Workqueue: events_unbound async_run_entry_fn
[    4.424018]  7828d55b 00000000 7f3e9968 78fa76a8 799d7a3c 7f3e99a0 78288323 7938b281
[    4.424018]  7938b2db 7938b2b1 7f3d6918 00000000 00000011 50354011 0000a985 7f3d6430
[    4.424018]  7f3d6430 85bf3540 00000000 7f3e99cc 78288faa 00000000 00000001 00000000
[    4.424018] Call Trace:
[    4.424018]  [<7828d55b>] ? console_unlock+0x353/0x380
[    4.424018]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.424018]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.424018]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.424018]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.424018]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.424018]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.424018]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.424018]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.424018]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.424018]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.424018]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.424018]  [<785ec187>] generic_make_request+0xf/0xb5
[    4.424018]  [<785ec292>] submit_bio+0x65/0xd2
[    4.424018]  [<78313f8d>] _submit_bh+0x226/0x243
[    4.424018]  [<78313fb4>] submit_bh+0xa/0xc
[    4.424018]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    4.424018]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    4.424018]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.424018]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.424018]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.424018]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    4.424018]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    4.424018]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    4.424018]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.424018]  [<782bf256>] read_cache_page+0xb/0x12
[    4.424018]  [<785f61b2>] read_dev_sector+0x26/0x61
[    4.424018]  [<785f6c00>] read_lba+0xae/0xf9
[    4.424018]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    4.424018]  [<785f7130>] efi_partition+0x17a/0x9c0
[    4.424018]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    4.424018]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.424018]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.424018]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    4.424018]  [<7860b627>] ? snprintf+0x15/0x17
[    4.424018]  [<785f62e9>] check_partition+0xe4/0x178
[    4.424018]  [<785f62e9>] ? check_partition+0xe4/0x178
[    4.424018]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    4.424018]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    4.424018]  [<78318d5f>] __blkdev_get+0x173/0x363
[    4.424018]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    4.424018]  [<78318658>] ? bdget+0xf8/0x105
[    4.424018]  [<788acee0>] ? put_device+0xf/0x11
[    4.424018]  [<785f3f90>] add_disk+0x26b/0x3b5
[    4.424018]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    4.424018]  [<789d1acd>] sd_probe_async+0x111/0x198
[    4.424018]  [<78274964>] async_run_entry_fn+0x59/0xff
[    4.424018]  [<7826bae8>] process_one_work+0x1ef/0x349
[    4.424018]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    4.424018]  [<7826c039>] worker_thread+0x1a3/0x274
[    4.424018]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    4.424018]  [<78270649>] kthread+0x8a/0x8f
[    4.424018]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    4.424018]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    4.424018]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    4.504043]  sda: unknown partition table
[    4.508369] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    4.512091] sd 0:0:0:0: [sda] Attached SCSI disk

dmesg-quantal-lkp-st01-9:20131112235827:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    5.084786] pmc551: not detected
[    5.089047] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    5.112327] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    5.125262] INFO: trying to register non-static key.
[    5.126013] the code is fine but needs lockdep annotation.
[    5.126013] turning off the locking correctness validator.
[    5.126013] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    5.126013] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.126013] Workqueue: events_unbound async_run_entry_fn
[    5.126013]  7828d55b 00000000 7f3b3968 78fa76a8 799d624c 7f3b39a0 78288323 7938b281
[    5.126013]  7938b2db 7938b2b1 7f3cc618 00000000 00000011 4035e011 0000a785 7f3cc130
[    5.126013]  7f3cc130 85d3e540 00000000 7f3b39cc 78288faa 00000000 00000001 00000000
[    5.126013] Call Trace:
[    5.126013]  [<7828d55b>] ? console_unlock+0x353/0x380
[    5.126013]  [<78fa76a8>] dump_stack+0x48/0x60
[    5.126013]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    5.126013]  [<78288faa>] lock_acquire+0x71/0x9a
[    5.126013]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    5.126013]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    5.126013]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    5.126013]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    5.126013]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    5.126013]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    5.126013]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    5.126013]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    5.126013]  [<785ec187>] generic_make_request+0xf/0xb5
[    5.126013]  [<785ec292>] submit_bio+0x65/0xd2
[    5.126013]  [<78313f8d>] _submit_bh+0x226/0x243
[    5.126013]  [<78313fb4>] submit_bh+0xa/0xc
[    5.126013]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    5.126013]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    5.126013]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    5.126013]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    5.126013]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    5.126013]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    5.126013]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    5.126013]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    5.126013]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    5.126013]  [<782bf256>] read_cache_page+0xb/0x12
[    5.126013]  [<785f61b2>] read_dev_sector+0x26/0x61
[    5.126013]  [<785f6c00>] read_lba+0xae/0xf9
[    5.126013]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    5.126013]  [<785f7130>] efi_partition+0x17a/0x9c0
[    5.126013]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    5.126013]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    5.126013]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    5.126013]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    5.126013]  [<7860b627>] ? snprintf+0x15/0x17
[    5.126013]  [<785f62e9>] check_partition+0xe4/0x178
[    5.126013]  [<785f62e9>] ? check_partition+0xe4/0x178
[    5.126013]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    5.126013]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    5.126013]  [<78318d5f>] __blkdev_get+0x173/0x363
[    5.126013]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    5.126013]  [<78318658>] ? bdget+0xf8/0x105
[    5.126013]  [<788acee0>] ? put_device+0xf/0x11
[    5.126013]  [<785f3f90>] add_disk+0x26b/0x3b5
[    5.224748] No valid DiskOnChip devices found
[    5.224777] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    5.224778] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-lkp-tt02-11:20131112065950:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    3.756725] device id = 2670
[    3.758466] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.761902] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    3.762276] INFO: trying to register non-static key.
[    3.762278] the code is fine but needs lockdep annotation.
[    3.762278] turning off the locking correctness validator.
[    3.762282] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    3.762283] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.762290] Workqueue: events_unbound async_run_entry_fn
[    3.762295]  7828d9ae 00000000 7f3d5968 78fa76a8 799d624c 7f3d59a0 78288323 7938b281
[    3.762300]  7938b2db 7938b2b1 7f3a8798 00000000 00000011 40350011 0000a785 7f3a82b0
[    3.762303]  7f3a82b0 85d3e540 00000000 7f3d59cc 78288faa 00000000 00000001 00000000
[    3.762304] Call Trace:
[    3.762310]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    3.762314]  [<78fa76a8>] dump_stack+0x48/0x60
[    3.762316]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    3.762319]  [<78288faa>] lock_acquire+0x71/0x9a
[    3.762323]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.762325]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    3.762328]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.762330]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    3.762333]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    3.762335]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.762340]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    3.762342]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.762345]  [<785ec187>] generic_make_request+0xf/0xb5
[    3.762347]  [<785ec292>] submit_bio+0x65/0xd2
[    3.762351]  [<78313f8d>] _submit_bh+0x226/0x243
[    3.762353]  [<78313fb4>] submit_bh+0xa/0xc
[    3.762355]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    3.762357]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    3.762362]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    3.762365]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.762367]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.762370]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    3.762372]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    3.762375]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    3.762377]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.762380]  [<782bf256>] read_cache_page+0xb/0x12
[    3.762382]  [<785f61b2>] read_dev_sector+0x26/0x61
[    3.762384]  [<785f6c00>] read_lba+0xae/0xf9
[    3.762388]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    3.762390]  [<785f7130>] efi_partition+0x17a/0x9c0
[    3.762393]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    3.762397]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.762399]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.762402]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    3.762404]  [<7860b627>] ? snprintf+0x15/0x17
[    3.762407]  [<785f62e9>] check_partition+0xe4/0x178
[    3.762409]  [<785f62e9>] ? check_partition+0xe4/0x178
[    3.762411]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    3.762414]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    3.762416]  [<78318d5f>] __blkdev_get+0x173/0x363
[    3.762418]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    3.762421]  [<78318658>] ? bdget+0xf8/0x105
[    3.762425]  [<788acee0>] ? put_device+0xf/0x11
[    3.762427]  [<785f3f90>] add_disk+0x26b/0x3b5
[    3.762431]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    3.762434]  [<789d1acd>] sd_probe_async+0x111/0x198
[    3.762437]  [<78274964>] async_run_entry_fn+0x59/0xff
[    3.762441]  [<7826bae8>] process_one_work+0x1ef/0x349
[    3.762444]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    3.762446]  [<7826c039>] worker_thread+0x1a3/0x274
[    3.762449]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    3.762451]  [<78270649>] kthread+0x8a/0x8f
[    3.762454]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    3.762458]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    3.762460]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    3.858589] pmc551: not detected
[    3.860049]  sda: unknown partition table
[    3.865611] Spectra MTD driver built on Nov 12 2013 @ 15:28:09

dmesg-quantal-lkp-tt02-15:20131112065525:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.376906] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    4.378898] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.390088] SSFDC read-only Flash Translation layer
[    4.391154] INFO: trying to register non-static key.
[    4.391155] the code is fine but needs lockdep annotation.
[    4.391155] turning off the locking correctness validator.
[    4.391159] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.391160] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.391168] Workqueue: events_unbound async_run_entry_fn
[    4.391173]  7828d9ae 00000000 7f3ef968 78fa76a8 799d7a3c 7f3ef9a0 78288323 7938b281
[    4.391177]  7938b2db 7938b2b1 7f390718 00000000 00000011 40348011 0000a785 7f390230
[    4.391181]  7f390230 85bf3540 00000000 7f3ef9cc 78288faa 00000000 00000001 00000000
[    4.391182] Call Trace:
[    4.391187]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    4.391191]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.391194]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.391196]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.391200]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.391203]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.391205]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.391208]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.391210]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.391213]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.391218]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.391220]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.391222]  [<785ec187>] generic_make_request+0xf/0xb5
[    4.391225]  [<785ec292>] submit_bio+0x65/0xd2
[    4.391228]  [<78313f8d>] _submit_bh+0x226/0x243
[    4.391230]  [<78313fb4>] submit_bh+0xa/0xc
[    4.391233]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    4.391235]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    4.391240]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.391243]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.391245]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.391247]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    4.391250]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    4.391253]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    4.391255]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.391258]  [<782bf256>] read_cache_page+0xb/0x12
[    4.391260]  [<785f61b2>] read_dev_sector+0x26/0x61
[    4.391262]  [<785f6c00>] read_lba+0xae/0xf9
[    4.391266]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    4.391268]  [<785f7130>] efi_partition+0x17a/0x9c0
[    4.391271]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    4.391275]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.391278]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.391280]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    4.391283]  [<7860b627>] ? snprintf+0x15/0x17
[    4.391285]  [<785f62e9>] check_partition+0xe4/0x178
[    4.391288]  [<785f62e9>] ? check_partition+0xe4/0x178
[    4.391290]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    4.391292]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    4.391295]  [<78318d5f>] __blkdev_get+0x173/0x363
[    4.391297]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    4.391300]  [<78318658>] ? bdget+0xf8/0x105
[    4.391304]  [<788acee0>] ? put_device+0xf/0x11
[    4.391306]  [<785f3f90>] add_disk+0x26b/0x3b5
[    4.391310]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    4.391313]  [<789d1acd>] sd_probe_async+0x111/0x198
[    4.391316]  [<78274964>] async_run_entry_fn+0x59/0xff
[    4.391320]  [<7826bae8>] process_one_work+0x1ef/0x349
[    4.391323]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    4.391325]  [<7826c039>] worker_thread+0x1a3/0x274
[    4.391328]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    4.391330]  [<78270649>] kthread+0x8a/0x8f
[    4.391333]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    4.391337]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    4.391339]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    4.393887]  sda: unknown partition table
[    4.398087] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.485183] device id = 2440

dmesg-quantal-lkp-tt02-17:20131112075147:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    3.875651] device id = 25a1
[    3.876286] device id = 2670
[    3.877131] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.877596] INFO: trying to register non-static key.
[    3.877597] the code is fine but needs lockdep annotation.
[    3.877597] turning off the locking correctness validator.
[    3.877601] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    3.877602] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.877611] Workqueue: events_unbound async_run_entry_fn
[    3.877616]  7828d9ae 00000000 7f3cb968 78fa76a8 799d624c 7f3cb9a0 78288323 7938b281
[    3.877621]  7938b2db 7938b2b1 7f380718 00000000 00000011 50350011 0000a985 7f380230
[    3.877624]  7f380230 85d3e540 00000000 7f3cb9cc 78288faa 00000000 00000001 00000000
[    3.877625] Call Trace:
[    3.877631]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    3.877636]  [<78fa76a8>] dump_stack+0x48/0x60
[    3.877639]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    3.877641]  [<78288faa>] lock_acquire+0x71/0x9a
[    3.877646]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.877649]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    3.877651]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.877654]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    3.877657]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    3.877659]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.877664]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    3.877666]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.877669]  [<785ec187>] generic_make_request+0xf/0xb5
[    3.877671]  [<785ec292>] submit_bio+0x65/0xd2
[    3.877675]  [<78313f8d>] _submit_bh+0x226/0x243
[    3.877677]  [<78313fb4>] submit_bh+0xa/0xc
[    3.877680]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    3.877682]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    3.877687]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    3.877689]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.877692]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.877694]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    3.877697]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    3.877699]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    3.877702]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.877704]  [<782bf256>] read_cache_page+0xb/0x12
[    3.877707]  [<785f61b2>] read_dev_sector+0x26/0x61
[    3.877709]  [<785f6c00>] read_lba+0xae/0xf9
[    3.877712]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    3.877714]  [<785f7130>] efi_partition+0x17a/0x9c0
[    3.877717]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    3.877722]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.877724]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.877727]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    3.877730]  [<7860b627>] ? snprintf+0x15/0x17
[    3.877732]  [<785f62e9>] check_partition+0xe4/0x178
[    3.877734]  [<785f62e9>] ? check_partition+0xe4/0x178
[    3.877736]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    3.877739]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    3.877741]  [<78318d5f>] __blkdev_get+0x173/0x363
[    3.877744]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    3.877746]  [<78318658>] ? bdget+0xf8/0x105
[    3.877751]  [<788acee0>] ? put_device+0xf/0x11
[    3.877753]  [<785f3f90>] add_disk+0x26b/0x3b5
[    3.877757]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    3.877761]  [<789d1acd>] sd_probe_async+0x111/0x198
[    3.877764]  [<78274964>] async_run_entry_fn+0x59/0xff
[    3.877768]  [<7826bae8>] process_one_work+0x1ef/0x349
[    3.877771]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    3.877773]  [<7826c039>] worker_thread+0x1a3/0x274
[    3.877776]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    3.877779]  [<78270649>] kthread+0x8a/0x8f
[    3.877781]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    3.877785]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    3.877787]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    3.957771] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    3.959542] pmc551: not detected
[    3.960042]  sda: unknown partition table

dmesg-quantal-lkp-tt02-1:20131112070545:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    3.760696] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.762154] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    3.763697] pmc551: not detected
[    3.766297] INFO: trying to register non-static key.
[    3.767020] the code is fine but needs lockdep annotation.
[    3.767020] turning off the locking correctness validator.
[    3.768790] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    3.767020] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    3.767020] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.767020] Workqueue: events_unbound async_run_entry_fn
[    3.767020]  7828d55b 00000000 7f3bb968 78fa76a8 799d624c 7f3bb9a0 78288323 7938b281
[    3.767020]  7938b2db 7938b2b1 7f3e7488 00000000 00000011 44352011 0000a805 7f3e6fa0
[    3.767020]  7f3e6fa0 85d3e540 00000000 7f3bb9cc 78288faa 00000000 00000001 00000000
[    3.767020] Call Trace:
[    3.767020]  [<7828d55b>] ? console_unlock+0x353/0x380
[    3.767020]  [<78fa76a8>] dump_stack+0x48/0x60
[    3.767020]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    3.767020]  [<78288faa>] lock_acquire+0x71/0x9a
[    3.767020]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.767020]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    3.767020]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.767020]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    3.767020]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    3.767020]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.767020]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    3.807097] No valid DiskOnChip devices found
[    3.807121] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.807122] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-lkp-tt02-22:20131112074856:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.503297] pmc551: not detected
[    4.518033] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.522833] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    4.537287] INFO: trying to register non-static key.
[    4.538018] the code is fine but needs lockdep annotation.
[    4.538018] turning off the locking correctness validator.
[    4.538018] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.538018] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.538018] Workqueue: events_unbound async_run_entry_fn
[    4.538018]  7828d55b 00000000 7f3e5968 78fa76a8 799d624c 7f3e59a0 78288323 7938b281
[    4.538018]  7938b2db 7938b2b1 7f38f388 00000000 00000011 40358011 0000a785 7f38eea0
[    4.538018]  7f38eea0 85d3e540 00000000 7f3e59cc 78288faa 00000000 00000001 00000000
[    4.538018] Call Trace:
[    4.538018]  [<7828d55b>] ? console_unlock+0x353/0x380
[    4.538018]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.538018]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.538018]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.538018]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.538018]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.538018]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.538018]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.538018]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.538018]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.538018]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.538018]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.587736] No valid DiskOnChip devices found
[    4.587767] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    4.587768] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-lkp-tt02-23:20131112065912:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    3.008326] pmc551: not detected
[    3.009464] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    3.040558] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    3.041360] INFO: trying to register non-static key.
[    3.041360] the code is fine but needs lockdep annotation.
[    3.041361] turning off the locking correctness validator.
[    3.041365] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    3.041366] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.041375] Workqueue: events_unbound async_run_entry_fn
[    3.041380]  7828d9ae 00000000 7f3db968 78fa76a8 799d624c 7f3db9a0 78288323 7938b281
[    3.041384]  7938b2db 7938b2b1 7f332518 00000000 00000011 50356011 0000a985 7f332030
[    3.041388]  7f332030 85d3e540 00000000 7f3db9cc 78288faa 00000000 00000001 00000000
[    3.041389] Call Trace:
[    3.041395]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    3.041401]  [<78fa76a8>] dump_stack+0x48/0x60
[    3.041403]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    3.041406]  [<78288faa>] lock_acquire+0x71/0x9a
[    3.041411]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.041414]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    3.041416]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.041418]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    3.041421]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    3.041424]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.041430]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    3.041432]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.041434]  [<785ec187>] generic_make_request+0xf/0xb5
[    3.041436]  [<785ec292>] submit_bio+0x65/0xd2
[    3.041441]  [<78313f8d>] _submit_bh+0x226/0x243
[    3.041444]  [<78313fb4>] submit_bh+0xa/0xc
[    3.041446]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    3.041448]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    3.041455]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    3.041458]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.041460]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.041463]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    3.041465]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    3.041468]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    3.041471]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.041473]  [<782bf256>] read_cache_page+0xb/0x12
[    3.041476]  [<785f61b2>] read_dev_sector+0x26/0x61
[    3.041478]  [<785f6c00>] read_lba+0xae/0xf9
[    3.041482]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    3.041484]  [<785f7130>] efi_partition+0x17a/0x9c0
[    3.041488]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    3.041493]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.041495]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.041498]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    3.041501]  [<7860b627>] ? snprintf+0x15/0x17
[    3.041503]  [<785f62e9>] check_partition+0xe4/0x178
[    3.041505]  [<785f62e9>] ? check_partition+0xe4/0x178
[    3.041507]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    3.041510]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    3.041512]  [<78318d5f>] __blkdev_get+0x173/0x363
[    3.041515]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    3.041517]  [<78318658>] ? bdget+0xf8/0x105
[    3.041524]  [<788acee0>] ? put_device+0xf/0x11
[    3.041526]  [<785f3f90>] add_disk+0x26b/0x3b5
[    3.041532]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    3.041538]  [<789d1acd>] sd_probe_async+0x111/0x198
[    3.041540]  [<78274964>] async_run_entry_fn+0x59/0xff
[    3.041546]  [<7826bae8>] process_one_work+0x1ef/0x349
[    3.041549]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    3.041551]  [<7826c039>] worker_thread+0x1a3/0x274
[    3.041554]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    3.041557]  [<78270649>] kthread+0x8a/0x8f
[    3.041559]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    3.041564]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    3.041566]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    3.116042]  sda: unknown partition table
[    3.121085] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.154135] No valid DiskOnChip devices found

dmesg-quantal-lkp-tt02-3:20131112065742:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.234030] pmc551: not detected
[    4.261290] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.267271] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    4.268380] INFO: trying to register non-static key.
[    4.268381] the code is fine but needs lockdep annotation.
[    4.268382] turning off the locking correctness validator.
[    4.268386] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.268387] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.268398] Workqueue: events_unbound async_run_entry_fn
[    4.268403]  7828d9ae 00000000 7f3f1968 78fa76a8 799d624c 7f3f19a0 78288323 7938b281
[    4.268407]  7938b2db 7938b2b1 7f390798 00000000 00000011 40356011 0000a785 7f3902b0
[    4.268411]  7f3902b0 85d3e540 00000000 7f3f19cc 78288faa 00000000 00000001 00000000
[    4.268412] Call Trace:
[    4.268418]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    4.268424]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.268427]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.268429]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.268434]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.268437]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.268440]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.268442]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.268445]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.268447]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.268453]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.268455]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.268458]  [<785ec187>] generic_make_request+0xf/0xb5
[    4.268460]  [<785ec292>] submit_bio+0x65/0xd2
[    4.268464]  [<78313f8d>] _submit_bh+0x226/0x243
[    4.268466]  [<78313fb4>] submit_bh+0xa/0xc
[    4.268469]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    4.268472]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    4.268477]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.268480]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.268482]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.268485]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    4.268487]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    4.268490]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    4.268492]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.268495]  [<782bf256>] read_cache_page+0xb/0x12
[    4.268497]  [<785f61b2>] read_dev_sector+0x26/0x61
[    4.268500]  [<785f6c00>] read_lba+0xae/0xf9
[    4.268503]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    4.268506]  [<785f7130>] efi_partition+0x17a/0x9c0
[    4.268509]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    4.268513]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.268516]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.268519]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    4.268521]  [<7860b627>] ? snprintf+0x15/0x17
[    4.268524]  [<785f62e9>] check_partition+0xe4/0x178
[    4.268526]  [<785f62e9>] ? check_partition+0xe4/0x178
[    4.268528]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    4.268531]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    4.268533]  [<78318d5f>] __blkdev_get+0x173/0x363
[    4.268536]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    4.268538]  [<78318658>] ? bdget+0xf8/0x105
[    4.268544]  [<788acee0>] ? put_device+0xf/0x11
[    4.268546]  [<785f3f90>] add_disk+0x26b/0x3b5
[    4.268550]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    4.268555]  [<789d1acd>] sd_probe_async+0x111/0x198
[    4.268557]  [<78274964>] async_run_entry_fn+0x59/0xff
[    4.268562]  [<7826bae8>] process_one_work+0x1ef/0x349
[    4.268565]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    4.268567]  [<7826c039>] worker_thread+0x1a3/0x274
[    4.268570]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    4.268573]  [<78270649>] kthread+0x8a/0x8f
[    4.268575]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    4.268579]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    4.268582]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    4.341044]  sda: unknown partition table
[    4.346084] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.379091] No valid DiskOnChip devices found

dmesg-quantal-lkp-tt02-6:20131112073129:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.209092] sd 0:0:0:0: [sda] Write Protect is off
[    4.210096] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    4.213057] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.222304] INFO: trying to register non-static key.
[    4.223022] the code is fine but needs lockdep annotation.
[    4.223022] turning off the locking correctness validator.
[    4.223022] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.223022] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.223022] Workqueue: events_unbound async_run_entry_fn
[    4.223022]  7828d55b 00000000 7f3c3968 78fa76a8 799d7a3c 7f3c39a0 78288323 7938b281
[    4.223022]  7938b2db 7938b2b1 7f384718 00000000 00000011 5035c011 0000a985 7f384230
[    4.223022]  7f384230 85bf3540 00000000 7f3c39cc 78288faa 00000000 00000001 00000000
[    4.223022] Call Trace:
[    4.223022]  [<7828d55b>] ? console_unlock+0x353/0x380
[    4.223022]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.223022]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.223022]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.223022]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.223022]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.223022]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.223022]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.223022]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.223022]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.223022]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.223022]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.223022]  [<785ec187>] generic_make_request+0xf/0xb5
[    4.266024] No valid DiskOnChip devices found
[    4.266052] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    4.266053] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-lkp-tt02-9:20131112065252:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    3.735659] device id = 25a1
[    3.736261] device id = 2670
[    3.736959] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.737319] INFO: trying to register non-static key.
[    3.737320] the code is fine but needs lockdep annotation.
[    3.737321] turning off the locking correctness validator.
[    3.737324] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    3.737325] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.737333] Workqueue: events_unbound async_run_entry_fn
[    3.737338]  7828d9ae 00000000 7f3f3968 78fa76a8 799d7a3c 7f3f39a0 78288323 7938b281
[    3.737342]  7938b2db 7938b2b1 7f38c618 00000000 00000011 4034e011 0000a785 7f38c130
[    3.737346]  7f38c130 85bf3540 00000000 7f3f39cc 78288faa 00000000 00000001 00000000
[    3.737347] Call Trace:
[    3.737353]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    3.737357]  [<78fa76a8>] dump_stack+0x48/0x60
[    3.737360]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    3.737362]  [<78288faa>] lock_acquire+0x71/0x9a
[    3.737366]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.737369]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    3.737371]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.737374]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    3.737376]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    3.737379]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.737384]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    3.737386]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.737389]  [<785ec187>] generic_make_request+0xf/0xb5
[    3.737391]  [<785ec292>] submit_bio+0x65/0xd2
[    3.737395]  [<78313f8d>] _submit_bh+0x226/0x243
[    3.737397]  [<78313fb4>] submit_bh+0xa/0xc
[    3.737400]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    3.737402]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    3.737407]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    3.737410]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.737412]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.737414]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    3.737417]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    3.737420]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    3.737422]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.737425]  [<782bf256>] read_cache_page+0xb/0x12
[    3.737427]  [<785f61b2>] read_dev_sector+0x26/0x61
[    3.737429]  [<785f6c00>] read_lba+0xae/0xf9
[    3.737433]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    3.737435]  [<785f7130>] efi_partition+0x17a/0x9c0
[    3.737438]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    3.737442]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.737445]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.737448]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    3.737450]  [<7860b627>] ? snprintf+0x15/0x17
[    3.737452]  [<785f62e9>] check_partition+0xe4/0x178
[    3.737455]  [<785f62e9>] ? check_partition+0xe4/0x178
[    3.737457]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    3.737459]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    3.737462]  [<78318d5f>] __blkdev_get+0x173/0x363
[    3.737464]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    3.737467]  [<78318658>] ? bdget+0xf8/0x105
[    3.737471]  [<788acee0>] ? put_device+0xf/0x11
[    3.737473]  [<785f3f90>] add_disk+0x26b/0x3b5
[    3.737478]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    3.737482]  [<789d1acd>] sd_probe_async+0x111/0x198
[    3.737485]  [<78274964>] async_run_entry_fn+0x59/0xff
[    3.737489]  [<7826bae8>] process_one_work+0x1ef/0x349
[    3.737492]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    3.737494]  [<7826c039>] worker_thread+0x1a3/0x274
[    3.737497]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    3.737499]  [<78270649>] kthread+0x8a/0x8f
[    3.737502]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    3.737506]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    3.737508]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    3.742044]  sda: unknown partition table
[    3.746093] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.809233] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.

dmesg-quantal-stoakley-4:20131112160859:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.361145] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.362659] pmc551: not detected
[    2.374045] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.374554] INFO: trying to register non-static key.
[    2.374555] the code is fine but needs lockdep annotation.
[    2.374555] turning off the locking correctness validator.
[    2.374558] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.374559] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.374566] Workqueue: events_unbound async_run_entry_fn
[    2.374570]  7828d9ae 00000000 7f3eb968 78fa76a8 799d624c 7f3eb9a0 78288323 7938b281
[    2.374573]  7938b2db 7938b2b1 7f3e3308 00000000 00000011 40352011 0000a785 7f3e2e20
[    2.374576]  7f3e2e20 85d3e540 00000000 7f3eb9cc 78288faa 00000000 00000001 00000000
[    2.374577] Call Trace:
[    2.374582]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    2.374585]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.374588]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.374589]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.374593]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.374595]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.374597]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.374598]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.374601]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.374603]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.374606]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.374608]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.374610]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.374612]  [<785ec292>] submit_bio+0x65/0xd2
[    2.374615]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.374617]  [<78313fb4>] submit_bh+0xa/0xc
[    2.374619]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.374621]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.374625]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.374626]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.374628]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.374630]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.374632]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.374634]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.374636]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.374638]  [<782bf256>] read_cache_page+0xb/0x12
[    2.374640]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.374642]  [<785f6c00>] read_lba+0xae/0xf9
[    2.374644]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.374646]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.374648]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.374651]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.374653]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.374656]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.374658]  [<7860b627>] ? snprintf+0x15/0x17
[    2.374659]  [<785f62e9>] check_partition+0xe4/0x178
[    2.374661]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.374663]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.374665]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.374667]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.374668]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.374670]  [<78318658>] ? bdget+0xf8/0x105
[    2.374674]  [<788acee0>] ? put_device+0xf/0x11
[    2.374676]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.374679]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.374682]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.374684]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.374688]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.374690]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.374692]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.374693]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.374695]  [<78270649>] kthread+0x8a/0x8f
[    2.374697]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.374701]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.374703]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.426031]  sda: unknown partition table
[    2.430066] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.462792] No valid DiskOnChip devices found

dmesg-quantal-stoakley-5:20131112165538:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.493225] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    4.494138] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    4.495176] pmc551: not detected
[    4.505267] INFO: trying to register non-static key.
[    4.505972] the code is fine but needs lockdep annotation.
[    4.506013] turning off the locking correctness validator.
[    4.506013] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.506013] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.506013] Workqueue: events_unbound async_run_entry_fn
[    4.506013]  7828d55b 00000000 7f3b5968 78fa76a8 799d624c 7f3b59a0 78288323 7938b281
[    4.506013]  7938b2db 7938b2b1 7f3ed508 00000000 00000011 50354011 0000a985 7f3ed020
[    4.506013]  7f3ed020 85d3e540 00000000 7f3b59cc 78288faa 00000000 00000001 00000000
[    4.506013] Call Trace:
[    4.506013]  [<7828d55b>] ? console_unlock+0x353/0x380
[    4.506013]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.506013]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.506013]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.506013]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.506013]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.506013]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.506013]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.506013]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.506013]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.506013]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.506013]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.506013]  [<785ec187>] generic_make_request+0xf/0xb5
[    4.506013]  [<785ec292>] submit_bio+0x65/0xd2
[    4.506013]  [<78313f8d>] _submit_bh+0x226/0x243
[    4.506013]  [<78313fb4>] submit_bh+0xa/0xc
[    4.506013]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    4.506013]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    4.506013]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.506013]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.506013]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.506013]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    4.506013]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    4.506013]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    4.506013]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.506013]  [<782bf256>] read_cache_page+0xb/0x12
[    4.506013]  [<785f61b2>] read_dev_sector+0x26/0x61
[    4.506013]  [<785f6c00>] read_lba+0xae/0xf9
[    4.506013]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    4.506013]  [<785f7130>] efi_partition+0x17a/0x9c0
[    4.506013]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    4.506013]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.506013]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    4.506013]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    4.506013]  [<7860b627>] ? snprintf+0x15/0x17
[    4.506013]  [<785f62e9>] check_partition+0xe4/0x178
[    4.506013]  [<785f62e9>] ? check_partition+0xe4/0x178
[    4.506013]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    4.506013]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    4.506013]  [<78318d5f>] __blkdev_get+0x173/0x363
[    4.506013]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    4.506013]  [<78318658>] ? bdget+0xf8/0x105
[    4.506013]  [<788acee0>] ? put_device+0xf/0x11
[    4.506013]  [<785f3f90>] add_disk+0x26b/0x3b5
[    4.506013]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    4.506013]  [<789d1acd>] sd_probe_async+0x111/0x198
[    4.506013]  [<78274964>] async_run_entry_fn+0x59/0xff
[    4.506013]  [<7826bae8>] process_one_work+0x1ef/0x349
[    4.506013]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    4.506013]  [<7826c039>] worker_thread+0x1a3/0x274
[    4.506013]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    4.506013]  [<78270649>] kthread+0x8a/0x8f
[    4.506013]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    4.506013]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    4.506013]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    4.601342]  sda: unknown partition table
[    4.602904] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    4.617068] sd 0:0:0:0: [sda] Attached SCSI disk

dmesg-quantal-stoakley-5:20131112165835:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.464040] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    2.466050] pmc551: not detected
[    2.469662] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.472202] INFO: trying to register non-static key.
[    2.472881] the code is fine but needs lockdep annotation.
[    2.473012] turning off the locking correctness validator.
[    2.473012] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.473012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.473012] Workqueue: events_unbound async_run_entry_fn
[    2.473012]  7828d55b 00000000 7f39b968 78fa76a8 799d624c 7f39b9a0 78288323 7938b281
[    2.473012]  7938b2db 7938b2b1 7f3bc618 00000000 00000011 40358011 0000a785 7f3bc130
[    2.473012]  7f3bc130 85d3e540 00000000 7f39b9cc 78288faa 00000000 00000001 00000000
[    2.473012] Call Trace:
[    2.473012]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.473012]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.473012]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.473012]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.473012]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.473012]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.473012]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.473012]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.473012]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.473012]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.473012]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.473012]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.473012]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.473012]  [<785ec292>] submit_bio+0x65/0xd2
[    2.473012]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.473012]  [<78313fb4>] submit_bh+0xa/0xc
[    2.473012]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.473012]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.473012]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.473012]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.473012]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.473012]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.473012]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.473012]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.473012]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.473012]  [<782bf256>] read_cache_page+0xb/0x12
[    2.473012]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.473012]  [<785f6c00>] read_lba+0xae/0xf9
[    2.473012]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.473012]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.473012]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.473012]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.473012]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.473012]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.473012]  [<7860b627>] ? snprintf+0x15/0x17
[    2.473012]  [<785f62e9>] check_partition+0xe4/0x178
[    2.473012]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.473012]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.473012]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.473012]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.508676] No valid DiskOnChip devices found
[    2.508701] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.508702] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-waimea-1:20131113005252:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    6.274511] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    6.275823] pmc551: not detected
[    6.278684] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    6.281161] INFO: trying to register non-static key.
[    6.281922] the code is fine but needs lockdep annotation.
[    6.282023] turning off the locking correctness validator.
[    6.282023] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    6.282023] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.282023] Workqueue: events_unbound async_run_entry_fn
[    6.282023]  7828d55b 00000000 7f3e5968 78fa76a8 799d624c 7f3e59a0 78288323 7938b281
[    6.282023]  7938b2db 7938b2b1 7f3a5508 00000000 00000011 40358011 0000a785 7f3a5020
[    6.282023]  7f3a5020 85d3e540 00000000 7f3e59cc 78288faa 00000000 00000001 00000000
[    6.282023] Call Trace:
[    6.282023]  [<7828d55b>] ? console_unlock+0x353/0x380
[    6.282023]  [<78fa76a8>] dump_stack+0x48/0x60
[    6.282023]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    6.282023]  [<78288faa>] lock_acquire+0x71/0x9a
[    6.282023]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    6.282023]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    6.282023]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    6.282023]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    6.282023]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    6.282023]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    6.282023]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    6.282023]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    6.282023]  [<785ec187>] generic_make_request+0xf/0xb5
[    6.282023]  [<785ec292>] submit_bio+0x65/0xd2
[    6.282023]  [<78313f8d>] _submit_bh+0x226/0x243
[    6.282023]  [<78313fb4>] submit_bh+0xa/0xc
[    6.282023]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    6.282023]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    6.282023]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    6.282023]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.282023]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.282023]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    6.282023]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    6.282023]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    6.282023]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.282023]  [<782bf256>] read_cache_page+0xb/0x12
[    6.282023]  [<785f61b2>] read_dev_sector+0x26/0x61
[    6.282023]  [<785f6c00>] read_lba+0xae/0xf9
[    6.343524] No valid DiskOnChip devices found
[    6.343544] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    6.343546] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-waimea-6:20131113000215:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    7.363614] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    7.369914] pmc551: not detected
[    7.376700] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    7.382979] INFO: trying to register non-static key.
[    7.383822] the code is fine but needs lockdep annotation.
[    7.383822] turning off the locking correctness validator.
[    7.383822] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    7.383822] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    7.383822] Workqueue: events_unbound async_run_entry_fn
[    7.383822]  7828d55b 00000000 7f3d5968 78fa76a8 799d624c 7f3d59a0 78288323 7938b281
[    7.383822]  7938b2db 7938b2b1 7f3c9308 00000000 00000011 4435c011 0000a805 7f3c8e20
[    7.383822]  7f3c8e20 85d3e540 00000000 7f3d59cc 78288faa 00000000 00000001 00000000
[    7.383822] Call Trace:
[    7.383822]  [<7828d55b>] ? console_unlock+0x353/0x380
[    7.383822]  [<78fa76a8>] dump_stack+0x48/0x60
[    7.383822]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    7.383822]  [<78288faa>] lock_acquire+0x71/0x9a
[    7.383822]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    7.383822]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    7.383822]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    7.383822]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    7.383822]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    7.383822]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    7.383822]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    7.383822]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    7.383822]  [<785ec187>] generic_make_request+0xf/0xb5
[    7.383822]  [<785ec292>] submit_bio+0x65/0xd2
[    7.383822]  [<78313f8d>] _submit_bh+0x226/0x243
[    7.383822]  [<78313fb4>] submit_bh+0xa/0xc
[    7.383822]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    7.383822]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    7.383822]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    7.383822]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    7.383822]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    7.383822]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    7.383822]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    7.383822]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    7.383822]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    7.383822]  [<782bf256>] read_cache_page+0xb/0x12
[    7.383822]  [<785f61b2>] read_dev_sector+0x26/0x61
[    7.383822]  [<785f6c00>] read_lba+0xae/0xf9
[    7.383822]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    7.383822]  [<785f7130>] efi_partition+0x17a/0x9c0
[    7.383822]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    7.383822]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    7.383822]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    7.383822]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    7.383822]  [<7860b627>] ? snprintf+0x15/0x17
[    7.383822]  [<785f62e9>] check_partition+0xe4/0x178
[    7.383822]  [<785f62e9>] ? check_partition+0xe4/0x178
[    7.465828] No valid DiskOnChip devices found
[    7.465848] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    7.465849] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-waimea-9:20131113000931:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    6.021298] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.023309] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.038607] SSFDC read-only Flash Translation layer
[    6.041386] INFO: trying to register non-static key.
[    6.042149] the code is fine but needs lockdep annotation.
[    6.042149] turning off the locking correctness validator.
[    6.042149] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2

dmesg-quantal-waimea-9:20131113005338:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    6.830826] options: 0x42
[    6.846482] Scanning device for bad blocks
[    6.877853] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.906188] INFO: trying to register non-static key.
[    6.907029] the code is fine but needs lockdep annotation.
[    6.907029] turning off the locking correctness validator.
[    6.907029] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    6.907029] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.907029] Workqueue: events_unbound async_run_entry_fn
[    6.907029]  7828d55b 00000000 78095968 78fa76a8 799d7a3c 780959a0 78288323 7938b281
[    6.907029]  7938b2db 7938b2b1 7f394818 00000000 00000011 50366011 0000a985 7f394330
[    6.907029]  7f394330 85bf3540 00000000 780959cc 78288faa 00000000 00000001 00000000
[    6.907029] Call Trace:
[    6.907029]  [<7828d55b>] ? console_unlock+0x353/0x380
[    6.923987] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    6.923992] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    6.924229]  [<78fa76a8>] dump_stack+0x48/0x60
[    6.924229]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    6.924229]  [<78288faa>] lock_acquire+0x71/0x9a
[    6.924229]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    6.924229]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    6.924229]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    6.924229]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    6.924229]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    6.924229]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    6.924229]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    6.924229]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    6.924229]  [<785ec187>] generic_make_request+0xf/0xb5
[    6.924229]  [<785ec292>] submit_bio+0x65/0xd2
[    6.924229]  [<78313f8d>] _submit_bh+0x226/0x243
[    6.924229]  [<78313fb4>] submit_bh+0xa/0xc
[    6.924229]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    6.924229]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    6.924229]  [<782c78b6>] ? __pagevec_lru_add+0xf/0x11
[    6.924229]  [<782c78fd>] ? __lru_cache_add+0x45/0x5b
[    6.924229]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.924229]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    6.924229]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    6.924229]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    6.924229]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    6.924229]  [<782bf256>] read_cache_page+0xb/0x12
[    6.924229]  [<785f61b2>] read_dev_sector+0x26/0x61
[    6.924229]  [<785f6c00>] read_lba+0xae/0xf9
[    6.924229]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    6.924229]  [<785f7130>] efi_partition+0x17a/0x9c0
[    6.924229]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    6.924229]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    6.924229]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    6.924229]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    6.924229]  [<7860b627>] ? snprintf+0x15/0x17
[    6.924229]  [<785f62e9>] check_partition+0xe4/0x178
[    6.924229]  [<785f62e9>] ? check_partition+0xe4/0x178
[    6.924229]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    6.924229]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    6.924229]  [<78318d5f>] __blkdev_get+0x173/0x363
[    6.924229]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    6.924229]  [<78318658>] ? bdget+0xf8/0x105
[    6.924229]  [<788acee0>] ? put_device+0xf/0x11
[    6.924229]  [<785f3f90>] add_disk+0x26b/0x3b5
[    6.924229]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    6.924229]  [<789d1acd>] sd_probe_async+0x111/0x198
[    6.924229]  [<78274964>] async_run_entry_fn+0x59/0xff
[    6.924229]  [<7826bae8>] process_one_work+0x1ef/0x349
[    6.924229]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    6.924229]  [<7826c039>] worker_thread+0x1a3/0x274
[    6.924229]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    6.924229]  [<78270649>] kthread+0x8a/0x8f
[    6.924229]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    6.924229]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    6.924229]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    7.068720] parport0: cannot grant exclusive access for device spi-lm70llp
[    7.070062] spi-lm70llp: spi_lm70llp probe fail, status -12
[    7.072076] libphy: Fixed MDIO Bus: probed

dmesg-quantal-xgwo-1:20131113004536:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    4.590948] pmc551: not detected
[    4.612084] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.616829] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    4.657111] INFO: trying to register non-static key.
[    4.657906] the code is fine but needs lockdep annotation.
[    4.658089] turning off the locking correctness validator.
[    4.658089] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    4.658089] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.658089] Workqueue: events_unbound async_run_entry_fn
[    4.658089]  7828d55b 00000000 7f3e1968 78fa76a8 799d624c 7f3e19a0 78288323 7938b281
[    4.658089]  7938b2db 7938b2b1 7f3d2598 00000000 00000011 4035a011 0000a785 7f3d20b0
[    4.658089]  7f3d20b0 85d3e540 00000000 7f3e19cc 78288faa 00000000 00000001 00000000
[    4.658089] Call Trace:
[    4.658089]  [<7828d55b>] ? console_unlock+0x353/0x380
[    4.658089]  [<78fa76a8>] dump_stack+0x48/0x60
[    4.658089]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.658089]  [<78288faa>] lock_acquire+0x71/0x9a
[    4.658089]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.658089]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    4.658089]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    4.658089]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    4.658089]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    4.658089]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.658089]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    4.658089]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    4.658089]  [<785ec187>] generic_make_request+0xf/0xb5
[    4.658089]  [<785ec292>] submit_bio+0x65/0xd2
[    4.658089]  [<78313f8d>] _submit_bh+0x226/0x243
[    4.658089]  [<78313fb4>] submit_bh+0xa/0xc
[    4.658089]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    4.658089]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    4.658089]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.658089]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.658089]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    4.658089]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    4.658089]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    4.658089]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    4.715132] No valid DiskOnChip devices found
[    4.715154] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    4.715155] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-xian-17:20131112160544:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.741669] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.742791] pmc551: not detected
[    2.745291] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.746233] INFO: trying to register non-static key.
[    2.746858] the code is fine but needs lockdep annotation.
[    2.747027] turning off the locking correctness validator.
[    2.747027] CPU: 0 PID: 6 Comm: kworker/u4:0 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.747027] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.747027] Workqueue: events_unbound async_run_entry_fn
[    2.747027]  7828d55b 00000000 854fb968 78fa76a8 799d7a3c 854fb9a0 78288323 7938b281
[    2.747027]  7938b2db 7938b2b1 854f6618 00000000 00000011 50352011 0000a985 854f6130
[    2.747027]  854f6130 85bf3540 00000000 854fb9cc 78288faa 00000000 00000001 00000000
[    2.747027] Call Trace:
[    2.747027]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.747027]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.747027]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.747027]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.747027]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.747027]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.747027]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.747027]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.747027]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.747027]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.747027]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.747027]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.747027]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.747027]  [<785ec292>] submit_bio+0x65/0xd2
[    2.747027]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.747027]  [<78313fb4>] submit_bh+0xa/0xc
[    2.747027]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.747027]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.747027]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.747027]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.747027]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.747027]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.747027]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.747027]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.747027]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.747027]  [<782bf256>] read_cache_page+0xb/0x12
[    2.747027]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.747027]  [<785f6c00>] read_lba+0xae/0xf9
[    2.747027]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.747027]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.747027]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.747027]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.747027]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.747027]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.747027]  [<7860b627>] ? snprintf+0x15/0x17
[    2.747027]  [<785f62e9>] check_partition+0xe4/0x178
[    2.747027]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.747027]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.747027]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.747027]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.747027]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.747027]  [<78318658>] ? bdget+0xf8/0x105
[    2.747027]  [<788acee0>] ? put_device+0xf/0x11
[    2.747027]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.747027]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.747027]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.747027]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.747027]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.784386] No valid DiskOnChip devices found
[    2.784411] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.784413] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-xian-34:20131112153804:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.848552] spi-lm70llp: spi_lm70llp probe fail, status -12
[    2.850745] libphy: Fixed MDIO Bus: probed
[    2.852249] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    2.852269] INFO: trying to register non-static key.
[    2.852270] the code is fine but needs lockdep annotation.
[    2.852271] turning off the locking correctness validator.
[    2.852275] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.852276] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.852287] Workqueue: events_unbound async_run_entry_fn
[    2.852292]  7828d9ae 00000000 7f3ef968 78fa76a8 799d624c 7f3ef9a0 78288323 7938b281
[    2.852297]  7938b2db 7938b2b1 7f3c8618 00000000 00000011 40360011 0000a785 7f3c8130
[    2.852301]  7f3c8130 85d3e540 00000000 7f3ef9cc 78288faa 00000000 00000001 00000000
[    2.852303] Call Trace:
[    2.852310]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    2.852315]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.852318]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.852321]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.852326]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.852329]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.852332]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.852335]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.852339]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.852341]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.852347]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.852350]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.852352]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.852355]  [<785ec292>] submit_bio+0x65/0xd2
[    2.852361]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.852364]  [<78313fb4>] submit_bh+0xa/0xc
[    2.852366]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.852369]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.852375]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.852379]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.852381]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.852384]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.852387]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.852390]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.852393]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.852396]  [<782bf256>] read_cache_page+0xb/0x12
[    2.852398]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.852401]  [<785f6c00>] read_lba+0xae/0xf9
[    2.852405]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.852408]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.852411]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.852416]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.852419]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.852423]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.852426]  [<7860b627>] ? snprintf+0x15/0x17
[    2.852428]  [<785f62e9>] check_partition+0xe4/0x178
[    2.852431]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.852433]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.852437]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.852440]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.852443]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.852445]  [<78318658>] ? bdget+0xf8/0x105
[    2.852451]  [<788acee0>] ? put_device+0xf/0x11
[    2.852453]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.852460]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.852464]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.852467]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.852473]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.852476]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.852479]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.852482]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.852485]  [<78270649>] kthread+0x8a/0x8f
[    2.852487]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.852493]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.852496]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.898696] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.18 (Sept 01, 2013)
[    2.900058]  sda: unknown partition table
[    2.900115] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50

dmesg-quantal-xian-42:20131112170024:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.684592] device id = 2670
[    2.685197] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.686107] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.687244] INFO: trying to register non-static key.
[    2.687252] pmc551: not detected
[    2.688025] the code is fine but needs lockdep annotation.
[    2.688025] turning off the locking correctness validator.
[    2.688025] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.688025] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.688025] Workqueue: events_unbound async_run_entry_fn
[    2.688025]  7828d55b 00000000 7f3cb968 78fa76a8 799d7a3c 7f3cb9a0 78288323 7938b281
[    2.688025]  7938b2db 7938b2b1 7f399488 00000000 00000011 40352011 0000a785 7f398fa0
[    2.688025]  7f398fa0 85bf3540 00000000 7f3cb9cc 78288faa 00000000 00000001 00000000
[    2.688025] Call Trace:
[    2.688025]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.688025]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.688025]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.688025]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.688025]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.688025]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.688025]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.688025]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.688025]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.688025]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.688025]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.688025]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.688025]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.688025]  [<785ec292>] submit_bio+0x65/0xd2
[    2.688025]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.688025]  [<78313fb4>] submit_bh+0xa/0xc
[    2.688025]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.688025]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.688025]  [<782c78b6>] ? __pagevec_lru_add+0xf/0x11
[    2.688025]  [<782c78fd>] ? __lru_cache_add+0x45/0x5b
[    2.688025]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.688025]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.688025]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.688025]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.688025]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.688025]  [<782bf256>] read_cache_page+0xb/0x12
[    2.688025]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.688025]  [<785f6c00>] read_lba+0xae/0xf9
[    2.688025]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.688025]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.688025]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.688025]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.688025]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.688025]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.688025]  [<7860b627>] ? snprintf+0x15/0x17
[    2.688025]  [<785f62e9>] check_partition+0xe4/0x178
[    2.688025]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.688025]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.688025]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.688025]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.688025]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.688025]  [<78318658>] ? bdget+0xf8/0x105
[    2.688025]  [<788acee0>] ? put_device+0xf/0x11
[    2.688025]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.688025]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.688025]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.688025]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.688025]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.688025]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.688025]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.688025]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.688025]  [<78270649>] kthread+0x8a/0x8f
[    2.688025]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.688025]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.688025]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.721664] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.722078]  sda: unknown partition table
[    2.726077] sd 0:0:0:0: [sda] Attached SCSI disk

dmesg-quantal-xian-7:20131112154210:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.868703] device id = 2670
[    2.869323] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.870384] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.871265] INFO: trying to register non-static key.
[    2.871267] the code is fine but needs lockdep annotation.
[    2.871268] turning off the locking correctness validator.
[    2.871273] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.871275] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.871284] Workqueue: events_unbound async_run_entry_fn
[    2.871290]  7828d9ae 00000000 7f3a5968 78fa76a8 799d7a3c 7f3a59a0 78288323 7938b281
[    2.871295]  7938b2db 7938b2b1 7f39c798 00000000 00000011 40352011 0000a785 7f39c2b0
[    2.871300]  7f39c2b0 85bf3540 00000000 7f3a59cc 78288faa 00000000 00000001 00000000
[    2.871301] Call Trace:
[    2.871308]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    2.871314]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.871317]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.871320]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.871325]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.871328]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.871331]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.871333]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.871337]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.871340]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.871346]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.871348]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.871351]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.871354]  [<785ec292>] submit_bio+0x65/0xd2
[    2.871358]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.871361]  [<78313fb4>] submit_bh+0xa/0xc
[    2.871364]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.871367]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.871372]  [<782c78b6>] ? __pagevec_lru_add+0xf/0x11
[    2.871375]  [<782c78fd>] ? __lru_cache_add+0x45/0x5b
[    2.871378]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.871381]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.871387]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.871390]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.871393]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.871396]  [<782bf256>] read_cache_page+0xb/0x12
[    2.871398]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.871401]  [<785f6c00>] read_lba+0xae/0xf9
[    2.871405]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.871407]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.871411]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.871416]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.871419]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.871423]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.871426]  [<7860b627>] ? snprintf+0x15/0x17
[    2.871428]  [<785f62e9>] check_partition+0xe4/0x178
[    2.871431]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.871433]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.871436]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.871439]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.871442]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.871445]  [<78318658>] ? bdget+0xf8/0x105
[    2.871449]  [<788acee0>] ? put_device+0xf/0x11
[    2.871451]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.871456]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.871459]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.871462]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.871468]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.871471]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.871474]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.871477]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.871479]  [<78270649>] kthread+0x8a/0x8f
[    2.871482]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.871486]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.871489]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.873060]  sda: unknown partition table
[    2.877121] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.924600] pmc551: not detected

dmesg-quantal-xps-1:20131113005454:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    3.180102] pmc551: not detected
[    3.181133] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    3.184433] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    3.189332] INFO: trying to register non-static key.
[    3.190032] the code is fine but needs lockdep annotation.
[    3.190061] turning off the locking correctness validator.
[    3.190061] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    3.190061] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.190061] Workqueue: events_unbound async_run_entry_fn
[    3.190061]  7828d55b 00000000 7f3f9968 78fa76a8 799d624c 7f3f99a0 78288323 7938b281
[    3.190061]  7938b2db 7938b2b1 7f3a8918 00000000 00000011 40358011 0000a785 7f3a8430
[    3.190061]  7f3a8430 85d3e540 00000000 7f3f99cc 78288faa 00000000 00000001 00000000
[    3.190061] Call Trace:
[    3.190061]  [<7828d55b>] ? console_unlock+0x353/0x380
[    3.190061]  [<78fa76a8>] dump_stack+0x48/0x60
[    3.190061]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    3.190061]  [<78288faa>] lock_acquire+0x71/0x9a
[    3.190061]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.190061]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    3.190061]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.190061]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    3.190061]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    3.190061]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.190061]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    3.190061]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.190061]  [<785ec187>] generic_make_request+0xf/0xb5
[    3.190061]  [<785ec292>] submit_bio+0x65/0xd2
[    3.190061]  [<78313f8d>] _submit_bh+0x226/0x243
[    3.190061]  [<78313fb4>] submit_bh+0xa/0xc
[    3.190061]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    3.190061]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    3.190061]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    3.190061]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.190061]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.190061]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    3.190061]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    3.190061]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    3.190061]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.190061]  [<782bf256>] read_cache_page+0xb/0x12
[    3.190061]  [<785f61b2>] read_dev_sector+0x26/0x61
[    3.190061]  [<785f6c00>] read_lba+0xae/0xf9
[    3.190061]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    3.190061]  [<785f7130>] efi_partition+0x17a/0x9c0
[    3.190061]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    3.190061]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.190061]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.190061]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    3.190061]  [<7860b627>] ? snprintf+0x15/0x17
[    3.248464] No valid DiskOnChip devices found
[    3.248534] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.248535] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-quantal-xps-2:20131112233313:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    5.716932] pmc551: not detected
[    5.724087] tsc: Refined TSC clocksource calibration: 2927.442 MHz
[    5.725828] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    5.728368] INFO: trying to register non-static key.
[    5.729137] the code is fine but needs lockdep annotation.
[    5.729137] turning off the locking correctness validator.
[    5.729137] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    5.729137] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    5.729137] Workqueue: events_unbound async_run_entry_fn
[    5.729137]  7828d55b 00000000 7f3e9968 78fa76a8 799d624c 7f3e99a0 78288323 7938b281
[    5.729137]  7938b2db 7938b2b1 7f3a0898 00000000 00000011 44356011 0000a805 7f3a03b0
[    5.729137]  7f3a03b0 85d3e540 00000000 7f3e99cc 78288faa 00000000 00000001 00000000
[    5.729137] Call Trace:
[    5.729137]  [<7828d55b>] ? console_unlock+0x353/0x380
[    5.729137]  [<78fa76a8>] dump_stack+0x48/0x60
[    5.729137]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    5.729137]  [<78288faa>] lock_acquire+0x71/0x9a
[    5.729137]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    5.729137]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    5.729137]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    5.729137]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    5.729137]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    5.729137]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    5.729137]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    5.729137]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    5.729137]  [<785ec187>] generic_make_request+0xf/0xb5
[    5.729137]  [<785ec292>] submit_bio+0x65/0xd2
[    5.729137]  [<78313f8d>] _submit_bh+0x226/0x243
[    5.729137]  [<78313fb4>] submit_bh+0xa/0xc
[    5.769515] No valid DiskOnChip devices found
[    5.769561] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    5.769563] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-ant-1:20131112235739:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[   35.106900] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[   35.116716] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[   35.118956] pmc551: not detected
[   35.226271] INFO: trying to register non-static key.
[   35.226437] the code is fine but needs lockdep annotation.
[   35.226437] turning off the locking correctness validator.
[   35.226437] CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 3.12.0-00186-gd3516a7 #2
[   35.226437] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   35.226437] Workqueue: events_unbound async_run_entry_fn
[   35.226437]  7828d55b 00000000 86cfd968 78fa76a8 799d92ec 86cfd9a0 78288323 7938b281
[   35.226437]  7938b2db 7938b2b1 86cfd984 00000000 86cfd98c 7828eed0 86cfd9a8 86cf80b0
[   35.226437]  86cf80b0 87198540 00000000 86cfd9cc 78288faa 00000000 00000001 00000000
[   35.226437] Call Trace:
[   35.226437]  [<7828d55b>] ? console_unlock+0x353/0x380
[   35.226437]  [<78fa76a8>] dump_stack+0x48/0x60
[   35.226437]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[   35.226437]  [<7828eed0>] ? irq_to_desc+0xf/0x11
[   35.226437]  [<78288faa>] lock_acquire+0x71/0x9a
[   35.226437]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[   35.226437]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[   35.226437]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[   35.226437]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[   35.226437]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[   35.226437]  [<78607548>] ? radix_tree_lookup+0xa/0xc
[   35.226437]  [<7828eed0>] ? irq_to_desc+0xf/0x11
[   35.226437]  [<7825ef31>] ? irq_exit+0x50/0x52
[   35.226437]  [<7822c7a0>] ? do_IRQ+0x7a/0x8e
[   35.226437]  [<78fbb0e9>] ? common_interrupt+0x29/0x2e
[   35.226437]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[   35.226437]  [<785ec187>] generic_make_request+0xf/0xb5
[   35.226437]  [<785ec292>] submit_bio+0x65/0xd2
[   35.226437]  [<78313f8d>] _submit_bh+0x226/0x243
[   35.226437]  [<78313fb4>] submit_bh+0xa/0xc
[   35.226437]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[   35.226437]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[   35.226437]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[   35.226437]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[   35.226437]  [<78317ec3>] blkdev_readpage+0xf/0x11
[   35.226437]  [<782be517>] do_read_cache_page+0x6e/0x11b
[   35.226437]  [<782bf225>] read_cache_page_async+0x19/0x1e
[   35.226437]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[   35.226437]  [<782bf256>] read_cache_page+0xb/0x12
[   35.226437]  [<785f61b2>] read_dev_sector+0x26/0x61
[   35.226437]  [<785f6c00>] read_lba+0xae/0xf9
[   35.226437]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[   35.226437]  [<785f7130>] efi_partition+0x17a/0x9c0
[   35.226437]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[   35.226437]  [<78607548>] ? radix_tree_lookup+0xa/0xc
[   35.226437]  [<7825ef31>] ? irq_exit+0x50/0x52
[   35.226437]  [<7822c7a0>] ? do_IRQ+0x7a/0x8e
[   35.226437]  [<78fbb0e9>] ? common_interrupt+0x29/0x2e
[   35.226437]  [<785f6fb6>] ? is_gpt_valid+0x36b/0x36b
[   35.226437]  [<785f62e9>] check_partition+0xe4/0x178
[   35.226437]  [<785f62e9>] ? check_partition+0xe4/0x178
[   35.226437]  [<785f5f3b>] rescan_partitions+0x89/0x267
[   35.226437]  [<78318d5f>] __blkdev_get+0x173/0x363
[   35.226437]  [<7822c7a0>] ? do_IRQ+0x7a/0x8e
[   35.226437]  [<78318f9a>] blkdev_get+0x4b/0x23d
[   35.226437]  [<785f3d1f>] ? bdget_disk+0x29/0x2f
[   35.226437]  [<785f3f90>] add_disk+0x26b/0x3b5
[   35.226437]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[   35.226437]  [<789d1acd>] sd_probe_async+0x111/0x198
[   35.226437]  [<78274964>] async_run_entry_fn+0x59/0xff
[   35.226437]  [<7826bae8>] process_one_work+0x1ef/0x349
[   35.226437]  [<7826ba8f>] ? process_one_work+0x196/0x349
[   35.226437]  [<7826c039>] worker_thread+0x1a3/0x274
[   35.226437]  [<7826be96>] ? rescuer_thread+0x233/0x233
[   35.226437]  [<78270649>] kthread+0x8a/0x8f
[   35.226437]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[   35.226437]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[   35.226437]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[   35.307897]  sda: unknown partition table
[   35.393684] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[   35.440653] No valid DiskOnChip devices found

dmesg-yocto-ant-8:20131113002420:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[   31.096727] Scanning device for bad blocks
[   33.527987] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[   33.531618] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[   33.682222] INFO: trying to register non-static key.
[   33.682381] the code is fine but needs lockdep annotation.
[   33.682381] turning off the locking correctness validator.
[   33.682381] CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 3.12.0-00186-gd3516a7 #2
[   33.682381] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   33.682381] Workqueue: events_unbound async_run_entry_fn
[   33.682381]  7828d55b 00000000 86cfd968 78fa76a8 799d92ec 86cfd9a0 78288323 7938b281
[   33.682381]  7938b2db 7938b2b1 00000000 00000000 86cfd98c 78607548 86cfd994 86cf80b0
[   33.682381]  86cf80b0 87198540 00000000 86cfd9cc 78288faa 00000000 00000001 00000000
[   33.682381] Call Trace:
[   33.682381]  [<7828d55b>] ? console_unlock+0x353/0x380
[   33.682381]  [<78fa76a8>] dump_stack+0x48/0x60
[   33.682381]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[   33.682381]  [<78607548>] ? radix_tree_lookup+0xa/0xc
[   33.682381]  [<78288faa>] lock_acquire+0x71/0x9a
[   33.682381]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[   33.682381]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[   33.682381]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[   33.682381]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[   33.682381]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[   33.682381]  [<78607548>] ? radix_tree_lookup+0xa/0xc
[   33.682381]  [<7828eed0>] ? irq_to_desc+0xf/0x11
[   33.682381]  [<7825ef31>] ? irq_exit+0x50/0x52
[   33.682381]  [<7822c7a0>] ? do_IRQ+0x7a/0x8e
[   33.682381]  [<78fbb0e9>] ? common_interrupt+0x29/0x2e
[   33.682381]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[   33.682381]  [<78607548>] ? radix_tree_lookup+0xa/0xc
[   33.682381]  [<7828eed0>] ? irq_to_desc+0xf/0x11
[   33.682381]  [<785ec187>] generic_make_request+0xf/0xb5
[   33.682381]  [<785ec292>] submit_bio+0x65/0xd2
[   33.682381]  [<78313f8d>] _submit_bh+0x226/0x243
[   33.682381]  [<78313fb4>] submit_bh+0xa/0xc
[   33.682381]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[   33.682381]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[   33.682381]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[   33.682381]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[   33.682381]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[   33.682381]  [<78317ec3>] blkdev_readpage+0xf/0x11
[   33.682381]  [<782be517>] do_read_cache_page+0x6e/0x11b
[   33.682381]  [<782bf225>] read_cache_page_async+0x19/0x1e
[   33.682381]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[   33.682381]  [<782bf256>] read_cache_page+0xb/0x12
[   33.682381]  [<785f61b2>] read_dev_sector+0x26/0x61
[   33.682381]  [<785f6c00>] read_lba+0xae/0xf9
[   33.682381]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[   33.682381]  [<785f7130>] efi_partition+0x17a/0x9c0
[   33.682381]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[   33.682381]  [<78607548>] ? radix_tree_lookup+0xa/0xc
[   33.682381]  [<7825ef31>] ? irq_exit+0x50/0x52
[   33.682381]  [<7822c7a0>] ? do_IRQ+0x7a/0x8e
[   33.682381]  [<78fbb0e9>] ? common_interrupt+0x29/0x2e
[   33.682381]  [<785f6fb6>] ? is_gpt_valid+0x36b/0x36b
[   33.682381]  [<785f62e9>] check_partition+0xe4/0x178
[   33.682381]  [<785f62e9>] ? check_partition+0xe4/0x178
[   33.682381]  [<785f5f3b>] rescan_partitions+0x89/0x267
[   33.682381]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[   33.682381]  [<78318d5f>] __blkdev_get+0x173/0x363
[   33.682381]  [<7822c7a0>] ? do_IRQ+0x7a/0x8e
[   33.682381]  [<78318f9a>] blkdev_get+0x4b/0x23d
[   33.682381]  [<788acee0>] ? put_device+0xf/0x11
[   33.682381]  [<785f3f90>] add_disk+0x26b/0x3b5
[   33.682381]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[   33.682381]  [<789d1acd>] sd_probe_async+0x111/0x198
[   33.682381]  [<78274964>] async_run_entry_fn+0x59/0xff
[   33.682381]  [<7826bae8>] process_one_work+0x1ef/0x349
[   33.682381]  [<7826ba8f>] ? process_one_work+0x196/0x349
[   33.682381]  [<7826c039>] worker_thread+0x1a3/0x274
[   33.682381]  [<7826be96>] ? rescuer_thread+0x233/0x233
[   33.682381]  [<78270649>] kthread+0x8a/0x8f
[   33.682381]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[   33.682381]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[   33.682381]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[   33.754156]  sda: unknown partition table
[   33.774489] parport0: cannot grant exclusive access for device spi-lm70llp
[   33.775715] spi-lm70llp: spi_lm70llp probe fail, status -12

dmesg-yocto-bens-1:20131112165949:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.535784] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.540869] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.542065] pmc551: not detected
[    2.545279] INFO: trying to register non-static key.
[    2.546014] the code is fine but needs lockdep annotation.
[    2.546014] turning off the locking correctness validator.
[    2.546014] CPU: 1 PID: 95 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.548925] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.548925] Workqueue: events_unbound async_run_entry_fn
[    2.548925]  7828d55b 00000000 8572f968 78fa76a8 799d7af4 8572f9a0 78288323 7938b281
[    2.548925]  7938b2db 7938b2b1 85762598 00000000 00000011 34352011 0000a605 857620b0
[    2.548925]  857620b0 872e3540 00000000 8572f9cc 78288faa 00000000 00000001 00000000
[    2.548925] Call Trace:
[    2.548925]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.548925]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.548925]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.548925]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.548925]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.548925]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.548925]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.548925]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.548925]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.548925]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.548925]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.548925]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.548925]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.548925]  [<785ec292>] submit_bio+0x65/0xd2
[    2.548925]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.548925]  [<78313fb4>] submit_bh+0xa/0xc
[    2.548925]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.548925]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.548925]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.548925]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.548925]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.548925]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.548925]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.548925]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.548925]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.548925]  [<782bf256>] read_cache_page+0xb/0x12
[    2.548925]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.548925]  [<785f6c00>] read_lba+0xae/0xf9
[    2.548925]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.548925]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.548925]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.548925]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.548925]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.548925]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.548925]  [<7860b627>] ? snprintf+0x15/0x17
[    2.548925]  [<785f62e9>] check_partition+0xe4/0x178
[    2.548925]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.548925]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.548925]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.548925]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.548925]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.548925]  [<78318658>] ? bdget+0xf8/0x105
[    2.548925]  [<788acee0>] ? put_device+0xf/0x11
[    2.548925]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.548925]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.548925]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.548925]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.548925]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.548925]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.548925]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.548925]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.548925]  [<78270649>] kthread+0x8a/0x8f
[    2.548925]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.548925]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.548925]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.625457] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.630036]  sda: unknown partition table
[    2.634082] sd 0:0:0:0: [sda] Attached SCSI disk

dmesg-yocto-bens-2:20131112153616:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.329372] spi-lm70llp: spi_lm70llp probe fail, status -12
[    2.332739] libphy: Fixed MDIO Bus: probed
[    2.334692] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    2.335345] INFO: trying to register non-static key.
[    2.335346] the code is fine but needs lockdep annotation.
[    2.335347] turning off the locking correctness validator.
[    2.335356] CPU: 0 PID: 95 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.335357] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.335395] Workqueue: events_unbound async_run_entry_fn
[    2.335400]  7828d9ae 00000000 8574b968 78fa76a8 799d92ec 8574b9a0 78288323 7938b281
[    2.335404]  7938b2db 7938b2b1 85728798 00000000 00000011 44360011 0000a805 857282b0
[    2.335407]  857282b0 87198540 00000000 8574b9cc 78288faa 00000000 00000001 00000000
[    2.335408] Call Trace:
[    2.335420]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    2.335444]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.335446]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.335448]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.335468]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.335471]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.335473]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.335475]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.335478]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.335480]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.335486]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.335488]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.335490]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.335492]  [<785ec292>] submit_bio+0x65/0xd2
[    2.335512]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.335514]  [<78313fb4>] submit_bh+0xa/0xc
[    2.335516]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.335519]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.335524]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.335527]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.335529]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.335531]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.335533]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.335536]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.335538]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.335540]  [<782bf256>] read_cache_page+0xb/0x12
[    2.335542]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.335544]  [<785f6c00>] read_lba+0xae/0xf9
[    2.335547]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.335554]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.335557]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.335561]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.335563]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.335569]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.335571]  [<7860b627>] ? snprintf+0x15/0x17
[    2.335573]  [<785f62e9>] check_partition+0xe4/0x178
[    2.335575]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.335577]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.335580]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.335582]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.335584]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.335586]  [<78318658>] ? bdget+0xf8/0x105
[    2.335607]  [<788acee0>] ? put_device+0xf/0x11
[    2.335610]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.335617]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.335629]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.335631]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.335636]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.335638]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.335641]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.335643]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.335645]  [<78270649>] kthread+0x8a/0x8f
[    2.335647]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.335655]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.335657]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.337059]  sda: unknown partition table
[    2.341092] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.395373] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.18 (Sept 01, 2013)

dmesg-yocto-bens-3:20131112161602:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.559181] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.560308] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.563537] e1000 0000:00:03.0: setting latency timer to 64
[    1.568355] INFO: trying to register non-static key.
[    1.569036] the code is fine but needs lockdep annotation.
[    1.569036] turning off the locking correctness validator.
[    1.569036] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.569036] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.569036] Workqueue: events_unbound async_run_entry_fn
[    1.569036]  7828d55b 00000000 85791968 78fa76a8 799d7af4 857919a0 78288323 7938b281
[    1.569036]  7938b2db 7938b2b1 85753588 00000000 00000011 34362011 0000a605 857530a0
[    1.569036]  857530a0 872e3540 00000000 857919cc 78288faa 00000000 00000001 00000000
[    1.569036] Call Trace:
[    1.569036]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.569036]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.569036]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.569036]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.569036]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.569036]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.569036]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.569036]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.569036]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.569036]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.569036]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.569036]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.569036]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.569036]  [<785ec292>] submit_bio+0x65/0xd2
[    1.569036]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.569036]  [<78313fb4>] submit_bh+0xa/0xc
[    1.569036]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.569036]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.569036]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.569036]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.569036]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.569036]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.569036]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.569036]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.569036]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.569036]  [<782bf256>] read_cache_page+0xb/0x12
[    1.569036]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.569036]  [<785f6c00>] read_lba+0xae/0xf9
[    1.569036]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.569036]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.569036]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.569036]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.569036]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.569036]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.569036]  [<7860b627>] ? snprintf+0x15/0x17
[    1.569036]  [<785f62e9>] check_partition+0xe4/0x178
[    1.569036]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.569036]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.569036]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.569036]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.569036]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.569036]  [<78318658>] ? bdget+0xf8/0x105
[    1.569036]  [<788acee0>] ? put_device+0xf/0x11
[    1.569036]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.569036]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.569036]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.569036]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.569036]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.569036]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.569036]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.569036]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.569036]  [<78270649>] kthread+0x8a/0x8f
[    1.569036]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.569036]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.569036]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.628086]  sda: unknown partition table
[    1.638112] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.754076] tsc: Refined TSC clocksource calibration: 2666.604 MHz

dmesg-yocto-bens-4:20131112154040:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.512619] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    2.516646] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.517816] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.518861] INFO: trying to register non-static key.
[    2.518862] the code is fine but needs lockdep annotation.
[    2.518862] turning off the locking correctness validator.
[    2.518872] CPU: 0 PID: 95 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.518872] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.518909] Workqueue: events_unbound async_run_entry_fn
[    2.518914]  7828d9ae 00000000 85783968 78fa76a8 799d92ec 857839a0 78288323 7938b281
[    2.518917]  7938b2db 7938b2b1 85732718 00000000 00000011 38354011 0000a685 85732230
[    2.518921]  85732230 87198540 00000000 857839cc 78288faa 00000000 00000001 00000000
[    2.518922] Call Trace:
[    2.518933]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    2.518955]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.518958]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.518960]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.518978]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.518980]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.518983]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.518985]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.518988]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.518990]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.518995]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.518997]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.518999]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.519001]  [<785ec292>] submit_bio+0x65/0xd2
[    2.519015]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.519017]  [<78313fb4>] submit_bh+0xa/0xc
[    2.519019]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.519022]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.519026]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.519028]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.519030]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.519033]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.519035]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.519037]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.519040]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.519042]  [<782bf256>] read_cache_page+0xb/0x12
[    2.519044]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.519046]  [<785f6c00>] read_lba+0xae/0xf9
[    2.519049]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.519051]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.519054]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.519058]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.519060]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.519065]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.519068]  [<7860b627>] ? snprintf+0x15/0x17
[    2.519070]  [<785f62e9>] check_partition+0xe4/0x178
[    2.519072]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.519074]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.519076]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.519078]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.519080]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.519082]  [<78318658>] ? bdget+0xf8/0x105
[    2.519103]  [<788acee0>] ? put_device+0xf/0x11
[    2.519106]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.519112]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.519124]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.519126]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.519130]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.519144]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.519146]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.519149]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.519151]  [<78270649>] kthread+0x8a/0x8f
[    2.519153]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.519161]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.519163]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.521037]  sda: unknown partition table
[    2.525103] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.586148] pmc551: not detected

dmesg-yocto-cairo-21:20131112161531:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.524306] libphy: Fixed MDIO Bus: probed
[    1.525982] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    1.527108] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.18 (Sept 01, 2013)
[    1.530211] INFO: trying to register non-static key.
[    1.530235] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50
[    1.530266] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    1.530399] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)

dmesg-yocto-cairo-26:20131112155501:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.498946] device id = 2480
[    1.499496] device id = 24c0
[    1.499967] device id = 24d0
[    1.500261] INFO: trying to register non-static key.
[    1.500262] the code is fine but needs lockdep annotation.
[    1.500263] turning off the locking correctness validator.
[    1.500267] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.500269] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.500280] Workqueue: events_unbound async_run_entry_fn
[    1.500286]  7828d9ae 00000000 85789968 78fa76a8 799d92ec 857899a0 78288323 7938b281
[    1.500291]  7938b2db 7938b2b1 8575c998 00000000 00000011 38344011 0000a685 8575c4b0
[    1.500295]  8575c4b0 87198540 00000000 857899cc 78288faa 00000000 00000001 00000000
[    1.500296] Call Trace:
[    1.500304]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    1.500310]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.500313]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.500316]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.500321]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.500324]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.500327]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.500330]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.500335]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.500338]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.500344]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.500346]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.500349]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.500352]  [<785ec292>] submit_bio+0x65/0xd2
[    1.500356]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.500359]  [<78313fb4>] submit_bh+0xa/0xc
[    1.500362]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.500365]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.500370]  [<782c78b6>] ? __pagevec_lru_add+0xf/0x11
[    1.500373]  [<782c78fd>] ? __lru_cache_add+0x45/0x5b
[    1.500376]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.500379]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.500384]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.500387]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.500389]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.500392]  [<782bf256>] read_cache_page+0xb/0x12
[    1.500395]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.500397]  [<785f6c00>] read_lba+0xae/0xf9
[    1.500401]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.500403]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.500406]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.500412]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.500415]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.500418]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.500421]  [<7860b627>] ? snprintf+0x15/0x17
[    1.500423]  [<785f62e9>] check_partition+0xe4/0x178
[    1.500426]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.500428]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.500431]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.500434]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.500437]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.500442]  [<78318658>] ? bdget+0xf8/0x105
[    1.500447]  [<788acee0>] ? put_device+0xf/0x11
[    1.500449]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.500453]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.500457]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.500460]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.500464]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.500467]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.500470]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.500474]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.500476]  [<78270649>] kthread+0x8a/0x8f
[    1.500479]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.500483]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.500486]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.502061]  sda: unknown partition table
[    1.506120] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.560531] device id = 25a1

dmesg-yocto-inn-47:20131112161057:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.141665] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    1.142073] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.144186] pmc551: not detected
[    1.147197] INFO: trying to register non-static key.
[    1.147211] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    1.148020] the code is fine but needs lockdep annotation.
[    1.148020] turning off the locking correctness validator.
[    1.148020] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.148020] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.148020] Workqueue: events_unbound async_run_entry_fn
[    1.148020]  7828d55b 00000000 85757968 78fa76a8 799d92ec 857579a0 78288323 7938b281
[    1.148020]  7938b2db 7938b2b1 85734718 00000000 00000011 3834e011 0000a685 85734230
[    1.148020]  85734230 87198540 00000000 857579cc 78288faa 00000000 00000001 00000000
[    1.148020] Call Trace:
[    1.148020]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.148020]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.148020]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.148020]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.148020]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.148020]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.148020]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.148020]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.148020]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.148020]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.148020]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.148020]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.148020]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.148020]  [<785ec292>] submit_bio+0x65/0xd2
[    1.148020]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.148020]  [<78313fb4>] submit_bh+0xa/0xc
[    1.148020]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.148020]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.148020]  [<782c78b6>] ? __pagevec_lru_add+0xf/0x11
[    1.148020]  [<782c78fd>] ? __lru_cache_add+0x45/0x5b
[    1.148020]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.148020]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.148020]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.148020]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.148020]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.148020]  [<782bf256>] read_cache_page+0xb/0x12
[    1.148020]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.148020]  [<785f6c00>] read_lba+0xae/0xf9
[    1.148020]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.148020]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.148020]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.148020]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.148020]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.148020]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.148020]  [<7860b627>] ? snprintf+0x15/0x17
[    1.148020]  [<785f62e9>] check_partition+0xe4/0x178
[    1.148020]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.148020]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.148020]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.148020]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.148020]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.148020]  [<78318658>] ? bdget+0xf8/0x105
[    1.148020]  [<788acee0>] ? put_device+0xf/0x11
[    1.148020]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.148020]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.148020]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.148020]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.148020]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.148020]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.148020]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.148020]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.148020]  [<78270649>] kthread+0x8a/0x8f
[    1.148020]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.148020]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.148020]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.183051]  sda: unknown partition table
[    1.185375] No valid DiskOnChip devices found
[    1.186150] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-jaketown-23:20131112153658:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.112141] sd 0:0:0:0: [sda] Write Protect is off
[    2.112147] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    2.114144] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    2.120639] INFO: trying to register non-static key.
[    2.120642] the code is fine but needs lockdep annotation.
[    2.120644] turning off the locking correctness validator.
[    2.120653] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.120656] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.120672] Workqueue: events_unbound async_run_entry_fn
[    2.120687]  7828d9ae 00000000 85761968 78fa76a8 799d92ec 857619a0 78288323 7938b281
[    2.120701]  7938b2db 7938b2b1 8574b408 00000000 00000011 44344011 0000a805 8574af20
[    2.120711]  8574af20 87198540 00000000 857619cc 78288faa 00000000 00000001 00000000
[    2.120714] Call Trace:
[    2.120727]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    2.120738]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.120745]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.120751]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.120761]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.120768]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.120775]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.120782]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.120791]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.120797]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.120809]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.120815]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.120822]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.120827]  [<785ec292>] submit_bio+0x65/0xd2
[    2.120836]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.120842]  [<78313fb4>] submit_bh+0xa/0xc
[    2.120849]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.120856]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.120867]  [<782c78b6>] ? __pagevec_lru_add+0xf/0x11
[    2.120874]  [<782c78fd>] ? __lru_cache_add+0x45/0x5b
[    2.120881]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.120887]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.120898]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.120905]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.120911]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.120918]  [<782bf256>] read_cache_page+0xb/0x12
[    2.120924]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.120930]  [<785f6c00>] read_lba+0xae/0xf9
[    2.120938]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.120944]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.120956]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.120963]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.120971]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.120985]  [<7860b627>] ? snprintf+0x15/0x17
[    2.120991]  [<785f62e9>] check_partition+0xe4/0x178
[    2.120996]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.121002]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.121008]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.121026]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.121032]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.121039]  [<78318658>] ? bdget+0xf8/0x105
[    2.121050]  [<788acee0>] ? put_device+0xf/0x11
[    2.121056]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.121056]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.121056]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.121056]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.121056]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.121056]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.121056]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.121056]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.121056]  [<78270649>] kthread+0x8a/0x8f
[    2.121056]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.121056]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.121056]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.123182]  sda: unknown partition table
[    2.127250] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.251782] SSFDC read-only Flash Translation layer

dmesg-yocto-jaketown-28:20131112153612:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.983826] device id = 25a1
[    1.984985] device id = 2670
[    1.986299] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    1.986533] INFO: trying to register non-static key.
[    1.986536] the code is fine but needs lockdep annotation.
[    1.986538] turning off the locking correctness validator.
[    1.986546] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.986549] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.986564] Workqueue: events_unbound async_run_entry_fn
[    1.986579]  7828d9ae 00000000 85761968 78fa76a8 799d7af4 857619a0 78288323 7938b281
[    1.986591]  7938b2db 7938b2b1 85744898 00000000 00000011 3434e011 0000a605 857443b0
[    1.986603]  857443b0 872e3540 00000000 857619cc 78288faa 00000000 00000001 00000000
[    1.986605] Call Trace:
[    1.986617]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    1.986626]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.986633]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.986639]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.986647]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.986654]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.986661]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.986667]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.986675]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.986682]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.986693]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.986698]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.986704]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.986710]  [<785ec292>] submit_bio+0x65/0xd2
[    1.986717]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.986723]  [<78313fb4>] submit_bh+0xa/0xc
[    1.986729]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.986735]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.986744]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.986751]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.986758]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.986764]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.986771]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.986779]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.986785]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.986792]  [<782bf256>] read_cache_page+0xb/0x12
[    1.986798]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.986804]  [<785f6c00>] read_lba+0xae/0xf9
[    1.986811]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.986817]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.986824]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.986833]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.986840]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.986847]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.986855]  [<7860b627>] ? snprintf+0x15/0x17
[    1.986861]  [<785f62e9>] check_partition+0xe4/0x178
[    1.986867]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.986873]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.986880]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.986887]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.986895]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.986902]  [<78318658>] ? bdget+0xf8/0x105
[    1.986910]  [<788acee0>] ? put_device+0xf/0x11
[    1.986915]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.986924]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.986931]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.986938]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.986969]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.986978]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.986985]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.986999]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.987006]  [<78270649>] kthread+0x8a/0x8f
[    1.987024]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.987035]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.987041]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.109929] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.112752] pmc551: not detected
[    2.113146]  sda: unknown partition table

dmesg-yocto-jaketown-28:20131112153751:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.075164] sd 0:0:0:0: [sda] Write Protect is off
[    2.075172] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    2.077150] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    2.083497] INFO: trying to register non-static key.
[    2.083501] the code is fine but needs lockdep annotation.
[    2.083503] turning off the locking correctness validator.
[    2.083512] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.083515] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.083535] Workqueue: events_unbound async_run_entry_fn
[    2.083550]  7828d9ae 00000000 8577b968 78fa76a8 799d92ec 8577b9a0 78288323 7938b281
[    2.083564]  7938b2db 7938b2b1 8574c518 00000000 00000011 4c342011 0000a905 8574c030
[    2.083577]  8574c030 87198540 00000000 8577b9cc 78288faa 00000000 00000001 00000000
[    2.083580] Call Trace:
[    2.083594]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    2.083603]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.083610]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.083617]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.083626]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.083634]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.083659]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.083666]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.083675]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.083682]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.083695]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.083701]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.083708]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.083714]  [<785ec292>] submit_bio+0x65/0xd2
[    2.083723]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.083730]  [<78313fb4>] submit_bh+0xa/0xc
[    2.083737]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.083744]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.083757]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.083765]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.083773]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.083780]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.083788]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.083796]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.083803]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.083810]  [<782bf256>] read_cache_page+0xb/0x12
[    2.083817]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.083823]  [<785f6c00>] read_lba+0xae/0xf9
[    2.083831]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.083837]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.083844]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.083854]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.083862]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.083870]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.083878]  [<7860b627>] ? snprintf+0x15/0x17
[    2.083884]  [<785f62e9>] check_partition+0xe4/0x178
[    2.083889]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.083896]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.083903]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.083910]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.083917]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.083924]  [<78318658>] ? bdget+0xf8/0x105
[    2.083932]  [<788acee0>] ? put_device+0xf/0x11
[    2.083938]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.083947]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.083955]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.083963]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.083972]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.083979]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.083987]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.083995]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.084002]  [<78270649>] kthread+0x8a/0x8f
[    2.084009]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.084035]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.084042]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.086122]  sda: unknown partition table
[    2.090270] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.216021] SSFDC read-only Flash Translation layer

dmesg-yocto-jaketown-33:20131112153716:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.037376] device id = 24d0
[    2.038583] device id = 25a1
[    2.039777] device id = 2670
[    2.041484] INFO: trying to register non-static key.
[    2.041487] the code is fine but needs lockdep annotation.
[    2.041489] turning off the locking correctness validator.
[    2.041497] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.041500] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.041517] Workqueue: events_unbound async_run_entry_fn
[    2.041531]  7828d9ae 00000000 85775968 78fa76a8 799d92ec 857759a0 78288323 7938b281
[    2.041544]  7938b2db 7938b2b1 8571e618 00000000 00000011 34348011 0000a605 8571e130
[    2.041556]  8571e130 87198540 00000000 857759cc 78288faa 00000000 00000001 00000000
[    2.041559] Call Trace:
[    2.041573]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    2.041584]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.041591]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.041598]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.041608]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.041616]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.041622]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.041629]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.041637]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.041644]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.041656]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.041662]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.041668]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.041674]  [<785ec292>] submit_bio+0x65/0xd2
[    2.041682]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.041688]  [<78313fb4>] submit_bh+0xa/0xc
[    2.041695]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.041702]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.041715]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.041722]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.041729]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.041735]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.041743]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.041751]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.041757]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.041764]  [<782bf256>] read_cache_page+0xb/0x12
[    2.041770]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.041776]  [<785f6c00>] read_lba+0xae/0xf9
[    2.041784]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.041790]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.041797]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.041807]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.041814]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.041822]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.041829]  [<7860b627>] ? snprintf+0x15/0x17
[    2.041835]  [<785f62e9>] check_partition+0xe4/0x178
[    2.041842]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.041848]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.041855]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.041862]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.041869]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.041875]  [<78318658>] ? bdget+0xf8/0x105
[    2.041886]  [<788acee0>] ? put_device+0xf/0x11
[    2.041892]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.041903]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.041913]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.041920]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.041931]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.041939]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.041946]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.041953]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.041960]  [<78270649>] kthread+0x8a/0x8f
[    2.041967]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.041979]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.041986]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.044132]  sda: unknown partition table
[    2.048262] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.191947] Generic platform RAM MTD, (c) 2004 Simtec Electronics

dmesg-yocto-lkp-st01-2:20131112235637:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.284387] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.285429] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.287106] pmc551: not detected
[    2.289354] INFO: trying to register non-static key.
[    2.290019] the code is fine but needs lockdep annotation.
[    2.290019] turning off the locking correctness validator.
[    2.290019] CPU: 1 PID: 95 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.290019] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.290019] Workqueue: events_unbound async_run_entry_fn
[    2.290019]  7828d55b 00000000 8576f968 78fa76a8 799d7af4 8576f9a0 78288323 7938b281
[    2.290019]  7938b2db 7938b2b1 85730598 00000000 00000011 38354011 0000a685 857300b0
[    2.296793]  857300b0 872e3540 00000000 8576f9cc 78288faa 00000000 00000001 00000000
[    2.296793] Call Trace:
[    2.296793]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.296793]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.296793]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.296793]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.296793]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.296793]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.296793]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.296793]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.296793]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.296793]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.296793]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.296793]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.296793]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.296793]  [<785ec292>] submit_bio+0x65/0xd2
[    2.296793]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.296793]  [<78313fb4>] submit_bh+0xa/0xc
[    2.296793]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.296793]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.296793]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.296793]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.296793]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.296793]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.296793]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.296793]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.296793]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.296793]  [<782bf256>] read_cache_page+0xb/0x12
[    2.296793]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.296793]  [<785f6c00>] read_lba+0xae/0xf9
[    2.296793]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.296793]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.296793]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.296793]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.296793]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.296793]  [<7860b627>] ? snprintf+0x15/0x17
[    2.296793]  [<785f62e9>] check_partition+0xe4/0x178
[    2.296793]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.296793]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.296793]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.296793]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.296793]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.296793]  [<78318658>] ? bdget+0xf8/0x105
[    2.296793]  [<788acee0>] ? put_device+0xf/0x11
[    2.296793]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.296793]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.296793]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.296793]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.296793]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.296793]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.296793]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.296793]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.296793]  [<78270649>] kthread+0x8a/0x8f
[    2.296793]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.296793]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.296793]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.358873]  sda: unknown partition table
[    2.361487] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.363143] sd 0:0:0:0: [sda] Attached SCSI disk

dmesg-yocto-lkp-st01-4:20131112235710:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.020956] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    2.022152] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    2.023492] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.026300] INFO: trying to register non-static key.
[    2.027018] the code is fine but needs lockdep annotation.
[    2.027018] turning off the locking correctness validator.
[    2.027018] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.027018] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.027018] Workqueue: events_unbound async_run_entry_fn
[    2.027018]  7828d55b 00000000 8575d968 78fa76a8 799d7af4 8575d9a0 78288323 7938b281
[    2.027018]  7938b2db 7938b2b1 8577d588 00000000 00000011 3836a011 0000a685 8577d0a0
[    2.027018]  8577d0a0 872e3540 00000000 8575d9cc 78288faa 00000000 00000001 00000000
[    2.027018] Call Trace:
[    2.027018]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.027018]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.027018]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.027018]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.038829] e1000 0000:00:03.0: setting latency timer to 64
[    2.027018]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.027018]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.027018]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.027018]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.027018]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.027018]  [<78c6d40a>] ? xpad360_process_packet.isra.8+0x7e/0x2d1
[    2.027018]  [<78c6d349>] ? xpad_set_up_abs+0x26/0x69
[    2.027018]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.027018]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.027018]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.027018]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.027018]  [<785ec292>] submit_bio+0x65/0xd2
[    2.027018]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.027018]  [<78313fb4>] submit_bh+0xa/0xc
[    2.027018]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.027018]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.027018]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.027018]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.027018]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.027018]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.027018]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.027018]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.027018]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.027018]  [<782bf256>] read_cache_page+0xb/0x12
[    2.027018]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.027018]  [<785f6c00>] read_lba+0xae/0xf9
[    2.027018]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.027018]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.027018]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.027018]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.027018]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.027018]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.027018]  [<7860b627>] ? snprintf+0x15/0x17
[    2.027018]  [<785f62e9>] check_partition+0xe4/0x178
[    2.027018]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.027018]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.027018]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.027018]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.027018]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.027018]  [<78318658>] ? bdget+0xf8/0x105
[    2.027018]  [<788acee0>] ? put_device+0xf/0x11
[    2.027018]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.027018]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.027018]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.027018]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.027018]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.027018]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.027018]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.027018]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.027018]  [<78270649>] kthread+0x8a/0x8f
[    2.027018]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.027018]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.027018]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.122036]  sda: unknown partition table
[    2.126078] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.476197] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56

dmesg-yocto-lkp-st01-4:20131113000216:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.984255] device id = 25a1
[    1.984705] device id = 2670
[    1.985294] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    1.986230] INFO: trying to register non-static key.
[    1.986272] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    1.986284] pmc551: not detected
[    1.987486] tsc: Refined TSC clocksource calibration: 2661.334 MHz

dmesg-yocto-lkp-st01-5:20131113000239:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.942106] sd 0:0:0:0: [sda] Write Protect is off
[    2.942108] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    2.944057] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    2.991690] INFO: trying to register non-static key.
[    2.993921] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.992300] the code is fine but needs lockdep annotation.
[    2.992300] turning off the locking correctness validator.
[    2.992300] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.992300] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.992300] Workqueue: events_unbound async_run_entry_fn
[    2.992300]  7828d55b 00000000 85751968 78fa76a8 799d92ec 857519a0 78288323 7938b281
[    2.992300]  7938b2db 7938b2b1 857cf308 00000000 00000011 48358011 0000a885 857cee20
[    2.992300]  857cee20 87198540 00000000 857519cc 78288faa 00000000 00000001 00000000
[    2.992300] Call Trace:
[    2.992300]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.992300]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.992300]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.992300]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.992300]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.992300]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.992300]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.992300]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.992300]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.992300]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.992300]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.992300]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.992300]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.992300]  [<785ec292>] submit_bio+0x65/0xd2
[    2.992300]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.992300]  [<78313fb4>] submit_bh+0xa/0xc
[    3.066116] No valid DiskOnChip devices found
[    3.066141] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.066142] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-lkp-st01-7:20131112232943:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.115046] pmc551: not detected
[    2.143259] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    2.148997] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.151431] INFO: trying to register non-static key.
[    2.152052] the code is fine but needs lockdep annotation.
[    2.152052] turning off the locking correctness validator.
[    2.152052] CPU: 1 PID: 95 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.152052] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.152052] Workqueue: events_unbound async_run_entry_fn
[    2.152052]  7828d55b 00000000 85741968 78fa76a8 799d7af4 857419a0 78288323 7938b281
[    2.152052]  7938b2db 7938b2b1 8576d308 00000000 00000011 3835a011 0000a685 8576ce20
[    2.152052]  8576ce20 872e3540 00000000 857419cc 78288faa 00000000 00000001 00000000
[    2.152052] Call Trace:
[    2.152052]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.152052]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.152052]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.152052]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.152052]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.152052]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.152052]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.152052]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.152052]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.152052]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.152052]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.152052]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.152052]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.152052]  [<785ec292>] submit_bio+0x65/0xd2
[    2.152052]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.152052]  [<78313fb4>] submit_bh+0xa/0xc
[    2.152052]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.152052]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.152052]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.152052]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.152052]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.152052]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.152052]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.152052]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.152052]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.152052]  [<782bf256>] read_cache_page+0xb/0x12
[    2.152052]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.152052]  [<785f6c00>] read_lba+0xae/0xf9
[    2.152052]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.152052]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.152052]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.152052]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.152052]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.152052]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.226273] No valid DiskOnChip devices found
[    2.226306] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.226307] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-lkp-st01-7:20131113000957:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.794116] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.795267] pmc551: not detected
[    2.803865] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.813283] INFO: trying to register non-static key.
[    2.814014] the code is fine but needs lockdep annotation.
[    2.814014] turning off the locking correctness validator.
[    2.814014] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.814014] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.814014] Workqueue: events_unbound async_run_entry_fn
[    2.814014]  7828d55b 00000000 8575d968 78fa76a8 799d7af4 8575d9a0 78288323 7938b281
[    2.814014]  7938b2db 7938b2b1 8574b508 00000000 00000011 38358011 0000a685 8574b020
[    2.814014]  8574b020 872e3540 00000000 8575d9cc 78288faa 00000000 00000001 00000000
[    2.814014] Call Trace:
[    2.814014]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.814014]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.814014]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.814014]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.814014]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.814014]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.814014]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.814014]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.814014]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.814014]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.814014]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.814014]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.814014]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.814014]  [<785ec292>] submit_bio+0x65/0xd2
[    2.814014]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.814014]  [<78313fb4>] submit_bh+0xa/0xc
[    2.814014]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.814014]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.814014]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.814014]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.814014]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.814014]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.814014]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.814014]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.814014]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.814014]  [<782bf256>] read_cache_page+0xb/0x12
[    2.814014]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.814014]  [<785f6c00>] read_lba+0xae/0xf9
[    2.814014]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.814014]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.814014]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.814014]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.814014]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.814014]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.814014]  [<7860b627>] ? snprintf+0x15/0x17
[    2.814014]  [<785f62e9>] check_partition+0xe4/0x178
[    2.814014]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.814014]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.814014]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.814014]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.921615] No valid DiskOnChip devices found
[    2.921645] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.921646] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-lkp-tt02-10:20131112070302:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.745826] sd 0:0:0:0: [sda] Write Protect is off
[    1.745829] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    1.747827] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.755159] INFO: trying to register non-static key.
[    1.755160] the code is fine but needs lockdep annotation.
[    1.755160] turning off the locking correctness validator.
[    1.755164] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.755166] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.755173] Workqueue: events_unbound async_run_entry_fn
[    1.755178]  7828d9ae 00000000 8578d968 78fa76a8 799d92ec 8578d9a0 78288323 7938b281
[    1.755182]  7938b2db 7938b2b1 85745588 00000000 00000011 3834e011 0000a685 857450a0
[    1.755186]  857450a0 87198540 00000000 8578d9cc 78288faa 00000000 00000001 00000000
[    1.755187] Call Trace:
[    1.755192]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    1.755197]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.755199]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.755202]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.755206]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.755209]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.755211]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.755213]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.755216]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.755219]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.755223]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.755225]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.755228]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.755230]  [<785ec292>] submit_bio+0x65/0xd2
[    1.755234]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.755236]  [<78313fb4>] submit_bh+0xa/0xc
[    1.755239]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.755241]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.755246]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.755248]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.755250]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.755253]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.755255]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.755258]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.755260]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.755263]  [<782bf256>] read_cache_page+0xb/0x12
[    1.755265]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.755268]  [<785f6c00>] read_lba+0xae/0xf9
[    1.755271]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.755273]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.755278]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.755280]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.755283]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.755285]  [<7860b627>] ? snprintf+0x15/0x17
[    1.755288]  [<785f62e9>] check_partition+0xe4/0x178
[    1.755290]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.755292]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.755294]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.755297]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.755299]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.755302]  [<78318658>] ? bdget+0xf8/0x105
[    1.755306]  [<788acee0>] ? put_device+0xf/0x11
[    1.755308]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.755312]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.755316]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.755318]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.755322]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.755325]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.755328]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.755330]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.755333]  [<78270649>] kthread+0x8a/0x8f
[    1.755335]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.755339]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.755341]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.757810]  sda: unknown partition table
[    1.762847] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.937120] device id = 2440

dmesg-yocto-lkp-tt02-12:20131112070207:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.327618] pmc551: not detected
[    1.330079] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.344630] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    1.351315] INFO: trying to register non-static key.
[    1.351316] the code is fine but needs lockdep annotation.
[    1.351317] turning off the locking correctness validator.
[    1.351320] CPU: 0 PID: 95 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.351321] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.351329] Workqueue: events_unbound async_run_entry_fn
[    1.351334]  7828d9ae 00000000 85753968 78fa76a8 799d92ec 857539a0 78288323 7938b281
[    1.351338]  7938b2db 7938b2b1 85729508 00000000 00000011 3834e011 0000a685 85729020
[    1.351342]  85729020 87198540 00000000 857539cc 78288faa 00000000 00000001 00000000
[    1.351343] Call Trace:
[    1.351349]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    1.351353]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.351355]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.351358]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.351362]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.351365]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.351367]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.351370]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.351373]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.351375]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.351380]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.351382]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.351385]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.351387]  [<785ec292>] submit_bio+0x65/0xd2
[    1.351391]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.351393]  [<78313fb4>] submit_bh+0xa/0xc
[    1.351395]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.351398]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.351402]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.351405]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.351407]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.351410]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.351412]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.351415]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.351417]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.351420]  [<782bf256>] read_cache_page+0xb/0x12
[    1.351422]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.351424]  [<785f6c00>] read_lba+0xae/0xf9
[    1.351428]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.351430]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.351433]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.351437]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.351439]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.351442]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.351444]  [<7860b627>] ? snprintf+0x15/0x17
[    1.351447]  [<785f62e9>] check_partition+0xe4/0x178
[    1.351449]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.351451]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.351454]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.351456]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.351458]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.351461]  [<78318658>] ? bdget+0xf8/0x105
[    1.351465]  [<788acee0>] ? put_device+0xf/0x11
[    1.351467]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.351472]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.351475]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.351478]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.351482]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.351485]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.351487]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.351490]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.351493]  [<78270649>] kthread+0x8a/0x8f
[    1.351495]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.351499]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.351502]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.353044]  sda: unknown partition table
[    1.357097] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.561625] No valid DiskOnChip devices found

dmesg-yocto-lkp-tt02-12:20131112071421:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.459685] pmc551: not detected
[    1.488036] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.493161] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    1.507270] INFO: trying to register non-static key.
[    1.508021] the code is fine but needs lockdep annotation.
[    1.508021] turning off the locking correctness validator.
[    1.508021] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.508021] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.508021] Workqueue: events_unbound async_run_entry_fn
[    1.508021]  7828d55b 00000000 8577f968 78fa76a8 799d92ec 8577f9a0 78288323 7938b281
[    1.508021]  7938b2db 7938b2b1 857a3208 00000000 00000011 4035a011 0000a785 857a2d20
[    1.508021]  857a2d20 87198540 00000000 8577f9cc 78288faa 00000000 00000001 00000000
[    1.508021] Call Trace:
[    1.508021]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.508021]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.508021]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.508021]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.508021]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.508021]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.508021]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.508021]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.508021]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.508021]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.555001] No valid DiskOnChip devices found
[    1.555042] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    1.555044] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-lkp-tt02-14:20131112070008:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.518551] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    1.520067] pmc551: not detected
[    1.548245] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.554466] INFO: trying to register non-static key.
[    1.555042] the code is fine but needs lockdep annotation.
[    1.555042] turning off the locking correctness validator.
[    1.555042] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.555042] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.555042] Workqueue: events_unbound async_run_entry_fn
[    1.555042]  7828d55b 00000000 85739968 78fa76a8 799d92ec 857399a0 78288323 7938b281
[    1.555042]  7938b2db 7938b2b1 8573d588 00000000 00000011 38352011 0000a685 8573d0a0
[    1.555042]  8573d0a0 87198540 00000000 857399cc 78288faa
[    1.566576] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
 00000000 00000001 00000000
[    1.555042] Call Trace:
[    1.555042]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.555042]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.555042]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.555042]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.555042]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.555042]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.555042]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.555042]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.555042]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.555042]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.555042]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.555042]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.555042]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.555042]  [<785ec292>] submit_bio+0x65/0xd2
[    1.555042]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.555042]  [<78313fb4>] submit_bh+0xa/0xc
[    1.555042]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.555042]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.555042]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.555042]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.555042]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.555042]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.555042]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.630233] No valid DiskOnChip devices found
[    1.630259] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    1.630261] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-lkp-tt02-15:20131112065446:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.519070] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    1.522064] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.527124] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.528315] INFO: trying to register non-static key.
[    1.529025] the code is fine but needs lockdep annotation.
[    1.529025] turning off the locking correctness validator.
[    1.529025] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.529025] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.529025] Workqueue: events_unbound async_run_entry_fn
[    1.529025]  7828d55b 00000000 8572d968 78fa76a8 799d92ec 8572d9a0 78288323 7938b281
[    1.529025]  7938b2db 7938b2b1 854ee598 00000000 00000011 38342011 0000a685 854ee0b0
[    1.529025]  854ee0b0 87198540 00000000 8572d9cc 78288faa 00000000 00000001 00000000
[    1.529025] Call Trace:
[    1.529025]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.529025]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.529025]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.529025]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.529025]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.529025]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.529025]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.529025]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.529025]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.529025]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.529025]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.529025]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.529025]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.529025]  [<785ec292>] submit_bio+0x65/0xd2
[    1.529025]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.529025]  [<78313fb4>] submit_bh+0xa/0xc
[    1.529025]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.529025]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.529025]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.529025]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.529025]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.529025]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.529025]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.529025]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.529025]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.529025]  [<782bf256>] read_cache_page+0xb/0x12
[    1.529025]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.529025]  [<785f6c00>] read_lba+0xae/0xf9
[    1.529025]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.529025]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.529025]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.529025]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.529025]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.529025]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.529025]  [<7860b627>] ? snprintf+0x15/0x17
[    1.529025]  [<785f62e9>] check_partition+0xe4/0x178
[    1.529025]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.529025]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.529025]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.529025]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.529025]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.529025]  [<78318658>] ? bdget+0xf8/0x105
[    1.529025]  [<788acee0>] ? put_device+0xf/0x11
[    1.529025]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.529025]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.529025]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.529025]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.529025]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.529025]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.529025]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.529025]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.529025]  [<78270649>] kthread+0x8a/0x8f
[    1.529025]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.529025]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.529025]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.649420] SSFDC read-only Flash Translation layer
[    1.650123]  sda: unknown partition table
[    1.656049] device id = 2440

dmesg-yocto-lkp-tt02-15:20131112070243:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.699440] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    1.699447] pmc551: not detected
[    1.717117] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    1.720476] INFO: trying to register non-static key.
[    1.721127] the code is fine but needs lockdep annotation.
[    1.721127] turning off the locking correctness validator.
[    1.721127] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.721127] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.721127] Workqueue: events_unbound async_run_entry_fn
[    1.721127]  7828d55b 00000000 8578b968 78fa76a8 799db38c 8578b9a0 78288323 7938b281
[    1.721127]  7938b2db 7938b2b1 85728698 00000000 00000011 3835a011 0000a685 857281b0
[    1.721127]  857281b0 872e3590 00000000 8578b9cc 78288faa 00000000 00000001 00000000
[    1.721127] Call Trace:
[    1.721127]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.721127]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.721127]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.721127]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.756665] No valid DiskOnChip devices found
[    1.756700] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    1.756701] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-lkp-tt02-17:20131112070126:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.579578] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    1.581263] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    1.582953] pmc551: not detected
[    1.585132] INFO: trying to register non-static key.
[    1.586026] the code is fine but needs lockdep annotation.
[    1.586026] turning off the locking correctness validator.
[    1.586026] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.586026] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.586026] Workqueue: events_unbound async_run_entry_fn
[    1.591768]  7828d55b 00000000 85767968 78fa76a8 799d7af4 857679a0 78288323 7938b281
[    1.591768]  7938b2db 7938b2b1 8573a818 00000000 00000011 3434a011 0000a605 8573a330
[    1.591768]  8573a330 872e3540 00000000 857679cc 78288faa 00000000 00000001 00000000
[    1.591768] Call Trace:
[    1.591768]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.591768]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.591768]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.591768]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.591768]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.591768]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.591768]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.591768]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.591768]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.591768]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.591768]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.591768]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.591768]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.591768]  [<785ec292>] submit_bio+0x65/0xd2
[    1.591768]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.591768]  [<78313fb4>] submit_bh+0xa/0xc
[    1.591768]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.591768]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.591768]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.591768]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.591768]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.591768]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.591768]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.591768]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.591768]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.591768]  [<782bf256>] read_cache_page+0xb/0x12
[    1.591768]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.591768]  [<785f6c00>] read_lba+0xae/0xf9
[    1.591768]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.591768]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.591768]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.591768]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.591768]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.591768]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.591768]  [<7860b627>] ? snprintf+0x15/0x17
[    1.591768]  [<785f62e9>] check_partition+0xe4/0x178
[    1.591768]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.591768]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.591768]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.591768]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.591768]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.591768]  [<78318658>] ? bdget+0xf8/0x105
[    1.591768]  [<788acee0>] ? put_device+0xf/0x11
[    1.591768]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.591768]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.591768]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.591768]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.591768]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.591768]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.591768]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.591768]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.591768]  [<78270649>] kthread+0x8a/0x8f
[    1.591768]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.591768]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.591768]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.672520] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    1.674800]  sda: unknown partition table
[    1.680700] sd 0:0:0:0: [sda] Attached SCSI disk

dmesg-yocto-lkp-tt02-1:20131112075410:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.021221] libphy: Fixed MDIO Bus: probed
[    2.023220] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    2.024709] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.18 (Sept 01, 2013)
[    2.039453] INFO: trying to register non-static key.
[    2.040099] the code is fine but needs lockdep annotation.
[    2.040099] turning off the locking correctness validator.
[    2.040099] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.040099] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.040099] Workqueue: events_unbound async_run_entry_fn
[    2.040099]  7828d55b 00000000 85769968 78fa76a8 799d92ec 857699a0 78288323
[    2.048107] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50

dmesg-yocto-lkp-tt02-20:20131112074645:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.612060] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.615558] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.617998] SSFDC read-only Flash Translation layer
[    1.618293] INFO: trying to register non-static key.
[    1.618295] the code is fine but needs lockdep annotation.
[    1.618296] turning off the locking correctness validator.
[    1.618299] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.618301] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.618308] Workqueue: events_unbound async_run_entry_fn
[    1.618313]  7828d9ae 00000000 8578d968 78fa76a8 799d92ec 8578d9a0 78288323 7938b281
[    1.618317]  7938b2db 7938b2b1 85744898 00000000 00000011 34340011 0000a605 857443b0
[    1.618321]  857443b0 87198540 00000000 8578d9cc 78288faa 00000000 00000001 00000000
[    1.618322] Call Trace:
[    1.618328]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    1.618332]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.618334]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.618337]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.618340]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.618343]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.618346]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.618348]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.618351]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.618353]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.618363]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.618365]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.618368]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.618370]  [<785ec292>] submit_bio+0x65/0xd2
[    1.618374]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.618376]  [<78313fb4>] submit_bh+0xa/0xc
[    1.618378]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.618381]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.618385]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.618388]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.618390]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.618393]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.618395]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.618417]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.618420]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.618422]  [<782bf256>] read_cache_page+0xb/0x12
[    1.618424]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.618427]  [<785f6c00>] read_lba+0xae/0xf9
[    1.618430]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.618432]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.618435]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.618439]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.618442]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.618445]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.618447]  [<7860b627>] ? snprintf+0x15/0x17
[    1.618450]  [<785f62e9>] check_partition+0xe4/0x178
[    1.618452]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.618454]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.618457]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.618459]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.618462]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.618464]  [<78318658>] ? bdget+0xf8/0x105
[    1.618468]  [<788acee0>] ? put_device+0xf/0x11
[    1.618471]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.618475]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.618478]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.618481]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.618485]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.618488]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.618490]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.618493]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.618495]  [<78270649>] kthread+0x8a/0x8f
[    1.618498]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.618502]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.618504]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.620052]  sda: unknown partition table
[    1.624088] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.753166] device id = 2440

dmesg-yocto-lkp-tt02-24:20131112070331:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.837061] sd 0:0:0:0: [sda] Write Protect is off
[    1.837064] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    1.839059] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.846276] INFO: trying to register non-static key.
[    1.847022] the code is fine but needs lockdep annotation.
[    1.847022] turning off the locking correctness validator.
[    1.847022] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.847022] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.847022] Workqueue: events_unbound async_run_entry_fn
[    1.847022]  7828d55b 00000000 85733968 78fa76a8 799d92ec 857339a0 78288323 7938b281
[    1.847022]  7938b2db 7938b2b1 857bf308 00000000 00000011 4834a011

dmesg-yocto-lkp-tt02-2:20131112070957:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.648692] pmc551: not detected
[    1.650713] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.657828] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    1.658430] INFO: trying to register non-static key.
[    1.658431] the code is fine but needs lockdep annotation.
[    1.658431] turning off the locking correctness validator.
[    1.658435] CPU: 0 PID: 95 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.658436] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.658448] Workqueue: events_unbound async_run_entry_fn
[    1.658535]  7828d9ae 00000000 85777968 78fa76a8 799d92ec 857779a0 78288323 7938b281
[    1.658539]  7938b2db 7938b2b1 85779488 00000000 00000011 3c356011 0000a705 85778fa0
[    1.658543]  85778fa0 87198540 00000000 857779cc 78288faa 00000000 00000001 00000000
[    1.658544] Call Trace:
[    1.658550]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    1.658556]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.658558]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.658561]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.658566]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.658568]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.658571]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.658573]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.658576]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.658579]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.658585]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.658587]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.658589]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.658592]  [<785ec292>] submit_bio+0x65/0xd2
[    1.658596]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.658598]  [<78313fb4>] submit_bh+0xa/0xc
[    1.658600]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.658603]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.658608]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.658611]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.658613]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.658616]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.658618]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.658621]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.658623]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.658626]  [<782bf256>] read_cache_page+0xb/0x12
[    1.658628]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.658630]  [<785f6c00>] read_lba+0xae/0xf9
[    1.658634]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.658637]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.658640]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.658645]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.658647]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.658650]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.658653]  [<7860b627>] ? snprintf+0x15/0x17
[    1.658655]  [<785f62e9>] check_partition+0xe4/0x178
[    1.658657]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.658659]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.658662]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.658664]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.658667]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.658669]  [<78318658>] ? bdget+0xf8/0x105
[    1.658674]  [<788acee0>] ? put_device+0xf/0x11
[    1.658676]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.658681]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.658685]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.658688]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.658693]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.658695]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.658698]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.658701]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.658703]  [<78270649>] kthread+0x8a/0x8f
[    1.658706]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.658710]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.658713]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.660045]  sda: unknown partition table
[    1.664091] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.779345] No valid DiskOnChip devices found

dmesg-yocto-lkp-tt02-9:20131112073928:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.614063] sd 0:0:0:0: [sda] Write Protect is off
[    1.614065] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    1.616082] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.622343] INFO: trying to register non-static key.
[    1.622344] the code is fine but needs lockdep annotation.
[    1.622345] turning off the locking correctness validator.
[    1.622348] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.622349] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.622357] Workqueue: events_unbound async_run_entry_fn
[    1.622362]  7828d9ae 00000000 85791968 78fa76a8 799d92ec 857919a0 78288323 7938b281
[    1.622367]  7938b2db 7938b2b1 8571d388 00000000 00000011 34342011 0000a605 8571cea0
[    1.622370]  8571cea0 87198540 00000000 857919cc 78288faa 00000000 00000001 00000000
[    1.622371] Call Trace:
[    1.622377]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    1.622381]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.622383]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.622386]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.622390]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.622392]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.622395]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.622397]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.622400]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.622402]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.622407]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.622410]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.622412]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.622414]  [<785ec292>] submit_bio+0x65/0xd2
[    1.622418]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.622420]  [<78313fb4>] submit_bh+0xa/0xc
[    1.622423]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.622425]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.622429]  [<782c78b6>] ? __pagevec_lru_add+0xf/0x11
[    1.622432]  [<782c78fd>] ? __lru_cache_add+0x45/0x5b
[    1.622434]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.622437]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.622441]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.622444]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.622446]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.622449]  [<782bf256>] read_cache_page+0xb/0x12
[    1.622451]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.622453]  [<785f6c00>] read_lba+0xae/0xf9
[    1.622457]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.622459]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.622461]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.622466]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.622468]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.622471]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.622473]  [<7860b627>] ? snprintf+0x15/0x17
[    1.622476]  [<785f62e9>] check_partition+0xe4/0x178
[    1.622478]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.622480]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.622483]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.622485]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.622488]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.622490]  [<78318658>] ? bdget+0xf8/0x105
[    1.622494]  [<788acee0>] ? put_device+0xf/0x11
[    1.622497]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.622501]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.622504]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.622507]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.622511]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.622514]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.622516]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.622519]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.622522]  [<78270649>] kthread+0x8a/0x8f
[    1.622524]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.622528]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.622531]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.624046]  sda: unknown partition table
[    1.628109] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.759869] SSFDC read-only Flash Translation layer

dmesg-yocto-snb-11:20131112160152:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.723722] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    1.725245] pmc551: not detected
[    1.729132] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    1.729260] INFO: trying to register non-static key.
[    1.729261] the code is fine but needs lockdep annotation.
[    1.729262] turning off the locking correctness validator.
[    1.729267] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.729268] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.729278] Workqueue: events_unbound async_run_entry_fn
[    1.729284]  7828d9ae 00000000 8578d968 78fa76a8 799d7af4 8578d9a0 78288323 7938b281
[    1.729290]  7938b2db 7938b2b1 8574f688 00000000 00000011 3c356011 0000a705 8574f1a0
[    1.729295]  8574f1a0 872e3540 00000000 8578d9cc 78288faa 00000000 00000001 00000000
[    1.729296] Call Trace:
[    1.729303]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    1.729308]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.729311]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.729314]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.729319]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.729322]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.729325]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.729328]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.729332]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.729335]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.729340]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.729343]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.729346]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.729349]  [<785ec292>] submit_bio+0x65/0xd2
[    1.729353]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.729355]  [<78313fb4>] submit_bh+0xa/0xc
[    1.729358]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.729362]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.729367]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.729371]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.729374]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.729377]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.729381]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.729385]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.729388]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.729391]  [<782bf256>] read_cache_page+0xb/0x12
[    1.729394]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.729397]  [<785f6c00>] read_lba+0xae/0xf9
[    1.729400]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.729403]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.729406]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.729410]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.729413]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.729417]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.729420]  [<7860b627>] ? snprintf+0x15/0x17
[    1.729423]  [<785f62e9>] check_partition+0xe4/0x178
[    1.729425]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.729428]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.729432]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.729434]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.729438]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.729441]  [<78318658>] ? bdget+0xf8/0x105
[    1.729445]  [<788acee0>] ? put_device+0xf/0x11
[    1.729448]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.729453]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.729457]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.729461]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.729466]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.729469]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.729473]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.729477]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.729480]  [<78270649>] kthread+0x8a/0x8f
[    1.729483]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.729488]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.729491]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.799059]  sda: unknown partition table
[    1.804111] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.835566] No valid DiskOnChip devices found

dmesg-yocto-stoakley-1:20131112154134:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.245041] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.246896] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    1.247918] pmc551: not detected
[    1.252205] INFO: trying to register non-static key.
[    1.252336] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    1.253012] the code is fine but needs lockdep annotation.
[    1.253012] turning off the locking correctness validator.
[    1.253012] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.253012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.253012] Workqueue: events_unbound async_run_entry_fn
[    1.253012]  7828d55b 00000000 78097968 78fa76a8 799d7af4 780979a0 78288323 7938b281
[    1.253012]  7938b2db 7938b2b1 857c0618 00000000 00000011 4434c011 0000a805 857c0130
[    1.253012]  857c0130 872e3540 00000000 780979cc 78288faa 00000000 00000001 00000000
[    1.253012] Call Trace:
[    1.253012]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.253012]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.253012]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.253012]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.253012]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.253012]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.253012]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.253012]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.253012]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.253012]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.253012]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.253012]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.253012]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.253012]  [<785ec292>] submit_bio+0x65/0xd2
[    1.253012]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.253012]  [<78313fb4>] submit_bh+0xa/0xc
[    1.253012]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.253012]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.253012]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.253012]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.253012]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.253012]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.253012]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.253012]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.253012]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.253012]  [<782bf256>] read_cache_page+0xb/0x12
[    1.253012]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.253012]  [<785f6c00>] read_lba+0xae/0xf9
[    1.253012]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.253012]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.253012]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.253012]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.253012]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.253012]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.253012]  [<7860b627>] ? snprintf+0x15/0x17
[    1.253012]  [<785f62e9>] check_partition+0xe4/0x178
[    1.253012]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.253012]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.253012]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.253012]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.253012]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.253012]  [<78318658>] ? bdget+0xf8/0x105
[    1.290423] No valid DiskOnChip devices found
[    1.290443] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    1.290444] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-stoakley-1:20131112155521:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.083639] bits in page size: 9
[    2.084100] bits in OOB size: 4
[    2.084526] flash size with OOB: 135168 KiB
[    2.085421] INFO: trying to register non-static key.
[    2.085422] the code is fine but needs lockdep annotation.
[    2.085423] turning off the locking correctness validator.
[    2.085426] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.085426] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.085433] Workqueue: events_unbound async_run_entry_fn
[    2.085437]  7828d9ae 00000000 857ab968 78fa76a8 799d92ec 857ab9a0 78288323 7938b281
[    2.085440]  7938b2db 7938b2b1 8577e618 00000000 00000011 38360011 0000a685 8577e130
[    2.085443]  8577e130 87198540 00000000 857ab9cc 78288faa 00000000 00000001 00000000
[    2.085444] Call Trace:
[    2.085448]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    2.085452]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.085453]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.085455]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.085459]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.085461]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.085463]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.085464]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.085467]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.085468]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.085472]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.085474]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.085476]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.085477]  [<785ec292>] submit_bio+0x65/0xd2
[    2.085480]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.085482]  [<78313fb4>] submit_bh+0xa/0xc
[    2.085484]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.085485]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.085489]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.085491]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.085493]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.085495]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.085497]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.085499]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.085501]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.085502]  [<782bf256>] read_cache_page+0xb/0x12
[    2.085504]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.085506]  [<785f6c00>] read_lba+0xae/0xf9
[    2.085508]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.085510]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.085512]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.085515]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.085517]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.085519]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.085521]  [<7860b627>] ? snprintf+0x15/0x17
[    2.085523]  [<785f62e9>] check_partition+0xe4/0x178
[    2.085524]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.085526]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.085528]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.085530]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.085532]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.085533]  [<78318658>] ? bdget+0xf8/0x105
[    2.085537]  [<788acee0>] ? put_device+0xf/0x11
[    2.085539]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.085542]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.085545]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.085547]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.085550]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.085552]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.085554]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.085555]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.085557]  [<78270649>] kthread+0x8a/0x8f
[    2.085559]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.085562]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.085564]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.087132]  sda: unknown partition table
[    2.091066] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.186259] page address bytes: 4

dmesg-yocto-stoakley-2:20131112155655:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.050041] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    2.052137] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.053186] pmc551: not detected
[    2.069221] INFO: trying to register non-static key.
[    2.069904] the code is fine but needs lockdep annotation.
[    2.069994] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.070014] turning off the locking correctness validator.
[    2.070014] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.070014] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.070014] Workqueue: events_unbound async_run_entry_fn
[    2.070014]  7828d55b 00000000 85735968 78fa76a8 799d7af4 857359a0 78288323 7938b281
[    2.070014]  7938b2db 7938b2b1 85774618 00000000 00000011 38358011 0000a685 85774130
[    2.070014]  85774130 872e3540 00000000 857359cc 78288faa 00000000 00000001 00000000
[    2.070014] Call Trace:
[    2.070014]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.070014]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.070014]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.070014]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.070014]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.070014]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.070014]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.070014]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.070014]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.070014]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.070014]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.070014]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.070014]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.070014]  [<785ec292>] submit_bio+0x65/0xd2
[    2.070014]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.070014]  [<78313fb4>] submit_bh+0xa/0xc
[    2.070014]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.070014]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.070014]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.070014]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.070014]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.070014]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.070014]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.070014]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.070014]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.070014]  [<782bf256>] read_cache_page+0xb/0x12
[    2.070014]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.070014]  [<785f6c00>] read_lba+0xae/0xf9
[    2.070014]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.070014]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.070014]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.070014]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.070014]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.070014]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.070014]  [<7860b627>] ? snprintf+0x15/0x17
[    2.070014]  [<785f62e9>] check_partition+0xe4/0x178
[    2.070014]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.070014]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.070014]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.070014]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.070014]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.070014]  [<78318658>] ? bdget+0xf8/0x105
[    2.070014]  [<788acee0>] ? put_device+0xf/0x11
[    2.070014]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.070014]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.070014]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.070014]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.070014]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.070014]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.139077] No valid DiskOnChip devices found
[    2.139097] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.139098] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-stoakley-2:20131112160141:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.367968] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    1.368870] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    1.369906] pmc551: not detected
[    1.374248] INFO: trying to register non-static key.
[    1.374982] the code is fine but needs lockdep annotation.
[    1.375015] turning off the locking correctness validator.
[    1.376172] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    1.375015] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.375015] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.375015] Workqueue: events_unbound async_run_entry_fn
[    1.375015]  7828d55b 00000000 85763968 78fa76a8 799d92ec 857639a0 78288323 7938b281
[    1.375015]  7938b2db 7938b2b1 8576e618 00000000 00000011 3434c011 0000a605 8576e130
[    1.375015]  8576e130 87198540 00000000 857639cc 78288faa 00000000 00000001 00000000
[    1.375015] Call Trace:
[    1.375015]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.375015]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.375015]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.375015]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.375015]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.375015]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.375015]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.375015]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.375015]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.375015]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.375015]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.375015]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.375015]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.375015]  [<785ec292>] submit_bio+0x65/0xd2
[    1.375015]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.375015]  [<78313fb4>] submit_bh+0xa/0xc
[    1.375015]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.375015]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.375015]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.375015]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.375015]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.375015]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.375015]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.414254] No valid DiskOnChip devices found
[    1.414274] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    1.414275] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-stoakley-4:20131112154720:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.390479] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.391473] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.394061] e1000 0000:00:03.0: setting latency timer to 64
[    1.400222] INFO: trying to register non-static key.
[    1.400903] the code is fine but needs lockdep annotation.
[    1.401013] turning off the locking correctness validator.
[    1.401013] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.401013] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.401013] Workqueue: events_unbound async_run_entry_fn
[    1.401013]  7828d55b 00000000 8577d968 78fa76a8 799d7af4 8577d9a0 78288323 7938b281
[    1.401013]  7938b2db 7938b2b1 85774618 00000000 00000011 34364011 0000a605 85774130
[    1.401013]  85774130 872e3540 00000000 8577d9cc 78288faa 00000000 00000001 00000000
[    1.401013] Call Trace:
[    1.401013]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.401013]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.401013]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.401013]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.401013]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.401013]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.401013]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.401013]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.401013]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.401013]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.401013]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.401013]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.401013]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.401013]  [<785ec292>] submit_bio+0x65/0xd2
[    1.401013]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.401013]  [<78313fb4>] submit_bh+0xa/0xc
[    1.401013]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.401013]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.401013]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.401013]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.401013]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.401013]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.401013]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.401013]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.401013]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.401013]  [<782bf256>] read_cache_page+0xb/0x12
[    1.401013]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.401013]  [<785f6c00>] read_lba+0xae/0xf9
[    1.401013]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.401013]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.401013]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.401013]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.401013]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.401013]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.401013]  [<7860b627>] ? snprintf+0x15/0x17
[    1.401013]  [<785f62e9>] check_partition+0xe4/0x178
[    1.401013]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.401013]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.401013]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.401013]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.401013]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.401013]  [<78318658>] ? bdget+0xf8/0x105
[    1.401013]  [<788acee0>] ? put_device+0xf/0x11
[    1.401013]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.401013]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.401013]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.401013]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.401013]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.401013]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.401013]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.401013]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.401013]  [<78270649>] kthread+0x8a/0x8f
[    1.401013]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.401013]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.401013]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.449032]  sda: unknown partition table
[    1.454086] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.676061] tsc: Refined TSC clocksource calibration: 2833.332 MHz

dmesg-yocto-stoakley-5:20131112160743:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.710596] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    1.711503] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    1.712531] pmc551: not detected
[    1.715256] INFO: trying to register non-static key.
[    1.716014] the code is fine but needs lockdep annotation.
[    1.716014] turning off the locking correctness validator.
[    1.716965] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    1.716014] CPU: 1 PID: 95 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.716014] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.716014] Workqueue: events_unbound async_run_entry_fn
[    1.716014]  7828d55b 00000000 8576b968 78fa76a8 799d7af4 8576b9a0 78288323 7938b281
[    1.716014]  7938b2db 7938b2b1 8576c598 00000000 00000011 38352011 0000a685 8576c0b0
[    1.716014]  8576c0b0 872e3540 00000000 8576b9cc 78288faa 00000000 00000001 00000000
[    1.716014] Call Trace:
[    1.716014]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.716014]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.716014]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.716014]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.716014]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.716014]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.716014]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.716014]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.716014]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.716014]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.716014]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.716014]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.716014]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.716014]  [<785ec292>] submit_bio+0x65/0xd2
[    1.716014]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.716014]  [<78313fb4>] submit_bh+0xa/0xc
[    1.716014]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.716014]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.716014]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.716014]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.716014]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.716014]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.755065] No valid DiskOnChip devices found
[    1.755084] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    1.755085] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-stoakley-6:20131112160745:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.013868] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    2.014895] pmc551: not detected
[    2.034695] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.063236] INFO: trying to register non-static key.
[    2.063916] the code is fine but needs lockdep annotation.
[    2.064011] turning off the locking correctness validator.
[    2.064011] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.064011] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.064011] Workqueue: events_unbound async_run_entry_fn
[    2.064011]  7828d55b 00000000 85743968 78fa76a8 799d7af4 857439a0 78288323 7938b281
[    2.064011]  7938b2db 7938b2b1 856da598 00000000 00000011 38356011 0000a685 856da0b0
[    2.064011]  856da0b0 872e3540 00000000 857439cc 78288faa 00000000 00000001 00000000
[    2.064011] Call Trace:
[    2.064011]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.064011]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.064011]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.064011]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.064011]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.064011]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.064011]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.064011]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.064011]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.087975] No valid DiskOnChip devices found
[    2.087996] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.087997] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-waimea-3:20131113005403:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    3.166823] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    3.168369] pmc551: not detected
[    3.170782] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    3.200173] INFO: trying to register non-static key.
[    3.201015] the code is fine but needs lockdep annotation.
[    3.201015] turning off the locking correctness validator.
[    3.201015] CPU: 0 PID: 95 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    3.201015] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.201015] Workqueue: events_unbound async_run_entry_fn
[    3.201015]  7828d55b 00000000 8574d968 78fa76a8 799d5d1c 8574d9a0 78288323 7938b281
[    3.201015]  7938b2db 7938b2b1 85724618 00000000 00000011 34362011 0000a605 85724130
[    3.201015]  85724130 871985c4 00000000 8574d9cc 78288faa 00000000 00000001 00000000
[    3.201015] Call Trace:
[    3.201015]  [<7828d55b>] ? console_unlock+0x353/0x380
[    3.201015]  [<78fa76a8>] dump_stack+0x48/0x60
[    3.201015]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    3.201015]  [<78288faa>] lock_acquire+0x71/0x9a
[    3.201015]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.201015]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    3.201015]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.201015]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    3.201015]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    3.201015]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.201015]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    3.201015]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.201015]  [<785ec187>] generic_make_request+0xf/0xb5
[    3.201015]  [<785ec292>] submit_bio+0x65/0xd2
[    3.201015]  [<78313f8d>] _submit_bh+0x226/0x243
[    3.201015]  [<78313fb4>] submit_bh+0xa/0xc
[    3.201015]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    3.201015]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    3.201015]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    3.201015]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.201015]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.201015]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    3.201015]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    3.201015]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    3.201015]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.201015]  [<782bf256>] read_cache_page+0xb/0x12
[    3.201015]  [<785f61b2>] read_dev_sector+0x26/0x61
[    3.201015]  [<785f6c00>] read_lba+0xae/0xf9
[    3.201015]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    3.201015]  [<785f7130>] efi_partition+0x17a/0x9c0
[    3.201015]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    3.201015]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.201015]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.201015]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    3.201015]  [<7860b627>] ? snprintf+0x15/0x17
[    3.271998] No valid DiskOnChip devices found
[    3.272041] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.272042] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-waimea-6:20131113000253:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    3.146854] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.148223] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.
[    3.149816] pmc551: not detected
[    3.155174] INFO: trying to register non-static key.
[    3.156026] the code is fine but needs lockdep annotation.
[    3.156026] turning off the locking correctness validator.
[    3.156026] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    3.156026] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.156026] Workqueue: events_unbound async_run_entry_fn
[    3.156026]  7828d55b 00000000 85743968 78fa76a8 799d92ec 857439a0 78288323 7938b281
[    3.156026]  7938b2db 7938b2b1 85738718 00000000 00000011 4835a011 0000a885 85738230
[    3.156026]  85738230 87198540 00000000 857439cc 78288faa 00000000 00000001 00000000
[    3.167518] Call Trace:
[    3.167518]  [<7828d55b>] ? console_unlock+0x353/0x380
[    3.167518]  [<78fa76a8>] dump_stack+0x48/0x60
[    3.167518]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    3.167518]  [<78288faa>] lock_acquire+0x71/0x9a
[    3.167518]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.167518]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    3.167518]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.167518]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    3.167518]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    3.167518]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.167518]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    3.167518]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.167518]  [<785ec187>] generic_make_request+0xf/0xb5
[    3.167518]  [<785ec292>] submit_bio+0x65/0xd2
[    3.167518]  [<78313f8d>] _submit_bh+0x226/0x243
[    3.167518]  [<78313fb4>] submit_bh+0xa/0xc
[    3.167518]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    3.167518]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    3.167518]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    3.167518]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.167518]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.167518]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    3.167518]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    3.167518]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    3.167518]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.167518]  [<782bf256>] read_cache_page+0xb/0x12
[    3.167518]  [<785f61b2>] read_dev_sector+0x26/0x61
[    3.167518]  [<785f6c00>] read_lba+0xae/0xf9
[    3.167518]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    3.167518]  [<785f7130>] efi_partition+0x17a/0x9c0
[    3.167518]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.167518]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.167518]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    3.167518]  [<7860b627>] ? snprintf+0x15/0x17
[    3.167518]  [<785f62e9>] check_partition+0xe4/0x178
[    3.167518]  [<785f62e9>] ? check_partition+0xe4/0x178
[    3.167518]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    3.167518]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    3.167518]  [<78318d5f>] __blkdev_get+0x173/0x363
[    3.167518]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    3.167518]  [<78318658>] ? bdget+0xf8/0x105
[    3.167518]  [<788acee0>] ? put_device+0xf/0x11
[    3.167518]  [<785f3f90>] add_disk+0x26b/0x3b5
[    3.167518]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    3.167518]  [<789d1acd>] sd_probe_async+0x111/0x198
[    3.167518]  [<78274964>] async_run_entry_fn+0x59/0xff
[    3.167518]  [<7826bae8>] process_one_work+0x1ef/0x349
[    3.167518]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    3.167518]  [<7826c039>] worker_thread+0x1a3/0x274
[    3.167518]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    3.167518]  [<78270649>] kthread+0x8a/0x8f
[    3.167518]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    3.167518]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    3.167518]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    3.350102] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    3.361479]  sda: unknown partition table
[    3.366086] sd 0:0:0:0: [sda] Attached SCSI disk

dmesg-yocto-waimea-7:20131113001534:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    3.986131] device id = 25a1
[    3.986751] device id = 2670
[    3.987468] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.992165] INFO: trying to register non-static key.
[    3.992166] the code is fine but needs lockdep annotation.
[    3.992166] turning off the locking correctness validator.
[    3.992169] CPU: 0 PID: 97 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    3.992170] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    3.992177] Workqueue: events_unbound async_run_entry_fn
[    3.992181]  7828d9ae 00000000 85779968 78fa76a8 799d92ec 857799a0 78288323 7938b281
[    3.992185]  7938b2db 7938b2b1 85750898 00000000 00000011 4835a011 0000a885 857503b0
[    3.992187]  857503b0 87198540 00000000 857799cc 78288faa 00000000 00000001 00000000
[    3.992188] Call Trace:
[    3.992193]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    3.992197]  [<78fa76a8>] dump_stack+0x48/0x60
[    3.992199]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    3.992202]  [<78288faa>] lock_acquire+0x71/0x9a
[    3.992205]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.992207]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    3.992209]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    3.992211]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    3.992214]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    3.992216]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.992224]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    3.992225]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    3.992227]  [<785ec187>] generic_make_request+0xf/0xb5
[    3.992229]  [<785ec292>] submit_bio+0x65/0xd2
[    3.992232]  [<78313f8d>] _submit_bh+0x226/0x243
[    3.992234]  [<78313fb4>] submit_bh+0xa/0xc
[    3.992236]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    3.992238]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    3.992241]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    3.992243]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.992245]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.992246]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    3.992249]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    3.992289]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    3.992291]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    3.992293]  [<782bf256>] read_cache_page+0xb/0x12
[    3.992295]  [<785f61b2>] read_dev_sector+0x26/0x61
[    3.992297]  [<785f6c00>] read_lba+0xae/0xf9
[    3.992299]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    3.992301]  [<785f7130>] efi_partition+0x17a/0x9c0
[    3.992305]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.992307]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    3.992309]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    3.992311]  [<7860b627>] ? snprintf+0x15/0x17
[    3.992312]  [<785f62e9>] check_partition+0xe4/0x178
[    3.992314]  [<785f62e9>] ? check_partition+0xe4/0x178
[    3.992316]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    3.992318]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    3.992320]  [<78318d5f>] __blkdev_get+0x173/0x363
[    3.992322]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    3.992324]  [<78318658>] ? bdget+0xf8/0x105
[    3.992327]  [<788acee0>] ? put_device+0xf/0x11
[    3.992329]  [<785f3f90>] add_disk+0x26b/0x3b5
[    3.992332]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    3.992334]  [<789d1acd>] sd_probe_async+0x111/0x198
[    3.992337]  [<78274964>] async_run_entry_fn+0x59/0xff
[    3.992340]  [<7826bae8>] process_one_work+0x1ef/0x349
[    3.992342]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    3.992344]  [<7826c039>] worker_thread+0x1a3/0x274
[    3.992346]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    3.992348]  [<78270649>] kthread+0x8a/0x8f
[    3.992350]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    3.992353]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    3.992355]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    3.995816]  sda: unknown partition table
[    3.999071] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.170734] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.

dmesg-yocto-waimea-7:20131113004133:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.049174] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.050652] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.052135] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.053676] INFO: trying to register non-static key.
[    2.053677] the code is fine but needs lockdep annotation.
[    2.053677] turning off the locking correctness validator.
[    2.053680] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.053681] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.053686] Workqueue: events_unbound async_run_entry_fn
[    2.053690]  7828d9ae 00000000 85763968 78fa76a8 799d7af4 857639a0 78288323 7938b281
[    2.053694]  7938b2db 7938b2b1 8573f508 00000000 00000011 34360011 0000a605 8573f020
[    2.053697]  8573f020 872e3540 00000000 857639cc 78288faa 00000000 00000001 00000000
[    2.053698] Call Trace:
[    2.053702]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    2.053706]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.053709]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.053710]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.053713]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.053716]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.053718]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.053720]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.053722]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.053724]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.053728]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.053730]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.053731]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.053733]  [<785ec292>] submit_bio+0x65/0xd2
[    2.053736]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.053738]  [<78313fb4>] submit_bh+0xa/0xc
[    2.053740]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.053742]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.053746]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.053749]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.053751]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.053752]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.053755]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.053757]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.053759]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.053761]  [<782bf256>] read_cache_page+0xb/0x12
[    2.053763]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.053765]  [<785f6c00>] read_lba+0xae/0xf9
[    2.053767]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.053769]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.053771]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.053774]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.053777]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.053779]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.053781]  [<7860b627>] ? snprintf+0x15/0x17
[    2.053783]  [<785f62e9>] check_partition+0xe4/0x178
[    2.053785]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.053787]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.053789]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.053791]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.053793]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.053795]  [<78318658>] ? bdget+0xf8/0x105
[    2.053799]  [<788acee0>] ? put_device+0xf/0x11
[    2.053801]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.053803]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.053807]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.053809]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.053812]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.053814]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.053817]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.053819]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.053821]  [<78270649>] kthread+0x8a/0x8f
[    2.053823]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.053827]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.053829]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.135027] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.136952] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.137049]  sda: unknown partition table

dmesg-yocto-xgwo-4:20131112233638:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.656089] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    2.658077] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    2.668531] SSFDC read-only Flash Translation layer
[    2.670314] INFO: trying to register non-static key.
[    2.670316] the code is fine but needs lockdep annotation.
[    2.670317] turning off the locking correctness validator.
[    2.670326] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.670327] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.670364] Workqueue: events_unbound async_run_entry_fn
[    2.670369]  7828d9ae 00000000 85743968 78fa76a8 799d92ec 857439a0 78288323 7938b281
[    2.670372]  7938b2db 7938b2b1 856e0598 00000000 00000011 3c34c011 0000a705 856e00b0
[    2.670376]  856e00b0 87198540 00000000 857439cc 78288faa 00000000 00000001 00000000
[    2.670381] Call Trace:
[    2.670392]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    2.670415]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.670418]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.670420]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.670438]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.670441]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.670443]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.670446]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.670448]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.670450]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.670456]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.670457]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.670460]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.670462]  [<785ec292>] submit_bio+0x65/0xd2
[    2.670473]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.670476]  [<78313fb4>] submit_bh+0xa/0xc
[    2.670478]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.670480]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.670485]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.670490]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.670492]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.670494]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.670497]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.670499]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.670501]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.670503]  [<782bf256>] read_cache_page+0xb/0x12
[    2.670505]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.670507]  [<785f6c00>] read_lba+0xae/0xf9
[    2.670510]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.670512]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.670515]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.670519]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.670521]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.670527]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.670529]  [<7860b627>] ? snprintf+0x15/0x17
[    2.670531]  [<785f62e9>] check_partition+0xe4/0x178
[    2.670533]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.670535]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.670538]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.670540]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.670542]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.670544]  [<78318658>] ? bdget+0xf8/0x105
[    2.670565]  [<788acee0>] ? put_device+0xf/0x11
[    2.670568]  [<785f3f90>] add_disk+0x26b/0x3b5
[    2.670575]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    2.670587]  [<789d1acd>] sd_probe_async+0x111/0x198
[    2.670590]  [<78274964>] async_run_entry_fn+0x59/0xff
[    2.670594]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.670596]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.670599]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.670601]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.670603]  [<78270649>] kthread+0x8a/0x8f
[    2.670606]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.670613]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    2.670615]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.672078]  sda: unknown partition table
[    2.676116] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.792452] device id = 2440

dmesg-yocto-xgwo-6:20131112233156:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.673642] pmc551: not detected
[    2.674074] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    2.704419] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    2.710323] INFO: trying to register non-static key.
[    2.711018] the code is fine but needs lockdep annotation.
[    2.711018] turning off the locking correctness validator.
[    2.711018] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.711018] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.711018] Workqueue: events_unbound async_run_entry_fn
[    2.711018]  7828d55b 00000000 85791968 78fa76a8 799d7af4 857919a0 78288323 7938b281
[    2.711018]  7938b2db 7938b2b1 85773708 00000000 00000011 48354011 0000a885 85773220
[    2.711018]  85773220 872e3540 00000000 857919cc 78288faa 00000000 00000001 00000000
[    2.711018] Call Trace:
[    2.711018]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.711018]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.711018]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.711018]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.711018]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.711018]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.711018]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.711018]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    2.711018]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    2.711018]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.711018]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    2.711018]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.711018]  [<785ec187>] generic_make_request+0xf/0xb5
[    2.711018]  [<785ec292>] submit_bio+0x65/0xd2
[    2.711018]  [<78313f8d>] _submit_bh+0x226/0x243
[    2.711018]  [<78313fb4>] submit_bh+0xa/0xc
[    2.711018]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    2.711018]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    2.711018]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    2.711018]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.711018]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.711018]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    2.711018]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    2.711018]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    2.711018]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    2.711018]  [<782bf256>] read_cache_page+0xb/0x12
[    2.711018]  [<785f61b2>] read_dev_sector+0x26/0x61
[    2.711018]  [<785f6c00>] read_lba+0xae/0xf9
[    2.711018]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    2.711018]  [<785f7130>] efi_partition+0x17a/0x9c0
[    2.711018]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    2.711018]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.711018]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    2.711018]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    2.711018]  [<7860b627>] ? snprintf+0x15/0x17
[    2.711018]  [<785f62e9>] check_partition+0xe4/0x178
[    2.711018]  [<785f62e9>] ? check_partition+0xe4/0x178
[    2.711018]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    2.711018]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    2.711018]  [<78318d5f>] __blkdev_get+0x173/0x363
[    2.711018]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    2.711018]  [<78318658>] ? bdget+0xf8/0x105
[    2.711018]  [<788acee0>] ? put_device+0xf/0x11
[    2.836665] No valid DiskOnChip devices found
[    2.836706] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.836707] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-xgwo-6:20131113003138:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    2.444302] sector address bytes: 3
[    2.444861] options: 0x42
[    2.455063] Scanning device for bad blocks
[    2.497289] INFO: trying to register non-static key.
[    2.498016] the code is fine but needs lockdep annotation.
[    2.498016] turning off the locking correctness validator.
[    2.498016] CPU: 1 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    2.498016] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.498016] Workqueue: events_unbound async_run_entry_fn
[    2.498016]  7828d55b 00000000 85769968 78fa76a8 799d7af4 857699a0 78288323 7938b281
[    2.498016]  7938b2db 7938b2b1 8574f588 00000000 00000011 34352011 0000a605 8574f0a0
[    2.498016]  8574f0a0 872e3540 00000000 857699cc 78288faa 00000000 00000001 00000000
[    2.498016] Call Trace:
[    2.498016]  [<7828d55b>] ? console_unlock+0x353/0x380
[    2.498016]  [<78fa76a8>] dump_stack+0x48/0x60
[    2.498016]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    2.498016]  [<78288faa>] lock_acquire+0x71/0x9a
[    2.498016]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.498016]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    2.498016]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    2.519383] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    2.519389] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    2.520342] parport0: cannot grant exclusive access for device spi-lm70llp

dmesg-yocto-xian-13:20131112153848:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.093206] device id = 25a1
[    1.093700] device id = 2670
[    1.094342] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    1.095250] INFO: trying to register non-static key.
[    1.095251] the code is fine but needs lockdep annotation.
[    1.095252] turning off the locking correctness validator.
[    1.095256] CPU: 0 PID: 95 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.095258] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.095266] Workqueue: events_unbound async_run_entry_fn
[    1.095272]  7828d9ae 00000000 8573b968 78fa76a8 799d92ec 8573b9a0 78288323 7938b281
[    1.095276]  7938b2db 7938b2b1 85772598 00000000 00000011 3434c011 0000a605 857720b0
[    1.095280]  857720b0 87198540 00000000 8573b9cc 78288faa 00000000 00000001 00000000
[    1.095281] Call Trace:
[    1.095289]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    1.095295]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.095298]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.095301]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.095306]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.095309]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.095312]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.095315]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.095319]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.095321]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.095327]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.095329]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.095331]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.095333]  [<785ec292>] submit_bio+0x65/0xd2
[    1.095338]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.095340]  [<78313fb4>] submit_bh+0xa/0xc
[    1.095343]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.095346]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.095352]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.095355]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.095358]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.095361]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.095364]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.095367]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.095369]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.095372]  [<782bf256>] read_cache_page+0xb/0x12
[    1.095374]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.095378]  [<785f6c00>] read_lba+0xae/0xf9
[    1.095382]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.095385]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.095388]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.095393]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.095396]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.095400]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.095403]  [<7860b627>] ? snprintf+0x15/0x17
[    1.095405]  [<785f62e9>] check_partition+0xe4/0x178
[    1.095407]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.095409]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.095412]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.095415]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.095418]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.095420]  [<78318658>] ? bdget+0xf8/0x105
[    1.095426]  [<788acee0>] ? put_device+0xf/0x11
[    1.095428]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.095435]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.095440]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.095443]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.095448]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.095451]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.095454]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.095457]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.095459]  [<78270649>] kthread+0x8a/0x8f
[    1.095462]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.095468]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.095471]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.097059]  sda: unknown partition table
[    1.101115] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.154057] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.

dmesg-yocto-xian-31:20131112165232:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.575461] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    1.576714] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    1.577910] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.578247] INFO: trying to register non-static key.
[    1.578248] the code is fine but needs lockdep annotation.
[    1.578249] turning off the locking correctness validator.
[    1.578253] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.578254] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.578264] Workqueue: events_unbound async_run_entry_fn
[    1.578270]  7828d9ae 00000000 85741968 78fa76a8 799d92ec 857419a0 78288323 7938b281
[    1.578275]  7938b2db 7938b2b1 8577a618 00000000 00000011 34364011 0000a605 8577a130
[    1.578279]  8577a130 87198540 00000000 857419cc 78288faa 00000000 00000001 00000000
[    1.578281] Call Trace:
[    1.578288]  [<7828d9ae>] ? vprintk_emit+0x426/0x4a0
[    1.578293]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.578296]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.578299]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.578304]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.578307]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.578310]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.578313]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.578317]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.578320]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.578326]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.578329]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.578332]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.578334]  [<785ec292>] submit_bio+0x65/0xd2
[    1.578338]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.578340]  [<78313fb4>] submit_bh+0xa/0xc
[    1.578343]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.578346]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.578353]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.578356]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.578359]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.578361]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.578365]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.578368]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.578371]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.578374]  [<782bf256>] read_cache_page+0xb/0x12
[    1.578376]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.578379]  [<785f6c00>] read_lba+0xae/0xf9
[    1.578383]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.578385]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.578389]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.578394]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.578397]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.578401]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.578404]  [<7860b627>] ? snprintf+0x15/0x17
[    1.578406]  [<785f62e9>] check_partition+0xe4/0x178
[    1.578408]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.578411]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.578414]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.578417]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.578419]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.578422]  [<78318658>] ? bdget+0xf8/0x105
[    1.578428]  [<788acee0>] ? put_device+0xf/0x11
[    1.578430]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.578435]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.578439]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.578442]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.578446]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.578449]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.578452]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.578455]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.578458]  [<78270649>] kthread+0x8a/0x8f
[    1.578461]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.578465]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.578468]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.580061]  sda: unknown partition table
[    1.584128] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.630783] e1000: Copyright (c) 1999-2006 Intel Corporation.

dmesg-yocto-xian-8:20131112153738:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.414973] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    1.416131] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    1.419064] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.425226] INFO: trying to register non-static key.
[    1.425930] the code is fine but needs lockdep annotation.
[    1.426028] turning off the locking correctness validator.
[    1.426028] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.426028] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.426028] Workqueue: events_unbound async_run_entry_fn
[    1.426028]  7828d55b 00000000 78097968 78fa76a8 799d92ec 780979a0 78288323 7938b281
[    1.426028]  7938b2db 7938b2b1 8577e598 00000000 00000011 44354011 0000a805 8577e0b0
[    1.426028]  8577e0b0 87198540 00000000 780979cc 78288faa 00000000 00000001 00000000
[    1.426028] Call Trace:
[    1.426028]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.426028]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.426028]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.426028]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.426028]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.426028]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.426028]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.426028]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.426028]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.426028]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.426028]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.426028]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.426028]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.426028]  [<785ec292>] submit_bio+0x65/0xd2
[    1.426028]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.426028]  [<78313fb4>] submit_bh+0xa/0xc
[    1.426028]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.426028]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.426028]  [<782c78b6>] ? __pagevec_lru_add+0xf/0x11
[    1.426028]  [<782c78fd>] ? __lru_cache_add+0x45/0x5b
[    1.426028]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.426028]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.426028]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.426028]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.426028]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.426028]  [<782bf256>] read_cache_page+0xb/0x12
[    1.426028]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.426028]  [<785f6c00>] read_lba+0xae/0xf9
[    1.426028]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.426028]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.426028]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.455751] No valid DiskOnChip devices found
[    1.455779] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    1.455781] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0

dmesg-yocto-xps-2:20131112233426:i386-randconfig-j7-11082318:3.12.0-00186-gd3516a7:2

[    1.800817] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    1.803065] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.804277] Spectra MTD driver built on Nov 12 2013 @ 15:28:09
[    1.810415] INFO: trying to register non-static key.
[    1.811086] the code is fine but needs lockdep annotation.
[    1.811086] turning off the locking correctness validator.
[    1.811086] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-00186-gd3516a7 #2
[    1.811086] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.811086] Workqueue: events_unbound async_run_entry_fn
[    1.811086]  7828d55b 00000000 85779968 78fa76a8 799d92ec 857799a0 78288323 7938b281
[    1.811086]  7938b2db 7938b2b1 8576e618 00000000 00000011 3835a011 0000a685 8576e130
[    1.811086]  8576e130 87198540 00000000 857799cc 78288faa 00000000 00000001 00000000
[    1.811086] Call Trace:
[    1.811086]  [<7828d55b>] ? console_unlock+0x353/0x380
[    1.811086]  [<78fa76a8>] dump_stack+0x48/0x60
[    1.811086]  [<78288323>] __lock_acquire.isra.26+0x7e3/0xceb
[    1.811086]  [<78288faa>] lock_acquire+0x71/0x9a
[    1.811086]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.811086]  [<785fb001>] throtl_update_dispatch_stats+0x7c/0x153
[    1.811086]  [<785fc420>] ? blk_throtl_bio+0x1c3/0x485
[    1.811086]  [<785fc420>] blk_throtl_bio+0x1c3/0x485
[    1.811086]  [<7827b5de>] ? sched_clock_local+0x17/0x106
[    1.811086]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.811086]  [<785ea9f2>] generic_make_request_checks+0x3bb/0x3d2
[    1.811086]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    1.811086]  [<785ec187>] generic_make_request+0xf/0xb5
[    1.811086]  [<785ec292>] submit_bio+0x65/0xd2
[    1.811086]  [<78313f8d>] _submit_bh+0x226/0x243
[    1.811086]  [<78313fb4>] submit_bh+0xa/0xc
[    1.811086]  [<78314f86>] block_read_full_page+0x2a8/0x2c3
[    1.811086]  [<78317c1e>] ? bio_dirty_fn+0x68/0x68
[    1.811086]  [<782bd9ac>] ? add_to_page_cache_locked+0xb4/0xe2
[    1.811086]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.811086]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.811086]  [<78317ec3>] blkdev_readpage+0xf/0x11
[    1.811086]  [<782be517>] do_read_cache_page+0x6e/0x11b
[    1.811086]  [<782bf225>] read_cache_page_async+0x19/0x1e
[    1.811086]  [<78317eb4>] ? blkdev_write_begin+0x20/0x20
[    1.811086]  [<782bf256>] read_cache_page+0xb/0x12
[    1.811086]  [<785f61b2>] read_dev_sector+0x26/0x61
[    1.811086]  [<785f6c00>] read_lba+0xae/0xf9
[    1.811086]  [<782e4686>] ? kmem_cache_alloc+0xf9/0x12b
[    1.811086]  [<785f7130>] efi_partition+0x17a/0x9c0
[    1.811086]  [<782c37ed>] ? __alloc_pages_nodemask+0xe3/0x61e
[    1.811086]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.811086]  [<7860a3fa>] ? string.isra.4+0x29/0x93
[    1.811086]  [<7860b19a>] ? vsnprintf+0x81/0x26f
[    1.811086]  [<7860b627>] ? snprintf+0x15/0x17
[    1.811086]  [<785f62e9>] check_partition+0xe4/0x178
[    1.811086]  [<785f62e9>] ? check_partition+0xe4/0x178
[    1.811086]  [<785f5f3b>] rescan_partitions+0x89/0x267
[    1.811086]  [<78317fa8>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    1.811086]  [<78318d5f>] __blkdev_get+0x173/0x363
[    1.811086]  [<78318f9a>] blkdev_get+0x4b/0x23d
[    1.811086]  [<78318658>] ? bdget+0xf8/0x105
[    1.811086]  [<788acee0>] ? put_device+0xf/0x11
[    1.811086]  [<785f3f90>] add_disk+0x26b/0x3b5
[    1.811086]  [<788b4ffa>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    1.811086]  [<789d1acd>] sd_probe_async+0x111/0x198
[    1.811086]  [<78274964>] async_run_entry_fn+0x59/0xff
[    1.811086]  [<7826bae8>] process_one_work+0x1ef/0x349
[    1.811086]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    1.811086]  [<7826c039>] worker_thread+0x1a3/0x274
[    1.811086]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    1.811086]  [<78270649>] kthread+0x8a/0x8f
[    1.811086]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    1.811086]  [<78fbabbb>] ret_from_kernel_thread+0x1b/0x30
[    1.811086]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    1.903306]  sda: unknown partition table
[    1.908351] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.911368] No valid DiskOnChip devices found
