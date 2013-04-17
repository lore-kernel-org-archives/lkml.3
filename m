Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab3DQBHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:07:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13923 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab3DQBHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:07:38 -0400
X-AuditID: cbfee68e-b7f946d000001e37-7e-516df5d8ad59
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
In-reply-to: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
Subject: [PATCH RESEND 3/8] rtc: rtc-coh901331: convert coh901331_driver to
 dev_pm_ops
Date: Wed, 17 Apr 2013 10:07:36 +0900
Message-id: <003201ce3b07$f2bb3cd0$d831b670$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac47B9XUIMaX4YjsSbW0FEYgtMIOOAAABIPA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zQ90bX3MDDRYttLFYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY+KVl2wFN0Qq7vX6NjC2CXYxcnJICJhI3L25mB3CFpO4cG89WxcjF4eQwDJGieNX
	lwA5HGBFUxdXg9QICUxnlLj2Og2i5hejxM4nm8Ga2QTUJL58OcwOUi8ioC/R1qIBUsMs0Mso
	caZ3NztEs63EzY5DTCA2p4CdxLcjdxhBbGGBCIlnl76B2SwCqhLzGi6wgNi8QPVX105lhbAF
	JX5MvgcWZxbQkli/8zgThC0vsXnNW2aIO9UlHv3VBQmLCBhJPJ7axAxRIiKx78U7RpB7JARu
	sUus//6HDWKXgMS3yYdYIHplJTYdYIaEg6TEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyi
	qQXJBcVJ6UVGesWJucWleel6yfm5mxghUdq3g/HmAetDjMlA6ycyS4km5wOjPK8k3tDYzMjC
	1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjPP2L12Stcb6kaQy
	o9TxyXZmz03WuKvIOvNMSA1gfVHfed75+IE1XK+Ox5gEHF0kODP//bn3TtzZr0xrn336tHnN
	zrDrRt8SWp8ISDdffLZvf0pU0usrBiFqG8zjfa9N/DiDTUdv1+OyJLeXfFvTXnUdyver3vNJ
	7OisAtVoz9rYNROfbr4zV16JpTgj0VCLuag4EQBatNV16AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd0bX3MDDY5uM7dYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPilZdsBTdEKu71+jYwtgl2MXJwSAiYSExd
	XN3FyAlkiklcuLeeDcQWEpjOKHHtdVoXIxeQ/YtRYueTzewgCTYBNYkvXw6zg/SKCOhLtLVo
	gNQwC/QySpzp3c0O0WwrcbPjEBOIzSlgJ/HtyB1GEFtYIELi2aVvYDaLgKrEvIYLLCA2L1D9
	1bVTWSFsQYkfk++BxZkFtCTW7zzOBGHLS2xe85YZ4mZ1iUd/dUHCIgJGEo+nNjFDlIhI7Hvx
	jnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITgHPpHcw
	rmqwOMQowMGoxMN7oSA3UIg1say4MvcQowQHs5IIr+IqoBBvSmJlVWpRfnxRaU5q8SHGZKBH
	JzJLiSbnA9NTXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw
	zr3+9eoE7aOhn/2e+q9QfM5/fUNn8GaWE/vUHp9sv8dtdFFwTUr0QsNCU2sNl5RkScXYtdGq
	4rOfFeW5vbDvaFvOXmTlt0/MoNi9cp7K3WlH1piGfbu5lU954Qax84n3ZsxctO/N6gfvyo1y
	JkoZW9gUH2wLXM2856V99GTJ4K17tqXcnt/qpsRSnJFoqMVcVJwIAEaqBIpFAwAA
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


