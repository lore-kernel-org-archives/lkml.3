Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaBNL40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:56:26 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36348 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaBNL4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:56:22 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 16/16] regulator: tps65217: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:20:02 +0530
Message-Id: <1392378602-32302-16-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/tps65217-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 9ea1bf26bd13..fd441f2738f5 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -187,7 +187,7 @@ static struct tps65217_board *tps65217_parse_dt(struct platform_device *pdev)
 	struct device_node *regs;
 	int i, count;
 
-	regs = of_find_node_by_name(node, "regulators");
+	regs = of_get_child_by_name(node, "regulators");
 	if (!regs)
 		return NULL;
 
-- 
1.7.9.5

