Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab3ILVfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:35:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:32989 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3ILVfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:35:34 -0400
Date: Thu, 12 Sep 2013 23:35:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Felipe Balbi <balbi@ti.com>
cc: Sricharan R <r.sricharan@ti.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, santosh.shilimkar@ti.com,
        linux@arm.linux.org.uk, tony@atomide.com, rnayak@ti.com
Subject: Re: [RFC PATCH 1/4] DRIVERS: IRQCHIP: Add crossbar irqchip driver
In-Reply-To: <20130912205417.GA539@radagast>
Message-ID: <alpine.DEB.2.02.1309122334370.4089@ionos.tec.linutronix.de>
References: <1379000351-15672-1-git-send-email-r.sricharan@ti.com> <1379000351-15672-2-git-send-email-r.sricharan@ti.com> <20130912205417.GA539@radagast>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Felipe Balbi wrote:

> On Thu, Sep 12, 2013 at 09:09:08PM +0530, Sricharan R wrote:
> > +unsigned int crossbar_request_irq(struct irq_data *d)
> > +{
> > +	int cb_no = d->hwirq;
> > +	int virq = allocate_free_irq(cb_no);
> > +	void *irq = &cb->crossbar_map[cb_no].hwirq;
> > +	int err;
> > +
> > +	err = request_threaded_irq(virq, crossbar_irq, NULL,
> > +				   0, "CROSSBAR", irq);
> 
> this is wrong, why don't you just set crossbar up as a chained handler.

That's just a detail, which does not solve the underlying problem of
the crossbar -> GIC mapping.

Thanks,

	tglx
