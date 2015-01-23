Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbbAWQOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:14:55 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:38094 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbbAWQOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:14:49 -0500
Date: Fri, 23 Jan 2015 16:14:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yingjoe Chen =?utf-8?B?KOmZs+iLsea0sik=?= 
	<Yingjoe.Chen@mediatek.com>,
        Henry Chen <henryc.chen@mediatek.com>,
        YH Chen =?utf-8?B?KOmZs+aYseixqik=?= <yh.chen@mediatek.com>,
        Flora Fu <flora.fu@mediatek.com>
Subject: Re: [PATCH 7/7] mfd: Add support for the MediaTek MT6397 PMIC
Message-ID: <20150123161440.GA11745@x1>
References: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
 <1422022202-7526-8-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1422022202-7526-8-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Sascha Hauer wrote:

> From: Flora Fu <flora.fu@mediatek.com>
> 
> This adds support for the MediaTek MT6397 PMIC. This is a
> multifunction device with the following sub modules:
> 
> - Regulator
> - RTC
> - Audio codec
> - GPIO
> - Clock
> 
> It is interfaced to the host controller using SPI interface by a proprietary
> hardware called PMIC wrapper or pwrap. MT6397 MFD is a child device of the
> pwrap.
> 
> Signed-off-by: Flora Fu, MediaTek
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/mfd/mt6397.txt |  70 +++++

This should be submitted seperately, as per:

  Documentation/devicetree/bindings/submitting-patches.txt

>  drivers/mfd/Kconfig                              |  10 +
>  drivers/mfd/Makefile                             |   1 +
>  drivers/mfd/mt6397-core.c                        | 251 ++++++++++++++++
>  include/linux/mfd/mt6397/core.h                  |  76 +++++
>  include/linux/mfd/mt6397/registers.h             | 362 +++++++++++++++++++++++
>  6 files changed, 770 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/mt6397.txt
>  create mode 100644 drivers/mfd/mt6397-core.c
>  create mode 100644 include/linux/mfd/mt6397/core.h
>  create mode 100644 include/linux/mfd/mt6397/registers.h
> 
> diff --git a/Documentation/devicetree/bindings/mfd/mt6397.txt b/Documentation/devicetree/bindings/mfd/mt6397.txt
> new file mode 100644
> index 0000000..25b40a6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/mt6397.txt
> @@ -0,0 +1,70 @@
> +MediaTek MT6397 Multifunction Device Driver
> +
> +MT6397 is a multifunction device with the following sub modules:
> +- Regulator
> +- RTC
> +- Audio codec
> +- GPIO
> +- Clock
> +
> +It is interfaced to host controller using SPI interface by a proprietary hardware
> +called PMIC wrapper or pwrap. MT6397 MFD is a child device of pwrap.
> +See the following for pwarp node definitions:
> +Documentation/devicetree/bindings/soc/pwrap.txt
> +
> +This document describes the binding for mfd device and its sub module.

Nit: s/mfd/MFD/

> +Required properties:
> +compatible: "mediatek,mt6397"
> +
> +Optional subnodes:
> +
> +- rtc:
> +	Required properties:
> +		- compatible: "mediatek,mt6397-rtc",
> +- regulators
> +	Required properties:
> +		- compatible: "mediatek,mt6397-regulator",
> +	see Documentation/devicetree/bindings/regulator/mt6397-regulator.txt
> +- codec
> +	Required properties:
> +		- compatible: "mediatek,mt6397-codec",
> +- clk
> +	Required properties:
> +		- compatible: "mediatek,mt6397-clk",

Nit: Titles with or without ':', as long as it's consistent.

Drop the comma at the end of each compatible line.

> +Example:
> +	pwrap: pwrap@1000f000 {
> +		compatible = "mediatek,mt8135-pwrap";
> +
> +		...
> +
> +		pmic {
> +			compatible = "mediatek,mt6397";
> +
> +			codec: mt6397codec {
> +				compatible = "mediatek,mt6397-codec";
> +			};
> +
> +			mt6397regulator: mt6397regulator {

s/mt6397regulator/regulator/

> +				compatible = "mediatek,mt6397-regulator";
> +
> +				mt6397_vpca15_reg: buck_vpca15 {
> +					regulator-compatible = "buck_vpca15";
> +					regulator-name = "vpca15";
> +					regulator-min-microvolt = < 850000>;

Attention to detail, whitespace.

> +					regulator-max-microvolt = <1400000>;
> +					regulator-ramp-delay = <12500>;
> +					regulator-always-on;
> +				};
> +
> +				mt6397_vgp4_reg: ldo_vgp4 {
> +					regulator-compatible = "ldo_vgp4";
> +					regulator-name = "vgp4";
> +					regulator-min-microvolt = <1200000>;
> +					regulator-max-microvolt = <3300000>;
> +					regulator-enable-ramp-delay = <218>;
> +				};
> +			};
> +		};
> +	};
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 2e6b731..7782e95 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -489,6 +489,16 @@ config MFD_MAX8998
>  	  additional drivers must be enabled in order to use the functionality
>  	  of the device.
>  
> +config MFD_MT6397
> +	tristate "MediaTek MT6397 PMIC Support"
> +	select MFD_CORE
> +	select IRQ_DOMAIN
> +	help
> +	  Say yes here to add support for MediaTek MT6397 PMIC. This is
> +	  a Power Management IC. This driver provides common support for
> +	  accessing the device; additional drivers must be enabled in order
> +	  to use the functionality of the device.
> +
>  config MFD_MENF21BMC
>  	tristate "MEN 14F021P00 Board Management Controller Support"
>  	depends on I2C
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 53467e2..329d4ed 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -179,3 +179,4 @@ obj-$(CONFIG_MFD_DLN2)		+= dln2.o
>  
>  intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
>  obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
> +obj-$(CONFIG_MFD_MT6397)	+= mt6397-core.o
> diff --git a/drivers/mfd/mt6397-core.c b/drivers/mfd/mt6397-core.c
> new file mode 100644
> index 0000000..9710fca
> --- /dev/null
> +++ b/drivers/mfd/mt6397-core.c
> @@ -0,0 +1,251 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: Flora Fu, MediaTek

Email address?

> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/of_irq.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/mt6397/core.h>
> +#include <linux/mfd/mt6397/registers.h>
> +
> +static const struct mfd_cell mt6397_devs[] = {
> +	{
> +		.name = "mt6397-rtc",
> +		.of_compatible = "mediatek,mt6397-rtc",
> +	}, {
> +		.name = "mt6397-regulator",
> +		.of_compatible = "mediatek,mt6397-regulator",
> +	}, {
> +		.name = "mt6397-codec",
> +		.of_compatible = "mediatek,mt6397-codec",
> +	}, {
> +		.name = "mt6397-clk",
> +		.of_compatible = "mediatek,mt6397-clk",
> +	},
> +};
> +
> +static inline u32 mt6397_irq_shift(int irq)
> +{
> +	return irq & 0xf;
> +}
> +
> +static inline u32 mt6397_irq_reg(int irq)
> +{
> +	return irq >> 4;
> +}
> +
> +static void mt6397_irq_lock(struct irq_data *data)
> +{
> +	struct mt6397_chip *mt6397 = irq_get_chip_data(data->irq);
> +
> +	mutex_lock(&mt6397->irqlock);
> +}
> +
> +static void mt6397_irq_sync_unlock(struct irq_data *data)
> +{
> +	int i;
> +	struct mt6397_chip *mt6397 = irq_get_chip_data(data->irq);
> +
> +	regmap_write(mt6397->regmap, MT6397_INT_CON0, mt6397->irq_masks_cur[0]);
> +	regmap_write(mt6397->regmap, MT6397_INT_CON1, mt6397->irq_masks_cur[1]);
> +
> +	mutex_unlock(&mt6397->irqlock);
> +}
> +
> +static void mt6397_irq_mask(struct irq_data *data)
> +{
> +	struct mt6397_chip *mt6397 = irq_get_chip_data(data->irq);
> +	int shift = mt6397_irq_shift(data->hwirq);
> +	int reg = mt6397_irq_reg(data->hwirq);
> +	int reg_ofs = MT6397_INT_CON0 + reg * 2;
> +
> +	mt6397->irq_masks_cur[reg] &= ~(1 << shift);

s/(1 << shift)/BIT(shift)/

> +	regmap_write(mt6397->regmap, reg_ofs, mt6397->irq_masks_cur[reg]);
> +}
> +
> +static void mt6397_irq_unmask(struct irq_data *data)
> +{
> +	struct mt6397_chip *mt6397 = irq_get_chip_data(data->irq);
> +	int shift = mt6397_irq_shift(data->hwirq);
> +	int reg = mt6397_irq_reg(data->hwirq);
> +	int reg_ofs = MT6397_INT_CON0 + reg * 2;
> +
> +	mt6397->irq_masks_cur[reg] |= (1 << shift);

As above.

> +	regmap_write(mt6397->regmap, reg_ofs, mt6397->irq_masks_cur[reg]);
> +}
> +
> +static void mt6397_irq_ack(struct irq_data *data)
> +{
> +	struct mt6397_chip *mt6397 = irq_get_chip_data(data->irq);
> +	int shift = mt6397_irq_shift(data->hwirq);
> +	int reg = mt6397_irq_reg(data->hwirq);
> +	int reg_ofs = MT6397_INT_STATUS0 + reg * 2;
> +
> +	regmap_write(mt6397->regmap, reg_ofs, 1 << shift);

Etc etc...

> +}
> +
> +static struct irq_chip mt6397_irq_chip = {
> +	.name = "mt6397-irq",
> +	.irq_bus_lock = mt6397_irq_lock,
> +	.irq_bus_sync_unlock = mt6397_irq_sync_unlock,
> +	.irq_mask = mt6397_irq_mask,
> +	.irq_unmask = mt6397_irq_unmask,
> +	.irq_ack = mt6397_irq_ack,
> +};
> +
> +static irqreturn_t mt6397_irq_thread(int irq, void *data)
> +{
> +	struct mt6397_chip *mt6397 = data;
> +	int irq_reg[MT6397_IRQ_GROUP_NR];
> +	int i, cur_irq, ret;
> +
> +	for (i = 0; i < MT6397_IRQ_GROUP_NR; i++) {
> +		ret = regmap_read(mt6397->regmap,
> +			MT6397_INT_STATUS0 + i * 2, &irq_reg[i]);
> +		if (ret > 0) {

Can regmap_read() return <0?

> +			dev_err(mt6397->dev,
> +				"failed to read interrupt status [0x%x]\n",
> +				MT6397_INT_STATUS0 + i * 2);
> +			return IRQ_NONE;
> +		}
> +	}
> +
> +	for (i = 0; i < MT6397_IRQ_NR; i++) {
> +		int shift = mt6397_irq_shift(i);
> +		int reg = mt6397_irq_reg(i);
> +		int reg_ofs = MT6397_INT_STATUS0 + reg * 2;
> +
> +		if (irq_reg[reg] & (1 << shift)) {
> +			cur_irq = irq_find_mapping(mt6397->irq_domain, i);
> +			if (cur_irq)
> +				handle_nested_irq(cur_irq);
> +
> +			/* write 1 to status bit to clear the event.  */

There are very few comments in the driver and _this_ is where it was
felt appropriate to do so?  If you put "MT6397_INT_STATUS0 + reg * 2"
directly into the call, the line will speak for itself.

Nit: There are also some whitespace issues going on.

> +			regmap_write(mt6397->regmap, reg_ofs, 1 << shift);
> +		}
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int mt6397_irq_domain_map(struct irq_domain *d, unsigned int irq,
> +					irq_hw_number_t hw)
> +{
> +	struct mt6397_chip *mt6397 = d->host_data;
> +
> +	irq_set_chip_data(irq, mt6397);
> +	irq_set_chip_and_handler(irq, &mt6397_irq_chip, handle_level_irq);
> +	irq_set_nested_thread(irq, 1);
> +	set_irq_flags(irq, IRQF_VALID);
> +
> +	return 0;
> +}
> +
> +static struct irq_domain_ops mt6397_irq_domain_ops = {
> +	.map = mt6397_irq_domain_map,
> +};
> +
> +static int mt6397_irq_init(struct mt6397_chip *mt6397)
> +{
> +	int ret;
> +
> +	mutex_init(&mt6397->irqlock);
> +
> +	/* Mask all interrupt sources */
> +	regmap_write(mt6397->regmap, MT6397_INT_CON0, 0x0);
> +	regmap_write(mt6397->regmap, MT6397_INT_CON1, 0x0);
> +
> +	mt6397->irq_domain = irq_domain_add_linear(mt6397->dev->of_node,
> +		MT6397_IRQ_NR, &mt6397_irq_domain_ops, mt6397);
> +	if (!mt6397->irq_domain) {
> +		dev_err(mt6397->dev, "could not create irq domain\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret = devm_request_threaded_irq(mt6397->dev, mt6397->irq, NULL,
> +		mt6397_irq_thread, IRQF_ONESHOT, "mt6397-pmic", mt6397);
> +	if (ret) {
> +		dev_err(mt6397->dev, "failed to register irq=%d; err: %d\n",
> +			mt6397->irq, ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mt6397_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct mt6397_chip *mt6397;
> +
> +	mt6397 = devm_kzalloc(&pdev->dev, sizeof(*mt6397), GFP_KERNEL);
> +	if (!mt6397)
> +		return -ENOMEM;
> +
> +	mt6397->dev = &pdev->dev;
> +	/*
> +	 * mt6397 MFD is child device of soc pmic wrapper.
> +	 * Regmap is set from its parent.
> +	 */
> +	mt6397->regmap = dev_get_regmap(pdev->dev.parent, NULL);
> +	if (!mt6397->regmap)
> +		return -ENODEV;
> +
> +	platform_set_drvdata(pdev, mt6397);
> +
> +	mt6397->irq = platform_get_irq(pdev, 0);
> +	if (mt6397->irq > 0) {
> +		ret = mt6397_irq_init(mt6397);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = mfd_add_devices(&pdev->dev, -1, mt6397_devs,
> +			ARRAY_SIZE(mt6397_devs), NULL, 0, NULL);
> +	if (ret)
> +		dev_err(&pdev->dev, "failed to add child devices: %d\n", ret);
> +
> +	return ret;
> +}
> +
> +static int mt6397_remove(struct platform_device *pdev)
> +{
> +	mfd_remove_devices(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id mt6397_of_match[] = {
> +	{ .compatible = "mediatek,mt6397" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, mt6397_of_match);
> +
> +static struct platform_driver mt6397_driver = {
> +	.probe = mt6397_probe,
> +	.remove = mt6397_remove,
> +	.driver = {
> +		.name = "mt6397",
> +		.of_match_table = of_match_ptr(mt6397_of_match),
> +	},
> +};
> +
> +module_platform_driver(mt6397_driver);
> +
> +MODULE_AUTHOR("Flora Fu, MediaTek");

Email.

> +MODULE_DESCRIPTION("Driver for MediaTek MT6397 PMIC");
> +MODULE_LICENSE("GPL");

GPL v2

> +MODULE_ALIAS("platform:mt6397");
> diff --git a/include/linux/mfd/mt6397/core.h b/include/linux/mfd/mt6397/core.h
> new file mode 100644
> index 0000000..fa8fe24
> --- /dev/null
> +++ b/include/linux/mfd/mt6397/core.h
> @@ -0,0 +1,76 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: Flora Fu, MediaTek
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MFD_MT6397_CORE_H__
> +#define __MFD_MT6397_CORE_H__
> +
> +enum PMIC_INT_CON_GRP {
> +	GRP_INT_CON0 = 0,
> +	GRP_INT_CON1,
> +	MT6397_IRQ_GROUP_NR,
> +};
> +
> +enum PMIC_INT_STATUS_GRP {
> +	GRP_INT_STATUS0 = 0,
> +	GRP_INT_STATUS1,
> +	MT6397_IRQ_STATUS_GROUP_NR,
> +};
> +
> +enum PMIC_INT_STATUS {
> +	RG_INT_STATUS_SPKL_AB = 0,
> +	RG_INT_STATUS_SPKR_AB,
> +	RG_INT_STATUS_SPKL,
> +	RG_INT_STATUS_SPKR,
> +	RG_INT_STATUS_BAT_L,
> +	RG_INT_STATUS_BAT_H,
> +	RG_INT_STATUS_FG_BAT_L,
> +	RG_INT_STATUS_FG_BAT_H,
> +	RG_INT_STATUS_WATCHDOG,
> +	RG_INT_STATUS_PWRKEY,
> +	RG_INT_STATUS_THR_L,
> +	RG_INT_STATUS_THR_H,
> +	RG_INT_STATUS_VBATON_UNDET,
> +	RG_INT_STATUS_BVALID_DET,
> +	RG_INT_STATUS_CHRDET,
> +	RG_INT_STATUS_OV,
> +	RG_INT_STATUS_LDO,
> +	RG_INT_STATUS_HOMEKEY,
> +	RG_INT_STATUS_ACCDET,
> +	RG_INT_STATUS_AUDIO,
> +	RG_INT_STATUS_RTC,
> +	RG_INT_STATUS_PWRKEY_RSTB,
> +	RG_INT_STATUS_HDMI_SIFM,
> +	RG_INT_STATUS_HDMI_CEC,
> +	RG_INT_STATUS_VCA15,
> +	RG_INT_STATUS_VSRMCA15,
> +	RG_INT_STATUS_VCORE,
> +	RG_INT_STATUS_VGPU,
> +	RG_INT_STATUS_VIO18,
> +	RG_INT_STATUS_VPCA7,
> +	RG_INT_STATUS_VSRMCA7,
> +	RG_INT_STATUS_VDRM,
> +	MT6397_IRQ_NR,
> +};
> +
> +struct mt6397_chip {
> +	struct device *dev;
> +	struct regmap *regmap;
> +	struct irq_domain *irq_domain;
> +	struct mutex irqlock;
> +	int irq;
> +	u16 irq_masks_cur[MT6397_IRQ_GROUP_NR];
> +	u16 irq_masks_cache[MT6397_IRQ_GROUP_NR];
> +};
> +
> +#endif /* __MFD_MT6397_CORE_H__ */
> diff --git a/include/linux/mfd/mt6397/registers.h b/include/linux/mfd/mt6397/registers.h
> new file mode 100644
> index 0000000..f23a0a6
> --- /dev/null
> +++ b/include/linux/mfd/mt6397/registers.h
> @@ -0,0 +1,362 @@
> +/*
> + * Copyright (c) 2014 MediaTek Inc.
> + * Author: Flora Fu, MediaTek
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MFD_MT6397_REGISTERS_H__
> +#define __MFD_MT6397_REGISTERS_H__
> +
> +/* PMIC Registers */
> +#define MT6397_CID			0x0100
> +#define MT6397_TOP_CKPDN		0x0102
> +#define MT6397_TOP_CKPDN_SET		0x0104
> +#define MT6397_TOP_CKPDN_CLR		0x0106
> +#define MT6397_TOP_CKPDN2		0x0108
> +#define MT6397_TOP_CKPDN2_SET		0x010A
> +#define MT6397_TOP_CKPDN2_CLR		0x010C
> +#define MT6397_TOP_GPIO_CKPDN		0x010E
> +#define MT6397_TOP_RST_CON		0x0114
> +#define MT6397_WRP_CKPDN		0x011A
> +#define MT6397_WRP_RST_CON		0x0120
> +#define MT6397_TOP_RST_MISC		0x0126
> +#define MT6397_TOP_CKCON1		0x0128
> +#define MT6397_TOP_CKCON2		0x012A
> +#define MT6397_TOP_CKTST1		0x012C
> +#define MT6397_TOP_CKTST2		0x012E
> +#define MT6397_OC_DEG_EN		0x0130
> +#define MT6397_OC_CTL0			0x0132
> +#define MT6397_OC_CTL1			0x0134
> +#define MT6397_OC_CTL2			0x0136
> +#define MT6397_INT_RSV			0x0138
> +#define MT6397_TEST_CON0		0x013A
> +#define MT6397_TEST_CON1		0x013C
> +#define MT6397_STATUS0			0x013E
> +#define MT6397_STATUS1			0x0140
> +#define MT6397_PGSTATUS			0x0142
> +#define MT6397_CHRSTATUS		0x0144
> +#define MT6397_OCSTATUS0		0x0146
> +#define MT6397_OCSTATUS1		0x0148
> +#define MT6397_OCSTATUS2		0x014A
> +#define MT6397_HDMI_PAD_IE		0x014C
> +#define MT6397_TEST_OUT_L		0x014E
> +#define MT6397_TEST_OUT_H		0x0150
> +#define MT6397_TDSEL_CON		0x0152
> +#define MT6397_RDSEL_CON		0x0154
> +#define MT6397_GPIO_SMT_CON0		0x0156
> +#define MT6397_GPIO_SMT_CON1		0x0158
> +#define MT6397_GPIO_SMT_CON2		0x015A
> +#define MT6397_GPIO_SMT_CON3		0x015C
> +#define MT6397_DRV_CON0			0x015E
> +#define MT6397_DRV_CON1			0x0160
> +#define MT6397_DRV_CON2			0x0162
> +#define MT6397_DRV_CON3			0x0164
> +#define MT6397_DRV_CON4			0x0166
> +#define MT6397_DRV_CON5			0x0168
> +#define MT6397_DRV_CON6			0x016A
> +#define MT6397_DRV_CON7			0x016C
> +#define MT6397_DRV_CON8			0x016E
> +#define MT6397_DRV_CON9			0x0170
> +#define MT6397_DRV_CON10		0x0172
> +#define MT6397_DRV_CON11		0x0174
> +#define MT6397_DRV_CON12		0x0176
> +#define MT6397_INT_CON0			0x0178
> +#define MT6397_INT_CON1			0x017E
> +#define MT6397_INT_STATUS0		0x0184
> +#define MT6397_INT_STATUS1		0x0186
> +#define MT6397_FQMTR_CON0		0x0188
> +#define MT6397_FQMTR_CON1		0x018A
> +#define MT6397_FQMTR_CON2		0x018C
> +#define MT6397_EFUSE_DOUT_0_15		0x01C4
> +#define MT6397_EFUSE_DOUT_16_31		0x01C6
> +#define MT6397_EFUSE_DOUT_32_47		0x01C8
> +#define MT6397_EFUSE_DOUT_48_63		0x01CA
> +#define MT6397_SPI_CON			0x01CC
> +#define MT6397_TOP_CKPDN3		0x01CE
> +#define MT6397_TOP_CKCON3		0x01D4
> +#define MT6397_EFUSE_DOUT_64_79		0x01D6
> +#define MT6397_EFUSE_DOUT_80_95		0x01D8
> +#define MT6397_EFUSE_DOUT_96_111	0x01DA
> +#define MT6397_EFUSE_DOUT_112_127	0x01DC
> +#define MT6397_EFUSE_DOUT_128_143	0x01DE
> +#define MT6397_EFUSE_DOUT_144_159	0x01E0
> +#define MT6397_EFUSE_DOUT_160_175	0x01E2
> +#define MT6397_EFUSE_DOUT_176_191	0x01E4
> +#define MT6397_EFUSE_DOUT_192_207	0x01E6
> +#define MT6397_EFUSE_DOUT_208_223	0x01E8
> +#define MT6397_EFUSE_DOUT_224_239	0x01EA
> +#define MT6397_EFUSE_DOUT_240_255	0x01EC
> +#define MT6397_EFUSE_DOUT_256_271	0x01EE
> +#define MT6397_EFUSE_DOUT_272_287	0x01F0
> +#define MT6397_EFUSE_DOUT_288_300	0x01F2
> +#define MT6397_EFUSE_DOUT_304_319	0x01F4
> +#define MT6397_BUCK_CON0		0x0200
> +#define MT6397_BUCK_CON1		0x0202
> +#define MT6397_BUCK_CON2		0x0204
> +#define MT6397_BUCK_CON3		0x0206
> +#define MT6397_BUCK_CON4		0x0208
> +#define MT6397_BUCK_CON5		0x020A
> +#define MT6397_BUCK_CON6		0x020C
> +#define MT6397_BUCK_CON7		0x020E
> +#define MT6397_BUCK_CON8		0x0210
> +#define MT6397_BUCK_CON9		0x0212
> +#define MT6397_VCA15_CON0		0x0214
> +#define MT6397_VCA15_CON1		0x0216
> +#define MT6397_VCA15_CON2		0x0218
> +#define MT6397_VCA15_CON3		0x021A
> +#define MT6397_VCA15_CON4		0x021C
> +#define MT6397_VCA15_CON5		0x021E
> +#define MT6397_VCA15_CON6		0x0220
> +#define MT6397_VCA15_CON7		0x0222
> +#define MT6397_VCA15_CON8		0x0224
> +#define MT6397_VCA15_CON9		0x0226
> +#define MT6397_VCA15_CON10		0x0228
> +#define MT6397_VCA15_CON11		0x022A
> +#define MT6397_VCA15_CON12		0x022C
> +#define MT6397_VCA15_CON13		0x022E
> +#define MT6397_VCA15_CON14		0x0230
> +#define MT6397_VCA15_CON15		0x0232
> +#define MT6397_VCA15_CON16		0x0234
> +#define MT6397_VCA15_CON17		0x0236
> +#define MT6397_VCA15_CON18		0x0238
> +#define MT6397_VSRMCA15_CON0		0x023A
> +#define MT6397_VSRMCA15_CON1		0x023C
> +#define MT6397_VSRMCA15_CON2		0x023E
> +#define MT6397_VSRMCA15_CON3		0x0240
> +#define MT6397_VSRMCA15_CON4		0x0242
> +#define MT6397_VSRMCA15_CON5		0x0244
> +#define MT6397_VSRMCA15_CON6		0x0246
> +#define MT6397_VSRMCA15_CON7		0x0248
> +#define MT6397_VSRMCA15_CON8		0x024A
> +#define MT6397_VSRMCA15_CON9		0x024C
> +#define MT6397_VSRMCA15_CON10		0x024E
> +#define MT6397_VSRMCA15_CON11		0x0250
> +#define MT6397_VSRMCA15_CON12		0x0252
> +#define MT6397_VSRMCA15_CON13		0x0254
> +#define MT6397_VSRMCA15_CON14		0x0256
> +#define MT6397_VSRMCA15_CON15		0x0258
> +#define MT6397_VSRMCA15_CON16		0x025A
> +#define MT6397_VSRMCA15_CON17		0x025C
> +#define MT6397_VSRMCA15_CON18		0x025E
> +#define MT6397_VSRMCA15_CON19		0x0260
> +#define MT6397_VSRMCA15_CON20		0x0262
> +#define MT6397_VSRMCA15_CON21		0x0264
> +#define MT6397_VCORE_CON0		0x0266
> +#define MT6397_VCORE_CON1		0x0268
> +#define MT6397_VCORE_CON2		0x026A
> +#define MT6397_VCORE_CON3		0x026C
> +#define MT6397_VCORE_CON4		0x026E
> +#define MT6397_VCORE_CON5		0x0270
> +#define MT6397_VCORE_CON6		0x0272
> +#define MT6397_VCORE_CON7		0x0274
> +#define MT6397_VCORE_CON8		0x0276
> +#define MT6397_VCORE_CON9		0x0278
> +#define MT6397_VCORE_CON10		0x027A
> +#define MT6397_VCORE_CON11		0x027C
> +#define MT6397_VCORE_CON12		0x027E
> +#define MT6397_VCORE_CON13		0x0280
> +#define MT6397_VCORE_CON14		0x0282
> +#define MT6397_VCORE_CON15		0x0284
> +#define MT6397_VCORE_CON16		0x0286
> +#define MT6397_VCORE_CON17		0x0288
> +#define MT6397_VCORE_CON18		0x028A
> +#define MT6397_VGPU_CON0		0x028C
> +#define MT6397_VGPU_CON1		0x028E
> +#define MT6397_VGPU_CON2		0x0290
> +#define MT6397_VGPU_CON3		0x0292
> +#define MT6397_VGPU_CON4		0x0294
> +#define MT6397_VGPU_CON5		0x0296
> +#define MT6397_VGPU_CON6		0x0298
> +#define MT6397_VGPU_CON7		0x029A
> +#define MT6397_VGPU_CON8		0x029C
> +#define MT6397_VGPU_CON9		0x029E
> +#define MT6397_VGPU_CON10		0x02A0
> +#define MT6397_VGPU_CON11		0x02A2
> +#define MT6397_VGPU_CON12		0x02A4
> +#define MT6397_VGPU_CON13		0x02A6
> +#define MT6397_VGPU_CON14		0x02A8
> +#define MT6397_VGPU_CON15		0x02AA
> +#define MT6397_VGPU_CON16		0x02AC
> +#define MT6397_VGPU_CON17		0x02AE
> +#define MT6397_VGPU_CON18		0x02B0
> +#define MT6397_VIO18_CON0		0x0300
> +#define MT6397_VIO18_CON1		0x0302
> +#define MT6397_VIO18_CON2		0x0304
> +#define MT6397_VIO18_CON3		0x0306
> +#define MT6397_VIO18_CON4		0x0308
> +#define MT6397_VIO18_CON5		0x030A
> +#define MT6397_VIO18_CON6		0x030C
> +#define MT6397_VIO18_CON7		0x030E
> +#define MT6397_VIO18_CON8		0x0310
> +#define MT6397_VIO18_CON9		0x0312
> +#define MT6397_VIO18_CON10		0x0314
> +#define MT6397_VIO18_CON11		0x0316
> +#define MT6397_VIO18_CON12		0x0318
> +#define MT6397_VIO18_CON13		0x031A
> +#define MT6397_VIO18_CON14		0x031C
> +#define MT6397_VIO18_CON15		0x031E
> +#define MT6397_VIO18_CON16		0x0320
> +#define MT6397_VIO18_CON17		0x0322
> +#define MT6397_VIO18_CON18		0x0324
> +#define MT6397_VPCA7_CON0		0x0326
> +#define MT6397_VPCA7_CON1		0x0328
> +#define MT6397_VPCA7_CON2		0x032A
> +#define MT6397_VPCA7_CON3		0x032C
> +#define MT6397_VPCA7_CON4		0x032E
> +#define MT6397_VPCA7_CON5		0x0330
> +#define MT6397_VPCA7_CON6		0x0332
> +#define MT6397_VPCA7_CON7		0x0334
> +#define MT6397_VPCA7_CON8		0x0336
> +#define MT6397_VPCA7_CON9		0x0338
> +#define MT6397_VPCA7_CON10		0x033A
> +#define MT6397_VPCA7_CON11		0x033C
> +#define MT6397_VPCA7_CON12		0x033E
> +#define MT6397_VPCA7_CON13		0x0340
> +#define MT6397_VPCA7_CON14		0x0342
> +#define MT6397_VPCA7_CON15		0x0344
> +#define MT6397_VPCA7_CON16		0x0346
> +#define MT6397_VPCA7_CON17		0x0348
> +#define MT6397_VPCA7_CON18		0x034A
> +#define MT6397_VSRMCA7_CON0		0x034C
> +#define MT6397_VSRMCA7_CON1		0x034E
> +#define MT6397_VSRMCA7_CON2		0x0350
> +#define MT6397_VSRMCA7_CON3		0x0352
> +#define MT6397_VSRMCA7_CON4		0x0354
> +#define MT6397_VSRMCA7_CON5		0x0356
> +#define MT6397_VSRMCA7_CON6		0x0358
> +#define MT6397_VSRMCA7_CON7		0x035A
> +#define MT6397_VSRMCA7_CON8		0x035C
> +#define MT6397_VSRMCA7_CON9		0x035E
> +#define MT6397_VSRMCA7_CON10		0x0360
> +#define MT6397_VSRMCA7_CON11		0x0362
> +#define MT6397_VSRMCA7_CON12		0x0364
> +#define MT6397_VSRMCA7_CON13		0x0366
> +#define MT6397_VSRMCA7_CON14		0x0368
> +#define MT6397_VSRMCA7_CON15		0x036A
> +#define MT6397_VSRMCA7_CON16		0x036C
> +#define MT6397_VSRMCA7_CON17		0x036E
> +#define MT6397_VSRMCA7_CON18		0x0370
> +#define MT6397_VSRMCA7_CON19		0x0372
> +#define MT6397_VSRMCA7_CON20		0x0374
> +#define MT6397_VSRMCA7_CON21		0x0376
> +#define MT6397_VDRM_CON0		0x0378
> +#define MT6397_VDRM_CON1		0x037A
> +#define MT6397_VDRM_CON2		0x037C
> +#define MT6397_VDRM_CON3		0x037E
> +#define MT6397_VDRM_CON4		0x0380
> +#define MT6397_VDRM_CON5		0x0382
> +#define MT6397_VDRM_CON6		0x0384
> +#define MT6397_VDRM_CON7		0x0386
> +#define MT6397_VDRM_CON8		0x0388
> +#define MT6397_VDRM_CON9		0x038A
> +#define MT6397_VDRM_CON10		0x038C
> +#define MT6397_VDRM_CON11		0x038E
> +#define MT6397_VDRM_CON12		0x0390
> +#define MT6397_VDRM_CON13		0x0392
> +#define MT6397_VDRM_CON14		0x0394
> +#define MT6397_VDRM_CON15		0x0396
> +#define MT6397_VDRM_CON16		0x0398
> +#define MT6397_VDRM_CON17		0x039A
> +#define MT6397_VDRM_CON18		0x039C
> +#define MT6397_BUCK_K_CON0		0x039E
> +#define MT6397_BUCK_K_CON1		0x03A0
> +#define MT6397_ANALDO_CON0		0x0400
> +#define MT6397_ANALDO_CON1		0x0402
> +#define MT6397_ANALDO_CON2		0x0404
> +#define MT6397_ANALDO_CON3		0x0406
> +#define MT6397_ANALDO_CON4		0x0408
> +#define MT6397_ANALDO_CON5		0x040A
> +#define MT6397_ANALDO_CON6		0x040C
> +#define MT6397_ANALDO_CON7		0x040E
> +#define MT6397_DIGLDO_CON0		0x0410
> +#define MT6397_DIGLDO_CON1		0x0412
> +#define MT6397_DIGLDO_CON2		0x0414
> +#define MT6397_DIGLDO_CON3		0x0416
> +#define MT6397_DIGLDO_CON4		0x0418
> +#define MT6397_DIGLDO_CON5		0x041A
> +#define MT6397_DIGLDO_CON6		0x041C
> +#define MT6397_DIGLDO_CON7		0x041E
> +#define MT6397_DIGLDO_CON8		0x0420
> +#define MT6397_DIGLDO_CON9		0x0422
> +#define MT6397_DIGLDO_CON10		0x0424
> +#define MT6397_DIGLDO_CON11		0x0426
> +#define MT6397_DIGLDO_CON12		0x0428
> +#define MT6397_DIGLDO_CON13		0x042A
> +#define MT6397_DIGLDO_CON14		0x042C
> +#define MT6397_DIGLDO_CON15		0x042E
> +#define MT6397_DIGLDO_CON16		0x0430
> +#define MT6397_DIGLDO_CON17		0x0432
> +#define MT6397_DIGLDO_CON18		0x0434
> +#define MT6397_DIGLDO_CON19		0x0436
> +#define MT6397_DIGLDO_CON20		0x0438
> +#define MT6397_DIGLDO_CON21		0x043A
> +#define MT6397_DIGLDO_CON22		0x043C
> +#define MT6397_DIGLDO_CON23		0x043E
> +#define MT6397_DIGLDO_CON24		0x0440
> +#define MT6397_DIGLDO_CON25		0x0442
> +#define MT6397_DIGLDO_CON26		0x0444
> +#define MT6397_DIGLDO_CON27		0x0446
> +#define MT6397_DIGLDO_CON28		0x0448
> +#define MT6397_DIGLDO_CON29		0x044A
> +#define MT6397_DIGLDO_CON30		0x044C
> +#define MT6397_DIGLDO_CON31		0x044E
> +#define MT6397_DIGLDO_CON32		0x0450
> +#define MT6397_DIGLDO_CON33		0x045A
> +#define MT6397_SPK_CON0			0x0600
> +#define MT6397_SPK_CON1			0x0602
> +#define MT6397_SPK_CON2			0x0604
> +#define MT6397_SPK_CON3			0x0606
> +#define MT6397_SPK_CON4			0x0608
> +#define MT6397_SPK_CON5			0x060A
> +#define MT6397_SPK_CON6			0x060C
> +#define MT6397_SPK_CON7			0x060E
> +#define MT6397_SPK_CON8			0x0610
> +#define MT6397_SPK_CON9			0x0612
> +#define MT6397_SPK_CON10		0x0614
> +#define MT6397_SPK_CON11		0x0616
> +#define MT6397_AUDDAC_CON0		0x0700
> +#define MT6397_AUDBUF_CFG0		0x0702
> +#define MT6397_AUDBUF_CFG1		0x0704
> +#define MT6397_AUDBUF_CFG2		0x0706
> +#define MT6397_AUDBUF_CFG3		0x0708
> +#define MT6397_AUDBUF_CFG4		0x070A
> +#define MT6397_IBIASDIST_CFG0		0x070C
> +#define MT6397_AUDACCDEPOP_CFG0		0x070E
> +#define MT6397_AUD_IV_CFG0		0x0710
> +#define MT6397_AUDCLKGEN_CFG0		0x0712
> +#define MT6397_AUDLDO_CFG0		0x0714
> +#define MT6397_AUDLDO_CFG1		0x0716
> +#define MT6397_AUDNVREGGLB_CFG0		0x0718
> +#define MT6397_AUD_NCP0			0x071A
> +#define MT6397_AUDPREAMP_CON0		0x071C
> +#define MT6397_AUDADC_CON0		0x071E
> +#define MT6397_AUDADC_CON1		0x0720
> +#define MT6397_AUDADC_CON2		0x0722
> +#define MT6397_AUDADC_CON3		0x0724
> +#define MT6397_AUDADC_CON4		0x0726
> +#define MT6397_AUDADC_CON5		0x0728
> +#define MT6397_AUDADC_CON6		0x072A
> +#define MT6397_AUDDIGMI_CON0		0x072C
> +#define MT6397_AUDLSBUF_CON0		0x072E
> +#define MT6397_AUDLSBUF_CON1		0x0730
> +#define MT6397_AUDENCSPARE_CON0		0x0732
> +#define MT6397_AUDENCCLKSQ_CON0		0x0734
> +#define MT6397_AUDPREAMPGAIN_CON0	0x0736
> +#define MT6397_ZCD_CON0			0x0738
> +#define MT6397_ZCD_CON1			0x073A
> +#define MT6397_ZCD_CON2			0x073C
> +#define MT6397_ZCD_CON3			0x073E
> +#define MT6397_ZCD_CON4			0x0740
> +#define MT6397_ZCD_CON5			0x0742
> +#define MT6397_NCP_CLKDIV_CON0		0x0744
> +#define MT6397_NCP_CLKDIV_CON1		0x0746
> +
> +#endif /* __MFD_MT6397_REGISTERS_H__ */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
