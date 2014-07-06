Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaGFSiI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:38:08 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:56135 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaGFSiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:38:06 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: mb862xx: mb862xxfb_accel.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:39:22 +0200
Message-Id: <1404671962-18806-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/mb862xx/mb862xxfb_accel.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/video/fbdev/mb862xx/mb862xxfb_accel.c b/drivers/video/fbdev/mb862xx/mb862xxfb_accel.c
index fe92eed..aa778ba 100644
--- a/drivers/video/fbdev/mb862xx/mb862xxfb_accel.c
+++ b/drivers/video/fbdev/mb862xx/mb862xxfb_accel.c
@@ -28,7 +28,6 @@
 
 static void mb862xxfb_write_fifo(u32 count, u32 *data, struct fb_info *info)
 {
-	struct mb862xxfb_par *par = info->par;
 	static u32 free;
 
 	u32 total = 0;
@@ -188,7 +187,6 @@ static void mb86290fb_imageblit16(u32 *cmd, u16 step, u16 dx, u16 dy,
 static void mb86290fb_imageblit(struct fb_info *info,
 				const struct fb_image *image)
 {
-	int mdr;
 	u32 *cmd = NULL;
 	void (*cmdfn) (u32 *, u16, u16, u16, u16, u16, u32, u32,
 		       const struct fb_image *, struct fb_info *) = NULL;
@@ -200,7 +198,6 @@ static void mb86290fb_imageblit(struct fb_info *info,
 	u16 dx = image->dx, dy = image->dy;
 	int x2, y2, vxres, vyres;
 
-	mdr = (GDC_ROP_COPY << 9);
 	x2 = image->dx + image->width;
 	y2 = image->dy + image->height;
 	vxres = info->var.xres_virtual;
@@ -309,8 +306,6 @@ static void mb86290fb_fillrect(struct fb_info *info,
 
 void mb862xxfb_init_accel(struct fb_info *info, int xres)
 {
-	struct mb862xxfb_par *par = info->par;
-
 	if (info->var.bits_per_pixel == 32) {
 		info->fbops->fb_fillrect = cfb_fillrect;
 		info->fbops->fb_copyarea = cfb_copyarea;
-- 
1.7.10.4

