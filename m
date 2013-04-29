Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3D2Jee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:34:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26146 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab3D2Jec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:34:32 -0400
X-AuditID: cbfee690-b7f136d000000fea-1e-517e3ea723d0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH RESEND 1/7] watchdog: at32ap700x_wdt: use devm_*() functions
Date: Mon, 29 Apr 2013 18:34:31 +0900
Message-id: <000b01ce44bc$c0960280$41c20780$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EvL/H9OS3/2XxQq+MDqCZADo6sA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zY93ldnWBBgefm1rMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	bJ25kq2gga/i7cl17A2MG7i7GDk5JARMJKZfeM4GYYtJXLi3Hsjm4hASWMYo0dS7gQmmaN6G
	VYwQiemMElt2LGKCcH4xSlx/8IMRpIpNQE3iy5fD7F2MHBwiAvoSbS0aIDXMAl2MEnuf/2EH
	qREW8JFY37aCCaSGRUBV4vx7sFZeAUuJV2sfM0PYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOW
	GeIgBYkdZ1+D9YoI6Ek8PrAYql5EYt+Ld4wQNfvYJY6/VQOxWQQEJL5NPsQCslZCQFZi0wGo
	MZISB1fcYJnAKDYLyeZZSDbPQrJ5FpINCxhZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmKE
	RNuEHYz3DlgfYkwGWj+RWUo0OR8YrXkl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYJyWY7o82y48RHNfiUob23OdQ3XmLB0iYvpX9Jce3R+uz/no
	WM6V0PxLmcEbDyye33VZ/mXzzHfu1+87mC712ebyVut66y5nziyFSuat9fKx78+fmr+AferH
	ZffbTV34KvNClt1Zbp4VvfHEjtnlluGXAzYzXJ4VO/07x7olhnN+vj7OGuUVa6LEUpyRaKjF
	XFScCAApimH0zAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd3ldnWBBld+GlrMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZmyduZKtoIGv4u3JdewNjBu4uxg5OSQETCTmbVjFCGGL
	SVy4t56ti5GLQ0hgOqPElh2LmCCcX4wS1x/8AKtiE1CT+PLlMHsXIweHiIC+RFuLBkgNs0AX
	o8Te53/YQWqEBXwk1retYAKpYRFQlTj/HqyVV8BS4tXax8wQtqDEj8n3WEBsZgEtifU7jzNB
	2PISm9e8ZYY4SEFix9nXYL0iAnoSjw8shqoXkdj34h3jBEaBWUhGzUIyahaSUbOQtCxgZFnF
	KJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzNz6R3MK5qsDjEKMDBqMTDG7C5NlCINbGsuDL3
	EKMEB7OSCO8Ky7pAId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4HJpq8knhDYxMzI0sjMwsj
	E3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBcEc282+b8F2PL1i1lCtZr/FY6qhn0
	2R7aK6la+Mks9NdDhaP3X/b2iB9ey/HNNV9oT4XlLLHO7xLbeY3UvBySvV0VNh8WPOTXUqJ7
	JT5y0Tez8DWZ01dMd4wqYCoqP107T/Nk0ucrO65ujFi+5+frspQnV4xNP6Tbf7NT3HWu4/P2
	inK7nV+VWIozEg21mIuKEwHAVG+2KgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/at32ap700x_wdt.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index 7a715e3..c4cb552 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -321,13 +321,14 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	wdt = kzalloc(sizeof(struct wdt_at32ap700x), GFP_KERNEL);
+	wdt = devm_kzalloc(&pdev->dev, sizeof(struct wdt_at32ap700x),
+			GFP_KERNEL);
 	if (!wdt) {
 		dev_dbg(&pdev->dev, "no memory for wdt structure\n");
 		return -ENOMEM;
 	}
 
-	wdt->regs = ioremap(regs->start, resource_size(regs));
+	wdt->regs = devm_ioremap(&pdev->dev, regs->start, resource_size(regs));
 	if (!wdt->regs) {
 		ret = -ENOMEM;
 		dev_dbg(&pdev->dev, "could not map I/O memory\n");
@@ -342,7 +343,7 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 		dev_info(&pdev->dev, "CPU must be reset with external "
 				"reset or POR due to silicon errata.\n");
 		ret = -EIO;
-		goto err_iounmap;
+		goto err_free;
 	} else {
 		wdt->users = 0;
 	}
@@ -375,10 +376,7 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 
 err_register:
 	platform_set_drvdata(pdev, NULL);
-err_iounmap:
-	iounmap(wdt->regs);
 err_free:
-	kfree(wdt);
 	wdt = NULL;
 	return ret;
 }
@@ -391,8 +389,6 @@ static int __exit at32_wdt_remove(struct platform_device *pdev)
 			at32_wdt_stop();
 
 		misc_deregister(&wdt->miscdev);
-		iounmap(wdt->regs);
-		kfree(wdt);
 		wdt = NULL;
 		platform_set_drvdata(pdev, NULL);
 	}
-- 
1.7.2.5


