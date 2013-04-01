Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab3DAJrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:47:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20330 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113Ab3DAJrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:47:08 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-a6-5159579a3f77
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 15/27] rtc: rtc-nuc900: use devm_*() functions
Date: Mon, 01 Apr 2013 18:47:06 +0900
Message-id: <001a01ce2ebd$df133e40$9d39bac0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAKsNQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zI91Z4ZGBBqvWWlksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0b93E0vBEcmKi20P2RoYN4l2MXJwSAiYSEx/q97FyAlkiklcuLeeDcQWEljGKDHn
	qhlE3ERi56xm1i5GLqD4IkaJ2x/+M0E4vxglll1cwQxSxSagJvHly2F2kKEiAvoSbS0aIDXM
	Ar2MEmd6d7NDTLWV+HH2O1g9p4CdxJuF8xhB6oWB7FUzS0HCLAKqEhuvNLOA2LxA5Yd3fICy
	BSV+TL4HZjMLaEms33mcCcKWl9i85i0zxC/qEo/+6oKERQSMJF53rIUqEZHY9+IdI8g5EgK3
	2CUOLLvIBrFLQOLb5EMsEL2yEpsOMEP8KylxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNo
	akFyQXFSepGxXnFibnFpXrpecn7uJkZIlPbvYLx7wPoQYzLQ+onMUqLJ+cAozyuJNzQ2M7Iw
	NTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo4eDjfiEwMtHnqyZ
	8aSw4fA1pZUXT0keOZDl1hUi8eDiDVZm/0dd69b/uiM05YfsDZW9Zn6z5BQTlxTq2NcnfxC7
	1/goO/iBae7zk4blv9YKS4bd8zRYeMr3YDHHTrb9k85y5J9+Pi/H2ezUJYG5/z/JV896L3B/
	45LDHzLTGCY6rdYyuML0JkiJpTgj0VCLuag4EQAVRCbO6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd1Z4ZGBBmu/mlosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNG/dxNLwRHJiottD9kaGDeJdjFyckgImEjs
	nNXMCmGLSVy4t56ti5GLQ0hgEaPE7Q//mSCcX4wSyy6uYAapYhNQk/jy5TB7FyMHh4iAvkRb
	iwZIDbNAL6PEmd7d7CA1QgK2Ej/Ofger5xSwk3izcB4jSL0wkL1qZilImEVAVWLjlWYWEJsX
	qPzwjg9QtqDEj8n3wGxmAS2J9TuPM0HY8hKb17xlBhkjIaAu8eivLkhYRMBI4nXHWqgSEYl9
	L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFp4Jn0
	DsZVDRaHGAU4GJV4eCMuRAQKsSaWFVfmHmKU4GBWEuH1+QYU4k1JrKxKLcqPLyrNSS0+xJgM
	9OhEZinR5HxgisoriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6p
	BkbLRT+cC3feC5oQpJl1/smPT9VGnGx2bH/sRKdyrRLofbUyUM7rqU/qJEGO5uxXXqG2DEob
	XY9eFf3yPrebrUdnVUVZ1qS7b45pfJWr65vdflsm0sjS1fPU1/7a1nV8Buv8HjDH9GfmCU34
	lt0R9/yr2czbL6oezqh8l+CmcG+ih1WU2unig0osxRmJhlrMRcWJAAqu9MpHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-nuc900.c |   53 +++++++++------------------------------------
 1 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index 4d9525c..f5dfb6e 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -226,9 +226,9 @@ static int __init nuc900_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct nuc900_rtc *nuc900_rtc;
-	int err = 0;
 
-	nuc900_rtc = kzalloc(sizeof(struct nuc900_rtc), GFP_KERNEL);
+	nuc900_rtc = devm_kzalloc(&pdev->dev, sizeof(struct nuc900_rtc),
+				GFP_KERNEL);
 	if (!nuc900_rtc) {
 		dev_err(&pdev->dev, "kzalloc nuc900_rtc failed\n");
 		return -ENOMEM;
@@ -236,68 +236,37 @@ static int __init nuc900_rtc_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "platform_get_resource failed\n");
-		err = -ENXIO;
-		goto fail1;
+		return -ENXIO;
 	}
 
-	if (!request_mem_region(res->start, resource_size(res),
-				pdev->name)) {
-		dev_err(&pdev->dev, "request_mem_region failed\n");
-		err = -EBUSY;
-		goto fail1;
-	}
-
-	nuc900_rtc->rtc_reg = ioremap(res->start, resource_size(res));
-	if (!nuc900_rtc->rtc_reg) {
-		dev_err(&pdev->dev, "ioremap rtc_reg failed\n");
-		err = -ENOMEM;
-		goto fail2;
-	}
+	nuc900_rtc->rtc_reg = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(nuc900_rtc->rtc_reg))
+		return PTR_ERR(nuc900_rtc->rtc_reg);
 
 	platform_set_drvdata(pdev, nuc900_rtc);
 
-	nuc900_rtc->rtcdev = rtc_device_register(pdev->name, &pdev->dev,
+	nuc900_rtc->rtcdev = devm_rtc_device_register(&pdev->dev, pdev->name,
 						&nuc900_rtc_ops, THIS_MODULE);
 	if (IS_ERR(nuc900_rtc->rtcdev)) {
 		dev_err(&pdev->dev, "rtc device register failed\n");
-		err = PTR_ERR(nuc900_rtc->rtcdev);
-		goto fail3;
+		return PTR_ERR(nuc900_rtc->rtcdev);
 	}
 
 	__raw_writel(__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_TSSR) | MODE24,
 					nuc900_rtc->rtc_reg + REG_RTC_TSSR);
 
 	nuc900_rtc->irq_num = platform_get_irq(pdev, 0);
-	if (request_irq(nuc900_rtc->irq_num, nuc900_rtc_interrupt,
-				0, "nuc900rtc", nuc900_rtc)) {
+	if (devm_request_irq(&pdev->dev, nuc900_rtc->irq_num,
+			nuc900_rtc_interrupt, 0, "nuc900rtc", nuc900_rtc)) {
 		dev_err(&pdev->dev, "NUC900 RTC request irq failed\n");
-		err = -EBUSY;
-		goto fail4;
+		return -EBUSY;
 	}
 
 	return 0;
-
-fail4:	rtc_device_unregister(nuc900_rtc->rtcdev);
-fail3:	iounmap(nuc900_rtc->rtc_reg);
-fail2:	release_mem_region(res->start, resource_size(res));
-fail1:	kfree(nuc900_rtc);
-	return err;
 }
 
 static int __exit nuc900_rtc_remove(struct platform_device *pdev)
 {
-	struct nuc900_rtc *nuc900_rtc = platform_get_drvdata(pdev);
-	struct resource *res;
-
-	free_irq(nuc900_rtc->irq_num, nuc900_rtc);
-	rtc_device_unregister(nuc900_rtc->rtcdev);
-	iounmap(nuc900_rtc->rtc_reg);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	kfree(nuc900_rtc);
-
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


