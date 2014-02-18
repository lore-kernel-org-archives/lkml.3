Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbaBRKrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:47:21 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43318 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbaBRKrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:47:18 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 11/15] regulator: 88pm800: Remove redundant error message
Date: Tue, 18 Feb 2014 16:11:07 +0530
Message-Id: <1392720071-13503-11-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/88pm800.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
index d333f7eac106..7a721d67e6ac 100644
--- a/drivers/regulator/88pm800.c
+++ b/drivers/regulator/88pm800.c
@@ -310,10 +310,8 @@ static int pm800_regulator_probe(struct platform_device *pdev)
 
 	pm800_data = devm_kzalloc(&pdev->dev, sizeof(*pm800_data),
 					GFP_KERNEL);
-	if (!pm800_data) {
-		dev_err(&pdev->dev, "Failed to allocate pm800_regualtors");
+	if (!pm800_data)
 		return -ENOMEM;
-	}
 
 	pm800_data->map = chip->subchip->regmap_power;
 	pm800_data->chip = chip;
-- 
1.7.9.5

