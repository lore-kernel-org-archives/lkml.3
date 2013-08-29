Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3H2Vqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:46:43 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:45304 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3H2Vqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:46:42 -0400
Message-ID: <521FC12A.9060302@gmail.com>
Date: Thu, 29 Aug 2013 23:46:18 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Subject: 3.10.9: Oops at elf_core_dump()
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I just got this stacktrace. Not sure whom to send it, poking throu MAINTAINERS
file and looking for ELF gave me nothing. ;-)

[105670.434336] BUG: unable to handle kernel NULL pointer dereference at           (null)
[105670.434366] IP: [<ffffffff812f7b42>] strlen+0x2/0x20
[105670.434385] PGD 18c8e5067 PUD 2b547e067 PMD 0 
[105670.434401] Oops: 0000 [#1] SMP 
[105670.434413] Modules linked in: iwldvm iwlwifi
[105670.434432] CPU: 0 PID: 7497 Comm: emerge Not tainted 3.10.9-default-pciehp #8
[105670.434451] Hardware name: Dell Inc. Vostro 3550/, BIOS A11 08/03/2012
[105670.434468] task: ffff88037df42f70 ti: ffff88018683c000 task.ti: ffff88018683c000
[105670.434487] RIP: 0010:[<ffffffff812f7b42>]  [<ffffffff812f7b42>] strlen+0x2/0x20
[105670.434509] RSP: 0018:ffff88018683d9f0  EFLAGS: 00010246
[105670.434523] RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffff88037df42f70
[105670.434542] RDX: 00000000016e3610 RSI: 0000000000000000 RDI: 0000000000000000
[105670.434560] RBP: ffff88018683da08 R08: 0000000000000000 R09: 0000000000000000
[105670.434579] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88018683db00
[105670.434598] R13: 00007ffffffff000 R14: 0000000000000004 R15: 0000000000000000
[105670.434617] FS:  00007f89b0989740(0000) GS:ffff88041d800000(0000) knlGS:0000000000000000
[105670.434637] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[105670.434652] CR2: 0000000000000000 CR3: 00000002b4c06000 CR4: 00000000000407f0
[105670.434671] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[105670.434690] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[105670.434708] Stack:
[105670.434715]  ffffffff811bb0a3 0000000000000004 00000000000003d8 ffff88018683dc08
[105670.434738]  ffffffff811bbcbd ffffffff811bb913 0000000000000000 ffff88018683db28
[105670.434762]  ffff88037df42f70 ffff88018683ffff 0000000000000246 000f424200000000
[105670.434785] Call Trace:
[105670.434795]  [<ffffffff811bb0a3>] ? notesize.isra.11+0x13/0x30
[105670.434812]  [<ffffffff811bbcbd>] elf_core_dump+0xbfd/0x1570
[105670.434828]  [<ffffffff811bb913>] ? elf_core_dump+0x853/0x1570
[105670.434845]  [<ffffffff811c2bc5>] ? do_coredump+0xe25/0xff0
[105670.434861]  [<ffffffff810eb85d>] ? trace_hardirqs_on+0xd/0x10
[105670.434878]  [<ffffffff8116e0ff>] ? __sb_start_write+0xdf/0x1b0
[105670.434894]  [<ffffffff811c2bc5>] ? do_coredump+0xe25/0xff0
[105670.434911]  [<ffffffff81097209>] ? unshare_files+0x29/0xa0
[105670.434926]  [<ffffffff811c289c>] do_coredump+0xafc/0xff0
[105670.434943]  [<ffffffff810a63c8>] ? __sigqueue_free+0x38/0x40
[105670.434960]  [<ffffffff810a9961>] get_signal_to_deliver+0x1c1/0x5c0
[105670.434977]  [<ffffffff810a8721>] ? do_send_sig_info+0x61/0x90
[105670.434994]  [<ffffffff81002303>] do_signal+0x53/0x8e0
[105670.435008]  [<ffffffff810a8cd0>] ? kill_pgrp+0x60/0x60
[105670.435025]  [<ffffffff810c2b9e>] ? finish_task_switch+0x7e/0xe0
[105670.435043]  [<ffffffff81799750>] ? sysret_signal+0x5/0x47
[105670.435058]  [<ffffffff81002bef>] do_notify_resume+0x5f/0x70
[105670.435074]  [<ffffffff812fc71e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[105670.435092]  [<ffffffff817999e2>] int_signal+0x12/0x17
[105670.435106] Code: 48 89 e5 f6 82 40 c6 84 81 20 74 15 0f 1f 44 00 00 48 83 c0 01 0f b6 10 f6 82 40 c6 84 81 20 75 f0 5d c3 66 0f 1f 44 00 00 31 c0 <80> 3f 00 55 48 89 e5 74 11 48 89 f8 66 90 48 83 c0 01 80 38 00 
[105670.435238] RIP  [<ffffffff812f7b42>] strlen+0x2/0x20
[105670.435254]  RSP <ffff88018683d9f0>
[105670.435843] CR2: 0000000000000000
[105670.439699] ---[ end trace 9d67aee555e92d75 ]---



Martin
