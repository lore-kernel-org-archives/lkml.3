Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaBNLzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:55:52 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43321 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaBNLzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:55:50 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 05/16] regulator: max8925: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:19:51 +0530
Message-Id: <1392378602-32302-5-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/max8925-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 759510789e71..5b939894bfc4 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -254,7 +254,7 @@ static int max8925_regulator_dt_init(struct platform_device *pdev,
 	nproot = of_node_get(pdev->dev.parent->of_node);
 	if (!nproot)
 		return -ENODEV;
-	np = of_find_node_by_name(nproot, "regulators");
+	np = of_get_child_by_name(nproot, "regulators");
 	if (!np) {
 		dev_err(&pdev->dev, "failed to find regulators node\n");
 		return -ENODEV;
-- 
1.7.9.5

