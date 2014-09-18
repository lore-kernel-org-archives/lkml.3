Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbaIRCO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:14:58 -0400
Received: from mail-by2on0111.outbound.protection.outlook.com ([207.46.100.111]:4153
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757000AbaIRCO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:14:56 -0400
Date: Thu, 18 Sep 2014 10:21:27 +0800
From: Robin Gong <b38343@freescale.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>
Subject: Re: [PATCH v3 2/3] power: reset: imx-snvs-poweroff: add power off
 driver for i.mx6
Message-ID: <20140918022125.GA8150@Robin-OptiPlex-780>
References: <1410947881-7345-1-git-send-email-b38343@freescale.com>
 <1410947881-7345-3-git-send-email-b38343@freescale.com>
 <20140917175244.GC7983@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140917175244.GC7983@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(24454002)(189002)(83506001)(76176999)(80022003)(33656002)(79102003)(105606002)(20776003)(47776003)(15975445006)(74502003)(19580395003)(107046002)(92726001)(64706001)(81342003)(4396001)(77982003)(83072002)(19580405001)(23726002)(81542003)(46102003)(44976005)(74662003)(83322001)(99396002)(6806004)(110136001)(106466001)(15202345003)(68736004)(26826002)(76482002)(90102001)(54356999)(50986999)(21056001)(87936001)(84676001)(85852003)(92566001)(104016003)(85306004)(95666004)(97736003)(97756001)(33716001)(102836001)(46406003)(50466002)(230783001)(31966008)(2004002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB352;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 06:52:44PM +0100, Mark Rutland wrote:
> On Wed, Sep 17, 2014 at 10:57:59AM +0100, Robin Gong wrote:
> > This driver register pm_power_off with snvs power off function. If
> > your boards NOT use PMIC_ON_REQ to turn on/off external pmic, or use
> > other pin to do, please disable the driver in dts, otherwise, your
> > pm_power_off maybe overwrote by this driver.
> > 
> > Signed-off-by: Robin Gong <b38343@freescale.com>
> > ---
> >  .../bindings/power_supply/imx-snvs-poweroff.txt    |   23 +++++++
> >  drivers/power/reset/Kconfig                        |    9 +++
> >  drivers/power/reset/Makefile                       |    1 +
> >  drivers/power/reset/imx-snvs-poweroff.c            |   66 ++++++++++++++++++++
> >  4 files changed, 99 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
> >  create mode 100644 drivers/power/reset/imx-snvs-poweroff.c
> > 
> > diff --git a/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt b/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
> > new file mode 100644
> > index 0000000..6caf64e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
> > @@ -0,0 +1,23 @@
> > +i.mx6 Poweroff Driver
> > +
> > +SNVS_LPCR in SNVS module can power off the whole system by pull
> > +PMIC_ON_REQ low if PMIC_ON_REQ is connected with external PMIC.
> > +If you don't want to use PMIC_ON_REQ as power on/off control,
> > +please set status='disabled' to disable this driver.
> > +
> > +Required Properties:
> > +-compatible: "fsl,sec-v4.0-poweroff"
> > +-reg: Specifies the physical address of the SNVS_LPCR register
> 
> As you describe above, this is part of the SNVS module. So why does this
> need a separate node?
> 
> Surely there should just be a property on the SNVS node that desribers
> whether or not this can be used?
> 
> Mark.
>
Yes, put this function in rtc-snvs make things easier, honestly,this is our way
in internal tree. But looks more and more power off driver put in drivers/power
/reset,so we decided to add new power off driver. If it is ok to register
pm_power_off hook in drivers/rtc/rtc-snvs.c, I can drop this patch.
> > +
> > +Example:
> > +	snvs@020cc000 {
> > +		compatible = "fsl,sec-v4.0-mon", "simple-bus";
> > +		#address-cells = <1>;
> > +		#size-cells = <1>;
> > +		ranges = <0 0x020cc000 0x4000>;
> > +		.....
> > +		snvs-poweroff@38 {
> > +			compatible = "fsl,sec-v4.0-poweroff";
> > +			reg = <0x38 0x4>;
> > +		};
> > +	}
> > diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> > index ca41523..b26c547 100644
> > --- a/drivers/power/reset/Kconfig
> > +++ b/drivers/power/reset/Kconfig
> > @@ -45,6 +45,15 @@ config POWER_RESET_HISI
> >  	help
> >  	  Reboot support for Hisilicon boards.
> >  
> > +config POWER_RESET_IMX
> > +	bool "IMX6 power-off driver"
> > +	depends on POWER_RESET && SOC_IMX6
> > +	help
> > +	  This driver support power off external PMIC by PMIC_ON_REQ on i.mx6
> > +	  boards.If you want to use other pin to control external power,please
> > +	  say N here or disable in dts to make sure pm_power_off never be
> > +	  overwrote wrongly by this driver.
> > +
> >  config POWER_RESET_MSM
> >  	bool "Qualcomm MSM power-off driver"
> >  	depends on POWER_RESET && ARCH_QCOM
> > diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
> > index a42e70e..2524daf 100644
> > --- a/drivers/power/reset/Makefile
> > +++ b/drivers/power/reset/Makefile
> > @@ -3,6 +3,7 @@ obj-$(CONFIG_POWER_RESET_AXXIA) += axxia-reset.o
> >  obj-$(CONFIG_POWER_RESET_BRCMSTB) += brcmstb-reboot.o
> >  obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
> >  obj-$(CONFIG_POWER_RESET_HISI) += hisi-reboot.o
> > +obj-$(CONFIG_POWER_RESET_IMX) += imx-snvs-poweroff.o
> >  obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
> >  obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
> >  obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
> > diff --git a/drivers/power/reset/imx-snvs-poweroff.c b/drivers/power/reset/imx-snvs-poweroff.c
> > new file mode 100644
> > index 0000000..d726ac4
> > --- /dev/null
> > +++ b/drivers/power/reset/imx-snvs-poweroff.c
> > @@ -0,0 +1,66 @@
> > +/* Power off driver for i.mx6
> > + * Copyright (c) 2014, FREESCALE CORPORATION.  All rights reserved.
> > + *
> > + * based on msm-poweroff.c
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 and
> > + * only version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + */
> > +
> > +#include <linux/err.h>
> > +#include <linux/init.h>
> > +#include <linux/io.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/platform_device.h>
> > +
> > +static void __iomem *snvs_base;
> > +
> > +static void do_imx_poweroff(void)
> > +{
> > +	u32 value = readl(snvs_base);
> > +
> > +	/* set TOP and DP_EN bit */
> > +	writel(value | 0x60, snvs_base);
> > +}
> > +
> > +static int imx_poweroff_probe(struct platform_device *pdev)
> > +{
> > +	snvs_base = of_iomap(pdev->dev.of_node, 0);
> > +	if (!snvs_base) {
> > +		dev_err(&pdev->dev, "failed to get memory\n");
> > +		return -EIO;
> > +	}
> > +
> > +	pm_power_off = do_imx_poweroff;
> > +	return 0;
> > +}
> > +
> > +static const struct of_device_id of_imx_poweroff_match[] = {
> > +	{ .compatible = "fsl,sec-v4.0-poweroff", },
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, of_imx_poweroff_match);
> > +
> > +static struct platform_driver imx_poweroff_driver = {
> > +	.probe = imx_poweroff_probe,
> > +	.driver = {
> > +		.name = "imx-snvs-poweroff",
> > +		.of_match_table = of_match_ptr(of_imx_poweroff_match),
> > +	},
> > +};
> > +
> > +static int __init imx_poweroff_init(void)
> > +{
> > +	return platform_driver_register(&imx_poweroff_driver);
> > +}
> > +device_initcall(imx_poweroff_init);
> > -- 
> > 1.7.9.5
> > 
> > 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
