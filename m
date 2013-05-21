Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3EUGS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:18:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58223 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3EUGSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:18:55 -0400
X-AuditID: cbfee691-b7fef6d000002d62-d6-519b11ceb1b9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 8/8] rtc: rtc-sh: use devm_*() functions
Date: Tue, 21 May 2013 15:18:54 +0900
Message-id: <000b01ce55eb$119424c0$34bc6e40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5V6w9dLmdhojZkS16HBVhjfXTA5Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zI91zgrMDDQ4+lrNYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEr43z7ctaCy9oVr08uZGtgnKrcxcjJISFgIvHv1HlWCFtM4sK99WxdjFwcQgLLGCVm
	LlzPAlM0bdZfFojEIkaJ3gOPoKp+MUocn/2QGaSKTUBN4suXw+xdjBwcIgL6Em0tGiA1zALd
	jBKPmueC1QgLWEi8a5vKDmKzCKhKvHnfBRbnFbCUePbsNAuELSjxY/I9MJtZQEti/c7jTBC2
	vMTmNW+ZIS5SkNhx9jUjiC0ioCcx6eENqBoRiX0v3jGCLJYQOMYusXTmMWaIZQIS3yYfYgE5
	TkJAVmLTAag5khIHV9xgmcAoNgvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCelF5nqFSfmFpfm
	pesl5+duYoRE38QdjPcPWB9iTAZaP5FZSjQ5Hxi9eSXxhsZmRhamJqbGRuaWZqQJK4nzqrdY
	BwoJpCeWpGanphakFsUXleakFh9iZOLglGpgLL3KOM+ugmuOrV7q6udf0xTjv2q4VheEThRQ
	cKj5/VsyKVLMbLv/6Tf3ZU9UzmueUfLMLGJrx+Q7NdMb+Be2LzPu53lu0XN6X+VtA5e/oRkV
	s+erntK2vvDt84otocqzDogqiWtvCgmY+y82X6pMmq3x0+UtqXnfA7L5/7x6dWDjjsa6+jn/
	lViKMxINtZiLihMBrV348NQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd1zgrMDDe5ukLJYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMeN8+3LWgsvaFa9PLmRrYJyq3MXIySEhYCIx
	bdZfFghbTOLCvfVsXYxcHEICixgleg88gnJ+MUocn/2QGaSKTUBN4suXw+xdjBwcIgL6Em0t
	GiA1zALdjBKPmueC1QgLWEi8a5vKDmKzCKhKvHnfBRbnFbCUePbsNAuELSjxY/I9MJtZQEti
	/c7jTBC2vMTmNW+ZIS5SkNhx9jUjiC0ioCcx6eENqBoRiX0v3jFOYBSYhWTULCSjZiEZNQtJ
	ywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwbH9THoH46oGi0OMAhyMSjy8AoazAoVY
	E8uKK3MPMUpwMCuJ8H5vBgrxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjDt5JXEGxqbmBlZ
	GplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo7oQz5eTbP9+nGm+nzut20ni
	xIKfvX/KPj7ftTymqZJbs0nRknPfcgGPsCVRb7XiJpWp/6mdxG8+cUHeRdN/WhcvXJ/60eKp
	XIxvv1fO546fm4/PfCTD2lK0gWm+l57I2esNMXODLy+wYnnwU27q4/WKUyvmTV384w6jr/sy
	sTfzDYVOL/+YlK/EUpyRaKjFXFScCABaSYUtMQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-sh.c |   72 +++++++++++++++-----------------------------------
 1 file changed, 21 insertions(+), 51 deletions(-)

diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index cb2f839..6d87e26 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -593,7 +593,7 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 	char clk_name[6];
 	int clk_id, ret;
 
-	rtc = kzalloc(sizeof(struct sh_rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (unlikely(!rtc))
 		return -ENOMEM;
 
@@ -602,9 +602,8 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 	/* get periodic/carry/alarm irqs */
 	ret = platform_get_irq(pdev, 0);
 	if (unlikely(ret <= 0)) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IRQ resource\n");
-		goto err_badres;
+		return -ENOENT;
 	}
 
 	rtc->periodic_irq = ret;
@@ -613,24 +612,21 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (unlikely(res == NULL)) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "No IO resource\n");
-		goto err_badres;
+		return -ENOENT;
 	}
 
 	rtc->regsize = resource_size(res);
 
-	rtc->res = request_mem_region(res->start, rtc->regsize, pdev->name);
-	if (unlikely(!rtc->res)) {
-		ret = -EBUSY;
-		goto err_badres;
-	}
+	rtc->res = devm_request_mem_region(&pdev->dev, res->start,
+					rtc->regsize, pdev->name);
+	if (unlikely(!rtc->res))
+		return -EBUSY;
 
-	rtc->regbase = ioremap_nocache(rtc->res->start, rtc->regsize);
-	if (unlikely(!rtc->regbase)) {
-		ret = -EINVAL;
-		goto err_badmap;
-	}
+	rtc->regbase = devm_ioremap_nocache(&pdev->dev, rtc->res->start,
+					rtc->regsize);
+	if (unlikely(!rtc->regbase))
+		return -EINVAL;
 
 	clk_id = pdev->id;
 	/* With a single device, the clock id is still "rtc0" */
@@ -639,7 +635,7 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 
 	snprintf(clk_name, sizeof(clk_name), "rtc%d", clk_id);
 
-	rtc->clk = clk_get(&pdev->dev, clk_name);
+	rtc->clk = devm_clk_get(&pdev->dev, clk_name);
 	if (IS_ERR(rtc->clk)) {
 		/*
 		 * No error handling for rtc->clk intentionally, not all
@@ -665,8 +661,8 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 
 	if (rtc->carry_irq <= 0) {
 		/* register shared periodic/carry/alarm irq */
-		ret = request_irq(rtc->periodic_irq, sh_rtc_shared,
-				  0, "sh-rtc", rtc);
+		ret = devm_request_irq(&pdev->dev, rtc->periodic_irq,
+				sh_rtc_shared, 0, "sh-rtc", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request IRQ failed with %d, IRQ %d\n", ret,
@@ -675,8 +671,8 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 		}
 	} else {
 		/* register periodic/carry/alarm irqs */
-		ret = request_irq(rtc->periodic_irq, sh_rtc_periodic,
-				  0, "sh-rtc period", rtc);
+		ret = devm_request_irq(&pdev->dev, rtc->periodic_irq,
+				sh_rtc_periodic, 0, "sh-rtc period", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request period IRQ failed with %d, IRQ %d\n",
@@ -684,24 +680,21 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 			goto err_unmap;
 		}
 
-		ret = request_irq(rtc->carry_irq, sh_rtc_interrupt,
-				  0, "sh-rtc carry", rtc);
+		ret = devm_request_irq(&pdev->dev, rtc->carry_irq,
+				sh_rtc_interrupt, 0, "sh-rtc carry", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request carry IRQ failed with %d, IRQ %d\n",
 				ret, rtc->carry_irq);
-			free_irq(rtc->periodic_irq, rtc);
 			goto err_unmap;
 		}
 
-		ret = request_irq(rtc->alarm_irq, sh_rtc_alarm,
-				  0, "sh-rtc alarm", rtc);
+		ret = devm_request_irq(&pdev->dev, rtc->alarm_irq,
+				sh_rtc_alarm, 0, "sh-rtc alarm", rtc);
 		if (unlikely(ret)) {
 			dev_err(&pdev->dev,
 				"request alarm IRQ failed with %d, IRQ %d\n",
 				ret, rtc->alarm_irq);
-			free_irq(rtc->carry_irq, rtc);
-			free_irq(rtc->periodic_irq, rtc);
 			goto err_unmap;
 		}
 	}
@@ -714,13 +707,10 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 	sh_rtc_setaie(&pdev->dev, 0);
 	sh_rtc_setcie(&pdev->dev, 0);
 
-	rtc->rtc_dev = rtc_device_register("sh", &pdev->dev,
+	rtc->rtc_dev = devm_rtc_device_register(&pdev->dev, "sh",
 					   &sh_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc_dev)) {
 		ret = PTR_ERR(rtc->rtc_dev);
-		free_irq(rtc->periodic_irq, rtc);
-		free_irq(rtc->carry_irq, rtc);
-		free_irq(rtc->alarm_irq, rtc);
 		goto err_unmap;
 	}
 
@@ -737,12 +727,6 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 
 err_unmap:
 	clk_disable(rtc->clk);
-	clk_put(rtc->clk);
-	iounmap(rtc->regbase);
-err_badmap:
-	release_mem_region(rtc->res->start, rtc->regsize);
-err_badres:
-	kfree(rtc);
 
 	return ret;
 }
@@ -751,26 +735,12 @@ static int __exit sh_rtc_remove(struct platform_device *pdev)
 {
 	struct sh_rtc *rtc = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(rtc->rtc_dev);
 	sh_rtc_irq_set_state(&pdev->dev, 0);
 
 	sh_rtc_setaie(&pdev->dev, 0);
 	sh_rtc_setcie(&pdev->dev, 0);
 
-	free_irq(rtc->periodic_irq, rtc);
-
-	if (rtc->carry_irq > 0) {
-		free_irq(rtc->carry_irq, rtc);
-		free_irq(rtc->alarm_irq, rtc);
-	}
-
-	iounmap(rtc->regbase);
-	release_mem_region(rtc->res->start, rtc->regsize);
-
 	clk_disable(rtc->clk);
-	clk_put(rtc->clk);
-
-	kfree(rtc);
 
 	return 0;
 }
-- 
1.7.10.4


