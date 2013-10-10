Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3JJBln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 21:41:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22524 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab3JJBll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 21:41:41 -0400
X-AuditID: cbfee68e-b7f756d000004512-10-525605d34ed0
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org, lgirdwood@gmail.com, sbkim73@samsung.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        YoungJun Cho <yj44.cho@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] regulator: s5m8767: Modify parsing method of the voltage
 table of buck2/3/4
Date: Thu, 10 Oct 2013 10:41:36 +0900
Message-id: <1381369296-17101-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1381369296-17101-1-git-send-email-cw00.choi@samsung.com>
References: <1381369296-17101-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkRPcKa1iQwa1nrBZTHz5hs7j+5Tmr
	xfwj51gtzja9Ybf4dqWDyeLyrjlsFhdXfGGy2LtzMqMDh8fOWXfZPTat6mTz6NuyitHj8ya5
	AJYoLpuU1JzMstQifbsErowDO9IKlstWbLqxg7mBca9EFyMHh4SAicTyG5ZdjJxAppjEhXvr
	2boYuTiEBJYySjzt/skOkTCR2Ll4CjtEYhGjxJ5Vh6CqGpkkJv+7zwJSxSagJbH/xQ02kKki
	Ag4SkxfogtQwC2xjlGje/IUNpEZYIEnixLqXYFNZBFQlrp1qBLN5BVwlDjZ2Qm2Tk/iw5xGY
	zSngJnH75AcmEFsIqObH+hlgiyUEprNLNN5ewwwxSEDi2+RDLBDvyEpsOsAMMUdS4uCKGywT
	GIUXMDKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAgM8tP/nvXtYLx5wPoQYzLQuInMUqLJ
	+cAoySuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD
	o8HFDskOaY9X1z3+3Jv7wqHwynKB9MdPc+daJdt9OqgQs3hn56pfZXePO5omfzTxck0Lqrc9
	uSasQ0GxK5MveOuJPpeOl7/0+Q5vDW4Jr1qfsqx0YtuhrQ/MC4RWBLpc71h2r7SF55NL8eZY
	9vu2f05VnlTz8b3v19guu2hjZ/kB8zWcod8FlViKMxINtZiLihMBwxmc44gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jAd3LrGFBBld2W1lMffiEzeL6l+es
	FvOPnGO1ONv0ht3i25UOJovLu+awWVxc8YXJYu/OyYwOHB47Z91l99i0qpPNo2/LKkaPz5vk
	AliiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmHNiRVrBctmLTjR3MDYx7
	JboYOTkkBEwkdi6ewg5hi0lcuLeerYuRi0NIYBGjxJ5Vh6CcRiaJyf/us4BUsQloSex/cQMo
	wcEhIuAgMXmBLkgNs8A2RonmzV/YQGqEBZIkTqx7CTaVRUBV4tqpRjCbV8BV4mBjJ9Q2OYkP
	ex6B2ZwCbhK3T35gArGFgGp+rJ/BNoGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M
	4Ch6JrWDcWWDxSFGAQ5GJR7eirLQICHWxLLiytxDjBIczEoivNNPAoV4UxIrq1KL8uOLSnNS
	iw8xJgNdNZFZSjQ5HxjheSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZ
	wsTBKdXAWLrskqbjQ5bTzn0P/JxWvbhtcP55BjPnljkty+I1QmTm114KT5k8/VEuR8y+vV5T
	D20MP37sVp5ZhK8pT33bRt4/zj8MzO8lNDryK0y/6H+WWZ9D8t3T/G1JPPc2XmDiCteOsHJq
	6fcpNS1IE56TNFlwRb1Tgo/EccPuiXv9rxha6tYsnPpUiaU4I9FQi7moOBEAiCiwN+YCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The s5m8767 regulator driver parse always the voltage table of buck2/3/4.
If gpio_dvs feature isn't used and dts haven't included the voltage table
of buck2/3/4, s5m8767 regulator driver return error and file probe state.

This patch check only voltage table of buck on s5m8767_pmic_dt_parse_pdata()
if buck[2-4]_gpiodvs is true.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/s5m8767.c | 54 +++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index cb6cdb3..29999c0 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -522,7 +522,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 	struct device_node *pmic_np, *regulators_np, *reg_np;
 	struct sec_regulator_data *rdata;
 	struct sec_opmode_data *rmode;
-	unsigned int i, dvs_voltage_nr = 1, ret;
+	unsigned int i, dvs_voltage_nr = 8, ret;
 
 	pmic_np = iodev->dev->of_node;
 	if (!pmic_np) {
@@ -586,15 +586,39 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 		rmode++;
 	}
 
-	if (of_get_property(pmic_np, "s5m8767,pmic-buck2-uses-gpio-dvs", NULL))
+	if (of_get_property(pmic_np, "s5m8767,pmic-buck2-uses-gpio-dvs", NULL)) {
 		pdata->buck2_gpiodvs = true;
 
-	if (of_get_property(pmic_np, "s5m8767,pmic-buck3-uses-gpio-dvs", NULL))
+		if (of_property_read_u32_array(pmic_np,
+				"s5m8767,pmic-buck2-dvs-voltage",
+				pdata->buck2_voltage, dvs_voltage_nr)) {
+			dev_err(iodev->dev, "buck2 voltages not specified\n");
+			return -EINVAL;
+		}
+	}
+
+	if (of_get_property(pmic_np, "s5m8767,pmic-buck3-uses-gpio-dvs", NULL)) {
 		pdata->buck3_gpiodvs = true;
 
-	if (of_get_property(pmic_np, "s5m8767,pmic-buck4-uses-gpio-dvs", NULL))
+		if (of_property_read_u32_array(pmic_np,
+				"s5m8767,pmic-buck3-dvs-voltage",
+				pdata->buck3_voltage, dvs_voltage_nr)) {
+			dev_err(iodev->dev, "buck3 voltages not specified\n");
+			return -EINVAL;
+		}
+	}
+
+	if (of_get_property(pmic_np, "s5m8767,pmic-buck4-uses-gpio-dvs", NULL)) {
 		pdata->buck4_gpiodvs = true;
 
+		if (of_property_read_u32_array(pmic_np,
+				"s5m8767,pmic-buck4-dvs-voltage",
+				pdata->buck4_voltage, dvs_voltage_nr)) {
+			dev_err(iodev->dev, "buck4 voltages not specified\n");
+			return -EINVAL;
+		}
+	}
+
 	if (pdata->buck2_gpiodvs || pdata->buck3_gpiodvs ||
 						pdata->buck4_gpiodvs) {
 		ret = s5m8767_pmic_dt_parse_dvs_gpio(iodev, pdata, pmic_np);
@@ -612,34 +636,12 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 				"invalid value for default dvs index, use 0\n");
 			}
 		}
-		dvs_voltage_nr = 8;
 	}
 
 	ret = s5m8767_pmic_dt_parse_ds_gpio(iodev, pdata, pmic_np);
 	if (ret)
 		return -EINVAL;
 
-	if (of_property_read_u32_array(pmic_np,
-				"s5m8767,pmic-buck2-dvs-voltage",
-				pdata->buck2_voltage, dvs_voltage_nr)) {
-		dev_err(iodev->dev, "buck2 voltages not specified\n");
-		return -EINVAL;
-	}
-
-	if (of_property_read_u32_array(pmic_np,
-				"s5m8767,pmic-buck3-dvs-voltage",
-				pdata->buck3_voltage, dvs_voltage_nr)) {
-		dev_err(iodev->dev, "buck3 voltages not specified\n");
-		return -EINVAL;
-	}
-
-	if (of_property_read_u32_array(pmic_np,
-				"s5m8767,pmic-buck4-dvs-voltage",
-				pdata->buck4_voltage, dvs_voltage_nr)) {
-		dev_err(iodev->dev, "buck4 voltages not specified\n");
-		return -EINVAL;
-	}
-
 	if (of_get_property(pmic_np, "s5m8767,pmic-buck2-ramp-enable", NULL))
 		pdata->buck2_ramp_enable = true;
 
-- 
1.8.0

