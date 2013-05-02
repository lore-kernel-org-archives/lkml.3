Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3EBFwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 01:52:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54275 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab3EBFwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 01:52:17 -0400
X-AuditID: cbfee68d-b7f016d000007930-3d-5181ff1041c1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V3 7/7] watchdog: ts72xx_wdt: use devm_*() functions
Date: Thu, 02 May 2013 14:52:16 +0900
Message-id: <000a01ce46f9$334257f0$99c707d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5G+TFFEK27ofz2QSKww3BSRyGJ4g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zI12B/42BBlfuCVrMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFk4VnmCxuzXjB6sDmcW2zmMeJGb9ZPHZ+b2D36NuyitHj8ya5ANYoLpuU
	1JzMstQifbsErowbzzpYCu7IVPTv8Ghg/CDexcjJISFgIrHswyN2CFtM4sK99WxdjFwcQgLL
	GCU+rZzKCFPUdn8nmC0kMJ1R4vRbNQj7F6PEjVYNEJtNQE3iy5fDQIM4OEQE9CXaWjRA5jAL
	bGCUOPn/L9gCYQEXiTcbnrKB2CwCqhLXPmxmAannFbCUmPlbHiTMKyAo8WPyPRYQm1lAS2L9
	zuNMELa8xOY1b5khzlGQ2HH2Ndg5IgJ6EttefWOFqBGR2PfiHSPIXgmBU+wSp6deZIHYJSDx
	bfIhsF0SArISmw5AzZGUOLjiBssERrFZSFbPQrJ6FpLVs5CsWMDIsopRNLUguaA4Kb3IUK84
	Mbe4NC9dLzk/dxMjJPp6dzDePmB9iDEZaP1EZinR5Hxg9OaVxBsamxlZmJqYGhuZW5qRJqwk
	zqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVFbz5fPQf/q5rvpBX7mMwP6ZrSbrfjT
	8ZmL46+4NcOTV4rCrfrWn6SKQ5/5HX104kh6o5GezYTTkxYF++9jUgxxKkuVz3wdnuWeUnJ9
	8c3kqquVwhJic3ZOUGBmeLj4zdJP6vkrTt83/1JmWLZRMuuq0dvn3k3B+QHH9dnYGsOncwid
	lMvzU2Ipzkg01GIuKk4EAMqAqm3UAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQV2B/42BBtcX8FrMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFk4VnmCxuzXjB6sDmcW2zmMeJGb9ZPHZ+b2D36NuyitHj8ya5ANaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZN551sBTckano3+HRwPhBvIuRk0NC
	wESi7f5ORghbTOLCvfVsILaQwHRGidNv1SDsX4wSN1o1QGw2ATWJL18Os3cxcnCICOhLtLUA
	hbk4mAU2MEqc/P+XHaRGWMBF4s2Gp2BzWARUJa592MwCUs8rYCkx87c8SJhXQFDix+R7LCA2
	s4CWxPqdx5kgbHmJzWveMkOcoyCx4+xrsNNEBPQktr36xgpRIyKx78U7xgmMArOQjJqFZNQs
	JKNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4tp9J72Bc1WBxiFGAg1GJh/eD
	bmOgEGtiWXFl7iFGCQ5mJRHeBa+BQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTDt5JfGG
	xiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cBY3xN8w+c/e1V7xQEl
	aQle2V+fVRgTohd/m3B0C9OzK2k371ozsOldnmeupsLLqrdyeeCvYzbLez2/qvL+yJ1a8jBT
	JXCeLk+A12zXf9MmrKqc2iiw7s7bA7XRv/yuHWNv2DrTZH70tKCJhgIaZb2nNF8wCc9vFFBk
	WdV+bB7728lXHWtPGu5QYinOSDTUYi4qTgQA+QBw3jEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v2:
- removed unnecessary platform_set_drvdata(pdev, NULL)

 drivers/watchdog/ts72xx_wdt.c |   67 ++++++----------------------------------
 1 files changed, 10 insertions(+), 57 deletions(-)

diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index b8a9245..4da59b4 100644
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
+		return -ENODEV;
 	}
 
-	r1 = request_mem_region(r1->start, resource_size(r1), pdev->name);
-	if (!r1) {
-		dev_err(&pdev->dev, "cannot request memory region\n");
-		error = -EBUSY;
-		goto fail;
-	}
-
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
-	}
-
-	r2 = request_mem_region(r2->start, resource_size(r2), pdev->name);
-	if (!r2) {
-		dev_err(&pdev->dev, "cannot request memory region\n");
-		error = -EBUSY;
-		goto fail_unmap_control;
+		return -ENODEV;
 	}
 
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
@@ -455,45 +433,20 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	error = misc_register(&ts72xx_wdt_miscdev);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register miscdev\n");
-		goto fail_unmap_feed;
+		return error;
 	}
 
 	dev_info(&pdev->dev, "TS-72xx Watchdog driver\n");
 
 	return 0;
-
-fail_unmap_feed:
-	platform_set_drvdata(pdev, NULL);
-	iounmap(wdt->feed_reg);
-fail_free_feed:
-	release_mem_region(r2->start, resource_size(r2));
-fail_unmap_control:
-	iounmap(wdt->control_reg);
-fail_free_control:
-	release_mem_region(r1->start, resource_size(r1));
-fail:
-	kfree(wdt);
-	return error;
 }
 
 static int ts72xx_wdt_remove(struct platform_device *pdev)
 {
-	struct ts72xx_wdt *wdt = platform_get_drvdata(pdev);
-	struct resource *res;
 	int error;
 
 	error = misc_deregister(&ts72xx_wdt_miscdev);
-	platform_set_drvdata(pdev, NULL);
-
-	iounmap(wdt->feed_reg);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	release_mem_region(res->start, resource_size(res));
-
-	iounmap(wdt->control_reg);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
 
-	kfree(wdt);
 	return error;
 }
 
-- 
1.7.2.5


