Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3A3Mw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:52:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46825 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3A3Mw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:52:56 -0500
Message-ID: <1359550369.3885.6.camel@phoenix>
Subject: [PATCH 1/2] regulator: max8997: Use of_get_child_count()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@smasung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Jan 2013 20:52:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8997.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 7d2b1b5..c780104 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -930,9 +930,7 @@ static int max8997_pmic_dt_parse_pdata(struct platform_device *pdev,
 	}
 
 	/* count the number of regulators to be supported in pmic */
-	pdata->num_regulators = 0;
-	for_each_child_of_node(regulators_np, reg_np)
-		pdata->num_regulators++;
+	pdata->num_regulators = of_get_child_count(regulators_np);
 
 	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
 				pdata->num_regulators, GFP_KERNEL);
-- 
1.7.9.5



