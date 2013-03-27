Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3C0Xnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:43:39 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:49319 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3C0Xnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:43:37 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: linux@prisktech.co.nz, FlorianSchandinat@gmx.de,
        linux-arm-kernel@lists.infradead.org
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] video: fixed missing iounmap coccinelle errors
Date: Thu, 28 Mar 2013 01:43:25 +0200
Message-Id: <1364427805-11972-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified or added the necessary goto statements so that the ioremapped
regions get unmapped before return.

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 drivers/video/vt8500lcdfb.c |    7 ++++---
 drivers/video/wm8505fb.c    |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index aa2579c..b4ccca2 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -350,7 +350,7 @@ static int vt8500lcd_probe(struct platform_device *pdev)
 	if (!np) {
 		pr_err("%s: No display description in Device Tree\n", __func__);
 		ret = -EINVAL;
-		goto failed_free_res;
+		goto failed_free_io;
 	}
 
 	/*
@@ -369,7 +369,7 @@ static int vt8500lcd_probe(struct platform_device *pdev)
 	ret |= of_property_read_u32(np, "bpp", &bpp);
 	if (ret) {
 		pr_err("%s: Unable to read display properties\n", __func__);
-		goto failed_free_res;
+		goto failed_free_io;
 	}
 	of_mode.vmode = FB_VMODE_NONINTERLACED;
 
@@ -379,7 +379,8 @@ static int vt8500lcd_probe(struct platform_device *pdev)
 				GFP_KERNEL);
 	if (!fb_mem_virt) {
 		pr_err("%s: Failed to allocate framebuffer\n", __func__);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto failed_free_io;
 	};
 
 	fbi->fb.fix.smem_start	= fb_mem_phys;
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 4dd0580..2e8298e 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -332,7 +332,7 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	if (!np) {
 		pr_err("%s: No display description in Device Tree\n", __func__);
 		ret = -EINVAL;
-		goto failed_free_res;
+		goto failed_free_io;
 	}
 
 	/*
@@ -351,7 +351,7 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	ret |= of_property_read_u32(np, "bpp", &bpp);
 	if (ret) {
 		pr_err("%s: Unable to read display properties\n", __func__);
-		goto failed_free_res;
+		goto failed_free_io;
 	}
 
 	of_mode.vmode = FB_VMODE_NONINTERLACED;
@@ -369,7 +369,8 @@ static int wm8505fb_probe(struct platform_device *pdev)
 				GFP_KERNEL);
 	if (!fb_mem_virt) {
 		pr_err("%s: Failed to allocate framebuffer\n", __func__);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto failed_free_io;
 	};
 
 	fbi->fb.var.xres_virtual	= of_mode.xres;
-- 
1.7.9.5

