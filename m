Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab3BFCzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:55:24 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:53583 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3BFCzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:55:18 -0500
Message-ID: <1360119305.8965.1.camel@phoenix>
Subject: [PATCH 1/3] regulator: s5m8767: Use of_get_child_count()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>, LiamGirdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 06 Feb 2013 10:55:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/s5m8767.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 1250cef..194b5dd 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -536,9 +536,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
 	}
 
 	/* count the number of regulators to be supported in pmic */
-	pdata->num_regulators = 0;
-	for_each_child_of_node(regulators_np, reg_np)
-		pdata->num_regulators++;
+	pdata->num_regulators = of_get_child_count(regulators_np);
 
 	rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
 				pdata->num_regulators, GFP_KERNEL);
-- 
1.7.9.5



