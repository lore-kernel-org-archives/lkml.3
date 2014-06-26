Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbaFZJbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:31:42 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31137 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbaFZJbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:31:36 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f626d000004b39-71-53abe875707b
Content-transfer-encoding: 8BIT
Message-id: <1403775093.27156.13.camel@AMDC1943>
Subject: Re: [PATCH v4 07/14] mfd: Add driver for Maxim 77802 Power Management
 IC
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 11:31:33 +0200
In-reply-to: <1403723019-6212-8-git-send-email-javier.martinez@collabora.co.uk>
References: <1403723019-6212-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403723019-6212-8-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t/xq7qlL1YHGxz+JW6x5OJVdoupD5+w
	WWzq38puMf/IOVaLs8sOslkc/V1g0bvgKpvF/a9HGS2+Xelgstj0+BqrxeVdc9gsZpzfx2Tx
	dMJFNotT1z+zWZzuZrWYfvwtq0Xf2ktsDoIesxsusnj8fX6dxWPH3SWMHjtn3WX32LSqk83j
	zrU9bB7zTgZ6bF5S73HlRBOrR9+WVYwe0+f9ZPL4vEkugCeKyyYlNSezLLVI3y6BK+PAqqvs
	BW9XMVb8+HCbpYFxdidjFyMHh4SAicSLh7ldjJxAppjEhXvr2boYuTiEBJYySrzY8J4RJMEr
	ICjxY/I9FpB6ZgF5iSOXskHCzALqEpPmLWKGqP/MKNHyqpcJot5AovfXOxYQW1ggWGLhw4/M
	IDabgLHE5uVL2EBsEQE7iRurH4I1Mws8YpF4tOUP2DIWAVWJ39uugRVxCvhLbLrUzgqxYTKj
	xJKbEBdJCChLzNt/jGkCo8AsJAfOQjhwFpIDFzAyr2IUTS1NLihOSs810itOzC0uzUvXS87P
	3cQIicWvOxiXHrM6xCjAwajEw3sibHWwEGtiWXFl7iFGCQ5mJRHezjtAId6UxMqq1KL8+KLS
	nNTiQ4xMHJxSDYzVZ6o/9v8ONPjLcSWTO9Tc+xV3N5tDil37jh2Zj/MkJ5s8tltgqMhe3BWU
	uII57+xB7yzdprOzdu96LXNxVdKlpUfXTqm/cvF/3s+7nt7/2sorT36O+C+nnN3As33u3LW/
	dA5+E3rP1rm3ZKPzQ7m9EtKHf4cZZNW/X71+sxX7Ym8BI1f531xKLMUZiYZazEXFiQDVDtuw
	owIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just a few nit-picks below but overall everything looks fine:

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>


On śro, 2014-06-25 at 21:03 +0200, Javier Martinez Canillas wrote:
> Maxim MAX77802 is a power management chip that contains 10 high
> efficiency Buck regulators, 32 Low-dropout (LDO) regulators used
> to power up application processors and peripherals, a 2-channel
> 32kHz clock outputs, a Real-Time-Clock (RTC) and a I2C interface
> to program the individual regulators, clocks outputs and the RTC.
> 
> This patch adds the core support for MAX77802 PMIC and is based
> on a driver added by Simon Glass to the Chrome OS kernel 3.8 tree.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

(...)

> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f001487..e795bfe 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -117,6 +117,7 @@ obj-$(CONFIG_MFD_DA9063)	+= da9063.o
>  obj-$(CONFIG_MFD_MAX14577)	+= max14577.o
>  obj-$(CONFIG_MFD_MAX77686)	+= max77686.o
>  obj-$(CONFIG_MFD_MAX77693)	+= max77693.o
> +obj-$(CONFIG_MFD_MAX77802)      += max77802.o
>  obj-$(CONFIG_MFD_MAX8907)	+= max8907.o
>  max8925-objs			:= max8925-core.o max8925-i2c.o
>  obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
> diff --git a/drivers/mfd/max77802.c b/drivers/mfd/max77802.c
> new file mode 100644
> index 0000000..3d477fb
> --- /dev/null
> +++ b/drivers/mfd/max77802.c
> @@ -0,0 +1,366 @@
> +/*
> + * max77802.c - mfd core driver for the Maxim 77802
> + *
> + * Copyright (C) 2013-2014 Google, Inc
> + * Simon Glass <sjg@chromium.org>
> + *
> + * Copyright (C) 2012 Samsung Electronics
> + * Chiwoong Byun <woong.byun@smasung.com>
> + * Jonghwa Lee <jonghwa3.lee@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * This driver is based on max8997.c
> + */
> +
> +#include <linux/export.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/module.h>
> +#include <linux/mfd/core.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/mfd/max77802.h>
> +#include <linux/mfd/max77802-private.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/err.h>
> +
> +static const struct mfd_cell max77802_devs[] = {
> +	{ .name = "max77802-pmic", },
> +	{ .name = "max77802-clk", },
> +	{ .name = "max77802-rtc", },
> +};
> +
> +static bool max77802_pmic_is_accessible_reg(struct device *dev,
> +					    unsigned int reg)
> +{
> +	return (reg >= MAX77802_REG_DEVICE_ID && reg < MAX77802_REG_PMIC_END);
> +}
> +
> +static bool max77802_rtc_is_accessible_reg(struct device *dev,
> +					   unsigned int reg)
> +{
> +	return (reg >= MAX77802_RTC_INT && reg < MAX77802_RTC_END);
> +}
> +
> +static bool max77802_is_accessible_reg(struct device *dev, unsigned int reg)
> +{
> +	return (max77802_pmic_is_accessible_reg(dev, reg) ||
> +		max77802_rtc_is_accessible_reg(dev, reg));
> +}
> +
> +static bool max77802_pmic_is_precious_reg(struct device *dev, unsigned int reg)
> +{
> +	return (reg == MAX77802_REG_INTSRC || reg == MAX77802_REG_INT1 ||
> +		reg == MAX77802_REG_INT2);
> +}
> +
> +static bool max77802_rtc_is_precious_reg(struct device *dev, unsigned int reg)
> +{
> +	return (reg == MAX77802_RTC_INT ||
> +		reg == MAX77802_RTC_UPDATE0 ||
> +		reg == MAX77802_RTC_UPDATE1);
> +}
> +
> +static bool max77802_is_precious_reg(struct device *dev, unsigned int reg)
> +{
> +	return (max77802_pmic_is_precious_reg(dev, reg) ||
> +		max77802_rtc_is_precious_reg(dev, reg));
> +}
> +
> +static bool max77802_pmic_is_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	return (max77802_is_precious_reg(dev, reg) ||
> +		reg == MAX77802_REG_STATUS1 || reg == MAX77802_REG_STATUS2 ||
> +		reg == MAX77802_REG_PWRON);
> +}
> +
> +static bool max77802_rtc_is_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	return (max77802_rtc_is_precious_reg(dev, reg) ||
> +		reg == MAX77802_RTC_SEC ||
> +		reg == MAX77802_RTC_MIN ||
> +		reg == MAX77802_RTC_HOUR ||
> +		reg == MAX77802_RTC_WEEKDAY ||
> +		reg == MAX77802_RTC_MONTH ||
> +		reg == MAX77802_RTC_YEAR ||
> +		reg == MAX77802_RTC_DATE);
> +}
> +
> +static bool max77802_is_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	return (max77802_pmic_is_volatile_reg(dev, reg) ||
> +		max77802_rtc_is_volatile_reg(dev, reg));
> +}
> +
> +static struct regmap_config max77802_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.writeable_reg = max77802_is_accessible_reg,
> +	.readable_reg = max77802_is_accessible_reg,
> +	.precious_reg = max77802_is_precious_reg,
> +	.volatile_reg = max77802_is_volatile_reg,
> +	.name = "max77802-pmic",
> +	.cache_type = REGCACHE_RBTREE,
> +};
> +
> +static const struct regmap_irq max77802_irqs[] = {
> +	/* INT1 interrupts */
> +	{ .reg_offset = 0, .mask = MAX77802_INT1_PWRONF_MSK, },
> +	{ .reg_offset = 0, .mask = MAX77802_INT1_PWRONR_MSK, },
> +	{ .reg_offset = 0, .mask = MAX77802_INT1_JIGONBF_MSK, },
> +	{ .reg_offset = 0, .mask = MAX77802_INT1_JIGONBR_MSK, },
> +	{ .reg_offset = 0, .mask = MAX77802_INT1_ACOKBF_MSK, },
> +	{ .reg_offset = 0, .mask = MAX77802_INT1_ACOKBR_MSK, },
> +	{ .reg_offset = 0, .mask = MAX77802_INT1_ONKEY1S_MSK, },
> +	{ .reg_offset = 0, .mask = MAX77802_INT1_MRSTB_MSK, },
> +	/* INT2 interrupts */
> +	{ .reg_offset = 1, .mask = MAX77802_INT2_140C_MSK, },
> +	{ .reg_offset = 1, .mask = MAX77802_INT2_120C_MSK, },
> +};
> +
> +static const struct regmap_irq_chip max77802_irq_chip = {
> +	.name			= "max77802-pmic",
> +	.status_base		= MAX77802_REG_INT1,
> +	.mask_base		= MAX77802_REG_INT1MSK,
> +	.num_regs		= 2,
> +	.irqs			= max77802_irqs,
> +	.num_irqs		= ARRAY_SIZE(max77802_irqs),
> +};
> +
> +static const struct regmap_irq max77802_rtc_irqs[] = {
> +	/* RTC interrupts */
> +	{ .reg_offset = 0, .mask = MAX77802_RTCINT_RTC60S_MSK, },
> +	{ .reg_offset = 0, .mask = MAX77802_RTCINT_RTCA1_MSK, },
> +	{ .reg_offset = 0, .mask = MAX77802_RTCINT_RTCA2_MSK, },
> +	{ .reg_offset = 0, .mask = MAX77802_RTCINT_SMPL_MSK, },
> +	{ .reg_offset = 0, .mask = MAX77802_RTCINT_RTC1S_MSK, },
> +	{ .reg_offset = 0, .mask = MAX77802_RTCINT_WTSR_MSK, },
> +};
> +
> +static const struct regmap_irq_chip max77802_rtc_irq_chip = {
> +	.name			= "max77802-rtc",
> +	.status_base		= MAX77802_RTC_INT,
> +	.mask_base		= MAX77802_RTC_INTM,
> +	.num_regs		= 1,
> +	.irqs			= max77802_rtc_irqs,
> +	.num_irqs		= ARRAY_SIZE(max77802_rtc_irqs),
> +};
> +
> +#ifdef CONFIG_OF
> +static struct of_device_id max77802_pmic_dt_match[] = {
> +	{.compatible = "maxim,max77802", .data = NULL},
> +	{},
> +};
> +
> +static void max77802_dt_parse_dvs_gpio(struct device *dev,
> +				       struct max77802_platform_data *pd,
> +				       struct device_node *np)
> +{
> +	int i;
> +
> +	/*
> +	 * NOTE: we don't consider GPIO errors fatal; board may have some lines
> +	 * directly pulled high or low and thus doesn't specify them.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_dvs); i++)
> +		pd->buck_gpio_dvs[i] =
> +			devm_gpiod_get_index(dev, "max77802,pmic-buck-dvs", i);
> +
> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++)
> +		pd->buck_gpio_selb[i] =
> +			devm_gpiod_get_index(dev, "max77802,pmic-buck-selb", i);
> +}
> +
> +static struct max77802_platform_data *max77802_i2c_parse_dt_pdata(struct device
> +								  *dev)
> +{
> +	struct device_node *np = dev->of_node;
> +	struct max77802_platform_data *pd;
> +
> +	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
> +	if (!pd)
> +		return NULL;
> +
> +	/* Read default index and ignore errors, since default is 0 */
> +	of_property_read_u32(np, "max77802,pmic-buck-default-dvs-idx",
> +			     &pd->buck_default_idx);
> +
> +	max77802_dt_parse_dvs_gpio(dev, pd, np);
> +
> +	dev->platform_data = pd;
> +	return pd;
> +}
> +#else
> +static struct max77802_platform_data *max77802_i2c_parse_dt_pdata(struct device
> +								  *dev)
> +{
> +	return 0;
> +}
> +#endif
> +
> +static int max77802_i2c_probe(struct i2c_client *i2c,
> +			      const struct i2c_device_id *id)
> +{
> +	struct max77802_dev *max77802 = NULL;
> +	struct max77802_platform_data *pdata = dev_get_platdata(&i2c->dev);
> +	unsigned int data;
> +	int ret = 0;
> +
> +	if (i2c->dev.of_node)
> +		pdata = max77802_i2c_parse_dt_pdata(&i2c->dev);
> +
> +	if (!pdata) {
> +		dev_err(&i2c->dev, "No platform data found.\n");
> +		return -EIO;
> +	}
> +
> +	max77802 = devm_kzalloc(&i2c->dev, sizeof(struct max77802_dev),
> +				GFP_KERNEL);
> +	if (max77802 == NULL)

It is inconsistent. Before you used "(!pd)" and "(!pdata)" so maybe
stick to one format?

> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(i2c, max77802);
> +
> +	max77802->dev = &i2c->dev;
> +	max77802->i2c = i2c;
> +	max77802->type = id->driver_data;
> +
> +	max77802->wakeup = pdata->wakeup;
> +	max77802->irq = i2c->irq;
> +
> +	max77802->regmap = devm_regmap_init_i2c(i2c, &max77802_regmap_config);
> +	if (IS_ERR(max77802->regmap)) {
> +		ret = PTR_ERR(max77802->regmap);
> +		dev_err(max77802->dev, "Failed to allocate register map: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	if (regmap_read(max77802->regmap,
> +			 MAX77802_REG_DEVICE_ID, &data) < 0) {
> +		dev_err(max77802->dev,
> +			"device not found on this channel\n");
> +		return -ENODEV;
> +	}
> +
> +	ret = regmap_add_irq_chip(max77802->regmap, max77802->irq,
> +				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
> +				  IRQF_SHARED, 0, &max77802_irq_chip,
> +				  &max77802->irq_data);
> +	if (ret != 0) {
> +		dev_err(&i2c->dev, "failed to add PMIC irq chip: %d\n", ret);
> +		return ret;
> +	}
> +	ret = regmap_add_irq_chip(max77802->regmap, max77802->irq,
> +				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
> +				  IRQF_SHARED, 0, &max77802_rtc_irq_chip,
> +				  &max77802->rtc_irq_data);
> +	if (ret != 0) {
> +		dev_err(&i2c->dev, "failed to add RTC irq chip: %d\n", ret);
> +		goto err_del_irqc;
> +	}
> +
> +	ret = mfd_add_devices(max77802->dev, -1, max77802_devs,
> +			      ARRAY_SIZE(max77802_devs), NULL, 0, NULL);
> +	if (ret < 0) {
> +		dev_err(&i2c->dev, "failed to add MFD devices: %d\n", ret);
> +		goto err_del_rtc_irqc;
> +	}
> +
> +	return 0;
> +
> +err_del_rtc_irqc:
> +	regmap_del_irq_chip(max77802->irq, max77802->rtc_irq_data);
> +err_del_irqc:
> +	regmap_del_irq_chip(max77802->irq, max77802->irq_data);
> +	return ret;
> +}
> +
> +static int max77802_i2c_remove(struct i2c_client *i2c)
> +{
> +	struct max77802_dev *max77802 = i2c_get_clientdata(i2c);
> +
> +	mfd_remove_devices(max77802->dev);
> +
> +	regmap_del_irq_chip(max77802->irq, max77802->rtc_irq_data);
> +	regmap_del_irq_chip(max77802->irq, max77802->irq_data);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id max77802_i2c_id[] = {
> +	{ "max77802", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, max77802_i2c_id);
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int max77802_suspend(struct device *dev)
> +{
> +	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
> +	struct max77802_dev *max77802 = i2c_get_clientdata(i2c);
> +
> +	if (device_may_wakeup(dev))
> +		enable_irq_wake(max77802->irq);
> +
> +	disable_irq(max77802->irq);

Can you add short comment why this is needed? I know why but just for
future generations which will wonder: "why do we need to disable the IRQ
while suspending?" :). Especially that this is rather a workaround for
issue in other driver (I2C bus).

> +
> +	return 0;
> +}
> +
> +static int max77802_resume(struct device *dev)
> +{
> +	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
> +	struct max77802_dev *max77802 = i2c_get_clientdata(i2c);
> +
> +	if (device_may_wakeup(dev))
> +		disable_irq_wake(max77802->irq);
> +
> +	enable_irq(max77802->irq);
> +
> +	return 0;
> +}
> +#endif /* CONFIG_PM_SLEEP */
> +
> +static SIMPLE_DEV_PM_OPS(max77802_pm, max77802_suspend, max77802_resume);
> +
> +static struct i2c_driver max77802_i2c_driver = {
> +	.driver = {
> +		   .name = "max77802",
> +		   .owner = THIS_MODULE,
> +		   .pm = &max77802_pm,
> +		   .of_match_table = of_match_ptr(max77802_pmic_dt_match),
> +	},
> +	.probe = max77802_i2c_probe,
> +	.remove = max77802_i2c_remove,
> +	.id_table = max77802_i2c_id,
> +};
> +
> +static int __init max77802_i2c_init(void)
> +{
> +	return i2c_add_driver(&max77802_i2c_driver);
> +}
> +/* init early so consumer devices can complete system boot */
> +subsys_initcall(max77802_i2c_init);
> +
> +static void __exit max77802_i2c_exit(void)
> +{
> +	i2c_del_driver(&max77802_i2c_driver);
> +}
> +module_exit(max77802_i2c_exit);
> +
> +MODULE_DESCRIPTION("MAXIM 77802 multi-function core driver");
> +MODULE_AUTHOR("Simon Glass <sjg@chromium.org>");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/mfd/max77802-private.h b/include/linux/mfd/max77802-private.h
> new file mode 100644
> index 0000000..7539ab4
> --- /dev/null
> +++ b/include/linux/mfd/max77802-private.h
> @@ -0,0 +1,307 @@
> +/*
> + * max77802-private.h - Voltage regulator driver for the Maxim 77802
> + *
> + *  Copyright (C) 2012 Samsung Electrnoics
> + *  Chiwoong Byun <woong.byun@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __LINUX_MFD_MAX77802_PRIV_H
> +#define __LINUX_MFD_MAX77802_PRIV_H
> +
> +#include <linux/i2c.h>
> +#include <linux/regmap.h>
> +#include <linux/module.h>
> +
> +#define MAX77802_REG_INVALID		(0xff)
> +
> +enum max77802_pmic_reg {
> +	MAX77802_REG_DEVICE_ID		= 0x00,
> +	MAX77802_REG_INTSRC		= 0x01,
> +	MAX77802_REG_INT1		= 0x02,
> +	MAX77802_REG_INT2		= 0x03,
> +
> +	MAX77802_REG_INT1MSK		= 0x04,
> +	MAX77802_REG_INT2MSK		= 0x05,
> +
> +	MAX77802_REG_STATUS1		= 0x06,
> +	MAX77802_REG_STATUS2		= 0x07,
> +
> +	MAX77802_REG_PWRON		= 0x08,
> +	/* Reserved: 0x09 */
> +	MAX77802_REG_MRSTB		= 0x0A,
> +	MAX77802_REG_EPWRHOLD		= 0x0B,
> +	/* Reserved: 0x0C-0x0D */
> +	MAX77802_REG_BOOSTCTRL		= 0x0E,
> +	MAX77802_REG_BOOSTOUT		= 0x0F,
> +
> +	MAX77802_REG_BUCK1CTRL		= 0x10,
> +	MAX77802_REG_BUCK1DVS1		= 0x11,
> +	MAX77802_REG_BUCK1DVS2		= 0x12,
> +	MAX77802_REG_BUCK1DVS3		= 0x13,
> +	MAX77802_REG_BUCK1DVS4		= 0x14,
> +	MAX77802_REG_BUCK1DVS5		= 0x15,
> +	MAX77802_REG_BUCK1DVS6		= 0x16,
> +	MAX77802_REG_BUCK1DVS7		= 0x17,
> +	MAX77802_REG_BUCK1DVS8		= 0x18,
> +	/* Reserved: 0x19 */
> +	MAX77802_REG_BUCK2CTRL1		= 0x1A,
> +	MAX77802_REG_BUCK2CTRL2		= 0x1B,
> +	MAX77802_REG_BUCK2PHTRAN	= 0x1C,
> +	MAX77802_REG_BUCK2DVS1		= 0x1D,
> +	MAX77802_REG_BUCK2DVS2		= 0x1E,
> +	MAX77802_REG_BUCK2DVS3		= 0x1F,
> +	MAX77802_REG_BUCK2DVS4		= 0x20,
> +	MAX77802_REG_BUCK2DVS5		= 0x21,
> +	MAX77802_REG_BUCK2DVS6		= 0x22,
> +	MAX77802_REG_BUCK2DVS7		= 0x23,
> +	MAX77802_REG_BUCK2DVS8		= 0x24,
> +	/* Reserved: 0x25-0x26 */
> +	MAX77802_REG_BUCK3CTRL1		= 0x27,
> +	MAX77802_REG_BUCK3DVS1		= 0x28,
> +	MAX77802_REG_BUCK3DVS2		= 0x29,
> +	MAX77802_REG_BUCK3DVS3		= 0x2A,
> +	MAX77802_REG_BUCK3DVS4		= 0x2B,
> +	MAX77802_REG_BUCK3DVS5		= 0x2C,
> +	MAX77802_REG_BUCK3DVS6		= 0x2D,
> +	MAX77802_REG_BUCK3DVS7		= 0x2E,
> +	MAX77802_REG_BUCK3DVS8		= 0x2F,
> +	/* Reserved: 0x30-0x36 */
> +	MAX77802_REG_BUCK4CTRL1		= 0x37,
> +	MAX77802_REG_BUCK4DVS1		= 0x38,
> +	MAX77802_REG_BUCK4DVS2		= 0x39,
> +	MAX77802_REG_BUCK4DVS3		= 0x3A,
> +	MAX77802_REG_BUCK4DVS4		= 0x3B,
> +	MAX77802_REG_BUCK4DVS5		= 0x3C,
> +	MAX77802_REG_BUCK4DVS6		= 0x3D,
> +	MAX77802_REG_BUCK4DVS7		= 0x3E,
> +	MAX77802_REG_BUCK4DVS8		= 0x3F,
> +	/* Reserved: 0x40 */
> +	MAX77802_REG_BUCK5CTRL		= 0x41,
> +	MAX77802_REG_BUCK5OUT		= 0x42,
> +	/* Reserved: 0x43 */
> +	MAX77802_REG_BUCK6CTRL		= 0x44,
> +	MAX77802_REG_BUCK6DVS1		= 0x45,
> +	MAX77802_REG_BUCK6DVS2		= 0x46,
> +	MAX77802_REG_BUCK6DVS3		= 0x47,
> +	MAX77802_REG_BUCK6DVS4		= 0x48,
> +	MAX77802_REG_BUCK6DVS5		= 0x49,
> +	MAX77802_REG_BUCK6DVS6		= 0x4A,
> +	MAX77802_REG_BUCK6DVS7		= 0x4B,
> +	MAX77802_REG_BUCK6DVS8		= 0x4C,
> +	/* Reserved: 0x4D */
> +	MAX77802_REG_BUCK7CTRL		= 0x4E,
> +	MAX77802_REG_BUCK7OUT		= 0x4F,
> +	/* Reserved: 0x50 */
> +	MAX77802_REG_BUCK8CTRL		= 0x51,
> +	MAX77802_REG_BUCK8OUT		= 0x52,
> +	/* Reserved: 0x53 */
> +	MAX77802_REG_BUCK9CTRL		= 0x54,
> +	MAX77802_REG_BUCK9OUT		= 0x55,
> +	/* Reserved: 0x56 */
> +	MAX77802_REG_BUCK10CTRL		= 0x57,
> +	MAX77802_REG_BUCK10OUT		= 0x58,
> +
> +	/* Reserved: 0x59-0x5F */
> +
> +	MAX77802_REG_LDO1CTRL1		= 0x60,
> +	MAX77802_REG_LDO2CTRL1		= 0x61,
> +	MAX77802_REG_LDO3CTRL1		= 0x62,
> +	MAX77802_REG_LDO4CTRL1		= 0x63,
> +	MAX77802_REG_LDO5CTRL1		= 0x64,
> +	MAX77802_REG_LDO6CTRL1		= 0x65,
> +	MAX77802_REG_LDO7CTRL1		= 0x66,
> +	MAX77802_REG_LDO8CTRL1		= 0x67,
> +	MAX77802_REG_LDO9CTRL1		= 0x68,
> +	MAX77802_REG_LDO10CTRL1		= 0x69,
> +	MAX77802_REG_LDO11CTRL1		= 0x6A,
> +	MAX77802_REG_LDO12CTRL1		= 0x6B,
> +	MAX77802_REG_LDO13CTRL1		= 0x6C,
> +	MAX77802_REG_LDO14CTRL1		= 0x6D,
> +	MAX77802_REG_LDO15CTRL1		= 0x6E,
> +	/* Reserved: 0x6F */
> +	MAX77802_REG_LDO17CTRL1		= 0x70,
> +	MAX77802_REG_LDO18CTRL1		= 0x71,
> +	MAX77802_REG_LDO19CTRL1		= 0x72,
> +	MAX77802_REG_LDO20CTRL1		= 0x73,
> +	MAX77802_REG_LDO21CTRL1		= 0x74,
> +	MAX77802_REG_LDO22CTRL1		= 0x75,
> +	MAX77802_REG_LDO23CTRL1		= 0x76,
> +	MAX77802_REG_LDO24CTRL1		= 0x77,
> +	MAX77802_REG_LDO25CTRL1		= 0x78,
> +	MAX77802_REG_LDO26CTRL1		= 0x79,
> +	MAX77802_REG_LDO27CTRL1		= 0x7A,
> +	MAX77802_REG_LDO28CTRL1		= 0x7B,
> +	MAX77802_REG_LDO29CTRL1		= 0x7C,
> +	MAX77802_REG_LDO30CTRL1		= 0x7D,
> +	/* Reserved: 0x7E */
> +	MAX77802_REG_LDO32CTRL1		= 0x7F,
> +	MAX77802_REG_LDO33CTRL1		= 0x80,
> +	MAX77802_REG_LDO34CTRL1		= 0x81,
> +	MAX77802_REG_LDO35CTRL1		= 0x82,
> +	/* Reserved: 0x83-0x8F */
> +	MAX77802_REG_LDO1CTRL2		= 0x90,
> +	MAX77802_REG_LDO2CTRL2		= 0x91,
> +	MAX77802_REG_LDO3CTRL2		= 0x92,
> +	MAX77802_REG_LDO4CTRL2		= 0x93,
> +	MAX77802_REG_LDO5CTRL2		= 0x94,
> +	MAX77802_REG_LDO6CTRL2		= 0x95,
> +	MAX77802_REG_LDO7CTRL2		= 0x96,
> +	MAX77802_REG_LDO8CTRL2		= 0x97,
> +	MAX77802_REG_LDO9CTRL2		= 0x98,
> +	MAX77802_REG_LDO10CTRL2		= 0x99,
> +	MAX77802_REG_LDO11CTRL2		= 0x9A,
> +	MAX77802_REG_LDO12CTRL2		= 0x9B,
> +	MAX77802_REG_LDO13CTRL2		= 0x9C,
> +	MAX77802_REG_LDO14CTRL2		= 0x9D,
> +	MAX77802_REG_LDO15CTRL2		= 0x9E,
> +	/* Reserved: 0x9F */
> +	MAX77802_REG_LDO17CTRL2		= 0xA0,
> +	MAX77802_REG_LDO18CTRL2		= 0xA1,
> +	MAX77802_REG_LDO19CTRL2		= 0xA2,
> +	MAX77802_REG_LDO20CTRL2		= 0xA3,
> +	MAX77802_REG_LDO21CTRL2		= 0xA4,
> +	MAX77802_REG_LDO22CTRL2		= 0xA5,
> +	MAX77802_REG_LDO23CTRL2		= 0xA6,
> +	MAX77802_REG_LDO24CTRL2		= 0xA7,
> +	MAX77802_REG_LDO25CTRL2		= 0xA8,
> +	MAX77802_REG_LDO26CTRL2		= 0xA9,
> +	MAX77802_REG_LDO27CTRL2		= 0xAA,
> +	MAX77802_REG_LDO28CTRL2		= 0xAB,
> +	MAX77802_REG_LDO29CTRL2		= 0xAC,
> +	MAX77802_REG_LDO30CTRL2		= 0xAD,
> +	/* Reserved: 0xAE */
> +	MAX77802_REG_LDO32CTRL2		= 0xAF,
> +	MAX77802_REG_LDO33CTRL2		= 0xB0,
> +	MAX77802_REG_LDO34CTRL2		= 0xB1,
> +	MAX77802_REG_LDO35CTRL2		= 0xB2,
> +	/* Reserved: 0xB3 */
> +
> +	MAX77802_REG_BBAT_CHG		= 0xB4,
> +	MAX77802_REG_32KHZ		= 0xB5,
> +
> +	MAX77802_REG_PMIC_END		= 0xB6,
> +};
> +
> +enum max77802_rtc_reg {
> +	MAX77802_RTC_INT		= 0xC0,
> +	MAX77802_RTC_INTM		= 0xC1,
> +	MAX77802_RTC_CONTROLM		= 0xC2,
> +	MAX77802_RTC_CONTROL		= 0xC3,
> +	MAX77802_RTC_UPDATE0		= 0xC4,
> +	MAX77802_RTC_UPDATE1		= 0xC5,
> +	MAX77802_WTSR_SMPL_CNTL		= 0xC6,
> +	MAX77802_RTC_SEC		= 0xC7,
> +	MAX77802_RTC_MIN		= 0xC8,
> +	MAX77802_RTC_HOUR		= 0xC9,
> +	MAX77802_RTC_WEEKDAY		= 0xCA,
> +	MAX77802_RTC_MONTH		= 0xCB,
> +	MAX77802_RTC_YEAR		= 0xCC,
> +	MAX77802_RTC_DATE		= 0xCD,
> +	MAX77802_RTC_AE1		= 0xCE,
> +	MAX77802_ALARM1_SEC		= 0xCF,
> +	MAX77802_ALARM1_MIN		= 0xD0,
> +	MAX77802_ALARM1_HOUR		= 0xD1,
> +	MAX77802_ALARM1_WEEKDAY		= 0xD2,
> +	MAX77802_ALARM1_MONTH		= 0xD3,
> +	MAX77802_ALARM1_YEAR		= 0xD4,
> +	MAX77802_ALARM1_DATE		= 0xD5,
> +	MAX77802_RTC_AE2		= 0xD6,
> +	MAX77802_ALARM2_SEC		= 0xD7,
> +	MAX77802_ALARM2_MIN		= 0xD8,
> +	MAX77802_ALARM2_HOUR		= 0xD9,
> +	MAX77802_ALARM2_WEEKDAY		= 0xDA,
> +	MAX77802_ALARM2_MONTH		= 0xDB,
> +	MAX77802_ALARM2_YEAR		= 0xDC,
> +	MAX77802_ALARM2_DATE		= 0xDD,
> +
> +	MAX77802_RTC_END		= 0xDF,
> +};
> +
> +#define MAX77802_IRQSRC_PMIC            (0)

Shouldn't it be BIT(0) or BIT(1)? It looks odd.

> +#define MAX77802_IRQSRC_RTC	        BIT(0)

Anyway, are these defines used anywhere? Seems not. 

Best regards,
Krzysztof

