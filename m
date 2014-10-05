Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059AbaJEFHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 01:07:11 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:41138 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaJEFHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 01:07:07 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Sun, 5 Oct 2014 01:13:24 -0400 (EDT)
To: Mark Rutland <mark.rutland@arm.com>
cc: linux-kernel@vger.kernel.org, will.deacon@arm.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: Perf lockups / stack overflows on v3.17-rc6, x86_64, arm,
 arm64
In-Reply-To: <20140925152825.GA6531@leverpostej>
Message-ID: <alpine.DEB.2.11.1410050106360.9898@vincent-weaver-1.umelst.maine.edu>
References: <20140925152825.GA6531@leverpostej>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Mark Rutland wrote:

> Log 1, x86_64 lockup
> [  223.007005]  [<ffffffff81168910>] ? poll_select_copy_remaining+0x130/0x130
> [  223.007005]  [<ffffffff811600ea>] ? getname_flags+0x4a/0x1a0
> [  223.007005]  [<ffffffff8116007d>] ? final_putname+0x1d/0x40
> [  223.007005]  [<ffffffff811602f4>] ? putname+0x24/0x40
> [  223.007005]  [<ffffffff8116581a>] ? user_path_at_empty+0x5a/0x90
> [  223.007005]  [<ffffffff810701c0>] ? wake_up_state+0x10/0x10
> [  223.007005]  [<ffffffff81198078>] ? eventfd_read+0x38/0x60
> [  223.007005]  [<ffffffff810a1e75>] ? ktime_get_ts64+0x45/0xf0
> [  223.007005]  [<ffffffff81169f00>] SyS_poll+0x60/0xf0

I have seen issues similar to this before, where the problem appeared
to be in poll/hrtimer.  Never managed to track down anything useful about
the bug.

> Log 2, x86_64 stack overflow

> [  346.641345] divide error: 0000 [#1] SMP
> [  346.642010] Modules linked in:
> [  346.642010] CPU: 0 PID: 4076 Comm: perf_fuzzer Not tainted 3.17.0-rc6hark-perf-lockup+ #1
> [  346.642010] Hardware name: LENOVO 7484A3G/LENOVO, BIOS 5CKT54AUS 09/07/2009
> [  346.642010] task: ffff8801ac449a70 ti: ffff8801ac574000 task.ti: ffff8801ac574000
> [  346.642010] RIP: 0010:[<ffffffff81078bce>]  [<ffffffff81078bce>] find_busiest_group+0x28e/0x8a0
> [  346.642010] RSP: 0018:ffff8801ac577760  EFLAGS: 00010006
> [  346.642010] RAX: 00000000000003ff RBX: 0000000000000000 RCX: 00000000ffff8801
> [  346.642010] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> [  346.642010] RBP: ffff8801ac577890 R08: 0000000000000000 R09: 0000000000000000
> [  346.704010] ------------[ cut here ]------------
> [  346.704017] WARNING: CPU: 2 PID: 5 at arch/x86/kernel/irq_64.c:70 handle_irq+0x141/0x150()
> [  346.704019] do_IRQ():  has overflown the kernel stack (cur:1,sp:ffff8801b653fe88,irq stk top-bottom:ffff8801bed00080-ffff8801bed03fc0,exception stk top-bottom:ffff8801bed04080-ffff8801bed0a000)

weird, have not seen this before.  Though I was hitting a reboot issue
that would give really strange crash messages that was possibly fixed by
a patch that went into 3.17-rc7.

> Log 3, arm64 lockup
> ---->8----

>         Seeding random number generator with 1411488270
>         /proc/sys/kernel/perf_event_max_sample_rate currently: 285518974/s
>         /proc/sys/kernel/perf_event_paranoid currently: 1142898651

Those last two lines are suspect.  Is my fuzzer broken on arm64 somehow?
I do try to test on arm occasionally, but my pandaboard suffered massive 
SD card failure and I haven't had a chance to get it back running yet.
I have trouble getting any of my other flock of arm machines running 
recent upstream kernels.


Sorry that I don't have good answers for these bugs, but I will stick them 
in my perf_fuzzer outstanding bugs list.

Vince
