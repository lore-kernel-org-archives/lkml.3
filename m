Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576Ab3EBVe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:34:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:42069 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab3EBVe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:34:58 -0400
Date: Thu, 2 May 2013 23:34:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
In-Reply-To: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <alpine.LFD.2.02.1305022324371.2891@ionos>
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

please do not take the rant below personally. You just happen to
trigger it.

On Thu, 2 May 2013, Sebastian Hesselbarth wrote:

> +static void orion_irq_mask(struct irq_data *irqd)
> +{
> +	unsigned int irq = irqd_to_hwirq(irqd);
> +	unsigned int irq_off = irq % 32;
> +	int reg = irq / 32;
> +	u32 val;
> +
> +	val = readl(orion_irq_base[reg] + ORION_IRQ_MASK);
> +	writel(val & ~(1 << irq_off), orion_irq_base[reg] + ORION_IRQ_MASK);
> +}
> +
> +static void orion_irq_unmask(struct irq_data *irqd)
> +{
> +	unsigned int irq = irqd_to_hwirq(irqd);
> +	unsigned int irq_off = irq % 32;
> +	int reg = irq / 32;
> +	u32 val;
> +
> +	val = readl(orion_irq_base[reg] + ORION_IRQ_MASK);
> +	writel(val | (1 << irq_off), orion_irq_base[reg] + ORION_IRQ_MASK);
> +}

I'm really tired of looking at the next incarnation of an OF/DT irq
chip driver, which reimplements stuff which I have consolidated in the
generic irq chip implementation with a lot of effort.

Just look at the various implementations in drivers/irqchip/ and find
out how similar they are. Moving code to drivers/irqchip/ does not
make an excuse for reestablishing the mess which was addressed by the
generic irq chip implementation.

Can you - and that means all of you ARM folks - please get your gear
together and add the missing features to the generic irq chip
implementation? I'm not going to accept more of that OF/DT frenzy.

Thanks,

	tglx
