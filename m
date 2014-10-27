Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaJ0Jow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:44:52 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25468 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaJ0Jos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:44:48 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-0c-544e140ecf9c
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
Subject: [PATCH v4 1/3] regulator: max77686: Replace hard-coded opmode values
 with defines
Date: Mon, 27 Oct 2014 10:44:24 +0100
Message-id: <1414403066-7872-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414403066-7872-1-git-send-email-k.kozlowski@samsung.com>
References: <1414403066-7872-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xK7p8In4hBotfMVtsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gtvl3pYLLY9Pgaq8XlXXPYLGac
	38dkcfsyr8XaI3fZHfg9Wpp72Dz+Pr/O4vF31Qtmj52z7rJ7bFrVyeaxeUm9R9+WVYwenzfJ
	BXBEcdmkpOZklqUW6dslcGVM6r/MWnBVomLxmVOsDYzrRLoYOTkkBEwkfnw9xw5hi0lcuLee
	rYuRi0NIYCmjxNJzb8ESQgJ9TBJTvqeA2GwCxhKbly9hA7FFBPYzSTyeYALSwCywmkni55VT
	zCAJYYEYiXmHv4DZLAKqEiunTgKzeQXcJLa+PsIGsU1O4uSxyawgNqeAu8S87r1sEMvcJG5P
	n8M6gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ4P26g3HpMatDjAIcjEo8vBOK
	fUOEWBPLiitzDzFKcDArifA6/gQK8aYkVlalFuXHF5XmpBYfYmTi4JRqYOSPXRdRMd3Gafac
	1AQ57pmaR/kjGy6L8ytsmTGVa8GzDN+1csd+7jp4UohbzXPBoZ5drIV7vedNmtS88P8tiRbh
	Pcs1OgvMv6ow6tjy+ex59md5LvM1o/8P4lfEi1yPfTnFqd7c841CTNmylTJXW3YoSa11YohS
	zK1+u+XhVunmzsQGnisKXUosxRmJhlrMRcWJADSkoHo8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add defines for regulator operating modes which should be more readable,
especially if one does not have Maxim 77686 datasheet.

The patch does not introduce any functional change.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77686.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index ef1af2debbd2..3d0922051488 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -45,6 +45,25 @@
 #define MAX77686_DVS_MINUV	600000
 #define MAX77686_DVS_UVSTEP	12500
 
+/* Values used for configuring Buck[1234] */
+#define MAX77686_BUCK_OFF_PWRREQ	0x1
+#define MAX77686_BUCK_LOWPOWER		0x2
+#define MAX77686_BUCK_NORMAL		0x3
+
+/*
+ * Values used for configuring LDOn:
+ *  - LDO1, 3-5, 9, 13, 17-26: forcing low power mode
+ */
+#define MAX77686_LDO_LOWPOWER		0x1
+/*
+ * In the same time for LDOn:
+ *  - LDO2, 6-8, 10-12, 14-16: on/off controlled by PWRREQ
+ */
+#define MAX77686_LDO_OFF_PWRREQ		0x1
+/* Low power mode controlled by PWRREQ */
+#define MAX77686_LDO_LOWPOWER_PWRREQ	0x2
+#define MAX77686_LDO_NORMAL		0x3
+
 #define MAX77686_OPMODE_SHIFT	6
 #define MAX77686_OPMODE_BUCK234_SHIFT	4
 #define MAX77686_OPMODE_MASK	0x3
@@ -76,9 +95,10 @@ static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
 	int ret, id = rdev_get_id(rdev);
 
 	if (id == MAX77686_BUCK1)
-		val = 0x1;
+		val = MAX77686_BUCK_OFF_PWRREQ;
 	else
-		val = 0x1 << MAX77686_OPMODE_BUCK234_SHIFT;
+		val = MAX77686_BUCK_OFF_PWRREQ
+			<< MAX77686_OPMODE_BUCK234_SHIFT;
 
 	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				 rdev->desc->enable_mask, val);
@@ -103,10 +123,10 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
 
 	switch (mode) {
 	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
-		val = 0x2 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_LDO_LOWPOWER_PWRREQ << MAX77686_OPMODE_SHIFT;
 		break;
 	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = 0x3 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_LDO_NORMAL << MAX77686_OPMODE_SHIFT;
 		break;
 	default:
 		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
@@ -133,13 +153,13 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 
 	switch (mode) {
 	case REGULATOR_MODE_STANDBY:			/* switch off */
-		val = 0x1 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_LDO_OFF_PWRREQ << MAX77686_OPMODE_SHIFT;
 		break;
 	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
-		val = 0x2 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_LDO_LOWPOWER_PWRREQ << MAX77686_OPMODE_SHIFT;
 		break;
 	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = 0x3 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_LDO_NORMAL << MAX77686_OPMODE_SHIFT;
 		break;
 	default:
 		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
-- 
1.9.1

