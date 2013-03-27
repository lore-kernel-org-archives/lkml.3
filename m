Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3C0Xzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:55:35 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:33830 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3C0Xzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:55:33 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: linux@prisktech.co.nz, FlorianSchandinat@gmx.de,
        linux-arm-kernel@lists.infradead.org
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] video: fix invalid free of devm_ allocated data
Date: Thu, 28 Mar 2013 01:55:24 +0200
Message-Id: <1364428524-13821-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The objects allocated by devm_* APIs are managed by devres and are freed when
the device is detached. Hence there is no need to use kfree() explicitly.
Patch found using coccinelle.

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 drivers/video/vt8500lcdfb.c |    3 ---
 drivers/video/wm8505fb.c    |    3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index b4ccca2..ea3ee61 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -465,7 +465,6 @@ failed_free_res:
 	release_mem_region(res->start, resource_size(res));
 failed_fbi:
 	platform_set_drvdata(pdev, NULL);
-	kfree(fbi);
 failed:
 	return ret;
 }
@@ -494,8 +493,6 @@ static int vt8500lcd_remove(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, resource_size(res));
 
-	kfree(fbi);
-
 	return 0;
 }
 
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 2e8298e..34a2de1 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -427,7 +427,6 @@ failed_free_res:
 	release_mem_region(res->start, resource_size(res));
 failed_fbi:
 	platform_set_drvdata(pdev, NULL);
-	kfree(fbi);
 failed:
 	return ret;
 }
@@ -451,8 +450,6 @@ static int wm8505fb_remove(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, resource_size(res));
 
-	kfree(fbi);
-
 	return 0;
 }
 
-- 
1.7.9.5

