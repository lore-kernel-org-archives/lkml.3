Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab3FTKmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:42:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:60480 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab3FTKmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:42:08 -0400
Date: Thu, 20 Jun 2013 12:42:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of
 spin_lock + local_irq_save, especially when CONFIG_LOCKDEP not defined
In-Reply-To: <51C2D10B.5030408@asianux.com>
Message-ID: <alpine.DEB.2.02.1306201218360.4013@ionos.tec.linutronix.de>
References: <51C11E83.8030902@asianux.com> <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de> <51C17D01.2060208@asianux.com> <alpine.DEB.2.02.1306191151390.4013@ionos.tec.linutronix.de> <51C1861A.6030901@asianux.com>
 <alpine.DEB.2.02.1306191249260.4013@ionos.tec.linutronix.de> <51C2BF3C.8020804@asianux.com> <alpine.DEB.2.02.1306201102330.4013@ionos.tec.linutronix.de> <51C2D10B.5030408@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen,

On Thu, 20 Jun 2013, Chen Gang wrote:
> On 06/20/2013 05:07 PM, Thomas Gleixner wrote:
> > If A is semantically the same as B, then B is semantically the same as
> > A. At least that's the common understanding.
> > 
> 
>   From A to B is OK.
> 
> Not means:
> 
>   From B to A is also OK.

Either you're questioning logic, math and fundamental basics of
computer science or you simply fail to grok the difference between
semantics and implementation details. See below.

> > Yes, it depends on the implementation, but all implementations do:
> > 
> >      local_irq_save(flags);
> >      arch_spin_lock_flags(l, flags);
> > 
> 
> Yes this is spin_lock_irqsave().
> 
> At least, this implemenation is not equal to.
> 
> 	local_irq_save(flags);
> 	spin_lock(l);

Again. It is semantically the same, because the semantics are:

   spin_lock_irqsave() returns with interrupts disabled, preemption
   disabled and the lock acquired.

This construct exactly follows these semantics:

 	local_irq_save(flags);
 	spin_lock(l);

After spin_lock(l) interrupts are disabled, preemption is disabled and
the lock is acquired. End of discussion.

I wasted enough time explaining you the difference between semantics
and implementation, but you seem to be simply advisory restistant.

And I already told you very impolite in the other thread, that I'm not
going to cope with such nonsense anymore. And yes, I'm tired of it.

Provide factual prove, that there is a bug in the code. And to prove
that, you actually need to understand the code and the basic concepts
behind it. 

If you keep up pursuing your contributions plan at the expense of my
and other peoples valuable time, I consider this as extremly impolite
from your side. The form of collaboration you are going to achieve
this way is an entry in my /dev/null mail filter.

Thanks,

	tglx





