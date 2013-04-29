Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab3D2JQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:16:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23432 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3D2JQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:16:52 -0400
X-AuditID: cbfee691-b7fe56d000004b96-29-517e3a8118b3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 5/5] watchdog: sp805_wdt: use devm_clk_get()
Date: Mon, 29 Apr 2013 18:16:49 +0900
Message-id: <000601ce44ba$47b62bd0$d7228370$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EukOR02+TtHFZRxGP1OZ8wf1eQg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zA90mq7pAg03vGC3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	5jXsYy54wFWx4uwWxgbGVxxdjBwcEgImEjcXlHUxcgKZYhIX7q1n62Lk4hASWMYocfh2DzNE
	wkRi0d0lTBCJ6YwSjw+sZoRwfjFKrGqewARSxSagJvHly2F2kKkiAvoSbS0aIDXMAh2MEgee
	LmUFqREWcJZ41PiJBcRmEVCVeLF4IhNIPa+ApcSlo1UgYV4BQYkfk++BlTALaEms33mcCcKW
	l9i85i3UQQoSO86+ZgSxRQT0JBatvgRVIyKx78U7sNskBPaxS/zqWg61S0Di2+RDLBAfy0ps
	OgA1R1Li4IobLBMYxWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CJTveLE3OLSvHS95Pzc
	TYyQaJu4g/H+AetDjMlA6ycyS4km5wOjNa8k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTE
	ktTs1NSC1KL4otKc1OJDjEwcnFINjI5hz1eG7qn78UZO5JR5cqgti57u7p3iC6tmsp3R4muU
	ruNwnuuVdVc/Z9KLb2w2v6earmVsjPx+slBMSKs+YV3bwk3iL0o2lCl/+a3grDnJPMjN2H9G
	9aF0nrDji2dbvhL7ttck74FmWKXgLPeKGTLC11b+O9P7LfPkHq34r55emZ6Hqi8+UmIpzkg0
	1GIuKk4EAHOXvzfMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd1Gq7pAg/X91hZz1q9hs7i88BKr
	xeVdc9gsbqzbx25xa8YLVgdWj2ubxTxOzPjN4tG3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGfMa9jEXPOCqWHF2C2MD4yuOLkZODgkBE4lFd5cwQdhi
	EhfurWfrYuTiEBKYzijx+MBqRgjnF6PEquYJYFVsAmoSX74cZu9i5OAQEdCXaGvRAKlhFuhg
	lDjwdCkrSI2wgLPEo8ZPLCA2i4CqxIvFE5lA6nkFLCUuHa0CCfMKCEr8mHwPrIRZQEti/c7j
	TBC2vMTmNW+ZIQ5SkNhx9jUjiC0ioCexaPUlqBoRiX0v3jFOYBSYhWTULCSjZiEZNQtJywJG
	llWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwdH8THoH46oGi0OMAhyMSjy8AZtrA4VYE8uK
	K3MPMUpwMCuJ8Coa1QUK8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4w0eSVxBsam5gZWRqZ
	WRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6OE4Pp8/gO/Dk+c0bOh6tLUYnZp
	fWbnP46cr5PWRq2yrOj1DGYQNE/hquVJuqXAHvQn4bxJ7rWY9bMteLuX60zh/VU1edvb4Dqf
	qmmZQU0x2p6+7/s/sskbpmkXceac5bY197v0QYkra/eLm7Jn++/cXXH51E79kM0uzF+cq09u
	/Phlx/eAm0osxRmJhlrMRcWJADJEWuAqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/sp805_wdt.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 8872642..58df98a 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -231,7 +231,7 @@ sp805_wdt_probe(struct amba_device *adev, const struct amba_id *id)
 		goto err;
 	}
 
-	wdt->clk = clk_get(&adev->dev, NULL);
+	wdt->clk = devm_clk_get(&adev->dev, NULL);
 	if (IS_ERR(wdt->clk)) {
 		dev_warn(&adev->dev, "Clock not found\n");
 		ret = PTR_ERR(wdt->clk);
@@ -251,15 +251,13 @@ sp805_wdt_probe(struct amba_device *adev, const struct amba_id *id)
 	if (ret) {
 		dev_err(&adev->dev, "watchdog_register_device() failed: %d\n",
 				ret);
-		goto err_register;
+		goto err;
 	}
 	amba_set_drvdata(adev, wdt);
 
 	dev_info(&adev->dev, "registration successful\n");
 	return 0;
 
-err_register:
-	clk_put(wdt->clk);
 err:
 	dev_err(&adev->dev, "Probe Failed!!!\n");
 	return ret;
@@ -272,7 +270,6 @@ static int sp805_wdt_remove(struct amba_device *adev)
 	watchdog_unregister_device(&wdt->wdd);
 	amba_set_drvdata(adev, NULL);
 	watchdog_set_drvdata(&wdt->wdd, NULL);
-	clk_put(wdt->clk);
 
 	return 0;
 }
-- 
1.7.2.5


