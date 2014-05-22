Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaEVNPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:15:22 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:36515 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaEVNPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:15:20 -0400
From: Emil Goode <emilgoode@gmail.com>
To: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] ARM: imx: add missing kfree call in error paths
Date: Thu, 22 May 2014 15:14:42 +0200
Message-Id: <1400764482-20147-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We forgot to free pdev->dev.dma_mask as it is not freed
by platform_device_put().

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 arch/arm/mach-imx/mach-mx31_3ds.c    |    4 +++-
 arch/arm/mach-imx/mach-mx31moboard.c |    4 +++-
 arch/arm/mach-imx/mach-mx35_3ds.c    |    4 +++-
 arch/arm/mach-imx/mach-pcm037.c      |    4 +++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
index 453f41a..8de1019 100644
--- a/arch/arm/mach-imx/mach-mx31_3ds.c
+++ b/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -201,9 +201,11 @@ static int __init mx31_3ds_init_camera(void)
 		goto err;
 
 	ret = platform_device_add(pdev);
-	if (ret)
+	if (ret) {
 err:
+		kfree(pdev->dev.dma_mask);
 		platform_device_put(pdev);
+	}
 
 	return ret;
 }
diff --git a/arch/arm/mach-imx/mach-mx31moboard.c b/arch/arm/mach-imx/mach-mx31moboard.c
index 6bed570..f24a93c 100644
--- a/arch/arm/mach-imx/mach-mx31moboard.c
+++ b/arch/arm/mach-imx/mach-mx31moboard.c
@@ -494,9 +494,11 @@ static int __init mx31moboard_init_cam(void)
 		goto err;
 
 	ret = platform_device_add(pdev);
-	if (ret)
+	if (ret) {
 err:
+		kfree(pdev->dev.dma_mask);
 		platform_device_put(pdev);
+	}
 
 	return ret;
 
diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index 72cd77d..ffdddb3 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -284,9 +284,11 @@ static int __init imx35_3ds_init_camera(void)
 		goto err;
 
 	ret = platform_device_add(pdev);
-	if (ret)
+	if (ret) {
 err:
+		kfree(pdev->dev.dma_mask);
 		platform_device_put(pdev);
+	}
 
 	return ret;
 }
diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index 8eb1570..764a111 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -427,9 +427,11 @@ static int __init pcm037_init_camera(void)
 		goto err;
 
 	ret = platform_device_add(pdev);
-	if (ret)
+	if (ret) {
 err:
+		kfree(pdev->dev.dma_mask);
 		platform_device_put(pdev);
+	}
 
 	return ret;
 }
-- 
1.7.10.4

