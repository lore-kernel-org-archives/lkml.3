Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3IYMha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:37:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14257 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab3IYMh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:37:26 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-6b-5242d904796e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, bcousson@baylibre.com, tony@atomide.com, balajitk@ti.com,
        kishon@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 09/15] ata: ti_sata: Add Texas Instruments SATA Wrapper
 driver
Date: Wed, 25 Sep 2013 14:37:19 +0200
Message-id: <5608096.0pgFIteLqQ@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1379595943-14622-10-git-send-email-rogerq@ti.com>
References: <1379595943-14622-1-git-send-email-rogerq@ti.com>
 <1379595943-14622-10-git-send-email-rogerq@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t9jAV2Wm05BBrP+6VtMnbydzeLg/XqL
	O/P/slrMP3KO1eLC0x42i02Pr7FaHNvxiMni8q45bBazl/SzWPQ80rL4tfwoo8X+K14OPB7f
	vk5i8Xh/o5XdY9OqTjaPzUvqPY7f2M7k8XmTXABbFJdNSmpOZllqkb5dAlfGlledjAXPbSrO
	zJjG3MD4RL+LkZNDQsBE4nL/RxYIW0ziwr31bF2MXBxCAosYJb5M/c0O4bQwSUza0w9WxSZg
	JTGxfRUjiC0ioChxbyVEB7PAZCaJXT+vs4IkhAUiJDZdb2YDsVkEVCWW/XoKZvMKaEosWfsG
	bJCogKfEp0lLmUFsTgF7ie9fN4PZQgJFEp37G9kh6gUlfky+B1bPLCAvsW//VFYIW0dif+s0
	tgmMArOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHR8Ux6B+OqBotD
	jAIcjEo8vAJHHYOEWBPLiitzDzFKcDArifD2X3cKEuJNSaysSi3Kjy8qzUktPsQozcGiJM57
	sNU6UEggPbEkNTs1tSC1CCbLxMEp1cAoY1cucWVJgsAjvgX8ZR/fzrnFYp3sstgh0jLQnz8m
	/6CQZqv9sQUJ66wWx0pm/vLZe3rafb8LW8IbLnzN8FBduVDNKo/R4ohTiMqUmw/4Xf2Ovsw3
	2O4nc/T43sVXy7R/tl7UMsqZln9t46Ef8d9c5i9IdD7IxhLX8fyUaPOXd+v5YqI8vl1QYinO
	SDTUYi4qTgQAreXw5YoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, September 19, 2013 04:05:37 PM Roger Quadros wrote:
> Texas Instruments SoCs like OMAP5 and DRA7 contain a SATA wrapper
> around the AHCI SATA core. This driver will manage that.
> 
> CC: Tejun Heo <tj@kernel.org>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  Documentation/devicetree/bindings/ata/ti-sata.txt |   31 ++++
>  drivers/ata/Kconfig                               |    7 +
>  drivers/ata/Makefile                              |    1 +
>  drivers/ata/sata_ti.c                             |  160 +++++++++++++++++++++
>  4 files changed, 199 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ata/ti-sata.txt
>  create mode 100644 drivers/ata/sata_ti.c
> 
> diff --git a/Documentation/devicetree/bindings/ata/ti-sata.txt b/Documentation/devicetree/bindings/ata/ti-sata.txt
> new file mode 100644
> index 0000000..bf0ea3b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ata/ti-sata.txt
> @@ -0,0 +1,31 @@
> +* Texas Instruments SATA Controller Wrapper
> +
> +Required properties:
> +- compatible	: "ti,sata"
> +- ti,hwmods	: "sata"
> +- reg		: Register mapping
> +- #address-cells: <1>
> +- #size-cells	: <1>
> +- ranges	: allows valid translation between child's address space and parent's
> +		  address space.
> +- Must contain at least one child node for the SATA controller core
> +
> +Example:
> +
> +	sata: sata@4a141100 {
> +		compatible = "ti,sata";
> +		ti,hwmods = "sata";
> +		reg = <0x4a141100 0x7>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +		dwc-ahci@4a140000 {
> +			compatible = "snps,dwc-ahci";
> +			reg = <0x4a140000 0x1100>;
> +			interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
> +			phys = <&sata_phy>;
> +			phy-names = "sata-phy";
> +			clocks = <&sata_ref_clk>;
> +			clock-names = "optclk";
> +		};
> +	};
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index a53ef27..a3de4d2 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -138,6 +138,13 @@ config SATA_SIL24
>  
>  	  If unsure, say N.
>  
> +config SATA_TI
> +	tristate "Texas Instruments SATA Wrapper driver"
> +	depends on ARCH_OMAP
> +	help
> +	  This options enables SATA Wrapper driver for Texas Instruments SoCs.
> +	  It is found on OMAP5 and DRA7.
> +
>  config ATA_SFF
>  	bool "ATA SFF support (for legacy IDE and PATA)"
>  	default y
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index 46518c6..673ba5e 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
>  obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
>  obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
>  obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o
> +obj-$(CONFIG_SATA_TI)		+= sata_ti.o
>  
>  # SFF w/ custom DMA
>  obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
> diff --git a/drivers/ata/sata_ti.c b/drivers/ata/sata_ti.c
> new file mode 100644
> index 0000000..0b9093d
> --- /dev/null
> +++ b/drivers/ata/sata_ti.c
> @@ -0,0 +1,160 @@
> +/**
> + * sata-ti.c - Texas Instruments Specific SATA Glue layer

s/sata-ti/sata_ti/

> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
> + *
> + * Authors: Roger Quadros <rogerq@ti.com>
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2  of
> + * the License as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/ioport.h>
> +#include <linux/io.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +
> +/*
> + * All these registers belong to OMAP's Wrapper around the
> + * DesignWare SATA Core.
> + */
> +
> +#define SATA_SYSCONFIG				0x0000
> +#define SATA_CDRLOCK				0x0004

These defines are not used anywhere.

> +struct ti_sata {
> +	struct device *dev;
> +	void __iomem *base;
> +};
> +
> +static int ti_sata_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct device *dev = &pdev->dev;
> +	struct ti_sata *sata;
> +	struct resource *res;
> +	void __iomem *base;
> +	int ret;
> +
> +	if (!np) {
> +		dev_err(dev, "device node not found\n");
> +		return -EINVAL;
> +	}
> +
> +	sata = devm_kzalloc(dev, sizeof(*sata), GFP_KERNEL);
> +	if (!sata)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, sata);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(dev, "missing memory base resource\n");
> +		return -EINVAL;
> +	}
> +
> +	base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
> +
> +	sata->dev = dev;
> +	sata->base = base;

sata structure is just setup and it is not used later anywhere.

> +	pm_runtime_enable(dev);
> +	ret = pm_runtime_get_sync(dev);
> +	if (ret < 0) {
> +		dev_err(dev, "pm_runtime_get_sync failed with err %d\n",
> +									ret);
> +		goto runtime_disable;
> +	}
> +
> +	ret = of_platform_populate(np, NULL, NULL, dev);

Shouldn't this driver depend on CONFIG_OF?

> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to create TI SATA children\n");
> +		goto runtime_put;
> +	}
> +
> +	return 0;
> +
> +runtime_put:
> +	pm_runtime_put_sync(dev);
> +
> +runtime_disable:
> +	pm_runtime_disable(dev);
> +
> +	return ret;
> +}
> +
> +static int ti_sata_remove_child(struct device *dev, void *c)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +
> +	platform_device_unregister(pdev);
> +
> +	return 0;
> +}
> +
> +static int ti_sata_remove(struct platform_device *pdev)
> +{
> +	pm_runtime_put_sync(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
> +	device_for_each_child(&pdev->dev, NULL, ti_sata_remove_child);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id of_ti_sata_match[] = {
> +	{
> +		.compatible =	"ti,sata"
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, of_ti_sata_match);
> +
> +#ifdef CONFIG_PM
> +
> +static int ti_sata_resume(struct device *dev)
> +{
> +	pm_runtime_disable(dev);
> +	pm_runtime_set_active(dev);
> +	pm_runtime_enable(dev);

This doesn't look like a correct ->resume method:
* it shouldn't touch runtime PM at all
* for each ->resume method there should be a corresponding ->suspend method

Moreover this whole wrapper driver seems strange, why not just add a proper
runtime PM support to ahci_platform driver instead?

> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops ti_sata_dev_pm_ops = {
> +	.resume = ti_sata_resume,
> +};
> +
> +#define DEV_PM_OPS	(&ti_sata_dev_pm_ops)
> +#else
> +#define DEV_PM_OPS	NULL
> +#endif /* CONFIG_PM */
> +
> +static struct platform_driver ti_sata_driver = {
> +	.probe		= ti_sata_probe,
> +	.remove		= ti_sata_remove,
> +	.driver		= {
> +		.name	= "ti-sata",
> +		.of_match_table	= of_ti_sata_match,
> +		.pm	= DEV_PM_OPS,
> +	},
> +};
> +
> +module_platform_driver(ti_sata_driver);
> +
> +MODULE_ALIAS("platform:ti-sata");
> +MODULE_AUTHOR("Roger Quadros <rogerq@ti.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("TI SATA Glue Layer");

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

