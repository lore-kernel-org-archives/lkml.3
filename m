Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbaJUNVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:21:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18140 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbaJUNUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:20:10 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-cc-54465d86368c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 1/4] regulator: max77686: Replace hard-coded opmode values
 with defines
Date: Tue, 21 Oct 2014 15:19:52 +0200
Message-id: <1413897595-28752-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413897595-28752-1-git-send-email-k.kozlowski@samsung.com>
References: <1413897595-28752-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t/xy7rtsW4hBrM9LDbOWM9qMWndASaL
	qQ+fsFlc//Kc1WL+kXOsFkd/F1i8fmFo0bvgKpvF2aY37Bb3vx5ltPh2pYPJYtPja6wWl3fN
	YbOYcX4fk8Xty7wWa4/cZbc43c3qIOjR0tzD5vH3+XUWj7+rXjB77Jx1l91j06pONo871/aw
	ecw7GeixeUm9R9+WVYwenzfJBXBFcdmkpOZklqUW6dslcGVMbjMt6JGoePBrN2sD42vhLkZO
	DgkBE4lTBy+yQNhiEhfurWfrYuTiEBJYyijx9/JKdginj0ni16YZzCBVbALGEpuXL2EDsUUE
	OpklvnwPACliFljNJPHzyimwImGBGIk52w4wgdgsAqoSn8/PYgSxeQXcJaaf+s8IsU5O4uSx
	yawgNqeAh8Tv3XuB4hxA29wlrn1OncDIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZG
	SHB/2cG4+JjVIUYBDkYlHt4Ny1xDhFgTy4orcw8xSnAwK4nw5gq7hQjxpiRWVqUW5ccXleak
	Fh9iZOLglGpglJl9bOom29OVJQazvq1J9uTa95+/Z1rv5e89i5/MPfzP5cNbKZ/FJQf37u5b
	mXWZ00mwPENEuV2z7uF1a26ZGeeF1NK3PJeyag6fWvszdp5+752IGt1T4u9fd1S3/exceb3m
	10+JA9sDH1gmylyP36tRk9PIfn52pcGZml9r1iX9unHSlTmGSYmlOCPRUIu5qDgRAAUYB51M	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add defines for regulator operating modes which should be more readable,
especially if one does not have Maxim 77686 datasheet.

The patch does not introduce any functional change.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
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

