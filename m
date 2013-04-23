Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3DWMqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 08:46:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:34711 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3DWMqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 08:46:19 -0400
Date: Tue, 23 Apr 2013 14:46:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andreas Fenkart <andreas.fenkart@streamunlimited.com>, zonque@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: use irq_mask as fallback for irq_disable.
In-Reply-To: <20130422162409.e66b1e6ac3111bd3995c5fd6@linux-foundation.org>
Message-ID: <alpine.LFD.2.02.1304231445140.21884@ionos>
References: <1366378862-22359-1-git-send-email-andreas.fenkart@streamunlimited.com> <20130422162409.e66b1e6ac3111bd3995c5fd6@linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013, Andrew Morton wrote:

> On Fri, 19 Apr 2013 15:41:02 +0200 Andreas Fenkart <andreas.fenkart@streamunlimited.com> wrote:
> 
> > This is in line with irq_enable that uses the same fallback.
> > When masked, interrupts are still latched into the status register
> > so when unmasked there is an interrupt straight away.
> > 
> > ...
> >
> > --- a/kernel/irq/chip.c
> > +++ b/kernel/irq/chip.c
> > @@ -216,10 +216,11 @@ void irq_enable(struct irq_desc *desc)
> >  void irq_disable(struct irq_desc *desc)
> >  {
> >  	irq_state_set_disabled(desc);
> > -	if (desc->irq_data.chip->irq_disable) {
> > +	if (desc->irq_data.chip->irq_disable)
> >  		desc->irq_data.chip->irq_disable(&desc->irq_data);
> > -		irq_state_set_masked(desc);
> > -	}
> > +	else
> > +		desc->irq_data.chip->irq_mask(&desc->irq_data);
> > +	irq_state_set_masked(desc);
> >  }
> >  
> >  void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu)
> 
> Well I hope Thomas knows what this patch does, because I sure don't.

I know what it does, but the changelog is completely useless.
 
> Does it fix a bug?  Does it add a bug?  Does it have any
> runtime-observable effects at all?  If so, what are they?

It fixes a state inconsistency. Have to think about observable
effects.

Thanks

	tglx

