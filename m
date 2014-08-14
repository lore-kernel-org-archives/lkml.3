Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaHNOY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:24:27 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41626 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbaHNOYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:24:24 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, balbi@ti.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, jg1.han@samsung.com, s.nawrocki@samsung.com,
        k.debski@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH RFC 2/7] usb-phy: samsung-usb2: Remove support for Exynos5250
Date: Thu, 14 Aug 2014 19:53:55 +0530
Message-Id: <1408026240-28365-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
References: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have moved to new PHY driver for Exynos5250's USB 2.0
controller, which is based on generic phy framework; we no longer
need to keep support of the same in older usb-phy based driver.
So removing this entire code for Exyno5250.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/phy-samsung-usb.c  |    9 +-
 drivers/usb/phy/phy-samsung-usb.h  |   92 -------------------
 drivers/usb/phy/phy-samsung-usb2.c |  171 +-----------------------------------
 3 files changed, 2 insertions(+), 270 deletions(-)

diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-samsung-usb.c
index ac025ca..a07671d 100644
--- a/drivers/usb/phy/phy-samsung-usb.c
+++ b/drivers/usb/phy/phy-samsung-usb.c
@@ -218,14 +218,7 @@ int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
 	unsigned long rate;
 	int refclk_freq;
 
-	/*
-	 * In exynos5250 USB host and device PHY use
-	 * external crystal clock XXTI
-	 */
-	if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
-		ref_clk = clk_get(sphy->dev, "ext_xtal");
-	else
-		ref_clk = clk_get(sphy->dev, "xusbxti");
+	ref_clk = clk_get(sphy->dev, "xusbxti");
 	if (IS_ERR(ref_clk)) {
 		dev_err(sphy->dev, "Failed to get reference clock\n");
 		return PTR_ERR(ref_clk);
diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
index dd2a0b5..7083cb6 100644
--- a/drivers/usb/phy/phy-samsung-usb.h
+++ b/drivers/usb/phy/phy-samsung-usb.h
@@ -57,19 +57,6 @@
 
 #define RSTCON_HOSTPHY_SWRST			(0xf << 3)
 
-/* EXYNOS5 */
-#define EXYNOS5_PHY_HOST_CTRL0			(0x00)
-
-#define HOST_CTRL0_PHYSWRSTALL			(0x1 << 31)
-
-#define HOST_CTRL0_REFCLKSEL_MASK		(0x3 << 19)
-#define HOST_CTRL0_REFCLKSEL_XTAL		(0x0 << 19)
-#define HOST_CTRL0_REFCLKSEL_EXTL		(0x1 << 19)
-#define HOST_CTRL0_REFCLKSEL_CLKCORE		(0x2 << 19)
-
-#define HOST_CTRL0_FSEL_MASK			(0x7 << 16)
-#define HOST_CTRL0_FSEL(_x)			((_x) << 16)
-
 #define FSEL_CLKSEL_50M				(0x7)
 #define FSEL_CLKSEL_24M				(0x5)
 #define FSEL_CLKSEL_20M				(0x4)
@@ -78,83 +65,6 @@
 #define FSEL_CLKSEL_10M				(0x1)
 #define FSEL_CLKSEL_9600K			(0x0)
 
-#define HOST_CTRL0_TESTBURNIN			(0x1 << 11)
-#define HOST_CTRL0_RETENABLE			(0x1 << 10)
-#define HOST_CTRL0_COMMONON_N			(0x1 << 9)
-#define HOST_CTRL0_SIDDQ			(0x1 << 6)
-#define HOST_CTRL0_FORCESLEEP			(0x1 << 5)
-#define HOST_CTRL0_FORCESUSPEND			(0x1 << 4)
-#define HOST_CTRL0_WORDINTERFACE		(0x1 << 3)
-#define HOST_CTRL0_UTMISWRST			(0x1 << 2)
-#define HOST_CTRL0_LINKSWRST			(0x1 << 1)
-#define HOST_CTRL0_PHYSWRST			(0x1 << 0)
-
-#define EXYNOS5_PHY_HOST_TUNE0			(0x04)
-
-#define EXYNOS5_PHY_HSIC_CTRL1			(0x10)
-
-#define EXYNOS5_PHY_HSIC_TUNE1			(0x14)
-
-#define EXYNOS5_PHY_HSIC_CTRL2			(0x20)
-
-#define EXYNOS5_PHY_HSIC_TUNE2			(0x24)
-
-#define HSIC_CTRL_REFCLKSEL_MASK		(0x3 << 23)
-#define HSIC_CTRL_REFCLKSEL			(0x2 << 23)
-
-#define HSIC_CTRL_REFCLKDIV_MASK		(0x7f << 16)
-#define HSIC_CTRL_REFCLKDIV(_x)			((_x) << 16)
-#define HSIC_CTRL_REFCLKDIV_12			(0x24 << 16)
-#define HSIC_CTRL_REFCLKDIV_15			(0x1c << 16)
-#define HSIC_CTRL_REFCLKDIV_16			(0x1a << 16)
-#define HSIC_CTRL_REFCLKDIV_19_2		(0x15 << 16)
-#define HSIC_CTRL_REFCLKDIV_20			(0x14 << 16)
-
-#define HSIC_CTRL_SIDDQ				(0x1 << 6)
-#define HSIC_CTRL_FORCESLEEP			(0x1 << 5)
-#define HSIC_CTRL_FORCESUSPEND			(0x1 << 4)
-#define HSIC_CTRL_WORDINTERFACE			(0x1 << 3)
-#define HSIC_CTRL_UTMISWRST			(0x1 << 2)
-#define HSIC_CTRL_PHYSWRST			(0x1 << 0)
-
-#define EXYNOS5_PHY_HOST_EHCICTRL		(0x30)
-
-#define HOST_EHCICTRL_ENAINCRXALIGN		(0x1 << 29)
-#define HOST_EHCICTRL_ENAINCR4			(0x1 << 28)
-#define HOST_EHCICTRL_ENAINCR8			(0x1 << 27)
-#define HOST_EHCICTRL_ENAINCR16			(0x1 << 26)
-
-#define EXYNOS5_PHY_HOST_OHCICTRL		(0x34)
-
-#define HOST_OHCICTRL_SUSPLGCY			(0x1 << 3)
-#define HOST_OHCICTRL_APPSTARTCLK		(0x1 << 2)
-#define HOST_OHCICTRL_CNTSEL			(0x1 << 1)
-#define HOST_OHCICTRL_CLKCKTRST			(0x1 << 0)
-
-#define EXYNOS5_PHY_OTG_SYS			(0x38)
-
-#define OTG_SYS_PHYLINK_SWRESET			(0x1 << 14)
-#define OTG_SYS_LINKSWRST_UOTG			(0x1 << 13)
-#define OTG_SYS_PHY0_SWRST			(0x1 << 12)
-
-#define OTG_SYS_REFCLKSEL_MASK			(0x3 << 9)
-#define OTG_SYS_REFCLKSEL_XTAL			(0x0 << 9)
-#define OTG_SYS_REFCLKSEL_EXTL			(0x1 << 9)
-#define OTG_SYS_REFCLKSEL_CLKCORE		(0x2 << 9)
-
-#define OTG_SYS_IDPULLUP_UOTG			(0x1 << 8)
-#define OTG_SYS_COMMON_ON			(0x1 << 7)
-
-#define OTG_SYS_FSEL_MASK			(0x7 << 4)
-#define OTG_SYS_FSEL(_x)			((_x) << 4)
-
-#define OTG_SYS_FORCESLEEP			(0x1 << 3)
-#define OTG_SYS_OTGDISABLE			(0x1 << 2)
-#define OTG_SYS_SIDDQ_UOTG			(0x1 << 1)
-#define OTG_SYS_FORCESUSPEND			(0x1 << 0)
-
-#define EXYNOS5_PHY_OTG_TUNE			(0x40)
-
 #ifndef MHZ
 #define MHZ (1000*1000)
 #endif
@@ -163,7 +73,6 @@
 #define KHZ (1000)
 #endif
 
-#define EXYNOS_USBHOST_PHY_CTRL_OFFSET		(0x4)
 #define S3C64XX_USBPHY_ENABLE			(0x1 << 16)
 #define EXYNOS_USBPHY_ENABLE			(0x1 << 0)
 #define EXYNOS_USB20PHY_CFG_HOST_LINK		(0x1 << 0)
@@ -172,7 +81,6 @@ enum samsung_cpu_type {
 	TYPE_S3C64XX,
 	TYPE_EXYNOS4210,
 	TYPE_EXYNOS4X12,
-	TYPE_EXYNOS5250,
 };
 
 struct samsung_usbphy;
diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index b3ba866..9bfa436 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -43,121 +43,6 @@ static int samsung_usbphy_set_host(struct usb_otg *otg, struct usb_bus *host)
 	return 0;
 }
 
-static bool exynos5_phyhost_is_on(void __iomem *regs)
-{
-	u32 reg;
-
-	reg = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
-
-	return !(reg & HOST_CTRL0_SIDDQ);
-}
-
-static void samsung_exynos5_usb2phy_enable(struct samsung_usbphy *sphy)
-{
-	void __iomem *regs = sphy->regs;
-	u32 phyclk = sphy->ref_clk_freq;
-	u32 phyhost;
-	u32 phyotg;
-	u32 phyhsic;
-	u32 ehcictrl;
-	u32 ohcictrl;
-
-	/*
-	 * phy_usage helps in keeping usage count for phy
-	 * so that the first consumer enabling the phy is also
-	 * the last consumer to disable it.
-	 */
-
-	atomic_inc(&sphy->phy_usage);
-
-	if (exynos5_phyhost_is_on(regs)) {
-		dev_info(sphy->dev, "Already power on PHY\n");
-		return;
-	}
-
-	/* Host configuration */
-	phyhost = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
-
-	/* phy reference clock configuration */
-	phyhost &= ~HOST_CTRL0_FSEL_MASK;
-	phyhost |= HOST_CTRL0_FSEL(phyclk);
-
-	/* host phy reset */
-	phyhost &= ~(HOST_CTRL0_PHYSWRST |
-			HOST_CTRL0_PHYSWRSTALL |
-			HOST_CTRL0_SIDDQ |
-			/* Enable normal mode of operation */
-			HOST_CTRL0_FORCESUSPEND |
-			HOST_CTRL0_FORCESLEEP);
-
-	/* Link reset */
-	phyhost |= (HOST_CTRL0_LINKSWRST |
-			HOST_CTRL0_UTMISWRST |
-			/* COMMON Block configuration during suspend */
-			HOST_CTRL0_COMMONON_N);
-	writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
-	udelay(10);
-	phyhost &= ~(HOST_CTRL0_LINKSWRST |
-			HOST_CTRL0_UTMISWRST);
-	writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
-
-	/* OTG configuration */
-	phyotg = readl(regs + EXYNOS5_PHY_OTG_SYS);
-
-	/* phy reference clock configuration */
-	phyotg &= ~OTG_SYS_FSEL_MASK;
-	phyotg |= OTG_SYS_FSEL(phyclk);
-
-	/* Enable normal mode of operation */
-	phyotg &= ~(OTG_SYS_FORCESUSPEND |
-			OTG_SYS_SIDDQ_UOTG |
-			OTG_SYS_FORCESLEEP |
-			OTG_SYS_REFCLKSEL_MASK |
-			/* COMMON Block configuration during suspend */
-			OTG_SYS_COMMON_ON);
-
-	/* OTG phy & link reset */
-	phyotg |= (OTG_SYS_PHY0_SWRST |
-			OTG_SYS_LINKSWRST_UOTG |
-			OTG_SYS_PHYLINK_SWRESET |
-			OTG_SYS_OTGDISABLE |
-			/* Set phy refclk */
-			OTG_SYS_REFCLKSEL_CLKCORE);
-
-	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
-	udelay(10);
-	phyotg &= ~(OTG_SYS_PHY0_SWRST |
-			OTG_SYS_LINKSWRST_UOTG |
-			OTG_SYS_PHYLINK_SWRESET);
-	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
-
-	/* HSIC phy configuration */
-	phyhsic = (HSIC_CTRL_REFCLKDIV_12 |
-			HSIC_CTRL_REFCLKSEL |
-			HSIC_CTRL_PHYSWRST);
-	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
-	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
-	udelay(10);
-	phyhsic &= ~HSIC_CTRL_PHYSWRST;
-	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
-	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
-
-	udelay(80);
-
-	/* enable EHCI DMA burst */
-	ehcictrl = readl(regs + EXYNOS5_PHY_HOST_EHCICTRL);
-	ehcictrl |= (HOST_EHCICTRL_ENAINCRXALIGN |
-				HOST_EHCICTRL_ENAINCR4 |
-				HOST_EHCICTRL_ENAINCR8 |
-				HOST_EHCICTRL_ENAINCR16);
-	writel(ehcictrl, regs + EXYNOS5_PHY_HOST_EHCICTRL);
-
-	/* set ohci_suspend_on_n */
-	ohcictrl = readl(regs + EXYNOS5_PHY_HOST_OHCICTRL);
-	ohcictrl |= HOST_OHCICTRL_SUSPLGCY;
-	writel(ohcictrl, regs + EXYNOS5_PHY_HOST_OHCICTRL);
-}
-
 static void samsung_usb2phy_enable(struct samsung_usbphy *sphy)
 {
 	void __iomem *regs = sphy->regs;
@@ -200,41 +85,6 @@ static void samsung_usb2phy_enable(struct samsung_usbphy *sphy)
 	writel(rstcon, regs + SAMSUNG_RSTCON);
 }
 
-static void samsung_exynos5_usb2phy_disable(struct samsung_usbphy *sphy)
-{
-	void __iomem *regs = sphy->regs;
-	u32 phyhost;
-	u32 phyotg;
-	u32 phyhsic;
-
-	if (atomic_dec_return(&sphy->phy_usage) > 0) {
-		dev_info(sphy->dev, "still being used\n");
-		return;
-	}
-
-	phyhsic = (HSIC_CTRL_REFCLKDIV_12 |
-			HSIC_CTRL_REFCLKSEL |
-			HSIC_CTRL_SIDDQ |
-			HSIC_CTRL_FORCESLEEP |
-			HSIC_CTRL_FORCESUSPEND);
-	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
-	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
-
-	phyhost = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
-	phyhost |= (HOST_CTRL0_SIDDQ |
-			HOST_CTRL0_FORCESUSPEND |
-			HOST_CTRL0_FORCESLEEP |
-			HOST_CTRL0_PHYSWRST |
-			HOST_CTRL0_PHYSWRSTALL);
-	writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
-
-	phyotg = readl(regs + EXYNOS5_PHY_OTG_SYS);
-	phyotg |= (OTG_SYS_FORCESUSPEND |
-			OTG_SYS_SIDDQ_UOTG |
-			OTG_SYS_FORCESLEEP);
-	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
-}
-
 static void samsung_usb2phy_disable(struct samsung_usbphy *sphy)
 {
 	void __iomem *regs = sphy->regs;
@@ -382,10 +232,7 @@ static int samsung_usb2phy_probe(struct platform_device *pdev)
 
 	drv_data = samsung_usbphy_get_driver_data(pdev);
 
-	if (drv_data->cpu_type == TYPE_EXYNOS5250)
-		clk = devm_clk_get(dev, "usbhost");
-	else
-		clk = devm_clk_get(dev, "otg");
+	clk = devm_clk_get(dev, "otg");
 
 	if (IS_ERR(clk)) {
 		dev_err(dev, "Failed to get usbhost/otg clock\n");
@@ -473,16 +320,6 @@ static const struct samsung_usbphy_drvdata usb2phy_exynos4x12 = {
 	.phy_disable		= samsung_usb2phy_disable,
 };
 
-static struct samsung_usbphy_drvdata usb2phy_exynos5 = {
-	.cpu_type		= TYPE_EXYNOS5250,
-	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
-	.hostphy_reg_offset	= EXYNOS_USBHOST_PHY_CTRL_OFFSET,
-	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_4x12,
-	.set_isolation		= samsung_usbphy_set_isolation_4210,
-	.phy_enable		= samsung_exynos5_usb2phy_enable,
-	.phy_disable		= samsung_exynos5_usb2phy_disable,
-};
-
 #ifdef CONFIG_OF
 static const struct of_device_id samsung_usbphy_dt_match[] = {
 	{
@@ -494,9 +331,6 @@ static const struct of_device_id samsung_usbphy_dt_match[] = {
 	}, {
 		.compatible = "samsung,exynos4x12-usb2phy",
 		.data = &usb2phy_exynos4x12,
-	}, {
-		.compatible = "samsung,exynos5250-usb2phy",
-		.data = &usb2phy_exynos5
 	},
 	{},
 };
@@ -513,9 +347,6 @@ static struct platform_device_id samsung_usbphy_driver_ids[] = {
 	}, {
 		.name		= "exynos4x12-usb2phy",
 		.driver_data	= (unsigned long)&usb2phy_exynos4x12,
-	}, {
-		.name		= "exynos5250-usb2phy",
-		.driver_data	= (unsigned long)&usb2phy_exynos5,
 	},
 	{},
 };
-- 
1.7.10.4

