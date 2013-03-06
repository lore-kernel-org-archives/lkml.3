Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3CFFbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:31:37 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25478 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3CFFbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:31:36 -0500
X-AuditID: cbfee690-b7f6b6d000004563-10-5136d4b7cd0a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 13/30] rtc: rtc-max77686: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:31:34 +0900
Message-id: <004f01ce1a2b$ddf219b0$99d64d10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAJegQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY93tV8wCDb6c5LFYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY/LzvywF93gqph6ZyNTAeI6ri5GTQ0LAROLfibOMELaYxIV769lAbCGBZYwSTXcN
	YGr+tD8BquECik9nlHg7dzcrhPOLUeLlvCnMIFVsAmoSX74cZu9i5OAQEdCXaGvRAKlhFuhl
	lDjTu5sdYqqtxNXuVWD1nAJ2Essfz2IBsYUFPCQmTLrDBGKzCKhKzN01EayeF6i+5+RtRghb
	UOLH5Htg9cwCWhLrdx5ngrDlJTavecsMsldCQF3i0V9dkLCIgJHE8/ZprBAlIhL7XrwDe0BC
	4BG7xNubq9kgdglIfJt8iAWiV1Zi0wFmiIclJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxi
	FE0tSC4oTkovMtErTswtLs1L10vOz93ECInUCTsY7x2wPsSYDLR+IrOUaHI+MNLzSuINjY1N
	zExMTcwtTc1NSRNWEueVvyQTKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoEx8YmqSR77vw5R
	juDaDn3R2ZuZW766rC+SX++77r//G53du+uv+dtfu7OY+dJuKV2pmftsvm8Tay4LuMa6qyDW
	Y/P/v53sd8vy9y1y9L6srrl1Wvk/JkX7TZxvd6/f8ILb8Zr53iUnP781is85rl17RWF9/DfG
	/1eO5plWH10jVzdp4p/0Qq27SizFGYmGWsxFxYkA1dOnf+oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd3tV8wCDV6/YLdYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPy878sBfd4KqYemcjUwHiOq4uRk0NCwETi
	T/sTRghbTOLCvfVsXYxcHEIC0xkl3s7dzQrh/GKUeDlvCjNIFZuAmsSXL4fZuxg5OEQE9CXa
	WjRAapgFehklzvTuZgepERKwlbjavQqsnlPATmL541ksILawgIfEhEl3mEBsFgFVibm7JoLV
	8wLV95y8zQhhC0r8mHwPrJ5ZQEti/c7jTBC2vMTmNW+ZQfZKCKhLPPqrCxIWETCSeN4+jRWi
	RERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw
	IngmvYNxVYPFIUYBDkYlHt4JKmaBQqyJZcWVuYcYJTiYlUR4uc4AhXhTEiurUovy44tKc1KL
	DzEmAz06kVlKNDkfmKTySuINjU3MjCyNzCyMTMzNSRNWEudlPPUkQEggPbEkNTs1tSC1CGYL
	EwenVANj8vzgpNYfp+97lkw0uJBcuqzHLlaMQ/KejqGUrNvSqwcv5MQzTj3CLL/riCDvw5/O
	sj29X2R9a+3/XvRr+dZwUaxwkt/HFUH55/X7Hq9pXX31THV35OSPldaCetaSKtmVxdViO+7Z
	vjtnfuvpzindj9gfzpuWvf3Bpl3CV9l+WYivn6jyr/aaEktxRqKhFnNRcSIAAVLX5EgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler. Also, this patch uses devm_request_threaded_irq().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max77686.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index df66bab..69524c8 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -538,8 +538,8 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register("max77686-rtc", &pdev->dev,
-			&max77686_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register("max77686-rtc", &pdev->dev,
+					&max77686_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
 		dev_info(&pdev->dev, "%s: fail\n", __func__);
@@ -555,8 +555,8 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 		goto err_rtc;
 	info->virq = virq;
 
-	ret = request_threaded_irq(virq, NULL, max77686_rtc_alarm_irq, 0,
-			"rtc-alarm0", info);
+	ret = devm_request_threaded_irq(&pdev->dev, virq, NULL,
+				max77686_rtc_alarm_irq, 0, "rtc-alarm0", info);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			info->virq, ret);
@@ -569,13 +569,6 @@ err_rtc:
 
 static int max77686_rtc_remove(struct platform_device *pdev)
 {
-	struct max77686_rtc_info *info = platform_get_drvdata(pdev);
-
-	if (info) {
-		free_irq(info->virq, info);
-		rtc_device_unregister(info->rtc_dev);
-	}
-
 	return 0;
 }
 
-- 
1.7.2.5


