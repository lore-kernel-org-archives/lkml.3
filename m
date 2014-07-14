Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaGNKMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:12:48 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59812 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaGNKMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:12:41 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kishon@ti.com, dianders@chromium.org,
        gautam.vivek@samsung.com, spk.linux@gmail.com
Subject: [PATCH v3 1/2] phy: Kconfig: Re-organize Exynos USB 2.0 PHY configs
Date: Mon, 14 Jul 2014 15:38:41 +0530
Message-Id: <1405332522-6162-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the USB 2.0 PHYs are required with EHCI/OHCI USB drivers and
USB gadget controller supported by the DWC2 gadget driver, make it
depend on them and default to ARCH_EXYNOS as they are meant for
Exynos platforms. Also, make the sub-drivers silent options enabling
them based on the SoC platforms that they are meant to work with. This
will make life easier for end users who do not have any way knowing the
dependencies.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v3:
* Rebased the series on top of latest PHY tree [1].
[1] git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git
---
 drivers/phy/Kconfig |   35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 5fceb33..c412ca4 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -132,43 +132,30 @@ config PHY_SUN4I_USB
 config PHY_SAMSUNG_USB2
 	tristate "Samsung USB 2.0 PHY driver"
 	depends on HAS_IOMEM
+	depends on USB_EHCI_EXYNOS || USB_OHCI_EXYNOS || USB_DWC2
 	select GENERIC_PHY
 	select MFD_SYSCON
+	default ARCH_EXYNOS
 	help
 	  Enable this to support the Samsung USB 2.0 PHY driver for Samsung
-	  SoCs. This driver provides the interface for USB 2.0 PHY. Support for
-	  particular SoCs has to be enabled in addition to this driver. Number
-	  and type of supported phys depends on the SoC.
+	  SoCs. This driver provides the interface for USB 2.0 PHY. Support
+	  for particular PHYs will be enabled based on the SoC type in addition
+	  to this driver.
 
 config PHY_EXYNOS4210_USB2
-	bool "Support for Exynos 4210"
+	bool
 	depends on PHY_SAMSUNG_USB2
-	depends on CPU_EXYNOS4210
-	help
-	  Enable USB PHY support for Exynos 4210. This option requires that
-	  Samsung USB 2.0 PHY driver is enabled and means that support for this
-	  particular SoC is compiled in the driver. In case of Exynos 4210 four
-	  phys are available - device, host, HSIC0 and HSIC1.
+	default CPU_EXYNOS4210
 
 config PHY_EXYNOS4X12_USB2
-	bool "Support for Exynos 3250/4x12"
+	bool
 	depends on PHY_SAMSUNG_USB2
-	depends on (SOC_EXYNOS3250 || SOC_EXYNOS4212 || SOC_EXYNOS4412)
-	help
-	  Enable USB PHY support for Exynos 3250/4x12. This option requires
-	  that Samsung USB 2.0 PHY driver is enabled and means that support for
-	  this particular SoC is compiled in the driver. In case of Exynos 4x12
-	  four phys are available - device, host, HSIC0 and HSIC1.
+	default SOC_EXYNOS3250 || SOC_EXYNOS4212 || SOC_EXYNOS4412
 
 config PHY_EXYNOS5250_USB2
-	bool "Support for Exynos 5250"
+	bool
 	depends on PHY_SAMSUNG_USB2
-	depends on SOC_EXYNOS5250
-	help
-	  Enable USB PHY support for Exynos 5250. This option requires that
-	  Samsung USB 2.0 PHY driver is enabled and means that support for this
-	  particular SoC is compiled in the driver. In case of Exynos 5250 four
-	  phys are available - device, host, HSIC0 and HSIC.
+	default SOC_EXYNOS5250 || SOC_EXYNOS5420
 
 config PHY_EXYNOS5_USBDRD
 	tristate "Exynos5 SoC series USB DRD PHY driver"
-- 
1.7.9.5

