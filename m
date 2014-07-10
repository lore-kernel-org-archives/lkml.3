Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaGJPRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:17:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64534 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaGJPRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:17:51 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-1d-53beae9cf6cd
From: Kamil Debski <k.debski@samsung.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1404917600-4430-1-git-send-email-k.debski@samsung.com>
 <20140709165817.GA24842@roeck-us.net>
In-reply-to: <20140709165817.GA24842@roeck-us.net>
Subject: RE: [lm-sensors] [PATCH] hwmon: pwm-fan: Add pwm-fan driver
Date: Thu, 10 Jul 2014 17:17:54 +0200
Message-id: <107401cf9c52$1fe0a0e0$5fa1e2a0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+blwAJnEaTCVqDQXqAN4TbaxFC4wAj+Jzg
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xa7pz1u0LNmi6qWMx/8g5VovLu+aw
	WTxZeIbJ4s60vWwWa4/cZbdYP+M1iwObx4OJu9k8dn5vYPfo27KK0ePzJrkAligum5TUnMyy
	1CJ9uwSujC3fJ7EX3Auv6Hv5lLWB8bpzFyMnh4SAicSWvyvZIGwxiQv31oPZQgJLGSV2PlXq
	YuQCshuYJF58fM3axcjBwSagKbHqngdIjYiAhsT1KXMYQWxmgVWMEqeWS0D0Zktc/3afGcTm
	FDCSmDF1BROILSzgInHr2g+wOIuAqsSJji9gvbwCDhKbG+awQNiCEj8m32OBmKklsX7ncSYI
	W15i85q3zCAnSAioSzz6qwtxgpHEh6szoMpFJO42PGedwCg0C8mkWUgmzUIyaRaSlgWMLKsY
	RVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQqLiyw7GxcesDjEKcDAq8fBq1O4OFmJNLCuuzD3E
	KMHBrCTCW75iX7AQb0piZVVqUX58UWlOavEhRiYOTqkGxoTvxjoHImPLps69wCbnEtj+ufpa
	6RGOtKUXXzx8fS4pqv7DUy224Kf3WjQ3rnw+9VXnsj0Pl1f8jVh/dKHLE7VNwlwHJ7Vd7TTm
	6WhK3nDMc/MPKU5uyZD93+797t0aoX0gdJrFcqGVRr6F7P988qZFdn6fLtmv8uHvl1OvO95+
	SN6xeeMct0glluKMREMt5qLiRAARKCRhaAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Thank you for your review.

> From: Guenter Roeck [mailto:groeck7@gmail.com] On Behalf Of Guenter
> Roeck
> Sent: Wednesday, July 09, 2014 6:58 PM
> 
> On Wed, Jul 09, 2014 at 04:53:20PM +0200, Kamil Debski wrote:
> > The pwm-fan driver enables control of fans connected to PWM lines.
> > This driver uses the PWM framework, so it is compatible with all PWM
> > devices that provide drivers through the PWM framework.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > ---
> >  .../devicetree/bindings/hwmon/pwm-fan.txt          |   12 ++
> >  drivers/hwmon/Kconfig                              |    9 +
> >  drivers/hwmon/Makefile                             |    1 +
> >  drivers/hwmon/pwm-fan.c                            |  199
> ++++++++++++++++++++
> >  4 files changed, 221 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> >  create mode 100644 drivers/hwmon/pwm-fan.c
> 
> Documentation/hwmon/pwm-fan is missing.

Ok, I will add it.
 
> >
> > diff --git a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> > b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> > new file mode 100644
> > index 0000000..f534607
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> > @@ -0,0 +1,12 @@
> > +Bindings for a fan connected to the PWM lines
> > +
> > +Required properties:
> > +- compatible: "pwm-fan"
> > +- pwms: the PWM that is used to control the PWM fan
> > +
> > +Example:
> > +	pwm-fan {
> > +		compatible = "pwm-fan";
> > +		status = "okay";
> > +		pwms = <&pwm 0 10000 0>;
> > +	};
> > diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig index
> > 08531a1..838ffb8 100644
> > --- a/drivers/hwmon/Kconfig
> > +++ b/drivers/hwmon/Kconfig
> > @@ -1104,6 +1104,15 @@ config SENSORS_PCF8591
> >
> >  source drivers/hwmon/pmbus/Kconfig
> >
> > +config SENSORS_PWM_FAN
> > +	tristate "PWM fan"
> > +	depends on PWM
> > +	help
> > +	  If you say yes here you get support for fans connected to PWM
> lines.
> > +
> > +	  This driver can also be built as a module.  If so, the module
> > +	  will be called pwm-fan.
> > +
> >  config SENSORS_SHT15
> >  	tristate "Sensiron humidity and temperature sensors. SHT15 and
> compat."
> >  	depends on GPIOLIB
> > diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile index
> > 3dc0f02..3967ecf 100644
> > --- a/drivers/hwmon/Makefile
> > +++ b/drivers/hwmon/Makefile
> > @@ -120,6 +120,7 @@ obj-$(CONFIG_SENSORS_NTC_THERMISTOR)	+=
> ntc_thermistor.o
> >  obj-$(CONFIG_SENSORS_PC87360)	+= pc87360.o
> >  obj-$(CONFIG_SENSORS_PC87427)	+= pc87427.o
> >  obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
> > +obj-$(CONFIG_SENSORS_PWM_FAN)	+= pwm-fan.o
> >  obj-$(CONFIG_SENSORS_S3C)	+= s3c-hwmon.o
> >  obj-$(CONFIG_SENSORS_SCH56XX_COMMON)+= sch56xx-common.o
> >  obj-$(CONFIG_SENSORS_SCH5627)	+= sch5627.o
> > diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c new
> > file mode 100644 index 0000000..78fa627
> > --- /dev/null
> > +++ b/drivers/hwmon/pwm-fan.c
> > @@ -0,0 +1,199 @@
> > +/*
> > + * pwm-fan.c - Hwmon driver for fans connected to PWM lines.
> > + *
> > + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> > + *
> > + * Author: Kamil Debski <k.debski@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License as published
> > +by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> > +02111-1307  USA
> 
> Please run the patch through checkpatch and ensure that all warnings
> and errors are fixed.

I did checkpatch with -f by mistake, so it missed this error. Thanks for
pointing this out.

> > + */
> > +
> > +#include <linux/hwmon-sysfs.h>
> > +#include <linux/hwmon.h>
> > +#include <linux/module.h>
> > +#include <linux/mutex.h>
> > +#include <linux/of.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/pwm.h>
> 
> For new drivers, please list include files in alphabetic order.

Ok.

> 
> > +
> > +#define MAX_PWM 255
> > +
> > +struct pwm_fan_ctx {
> > +	struct device *hwmon;
> > +	struct mutex lock;
> > +	struct platform_device *pdev;
> > +	struct pwm_device *pwm;
> > +	unsigned int duty_cycle;
> > +	unsigned char pwm_value;
> > +};
> > +
> > +static ssize_t show_pwm_enable(struct device *dev,
> > +			       struct device_attribute *attr, char *buf) {
> > +	/* For the sake of simplicity only mode 1 (PWM) is supported */
> > +	return sprintf(buf, "1\n");
> > +}
> > +
> > +static ssize_t set_pwm(struct device *dev, struct device_attribute
> *attr,
> > +		       const char *buf, size_t count) {
> > +	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
> > +	unsigned long pwm, duty;
> > +
> > +	if (kstrtoul(buf, 10, &pwm) || pwm > MAX_PWM)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&ctx->lock);
> > +
> > +	if (ctx->pwm_value == pwm)
> > +		goto exit_set_pwm;
> > +
> > +	duty =  DIV_ROUND_UP(pwm * (ctx->pwm->period - 1), MAX_PWM);
> 
> Unnecessary double space.

Right.

> 
> > +	if (pwm_config(ctx->pwm, duty, ctx->pwm->period))
> > +		goto exit_set_pwm;
> 
> Please return the error code.

Right.

> 
> > +
> > +	ctx->duty_cycle = duty;
> > +	ctx->pwm_value = pwm;
> > +
> > +
> Single empty line only please.

Ok.

> 
> > +exit_set_pwm:
> > +	mutex_unlock(&ctx->lock);
> > +
> > +	return count;
> > +}
> > +
> > +static ssize_t show_pwm(struct device *dev,
> > +			struct device_attribute *attr, char *buf) {
> > +	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
> > +
> > +	return sprintf(buf, "%d\n", ctx->pwm_value);
> 
> pwm_value is unsigned, so please use %u.

Ok.

> 
> > +}
> > +
> > +
> Single empty line only please

Ok.

> 
> > +static SENSOR_DEVICE_ATTR(pwm1_enable, S_IRUGO | S_IWUSR,
> > +		   show_pwm_enable, NULL, 0);
> 
> Is this attribute really needed ?

I it can be omitted then I see no problem removing this.

> 
> > +static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO | S_IWUSR,
> > +		   show_pwm, set_pwm, 0);
> > +
> > +static struct attribute *pwm_fan_attributes[] = {
> > +	&sensor_dev_attr_pwm1_enable.dev_attr.attr,
> > +	&sensor_dev_attr_pwm1.dev_attr.attr,
> > +	NULL,
> > +};
> > +
> > +static const struct attribute_group pwm_fan_group = {
> > +	.attrs = pwm_fan_attributes,
> > +};
> > +
> > +static const struct attribute_group *pwm_fan_groups[] = {
> > +	&pwm_fan_group,
> > +	NULL
> > +};
> 
> Please use the ATTRIBUTE_GROUPS macro.

Ok.

> 
> > +
> > +static int pwm_fan_probe(struct platform_device *pdev) {
> > +	struct pwm_fan_ctx *ctx;
> > +
> > +	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
> > +	if (!ctx) {
> > +		dev_err(&pdev->dev, "Not enough memory for PWM fan
> device\n");
> 
> Unnecessary error message.

Ok.

> 
> > +		return -ENOMEM;
> > +	}
> > +
> > +	ctx->pdev = pdev;
> > +	mutex_init(&ctx->lock);
> > +
> > +	ctx->pwm = devm_of_pwm_get(&pdev->dev, pdev->dev.of_node, 0);
> 
> Last argument is a string pointer. Please use NULL.

Ok.

> 
> > +	if (IS_ERR(ctx->pwm)) {
> > +		dev_err(&pdev->dev, "Could not get PWM");
> > +		return -EINVAL;
> 
> Return PTR_ERR(ctx->pwm).

Right.

> 
> > +	}
> > +
> > +	dev_set_drvdata(&pdev->dev, ctx);
> > +	platform_set_drvdata(pdev, ctx);
> > +
> > +	/* Set duty cycle to maximum allowed */
> > +	ctx->duty_cycle = ctx->pwm->period - 1;
> > +	ctx->pwm_value = MAX_PWM;
> > +	pwm_config(ctx->pwm, ctx->duty_cycle, ctx->pwm->period);

Guenter, I have a question regarding this. I see that gpio-fan reads
the state of gpios and uses this as the initial setting. 
Led-pwm on init sets the brightness to LED_OFF.

What should be the default state after init? Should the fan be off or
at full power? I am thinking about adding an optional node to device
tree that could be used to set this. But the question remains - what
should be the default setting?

> 
> pwm_config() can return an error. Why not check it here ?

Right.

> 
> > +
> > +	ctx->hwmon = hwmon_device_register_with_groups(&pdev->dev,
> "pwmfan",
> > +		ctx, pwm_fan_groups);
> 
> Why not devm_hwmon_device_register_with_groups ?

You're right.

> 
> > +
> > +	if (IS_ERR(ctx->hwmon)) {
> > +		dev_err(&pdev->dev, "Failed to register hwmon device");
> > +		return PTR_ERR(ctx->hwmon);
> > +	}
> > +
> > +	/* Enbale PWM output */
> > +	pwm_enable(ctx->pwm);
> > +
> > +	return 0;
> > +}
> > +
> > +static int pwm_fan_remove(struct platform_device *pdev) {
> > +	struct pwm_fan_ctx *ctx = platform_get_drvdata(pdev);
> > +
> > +	pwm_disable(ctx->pwm);
> 
> Is this needed ? I don't see it used by the leds-pwm driver on cleanup.
> 
> > +	hwmon_device_unregister(ctx->hwmon);
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int pwm_fan_suspend(struct device *dev) {
> > +	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
> > +
> > +	return pwm_config(ctx->pwm, 0, ctx->pwm->period);
> 
> Wonder if this should be pwm_disable instead (and pwm_enable on resume).
> Any thoughts ?

I think this is a good idea. I had also looked on the leds-pwm, that you
mentioned, and the driver also runs pwm_disable for pwm setting of 0, which
seems like a good idea as well.
 
> > +}
> > +
> > +static int pwm_fan_resume(struct device *dev) {
> > +	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
> > +
> > +	return pwm_config(ctx->pwm, ctx->duty_cycle, ctx->pwm->period); }
> > +
> > +static SIMPLE_DEV_PM_OPS(pwm_fan_pm, pwm_fan_suspend,
> > +pwm_fan_resume); #endif
> > +
> > +
> > +
> Single empty line only please

Ok.

> 
> > +static struct of_device_id of_pwm_fan_match[] = {
> > +	{ .compatible = "pwm-fan", },
> > +	{},
> > +};
> > +
> > +static struct platform_driver pwm_fan_driver = {
> > +	.probe		= pwm_fan_probe,
> > +	.remove		= pwm_fan_remove,
> > +	.driver	= {
> > +		.name		= "pwm-fan",
> > +#ifdef CONFIG_PM_SLEEP
> > +		.pm		= &pwm_fan_pm,
> > +#endif
> > +		.of_match_table	= of_match_ptr(of_pwm_fan_match),
> > +	},
> > +};
> > +
> > +module_platform_driver(pwm_fan_driver);
> > +
> > +MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
> > +MODULE_ALIAS("platform:pwm-fan");
> > +MODULE_DESCRIPTION("PWM FAN driver"); MODULE_LICENSE("GPL");
> > --
> > 1.7.9.5
> >
> >
> > _______________________________________________
> > lm-sensors mailing list
> > lm-sensors@lm-sensors.org
> > http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
> >

