Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaBTJAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:00:47 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51291 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbaBTI7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:53 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 21/23] regulator: wm831x-isink: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:21 +0530
Message-Id: <1392886403-10640-21-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/wm831x-isink.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 0339b886df5d..72e385e76a9d 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -165,10 +165,8 @@ static int wm831x_isink_probe(struct platform_device *pdev)
 
 	isink = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_isink),
 			     GFP_KERNEL);
-	if (isink == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (!isink)
 		return -ENOMEM;
-	}
 
 	isink->wm831x = wm831x;
 
-- 
1.7.9.5

