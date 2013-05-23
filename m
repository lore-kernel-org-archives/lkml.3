Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab3EWKnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:43:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58655 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab3EWKnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:43:01 -0400
X-AuditID: cbfee68e-b7f276d000002279-2d-519df2b4696e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/3] rtc: rtc-rc5t583: use platform_{get,set}_drvdata()
Date: Thu, 23 May 2013 19:42:59 +0900
Message-id: <003301ce57a2$4b300600$e1901200$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5XojmGNpIBPxbyReKNQq9xBz/06w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t8zI90tn+YGGnw/wmWx5OJVdos569ew
	WVxeeInV4vKuOWwW+zs7GB1YPfZMPMnmcWLGbxaPvi2rGD2mz/vJ5PF5k1wAaxSXTUpqTmZZ
	apG+XQJXxpbVx1kKvrFVnDgZ0sD4gbWLkYNDQsBE4s0X4S5GTiBTTOLCvfVsXYxcHEICyxgl
	thy8ygSRMJHY2X6RFSKxiFGi8/0qFgjnF6PEh7/PmEGq2ATUJL58OcwOMlVEQF+irUUDpIZZ
	oJtR4lHzXGaQuLCAu8SvRUYgJouAqkTfrTyQTl4BS4m/6y+zQNiCEj8m3wOzmQW0JNbvPM4E
	YctLbF7zlhniHgWJHWdfM0Js0pO4eTYZokREYt+Ld4wgWyUEDrFLTLm2lBUkwSIgIPFt8iEW
	iH9lJTYdgBojKXFwxQ2WCYxis5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kZFecWJucWle
	ul5yfu4mRkjM9e1gvHnA+hBjMtD6icxSosn5wJjNK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6
	UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj/5oXVidD9rX0TJJJPd7knqLa927ReeEQPqY5
	PRYJF+7s3zbRYcVlIVWV9SsDEizzGdeGJ+0P1VvbejrNfILHiqtHw9Q15CvCJ//hOixquvzd
	jUd9FQ+Pxd8723XupGyLlGSN+ufdLT4TvHLWavKGrlf5dLx/rXjV1cwXx7v55ZNn8Uacav6v
	xFKckWioxVxUnAgAqQcNIc8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAd0tn+YGGkx9w2ax5OJVdos569ew
	WVxeeInV4vKuOWwW+zs7GB1YPfZMPMnmcWLGbxaPvi2rGD2mz/vJ5PF5k1wAa1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0HYlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8aW1cdZCr6xVZw4GdLA+IG1i5GTQ0LARGJn
	+0UoW0ziwr31bF2MXBxCAosYJTrfr2KBcH4xSnz4+4wZpIpNQE3iy5fD7F2MHBwiAvoSbS0a
	IDXMAt2MEo+a5zKDxIUF3CV+LTICMVkEVCX6buWBdPIKWEr8XX+ZBcIWlPgx+R6YzSygJbF+
	53EmCFteYvOat8wQ9yhI7Dj7mhFik57EzbPJECUiEvtevGOcwCgwC8mkWUgmzUIyaRaSlgWM
	LKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgmP6mdQOxpUNFocYBTgYlXh4JW7PCRRiTSwr
	rsw9xCjBwawkwru5Z26gEG9KYmVValF+fFFpTmrxIcZkoD8nMkuJJucD001eSbyhsYmZkaWR
	mYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTCe25Qrk7tL5MrnBZ83Ozyf7a/c
	2+TA/fzccX23c4qa80riuFcnnnkx8+isG6WvRTu0Ql+8DvWd81B5v9z6jPnSTcHL077fr5P/
	f/L31DsLftgpFdfy6jbIHVaP0t3C/HD3ZKvE6zt4dSX4vxTdVxAuyRRrFpztdMtiZ138NTuu
	d2fL/grktL1SYinOSDTUYi4qTgQA6sGTVS0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-rc5t583.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rc5t583.c b/drivers/rtc/rtc-rc5t583.c
index 8eabcf5..e53e9b1 100644
--- a/drivers/rtc/rtc-rc5t583.c
+++ b/drivers/rtc/rtc-rc5t583.c
@@ -273,7 +273,7 @@ static int rc5t583_rtc_probe(struct platform_device *pdev)
  */
 static int rc5t583_rtc_remove(struct platform_device *pdev)
 {
-	struct rc5t583_rtc *rc5t583_rtc = dev_get_drvdata(&pdev->dev);
+	struct rc5t583_rtc *rc5t583_rtc = platform_get_drvdata(pdev);
 
 	rc5t583_rtc_alarm_irq_enable(&rc5t583_rtc->rtc->dev, 0);
 	return 0;
-- 
1.7.10.4


