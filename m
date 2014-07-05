Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbaGEMde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:33:34 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57612 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaGEMdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:33:32 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Joe Perches <joe@perches.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: neofb.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:34:48 +0200
Message-Id: <1404563688-20603-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/neofb.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/video/fbdev/neofb.c b/drivers/video/fbdev/neofb.c
index 44f99a6..b1779ae 100644
--- a/drivers/video/fbdev/neofb.c
+++ b/drivers/video/fbdev/neofb.c
@@ -701,8 +701,6 @@ neofb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	if (memlen > vramlen) {
 		var->yres_virtual =  vramlen * 8 / (var->xres_virtual *
 				   	var->bits_per_pixel);
-		memlen = var->xres_virtual * var->bits_per_pixel *
-				var->yres_virtual / 8;
 	}
 
 	/* we must round yres/xres down, we already rounded y/xres_virtual up
@@ -1855,7 +1853,6 @@ static int neo_init_hw(struct fb_info *info)
 	struct neofb_par *par = info->par;
 	int videoRam = 896;
 	int maxClock = 65000;
-	int CursorMem = 1024;
 	int CursorOff = 0x100;
 
 	DBG("neo_init_hw");
@@ -1907,19 +1904,16 @@ static int neo_init_hw(struct fb_info *info)
 	case FB_ACCEL_NEOMAGIC_NM2070:
 	case FB_ACCEL_NEOMAGIC_NM2090:
 	case FB_ACCEL_NEOMAGIC_NM2093:
-		CursorMem = 2048;
 		CursorOff = 0x100;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2097:
 	case FB_ACCEL_NEOMAGIC_NM2160:
-		CursorMem = 1024;
 		CursorOff = 0x100;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2200:
 	case FB_ACCEL_NEOMAGIC_NM2230:
 	case FB_ACCEL_NEOMAGIC_NM2360:
 	case FB_ACCEL_NEOMAGIC_NM2380:
-		CursorMem = 1024;
 		CursorOff = 0x1000;
 
 		par->neo2200 = (Neo2200 __iomem *) par->mmio_vbase;
-- 
1.7.10.4

