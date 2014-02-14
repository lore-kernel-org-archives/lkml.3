Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaBNL4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:56:05 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52612 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaBNL4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:56:02 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 09/16] regulator: as3711: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:19:55 +0530
Message-Id: <1392378602-32302-9-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/as3711-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index 67fd548dcdba..856c55f3a832 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -191,7 +191,7 @@ static int as3711_regulator_parse_dt(struct device *dev,
 {
 	struct as3711_regulator_pdata *pdata = dev_get_platdata(dev);
 	struct device_node *regulators =
-		of_find_node_by_name(dev->parent->of_node, "regulators");
+		of_get_child_by_name(dev->parent->of_node, "regulators");
 	struct of_regulator_match *match;
 	int ret, i;
 
-- 
1.7.9.5

