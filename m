Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaB0Lzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:55:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50199 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbaB0Lzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:55:43 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Airlie <airlied@linux.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 2/3] fbdev: move fbdev core files to separate directory
Date: Thu, 27 Feb 2014 13:54:45 +0200
Message-ID: <1393502086-9433-3-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com>
References: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of having fbdev framework core files at the root fbdev
directory, mixed with random fbdev device drivers, move the fbdev core
files to a separate core directory. This makes it much clearer which of
the files are actually part of the fbdev framework, and which are part
of device drivers.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Rob Clark <robdclark@gmail.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/fbdev/Makefile                 | 16 +---------------
 drivers/video/fbdev/core/Makefile            | 16 ++++++++++++++++
 drivers/video/fbdev/{ => core}/cfbcopyarea.c |  0
 drivers/video/fbdev/{ => core}/cfbfillrect.c |  0
 drivers/video/fbdev/{ => core}/cfbimgblt.c   |  0
 drivers/video/fbdev/{ => core}/fb_ddc.c      |  2 +-
 drivers/video/fbdev/{ => core}/fb_defio.c    |  0
 drivers/video/fbdev/{ => core}/fb_draw.h     |  0
 drivers/video/fbdev/{ => core}/fb_notify.c   |  0
 drivers/video/fbdev/{ => core}/fb_sys_fops.c |  0
 drivers/video/fbdev/{ => core}/fbcmap.c      |  0
 drivers/video/fbdev/{ => core}/fbcvt.c       |  0
 drivers/video/fbdev/{ => core}/fbmem.c       |  0
 drivers/video/fbdev/{ => core}/fbmon.c       |  2 +-
 drivers/video/fbdev/{ => core}/fbsysfs.c     |  0
 drivers/video/fbdev/{ => core}/modedb.c      |  0
 drivers/video/fbdev/{ => core}/svgalib.c     |  0
 drivers/video/fbdev/{ => core}/syscopyarea.c |  0
 drivers/video/fbdev/{ => core}/sysfillrect.c |  0
 drivers/video/fbdev/{ => core}/sysimgblt.c   |  0
 drivers/video/fbdev/wmt_ge_rops.c            |  2 +-
 21 files changed, 20 insertions(+), 18 deletions(-)
 create mode 100644 drivers/video/fbdev/core/Makefile
 rename drivers/video/fbdev/{ => core}/cfbcopyarea.c (100%)
 rename drivers/video/fbdev/{ => core}/cfbfillrect.c (100%)
 rename drivers/video/fbdev/{ => core}/cfbimgblt.c (100%)
 rename drivers/video/fbdev/{ => core}/fb_ddc.c (99%)
 rename drivers/video/fbdev/{ => core}/fb_defio.c (100%)
 rename drivers/video/fbdev/{ => core}/fb_draw.h (100%)
 rename drivers/video/fbdev/{ => core}/fb_notify.c (100%)
 rename drivers/video/fbdev/{ => core}/fb_sys_fops.c (100%)
 rename drivers/video/fbdev/{ => core}/fbcmap.c (100%)
 rename drivers/video/fbdev/{ => core}/fbcvt.c (100%)
 rename drivers/video/fbdev/{ => core}/fbmem.c (100%)
 rename drivers/video/fbdev/{ => core}/fbmon.c (99%)
 rename drivers/video/fbdev/{ => core}/fbsysfs.c (100%)
 rename drivers/video/fbdev/{ => core}/modedb.c (100%)
 rename drivers/video/fbdev/{ => core}/svgalib.c (100%)
 rename drivers/video/fbdev/{ => core}/syscopyarea.c (100%)
 rename drivers/video/fbdev/{ => core}/sysfillrect.c (100%)
 rename drivers/video/fbdev/{ => core}/sysimgblt.c (100%)

diff --git a/drivers/video/fbdev/Makefile b/drivers/video/fbdev/Makefile
index 616e0975ae6e..6ef2c66110e3 100644
--- a/drivers/video/fbdev/Makefile
+++ b/drivers/video/fbdev/Makefile
@@ -4,25 +4,11 @@
 
 # Each configuration option enables a list of files.
 
-obj-y                             += fb_notify.o
-obj-$(CONFIG_FB)                  += fb.o
-fb-y                              := fbmem.o fbmon.o fbcmap.o fbsysfs.o \
-                                     modedb.o fbcvt.o
-fb-objs                           := $(fb-y)
+obj-y				+= core/
 
 obj-$(CONFIG_EXYNOS_VIDEO)     += exynos/
 
-obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
-obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o
-obj-$(CONFIG_FB_CFB_IMAGEBLIT) += cfbimgblt.o
-obj-$(CONFIG_FB_SYS_FILLRECT)  += sysfillrect.o
-obj-$(CONFIG_FB_SYS_COPYAREA)  += syscopyarea.o
-obj-$(CONFIG_FB_SYS_IMAGEBLIT) += sysimgblt.o
-obj-$(CONFIG_FB_SYS_FOPS)      += fb_sys_fops.o
-obj-$(CONFIG_FB_SVGALIB)       += svgalib.o
 obj-$(CONFIG_FB_MACMODES)      += macmodes.o
-obj-$(CONFIG_FB_DDC)           += fb_ddc.o
-obj-$(CONFIG_FB_DEFERRED_IO)   += fb_defio.o
 obj-$(CONFIG_FB_WMT_GE_ROPS)   += wmt_ge_rops.o
 
 # Hardware specific drivers go first
diff --git a/drivers/video/fbdev/core/Makefile b/drivers/video/fbdev/core/Makefile
new file mode 100644
index 000000000000..fa306538dac2
--- /dev/null
+++ b/drivers/video/fbdev/core/Makefile
@@ -0,0 +1,16 @@
+obj-y                             += fb_notify.o
+obj-$(CONFIG_FB)                  += fb.o
+fb-y                              := fbmem.o fbmon.o fbcmap.o fbsysfs.o \
+                                     modedb.o fbcvt.o
+fb-objs                           := $(fb-y)
+
+obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
+obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o
+obj-$(CONFIG_FB_CFB_IMAGEBLIT) += cfbimgblt.o
+obj-$(CONFIG_FB_SYS_FILLRECT)  += sysfillrect.o
+obj-$(CONFIG_FB_SYS_COPYAREA)  += syscopyarea.o
+obj-$(CONFIG_FB_SYS_IMAGEBLIT) += sysimgblt.o
+obj-$(CONFIG_FB_SYS_FOPS)      += fb_sys_fops.o
+obj-$(CONFIG_FB_SVGALIB)       += svgalib.o
+obj-$(CONFIG_FB_DDC)           += fb_ddc.o
+obj-$(CONFIG_FB_DEFERRED_IO)   += fb_defio.o
diff --git a/drivers/video/fbdev/cfbcopyarea.c b/drivers/video/fbdev/core/cfbcopyarea.c
similarity index 100%
rename from drivers/video/fbdev/cfbcopyarea.c
rename to drivers/video/fbdev/core/cfbcopyarea.c
diff --git a/drivers/video/fbdev/cfbfillrect.c b/drivers/video/fbdev/core/cfbfillrect.c
similarity index 100%
rename from drivers/video/fbdev/cfbfillrect.c
rename to drivers/video/fbdev/core/cfbfillrect.c
diff --git a/drivers/video/fbdev/cfbimgblt.c b/drivers/video/fbdev/core/cfbimgblt.c
similarity index 100%
rename from drivers/video/fbdev/cfbimgblt.c
rename to drivers/video/fbdev/core/cfbimgblt.c
diff --git a/drivers/video/fbdev/fb_ddc.c b/drivers/video/fbdev/core/fb_ddc.c
similarity index 99%
rename from drivers/video/fbdev/fb_ddc.c
rename to drivers/video/fbdev/core/fb_ddc.c
index 2b106f046fde..94322ccfedde 100644
--- a/drivers/video/fbdev/fb_ddc.c
+++ b/drivers/video/fbdev/core/fb_ddc.c
@@ -15,7 +15,7 @@
 #include <linux/i2c-algo-bit.h>
 #include <linux/slab.h>
 
-#include "edid.h"
+#include "../edid.h"
 
 #define DDC_ADDR	0x50
 
diff --git a/drivers/video/fbdev/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
similarity index 100%
rename from drivers/video/fbdev/fb_defio.c
rename to drivers/video/fbdev/core/fb_defio.c
diff --git a/drivers/video/fbdev/fb_draw.h b/drivers/video/fbdev/core/fb_draw.h
similarity index 100%
rename from drivers/video/fbdev/fb_draw.h
rename to drivers/video/fbdev/core/fb_draw.h
diff --git a/drivers/video/fbdev/fb_notify.c b/drivers/video/fbdev/core/fb_notify.c
similarity index 100%
rename from drivers/video/fbdev/fb_notify.c
rename to drivers/video/fbdev/core/fb_notify.c
diff --git a/drivers/video/fbdev/fb_sys_fops.c b/drivers/video/fbdev/core/fb_sys_fops.c
similarity index 100%
rename from drivers/video/fbdev/fb_sys_fops.c
rename to drivers/video/fbdev/core/fb_sys_fops.c
diff --git a/drivers/video/fbdev/fbcmap.c b/drivers/video/fbdev/core/fbcmap.c
similarity index 100%
rename from drivers/video/fbdev/fbcmap.c
rename to drivers/video/fbdev/core/fbcmap.c
diff --git a/drivers/video/fbdev/fbcvt.c b/drivers/video/fbdev/core/fbcvt.c
similarity index 100%
rename from drivers/video/fbdev/fbcvt.c
rename to drivers/video/fbdev/core/fbcvt.c
diff --git a/drivers/video/fbdev/fbmem.c b/drivers/video/fbdev/core/fbmem.c
similarity index 100%
rename from drivers/video/fbdev/fbmem.c
rename to drivers/video/fbdev/core/fbmem.c
diff --git a/drivers/video/fbdev/fbmon.c b/drivers/video/fbdev/core/fbmon.c
similarity index 99%
rename from drivers/video/fbdev/fbmon.c
rename to drivers/video/fbdev/core/fbmon.c
index 6103fa6fb54f..c204ebe6187e 100644
--- a/drivers/video/fbdev/fbmon.c
+++ b/drivers/video/fbdev/core/fbmon.c
@@ -37,7 +37,7 @@
 #include <asm/prom.h>
 #include <asm/pci-bridge.h>
 #endif
-#include "edid.h"
+#include "../edid.h"
 
 /*
  * EDID parser
diff --git a/drivers/video/fbdev/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
similarity index 100%
rename from drivers/video/fbdev/fbsysfs.c
rename to drivers/video/fbdev/core/fbsysfs.c
diff --git a/drivers/video/fbdev/modedb.c b/drivers/video/fbdev/core/modedb.c
similarity index 100%
rename from drivers/video/fbdev/modedb.c
rename to drivers/video/fbdev/core/modedb.c
diff --git a/drivers/video/fbdev/svgalib.c b/drivers/video/fbdev/core/svgalib.c
similarity index 100%
rename from drivers/video/fbdev/svgalib.c
rename to drivers/video/fbdev/core/svgalib.c
diff --git a/drivers/video/fbdev/syscopyarea.c b/drivers/video/fbdev/core/syscopyarea.c
similarity index 100%
rename from drivers/video/fbdev/syscopyarea.c
rename to drivers/video/fbdev/core/syscopyarea.c
diff --git a/drivers/video/fbdev/sysfillrect.c b/drivers/video/fbdev/core/sysfillrect.c
similarity index 100%
rename from drivers/video/fbdev/sysfillrect.c
rename to drivers/video/fbdev/core/sysfillrect.c
diff --git a/drivers/video/fbdev/sysimgblt.c b/drivers/video/fbdev/core/sysimgblt.c
similarity index 100%
rename from drivers/video/fbdev/sysimgblt.c
rename to drivers/video/fbdev/core/sysimgblt.c
diff --git a/drivers/video/fbdev/wmt_ge_rops.c b/drivers/video/fbdev/wmt_ge_rops.c
index b0a9f34b2e01..9df6fe78a44b 100644
--- a/drivers/video/fbdev/wmt_ge_rops.c
+++ b/drivers/video/fbdev/wmt_ge_rops.c
@@ -18,7 +18,7 @@
 #include <linux/module.h>
 #include <linux/fb.h>
 #include <linux/platform_device.h>
-#include "fb_draw.h"
+#include "core/fb_draw.h"
 
 #define GE_COMMAND_OFF		0x00
 #define GE_DEPTH_OFF		0x04
-- 
1.8.3.2

