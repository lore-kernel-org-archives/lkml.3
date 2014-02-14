Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBNL4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:56:11 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:63660 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaBNL4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:56:08 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 11/16] regulator: da9055: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:19:57 +0530
Message-Id: <1392378602-32302-11-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/da9055-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index cf7404026588..126e7c6d2c12 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -559,7 +559,7 @@ static int da9055_regulator_dt_init(struct platform_device *pdev,
 	if (!nproot)
 		return -ENODEV;
 
-	np = of_find_node_by_name(nproot, "regulators");
+	np = of_get_child_by_name(nproot, "regulators");
 	if (!np)
 		return -ENODEV;
 
-- 
1.7.9.5

