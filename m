Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaBTJAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:00:03 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42917 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbaBTI76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:58 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 23/23] regulator: wm8994: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:23 +0530
Message-Id: <1392886403-10640-23-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/wm8994-regulator.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 71c5911f2e71..c24346db8a71 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -134,10 +134,8 @@ static int wm8994_ldo_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
 	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm8994_ldo), GFP_KERNEL);
-	if (ldo == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (!ldo)
 		return -ENOMEM;
-	}
 
 	ldo->wm8994 = wm8994;
 	ldo->supply = wm8994_ldo_consumer[id];
-- 
1.7.9.5

