Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaGFS0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:26:46 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62210 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaGFS0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:26:44 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hanjun Guo <hanjun.guo@linaro.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: au1200fb.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:27:59 +0200
Message-Id: <1404671279-17856-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/au1200fb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index 4cfba78..2249d3d 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -710,7 +710,7 @@ static int fbinfo2index (struct fb_info *fb_info)
 static int au1200_setlocation (struct au1200fb_device *fbdev, int plane,
 	int xpos, int ypos)
 {
-	uint32 winctrl0, winctrl1, winenable, fb_offset = 0;
+	uint32 winctrl0, winctrl1, winenable;
 	int xsz, ysz;
 
 	/* FIX!!! NOT CHECKING FOR COMPLETE OFFSCREEN YET */
@@ -738,7 +738,6 @@ static int au1200_setlocation (struct au1200fb_device *fbdev, int plane,
 	if (xpos < 0) {
 		/* Off-screen to the left */
 		xsz = win->w[plane].xres + xpos;
-		fb_offset += (((0 - xpos) * winbpp(lcd->window[plane].winctrl1))/8);
 		xpos = 0;
 		/*printk("off screen left\n");*/
 	}
-- 
1.7.10.4

