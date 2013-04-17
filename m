Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab3DQBJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:09:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33342 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab3DQBJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:09:15 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-e3-516df63ab262
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
In-reply-to: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
Subject: [PATCH RESEND 8/8] rtc: rtc-twl: convert twl4030rtc_driver to
 dev_pm_ops
Date: Wed, 17 Apr 2013 10:09:14 +0900
Message-id: <003701ce3b08$2d47f230$87d7d690$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac47B9XUIMaX4YjsSbW0FEYgtMIOOAAAE2Ew
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY12rb7mBBlfumlksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsfupSMEv3orvl08zNjDu5+5i5OSQEDCR6D++kxnCFpO4cG89WxcjF4eQwDJGiaev
	/zPBFD1b28sCkZjOKNE8/zk7hPOLUeL8ndWMIFVsAmoSX74cBkpwcIgI6Eu0tWiA1DAL9DJK
	nOndzQ5SIyRgK3Gz4xDYVE4BO4lvR+6A9QoLBEvMm/SMDcRmEVCVuLuugwXE5gWqn7a/nQ3C
	FpT4MfkeWJxZQEti/c7jTBC2vMTmNW+ZQfZKCKhLPPqrCxIWETCSWL6ukw2iRERi34t3jCD3
	SAjcY5fY8bmRHWKXgMS3yYdYIHplJTYdgIaEpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZV
	jKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCGROnEH4/0D1ocYk4HWT2SWEk3OB0Z6Xkm8obGZ
	kYWpiamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYL8TJaz/ft6M2
	JCntyPyof1911Uu2Bkv87yyd+CauljWzUGlbdPHp+Cc2XrKOK9WbPMtONPddrNZi31o8d7HS
	mb0fvaok7/+dcvzF86NH8yetDb9+K8X10ovV7tOmfDP5oBY5tZbnSb1tjBv/srq9MyUfHdub
	1vhif5vat/8ZZ4+8NN5z/VjmPCWW4oxEQy3mouJEAJf0sRDqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV2rb7mBBqcnGVssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLH7qUjBL96K75dPMzYw7ufuYuTkkBAwkXi2
	tpcFwhaTuHBvPVsXIxeHkMB0Ronm+c/ZIZxfjBLn76xmBKliE1CT+PLlMFCCg0NEQF+irUUD
	pIZZoJdR4kzvbnaQGiEBW4mbHYeYQGxOATuJb0fugPUKCwRLzJv0jA3EZhFQlbi7rgNsMy9Q
	/bT97WwQtqDEj8n3wOLMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxPJ1nWwQJSIS
	+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC08Az
	qR2MKxssDjEKcDAq8fBeKMgNFGJNLCuuzD3EKMHBrCTCq7gKKMSbklhZlVqUH19UmpNafIgx
	GejRicxSosn5wBSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2MhjUmx87pNngsrtnEWitesEp567TQpxJNflFWU30cpz4J/5S8ZVO019eZ3muKGibO6fa1
	UrpRXHWML/p32kINWTeL0woiV5iLVFY/0BBveadZuVptZ8/5k6v/b9hRs0TZOKB9jfHFhVe2
	eDWW2jK+VhOYm7pkh4HssoL8eaXuUl9ma0W09E5TYinOSDTUYi4qTgQA2dBRlkcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-twl.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 8bc6c80..8751a52 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -566,11 +566,10 @@ static void twl_rtc_shutdown(struct platform_device *pdev)
 	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static unsigned char irqstat;
 
-static int twl_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int twl_rtc_suspend(struct device *dev)
 {
 	irqstat = rtc_irq_bits;
 
@@ -578,17 +577,15 @@ static int twl_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int twl_rtc_resume(struct platform_device *pdev)
+static int twl_rtc_resume(struct device *dev)
 {
 	set_rtc_irq_bit(irqstat);
 	return 0;
 }
-
-#else
-#define twl_rtc_suspend NULL
-#define twl_rtc_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(twl_rtc_pm_ops, twl_rtc_suspend, twl_rtc_resume);
+
 #ifdef CONFIG_OF
 static const struct of_device_id twl_rtc_of_match[] = {
 	{.compatible = "ti,twl4030-rtc", },
@@ -603,11 +600,10 @@ static struct platform_driver twl4030rtc_driver = {
 	.probe		= twl_rtc_probe,
 	.remove		= twl_rtc_remove,
 	.shutdown	= twl_rtc_shutdown,
-	.suspend	= twl_rtc_suspend,
-	.resume		= twl_rtc_resume,
 	.driver		= {
 		.owner		= THIS_MODULE,
 		.name		= "twl_rtc",
+		.pm		= &twl_rtc_pm_ops,
 		.of_match_table = of_match_ptr(twl_rtc_of_match),
 	},
 };
-- 
1.7.2.5


