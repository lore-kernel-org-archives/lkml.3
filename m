Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab3CHUV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:21:29 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:52043 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3CHUV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:21:27 -0500
MIME-Version: 1.0
Date: Fri, 8 Mar 2013 22:21:26 +0200
Message-ID: <CA+ydwto_v9HaRfr0HfzRV9fxUs6yuTnSkUutCQ94r_K_gujziQ@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference at
 0000000000000010, IP: [<ffffffff819865fb>] snd_info_get_line+0x3b/0xf0
From: Tommi Rantala <tt.rantala@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Saw this while fuzzing with trinity in a qemu virtual machine:

[6026] Random reseed: 625996896
[watchdog] 7640111 iterations. [F:6650299 S:989808]
[6026] Random reseed: 472197910
[  459.365417] misc rfkill: uevent: unknown action-string
[  459.521953] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000010
[  459.522027] IP: [<ffffffff819865fb>] snd_info_get_line+0x3b/0xf0
[  459.522027] PGD 52deb067 PUD 50bbc067 PMD 0
[  459.522027] Oops: 0000 [#1] SMP
[  459.522027] CPU 0
[  459.522027] Pid: 7781, comm: trinity-child53 Tainted: G        W
3.9.0-rc1+ #103 Bochs Bochs
[  459.522027] RIP: 0010:[<ffffffff819865fb>]  [<ffffffff819865fb>]
snd_info_get_line+0x3b/0xf0
[  459.522027] RSP: 0018:ffff880065455a88  EFLAGS: 00010202
[  459.522027] RAX: 0000000000000001 RBX: ffff8800508e1760 RCX: 0000000000000000
[  459.522027] RDX: ffff880065455b57 RSI: ffff880065455ad8 RDI: ffff8800599ceba0
[  459.522027] RBP: ffff880065455a88 R08: 0000000000000010 R09: 0000000000000001
[  459.522027] R10: ffff8800461f5630 R11: 0000000000000000 R12: ffff88007a470960
[  459.522027] R13: ffff88007a43b980 R14: ffff88007a470000 R15: ffff88007a43b900
[  459.522027] FS:  00007f9c07c94700(0000) GS:ffff88007f800000(0000)
knlGS:0000000000000000
[  459.522027] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  459.522027] CR2: 0000000000000010 CR3: 0000000060ee2000 CR4: 00000000000006f0
[  459.522027] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  459.522027] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  459.522027] Process trinity-child53 (pid: 7781, threadinfo
ffff880065454000, task ffff8800797c2290)
[  459.522027] Stack:
[  459.522027]  ffff880065455b88 ffffffff819a3f7e ffff880065455ab8
ffff8800599ceba0
[  459.522027]  ffff8800508e1220 ffff8800508e1200 ffff880065455b48
ffffffff8136eafc
[  459.522027]  ffff880065455ae8 ffffffff81091198 ffff88007cc01600
ffff8800508e1200
[  459.522027] Call Trace:
[  459.522027]  [<ffffffff819a3f7e>] snd_mixer_oss_proc_write+0x1ee/0x250
[  459.522027]  [<ffffffff8136eafc>] ? debug_check_no_obj_freed+0x17c/0x230
[  459.522027]  [<ffffffff81091198>] ? kmemcheck_shadow_lookup+0x28/0x80
[  459.522027]  [<ffffffff81985a38>] ? snd_info_entry_release+0x48/0xd0
[  459.522027]  [<ffffffff81199c0c>] ? kfree+0x1ac/0x1e0
[  459.522027]  [<ffffffff81985a50>] snd_info_entry_release+0x60/0xd0
[  459.522027]  [<ffffffff81211022>] proc_reg_release+0x132/0x180
[  459.522027]  [<ffffffff819859f0>] ? snd_info_entry_llseek+0x100/0x100
[  459.522027]  [<ffffffff811a807a>] __fput+0x11a/0x220
[  459.522027]  [<ffffffff811a8189>] ____fput+0x9/0x10
[  459.522027]  [<ffffffff810bcbbe>] task_work_run+0x9e/0xc0
[  459.522027]  [<ffffffff8109d85c>] do_exit+0x3ac/0xad0
[  459.522027]  [<ffffffff810afc29>] ? get_signal_to_deliver+0xf9/0x810
[  459.522027]  [<ffffffff8109e044>] do_group_exit+0x84/0xd0
[  459.522027]  [<ffffffff810b0269>] get_signal_to_deliver+0x739/0x810
[  459.522027]  [<ffffffff810583b2>] do_signal+0x52/0x570
[  459.522027]  [<ffffffff810cbaf3>] ? finish_task_switch+0x43/0x120
[  459.522027]  [<ffffffff810f3366>] ? trace_hardirqs_on_caller+0x16/0x1f0
[  459.522027]  [<ffffffff810f354d>] ? trace_hardirqs_on+0xd/0x10
[  459.522027]  [<ffffffff81fad85b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  459.522027]  [<ffffffff810cbb30>] ? finish_task_switch+0x80/0x120
[  459.522027]  [<ffffffff810cbaf3>] ? finish_task_switch+0x43/0x120
[  459.522027]  [<ffffffff810588f7>] do_notify_resume+0x27/0x70
[  459.522027]  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  459.522027]  [<ffffffff81faf0a2>] int_signal+0x12/0x17
[  459.522027] Code: 00 8b 4f 14 85 c9 0f 85 cf 00 00 00 44 8b 5f 18
45 85 db 74 6b e9 c1 00 00 00 66 0f 1f 44 00 00 8b 47 08 4c 8b 07 89
c1 83 c0 01 <41> 0f b6 0c 08 89 47 08 44 0f be c1 41 83 f8 0a 75 2b 39
47 0c
[  459.522027] RIP  [<ffffffff819865fb>] snd_info_get_line+0x3b/0xf0
[  459.522027]  RSP <ffff880065455a88>
[  459.522027] CR2: 0000000000000010
[  459.652998] ---[ end trace a9ded493128a1bce ]---
[  459.654880] Fixing recursive fault but reboot is needed!
[6026] Random reseed: 807260652
[watchdog] pid 8469 hasn't made progress in 30 seconds!
(last:2725563185 now:2725563215 diff:30). Stuck in syscall 70:msgrcv.
Sending SIGKILL.
[watchdog] 7677069 iterations. [F:6682605 S:994461]
[6026] Random reseed: 575363686
[  461.032969] misc ashmem: uevent: unknown action-string
[6026] Random reseed: 1095114151
[6026] Regenerating random pages, fd's etc.

Tommi
