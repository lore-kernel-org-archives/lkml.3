Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab3HBAxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 20:53:41 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:54605 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3HBAxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 20:53:06 -0400
From: Julius Werner <jwerner@chromium.org>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, devicetree@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH 2/3] usb: phy-samsung-usb: trivial: rename pmuregs variable
Date: Thu,  1 Aug 2013 17:52:05 -0700
Message-Id: <1375404726-26264-3-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1375404726-26264-1-git-send-email-jwerner@chromium.org>
References: <1375404726-26264-1-git-send-email-jwerner@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the sphy->pmuregs variable always points to only a single
register, let's rename it to make that more clear.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/phy/phy-samsung-usb.c  | 14 +++++++-------
 drivers/usb/phy/phy-samsung-usb.h  |  4 ++--
 drivers/usb/phy/phy-samsung-usb2.c |  4 ++--
 drivers/usb/phy/phy-samsung-usb3.c |  4 ++--
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-samsung-usb.c
index 51cad19..fa382c9 100644
--- a/drivers/usb/phy/phy-samsung-usb.c
+++ b/drivers/usb/phy/phy-samsung-usb.c
@@ -42,9 +42,9 @@ int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
 		return -ENODEV;
 	}
 
-	sphy->pmuregs = of_iomap(usbphy_sys, 0);
+	sphy->pmureg = of_iomap(usbphy_sys, 0);
 
-	if (sphy->pmuregs == NULL) {
+	if (sphy->pmureg == NULL) {
 		dev_err(sphy->dev, "Can't get usb-phy pmu control register\n");
 		goto err0;
 	}
@@ -77,23 +77,23 @@ void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy, bool on)
 {
 	u32 reg_val;
 
-	if (!sphy->pmuregs) {
+	if (!sphy->pmureg) {
 		dev_warn(sphy->dev, "Can't set pmu isolation\n");
 		return;
 	}
 
-	reg_val = readl(sphy->pmuregs);
+	reg_val = readl(sphy->pmureg);
 
 	if (on)
 		reg_val &= ~sphy->drv_data->phy_en_mask;
 	else
 		reg_val |= sphy->drv_data->phy_en_mask;
 
-	writel(reg_val, sphy->pmuregs);
+	writel(reg_val, sphy->pmureg);
 
 	if (sphy->drv_data->cpu_type == TYPE_EXYNOS4X12) {
-		writel(reg_val, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL0);
-		writel(reg_val, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL1);
+		writel(reg_val, sphy->pmureg + EXYNOS4X12_PHY_HSIC_CTRL0);
+		writel(reg_val, sphy->pmureg + EXYNOS4X12_PHY_HSIC_CTRL1);
 	}
 }
 EXPORT_SYMBOL_GPL(samsung_usbphy_set_isolation_4210);
diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
index a817af5..f2e9c4a 100644
--- a/drivers/usb/phy/phy-samsung-usb.h
+++ b/drivers/usb/phy/phy-samsung-usb.h
@@ -281,7 +281,7 @@ struct samsung_usbphy_drvdata {
  * @dev: The parent device supplied to the probe function
  * @clk: usb phy clock
  * @regs: usb phy controller registers memory base
- * @pmuregs: USB device PHY_CONTROL register memory base
+ * @pmureg: USB device PHY_CONTROL register address
  * @sysreg: USB2.0 PHY_CFG register memory base
  * @ref_clk_freq: reference clock frequency selection
  * @drv_data: driver data available for different SoCs
@@ -296,7 +296,7 @@ struct samsung_usbphy {
 	struct device	*dev;
 	struct clk	*clk;
 	void __iomem	*regs;
-	void __iomem	*pmuregs;
+	void __iomem	*pmureg;
 	void __iomem	*sysreg;
 	int		ref_clk_freq;
 	const struct samsung_usbphy_drvdata *drv_data;
diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index adbaa8c..c2c83d4 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -435,8 +435,8 @@ static int samsung_usb2phy_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&sphy->phy);
 
-	if (sphy->pmuregs)
-		iounmap(sphy->pmuregs);
+	if (sphy->pmureg)
+		iounmap(sphy->pmureg);
 	if (sphy->sysreg)
 		iounmap(sphy->sysreg);
 
diff --git a/drivers/usb/phy/phy-samsung-usb3.c b/drivers/usb/phy/phy-samsung-usb3.c
index 3ad9579..6259a35 100644
--- a/drivers/usb/phy/phy-samsung-usb3.c
+++ b/drivers/usb/phy/phy-samsung-usb3.c
@@ -292,8 +292,8 @@ static int samsung_usb3phy_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&sphy->phy);
 
-	if (sphy->pmuregs)
-		iounmap(sphy->pmuregs);
+	if (sphy->pmureg)
+		iounmap(sphy->pmureg);
 	if (sphy->sysreg)
 		iounmap(sphy->sysreg);
 
-- 
1.7.12.4

