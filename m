Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaGFSb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:31:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38246 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaGFSbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:31:55 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Julia Lawall <Julia.Lawall@lip6.fr>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: i810: i810_main.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:33:10 +0200
Message-Id: <1404671590-18288-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/i810/i810_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/i810/i810_main.c b/drivers/video/fbdev/i810/i810_main.c
index bb674e4..754ef33 100644
--- a/drivers/video/fbdev/i810/i810_main.c
+++ b/drivers/video/fbdev/i810/i810_main.c
@@ -1135,12 +1135,11 @@ static int encode_fix(struct fb_fix_screeninfo *fix, struct fb_info *info)
 static void decode_var(const struct fb_var_screeninfo *var, 
 		       struct i810fb_par *par)
 {
-	u32 xres, yres, vxres, vyres;
+	u32 xres, yres, vxres;
 
 	xres = var->xres;
 	yres = var->yres;
 	vxres = var->xres_virtual;
-	vyres = var->yres_virtual;
 
 	switch (var->bits_per_pixel) {
 	case 8:
-- 
1.7.10.4

