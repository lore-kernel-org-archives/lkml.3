Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3FCIEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:04:12 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:36310 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab3FCIDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:03:35 -0400
MIME-Version: 1.0
Date: Mon, 3 Jun 2013 11:03:34 +0300
Message-ID: <CA+ydwtqfJmD4aVcuDS6u96SiYT3Wg5Zj_5oXOkzHptG-TiG-_Q@mail.gmail.com>
Subject: GPF at fsnotify_clear_marks_by_group_flags()
From: Tommi Rantala <tt.rantala@gmail.com>
To: Eric Paris <eparis@redhat.com>, Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hit this while fuzzing v3.10-rc4-0-gd683b96 with trinity.

Looks similar to what I reported back in March:
https://lkml.org/lkml/2013/3/13/222

Tommi

[42279.088045] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[42279.091904] CPU: 1 PID: 10937 Comm: trinity-child7 Tainted: G
   I  3.10.0-rc4 #1
[42279.091904] Hardware name: Hewlett-Packard HP Compaq dc7800 Small
Form Factor/0AA8h, BIOS 786F1 v01.24 03/18/2008
[42279.091904] task: ffff8801125e23e0 ti: ffff8800bdf40000 task.ti:
ffff8800bdf40000
[42279.091904] RIP: 0010:[<ffffffff81275b63>]  [<ffffffff81275b63>]
fsnotify_clear_marks_by_group_flags+0x93/0xb0
[42279.091904] RSP: 0018:ffff8800bdf41be8  EFLAGS: 00010246
[42279.091904] RAX: ffff8800bdf41f00 RBX: ffff880102381400 RCX: 0000000000006c6b
[42279.091904] RDX: 0000000000000000 RSI: ffffffff82a42863 RDI: ffff880102381400
[42279.091904] RBP: ffff8800bdf41c18 R08: 0000000000000002 R09: 0000000000000000
[42279.091904] R10: 0000000000000000 R11: 0000000000000000 R12: 6b6b6b6b6b6b6b5b
[42279.091904] R13: ffff8800d4630a90 R14: 00000000ffffffff R15: ffff8800d4630c70
[42279.091904] FS:  00007f9d0c425700(0000) GS:ffff880116a00000(0000)
knlGS:0000000000000000
[42279.091904] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[42279.091904] CR2: 0000000000000000 CR3: 0000000110ea3000 CR4: 00000000000007e0
[42279.091904] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[42279.091904] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[42279.091904] Stack:
[42279.091904]  ffff8800d4630bc0 ffff8800d4630a90 0000000000000010
ffff8800c51d0b90
[42279.091904]  ffff880114fbe9a0 ffff880115f78ca0 ffff8800bdf41c28
ffffffff81275b8e
[42279.091904]  ffff8800bdf41c40 ffffffff81274c3d ffff8800c96ca940
ffff8800bdf41c50
[42279.091904] Call Trace:
[42279.091904]  [<ffffffff81275b8e>] fsnotify_clear_marks_by_group+0xe/0x10
[42279.091904]  [<ffffffff81274c3d>] fsnotify_destroy_group+0xd/0x30
[42279.091904]  [<ffffffff81277060>] inotify_release+0x10/0x20
[42279.091904]  [<ffffffff8123237a>] __fput+0x12a/0x230
[42279.091904]  [<ffffffff81232489>] ____fput+0x9/0x10
[42279.091904]  [<ffffffff8113a79e>] task_work_run+0xae/0xf0
[42279.091904]  [<ffffffff811172bc>] do_exit+0x44c/0xb40
[42279.091904]  [<ffffffff81129f39>] ? get_signal_to_deliver+0xf9/0x920
[42279.091904]  [<ffffffff81117a74>] do_group_exit+0x84/0xd0
[42279.091904]  [<ffffffff8112a661>] get_signal_to_deliver+0x821/0x920
[42279.091904]  [<ffffffff810673e2>] do_signal+0x52/0x590
[42279.091904]  [<ffffffff81231849>] ? do_readv_writev+0x249/0x270
[42279.091904]  [<ffffffff81142191>] ? __hrtimer_start_range_ns+0x451/0x500
[42279.091904]  [<ffffffff8117302d>] ? trace_hardirqs_on+0xd/0x10
[42279.091904]  [<ffffffff822a1787>] ? _raw_spin_unlock_irq+0x27/0x50
[42279.091904]  [<ffffffff8111870c>] ? do_setitimer+0x27c/0x330
[42279.091904]  [<ffffffff81067947>] do_notify_resume+0x27/0x70
[42279.091904]  [<ffffffff822a3162>] int_signal+0x12/0x17
[42279.091904] Code: 0f 1f 84 00 00 00 00 00 49 89 d4 44 85 b3 94 00
00 00 74 17 f0 ff 43 04 48 89 df 4c 89 ee e8 75 fa ff ff 48 89 df e8
ad f8 ff ff <49> 8b 54 24 10 49 8d 44 24 10 4c 89 e3 48 83 ea 10 49 39
c7 75
[42279.091904] RIP  [<ffffffff81275b63>]
fsnotify_clear_marks_by_group_flags+0x93/0xb0
[42279.091904]  RSP <ffff8800bdf41be8>
[42279.417403] ---[ end trace 1dec2388e3dff256 ]---
[42279.423057] Fixing recursive fault but reboot is needed!
