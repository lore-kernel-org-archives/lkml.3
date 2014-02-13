Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaBMLk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:40:27 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53558 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaBMLk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:40:26 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sbkim73@samsung.com,
        sachin.kamat@linaro.org
Subject: [PATCH 1/2] regulator: s5m8767: Use of_get_child_by_name
Date: Thu, 13 Feb 2014 17:05:06 +0530
Message-Id: <1392291307-21104-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name walks the allnodes list, and can thus walk
outside of the parent node. Use of_get_child_by_name instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/s5m8767.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 6850a25a41c4..40de16802681 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -601,7 +601,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 		return -ENODEV;
 	}
 
-	regulators_np = of_find_node_by_name(pmic_np, "regulators");
+	regulators_np = of_get_child_by_name(pmic_np, "regulators");
 	if (!regulators_np) {
 		dev_err(iodev->dev, "could not find regulators sub-node\n");
 		return -EINVAL;
-- 
1.7.9.5

