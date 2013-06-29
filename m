Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab3GHNAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:00:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64421 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3GHM74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:59:56 -0400
X-AuditID: cbfee68e-b7f276d000002279-ef-51dab7cbbf38
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sbkim73@samsung.com, broonie@kernel.org, lgirdwood@gmail.com,
        sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, sachin.kamat@linaro.org,
        yadi.brar01@gmail.com, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [v2 PATCH 4/6] regulator: s2mps11: Convert driver completely to use
 set_ramp_delay callback
Date: Sat, 29 Jun 2013 18:21:18 +0530
Message-id: <1372510280-31931-5-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
References: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSo3t6+61Ag9UTVS2mPnzCZnHgzw5G
	i29XOpgsLu+aw2ZxeMUBJouTf3oZLU53s1pcXPGFyWLu70ZWiznT3zE5cHks+HyF3WPnrLvs
	HptWdbJ53Lm2h81j3slAj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4Mr4sfkSe8FGuYpjP2ew
	NzB2SXYxcnJICJhInD3bwQhhi0lcuLeerYuRi0NIYCmjxLmDP1lgilYcvMoEkVjEKDGhZycz
	hNPGJHHx5EEgh4ODTcBI4tUxO5AGEQEFic29z1hBapgF3jJKLF16A2ySsECaxNmfa8DWsQio
	SrRe72IE6eUVcJV48zoLYpmCROuyQ+wgNqeAm0TX5OtMILYQUMnHPe1gR0gIHGKXmLd4EzvE
	HAGJb5MPsYDMkRCQldh0gBlijqTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKRXnJhbXJqXrpec
	n7uJERgVp/8969vBePOA9SHGZKBxE5mlRJPzgVGVVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1
	oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGBPHK4soXqxuc3m7be1/ltck9ll6vbU1JdfaH
	dm/bcdvUQuLNGmbnJXvmal3Rk3fLVZ6qqRiq1Br50Tn2xaEJoTVxphXFfoxJnn5HWy42br/T
	YWh7b//9t1ndCx87XVDqT3/hkyZ4/aziQqOjR6PaDerT/M4UL12UK5XQwGAwZ7qYE/v/nE4l
	luKMREMt5qLiRADecK9ToAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAd3T228FGtz4Im0x9eETNosDf3Yw
	Wny70sFkcXnXHDaLwysOMFmc/NPLaHG6m9Xi4oovTBZzfzeyWsyZ/o7Jgctjwecr7B47Z91l
	99i0qpPN4861PWwe804GevRtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjB+bL7EXbJSrOPZzBnsDY5dkFyMnh4SAicSKg1eZIGwxiQv31rN1MXJxCAks
	YpSY0LOTGcJpY5K4ePIgkMPBwSZgJPHqmB1Ig4iAgsTm3mesIDXMAm8ZJZYuvcECkhAWSJM4
	+3MNI4jNIqAq0Xq9ixGkl1fAVeLN6yyIZQoSrcsOsYPYnAJuEl2Tr4MdIQRU8nFPO9MERt4F
	jAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj7pn0DsZVDRaHGAU4GJV4eCVO3wwUYk0s
	K67MPcQowcGsJMIrznorUIg3JbGyKrUoP76oNCe1+BBjMtBRE5mlRJPzgekgryTe0NjE3NTY
	1NLEwsTMkjRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoY4xu9+88zaE2oFzhi+SqqwzU2
	eI7R1FPsh7wOZydftFzk1zzhudLiRetjU+ZNSDxx8PbSGt6/vxNcFnw8tMx0i/FnpTppfpuq
	ctFVWdOOynfYMezlk+N6wRTefctIybFjekh1sqNJscusAv3EkCyn2/1VzY171UNObpy9PTub
	qTqpcfpcCQklluKMREMt5qLiRADNLZLy/QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since now we have ramp_delay and ramp_disable as standard regulator
constraints and DT part using it so this patch removes legacy part i.e. getting
ramp_delayxx and ramp_enable from pdata since it can be passed as
standard regulator constraints.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/s2mps11.c |   62 ++++++------------------------------------
 1 files changed, 9 insertions(+), 53 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 4157759..e1aadbd 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -35,11 +35,6 @@ struct s2mps11_info {
 	int ramp_delay16;
 	int ramp_delay7810;
 	int ramp_delay9;
-
-	bool buck6_ramp;
-	bool buck2_ramp;
-	bool buck3_ramp;
-	bool buck4_ramp;
 };
 
 static int get_ramp_delay(int ramp_delay)
@@ -67,26 +62,18 @@ static int s2mps11_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 
 	switch (rdev->desc->id) {
 	case S2MPS11_BUCK2:
-		if (!s2mps11->buck2_ramp)
-			return 0;
 		ramp_delay = s2mps11->ramp_delay2;
 		break;
 	case S2MPS11_BUCK3:
-		if (!s2mps11->buck3_ramp)
-			return 0;
 		ramp_delay = s2mps11->ramp_delay34;
 		break;
 	case S2MPS11_BUCK4:
-		if (!s2mps11->buck4_ramp)
-			return 0;
 		ramp_delay = s2mps11->ramp_delay34;
 		break;
 	case S2MPS11_BUCK5:
 		ramp_delay = s2mps11->ramp_delay5;
 		break;
 	case S2MPS11_BUCK6:
-		if (!s2mps11->buck6_ramp)
-			return 0;
 	case S2MPS11_BUCK1:
 		ramp_delay = s2mps11->ramp_delay16;
 		break;
@@ -415,15 +402,21 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 	struct regulator_config config = { };
 	struct s2mps11_info *s2mps11;
 	int i, ret;
-	unsigned char ramp_enable, ramp_reg = 0;
 
 	s2mps11 = devm_kzalloc(&pdev->dev, sizeof(struct s2mps11_info),
 				GFP_KERNEL);
 	if (!s2mps11)
 		return -ENOMEM;
 
-	if (!iodev->dev->of_node)
-		goto p_data;
+	if (!iodev->dev->of_node) {
+		if (pdata) {
+			goto common_reg;
+		} else {
+			dev_err(pdev->dev.parent,
+				"Platform data or DT node not supplied\n");
+			return -ENODEV;
+		}
+	}
 
 	for (i = 0; i < S2MPS11_REGULATOR_CNT; i++)
 		rdata[i].name = regulators[i].name;
@@ -436,43 +429,6 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 
 	of_regulator_match(&pdev->dev, reg_np, rdata, S2MPS11_REGULATOR_MAX);
 
-	goto common_reg;
-p_data:
-	if (!pdata) {
-		dev_err(pdev->dev.parent, "Platform data not supplied\n");
-		return -ENODEV;
-	}
-
-	s2mps11->ramp_delay2 = pdata->buck2_ramp_delay;
-	s2mps11->ramp_delay34 = pdata->buck34_ramp_delay;
-	s2mps11->ramp_delay5 = pdata->buck5_ramp_delay;
-	s2mps11->ramp_delay16 = pdata->buck16_ramp_delay;
-	s2mps11->ramp_delay7810 = pdata->buck7810_ramp_delay;
-	s2mps11->ramp_delay9 = pdata->buck9_ramp_delay;
-
-	s2mps11->buck6_ramp = pdata->buck6_ramp_enable;
-	s2mps11->buck2_ramp = pdata->buck2_ramp_enable;
-	s2mps11->buck3_ramp = pdata->buck3_ramp_enable;
-	s2mps11->buck4_ramp = pdata->buck4_ramp_enable;
-
-	ramp_enable = (s2mps11->buck2_ramp << 3) | (s2mps11->buck3_ramp << 2) |
-		(s2mps11->buck4_ramp << 1) | s2mps11->buck6_ramp ;
-
-	if (ramp_enable) {
-		if (s2mps11->buck2_ramp)
-			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay2) << 6;
-		if (s2mps11->buck3_ramp || s2mps11->buck4_ramp)
-			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay34) << 4;
-		sec_reg_write(iodev, S2MPS11_REG_RAMP, ramp_reg | ramp_enable);
-	}
-
-	ramp_reg &= 0x00;
-	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay5) << 6;
-	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay16) << 4;
-	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay7810) << 2;
-	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay9);
-	sec_reg_write(iodev, S2MPS11_REG_RAMP_BUCK, ramp_reg);
-
 common_reg:
 	platform_set_drvdata(pdev, s2mps11);
 
-- 
1.7.0.4

