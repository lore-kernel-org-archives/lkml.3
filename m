Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3KZEi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 23:38:56 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:35042 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3KZEiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 23:38:54 -0500
MIME-Version: 1.0
Date: Tue, 26 Nov 2013 12:38:53 +0800
Message-ID: <CAGdX0WFeEuy+DtpsJzyzn0343qEEjLX97+o1VREFkUEhndC+5Q@mail.gmail.com>
Subject: [BUG] 3.13-rc1 kernel crash when enable all tracepoints
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not sure this issue already be fixed or not, it can be reproduced
permanently.

(I didn't use git-bisect yet, you guys might can understand it quickly)

#echo 1 > /sys/kernel/debug/tracing/events/enable

[  160.472176] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[  160.472176] IP: [<ffffffff8132ae40>] strlen+0x0/0x30
[  160.472176] PGD 7b67a067 PUD 788c6067 PMD 0
[  160.472176] Oops: 0000 [#12] SMP
[  160.472176] Modules linked in: ebtable_nat ebtables joydev e1000
[  160.472176] CPU: 0 PID: 741 Comm: bash Tainted: G      D      3.13.0-rc1+ #16
[  160.472176] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  160.472176] task: ffff88007891e000 ti: ffff880074d04000 task.ti:
ffff880074d04000
[  160.472176] RIP: 0010:[<ffffffff8132ae40>]  [<ffffffff8132ae40>]
strlen+0x0/0x30
[  160.472176] RSP: 0018:ffff88007fc03e40  EFLAGS: 00010006
[  160.472176] RAX: 0000000000000002 RBX: ffff88007bb19d80 RCX: 0000000000000002
[  160.472176] RDX: ffffffff8107a5ac RSI: ffffffff826eac88 RDI: 0000000000000000
[  160.472176] RBP: ffff88007fc03e88 R08: 0000000000000002 R09: 0000000000000000
[  160.472176] R10: ffff88007891e000 R11: 0000000000000000 R12: ffffffff826eac88
[  160.472176] R13: 0000000000010000 R14: 0000000000000046 R15: ffffffff81c47880
[  160.472176] FS:  00007fef34515740(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[  160.472176] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  160.472176] CR2: 0000000000000000 CR3: 000000007a492000 CR4: 00000000000006f0
[  160.472176] Stack:
[  160.472176]  ffffffff810999e0 0000000000000002 0000000000000046
ffff88007fc03ec0
[  160.472176]  ffff8800788031a0 ffffffff826eac88 ffffffff8107a5ac
0000000000000046
[  160.472176]  0000000000000001 ffff88007fc03ec0 ffffffff8109e840
0000000000000082
[  160.472176] Call Trace:
[  160.472176]  <IRQ>
[  160.472176]  [<ffffffff810999e0>] ? ftrace_raw_event_lock+0x50/0xe0
[  160.472176]  [<ffffffff8107a5ac>] ? hrtimer_interrupt+0x7c/0x240
[  160.472176]  [<ffffffff8109e840>] lock_release+0xe0/0x1f0
[  160.472176]  [<ffffffff810bb612>] ktime_get_update_offsets+0x62/0x150
[  160.472176]  [<ffffffff8107a5ac>] ? hrtimer_interrupt+0x7c/0x240
[  160.472176]  [<ffffffff8107a5ac>] hrtimer_interrupt+0x7c/0x240
[  160.472176]  [<ffffffff811016d6>] ? trace_event_buffer_lock_reserve+0x26/0x30
[  160.472176]  [<ffffffff810301d7>] local_apic_timer_interrupt+0x37/0x60
[  160.472176]  [<ffffffff81643b4a>] smp_trace_apic_timer_interrupt+0x4a/0xc9
[  160.472176]  [<ffffffff816427ef>] trace_apic_timer_interrupt+0x6f/0x80
[  160.472176]  <EOI>
[  160.472176]  [<ffffffff810c89ba>] ? smp_call_function_many+0x25a/0x2c0
[  160.472176]  [<ffffffff81008b80>] ? setup_data_read+0xa0/0xa0
[  160.472176]  [<ffffffff8109e7a6>] ? lock_release+0x46/0x1f0
[  160.472176]  [<ffffffff81008b80>] ? setup_data_read+0xa0/0xa0
[  160.472176]  [<ffffffff8109e7a7>] ? lock_release+0x47/0x1f0
[  160.472176]  [<ffffffff810c8a7d>] on_each_cpu+0x2d/0x60
[  160.472176]  [<ffffffff8109e7a6>] ? lock_release+0x46/0x1f0
[  160.472176]  [<ffffffff810092e8>] text_poke_bp+0xa8/0xc0
[  160.472176]  [<ffffffff8109e7a6>] ? lock_release+0x46/0x1f0
[  160.472176]  [<ffffffff8100685e>] arch_jump_label_transform+0x8e/0x100
[  160.472176]  [<ffffffff8112b73f>] __jump_label_update+0x5f/0x80
[  160.472176]  [<ffffffff8112b7fd>] jump_label_update+0x9d/0xb0
[  160.472176]  [<ffffffff8112ba3d>] static_key_slow_inc+0xad/0xb0
[  160.472176]  [<ffffffff810f2979>] tracepoint_update_probe_range+0x139/0x160
[  160.472176]  [<ffffffff810f32d4>] tracepoint_probe_register+0x54/0xa0
[  160.472176]  [<ffffffff81110b19>] ftrace_event_reg+0x69/0x90
[  160.472176]  [<ffffffff8110fb9f>] __ftrace_event_enable_disable+0x5f/0x1b0
[  160.472176]  [<ffffffff8110fdb7>] __ftrace_set_clr_event_nolock+0xc7/0xf0
[  160.472176]  [<ffffffff8111049b>] system_enable_write+0x9b/0xe0
[  160.472176]  [<ffffffff8118d494>] vfs_write+0xb4/0x1f0
[  160.472176]  [<ffffffff8118dec9>] SyS_write+0x49/0xa0
[  160.472176]  [<ffffffff810e9d7c>] ? __audit_syscall_entry+0x9c/0xf0
[  160.472176]  [<ffffffff81641b12>] system_call_fastpath+0x16/0x1b
[  160.472176] Code: 89 f8 48 89 e5 f6 82 e0 c7 85 81 20 74 15 0f 1f
44 00 00 48 83 c0 01 0f b6 10 f6 82 e0 c7 85 81 20 75 f0 5d c3 66 0f
1f 44 00 00 <80> 3f 00 55 48 89 e5 74 15 48 89 f8 0f 1f 40 00 48 83 c0
01 80
[  160.472176] RIP  [<ffffffff8132ae40>] strlen+0x0/0x30
[  160.472176]  RSP <ffff88007fc03e40>
[  160.472176] CR2: 0000000000000000
[  160.472176] ---[ end trace cadf03f6f81c6eb9 ]---
[  160.472277] Shutting down cpus with NMI
