Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3FRKgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:36:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43331 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab3FRKgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:36:15 -0400
Date: Tue, 18 Jun 2013 11:35:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] ARM: irqchip: add support for MOXA ART SoCs
Message-ID: <20130618103534.GW2718@n2100.arm.linux.org.uk>
References: <1371549584-7169-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371549584-7169-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 11:59:44AM +0200, Jonas Jensen wrote:
> +void moxart_irq_ack(struct irq_data *irqd)
> +{
> +	unsigned int irq = irqd_to_hwirq(irqd);
> +
> +	writel(1 << irq, IRQ_CLEAR(moxart_irq_base));
> +}
> +
> +static void moxart_irq_mask(struct irq_data *irqd)
> +{
> +	unsigned int irq = irqd_to_hwirq(irqd);
> +	unsigned int mask;
> +
> +	mask = readl(IRQ_MASK(moxart_irq_base));
> +	mask &= ~(1 << irq);
> +	writel(mask, IRQ_MASK(moxart_irq_base));
> +}
> +
> +static void moxart_irq_unmask(struct irq_data *irqd)
> +{
> +	unsigned int irq = irqd_to_hwirq(irqd);
> +	unsigned int mask;
> +
> +	mask = readl(IRQ_MASK(moxart_irq_base));
> +	mask |= (1 << irq);
> +	writel(mask, IRQ_MASK(moxart_irq_base));
> +}

Is there a reason this isn't using the irq_chip_generic stuff which would
eliminate all the above?
