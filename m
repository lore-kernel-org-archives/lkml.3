Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3KTU54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:57:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:36080 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3KTU5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:57:53 -0500
Date: Wed, 20 Nov 2013 21:57:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tony Luck <tony.luck@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [patch 4/6] ia64: Use preempt_schedule_irq
In-Reply-To: <CA+8MBbKq1idWt1OSpRM3mWMDAQaEoewrU=h=m_pFoidVy6OA-Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311202121340.30673@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917182350.449685712@linutronix.de> <20130917183628.857145384@linutronix.de> <CA+8MBbKq1idWt1OSpRM3mWMDAQaEoewrU=h=m_pFoidVy6OA-Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Nov 2013, Tony Luck wrote:

> On Tue, Sep 17, 2013 at 11:53 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Use the proper core function instead of fiddling with PREEMPT_ACTIVE
> > and enable/disable interrupts in the low level code.
> >
> > Index: linux-2.6/arch/ia64/kernel/entry.S
> > ===================================================================
> > --- linux-2.6.orig/arch/ia64/kernel/entry.S
> > +++ linux-2.6/arch/ia64/kernel/entry.S
> ...
> > -       br.call.spnt.many rp=schedule
> > +       br.call.spnt.many rp=preempt_schedule_irq
> 
> This just hit mainline ... and I'm getting
> 
> arch/ia64/kernel/built-in.o: In function `skip_rbs_switch':
> (.text+0xef2): undefined reference to `preempt_schedule_irq'
> make: *** [vmlinux] Error 1

Hrmpf.
 
> Probably because I have CONFIG_PREEMPT=n, and there seems only
> to be a definition for this function in kernel/sched/core.c when it is =y.

Bah. I probably compiled that with preempt=y ...
 
> Do we need a stub for the =n case:
> 
> asmlinkage void __sched preempt_schedule_irq(void)
> {
>            schedule();
> }
> 
> Or is life more complicated than that?

Hmm, I think I fubared that and you decided to ignore my patch :) 

Let me look at it tomorrow morning with full awake brain cells.

Thanks,

	tglx
