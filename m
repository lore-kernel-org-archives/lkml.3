Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3CFFcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:32:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25642 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3CFFcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:32:17 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-e4-5136d4e044e0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 15/30] rtc: rtc-max8997: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:32:15 +0900
Message-id: <005101ce1a2b$f66170e0$e32452a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAALABA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zI90HV8wCDVY2iFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M40+NCnZwVhxu/cnewPievYuRk0NCwERi8Y/dbBC2mMSFe+uB
	bC4OIYFljBIH9syFK+r7+JcZxBYSWMQoMWFBHUTRbCaJB0/bWUESbAJqEl++HAZq4OAQEdCX
	aGvRAKlhFuhllDjTu5sdotlW4mr3KrBBnAJ2Essfz2IBsYUF3CXOPZ0DFmcRUJVY+X4bWJwX
	qL55ZzcrhC0o8WPyPbA4s4CWxPqdx5kgbHmJzWveMoPslRBQl3j0VxckLCJgJHHnxEmochGJ
	fS/eMYLcIyEwj12ibfN+FohdAhLfJh9igeiVldh0gBniX0mJgytusExglJiFZPMsJJtnIdk8
	C8mKBYwsqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzFC4qp/B+PdA9aHGJOB1k9klhJNzgfG
	ZV5JvKGxsYmZiamJuaWpuSlpwkrivPKXZAKFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MEYH
	efm4CZsf9lf7XuDvvujmw6O27kd2P93B33Lpzjo3oeAP3sqXMngSj6uXHKmXcm74cW7xzD5d
	t6fbj1S3xlxmLszXO234PrWvlSVk38zYdUs6jH+fOXO6JXLRvOs/z4h0TXo9b/WfG8cezjQp
	j/lwIsVQ8+rMxQ8N6+rXb8t0zG3jOLTR6bwSS3FGoqEWc1FxIgDGv+JMwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO6DK2aBBlO2C1pc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjONPjQp2cFYcbv3J3sD4
	nr2LkZNDQsBEou/jX2YIW0ziwr31bCC2kMAiRokJC+q6GLmA7NlMEg+etrOCJNgE1CS+fDkM
	1MzBISKgL9HWogFSwyzQyyhxpnc3O0SzrcTV7lVgQzkF7CSWP57FAmILC7hLnHs6ByzOIqAq
	sfL9NrA4L1B9885uVghbUOLH5HtgcWYBLYn1O48zQdjyEpvXvGUG2SshoC7x6K8uSFhEwEji
	zomTUOUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLz
	czcxgqP2mdQOxpUNFocYBTgYlXh4LZTMAoVYE8uKK3MPMUpwMCuJ8HKdAQrxpiRWVqUW5ccX
	leakFh9iTAZ6dCKzlGhyPjCh5JXEGxqbmBlZGplZGJmYm5MmrCTOy3jqSYCQQHpiSWp2ampB
	ahHMFiYOTqkGRtWeffNXuRWvbfjGefX8I94pgjEbSksX5qVcj5suaKdZf+LPXoVt55fsMCud
	1PU83+SDktjKtMqe4K87Hu4/+IHX6M8HC1FJsyybgzcLuyV6Xjh/Ts8RDv9canCBO/+j2NFC
	hrgdu80SA7RLk3d2zvKZ4iwda+T9fkuC6XWGoK2rTl+27nLPU2Ipzkg01GIuKk4EAOH7Yfse	AwAA
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
 drivers/rtc/rtc-max8997.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
index 00e505b..69d75b0 100644
--- a/drivers/rtc/rtc-max8997.c
+++ b/drivers/rtc/rtc-max8997.c
@@ -479,8 +479,8 @@ static int max8997_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register("max8997-rtc", &pdev->dev,
-			&max8997_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register("max8997-rtc", &pdev->dev,
+					&max8997_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
@@ -507,17 +507,11 @@ static int max8997_rtc_probe(struct platform_device *pdev)
 	return ret;
 
 err_out:
-	rtc_device_unregister(info->rtc_dev);
 	return ret;
 }
 
 static int max8997_rtc_remove(struct platform_device *pdev)
 {
-	struct max8997_rtc_info *info = platform_get_drvdata(pdev);
-
-	if (info)
-		rtc_device_unregister(info->rtc_dev);
-
 	return 0;
 }
 
-- 
1.7.2.5


