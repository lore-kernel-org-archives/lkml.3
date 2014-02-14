Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaBNL4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:56:17 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33021 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaBNL4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:56:14 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 13/16] regulator: mc13xxx: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:19:59 +0530
Message-Id: <1392378602-32302-13-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/mc13xxx-regulator-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index da4859282302..4498a3f0733d 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -168,7 +168,7 @@ int mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
 	int num;
 
 	of_node_get(pdev->dev.parent->of_node);
-	parent = of_find_node_by_name(pdev->dev.parent->of_node, "regulators");
+	parent = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
 	if (!parent)
 		return -ENODEV;
 
@@ -188,7 +188,7 @@ struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 	int i, parsed = 0;
 
 	of_node_get(pdev->dev.parent->of_node);
-	parent = of_find_node_by_name(pdev->dev.parent->of_node, "regulators");
+	parent = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
 	if (!parent)
 		return NULL;
 
-- 
1.7.9.5

