Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaBNL6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:58:20 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44781 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaBNLz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:55:59 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 08/16] regulator: act8865: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:19:54 +0530
Message-Id: <1392378602-32302-8-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/act8865-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index 084cc0819a52..c9f98b061307 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -213,7 +213,7 @@ static int act8865_pdata_from_dt(struct device *dev,
 	struct device_node *np;
 	struct act8865_regulator_data *regulator;
 
-	np = of_find_node_by_name(dev->of_node, "regulators");
+	np = of_get_child_by_name(dev->of_node, "regulators");
 	if (!np) {
 		dev_err(dev, "missing 'regulators' subnode in DT\n");
 		return -EINVAL;
-- 
1.7.9.5

