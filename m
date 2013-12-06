Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab3LFK72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 05:59:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55964 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab3LFK70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 05:59:26 -0500
Message-ID: <52A1ADFF.4060207@ti.com>
Date: Fri, 6 Dec 2013 16:29:11 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <kyungmin.park@samsung.com>, <t.figa@samsung.com>,
        <s.nawrocki@samsung.com>, <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>
Subject: Re: [PATCH v4 3/9] phy: Add new Exynos USB PHY driver
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com> <1386246579-25141-4-git-send-email-k.debski@samsung.com>
In-Reply-To: <1386246579-25141-4-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 05 December 2013 05:59 PM, Kamil Debski wrote:
> Add a new driver for the Exynos USB PHY. The new driver uses the generic
> PHY framework. The driver includes support for the Exynos 4x10 and 4x12
> SoC families.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/phy/samsung-usbphy.txt     |   54 ++++
>  drivers/phy/Kconfig                                |   20 ++
>  drivers/phy/Makefile                               |    3 +
>  drivers/phy/phy-exynos4210-usb2.c                  |  264 +++++++++++++++++
>  drivers/phy/phy-exynos4212-usb2.c                  |  312 ++++++++++++++++++++
>  drivers/phy/phy-samsung-usb2.c                     |  228 ++++++++++++++
>  drivers/phy/phy-samsung-usb2.h                     |   72 +++++
>  7 files changed, 953 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/samsung-usbphy.txt
>  create mode 100644 drivers/phy/phy-exynos4210-usb2.c
>  create mode 100644 drivers/phy/phy-exynos4212-usb2.c
>  create mode 100644 drivers/phy/phy-samsung-usb2.c
>  create mode 100644 drivers/phy/phy-samsung-usb2.h
> 
> diff --git a/Documentation/devicetree/bindings/phy/samsung-usbphy.txt b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> new file mode 100644
> index 0000000..cadbf70
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt

use the existing samsung-phy.txt.
> @@ -0,0 +1,54 @@
> +Samsung S5P/EXYNOS SoC series USB PHY
> +-------------------------------------------------
> +
> +Required properties:
> +- compatible : should be one of the listed compatibles:
> +	- "samsung,exynos4210-usb2-phy"
> +	- "samsung,exynos4212-usb2-phy"
> +- reg : a list of registers used by phy driver
> +	- first and obligatory is the location of phy modules registers
> +- samsung,sysreg-phandle - handle to syscon used to control the system registers
> +- samsung,pmureg-phandle - handle to syscon used to control PMU registers
> +- #phy-cells : from the generic phy bindings, must be 1;
> +- clocks and clock-names:
> +	- the "phy" clocks is required by the phy module
> +	- next for each of the phys a clock has to be assidned, this clock

%s/assidned/assigned/
> +	  will be used to determine clocking frequency for the phys
> +	  (the labels are specified in the paragraph below)
> +
> +The first phandle argument in the PHY specifier identifies the PHY, its
> +meaning is compatible dependent. For the currently supported SoCs (Exynos 4210
> +and Exynos 4212) it is as follows:
> +  0 - USB device ("device"),
> +  1 - USB host ("host"),
> +  2 - HSIC0 ("hsic0"),
> +  3 - HSIC1 ("hsic1"),
> +
> +Exynos 4210 and Exynos 4212 use mode switching and require that mode switch
> +register is supplied.
> +
> +Example:
> +
> +For Exynos 4412 (compatible with Exynos 4212):
> +
> +usbphy: phy@125B0000 {

use lower case for address here...
> +	compatible = "samsung,exynos4212-usb2-phy";
> +	reg = <0x125B0000 0x100 0x10020704 0x0c 0x1001021c 0x4>;
and here..
> +	clocks = <&clock 305>, <&clock 2>, <&clock 2>, <&clock 2>,
> +							<&clock 2>;
> +	clock-names = "phy", "device", "host", "hsic0", "hsic1";
> +	status = "okay";
> +	#phy-cells = <1>;
> +	samsung,sysreg-phandle = <&sys_reg>;
> +	samsung,pmureg-phandle = <&pmu_reg>;
> +};
> +
> +Then the PHY can be used in other nodes such as:
> +
> +phy-consumer@12340000 {
> +	phys = <&usbphy 2>;
> +	phy-names = "phy";
> +};
> +
> +Refer to DT bindings documentation of particular PHY consumer devices for more
> +information about required PHYs and the way of specification.
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index a344f3d..b29018f 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -51,4 +51,24 @@ config PHY_EXYNOS_DP_VIDEO
>  	help
>  	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
>  
> +config PHY_SAMSUNG_USB2
> +	tristate "Samsung USB 2.0 PHY driver"
> +	help
> +	  Enable this to support Samsung USB phy helper driver for Samsung SoCs.
> +	  This driver provides common interface to interact, for Samsung
> +	  USB 2.0 PHY driver.
> +
> +config PHY_EXYNOS4210_USB2
> +	bool "Support for Exynos 4210"
> +	depends on PHY_SAMSUNG_USB2
> +	depends on CPU_EXYNOS4210

select GENERIC_PHY here?
> +	help
> +	  Enable USB PHY support for Exynos 4210

Add more explanation here and make checkpatch happy.
> +
> +config PHY_EXYNOS4212_USB2
> +	bool "Support for Exynos 4212"
> +	depends on PHY_SAMSUNG_USB2
> +	depends on (SOC_EXYNOS4212 || SOC_EXYNOS4412)

select GENERIC_PHY.
> +	help
> +	  Enable USB PHY support for Exynos 4212

more explanation here too..
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index d0caae9..9f4befd 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -7,3 +7,6 @@ obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>  obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>  obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>  obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> +obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-samsung-usb2.o
> +obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
> +obj-$(CONFIG_PHY_EXYNOS4212_USB2)	+= phy-exynos4212-usb2.o
> diff --git a/drivers/phy/phy-exynos4210-usb2.c b/drivers/phy/phy-exynos4210-usb2.c
> new file mode 100644
> index 0000000..a02e5c2
> --- /dev/null
> +++ b/drivers/phy/phy-exynos4210-usb2.c
> @@ -0,0 +1,264 @@
> +/*
> + * Samsung SoC USB 1.1/2.0 PHY driver - Exynos 4210 support
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Author: Kamil Debski <k.debski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/spinlock.h>

You've included most of the above header files in phy-samsung-usb2.h which you
are including below.
> +#include "phy-samsung-usb2.h"
> +
> +/* Exynos USB PHY registers */
> +
> +/* PHY power control */
> +#define EXYNOS_4210_UPHYPWR			0x0
> +
> +#define EXYNOS_4210_UPHYPWR_PHY0_SUSPEND	(1 << 0)

use BIT() here and everywhere below.
> +#define EXYNOS_4210_UPHYPWR_PHY0_PWR		(1 << 3)

replace PHY0 here with DEV so it looks similar to EXYNOS_4212.
> +#define EXYNOS_4210_UPHYPWR_PHY0_OTG_PWR	(1 << 4)
> +#define EXYNOS_4210_UPHYPWR_PHY0_SLEEP		(1 << 5)
> +#define EXYNOS_4210_UPHYPWR_PHY0	( \
> +	EXYNOS_4210_UPHYPWR_PHY0_SUSPEND | \
> +	EXYNOS_4210_UPHYPWR_PHY0_PWR | \
> +	EXYNOS_4210_UPHYPWR_PHY0_OTG_PWR | \
> +	EXYNOS_4210_UPHYPWR_PHY0_SLEEP)
> +
> +#define EXYNOS_4210_UPHYPWR_PHY1_SUSPEND	(1 << 6)

replace PHY0 here with HOST so it looks similar to EXYNOS_4212.
> +#define EXYNOS_4210_UPHYPWR_PHY1_PWR		(1 << 7)
> +#define EXYNOS_4210_UPHYPWR_PHY1_SLEEP		(1 << 8)
> +#define EXYNOS_4210_UPHYPWR_PHY1 ( \
> +	EXYNOS_4210_UPHYPWR_PHY1_SUSPEND | \
> +	EXYNOS_4210_UPHYPWR_PHY1_PWR | \
> +	EXYNOS_4210_UPHYPWR_PHY1_SLEEP)
> +
> +#define EXYNOS_4210_UPHYPWR_HSCI0_SUSPEND	(1 << 9)
> +#define EXYNOS_4210_UPHYPWR_HSCI0_SLEEP		(1 << 10)
> +#define EXYNOS_4210_UPHYPWR_HSCI0 ( \
> +	EXYNOS_4210_UPHYPWR_HSCI0_SUSPEND | \
> +	EXYNOS_4210_UPHYPWR_HSCI0_SLEEP)
> +
> +#define EXYNOS_4210_UPHYPWR_HSCI1_SUSPEND	(1 << 11)
> +#define EXYNOS_4210_UPHYPWR_HSCI1_SLEEP		(1 << 12)
> +#define EXYNOS_4210_UPHYPWR_HSCI1 ( \
> +	EXYNOS_4210_UPHYPWR_HSCI1_SUSPEND | \
> +	EXYNOS_4210_UPHYPWR_HSCI1_SLEEP)
> +
> +/* PHY clock control */
> +#define EXYNOS_4210_UPHYCLK			0x4
> +
> +#define EXYNOS_4210_UPHYCLK_PHYFSEL_MASK	(0x3 << 0)
> +#define EXYNOS_4210_UPHYCLK_PHYFSEL_48MHZ	(0x0 << 0)
> +#define EXYNOS_4210_UPHYCLK_PHYFSEL_24MHZ	(0x3 << 0)
> +#define EXYNOS_4210_UPHYCLK_PHYFSEL_12MHZ	(0x2 << 0)
> +
> +#define EXYNOS_4210_UPHYCLK_PHY0_ID_PULLUP	(0x1 << 2)
> +#define EXYNOS_4210_UPHYCLK_PHY0_COMMON_ON	(0x1 << 4)
> +#define EXYNOS_4210_UPHYCLK_PHY1_COMMON_ON	(0x1 << 7)
> +
> +/* PHY reset control */
> +#define EXYNOS_4210_UPHYRST			0x8
> +
> +#define EXYNOS_4210_URSTCON_PHY0		(1 << 0)
> +#define EXYNOS_4210_URSTCON_OTG_HLINK		(1 << 1)
> +#define EXYNOS_4210_URSTCON_OTG_PHYLINK		(1 << 2)
> +#define EXYNOS_4210_URSTCON_PHY1_ALL		(1 << 3)
> +#define EXYNOS_4210_URSTCON_PHY1_P0		(1 << 4)
> +#define EXYNOS_4210_URSTCON_PHY1_P1P2		(1 << 5)
> +#define EXYNOS_4210_URSTCON_HOST_LINK_ALL	(1 << 6)
> +#define EXYNOS_4210_URSTCON_HOST_LINK_P0	(1 << 7)
> +#define EXYNOS_4210_URSTCON_HOST_LINK_P1	(1 << 8)
> +#define EXYNOS_4210_URSTCON_HOST_LINK_P2	(1 << 9)
> +
> +/* Isolation, configured in the power management unit */
> +#define EXYNOS_4210_USB_ISOL_DEVICE_OFFSET	0x704
> +#define EXYNOS_4210_USB_ISOL_DEVICE		(1 << 0)
> +#define EXYNOS_4210_USB_ISOL_HOST_OFFSET	0x708
> +#define EXYNOS_4210_USB_ISOL_HOST		(1 << 0)
> +
> +/* USBYPHY1 Floating prevention */
> +#define EXYNOS_4210_UPHY1CON			0x34
> +#define EXYNOS_4210_UPHY1CON_FLOAT_PREVENTION	0x1
> +
> +/* Mode switching SUB Device <-> Host */
> +#define EXYNOS_4210_MODE_SWITCH_OFFSET		0x21c
> +#define EXYNOS_4210_MODE_SWITCH_MASK		1
> +#define EXYNOS_4210_MODE_SWITCH_DEVICE		0
> +#define EXYNOS_4210_MODE_SWITCH_HOST		1
> +
> +enum exynos4210_phy_id {
> +	EXYNOS4210_DEVICE,
> +	EXYNOS4210_HOST,
> +	EXYNOS4210_HSIC0,
> +	EXYNOS4210_HSIC1,
> +	EXYNOS4210_NUM_PHYS,
> +};
> +
> +/*
> + * exynos4210_rate_to_clk() converts the supplied clock rate to the value that
> + * can be written to the phy register.
> + */
> +static int exynos4210_rate_to_clk(unsigned long rate, u32 *reg)
> +{
> +	switch (rate) {
> +	case 12 * MHZ:
> +		*reg = EXYNOS_4210_UPHYCLK_PHYFSEL_12MHZ;
> +		break;
> +	case 24 * MHZ:
> +		*reg = EXYNOS_4210_UPHYCLK_PHYFSEL_24MHZ;
> +		break;
> +	case 48 * MHZ:
> +		reg = EXYNOS_4210_UPHYCLK_PHYFSEL_48MHZ;

%s/reg/*reg
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static void exynos4210_isol(struct samsung_usb2_phy_instance *inst, bool on)
> +{
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +	u32 offset;
> +	u32 mask;
> +
> +	switch (inst->cfg->id) {
> +	case EXYNOS4210_DEVICE:
> +		offset = EXYNOS_4210_USB_ISOL_DEVICE_OFFSET;
> +		mask = EXYNOS_4210_USB_ISOL_DEVICE;
> +		break;
> +	case EXYNOS4210_HOST:
> +		offset = EXYNOS_4210_USB_ISOL_HOST_OFFSET;
> +		mask = EXYNOS_4210_USB_ISOL_HOST;
> +		break;
> +	default:
> +		return;
> +	};
> +
> +	regmap_update_bits(drv->reg_pmu, offset, mask, on ? 0 : mask);
> +}
> +
> +static void exynos4210_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
> +{
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +	u32 rstbits = 0;
> +	u32 phypwr = 0;
> +	u32 rst;
> +	u32 pwr;
> +
> +	switch (inst->cfg->id) {
> +	case EXYNOS4210_DEVICE:
> +		phypwr =	EXYNOS_4210_UPHYPWR_PHY0;
> +		rstbits =	EXYNOS_4210_URSTCON_PHY0;
> +		break;
> +	case EXYNOS4210_HOST:
> +		phypwr =	EXYNOS_4210_UPHYPWR_PHY1;
> +		rstbits =	EXYNOS_4210_URSTCON_PHY1_ALL |
> +				EXYNOS_4210_URSTCON_PHY1_P0 |
> +				EXYNOS_4210_URSTCON_PHY1_P1P2 |
> +				EXYNOS_4210_URSTCON_HOST_LINK_ALL |
> +				EXYNOS_4210_URSTCON_HOST_LINK_P0;
> +		writel(on, drv->reg_phy + EXYNOS_4210_UPHY1CON);
> +		break;
> +	case EXYNOS4210_HSIC0:
> +		phypwr =	EXYNOS_4210_UPHYPWR_HSCI0;
> +		rstbits =	EXYNOS_4210_URSTCON_PHY1_P1P2 |
> +				EXYNOS_4210_URSTCON_HOST_LINK_P1;
> +		break;
> +	case EXYNOS4210_HSIC1:
> +		phypwr =	EXYNOS_4210_UPHYPWR_HSCI1;
> +		rstbits =	EXYNOS_4210_URSTCON_PHY1_P1P2 |
> +				EXYNOS_4210_URSTCON_HOST_LINK_P2;
> +		break;
> +	};
> +
> +	if (on) {
> +		writel(inst->clk_reg_val, drv->reg_phy + EXYNOS_4210_UPHYCLK);
> +
> +		pwr = readl(drv->reg_phy + EXYNOS_4210_UPHYPWR);
> +		pwr &= ~phypwr;
> +		writel(pwr, drv->reg_phy + EXYNOS_4210_UPHYPWR);
> +
> +		rst = readl(drv->reg_phy + EXYNOS_4210_UPHYRST);
> +		rst |= rstbits;
> +		writel(rst, drv->reg_phy + EXYNOS_4210_UPHYRST);
> +		udelay(10);
> +		rst &= ~rstbits;
> +		writel(rst, drv->reg_phy + EXYNOS_4210_UPHYRST);

Do you have to reset during every power on? IMO this reset should be done once
in phy_init.
> +	} else {
> +		pwr = readl(drv->reg_phy + EXYNOS_4210_UPHYPWR);
> +		pwr |= phypwr;
> +		writel(pwr, drv->reg_phy + EXYNOS_4210_UPHYPWR);
> +	}
> +}
> +
> +static int exynos4210_power_on(struct samsung_usb2_phy_instance *inst)
> +{
> +	/* Order of initialisation is important - first power then isolation */
> +	exynos4210_phy_pwr(inst, 1);
> +	exynos4210_isol(inst, 0);
> +
> +	return 0;
> +}
> +
> +static int exynos4210_power_off(struct samsung_usb2_phy_instance *inst)
> +{
> +	exynos4210_isol(inst, 1);
> +	exynos4210_phy_pwr(inst, 0);
> +
> +	return 0;
> +}
> +
> +
> +static const struct samsung_usb2_common_phy exynos4210_phys[] = {
> +	{
> +		.label		= "device",
> +		.id		= EXYNOS4210_DEVICE,
> +		.rate_to_clk	= exynos4210_rate_to_clk,
> +		.power_on	= exynos4210_power_on,
> +		.power_off	= exynos4210_power_off,
> +	},
> +	{
> +		.label		= "host",
> +		.id		= EXYNOS4210_HOST,
> +		.rate_to_clk	= exynos4210_rate_to_clk,
> +		.power_on	= exynos4210_power_on,
> +		.power_off	= exynos4210_power_off,
> +	},
> +	{
> +		.label		= "hsic0",
> +		.id		= EXYNOS4210_HSIC0,
> +		.rate_to_clk	= exynos4210_rate_to_clk,
> +		.power_on	= exynos4210_power_on,
> +		.power_off	= exynos4210_power_off,
> +	},
> +	{
> +		.label		= "hsic1",
> +		.id		= EXYNOS4210_HSIC1,
> +		.rate_to_clk	= exynos4210_rate_to_clk,
> +		.power_on	= exynos4210_power_on,
> +		.power_off	= exynos4210_power_off,
> +	},
> +	{},
> +};
> +
> +const struct samsung_usb2_phy_config exynos4210_usb2_phy_config = {
> +	.num_phys		= EXYNOS4210_NUM_PHYS,
> +	.phys			= exynos4210_phys,
> +	.has_mode_switch	= 1,
> +};
> +
> diff --git a/drivers/phy/phy-exynos4212-usb2.c b/drivers/phy/phy-exynos4212-usb2.c
> new file mode 100644
> index 0000000..375ece0
> --- /dev/null
> +++ b/drivers/phy/phy-exynos4212-usb2.c
> @@ -0,0 +1,312 @@
> +/*
> + * Samsung S5P/EXYNOS SoC series USB PHY driver - Exynos 4212 support
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Author: Kamil Debski <k.debski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/spinlock.h>

You've included most of the above header files in phy-samsung-usb2.h which you
are including below.
> +#include "phy-samsung-usb2.h"
> +
> +/* Exynos USB PHY registers */
> +
> +/* PHY power control */
> +#define EXYNOS_4212_UPHYPWR			0x0
> +
> +#define EXYNOS_4212_UPHYPWR_DEV_SUSPEND		(1 << 0)

use BIT() here and below..
> +#define EXYNOS_4212_UPHYPWR_DEV_PWR		(1 << 3)
> +#define EXYNOS_4212_UPHYPWR_DEV_OTG_PWR		(1 << 4)
> +#define EXYNOS_4212_UPHYPWR_DEV_SLEEP		(1 << 5)
> +#define EXYNOS_4212_UPHYPWR_DEV	( \
> +	EXYNOS_4212_UPHYPWR_DEV_SUSPEND | \
> +	EXYNOS_4212_UPHYPWR_DEV_PWR | \
> +	EXYNOS_4212_UPHYPWR_DEV_OTG_PWR | \
> +	EXYNOS_4212_UPHYPWR_DEV_SLEEP)
> +
> +#define EXYNOS_4212_UPHYPWR_HOST_SUSPEND	(1 << 6)
> +#define EXYNOS_4212_UPHYPWR_HOST_PWR		(1 << 7)
> +#define EXYNOS_4212_UPHYPWR_HOST_SLEEP		(1 << 8)
> +#define EXYNOS_4212_UPHYPWR_HOST ( \
> +	EXYNOS_4212_UPHYPWR_HOST_SUSPEND | \
> +	EXYNOS_4212_UPHYPWR_HOST_PWR | \
> +	EXYNOS_4212_UPHYPWR_HOST_SLEEP)
> +
> +#define EXYNOS_4212_UPHYPWR_HSCI0_SUSPEND	(1 << 9)
> +#define EXYNOS_4212_UPHYPWR_HSCI0_PWR		(1 << 10)
> +#define EXYNOS_4212_UPHYPWR_HSCI0_SLEEP		(1 << 11)
> +#define EXYNOS_4212_UPHYPWR_HSCI0 ( \
> +	EXYNOS_4212_UPHYPWR_HSCI0_SUSPEND | \
> +	EXYNOS_4212_UPHYPWR_HSCI0_PWR | \
> +	EXYNOS_4212_UPHYPWR_HSCI0_SLEEP)
> +
> +#define EXYNOS_4212_UPHYPWR_HSCI1_SUSPEND	(1 << 12)
> +#define EXYNOS_4212_UPHYPWR_HSCI1_PWR		(1 << 13)
> +#define EXYNOS_4212_UPHYPWR_HSCI1_SLEEP		(1 << 14)
> +#define EXYNOS_4212_UPHYPWR_HSCI1 ( \
> +	EXYNOS_4212_UPHYPWR_HSCI1_SUSPEND | \
> +	EXYNOS_4212_UPHYPWR_HSCI1_PWR | \
> +	EXYNOS_4212_UPHYPWR_HSCI1_SLEEP)
> +
> +/* PHY clock control */
> +#define EXYNOS_4212_UPHYCLK			0x4
> +
> +#define EXYNOS_4212_UPHYCLK_PHYFSEL_MASK	(0x7 << 0)
> +#define EXYNOS_4212_UPHYCLK_PHYFSEL_9MHZ6	(0x0 << 0)
> +#define EXYNOS_4212_UPHYCLK_PHYFSEL_10MHZ	(0x1 << 0)
> +#define EXYNOS_4212_UPHYCLK_PHYFSEL_12MHZ	(0x2 << 0)
> +#define EXYNOS_4212_UPHYCLK_PHYFSEL_19MHZ2	(0x3 << 0)
> +#define EXYNOS_4212_UPHYCLK_PHYFSEL_20MHZ	(0x4 << 0)
> +#define EXYNOS_4212_UPHYCLK_PHYFSEL_24MHZ	(0x5 << 0)
> +#define EXYNOS_4212_UPHYCLK_PHYFSEL_50MHZ	(0x7 << 0)
> +
> +#define EXYNOS_4212_UPHYCLK_PHY0_ID_PULLUP	(0x1 << 3)
> +#define EXYNOS_4212_UPHYCLK_PHY0_COMMON_ON	(0x1 << 4)
> +#define EXYNOS_4212_UPHYCLK_PHY1_COMMON_ON	(0x1 << 7)
> +
> +#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_MASK	(0x7f << 10)
> +#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_12MHZ	(0x24 << 10)
> +#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_15MHZ	(0x1c << 10)
> +#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_16MHZ	(0x1a << 10)
> +#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_19MHZ2	(0x15 << 10)
> +#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_20MHZ	(0x14 << 10)
> +
> +/* PHY reset control */
> +#define EXYNOS_4212_UPHYRST			0x8
> +
> +#define EXYNOS_4212_URSTCON_DEVICE		(1 << 0)
> +#define EXYNOS_4212_URSTCON_OTG_HLINK		(1 << 1)
> +#define EXYNOS_4212_URSTCON_OTG_PHYLINK		(1 << 2)
> +#define EXYNOS_4212_URSTCON_HOST_PHY		(1 << 3)
> +#define EXYNOS_4212_URSTCON_PHY1		(1 << 4)
> +#define EXYNOS_4212_URSTCON_HSIC0		(1 << 5)
> +#define EXYNOS_4212_URSTCON_HSIC1		(1 << 6)
> +#define EXYNOS_4212_URSTCON_HOST_LINK_ALL	(1 << 7)
> +#define EXYNOS_4212_URSTCON_HOST_LINK_P0	(1 << 8)
> +#define EXYNOS_4212_URSTCON_HOST_LINK_P1	(1 << 9)
> +#define EXYNOS_4212_URSTCON_HOST_LINK_P2	(1 << 10)
> +
> +/* Isolation, configured in the power management unit */
> +#define EXYNOS_4212_USB_ISOL_OFFSET		0x704
> +#define EXYNOS_4212_USB_ISOL_OTG		(1 << 0)
> +#define EXYNOS_4212_USB_ISOL_HSIC0_OFFSET	0x708
> +#define EXYNOS_4212_USB_ISOL_HSIC0		(1 << 0)
> +#define EXYNOS_4212_USB_ISOL_HSIC1_OFFSET	0x70c
> +#define EXYNOS_4212_USB_ISOL_HSIC1		(1 << 0)
> +
> +/* Mode switching SUB Device <-> Host */
> +#define EXYNOS_4212_MODE_SWITCH_OFFSET		0x21c
> +#define EXYNOS_4212_MODE_SWITCH_MASK		1
> +#define EXYNOS_4212_MODE_SWITCH_DEVICE		0
> +#define EXYNOS_4212_MODE_SWITCH_HOST		1
> +
> +enum exynos4x12_phy_id {
> +	EXYNOS4212_DEVICE,
> +	EXYNOS4212_HOST,
> +	EXYNOS4212_HSIC0,
> +	EXYNOS4212_HSIC1,
> +	EXYNOS4212_NUM_PHYS,
> +};
> +
> +/*
> + * exynos4212_rate_to_clk() converts the supplied clock rate to the value that
> + * can be written to the phy register.
> + */
> +static int exynos4212_rate_to_clk(unsigned long rate, u32 *reg)
> +{
> +	/* EXYNOS_4212_UPHYCLK_PHYFSEL_MASK */
> +
> +	switch (rate) {
> +	case 9600 * KHZ:
> +		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_9MHZ6;
> +		break;
> +	case 10 * MHZ:
> +		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_10MHZ;
> +		break;
> +	case 12 * MHZ:
> +		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_12MHZ;
> +		break;
> +	case 19200 * KHZ:
> +		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_19MHZ2;
> +		break;
> +	case 20 * MHZ:
> +		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_20MHZ;
> +		break;
> +	case 24 * MHZ:
> +		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_24MHZ;
> +		break;
> +	case 50 * MHZ:
> +		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_50MHZ;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static void exynos4212_isol(struct samsung_usb2_phy_instance *inst, bool on)
> +{
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +	u32 offset;
> +	u32 mask;
> +
> +	switch (inst->cfg->id) {
> +	case EXYNOS4212_DEVICE:
> +	case EXYNOS4212_HOST:
> +		offset = EXYNOS_4212_USB_ISOL_OFFSET;
> +		mask = EXYNOS_4212_USB_ISOL_OTG;
> +		break;
> +	case EXYNOS4212_HSIC0:
> +		offset = EXYNOS_4212_USB_ISOL_HSIC0_OFFSET;
> +		mask = EXYNOS_4212_USB_ISOL_HSIC0;
> +		break;
> +	case EXYNOS4212_HSIC1:
> +		offset = EXYNOS_4212_USB_ISOL_HSIC1_OFFSET;
> +		mask = EXYNOS_4212_USB_ISOL_HSIC1;
> +		break;
> +	default:
> +		return;
> +	};
> +
> +	regmap_update_bits(drv->reg_pmu, offset, mask, on ? 0 : mask);
> +}
> +
> +static void exynos4212_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
> +{
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +	u32 rstbits = 0;
> +	u32 phypwr = 0;
> +	u32 rst;
> +	u32 pwr;
> +
> +	switch (inst->cfg->id) {
> +	case EXYNOS4212_DEVICE:
> +		phypwr =	EXYNOS_4212_UPHYPWR_DEV;
> +		rstbits =	EXYNOS_4212_URSTCON_DEVICE;
> +		break;
> +	case EXYNOS4212_HOST:
> +		phypwr =	EXYNOS_4212_UPHYPWR_HOST;
> +		rstbits =	EXYNOS_4212_URSTCON_HOST_PHY;
> +		break;
> +	case EXYNOS4212_HSIC0:
> +		phypwr =	EXYNOS_4212_UPHYPWR_HSCI0;
> +		rstbits =	EXYNOS_4212_URSTCON_HSIC1 |
> +				EXYNOS_4212_URSTCON_HOST_LINK_P0 |
> +				EXYNOS_4212_URSTCON_HOST_PHY;
> +		break;
> +	case EXYNOS4212_HSIC1:
> +		phypwr =	EXYNOS_4212_UPHYPWR_HSCI1;
> +		rstbits =	EXYNOS_4212_URSTCON_HSIC1 |
> +				EXYNOS_4212_URSTCON_HOST_LINK_P1;
> +		break;
> +	};
> +
> +	if (on) {
> +		writel(inst->clk_reg_val, drv->reg_phy + EXYNOS_4212_UPHYCLK);
> +
> +		pwr = readl(drv->reg_phy + EXYNOS_4212_UPHYPWR);
> +		pwr &= ~phypwr;
> +		writel(pwr, drv->reg_phy + EXYNOS_4212_UPHYPWR);
> +
> +		rst = readl(drv->reg_phy + EXYNOS_4212_UPHYRST);
> +		rst |= rstbits;
> +		writel(rst, drv->reg_phy + EXYNOS_4212_UPHYRST);
> +		udelay(10);
> +		rst &= ~rstbits;
> +		writel(rst, drv->reg_phy + EXYNOS_4212_UPHYRST);

reset should be done once in init?
> +	} else {
> +		pwr = readl(drv->reg_phy + EXYNOS_4212_UPHYPWR);
> +		pwr |= phypwr;
> +		writel(pwr, drv->reg_phy + EXYNOS_4212_UPHYPWR);
> +	}
> +}
> +
> +static int exynos4212_power_on(struct samsung_usb2_phy_instance *inst)
> +{
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +
> +	inst->enabled = 1;
> +	exynos4212_phy_pwr(inst, 1);
> +	exynos4212_isol(inst, 0);
> +
> +	/* Power on the device, as it is necessary for HSIC to work */

This looks weird. How powering on the 'device PHY' makes 'HSIC PHY' to work?
> +	if (inst->cfg->id == EXYNOS4212_HSIC0) {
> +		struct samsung_usb2_phy_instance *device =
> +					&drv->instances[EXYNOS4212_DEVICE];
> +		exynos4212_phy_pwr(device, 1);
> +		exynos4212_isol(device, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +static int exynos4212_power_off(struct samsung_usb2_phy_instance *inst)
> +{
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +	struct samsung_usb2_phy_instance *device = &drv->instances[EXYNOS4212_DEVICE];
> +
> +	inst->enabled = 0;
> +	exynos4212_isol(inst, 1);
> +	exynos4212_phy_pwr(inst, 0);
> +
> +	if (inst->cfg->id == EXYNOS4212_HSIC0 && !device->enabled) {
> +		exynos4212_isol(device, 1);
> +		exynos4212_phy_pwr(device, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +
> +static const struct samsung_usb2_common_phy exynos4212_phys[] = {
> +	{
> +		.label		= "device",
> +		.id		= EXYNOS4212_DEVICE,
> +		.rate_to_clk	= exynos4212_rate_to_clk,
> +		.power_on	= exynos4212_power_on,
> +		.power_off	= exynos4212_power_off,
> +	},
> +	{
> +		.label		= "host",
> +		.id		= EXYNOS4212_HOST,
> +		.rate_to_clk	= exynos4212_rate_to_clk,
> +		.power_on	= exynos4212_power_on,
> +		.power_off	= exynos4212_power_off,
> +	},
> +	{
> +		.label		= "hsic0",
> +		.id		= EXYNOS4212_HSIC0,
> +		.rate_to_clk	= exynos4212_rate_to_clk,
> +		.power_on	= exynos4212_power_on,
> +		.power_off	= exynos4212_power_off,
> +	},
> +	{
> +		.label		= "hsic1",
> +		.id		= EXYNOS4212_HSIC1,
> +		.rate_to_clk	= exynos4212_rate_to_clk,
> +		.power_on	= exynos4212_power_on,
> +		.power_off	= exynos4212_power_off,
> +	},
> +	{},
> +};
> +
> +const struct samsung_usb2_phy_config exynos4212_usb2_phy_config = {
> +	.num_phys		= EXYNOS4212_NUM_PHYS,
> +	.phys			= exynos4212_phys,
> +	.has_mode_switch	= 1,
> +};
> +
> diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
> new file mode 100644
> index 0000000..804ec77
> --- /dev/null
> +++ b/drivers/phy/phy-samsung-usb2.c
> @@ -0,0 +1,228 @@
> +/*
> + * Samsung SoC USB 1.1/2.0 PHY driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Author: Kamil Debski <k.debski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>

You've included most of the above header files in phy-samsung-usb2.h which you
are including below.
> +#include "phy-samsung-usb2.h"
> +
> +static int samsung_usb2_phy_power_on(struct phy *phy)
> +{
> +	struct samsung_usb2_phy_instance *inst = phy_get_drvdata(phy);
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +	int ret;
> +
> +	dev_dbg(drv->dev, "Request to power_on \"%s\" usb phy\n",
> +							inst->cfg->label);
> +	ret = clk_prepare_enable(drv->clk);
> +	if (ret)
> +		goto err_main_clk;
> +	ret = clk_prepare_enable(inst->clk);
> +	if (ret)
> +		goto err_instance_clk;
> +	inst->rate = clk_get_rate(inst->clk);
> +	if (inst->cfg->rate_to_clk) {
> +		ret = inst->cfg->rate_to_clk(inst->rate, &inst->clk_reg_val);
> +		if (ret)
> +			goto err_get_rate;
> +	}
> +	if (inst->cfg->power_on) {
> +		spin_lock(&drv->lock);
> +		ret = inst->cfg->power_on(inst);
> +		spin_unlock(&drv->lock);
> +	}
> +
> +	return 0;
> +
> +err_get_rate:
> +	clk_disable_unprepare(inst->clk);
> +err_instance_clk:
> +	clk_disable_unprepare(drv->clk);
> +err_main_clk:
> +	return ret;
> +}
> +
> +static int samsung_usb2_phy_power_off(struct phy *phy)
> +{
> +	struct samsung_usb2_phy_instance *inst = phy_get_drvdata(phy);
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +	int ret = 0;
> +
> +	dev_dbg(drv->dev, "Request to power_off \"%s\" usb phy\n",
> +							inst->cfg->label);
> +	if (inst->cfg->power_off) {
> +		spin_lock(&drv->lock);
> +		ret = inst->cfg->power_off(inst);
> +		spin_unlock(&drv->lock);
> +	}
> +	clk_disable_unprepare(inst->clk);
> +	clk_disable_unprepare(drv->clk);
> +	return ret;
> +}
> +
> +static struct phy_ops samsung_usb2_phy_ops = {
> +	.power_on	= samsung_usb2_phy_power_on,
> +	.power_off	= samsung_usb2_phy_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static struct phy *samsung_usb2_phy_xlate(struct device *dev,
> +					struct of_phandle_args *args)
> +{
> +	struct samsung_usb2_phy_driver *drv;
> +
> +	drv = dev_get_drvdata(dev);
> +	if (!drv)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (WARN_ON(args->args[0] >= drv->cfg->num_phys))
> +		return ERR_PTR(-ENODEV);
> +
> +	return drv->instances[args->args[0]].phy;
> +}
> +
> +static const struct of_device_id samsung_usb2_phy_of_match[] = {
> +#ifdef CONFIG_PHY_EXYNOS4210_USB2
> +	{
> +		.compatible = "samsung,exynos4210-usb2-phy",
> +		.data = &exynos4210_usb2_phy_config,
> +	},
> +#endif
> +#ifdef CONFIG_PHY_EXYNOS4212_USB2
> +	{
> +		.compatible = "samsung,exynos4212-usb2-phy",
> +		.data = &exynos4212_usb2_phy_config,
> +	},
> +#endif
> +	{ },
> +};

I think we've had enough discussion about this approach. Let's get the opinion
of others too. Felipe? Greg?

Summary:
We have two drivers PHY_EXYNOS4210_USB2 and PHY_EXYNOS4212_USB2 with almost
similar register map [1] and a samsung helper driver for these two drivers.
These two PHY drivers populate the function pointers in the helper driver. So
any phy_ops will first invoke the helper driver which will then invoke the
corresponding phy driver.

[1] -> http://www.diffchecker.com/7yno1uvk

Advantages:
* (more) clean and readable
* helper driver can be used with other PHY drivers which will be added soon

Disadvantages:
* code duplication

Maybe having a helper driver makes sense when we have other samsung PHY drivers
added but not sure if it's needed here for EXYNOS4210_USB2 and EXYNOS4212_USB2

Need your inputs on what you think about this.
> +
> +static int samsung_usb2_phy_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +	const struct samsung_usb2_phy_config *cfg;
> +	struct clk *clk;
> +	struct device *dev = &pdev->dev;
> +	struct phy_provider *phy_provider;
> +	struct resource *mem;
> +	struct samsung_usb2_phy_driver *drv;
> +	int i;
> +
> +	if (!pdev->dev.of_node) {
> +		dev_err(dev, "This driver is required to be instantiated from device tree\n");
> +		return -EINVAL;
> +	}
> +
> +	match = of_match_node(samsung_usb2_phy_of_match, pdev->dev.of_node);
> +	if (!match) {
> +		dev_err(dev, "of_match_node() failed\n");
> +		return -EINVAL;
> +	}
> +	cfg = match->data;
> +
> +	drv = devm_kzalloc(dev, sizeof(struct samsung_usb2_phy_driver) +
> +		cfg->num_phys * sizeof(struct samsung_usb2_phy_instance), GFP_KERNEL);
> +	if (!drv)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(dev, drv);
> +	spin_lock_init(&drv->lock);
> +
> +	drv->cfg = cfg;
> +	drv->dev = dev;
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	drv->reg_phy = devm_ioremap_resource(dev, mem);
> +	if (IS_ERR(drv->reg_phy)) {
> +		dev_err(dev, "Failed to map register memory (phy)\n");
> +		return PTR_ERR(drv->reg_phy);
> +	}
> +
> +	drv->reg_pmu = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
> +		"samsung,pmureg-phandle");
> +	if (IS_ERR(drv->reg_pmu)) {
> +		dev_err(dev, "Failed to map PMU registers (via syscon)\n");
> +		return PTR_ERR(drv->reg_pmu);
> +	}
> +
> +	if (drv->cfg->has_mode_switch) {
> +		drv->reg_sys = syscon_regmap_lookup_by_phandle(
> +				pdev->dev.of_node, "samsung,sysreg-phandle");
> +		if (IS_ERR(drv->reg_sys)) {
> +			dev_err(dev, "Failed to map system registers (via syscon)\n");
> +			return PTR_ERR(drv->reg_sys);
> +		}
> +	}
> +
> +	drv->clk = devm_clk_get(dev, "phy");
> +	if (IS_ERR(drv->clk)) {
> +		dev_err(dev, "Failed to get clock of phy controller\n");
> +		return PTR_ERR(drv->clk);
> +	}
> +
> +	for (i = 0; i < drv->cfg->num_phys; i++) {
> +		char *label = drv->cfg->phys[i].label;
> +		struct samsung_usb2_phy_instance *p = &drv->instances[i];
> +
> +		dev_dbg(dev, "Creating phy \"%s\"\n", label);
> +		p->phy = devm_phy_create(dev, &samsung_usb2_phy_ops, NULL);
> +		if (IS_ERR(p->phy)) {
> +			dev_err(drv->dev, "Failed to create usb2_phy \"%s\"\n",
> +						label);
> +			return PTR_ERR(p->phy);
> +		}
> +
> +		p->cfg = &drv->cfg->phys[i];
> +		p->drv = drv;
> +		phy_set_drvdata(p->phy, p);
> +
> +		clk = devm_clk_get(dev, p->cfg->label);
> +		if (IS_ERR(clk)) {
> +			dev_err(dev, "Failed to get clock of \"%s\" phy\n",
> +								p->cfg->label);
> +			return PTR_ERR(clk);
> +		}
> +		p->clk = clk;
> +	}
> +
> +	phy_provider = devm_of_phy_provider_register(dev,
> +							samsung_usb2_phy_xlate);
> +	if (IS_ERR(phy_provider)) {
> +		dev_err(drv->dev, "Failed to register phy provider\n");
> +		return PTR_ERR(phy_provider);
> +	}
> +
> +	return 0;
> +}
> +
> +static struct platform_driver samsung_usb2_phy_driver = {
> +	.probe	= samsung_usb2_phy_probe,
> +	.driver = {
> +		.of_match_table	= samsung_usb2_phy_of_match,
> +		.name		= "samsung-usb2-phy",
> +		.owner		= THIS_MODULE,
> +	}
> +};
> +
> +module_platform_driver(samsung_usb2_phy_driver);
> +MODULE_DESCRIPTION("Samsung S5P/EXYNOS SoC USB PHY driver");
> +MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:samsung-usb2-phy");
> +
> diff --git a/drivers/phy/phy-samsung-usb2.h b/drivers/phy/phy-samsung-usb2.h
> new file mode 100644
> index 0000000..cd12477
> --- /dev/null
> +++ b/drivers/phy/phy-samsung-usb2.h
> @@ -0,0 +1,72 @@
> +/*
> + * Samsung SoC USB 1.1/2.0 PHY driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Author: Kamil Debski <k.debski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef _PHY_EXYNOS_USB2_H
> +#define _PHY_EXYNOS_USB2_H
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +
> +#define KHZ 1000
> +#define MHZ (KHZ * KHZ)
> +
> +struct samsung_usb2_phy_driver;
> +struct samsung_usb2_phy_instance;
> +struct samsung_usb2_phy_config;
> +
> +struct samsung_usb2_phy_instance {
> +	struct samsung_usb2_phy_driver *drv;
> +	struct phy *phy;
> +	const struct samsung_usb2_common_phy *cfg;
> +	char enabled;
> +	struct clk *clk;
> +	u32 clk_reg_val;
> +	unsigned long rate;
> +};
> +
> +struct samsung_usb2_phy_driver {
> +	struct device *dev;
> +	spinlock_t lock;
> +	void __iomem *reg_phy;
> +	struct regmap *reg_sys;
> +	struct regmap *reg_pmu;
> +	const struct samsung_usb2_phy_config *cfg;
> +	struct clk *clk;
> +	struct samsung_usb2_phy_instance instances[0];
> +};
> +
> +struct samsung_usb2_common_phy {
> +	char *label;
> +	unsigned int id;
> +	int (*rate_to_clk)(unsigned long, u32 *);
> +	int (*power_on)(struct samsung_usb2_phy_instance *);
> +	int (*power_off)(struct samsung_usb2_phy_instance *);
> +};
> +
> +
> +struct samsung_usb2_phy_config {
> +	int num_phys;
> +	const struct samsung_usb2_common_phy *phys;
> +	char has_mode_switch;

u8 instead?

Thanks
Kishon
