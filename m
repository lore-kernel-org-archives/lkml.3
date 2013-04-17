Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3DQBGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:06:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13741 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3DQBGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:06:49 -0400
X-AuditID: cbfee68e-b7f946d000001e37-3f-516df5a8373e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH RESEND 1/8] rtc: rtc-at91sam9: convert at91_rtc_driver to
 dev_pm_ops
Date: Wed, 17 Apr 2013 10:06:47 +0900
Message-id: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac47B9XUIMaX4YjsSbW0FEYgtMIOOA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zQ90VX3MDDT7OF7ZYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY3vLTOaCU8IVSxp3MDYw/uTvYuTkkBAwkfh8+RorhC0mceHeerYuRi4OIYFljBKr
	nz9jhSl6eHMjO0RiEaPEh0VfmCGcX4wSMz7OA6tiE1CT+PLlMFAVB4eIgL5EW4sGSA2zQC+j
	xJne3ewgNcICYRKPns5gBLFZBFQlTtybAtbLK2Ar0dt/iQXCFpT4MfkemM0soCWxfudxJghb
	XmLzmrfMIPMlBNQlHv3VBQmLCOhJ9B28ygxRIiKx78U7RpC9EgLH2CVWvpvKDrFLQOLb5EMs
	EL2yEpsOMEM8JilxcMUNlgmMYrOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGRXnFibnFp
	Xrpecn7uJkZI7PXtYLx5wPoQYzLQ+onMUqLJ+cDYzSuJNzQ2M7IwNTE1NjK3NCNNWEmcV63F
	OlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo/siIX7Jp8Vn3tR1OK+ZJqPWOz+u/n/mJI4O
	7eu2n6a3bWA3M81/2ZD/gKUnaav+T6Yeq9Vf6ypObP0pPVntV/nWhWJqR2fcX/HMdN2mG2lu
	XmL/r8nx9gVdfrt06a7uE4/+/Ax4U6y+aZFhfZNOhJCG0yQ1iXVXv92ad0DMYprotP0KezhY
	3JVYijMSDbWYi4oTAeraHznTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd0VX3MDDc6t4rNYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWN7y0zmglPCFUsadzA2MP7k72Lk5JAQMJF4
	eHMjO4QtJnHh3nq2LkYuDiGBRYwSHxZ9YYZwfjFKzPg4jxWkik1ATeLLl8NAHRwcIgL6Em0t
	GiA1zAK9jBJneneDTRIWCJN49HQGI4jNIqAqceLeFLBeXgFbid7+SywQtqDEj8n3wGxmAS2J
	9TuPM0HY8hKb17xlBpkvIaAu8eivLkhYREBPou/gVWaIEhGJfS/eMU5gFJiFZNIsJJNmIZk0
	C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBkf1MegfjqgaLQ4wCHIxKPLwXCnID
	hVgTy4orcw8xSnAwK4nwKq4CCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MOnklcQbGpuY
	GVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOji6VOyMPYeIYHruuz5iyy
	aLx95uMFi3UOpY2xVy3jWbTye0JVNYIemDLvrkx4k5wfnvdzhrKxenNinKZ245M1VwR1orbe
	E56wOGKmsiy73XXX56tNjh5mOsMeOXOVhnPXXzWfb6+Zmc1z5u8NPKHk5+O/zeD+lzzNml/X
	FiaXzM8XbjJmKlFiKc5INNRiLipOBACzP12GMAMAAA==
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


