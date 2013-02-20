Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3BTXP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:15:58 -0500
Received: from www.linutronix.de ([62.245.132.108]:43611 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3BTXP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:15:57 -0500
Date: Thu, 21 Feb 2013 00:15:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] nohz: Make tick_nohz_irq_exit() irq safe
In-Reply-To: <CAFTL4hx_uXfY=bH9nnEsN6AJFTcwqdAWTxcR0jc=hL1FBrwk0w@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302210013070.22263@ionos>
References: <1361373336-11337-1-git-send-email-fweisbec@gmail.com> <alpine.LFD.2.02.1302202155320.22263@ionos> <CAFTL4hx_uXfY=bH9nnEsN6AJFTcwqdAWTxcR0jc=hL1FBrwk0w@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Frederic Weisbecker wrote:
> 2013/2/20 Thomas Gleixner <tglx@linutronix.de>:
> > That's not a fix. That's an hack.
> 
> I know it looks that way. That's because it's a pure regression fix,
> minimal for backportability.
> 
> I'm distinguishing two different things here: the fact that some archs
> can call irq_exit() with interrupts enabled which is a global design
> problem, and the fact that tick_nohz_irq_exit() was safe against that
> until 3.2 when I broke it with a commit of mine.
> 
> My goal was basically to restore that protection in a minimal commit
> such that we can backport the regression fix, then deal with
> __ARCH_IRQ_EXIT_IRQS_DISABLED afterward, since it requires some more
> invasive changes.
> 
> >> A saner long term solution will be to remove
> >> __ARCH_IRQ_EXIT_IRQS_DISABLED.
> >
> > We really want to enforce that interrupt disabled condition for
> > calling irq_exit(). So why make this exclusive to tick_nohz_irq_exit()?
> 
> I need a fix that I can backport. Is the below fine with a stable tag?
> It looks a bit too invasive for the single regression involved.

I think that's fine as it's obviously correct and not diluting the
real underlying issue of the __ARCH_IRQ_EXIT_IRQS_DISABLED insanity.

Thanks,

	tglx
