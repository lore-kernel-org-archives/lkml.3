Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaCJKDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:03:46 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40398 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaCJKDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:03:45 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH Resend 1/2] regulator: s2mps11: Use of_get_child_by_name
Date: Mon, 10 Mar 2014 15:27:40 +0530
Message-Id: <1394445461-17532-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name walks the allnodes list, and can thus walk
outside of the parent node. Use of_get_child_by_name instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/s2mps11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index b51ccf5..0f6177b 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -438,7 +438,7 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	for (i = 0; i < s2mps11->rdev_num; i++)
 		rdata[i].name = regulators[i].name;
 
-	reg_np = of_find_node_by_name(iodev->dev->of_node, "regulators");
+	reg_np = of_get_child_by_name(iodev->dev->of_node, "regulators");
 	if (!reg_np) {
 		dev_err(&pdev->dev, "could not find regulators sub-node\n");
 		ret = -EINVAL;
-- 
1.7.9.5

