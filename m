Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaJULYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:24:04 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10437 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbaJULYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:24:00 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-1a-5446424eea74
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
Subject: [PATCH v2 1/4] regulator: max77686: Replace hard-coded opmode values
 with defines
Date: Tue, 21 Oct 2014 13:23:14 +0200
Message-id: <1413890597-31037-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com>
References: <1413890597-31037-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xK7p+Tm4hBhf6WCw2zljPajFp3QEm
	i6kPn7BZXP/ynNVi/pFzrBZHfxdYvH5haNG74CqbxdmmN+wW3650MFlsenyN1eLyrjlsFjPO
	72OyuH2Z12LtkbvsDvweLc09bB5/n19n8fi76gWzx85Zd9k9Nq3qZPPYvKTeo2/LKkaPz5vk
	AjiiuGxSUnMyy1KL9O0SuDL2909hLHgiWrFg9iHWBsYfgl2MnBwSAiYSD1svsEPYYhIX7q1n
	62Lk4hASWMoo8enaQVYIp49J4sXy42wgVWwCxhKbly8Bs0UE9jNJPJ5gAlLELLCaSeLnlVPM
	XYwcHMICMRJfruSB1LAIqEo0dPQwg9i8Au4Skz5NZYbYJidx8thkVhCbU8BD4s71DrArhIBq
	Vh+cwzqBkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJDg/bKDcfExq0OMAhyMSjy8
	G5a5hgixJpYVV+YeYpTgYFYS4c0VdgsR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwKjrbVR0bpf4
	gWtfhUKLJ1y5/bCVU2VTnPAzy5Q3Lko+ms/9Xu5bVimf6BO+92+AbNRBt4B3/9s2Lj2yW/XC
	FaXzV98dlDI057A4Pe270dfzCbLLFdluViYk+W3b4VT9I9ouXb+Pya7ynmjVd+ar5UVyxtZz
	ZzwxfvdtyQd+92z2P1yKh7gq9yqxFGckGmoxFxUnAgB5bdLtPAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add defines for regulator operating modes which should be more readable,
especially if one does not have Maxim 77686 datasheet.

The patch does not introduce any functional change.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77686.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index ef1af2debbd2..cffe0c69d57d 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -45,6 +45,16 @@
 #define MAX77686_DVS_MINUV	600000
 #define MAX77686_DVS_UVSTEP	12500
 
+/* On/off controlled by PWRREQ */
+#define MAX77686_OPMODE_OFF_PWRREQ	0x1
+/*
+ * For some regulators this means:
+ *  - forcing low power mode.
+ *  - low power mode controlled by PWRREQ.
+ */
+#define MAX77686_OPMODE_LOWPOWER	0x2
+#define MAX77686_OPMODE_NORMAL		0x3
+
 #define MAX77686_OPMODE_SHIFT	6
 #define MAX77686_OPMODE_BUCK234_SHIFT	4
 #define MAX77686_OPMODE_MASK	0x3
@@ -76,9 +86,10 @@ static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
 	int ret, id = rdev_get_id(rdev);
 
 	if (id == MAX77686_BUCK1)
-		val = 0x1;
+		val = MAX77686_OPMODE_OFF_PWRREQ;
 	else
-		val = 0x1 << MAX77686_OPMODE_BUCK234_SHIFT;
+		val = MAX77686_OPMODE_OFF_PWRREQ
+			<< MAX77686_OPMODE_BUCK234_SHIFT;
 
 	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				 rdev->desc->enable_mask, val);
@@ -103,10 +114,10 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
 
 	switch (mode) {
 	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
-		val = 0x2 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_OPMODE_LOWPOWER << MAX77686_OPMODE_SHIFT;
 		break;
 	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = 0x3 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_OPMODE_NORMAL << MAX77686_OPMODE_SHIFT;
 		break;
 	default:
 		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
@@ -133,13 +144,13 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 
 	switch (mode) {
 	case REGULATOR_MODE_STANDBY:			/* switch off */
-		val = 0x1 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_OPMODE_OFF_PWRREQ << MAX77686_OPMODE_SHIFT;
 		break;
 	case REGULATOR_MODE_IDLE:			/* ON in LP Mode */
-		val = 0x2 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_OPMODE_LOWPOWER << MAX77686_OPMODE_SHIFT;
 		break;
 	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = 0x3 << MAX77686_OPMODE_SHIFT;
+		val = MAX77686_OPMODE_NORMAL << MAX77686_OPMODE_SHIFT;
 		break;
 	default:
 		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
-- 
1.9.1

