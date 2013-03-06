Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3CFFd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:33:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25952 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3CFFd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:33:56 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-b3-5136d5425d2e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 20/30] rtc: rtc-s3c: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:33:54 +0900
Message-id: <005601ce1a2c$313a9890$93afc9b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAOy7g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ12nq2aBBud3WFosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVMeXmSeaCbZwVM17tZmtgfMzexcjJISFgItG28jUzhC0mceHeerYuRi4OIYFljBIX
	Nq9g7WLkACvafNsfIj6dUaLl3HZGCOcXo8S8TYtZQLrZBNQkvnw5zA7SICKgL9HWogFSwyzQ
	yyhxpnc32DYhAVuJq92rwLZxCthJLH88iwWkXljAWeLJNwOQMIuAqsTNbQ9ZQWxeoPLrdx9D
	2YISPybfA1vFLKAlsX7ncSYIW15i85q3zBB3qks8+qsLEhYRMJL49e8bM0SJiMS+F+/ATpYQ
	uMcusX3KVxaIXQIS3yYfYoHolZXYdAAaDpISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGK
	phYkFxQnpRcZ6RUn5haX5qXrJefnbmKExGnfDsabB6wPMSYDrZ/ILCWanA+M87ySeENjYxMz
	E1MTc0tTc1PShJXEeeUvyQQKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYHRgyl+/42LgR9W6
	2svbMj/deW1Zy75L4nmVp/vCg5f+rDzbMlVzkro9R5XNIemvL5p4MnkMJuhvXyTz7XKsxZOz
	O48dnTjD0lfo2enclUvlHnttPzRvmhK7eZqie7rm9qSjmRVzT+77tkDqp1uChsahjuWf53Ac
	d+h+Y2cZ1fpb8h1f/bl6gyNKLMUZiYZazEXFiQAKto/E6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV2nq2aBBsf2mVgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDHl5knmgm2cFTNe7WZrYHzM3sXIwSEhYCKx
	+bZ/FyMnkCkmceHeerYuRi4OIYHpjBIt57YzQji/GCXmbVrMAlLFJqAm8eXLYbBmEQF9ibYW
	DZAaZoFeRokzvbvZQWqEBGwlrnavYgaxOQXsJJY/nsUCUi8s4Czx5JsBSJhFQFXi5raHrCA2
	L1D59buPoWxBiR+T74GtYhbQkli/8zgThC0vsXnNW2aIm9UlHv3VBQmLCBhJ/Pr3jRmiRERi
	34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwEngm
	tYNxZYPFIUYBDkYlHl4LJbNAIdbEsuLK3EOMEhzMSiK8XGeAQrwpiZVVqUX58UWlOanFhxiT
	gR6dyCwlmpwPTFB5JfGGxiZmRpZGZhZGJubmpAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNT
	qoGRvZZlltPLsvLd5/K7pgi1rw34mHzfdvnGiOayY/OWPtGKXfq926R5Xst0tifsk5h5ajYJ
	/Egwe507YY2iz63OT2ESTyc9XLTWct/Ou+2ntt58/GxetePtr6F3J50L/KT6VNJ+69QGN8aK
	uxGvv21Xzi08dmK5buhy80NHRXu7Hk/zuWFlEa59RImlOCPRUIu5qDgRAHlp9vpGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-s3c.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index fb994e9..21ff72e 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -423,10 +423,7 @@ static void s3c_rtc_enable(struct platform_device *pdev, int en)
 
 static int s3c_rtc_remove(struct platform_device *dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(dev);
-
 	platform_set_drvdata(dev, NULL);
-	rtc_device_unregister(rtc);
 
 	s3c_rtc_setaie(&dev->dev, 0);
 
@@ -511,7 +508,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 
 	/* register RTC and exit */
 
-	rtc = rtc_device_register("s3c", &pdev->dev, &s3c_rtcops,
+	rtc = devm_rtc_device_register("s3c", &pdev->dev, &s3c_rtcops,
 				  THIS_MODULE);
 
 	if (IS_ERR(rtc)) {
@@ -574,7 +571,6 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 
  err_alarm_irq:
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(rtc);
 
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
-- 
1.7.2.5


