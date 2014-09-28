Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaI1Vfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 17:35:32 -0400
Received: from mail-bl2on0121.outbound.protection.outlook.com ([65.55.169.121]:33528
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753943AbaI1Vf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 17:35:29 -0400
X-WSS-ID: 0NCMRYY-07-PM4-02
X-M-MSG: 
Message-ID: <54287F17.8000503@amd.com>
Date: Sun, 28 Sep 2014 16:35:19 -0500
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>,
        <tglx@linutronix.de>
CC: <will.deacon@arm.com>, <catalin.marinas@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [RFC 4/4] irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1411937610-22125-5-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1411937610-22125-5-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(479174003)(377454003)(189002)(164054003)(24454002)(51704005)(84676001)(101416001)(80022003)(77982003)(79102003)(74662003)(92566001)(21056001)(81542003)(64126003)(86362001)(10300001)(99396003)(50986999)(83072002)(85852003)(102836001)(97736003)(23756003)(2201001)(44976005)(74502003)(90102001)(92726001)(46102003)(80316001)(19580405001)(76482002)(81342003)(95666004)(19580395003)(65956001)(68736004)(65806001)(15975445006)(64706001)(83506001)(85306004)(4396001)(105586002)(33656002)(120916001)(76176999)(20776003)(36756003)(87936001)(50466002)(31966008)(87266999)(54356999)(65816999)(83322001)(47776003)(107046002)(106466001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Forefront-PRVS: 03484C0ABF
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason/Thomas,

This patch comes from:
     [V8 2/2] irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)
     (https://lkml.org/lkml/2014/9/20/113)

It has been slightly modified to remove the multi-MSI supports for now
(I am waiting to discuss with Marc after he returned from vacation.), 
and will be submitted separately.

Since this patch is independent from the multi-MSI stuff.  Please let me 
know if you would consider taking this separately.

Thanks,

Suravee

On 09/28/2014 03:53 PM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> ARM GICv2m specification extends GICv2 to support MSI(-X) with
> a new set of register frame. This patch introduces support for
> the non-secure GICv2m register frame. Currently, GICV2m is available
> in certain version of GIC-400.
>
> The patch introduces a new property in ARM gic binding, the v2m subnode.
> It is optional.
>
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Cc: Mark Rutland <Mark.Rutland@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Catalin Marinas <Catalin.Marinas@arm.com>
> Cc: Will Deacon <Will.Deacon@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>   Documentation/devicetree/bindings/arm/gic.txt |  53 +++++
>   arch/arm64/Kconfig                            |   1 +
>   drivers/irqchip/Kconfig                       |   5 +
>   drivers/irqchip/Makefile                      |   1 +
>   drivers/irqchip/irq-gic-v2m.c                 | 301 ++++++++++++++++++++++++++
>   drivers/irqchip/irq-gic.c                     |  82 ++++---
>   drivers/irqchip/irq-gic.h                     |  54 +++++
>   7 files changed, 467 insertions(+), 30 deletions(-)
>   create mode 100644 drivers/irqchip/irq-gic-v2m.c
>   create mode 100644 drivers/irqchip/irq-gic.h
>
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> index c7d2fa1..ebf976a 100644
> --- a/Documentation/devicetree/bindings/arm/gic.txt
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -96,3 +96,56 @@ Example:
>   		      <0x2c006000 0x2000>;
>   		interrupts = <1 9 0xf04>;
>   	};
> +
> +
> +* GICv2m extension for MSI/MSI-x support (Optional)
> +
> +Certain revisions of GIC-400 supports MSI/MSI-x via V2M register frame(s).
> +This is enabled by specifying v2m sub-node(s).
> +
> +Required properties:
> +
> +- compatible        : The value here should contain "arm,gic-v2m-frame".
> +
> +- msi-controller    : Identifies the node as an MSI controller.
> +
> +- reg               : GICv2m MSI interface register base and size
> +
> +Optional properties:
> +
> +- arm,msi-base-spi  : When the MSI_TYPER register contains an incorrect
> +                      value, this property should contain the SPI base of
> +                      the MSI frame, overriding the HW value.
> +
> +- arm,msi-num-spis  : When the MSI_TYPER register contains an incorrect
> +                      value, this property should contain the number of
> +                      SPIs assigned to the frame, overriding the HW value.
> +
> +Example:
> +
> +	interrupt-controller@e1101000 {
> +		compatible = "arm,gic-400";
> +		#interrupt-cells = <3>;
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		interrupt-controller;
> +		interrupts = <1 8 0xf04>;
> +		ranges = <0 0 0 0xe1100000 0 0x100000>;
> +		reg = <0x0 0xe1110000 0 0x01000>,
> +		      <0x0 0xe112f000 0 0x02000>,
> +		      <0x0 0xe1140000 0 0x10000>,
> +		      <0x0 0xe1160000 0 0x10000>;
> +		v2m0: v2m@0x8000 {
> +			compatible = "arm,gic-v2m-frame";
> +			msi-controller;
> +			reg = <0x0 0x80000 0 0x1000>;
> +		};
> +
> +		....
> +
> +		v2mN: v2m@0x9000 {
> +			compatible = "arm,gic-v2m-frame";
> +			msi-controller;
> +			reg = <0x0 0x90000 0 0x1000>;
> +		};
> +	};
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 6b01df9..01927e5 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -12,6 +12,7 @@ config ARM64
>   	select ARM_ARCH_TIMER
>   	select ARM_GIC
>   	select AUDIT_ARCH_COMPAT_GENERIC
> +	select ARM_GIC_V2M
>   	select ARM_GIC_V3
>   	select BUILDTIME_EXTABLE_SORT
>   	select CLONE_BACKWARDS
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index b8632bf..61d18d9 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -7,6 +7,11 @@ config ARM_GIC
>   	select IRQ_DOMAIN
>   	select MULTI_IRQ_HANDLER
>
> +config ARM_GIC_V2M
> +	bool
> +	depends on ARM_GIC
> +	depends on PCI && PCI_MSI
> +
>   config GIC_NON_BANKED
>   	bool
>
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index 73052ba..3bda951 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_ARCH_SUNXI)		+= irq-sun4i.o
>   obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi-nmi.o
>   obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
>   obj-$(CONFIG_ARM_GIC)			+= irq-gic.o irq-gic-common.o
> +obj-$(CONFIG_ARM_GIC_V2M)		+= irq-gic-v2m.o
>   obj-$(CONFIG_ARM_GIC_V3)		+= irq-gic-v3.o irq-gic-common.o
>   obj-$(CONFIG_ARM_NVIC)			+= irq-nvic.o
>   obj-$(CONFIG_ARM_VIC)			+= irq-vic.o
> diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
> new file mode 100644
> index 0000000..725b8a4
> --- /dev/null
> +++ b/drivers/irqchip/irq-gic-v2m.c
> @@ -0,0 +1,301 @@
> +/*
> + * ARM GIC v2m MSI(-X) support
> + * Support for Message Signaled Interrupts for systems that
> + * implement ARM Generic Interrupt Controller: GICv2m.
> + *
> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
> + * Authors: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> + *          Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>
> + *          Brandon Anderson <brandon.anderson@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + */
> +
> +#define pr_fmt(fmt) "GICv2m: " fmt
> +
> +#include <linux/bitmap.h>
> +#include <linux/irq.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/of_pci.h>
> +#include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +
> +#include "irqchip.h"
> +#include "irq-gic.h"
> +#include "irq-gic-common.h"
> +
> +/*
> +* MSI_TYPER:
> +*     [31:26] Reserved
> +*     [25:16] lowest SPI assigned to MSI
> +*     [15:10] Reserved
> +*     [9:0]   Numer of SPIs assigned to MSI
> +*/
> +#define V2M_MSI_TYPER			0x008
> +#define V2M_MSI_TYPER_BASE_SHIFT	16
> +#define V2M_MSI_TYPER_BASE_MASK		0x3FF
> +#define V2M_MSI_TYPER_NUM_MASK		0x3FF
> +#define V2M_MSI_SETSPI_NS		0x040
> +#define V2M_MIN_SPI			32
> +#define V2M_MAX_SPI			1019
> +
> +#define V2M_MSI_TYPER_BASE_SPI(x)	\
> +		(((x) >> V2M_MSI_TYPER_BASE_SHIFT) & V2M_MSI_TYPER_BASE_MASK)
> +
> +#define V2M_MSI_TYPER_NUM_SPI(x)	((x) & V2M_MSI_TYPER_NUM_MASK)
> +
> +/*
> + * alloc_msi_irq - Allocate MSIs from available MSI bitmap.
> + * @data: Pointer to v2m_data
> + * @nvec: Number of interrupts to allocate
> + * @irq: Pointer to the allocated irq
> + *
> + * Allocates interrupts only if the contiguous range of MSIs
> + * with specified nvec are available. Otherwise return the number
> + * of available interrupts. If none are available, then returns -ENOENT.
> + */
> +static int alloc_msi_irq(struct v2m_data *data, int nvec, int *irq)
> +{
> +	int size = data->nr_spis;
> +	int next = size, i = nvec, ret;
> +
> +	/* We should never allocate more than available nr_spis */
> +	if (i >= size)
> +		i = size;
> +
> +	spin_lock(&data->msi_cnt_lock);
> +
> +	for (; i > 0; i--) {
> +		next = bitmap_find_next_zero_area(data->bm,
> +					size, 0, i, 0);
> +		if (next < size)
> +			break;
> +	}
> +
> +	if (i != nvec) {
> +		ret = i ? : -ENOENT;
> +	} else {
> +		bitmap_set(data->bm, next, nvec);
> +		*irq = data->spi_start + next;
> +		ret = 0;
> +	}
> +
> +	spin_unlock(&data->msi_cnt_lock);
> +
> +	return ret;
> +}
> +
> +static void gicv2m_teardown_msi_irq(struct msi_chip *chip, unsigned int irq)
> +{
> +	int pos;
> +	struct v2m_data *data = container_of(chip, struct v2m_data, msi_chip);
> +
> +	spin_lock(&data->msi_cnt_lock);
> +
> +	pos = irq - data->spi_start;
> +	if (pos >= 0 && pos < data->nr_spis)
> +		bitmap_clear(data->bm, pos, 1);
> +
> +	spin_unlock(&data->msi_cnt_lock);
> +}
> +
> +bool gicv2m_check_msi_range(struct gic_chip_data *gic, irq_hw_number_t hw)
> +{
> +	struct v2m_data *v2m = NULL;
> +
> +	list_for_each_entry(v2m, &gic->v2m_list, list) {
> +		if (hw >= v2m->spi_start &&
> +		    hw <  v2m->spi_start + v2m->nr_spis)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +static int gicv2m_setup_msi_irq(struct msi_chip *chip,
> +				struct pci_dev *pdev,
> +				struct msi_desc *desc)
> +{
> +	int irq = 0, avail;
> +	struct msi_msg msg;
> +	phys_addr_t addr;
> +	struct v2m_data *data = container_of(chip, struct v2m_data, msi_chip);
> +
> +	if (!desc) {
> +		dev_err(&pdev->dev,
> +			"MSI setup failed. Invalid msi descriptor\n");
> +		return -EINVAL;
> +	}
> +
> +	avail = alloc_msi_irq(data, 1, &irq);
> +	if (avail != 0) {
> +		dev_err(&pdev->dev,
> +			"MSI setup failed. Cannnot allocate IRQ\n");
> +		return -ENOSPC;
> +	}
> +
> +	irq_set_chip_data(irq, chip);
> +	irq_set_msi_desc(irq, desc);
> +	irq_set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
> +
> +	addr = data->res.start + V2M_MSI_SETSPI_NS;
> +	msg.address_hi = (u32)(addr >> 32);
> +	msg.address_lo = (u32)(addr);
> +	msg.data = irq;
> +	write_msi_msg(irq, &msg);
> +
> +	return 0;
> +}
> +
> +static void gicv2m_mask_irq(struct irq_data *d)
> +{
> +	gic_mask_irq(d);
> +	if (d->msi_desc)
> +		mask_msi_irq(d);
> +}
> +
> +static void gicv2m_unmask_irq(struct irq_data *d)
> +{
> +	gic_unmask_irq(d);
> +	if (d->msi_desc)
> +		unmask_msi_irq(d);
> +}
> +
> +static bool is_msi_spi_valid(u32 base, u32 num)
> +{
> +	if (base < V2M_MIN_SPI) {
> +		pr_err("Invalid MSI base SPI (base:%u)\n", base);
> +		return false;
> +	}
> +
> +	if ((num == 0) || (base + num > V2M_MAX_SPI)) {
> +		pr_err("Number of SPIs (%u) exceed maximum (%u)\n",
> +		       num, V2M_MAX_SPI - V2M_MIN_SPI + 1);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static int __init
> +gicv2m_init_one(struct device_node *node, struct v2m_data **v,
> +		struct gic_chip_data *gic)
> +{
> +	int ret;
> +	struct v2m_data *v2m = NULL;
> +
> +	*v = kzalloc(sizeof(struct v2m_data), GFP_KERNEL);
> +	if (!*v) {
> +		pr_err("Failed to allocate struct v2m_data.\n");
> +		return -ENOMEM;
> +	}
> +
> +	v2m = *v;
> +	v2m->gic = gic;
> +	v2m->msi_chip.owner = THIS_MODULE;
> +	v2m->msi_chip.of_node = node;
> +	v2m->msi_chip.setup_irq = gicv2m_setup_msi_irq;
> +	v2m->msi_chip.teardown_irq = gicv2m_teardown_msi_irq;
> +	ret = of_address_to_resource(node, 0, &v2m->res);
> +	if (ret) {
> +		pr_err("Failed to allocate v2m resource.\n");
> +		goto err_out;
> +	}
> +
> +	v2m->base = ioremap(v2m->res.start, resource_size(&v2m->res));
> +	if (!v2m->base) {
> +		pr_err("Failed to map GICv2m resource\n");
> +		ret = -EINVAL;
> +		goto err_out;
> +	}
> +
> +	ret = of_pci_msi_chip_add(&v2m->msi_chip);
> +	if (ret) {
> +		pr_info("Failed to add msi_chip.\n");
> +		goto err_out;
> +	}
> +
> +	if (!of_property_read_u32(node, "arm,msi-base-spi", &v2m->spi_start) &&
> +	    !of_property_read_u32(node, "arm,msi-num-spis", &v2m->nr_spis)) {
> +		pr_info("Overriding V2M MSI_TYPER (base:%u, num:%u)\n",
> +			v2m->spi_start, v2m->nr_spis);
> +	} else {
> +		u32 typer = readl_relaxed(v2m->base + V2M_MSI_TYPER);
> +
> +		v2m->spi_start = V2M_MSI_TYPER_BASE_SPI(typer);
> +		v2m->nr_spis = V2M_MSI_TYPER_NUM_SPI(typer);
> +	}
> +
> +	if (!is_msi_spi_valid(v2m->spi_start, v2m->nr_spis)) {
> +		ret = -EINVAL;
> +		goto err_out;
> +	}
> +
> +	v2m->bm = kzalloc(sizeof(long) * BITS_TO_LONGS(v2m->nr_spis),
> +			  GFP_KERNEL);
> +	if (!v2m->bm) {
> +		pr_err("Failed to allocate MSI bitmap\n");
> +		ret = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	spin_lock_init(&v2m->msi_cnt_lock);
> +
> +	pr_info("Node %s: range[%#lx:%#lx], SPI[%d:%d]\n", node->name,
> +		(unsigned long)v2m->res.start, (unsigned long)v2m->res.end,
> +		v2m->spi_start, (v2m->spi_start + v2m->nr_spis));
> +
> +	return 0;
> +err_out:
> +	of_pci_msi_chip_remove(&v2m->msi_chip);
> +	if (v2m->base)
> +		iounmap(v2m->base);
> +	kfree(v2m);
> +	return ret;
> +}
> +
> +int __init gicv2m_of_init(struct device_node *node,
> +			  struct gic_chip_data *gic,
> +			  struct irq_chip *v2m_chip)
> +{
> +	int ret = 0;
> +	struct v2m_data *v2m;
> +	struct device_node *child = NULL;
> +
> +	INIT_LIST_HEAD(&gic->v2m_list);
> +
> +	v2m_chip->irq_mask = gicv2m_mask_irq;
> +	v2m_chip->irq_unmask = gicv2m_unmask_irq;
> +
> +	for (;;) {
> +		child = of_get_next_child(node, child);
> +		if (!child)
> +			break;
> +
> +		if (!of_device_is_compatible(child, "arm,gic-v2m-frame"))
> +			continue;
> +
> +		if (!of_find_property(child, "msi-controller", NULL))
> +			continue;
> +
> +		ret = gicv2m_init_one(child, &v2m, gic);
> +		if (ret) {
> +			of_node_put(node);
> +			break;
> +		}
> +
> +		list_add_tail(&v2m->list, &gic->v2m_list);
> +	}
> +
> +	if (ret && list_empty(&gic->v2m_list)) {
> +		pr_warn("Warning: Failed to enable GICv2m support.\n");
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index dda6dbc..63fa02d 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -46,30 +46,9 @@
>   #include <asm/smp_plat.h>
>
>   #include "irq-gic-common.h"
> +#include "irq-gic.h"
>   #include "irqchip.h"
>
> -union gic_base {
> -	void __iomem *common_base;
> -	void __percpu * __iomem *percpu_base;
> -};
> -
> -struct gic_chip_data {
> -	union gic_base dist_base;
> -	union gic_base cpu_base;
> -#ifdef CONFIG_CPU_PM
> -	u32 saved_spi_enable[DIV_ROUND_UP(1020, 32)];
> -	u32 saved_spi_conf[DIV_ROUND_UP(1020, 16)];
> -	u32 saved_spi_target[DIV_ROUND_UP(1020, 4)];
> -	u32 __percpu *saved_ppi_enable;
> -	u32 __percpu *saved_ppi_conf;
> -#endif
> -	struct irq_domain *domain;
> -	unsigned int gic_irqs;
> -#ifdef CONFIG_GIC_NON_BANKED
> -	void __iomem *(*get_base)(union gic_base *);
> -#endif
> -};
> -
>   static DEFINE_RAW_SPINLOCK(irq_controller_lock);
>
>   /*
> @@ -131,15 +110,36 @@ static inline void gic_set_base_accessor(struct gic_chip_data *data,
>   #define gic_set_base_accessor(d, f)
>   #endif
>
> +static inline
> +struct gic_chip_data *irq_data_get_gic_chip_data(struct irq_data *d)
> +{
> +	struct gic_chip_data *gic_data;
> +	struct msi_chip *mchip;
> +	struct v2m_data *v2mdat;
> +
> +	/*
> +	 * For MSI, irq_data.chip_data points to struct msi_chip.
> +	 * For non-MSI, irq_data.chip_data points to struct gic_chip_data.
> +	 */
> +	if (d->msi_desc) {
> +		mchip = irq_data_get_irq_chip_data(d);
> +		v2mdat = container_of(mchip, struct v2m_data, msi_chip);
> +		gic_data = v2mdat->gic;
> +	} else {
> +		gic_data = irq_data_get_irq_chip_data(d);
> +	}
> +	return gic_data;
> +}
> +
>   static inline void __iomem *gic_dist_base(struct irq_data *d)
>   {
> -	struct gic_chip_data *gic_data = irq_data_get_irq_chip_data(d);
> +	struct gic_chip_data *gic_data = irq_data_get_gic_chip_data(d);
>   	return gic_data_dist_base(gic_data);
>   }
>
>   static inline void __iomem *gic_cpu_base(struct irq_data *d)
>   {
> -	struct gic_chip_data *gic_data = irq_data_get_irq_chip_data(d);
> +	struct gic_chip_data *gic_data = irq_data_get_gic_chip_data(d);
>   	return gic_data_cpu_base(gic_data);
>   }
>
> @@ -151,7 +151,7 @@ static inline unsigned int gic_irq(struct irq_data *d)
>   /*
>    * Routines to acknowledge, disable and enable interrupts
>    */
> -static void gic_mask_irq(struct irq_data *d)
> +void gic_mask_irq(struct irq_data *d)
>   {
>   	u32 mask = 1 << (gic_irq(d) % 32);
>
> @@ -162,7 +162,7 @@ static void gic_mask_irq(struct irq_data *d)
>   	raw_spin_unlock(&irq_controller_lock);
>   }
>
> -static void gic_unmask_irq(struct irq_data *d)
> +void gic_unmask_irq(struct irq_data *d)
>   {
>   	u32 mask = 1 << (gic_irq(d) % 32);
>
> @@ -325,6 +325,15 @@ static struct irq_chip gic_chip = {
>   	.irq_set_wake		= gic_set_wake,
>   };
>
> +static struct irq_chip v2m_chip = {
> +	.name			= "GICv2m",
> +	.irq_eoi		= gic_eoi_irq,
> +	.irq_set_type		= gic_set_type,
> +#ifdef CONFIG_SMP
> +	.irq_set_affinity	= gic_set_affinity,
> +#endif
> +};
> +
>   void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
>   {
>   	if (gic_nr >= MAX_GIC_NR)
> @@ -767,19 +776,29 @@ void __init gic_init_physaddr(struct device_node *node)
>   static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
>   				irq_hw_number_t hw)
>   {
> +	struct gic_chip_data *gic = d->host_data;
> +
> +	irq_set_chip_data(irq, gic);
> +
>   	if (hw < 32) {
> +		/* PPIs */
>   		irq_set_percpu_devid(irq);
>   		irq_set_chip_and_handler(irq, &gic_chip,
>   					 handle_percpu_devid_irq);
>   		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
>   	} else {
> -		irq_set_chip_and_handler(irq, &gic_chip,
> -					 handle_fasteoi_irq);
> +		/* SPIs */
>   		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>
> -		gic_routable_irq_domain_ops->map(d, irq, hw);
> +		if (!gicv2m_check_msi_range(gic, hw)) {
> +			irq_set_chip_and_handler(irq, &gic_chip,
> +						 handle_fasteoi_irq);
> +			gic_routable_irq_domain_ops->map(d, irq, hw);
> +		} else {
> +			irq_set_chip_and_handler(irq, &v2m_chip,
> +					 handle_fasteoi_irq);
> +		}
>   	}
> -	irq_set_chip_data(irq, d->host_data);
>   	return 0;
>   }
>
> @@ -1010,6 +1029,9 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>   	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
>   		percpu_offset = 0;
>
> +	if (IS_ENABLED(CONFIG_ARM_GIC_V2M))
> +		gicv2m_of_init(node, &gic_data[gic_cnt], &v2m_chip);
> +
>   	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, node);
>   	if (!gic_cnt)
>   		gic_init_physaddr(node);
> diff --git a/drivers/irqchip/irq-gic.h b/drivers/irqchip/irq-gic.h
> new file mode 100644
> index 0000000..3021665
> --- /dev/null
> +++ b/drivers/irqchip/irq-gic.h
> @@ -0,0 +1,54 @@
> +#ifndef _IRQ_GIC_H_
> +#define _IRQ_GIC_H_
> +
> +#include <linux/msi.h>
> +#include <linux/pci.h>
> +
> +union gic_base {
> +	void __iomem *common_base;
> +	void __percpu * __iomem *percpu_base;
> +};
> +
> +struct gic_chip_data;
> +
> +struct v2m_data {
> +#ifdef CONFIG_ARM_GIC_V2M
> +	struct list_head list;
> +	spinlock_t msi_cnt_lock;
> +	struct msi_chip msi_chip;
> +	struct resource res;      /* GICv2m resource */
> +	void __iomem *base;       /* GICv2m virt address */
> +	unsigned int spi_start;   /* The SPI number that MSIs start */
> +	unsigned int nr_spis;     /* The number of SPIs for MSIs */
> +	unsigned long *bm;        /* MSI vector bitmap */
> +	struct gic_chip_data *gic;
> +#endif
> +};
> +
> +struct gic_chip_data {
> +	union gic_base dist_base;
> +	union gic_base cpu_base;
> +#ifdef CONFIG_CPU_PM
> +	u32 saved_spi_enable[DIV_ROUND_UP(1020, 32)];
> +	u32 saved_spi_conf[DIV_ROUND_UP(1020, 16)];
> +	u32 saved_spi_target[DIV_ROUND_UP(1020, 4)];
> +	u32 __percpu *saved_ppi_enable;
> +	u32 __percpu *saved_ppi_conf;
> +#endif
> +	struct irq_domain *domain;
> +	unsigned int gic_irqs;
> +#ifdef CONFIG_GIC_NON_BANKED
> +	void __iomem *(*get_base)(union gic_base *);
> +#endif
> +#ifdef CONFIG_ARM_GIC_V2M
> +	struct list_head v2m_list;
> +#endif
> +};
> +
> +void gic_mask_irq(struct irq_data *d);
> +void gic_unmask_irq(struct irq_data *d);
> +int gicv2m_of_init(struct device_node *node, struct gic_chip_data *gic,
> +		   struct irq_chip *v2m_chip) __init;
> +bool gicv2m_check_msi_range(struct gic_chip_data *gic, irq_hw_number_t hw);
> +
> +#endif /* _IRQ_GIC_H_ */
>
