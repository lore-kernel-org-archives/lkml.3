Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaGFSxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:53:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43855 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaGFSxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:53:53 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: pxa168fb.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:55:08 +0200
Message-Id: <1404672908-20071-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/pxa168fb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/pxa168fb.c b/drivers/video/fbdev/pxa168fb.c
index c95b9e4..fd6c56b 100644
--- a/drivers/video/fbdev/pxa168fb.c
+++ b/drivers/video/fbdev/pxa168fb.c
@@ -405,9 +405,8 @@ static int pxa168fb_set_par(struct fb_info *info)
 	struct fb_var_screeninfo *var = &info->var;
 	struct fb_videomode mode;
 	u32 x;
-	struct pxa168fb_mach_info *mi;
 
-	mi = dev_get_platdata(fbi->dev);
+	dev_get_platdata(fbi->dev);
 
 	/*
 	 * Set additional mode info.
@@ -787,7 +786,6 @@ static int pxa168fb_remove(struct platform_device *pdev)
 {
 	struct pxa168fb_info *fbi = platform_get_drvdata(pdev);
 	struct fb_info *info;
-	int irq;
 	unsigned int data;
 
 	if (!fbi)
@@ -807,7 +805,7 @@ static int pxa168fb_remove(struct platform_device *pdev)
 	if (info->cmap.len)
 		fb_dealloc_cmap(&info->cmap);
 
-	irq = platform_get_irq(pdev, 0);
+	platform_get_irq(pdev, 0);
 
 	dma_free_writecombine(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
 				info->screen_base, info->fix.smem_start);
-- 
1.7.10.4

