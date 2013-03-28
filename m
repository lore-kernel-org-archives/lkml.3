Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab3C1IhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:37:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9731 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab3C1IhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:37:04 -0400
X-AuditID: cbfee68e-b7f946d000001e37-f6-5154011da393
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/8] rtc: rtc-at91sam9: convert at91_rtc_driver to dev_pm_ops
Date: Thu, 28 Mar 2013 17:36:45 +0900
Message-id: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4rj2FhCGvCEF7CQ36UwoHUUgpQOw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zfV05xpBAg3WrmCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK2N4yk7nglHDFksYdjA2MP/m7GDk5JARMJA6/eMgKYYtJXLi3nq2LkYtDSGAZo8S+
	1Y1sMEWfTx1ngUhMZ5T4NbmVGcL5xSjRtuAUI0gVm4CaxJcvh9m7GDk4RAT0JdpaNEBqmAV6
	GSXO9O5mB6kRFvCVuPfuG9hUFgFViWWP97CA2LwCthKNzftZIWxBiR+T74HFmQW0JNbvPM4E
	YctLbF7zlhlkvoSAusSjv7oQq/Qkfn6yhKgQkdj34h0jyFoJgWPsEu8PrWKCWCUg8W3yIRaI
	VlmJTQeYIf6SlDi44gbLBEaxWUgWz0KyeBaSxbOQrFjAyLKKUTS1ILmgOCm9yEivODG3uDQv
	XS85P3cTIyTy+nYw3jxgfYgxGWj9RGYp0eR8YOTmlcQbGpsZWZiamBobmVuakSasJM6r1mId
	KCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHR9ZPbfA999q1sHXPkGuwiHDJWxImt7HeQ4243
	MvtvLle2JLLh/+N9LFPXBPilNa0MdZj00OSh9ddXAbUd214uXSN91XuFT8L6GrXSDZfMCuuj
	u/i2HC8LbdOwW1CQ9+lqvsOp0LA70347Wl05PjEt1drYzWByAwOjkqFb5J24bh+FBq2715VY
	ijMSDbWYi4oTAd6RJH7SAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQV1ZxpBAg8sPrCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNjeMpO54JRwxZLGHYwNjD/5uxg5OSQETCQ+
	nzrOAmGLSVy4t56ti5GLQ0hgOqPEr8mtzBDOL0aJtgWnGEGq2ATUJL58OczexcjBISKgL9HW
	ogFSwyzQyyhxpnc3O0iNsICvxL1339hAbBYBVYllj/eAbeAVsJVobN7PCmELSvyYfA8sziyg
	JbF+53EmCFteYvOat8wg8yUE1CUe/dWFWKUn8fOTJUSFiMS+F+8YJzAKzEIyaBaSQbOQDJqF
	pGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOC4fia9g3FVg8UhRgEORiUe3gqB4EAh
	1sSy4srcQ4wSHMxKIryHOoFCvCmJlVWpRfnxRaU5qcWHGJOB/pzILCWanA9MOXkl8YbGJmZG
	lkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwKjmbO6wtmDnzRIBvozEPWJm
	St0FVc938l+TP74mfKLPj3977vOJmOVvW2+yI1TAYdMpj+8nBEpe/g9oE6ld9PxlGWfN0+Xv
	pUwms2wucOaZcXvDbMmL16K2ORgUfWU47xjRe+zgkgXrb0ZPrT397vgL3YBPfosT/tbGPVbk
	c/W6u/EBRyNbGosSS3FGoqEWc1FxIgCpLtpULwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-at91sam9.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 39cfd2e..4843e42 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -414,14 +414,13 @@ static void at91_rtc_shutdown(struct platform_device *pdev)
 	rtt_writel(rtc, MR, mr & ~rtc->imr);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 /* AT91SAM9 RTC Power management control */
 
-static int at91_rtc_suspend(struct platform_device *pdev,
-					pm_message_t state)
+static int at91_rtc_suspend(struct device *dev)
 {
-	struct sam9_rtc	*rtc = platform_get_drvdata(pdev);
+	struct sam9_rtc	*rtc = dev_get_drvdata(dev);
 	u32		mr = rtt_readl(rtc, MR);
 
 	/*
@@ -430,7 +429,7 @@ static int at91_rtc_suspend(struct platform_device *pdev,
 	 */
 	rtc->imr = mr & (AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
 	if (rtc->imr) {
-		if (device_may_wakeup(&pdev->dev) && (mr & AT91_RTT_ALMIEN)) {
+		if (device_may_wakeup(dev) && (mr & AT91_RTT_ALMIEN)) {
 			enable_irq_wake(rtc->irq);
 			/* don't let RTTINC cause wakeups */
 			if (mr & AT91_RTT_RTTINCIEN)
@@ -442,13 +441,13 @@ static int at91_rtc_suspend(struct platform_device *pdev,
 	return 0;
 }
 
-static int at91_rtc_resume(struct platform_device *pdev)
+static int at91_rtc_resume(struct device *dev)
 {
-	struct sam9_rtc	*rtc = platform_get_drvdata(pdev);
+	struct sam9_rtc	*rtc = dev_get_drvdata(dev);
 	u32		mr;
 
 	if (rtc->imr) {
-		if (device_may_wakeup(&pdev->dev))
+		if (device_may_wakeup(dev))
 			disable_irq_wake(rtc->irq);
 		mr = rtt_readl(rtc, MR);
 		rtt_writel(rtc, MR, mr | rtc->imr);
@@ -456,20 +455,18 @@ static int at91_rtc_resume(struct platform_device *pdev)
 
 	return 0;
 }
-#else
-#define at91_rtc_suspend	NULL
-#define at91_rtc_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops, at91_rtc_suspend, at91_rtc_resume);
+
 static struct platform_driver at91_rtc_driver = {
 	.probe		= at91_rtc_probe,
 	.remove		= at91_rtc_remove,
 	.shutdown	= at91_rtc_shutdown,
-	.suspend	= at91_rtc_suspend,
-	.resume		= at91_rtc_resume,
 	.driver		= {
 		.name	= "rtc-at91sam9",
 		.owner	= THIS_MODULE,
+		.pm	= &at91_rtc_pm_ops,
 	},
 };
 
-- 
1.7.2.5


