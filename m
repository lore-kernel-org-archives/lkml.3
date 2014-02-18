Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaBRKra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:47:30 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56501 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbaBRKrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:47:25 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 13/15] regulator: arizona-ldo1: Remove redundant error message
Date: Tue, 18 Feb 2014 16:11:09 +0530
Message-Id: <1392720071-13503-13-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/arizona-ldo1.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 4f6c2055f6b2..d8e7db696d5a 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -189,10 +189,8 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	int ret;
 
 	ldo1 = devm_kzalloc(&pdev->dev, sizeof(*ldo1), GFP_KERNEL);
-	if (ldo1 == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (!ldo1)
 		return -ENOMEM;
-	}
 
 	ldo1->arizona = arizona;
 
-- 
1.7.9.5

