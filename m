Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaBTJHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:07:42 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:65143 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbaBTI7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:14 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 08/23] regulator: max8952: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:08 +0530
Message-Id: <1392886403-10640-8-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8952.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 788e5ae2af1b..66e777967c69 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -144,10 +144,8 @@ static struct max8952_platform_data *max8952_parse_dt(struct device *dev)
 	int i;
 
 	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		dev_err(dev, "Failed to allocate platform data\n");
+	if (!pd)
 		return NULL;
-	}
 
 	pd->gpio_vid0 = of_get_named_gpio(np, "max8952,vid-gpios", 0);
 	pd->gpio_vid1 = of_get_named_gpio(np, "max8952,vid-gpios", 1);
-- 
1.7.9.5

