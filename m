Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3AURRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:17:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51282 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab3AURQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:16:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 12/15] USB: gadget/freescale: disable non-multiplatform drivers
Date: Mon, 21 Jan 2013 17:16:05 +0000
Message-Id: <1358788568-11137-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:WdL7dgwuk9U5HnounbbKvrzHsWPumyeOcVysJGvKuv2
 1PWA1QkK9gSow5FwrxAmYxHcj9REepJ2JUexsOVPaAnGBW2MaE
 jNI1z1I9q1n5g/byNBPW+cP87C1dQHJz7tFSIJU/taiz7wuRjW
 YfJYa+3J6qIgffI4PW05HMEcAA1wFq9Tue3TfDID0QGvHV374A
 6tGh0MWVvrfBzPg78L9KJEHJTRDWg3Ie9xJYzbOeRxia8VIV02
 CofzKtV2m4ANwAzyJOvij3BIXSvkXD9bzhkdBuMGM8vJC4rGpu
 6jJQYmJl4C+vpPCdZEauOVo8ij1xdH7BoCCbUUJSkbSNVr+2eR
 C8s/velzklFcmpy7eiNx7ZiAFwMGgPlDXkf/xwKkr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both the fsl_mxc gadget and the imx_udc gadget drivers fail to build
without the mach/hardware.h file that is not available when building
for multiplatform. Let's disable these drivers for v3.8 in combination
with CONFIG_ARCH_MULTIPLATFORM, and fix them properly in v3.9 unless
someone has an better solution.

Without this patch, building allyesconfig results in:

drivers/usb/gadget/fsl_mxc_udc.c:21:27: fatal error: mach/hardware.h: No such file or directory

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/gadget/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 14625fd..ca57a6d 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -173,6 +173,7 @@ config USB_BCM63XX_UDC
 config USB_FSL_USB2
 	tristate "Freescale Highspeed USB DR Peripheral Controller"
 	depends on FSL_SOC || ARCH_MXC
+	depends on !ARCH_MULTIPLATFORM
 	select USB_FSL_MPH_DR_OF if OF
 	help
 	   Some of Freescale PowerPC and i.MX processors have a High Speed
@@ -280,7 +281,7 @@ config USB_S3C_HSOTG
 
 config USB_IMX
 	tristate "Freescale i.MX1 USB Peripheral Controller"
-	depends on ARCH_MXC
+	depends on ARCH_MXC && !ARCH_MULTIPLATFORM
 	help
 	   Freescale's i.MX1 includes an integrated full speed
 	   USB 1.1 device controller.
-- 
1.7.10.4

