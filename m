Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbaDLLek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 07:34:40 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:44749 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbaDLLeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 07:34:37 -0400
Date: Sat, 12 Apr 2014 13:34:31 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1299097701.20140412133431@eikelenboom.it>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 3.15-mw:  Oops Workqueue: writeback bdi_writeback_workfn (flush-8:16)  RIP: e030:[<ffffffff814c6bc1>]  [<ffffffff814c6bc1>] kobject_put+0x11/0x70
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just ran into the oops belowafter some uptime.

--
Sander

[175753.946560] IP: [<ffffffff814c6bc1>] kobject_put+0x11/0x70
[175753.964484] PGD 0 
[175753.982157] Oops: 0000 [#1] SMP 
[175753.999575] Modules linked in:
[175754.016705] CPU: 4 PID: 23869 Comm: kworker/u12:3 Not tainted 3.14.0-mw-20140409a+ #1
[175754.033879] Hardware name: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS V1.8B1 09/13/2010
[175754.050839] Workqueue: writeback bdi_writeback_workfn (flush-8:16)
[175754.067560] task: ffff88000f1d91e0 ti: ffff8800046c6000 task.ti: ffff8800046c6000
[175754.084258] RIP: e030:[<ffffffff814c6bc1>]  [<ffffffff814c6bc1>] kobject_put+0x11/0x70
[175754.100764] RSP: e02b:ffff8800046c76f8  EFLAGS: 00010002
[175754.117096] RAX: 0000000000000001 RBX: 00000000000001d0 RCX: 00000000010f5319
[175754.133166] RDX: 00000000010f5318 RSI: ffff88005f717e20 RDI: 00000000000001d0
[175754.149101] RBP: ffff8800046c7708 R08: 0000000000017e20 R09: ffff880057588718
[175754.164706] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[175754.180080] R13: 0000000000000020 R14: 0000000000080000 R15: ffff88002ad154c8
[175754.195262] FS:  00007f1ac8154700(0000) GS:ffff88005f700000(0000) knlGS:0000000000000000
[175754.210318] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[175754.225097] CR2: 000000000000020c CR3: 0000000002210000 CR4: 0000000000000660
[175754.239767] Stack:
[175754.254060]  ffff88000835cc40 ffff88000835cc40 ffff8800046c7718 ffffffff816e04b7
[175754.268330]  ffff8800046c7768 ffffffff8171002c ffff8800591589c0 ffff8800571da000
[175754.282367]  ffff8800046c7768 ffff880059158800 ffff88002ad154c8 0000000000000000
[175754.296180] Call Trace:
[175754.309706]  [<ffffffff816e04b7>] put_device+0x17/0x20
[175754.323129]  [<ffffffff8171002c>] scsi_init_io+0x10c/0x170
[175754.336275]  [<ffffffff81710266>] scsi_setup_fs_cmnd+0x66/0xa0
[175754.349247]  [<ffffffff8171bf44>] sd_prep_fn+0x2a4/0xd30
[175754.362023]  [<ffffffff817000bd>] ? frontend_changed+0x2dd/0x3e0
[175754.374461]  [<ffffffff814a34ee>] blk_peek_request+0xbe/0x220
[175754.386674]  [<ffffffff8170fcbd>] ? scsi_request_fn+0x2dd/0x470
[175754.398681]  [<ffffffff8170fa21>] scsi_request_fn+0x41/0x470
[175754.410403]  [<ffffffff81116e85>] ? lock_acquire+0xe5/0x150
[175754.421913]  [<ffffffff8149f8e7>] __blk_run_queue+0x37/0x50
[175754.433239]  [<ffffffff814a0a89>] queue_unplugged+0x39/0xb0
[175754.444271]  [<ffffffff814a3aab>] blk_flush_plug_list+0x1fb/0x280
[175754.455069]  [<ffffffff814a3b48>] blk_finish_plug+0x18/0x50
[175754.465622]  [<ffffffff812a1526>] ext4_writepages+0x446/0xd20
[175754.476014]  [<ffffffff81114af6>] ? __lock_acquire+0x516/0x2210
[175754.486096]  [<ffffffff8119dcd1>] do_writepages+0x21/0x50
[175754.495922]  [<ffffffff8121c3e0>] __writeback_single_inode+0x40/0x220
[175754.505550]  [<ffffffff8121d911>] writeback_sb_inodes+0x291/0x440
[175754.515007]  [<ffffffff8121db5f>] __writeback_inodes_wb+0x9f/0xd0
[175754.524158]  [<ffffffff8121ddd3>] wb_writeback+0x243/0x2c0
[175754.533058]  [<ffffffff8121e0d8>] bdi_writeback_workfn+0x118/0x480
[175754.541760]  [<ffffffff810e607b>] ? process_one_work+0x15b/0x490
[175754.550297]  [<ffffffff810e60e5>] process_one_work+0x1c5/0x490
[175754.558544]  [<ffffffff810e607b>] ? process_one_work+0x15b/0x490
[175754.566551]  [<ffffffff810e73bb>] worker_thread+0x11b/0x370
[175754.574323]  [<ffffffff81112dcd>] ? trace_hardirqs_on+0xd/0x10
[175754.581861]  [<ffffffff810e72a0>] ? manage_workers.isra.21+0x2b0/0x2b0
[175754.589261]  [<ffffffff810ee1a4>] kthread+0xe4/0x100
[175754.596332]  [<ffffffff810ee0c0>] ? __init_kthread_worker+0x70/0x70
[175754.603198]  [<ffffffff81b97e7c>] ret_from_fork+0x7c/0xb0
[175754.609811]  [<ffffffff810ee0c0>] ? __init_kthread_worker+0x70/0x70
[175754.616232] Code: 89 f7 e8 03 19 00 00 0f b6 43 04 eb a2 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 85 ff 74 0d <f6> 47 3c 01 74 29 f0 83 6b 38 01 74 0a 48 83 c4 08 5b 5d c3 0f 
[175754.629397] RIP  [<ffffffff814c6bc1>] kobject_put+0x11/0x70
[175754.635534]  RSP <ffff8800046c76f8>
[175754.641515] CR2: 000000000000020c
[175754.647383] ---[ end trace 8a401ccf86be679c ]---

