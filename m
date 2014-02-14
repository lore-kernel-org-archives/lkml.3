Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaBNLzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:55:48 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57322 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaBNLzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:55:45 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 03/16] regulator: max8660: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:19:49 +0530
Message-Id: <1392378602-32302-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name walks the allnodes list, and can thus walk
outside of the parent node. Use of_get_child_by_name instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8660.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index 8d94d3d7f97f..70351abbd1e9 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -330,7 +330,7 @@ static int max8660_pdata_from_dt(struct device *dev,
 	struct max8660_subdev_data *sub;
 	struct of_regulator_match rmatch[ARRAY_SIZE(max8660_reg)];
 
-	np = of_find_node_by_name(dev->of_node, "regulators");
+	np = of_get_child_by_name(dev->of_node, "regulators");
 	if (!np) {
 		dev_err(dev, "missing 'regulators' subnode in DT\n");
 		return -EINVAL;
-- 
1.7.9.5

