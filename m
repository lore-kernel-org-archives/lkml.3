Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab3DYRdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:33:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695Ab3DYR3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Roland Stigge <stigge@antcom.de>
Subject: [PATCH 19/21] USB: lpc32xx: ISP1301 needs USB_PHY
Date: Thu, 25 Apr 2013 19:29:02 +0200
Message-Id: <1366910944-3033663-20-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:D4LkYAlUVIFCIq0qFF2a5eNyv0xkP4yRWYcX8IGDQDy
 m3JSOH1PJcPorQrPU4m1CE+YybBiUsHNB7sjFdmi5Z4f4dQNN8
 Tfxg5snBhLFlnd/GiI86C/UMxmWeBBcUgCGirGGu4UaBz2LYll
 EaM4tj2kDf9ykrCJX3JKQP8SOAAZGYAgSk6RM0jnA5tuHDHd/s
 Bco/hyKbVnmwyZGB50Xe0z2i6lmS4L3k8qA5ZOp57gq1HVFPx9
 bqLX63kVF4p4TfA6jukV0pbXGbRsojHDNUwGiSAAtGaYiZSzkd
 3mFDQd1lQ0YJViX4wxEGQYHBLGV6OmlnkjsVHbWN7iFgqam5ki
 /EsNX/54DE4y+C0D66O0fnTZJ+ZNkAO7QM/aSkW31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for USB_LPC32XX unconditionally selects USB_ISP1301,
which is now only visible when USB_PHY is also enabled.

This adds an appropriate dependency and enables USB_PHY in the msm
defconfig, avoiding these build errors:

warning: (USB_LPC32XX) selects USB_ISP1301 which has unmet direct dependencies (USB_SUPPORT && USB_PHY && (USB || USB_GADGET) && I2C)
drivers/built-in.o: In function `usb_hcd_nxp_probe':
drivers/usb/host/ohci-nxp.c:224: undefined reference to `isp1301_get_client'
drivers/built-in.o: In function `lpc32xx_udc_probe':
drivers/usb/gadget/lpc32xx_udc.c:3071: undefined reference to `isp1301_get_client'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Roland Stigge <stigge@antcom.de>
---
 arch/arm/configs/lpc32xx_defconfig | 1 +
 drivers/usb/gadget/Kconfig         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/configs/lpc32xx_defconfig b/arch/arm/configs/lpc32xx_defconfig
index 8fee514..398a367 100644
--- a/arch/arm/configs/lpc32xx_defconfig
+++ b/arch/arm/configs/lpc32xx_defconfig
@@ -146,6 +146,7 @@ CONFIG_SND_DEBUG_VERBOSE=y
 # CONFIG_SND_SPI is not set
 CONFIG_SND_SOC=y
 CONFIG_USB=y
+CONFIG_USB_PHY=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_STORAGE=y
 CONFIG_USB_GADGET=y
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index a61d981..f85b427 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -144,6 +144,7 @@ config USB_AT91
 config USB_LPC32XX
 	tristate "LPC32XX USB Peripheral Controller"
 	depends on ARCH_LPC32XX
+	depends on USB_PHY
 	select USB_ISP1301
 	select USB_OTG_UTILS
 	help
-- 
1.8.1.2

