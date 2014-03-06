Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaCFPii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:38:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49208 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaCFPie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:38:34 -0500
Message-ID: <53189654.2090406@ti.com>
Date: Thu, 6 Mar 2014 21:07:56 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v2 01/13] phy: rename struct omap_control_usb to struct
 omap_control_phy
References: <1394116729-28811-1-git-send-email-rogerq@ti.com> <1394116729-28811-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1394116729-28811-2-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

On Thursday 06 March 2014 08:08 PM, Roger Quadros wrote:
> From: Kishon Vijay Abraham I <kishon@ti.com>
>
> Rename struct omap_control_usb to struct omap_control_phy since it can
> be used to control PHY of USB, SATA and PCIE. Also move the driver and
> include files under *phy* and made the corresponding changes in the users
> of phy-omap-control.
>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>   drivers/phy/Kconfig                                |  14 +-
>   drivers/phy/Makefile                               |   1 +
>   drivers/{usb => }/phy/phy-omap-control.c           | 165 +++++++++++----------
>   drivers/phy/phy-omap-usb2.c                        |   8 +-
>   drivers/phy/phy-ti-pipe3.c                         |   8 +-
>   drivers/usb/musb/omap2430.c                        |   2 +-
>   drivers/usb/phy/Kconfig                            |  10 --
>   drivers/usb/phy/Makefile                           |   1 -

Hope you are fine with the changes in drivers/usb/? Can you give your 
Acked-by?

Regards
Kishon

>   .../omap_control_usb.h => phy/omap_control_phy.h}  |  36 ++---
>   9 files changed, 123 insertions(+), 122 deletions(-)
>   rename drivers/{usb => }/phy/phy-omap-control.c (55%)
>   rename include/linux/{usb/omap_control_usb.h => phy/omap_control_phy.h} (68%)
>
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 1b607d7..fe8c009 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -31,12 +31,22 @@ config PHY_MVEBU_SATA
>   	depends on OF
>   	select GENERIC_PHY
>
> +config OMAP_CONTROL_PHY
> +	tristate "OMAP CONTROL PHY Driver"
> +	help
> +	  Enable this to add support for the PHY part present in the control
> +	  module. This driver has API to power on the USB2 PHY and to write to
> +	  the mailbox. The mailbox is present only in omap4 and the register to
> +	  power on the USB2 PHY is present in OMAP4 and OMAP5. OMAP5 has an
> +	  additional register to power on USB3 PHY/SATA PHY/PCIE PHY
> +	  (PIPE3 PHY).
> +
>   config OMAP_USB2
>   	tristate "OMAP USB2 PHY Driver"
>   	depends on ARCH_OMAP2PLUS
>   	depends on USB_PHY
>   	select GENERIC_PHY
> -	select OMAP_CONTROL_USB
> +	select OMAP_CONTROL_PHY
>   	help
>   	  Enable this to support the transceiver that is part of SOC. This
>   	  driver takes care of all the PHY functionality apart from comparator.
> @@ -47,7 +57,7 @@ config TI_PIPE3
>   	tristate "TI PIPE3 PHY Driver"
>   	depends on ARCH_OMAP2PLUS || COMPILE_TEST
>   	select GENERIC_PHY
> -	select OMAP_CONTROL_USB
> +	select OMAP_CONTROL_PHY
>   	help
>   	  Enable this to support the PIPE3 PHY that is part of TI SOCs. This
>   	  driver takes care of all the PHY functionality apart from comparator.
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index ecf0d3f..8da05a8 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
>   obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>   obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>   obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
> +obj-$(CONFIG_OMAP_CONTROL_PHY)		+= phy-omap-control.o
>   obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>   obj-$(CONFIG_TI_PIPE3)			+= phy-ti-pipe3.o
>   obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/phy/phy-omap-control.c
> similarity index 55%
> rename from drivers/usb/phy/phy-omap-control.c
> rename to drivers/phy/phy-omap-control.c
> index e725318..17fc200 100644
> --- a/drivers/usb/phy/phy-omap-control.c
> +++ b/drivers/phy/phy-omap-control.c
> @@ -1,5 +1,5 @@
>   /*
> - * omap-control-usb.c - The USB part of control module.
> + * omap-control-phy.c - The PHY part of control module.
>    *
>    * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
>    * This program is free software; you can redistribute it and/or modify
> @@ -24,36 +24,36 @@
>   #include <linux/err.h>
>   #include <linux/io.h>
>   #include <linux/clk.h>
> -#include <linux/usb/omap_control_usb.h>
> +#include <linux/phy/omap_control_phy.h>
>
>   /**
> - * omap_control_usb_phy_power - power on/off the phy using control module reg
> + * omap_control_phy_power - power on/off the phy using control module reg
>    * @dev: the control module device
>    * @on: 0 or 1, based on powering on or off the PHY
>    */
> -void omap_control_usb_phy_power(struct device *dev, int on)
> +void omap_control_phy_power(struct device *dev, int on)
>   {
>   	u32 val;
>   	unsigned long rate;
> -	struct omap_control_usb	*control_usb;
> +	struct omap_control_phy	*control_phy;
>
>   	if (IS_ERR(dev) || !dev) {
>   		pr_err("%s: invalid device\n", __func__);
>   		return;
>   	}
>
> -	control_usb = dev_get_drvdata(dev);
> -	if (!control_usb) {
> -		dev_err(dev, "%s: invalid control usb device\n", __func__);
> +	control_phy = dev_get_drvdata(dev);
> +	if (!control_phy) {
> +		dev_err(dev, "%s: invalid control phy device\n", __func__);
>   		return;
>   	}
>
> -	if (control_usb->type == OMAP_CTRL_TYPE_OTGHS)
> +	if (control_phy->type == OMAP_CTRL_TYPE_OTGHS)
>   		return;
>
> -	val = readl(control_usb->power);
> +	val = readl(control_phy->power);
>
> -	switch (control_usb->type) {
> +	switch (control_phy->type) {
>   	case OMAP_CTRL_TYPE_USB2:
>   		if (on)
>   			val &= ~OMAP_CTRL_DEV_PHY_PD;
> @@ -62,19 +62,20 @@ void omap_control_usb_phy_power(struct device *dev, int on)
>   		break;
>
>   	case OMAP_CTRL_TYPE_PIPE3:
> -		rate = clk_get_rate(control_usb->sys_clk);
> +		rate = clk_get_rate(control_phy->sys_clk);
>   		rate = rate/1000000;
>
>   		if (on) {
> -			val &= ~(OMAP_CTRL_USB_PWRCTL_CLK_CMD_MASK |
> -					OMAP_CTRL_USB_PWRCTL_CLK_FREQ_MASK);
> -			val |= OMAP_CTRL_USB3_PHY_TX_RX_POWERON <<
> -				OMAP_CTRL_USB_PWRCTL_CLK_CMD_SHIFT;
> -			val |= rate << OMAP_CTRL_USB_PWRCTL_CLK_FREQ_SHIFT;
> +			val &= ~(OMAP_CTRL_PIPE3_PHY_PWRCTL_CLK_CMD_MASK |
> +				OMAP_CTRL_PIPE3_PHY_PWRCTL_CLK_FREQ_MASK);
> +			val |= OMAP_CTRL_PIPE3_PHY_TX_RX_POWERON <<
> +				OMAP_CTRL_PIPE3_PHY_PWRCTL_CLK_CMD_SHIFT;
> +			val |= rate <<
> +				OMAP_CTRL_PIPE3_PHY_PWRCTL_CLK_FREQ_SHIFT;
>   		} else {
> -			val &= ~OMAP_CTRL_USB_PWRCTL_CLK_CMD_MASK;
> -			val |= OMAP_CTRL_USB3_PHY_TX_RX_POWEROFF <<
> -				OMAP_CTRL_USB_PWRCTL_CLK_CMD_SHIFT;
> +			val &= ~OMAP_CTRL_PIPE3_PHY_PWRCTL_CLK_CMD_MASK;
> +			val |= OMAP_CTRL_PIPE3_PHY_TX_RX_POWEROFF <<
> +				OMAP_CTRL_PIPE3_PHY_PWRCTL_CLK_CMD_SHIFT;
>   		}
>   		break;
>
> @@ -100,66 +101,66 @@ void omap_control_usb_phy_power(struct device *dev, int on)
>   		break;
>   	default:
>   		dev_err(dev, "%s: type %d not recognized\n",
> -					__func__, control_usb->type);
> +			__func__, control_phy->type);
>   		break;
>   	}
>
> -	writel(val, control_usb->power);
> +	writel(val, control_phy->power);
>   }
> -EXPORT_SYMBOL_GPL(omap_control_usb_phy_power);
> +EXPORT_SYMBOL_GPL(omap_control_phy_power);
>
>   /**
>    * omap_control_usb_host_mode - set AVALID, VBUSVALID and ID pin in grounded
> - * @ctrl_usb: struct omap_control_usb *
> + * @ctrl_phy: struct omap_control_phy *
>    *
>    * Writes to the mailbox register to notify the usb core that a usb
>    * device has been connected.
>    */
> -static void omap_control_usb_host_mode(struct omap_control_usb *ctrl_usb)
> +static void omap_control_usb_host_mode(struct omap_control_phy *ctrl_phy)
>   {
>   	u32 val;
>
> -	val = readl(ctrl_usb->otghs_control);
> +	val = readl(ctrl_phy->otghs_control);
>   	val &= ~(OMAP_CTRL_DEV_IDDIG | OMAP_CTRL_DEV_SESSEND);
>   	val |= OMAP_CTRL_DEV_AVALID | OMAP_CTRL_DEV_VBUSVALID;
> -	writel(val, ctrl_usb->otghs_control);
> +	writel(val, ctrl_phy->otghs_control);
>   }
>
>   /**
>    * omap_control_usb_device_mode - set AVALID, VBUSVALID and ID pin in high
>    * impedance
> - * @ctrl_usb: struct omap_control_usb *
> + * @ctrl_phy: struct omap_control_phy *
>    *
>    * Writes to the mailbox register to notify the usb core that it has been
>    * connected to a usb host.
>    */
> -static void omap_control_usb_device_mode(struct omap_control_usb *ctrl_usb)
> +static void omap_control_usb_device_mode(struct omap_control_phy *ctrl_phy)
>   {
>   	u32 val;
>
> -	val = readl(ctrl_usb->otghs_control);
> +	val = readl(ctrl_phy->otghs_control);
>   	val &= ~OMAP_CTRL_DEV_SESSEND;
>   	val |= OMAP_CTRL_DEV_IDDIG | OMAP_CTRL_DEV_AVALID |
>   		OMAP_CTRL_DEV_VBUSVALID;
> -	writel(val, ctrl_usb->otghs_control);
> +	writel(val, ctrl_phy->otghs_control);
>   }
>
>   /**
>    * omap_control_usb_set_sessionend - Enable SESSIONEND and IDIG to high
>    * impedance
> - * @ctrl_usb: struct omap_control_usb *
> + * @ctrl_phy: struct omap_control_phy *
>    *
>    * Writes to the mailbox register to notify the usb core it's now in
>    * disconnected state.
>    */
> -static void omap_control_usb_set_sessionend(struct omap_control_usb *ctrl_usb)
> +static void omap_control_usb_set_sessionend(struct omap_control_phy *ctrl_phy)
>   {
>   	u32 val;
>
> -	val = readl(ctrl_usb->otghs_control);
> +	val = readl(ctrl_phy->otghs_control);
>   	val &= ~(OMAP_CTRL_DEV_AVALID | OMAP_CTRL_DEV_VBUSVALID);
>   	val |= OMAP_CTRL_DEV_IDDIG | OMAP_CTRL_DEV_SESSEND;
> -	writel(val, ctrl_usb->otghs_control);
> +	writel(val, ctrl_phy->otghs_control);
>   }
>
>   /**
> @@ -174,30 +175,30 @@ static void omap_control_usb_set_sessionend(struct omap_control_usb *ctrl_usb)
>   void omap_control_usb_set_mode(struct device *dev,
>   	enum omap_control_usb_mode mode)
>   {
> -	struct omap_control_usb	*ctrl_usb;
> +	struct omap_control_phy	*ctrl_phy;
>
>   	if (IS_ERR(dev) || !dev)
>   		return;
>
> -	ctrl_usb = dev_get_drvdata(dev);
> +	ctrl_phy = dev_get_drvdata(dev);
>
> -	if (!ctrl_usb) {
> -		dev_err(dev, "Invalid control usb device\n");
> +	if (!ctrl_phy) {
> +		dev_err(dev, "Invalid control phy device\n");
>   		return;
>   	}
>
> -	if (ctrl_usb->type != OMAP_CTRL_TYPE_OTGHS)
> +	if (ctrl_phy->type != OMAP_CTRL_TYPE_OTGHS)
>   		return;
>
>   	switch (mode) {
>   	case USB_MODE_HOST:
> -		omap_control_usb_host_mode(ctrl_usb);
> +		omap_control_usb_host_mode(ctrl_phy);
>   		break;
>   	case USB_MODE_DEVICE:
> -		omap_control_usb_device_mode(ctrl_usb);
> +		omap_control_usb_device_mode(ctrl_phy);
>   		break;
>   	case USB_MODE_DISCONNECT:
> -		omap_control_usb_set_sessionend(ctrl_usb);
> +		omap_control_usb_set_sessionend(ctrl_phy);
>   		break;
>   	default:
>   		dev_vdbg(dev, "invalid omap control usb mode\n");
> @@ -207,13 +208,13 @@ EXPORT_SYMBOL_GPL(omap_control_usb_set_mode);
>
>   #ifdef CONFIG_OF
>
> -static const enum omap_control_usb_type otghs_data = OMAP_CTRL_TYPE_OTGHS;
> -static const enum omap_control_usb_type usb2_data = OMAP_CTRL_TYPE_USB2;
> -static const enum omap_control_usb_type pipe3_data = OMAP_CTRL_TYPE_PIPE3;
> -static const enum omap_control_usb_type dra7usb2_data = OMAP_CTRL_TYPE_DRA7USB2;
> -static const enum omap_control_usb_type am437usb2_data = OMAP_CTRL_TYPE_AM437USB2;
> +static const enum omap_control_phy_type otghs_data = OMAP_CTRL_TYPE_OTGHS;
> +static const enum omap_control_phy_type usb2_data = OMAP_CTRL_TYPE_USB2;
> +static const enum omap_control_phy_type pipe3_data = OMAP_CTRL_TYPE_PIPE3;
> +static const enum omap_control_phy_type dra7usb2_data = OMAP_CTRL_TYPE_DRA7USB2;
> +static const enum omap_control_phy_type am437usb2_data = OMAP_CTRL_TYPE_AM437USB2;
>
> -static const struct of_device_id omap_control_usb_id_table[] = {
> +static const struct of_device_id omap_control_phy_id_table[] = {
>   	{
>   		.compatible = "ti,control-phy-otghs",
>   		.data = &otghs_data,
> @@ -236,84 +237,84 @@ static const struct of_device_id omap_control_usb_id_table[] = {
>   	},
>   	{},
>   };
> -MODULE_DEVICE_TABLE(of, omap_control_usb_id_table);
> +MODULE_DEVICE_TABLE(of, omap_control_phy_id_table);
>   #endif
>
>
> -static int omap_control_usb_probe(struct platform_device *pdev)
> +static int omap_control_phy_probe(struct platform_device *pdev)
>   {
>   	struct resource	*res;
>   	const struct of_device_id *of_id;
> -	struct omap_control_usb *control_usb;
> +	struct omap_control_phy *control_phy;
>
> -	of_id = of_match_device(of_match_ptr(omap_control_usb_id_table),
> -								&pdev->dev);
> +	of_id = of_match_device(of_match_ptr(omap_control_phy_id_table),
> +				&pdev->dev);
>   	if (!of_id)
>   		return -EINVAL;
>
> -	control_usb = devm_kzalloc(&pdev->dev, sizeof(*control_usb),
> +	control_phy = devm_kzalloc(&pdev->dev, sizeof(*control_phy),
>   		GFP_KERNEL);
> -	if (!control_usb) {
> -		dev_err(&pdev->dev, "unable to alloc memory for control usb\n");
> +	if (!control_phy) {
> +		dev_err(&pdev->dev, "unable to alloc memory for control phy\n");
>   		return -ENOMEM;
>   	}
>
> -	control_usb->dev = &pdev->dev;
> -	control_usb->type = *(enum omap_control_usb_type *)of_id->data;
> +	control_phy->dev = &pdev->dev;
> +	control_phy->type = *(enum omap_control_phy_type *)of_id->data;
>
> -	if (control_usb->type == OMAP_CTRL_TYPE_OTGHS) {
> +	if (control_phy->type == OMAP_CTRL_TYPE_OTGHS) {
>   		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>   			"otghs_control");
> -		control_usb->otghs_control = devm_ioremap_resource(
> +		control_phy->otghs_control = devm_ioremap_resource(
>   			&pdev->dev, res);
> -		if (IS_ERR(control_usb->otghs_control))
> -			return PTR_ERR(control_usb->otghs_control);
> +		if (IS_ERR(control_phy->otghs_control))
> +			return PTR_ERR(control_phy->otghs_control);
>   	} else {
>   		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>   				"power");
> -		control_usb->power = devm_ioremap_resource(&pdev->dev, res);
> -		if (IS_ERR(control_usb->power)) {
> +		control_phy->power = devm_ioremap_resource(&pdev->dev, res);
> +		if (IS_ERR(control_phy->power)) {
>   			dev_err(&pdev->dev, "Couldn't get power register\n");
> -			return PTR_ERR(control_usb->power);
> +			return PTR_ERR(control_phy->power);
>   		}
>   	}
>
> -	if (control_usb->type == OMAP_CTRL_TYPE_PIPE3) {
> -		control_usb->sys_clk = devm_clk_get(control_usb->dev,
> +	if (control_phy->type == OMAP_CTRL_TYPE_PIPE3) {
> +		control_phy->sys_clk = devm_clk_get(control_phy->dev,
>   			"sys_clkin");
> -		if (IS_ERR(control_usb->sys_clk)) {
> +		if (IS_ERR(control_phy->sys_clk)) {
>   			pr_err("%s: unable to get sys_clkin\n", __func__);
>   			return -EINVAL;
>   		}
>   	}
>
> -	dev_set_drvdata(control_usb->dev, control_usb);
> +	dev_set_drvdata(control_phy->dev, control_phy);
>
>   	return 0;
>   }
>
> -static struct platform_driver omap_control_usb_driver = {
> -	.probe		= omap_control_usb_probe,
> +static struct platform_driver omap_control_phy_driver = {
> +	.probe		= omap_control_phy_probe,
>   	.driver		= {
> -		.name	= "omap-control-usb",
> +		.name	= "omap-control-phy",
>   		.owner	= THIS_MODULE,
> -		.of_match_table = of_match_ptr(omap_control_usb_id_table),
> +		.of_match_table = of_match_ptr(omap_control_phy_id_table),
>   	},
>   };
>
> -static int __init omap_control_usb_init(void)
> +static int __init omap_control_phy_init(void)
>   {
> -	return platform_driver_register(&omap_control_usb_driver);
> +	return platform_driver_register(&omap_control_phy_driver);
>   }
> -subsys_initcall(omap_control_usb_init);
> +subsys_initcall(omap_control_phy_init);
>
> -static void __exit omap_control_usb_exit(void)
> +static void __exit omap_control_phy_exit(void)
>   {
> -	platform_driver_unregister(&omap_control_usb_driver);
> +	platform_driver_unregister(&omap_control_phy_driver);
>   }
> -module_exit(omap_control_usb_exit);
> +module_exit(omap_control_phy_exit);
>
> -MODULE_ALIAS("platform: omap_control_usb");
> +MODULE_ALIAS("platform: omap_control_phy");
>   MODULE_AUTHOR("Texas Instruments Inc.");
> -MODULE_DESCRIPTION("OMAP Control Module USB Driver");
> +MODULE_DESCRIPTION("OMAP Control Module PHY Driver");
>   MODULE_LICENSE("GPL v2");
> diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
> index 3cc4aba..a2205a8 100644
> --- a/drivers/phy/phy-omap-usb2.c
> +++ b/drivers/phy/phy-omap-usb2.c
> @@ -27,7 +27,7 @@
>   #include <linux/err.h>
>   #include <linux/pm_runtime.h>
>   #include <linux/delay.h>
> -#include <linux/usb/omap_control_usb.h>
> +#include <linux/phy/omap_control_phy.h>
>   #include <linux/phy/phy.h>
>   #include <linux/of_platform.h>
>
> @@ -105,7 +105,7 @@ static int omap_usb_power_off(struct phy *x)
>   {
>   	struct omap_usb *phy = phy_get_drvdata(x);
>
> -	omap_control_usb_phy_power(phy->control_dev, 0);
> +	omap_control_phy_power(phy->control_dev, 0);
>
>   	return 0;
>   }
> @@ -114,7 +114,7 @@ static int omap_usb_power_on(struct phy *x)
>   {
>   	struct omap_usb *phy = phy_get_drvdata(x);
>
> -	omap_control_usb_phy_power(phy->control_dev, 1);
> +	omap_control_phy_power(phy->control_dev, 1);
>
>   	return 0;
>   }
> @@ -251,7 +251,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
>   	}
>
>   	phy->control_dev = &control_pdev->dev;
> -	omap_control_usb_phy_power(phy->control_dev, 0);
> +	omap_control_phy_power(phy->control_dev, 0);
>
>   	otg->set_host		= omap_usb_set_host;
>   	otg->set_peripheral	= omap_usb_set_peripheral;
> diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
> index c8d1674..fd029b1 100644
> --- a/drivers/phy/phy-ti-pipe3.c
> +++ b/drivers/phy/phy-ti-pipe3.c
> @@ -26,7 +26,7 @@
>   #include <linux/io.h>
>   #include <linux/pm_runtime.h>
>   #include <linux/delay.h>
> -#include <linux/usb/omap_control_usb.h>
> +#include <linux/phy/omap_control_phy.h>
>   #include <linux/of_platform.h>
>
>   #define	PLL_STATUS		0x00000004
> @@ -134,7 +134,7 @@ static int ti_pipe3_power_off(struct phy *x)
>   		return -EBUSY;
>   	}
>
> -	omap_control_usb_phy_power(phy->control_dev, 0);
> +	omap_control_phy_power(phy->control_dev, 0);
>
>   	return 0;
>   }
> @@ -232,7 +232,7 @@ static int ti_pipe3_init(struct phy *x)
>   	if (ret)
>   		return ret;
>
> -	omap_control_usb_phy_power(phy->control_dev, 1);
> +	omap_control_phy_power(phy->control_dev, 1);
>
>   	return 0;
>   }
> @@ -304,7 +304,7 @@ static int ti_pipe3_probe(struct platform_device *pdev)
>
>   	phy->control_dev = &control_pdev->dev;
>
> -	omap_control_usb_phy_power(phy->control_dev, 0);
> +	omap_control_phy_power(phy->control_dev, 0);
>
>   	platform_set_drvdata(pdev, phy);
>   	pm_runtime_enable(phy->dev);
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index 8aa59a2..d341c14 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -37,7 +37,7 @@
>   #include <linux/err.h>
>   #include <linux/delay.h>
>   #include <linux/usb/musb-omap.h>
> -#include <linux/usb/omap_control_usb.h>
> +#include <linux/phy/omap_control_phy.h>
>   #include <linux/of_platform.h>
>
>   #include "musb_core.h"
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index c337ba2..416e0c8 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -75,16 +75,6 @@ config NOP_USB_XCEIV
>   	  built-in with usb ip or which are autonomous and doesn't require any
>   	  phy programming such as ISP1x04 etc.
>
> -config OMAP_CONTROL_USB
> -	tristate "OMAP CONTROL USB Driver"
> -	depends on ARCH_OMAP2PLUS || COMPILE_TEST
> -	help
> -	  Enable this to add support for the USB part present in the control
> -	  module. This driver has API to power on the USB2 PHY and to write to
> -	  the mailbox. The mailbox is present only in omap4 and the register to
> -	  power on the USB2 PHY is present in OMAP4 and OMAP5. OMAP5 has an
> -	  additional register to power on USB3 PHY.
> -
>   config AM335X_CONTROL_USB
>   	tristate
>
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index 15f1878..f8fa719 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -13,7 +13,6 @@ obj-$(CONFIG_ISP1301_OMAP)		+= phy-isp1301-omap.o
>   obj-$(CONFIG_MV_U3D_PHY)		+= phy-mv-u3d-usb.o
>   obj-$(CONFIG_NOP_USB_XCEIV)		+= phy-generic.o
>   obj-$(CONFIG_TAHVO_USB)			+= phy-tahvo.o
> -obj-$(CONFIG_OMAP_CONTROL_USB)		+= phy-omap-control.o
>   obj-$(CONFIG_AM335X_CONTROL_USB)	+= phy-am335x-control.o
>   obj-$(CONFIG_AM335X_PHY_USB)		+= phy-am335x.o
>   obj-$(CONFIG_OMAP_OTG)			+= phy-omap-otg.o
> diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/phy/omap_control_phy.h
> similarity index 68%
> rename from include/linux/usb/omap_control_usb.h
> rename to include/linux/phy/omap_control_phy.h
> index 69ae383..5450403 100644
> --- a/include/linux/usb/omap_control_usb.h
> +++ b/include/linux/phy/omap_control_phy.h
> @@ -1,5 +1,5 @@
>   /*
> - * omap_control_usb.h - Header file for the USB part of control module.
> + * omap_control_phy.h - Header file for the PHY part of control module.
>    *
>    * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
>    * This program is free software; you can redistribute it and/or modify
> @@ -16,10 +16,10 @@
>    *
>    */
>
> -#ifndef __OMAP_CONTROL_USB_H__
> -#define __OMAP_CONTROL_USB_H__
> +#ifndef __OMAP_CONTROL_PHY_H__
> +#define __OMAP_CONTROL_PHY_H__
>
> -enum omap_control_usb_type {
> +enum omap_control_phy_type {
>   	OMAP_CTRL_TYPE_OTGHS = 1,	/* Mailbox OTGHS_CONTROL */
>   	OMAP_CTRL_TYPE_USB2,	/* USB2_PHY, power down in CONTROL_DEV_CONF */
>   	OMAP_CTRL_TYPE_PIPE3,	/* PIPE3 PHY, DPLL & seperate Rx/Tx power */
> @@ -27,7 +27,7 @@ enum omap_control_usb_type {
>   	OMAP_CTRL_TYPE_AM437USB2, /* USB2 PHY, power e.g. AM437x */
>   };
>
> -struct omap_control_usb {
> +struct omap_control_phy {
>   	struct device *dev;
>
>   	u32 __iomem *otghs_control;
> @@ -36,7 +36,7 @@ struct omap_control_usb {
>
>   	struct clk *sys_clk;
>
> -	enum omap_control_usb_type type;
> +	enum omap_control_phy_type type;
>   };
>
>   enum omap_control_usb_mode {
> @@ -54,14 +54,14 @@ enum omap_control_usb_mode {
>   #define	OMAP_CTRL_DEV_SESSEND		BIT(3)
>   #define	OMAP_CTRL_DEV_IDDIG		BIT(4)
>
> -#define	OMAP_CTRL_USB_PWRCTL_CLK_CMD_MASK	0x003FC000
> -#define	OMAP_CTRL_USB_PWRCTL_CLK_CMD_SHIFT	0xE
> +#define	OMAP_CTRL_PIPE3_PHY_PWRCTL_CLK_CMD_MASK		0x003FC000
> +#define	OMAP_CTRL_PIPE3_PHY_PWRCTL_CLK_CMD_SHIFT	0xE
>
> -#define	OMAP_CTRL_USB_PWRCTL_CLK_FREQ_MASK	0xFFC00000
> -#define	OMAP_CTRL_USB_PWRCTL_CLK_FREQ_SHIFT	0x16
> +#define	OMAP_CTRL_PIPE3_PHY_PWRCTL_CLK_FREQ_MASK	0xFFC00000
> +#define	OMAP_CTRL_PIPE3_PHY_PWRCTL_CLK_FREQ_SHIFT	0x16
>
> -#define	OMAP_CTRL_USB3_PHY_TX_RX_POWERON	0x3
> -#define	OMAP_CTRL_USB3_PHY_TX_RX_POWEROFF	0x0
> +#define	OMAP_CTRL_PIPE3_PHY_TX_RX_POWERON	0x3
> +#define	OMAP_CTRL_PIPE3_PHY_TX_RX_POWEROFF	0x0
>
>   #define OMAP_CTRL_USB2_PHY_PD		BIT(28)
>
> @@ -70,13 +70,13 @@ enum omap_control_usb_mode {
>   #define AM437X_CTRL_USB2_OTGVDET_EN	BIT(19)
>   #define AM437X_CTRL_USB2_OTGSESSEND_EN	BIT(20)
>
> -#if IS_ENABLED(CONFIG_OMAP_CONTROL_USB)
> -extern void omap_control_usb_phy_power(struct device *dev, int on);
> -extern void omap_control_usb_set_mode(struct device *dev,
> -	enum omap_control_usb_mode mode);
> +#if IS_ENABLED(CONFIG_OMAP_CONTROL_PHY)
> +void omap_control_phy_power(struct device *dev, int on);
> +void omap_control_usb_set_mode(struct device *dev,
> +			       enum omap_control_usb_mode mode);
>   #else
>
> -static inline void omap_control_usb_phy_power(struct device *dev, int on)
> +static inline void omap_control_phy_power(struct device *dev, int on)
>   {
>   }
>
> @@ -86,4 +86,4 @@ static inline void omap_control_usb_set_mode(struct device *dev,
>   }
>   #endif
>
> -#endif	/* __OMAP_CONTROL_USB_H__ */
> +#endif	/* __OMAP_CONTROL_PHY_H__ */
>
