Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbaFZKkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 06:40:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8761 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbaFZKkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 06:40:22 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f626d000004b39-ea-53abf8935da5
Content-transfer-encoding: 8BIT
Message-id: <1403779219.27156.20.camel@AMDC1943>
Subject: Re: [PATCH v4 11/14] clk: Add driver for Maxim 77802 PMIC clocks
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
Date: Thu, 26 Jun 2014 12:40:19 +0200
In-reply-to: <1403723019-6212-12-git-send-email-javier.martinez@collabora.co.uk>
References: <1403723019-6212-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403723019-6212-12-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4Vd3JP1YHG2x8zGux5OJVdoupD5+w
	WWzq38puMf/IOVaLs8sOslkc/V1g0bvgKpvF/a9HGS2+Xelgstj0+BqrxeVdc9gsZpzfx2Tx
	dMJFNotT1z+zWZzuZrWYfvwtq0Xf2ktsDoIesxsusnj8fX6dxWPH3SWMHjtn3WX32LSqk83j
	zrU9bB7zTgZ6bF5S73HlRBOrR9+WVYwe0+f9ZPL4vEkugCeKyyYlNSezLLVI3y6BK2Pmu5Vs
	BRuMK95uMmxgPKzZxcjJISFgIvGpuY8NwhaTuHBvPZDNxSEksJRRYs2hLhaQBK+AoMSPyfeA
	bA4OZgF5iSOXskHCzALqEpPmLWKGqP/MKPH97RJmiHoDiX3vf4D1Cgt4Shzc2sEEYrMJGEts
	Xr4EbJmIgJ3EjdUPwZqZBR6xSDza8ocRJMEioCrxrv8nK4jNKRAgcehdIyvEhimMEkdOTmSC
	OFVZYt7+Y0wTGAVmITlwFsKBs5AcuICReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSBx+
	3cG49JjVIUYBDkYlHt4TYauDhVgTy4orcw8xSnAwK4nwsnwBCvGmJFZWpRblxxeV5qQWH2Jk
	4uCUamDckR+b6XDiwuItIedkom8vVJ4mtn3hrJtfdM0ePK+3sI3vvP8m5n7eLt+SpYZJkzde
	3PXHrdpASE7j2aeclavMNlsyHD/1+GfXpxPXTuXfmHM40T30z4sJr6f0Rh6a9bc/ebvc648V
	+SKfGvSPzDu2a+LyzHP6E1w0jfxP3Zu3P/m83jEp/8tBm5RYijMSDbWYi4oTAZ+aatahAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-06-25 at 21:03 +0200, Javier Martinez Canillas wrote:
> The MAX77802 PMIC has two 32.768kHz Buffered Clock Outputs with
> Low Jitter Mode. This patch adds support for these two clocks.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
> 
> Changes since v3: None
> 
> Changes since v2: None
> 
> Changes since v1:
>  - Use module_platform_driver() instead of having init/exit functions.
>    Suggested by Mark Brown.
>  - Use the generic maxim clock driver to reduce code duplication with
>    clk-max77686.c driver.
> 
>  drivers/clk/Kconfig                        |  7 +++
>  drivers/clk/Makefile                       |  1 +
>  drivers/clk/clk-max77802.c                 | 99 ++++++++++++++++++++++++++++++
>  include/dt-bindings/clock/maxim,max77802.h | 22 +++++++
>  4 files changed, 129 insertions(+)
>  create mode 100644 drivers/clk/clk-max77802.c
>  create mode 100644 include/dt-bindings/clock/maxim,max77802.h


Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> 
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 3fd4270..221260b 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -42,6 +42,13 @@ config COMMON_CLK_MAX77686
>  	---help---
>  	  This driver supports Maxim 77686 crystal oscillator clock. 
>  
> +config COMMON_CLK_MAX77802
> +	tristate "Clock driver for Maxim 77802 MFD"
> +	depends on MFD_MAX77802
> +	select COMMON_CLK_MAX_GEN
> +	---help---
> +	  This driver supports Maxim 77802 crystal oscillator clock.
> +
>  config COMMON_CLK_SI5351
>  	tristate "Clock driver for SiLabs 5351A/B/C"
>  	depends on I2C
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 6c1aff6..520ff76 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_ARCH_HIGHBANK)		+= clk-highbank.o
>  obj-$(CONFIG_MACH_LOONGSON1)		+= clk-ls1x.o
>  obj-$(CONFIG_COMMON_CLK_MAX_GEN)	+= clk-max-gen.o
>  obj-$(CONFIG_COMMON_CLK_MAX77686)	+= clk-max77686.o
> +obj-$(CONFIG_COMMON_CLK_MAX77802)	+= clk-max77802.o
>  obj-$(CONFIG_ARCH_MOXART)		+= clk-moxart.o
>  obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomadik.o
>  obj-$(CONFIG_ARCH_NSPIRE)		+= clk-nspire.o
> diff --git a/drivers/clk/clk-max77802.c b/drivers/clk/clk-max77802.c
> new file mode 100644
> index 0000000..4253b44
> --- /dev/null
> +++ b/drivers/clk/clk-max77802.c
> @@ -0,0 +1,99 @@
> +/*
> + * clk-max77802.c - Clock driver for Maxim 77802
> + *
> + * Copyright (C) 2014 Google, Inc
> + *
> + * Copyright (C) 2012 Samsung Electornics
> + * Jonghwa Lee <jonghwa3.lee@samsung.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * This driver is based on clk-max77686.c
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/max77802.h>
> +#include <linux/mfd/max77802-private.h>
> +#include <linux/clk-provider.h>
> +#include <linux/mutex.h>
> +#include <linux/clkdev.h>
> +
> +#include <dt-bindings/clock/maxim,max77802.h>
> +#include "clk-max-gen.h"
> +
> +#define MAX77802_CLOCK_OPMODE_MASK	0x1
> +#define MAX77802_CLOCK_LOW_JITTER_SHIFT 0x3
> +
> +static struct clk_init_data max77802_clks_init[MAX77802_CLKS_NUM] = {
> +	[MAX77802_CLK_32K_AP] = {
> +		.name = "32khz_ap",
> +		.ops = &max_gen_clk_ops,
> +		.flags = CLK_IS_ROOT,
> +	},
> +	[MAX77802_CLK_32K_CP] = {
> +		.name = "32khz_cp",
> +		.ops = &max_gen_clk_ops,
> +		.flags = CLK_IS_ROOT,
> +	},
> +};
> +
> +static int max77802_clk_probe(struct platform_device *pdev)
> +{
> +	struct max77802_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> +	int ret;
> +
> +	ret = max_gen_clk_probe(pdev, iodev->regmap, MAX77802_REG_32KHZ,
> +				max77802_clks_init, MAX77802_CLKS_NUM);
> +
> +	if (ret) {
> +		dev_err(&pdev->dev, "generic probe failed %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Enable low-jitter mode on the 32khz clocks. */
> +	ret = regmap_update_bits(iodev->regmap, MAX77802_REG_32KHZ,
> +				 1 << MAX77802_CLOCK_LOW_JITTER_SHIFT,
> +				 1 << MAX77802_CLOCK_LOW_JITTER_SHIFT);
> +	if (ret < 0)
> +		dev_err(&pdev->dev, "failed to enable low-jitter mode\n");
> +
> +	return ret;
> +}
> +
> +static int max77802_clk_remove(struct platform_device *pdev)
> +{
> +	return max_gen_clk_remove(pdev, MAX77802_CLKS_NUM);
> +}
> +
> +static const struct platform_device_id max77802_clk_id[] = {
> +	{ "max77802-clk", 0},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(platform, max77802_clk_id);
> +
> +static struct platform_driver max77802_clk_driver = {
> +	.driver = {
> +		.name  = "max77802-clk",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = max77802_clk_probe,
> +	.remove = max77802_clk_remove,
> +	.id_table = max77802_clk_id,
> +};
> +
> +module_platform_driver(max77802_clk_driver);
> +
> +MODULE_DESCRIPTION("MAXIM 77802 Clock Driver");
> +MODULE_AUTHOR("Javier Martinez Canillas <javier.martinez@collabora.co.uk>");
> +MODULE_LICENSE("GPL");
> diff --git a/include/dt-bindings/clock/maxim,max77802.h b/include/dt-bindings/clock/maxim,max77802.h
> new file mode 100644
> index 0000000..997312e
> --- /dev/null
> +++ b/include/dt-bindings/clock/maxim,max77802.h
> @@ -0,0 +1,22 @@
> +/*
> + * Copyright (C) 2014 Google, Inc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Device Tree binding constants clocks for the Maxim 77802 PMIC.
> + */
> +
> +#ifndef _DT_BINDINGS_CLOCK_MAXIM_MAX77802_CLOCK_H
> +#define _DT_BINDINGS_CLOCK_MAXIM_MAX77802_CLOCK_H
> +
> +/* Fixed rate clocks. */
> +
> +#define MAX77802_CLK_32K_AP		0
> +#define MAX77802_CLK_32K_CP		1
> +
> +/* Total number of clocks. */
> +#define MAX77802_CLKS_NUM		(MAX77802_CLK_32K_CP + 1)
> +
> +#endif /* _DT_BINDINGS_CLOCK_MAXIM_MAX77802_CLOCK_H */

