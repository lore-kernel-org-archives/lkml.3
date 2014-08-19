Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaHSMPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:15:45 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63636 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaHSMPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:15:02 -0400
Date: Tue, 19 Aug 2014 13:14:58 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jason Wang <jasowang@redhat.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: [PANIC, hyperv] kernel BUG at drivers/hv/channel.c:504!
Message-ID: <20140819121458.GB12160@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While booting a Hyper-V 3.17.0-rc1 guest on a 2012 R2 host a BUG was
triggered in drivers/hv/channel.c:504 which in turn caused a panic:

[   11.367472] Non-volatile memory driver v1.3
[   11.395587] Linux agpgart interface v0.103
[   11.425034] loop: module loaded
[   11.446046] Loading iSCSI transport class v2.0-870.
[   11.487851] iscsi: registered transport (tcp)
[   11.516175] hv_vmbus: registering driver hv_storvsc
[   11.554505] scsi host0: storvsc_host_t
[   11.598422] scsi 0:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 4
[   11.669970] scsi host1: storvsc_host_t
[   11.700535] sd 0:0:0:0: [sda] 8388608 512-byte logical blocks: (4.29 GB/4.00 GiB)
[   11.700546] scsi 1:0:0:0: scsi scan: INQUIRY result too short (5), using 36
[   11.713200] scsi 1:0:0:1: Direct-Access     ADATA    SSD S510 120GB   5.2. PQ: 0 ANSI: 0
[   11.720373] scsi 1:0:0:2: Direct-Access     MDT MD50 00AAKS-00TMA0         PQ: 0 ANSI: 2 CCS
[   11.733693] scsi 1:0:0:3: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 4
[   11.742720] scsi 1:0:0:4: Direct-Access              ST1000DM003-9YN1 CC4H PQ: 0 ANSI: 0
[   11.750192] scsi 1:0:0:5: scsi scan: INQUIRY result too short (5), using 36
[   11.757782] scsi 1:0:1:0: scsi scan: INQUIRY result too short (5), using 36
[   11.759327] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   11.763165] ata_piix 0000:00:07.1: Hyper-V Virtual Machine detected, ATA device ignore set
[   11.768407] scsi 1:0:1:1: scsi scan: INQUIRY result too short (5), using 36
[   11.778153] scsi 1:1:0:0: scsi scan: INQUIRY result too short (5), using 36
[   11.788993] scsi 1:1:0:1: scsi scan: INQUIRY result too short (5), using 36
[   11.799140] scsi 1:1:1:0: scsi scan: INQUIRY result too short (5), using 36
[   11.807839] scsi 1:1:1:1: scsi scan: INQUIRY result too short (5), using 36
[   11.820381] scsi 1:2:0:0: scsi scan: INQUIRY result too short (5), using 36
[   11.830658] scsi 1:2:0:1: scsi scan: INQUIRY result too short (5), using 36
[   11.846730] scsi 1:2:1:0: scsi scan: INQUIRY result too short (5), using 36
[   11.856029] scsi 1:2:1:1: scsi scan: INQUIRY result too short (5), using 36
[   11.866376] scsi 1:3:0:0: scsi scan: INQUIRY result too short (5), using 36
[   11.876016] scsi 1:3:0:1: scsi scan: INQUIRY result too short (5), using 36
[   11.885970] scsi 1:3:1:0: scsi scan: INQUIRY result too short (5), using 36
[   11.895874] scsi 1:3:1:1: scsi scan: INQUIRY result too short (5), using 36
[   11.904325] scsi 1:4:0:0: scsi scan: INQUIRY result too short (5), using 36
[   11.912754] scsi 1:4:0:1: scsi scan: INQUIRY result too short (5), using 36
[   11.916263] scsi host2: ata_piix
[   11.920088] scsi 1:4:1:0: scsi scan: INQUIRY result too short (5), using 36
[   11.921745] scsi host3: ata_piix
[   11.926950] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[   11.926953] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[   11.928912] scsi 1:4:1:1: scsi scan: INQUIRY result too short (5), using 36
[   11.932451] libphy: Fixed MDIO Bus: probed
[   11.932473] hv_vmbus: registering driver hv_netvsc
[   11.948202] scsi 1:5:0:0: scsi scan: INQUIRY result too short (5), using 36
[   11.957281] scsi 1:5:0:1: scsi scan: INQUIRY result too short (5), using 36
[   11.966949] scsi 1:5:1:0: scsi scan: INQUIRY result too short (5), using 36
[   11.973444] scsi 1:5:1:1: scsi scan: INQUIRY result too short (5), using 36
[   11.982711] scsi 1:6:0:0: scsi scan: INQUIRY result too short (5), using 36
[   11.991903] scsi 1:6:0:1: scsi scan: INQUIRY result too short (5), using 36
[   12.001777] scsi 1:6:1:0: scsi scan: INQUIRY result too short (5), using 36
[   12.010837] scsi 1:6:1:1: scsi scan: INQUIRY result too short (5), using 36
[   12.020033] scsi 1:7:0:0: scsi scan: INQUIRY result too short (5), using 36
[   12.027225] scsi 1:7:0:1: scsi scan: INQUIRY result too short (5), using 36
[   12.036701] scsi 1:7:1:0: scsi scan: INQUIRY result too short (5), using 36
[   12.052576] scsi 1:7:1:1: scsi scan: INQUIRY result too short (5), using 36
[   12.063680] sd 1:0:0:1: [sdb] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[   12.068274] sd 1:0:0:1: Attached scsi generic sg1 type 0
[   12.081024] sd 1:0:0:2: Attached scsi generic sg2 type 0
[   12.090032] sd 1:0:0:3: Attached scsi generic sg3 type 0
[   12.099894] sd 1:0:0:4: Attached scsi generic sg4 type 0
[   12.101244] sd 1:0:0:4: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[   12.135360] sd 1:0:0:1: [sdb] Write Protect is off
[   12.136031] sd 1:0:0:2: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[   12.136431] sd 1:0:0:3: [sdd] 199229440 512-byte logical blocks: (102 GB/95.0 GiB)
[   12.156796] sd 1:0:0:2: [sdc] Write Protect is off
[   12.156913] sd 1:0:0:3: [sdd] Write Protect is off
[   12.175208] sd 1:0:0:1: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   12.178922] sd 1:0:0:2: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   12.181124] sd 1:0:0:3: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   12.349318] sd 1:0:0:4: [sde] Write Protect is off
[   12.352849] sd 1:0:0:4: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   12.380163]  sde: sde1 sde2
[   12.398504] sd 1:0:0:4: [sde] Attached SCSI disk
[   12.414890]  sdc: unknown partition table
[   12.423556]  sdb: sdb1
[   12.429735] sd 1:0:0:2: [sdc] Attached SCSI disk
[   12.442067]  sdd: unknown partition table
[   12.497141] sd 1:0:0:1: [sdb] Attached SCSI disk
[   12.497922] sd 1:0:0:3: [sdd] Attached SCSI disk
[   14.904693] sd 0:0:0:0: [sda] Write Protect is off
[   14.904718] hv_netvsc: hv_netvsc channel opened successfully
[   14.976202] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.027923]  sda: sda1
[   15.042664] sd 0:0:0:0: [sda] Attached SCSI disk
[   15.073726] hv_netvsc vmbus_0_14 (unnamed net_device) (uninitialized): unable to establish receive buffer's gpadl
[   15.172674] hv_netvsc vmbus_0_14 (unnamed net_device) (uninitialized): unable to connect to NetVSP - 4
[   15.258991] ------------[ cut here ]------------
[   15.259943] kernel BUG at drivers/hv/channel.c:504!
[   15.259943] invalid opcode: 0000 [#1] SMP
[   15.259943] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc1.x86_64 #124
[   15.259943] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   15.259943] task: ffff8801fc1b0000 ti: ffff8801fc1b8000 task.ti: ffff8801fc1b8000
[   15.259943] RIP: 0010:[<ffffffff815a8e06>]  [<ffffffff815a8e06>] vmbus_close_internal+0x86/0xf0
[   15.259943] RSP: 0000:ffff8801fc1bbbb0  EFLAGS: 00010202
[   15.259943] RAX: 0000000000000004 RBX: ffff8801fbb89fb0 RCX: 0000000000000000
[   15.259943] RDX: 0000000000000006 RSI: ffff8801fc1b0768 RDI: 0000000000000246
[   15.259943] RBP: ffff8801fc1bbbb8 R08: 0000000000000000 R09: 0000000000000000
[   15.259943] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8801fbb89fb0
[   15.259943] R13: ffff8801fbb8a2d8 R14: ffff8800f104d668 R15: 0000000000000004
[   15.259943] FS:  0000000000000000(0000) GS:ffff880207c60000(0000) knlGS:0000000000000000
[   15.259943] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   15.259943] CR2: 0000000000000000 CR3: 0000000001c0e000 CR4: 00000000000406e0
[   15.259943] Stack:
[   15.259943]  ffff8801fbb8a2d8 ffff8801fc1bbbe0 ffffffff815a8eb0 ffff8801fbb8d9c8
[   15.259943]  ffff8800f104e7c0 ffff8800f104d668 ffff8801fc1bbc50 ffffffff814e8adf
[   15.259943]  ffff8801fbb89fb0 0000000000000000 ffff8800f104d710 ffff8801fc1bbc24
[   15.259943] Call Trace:
[   15.259943]  [<ffffffff815a8eb0>] vmbus_close+0x40/0x80
[   15.259943]  [<ffffffff814e8adf>] netvsc_device_add+0x70f/0x7c0
[   15.259943]  [<ffffffff814e9c20>] rndis_filter_device_add+0x80/0x430
[   15.259943]  [<ffffffff810ba258>] ? lockdep_init_map+0x4c8/0x510
[   15.259943]  [<ffffffff814e7172>] netvsc_probe+0x192/0x280
[   15.259943]  [<ffffffff815a66eb>] vmbus_probe+0x3b/0xa0
[   15.259943]  [<ffffffff814799ad>] driver_probe_device+0x16d/0x380
[   15.259943]  [<ffffffff81479c7e>] __driver_attach+0x6e/0xa0
[   15.259943]  [<ffffffff81479c10>] ? __device_attach+0x50/0x50
[   15.259943]  [<ffffffff81477b5e>] bus_for_each_dev+0x6e/0xc0
[   15.259943]  [<ffffffff81479d7e>] driver_attach+0x1e/0x20
[   15.259943]  [<ffffffff81478668>] bus_add_driver+0x128/0x250
[   15.259943]  [<ffffffff81d844f0>] ? fixed_mdio_bus_init+0xf3/0xf3
[   15.259943]  [<ffffffff8147a2b8>] driver_register+0x98/0xe0
[   15.259943]  [<ffffffff815a7347>] __vmbus_driver_register+0x57/0x60
[   15.259943]  [<ffffffff81d8452f>] netvsc_drv_init+0x3f/0x41
[   15.259943]  [<ffffffff81d3e124>] do_one_initcall+0xf9/0x1a7
[   15.259943]  [<ffffffff8108de65>] ? parse_args+0x295/0x430
[   15.259943]  [<ffffffff81d3e3a6>] kernel_init_freeable+0x1d4/0x268
[   15.259943]  [<ffffffff81d3d88d>] ? do_early_param+0x8a/0x8a
[   15.259943]  [<ffffffff8168ccb0>] ? rest_init+0xd0/0xd0
[   15.259943]  [<ffffffff8168ccbe>] kernel_init+0xe/0x100
[   15.259943]  [<ffffffff816a2c7c>] ret_from_fork+0x7c/0xb0
[   15.259943]  [<ffffffff8168ccb0>] ? rest_init+0xd0/0xd0
[   15.259943] Code: 8b 83 14 01 00 00 48 8d bb a0 02 00 00 c7 83 a0 02 00 00 07 00 00 00 be 0c 00 00 00 89 83 a8 02 00 00 e8 1e f1 ff ff 85 c0 74 0a <0f> 0b 0f 1f 84 00 00 00 00 00 8b b3 24 01 00 00 85 f6 74 08 48
[   15.259943] RIP  [<ffffffff815a8e06>] vmbus_close_internal+0x86/0xf0
[   15.259943]  RSP <ffff8801fc1bbbb0>
[   17.496773] ---[ end trace 2d42ce1fc914616e ]---
[   17.533369] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[   17.533369]
[   17.534323] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[   17.534323] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[   17.534323]

-- 
Sitsofe | http://sucs.org/~sits/
