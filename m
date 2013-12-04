Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3LDKbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:31:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:34310 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3LDKbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:31:50 -0500
Date: Wed, 4 Dec 2013 11:31:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Tang <dt.tangr@gmail.com>
cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv2 RESEND] irqchip: Add support for TI-NSPIRE irqchip
In-Reply-To: <1385352167-94223-1-git-send-email-dt.tangr@gmail.com>
Message-ID: <alpine.DEB.2.02.1312041128290.30673@ionos.tec.linutronix.de>
References: <1385352167-94223-1-git-send-email-dt.tangr@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Nov 2013, dt.tangr@gmail.com wrote:
> diff --git a/drivers/irqchip/irq-zevio.c b/drivers/irqchip/irq-zevio.c
> +static void zevio_irq_ack(struct irq_data *irqd)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(irqd);
> +	struct irq_chip_regs *regs =
> +		&container_of(irqd->chip, struct irq_chip_type, chip)->regs;
> +
> +	irq_gc_lock(gc);

Why do you need to lock here? You are reading the ack register and not
modifying it. You are neither storing the value in the gc itself. So
what are you trying to protect?

> +	readl(gc->reg_base + regs->ack);
> +	irq_gc_unlock(gc);
> +}
> +
> +static void init_base(void __iomem *base)

Shouldnt that be marked __init ?

> +{
> +	/* Disable all interrupts */
> +	writel(~0, base + IO_DISABLE);

Thanks,

	tglx
