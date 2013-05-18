Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3ERJPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 05:15:43 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:51380 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3ERJPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 05:15:17 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 1/4] fb: vt8500: Move register defines inside driver
Date: Sat, 18 May 2013 21:15:11 +1200
Message-Id: <1368868514-18975-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368868514-18975-1-git-send-email-linux@prisktech.co.nz>
References: <1368868514-18975-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The #defines in wm8505fb_regs.h are only used in the wm8505fb driver,
and don't need to be visible outside.

Move the defines into the driver and remove the header.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/video/wm8505fb.c      |   25 +++++++++++++-
 drivers/video/wm8505fb_regs.h |   76 -----------------------------------------
 2 files changed, 24 insertions(+), 77 deletions(-)
 delete mode 100644 drivers/video/wm8505fb_regs.h

diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 01f9ace..f824af8 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -34,11 +34,34 @@
 #include <linux/wait.h>
 #include <video/of_display_timing.h>
 
-#include "wm8505fb_regs.h"
 #include "wmt_ge_rops.h"
 
 #define DRIVER_NAME "wm8505-fb"
 
+#define WMT_GOVR_COLORSPACE1	0x030
+#define WMT_GOVR_MIF_ENABLE	0x080
+#define WMT_GOVR_FBADDR		0x090
+#define WMT_GOVR_FBADDR1	0x094
+#define WMT_GOVR_XRES		0x098
+#define WMT_GOVR_XRES_VIRTUAL	0x09c
+#define WMT_GOVR_YPAN		0x0a0
+#define WMT_GOVR_XPAN		0x0a4
+#define WMT_GOVR_FHI		0x0a8
+#define WMT_GOVR_REG_UPDATE	0x0e4
+#define WMT_GOVR_TG		0x100
+#define WMT_GOVR_TIMING_H_ALL	0x108
+#define WMT_GOVR_TIMING_V_ALL	0x10c
+#define WMT_GOVR_TIMING_V_START	0x110
+#define WMT_GOVR_TIMING_V_END	0x114
+#define WMT_GOVR_TIMING_H_START	0x118
+#define WMT_GOVR_TIMING_H_END	0x11c
+#define WMT_GOVR_TIMING_V_SYNC	0x128
+#define WMT_GOVR_TIMING_H_SYNC	0x12c
+#define WMT_GOVR_DVO_SET	0x148
+#define WMT_GOVR_CONTRAST	0x1b8
+#define WMT_GOVR_BRGHTNESS	0x1bc
+#define WMT_GOVR_COLORSPACE	0x1e4
+
 #define to_wm8505fb_info(__info) container_of(__info, \
 						struct wm8505fb_info, fb)
 struct wm8505fb_info {
diff --git a/drivers/video/wm8505fb_regs.h b/drivers/video/wm8505fb_regs.h
deleted file mode 100644
index 4dd4166..0000000
--- a/drivers/video/wm8505fb_regs.h
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- *  GOVR registers list for WM8505 chips
- *
- *  Copyright (C) 2010 Ed Spiridonov <edo.rus@gmail.com>
- *   Based on VIA/WonderMedia wm8510-govrh-reg.h
- *   http://github.com/projectgus/kernel_wm8505/blob/wm8505_2.6.29/
- *         drivers/video/wmt/register/wm8510/wm8510-govrh-reg.h
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef _WM8505FB_REGS_H
-#define _WM8505FB_REGS_H
-
-/*
- * Color space select register, default value 0x1c
- *   BIT0 GOVRH_DVO_YUV2RGB_ENABLE
- *   BIT1 GOVRH_VGA_YUV2RGB_ENABLE
- *   BIT2 GOVRH_RGB_MODE
- *   BIT3 GOVRH_DAC_CLKINV
- *   BIT4 GOVRH_BLANK_ZERO
- */
-#define WMT_GOVR_COLORSPACE	0x1e4
-/*
- * Another colorspace select register, default value 1
- *   BIT0 GOVRH_DVO_RGB
- *   BIT1 GOVRH_DVO_YUV422
- */
-#define WMT_GOVR_COLORSPACE1	 0x30
-
-#define WMT_GOVR_CONTRAST	0x1b8
-#define WMT_GOVR_BRGHTNESS	0x1bc /* incompatible with RGB? */
-
-/* Framubeffer address */
-#define WMT_GOVR_FBADDR		 0x90
-#define WMT_GOVR_FBADDR1	 0x94 /* UV offset in YUV mode */
-
-/* Offset of visible window */
-#define WMT_GOVR_XPAN		 0xa4
-#define WMT_GOVR_YPAN		 0xa0
-
-#define WMT_GOVR_XRES		 0x98
-#define WMT_GOVR_XRES_VIRTUAL	 0x9c
-
-#define WMT_GOVR_MIF_ENABLE	 0x80
-#define WMT_GOVR_FHI		 0xa8
-#define WMT_GOVR_REG_UPDATE	 0xe4
-
-/*
- *   BIT0 GOVRH_DVO_OUTWIDTH
- *   BIT1 GOVRH_DVO_SYNC_POLAR
- *   BIT2 GOVRH_DVO_ENABLE
- */
-#define WMT_GOVR_DVO_SET	0x148
-
-/* Timing generator? */
-#define WMT_GOVR_TG		0x100
-
-/* Timings */
-#define WMT_GOVR_TIMING_H_ALL	0x108
-#define WMT_GOVR_TIMING_V_ALL	0x10c
-#define WMT_GOVR_TIMING_V_START	0x110
-#define WMT_GOVR_TIMING_V_END	0x114
-#define WMT_GOVR_TIMING_H_START	0x118
-#define WMT_GOVR_TIMING_H_END	0x11c
-#define WMT_GOVR_TIMING_V_SYNC	0x128
-#define WMT_GOVR_TIMING_H_SYNC	0x12c
-
-#endif /* _WM8505FB_REGS_H */
-- 
1.7.9.5

