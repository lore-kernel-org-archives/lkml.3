Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaBQJJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:09:10 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37912 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaBQJJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:09:05 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 2/9] regulator: as3722: Add missing of_node_put
Date: Mon, 17 Feb 2014 14:33:30 +0530
Message-Id: <1392627817-26957-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to decrement the ref count.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/as3722-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index 8b17d786cb71..85585219ce82 100644
--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -719,6 +719,7 @@ static int as3722_get_regulator_dt_data(struct platform_device *pdev,
 
 	ret = of_regulator_match(&pdev->dev, np, as3722_regulator_matches,
 			ARRAY_SIZE(as3722_regulator_matches));
+	of_node_put(np);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Parsing of regulator node failed: %d\n",
 			ret);
-- 
1.7.9.5

