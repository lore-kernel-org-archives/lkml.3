Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab3DYR3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:29:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63252 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3DYR3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 20/21] USB: OMAP: ISP1301 needs USB_PHY
Date: Thu, 25 Apr 2013 19:29:03 +0200
Message-Id: <1366910944-3033663-21-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:gJfm+LdE9498SzbAP2dQbHA9jKnfPQSVwF+8ldOqUjP
 j0heciFOl4EbR2gxdZKBD0SaUGRn8XM37jGKlfMjv/SlYxAgrB
 8kMlXp4h/HjQJ4SaDTssFSXZXLlNJVpBOoDU0qmSh9+UqdaxPS
 sGueX5N/3+SCLx2uxkNPsOOcw7bKuWA9mC/svXzT52gtmZ/mZd
 /1qTht9DX9rRgdInR/uJKhEvC8olf6lmeCY4+DhbwO/r5pFf/D
 VQ/G3RV+sWSB6FBTPC6+PV8FU1pbJ3u/PvEI6djb1Hizbx3i27
 noSUghY9+7ivJZBsCAFC+bDz3jgPs7/DtI0eaUDR+nPV7xnF7c
 f8Mf6Nr5nA2ndu5GupmqDaUFGWVWK+jKTBucH7Ys5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for USB_OMAP unconditionally selects USB_ISP1301,
which is now only visible when USB_PHY is also enabled.

This adds an appropriate dependency and enables USB_PHY in the omap1
defconfig, avoiding these build warnings:

warning: (USB_OHCI_HCD && USB_OMAP) selects ISP1301_OMAP which has unmet direct dependencies (USB_SUPPORT && USB_PHY && I2C && ARCH_OMAP_OTG)

Also fix a Makefile typo while we're at it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>
---
 arch/arm/configs/omap1_defconfig | 1 +
 drivers/usb/gadget/Kconfig       | 1 +
 drivers/usb/phy/Makefile         | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index 2280d9d..a1ee534 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -196,6 +196,7 @@ CONFIG_SND_SOC=y
 CONFIG_SND_OMAP_SOC=y
 # CONFIG_USB_HID is not set
 CONFIG_USB=y
+CONFIG_USB_PHY=y
 CONFIG_USB_DEBUG=y
 CONFIG_USB_DEVICEFS=y
 # CONFIG_USB_DEVICE_CLASS is not set
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index f85b427..83300d9 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -196,6 +196,7 @@ config USB_FUSB300
 config USB_OMAP
 	tristate "OMAP USB Device Controller"
 	depends on ARCH_OMAP1
+	depends on USB_PHY
 	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4_OTG
 	help
 	   Many Texas Instruments OMAP processors have flexible full
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 33863c0..a9169cb 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_USB_PHY)			+= phy.o
 obj-$(CONFIG_AB8500_USB)		+= phy-ab8500-usb.o
 phy-fsl-usb2-objs			:= phy-fsl-usb.o phy-fsm-usb.o
 obj-$(CONFIG_FSL_USB2_OTG)		+= phy-fsl-usb2.o
-obj-$(CONFIG_ISP1301_OMAP)		+= phy-isp1301.omap.o
+obj-$(CONFIG_ISP1301_OMAP)		+= phy-isp1301-omap.o
 obj-$(CONFIG_MV_U3D_PHY)		+= phy-mv-u3d-usb.o
 obj-$(CONFIG_NOP_USB_XCEIV)		+= phy-nop.o
 obj-$(CONFIG_OMAP_CONTROL_USB)		+= phy-omap-control.o
-- 
1.8.1.2

