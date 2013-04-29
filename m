Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab3D2JgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:36:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24131 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3D2JgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:36:10 -0400
X-AuditID: cbfee68d-b7f016d000007930-6f-517e3f09f3e4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 6/7] watchdog: riowd: use devm_kzalloc()
Date: Mon, 29 Apr 2013 18:36:09 +0900
Message-id: <001001ce44bc$faf2ce40$f0d86ac0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EvPo5/7YcwIKZRZeR3ze+xbunNQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zfV1O+7pAgzn3TC3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Nj2fwl7wlLPi/b+1jA2Mr9i7GDk5JARMJE6vecoCYYtJXLi3ng3EFhJYxijx8bFeFyMHWM27
	h4JdjFxA4emMEsvaF7JAOL8YJc5segjWwCagJvHly2F2kAYRAX2JthYNkBpmgQ5GiQNPl7KC
	1AgL2EssmrAYzGYRUJVYcaiXGcTmFbCU2LZnERuELSjxY/I9sIOYBbQk1u88zgRhy0tsXvOW
	GeJQBYkdZ18zgtgiAnoSt798Y4OoEZHY9+IdI8hiCYF97BJX/vxjgVgmIPFt8iEWiG9kJTYd
	gJojKXFwxQ2WCYxis5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kaFecWJucWleul5yfu4m
	Rki09e5gvH3A+hBjMtD6icxSosn5wGjNK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEk
	NTs1tSC1KL6oNCe1+BAjEwenVAPjNMPnvWtz1utULbU5OztQ+YTf48gtGhtPnI2KF8q8uf56
	8xR7SXmLey+36h+es/uE74Orweniu7PWcl+48ewmg977HEPn2B5P6XWS3jWbz0vXTm4/Fjtp
	XUrxkkO/rhXsatmn2x0jMUNqcU3J2tg5Ffk/HS4f0N3U2sp4ds5Lab+nd9NzGu5cVGIpzkg0
	1GIuKk4EAEEAg/bMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQV1O+7pAg/PfDS3mrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYMzY9n8Je8JSz4v2/tYwNjK/Yuxg5OCQETCTePRTsYuQE
	MsUkLtxbz9bFyMUhJDCdUWJZ+0IWCOcXo8SZTQ/ZQKrYBNQkvnw5DNYsIqAv0daiAVLDLNDB
	KHHg6VJWkBphAXuJRRMWg9ksAqoSKw71MoPYvAKWEtv2LGKDsAUlfky+xwJiMwtoSazfeZwJ
	wpaX2LzmLTPERQoSO86+ZgSxRQT0JG5/+cYGUSMise/FO8YJjAKzkIyahWTULCSjZiFpWcDI
	sopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOJqfSe1gXNlgcYhRgINRiYc3YHNtoBBrYllx
	Ze4hRgkOZiUR3hWWdYFCvCmJlVWpRfnxRaU5qcWHGJOBPp3ILCWanA9MNHkl8YbGJmZGlkZm
	FkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwNgXxfHG1KT5Qxurv26K82nGku78
	ta/XvmJ8sO46ozhD+IUN2ptn73m36JDwpilnhWQjJmVGW5Qt4ZXY7PTTsHvOB11jLROhbo6G
	DLm0JXE260JdS1Pss4WrDuxN/m7QYaPduNxaW+dWX+qff59uqtmnzs36bvj7p9BzfsvazGLW
	8KVrmsXmK7EUZyQaajEXFScCAFZOJ5gqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/riowd.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 0040451..13363ad 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -183,7 +183,7 @@ static int riowd_probe(struct platform_device *op)
 		goto out;
 
 	err = -ENOMEM;
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(&op->dev, sizeof(*p), GFP_KERNEL);
 	if (!p)
 		goto out;
 
@@ -192,7 +192,7 @@ static int riowd_probe(struct platform_device *op)
 	p->regs = of_ioremap(&op->resource[0], 0, 2, DRIVER_NAME);
 	if (!p->regs) {
 		pr_err("Cannot map registers\n");
-		goto out_free;
+		goto out;
 	}
 	/* Make miscdev useable right away */
 	riowd_device = p;
@@ -213,9 +213,6 @@ out_iounmap:
 	riowd_device = NULL;
 	of_iounmap(&op->resource[0], p->regs, 2);
 
-out_free:
-	kfree(p);
-
 out:
 	return err;
 }
@@ -226,7 +223,6 @@ static int riowd_remove(struct platform_device *op)
 
 	misc_deregister(&riowd_miscdev);
 	of_iounmap(&op->resource[0], p->regs, 2);
-	kfree(p);
 
 	return 0;
 }
-- 
1.7.2.5


