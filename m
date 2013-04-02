Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108Ab3DBSUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:20:38 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:51903 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760543Ab3DBSUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:20:34 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: tomi.valkeinen@ti.com
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv3 2/6] video: vt8500: Remove unused platform_data/video-vt8500lcdfb.h
Date: Wed,  3 Apr 2013 07:20:34 +1300
Message-Id: <1364926838-6721-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
References: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the conversion to devicetree only for arch-vt8500, this
header is no longer required. This patch removes the #include
from the two framebuffer drivers that used it, and the header file.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Reviewed-by: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
---
 drivers/video/vt8500lcdfb.c                     |    2 --
 drivers/video/wm8505fb.c                        |    2 --
 include/linux/platform_data/video-vt8500lcdfb.h |   31 -----------------------
 3 files changed, 35 deletions(-)
 delete mode 100644 include/linux/platform_data/video-vt8500lcdfb.h

diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index aa2579c..2ff2312 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -30,8 +30,6 @@
 #include <linux/platform_device.h>
 #include <linux/wait.h>
 
-#include <linux/platform_data/video-vt8500lcdfb.h>
-
 #include "vt8500lcdfb.h"
 #include "wmt_ge_rops.h"
 
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 4dd0580..fe9afd6 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -32,8 +32,6 @@
 #include <linux/of_fdt.h>
 #include <linux/memblock.h>
 
-#include <linux/platform_data/video-vt8500lcdfb.h>
-
 #include "wm8505fb_regs.h"
 #include "wmt_ge_rops.h"
 
diff --git a/include/linux/platform_data/video-vt8500lcdfb.h b/include/linux/platform_data/video-vt8500lcdfb.h
deleted file mode 100644
index 7f399c3..0000000
--- a/include/linux/platform_data/video-vt8500lcdfb.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- *  VT8500/WM8505 Frame Buffer platform data definitions
- *
- *  Copyright (C) 2010 Ed Spiridonov <edo.rus@gmail.com>
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
-#ifndef _VT8500FB_H
-#define _VT8500FB_H
-
-#include <linux/fb.h>
-
-struct vt8500fb_platform_data {
-	struct fb_videomode	mode;
-	u32			xres_virtual;
-	u32			yres_virtual;
-	u32			bpp;
-	unsigned long		video_mem_phys;
-	void			*video_mem_virt;
-	unsigned long		video_mem_len;
-};
-
-#endif /* _VT8500FB_H */
-- 
1.7.9.5

