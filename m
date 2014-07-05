Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaGEMMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:12:00 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:42426 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbaGEML6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:11:58 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: amifb.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:13:13 +0200
Message-Id: <1404562393-18641-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
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
 drivers/video/fbdev/amifb.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/video/fbdev/amifb.c b/drivers/video/fbdev/amifb.c
index 518f790..19ed1fa 100644
--- a/drivers/video/fbdev/amifb.c
+++ b/drivers/video/fbdev/amifb.c
@@ -1124,7 +1124,6 @@ static int ami_decode_var(struct fb_var_screeninfo *var, struct amifb_par *par,
 {
 	u_short clk_shift, line_shift;
 	u_long maxfetchstop, fstrt, fsize, fconst, xres_n, yres_n;
-	u_int htotal, vtotal;
 
 	/*
 	 * Find a matching Pixel Clock
@@ -1270,8 +1269,6 @@ static int ami_decode_var(struct fb_var_screeninfo *var, struct amifb_par *par,
 				DPRINTK("diwstrt_v too low for pal\n");
 				return -EINVAL;
 			}
-			htotal = PAL_HTOTAL>>clk_shift;
-			vtotal = PAL_VTOTAL>>1;
 			if (!IS_OCS) {
 				par->beamcon0 = BMC0_PAL;
 				par->bplcon3 |= BPC3_BRDRBLNK;
@@ -1300,8 +1297,6 @@ static int ami_decode_var(struct fb_var_screeninfo *var, struct amifb_par *par,
 				DPRINTK("diwstrt_v too low for ntsc\n");
 				return -EINVAL;
 			}
-			htotal = NTSC_HTOTAL>>clk_shift;
-			vtotal = NTSC_VTOTAL>>1;
 			if (!IS_OCS) {
 				par->beamcon0 = 0;
 				par->bplcon3 |= BPC3_BRDRBLNK;
@@ -1360,8 +1355,6 @@ static int ami_decode_var(struct fb_var_screeninfo *var, struct amifb_par *par,
 			par->beamcon0 |= BMC0_VSYTRUE;
 		if (var->sync & FB_SYNC_COMP_HIGH_ACT)
 			par->beamcon0 |= BMC0_CSYTRUE;
-		htotal = par->htotal>>clk_shift;
-		vtotal = par->vtotal>>1;
 	} else {
 		DPRINTK("only broadcast modes possible for ocs\n");
 		return -EINVAL;
@@ -1847,10 +1840,9 @@ static int ami_get_var_cursorinfo(struct fb_var_cursorinfo *var,
 	register short delta;
 	register u_char color;
 	short height, width, bits, words;
-	int size, alloc;
+	int size;
 
 	size = par->crsr.height * par->crsr.width;
-	alloc = var->height * var->width;
 	var->height = par->crsr.height;
 	var->width = par->crsr.width;
 	var->xspot = par->crsr.spot_x;
-- 
1.7.10.4

