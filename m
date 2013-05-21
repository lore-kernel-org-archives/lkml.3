Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3EUGR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:17:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24775 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab3EUGRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:17:54 -0400
X-AuditID: cbfee691-b7fef6d000002d62-52-519b1190fef5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 5/8] rtc: rtc-pm8xxx: use devm_*() functions
Date: Tue, 21 May 2013 15:17:52 +0900
Message-id: <000801ce55ea$ecdba950$c692fbf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5V6uwySmVn3U0XRZm0AWXxq1bX5g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zI90JgrMDDabf17RYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY/uWrSwFi6QqPm48wNTAuFa0i5GDQ0LARGL6Hf4uRk4gU0ziwr31bF2MXBxCAssY
	JXauuMAIkTCR2L7vDjtEYhGjxM322awQzi9GiZPXmllBqtgE1CS+fDnMDjJVREBfoq1FA6SG
	WaCbUeJR81xmkBphARuJYzf3sYHYLAKqEhuOfWAHsXkFLCXevH3DCmELSvyYfI8FxGYW0JJY
	v/M4E4QtL7F5zVtmiIsUJHacfQ12nYiAnsTbY5tYIWpEJPa9eMcIslhC4BS7xPE1D9khlglI
	fJt8iAXiZVmJTQeg5khKHFxxg2UCo9gsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5kqlec
	mFtcmpeul5yfu4kREnsTdzDeP2B9iDEZaP1EZinR5Hxg7OaVxBsamxlZmJqYGhuZW5qRJqwk
	zqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTFlaUl26gIdzqLnRRtM3RfbSd4oPulW
	aug75Z22tbW97dHG+BDnCq2OgxxHegQ4ny2fMfPF64k9JdxqiqtUJpgpFr3p37/VxHll9GTe
	6Zbfz23grjO4zuJzJO19Z3juvMfMa3JYYrY57z1tK5y+NUS3M7L2oujWP44eC0z3TnG4PFnZ
	mXv6SyWW4oxEQy3mouJEAK+4BCbTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd0JgrMDDc6/V7VYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWP7lq0sBYukKj5uPMDUwLhWtIuRk0NCwERi
	+7477BC2mMSFe+vZuhi5OIQEFjFK3GyfzQrh/GKUOHmtmRWkik1ATeLLl8NAHRwcIgL6Em0t
	GiA1zALdjBKPmucyg9QIC9hIHLu5jw3EZhFQldhw7APYBl4BS4k3b9+wQtiCEj8m32MBsZkF
	tCTW7zzOBGHLS2xe85YZ4iIFiR1nXzOC2CICehJvj21ihagRkdj34h3jBEaBWUhGzUIyahaS
	UbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzbz6R2MK5ssDjEKMDBqMTDK2A4
	K1CINbGsuDL3EKMEB7OSCO/3ZqAQb0piZVVqUX58UWlOavEhxmSgTycyS4km5wPTTl5JvKGx
	iZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MIZdmFSWW3bZZrvbpdya
	PaKer1YcOLDh9U+TxIszLBacz1lmcGvWrjxWbus645gHrwJzT1vkhlscfyZ4W0Fhu2q8+MP3
	k7YF5lyTqtCdqLlvhYDI37Qp1z0udroo3jlUdJLh/d2Tpdt/KJxIqSjme1v9OuH/uf0ir25n
	V/Rd/ygzr7RA3YaJl0mJpTgj0VCLuag4EQAxKzpUMQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pm8xxx.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 14ee860..03f8f75 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -395,7 +395,7 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 	if (pdata != NULL)
 		rtc_write_enable = pdata->rtc_write_enable;
 
-	rtc_dd = kzalloc(sizeof(*rtc_dd), GFP_KERNEL);
+	rtc_dd = devm_kzalloc(&pdev->dev, sizeof(*rtc_dd), GFP_KERNEL);
 	if (rtc_dd == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate memory!\n");
 		return -ENOMEM;
@@ -407,16 +407,14 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 	rtc_dd->rtc_alarm_irq = platform_get_irq(pdev, 0);
 	if (rtc_dd->rtc_alarm_irq < 0) {
 		dev_err(&pdev->dev, "Alarm IRQ resource absent!\n");
-		rc = -ENXIO;
-		goto fail_rtc_enable;
+		return -ENXIO;
 	}
 
 	rtc_resource = platform_get_resource_byname(pdev, IORESOURCE_IO,
 							"pmic_rtc_base");
 	if (!(rtc_resource && rtc_resource->start)) {
 		dev_err(&pdev->dev, "RTC IO resource absent!\n");
-		rc = -ENXIO;
-		goto fail_rtc_enable;
+		return -ENXIO;
 	}
 
 	rtc_dd->rtc_base = rtc_resource->start;
@@ -432,7 +430,7 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "RTC control register read failed!\n");
-		goto fail_rtc_enable;
+		return rc;
 	}
 
 	if (!(ctrl_reg & PM8xxx_RTC_ENABLE)) {
@@ -442,7 +440,7 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 		if (rc < 0) {
 			dev_err(&pdev->dev, "Write to RTC control register "
 								"failed\n");
-			goto fail_rtc_enable;
+			return rc;
 		}
 	}
 
@@ -453,13 +451,12 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, rtc_dd);
 
 	/* Register the RTC device */
-	rtc_dd->rtc = rtc_device_register("pm8xxx_rtc", &pdev->dev,
+	rtc_dd->rtc = devm_rtc_device_register(&pdev->dev, "pm8xxx_rtc",
 				&pm8xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc_dd->rtc)) {
 		dev_err(&pdev->dev, "%s: RTC registration failed (%ld)\n",
 					__func__, PTR_ERR(rtc_dd->rtc));
-		rc = PTR_ERR(rtc_dd->rtc);
-		goto fail_rtc_enable;
+		return PTR_ERR(rtc_dd->rtc);
 	}
 
 	/* Request the alarm IRQ */
@@ -468,7 +465,7 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 				 "pm8xxx_rtc_alarm", rtc_dd);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Request IRQ failed (%d)\n", rc);
-		goto fail_req_irq;
+		return rc;
 	}
 
 	device_init_wakeup(&pdev->dev, 1);
@@ -476,12 +473,6 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Probe success !!\n");
 
 	return 0;
-
-fail_req_irq:
-	rtc_device_unregister(rtc_dd->rtc);
-fail_rtc_enable:
-	kfree(rtc_dd);
-	return rc;
 }
 
 static int pm8xxx_rtc_remove(struct platform_device *pdev)
@@ -490,8 +481,6 @@ static int pm8xxx_rtc_remove(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 0);
 	free_irq(rtc_dd->rtc_alarm_irq, rtc_dd);
-	rtc_device_unregister(rtc_dd->rtc);
-	kfree(rtc_dd);
 
 	return 0;
 }
-- 
1.7.10.4


