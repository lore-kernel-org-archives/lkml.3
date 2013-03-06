Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3CFH4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:56:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58849 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab3CFH4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:56:33 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-4a-5136f6b05f0a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 27/30] rtc: rtc-tps80031: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:56:32 +0900
Message-id: <009501ce1a40$1e005350$5a00f9f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAULzw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ90N38wCDaZeV7ZYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY92vN8wFt7kqti98w9jA+Jyji5GDQ0LAROLCG9UuRk4gU0ziwr31bF2MXBxCAssY
	JRZO7mCHSJhI7LzyngUiMZ1R4sCKW4wQzi9GibbOK2BVbAJqEl++HGYHmSoioC/R1qIBUsMs
	0MsocaZ3N1hcSMBWomceD0g5p4CdxJSJj8FahQW8Jbp65rCC2CwCqhJP13Yygdi8QOW3Ln5k
	hrAFJX5MvscCYjMLaEms33mcCcKWl9i85i0zxDPqEo/+6oKERQSMJPrftrFClIhI7HvxDuxk
	CYF77BLr+vYyQuwSkPg2+RALRK+sxKYDzBD/SkocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZ
	xSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRESp307GG8esD7EmAy0fiKzlGhyPjDO80riDY2N
	TcxMTE3MLU3NTUkTVhLnlb8kEygkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0dHx1KUdnm1K
	Rnr37vpUvpg+s3bl+nPqTozeylk31nsV19fP8J3G+1gvrpjpwNxdbk6aSltinvLcFWTI9Pu7
	/m2etbr0bv+VM974KR/fkvKz+OfHO9dWMTzNVsplt1HIt+oJ0vQSuHYwc+K2BUkZbkKzQ9OZ
	Obxvf7fd/6x5h4px44XAF2yrlViKMxINtZiLihMBvF16dekCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd0N38wCDQ71y1ssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLHu1xvmgttcFdsXvmFsYHzO0cXIySEhYCKx
	88p7FghbTOLCvfVsXYxcHEIC0xklDqy4xQjh/GKUaOu8wg5SxSagJvHly2Egm4NDREBfoq1F
	A6SGWaCXUeJM726wuJCArUTPPB6Qck4BO4kpEx+DtQoLeEt09cxhBbFZBFQlnq7tZAKxeYHK
	b138yAxhC0r8mHwP7CBmAS2J9TuPM0HY8hKb17xlBhkvIaAu8eivLkhYRMBIov9tGytEiYjE
	vhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgNPBM
	agfjygaLQ4wCHIxKPLwWSmaBQqyJZcWVuYcYJTiYlUR4uc4AhXhTEiurUovy44tKc1KLDzEm
	Az06kVlKNDkfmKLySuINjU3MjCyNzCyMTMzNSRNWEudlPPUkQEggPbEkNTs1tSC1CGYLEwen
	VAPjNo+HDmxlF45eadISN6v6P+2jydOLN56f7fGN4uVOvWuRsolBPY/3yIwF8/fpsnO9e666
	8LdrQ96MogvKT9czyFRbyb2for1euoO5+OHO+HC/CR3fWN/y87Qz9HzImKlpfT2ivkDE+0Oa
	hERi+fZnEv+6y/8rnmPblLmET1Mp9cjUiOmndXOUWIozEg21mIuKEwErMD0lRwMAAA==
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
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-tps80031.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-tps80031.c b/drivers/rtc/rtc-tps80031.c
index 9aaf8aa..dc62d5f 100644
--- a/drivers/rtc/rtc-tps80031.c
+++ b/drivers/rtc/rtc-tps80031.c
@@ -277,7 +277,7 @@ static int tps80031_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 			       &tps80031_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		ret = PTR_ERR(rtc->rtc);
@@ -292,7 +292,6 @@ static int tps80031_rtc_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "request IRQ:%d failed, err = %d\n",
 			 rtc->irq, ret);
-		rtc_device_unregister(rtc->rtc);
 		return ret;
 	}
 	device_set_wakeup_capable(&pdev->dev, 1);
@@ -301,9 +300,6 @@ static int tps80031_rtc_probe(struct platform_device *pdev)
 
 static int tps80031_rtc_remove(struct platform_device *pdev)
 {
-	struct tps80031_rtc *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc->rtc);
 	return 0;
 }
 
-- 
1.7.2.5


