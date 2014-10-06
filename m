Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaJFKAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:00:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33700 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbaJFJ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:59:57 -0400
Date: Mon, 6 Oct 2014 10:59:31 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: Perf lockups / stack overflows on v3.17-rc6, x86_64, arm, arm64
Message-ID: <20141006095931.GB24686@leverpostej>
References: <20140925152825.GA6531@leverpostej>
 <alpine.DEB.2.11.1410050106360.9898@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410050106360.9898@vincent-weaver-1.umelst.maine.edu>
Thread-Topic: Perf lockups / stack overflows on v3.17-rc6, x86_64, arm, arm64
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 06:13:24AM +0100, Vince Weaver wrote:
> On Thu, 25 Sep 2014, Mark Rutland wrote:
> 
> > Log 1, x86_64 lockup
> > [  223.007005]  [<ffffffff81168910>] ? poll_select_copy_remaining+0x130/0x130
> > [  223.007005]  [<ffffffff811600ea>] ? getname_flags+0x4a/0x1a0
> > [  223.007005]  [<ffffffff8116007d>] ? final_putname+0x1d/0x40
> > [  223.007005]  [<ffffffff811602f4>] ? putname+0x24/0x40
> > [  223.007005]  [<ffffffff8116581a>] ? user_path_at_empty+0x5a/0x90
> > [  223.007005]  [<ffffffff810701c0>] ? wake_up_state+0x10/0x10
> > [  223.007005]  [<ffffffff81198078>] ? eventfd_read+0x38/0x60
> > [  223.007005]  [<ffffffff810a1e75>] ? ktime_get_ts64+0x45/0xf0
> > [  223.007005]  [<ffffffff81169f00>] SyS_poll+0x60/0xf0
> 
> I have seen issues similar to this before, where the problem appeared
> to be in poll/hrtimer.  Never managed to track down anything useful about
> the bug.

Ok. 

> > Log 2, x86_64 stack overflow
> 
> > [  346.641345] divide error: 0000 [#1] SMP
> > [  346.642010] Modules linked in:
> > [  346.642010] CPU: 0 PID: 4076 Comm: perf_fuzzer Not tainted 3.17.0-rc6hark-perf-lockup+ #1
> > [  346.642010] Hardware name: LENOVO 7484A3G/LENOVO, BIOS 5CKT54AUS 09/07/2009
> > [  346.642010] task: ffff8801ac449a70 ti: ffff8801ac574000 task.ti: ffff8801ac574000
> > [  346.642010] RIP: 0010:[<ffffffff81078bce>]  [<ffffffff81078bce>] find_busiest_group+0x28e/0x8a0
> > [  346.642010] RSP: 0018:ffff8801ac577760  EFLAGS: 00010006
> > [  346.642010] RAX: 00000000000003ff RBX: 0000000000000000 RCX: 00000000ffff8801
> > [  346.642010] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> > [  346.642010] RBP: ffff8801ac577890 R08: 0000000000000000 R09: 0000000000000000
> > [  346.704010] ------------[ cut here ]------------
> > [  346.704017] WARNING: CPU: 2 PID: 5 at arch/x86/kernel/irq_64.c:70 handle_irq+0x141/0x150()
> > [  346.704019] do_IRQ():  has overflown the kernel stack (cur:1,sp:ffff8801b653fe88,irq stk top-bottom:ffff8801bed00080-ffff8801bed03fc0,exception stk top-bottom:ffff8801bed04080-ffff8801bed0a000)
> 
> weird, have not seen this before.  Though I was hitting a reboot issue
> that would give really strange crash messages that was possibly fixed by
> a patch that went into 3.17-rc7.

Interesting. I'll retry with v3.17.

> > Log 3, arm64 lockup
> > ---->8----
> 
> >         Seeding random number generator with 1411488270
> >         /proc/sys/kernel/perf_event_max_sample_rate currently: 285518974/s
> >         /proc/sys/kernel/perf_event_paranoid currently: 1142898651
> 
> Those last two lines are suspect.  Is my fuzzer broken on arm64 somehow?

Good point. I'd mainly paid attention to the stack dump and hadn't
noticed. I'll take a look shortly and see what's going on.

> Sorry that I don't have good answers for these bugs, but I will stick them 
> in my perf_fuzzer outstanding bugs list.

Cheers anyhow. I'll see if I can figure out anything further.

Mark.
