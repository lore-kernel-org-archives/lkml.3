Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3DMOFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 10:05:49 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58102 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3DMOFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:05:48 -0400
Message-ID: <1365861943.3814.3.camel@phoenix>
Subject: [PATCH] regulator: max8997: Test pdata by NULL checking instead of
 IS_ERR_OR_NULL
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@smasung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 13 Apr 2013 22:05:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pdata is either a valid pointer or NULL, use NULL checking rather than
IS_ERR_OR_NULL macro.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8997.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 0ac7a87..df20069 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -1035,8 +1035,8 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	int i, ret, size, nr_dvs;
 	u8 max_buck1 = 0, max_buck2 = 0, max_buck5 = 0;
 
-	if (IS_ERR_OR_NULL(pdata)) {
-		dev_err(pdev->dev.parent, "No platform init data supplied.\n");
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform init data supplied.\n");
 		return -ENODEV;
 	}
 
-- 
1.7.10.4



