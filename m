Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab3CNIVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:21:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33441 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab3CNIVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:21:20 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-f5-5141887d0959
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 20/30] rtc: rtc-rc5t583: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:21:16 +0900
Message-id: <009701ce208c$e63471b0$b29d5510$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAX+SA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zfd3aDsdAgzXdghaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjyoKpLAVzOCpuvtjB1MD4l62LkZNDQsBEoqG7iQXCFpO4cG89
	UJyLQ0hgGaPEzhsfmGGK/i9uYYZILGKU6Nz/EKpqNpPE0/6LrCBVbAJqEl++HGbvYuTgEBHQ
	l2hr0QCpYRboZZQ407sbLC4kYCtx/b8diMkpYCexYb0YSKewgLvE8S2z2EFsFgFVie0n1jOC
	2LxA1c8W7mOCsAUlfky+B3Yos4CWxPqdx5kgbHmJzWveMoOMlBBQl3j0VxckLCJgJPGrr4kZ
	okREYt+Ld4wg10gILGOXuL6zmRFil4DEt8mHWCB6ZSU2HYB6V1Li4IobLBMYJWYh2TwLyeZZ
	SDbPQrJiASPLKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQuJq4g/H+AetDjMlA6ycyS4km
	5wPjMq8k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jJZpWyKX/LGKOsss8GO/7vOSvR0xZmfrVsjUnN9/+emiHvfW041BLS4Xo09vkne4tEeOa0fG
	8uC1WTZpWcstG3tinl26Mbk5fYvUSu0N4SE+jZMkM8zb2DMvnjbYNMvin0eLjfbiS7w9X4o9
	rt+bsOLuvnLHZ466Zc/fbKtL7O//9v7ApQMt25RYijMSDbWYi4oTAd+u+4jBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG5th2OgwZ4tvBaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x48qCqSwFczgqbr7YwdTA
	+Jeti5GTQ0LAROL/4hZmCFtM4sK99UBxLg4hgUWMEp37H0I5s5kknvZfZAWpYhNQk/jy5TB7
	FyMHh4iAvkRbiwZIDbNAL6PEmd7dYHEhAVuJ6//tQExOATuJDevFQDqFBdwljm+ZxQ5iswio
	Smw/sZ4RxOYFqn62cB8ThC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lBRkoIqEs8+qsLEhYR
	MJL41dfEDFEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQv
	XS85P3cTIzhqn0ntYFzZYHGIUYCDUYmH90C/Q6AQa2JZcWXuIUYJDmYlEV5PL8dAId6UxMqq
	1KL8+KLSnNTiQ4zJQI9OZJYSTc4HJpS8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5ak
	ZqemFqQWwWxh4uCUamBktn58YrXIjYsPmH54fErIV+XZIHhu1v9/9ksONq9dHCHiuJd3jb3p
	xOpza97IxWhOY9B36w6aXVwpczba4z7bm1PytUu+lYotSIqODFj4aPH7c/3iPu/Wy1zbM0/7
	yIfw/Ut8b00MOiJ4TfvU5StNJvJ9Qe/4N2g9cdV+8S0xJEJQvP7UM9kKJZbijERDLeai4kQA
	9lfXKR4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-rc5t583.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-rc5t583.c b/drivers/rtc/rtc-rc5t583.c
index eb3194d..518908d 100644
--- a/drivers/rtc/rtc-rc5t583.c
+++ b/drivers/rtc/rtc-rc5t583.c
@@ -256,7 +256,7 @@ static int rc5t583_rtc_probe(struct platform_device *pdev)
 	}
 	device_init_wakeup(&pdev->dev, 1);
 
-	ricoh_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	ricoh_rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 		&rc5t583_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ricoh_rtc->rtc)) {
 		ret = PTR_ERR(ricoh_rtc->rtc);
@@ -276,8 +276,6 @@ static int rc5t583_rtc_remove(struct platform_device *pdev)
 	struct rc5t583_rtc *rc5t583_rtc = dev_get_drvdata(&pdev->dev);
 
 	rc5t583_rtc_alarm_irq_enable(&rc5t583_rtc->rtc->dev, 0);
-
-	rtc_device_unregister(rc5t583_rtc->rtc);
 	return 0;
 }
 
-- 
1.7.2.5


