Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3LCOJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:09:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52406 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3LCOJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:09:28 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <linux@arm.linux.org.uk>
CC: <santosh.shilimkar@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] phy: kconfig: add depends on "USB_PHY" to OMAP_USB2 and TWL4030_USB
Date: Tue, 3 Dec 2013 19:38:52 +0530
Message-ID: <1386079732-19657-1-git-send-email-kishon@ti.com>
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

Reported-by: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
Changes from v1:
* changed from *depends on USB_SUPPORT* to *depends on USB_PHY" and
also changed the subject.
 drivers/phy/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index a344f3d..330ef2d 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -24,8 +24,8 @@ config PHY_EXYNOS_MIPI_VIDEO
 config OMAP_USB2
 	tristate "OMAP USB2 PHY Driver"
 	depends on ARCH_OMAP2PLUS
+	depends on USB_PHY
 	select GENERIC_PHY
-	select USB_PHY
 	select OMAP_CONTROL_USB
 	help
 	  Enable this to support the transceiver that is part of SOC. This
@@ -36,8 +36,8 @@ config OMAP_USB2
 config TWL4030_USB
 	tristate "TWL4030 USB Transceiver Driver"
 	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
+	depends on USB_PHY
 	select GENERIC_PHY
-	select USB_PHY
 	help
 	  Enable this to support the USB OTG transceiver on TWL4030
 	  family chips (including the TWL5030 and TPS659x0 devices).
-- 
1.7.10.4

