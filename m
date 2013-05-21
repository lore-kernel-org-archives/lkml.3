Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab3EUGSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:18:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58107 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab3EUGSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:18:15 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-af-519b11a627ae
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 6/8] rtc: rtc-pxa: use devm_*() functions
Date: Tue, 21 May 2013 15:18:14 +0900
Message-id: <000901ce55ea$fa02aa70$ee07ff50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5V6vlFLYEINeFgQ4+UOEY7MYN0pA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zfd1lgrMDDRZ91rNYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEr4959z4JOsYpJDw+yNzB+EOxi5OSQEDCRmD93IxOELSZx4d56ti5GLg4hgWWMEk0z
	prLAFPXeWscOkVjEKDHlzndmCOcXo8Sqvz/B2tkE1CS+fDkMVMXBISKgL9HWogFSwyzQzSjx
	qHkuM0iNsIClxKLHDxlBbBYBVYkXf2ewgdTzAsXbnuaBhHkFBCV+TL4HtphZQEti/c7jTBC2
	vMTmNW+ZIQ5SkNhx9jUjxCo9iUUvCiBKRCT2vXjHCLJWQuAQu8SJEyeYIVYJSHybfIgFpF5C
	QFZi0wGoMZISB1fcYJnAKDYLyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpRcZ6hUn5haX5qXr
	JefnbmKExF3vDsbbB6wPMSYDrZ/ILCWanA+M27ySeENjMyMLUxNTYyNzSzPShJXEedVarAOF
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MKo/nP1U+M974Yjo3lMCtwqqz0omcLqf9bR5zaot
	5rlxDovc3q21B+w3fL49eUfe47m9z6Y7+nRonvCoq177p1zBbt0k+7A8VrZ+9W+rek9tsb+4
	9WG2idkq59lGh6sX73/5YX32P9bas/+EFs340CF9SNM3e/qfybOmlolrPQ53+MTx99ikxnYl
	luKMREMt5qLiRABURPFz0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd1lgrMDDSbc0LJYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePefc+CTrGKSQ8PsjcwfhDsYuTkkBAwkei9
	tY4dwhaTuHBvPVsXIxeHkMAiRokpd74zQzi/GCVW/f3JBFLFJqAm8eXLYaAODg4RAX2JthYN
	kBpmgW5GiUfNc5lBaoQFLCUWPX7ICGKzCKhKvPg7gw2knhco3vY0DyTMKyAo8WPyPRYQm1lA
	S2L9zuNMELa8xOY1b5khDlKQ2HH2NSPEKj2JRS8KIEpEJPa9eMc4gVFgFpJJs5BMmoVk0iwk
	LQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEf1M6kdjCsbLA4xCnAwKvHwChjOChRi
	TSwrrsw9xCjBwawkwvu9GSjEm5JYWZValB9fVJqTWnyIMRnoz4nMUqLJ+cCEk1cSb2hsYmZk
	aWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjIKLugt+GcSt6j51Uea9RVjj
	I5anPxW/F728pKKTotR2wO7kvTBdt4lcwa3vs7tPifuw8n/+JR9z959L4SWZ3S5vYrf92fwu
	KLir6U9zU5PRgXX7bspZJd6wSP7KtVfS+Ir6dduNjAszLrII3pf+tu0mA/8dXfF/ZZ8yrur1
	3z7PrDrXsmNOqBJLcUaioRZzUXEiALlZRJsuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pxa.c |   43 ++++++++++++-------------------------------
 1 file changed, 12 insertions(+), 31 deletions(-)

diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index ed037ae..a355f2b 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -324,37 +324,35 @@ static int __init pxa_rtc_probe(struct platform_device *pdev)
 	int ret;
 	u32 rttr;
 
-	pxa_rtc = kzalloc(sizeof(struct pxa_rtc), GFP_KERNEL);
+	pxa_rtc = devm_kzalloc(dev, sizeof(*pxa_rtc), GFP_KERNEL);
 	if (!pxa_rtc)
 		return -ENOMEM;
 
 	spin_lock_init(&pxa_rtc->lock);
 	platform_set_drvdata(pdev, pxa_rtc);
 
-	ret = -ENXIO;
 	pxa_rtc->ress = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!pxa_rtc->ress) {
 		dev_err(dev, "No I/O memory resource defined\n");
-		goto err_ress;
+		return -ENXIO;
 	}
 
 	pxa_rtc->irq_1Hz = platform_get_irq(pdev, 0);
 	if (pxa_rtc->irq_1Hz < 0) {
 		dev_err(dev, "No 1Hz IRQ resource defined\n");
-		goto err_ress;
+		return -ENXIO;
 	}
 	pxa_rtc->irq_Alrm = platform_get_irq(pdev, 1);
 	if (pxa_rtc->irq_Alrm < 0) {
 		dev_err(dev, "No alarm IRQ resource defined\n");
-		goto err_ress;
+		return -ENXIO;
 	}
 	pxa_rtc_open(dev);
-	ret = -ENOMEM;
-	pxa_rtc->base = ioremap(pxa_rtc->ress->start,
+	pxa_rtc->base = devm_ioremap(dev, pxa_rtc->ress->start,
 				resource_size(pxa_rtc->ress));
 	if (!pxa_rtc->base) {
-		dev_err(&pdev->dev, "Unable to map pxa RTC I/O memory\n");
-		goto err_map;
+		dev_err(dev, "Unable to map pxa RTC I/O memory\n");
+		return -ENOMEM;
 	}
 
 	/*
@@ -370,41 +368,24 @@ static int __init pxa_rtc_probe(struct platform_device *pdev)
 
 	rtsr_clear_bits(pxa_rtc, RTSR_PIALE | RTSR_RDALE1 | RTSR_HZE);
 
-	pxa_rtc->rtc = rtc_device_register("pxa-rtc", &pdev->dev, &pxa_rtc_ops,
-					   THIS_MODULE);
-	ret = PTR_ERR(pxa_rtc->rtc);
+	pxa_rtc->rtc = devm_rtc_device_register(&pdev->dev, "pxa-rtc",
+						&pxa_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pxa_rtc->rtc)) {
+		ret = PTR_ERR(pxa_rtc->rtc);
 		dev_err(dev, "Failed to register RTC device -> %d\n", ret);
-		goto err_rtc_reg;
+		return ret;
 	}
 
 	device_init_wakeup(dev, 1);
 
 	return 0;
-
-err_rtc_reg:
-	 iounmap(pxa_rtc->base);
-err_ress:
-err_map:
-	kfree(pxa_rtc);
-	return ret;
 }
 
 static int __exit pxa_rtc_remove(struct platform_device *pdev)
 {
-	struct pxa_rtc *pxa_rtc = platform_get_drvdata(pdev);
-
 	struct device *dev = &pdev->dev;
-	pxa_rtc_release(dev);
-
-	rtc_device_unregister(pxa_rtc->rtc);
-
-	spin_lock_irq(&pxa_rtc->lock);
-	iounmap(pxa_rtc->base);
-	spin_unlock_irq(&pxa_rtc->lock);
-
-	kfree(pxa_rtc);
 
+	pxa_rtc_release(dev);
 	return 0;
 }
 
-- 
1.7.10.4


