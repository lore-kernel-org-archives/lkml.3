Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab3BEMj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:39:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38187 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3BEMjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:39:52 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-c6-5110fd96eab7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gregkh@linuxfoundation.org,
        balbi@ti.com, kgene.kim@samsung.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, av.tikhomirov@samsung.com,
        dianders@chromium.org, p.paneri@samsung.com
Subject: [PATCH v5 1/2] usb: phy: samsung: Common out the generic stuff
Date: Tue, 05 Feb 2013 18:14:15 +0530
Message-id: <1360068256-19602-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1360068256-19602-1-git-send-email-gautam.vivek@samsung.com>
References: <1360068256-19602-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkWnfaX4FAg0tNxhaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZVxv62Iv+PGBqeLx3GamBsZT65i6GDk5JARM
	JJ5NvQ9li0lcuLeerYuRi0NIYCmjxLr3V5hhih7cmcsEkVjEKLF6ZTszhDOZSWL/jalsIFVs
	AroSTW93MYLYIgKyEoev/AYrYhZ4xCTxZd9zFpCEsIC7xOslE8CKWARUJS5enge2glfAQ6Jj
	0TxGiHUKEm9uPwOKc3BwCnhKnGnzBwkLAZVMermFFWSmhMBzNokLnXeg5ghIfJt8iAWkXgJo
	8aYDUFdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxiBwXn63zPpHYyr
	GiwOMQpwMCrx8P64zB8oxJpYVlyZe4hRgoNZSYS3+otAoBBvSmJlVWpRfnxRaU5q8SHGZKDl
	E5mlRJPzgZGTVxJvaGxibmpsamlkZGZqSpqwkjgv46knAUIC6YklqdmpqQWpRTBbmDg4pRoY
	dWI1PxgwqOsZuO/+3fvp5o09tpVHn0/svfriw1mfp1Mag3QScvv+c9/3Cyzgneb33WcD04/u
	mdVJBTf25b0UX6zXnbojd+fEqVzlDkmGxjGH19kGXfN6O++2eK/7zzMt/3wjzrEHsZ7ZrfFd
	zyNjqVBq8KE5BYocefa1tR56Eldb1ztN+bFLiaU4I9FQi7moOBEAqYyKyZICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t9jAd1pfwUCDeauFrO4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHjelsX
	e8GPD0wVj+c2MzUwnlrH1MXIySEhYCLx4M5cKFtM4sK99WxdjFwcQgKLGCVWr2xnhnAmM0ns
	vzGVDaSKTUBXountLkYQW0RAVuLwld9gRcwCj5gkvux7zgKSEBZwl3i9ZAJYEYuAqsTFy/OY
	QWxeAQ+JjkXzGCHWKUi8uf0MKM7BwSngKXGmzR8kLARUMunlFtYJjLwLGBlWMYqmFiQXFCel
	5xrpFSfmFpfmpesl5+duYgSH/jPpHYyrGiwOMQpwMCrx8P64zB8oxJpYVlyZe4hRgoNZSYS3
	+otAoBBvSmJlVWpRfnxRaU5q8SHGZKCjJjJLiSbnA+MyryTe0NjE3NTY1NLEwsTMkjRhJXFe
	xlNPAoQE0hNLUrNTUwtSi2C2MHFwSjUwdi9/+CBAc5HH8qqzWbNvu865av22nIFxxfb1/GL6
	Tv8LssyEa1Pa67jr1+opmrrfavx5++m3oqbuO1qLLPVlZp/ZvaxjX9vSo53XE8q1TFi7Ixh2
	zrH+1jZ9iqyJ+7QJ9+5KVZ1kMnP86/H3rNydiN9Oz47PKHSUCnL5cmDO3CucjDtuMS5fo8RS
	nJFoqMVcVJwIAGN5i7jBAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving register and structure definitions to header file,
and keeping the generic functions to be used across
multiple PHYs in common phy helper driver under SAMSUNG_USBPHY,
and moving USB 2.0 PHY driver under SAMSUNG_USB2PHY.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/Kconfig           |   17 +-
 drivers/usb/phy/Makefile          |    1 +
 drivers/usb/phy/samsung-usb2phy.c |  511 ++++++++++++++++++++++++++
 drivers/usb/phy/samsung-usbphy.c  |  717 +------------------------------------
 drivers/usb/phy/samsung-usbphy.h  |  247 +++++++++++++
 5 files changed, 780 insertions(+), 713 deletions(-)
 create mode 100644 drivers/usb/phy/samsung-usb2phy.c
 create mode 100644 drivers/usb/phy/samsung-usbphy.h

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 65217a5..b28878d 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -66,10 +66,17 @@ config USB_RCAR_PHY
 	  To compile this driver as a module, choose M here: the
 	  module will be called rcar-phy.
 
-config SAMSUNG_USBPHY
-	bool "Samsung USB PHY controller Driver"
-	depends on USB_S3C_HSOTG || USB_EHCI_S5P || USB_OHCI_EXYNOS
+config SAMSUNG_USB2PHY
+	bool "Samsung USB 2.0 PHY controller Driver"
+	select SAMSUNG_USBPHY
 	select USB_OTG_UTILS
 	help
-	  Enable this to support Samsung USB phy controller for samsung
-	  SoCs.
+	  Enable this to support Samsung USB 2.0 (High Speed) PHY controller
+	  driver for Samsung SoCs.
+
+config SAMSUNG_USBPHY
+	bool "Samsung USB PHY Driver"
+	help
+	  Enable this to support Samsung USB phy helper driver for Samsung SoCs.
+	  This driver provides common interface to interact, for Samsung USB 2.0 PHY
+	  driver and later for Samsung USB 3.0 PHY driver.
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index b13faa1..1efa174 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_MV_U3D_PHY)		+= mv_u3d_phy.o
 obj-$(CONFIG_USB_EHCI_TEGRA)	+= tegra_usb_phy.o
 obj-$(CONFIG_USB_RCAR_PHY)		+= rcar-phy.o
 obj-$(CONFIG_SAMSUNG_USBPHY)		+= samsung-usbphy.o
+obj-$(CONFIG_SAMSUNG_USB2PHY)		+= samsung-usb2phy.o
diff --git a/drivers/usb/phy/samsung-usb2phy.c b/drivers/usb/phy/samsung-usb2phy.c
new file mode 100644
index 0000000..55ac3a8
--- /dev/null
+++ b/drivers/usb/phy/samsung-usb2phy.c
@@ -0,0 +1,511 @@
+/* linux/drivers/usb/phy/samsung-usb2phy.c
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * Author: Praveen Paneri <p.paneri@samsung.com>
+ *
+ * Samsung USB2.0 PHY transceiver; talks to S3C HS OTG controller, EHCI-S5P and
+ * OHCI-EXYNOS controllers.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/usb/otg.h>
+#include <linux/usb/samsung_usb_phy.h>
+#include <linux/platform_data/samsung-usbphy.h>
+
+#include "samsung-usbphy.h"
+
+int samsung_usb2phy_set_host(struct usb_otg *otg, struct usb_bus *host)
+{
+	if (!otg)
+		return -ENODEV;
+
+	if (!otg->host)
+		otg->host = host;
+
+	return 0;
+}
+
+static bool exynos5_phyhost_is_on(void *regs)
+{
+	u32 reg;
+
+	reg = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
+
+	return !(reg & HOST_CTRL0_SIDDQ);
+}
+
+static void samsung_exynos5_usb2phy_enable(struct samsung_usbphy *sphy)
+{
+	void __iomem *regs = sphy->regs;
+	u32 phyclk = sphy->ref_clk_freq;
+	u32 phyhost;
+	u32 phyotg;
+	u32 phyhsic;
+	u32 ehcictrl;
+	u32 ohcictrl;
+
+	/*
+	 * phy_usage helps in keeping usage count for phy
+	 * so that the first consumer enabling the phy is also
+	 * the last consumer to disable it.
+	 */
+
+	atomic_inc(&sphy->phy_usage);
+
+	if (exynos5_phyhost_is_on(regs)) {
+		dev_info(sphy->dev, "Already power on PHY\n");
+		return;
+	}
+
+	/* Host configuration */
+	phyhost = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
+
+	/* phy reference clock configuration */
+	phyhost &= ~HOST_CTRL0_FSEL_MASK;
+	phyhost |= HOST_CTRL0_FSEL(phyclk);
+
+	/* host phy reset */
+	phyhost &= ~(HOST_CTRL0_PHYSWRST |
+			HOST_CTRL0_PHYSWRSTALL |
+			HOST_CTRL0_SIDDQ |
+			/* Enable normal mode of operation */
+			HOST_CTRL0_FORCESUSPEND |
+			HOST_CTRL0_FORCESLEEP);
+
+	/* Link reset */
+	phyhost |= (HOST_CTRL0_LINKSWRST |
+			HOST_CTRL0_UTMISWRST |
+			/* COMMON Block configuration during suspend */
+			HOST_CTRL0_COMMONON_N);
+	writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
+	udelay(10);
+	phyhost &= ~(HOST_CTRL0_LINKSWRST |
+			HOST_CTRL0_UTMISWRST);
+	writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
+
+	/* OTG configuration */
+	phyotg = readl(regs + EXYNOS5_PHY_OTG_SYS);
+
+	/* phy reference clock configuration */
+	phyotg &= ~OTG_SYS_FSEL_MASK;
+	phyotg |= OTG_SYS_FSEL(phyclk);
+
+	/* Enable normal mode of operation */
+	phyotg &= ~(OTG_SYS_FORCESUSPEND |
+			OTG_SYS_SIDDQ_UOTG |
+			OTG_SYS_FORCESLEEP |
+			OTG_SYS_REFCLKSEL_MASK |
+			/* COMMON Block configuration during suspend */
+			OTG_SYS_COMMON_ON);
+
+	/* OTG phy & link reset */
+	phyotg |= (OTG_SYS_PHY0_SWRST |
+			OTG_SYS_LINKSWRST_UOTG |
+			OTG_SYS_PHYLINK_SWRESET |
+			OTG_SYS_OTGDISABLE |
+			/* Set phy refclk */
+			OTG_SYS_REFCLKSEL_CLKCORE);
+
+	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
+	udelay(10);
+	phyotg &= ~(OTG_SYS_PHY0_SWRST |
+			OTG_SYS_LINKSWRST_UOTG |
+			OTG_SYS_PHYLINK_SWRESET);
+	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
+
+	/* HSIC phy configuration */
+	phyhsic = (HSIC_CTRL_REFCLKDIV_12 |
+			HSIC_CTRL_REFCLKSEL |
+			HSIC_CTRL_PHYSWRST);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
+	udelay(10);
+	phyhsic &= ~HSIC_CTRL_PHYSWRST;
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
+
+	udelay(80);
+
+	/* enable EHCI DMA burst */
+	ehcictrl = readl(regs + EXYNOS5_PHY_HOST_EHCICTRL);
+	ehcictrl |= (HOST_EHCICTRL_ENAINCRXALIGN |
+				HOST_EHCICTRL_ENAINCR4 |
+				HOST_EHCICTRL_ENAINCR8 |
+				HOST_EHCICTRL_ENAINCR16);
+	writel(ehcictrl, regs + EXYNOS5_PHY_HOST_EHCICTRL);
+
+	/* set ohci_suspend_on_n */
+	ohcictrl = readl(regs + EXYNOS5_PHY_HOST_OHCICTRL);
+	ohcictrl |= HOST_OHCICTRL_SUSPLGCY;
+	writel(ohcictrl, regs + EXYNOS5_PHY_HOST_OHCICTRL);
+}
+
+static void samsung_usb2phy_enable(struct samsung_usbphy *sphy)
+{
+	void __iomem *regs = sphy->regs;
+	u32 phypwr;
+	u32 phyclk;
+	u32 rstcon;
+
+	/* set clock frequency for PLL */
+	phyclk = sphy->ref_clk_freq;
+	phypwr = readl(regs + SAMSUNG_PHYPWR);
+	rstcon = readl(regs + SAMSUNG_RSTCON);
+
+	switch (sphy->drv_data->cpu_type) {
+	case TYPE_S3C64XX:
+		phyclk &= ~PHYCLK_COMMON_ON_N;
+		phypwr &= ~PHYPWR_NORMAL_MASK;
+		rstcon |= RSTCON_SWRST;
+		break;
+	case TYPE_EXYNOS4210:
+		phypwr &= ~PHYPWR_NORMAL_MASK_PHY0;
+		rstcon |= RSTCON_SWRST;
+	default:
+		break;
+	}
+
+	writel(phyclk, regs + SAMSUNG_PHYCLK);
+	/* Configure PHY0 for normal operation*/
+	writel(phypwr, regs + SAMSUNG_PHYPWR);
+	/* reset all ports of PHY and Link */
+	writel(rstcon, regs + SAMSUNG_RSTCON);
+	udelay(10);
+	rstcon &= ~RSTCON_SWRST;
+	writel(rstcon, regs + SAMSUNG_RSTCON);
+}
+
+static void samsung_exynos5_usb2phy_disable(struct samsung_usbphy *sphy)
+{
+	void __iomem *regs = sphy->regs;
+	u32 phyhost;
+	u32 phyotg;
+	u32 phyhsic;
+
+	if (atomic_dec_return(&sphy->phy_usage) > 0) {
+		dev_info(sphy->dev, "still being used\n");
+		return;
+	}
+
+	phyhsic = (HSIC_CTRL_REFCLKDIV_12 |
+			HSIC_CTRL_REFCLKSEL |
+			HSIC_CTRL_SIDDQ |
+			HSIC_CTRL_FORCESLEEP |
+			HSIC_CTRL_FORCESUSPEND);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL1);
+	writel(phyhsic, regs + EXYNOS5_PHY_HSIC_CTRL2);
+
+	phyhost = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
+	phyhost |= (HOST_CTRL0_SIDDQ |
+			HOST_CTRL0_FORCESUSPEND |
+			HOST_CTRL0_FORCESLEEP |
+			HOST_CTRL0_PHYSWRST |
+			HOST_CTRL0_PHYSWRSTALL);
+	writel(phyhost, regs + EXYNOS5_PHY_HOST_CTRL0);
+
+	phyotg = readl(regs + EXYNOS5_PHY_OTG_SYS);
+	phyotg |= (OTG_SYS_FORCESUSPEND |
+			OTG_SYS_SIDDQ_UOTG |
+			OTG_SYS_FORCESLEEP);
+	writel(phyotg, regs + EXYNOS5_PHY_OTG_SYS);
+}
+
+static void samsung_usb2phy_disable(struct samsung_usbphy *sphy)
+{
+	void __iomem *regs = sphy->regs;
+	u32 phypwr;
+
+	phypwr = readl(regs + SAMSUNG_PHYPWR);
+
+	switch (sphy->drv_data->cpu_type) {
+	case TYPE_S3C64XX:
+		phypwr |= PHYPWR_NORMAL_MASK;
+		break;
+	case TYPE_EXYNOS4210:
+		phypwr |= PHYPWR_NORMAL_MASK_PHY0;
+	default:
+		break;
+	}
+
+	/* Disable analog and otg block power */
+	writel(phypwr, regs + SAMSUNG_PHYPWR);
+}
+
+/*
+ * The function passed to the usb driver for phy initialization
+ */
+static int samsung_usb2phy_init(struct usb_phy *phy)
+{
+	struct samsung_usbphy *sphy;
+	struct usb_bus *host = NULL;
+	unsigned long flags;
+	int ret = 0;
+
+	sphy = phy_to_sphy(phy);
+
+	host = phy->otg->host;
+
+	/* Enable the phy clock */
+	ret = clk_prepare_enable(sphy->clk);
+	if (ret) {
+		dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
+		return ret;
+	}
+
+	spin_lock_irqsave(&sphy->lock, flags);
+
+	if (host) {
+		/* setting default phy-type for USB 2.0 */
+		if (!strstr(dev_name(host->controller), "ehci") ||
+				!strstr(dev_name(host->controller), "ohci"))
+			samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
+	} else {
+		samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
+	}
+
+	/* Disable phy isolation */
+	if (sphy->plat && sphy->plat->pmu_isolation)
+		sphy->plat->pmu_isolation(false);
+	else
+		samsung_usbphy_set_isolation(sphy, false);
+
+	/* Selecting Host/OTG mode; After reset USB2.0PHY_CFG: HOST */
+	samsung_usbphy_cfg_sel(sphy);
+
+	/* Initialize usb phy registers */
+	if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
+		samsung_exynos5_usb2phy_enable(sphy);
+	else
+		samsung_usb2phy_enable(sphy);
+
+	spin_unlock_irqrestore(&sphy->lock, flags);
+
+	/* Disable the phy clock */
+	clk_disable_unprepare(sphy->clk);
+
+	return ret;
+}
+
+/*
+ * The function passed to the usb driver for phy shutdown
+ */
+static void samsung_usb2phy_shutdown(struct usb_phy *phy)
+{
+	struct samsung_usbphy *sphy;
+	struct usb_bus *host = NULL;
+	unsigned long flags;
+
+	sphy = phy_to_sphy(phy);
+
+	host = phy->otg->host;
+
+	if (clk_prepare_enable(sphy->clk)) {
+		dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
+		return;
+	}
+
+	spin_lock_irqsave(&sphy->lock, flags);
+
+	if (host) {
+		/* setting default phy-type for USB 2.0 */
+		if (!strstr(dev_name(host->controller), "ehci") ||
+				!strstr(dev_name(host->controller), "ohci"))
+			samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
+	} else {
+		samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
+	}
+
+	/* De-initialize usb phy registers */
+	if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
+		samsung_exynos5_usb2phy_disable(sphy);
+	else
+		samsung_usb2phy_disable(sphy);
+
+	/* Enable phy isolation */
+	if (sphy->plat && sphy->plat->pmu_isolation)
+		sphy->plat->pmu_isolation(true);
+	else
+		samsung_usbphy_set_isolation(sphy, true);
+
+	spin_unlock_irqrestore(&sphy->lock, flags);
+
+	clk_disable_unprepare(sphy->clk);
+}
+
+static int samsung_usb2phy_probe(struct platform_device *pdev)
+{
+	struct samsung_usbphy *sphy;
+	struct usb_otg *otg;
+	struct samsung_usbphy_data *pdata = pdev->dev.platform_data;
+	const struct samsung_usbphy_drvdata *drv_data;
+	struct device *dev = &pdev->dev;
+	struct resource *phy_mem;
+	void __iomem	*phy_base;
+	struct clk *clk;
+	int ret;
+
+	phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!phy_mem) {
+		dev_err(dev, "%s: missing mem resource\n", __func__);
+		return -ENODEV;
+	}
+
+	phy_base = devm_request_and_ioremap(dev, phy_mem);
+	if (!phy_base) {
+		dev_err(dev, "%s: register mapping failed\n", __func__);
+		return -ENXIO;
+	}
+
+	sphy = devm_kzalloc(dev, sizeof(*sphy), GFP_KERNEL);
+	if (!sphy)
+		return -ENOMEM;
+
+	otg = devm_kzalloc(dev, sizeof(*otg), GFP_KERNEL);
+	if (!otg)
+		return -ENOMEM;
+
+	drv_data = samsung_usbphy_get_driver_data(pdev);
+
+	if (drv_data->cpu_type == TYPE_EXYNOS5250)
+		clk = devm_clk_get(dev, "usbhost");
+	else
+		clk = devm_clk_get(dev, "otg");
+
+	if (IS_ERR(clk)) {
+		dev_err(dev, "Failed to get otg clock\n");
+		return PTR_ERR(clk);
+	}
+
+	sphy->dev = dev;
+
+	if (dev->of_node) {
+		ret = samsung_usbphy_parse_dt(sphy);
+		if (ret < 0)
+			return ret;
+	} else {
+		if (!pdata) {
+			dev_err(dev, "no platform data specified\n");
+			return -EINVAL;
+		}
+	}
+
+	sphy->plat		= pdata;
+	sphy->regs		= phy_base;
+	sphy->clk		= clk;
+	sphy->drv_data		= drv_data;
+	sphy->phy.dev		= sphy->dev;
+	sphy->phy.label		= "samsung-usb2phy";
+	sphy->phy.init		= samsung_usb2phy_init;
+	sphy->phy.shutdown	= samsung_usb2phy_shutdown;
+	sphy->ref_clk_freq	= samsung_usbphy_get_refclk_freq(sphy);
+
+	sphy->phy.otg		= otg;
+	sphy->phy.otg->phy	= &sphy->phy;
+	sphy->phy.otg->set_host = samsung_usb2phy_set_host;
+
+	spin_lock_init(&sphy->lock);
+
+	platform_set_drvdata(pdev, sphy);
+
+	return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB2);
+}
+
+static int samsung_usb2phy_remove(struct platform_device *pdev)
+{
+	struct samsung_usbphy *sphy = platform_get_drvdata(pdev);
+
+	usb_remove_phy(&sphy->phy);
+
+	if (sphy->pmuregs)
+		iounmap(sphy->pmuregs);
+	if (sphy->sysreg)
+		iounmap(sphy->sysreg);
+
+	return 0;
+}
+
+static const struct samsung_usbphy_drvdata usb2phy_s3c64xx = {
+	.cpu_type		= TYPE_S3C64XX,
+	.devphy_en_mask		= S3C64XX_USBPHY_ENABLE,
+};
+
+static const struct samsung_usbphy_drvdata usb2phy_exynos4 = {
+	.cpu_type		= TYPE_EXYNOS4210,
+	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
+	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
+};
+
+static struct samsung_usbphy_drvdata usb2phy_exynos5 = {
+	.cpu_type		= TYPE_EXYNOS5250,
+	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
+	.hostphy_reg_offset	= EXYNOS_USBHOST_PHY_CTRL_OFFSET,
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id samsung_usbphy_dt_match[] = {
+	{
+		.compatible = "samsung,s3c64xx-usb2phy",
+		.data = &usb2phy_s3c64xx,
+	}, {
+		.compatible = "samsung,exynos4210-usb2phy",
+		.data = &usb2phy_exynos4,
+	}, {
+		.compatible = "samsung,exynos5250-usb2phy",
+		.data = &usb2phy_exynos5
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, samsung_usbphy_dt_match);
+#endif
+
+static struct platform_device_id samsung_usbphy_driver_ids[] = {
+	{
+		.name		= "s3c64xx-usb2phy",
+		.driver_data	= (unsigned long)&usb2phy_s3c64xx,
+	}, {
+		.name		= "exynos4210-usb2phy",
+		.driver_data	= (unsigned long)&usb2phy_exynos4,
+	}, {
+		.name		= "exynos5250-usb2phy",
+		.driver_data	= (unsigned long)&usb2phy_exynos5,
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(platform, samsung_usbphy_driver_ids);
+
+static struct platform_driver samsung_usb2phy_driver = {
+	.probe		= samsung_usb2phy_probe,
+	.remove		= samsung_usb2phy_remove,
+	.id_table	= samsung_usbphy_driver_ids,
+	.driver		= {
+		.name	= "samsung-usb2phy",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(samsung_usbphy_dt_match),
+	},
+};
+
+module_platform_driver(samsung_usb2phy_driver);
+
+MODULE_DESCRIPTION("Samsung USB 2.0 phy controller");
+MODULE_AUTHOR("Praveen Paneri <p.paneri@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:samsung-usb2phy");
diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
index 6ea5537..4fb03dc 100644
--- a/drivers/usb/phy/samsung-usbphy.c
+++ b/drivers/usb/phy/samsung-usbphy.c
@@ -5,8 +5,9 @@
  *
  * Author: Praveen Paneri <p.paneri@samsung.com>
  *
- * Samsung USB2.0 PHY transceiver; talks to S3C HS OTG controller, EHCI-S5P and
- * OHCI-EXYNOS controllers.
+ * Samsung USB-PHY helper driver with common function calls;
+ * interacts with Samsung USB 2.0 PHY controller driver and later
+ * with Samsung USB 3.0 PHY driver.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -21,233 +22,16 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
-#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/usb/otg.h>
 #include <linux/usb/samsung_usb_phy.h>
-#include <linux/platform_data/samsung-usbphy.h>
 
-/* Register definitions */
+#include "samsung-usbphy.h"
 
-#define SAMSUNG_PHYPWR				(0x00)
-
-#define PHYPWR_NORMAL_MASK			(0x19 << 0)
-#define PHYPWR_OTG_DISABLE			(0x1 << 4)
-#define PHYPWR_ANALOG_POWERDOWN			(0x1 << 3)
-#define PHYPWR_FORCE_SUSPEND			(0x1 << 1)
-/* For Exynos4 */
-#define PHYPWR_NORMAL_MASK_PHY0			(0x39 << 0)
-#define PHYPWR_SLEEP_PHY0			(0x1 << 5)
-
-#define SAMSUNG_PHYCLK				(0x04)
-
-#define PHYCLK_MODE_USB11			(0x1 << 6)
-#define PHYCLK_EXT_OSC				(0x1 << 5)
-#define PHYCLK_COMMON_ON_N			(0x1 << 4)
-#define PHYCLK_ID_PULL				(0x1 << 2)
-#define PHYCLK_CLKSEL_MASK			(0x3 << 0)
-#define PHYCLK_CLKSEL_48M			(0x0 << 0)
-#define PHYCLK_CLKSEL_12M			(0x2 << 0)
-#define PHYCLK_CLKSEL_24M			(0x3 << 0)
-
-#define SAMSUNG_RSTCON				(0x08)
-
-#define RSTCON_PHYLINK_SWRST			(0x1 << 2)
-#define RSTCON_HLINK_SWRST			(0x1 << 1)
-#define RSTCON_SWRST				(0x1 << 0)
-
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
-#define FSEL_CLKSEL_50M				(0x7)
-#define FSEL_CLKSEL_24M				(0x5)
-#define FSEL_CLKSEL_20M				(0x4)
-#define FSEL_CLKSEL_19200K			(0x3)
-#define FSEL_CLKSEL_12M				(0x2)
-#define FSEL_CLKSEL_10M				(0x1)
-#define FSEL_CLKSEL_9600K			(0x0)
-
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
-#ifndef MHZ
-#define MHZ (1000*1000)
-#endif
-
-#ifndef KHZ
-#define KHZ (1000)
-#endif
-
-#define EXYNOS_USBHOST_PHY_CTRL_OFFSET		(0x4)
-#define S3C64XX_USBPHY_ENABLE			(0x1 << 16)
-#define EXYNOS_USBPHY_ENABLE			(0x1 << 0)
-#define EXYNOS_USB20PHY_CFG_HOST_LINK		(0x1 << 0)
-
-enum samsung_cpu_type {
-	TYPE_S3C64XX,
-	TYPE_EXYNOS4210,
-	TYPE_EXYNOS5250,
-};
-
-/*
- * struct samsung_usbphy_drvdata - driver data for various SoC variants
- * @cpu_type: machine identifier
- * @devphy_en_mask: device phy enable mask for PHY CONTROL register
- * @hostphy_en_mask: host phy enable mask for PHY CONTROL register
- * @devphy_reg_offset: offset to DEVICE PHY CONTROL register from
- *		       mapped address of system controller.
- * @hostphy_reg_offset: offset to HOST PHY CONTROL register from
- *		       mapped address of system controller.
- *
- *	Here we have a separate mask for device type phy.
- *	Having different masks for host and device type phy helps
- *	in setting independent masks in case of SoCs like S5PV210,
- *	in which PHY0 and PHY1 enable bits belong to same register
- *	placed at position 0 and 1 respectively.
- *	Although for newer SoCs like exynos these bits belong to
- *	different registers altogether placed at position 0.
- */
-struct samsung_usbphy_drvdata {
-	int cpu_type;
-	int devphy_en_mask;
-	int hostphy_en_mask;
-	u32 devphy_reg_offset;
-	u32 hostphy_reg_offset;
-};
-
-/*
- * struct samsung_usbphy - transceiver driver state
- * @phy: transceiver structure
- * @plat: platform data
- * @dev: The parent device supplied to the probe function
- * @clk: usb phy clock
- * @regs: usb phy controller registers memory base
- * @pmuregs: USB device PHY_CONTROL register memory base
- * @sysreg: USB2.0 PHY_CFG register memory base
- * @ref_clk_freq: reference clock frequency selection
- * @drv_data: driver data available for different SoCs
- * @phy_type: Samsung SoCs specific phy types:	#HOST
- *						#DEVICE
- * @phy_usage: usage count for phy
- * @lock: lock for phy operations
- */
-struct samsung_usbphy {
-	struct usb_phy	phy;
-	struct samsung_usbphy_data *plat;
-	struct device	*dev;
-	struct clk	*clk;
-	void __iomem	*regs;
-	void __iomem	*pmuregs;
-	void __iomem	*sysreg;
-	int		ref_clk_freq;
-	const struct samsung_usbphy_drvdata *drv_data;
-	enum samsung_usb_phy_type phy_type;
-	atomic_t	phy_usage;
-	spinlock_t	lock;
-};
-
-#define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
-
-int samsung_usbphy_set_host(struct usb_otg *otg, struct usb_bus *host)
-{
-	if (!otg)
-		return -ENODEV;
-
-	if (!otg->host)
-		otg->host = host;
-
-	return 0;
-}
-
-static int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
+int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
 {
 	struct device_node *usbphy_sys;
 
@@ -288,7 +72,7 @@ err0:
  * Here 'on = true' would mean USB PHY block is isolated, hence
  * de-activated and vice-versa.
  */
-static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, bool on)
+void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, bool on)
 {
 	void __iomem *reg = NULL;
 	u32 reg_val;
@@ -340,7 +124,7 @@ static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, bool on)
 /*
  * Configure the mode of working of usb-phy here: HOST/DEVICE.
  */
-static void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy)
+void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy)
 {
 	u32 reg;
 
@@ -364,7 +148,7 @@ static void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy)
  * This make sure that correct PHY type is selected before
  * any operation on PHY.
  */
-static int samsung_usbphy_set_type(struct usb_phy *phy,
+int samsung_usbphy_set_type(struct usb_phy *phy,
 				enum samsung_usb_phy_type phy_type)
 {
 	struct samsung_usbphy *sphy = phy_to_sphy(phy);
@@ -377,7 +161,7 @@ static int samsung_usbphy_set_type(struct usb_phy *phy,
 /*
  * Returns reference clock frequency selection value
  */
-static int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
+int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
 {
 	struct clk *ref_clk;
 	int refclk_freq = 0;
@@ -445,486 +229,3 @@ static int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
 
 	return refclk_freq;
 }
-
-static bool exynos5_phyhost_is_on(void *regs)
-{
-	u32 reg;
-
-	reg = readl(regs + EXYNOS5_PHY_HOST_CTRL0);
-
-	return !(reg & HOST_CTRL0_SIDDQ);
-}
-
-static void samsung_exynos5_usbphy_enable(struct samsung_usbphy *sphy)
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
-static void samsung_usbphy_enable(struct samsung_usbphy *sphy)
-{
-	void __iomem *regs = sphy->regs;
-	u32 phypwr;
-	u32 phyclk;
-	u32 rstcon;
-
-	/* set clock frequency for PLL */
-	phyclk = sphy->ref_clk_freq;
-	phypwr = readl(regs + SAMSUNG_PHYPWR);
-	rstcon = readl(regs + SAMSUNG_RSTCON);
-
-	switch (sphy->drv_data->cpu_type) {
-	case TYPE_S3C64XX:
-		phyclk &= ~PHYCLK_COMMON_ON_N;
-		phypwr &= ~PHYPWR_NORMAL_MASK;
-		rstcon |= RSTCON_SWRST;
-		break;
-	case TYPE_EXYNOS4210:
-		phypwr &= ~PHYPWR_NORMAL_MASK_PHY0;
-		rstcon |= RSTCON_SWRST;
-	default:
-		break;
-	}
-
-	writel(phyclk, regs + SAMSUNG_PHYCLK);
-	/* Configure PHY0 for normal operation*/
-	writel(phypwr, regs + SAMSUNG_PHYPWR);
-	/* reset all ports of PHY and Link */
-	writel(rstcon, regs + SAMSUNG_RSTCON);
-	udelay(10);
-	rstcon &= ~RSTCON_SWRST;
-	writel(rstcon, regs + SAMSUNG_RSTCON);
-}
-
-static void samsung_exynos5_usbphy_disable(struct samsung_usbphy *sphy)
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
-static void samsung_usbphy_disable(struct samsung_usbphy *sphy)
-{
-	void __iomem *regs = sphy->regs;
-	u32 phypwr;
-
-	phypwr = readl(regs + SAMSUNG_PHYPWR);
-
-	switch (sphy->drv_data->cpu_type) {
-	case TYPE_S3C64XX:
-		phypwr |= PHYPWR_NORMAL_MASK;
-		break;
-	case TYPE_EXYNOS4210:
-		phypwr |= PHYPWR_NORMAL_MASK_PHY0;
-	default:
-		break;
-	}
-
-	/* Disable analog and otg block power */
-	writel(phypwr, regs + SAMSUNG_PHYPWR);
-}
-
-/*
- * The function passed to the usb driver for phy initialization
- */
-static int samsung_usbphy_init(struct usb_phy *phy)
-{
-	struct samsung_usbphy *sphy;
-	struct usb_bus *host = NULL;
-	unsigned long flags;
-	int ret = 0;
-
-	sphy = phy_to_sphy(phy);
-
-	host = phy->otg->host;
-
-	/* Enable the phy clock */
-	ret = clk_prepare_enable(sphy->clk);
-	if (ret) {
-		dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
-		return ret;
-	}
-
-	spin_lock_irqsave(&sphy->lock, flags);
-
-	if (host) {
-		/* setting default phy-type for USB 2.0 */
-		if (!strstr(dev_name(host->controller), "ehci") ||
-				!strstr(dev_name(host->controller), "ohci"))
-			samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
-	} else {
-		samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
-	}
-
-	/* Disable phy isolation */
-	if (sphy->plat && sphy->plat->pmu_isolation)
-		sphy->plat->pmu_isolation(false);
-	else
-		samsung_usbphy_set_isolation(sphy, false);
-
-	/* Selecting Host/OTG mode; After reset USB2.0PHY_CFG: HOST */
-	samsung_usbphy_cfg_sel(sphy);
-
-	/* Initialize usb phy registers */
-	if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
-		samsung_exynos5_usbphy_enable(sphy);
-	else
-		samsung_usbphy_enable(sphy);
-
-	spin_unlock_irqrestore(&sphy->lock, flags);
-
-	/* Disable the phy clock */
-	clk_disable_unprepare(sphy->clk);
-
-	return ret;
-}
-
-/*
- * The function passed to the usb driver for phy shutdown
- */
-static void samsung_usbphy_shutdown(struct usb_phy *phy)
-{
-	struct samsung_usbphy *sphy;
-	struct usb_bus *host = NULL;
-	unsigned long flags;
-
-	sphy = phy_to_sphy(phy);
-
-	host = phy->otg->host;
-
-	if (clk_prepare_enable(sphy->clk)) {
-		dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
-		return;
-	}
-
-	spin_lock_irqsave(&sphy->lock, flags);
-
-	if (host) {
-		/* setting default phy-type for USB 2.0 */
-		if (!strstr(dev_name(host->controller), "ehci") ||
-				!strstr(dev_name(host->controller), "ohci"))
-			samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
-	} else {
-		samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
-	}
-
-	/* De-initialize usb phy registers */
-	if (sphy->drv_data->cpu_type == TYPE_EXYNOS5250)
-		samsung_exynos5_usbphy_disable(sphy);
-	else
-		samsung_usbphy_disable(sphy);
-
-	/* Enable phy isolation */
-	if (sphy->plat && sphy->plat->pmu_isolation)
-		sphy->plat->pmu_isolation(true);
-	else
-		samsung_usbphy_set_isolation(sphy, true);
-
-	spin_unlock_irqrestore(&sphy->lock, flags);
-
-	clk_disable_unprepare(sphy->clk);
-}
-
-static const struct of_device_id samsung_usbphy_dt_match[];
-
-static inline const struct samsung_usbphy_drvdata
-*samsung_usbphy_get_driver_data(struct platform_device *pdev)
-{
-	if (pdev->dev.of_node) {
-		const struct of_device_id *match;
-		match = of_match_node(samsung_usbphy_dt_match,
-							pdev->dev.of_node);
-		return match->data;
-	}
-
-	return (struct samsung_usbphy_drvdata *)
-				platform_get_device_id(pdev)->driver_data;
-}
-
-static int samsung_usbphy_probe(struct platform_device *pdev)
-{
-	struct samsung_usbphy *sphy;
-	struct usb_otg *otg;
-	struct samsung_usbphy_data *pdata = pdev->dev.platform_data;
-	const struct samsung_usbphy_drvdata *drv_data;
-	struct device *dev = &pdev->dev;
-	struct resource *phy_mem;
-	void __iomem	*phy_base;
-	struct clk *clk;
-	int ret;
-
-	phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!phy_mem) {
-		dev_err(dev, "%s: missing mem resource\n", __func__);
-		return -ENODEV;
-	}
-
-	phy_base = devm_request_and_ioremap(dev, phy_mem);
-	if (!phy_base) {
-		dev_err(dev, "%s: register mapping failed\n", __func__);
-		return -ENXIO;
-	}
-
-	sphy = devm_kzalloc(dev, sizeof(*sphy), GFP_KERNEL);
-	if (!sphy)
-		return -ENOMEM;
-
-	otg = devm_kzalloc(dev, sizeof(*otg), GFP_KERNEL);
-	if (!otg)
-		return -ENOMEM;
-
-	drv_data = samsung_usbphy_get_driver_data(pdev);
-
-	if (drv_data->cpu_type == TYPE_EXYNOS5250)
-		clk = devm_clk_get(dev, "usbhost");
-	else
-		clk = devm_clk_get(dev, "otg");
-
-	if (IS_ERR(clk)) {
-		dev_err(dev, "Failed to get otg clock\n");
-		return PTR_ERR(clk);
-	}
-
-	sphy->dev = dev;
-
-	if (dev->of_node) {
-		ret = samsung_usbphy_parse_dt(sphy);
-		if (ret < 0)
-			return ret;
-	} else {
-		if (!pdata) {
-			dev_err(dev, "no platform data specified\n");
-			return -EINVAL;
-		}
-	}
-
-	sphy->plat		= pdata;
-	sphy->regs		= phy_base;
-	sphy->clk		= clk;
-	sphy->drv_data		= drv_data;
-	sphy->phy.dev		= sphy->dev;
-	sphy->phy.label		= "samsung-usbphy";
-	sphy->phy.init		= samsung_usbphy_init;
-	sphy->phy.shutdown	= samsung_usbphy_shutdown;
-	sphy->ref_clk_freq	= samsung_usbphy_get_refclk_freq(sphy);
-
-	sphy->phy.otg		= otg;
-	sphy->phy.otg->phy	= &sphy->phy;
-	sphy->phy.otg->set_host = samsung_usbphy_set_host;
-
-	spin_lock_init(&sphy->lock);
-
-	platform_set_drvdata(pdev, sphy);
-
-	return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB2);
-}
-
-static int samsung_usbphy_remove(struct platform_device *pdev)
-{
-	struct samsung_usbphy *sphy = platform_get_drvdata(pdev);
-
-	usb_remove_phy(&sphy->phy);
-
-	if (sphy->pmuregs)
-		iounmap(sphy->pmuregs);
-	if (sphy->sysreg)
-		iounmap(sphy->sysreg);
-
-	return 0;
-}
-
-static const struct samsung_usbphy_drvdata usbphy_s3c64xx = {
-	.cpu_type		= TYPE_S3C64XX,
-	.devphy_en_mask		= S3C64XX_USBPHY_ENABLE,
-};
-
-static const struct samsung_usbphy_drvdata usbphy_exynos4 = {
-	.cpu_type		= TYPE_EXYNOS4210,
-	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
-	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
-};
-
-static struct samsung_usbphy_drvdata usbphy_exynos5 = {
-	.cpu_type		= TYPE_EXYNOS5250,
-	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
-	.hostphy_reg_offset	= EXYNOS_USBHOST_PHY_CTRL_OFFSET,
-};
-
-#ifdef CONFIG_OF
-static const struct of_device_id samsung_usbphy_dt_match[] = {
-	{
-		.compatible = "samsung,s3c64xx-usbphy",
-		.data = &usbphy_s3c64xx,
-	}, {
-		.compatible = "samsung,exynos4210-usbphy",
-		.data = &usbphy_exynos4,
-	}, {
-		.compatible = "samsung,exynos5250-usbphy",
-		.data = &usbphy_exynos5
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(of, samsung_usbphy_dt_match);
-#endif
-
-static struct platform_device_id samsung_usbphy_driver_ids[] = {
-	{
-		.name		= "s3c64xx-usbphy",
-		.driver_data	= (unsigned long)&usbphy_s3c64xx,
-	}, {
-		.name		= "exynos4210-usbphy",
-		.driver_data	= (unsigned long)&usbphy_exynos4,
-	}, {
-		.name		= "exynos5250-usbphy",
-		.driver_data	= (unsigned long)&usbphy_exynos5,
-	},
-	{},
-};
-
-MODULE_DEVICE_TABLE(platform, samsung_usbphy_driver_ids);
-
-static struct platform_driver samsung_usbphy_driver = {
-	.probe		= samsung_usbphy_probe,
-	.remove		= samsung_usbphy_remove,
-	.id_table	= samsung_usbphy_driver_ids,
-	.driver		= {
-		.name	= "samsung-usbphy",
-		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(samsung_usbphy_dt_match),
-	},
-};
-
-module_platform_driver(samsung_usbphy_driver);
-
-MODULE_DESCRIPTION("Samsung USB phy controller");
-MODULE_AUTHOR("Praveen Paneri <p.paneri@samsung.com>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:samsung-usbphy");
diff --git a/drivers/usb/phy/samsung-usbphy.h b/drivers/usb/phy/samsung-usbphy.h
new file mode 100644
index 0000000..969632b
--- /dev/null
+++ b/drivers/usb/phy/samsung-usbphy.h
@@ -0,0 +1,247 @@
+/* linux/drivers/usb/phy/samsung-usbphy.h
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * Samsung USB-PHY transceiver; talks to S3C HS OTG controller, EHCI-S5P and
+ * OHCI-EXYNOS controllers.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/usb/phy.h>
+
+/* Register definitions */
+
+#define SAMSUNG_PHYPWR				(0x00)
+
+#define PHYPWR_NORMAL_MASK			(0x19 << 0)
+#define PHYPWR_OTG_DISABLE			(0x1 << 4)
+#define PHYPWR_ANALOG_POWERDOWN			(0x1 << 3)
+#define PHYPWR_FORCE_SUSPEND			(0x1 << 1)
+/* For Exynos4 */
+#define PHYPWR_NORMAL_MASK_PHY0			(0x39 << 0)
+#define PHYPWR_SLEEP_PHY0			(0x1 << 5)
+
+#define SAMSUNG_PHYCLK				(0x04)
+
+#define PHYCLK_MODE_USB11			(0x1 << 6)
+#define PHYCLK_EXT_OSC				(0x1 << 5)
+#define PHYCLK_COMMON_ON_N			(0x1 << 4)
+#define PHYCLK_ID_PULL				(0x1 << 2)
+#define PHYCLK_CLKSEL_MASK			(0x3 << 0)
+#define PHYCLK_CLKSEL_48M			(0x0 << 0)
+#define PHYCLK_CLKSEL_12M			(0x2 << 0)
+#define PHYCLK_CLKSEL_24M			(0x3 << 0)
+
+#define SAMSUNG_RSTCON				(0x08)
+
+#define RSTCON_PHYLINK_SWRST			(0x1 << 2)
+#define RSTCON_HLINK_SWRST			(0x1 << 1)
+#define RSTCON_SWRST				(0x1 << 0)
+
+/* EXYNOS5 */
+#define EXYNOS5_PHY_HOST_CTRL0			(0x00)
+
+#define HOST_CTRL0_PHYSWRSTALL			(0x1 << 31)
+
+#define HOST_CTRL0_REFCLKSEL_MASK		(0x3 << 19)
+#define HOST_CTRL0_REFCLKSEL_XTAL		(0x0 << 19)
+#define HOST_CTRL0_REFCLKSEL_EXTL		(0x1 << 19)
+#define HOST_CTRL0_REFCLKSEL_CLKCORE		(0x2 << 19)
+
+#define HOST_CTRL0_FSEL_MASK			(0x7 << 16)
+#define HOST_CTRL0_FSEL(_x)			((_x) << 16)
+
+#define FSEL_CLKSEL_50M				(0x7)
+#define FSEL_CLKSEL_24M				(0x5)
+#define FSEL_CLKSEL_20M				(0x4)
+#define FSEL_CLKSEL_19200K			(0x3)
+#define FSEL_CLKSEL_12M				(0x2)
+#define FSEL_CLKSEL_10M				(0x1)
+#define FSEL_CLKSEL_9600K			(0x0)
+
+#define HOST_CTRL0_TESTBURNIN			(0x1 << 11)
+#define HOST_CTRL0_RETENABLE			(0x1 << 10)
+#define HOST_CTRL0_COMMONON_N			(0x1 << 9)
+#define HOST_CTRL0_SIDDQ			(0x1 << 6)
+#define HOST_CTRL0_FORCESLEEP			(0x1 << 5)
+#define HOST_CTRL0_FORCESUSPEND			(0x1 << 4)
+#define HOST_CTRL0_WORDINTERFACE		(0x1 << 3)
+#define HOST_CTRL0_UTMISWRST			(0x1 << 2)
+#define HOST_CTRL0_LINKSWRST			(0x1 << 1)
+#define HOST_CTRL0_PHYSWRST			(0x1 << 0)
+
+#define EXYNOS5_PHY_HOST_TUNE0			(0x04)
+
+#define EXYNOS5_PHY_HSIC_CTRL1			(0x10)
+
+#define EXYNOS5_PHY_HSIC_TUNE1			(0x14)
+
+#define EXYNOS5_PHY_HSIC_CTRL2			(0x20)
+
+#define EXYNOS5_PHY_HSIC_TUNE2			(0x24)
+
+#define HSIC_CTRL_REFCLKSEL_MASK		(0x3 << 23)
+#define HSIC_CTRL_REFCLKSEL			(0x2 << 23)
+
+#define HSIC_CTRL_REFCLKDIV_MASK		(0x7f << 16)
+#define HSIC_CTRL_REFCLKDIV(_x)			((_x) << 16)
+#define HSIC_CTRL_REFCLKDIV_12			(0x24 << 16)
+#define HSIC_CTRL_REFCLKDIV_15			(0x1c << 16)
+#define HSIC_CTRL_REFCLKDIV_16			(0x1a << 16)
+#define HSIC_CTRL_REFCLKDIV_19_2		(0x15 << 16)
+#define HSIC_CTRL_REFCLKDIV_20			(0x14 << 16)
+
+#define HSIC_CTRL_SIDDQ				(0x1 << 6)
+#define HSIC_CTRL_FORCESLEEP			(0x1 << 5)
+#define HSIC_CTRL_FORCESUSPEND			(0x1 << 4)
+#define HSIC_CTRL_WORDINTERFACE			(0x1 << 3)
+#define HSIC_CTRL_UTMISWRST			(0x1 << 2)
+#define HSIC_CTRL_PHYSWRST			(0x1 << 0)
+
+#define EXYNOS5_PHY_HOST_EHCICTRL		(0x30)
+
+#define HOST_EHCICTRL_ENAINCRXALIGN		(0x1 << 29)
+#define HOST_EHCICTRL_ENAINCR4			(0x1 << 28)
+#define HOST_EHCICTRL_ENAINCR8			(0x1 << 27)
+#define HOST_EHCICTRL_ENAINCR16			(0x1 << 26)
+
+#define EXYNOS5_PHY_HOST_OHCICTRL		(0x34)
+
+#define HOST_OHCICTRL_SUSPLGCY			(0x1 << 3)
+#define HOST_OHCICTRL_APPSTARTCLK		(0x1 << 2)
+#define HOST_OHCICTRL_CNTSEL			(0x1 << 1)
+#define HOST_OHCICTRL_CLKCKTRST			(0x1 << 0)
+
+#define EXYNOS5_PHY_OTG_SYS			(0x38)
+
+#define OTG_SYS_PHYLINK_SWRESET			(0x1 << 14)
+#define OTG_SYS_LINKSWRST_UOTG			(0x1 << 13)
+#define OTG_SYS_PHY0_SWRST			(0x1 << 12)
+
+#define OTG_SYS_REFCLKSEL_MASK			(0x3 << 9)
+#define OTG_SYS_REFCLKSEL_XTAL			(0x0 << 9)
+#define OTG_SYS_REFCLKSEL_EXTL			(0x1 << 9)
+#define OTG_SYS_REFCLKSEL_CLKCORE		(0x2 << 9)
+
+#define OTG_SYS_IDPULLUP_UOTG			(0x1 << 8)
+#define OTG_SYS_COMMON_ON			(0x1 << 7)
+
+#define OTG_SYS_FSEL_MASK			(0x7 << 4)
+#define OTG_SYS_FSEL(_x)			((_x) << 4)
+
+#define OTG_SYS_FORCESLEEP			(0x1 << 3)
+#define OTG_SYS_OTGDISABLE			(0x1 << 2)
+#define OTG_SYS_SIDDQ_UOTG			(0x1 << 1)
+#define OTG_SYS_FORCESUSPEND			(0x1 << 0)
+
+#define EXYNOS5_PHY_OTG_TUNE			(0x40)
+
+#ifndef MHZ
+#define MHZ (1000*1000)
+#endif
+
+#ifndef KHZ
+#define KHZ (1000)
+#endif
+
+#define EXYNOS_USBHOST_PHY_CTRL_OFFSET		(0x4)
+#define S3C64XX_USBPHY_ENABLE			(0x1 << 16)
+#define EXYNOS_USBPHY_ENABLE			(0x1 << 0)
+#define EXYNOS_USB20PHY_CFG_HOST_LINK		(0x1 << 0)
+
+enum samsung_cpu_type {
+	TYPE_S3C64XX,
+	TYPE_EXYNOS4210,
+	TYPE_EXYNOS5250,
+};
+
+/*
+ * struct samsung_usbphy_drvdata - driver data for various SoC variants
+ * @cpu_type: machine identifier
+ * @devphy_en_mask: device phy enable mask for PHY CONTROL register
+ * @hostphy_en_mask: host phy enable mask for PHY CONTROL register
+ * @devphy_reg_offset: offset to DEVICE PHY CONTROL register from
+ *		       mapped address of system controller.
+ * @hostphy_reg_offset: offset to HOST PHY CONTROL register from
+ *		       mapped address of system controller.
+ *
+ *	Here we have a separate mask for device type phy.
+ *	Having different masks for host and device type phy helps
+ *	in setting independent masks in case of SoCs like S5PV210,
+ *	in which PHY0 and PHY1 enable bits belong to same register
+ *	placed at position 0 and 1 respectively.
+ *	Although for newer SoCs like exynos these bits belong to
+ *	different registers altogether placed at position 0.
+ */
+struct samsung_usbphy_drvdata {
+	int cpu_type;
+	int devphy_en_mask;
+	int hostphy_en_mask;
+	u32 devphy_reg_offset;
+	u32 hostphy_reg_offset;
+};
+
+/*
+ * struct samsung_usbphy - transceiver driver state
+ * @phy: transceiver structure
+ * @plat: platform data
+ * @dev: The parent device supplied to the probe function
+ * @clk: usb phy clock
+ * @regs: usb phy controller registers memory base
+ * @pmuregs: USB device PHY_CONTROL register memory base
+ * @sysreg: USB2.0 PHY_CFG register memory base
+ * @ref_clk_freq: reference clock frequency selection
+ * @drv_data: driver data available for different SoCs
+ * @phy_type: Samsung SoCs specific phy types:	#HOST
+ *						#DEVICE
+ * @phy_usage: usage count for phy
+ * @lock: lock for phy operations
+ */
+struct samsung_usbphy {
+	struct usb_phy	phy;
+	struct samsung_usbphy_data *plat;
+	struct device	*dev;
+	struct clk	*clk;
+	void __iomem	*regs;
+	void __iomem	*pmuregs;
+	void __iomem	*sysreg;
+	int		ref_clk_freq;
+	const struct samsung_usbphy_drvdata *drv_data;
+	enum samsung_usb_phy_type phy_type;
+	atomic_t	phy_usage;
+	spinlock_t	lock;
+};
+
+#define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
+
+static const struct of_device_id samsung_usbphy_dt_match[];
+
+static inline const struct samsung_usbphy_drvdata
+*samsung_usbphy_get_driver_data(struct platform_device *pdev)
+{
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(samsung_usbphy_dt_match,
+							pdev->dev.of_node);
+		return match->data;
+	}
+
+	return (struct samsung_usbphy_drvdata *)
+				platform_get_device_id(pdev)->driver_data;
+}
+
+extern int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy);
+extern void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, bool on);
+extern void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy);
+extern int samsung_usbphy_set_type(struct usb_phy *phy,
+				enum samsung_usb_phy_type phy_type);
+extern int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy);
-- 
1.7.6.5

