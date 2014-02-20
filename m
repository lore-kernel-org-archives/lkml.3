Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbaBTI7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:53 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:52338 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaBTI7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:50 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 20/23] regulator: wm831x-dcdc: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:20 +0530
Message-Id: <1392886403-10640-20-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/wm831x-dcdc.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 04cf9c16ef23..0d88a82ab2a2 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -469,10 +469,8 @@ static int wm831x_buckv_probe(struct platform_device *pdev)
 
 	dcdc = devm_kzalloc(&pdev->dev,  sizeof(struct wm831x_dcdc),
 			    GFP_KERNEL);
-	if (dcdc == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (!dcdc)
 		return -ENOMEM;
-	}
 
 	dcdc->wm831x = wm831x;
 
@@ -622,10 +620,8 @@ static int wm831x_buckp_probe(struct platform_device *pdev)
 
 	dcdc = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_dcdc),
 			    GFP_KERNEL);
-	if (dcdc == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (!dcdc)
 		return -ENOMEM;
-	}
 
 	dcdc->wm831x = wm831x;
 
@@ -752,10 +748,8 @@ static int wm831x_boostp_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	dcdc = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_dcdc), GFP_KERNEL);
-	if (dcdc == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (!dcdc)
 		return -ENOMEM;
-	}
 
 	dcdc->wm831x = wm831x;
 
@@ -842,10 +836,8 @@ static int wm831x_epe_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Probing EPE%d\n", id + 1);
 
 	dcdc = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_dcdc), GFP_KERNEL);
-	if (dcdc == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (!dcdc)
 		return -ENOMEM;
-	}
 
 	dcdc->wm831x = wm831x;
 
-- 
1.7.9.5

