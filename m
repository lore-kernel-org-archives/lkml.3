Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaICMSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:18:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:43992 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbaICMSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:18:54 -0400
Date: Wed, 3 Sep 2014 14:18:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Fainelli <f.fainelli@gmail.com>
cc: linux-kernel@vger.kernel.org, jason@lakedaemon.net,
        computersforpeace@gmail.com
Subject: Re: [PATCH 1/2] irqchip: add Broadcom BCM7120-style Level 2 interrupt
 controller
In-Reply-To: <1409265326-7579-2-git-send-email-f.fainelli@gmail.com>
Message-ID: <alpine.DEB.2.10.1409031413230.3333@nanos>
References: <1409265326-7579-1-git-send-email-f.fainelli@gmail.com> <1409265326-7579-2-git-send-email-f.fainelli@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Florian Fainelli wrote:
> +static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct bcm7120_l2_intc_data *b = irq_desc_get_handler_data(desc);
> +	struct irq_chip *chip = irq_desc_get_chip(desc);
> +	struct irq_chip_generic *gc = irq_get_domain_generic_chip(b->domain, 0);
> +	u32 status;
> +
> +	chained_irq_enter(chip, desc);
> +
> +	irq_gc_lock(gc);
> +	status = __raw_readl(b->base + IRQSTAT);
> +	irq_gc_unlock(gc);

Why do you need locking around the status read out?

> +	for (irq = 0; irq < num_parent_irqs; irq++) {
> +		ret = bcm7120_l2_intc_init_one(dn, data, irq, map_mask);
> +		if (ret)
> +			continue;

What's the exact purpose of this "if (ret)" construct?

Thanks,

	tglx
