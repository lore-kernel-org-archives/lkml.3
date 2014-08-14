Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaHNOYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:24:31 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37174 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbaHNOY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:24:28 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, balbi@ti.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, jg1.han@samsung.com, s.nawrocki@samsung.com,
        k.debski@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH RFC 3/7] usb-phy: samsung-usb2: Remove support for Exynos4X12
Date: Thu, 14 Aug 2014 19:53:56 +0530
Message-Id: <1408026240-28365-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
References: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have moved to new PHY driver for Exynos4X12's USB 2.0
controller, which is based on generic phy framework; so removing
this entire code for Exyno4X12.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/phy-samsung-usb.c  |   42 ------------------------------------
 drivers/usb/phy/phy-samsung-usb.h  |   25 ---------------------
 drivers/usb/phy/phy-samsung-usb2.c |   27 -----------------------
 3 files changed, 94 deletions(-)

diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-samsung-usb.c
index a07671d..0e40db1 100644
--- a/drivers/usb/phy/phy-samsung-usb.c
+++ b/drivers/usb/phy/phy-samsung-usb.c
@@ -100,11 +100,6 @@ void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy, bool on)
 		reg_val |= en_mask;
 
 	writel(reg_val, reg);
-
-	if (sphy->drv_data->cpu_type == TYPE_EXYNOS4X12) {
-		writel(reg_val, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL0);
-		writel(reg_val, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL1);
-	}
 }
 EXPORT_SYMBOL_GPL(samsung_usbphy_set_isolation_4210);
 
@@ -172,43 +167,6 @@ int samsung_usbphy_rate_to_clksel_64xx(struct samsung_usbphy *sphy,
 }
 EXPORT_SYMBOL_GPL(samsung_usbphy_rate_to_clksel_64xx);
 
-int samsung_usbphy_rate_to_clksel_4x12(struct samsung_usbphy *sphy,
-							unsigned long rate)
-{
-	unsigned int clksel;
-
-	switch (rate) {
-	case 9600 * KHZ:
-		clksel = FSEL_CLKSEL_9600K;
-		break;
-	case 10 * MHZ:
-		clksel = FSEL_CLKSEL_10M;
-		break;
-	case 12 * MHZ:
-		clksel = FSEL_CLKSEL_12M;
-		break;
-	case 19200 * KHZ:
-		clksel = FSEL_CLKSEL_19200K;
-		break;
-	case 20 * MHZ:
-		clksel = FSEL_CLKSEL_20M;
-		break;
-	case 24 * MHZ:
-		clksel = FSEL_CLKSEL_24M;
-		break;
-	case 50 * MHZ:
-		clksel = FSEL_CLKSEL_50M;
-		break;
-	default:
-		dev_err(sphy->dev,
-			"Invalid reference clock frequency: %lu\n", rate);
-		return -EINVAL;
-	}
-
-	return clksel;
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_rate_to_clksel_4x12);
-
 /*
  * Returns reference clock frequency selection value
  */
diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
index 7083cb6..9d03e3b 100644
--- a/drivers/usb/phy/phy-samsung-usb.h
+++ b/drivers/usb/phy/phy-samsung-usb.h
@@ -47,32 +47,10 @@
 #define RSTCON_HLINK_SWRST			(0x1 << 1)
 #define RSTCON_SWRST				(0x1 << 0)
 
-/* EXYNOS4X12 */
-#define EXYNOS4X12_PHY_HSIC_CTRL0		(0x04)
-#define EXYNOS4X12_PHY_HSIC_CTRL1		(0x08)
-
-#define PHYPWR_NORMAL_MASK_HSIC1		(0x7 << 12)
-#define PHYPWR_NORMAL_MASK_HSIC0		(0x7 << 9)
-#define PHYPWR_NORMAL_MASK_PHY1			(0x7 << 6)
-
-#define RSTCON_HOSTPHY_SWRST			(0xf << 3)
-
-#define FSEL_CLKSEL_50M				(0x7)
-#define FSEL_CLKSEL_24M				(0x5)
-#define FSEL_CLKSEL_20M				(0x4)
-#define FSEL_CLKSEL_19200K			(0x3)
-#define FSEL_CLKSEL_12M				(0x2)
-#define FSEL_CLKSEL_10M				(0x1)
-#define FSEL_CLKSEL_9600K			(0x0)
-
 #ifndef MHZ
 #define MHZ (1000*1000)
 #endif
 
-#ifndef KHZ
-#define KHZ (1000)
-#endif
-
 #define S3C64XX_USBPHY_ENABLE			(0x1 << 16)
 #define EXYNOS_USBPHY_ENABLE			(0x1 << 0)
 #define EXYNOS_USB20PHY_CFG_HOST_LINK		(0x1 << 0)
@@ -80,7 +58,6 @@
 enum samsung_cpu_type {
 	TYPE_S3C64XX,
 	TYPE_EXYNOS4210,
-	TYPE_EXYNOS4X12,
 };
 
 struct samsung_usbphy;
@@ -173,5 +150,3 @@ extern int samsung_usbphy_set_type(struct usb_phy *phy,
 extern int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy);
 extern int samsung_usbphy_rate_to_clksel_64xx(struct samsung_usbphy *sphy,
 							unsigned long rate);
-extern int samsung_usbphy_rate_to_clksel_4x12(struct samsung_usbphy *sphy,
-							unsigned long rate);
diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index 9bfa436..6b5ce21 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -61,11 +61,6 @@ static void samsung_usb2phy_enable(struct samsung_usbphy *sphy)
 		phypwr &= ~PHYPWR_NORMAL_MASK;
 		rstcon |= RSTCON_SWRST;
 		break;
-	case TYPE_EXYNOS4X12:
-		phypwr &= ~(PHYPWR_NORMAL_MASK_HSIC0 |
-				PHYPWR_NORMAL_MASK_HSIC1 |
-				PHYPWR_NORMAL_MASK_PHY1);
-		rstcon |= RSTCON_HOSTPHY_SWRST;
 	case TYPE_EXYNOS4210:
 		phypwr &= ~PHYPWR_NORMAL_MASK_PHY0;
 		rstcon |= RSTCON_SWRST;
@@ -79,8 +74,6 @@ static void samsung_usb2phy_enable(struct samsung_usbphy *sphy)
 	/* reset all ports of PHY and Link */
 	writel(rstcon, regs + SAMSUNG_RSTCON);
 	udelay(10);
-	if (sphy->drv_data->cpu_type == TYPE_EXYNOS4X12)
-		rstcon &= ~RSTCON_HOSTPHY_SWRST;
 	rstcon &= ~RSTCON_SWRST;
 	writel(rstcon, regs + SAMSUNG_RSTCON);
 }
@@ -96,10 +89,6 @@ static void samsung_usb2phy_disable(struct samsung_usbphy *sphy)
 	case TYPE_S3C64XX:
 		phypwr |= PHYPWR_NORMAL_MASK;
 		break;
-	case TYPE_EXYNOS4X12:
-		phypwr |= (PHYPWR_NORMAL_MASK_HSIC0 |
-				PHYPWR_NORMAL_MASK_HSIC1 |
-				PHYPWR_NORMAL_MASK_PHY1);
 	case TYPE_EXYNOS4210:
 		phypwr |= PHYPWR_NORMAL_MASK_PHY0;
 	default:
@@ -310,16 +299,6 @@ static const struct samsung_usbphy_drvdata usb2phy_exynos4 = {
 	.phy_disable		= samsung_usb2phy_disable,
 };
 
-static const struct samsung_usbphy_drvdata usb2phy_exynos4x12 = {
-	.cpu_type		= TYPE_EXYNOS4X12,
-	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
-	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
-	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_4x12,
-	.set_isolation		= samsung_usbphy_set_isolation_4210,
-	.phy_enable		= samsung_usb2phy_enable,
-	.phy_disable		= samsung_usb2phy_disable,
-};
-
 #ifdef CONFIG_OF
 static const struct of_device_id samsung_usbphy_dt_match[] = {
 	{
@@ -328,9 +307,6 @@ static const struct of_device_id samsung_usbphy_dt_match[] = {
 	}, {
 		.compatible = "samsung,exynos4210-usb2phy",
 		.data = &usb2phy_exynos4,
-	}, {
-		.compatible = "samsung,exynos4x12-usb2phy",
-		.data = &usb2phy_exynos4x12,
 	},
 	{},
 };
@@ -344,9 +320,6 @@ static struct platform_device_id samsung_usbphy_driver_ids[] = {
 	}, {
 		.name		= "exynos4210-usb2phy",
 		.driver_data	= (unsigned long)&usb2phy_exynos4,
-	}, {
-		.name		= "exynos4x12-usb2phy",
-		.driver_data	= (unsigned long)&usb2phy_exynos4x12,
 	},
 	{},
 };
-- 
1.7.10.4

