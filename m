Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3J3Pah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:30:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:33536 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3J3Pag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:30:36 -0400
Date: Wed, 30 Oct 2013 16:30:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sricharan R <r.sricharan@ti.com>
cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        linux@arm.linux.org.uk, tony@atomide.com, rnayak@ti.com,
        marc.zyngier@arm.com, grant.likely@linaro.org, mark.rutland@arm.com,
        robherring2@gmail.com, santosh.shilimkar@ti.com,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH V2 2/7] DRIVERS: IRQCHIP: CROSSBAR: Add support for
 Crossbar IP
In-Reply-To: <1383145040-15852-3-git-send-email-r.sricharan@ti.com>
Message-ID: <alpine.DEB.2.02.1310301615430.24686@ionos.tec.linutronix.de>
References: <1383145040-15852-1-git-send-email-r.sricharan@ti.com> <1383145040-15852-3-git-send-email-r.sricharan@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013, Sricharan R wrote:
> +static inline const u32 allocate_free_irq(int cb_no)

I understand the "static inline" part, but "const u32" is more than
fishy. What's wrong with "static inline int" ?

> +{
> +	int i;
> +
> +	for (i = 0; i < cb->int_max; i++) {
> +		if (cb->irq_map[i] == IRQ_FREE) {
> +			cb->irq_map[i] = cb_no;
> +			return i;
> +		}
> +	}
> +
> +	return -ENODEV;
> +}

> +static int crossbar_domain_xlate(struct irq_domain *d,
> +				 struct device_node *controller,
> +				 const u32 *intspec, unsigned int intsize,
> +				 unsigned long *out_hwirq,
> +				 unsigned int *out_type)
> +{
> +	unsigned long ret = 0;

Why do you need to initialize ret when you assign a value to it in the
next line?

Thanks,

	tglx
