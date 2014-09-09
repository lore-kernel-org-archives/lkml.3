Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaIIIL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:11:58 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:40386 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaIIILv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:11:51 -0400
Date: Tue, 9 Sep 2014 09:11:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH 1/4] mfd/axp20x: rename files to support more devices
Message-ID: <20140909081140.GH30307@lee--X1>
References: <1410215046-31751-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1410215046-31751-2-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410215046-31751-2-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2014, Jacob Pan wrote:

> More XPowers PMIC devices can be supported by extending this driver, so
> rename it to axp2xx to cover axp288 variant.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/mfd/Kconfig        |   7 +-
>  drivers/mfd/Makefile       |   2 +-
>  drivers/mfd/axp20x.c       | 258 ---------------------------------------------
>  drivers/mfd/axp2xx.c       | 258 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/axp20x.h | 180 -------------------------------
>  include/linux/mfd/axp2xx.h | 180 +++++++++++++++++++++++++++++++
>  6 files changed, 443 insertions(+), 442 deletions(-)
>  delete mode 100644 drivers/mfd/axp20x.c
>  create mode 100644 drivers/mfd/axp2xx.c
>  delete mode 100644 include/linux/mfd/axp20x.h
>  create mode 100644 include/linux/mfd/axp2xx.h

Please resubmit using `git format-patch -M`

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index de5abf2..42a70a3 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -67,14 +67,15 @@ config MFD_BCM590XX
>  	help
>  	  Support for the BCM590xx PMUs from Broadcom
>  
> -config MFD_AXP20X
> -	bool "X-Powers AXP20X"
> +config MFD_AXP2XX
> +	bool "X-Powers AXP2XX"
>  	select MFD_CORE
>  	select REGMAP_I2C
>  	select REGMAP_IRQ
>  	depends on I2C=y
>  	help
> -	  If you say Y here you get support for the X-Powers AXP202 and AXP209.
> +	  If you say Y here you get support for the X-Powers AXP202, AXP209 and
> +	  AXP288 power management IC (PMIC).
>  	  This driver include only the core APIs. You have to select individual
>  	  components like regulators or the PEK (Power Enable Key) under the
>  	  corresponding menus.
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f001487..55d76b3 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -103,7 +103,7 @@ obj-$(CONFIG_PMIC_DA9052)	+= da9052-irq.o
>  obj-$(CONFIG_PMIC_DA9052)	+= da9052-core.o
>  obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
>  obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
> -obj-$(CONFIG_MFD_AXP20X)	+= axp20x.o
> +obj-$(CONFIG_MFD_AXP2XX)	+= axp2xx.o
>  
>  obj-$(CONFIG_MFD_LP3943)	+= lp3943.o
>  obj-$(CONFIG_MFD_LP8788)	+= lp8788.o lp8788-irq.o
> diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
> deleted file mode 100644
> index dee6539..0000000
> --- a/drivers/mfd/axp20x.c
> +++ /dev/null
> @@ -1,258 +0,0 @@
> -/*
> - * axp20x.c - MFD core driver for the X-Powers AXP202 and AXP209
> - *
> - * AXP20x comprises an adaptive USB-Compatible PWM charger, 2 BUCK DC-DC
> - * converters, 5 LDOs, multiple 12-bit ADCs of voltage, current and temperature
> - * as well as 4 configurable GPIOs.
> - *
> - * Author: Carlo Caione <carlo@caione.org>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#include <linux/err.h>
> -#include <linux/i2c.h>
> -#include <linux/interrupt.h>
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/pm_runtime.h>
> -#include <linux/regmap.h>
> -#include <linux/slab.h>
> -#include <linux/regulator/consumer.h>
> -#include <linux/mfd/axp20x.h>
> -#include <linux/mfd/core.h>
> -#include <linux/of_device.h>
> -#include <linux/of_irq.h>
> -
> -#define AXP20X_OFF	0x80
> -
> -static const struct regmap_range axp20x_writeable_ranges[] = {
> -	regmap_reg_range(AXP20X_DATACACHE(0), AXP20X_IRQ5_STATE),
> -	regmap_reg_range(AXP20X_DCDC_MODE, AXP20X_FG_RES),
> -};
> -
> -static const struct regmap_range axp20x_volatile_ranges[] = {
> -	regmap_reg_range(AXP20X_IRQ1_EN, AXP20X_IRQ5_STATE),
> -};
> -
> -static const struct regmap_access_table axp20x_writeable_table = {
> -	.yes_ranges	= axp20x_writeable_ranges,
> -	.n_yes_ranges	= ARRAY_SIZE(axp20x_writeable_ranges),
> -};
> -
> -static const struct regmap_access_table axp20x_volatile_table = {
> -	.yes_ranges	= axp20x_volatile_ranges,
> -	.n_yes_ranges	= ARRAY_SIZE(axp20x_volatile_ranges),
> -};
> -
> -static struct resource axp20x_pek_resources[] = {
> -	{
> -		.name	= "PEK_DBR",
> -		.start	= AXP20X_IRQ_PEK_RIS_EDGE,
> -		.end	= AXP20X_IRQ_PEK_RIS_EDGE,
> -		.flags	= IORESOURCE_IRQ,
> -	}, {
> -		.name	= "PEK_DBF",
> -		.start	= AXP20X_IRQ_PEK_FAL_EDGE,
> -		.end	= AXP20X_IRQ_PEK_FAL_EDGE,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static const struct regmap_config axp20x_regmap_config = {
> -	.reg_bits	= 8,
> -	.val_bits	= 8,
> -	.wr_table	= &axp20x_writeable_table,
> -	.volatile_table	= &axp20x_volatile_table,
> -	.max_register	= AXP20X_FG_RES,
> -	.cache_type	= REGCACHE_RBTREE,
> -};
> -
> -#define AXP20X_IRQ(_irq, _off, _mask) \
> -	[AXP20X_IRQ_##_irq] = { .reg_offset = (_off), .mask = BIT(_mask) }
> -
> -static const struct regmap_irq axp20x_regmap_irqs[] = {
> -	AXP20X_IRQ(ACIN_OVER_V,		0, 7),
> -	AXP20X_IRQ(ACIN_PLUGIN,		0, 6),
> -	AXP20X_IRQ(ACIN_REMOVAL,	0, 5),
> -	AXP20X_IRQ(VBUS_OVER_V,		0, 4),
> -	AXP20X_IRQ(VBUS_PLUGIN,		0, 3),
> -	AXP20X_IRQ(VBUS_REMOVAL,	0, 2),
> -	AXP20X_IRQ(VBUS_V_LOW,		0, 1),
> -	AXP20X_IRQ(BATT_PLUGIN,		1, 7),
> -	AXP20X_IRQ(BATT_REMOVAL,	1, 6),
> -	AXP20X_IRQ(BATT_ENT_ACT_MODE,	1, 5),
> -	AXP20X_IRQ(BATT_EXIT_ACT_MODE,	1, 4),
> -	AXP20X_IRQ(CHARG,		1, 3),
> -	AXP20X_IRQ(CHARG_DONE,		1, 2),
> -	AXP20X_IRQ(BATT_TEMP_HIGH,	1, 1),
> -	AXP20X_IRQ(BATT_TEMP_LOW,	1, 0),
> -	AXP20X_IRQ(DIE_TEMP_HIGH,	2, 7),
> -	AXP20X_IRQ(CHARG_I_LOW,		2, 6),
> -	AXP20X_IRQ(DCDC1_V_LONG,	2, 5),
> -	AXP20X_IRQ(DCDC2_V_LONG,	2, 4),
> -	AXP20X_IRQ(DCDC3_V_LONG,	2, 3),
> -	AXP20X_IRQ(PEK_SHORT,		2, 1),
> -	AXP20X_IRQ(PEK_LONG,		2, 0),
> -	AXP20X_IRQ(N_OE_PWR_ON,		3, 7),
> -	AXP20X_IRQ(N_OE_PWR_OFF,	3, 6),
> -	AXP20X_IRQ(VBUS_VALID,		3, 5),
> -	AXP20X_IRQ(VBUS_NOT_VALID,	3, 4),
> -	AXP20X_IRQ(VBUS_SESS_VALID,	3, 3),
> -	AXP20X_IRQ(VBUS_SESS_END,	3, 2),
> -	AXP20X_IRQ(LOW_PWR_LVL1,	3, 1),
> -	AXP20X_IRQ(LOW_PWR_LVL2,	3, 0),
> -	AXP20X_IRQ(TIMER,		4, 7),
> -	AXP20X_IRQ(PEK_RIS_EDGE,	4, 6),
> -	AXP20X_IRQ(PEK_FAL_EDGE,	4, 5),
> -	AXP20X_IRQ(GPIO3_INPUT,		4, 3),
> -	AXP20X_IRQ(GPIO2_INPUT,		4, 2),
> -	AXP20X_IRQ(GPIO1_INPUT,		4, 1),
> -	AXP20X_IRQ(GPIO0_INPUT,		4, 0),
> -};
> -
> -static const struct of_device_id axp20x_of_match[] = {
> -	{ .compatible = "x-powers,axp202", .data = (void *) AXP202_ID },
> -	{ .compatible = "x-powers,axp209", .data = (void *) AXP209_ID },
> -	{ },
> -};
> -MODULE_DEVICE_TABLE(of, axp20x_of_match);
> -
> -/*
> - * This is useless for OF-enabled devices, but it is needed by I2C subsystem
> - */
> -static const struct i2c_device_id axp20x_i2c_id[] = {
> -	{ },
> -};
> -MODULE_DEVICE_TABLE(i2c, axp20x_i2c_id);
> -
> -static const struct regmap_irq_chip axp20x_regmap_irq_chip = {
> -	.name			= "axp20x_irq_chip",
> -	.status_base		= AXP20X_IRQ1_STATE,
> -	.ack_base		= AXP20X_IRQ1_STATE,
> -	.mask_base		= AXP20X_IRQ1_EN,
> -	.num_regs		= 5,
> -	.irqs			= axp20x_regmap_irqs,
> -	.num_irqs		= ARRAY_SIZE(axp20x_regmap_irqs),
> -	.mask_invert		= true,
> -	.init_ack_masked	= true,
> -};
> -
> -static const char * const axp20x_supplies[] = {
> -	"acin",
> -	"vin2",
> -	"vin3",
> -	"ldo24in",
> -	"ldo3in",
> -	"ldo5in",
> -};
> -
> -static struct mfd_cell axp20x_cells[] = {
> -	{
> -		.name			= "axp20x-pek",
> -		.num_resources		= ARRAY_SIZE(axp20x_pek_resources),
> -		.resources		= axp20x_pek_resources,
> -	}, {
> -		.name			= "axp20x-regulator",
> -		.parent_supplies	= axp20x_supplies,
> -		.num_parent_supplies	= ARRAY_SIZE(axp20x_supplies),
> -	},
> -};
> -
> -static struct axp20x_dev *axp20x_pm_power_off;
> -static void axp20x_power_off(void)
> -{
> -	regmap_write(axp20x_pm_power_off->regmap, AXP20X_OFF_CTRL,
> -		     AXP20X_OFF);
> -}
> -
> -static int axp20x_i2c_probe(struct i2c_client *i2c,
> -			 const struct i2c_device_id *id)
> -{
> -	struct axp20x_dev *axp20x;
> -	const struct of_device_id *of_id;
> -	int ret;
> -
> -	axp20x = devm_kzalloc(&i2c->dev, sizeof(*axp20x), GFP_KERNEL);
> -	if (!axp20x)
> -		return -ENOMEM;
> -
> -	of_id = of_match_device(axp20x_of_match, &i2c->dev);
> -	if (!of_id) {
> -		dev_err(&i2c->dev, "Unable to setup AXP20X data\n");
> -		return -ENODEV;
> -	}
> -	axp20x->variant = (long) of_id->data;
> -
> -	axp20x->i2c_client = i2c;
> -	axp20x->dev = &i2c->dev;
> -	dev_set_drvdata(axp20x->dev, axp20x);
> -
> -	axp20x->regmap = devm_regmap_init_i2c(i2c, &axp20x_regmap_config);
> -	if (IS_ERR(axp20x->regmap)) {
> -		ret = PTR_ERR(axp20x->regmap);
> -		dev_err(&i2c->dev, "regmap init failed: %d\n", ret);
> -		return ret;
> -	}
> -
> -	ret = regmap_add_irq_chip(axp20x->regmap, i2c->irq,
> -				  IRQF_ONESHOT | IRQF_SHARED, -1,
> -				  &axp20x_regmap_irq_chip,
> -				  &axp20x->regmap_irqc);
> -	if (ret) {
> -		dev_err(&i2c->dev, "failed to add irq chip: %d\n", ret);
> -		return ret;
> -	}
> -
> -	ret = mfd_add_devices(axp20x->dev, -1, axp20x_cells,
> -			      ARRAY_SIZE(axp20x_cells), NULL, 0, NULL);
> -
> -	if (ret) {
> -		dev_err(&i2c->dev, "failed to add MFD devices: %d\n", ret);
> -		regmap_del_irq_chip(i2c->irq, axp20x->regmap_irqc);
> -		return ret;
> -	}
> -
> -	if (!pm_power_off) {
> -		axp20x_pm_power_off = axp20x;
> -		pm_power_off = axp20x_power_off;
> -	}
> -
> -	dev_info(&i2c->dev, "AXP20X driver loaded\n");
> -
> -	return 0;
> -}
> -
> -static int axp20x_i2c_remove(struct i2c_client *i2c)
> -{
> -	struct axp20x_dev *axp20x = i2c_get_clientdata(i2c);
> -
> -	if (axp20x == axp20x_pm_power_off) {
> -		axp20x_pm_power_off = NULL;
> -		pm_power_off = NULL;
> -	}
> -
> -	mfd_remove_devices(axp20x->dev);
> -	regmap_del_irq_chip(axp20x->i2c_client->irq, axp20x->regmap_irqc);
> -
> -	return 0;
> -}
> -
> -static struct i2c_driver axp20x_i2c_driver = {
> -	.driver = {
> -		.name	= "axp20x",
> -		.owner	= THIS_MODULE,
> -		.of_match_table	= of_match_ptr(axp20x_of_match),
> -	},
> -	.probe		= axp20x_i2c_probe,
> -	.remove		= axp20x_i2c_remove,
> -	.id_table	= axp20x_i2c_id,
> -};
> -
> -module_i2c_driver(axp20x_i2c_driver);
> -
> -MODULE_DESCRIPTION("PMIC MFD core driver for AXP20X");
> -MODULE_AUTHOR("Carlo Caione <carlo@caione.org>");
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/mfd/axp2xx.c b/drivers/mfd/axp2xx.c
> new file mode 100644
> index 0000000..c534443
> --- /dev/null
> +++ b/drivers/mfd/axp2xx.c
> @@ -0,0 +1,258 @@
> +/*
> + * axp20x.c - MFD core driver for the X-Powers AXP202 and AXP209
> + *
> + * AXP20x comprises an adaptive USB-Compatible PWM charger, 2 BUCK DC-DC
> + * converters, 5 LDOs, multiple 12-bit ADCs of voltage, current and temperature
> + * as well as 4 configurable GPIOs.
> + *
> + * Author: Carlo Caione <carlo@caione.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/regmap.h>
> +#include <linux/slab.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/mfd/axp2xx.h>
> +#include <linux/mfd/core.h>
> +#include <linux/of_device.h>
> +#include <linux/of_irq.h>
> +
> +#define AXP20X_OFF	0x80
> +
> +static const struct regmap_range axp20x_writeable_ranges[] = {
> +	regmap_reg_range(AXP20X_DATACACHE(0), AXP20X_IRQ5_STATE),
> +	regmap_reg_range(AXP20X_DCDC_MODE, AXP20X_FG_RES),
> +};
> +
> +static const struct regmap_range axp20x_volatile_ranges[] = {
> +	regmap_reg_range(AXP20X_IRQ1_EN, AXP20X_IRQ5_STATE),
> +};
> +
> +static const struct regmap_access_table axp20x_writeable_table = {
> +	.yes_ranges	= axp20x_writeable_ranges,
> +	.n_yes_ranges	= ARRAY_SIZE(axp20x_writeable_ranges),
> +};
> +
> +static const struct regmap_access_table axp20x_volatile_table = {
> +	.yes_ranges	= axp20x_volatile_ranges,
> +	.n_yes_ranges	= ARRAY_SIZE(axp20x_volatile_ranges),
> +};
> +
> +static struct resource axp20x_pek_resources[] = {
> +	{
> +		.name	= "PEK_DBR",
> +		.start	= AXP20X_IRQ_PEK_RIS_EDGE,
> +		.end	= AXP20X_IRQ_PEK_RIS_EDGE,
> +		.flags	= IORESOURCE_IRQ,
> +	}, {
> +		.name	= "PEK_DBF",
> +		.start	= AXP20X_IRQ_PEK_FAL_EDGE,
> +		.end	= AXP20X_IRQ_PEK_FAL_EDGE,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
> +static const struct regmap_config axp20x_regmap_config = {
> +	.reg_bits	= 8,
> +	.val_bits	= 8,
> +	.wr_table	= &axp20x_writeable_table,
> +	.volatile_table	= &axp20x_volatile_table,
> +	.max_register	= AXP20X_FG_RES,
> +	.cache_type	= REGCACHE_RBTREE,
> +};
> +
> +#define AXP20X_IRQ(_irq, _off, _mask) \
> +	[AXP20X_IRQ_##_irq] = { .reg_offset = (_off), .mask = BIT(_mask) }
> +
> +static const struct regmap_irq axp20x_regmap_irqs[] = {
> +	AXP20X_IRQ(ACIN_OVER_V,		0, 7),
> +	AXP20X_IRQ(ACIN_PLUGIN,		0, 6),
> +	AXP20X_IRQ(ACIN_REMOVAL,	0, 5),
> +	AXP20X_IRQ(VBUS_OVER_V,		0, 4),
> +	AXP20X_IRQ(VBUS_PLUGIN,		0, 3),
> +	AXP20X_IRQ(VBUS_REMOVAL,	0, 2),
> +	AXP20X_IRQ(VBUS_V_LOW,		0, 1),
> +	AXP20X_IRQ(BATT_PLUGIN,		1, 7),
> +	AXP20X_IRQ(BATT_REMOVAL,	1, 6),
> +	AXP20X_IRQ(BATT_ENT_ACT_MODE,	1, 5),
> +	AXP20X_IRQ(BATT_EXIT_ACT_MODE,	1, 4),
> +	AXP20X_IRQ(CHARG,		1, 3),
> +	AXP20X_IRQ(CHARG_DONE,		1, 2),
> +	AXP20X_IRQ(BATT_TEMP_HIGH,	1, 1),
> +	AXP20X_IRQ(BATT_TEMP_LOW,	1, 0),
> +	AXP20X_IRQ(DIE_TEMP_HIGH,	2, 7),
> +	AXP20X_IRQ(CHARG_I_LOW,		2, 6),
> +	AXP20X_IRQ(DCDC1_V_LONG,	2, 5),
> +	AXP20X_IRQ(DCDC2_V_LONG,	2, 4),
> +	AXP20X_IRQ(DCDC3_V_LONG,	2, 3),
> +	AXP20X_IRQ(PEK_SHORT,		2, 1),
> +	AXP20X_IRQ(PEK_LONG,		2, 0),
> +	AXP20X_IRQ(N_OE_PWR_ON,		3, 7),
> +	AXP20X_IRQ(N_OE_PWR_OFF,	3, 6),
> +	AXP20X_IRQ(VBUS_VALID,		3, 5),
> +	AXP20X_IRQ(VBUS_NOT_VALID,	3, 4),
> +	AXP20X_IRQ(VBUS_SESS_VALID,	3, 3),
> +	AXP20X_IRQ(VBUS_SESS_END,	3, 2),
> +	AXP20X_IRQ(LOW_PWR_LVL1,	3, 1),
> +	AXP20X_IRQ(LOW_PWR_LVL2,	3, 0),
> +	AXP20X_IRQ(TIMER,		4, 7),
> +	AXP20X_IRQ(PEK_RIS_EDGE,	4, 6),
> +	AXP20X_IRQ(PEK_FAL_EDGE,	4, 5),
> +	AXP20X_IRQ(GPIO3_INPUT,		4, 3),
> +	AXP20X_IRQ(GPIO2_INPUT,		4, 2),
> +	AXP20X_IRQ(GPIO1_INPUT,		4, 1),
> +	AXP20X_IRQ(GPIO0_INPUT,		4, 0),
> +};
> +
> +static const struct of_device_id axp20x_of_match[] = {
> +	{ .compatible = "x-powers,axp202", .data = (void *) AXP202_ID },
> +	{ .compatible = "x-powers,axp209", .data = (void *) AXP209_ID },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, axp20x_of_match);
> +
> +/*
> + * This is useless for OF-enabled devices, but it is needed by I2C subsystem
> + */
> +static const struct i2c_device_id axp20x_i2c_id[] = {
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(i2c, axp20x_i2c_id);
> +
> +static const struct regmap_irq_chip axp20x_regmap_irq_chip = {
> +	.name			= "axp20x_irq_chip",
> +	.status_base		= AXP20X_IRQ1_STATE,
> +	.ack_base		= AXP20X_IRQ1_STATE,
> +	.mask_base		= AXP20X_IRQ1_EN,
> +	.num_regs		= 5,
> +	.irqs			= axp20x_regmap_irqs,
> +	.num_irqs		= ARRAY_SIZE(axp20x_regmap_irqs),
> +	.mask_invert		= true,
> +	.init_ack_masked	= true,
> +};
> +
> +static const char * const axp20x_supplies[] = {
> +	"acin",
> +	"vin2",
> +	"vin3",
> +	"ldo24in",
> +	"ldo3in",
> +	"ldo5in",
> +};
> +
> +static struct mfd_cell axp20x_cells[] = {
> +	{
> +		.name			= "axp20x-pek",
> +		.num_resources		= ARRAY_SIZE(axp20x_pek_resources),
> +		.resources		= axp20x_pek_resources,
> +	}, {
> +		.name			= "axp20x-regulator",
> +		.parent_supplies	= axp20x_supplies,
> +		.num_parent_supplies	= ARRAY_SIZE(axp20x_supplies),
> +	},
> +};
> +
> +static struct axp20x_dev *axp20x_pm_power_off;
> +static void axp20x_power_off(void)
> +{
> +	regmap_write(axp20x_pm_power_off->regmap, AXP20X_OFF_CTRL,
> +		     AXP20X_OFF);
> +}
> +
> +static int axp20x_i2c_probe(struct i2c_client *i2c,
> +			 const struct i2c_device_id *id)
> +{
> +	struct axp20x_dev *axp20x;
> +	const struct of_device_id *of_id;
> +	int ret;
> +
> +	axp20x = devm_kzalloc(&i2c->dev, sizeof(*axp20x), GFP_KERNEL);
> +	if (!axp20x)
> +		return -ENOMEM;
> +
> +	of_id = of_match_device(axp20x_of_match, &i2c->dev);
> +	if (!of_id) {
> +		dev_err(&i2c->dev, "Unable to setup AXP20X data\n");
> +		return -ENODEV;
> +	}
> +	axp20x->variant = (long) of_id->data;
> +
> +	axp20x->i2c_client = i2c;
> +	axp20x->dev = &i2c->dev;
> +	dev_set_drvdata(axp20x->dev, axp20x);
> +
> +	axp20x->regmap = devm_regmap_init_i2c(i2c, &axp20x_regmap_config);
> +	if (IS_ERR(axp20x->regmap)) {
> +		ret = PTR_ERR(axp20x->regmap);
> +		dev_err(&i2c->dev, "regmap init failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = regmap_add_irq_chip(axp20x->regmap, i2c->irq,
> +				  IRQF_ONESHOT | IRQF_SHARED, -1,
> +				  &axp20x_regmap_irq_chip,
> +				  &axp20x->regmap_irqc);
> +	if (ret) {
> +		dev_err(&i2c->dev, "failed to add irq chip: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = mfd_add_devices(axp20x->dev, -1, axp20x_cells,
> +			      ARRAY_SIZE(axp20x_cells), NULL, 0, NULL);
> +
> +	if (ret) {
> +		dev_err(&i2c->dev, "failed to add MFD devices: %d\n", ret);
> +		regmap_del_irq_chip(i2c->irq, axp20x->regmap_irqc);
> +		return ret;
> +	}
> +
> +	if (!pm_power_off) {
> +		axp20x_pm_power_off = axp20x;
> +		pm_power_off = axp20x_power_off;
> +	}
> +
> +	dev_info(&i2c->dev, "AXP20X driver loaded\n");
> +
> +	return 0;
> +}
> +
> +static int axp20x_i2c_remove(struct i2c_client *i2c)
> +{
> +	struct axp20x_dev *axp20x = i2c_get_clientdata(i2c);
> +
> +	if (axp20x == axp20x_pm_power_off) {
> +		axp20x_pm_power_off = NULL;
> +		pm_power_off = NULL;
> +	}
> +
> +	mfd_remove_devices(axp20x->dev);
> +	regmap_del_irq_chip(axp20x->i2c_client->irq, axp20x->regmap_irqc);
> +
> +	return 0;
> +}
> +
> +static struct i2c_driver axp20x_i2c_driver = {
> +	.driver = {
> +		.name	= "axp20x",
> +		.owner	= THIS_MODULE,
> +		.of_match_table	= of_match_ptr(axp20x_of_match),
> +	},
> +	.probe		= axp20x_i2c_probe,
> +	.remove		= axp20x_i2c_remove,
> +	.id_table	= axp20x_i2c_id,
> +};
> +
> +module_i2c_driver(axp20x_i2c_driver);
> +
> +MODULE_DESCRIPTION("PMIC MFD core driver for AXP20X");
> +MODULE_AUTHOR("Carlo Caione <carlo@caione.org>");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/mfd/axp20x.h b/include/linux/mfd/axp20x.h
> deleted file mode 100644
> index d0e31a2..0000000
> --- a/include/linux/mfd/axp20x.h
> +++ /dev/null
> @@ -1,180 +0,0 @@
> -/*
> - * Functions and registers to access AXP20X power management chip.
> - *
> - * Copyright (C) 2013, Carlo Caione <carlo@caione.org>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#ifndef __LINUX_MFD_AXP20X_H
> -#define __LINUX_MFD_AXP20X_H
> -
> -enum {
> -	AXP202_ID = 0,
> -	AXP209_ID,
> -};
> -
> -#define AXP20X_DATACACHE(m)		(0x04 + (m))
> -
> -/* Power supply */
> -#define AXP20X_PWR_INPUT_STATUS		0x00
> -#define AXP20X_PWR_OP_MODE		0x01
> -#define AXP20X_USB_OTG_STATUS		0x02
> -#define AXP20X_PWR_OUT_CTRL		0x12
> -#define AXP20X_DCDC2_V_OUT		0x23
> -#define AXP20X_DCDC2_LDO3_V_SCAL	0x25
> -#define AXP20X_DCDC3_V_OUT		0x27
> -#define AXP20X_LDO24_V_OUT		0x28
> -#define AXP20X_LDO3_V_OUT		0x29
> -#define AXP20X_VBUS_IPSOUT_MGMT		0x30
> -#define AXP20X_V_OFF			0x31
> -#define AXP20X_OFF_CTRL			0x32
> -#define AXP20X_CHRG_CTRL1		0x33
> -#define AXP20X_CHRG_CTRL2		0x34
> -#define AXP20X_CHRG_BAK_CTRL		0x35
> -#define AXP20X_PEK_KEY			0x36
> -#define AXP20X_DCDC_FREQ		0x37
> -#define AXP20X_V_LTF_CHRG		0x38
> -#define AXP20X_V_HTF_CHRG		0x39
> -#define AXP20X_APS_WARN_L1		0x3a
> -#define AXP20X_APS_WARN_L2		0x3b
> -#define AXP20X_V_LTF_DISCHRG		0x3c
> -#define AXP20X_V_HTF_DISCHRG		0x3d
> -
> -/* Interrupt */
> -#define AXP20X_IRQ1_EN			0x40
> -#define AXP20X_IRQ2_EN			0x41
> -#define AXP20X_IRQ3_EN			0x42
> -#define AXP20X_IRQ4_EN			0x43
> -#define AXP20X_IRQ5_EN			0x44
> -#define AXP20X_IRQ1_STATE		0x48
> -#define AXP20X_IRQ2_STATE		0x49
> -#define AXP20X_IRQ3_STATE		0x4a
> -#define AXP20X_IRQ4_STATE		0x4b
> -#define AXP20X_IRQ5_STATE		0x4c
> -
> -/* ADC */
> -#define AXP20X_ACIN_V_ADC_H		0x56
> -#define AXP20X_ACIN_V_ADC_L		0x57
> -#define AXP20X_ACIN_I_ADC_H		0x58
> -#define AXP20X_ACIN_I_ADC_L		0x59
> -#define AXP20X_VBUS_V_ADC_H		0x5a
> -#define AXP20X_VBUS_V_ADC_L		0x5b
> -#define AXP20X_VBUS_I_ADC_H		0x5c
> -#define AXP20X_VBUS_I_ADC_L		0x5d
> -#define AXP20X_TEMP_ADC_H		0x5e
> -#define AXP20X_TEMP_ADC_L		0x5f
> -#define AXP20X_TS_IN_H			0x62
> -#define AXP20X_TS_IN_L			0x63
> -#define AXP20X_GPIO0_V_ADC_H		0x64
> -#define AXP20X_GPIO0_V_ADC_L		0x65
> -#define AXP20X_GPIO1_V_ADC_H		0x66
> -#define AXP20X_GPIO1_V_ADC_L		0x67
> -#define AXP20X_PWR_BATT_H		0x70
> -#define AXP20X_PWR_BATT_M		0x71
> -#define AXP20X_PWR_BATT_L		0x72
> -#define AXP20X_BATT_V_H			0x78
> -#define AXP20X_BATT_V_L			0x79
> -#define AXP20X_BATT_CHRG_I_H		0x7a
> -#define AXP20X_BATT_CHRG_I_L		0x7b
> -#define AXP20X_BATT_DISCHRG_I_H		0x7c
> -#define AXP20X_BATT_DISCHRG_I_L		0x7d
> -#define AXP20X_IPSOUT_V_HIGH_H		0x7e
> -#define AXP20X_IPSOUT_V_HIGH_L		0x7f
> -
> -/* Power supply */
> -#define AXP20X_DCDC_MODE		0x80
> -#define AXP20X_ADC_EN1			0x82
> -#define AXP20X_ADC_EN2			0x83
> -#define AXP20X_ADC_RATE			0x84
> -#define AXP20X_GPIO10_IN_RANGE		0x85
> -#define AXP20X_GPIO1_ADC_IRQ_RIS	0x86
> -#define AXP20X_GPIO1_ADC_IRQ_FAL	0x87
> -#define AXP20X_TIMER_CTRL		0x8a
> -#define AXP20X_VBUS_MON			0x8b
> -#define AXP20X_OVER_TMP			0x8f
> -
> -/* GPIO */
> -#define AXP20X_GPIO0_CTRL		0x90
> -#define AXP20X_LDO5_V_OUT		0x91
> -#define AXP20X_GPIO1_CTRL		0x92
> -#define AXP20X_GPIO2_CTRL		0x93
> -#define AXP20X_GPIO20_SS		0x94
> -#define AXP20X_GPIO3_CTRL		0x95
> -
> -/* Battery */
> -#define AXP20X_CHRG_CC_31_24		0xb0
> -#define AXP20X_CHRG_CC_23_16		0xb1
> -#define AXP20X_CHRG_CC_15_8		0xb2
> -#define AXP20X_CHRG_CC_7_0		0xb3
> -#define AXP20X_DISCHRG_CC_31_24		0xb4
> -#define AXP20X_DISCHRG_CC_23_16		0xb5
> -#define AXP20X_DISCHRG_CC_15_8		0xb6
> -#define AXP20X_DISCHRG_CC_7_0		0xb7
> -#define AXP20X_CC_CTRL			0xb8
> -#define AXP20X_FG_RES			0xb9
> -
> -/* Regulators IDs */
> -enum {
> -	AXP20X_LDO1 = 0,
> -	AXP20X_LDO2,
> -	AXP20X_LDO3,
> -	AXP20X_LDO4,
> -	AXP20X_LDO5,
> -	AXP20X_DCDC2,
> -	AXP20X_DCDC3,
> -	AXP20X_REG_ID_MAX,
> -};
> -
> -/* IRQs */
> -enum {
> -	AXP20X_IRQ_ACIN_OVER_V = 1,
> -	AXP20X_IRQ_ACIN_PLUGIN,
> -	AXP20X_IRQ_ACIN_REMOVAL,
> -	AXP20X_IRQ_VBUS_OVER_V,
> -	AXP20X_IRQ_VBUS_PLUGIN,
> -	AXP20X_IRQ_VBUS_REMOVAL,
> -	AXP20X_IRQ_VBUS_V_LOW,
> -	AXP20X_IRQ_BATT_PLUGIN,
> -	AXP20X_IRQ_BATT_REMOVAL,
> -	AXP20X_IRQ_BATT_ENT_ACT_MODE,
> -	AXP20X_IRQ_BATT_EXIT_ACT_MODE,
> -	AXP20X_IRQ_CHARG,
> -	AXP20X_IRQ_CHARG_DONE,
> -	AXP20X_IRQ_BATT_TEMP_HIGH,
> -	AXP20X_IRQ_BATT_TEMP_LOW,
> -	AXP20X_IRQ_DIE_TEMP_HIGH,
> -	AXP20X_IRQ_CHARG_I_LOW,
> -	AXP20X_IRQ_DCDC1_V_LONG,
> -	AXP20X_IRQ_DCDC2_V_LONG,
> -	AXP20X_IRQ_DCDC3_V_LONG,
> -	AXP20X_IRQ_PEK_SHORT = 22,
> -	AXP20X_IRQ_PEK_LONG,
> -	AXP20X_IRQ_N_OE_PWR_ON,
> -	AXP20X_IRQ_N_OE_PWR_OFF,
> -	AXP20X_IRQ_VBUS_VALID,
> -	AXP20X_IRQ_VBUS_NOT_VALID,
> -	AXP20X_IRQ_VBUS_SESS_VALID,
> -	AXP20X_IRQ_VBUS_SESS_END,
> -	AXP20X_IRQ_LOW_PWR_LVL1,
> -	AXP20X_IRQ_LOW_PWR_LVL2,
> -	AXP20X_IRQ_TIMER,
> -	AXP20X_IRQ_PEK_RIS_EDGE,
> -	AXP20X_IRQ_PEK_FAL_EDGE,
> -	AXP20X_IRQ_GPIO3_INPUT,
> -	AXP20X_IRQ_GPIO2_INPUT,
> -	AXP20X_IRQ_GPIO1_INPUT,
> -	AXP20X_IRQ_GPIO0_INPUT,
> -};
> -
> -struct axp20x_dev {
> -	struct device			*dev;
> -	struct i2c_client		*i2c_client;
> -	struct regmap			*regmap;
> -	struct regmap_irq_chip_data	*regmap_irqc;
> -	long				variant;
> -};
> -
> -#endif /* __LINUX_MFD_AXP20X_H */
> diff --git a/include/linux/mfd/axp2xx.h b/include/linux/mfd/axp2xx.h
> new file mode 100644
> index 0000000..d0e31a2
> --- /dev/null
> +++ b/include/linux/mfd/axp2xx.h
> @@ -0,0 +1,180 @@
> +/*
> + * Functions and registers to access AXP20X power management chip.
> + *
> + * Copyright (C) 2013, Carlo Caione <carlo@caione.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __LINUX_MFD_AXP20X_H
> +#define __LINUX_MFD_AXP20X_H
> +
> +enum {
> +	AXP202_ID = 0,
> +	AXP209_ID,
> +};
> +
> +#define AXP20X_DATACACHE(m)		(0x04 + (m))
> +
> +/* Power supply */
> +#define AXP20X_PWR_INPUT_STATUS		0x00
> +#define AXP20X_PWR_OP_MODE		0x01
> +#define AXP20X_USB_OTG_STATUS		0x02
> +#define AXP20X_PWR_OUT_CTRL		0x12
> +#define AXP20X_DCDC2_V_OUT		0x23
> +#define AXP20X_DCDC2_LDO3_V_SCAL	0x25
> +#define AXP20X_DCDC3_V_OUT		0x27
> +#define AXP20X_LDO24_V_OUT		0x28
> +#define AXP20X_LDO3_V_OUT		0x29
> +#define AXP20X_VBUS_IPSOUT_MGMT		0x30
> +#define AXP20X_V_OFF			0x31
> +#define AXP20X_OFF_CTRL			0x32
> +#define AXP20X_CHRG_CTRL1		0x33
> +#define AXP20X_CHRG_CTRL2		0x34
> +#define AXP20X_CHRG_BAK_CTRL		0x35
> +#define AXP20X_PEK_KEY			0x36
> +#define AXP20X_DCDC_FREQ		0x37
> +#define AXP20X_V_LTF_CHRG		0x38
> +#define AXP20X_V_HTF_CHRG		0x39
> +#define AXP20X_APS_WARN_L1		0x3a
> +#define AXP20X_APS_WARN_L2		0x3b
> +#define AXP20X_V_LTF_DISCHRG		0x3c
> +#define AXP20X_V_HTF_DISCHRG		0x3d
> +
> +/* Interrupt */
> +#define AXP20X_IRQ1_EN			0x40
> +#define AXP20X_IRQ2_EN			0x41
> +#define AXP20X_IRQ3_EN			0x42
> +#define AXP20X_IRQ4_EN			0x43
> +#define AXP20X_IRQ5_EN			0x44
> +#define AXP20X_IRQ1_STATE		0x48
> +#define AXP20X_IRQ2_STATE		0x49
> +#define AXP20X_IRQ3_STATE		0x4a
> +#define AXP20X_IRQ4_STATE		0x4b
> +#define AXP20X_IRQ5_STATE		0x4c
> +
> +/* ADC */
> +#define AXP20X_ACIN_V_ADC_H		0x56
> +#define AXP20X_ACIN_V_ADC_L		0x57
> +#define AXP20X_ACIN_I_ADC_H		0x58
> +#define AXP20X_ACIN_I_ADC_L		0x59
> +#define AXP20X_VBUS_V_ADC_H		0x5a
> +#define AXP20X_VBUS_V_ADC_L		0x5b
> +#define AXP20X_VBUS_I_ADC_H		0x5c
> +#define AXP20X_VBUS_I_ADC_L		0x5d
> +#define AXP20X_TEMP_ADC_H		0x5e
> +#define AXP20X_TEMP_ADC_L		0x5f
> +#define AXP20X_TS_IN_H			0x62
> +#define AXP20X_TS_IN_L			0x63
> +#define AXP20X_GPIO0_V_ADC_H		0x64
> +#define AXP20X_GPIO0_V_ADC_L		0x65
> +#define AXP20X_GPIO1_V_ADC_H		0x66
> +#define AXP20X_GPIO1_V_ADC_L		0x67
> +#define AXP20X_PWR_BATT_H		0x70
> +#define AXP20X_PWR_BATT_M		0x71
> +#define AXP20X_PWR_BATT_L		0x72
> +#define AXP20X_BATT_V_H			0x78
> +#define AXP20X_BATT_V_L			0x79
> +#define AXP20X_BATT_CHRG_I_H		0x7a
> +#define AXP20X_BATT_CHRG_I_L		0x7b
> +#define AXP20X_BATT_DISCHRG_I_H		0x7c
> +#define AXP20X_BATT_DISCHRG_I_L		0x7d
> +#define AXP20X_IPSOUT_V_HIGH_H		0x7e
> +#define AXP20X_IPSOUT_V_HIGH_L		0x7f
> +
> +/* Power supply */
> +#define AXP20X_DCDC_MODE		0x80
> +#define AXP20X_ADC_EN1			0x82
> +#define AXP20X_ADC_EN2			0x83
> +#define AXP20X_ADC_RATE			0x84
> +#define AXP20X_GPIO10_IN_RANGE		0x85
> +#define AXP20X_GPIO1_ADC_IRQ_RIS	0x86
> +#define AXP20X_GPIO1_ADC_IRQ_FAL	0x87
> +#define AXP20X_TIMER_CTRL		0x8a
> +#define AXP20X_VBUS_MON			0x8b
> +#define AXP20X_OVER_TMP			0x8f
> +
> +/* GPIO */
> +#define AXP20X_GPIO0_CTRL		0x90
> +#define AXP20X_LDO5_V_OUT		0x91
> +#define AXP20X_GPIO1_CTRL		0x92
> +#define AXP20X_GPIO2_CTRL		0x93
> +#define AXP20X_GPIO20_SS		0x94
> +#define AXP20X_GPIO3_CTRL		0x95
> +
> +/* Battery */
> +#define AXP20X_CHRG_CC_31_24		0xb0
> +#define AXP20X_CHRG_CC_23_16		0xb1
> +#define AXP20X_CHRG_CC_15_8		0xb2
> +#define AXP20X_CHRG_CC_7_0		0xb3
> +#define AXP20X_DISCHRG_CC_31_24		0xb4
> +#define AXP20X_DISCHRG_CC_23_16		0xb5
> +#define AXP20X_DISCHRG_CC_15_8		0xb6
> +#define AXP20X_DISCHRG_CC_7_0		0xb7
> +#define AXP20X_CC_CTRL			0xb8
> +#define AXP20X_FG_RES			0xb9
> +
> +/* Regulators IDs */
> +enum {
> +	AXP20X_LDO1 = 0,
> +	AXP20X_LDO2,
> +	AXP20X_LDO3,
> +	AXP20X_LDO4,
> +	AXP20X_LDO5,
> +	AXP20X_DCDC2,
> +	AXP20X_DCDC3,
> +	AXP20X_REG_ID_MAX,
> +};
> +
> +/* IRQs */
> +enum {
> +	AXP20X_IRQ_ACIN_OVER_V = 1,
> +	AXP20X_IRQ_ACIN_PLUGIN,
> +	AXP20X_IRQ_ACIN_REMOVAL,
> +	AXP20X_IRQ_VBUS_OVER_V,
> +	AXP20X_IRQ_VBUS_PLUGIN,
> +	AXP20X_IRQ_VBUS_REMOVAL,
> +	AXP20X_IRQ_VBUS_V_LOW,
> +	AXP20X_IRQ_BATT_PLUGIN,
> +	AXP20X_IRQ_BATT_REMOVAL,
> +	AXP20X_IRQ_BATT_ENT_ACT_MODE,
> +	AXP20X_IRQ_BATT_EXIT_ACT_MODE,
> +	AXP20X_IRQ_CHARG,
> +	AXP20X_IRQ_CHARG_DONE,
> +	AXP20X_IRQ_BATT_TEMP_HIGH,
> +	AXP20X_IRQ_BATT_TEMP_LOW,
> +	AXP20X_IRQ_DIE_TEMP_HIGH,
> +	AXP20X_IRQ_CHARG_I_LOW,
> +	AXP20X_IRQ_DCDC1_V_LONG,
> +	AXP20X_IRQ_DCDC2_V_LONG,
> +	AXP20X_IRQ_DCDC3_V_LONG,
> +	AXP20X_IRQ_PEK_SHORT = 22,
> +	AXP20X_IRQ_PEK_LONG,
> +	AXP20X_IRQ_N_OE_PWR_ON,
> +	AXP20X_IRQ_N_OE_PWR_OFF,
> +	AXP20X_IRQ_VBUS_VALID,
> +	AXP20X_IRQ_VBUS_NOT_VALID,
> +	AXP20X_IRQ_VBUS_SESS_VALID,
> +	AXP20X_IRQ_VBUS_SESS_END,
> +	AXP20X_IRQ_LOW_PWR_LVL1,
> +	AXP20X_IRQ_LOW_PWR_LVL2,
> +	AXP20X_IRQ_TIMER,
> +	AXP20X_IRQ_PEK_RIS_EDGE,
> +	AXP20X_IRQ_PEK_FAL_EDGE,
> +	AXP20X_IRQ_GPIO3_INPUT,
> +	AXP20X_IRQ_GPIO2_INPUT,
> +	AXP20X_IRQ_GPIO1_INPUT,
> +	AXP20X_IRQ_GPIO0_INPUT,
> +};
> +
> +struct axp20x_dev {
> +	struct device			*dev;
> +	struct i2c_client		*i2c_client;
> +	struct regmap			*regmap;
> +	struct regmap_irq_chip_data	*regmap_irqc;
> +	long				variant;
> +};
> +
> +#endif /* __LINUX_MFD_AXP20X_H */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
