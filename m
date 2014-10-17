Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaJQNOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:14:43 -0400
Received: from mail.logicbricks.com ([89.201.165.134]:17285 "EHLO
	mail.logicbricks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaJQNM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:12:56 -0400
From: Davor Joja <davorjoja@logicbricks.com>
To: <linux-kernel@vger.kernel.org>
CC: Davor Joja <davorjoja@logicbricks.com>
Subject: [PATCH 06/10] fbdev: xylon: Framebuffer driver kernel and make configuration
Date: Fri, 17 Oct 2014 15:06:57 +0200
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413551221-15187-1-git-send-email-davorjoja@logicbricks.com>
References: <1413551221-15187-1-git-send-email-davorjoja@logicbricks.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.0.95]
Message-ID: <b471b4a8-074e-4cea-8be0-630d4f75b7bf@mail.xylon.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver kernel and build configuration.

Signed-off-by: Davor Joja <davorjoja@logicbricks.com>
---
 drivers/video/fbdev/xylon/Kconfig  | 31 +++++++++++++++++++++++++++++++
 drivers/video/fbdev/xylon/Makefile |  3 +++
 2 files changed, 34 insertions(+)
 create mode 100644 drivers/video/fbdev/xylon/Kconfig
 create mode 100644 drivers/video/fbdev/xylon/Makefile

diff --git a/drivers/video/fbdev/xylon/Kconfig b/drivers/video/fbdev/xylon/Kconfig
new file mode 100644
index 0000000..74278ad
--- /dev/null
+++ b/drivers/video/fbdev/xylon/Kconfig
@@ -0,0 +1,31 @@
+menuconfig FB_XYLON
+	tristate "Xylon logiCVC frame buffer support"
+	depends on FB
+	default n
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_MODE_HELPERS
+	select VIDEOMODE_HELPERS
+	help
+	  Choose this option if you want to use the Xylon logiCVC as frame
+	  buffer device. Without the support of PCI & AGP.
+
+config FB_XYLON_PIXCLK
+	bool "Xylon logiCVC pixel clock"
+	depends on FB_XYLON
+	default n
+	help
+	  logiCVC pixel clock generated from:
+	  - External generator not controllable by Xylon framebuffer driver
+	    This is default selection.
+	  - Generators controllable by Xylon framebuffer driver
+
+config FB_XYLON_PIXCLK_LOGICLK
+	bool "Xylon logiCLK pixel clock generator"
+	depends on FB_XYLON && FB_XYLON_PIXCLK
+	default n
+	select COMMON_CLK_LOGICLK
+	help
+	  Support for controlling pixel clock generation from
+	  Xylon logiCLK FGPA IP core.
diff --git a/drivers/video/fbdev/xylon/Makefile b/drivers/video/fbdev/xylon/Makefile
new file mode 100644
index 0000000..3baa96a
--- /dev/null
+++ b/drivers/video/fbdev/xylon/Makefile
@@ -0,0 +1,3 @@
+xylonfb-y := xylonfb_main.o xylonfb_core.o xylonfb_ioctl.o xylonfb_pixclk.o
+
+obj-$(CONFIG_FB_XYLON) += xylonfb.o
-- 
1.9.1

