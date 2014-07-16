Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440AbaGPPql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:46:41 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29707 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965053AbaGPPqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:46:38 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-3c-53c69e5baa7c
From: Kamil Debski <k.debski@samsung.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, tklauser@distanz.ch,
        linux-pwm@vger.kernel.org, varkabhadram@gmail.com
References: <1405505014-24983-1-git-send-email-k.debski@samsung.com>
 <53C683B7.9090805@roeck-us.net>
In-reply-to: <53C683B7.9090805@roeck-us.net>
Subject: RE: [PATCH v4] hwmon: pwm-fan: Add pwm-fan driver
Date: Wed, 16 Jul 2014 17:46:35 +0200
Message-id: <096c01cfa10d$206265c0$61273140$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+g/UKBB5fWmQ+PQtaYCPRkXs++IQADzX0w
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xq7rR844FG/y/yGwx/8g5VovLu+aw
	Wdy9u4rR4snCM0wWd6btZbNYe+Quu8X6Ga9ZLA4c+MtocbJjDqMDp8eVU6fZPXbOusvu8WDi
	bjaPnd8b2D36tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoErY9tC+4L3CRU/7nSxNjBe8+pi5OSQ
	EDCR6Fw6mw3CFpO4cG89kM3FISSwlFFi47luKKeBSeLo4WOsXYwcHGwCmhKr7nmAmCIC9RJr
	npWClDALzGWUeDRrBgvIICGBNIlFb1+xg9icAjoS3+b/YAepFxawkpi0sBQkzCKgKrFr+gxG
	EJtXwEFi+amDzBC2oMSPyffAxjALaEms33mcCcKWl9i85i0zyBgJAXWJR391QcIiAkYSTV3b
	GCFKRCTuNjxnncAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3
	MUKi6MsOxsXHrA4xCnAwKvHwMsw+GizEmlhWXJl7iFGCg1lJhHfarGPBQrwpiZVVqUX58UWl
	OanFhxiZODilGhhXxGhEiL5eVnkh4eSzj/UmVfsi5/9dJvDvWJykvwh36+kDHJ1ftU8enX7t
	54kH+g7L/UXnJctdCTgke2xlc0PXjvh90d/6/n2Ra9pVFVjlF5XeOPvm3C+xjsqTol89fXYo
	qyfRbMGGhkNZxVWfeRfYBn+OmRa9IDhulu48no/lEksb5jKH++gpsRRnJBpqMRcVJwIA9SYt
	wIACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> From: Guenter Roeck [mailto:linux@roeck-us.net]
> Sent: Wednesday, July 16, 2014 3:53 PM
> To: Kamil Debski; devicetree@vger.kernel.org; linux-
> kernel@vger.kernel.org; lm-sensors@lm-sensors.org
> Cc: t.figa@samsung.com; m.szyprowski@samsung.com; tklauser@distanz.ch;
> linux-pwm@vger.kernel.org; varkabhadram@gmail.com
> Subject: Re: [PATCH v4] hwmon: pwm-fan: Add pwm-fan driver
> 
> Hi Kamil,
> 
> comments inline.

Thank you for your review :-)

> 
> Thanks,
> Guenter
> 
> On 07/16/2014 03:03 AM, Kamil Debski wrote:
> > The pwm-fan driver enables control of fans connected to PWM lines.
> > This driver uses the PWM framework, so it is compatible with all PWM
> > devices that provide drivers through the PWM framework.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > ---
> > Changes since v3:
> > - fix missing "\n" in error messages
> > - remove of_match_ptr which was not necessary
> > - change error returned in case of failed allocation to -ENOMEM
> > Changes since v2:
> > - add CONFIG_PM_SLEEP around pwm_fan_suspend and pwm_fan_resume
> > Changes since v1:
> > - added documentation to Documentation/hwmon
> > - fix checkpatch errors
> > 	- added extra description to Kconfig
> > 	- removed whitespace errors
> > - include files rearranged to be in alphabetical order
> > - remove unused sysfs entry pwm1_enable
> > - changed the behavior of the set_pwm function
> > 	- when 0 PWM value is set pwm_disable is run
> > 	- pwm_config return value is checked for errors
> > - use of ATTRIBUTE_GROUPS was added
> > - removed "Not enouch memory" error message
> > - fixed probe return value in case of devm_of_pwm_get error
> > - changed hwmon_device_register_with_groups to
> >    devm_hwmon_device_register_with_groups
> > - changes suspend/resume to use pwm_disable/enable
> > - removed unnecessary CONFIG_PM_SLEEP ifdefs
> > ---
> >   .../devicetree/bindings/hwmon/pwm-fan.txt          |   12 ++
> >   Documentation/hwmon/pwm-fan                        |   17 ++
> >   drivers/hwmon/Kconfig                              |   11 ++
> >   drivers/hwmon/Makefile                             |    1 +
> >   drivers/hwmon/pwm-fan.c                            |  202
> ++++++++++++++++++++
> >   5 files changed, 243 insertions(+)
> >   create mode 100644 Documentation/devicetree/bindings/hwmon/pwm-
> fan.txt
> >   create mode 100644 Documentation/hwmon/pwm-fan
> >   create mode 100644 drivers/hwmon/pwm-fan.c
> >
> > diff --git a/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> > b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> > new file mode 100644
> > index 0000000..610757c
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> > @@ -0,0 +1,12 @@
> > +Bindings for a fan connected to the PWM lines
> > +
> > +Required properties:
> > +- compatible	: "pwm-fan"
> > +- pwms		: the PWM that is used to control the PWM fan
> > +
> > +Example:
> > +	pwm-fan {
> > +		compatible = "pwm-fan";
> > +		status = "okay";
> > +		pwms = <&pwm 0 10000 0>;
> > +	};
> > diff --git a/Documentation/hwmon/pwm-fan b/Documentation/hwmon/pwm-
> fan
> > new file mode 100644 index 0000000..18529d2
> > --- /dev/null
> > +++ b/Documentation/hwmon/pwm-fan
> > @@ -0,0 +1,17 @@
> > +Kernel driver pwm-fan
> > +=====================
> > +
> > +This driver enables the use of a PWM module to drive a fan. It uses
> > +the generic PWM interface thus it is hardware independent. It can be
> > +used on many SoCs, as long as the SoC supplies a PWM line driver
> that
> > +exposes the generic PWM API.
> > +
> > +Author: Kamil Debski <k.debski@samsung.com>
> > +
> > +Description
> > +-----------
> > +
> > +The driver implements a simple interface for driving a fan connected
> > +to a PWM output. It uses the generic PWM interface, thus it can be
> > +used with a range of SoCs. The driver exposes the fan to the user
> > +space through the hwmon's sysfs interface.
> > diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig index
> > 02d3d85..4ac13ab 100644
> > --- a/drivers/hwmon/Kconfig
> > +++ b/drivers/hwmon/Kconfig
> > @@ -1105,6 +1105,17 @@ config SENSORS_PCF8591
> >
> >   source drivers/hwmon/pmbus/Kconfig
> >
> > +config SENSORS_PWM_FAN
> > +	tristate "PWM fan"
> > +	depends on PWM
> > +	help
> > +	  If you say yes here you get support for fans connected to PWM
> lines.
> > +	  The driver uses the generic PWM interface, thus it will work on
> a
> > +	  variety of SoCs.
> > +
> > +	  This driver can also be built as a module.  If so, the module
> > +	  will be called pwm-fan.
> > +
> >   config SENSORS_SHT15
> >   	tristate "Sensiron humidity and temperature sensors. SHT15 and
> compat."
> >   	depends on GPIOLIB
> > diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile index
> > 3dc0f02..3967ecf 100644
> > --- a/drivers/hwmon/Makefile
> > +++ b/drivers/hwmon/Makefile
> > @@ -120,6 +120,7 @@ obj-$(CONFIG_SENSORS_NTC_THERMISTOR)	+=
> ntc_thermistor.o
> >   obj-$(CONFIG_SENSORS_PC87360)	+= pc87360.o
> >   obj-$(CONFIG_SENSORS_PC87427)	+= pc87427.o
> >   obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
> > +obj-$(CONFIG_SENSORS_PWM_FAN)	+= pwm-fan.o
> >   obj-$(CONFIG_SENSORS_S3C)	+= s3c-hwmon.o
> >   obj-$(CONFIG_SENSORS_SCH56XX_COMMON)+= sch56xx-common.o
> >   obj-$(CONFIG_SENSORS_SCH5627)	+= sch5627.o
> > diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c new
> > file mode 100644 index 0000000..cacb20a
> > --- /dev/null
> > +++ b/drivers/hwmon/pwm-fan.c
> > @@ -0,0 +1,202 @@
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
> > + */
> > +
> > +#include <linux/hwmon.h>
> > +#include <linux/hwmon-sysfs.h>
> > +#include <linux/module.h>
> > +#include <linux/mutex.h>
> > +#include <linux/of.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/pwm.h>
> > +#include <linux/sysfs.h>
> > +
> > +#define MAX_PWM 255
> > +
> > +struct pwm_fan_ctx {
> > +	struct device *hwmon;
> > +	struct mutex lock;
> > +	struct platform_device *pdev;
> 
> Neither hwmon nor pdev are used anywhere and are thus unnecessary.

Right.

> 
> > +	struct pwm_device *pwm;
> > +	unsigned int duty_cycle;
> 
> duty_cycle is only used in the probe function, and is thus unnecessary
> as well.

I agree.

> 
> > +	unsigned char pwm_value;
> > +};
> > +
> > +static ssize_t set_pwm(struct device *dev, struct device_attribute
> *attr,
> > +		       const char *buf, size_t count) {
> > +	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
> > +	unsigned long pwm, duty;
> > +	int ret;

I also changed this to ssize_t ret to match the return value of the
function.

> > +
> > +	if (kstrtoul(buf, 10, &pwm) || pwm > MAX_PWM)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&ctx->lock);
> > +
> > +	if (ctx->pwm_value == pwm)
> > +		goto exit_set_pwm;
> > +
> > +	if (pwm == 0) {
> > +		pwm_disable(ctx->pwm);
> > +		ctx->pwm_value = pwm;
> > +		goto exit_set_pwm;
> 
> You can add another label below to save the double assignment.

Good idea, thanks.

> 
> > +	}
> > +
> > +	duty = DIV_ROUND_UP(pwm * (ctx->pwm->period - 1), MAX_PWM);
> > +	ret = pwm_config(ctx->pwm, duty, ctx->pwm->period);
> > +	if (ret) {
> > +		count = ret; /* Set the return value */
> 
> Subtle problem: count is of type size_t which is unsigned. Sure it may
> well be that the negative value is converted to unsigned and then
> converted back to signed on return, but it is not a good idea to depend
> on it. I would suggest to return ret and assign
> 	ret = count;
> in the success case further below. You'll need an extra label for the
> success cases above.

Good idea.
 
> > +		goto exit_set_pwm;
> > +	}
> > +
> > +	if (ctx->pwm_value == 0)
> > +		ret = pwm_enable(ctx->pwm);
> > +	if (ret) {
> > +		count = ret; /* Set the return value */
> > +		goto exit_set_pwm;
> > +	}
> 
> This check for ret should really be within the if() statement.

Right, I missed it.

> 
> > +
> > +	ctx->duty_cycle = duty;
> > +	ctx->pwm_value = pwm;
> > +
> > +exit_set_pwm:
> > +	mutex_unlock(&ctx->lock);
> > +	return count;
> > +}
> > +
> > +static ssize_t show_pwm(struct device *dev,
> > +			struct device_attribute *attr, char *buf) {
> > +	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
> > +
> > +	return sprintf(buf, "%u\n", ctx->pwm_value); }
> > +
> > +
> > +static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO | S_IWUSR,
> > +		   show_pwm, set_pwm, 0);
> > +
> Continuation line is not needed here.

Ok.

> 
> > +static struct attribute *pwm_fan_attrs[] = {
> > +	&sensor_dev_attr_pwm1.dev_attr.attr,
> > +	NULL,
> > +};
> > +
> > +ATTRIBUTE_GROUPS(pwm_fan);
> > +
> > +static int pwm_fan_probe(struct platform_device *pdev) {
> > +	struct pwm_fan_ctx *ctx;
> > +	int ret;
> > +
> > +	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
> > +	if (!ctx)
> > +		return -ENOMEM;
> > +
> > +	ctx->pdev = pdev;
> > +	mutex_init(&ctx->lock);
> > +
> > +	ctx->pwm = devm_of_pwm_get(&pdev->dev, pdev->dev.of_node, 0);
> > +	if (IS_ERR(ctx->pwm)) {
> > +		dev_err(&pdev->dev, "Could not get PWM\n");
> > +		return PTR_ERR(ctx->pwm);
> > +	}
> > +
> > +	dev_set_drvdata(&pdev->dev, ctx);
> > +	platform_set_drvdata(pdev, ctx);
> > +
> > +	/* Set duty cycle to maximum allowed */
> > +	ctx->duty_cycle = ctx->pwm->period - 1;
> > +	ctx->pwm_value = MAX_PWM;
> > +
> > +	ret = pwm_config(ctx->pwm, ctx->duty_cycle, ctx->pwm->period);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to configure PWM\n");
> > +		return ret;
> > +	}
> > +
> > +	/* Enbale PWM output */
> > +	ret = pwm_enable(ctx->pwm);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to enable PWM\n");
> > +		return ret;
> > +	}
> > +
> > +	ctx->hwmon = devm_hwmon_device_register_with_groups(&pdev->dev,
> > +							    "pwmfan", ctx,
> > +							    pwm_fan_groups);
> > +
> > +	if (IS_ERR(ctx->hwmon)) {
> > +		dev_err(&pdev->dev, "Failed to register hwmon device\n");
> > +		pwm_disable(ctx->pwm);
> > +		return PTR_ERR(ctx->hwmon);
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int pwm_fan_remove(struct platform_device *pdev) {
> > +	struct pwm_fan_ctx *ctx = platform_get_drvdata(pdev);
> > +
> > +	if (ctx->pwm_value)
> > +		pwm_disable(ctx->pwm);
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int pwm_fan_suspend(struct device *dev) {
> > +	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
> > +
> > +	if (ctx->pwm_value)
> > +		pwm_disable(ctx->pwm);
> > +	return 0;
> > +}
> > +
> > +static int pwm_fan_resume(struct device *dev) {
> > +	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
> > +
> > +	if (ctx->pwm_value)
> > +		return pwm_enable(ctx->pwm);
> > +	return 0;
> > +}
> > +#endif
> > +
> > +static SIMPLE_DEV_PM_OPS(pwm_fan_pm, pwm_fan_suspend,
> > +pwm_fan_resume);
> > +
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
> > +		.pm		= &pwm_fan_pm,
> > +		.of_match_table	= of_pwm_fan_match,
> > +	},
> > +};
> > +
> > +module_platform_driver(pwm_fan_driver);
> > +
> > +MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
> > +MODULE_ALIAS("platform:pwm-fan");
> > +MODULE_DESCRIPTION("PWM FAN driver"); MODULE_LICENSE("GPL");
> >

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

