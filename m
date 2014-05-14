Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaENX5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:57:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:48972 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaENX5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:57:51 -0400
Date: Thu, 15 May 2014 01:57:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: LKML <linux-kernel@vger.kernel.org>, Tony Lu <zlu@tilera.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 03/32] genirq: Provide generic hwirq allocation
 facility
In-Reply-To: <5373AE8C.40705@tilera.com>
Message-ID: <alpine.DEB.2.02.1405150151090.6261@ionos.tec.linutronix.de>
References: <20140507153622.703412101@linutronix.de> <20140507154334.208629358@linutronix.de> <536A998A.4000307@tilera.com> <alpine.DEB.2.02.1405072259230.6261@ionos.tec.linutronix.de> <5373AE8C.40705@tilera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Chris Metcalf wrote:

> On 5/7/2014 7:15 PM, Thomas Gleixner wrote:
> > On Wed, 7 May 2014, Chris Metcalf wrote:
> > > We have an internal change that we haven't upstreamed yet that makes
> > > irqs actually (cpu,ipi) pairs, so that more irqs can be allocated.
> > > As a result we allocate some irqs as bound to a specific IPI on a single
> > > cpu, and some irqs get bound to a particular IPI registered on every cpu.
> > > 
> > > I'll have to set aside a bit of time to look more closely at how your
> > > change interacts with the work we've done internally.  I've appended the
> > > per-cpu IRQ change from our internal tree here (and cc'ed the author).
> > > The API change is in the <asm/irq.h> diff at the very start.
> > Sure it'll break it. [...]
> 
> I think the right thing for now is to take my Acked-by for the tile changes
> (given a couple of minor nits replied to in separate emails).
> 
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Thanks.
 
> When we have the chance to set aside some time for more upstreaming of some
> of the work we've done it does seem like it makes sense to tackle doing some
> kind of matrix mapping in a more generic way.

Please coordinate with x86 folks on that to avoid redundant efforts.
 
> You're probably right that a cpumask approach would have made more sense
> than a cpu integer in the tile API, so we'd certainly go with that in any
> generic matrix mapping code.

Anything else is just an intermediate and non generic solution.
 
> I do have one question about the irq_alloc_hwirqs() API, which is
> the use of zero as an error indicator.  Given that zero can
> plausibly be an IRQ number, it seems cleaner to specify this as
> returning a negative errno failure instead.  Doing so would also
> align with __irq_alloc_descs().  So, what was your thinking around
> using zero?

0 has been for a long time a not allocatable irq. Google will unearth
about a gazillion heated debates about that.

I personally agree, that using a negative error code is the right
thing to do. I'll update the series before I push it into tip.

Thanks for your input and cooperation!

       tglx
