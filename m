Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaHTJ0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:26:39 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:34899 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaHTJ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:26:37 -0400
Date: Wed, 20 Aug 2014 10:26:30 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org
Subject: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Message-ID: <20140820092630.GA1478@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While booting a Hyper-V 3.17.0-rc1 guest on a 2012 R2 host a BUG was
triggered while registering hyperv_fb which in turn caused a panic.
Various kernel debugging options (CONFIG_DEBUG_PAGEALLOC,
CONFIG_SLUB_DEBUG=y...) were on at the time. This only seems to happen
if the guest is being booted with only one CPU allocated to it.

[    7.549175] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    7.567501] io scheduler noop registered
[    7.577180] io scheduler deadline registered
[    7.589324] io scheduler cfq registered (default)
[    7.614583] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    7.629146] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    7.645526] hv_vmbus: registering driver hyperv_fb
[    7.657553] BUG: unable to handle kernel paging request at ffff880077800004
[    7.658224] IP: [<ffffffff8159a7ac>] hv_ringbuffer_write+0x7c/0x150
[    7.658224] PGD 2da9067 PUD 2dac067 PMD 7fa27067 PTE 8000000077800060
[    7.658224] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    7.658224] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc1.x86_64 #3
[    7.658224] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[    7.658224] task: ffff88007c070000 ti: ffff88007c06c000 task.ti: ffff88007c06c000
[    7.658224] RIP: 0010:[<ffffffff8159a7ac>]  [<ffffffff8159a7ac>] hv_ringbuffer_write+0x7c/0x150
[    7.658224] RSP: 0000:ffff88007c06fba0  EFLAGS: 00010092
[    7.658224] RAX: ffff880077800000 RBX: 0000000000000003 RCX: 000000000003f000
[    7.658224] RDX: 0000000000000000 RSI: ffffffff825b7640 RDI: ffff88007be6c0a8
[    7.658224] RBP: ffff88007c06fbe8 R08: 0000000000000000 R09: ffffffff82619f80
[    7.658224] R10: ffff88007c070000 R11: 0000000000000f40 R12: ffff88007c06fc20
[    7.658224] R13: ffff88007be6c098 R14: ffff880077fc0000 R15: 0000000000000030
[    7.658224] FS:  0000000000000000(0000) GS:ffff88007f800000(0000) knlGS:0000000000000000
[    7.658224] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.658224] CR2: ffff880077800004 CR3: 0000000001c0e000 CR4: 00000000000406f0
[    7.658224] Stack:
[    7.658224]  ffff88007c06fc07 0000000000000296 ffff88007be6c0a8 0000000000000000
[    7.658224]  ffff88007be6bf60 0000000000020003 ffff880077fc0400 ffff880077fc0000
[    7.658224]  0000000000000000 ffff88007c06fc60 ffffffff8159919c ffffffff811a1386
[    7.658224] Call Trace:
[    7.658224]  [<ffffffff8159919c>] vmbus_sendpacket+0x9c/0xc0
[    7.658224]  [<ffffffff811a1386>] ? kfree+0x196/0x1e0
[    7.658224]  [<ffffffff813f3359>] synthvid_negotiate_ver+0x99/0x100
[    7.658224]  [<ffffffff813f37dd>] hvfb_probe+0x19d/0xa10
[    7.658224]  [<ffffffff8122d9bf>] ? sysfs_do_create_link_sd.isra.2+0x6f/0xc0
[    7.658224]  [<ffffffff8159699b>] vmbus_probe+0x3b/0xa0
[    7.658224]  [<ffffffff8146f93d>] driver_probe_device+0x16d/0x380
[    7.658224]  [<ffffffff8146fc0e>] __driver_attach+0x6e/0xa0
[    7.658224]  [<ffffffff8146fba0>] ? __device_attach+0x50/0x50
[    7.658224]  [<ffffffff8146daee>] bus_for_each_dev+0x6e/0xc0
[    7.658224]  [<ffffffff8146fd0e>] driver_attach+0x1e/0x20
[    7.658224]  [<ffffffff8146e5f8>] bus_add_driver+0x128/0x250
[    7.658224]  [<ffffffff81d76bb6>] ? video_setup+0x7f/0x7f
[    7.658224]  [<ffffffff81470248>] driver_register+0x98/0xe0
[    7.658224]  [<ffffffff81597567>] __vmbus_driver_register+0x57/0x60
[    7.658224]  [<ffffffff81d76bd2>] hvfb_drv_init+0x1c/0x54
[    7.658224]  [<ffffffff81d3b124>] do_one_initcall+0xf9/0x1a7
[    7.658224]  [<ffffffff81089315>] ? parse_args+0x295/0x430
[    7.658224]  [<ffffffff81d3b3b9>] kernel_init_freeable+0x1e7/0x27b
[    7.658224]  [<ffffffff81d3a88d>] ? do_early_param+0x8a/0x8a
[    7.658224]  [<ffffffff8167bdf0>] ? rest_init+0xd0/0xd0
[    7.658224]  [<ffffffff8167bdfe>] kernel_init+0xe/0x100
[    7.658224]  [<ffffffff81691b7c>] ret_from_fork+0x7c/0xb0
[    7.658224]  [<ffffffff8167bdf0>] ? rest_init+0xd0/0xd0
[    7.658224] Code: 41 bf 08 00 00 00 66 0f 1f 84 00 00 00 00 00 49 8d 45 10 48 89 c7 48 89 45 c8 e8 40 66 0f 00 41 8b 4d 48 48 89 45 c0 49 8b 45 00 <8b> 50 04 44 8b 30 89 d0 44 29 f0 01 c1 44 39 f2 0f 46 c1 44 39
[    7.658224] RIP  [<ffffffff8159a7ac>] hv_ringbuffer_write+0x7c/0x150
[    7.658224]  RSP <ffff88007c06fba0>
[    7.658224] CR2: ffff880077800004
[    7.658224] ---[ end trace a117d5bf96688789 ]---
[    7.658224] note: swapper/0[1] exited with preempt_count 1
[    8.433656] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[    8.433656]
[    8.434596] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[    8.434596] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009

-- 
Sitsofe | http://sucs.org/~sits/
