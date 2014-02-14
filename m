Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaBNLzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:55:41 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52822 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBNLzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:55:39 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 01/16] regulator: max77686: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:19:47 +0530
Message-Id: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name walks the allnodes list, and can thus walk
outside of the parent node. Use of_get_child_by_name instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Series compile tested. Some max* regulators tested on h/w.
---
 drivers/regulator/max77686.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index ae001ccf26f4..0e725f6ed455 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -400,7 +400,7 @@ static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
 	unsigned int i;
 
 	pmic_np = iodev->dev->of_node;
-	regulators_np = of_find_node_by_name(pmic_np, "voltage-regulators");
+	regulators_np = of_get_child_by_name(pmic_np, "voltage-regulators");
 	if (!regulators_np) {
 		dev_err(&pdev->dev, "could not find regulators sub-node\n");
 		return -EINVAL;
-- 
1.7.9.5

