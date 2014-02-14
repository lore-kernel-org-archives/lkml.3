Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaBNL4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:56:13 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58973 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaBNL4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:56:11 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 12/16] regulator: da9063: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:19:58 +0530
Message-Id: <1392378602-32302-12-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/da9063-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 91e99a2c8dc1..bfd7f2f795a6 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -666,7 +666,7 @@ static struct da9063_regulators_pdata *da9063_parse_regulators_dt(
 	struct device_node *node;
 	int i, n, num;
 
-	node = of_find_node_by_name(pdev->dev.parent->of_node, "regulators");
+	node = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
 	if (!node) {
 		dev_err(&pdev->dev, "Regulators device node not found\n");
 		return ERR_PTR(-ENODEV);
-- 
1.7.9.5

