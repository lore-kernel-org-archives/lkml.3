Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaEHNMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:12:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:55230 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaEHNMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:12:35 -0400
Date: Thu, 8 May 2014 15:12:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [patch 03/32] genirq: Provide generic hwirq allocation
 facility
In-Reply-To: <20140508120738.B70FDC40D85@trevor.secretlab.ca>
Message-ID: <alpine.DEB.2.02.1405081505420.6261@ionos.tec.linutronix.de>
References: <20140507153622.703412101@linutronix.de> <20140507154334.208629358@linutronix.de> <20140508120738.B70FDC40D85@trevor.secretlab.ca>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Grant Likely wrote:
> On Wed, 07 May 2014 15:44:05 -0000, Thomas Gleixner <tglx@linutronix.de> wrote:
> > +EXPORT_SYMBOL_GPL(irq_alloc_hwirqs);
> 
> Okay, so regarding this and irq_domains, I think the functionality
> overlaps and irq_domain conversion wouldn't directly use this API. I
> could see two ways that it would be wired up in an irq_domain
> conversion...
> 
> 1) use an irq_domain to represent the root of the interrupt tree and be
> responsible for all of the hardware irqs. Child interrupt controllers
> would allocate a hwirq from the root irq_domain and program itself
> accordingly. This approach would either not use this API, or make it
> entirely internal to the root irq_domain.
> 
> 2) Use this API as the root of the interrupt tree and make first level
> of child interrupt controllers use this API to allocate HWIRQs to use
> for their irq outputs.
> 
> Most of the platforms using irq_domain now fall in the first category,
> which I think makes the most sense. Any platform like x86 that has
> multiple hwirq vectors and the option of per-cpu vectors would be best
> to keep all of that detail in one place. We could add a cpumask variant
> to the irqdomain APIs, and add a stock implementation of an allocator
> that can intelligently allocate when cpumasks are used.

When we have a root domain which handles the vector matrix, then we
can put sub domains on top which handle the various irq chips (PIC,
IOAPIC, MSI ....).

So that will need some cpumask support in irq domains, but that's not
a bad thing in general. Even ARM might get some benefit from for the
SPIs.

Thanks,

	tglx
