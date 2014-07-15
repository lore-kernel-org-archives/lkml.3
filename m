Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbaGOQ4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:56:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53387 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaGOQ4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:56:38 -0400
X-AuditID: cbfee61b-f79f86d00000144c-dc-53c55d43ff6d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-ide@vger.kernel.org,
        Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH v4 1/2] phy: qcom: Add driver for QCOM APQ8064 SATA PHY
Date: Tue, 15 Jul 2014 18:56:21 +0200
Message-id: <12555066.QsMd3v2SOo@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1405336679-32179-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1405336651-32135-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1405336679-32179-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jQV3n2KPBBpt/y1gc+LOD0eLC0x42
	i4n7z7JbHNvxiMni8q45bBate4+wW7QdO8ZqcXr9ajYHDo/Lfb1MHptWdbJ53Lm2h83j+I3t
	TB6fN8kFsEZx2aSk5mSWpRbp2yVwZUw5vZK14LdOxaTF0g2MX1S6GDk4JARMJGasEepi5AQy
	xSQu3FvP1sXIxSEkMJ1RYvnZ9SwQTguTRMeSWUwgVWwCVhIT21cxgtgiAhYS/ybMZQYpYhb4
	zyjRfvI/M0hCWMBbYseOW2A2i4CqROOvOawgNq+AlsTy+w1gtqiAp8SO7SvZQGxOAX+Jl7ub
	WCG2TWaU+LvqL1SDoMSPyfdYQGxmAXmJffunskLYOhL7W6exTWAUmIWkbBaSsllIyhYwMq9i
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA74Z9I7GFc1WBxiFOBgVOLh3RByNFiINbGsuDL3
	EKMEB7OSCK+kCVCINyWxsiq1KD++qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMH
	p1QDo3p5p5r0/9Sq7ZPaQi8l+8rUOh6zsua9VsI7J/C2fN2Lp0kr5wq/NtzXeVCp/YjqvIoD
	tYs5Vi6ItGdfmtqfc/mlU+OKIMXNZ96VTHzgJ9KY9voNl3raxr0VjV8EZhefibgmnPr6t5Wd
	fv3yHNfZt6zNRNY9OiRb5GbClbp2an/a55OHd7R2KrEUZyQaajEXFScCAET1OpZ0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, July 14, 2014 12:17:59 PM Srinivas Kandagatla wrote:
> Add a PHY driver for uses with AHCI based SATA controller driver on the
> APQ8064 family of SoCs.
> 
> This patch is a forward port from Qualcomm's v3.4 andriod kernel.
> 
> Tested on IFC6410 board.
> 
> CC: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Tested-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>  drivers/phy/Kconfig                 |   7 +
>  drivers/phy/Makefile                |   1 +
>  drivers/phy/phy-qcom-apq8064-sata.c | 288 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 296 insertions(+)
>  create mode 100644 drivers/phy/phy-qcom-apq8064-sata.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 5fceb33..e22b1d1 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -188,4 +188,11 @@ config PHY_XGENE
>  	help
>  	  This option enables support for APM X-Gene SoC multi-purpose PHY.
>  
> +config PHY_QCOM_APQ8064_SATA
> +	tristate "Qualcomm APQ8064 SATA SerDes/PHY driver"
> +	depends on ARCH_QCOM
> +	depends on HAS_IOMEM
> +	depends on OF
> +	select GENERIC_PHY
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 54f04d0..a4819d3 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -21,3 +21,4 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
>  phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
>  obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
> +obj-$(CONFIG_PHY_QCOM_APQ8064_SATA)	+= phy-qcom-apq8064-sata.o
> diff --git a/drivers/phy/phy-qcom-apq8064-sata.c b/drivers/phy/phy-qcom-apq8064-sata.c
> new file mode 100644
> index 0000000..c9b4dd6
> --- /dev/null
> +++ b/drivers/phy/phy-qcom-apq8064-sata.c
> @@ -0,0 +1,288 @@
> +/*
> + * Copyright (c) 2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/time.h>
> +#include <linux/delay.h>
> +#include <linux/clk.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/phy/phy.h>
> +
> +/* PHY registers */
> +#define UNIPHY_PLL_REFCLK_CFG		0x000
> +#define UNIPHY_PLL_PWRGEN_CFG		0x014
> +#define UNIPHY_PLL_GLB_CFG		0x020
> +#define UNIPHY_PLL_SDM_CFG0		0x038
> +#define UNIPHY_PLL_SDM_CFG1		0x03C
> +#define UNIPHY_PLL_SDM_CFG2		0x040
> +#define UNIPHY_PLL_SDM_CFG3		0x044
> +#define UNIPHY_PLL_SDM_CFG4		0x048
> +#define UNIPHY_PLL_SSC_CFG0		0x04C
> +#define UNIPHY_PLL_SSC_CFG1		0x050
> +#define UNIPHY_PLL_SSC_CFG2		0x054
> +#define UNIPHY_PLL_SSC_CFG3		0x058
> +#define UNIPHY_PLL_LKDET_CFG0		0x05C
> +#define UNIPHY_PLL_LKDET_CFG1		0x060
> +#define UNIPHY_PLL_LKDET_CFG2		0x064
> +#define UNIPHY_PLL_CAL_CFG0		0x06C
> +#define UNIPHY_PLL_CAL_CFG8		0x08C
> +#define UNIPHY_PLL_CAL_CFG9		0x090
> +#define UNIPHY_PLL_CAL_CFG10		0x094
> +#define UNIPHY_PLL_CAL_CFG11		0x098
> +#define UNIPHY_PLL_STATUS		0x0C0
> +
> +#define SATA_PHY_SER_CTRL		0x100
> +#define SATA_PHY_TX_DRIV_CTRL0		0x104
> +#define SATA_PHY_TX_DRIV_CTRL1		0x108
> +#define SATA_PHY_TX_IMCAL0		0x11C
> +#define SATA_PHY_TX_IMCAL2		0x124
> +#define SATA_PHY_RX_IMCAL0		0x128
> +#define SATA_PHY_EQUAL			0x13C
> +#define SATA_PHY_OOB_TERM		0x144
> +#define SATA_PHY_CDR_CTRL0		0x148
> +#define SATA_PHY_CDR_CTRL1		0x14C
> +#define SATA_PHY_CDR_CTRL2		0x150
> +#define SATA_PHY_CDR_CTRL3		0x154
> +#define SATA_PHY_PI_CTRL0		0x168
> +#define SATA_PHY_POW_DWN_CTRL0		0x180
> +#define SATA_PHY_POW_DWN_CTRL1		0x184
> +#define SATA_PHY_TX_DATA_CTRL		0x188
> +#define SATA_PHY_ALIGNP			0x1A4
> +#define SATA_PHY_TX_IMCAL_STAT		0x1E4
> +#define SATA_PHY_RX_IMCAL_STAT		0x1E8
> +
> +#define UNIPHY_PLL_LOCK		BIT(0)
> +#define SATA_PHY_TX_CAL		BIT(0)
> +#define SATA_PHY_RX_CAL		BIT(0)
> +
> +/* default timeout set to 1 sec */
> +#define TIMEOUT_MS		10000
> +#define DELAY_INTERVAL_US	100
> +
> +struct qcom_apq8064_sata_phy {
> +	void __iomem *mmio;
> +	struct clk *cfg_clk;
> +	struct device *dev;
> +};
> +
> +/* Helper function to do poll and timeout */
> +static int read_poll_timeout(void __iomem *addr, u32 mask)
> +{
> +	unsigned long timeout = jiffies + msecs_to_jiffies(TIMEOUT_MS);
> +
> +	do {
> +		if (readl_relaxed(addr) & mask)
> +			return 0;
> +
> +		 usleep_range(DELAY_INTERVAL_US, DELAY_INTERVAL_US + 50);
> +	} while (!time_after(jiffies, timeout));
> +
> +	return -ETIMEDOUT;
> +}

Thanks for reworking this code, unfortunately it still has a one
(unlikely but still theoretically possible) problem.  If there is
i.e. a big IRQ load between first usleep_range() call and first
time_after() check the function will timeout without checking
the register.  To fix it you needs to add an additonal register
checking before returning -ETIMEDOUT value or replace time_after()
condition with a fixed number of retries (100000 to cover 1sec
timeout).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

