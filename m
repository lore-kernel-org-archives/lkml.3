Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaBQJJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:09:43 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48303 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaBQJJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:09:24 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 9/9] regulator: tps65090: Add missing of_node_put
Date: Mon, 17 Feb 2014 14:33:37 +0530
Message-Id: <1392627817-26957-9-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to decrement the ref count.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps65090-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 676f75548f00..5674f886c471 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -188,6 +188,7 @@ static struct tps65090_platform_data *tps65090_parse_dt_reg_data(
 
 	ret = of_regulator_match(&pdev->dev, regulators, tps65090_matches,
 			ARRAY_SIZE(tps65090_matches));
+	of_node_put(regulators);
 	if (ret < 0) {
 		dev_err(&pdev->dev,
 			"Error parsing regulator init data: %d\n", ret);
-- 
1.7.9.5

