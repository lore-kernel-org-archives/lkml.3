Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3FPWHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:07:22 -0400
Received: from nm22.access.bullet.mail.sp2.yahoo.com ([98.139.44.149]:35995
	"EHLO nm22.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557Ab3FPWHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:07:09 -0400
X-Yahoo-Newman-Id: 839064.5214.bm@smtp104.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: t3NflLkVM1mWoTEODmyMO0alOETPKtA4L7EmLo7tLZ8nLEQ
 FeQbIWDdR3OqqqG3CcXyPktBwg5YWANc59JsOlLnK5hrkvhd3HIHzE.vTd7W
 Yfbmey9zLrNAxnh3k1bTad5sbx9_TWx9t57zUAO.Hg0KRwJOAU2g8nMHlawU
 9za5cQnOuRfjXXxmgqZaQ4KlYqbc.M6MfSW8UjtxJtFGeNuGvIL8obbl_xKo
 UY5a5gU_99BTGrS76bdRHRzEE0JgDTOvF9DLUdmeklzefh1SU7BZGYmdsUiO
 pEBB8IWm7lDDIPpd15NUs_1vCWmVB5UFnzqBwfFnZc2GZjeMlb4koU5nWYEv
 jGXb2DG09GYJiaQsGhxzCufcpvcKL4b45wjDMJeJB.izmnjjmuRRlE774B_T
 lx6LISl0SCJOrSVgz5_p7cqnPfbmaK8bJZNmXIfdHyvR4MrzPdguS.67OQ4M
 gEGwK.Vvlp1CImd8Tc9LAbbfa5FFxJFj2Alhu4ggUNSpKLaWgCChEI3THJmE
 .EuFPDLx.oJbuinI-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp104.sbc.mail.gq1.yahoo.com with SMTP; 16 Jun 2013 15:07:08 -0700 PDT
Date: Sun, 16 Jun 2013 15:07:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: wim@iguana.be, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, guenter@roeck-us.net
Subject: Re: [PATCH v9] watchdog: New watchdog driver for MEN A21 watchdogs
Message-ID: <20130616220715.GB32107@roeck-us.net>
References: <20130603143453.GA14251@jtlinux>
 <20130614105831.GA9334@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614105831.GA9334@jtlinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 12:58:37PM +0200, Johannes Thumshirn wrote:
> This patch adds the driver for the watchdog devices found on MEN Mikro
> Elektronik A21 VMEbus CPU Carrier Boards. It has DT-support and uses the
> watchdog framework.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>

Only nitpicks this time.

> ---
> 
>  Revision 2:
>  * Removed unneeded open flag in struct a21_wdt_drv
>  * Corrected 3bit reason code from gpio
>  * Additional sysfs files are now part of watchdog sysfs
>  * Changed OFF/ON delay in ping from 400ms to 10ns
>  * Reworked timeout setting
>  * Removed a21_wdt_ioctl(...)
> 
>  Revision 3:
>  * Changed pr_{err,info} to dev_{err,info}
>  * Removed out of memory error print
>  * Transition from "fast" to "slow" mode not allowed by chip
> 
>  Revision 4:
>  * Remove reboot_notifier and place disable code into platform_device's shutdown function
>  * Removed sysfs interface
> 
>  Revision 5:
>  * Added setting of .bootstatus on driver init
>  * Added initial timeout on driver init
> 
>  Revision 6:
>  * Use watchdog_init_timeout() to initialize timeout
> 
>  Revision 7:
>  * Fix possible get_bootstatus race condition
> 
>  Revision 8:
>  * a21_wdt_get_bootstatus() should return reset code
>  * GPIOs are supplied via DT instead of being hardcoded. Code derived from
>    (drivers/hwmon/gpio-fan.c)
>  * Added Devicetree binding document
>  * Driver now depends on GPIOLIB
> 
>  Revision 9:
>  * We need 6 GPIOs not only 1 to work
>  * GPIO_WD_RST[0..2] are inputs
> 
>  .../devicetree/bindings/gpio/men-a021-wdt.txt      |   25 ++
>  MAINTAINERS                                        |    6 +
>  drivers/watchdog/Kconfig                           |   12 +
>  drivers/watchdog/Makefile                          |    1 +
>  drivers/watchdog/mena21_wdt.c                      |  276 ++++++++++++++++++++
>  5 files changed, 320 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/men-a021-wdt.txt
>  create mode 100644 drivers/watchdog/mena21_wdt.c
> 
> diff --git a/Documentation/devicetree/bindings/gpio/men-a021-wdt.txt b/Documentation/devicetree/bindings/gpio/men-a021-wdt.txt
> new file mode 100644
> index 0000000..370dee3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/men-a021-wdt.txt
> @@ -0,0 +1,25 @@
> +Bindings for MEN A21 Watchdog device connected to GPIO lines
> +
> +Required properties:
> +- compatible: "men,a021-wdt"
> +- gpios: Specifies the pins that control the Watchdog, order:
> +  1: Watchdog enable
> +  2: Watchdog fast-mode
> +  3: Watchdog trigger
> +  4: Watchdog reset cause bit 0
> +  5: Watchdog reset cause bit 1
> +  6: Watchdog reset cause bit 2
> +
> +Optional properties:
> +- None
> +
> +Example:
> +	watchdog {
> +		compatible ="men,a021-wdt";
> +		gpios = <&gpio3 9  1	/* WD_EN */
> +			 &gpio3 10 1	/* WD_FAST */
> +			 &gpio3 11 1	/* WD_TRIG */
> +			 &gpio3 6  1	/* RST_CAUSE[0] */
> +			 &gpio3 7  1	/* RST_CAUSE[1] */
> +			 &gpio3 8  1>;	/* RST_CAUSE[2] */
> +	};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5be702c..824261e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5317,6 +5317,12 @@ F:	drivers/mtd/
>  F:	include/linux/mtd/
>  F:	include/uapi/mtd/
> 
> +MEN A21 WATCHDOG DRIVER
> +M:  	Johannes Thumshirn <johannes.thumshirn@men.de>
> +L:	linux-watchdog@vger.kernel.org
> +S:	Supported
> +F:	drivers/watchdog/mena21_wdt.c
> +
>  METAG ARCHITECTURE
>  M:	James Hogan <james.hogan@imgtec.com>
>  S:	Supported
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index e89fc31..8b143ee 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -1172,6 +1172,18 @@ config BOOKE_WDT_DEFAULT_TIMEOUT
> 
>  	  The value can be overridden by the wdt_period command-line parameter.
> 
> +config MEN_A21_WDT
> +       tristate "MEN A21 VME CPU Carrier Board Watchdog Timer"
> +       select WATCHDOG_CORE
> +       depends on GPIOLIB
> +       help
> +        Watchdog driver for MEN A21 VMEbus CPU Carrier Boards.
> +
> +	The driver can also be built as a module. If so, the module will be
> +	called mena21_wdt.
> +
> +	If unsure select N here.
> +
>  # PPC64 Architecture
> 
>  config WATCHDOG_RTAS
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index a300b94..bffdcb1 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -143,6 +143,7 @@ obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
>  obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
>  obj-$(CONFIG_PIKA_WDT) += pika_wdt.o
>  obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
> +obj-$(CONFIG_MEN_A21_WDT) += mena21_wdt.o
> 
>  # PPC64 Architecture
>  obj-$(CONFIG_WATCHDOG_RTAS) += wdrtas.o
> diff --git a/drivers/watchdog/mena21_wdt.c b/drivers/watchdog/mena21_wdt.c
> new file mode 100644
> index 0000000..0d3409a
> --- /dev/null
> +++ b/drivers/watchdog/mena21_wdt.c
> @@ -0,0 +1,276 @@
> +/*
> + * Watchdog driver for the A21 VME CPU Boards
> + *
> + * Copyright (C) 2013 MEN Mikro Elektronik Nuernberg GmbH
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation
> + */
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/watchdog.h>
> +#include <linux/uaccess.h>
> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>
> +#include <linux/delay.h>
> +#include <linux/bitops.h>
> +
> +#define NUM_GPIOS 6
> +
> +enum a21_wdt_gpios {
> +	GPIO_WD_ENAB,
> +	GPIO_WD_FAST,
> +	GPIO_WD_TRIG,
> +	GPIO_WD_RST0,
> +	GPIO_WD_RST1,
> +	GPIO_WD_RST2,
> +};
> +
> +struct a21_wdt_drv {
> +	struct watchdog_device wdt;
> +	struct mutex lock;
> +	unsigned gpios[NUM_GPIOS];
> +};
> +
> +static bool nowayout = WATCHDOG_NOWAYOUT;
> +module_param(nowayout, bool, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
> +			    __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> +
> +static unsigned int a21_wdt_get_bootstatus(struct a21_wdt_drv *drv)
> +{
> +	int reset = 0;
> +
> +	reset |= gpio_get_value(drv->gpios[GPIO_WD_RST0]) ? (1 << 0) : 0;
> +	reset |= gpio_get_value(drv->gpios[GPIO_WD_RST1]) ? (1 << 1) : 0;
> +	reset |= gpio_get_value(drv->gpios[GPIO_WD_RST2]) ? (1 << 2) : 0;
> +
> +	return reset;
> +}
> +
> +static int a21_wdt_start(struct watchdog_device *wdt)
> +{
> +	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
> +
> +	mutex_lock(&drv->lock);
> +
> +	gpio_set_value(drv->gpios[GPIO_WD_ENAB], 1);
> +
> +	mutex_unlock(&drv->lock);
> +
> +	return 0;
> +}
> +
> +static int a21_wdt_stop(struct watchdog_device *wdt)
> +{
> +	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
> +
> +	/* We don't stop if WDOG_NO_WAY_OUT is set */
> +	if (test_bit(WDOG_NO_WAY_OUT, &wdt->status))
> +		return -EINVAL;
> +
Already handled by watchdog core; no need to check again here.

> +	mutex_lock(&drv->lock);
> +
> +	gpio_set_value(drv->gpios[GPIO_WD_ENAB], 0);
> +
> +	mutex_unlock(&drv->lock);
> +
> +	return 0;
> +}
> +
> +static int a21_wdt_ping(struct watchdog_device *wdt)
> +{
> +	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
> +
> +	mutex_lock(&drv->lock);
> +
> +	gpio_set_value(drv->gpios[GPIO_WD_TRIG], 0);
> +	ndelay(10);

Is the delay specified somewehere or just to be sure ?

> +	gpio_set_value(drv->gpios[GPIO_WD_TRIG], 1);
> +
> +	mutex_unlock(&drv->lock);
> +
> +	return 0;
> +}
> +
> +static int a21_wdt_set_timeout(struct watchdog_device *wdt,
> +			       unsigned int timeout)
> +{
> +	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
> +
> +	if (timeout != 1 && timeout != 30) {
> +		dev_err(wdt->dev, "Only 1 and 30 allowed as timeout\n");
> +		return -EINVAL;
> +	}
> +
> +	if (timeout == 30 && wdt->timeout == 1) {
> +		dev_err(wdt->dev,
> +			"Transition from fast to slow mode not allowed\n");
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&drv->lock);
> +
> +	if (timeout == 1)
> +		gpio_set_value(drv->gpios[GPIO_WD_FAST], 1);
> +	else
> +		gpio_set_value(drv->gpios[GPIO_WD_FAST], 0);
> +
> +	wdt->timeout = timeout;
> +
> +	mutex_unlock(&drv->lock);
> +
> +	return 0;
> +}
> +
> +static const struct watchdog_info a21_wdt_info = {
> +	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
> +	.identity = "MEN A21 Watchdog",
> +};
> +
> +static const struct watchdog_ops a21_wdt_ops = {
> +	.owner = THIS_MODULE,
> +	.start = a21_wdt_start,
> +	.stop = a21_wdt_stop,
> +	.ping = a21_wdt_ping,
> +	.set_timeout = a21_wdt_set_timeout,
> +};
> +
> +static struct watchdog_device a21_wdt = {
> +	.info = &a21_wdt_info,
> +	.ops = &a21_wdt_ops,
> +	.min_timeout = 1,
> +	.max_timeout = 30,
> +};
> +
> +static int a21_wdt_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node;
> +	struct a21_wdt_drv *drv;
> +	unsigned int reset = 0;
> +	int num_gpios;
> +	int ret;
> +	int i;
> +
> +	dev_info(&pdev->dev, "MEN A21 watchdog timer driver enabled\n");
> +
Move to the very end of this function; otherwise it is misleading if lading the
driver fails.

> +	drv = devm_kzalloc(&pdev->dev, sizeof(struct a21_wdt_drv), GFP_KERNEL);
> +	if (!drv)
> +		return -ENOMEM;
> +
> +	/* Fill GPIO pin array */
> +	node = pdev->dev.of_node;
> +
> +	num_gpios = of_gpio_count(node);
> +	if (num_gpios != NUM_GPIOS) {
> +		dev_err(&pdev->dev, "gpios DT property wrong, got %d want %d",
> +			num_gpios, NUM_GPIOS);
> +		return -ENODEV;
> +	}
> +
> +	for (i = 0; i < num_gpios; i++) {
> +		int val;
> +
> +		val = of_get_gpio(node, i);
> +		if (val < 0)
> +			return val;
> +
> +		drv->gpios[i] = val;
> +	}
> +
> +	/* Request the used GPIOs */
> +	for (i = 0; i < num_gpios; i++) {
> +		ret = devm_gpio_request(&pdev->dev, drv->gpios[i],
> +					"MEN A21 Watchdog");
> +		if (ret)
> +			return ret;
> +
> +		if (i < GPIO_WD_RST0)
> +			ret = gpio_direction_output(drv->gpios[i],
> +						gpio_get_value(drv->gpios[i]));
> +		else		/* GPIO_WD_RST[0..2] are inputs */
> +			ret = gpio_direction_input(drv->gpios[i]);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	mutex_init(&drv->lock);
> +	watchdog_init_timeout(&a21_wdt, 30, &pdev->dev);
> +	watchdog_set_nowayout(&a21_wdt, nowayout);
> +	watchdog_set_drvdata(&a21_wdt, drv);
> +
> +	reset = a21_wdt_get_bootstatus(drv);
> +	if (reset == 2)
> +		a21_wdt.bootstatus |= WDIOF_EXTERN1;
> +	else if (reset == 4)
> +		a21_wdt.bootstatus |= WDIOF_CARDRESET;
> +	else if (reset == 5)
> +		a21_wdt.bootstatus |= WDIOF_POWERUNDER;
> +	else if (reset == 7)
> +		a21_wdt.bootstatus |= WDIOF_EXTERN2;
> +
> +
One empty line is sufficient.

> +	ret = watchdog_register_device(&a21_wdt);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Cannot register watchdog device\n");
> +		goto err_register_wd;
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, drv);
> +
> +	return 0;
> +
> +err_register_wd:
> +	mutex_destroy(&drv->lock);
> +
> +	return ret;
> +}
> +
> +static int a21_wdt_remove(struct platform_device *pdev)
> +{
> +	struct a21_wdt_drv *drv = dev_get_drvdata(&pdev->dev);
> +
> +	dev_warn(&pdev->dev,
> +		"Unregistering A21 watchdog driver, board may reboot\n");
> +
> +
One empty line

> +	watchdog_unregister_device(&drv->wdt);
> +
> +	mutex_destroy(&drv->lock);
> +
> +	return 0;
> +}
> +
> +static void a21_wdt_shutdown(struct platform_device *pdev)
> +{
> +	struct a21_wdt_drv *drv = dev_get_drvdata(&pdev->dev);
> +
> +	gpio_set_value(drv->gpios[GPIO_WD_ENAB], 0);
> +}
> +
> +static const struct of_device_id a21_wdt_ids[] = {
> +	{ .compatible = "men,a021-wdt" },
> +	{ },
> +};
> +
> +static struct platform_driver a21_wdt_driver = {
> +	.probe = a21_wdt_probe,
> +	.remove = a21_wdt_remove,
> +	.shutdown = a21_wdt_shutdown,
> +	.driver = {
> +		.name = "a21-watchdog",
> +		.of_match_table = a21_wdt_ids,
> +	},
> +};
> +
> +module_platform_driver(a21_wdt_driver);
> +
> +MODULE_AUTHOR("MEN Mikro Elektronik");
> +MODULE_DESCRIPTION("MEN A21 Watchdog");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:a21-watchdog");
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
