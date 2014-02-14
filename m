Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaBNLzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:55:45 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63565 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaBNLzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:55:42 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 02/16] regulator: max77693: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:19:48 +0530
Message-Id: <1392378602-32302-2-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/max77693.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index 5fb899f461d0..057d040e6feb 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -170,7 +170,7 @@ static int max77693_pmic_dt_parse_rdata(struct device *dev,
 	struct max77693_regulator_data *tmp;
 	int i, matched = 0;
 
-	np = of_find_node_by_name(dev->parent->of_node, "regulators");
+	np = of_get_child_by_name(dev->parent->of_node, "regulators");
 	if (!np)
 		return -EINVAL;
 
-- 
1.7.9.5

