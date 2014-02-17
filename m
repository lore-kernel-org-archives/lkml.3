Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaBQJK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:10:29 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37630 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaBQJJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:09:18 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 7/9] regulator: max8998: Add missing of_node_put
Date: Mon, 17 Feb 2014 14:33:35 +0530
Message-Id: <1392627817-26957-7-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to decrement the ref count.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8998.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index ae3f0656feb0..ce22d4f3f3eb 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -674,8 +674,10 @@ static int max8998_pmic_dt_parse_pdata(struct max8998_dev *iodev,
 
 	rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
 				pdata->num_regulators, GFP_KERNEL);
-	if (!rdata)
+	if (!rdata) {
+		of_node_put(regulators_np);
 		return -ENOMEM;
+	}
 
 	pdata->regulators = rdata;
 	for (i = 0; i < ARRAY_SIZE(regulators); ++i) {
@@ -692,6 +694,9 @@ static int max8998_pmic_dt_parse_pdata(struct max8998_dev *iodev,
 	}
 	pdata->num_regulators = rdata - pdata->regulators;
 
+	of_node_put(reg_np);
+	of_node_put(regulators_np);
+
 	ret = max8998_pmic_dt_parse_dvs_gpio(iodev, pdata, pmic_np);
 	if (ret)
 		return -EINVAL;
-- 
1.7.9.5

