Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab3AONbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:31:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58867 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab3AONbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:31:05 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 04/10] video: da8xx-fb: remove unneeded "var" initialization
Date: Tue, 15 Jan 2013 19:01:55 +0530
Message-ID: <03ef2f9478704988f0240b55da8243879ac579f3.1358250489.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1358250489.git.afzal@ti.com>
References: <cover.1358250489.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modedb helper now updates "var" information based on the detected
panel, remove the unnecessary initialization.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/video/da8xx-fb.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index a1f6544..18834fa 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -131,10 +131,6 @@
 
 #define WSI_TIMEOUT	50
 #define PALETTE_SIZE	256
-#define LEFT_MARGIN	64
-#define RIGHT_MARGIN	64
-#define UPPER_MARGIN	32
-#define LOWER_MARGIN	32
 
 static void __iomem *da8xx_fb_reg_base;
 static struct resource *lcdc_regs;
@@ -184,23 +180,7 @@ struct da8xx_fb_par {
 	u32 pseudo_palette[16];
 };
 
-/* Variable Screen Information */
-static struct fb_var_screeninfo da8xx_fb_var = {
-	.xoffset = 0,
-	.yoffset = 0,
-	.transp = {0, 0, 0},
-	.nonstd = 0,
-	.activate = 0,
-	.height = -1,
-	.width = -1,
-	.accel_flags = 0,
-	.left_margin = LEFT_MARGIN,
-	.right_margin = RIGHT_MARGIN,
-	.upper_margin = UPPER_MARGIN,
-	.lower_margin = LOWER_MARGIN,
-	.sync = 0,
-	.vmode = FB_VMODE_NONINTERLACED
-};
+static struct fb_var_screeninfo da8xx_fb_var;
 
 static struct fb_fix_screeninfo da8xx_fb_fix = {
 	.id = "DA8xx FB Drv",
-- 
1.7.9.5

