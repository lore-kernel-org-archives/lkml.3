Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab3C1IiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:38:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41434 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab3C1IiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:38:07 -0400
X-AuditID: cbfee690-b7f656d0000007e3-c9-5154016c21d4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
In-reply-to: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
Subject: [PATCH 3/8] rtc: rtc-coh901331: convert coh901331_driver to dev_pm_ops
Date: Thu, 28 Mar 2013 17:38:04 +0900
Message-id: <001201ce2b8f$908ed300$b1ac7900$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4rj2FhCGvCEF7CQ36UwoHUUgpQOwAABtgw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zfd0cxpBAgw+PjC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmHjlJVvBDZGKe72+DYxtgl2MnBwSAiYSM5o3sUDYYhIX7q1n62Lk4hASWMYocWLm
	OiCHA6zo0ZZskBohgUWMEv3n2CFqfjFKbHq/nR0kwSagJvHly2F2kHoRAX2JthYNkBpmgV5G
	iTO9u9khmm0lzh2+ygxicwrYSbSv2Qq2WFjAX+LbiatgNouAqsS357/YQGxeoPo/CxexQNiC
	Ej8m3wOzmQW0JNbvPM4EYctLbF7zlhniTnWJR391QcIiAkYSD87OYYMoEZHY9+IdI8g9EgK3
	2CUaLiyD2iUg8W3yIRaIXlmJTQeYIeEgKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hq
	QXJBcVJ6kYlecWJucWleul5yfu4mRkiUTtjBeO+A9SHGZKD1E5mlRJPzgVGeVxJvaGxmZGFq
	YmpsZG5pRpqwkjiveot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGr2udbud6FxUF7Dwb
	cv/PxV7N73XyGiwJ69cybLxXv/TxdO70huNMPzcskTf8xmvdVWJk517+6/WH81vmTg/QO3Rj
	UYeJu/n3rE+V5ce2LpnT93bqVmefM71mQSJJF59aJk7prXF/Hzrjoclmg3IxwVm5p895qqVu
	a5hixdA4Ye8iMwb+X3/TlViKMxINtZiLihMBWX/y3+gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAd0cxpBAgy0P9SyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJh45SVbwQ2Rinu9vg2MbYJdjBwcEgImEo+2
	ZHcxcgKZYhIX7q1nA7GFBBYxSvSfY+9i5AKyfzFKbHq/nR0kwSagJvHly2F2kF4RAX2JthYN
	kBpmgV5GiTO9u9khmm0lzh2+ygxicwrYSbSv2coCYgsL+Et8O3EVzGYRUJX49vwX2DJeoPo/
	CxexQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhniZnWJR391QcIiAkYSD87OYYMoEZHY9+Id
	4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcAp5J7WBc
	2WBxiFGAg1GJh7dCIDhQiDWxrLgy9xCjBAezkgjvoU6gEG9KYmVValF+fFFpTmrxIcZkoEcn
	MkuJJucD01NeSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTCe
	aPy1dXJlWOjc346z9vAtWTl5Z/7ZqytWeHZkuQutUP0acrlZftcdh6lK/R//PA+ZmnT6bW9J
	+za230um3H1mruWRd0ON0VHol+zFOXVieTc6N62Nzeusbr8SNJ1twdfrJds5kp9oVx4Vrq07
	lbbeJ6Rvbl2pQJ4Ir+LMZSs9NbJMrly9cqRFiaU4I9FQi7moOBEAlSi8AkUDAAA=
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
 drivers/rtc/rtc-coh901331.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index bf0387f..93c0658 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -47,7 +47,7 @@ struct coh901331_port {
 	u32 physize;
 	void __iomem *virtbase;
 	int irq;
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	u32 irqmaskstore;
 #endif
 };
@@ -225,17 +225,17 @@ static int __init coh901331_probe(struct platform_device *pdev)
 	return ret;
 }
 
-#ifdef CONFIG_PM
-static int coh901331_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int coh901331_suspend(struct device *dev)
 {
-	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
+	struct coh901331_port *rtap = dev_get_drvdata(dev);
 
 	/*
 	 * If this RTC alarm will be used for waking the system up,
 	 * don't disable it of course. Else we just disable the alarm
 	 * and await suspension.
 	 */
-	if (device_may_wakeup(&pdev->dev)) {
+	if (device_may_wakeup(dev)) {
 		enable_irq_wake(rtap->irq);
 	} else {
 		clk_enable(rtap->clk);
@@ -247,12 +247,12 @@ static int coh901331_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int coh901331_resume(struct platform_device *pdev)
+static int coh901331_resume(struct device *dev)
 {
-	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
+	struct coh901331_port *rtap = dev_get_drvdata(dev);
 
 	clk_prepare(rtap->clk);
-	if (device_may_wakeup(&pdev->dev)) {
+	if (device_may_wakeup(dev)) {
 		disable_irq_wake(rtap->irq);
 	} else {
 		clk_enable(rtap->clk);
@@ -261,11 +261,10 @@ static int coh901331_resume(struct platform_device *pdev)
 	}
 	return 0;
 }
-#else
-#define coh901331_suspend NULL
-#define coh901331_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(coh901331_pm_ops, coh901331_suspend, coh901331_resume);
+
 static void coh901331_shutdown(struct platform_device *pdev)
 {
 	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
@@ -279,10 +278,9 @@ static struct platform_driver coh901331_driver = {
 	.driver = {
 		.name = "rtc-coh901331",
 		.owner = THIS_MODULE,
+		.pm = &coh901331_pm_ops,
 	},
 	.remove = __exit_p(coh901331_remove),
-	.suspend = coh901331_suspend,
-	.resume = coh901331_resume,
 	.shutdown = coh901331_shutdown,
 };
 
-- 
1.7.2.5


