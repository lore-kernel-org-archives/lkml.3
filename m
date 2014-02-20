Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaBTI76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:58 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57637 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbaBTI74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:56 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 22/23] regulator: wm831x-ldo: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:22 +0530
Message-Id: <1392886403-10640-22-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/wm831x-ldo.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 46d6700467b5..eca0eeb78acd 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -235,10 +235,8 @@ static int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
 	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_ldo), GFP_KERNEL);
-	if (ldo == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (!ldo)
 		return -ENOMEM;
-	}
 
 	ldo->wm831x = wm831x;
 
@@ -447,10 +445,8 @@ static int wm831x_aldo_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
 	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_ldo), GFP_KERNEL);
-	if (ldo == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (!ldo)
 		return -ENOMEM;
-	}
 
 	ldo->wm831x = wm831x;
 
@@ -594,10 +590,8 @@ static int wm831x_alive_ldo_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
 	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_ldo), GFP_KERNEL);
-	if (ldo == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (!ldo)
 		return -ENOMEM;
-	}
 
 	ldo->wm831x = wm831x;
 
-- 
1.7.9.5

