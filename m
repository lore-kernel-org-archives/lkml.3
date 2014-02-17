Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaBQJJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:09:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45091 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaBQJJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:09:10 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 4/9] regulator: max77686: Add missing of_node_put
Date: Mon, 17 Feb 2014 14:33:32 +0530
Message-Id: <1392627817-26957-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to decrement the ref count.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max77686.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 0e725f6ed455..b411af00065d 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -412,6 +412,7 @@ static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
 	if (!rdata) {
 		dev_err(&pdev->dev,
 			"could not allocate memory for regulator data\n");
+		of_node_put(regulators_np);
 		return -ENOMEM;
 	}
 
@@ -425,6 +426,7 @@ static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
 	}
 
 	pdata->regulators = rdata;
+	of_node_put(regulators_np);
 
 	return 0;
 }
-- 
1.7.9.5

