Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab3DAJmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:42:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46953 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab3DAJmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:42:05 -0400
X-AuditID: cbfee690-b7f656d0000007e3-93-5159566b7bae
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/27] rtc: rtc-ab8500: use devm_*() functions
Date: Mon, 01 Apr 2013 18:42:02 +0900
Message-id: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zQ93ssMhAg5M/hSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKONgyh7ngAU/F9H23mBoYT3B1MXJySAiYSKw/eIINwhaTuHBvPZDNxSEksIxR4nDr
	R2aYogVrjrFAJBYxSrzcf5oZwvnFKHH2zhUWkCo2ATWJL18Os3cxcnCICOhLtLVogNQwC/Qy
	Spzp3c0OUiMsYCfx7t0esBoWAVWJya/BFvAK2Eq8bf/FBGELSvyYfA9sJLOAlsT6nceZIGx5
	ic1r3jKDtEoIqEs8+qsLEhYR0JN4vugNO0SJiMS+F+8YQdZKCBxjlzjy7yvYHBYBAYlvkw+x
	QPTKSmw6APWXpMTBFTdYJjCKzUKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRSZ6xYm5xaV5
	6XrJ+bmbGCGRN2EH470D1ocYk4HWT2SWEk3OB0ZuXkm8obGZkYWpiamxkbmlGWnCSuK86i3W
	gUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY7W1fvn75bdmXf0efzfA7uPrgsWIGndI92uv3
	y8/+ffuy/52qqCNBfAei78q6zfAt1P+/O4Tl8dSXb/J3TFI+66yxWj30ifunSoF5HyrW7pl4
	/JwbR5WivpBv75HX6qIJe49/OqN3l5XhmYgiV5tdy33drBv6VgFlsReXxO9wLHk1iWXe0ms1
	k5RYijMSDbWYi4oTAUX6Pm3SAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd3ssMhAg41z+CyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDjYMoe54AFPxfR9t5gaGE9wdTFyckgImEgs
	WHOMBcIWk7hwbz1bFyMXh5DAIkaJl/tPM0M4vxglzt65AlbFJqAm8eXLYfYuRg4OEQF9ibYW
	DZAaZoFeRokzvbvZQWqEBewk3r3bA1bDIqAqMfk1M0iYV8BW4m37LyYIW1Dix+R7YCOZBbQk
	1u88zgRhy0tsXvOWGaRVQkBd4tFfXZCwiICexPNFb9ghSkQk9r14xziBUWAWkkmzkEyahWTS
	LCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx/UzqR2MKxssDjEKcDAq8fBGXIgI
	FGJNLCuuzD3EKMHBrCTC6/MNKMSbklhZlVqUH19UmpNafIgxGejPicxSosn5wJSTVxJvaGxi
	ZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MnNuj+e1ygiZkbTU/YrF+
	ofWaykgHPkGL0w4xfKyOHZHKpY7n1mYeOZX2qYY/0UXigxV/bOqT2y2OLPKL1OfGn+++6L6m
	hXnX2v6YCBuVrp3sTMFq2U3d3sXT4wTvBUwOv7a0omnZXVfxM+F1cXdmP613CV7Y+F7mUKBS
	ypLohF2rVvpMnqzEUpyRaKjFXFScCAC8uip7LwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ab8500.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index 57cde2b..63cfa31 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -422,20 +422,19 @@ static int ab8500_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, true);
 
-	rtc = rtc_device_register("ab8500-rtc", &pdev->dev, &ab8500_rtc_ops,
-			THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, "ab8500-rtc",
+					&ab8500_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		dev_err(&pdev->dev, "Registration failed\n");
 		err = PTR_ERR(rtc);
 		return err;
 	}
 
-	err = request_threaded_irq(irq, NULL, rtc_alarm_handler,
-		IRQF_NO_SUSPEND | IRQF_ONESHOT, "ab8500-rtc", rtc);
-	if (err < 0) {
-		rtc_device_unregister(rtc);
+	err = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+			rtc_alarm_handler, IRQF_NO_SUSPEND | IRQF_ONESHOT,
+			"ab8500-rtc", rtc);
+	if (err < 0)
 		return err;
-	}
 
 	platform_set_drvdata(pdev, rtc);
 
@@ -450,13 +449,8 @@ static int ab8500_rtc_probe(struct platform_device *pdev)
 
 static int ab8500_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	int irq = platform_get_irq_byname(pdev, "ALARM");
-
 	ab8500_sysfs_rtc_unregister(&pdev->dev);
 
-	free_irq(irq, rtc);
-	rtc_device_unregister(rtc);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


