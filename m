Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbaDXMfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:35:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33461 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbaDXMe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:34:58 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-e1-535904f027fa
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>,
        patches@opensource.wolfsonmicro.com
Subject: [PATCHv3 6/9] extcon: arizona: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Thu, 24 Apr 2014 21:34:54 +0900
Message-id: <1398342897-23670-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSpPuBJTLYYOcFPYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbxfK3/9kcuD02repk83g5
	8TebR9+WVYweU6f8ZfQ4fmM7k8fnTXIBbFFcNimpOZllqUX6dglcGUuPWhQ0KVW8fr+BrYHx
	h3QXIyeHhICJxMFbT1ggbDGJC/fWs3UxcnEICSxllHjy+B87TNGchdvYIRLTGSV2HD/GDJIQ
	Emhikpi+3RDEZhPQktj/4gYbiC0ioCCxufcZK0gDs0A3k8TmGYvBGoQFQiXmzukAW8cioCox
	bfNWJhCbV8BVYuOnr1Db5CQ+7HkEZnMKuEmcvXCVDWKZq8TKhn9gQyUE9rFLzPx2kwlikIDE
	t8mHgIZyACVkJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525i
	BMbE6X/PJuxgvHfA+hBjMtC4icxSosn5wJjKK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBA
	emJJanZqakFqUXxRaU5q8SFGJg5OqQbG5rgZDDX2a5aurN0h0Fw0696z/vLdp30PCW242Jcu
	falR/MHLTQKLds61+bJ/UnXt/aj0XYf8qtpET3gWJ+w5WCMxr8v93VYHm8JCr8SVLlEn5cIs
	bxcbdUul114W1jwpEZA9UVvybuJCC5Z/nXY5JfcN3sndW3b5b6ruTsewGaHBiU039rEqsRRn
	JBpqMRcVJwIAYZC8558CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jQd0PLJHBBocfq1ocvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYLJa//c/mwO2xaVUnm8fL
	ib/ZPPq2rGL0mDrlL6PH8RvbmTw+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBc
	j5EBGkhYw5ix9KhFQZNSxev3G9gaGH9IdzFyckgImEjMWbiNHcIWk7hwbz1bFyMXh5DAdEaJ
	HcePMYMkhASamCSmbzcEsdkEtCT2v7jBBmKLCChIbO59xgrSwCzQzSSxecZisAZhgVCJuXM6
	WEBsFgFViWmbtzKB2LwCrhIbP32F2iYn8WHPIzCbU8BN4uyFq2wQy1wlVjb8Y53AyLuAkWEV
	o2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDEPZPewbiqweIQowAHoxIPr8Kt8GAh1sSy4src
	Q4wSHMxKIryz/0UEC/GmJFZWpRblxxeV5qQWH2JMBrpqIrOUaHI+MBnklcQbGpuYGVkamRta
	GBmbkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAPjHJ61t25sYxO2XLtyV7du4oLOnr9i
	P7fMWufuXh83q9GSKXR93yWebS6Byi8F39gr8nHrPyhekVX6g/nXo4NSd5ZtXvbF78DqpjKv
	Jubmvgc2z+MW/vuudvuG6G/1TzkGSZvEN7o5aS1o2aXctZS18V79zxMR849yb75ibtCjZHSq
	MHHz7d1VSizFGYmGWsxFxYkAhw+//fwCAAA=
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
Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index f63fa6f..78931f1 100644
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
@@ -1150,11 +1150,16 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 		break;
 	}
 
-	info->edev.name = "Headset Jack";
-	info->edev.dev.parent = arizona->dev;
-	info->edev.supported_cable = arizona_cable;
+	info->edev = devm_extcon_dev_allocate(&pdev->dev, arizona_cable);
+	if (!info->edev) {
+		dev_err(&pdev->dev, "failed to allocate extcon device\n");
+		return -ENOMEM;
+	}
+	info->edev->name = "Headset Jack";
+	info->edev->dev.parent = arizona->dev;
+
 
-	ret = devm_extcon_dev_register(&pdev->dev, &info->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret < 0) {
 		dev_err(arizona->dev, "extcon_dev_register() failed: %d\n",
 			ret);
-- 
1.8.0

