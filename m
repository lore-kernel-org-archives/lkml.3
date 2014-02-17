Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaBQJJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:09:25 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50387 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaBQJJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:09:21 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 8/9] regulator: tps6507x: Add missing of_node_put
Date: Mon, 17 Feb 2014 14:33:36 +0530
Message-Id: <1392627817-26957-8-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to decrement the ref count.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/tps6507x-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 5a558dad27e3..e506e7f54253 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -395,6 +395,7 @@ static struct tps6507x_board *tps6507x_parse_dt_reg_data(
 	matches = tps6507x_matches;
 
 	ret = of_regulator_match(&pdev->dev, regulators, matches, count);
+	of_node_put(regulators);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
 			ret);
-- 
1.7.9.5

