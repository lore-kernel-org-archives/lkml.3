Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaDUJh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:37:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21881 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaDUJg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:36:29 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-0c-5354e6993d8e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, gg@slimlogic.co.uk, kishon@ti.com, balbi@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        sangjung.woo@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH 7/9] extcon: arizona: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Mon, 21 Apr 2014 18:36:24 +0900
Message-id: <1398072986-17386-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
References: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSoDvzWUiwwekLGhYH79dbTH34hM3i
	35Qb7BbXvzxntejf4mLx+oWhxYWnPWwWZ5vesFtc3jWHzeJ24wo2i+Vv/7NZLNhT4sDjsWlV
	J5vHy4m/2Tz6tqxi9Jg65S+jx/Eb25k8Pm+SC2CL4rJJSc3JLEst0rdL4MqY9ugua8Fm1Yq3
	K3+zNjDeleti5OSQEDCR2LtjLROELSZx4d56ti5GLg4hgaWMEv++/meCKeptv8kGYgsJLGKU
	OHxQBaKoiUmi7e09dpAEm4CWxP4XN8CKRAQUJDb3PmMFsZkFljJJbHpmB2ILCwRLXJsEsoGD
	g0VAVeJOfyxImFfAVWL62Z1Qu+QkPux5BDaSU8BNYt2PblaIva4SHe/7GEH2SgjsY5c4sgfi
	OBYBAYlvkw+xgMyUEJCV2HSAGWKOpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kpFecmFtcmpeu
	l5yfu4kRGBmn/z3r28F484D1IcZkoHETmaVEk/OBkZVXEm9obGZkYWpiamxkbmlGmrCSOO+i
	h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjz3k8ubl2Tf5Vv7vsVGSmx/infde8ZfN4Y
	NOn1NY19JbcUphWoK+6TfPiud5tLfeBOxs01Fx1qrMolCk5b178rKO6RYDm4lit3RaLQFq7a
	GcfvNwuGSzwssmhUO1ThtVDkljy73LxnLizmrDFrXybPeKt0oPy1tHX03hqOg8HrPMQ5W7Y9
	0VRiKc5INNRiLipOBACaGXMGogIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jAd2Zz0KCDRrXyVscvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYLJa//c9msWBPiQOPx6ZV
	nWweLyf+ZvPo27KK0WPqlL+MHsdvbGfy+LxJLoAtqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoQiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6
	viFBcD1GBmggYQ1jxrRHd1kLNqtWvF35m7WB8a5cFyMnh4SAiURv+002CFtM4sK99WC2kMAi
	RonDB1W6GLmA7CYmiba399hBEmwCWhL7X9wAKxIRUJDY3PuMFcRmFljKJLHpmR2ILSwQLHFt
	EsggDg4WAVWJO/2xIGFeAVeJ6Wd3MkHskpP4sOcR2EhOATeJdT+6WSH2ukp0vO9jnMDIu4CR
	YRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcNw9k97BuKrB4hCjAAejEg/vi/yQYCHWxLLi
	ytxDjBIczEoivBHrgUK8KYmVValF+fFFpTmpxYcYk4GOmsgsJZqcD0wJeSXxhsYmZkaWRuaG
	FkbG5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXA6LF4Xux0Tdflb5kYYy68Pjc/wWTO
	K/3VjJ3qHu8OP3mXqmyzrnbPMQuzktfT7a2qwx4G+h4UmN2x4sK0suzOn+7ME7Z6plVtkXWf
	MdNXZtctt9AfTULVFbFLr1Rr/L8mEl793+yLi+IE9Y/z5GbWh3LX7MqcXxqverefgy+9JKXj
	F0tx3zFlJZbijERDLeai4kQAckewpv8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: patches@opensource.wolfsonmicro.com
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-arizona.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 98a14f6..39a15df 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -91,7 +91,7 @@ struct arizona_extcon_info {
 
 	int hpdet_ip;
 
-	struct extcon_dev edev;
+	struct extcon_dev *edev;
 };
 
 static const struct arizona_micd_config micd_default_modes[] = {
@@ -546,7 +546,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 	}
 
 	/* If the cable was removed while measuring ignore the result */
-	ret = extcon_get_cable_state_(&info->edev, ARIZONA_CABLE_MECHANICAL);
+	ret = extcon_get_cable_state_(info->edev, ARIZONA_CABLE_MECHANICAL);
 	if (ret < 0) {
 		dev_err(arizona->dev, "Failed to check cable state: %d\n",
 			ret);
@@ -581,7 +581,7 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 	else
 		report = ARIZONA_CABLE_HEADPHONE;
 
-	ret = extcon_set_cable_state_(&info->edev, report, true);
+	ret = extcon_set_cable_state_(info->edev, report, true);
 	if (ret != 0)
 		dev_err(arizona->dev, "Failed to report HP/line: %d\n",
 			ret);
@@ -664,7 +664,7 @@ err:
 			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
 
 	/* Just report headphone */
-	ret = extcon_update_state(&info->edev,
+	ret = extcon_update_state(info->edev,
 				  1 << ARIZONA_CABLE_HEADPHONE,
 				  1 << ARIZONA_CABLE_HEADPHONE);
 	if (ret != 0)
@@ -723,7 +723,7 @@ err:
 			   ARIZONA_ACCDET_MODE_MASK, ARIZONA_ACCDET_MODE_MIC);
 
 	/* Just report headphone */
-	ret = extcon_update_state(&info->edev,
+	ret = extcon_update_state(info->edev,
 				  1 << ARIZONA_CABLE_HEADPHONE,
 				  1 << ARIZONA_CABLE_HEADPHONE);
 	if (ret != 0)
@@ -764,7 +764,7 @@ static void arizona_micd_detect(struct work_struct *work)
 	mutex_lock(&info->lock);
 
 	/* If the cable was removed while measuring ignore the result */
-	ret = extcon_get_cable_state_(&info->edev, ARIZONA_CABLE_MECHANICAL);
+	ret = extcon_get_cable_state_(info->edev, ARIZONA_CABLE_MECHANICAL);
 	if (ret < 0) {
 		dev_err(arizona->dev, "Failed to check cable state: %d\n",
 				ret);
@@ -812,7 +812,7 @@ static void arizona_micd_detect(struct work_struct *work)
 	if (info->detecting && (val & ARIZONA_MICD_LVL_8)) {
 		arizona_identify_headphone(info);
 
-		ret = extcon_update_state(&info->edev,
+		ret = extcon_update_state(info->edev,
 					  1 << ARIZONA_CABLE_MICROPHONE,
 					  1 << ARIZONA_CABLE_MICROPHONE);
 
@@ -999,7 +999,7 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 
 	if (info->last_jackdet == present) {
 		dev_dbg(arizona->dev, "Detected jack\n");
-		ret = extcon_set_cable_state_(&info->edev,
+		ret = extcon_set_cable_state_(info->edev,
 					      ARIZONA_CABLE_MECHANICAL, true);
 
 		if (ret != 0)
@@ -1038,7 +1038,7 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 					 info->micd_ranges[i].key, 0);
 		input_sync(info->input);
 
-		ret = extcon_update_state(&info->edev, 0xffffffff, 0);
+		ret = extcon_update_state(info->edev, 0xffffffff, 0);
 		if (ret != 0)
 			dev_err(arizona->dev, "Removal report failed: %d\n",
 				ret);
@@ -1151,11 +1151,16 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 		break;
 	}
 
-	info->edev.name = "Headset Jack";
-	info->edev.dev.parent = arizona->dev;
-	info->edev.supported_cable = arizona_cable;
+	info->edev = devm_extcon_dev_allocate(&pdev->dev, arizona_cable);
+	if (!info->edev) {
+		dev_err(&pdev->dev, "failed to allocate extcon device\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+	info->edev->dev.parent = arizona->dev;
+	info->edev->name = "Headset Jack";
 
-	ret = extcon_dev_register(&info->edev);
+	ret = extcon_dev_register(info->edev);
 	if (ret < 0) {
 		dev_err(arizona->dev, "extcon_dev_register() failed: %d\n",
 			ret);
@@ -1410,7 +1415,7 @@ err_rise:
 err_input:
 err_register:
 	pm_runtime_disable(&pdev->dev);
-	extcon_dev_unregister(&info->edev);
+	extcon_dev_unregister(info->edev);
 err:
 	return ret;
 }
@@ -1445,7 +1450,7 @@ static int arizona_extcon_remove(struct platform_device *pdev)
 	regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_ANALOGUE,
 			   ARIZONA_JD1_ENA, 0);
 	arizona_clk32k_disable(arizona);
-	extcon_dev_unregister(&info->edev);
+	extcon_dev_unregister(info->edev);
 
 	return 0;
 }
-- 
1.8.0

