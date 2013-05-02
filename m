Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab3EBTXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:23:00 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:38175 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab3EBTW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:22:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+datVBTYtyKgmqi5bhoxzUYnx/20QIBus=
Date: Thu, 2 May 2013 15:22:28 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
Message-ID: <20130502192228.GI31290@titan.lakedaemon.net>
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 08:25:04PM +0200, Sebastian Hesselbarth wrote:
> This patch adds an irqchip driver for the main interrupt controller found
> on Marvell Orion SoCs (Kirkwood, Dove, Orion5x, Discovery Innovation).
> Corresponding device tree documentation is also added.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Note: This patch triggers a checkpatch warning for
>   WARNING: Avoid CamelCase: <handle_IRQ>
> 
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: Jean-Francois Moine <moinejf@free.fr>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  .../interrupt-controller/marvell,orion-mpic.txt    |   22 ++++
>  drivers/irqchip/Kconfig                            |    5 +
>  drivers/irqchip/Makefile                           |    1 +
>  drivers/irqchip/irq-orion.c                        |  129 ++++++++++++++++++++
>  include/linux/irqchip/orion.h                      |   18 +++
>  5 files changed, 175 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/marvell,orion-mpic.txt
>  create mode 100644 drivers/irqchip/irq-orion.c
>  create mode 100644 include/linux/irqchip/orion.h

Sebastian,

Could you please include this patch in the next version of the series
depending on it.  I'd like to get an Ack from the irqchip folks for us
to take this patch through mvebu/arm-soc.

This will prevent an external tree dependency, and any resulting merge
conflict will be a trivial add in Kconfig or Makefile.

thx,

Jason.

> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/marvell,orion-mpic.txt b/Documentation/devicetree/bindings/interrupt-controller/marvell,orion-mpic.txt
> new file mode 100644
> index 0000000..3b303ec
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/marvell,orion-mpic.txt
> @@ -0,0 +1,22 @@
> +Marvell Orion SoC main interrupt controller
> +
> +Required properties:
> +- compatible: shall be "marvell,orion-mpic"
> +- reg: base address(es) of interrupt registers starting with CAUSE register
> +- interrupt-controller: identifies the node as an interrupt controller
> +- #interrupt-cells: number of cells to encode an interrupt source, shall be 1.
> +
> +The interrupt sources map to the corresponding bits in the interrupt
> +registers, i.e.
> +- 0 maps to bit 0 of first base address,
> +- 1 maps to bit 1 of first base address,
> +- 32 maps to bit 0 of second base address, and so on.
> +
> +Example:
> +	intc: interrupt-controller {
> +		compatible = "marvell,orion-mpic";
> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +                /* Dove has 64 primary interrupts */
> +		reg = <0x20200 0x10>, <0x20210 0x10>;
> +	};
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index a350969..8da3559 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -2,6 +2,11 @@ config IRQCHIP
>  	def_bool y
>  	depends on OF_IRQ
>  
> +config IRQCHIP_ORION
> +	bool
> +	select IRQ_DOMAIN
> +	select MULTI_IRQ_HANDLER
> +
>  config ARM_GIC
>  	bool
>  	select IRQ_DOMAIN
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index 98e3b87..8adbd43 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -2,6 +2,7 @@ obj-$(CONFIG_IRQCHIP)			+= irqchip.o
>  
>  obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
>  obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-combiner.o
> +obj-$(CONFIG_IRQCHIP_ORION)		+= irq-orion.o
>  obj-$(CONFIG_METAG)			+= irq-metag-ext.o
>  obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
>  obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi.o
> diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
> new file mode 100644
> index 0000000..ea02e11
> --- /dev/null
> +++ b/drivers/irqchip/irq-orion.c
> @@ -0,0 +1,129 @@
> +/*
> + * Marvell Orion SoCs IRQ chip driver.
> + *
> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/irqchip/orion.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <asm/mach/irq.h>
> +
> +/* max number of handled irq register blocks */
> +#define ORION_MAX_IRQREG		2
> +
> +#define ORION_IRQ_CAUSE			0x00
> +#define ORION_IRQ_MASK			0x04
> +#define ORION_IRQ_FIQ_MASK		0x08
> +#define ORION_IRQ_ENDP_MASK		0x0c
> +
> +static void __iomem *orion_irq_base[ORION_MAX_IRQREG];
> +static unsigned int orion_irq_regs;
> +static struct irq_domain *orion_irq_domain;
> +
> +asmlinkage void __exception_irq_entry orion_handle_irq(struct pt_regs *regs)
> +{
> +	int n;
> +	for (n = 0; n < orion_irq_regs; n++) {
> +		u32 hwirq_base = n * 32;
> +		u32 stat = readl_relaxed(orion_irq_base[n] + ORION_IRQ_CAUSE) &
> +			   readl_relaxed(orion_irq_base[n] + ORION_IRQ_MASK);
> +		while (stat) {
> +			u32 hwirq = ffs(stat) - 1;
> +			u32 irq = irq_find_mapping(orion_irq_domain,
> +						hwirq_base + hwirq);
> +			handle_IRQ(irq, regs);
> +			stat &= ~(1 << hwirq);
> +		}
> +	}
> +}
> +
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
> +
> +static struct irq_chip orion_irq_chip = {
> +	.name		= "orion_irq",
> +	.irq_mask	= orion_irq_mask,
> +	.irq_unmask	= orion_irq_unmask,
> +};
> +
> +static int orion_irq_map(struct irq_domain *d, unsigned int virq,
> +			 irq_hw_number_t hw)
> +{
> +	irq_set_chip_and_handler(virq, &orion_irq_chip,
> +				 handle_level_irq);
> +	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
> +
> +	return 0;
> +}
> +
> +static struct irq_domain_ops orion_irq_ops = {
> +	.map = orion_irq_map,
> +	.xlate = irq_domain_xlate_onecell,
> +};
> +
> +static int __init orion_of_init(struct device_node *np,
> +				struct device_node *parent)
> +{
> +	int n;
> +
> +	for (n = 0; n < ORION_MAX_IRQREG; n++) {
> +		orion_irq_base[n] = of_iomap(np, n);
> +
> +		if (!orion_irq_base[n])
> +			continue;
> +
> +		/* mask all interrupts */
> +		writel(0, orion_irq_base[n] + ORION_IRQ_MASK);
> +		orion_irq_regs++;
> +	}
> +
> +	/* at least one irq reg must be set */
> +	if (!orion_irq_regs)
> +		panic("%s: unable to map IRQC registers\n", np->full_name);
> +
> +	orion_irq_domain = irq_domain_add_linear(np, orion_irq_regs * 32,
> +						 &orion_irq_ops, NULL);
> +	if (!orion_irq_domain)
> +		panic("%s: unable to create IRQ domain\n", np->full_name);
> +
> +	set_handle_irq(orion_handle_irq);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id orion_irq_dt_ids[] __initconst = {
> +	{ .compatible = "marvell,orion-mpic", .data = orion_of_init },
> +	{ }
> +};
> +
> +void __init orion_init_irq(void)
> +{
> +	of_irq_init(orion_irq_dt_ids);
> +}
> diff --git a/include/linux/irqchip/orion.h b/include/linux/irqchip/orion.h
> new file mode 100644
> index 0000000..04f7bab
> --- /dev/null
> +++ b/include/linux/irqchip/orion.h
> @@ -0,0 +1,18 @@
> +/*
> + * Marvell Orion SoCs IRQ chip driver header.
> + *
> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef __LINUX_IRQCHIP_ORION_H
> +#define __LINUX_IRQCHIP_ORION_H
> +
> +#include <asm/exception.h>
> +
> +extern void orion_init_irq(void);
> +
> +#endif
> -- 
> 1.7.2.5
> 
