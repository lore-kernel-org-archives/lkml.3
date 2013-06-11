Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3FKNpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:45:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:34432 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3FKNpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:45:42 -0400
Date: Tue, 11 Jun 2013 15:45:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/6] irqchip: add support for Marvell Orion SoCs
In-Reply-To: <51B7280B.7080604@gmail.com>
Message-ID: <alpine.LFD.2.02.1306111539310.22970@ionos>
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com> <1370536034-23956-2-git-send-email-sebastian.hesselbarth@gmail.com> <alpine.LFD.2.02.1306111045520.22970@ionos> <alpine.LFD.2.02.1306111525180.22970@ionos>
 <51B7280B.7080604@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013, Sebastian Hesselbarth wrote:

> On 06/11/13 15:30, Thomas Gleixner wrote:
> > On Tue, 11 Jun 2013, Thomas Gleixner wrote:
> > 
> > > On Thu, 6 Jun 2013, Sebastian Hesselbarth wrote:
> > > 
> > > > This patch adds an irqchip driver for the main interrupt controller
> > > > found
> > > > on Marvell Orion SoCs (Kirkwood, Dove, Orion5x, Discovery Innovation).
> > > > Corresponding device tree documentation is also added.
> > > > 
> > > > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > > 
> > > Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Second thoughts:
> > 
> > > +static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc
> > > *desc)
> > > +{
> > > +	struct irq_domain *d = irq_get_handler_data(irq);
> > > +	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, irq);
> > > +	u32 stat = readl_relaxed(gc->reg_base + ORION_BRIDGE_IRQ_CAUSE) &
> > > +		gc->mask_cache;
> > 
> > In init you map the first irq of that chip and install the chain
> > handler for it. Now if that first irq fires, isn't that set in the
> > cause register as well? And what acks that first irq?
> 
> It is "acked" by acking all unmasked bridge irqs.

Ok. A comment would be nice.

But what about the bit in of that first irq in the cause register? If
it's set on entry you call generic_handle_irq() for that as well. So
if it's set you need to mask it in stat. If not, then it wants a
comment.

Thanks,

	tglx
