Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab3AQDEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:04:04 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43479 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758552Ab3AQCyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:50 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 51/86] drivers/media: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:43 -0800
Message-Id: <1358391258-1771-52-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/platform/Kconfig       |    8 ++++----
 drivers/media/usb/dvb-usb-v2/Kconfig |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 3dcfea6..3324112 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -98,8 +98,8 @@ config VIDEO_OMAP2
 	  This is a v4l2 driver for the TI OMAP2 camera capture interface
 
 config VIDEO_OMAP3
-	tristate "OMAP 3 Camera support (EXPERIMENTAL)"
-	depends on OMAP_IOVMM && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3 && EXPERIMENTAL
+	tristate "OMAP 3 Camera support"
+	depends on OMAP_IOVMM && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
 	---help---
 	  Driver for an OMAP 3 camera controller.
 
@@ -169,8 +169,8 @@ config VIDEO_SAMSUNG_S5P_G2D
 	  2d graphics accelerator.
 
 config VIDEO_SAMSUNG_S5P_JPEG
-	tristate "Samsung S5P/Exynos4 JPEG codec driver (EXPERIMENTAL)"
-	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P && EXPERIMENTAL
+	tristate "Samsung S5P/Exynos4 JPEG codec driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 834bfec..7a622db 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -134,7 +134,7 @@ config DVB_USB_MXL111SF
 
 config DVB_USB_RTL28XXU
 	tristate "Realtek RTL28xxU DVB USB support"
-	depends on DVB_USB_V2 && EXPERIMENTAL
+	depends on DVB_USB_V2
 	select DVB_RTL2830
 	select DVB_RTL2832
 	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
-- 
1.7.9.5

