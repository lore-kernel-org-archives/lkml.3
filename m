Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab3EWKmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:42:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38496 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999Ab3EWKmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:42:18 -0400
X-AuditID: cbfee691-b7fef6d000002d62-ce-519df289463b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/3] rtc: rtc-mpc5121: use platform_{get,set}_drvdata()
Date: Thu, 23 May 2013 19:42:16 +0900
Message-id: <003201ce57a2$319bdde0$94d399a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5XojDf7y1QAUAfSHC150SGRBeGJA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zfd3OT3MDDVq+sVgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8WH1dfaCOdwVfxa+Z29g3MnZxcjJISFgIrFt7x9WCFtM4sK99WxdjFwcQgLLGCWO
	rj7BBFN0rHETM0RiEaPEwTtNjBDOL0aJT03NzCBVbAJqEl++HGbvYuTgEBHQl2hr0QCpYRbo
	ZpR41DwXrEZYwF1i25YGMJtFQFXiw/55YBt4BSwlvsz8yAZhC0r8mHyPBcRmFtCSWL/zOBOE
	LS+xec1bZoiLFCR2nH3NCGKLCOhJbF+1iB2iRkRi34t3YMdJCBxjl9jU/ZkdYpmAxLfJh1hA
	jpMQkJXYdABqjqTEwRU3WCYwis1CsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ6UWmesWJucWl
	eel6yfm5mxgh0TdxB+P9A9aHGJOB1k9klhJNzgdGb15JvKGxmZGFqYmpsZG5pRlpwkrivOot
	1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGE3MFNeZbpkp9yVnzTf9jW8Va+oXP9rLE52j
	0dhmeKlG3uIa9+u1/cddOyanBtRJ/kmyUmOUP7jU7sqf4zdj6taZdp78yHPd4/K0CQdvrvNc
	ub5/cort3JecPme7Ap+1rw02jaiS+Xfsz4N9Xz7KTkrSX7aK6a9VzY+1zx/cvinf+LN6RuIT
	pxdKLMUZiYZazEXFiQAP8yxa1AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd3OT3MDDR6sZrRYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePD6uvsBXO4K/4sfM/ewLiTs4uRk0NCwETi
	WOMmZghbTOLCvfVsXYxcHEICixglDt5pYoRwfjFKfGpqBqtiE1CT+PLlMHsXIweHiIC+RFuL
	BkgNs0A3o8Sj5rlgNcIC7hLbtjSA2SwCqhIf9s9jArF5BSwlvsz8yAZhC0r8mHyPBcRmFtCS
	WL/zOBOELS+xec1bqIsUJHacfc0IYosI6ElsX7WIHaJGRGLfi3eMExgFZiEZNQvJqFlIRs1C
	0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBsP5PawbiyweIQowAHoxIPr8TtOYFC
	rIllxZW5hxglOJiVRHg398wNFOJNSaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8YNrJK4k3NDYx
	M7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbG6p/771zmEtVZe1NYJHv2
	XC+fE0/czV6aqQpd2mDmlmfnq7D7r01IYOmC359fzP5od6dmReKduuVbsljN7mWz93pYHXy+
	7IlQnLfY9hT2GatmZCbzhdSU52pqzu1+uPzFjfl66+VnMPlMjF/4grd73ivvHX8EZuVH5Znb
	7YnMPK3j0ml4PixGiaU4I9FQi7moOBEAGX87jzEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-mpc5121.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index 213006b..f7891d5 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -325,7 +325,7 @@ static int mpc5121_rtc_probe(struct platform_device *op)
 
 	device_init_wakeup(&op->dev, 1);
 
-	dev_set_drvdata(&op->dev, rtc);
+	platform_set_drvdata(op, rtc);
 
 	rtc->irq = irq_of_parse_and_map(op->dev.of_node, 1);
 	err = request_irq(rtc->irq, mpc5121_rtc_handler, 0,
@@ -385,7 +385,7 @@ out_free:
 
 static int mpc5121_rtc_remove(struct platform_device *op)
 {
-	struct mpc5121_rtc_data *rtc = dev_get_drvdata(&op->dev);
+	struct mpc5121_rtc_data *rtc = platform_get_drvdata(op);
 	struct mpc5121_rtc_regs __iomem *regs = rtc->regs;
 
 	/* disable interrupt, so there are no nasty surprises */
@@ -398,7 +398,6 @@ static int mpc5121_rtc_remove(struct platform_device *op)
 	free_irq(rtc->irq_periodic, &op->dev);
 	irq_dispose_mapping(rtc->irq);
 	irq_dispose_mapping(rtc->irq_periodic);
-	dev_set_drvdata(&op->dev, NULL);
 	kfree(rtc);
 
 	return 0;
-- 
1.7.10.4


