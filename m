Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab3D2Jfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:35:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64230 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323Ab3D2Jff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:35:35 -0400
X-AuditID: cbfee68d-b7f016d000007930-fb-517e3ee64067
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 4/7] watchdog: nuc900_wdt: use devm_*() functions
Date: Mon, 29 Apr 2013 18:35:33 +0900
Message-id: <000e01ce44bc$e5d1dec0$b1759c40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EvOUEbkdFX7lWQDerm0aAGZoydw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t8zQ91ndnWBBhPmClrMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	TJ2yn6XgmGjFjA8HGRsY24S6GDk5JARMJPY//cYOYYtJXLi3ng3EFhJYxihx8qMETM2EG4dZ
	uhi5gOLTGSXenTrLCOH8YpRYP+8MWAebgJrEly+HgSZxcIgI6Eu0tWiA1DALdDBKHHi6lBUk
	LizgIXFrcRhIOYuAqsTU1UfBWnkFLCVObnvLAmELSvyYfA/MZhbQkli/8zgThC0vsXnNW2aI
	gxQkdpx9zQhiiwjoSXz+MZ8ZokZEYt+Ld4wQNYfYJfpe6EDsEpD4NvkQC8gJEgKyEpsOQI2R
	lDi44gbLBEaxWUg2z0KyeRaSzbOQbFjAyLKKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIyTW
	encw3j5gfYgxGWj9RGYp0eR8YKzmlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2a
	WpBaFF9UmpNafIiRiYNTqoFR2+OLX6u3mM6fF7rP+kO3ZJxekq66QNV0nobUvhKWnymnAhlX
	GiaaXE9JO1NXe3r7juWH67o2CZfMXxbP0nyq/PJGB6WkVSIhDN0bHZpe5m8M3xT7SWXzr8Ap
	PNt2XHNpfrk/KdP/vy/HxEMuP9csOs39L+T7brPWu/b3b+1zirI5+L2grr9GiaU4I9FQi7mo
	OBEArKK6+csCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd1ndnWBBi/v81jMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZkydsp+l4JhoxYwPBxkbGNuEuhg5OSQETCQm3DjMAmGL
	SVy4t56ti5GLQ0hgOqPEu1NnGSGcX4wS6+edYQOpYhNQk/jy5TB7FyMHh4iAvkRbiwZIDbNA
	B6PEgadLWUHiwgIeErcWh4GUswioSkxdfRSslVfAUuLktrcsELagxI/J98BsZgEtifU7jzNB
	2PISm9e8ZYY4SEFix9nXjCC2iICexOcf85khakQk9r14xziBUWAWklGzkIyahWTULCQtCxhZ
	VjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER/Mz6R2MqxosDjEKcDAq8fAGbK4NFGJNLCuu
	zD3EKMHBrCTCu8KyLlCINyWxsiq1KD++qDQntfgQYzLQpxOZpUST84GJJq8k3tDYxMzI0sjM
	wsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGBVetHS+4wt3fX/3+HW5ub6KBzx2
	Zt4xlvIXWJfRxPY+LFy0wsXjwvWpku+22svanr0n/b7GZOmu9fuczq678f/G1aao6ct/K5Vq
	mnTcu70+lFnF+NSy95vs5/+tmFi/wHCv9QmtxZ//PH7y8v9C8d6bLx615JaeuNX36MbDhS/+
	WFSJS753mmmmxFKckWioxVxUnAgAnsRUQioDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/nuc900_wdt.c |   45 ++++++++--------------------------------
 1 files changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
index 04c45a1..89e8991 100644
--- a/drivers/watchdog/nuc900_wdt.c
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -246,7 +246,8 @@ static int nuc900wdt_probe(struct platform_device *pdev)
 {
 	int ret = 0;
 
-	nuc900_wdt = kzalloc(sizeof(struct nuc900_wdt), GFP_KERNEL);
+	nuc900_wdt = devm_kzalloc(&pdev->dev, sizeof(struct nuc900_wdt),
+				GFP_KERNEL);
 	if (!nuc900_wdt)
 		return -ENOMEM;
 
@@ -257,30 +258,18 @@ static int nuc900wdt_probe(struct platform_device *pdev)
 	nuc900_wdt->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (nuc900_wdt->res == NULL) {
 		dev_err(&pdev->dev, "no memory resource specified\n");
-		ret = -ENOENT;
-		goto err_get;
+		return -ENOENT;
 	}
 
-	if (!request_mem_region(nuc900_wdt->res->start,
-				resource_size(nuc900_wdt->res), pdev->name)) {
-		dev_err(&pdev->dev, "failed to get memory region\n");
-		ret = -ENOENT;
-		goto err_get;
-	}
-
-	nuc900_wdt->wdt_base = ioremap(nuc900_wdt->res->start,
-					resource_size(nuc900_wdt->res));
-	if (nuc900_wdt->wdt_base == NULL) {
-		dev_err(&pdev->dev, "failed to ioremap() region\n");
-		ret = -EINVAL;
-		goto err_req;
-	}
+	nuc900_wdt->wdt_base = devm_ioremap_resource(&pdev->dev,
+						nuc900_wdt->res);
+	if (IS_ERR(nuc900_wdt->wdt_base))
+		return PTR_ERR(nuc900_wdt->wdt_base);
 
-	nuc900_wdt->wdt_clock = clk_get(&pdev->dev, NULL);
+	nuc900_wdt->wdt_clock = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(nuc900_wdt->wdt_clock)) {
 		dev_err(&pdev->dev, "failed to find watchdog clock source\n");
-		ret = PTR_ERR(nuc900_wdt->wdt_clock);
-		goto err_map;
+		return PTR_ERR(nuc900_wdt->wdt_clock);
 	}
 
 	clk_enable(nuc900_wdt->wdt_clock);
@@ -298,14 +287,6 @@ static int nuc900wdt_probe(struct platform_device *pdev)
 
 err_clk:
 	clk_disable(nuc900_wdt->wdt_clock);
-	clk_put(nuc900_wdt->wdt_clock);
-err_map:
-	iounmap(nuc900_wdt->wdt_base);
-err_req:
-	release_mem_region(nuc900_wdt->res->start,
-					resource_size(nuc900_wdt->res));
-err_get:
-	kfree(nuc900_wdt);
 	return ret;
 }
 
@@ -314,14 +295,6 @@ static int nuc900wdt_remove(struct platform_device *pdev)
 	misc_deregister(&nuc900wdt_miscdev);
 
 	clk_disable(nuc900_wdt->wdt_clock);
-	clk_put(nuc900_wdt->wdt_clock);
-
-	iounmap(nuc900_wdt->wdt_base);
-
-	release_mem_region(nuc900_wdt->res->start,
-					resource_size(nuc900_wdt->res));
-
-	kfree(nuc900_wdt);
 
 	return 0;
 }
-- 
1.7.2.5


