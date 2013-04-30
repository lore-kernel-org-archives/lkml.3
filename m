Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3D3FCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:02:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64847 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3D3FCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:02:32 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-eb-517f5061d84d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2 7/7] watchdog: ts72xx_wdt: use devm_*() functions
Date: Tue, 30 Apr 2013 14:02:25 +0900
Message-id: <001401ce455f$e7ba02a0$b72e07e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5FX+LIZLskk0e1Q1mcyU1vrqaDQg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zA93EgPpAgzsLrSzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8bhy7OYCk7JVCztuc3YwHhbvIuRk0NCwETiReMkFghbTOLCvfVsXYxcHEIC
	yxglPt1fwAhTdOLVGSaIxHRGiS0LPkM5vxgl7v26ywZSxSagJvHly2H2LkYODhEBfYm2Fg2Q
	GmaBDYwSJ///ZQepERZwkdh4t4UZxGYRUJV4fXcKK0g9r4ClxK+TXCBhXgFBiR+T74FdxCyg
	JbF+53EmCFteYvOat8wQBylI7Dj7Guw4EQE9iWNTrkPViEjse/GOEWSvhMAldomjnx+zQ+wS
	kPg2+RALyC4JAVmJTQeg5khKHFxxg2UCo9gsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5k
	pFecmFtcmpeul5yfu4kREoN9OxhvHrA+xJgMtH4is5Rocj4whvNK4g2NzYwsTE1MjY3MLc1I
	E1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwOj3fdYNwRsP7NT4Tz5763tCe4aK
	ae7vrOSSGVWm6rN6opynOipejdCcMpN9ok2IqUL4DIMJpQ3Sk4J0frzSn8UWnOW+ozU2esb7
	HrFvz1ZdT3//RekB74lVrJ75HlLOEbtWH4h08Qmdoyx83X3f0u0bjP/syNw6IfPko5qXuhw6
	lboXP/3pbFJiKc5INNRiLipOBACkh82F1wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd3EgPpAgyMbNC3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMw5dnMRWckqlY2nObsYHxtngXIyeH
	hICJxIlXZ5ggbDGJC/fWs3UxcnEICUxnlNiy4DMThPOLUeLer7tsIFVsAmoSX74cZu9i5OAQ
	EdCXaGvRAKlhFtjAKHHy/192kBphAReJjXdbmEFsFgFVidd3p7CC1PMKWEr8OskFEuYVEJT4
	MfkeC4jNLKAlsX7ncSYIW15i85q3zBAHKUjsOPuaEcQWEdCTODblOlSNiMS+F+8YJzAKzEIy
	ahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOAIfya1g3Flg8UhRgEO
	RiUe3h1L6gKFWBPLiitzDzFKcDArifBGO9YHCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+
	MPnklcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANjUvGrCiVf
	HRX2Y0HPjwmujdT2Ntr7nKXH7HHSjTXTS/6IXr695O5MXfNm3VfzG4I1LjNOXKN8+8KCH4wX
	/wU2Zs8uvPPsr2TZjmeM5078jlzw9tWZ9mf/Ln/Y+f+8wxPZazaXzzWV7lR5uiYl9b3N+mkC
	NVlZe7M1edYEN7yV6S3wrpcr26ixVomlOCPRUIu5qDgRALBCdkE0AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/watchdog/ts72xx_wdt.c |   64 +++++++----------------------------------
 1 files changed, 11 insertions(+), 53 deletions(-)

diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index b8a9245..b19ca75 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -396,7 +396,7 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	struct resource *r1, *r2;
 	int error = 0;
 
-	wdt = kzalloc(sizeof(struct ts72xx_wdt), GFP_KERNEL);
+	wdt = devm_kzalloc(&pdev->dev, sizeof(struct ts72xx_wdt), GFP_KERNEL);
 	if (!wdt) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
@@ -405,44 +405,22 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r1) {
 		dev_err(&pdev->dev, "failed to get memory resource\n");
-		error = -ENODEV;
-		goto fail;
-	}
-
-	r1 = request_mem_region(r1->start, resource_size(r1), pdev->name);
-	if (!r1) {
-		dev_err(&pdev->dev, "cannot request memory region\n");
-		error = -EBUSY;
-		goto fail;
+		return -ENODEV;
 	}
 
-	wdt->control_reg = ioremap(r1->start, resource_size(r1));
-	if (!wdt->control_reg) {
-		dev_err(&pdev->dev, "failed to map memory\n");
-		error = -ENODEV;
-		goto fail_free_control;
-	}
+	wdt->control_reg = devm_ioremap_resource(&pdev->dev, r1);
+	if (IS_ERR(wdt->control_reg))
+		return PTR_ERR(wdt->control_reg);
 
 	r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!r2) {
 		dev_err(&pdev->dev, "failed to get memory resource\n");
-		error = -ENODEV;
-		goto fail_unmap_control;
+		return -ENODEV;
 	}
 
-	r2 = request_mem_region(r2->start, resource_size(r2), pdev->name);
-	if (!r2) {
-		dev_err(&pdev->dev, "cannot request memory region\n");
-		error = -EBUSY;
-		goto fail_unmap_control;
-	}
-
-	wdt->feed_reg = ioremap(r2->start, resource_size(r2));
-	if (!wdt->feed_reg) {
-		dev_err(&pdev->dev, "failed to map memory\n");
-		error = -ENODEV;
-		goto fail_free_feed;
-	}
+	wdt->feed_reg = devm_ioremap_resource(&pdev->dev, r2);
+	if (IS_ERR(wdt->feed_reg))
+		return PTR_ERR(wdt->feed_reg);
 
 	platform_set_drvdata(pdev, wdt);
 	ts72xx_wdt_pdev = pdev;
@@ -455,45 +433,25 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	error = misc_register(&ts72xx_wdt_miscdev);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register miscdev\n");
-		goto fail_unmap_feed;
+		goto fail;
 	}
 
 	dev_info(&pdev->dev, "TS-72xx Watchdog driver\n");
 
 	return 0;
 
-fail_unmap_feed:
-	platform_set_drvdata(pdev, NULL);
-	iounmap(wdt->feed_reg);
-fail_free_feed:
-	release_mem_region(r2->start, resource_size(r2));
-fail_unmap_control:
-	iounmap(wdt->control_reg);
-fail_free_control:
-	release_mem_region(r1->start, resource_size(r1));
 fail:
-	kfree(wdt);
+	platform_set_drvdata(pdev, NULL);
 	return error;
 }
 
 static int ts72xx_wdt_remove(struct platform_device *pdev)
 {
-	struct ts72xx_wdt *wdt = platform_get_drvdata(pdev);
-	struct resource *res;
 	int error;
 
 	error = misc_deregister(&ts72xx_wdt_miscdev);
 	platform_set_drvdata(pdev, NULL);
 
-	iounmap(wdt->feed_reg);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	release_mem_region(res->start, resource_size(res));
-
-	iounmap(wdt->control_reg);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	kfree(wdt);
 	return error;
 }
 
-- 
1.7.2.5


