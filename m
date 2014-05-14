Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaENXuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:50:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:48947 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaENXuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:50:16 -0400
Date: Thu, 15 May 2014 01:50:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 15/32] tile: Implement irq_alloc/free_hwirq() for
 migration
In-Reply-To: <5373AC00.7090507@tilera.com>
Message-ID: <alpine.DEB.2.02.1405150148120.6261@ionos.tec.linutronix.de>
References: <20140507153622.703412101@linutronix.de> <20140507154336.947853241@linutronix.de> <5373AC00.7090507@tilera.com>
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
> On 5/7/2014 11:44 AM, Thomas Gleixner wrote:
> > We want to convert the drivers over to the new interface and finally
> > tile to sparse irqs. Implement irq_alloc/free_hwirq() for step by step
> > migration.
> > 
> > 
> > +void irq_free_hwirq(unsigned int irq)
> > +{
> > +	destroy_irq();
> > +}
> 
> Should be destroy_irq(irq).

Yep. I caught that already when I exposed the series step by step to
a compiler.

Thanks,

	tglx
