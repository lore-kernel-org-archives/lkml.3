Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab3JHDHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:07:45 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:41114 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3JHDHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <20131008023617.GA7066@localhost>
References: <20131006082340.GA24568@localhost>
	<CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
	<20131007021118.GA27927@localhost>
	<20131007051038.GA9764@localhost>
	<CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
	<20131007083505.GA22585@localhost>
	<CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
	<CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
	<20131008020918.GA1220@localhost>
	<20131008021452.GA6456@localhost>
	<20131008023617.GA7066@localhost>
Date: Mon, 7 Oct 2013 20:07:43 -0700
X-Google-Sender-Auth: cQ5gNDvcK8oGuj0p6C7X2j-tIf4
Message-ID: <CA+55aFwnRFFV_zzD=N2hAY2CyGcK+Su3CWpoURXbgGCyCx6SLw@mail.gmail.com>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll catch up with your emails if it kills me..

On Mon, Oct 7, 2013 at 7:36 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> On Tue, Oct 08, 2013 at 10:14:52AM +0800, Fengguang Wu wrote:
>
> Disabled PARPORT_PC:
>
> # CONFIG_PARPORT is not set
>
> and retest shows another call trace. Here are two run logs:

Ugh. Ok. So something else is wrong too.

> [    4.074903] registered taskstats version 1
> [    4.077382] rtc-test rtc-test.0: setting system clock to 2013-09-09 06:44:08 UTC (1378709048)
> [    4.081688] debug: unmapping init [mem 0xffffffff81df2000-0xffffffff81ec3fff]
> /bin/sh: /proc/self/fd/9: No such file or directory
> [    4.148224] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    4.150690] IP: [<          (null)>]           (null)
> [    4.152050] PGD 6a79067 PUD 69d3067 PMD 0
> [    4.152125] Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    4.152125] CPU: 0 PID: 130 Comm: sh Not tainted 3.11.0-rc2-00010-gc817a67-dirty #7
> [    4.152125] task: ffff880006a5e980 ti: ffff880006a3e000 task.ti: ffff880006a3e000
> [    4.152125] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
> [    4.152125] RSP: 0018:ffff88000dc03e40  EFLAGS: 00010286
> [    4.152125] RAX: 0000000000000001 RBX: 0000000000000102 RCX: 0000000000000000
> [    4.152125] RDX: 0000000000000f13 RSI: 0000000000000000 RDI: 0000000000000000
> [    4.152125] RBP: ffff88000dc03e98 R08: 000000000000160f R09: ffff88000dc0a000
> [    4.152125] R10: ffff88000dc0a000 R11: ffff880006a5e980 R12: ffff880006a3ffd8
> [    4.152125] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff81f347d8
> [    4.152125] FS:  00007fe94d7b4700(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
> [    4.152125] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    4.152125] CR2: 0000000000000000 CR3: 0000000006a49000 CR4: 00000000000006b0
> [    4.152125] Stack:
> [    4.152125]  ffffffff810989e6 ffffffff8109897b ffffffff810c73b8 ffff88000dc03e58
> [    4.152125]  ffffffff821cbe60 0000000000000000 0000000000000000 ffffffff81f33780
> [    4.152125]  ffff88000dc03ec8 ffffffff81f34fd8 ffffffff81f34bd8 ffff88000dc03f08
> [    4.152125] Call Trace:
> [    4.152125]  <IRQ>
> [    4.152125]  [<ffffffff810989e6>] ? call_timer_fn+0x6b/0xde
> [    4.152125]  [<ffffffff8109897b>] ? detach_timer+0x46/0x46
> [    4.152125]  [<ffffffff810c73b8>] ? trace_hardirqs_on_caller+0x13a/0x18b
> [    4.152125]  [<ffffffff81098fcb>] run_timer_softirq+0x187/0x1cf
> [    4.152125]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
> [    4.152125]  [<ffffffff811264a7>] ? unlazy_walk+0x125/0x172
> [    4.152125]  [<ffffffff81095745>] irq_exit+0x58/0x9e
> [    4.152125]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
> [    4.152125]  [<ffffffff818547b2>] apic_timer_interrupt+0x72/0x80
> [    4.152125]  <EOI>
> [    4.152125]  [<ffffffff810c563d>] ? arch_local_irq_restore+0x6/0xd
> [    4.152125]  [<ffffffff810c9235>] lock_release+0x16e/0x17a
> [    4.152125]  [<ffffffff81852754>] _raw_spin_unlock+0x1b/0x4f
> [    4.152125]  [<ffffffff811264a7>] unlazy_walk+0x125/0x172
> [    4.152125]  [<ffffffff81128578>] do_last+0x6cc/0x9b5
> [    4.152125]  [<ffffffff81126108>] ? inode_permission+0x3d/0x3f
> [    4.152125]  [<ffffffff81128a8b>] path_openat+0x22a/0x48d
> [    4.152125]  [<ffffffff81128d23>] do_filp_open+0x35/0x85
> [    4.152125]  [<ffffffff811337e9>] ? __alloc_fd+0xd8/0xea
> [    4.152125]  [<ffffffff8111d932>] do_sys_open+0x6b/0xfd
> [    4.152125]  [<ffffffff810c73d2>] ? trace_hardirqs_on_caller+0x154/0x18b
> [    4.152125]  [<ffffffff8111d9dd>] SyS_open+0x19/0x1b
> [    4.152125]  [<ffffffff81853b29>] system_call_fastpath+0x16/0x1b
> [    4.152125] Code:  Bad RIP value.

And this one doesn't leave any hint of where it came from. Damn. The
register contents aren't being very helpful either.

The second one is the same thing.. And equally unhelpful as far as I can tell.

I think we need more powerful debugging aids to make these useful.

               Linus
