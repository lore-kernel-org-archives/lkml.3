Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaBNLz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:55:59 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48046 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaBNLz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:55:56 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 07/16] regulator: 88pm8607: Use of_get_child_by_name
Date: Fri, 14 Feb 2014 17:19:53 +0530
Message-Id: <1392378602-32302-7-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/88pm8607.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index f704d83c93c4..fa99bfccaa6b 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -322,7 +322,7 @@ static int pm8607_regulator_dt_init(struct platform_device *pdev,
 	nproot = of_node_get(pdev->dev.parent->of_node);
 	if (!nproot)
 		return -ENODEV;
-	nproot = of_find_node_by_name(nproot, "regulators");
+	nproot = of_get_child_by_name(nproot, "regulators");
 	if (!nproot) {
 		dev_err(&pdev->dev, "failed to find regulators node\n");
 		return -ENODEV;
-- 
1.7.9.5

