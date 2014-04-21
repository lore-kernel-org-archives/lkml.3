Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaDUMDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:03:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42749 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaDUMCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:02:22 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-ae-535508cc106e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>,
        patches@opensource.wolfsonmicro.com
Subject: [PATCHv2 7/9] extcon: arizona: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Mon, 21 Apr 2014 21:02:20 +0900
Message-id: <1398081742-24277-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSrHuGIzTY4F2jmcXB+/UWUx8+YbP4
	N+UGu8X1L89ZLfq3uFi8fmFoceFpD5vF2aY37BaXd81hs7jduILNYvnb/2wO3B6bVnWyebyc
	+JvNo2/LKkaPqVP+Mnocv7GdyePzJrkAtigum5TUnMyy1CJ9uwSujOn/n7MUHFKs+Pz2CmMD
	417pLkZODgkBE4n5ky6yQNhiEhfurWfrYuTiEBJYyihx/OVOdpiiVcsvQyUWMUp0nupnhnCa
	mCR+/F3GBFLFJqAlsf/FDTYQW0RAQWJz7zNWkCJmgW4mic0zFgN1cHAIC4RKPF2nB1LDIqAq
	cXNdM9hqXgFXiY6PB6HOkJP4sOcRO0g5p4CbxIUT5SBhIaCSR783M4KMlBDYxy6xoPU0O8Qc
	AYlvkw+xgNRLCMhKbDrADDFGUuLgihssExiFFzAyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P
	3cQIjInT/55N2MF474D1IcZkoHETmaVEk/OBMZVXEm9obGZkYWpiamxkbmlGmrCSOK/ao6Qg
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyZrXfsQlvW+adOmKhmq/7b9uL8+oPun986Z77Z
	Xtj/IkY6yUV34pQfbpNDIrvmPDxZE9lW/3FvZtvz08yWjx+IvniROinB78Y+XvvWjlW3L89P
	uafyKtDJbef/3O2pZjbfZp2t8KtRFrn6ab9qy14NnX8T/y6fFPo2UuKXf+pfs76EyAC3uduV
	WIozEg21mIuKEwFL61m3nwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jAd0zHKHBBuu6dS0O3q+3mPrwCZvF
	vyk32C2uf3nOatG/xcXi9QtDiwtPe9gszja9Ybe4vGsOm8XtxhVsFsvf/mdz4PbYtKqTzePl
	xN9sHn1bVjF6TJ3yl9Hj+I3tTB6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcyY/v85S8EhxYrPb68wNjDule5i5OSQEDCRWLX8MhuELSZx4d56IJuLQ0hgEaNE
	56l+ZginiUnix99lTCBVbAJaEvtf3ADrEBFQkNjc+4wVpIhZoJtJYvOMxUAdHBzCAqEST9fp
	gdSwCKhK3FzXzAJi8wq4SnR8PMgCsU1O4sOeR+wg5ZwCbhIXTpSDhIWASh793sw4gZF3ASPD
	KkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgiHsmtYNxZYPFIUYBDkYlHt4ZJSHBQqyJZcWV
	uYcYJTiYlUR4I9YDhXhTEiurUovy44tKc1KLDzEmAx01kVlKNDkfmAzySuINjU3MjCyNzA0t
	jIzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGRuy9dxknvn3B32PxVHg2CJunC7y6J
	HNnSqHgvWq4lb/aG/3dvHmwMu7lITXUfm5laUKh+g2PT0cQVFa9+T23IUb0U8PLjU6krzByX
	ojbJL2fLlys/X3NYg9tN5tjDi0rG2TpfOQLebhMN2HM1yEvg3qXpXexzXnhcK/rKxfepPa72
	xNUXMveVWIozEg21mIuKEwHLbbyP/AIAAA==
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

