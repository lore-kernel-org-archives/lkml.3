Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaBQJMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:12:30 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:51694 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaBQJJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:09:13 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 5/9] regulator: max77693: Add missing of_node_put
Date: Mon, 17 Feb 2014 14:33:33 +0530
Message-Id: <1392627817-26957-5-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to decrement the ref count.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max77693.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index 057d040e6feb..d6807fd7eadc 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -176,13 +176,16 @@ static int max77693_pmic_dt_parse_rdata(struct device *dev,
 
 	rmatch = devm_kzalloc(dev,
 		 sizeof(*rmatch) * ARRAY_SIZE(regulators), GFP_KERNEL);
-	if (!rmatch)
+	if (!rmatch) {
+		of_node_put(np);
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(regulators); i++)
 		rmatch[i].name = regulators[i].name;
 
 	matched = of_regulator_match(dev, np, rmatch, ARRAY_SIZE(regulators));
+	of_node_put(np);
 	if (matched <= 0)
 		return matched;
 	*rdata = devm_kzalloc(dev, sizeof(**rdata) * matched, GFP_KERNEL);
-- 
1.7.9.5

