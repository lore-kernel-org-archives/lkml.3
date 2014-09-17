Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaIQCHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:07:12 -0400
Received: from mail-bl2on0144.outbound.protection.outlook.com ([65.55.169.144]:49808
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754525AbaIQCHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:07:11 -0400
Date: Wed, 17 Sep 2014 10:06:57 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Robin Gong <b38343@freescale.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <kernel@pengutronix.de>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] power: reset: imx-snvs-poweroff: add power off
 driver for i.mx6
Message-ID: <20140917020655.GC4796@dragon>
References: <1410511739-31122-1-git-send-email-b38343@freescale.com>
 <1410511739-31122-3-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410511739-31122-3-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(24454002)(199003)(92726001)(83506001)(83072002)(84676001)(102836001)(90102001)(23726002)(57986006)(50466002)(26826002)(99396002)(97736003)(21056001)(31966008)(46406003)(76176999)(106466001)(33716001)(6806004)(230783001)(19580395003)(107046002)(54356999)(77982003)(20776003)(46102003)(4396001)(110136001)(80022003)(44976005)(83322001)(92566001)(87936001)(86362001)(68736004)(47776003)(79102003)(64706001)(81342003)(33656002)(81542003)(97756001)(104016003)(105606002)(95666004)(85852003)(76482002)(50986999)(74502003)(19580405001)(74662003)(85306004)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN2PR03MB047;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 04:48:58PM +0800, Robin Gong wrote:
> Add simple power off driver for i.mx6.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  drivers/power/reset/Kconfig             |  6 +++
>  drivers/power/reset/Makefile            |  1 +
>  drivers/power/reset/imx-snvs-poweroff.c | 69 +++++++++++++++++++++++++++++++++
>  3 files changed, 76 insertions(+)
>  create mode 100644 drivers/power/reset/imx-snvs-poweroff.c
> 
> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> index ca41523..c48d9ba 100644
> --- a/drivers/power/reset/Kconfig
> +++ b/drivers/power/reset/Kconfig
> @@ -45,6 +45,12 @@ config POWER_RESET_HISI
>  	help
>  	  Reboot support for Hisilicon boards.
>  
> +config POWER_RESET_IMX
> +	bool "IMX6 power-off driver"
> +	depends on POWER_RESET && SOC_IMX6
> +	help
> +	  Power off support for i.mx6 boards.
> +
>  config POWER_RESET_MSM
>  	bool "Qualcomm MSM power-off driver"
>  	depends on POWER_RESET && ARCH_QCOM
> diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
> index a42e70e..2524daf 100644
> --- a/drivers/power/reset/Makefile
> +++ b/drivers/power/reset/Makefile
> @@ -3,6 +3,7 @@ obj-$(CONFIG_POWER_RESET_AXXIA) += axxia-reset.o
>  obj-$(CONFIG_POWER_RESET_BRCMSTB) += brcmstb-reboot.o
>  obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
>  obj-$(CONFIG_POWER_RESET_HISI) += hisi-reboot.o
> +obj-$(CONFIG_POWER_RESET_IMX) += imx-snvs-poweroff.o
>  obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
>  obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
>  obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
> diff --git a/drivers/power/reset/imx-snvs-poweroff.c b/drivers/power/reset/imx-snvs-poweroff.c
> new file mode 100644
> index 0000000..55603ba
> --- /dev/null
> +++ b/drivers/power/reset/imx-snvs-poweroff.c
> @@ -0,0 +1,69 @@
> +/* Power off driver for i.mx6
> + * Copyright (c) 2014, FREESCALE CORPORATION.  All rights reserved.
> + *
> + * based on msm-poweroff.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/delay.h>

Is it really needed?

> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +
> +#include <asm/system_misc.h>

Ditto

Shawn

> +
> +static void __iomem *snvs_base;
> +
> +static void do_imx_poweroff(void)
> +{
> +	u32 value = readl(snvs_base);
> +
> +	/* set TOP and DP_EN bit */
> +	writel(value | 0x60, snvs_base);
> +}
> +
> +static int imx_poweroff_probe(struct platform_device *pdev)
> +{
> +	snvs_base = of_iomap(pdev->dev.of_node, 0);
> +	if (!snvs_base) {
> +		dev_err(&pdev->dev, "failed to get memory\n");
> +		return -EIO;
> +	}
> +
> +	pm_power_off = do_imx_poweroff;
> +	return 0;
> +}
> +
> +static const struct of_device_id of_imx_poweroff_match[] = {
> +	{ .compatible = "fsl,sec-v4.0-poweroff", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, of_imx_poweroff_match);
> +
> +static struct platform_driver imx_poweroff_driver = {
> +	.probe = imx_poweroff_probe,
> +	.driver = {
> +		.name = "imx-snvs-poweroff",
> +		.of_match_table = of_match_ptr(of_imx_poweroff_match),
> +	},
> +};
> +
> +static int __init imx_poweroff_init(void)
> +{
> +	return platform_driver_register(&imx_poweroff_driver);
> +}
> +device_initcall(imx_poweroff_init);
> -- 
> 1.9.1
> 
