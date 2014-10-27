Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaJ0MML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:12:11 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35561 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaJ0MME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:12:04 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-80-544e3691355e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 1/4] regulator: max77686: Replace hard-coded opmode values
 with defines
Date: Mon, 27 Oct 2014 13:11:47 +0100
Message-id: <1414411911-5539-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xy7oTzfxCDN5sYLLYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g8fqFoUXvgqtsFmeb3rBbfLvSwWSx6fE1VovLu+awWcw4
	v4/J4vZlXou1R+6yO/B7tDT3sHn8fX6dxePvqhfMHjtn3WX32LSqk81j85J6j74tqxg9Pm+S
	C+CI4rJJSc3JLEst0rdL4Mq4fnQPc8Ec8YrXZ++yNjC2C3cxcnJICJhINO35ww5hi0lcuLee
	rYuRi0NIYCmjxITmBlYIp49JYuWywywgVWwCxhKbly9hA7FFBPYzSTyeYAJSxCywmkni55VT
	zCAJYYEYiaa+v2BjWQRUJbre/QVr4BVwk1i65T4jxDo5iZPHJrOC2JwC7hJv5rSBxYWAapad
	esg+gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ8P26g3HpMatDjAIcjEo8vBOK
	fUOEWBPLiitzDzFKcDArifA6/gQK8aYkVlalFuXHF5XmpBYfYmTi4JRqYJzBy3vDTN5zivTW
	2r71hZdc+K9wvD2+n33u5v+Wv2f/bw/It/7WnCJXKn7x0hPesqOiVybrsryQZXCz/+RQIrp0
	taRXRIPaHEXHgk3LIiPrTWbL3Kjb6L2N/+nMCVf+yERk/m9ca+rq9ePBFp7yJMMF2Sd6ptx8
	fVv59Ke8lVNtkvbXXSnY+EGJpTgj0VCLuag4EQD8xfvDPQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add defines for regulator operating modes which should be more readable,
especially if one does not have Maxim 77686 datasheet.

The patch does not introduce any functional change.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77686.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index ef1af2debbd2..c625a8a7940d 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -45,6 +45,23 @@
 #define MAX77686_DVS_MINUV	600000
 #define MAX77686_DVS_UVSTEP	12500
 
+/*
+ * Values used for configuring LDOs and bucks.
+ * Forcing low power mode: LDO1, 3-5, 9, 13, 17-26
+ */
+#define MAX77686_LDO_LOWPOWER		0x1
+/*
+ * On/off controlled by PWRREQ:
+ *  - LDO2, 6-8, 10-12, 14-16
+ *  - buck[1234]
+ */
+#define MAX77686_OFF_PWRREQ		0x1
+/* Low power mode controlled by PWRREQ: All LDOs */
+#define MAX77686_LDO_LOWPOWER_PWRREQ	0x2
+/* Forcing low power mode: buck[234] */
+#define MAX77686_BUCK_LOWPOWER		0x2
+#define MAX77686_NORMAL			0x3
+
 #define MAX77686_OPMODE_SHIFT	6
 #define MAX77686_OPMODE_BUCK234_SHIFT	4
 #define MAX77686_OPMODE_MASK	0x3
@@ -76,9 +93,9 @@ static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
 	int ret, id = rdev_get_id(rdev);
 
 	if (id == MAX77686_BUCK1)
-		val = 0x1;
+		val = MAX77686_OFF_PWRREQ;
 	else
-		val = 0x1 << MAX77686_OPMODE_BUCK234_SHIFT;
+		val = MAX77686_OFF_PWRREQ << MAX77686_OPMODE_BUCK234_SHIFT;
 
 	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				 rdev->desc->enable_mask, val);
@@ -103,10 +120,10 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
 
 	switch (mode) {
 	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
-		val = 0x2 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_LDO_LOWPOWER_PWRREQ << MAX77686_OPMODE_SHIFT;
 		break;
 	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = 0x3 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_NORMAL << MAX77686_OPMODE_SHIFT;
 		break;
 	default:
 		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
@@ -133,13 +150,13 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 
 	switch (mode) {
 	case REGULATOR_MODE_STANDBY:			/* switch off */
-		val = 0x1 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_OFF_PWRREQ << MAX77686_OPMODE_SHIFT;
 		break;
 	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
-		val = 0x2 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_LDO_LOWPOWER_PWRREQ << MAX77686_OPMODE_SHIFT;
 		break;
 	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = 0x3 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_NORMAL << MAX77686_OPMODE_SHIFT;
 		break;
 	default:
 		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
-- 
1.9.1

