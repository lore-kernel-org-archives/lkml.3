Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaBNLzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:55:50 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:46232 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaBNLzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:55:48 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 04/16] regulator: max8907: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:19:50 +0530
Message-Id: <1392378602-32302-4-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/max8907-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index 0c5fe6c6ac26..afda8c6af721 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -231,7 +231,7 @@ static int max8907_regulator_parse_dt(struct platform_device *pdev)
 	if (!np)
 		return 0;
 
-	regulators = of_find_node_by_name(np, "regulators");
+	regulators = of_get_child_by_name(np, "regulators");
 	if (!regulators) {
 		dev_err(&pdev->dev, "regulators node not found\n");
 		return -EINVAL;
-- 
1.7.9.5

