Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaBQJN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:13:28 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54290 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaBQJJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:09:08 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 3/9] regulator: da9063: Add missing of_node_put
Date: Mon, 17 Feb 2014 14:33:31 +0530
Message-Id: <1392627817-26957-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to decrement the ref count.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/da9063-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index bfd7f2f795a6..a61b5d997a08 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -674,6 +674,7 @@ static struct da9063_regulators_pdata *da9063_parse_regulators_dt(
 
 	num = of_regulator_match(&pdev->dev, node, da9063_matches,
 				 ARRAY_SIZE(da9063_matches));
+	of_node_put(node);
 	if (num < 0) {
 		dev_err(&pdev->dev, "Failed to match regulators\n");
 		return ERR_PTR(-EINVAL);
-- 
1.7.9.5

