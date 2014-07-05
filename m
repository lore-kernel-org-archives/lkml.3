Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbaGEMNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:13:11 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45690 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbaGEMNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:13:09 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Michael Schmitz <schmitzmic@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: atafb.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:14:24 +0200
Message-Id: <1404562464-18788-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
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
 drivers/video/fbdev/atafb.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/video/fbdev/atafb.c b/drivers/video/fbdev/atafb.c
index 4953b65..1bedbf35 100644
--- a/drivers/video/fbdev/atafb.c
+++ b/drivers/video/fbdev/atafb.c
@@ -2546,7 +2546,6 @@ static void atafb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
 	struct atafb_par *par = (struct atafb_par *)info->par;
 	int x2, y2;
 	u32 dx, dy, sx, sy, width, height;
-	int rev_copy = 0;
 
 #ifdef ATAFB_FALCON
 	if (info->var.bits_per_pixel == 16) {
@@ -2580,7 +2579,6 @@ static void atafb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
 	if (dy > sy || (dy == sy && dx > sx)) {
 		dy += height;
 		sy += height;
-		rev_copy = 1;
 	}
 
 	if (info->var.bits_per_pixel == 1)
@@ -2599,8 +2597,6 @@ static void atafb_imageblit(struct fb_info *info, const struct fb_image *image)
 {
 	struct atafb_par *par = (struct atafb_par *)info->par;
 	int x2, y2;
-	unsigned long *dst;
-	int dst_idx;
 	const char *src;
 	u32 dx, dy, width, height, pitch;
 
@@ -2627,10 +2623,6 @@ static void atafb_imageblit(struct fb_info *info, const struct fb_image *image)
 
 	if (image->depth == 1) {
 		// used for font data
-		dst = (unsigned long *)
-			((unsigned long)info->screen_base & ~(BYTES_PER_LONG - 1));
-		dst_idx = ((unsigned long)info->screen_base & (BYTES_PER_LONG - 1)) * 8;
-		dst_idx += dy * par->next_line * 8 + dx;
 		src = image->data;
 		pitch = (image->width + 7) / 8;
 		while (height--) {
-- 
1.7.10.4

