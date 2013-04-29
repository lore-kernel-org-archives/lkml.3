Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3D2JQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:16:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62516 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab3D2JQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:16:34 -0400
X-AuditID: cbfee68d-b7f016d000007930-1e-517e3a7151c8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 4/5] watchdog: shwdt: use devm_clk_get()
Date: Mon, 29 Apr 2013 18:16:33 +0900
Message-id: <000501ce44ba$3df0f350$b9d2d9f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EujxPWxJ+tfsGQaGceRtlmKw+DQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zI91Cq7pAg7031C3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	LvY/Yi54wFtx/PET5gbGBdxdjJwcEgImEnvu3WeHsMUkLtxbz9bFyMUhJLCMUeLFogZ2mKJn
	b/+xQCSmM0ps6bvLDOH8YpRYtrqPDaSKTUBN4suXw0AdHBwiAvoSbS0aIDXMAh2MEgeeLmUF
	qREWsJdYN+EYWD2LgKrE6fXPmEBsXgFLiU0vfzFD2IISPybfYwGxmQW0JNbvPM4EYctLbF7z
	lhniIgWJHWdfM4LYIgJ6Em0LLrNB1IhI7HvxjhGiZh+7RM9fQYhdAhLfJh9iAblNQkBWYtMB
	qDGSEgdX3GCZwCg2C8nmWUg2z0KyeRaSDQsYWVYxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525i
	hMRb7w7G2wesDzEmA62fyCwlmpwPjNe8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTAuVrnObG06P366PL/0Jb5Ypb88ioKnORiDvITMik7ldkSf
	DXW/vDXA7fP7L0vuv9w5745e8PxCqweFN2fNsgt/Ez21+f2xqC7fd+zi/18rZCeabLMRerxB
	d+MKhr2Lo0wKVqz58/Nt2O0FeoeeivjVeu+O9/xaoCB8OWDFuQu7thQz7OA9sMNEiaU4I9FQ
	i7moOBEAZL6Oa80CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jQd1Cq7pAg2NvlS3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYMy72P2IueMBbcfzxE+YGxgXcXYycHBICJhLP3v5jgbDF
	JC7cW8/WxcjFISQwnVFiS99dZgjnF6PEstV9bCBVbAJqEl++HGbvYuTgEBHQl2hr0QCpYRbo
	YJQ48HQpK0iNsIC9xLoJx8DqWQRUJU6vf8YEYvMKWEpsevmLGcIWlPgx+R7YZmYBLYn1O48z
	QdjyEpvXvGWGuEhBYsfZ14wgtoiAnkTbgstsEDUiEvtevGOcwCgwC8moWUhGzUIyahaSlgWM
	LKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguP5mfQOxlUNFocYBTgYlXh4AzbXBgqxJpYV
	V+YeYpTgYFYS4VU0qgsU4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5HxgqskriTc0NjEzsjQy
	szAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsb49zJMsmtLS39JX9/IJLZ4csSF
	srwA0dqa9Qd/rbley+ch2qFz/L7rvil+fI573fvspZatSr4e9IBvk714mJPP3g9ROy3URPiu
	1CT+UM6ZHKp+bclHps3TFoStK2Zf6d/7oHqH/NYrQgkq1lLTF2g7qGp5Xym95Ge5ySfatDj0
	WsCewwKxB5RYijMSDbWYi4oTATdmLH8rAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/shwdt.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index 6185af2..ea2154b 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -241,7 +241,7 @@ static int sh_wdt_probe(struct platform_device *pdev)
 
 	wdt->dev = &pdev->dev;
 
-	wdt->clk = clk_get(&pdev->dev, NULL);
+	wdt->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(wdt->clk)) {
 		/*
 		 * Clock framework support is optional, continue on
@@ -251,10 +251,8 @@ static int sh_wdt_probe(struct platform_device *pdev)
 	}
 
 	wdt->base = devm_ioremap_resource(wdt->dev, res);
-	if (IS_ERR(wdt->base)) {
-		rc = PTR_ERR(wdt->base);
-		goto err;
-	}
+	if (IS_ERR(wdt->base))
+		return PTR_ERR(wdt->base);
 
 	watchdog_set_nowayout(&sh_wdt_dev, nowayout);
 	watchdog_set_drvdata(&sh_wdt_dev, wdt);
@@ -277,7 +275,7 @@ static int sh_wdt_probe(struct platform_device *pdev)
 	rc = watchdog_register_device(&sh_wdt_dev);
 	if (unlikely(rc)) {
 		dev_err(&pdev->dev, "Can't register watchdog (err=%d)\n", rc);
-		goto err;
+		return rc;
 	}
 
 	init_timer(&wdt->timer);
@@ -292,11 +290,6 @@ static int sh_wdt_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	return 0;
-
-err:
-	clk_put(wdt->clk);
-
-	return rc;
 }
 
 static int sh_wdt_remove(struct platform_device *pdev)
@@ -308,7 +301,6 @@ static int sh_wdt_remove(struct platform_device *pdev)
 	watchdog_unregister_device(&sh_wdt_dev);
 
 	pm_runtime_disable(&pdev->dev);
-	clk_put(wdt->clk);
 
 	return 0;
 }
-- 
1.7.2.5


