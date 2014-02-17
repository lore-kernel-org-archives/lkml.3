Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaBQJJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:09:19 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51683 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaBQJJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:09:16 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 6/9] regulator: max8660: Add missing of_node_put
Date: Mon, 17 Feb 2014 14:33:34 +0530
Message-Id: <1392627817-26957-6-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to decrement the ref count.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8660.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 70351abbd1e9..61ecd0892637 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -340,6 +340,7 @@ static int max8660_pdata_from_dt(struct device *dev,
 		rmatch[i].name = max8660_reg[i].name;
 
 	matched = of_regulator_match(dev, np, rmatch, ARRAY_SIZE(rmatch));
+	of_node_put(np);
 	if (matched <= 0)
 		return matched;
 
-- 
1.7.9.5

