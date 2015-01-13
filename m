Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbbAMOYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:24:37 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44116 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbAMOYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:24:34 -0500
Date: Tue, 13 Jan 2015 23:25:09 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ata_eh_report() unable to handle kernel NULL pointer dereference
Message-ID: <20150113142509.GA985@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

linux-next 20150112

[  934.572323] ata2: exception Emask 0x50 SAct 0x0 SErr 0x4090800 action 0xe frozen
[  934.572329] ata2: irq_stat 0x00400040, connection status changed
[  934.572332] ata2: SError: { HostInt PHYRdyChg 10B8B DevExch }
[  934.572341] BUG: unable to handle kernel NULL pointer dereference at 0000000000000460
[  934.572346] IP: [<ffffffff812c722c>] ata_eh_report+0x3ad/0x74d
[  934.572354] PGD 0 
[  934.572357] Oops: 0000 [#1] PREEMPT SMP 
[  934.572360] Modules linked in: ipv6 rndis_host cdc_ether usbnet broadcom mii crc32c_intel tg3 microcode psmouse evdev ac i2c_i801 lpc_ich wmi battery processor ehci_pci ehci_hcd usbcore sd_mod ahci
[  934.572382] CPU: 3 PID: 81 Comm: scsi_eh_1 Not tainted 3.19.0-rc4-next-20150112-dbg-dirty #441
[  934.572384] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[  934.572387] task: ffff880151a1a0c0 ti: ffff88009ad8c000 task.ti: ffff88009ad8c000
[  934.572388] RIP: 0010:[<ffffffff812c722c>]  [<ffffffff812c722c>] ata_eh_report+0x3ad/0x74d
[  934.572392] RSP: 0018:ffff88009ad8fba8  EFLAGS: 00010246
[  934.572394] RAX: 0000000000000000 RBX: ffff88009ade4000 RCX: 0000000000000000
[  934.572396] RDX: 0000000000000000 RSI: ffffffff81580e6d RDI: ffff88009ad8fc0a
[  934.572398] RBP: ffff88009ad8fc78 R08: 0000000000000001 R09: 0000000000000000
[  934.572400] R10: 0000000080582700 R11: ffffffff82613e00 R12: ffff88009ade5e98
[  934.572402] R13: ffffffff81580e6d R14: 0000000000000020 R15: ffff88009ad8fc02
[  934.572404] FS:  0000000000000000(0000) GS:ffff880157d80000(0000) knlGS:0000000000000000
[  934.572406] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  934.572408] CR2: 0000000000000460 CR3: 000000000180b000 CR4: 00000000000007e0
[  934.572409] Stack:
[  934.572410]  ffff88009ad8fc48 ffffffff81580e6d ffffffff81580e6d ffffffff81580e6d
[  934.572414]  ffffffff81580e6d ffffffff81580e6d ffffffff81580e6d ffff88009ade4000
[  934.572418]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  934.572421] Call Trace:
[  934.572426]  [<ffffffff812c96e5>] ata_do_eh+0x2b/0x93
[  934.572429]  [<ffffffff812c05c0>] ? ata_phys_link_offline+0x29/0x29
[  934.572434]  [<ffffffff812d0bab>] ? ahci_do_softreset+0x192/0x192
[  934.572437]  [<ffffffff812cfb7e>] ? ahci_dev_classify+0x4d/0x4d
[  934.572440]  [<ffffffff812cf943>] ? ahci_pmp_attach+0x11d/0x11d
[  934.572442]  [<ffffffff812cfb7e>] ? ahci_dev_classify+0x4d/0x4d
[  934.572445]  [<ffffffff812c97a3>] ata_std_error_handler+0x56/0x5e
[  934.572448]  [<ffffffff812cfe8f>] ahci_error_handler+0x33/0x54
[  934.572451]  [<ffffffff812c9297>] ata_scsi_port_error_handler+0x21c/0x582
[  934.572454]  [<ffffffff812c968f>] ata_scsi_error+0x92/0xbd
[  934.572460]  [<ffffffff812b1b23>] scsi_error_handler+0x1ae/0x802
[  934.572465]  [<ffffffff810683c2>] ? trace_hardirqs_on_caller+0x180/0x19c
[  934.572468]  [<ffffffff810683eb>] ? trace_hardirqs_on+0xd/0xf
[  934.572473]  [<ffffffff813c0d5d>] ? _raw_spin_unlock_irqrestore+0x46/0x5b
[  934.572476]  [<ffffffff812b1975>] ? scsi_eh_get_sense+0x19e/0x19e
[  934.572480]  [<ffffffff81051a1c>] kthread+0x10e/0x116
[  934.572484]  [<ffffffff8105bee3>] ? arch_vtime_task_switch+0x106/0x113
[  934.572488]  [<ffffffff8105190e>] ? kthread_create_on_node+0x1b6/0x1b6
[  934.572491]  [<ffffffff813c162c>] ret_from_fork+0x7c/0xb0
[  934.572494]  [<ffffffff8105190e>] ? kthread_create_on_node+0x1b6/0x1b6
[  934.572495] Code: 03 00 00 00 48 8b 93 88 01 00 00 48 c7 85 76 ff ff ff 00 00 00 00 48 8d bd 7e ff ff ff 48 c7 45 8a 00 00 00 00 f3 ab 48 8d 7d 92 <44> 8b aa 60 04 00 00 b1 3e f3 aa f6 83 d2 01 00 00 01 0f 84 55 
[  934.572532] RIP  [<ffffffff812c722c>] ata_eh_report+0x3ad/0x74d
[  934.572535]  RSP <ffff88009ad8fba8>
[  934.572537] CR2: 0000000000000460
[  934.572540] ---[ end trace 62160753352ee227 ]---


	-ss
