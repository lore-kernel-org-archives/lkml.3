Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab3KZKCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:02:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58637 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab3KZKCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:02:33 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <linux@arm.linux.org.uk>
CC: <santosh.shilimkar@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] phy: kconfig: add depends on "USB_SUPPORT" to OMAP_USB2 and TWL4030_USB
Date: Tue, 26 Nov 2013 15:31:55 +0530
Message-ID: <1385460115-31194-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes
warning: (OMAP_USB2 && TWL4030_USB) selects USB_PHY which has unmet
direct dependencies (USB_SUPPORT)
that shows up while disabling USB_SUPPORT from menuconfig.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index a344f3d..0c87e4c 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -24,6 +24,7 @@ config PHY_EXYNOS_MIPI_VIDEO
 config OMAP_USB2
 	tristate "OMAP USB2 PHY Driver"
 	depends on ARCH_OMAP2PLUS
+	depends on USB_SUPPORT
 	select GENERIC_PHY
 	select USB_PHY
 	select OMAP_CONTROL_USB
@@ -36,6 +37,7 @@ config OMAP_USB2
 config TWL4030_USB
 	tristate "TWL4030 USB Transceiver Driver"
 	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
+	depends on USB_SUPPORT
 	select GENERIC_PHY
 	select USB_PHY
 	help
-- 
1.7.10.4

