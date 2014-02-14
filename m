Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaBNL4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:56:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51660 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaBNL4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:56:20 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 15/16] regulator: tps6507x: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:20:01 +0530
Message-Id: <1392378602-32302-15-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/tps6507x-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 862cc81f822f..5a558dad27e3 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -385,7 +385,7 @@ static struct tps6507x_board *tps6507x_parse_dt_reg_data(
 		return NULL;
 	}
 
-	regulators = of_find_node_by_name(np, "regulators");
+	regulators = of_get_child_by_name(np, "regulators");
 	if (!regulators) {
 		dev_err(&pdev->dev, "regulator node not found\n");
 		return NULL;
-- 
1.7.9.5

