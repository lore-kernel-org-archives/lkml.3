Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3CFFfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:35:53 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26256 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3CFFft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:35:49 -0500
X-AuditID: cbfee690-b7f6b6d000004563-1c-5136d5b4098e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 26/30] rtc: rtc-tps65910: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:35:48 +0900
Message-id: <005c01ce1a2c$74e486a0$5ead93e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAS/vg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zA90tV80CDX4+U7K4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZXSfOMxXM4qxY23SPuYHxEXsXIyeHhICJxJKXS1khbDGJC/fW
	s3UxcnEICSxjlNj87QEjTNGxRZ+YIBKLGCXuT30NVTWbSWLhx0dgVWwCahJfvhwGGsvBISKg
	L9HWogFSwyzQyyhxpnc32DohAVuJq92rmEFsTgE7ieWPZ7GA2MICHhLz+l6DncEioCpx7f8N
	sJm8QPWrLs1hg7AFJX5MvgdWzyygJbF+53EmCFteYvOat8wgeyUE1CUe/dWFOMFI4vdxHYgK
	EYl9L94xgpwjIbCIXeLz8StQqwQkvk0+xALRKiux6QAzxL+SEgdX3GCZwCgxC8niWUgWz0Ky
	eBaSFQsYWVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525ihETWhB2M9w5YH2JMBlo/kVlKNDkf
	GJl5JfGGxsYmZiamJuaWpuampAkrifPKX5IJFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4
	RGeSU3/kvUWRT7n77po+krgq5VwScGGyb9oVmz1Z/0M+pj27/EeAXVrmv/1mmXVPmtPnRvzT
	ECgp6ItQ/yZbVszwQSGtd27+EmPxEEFLvU4HS5X4XC8pTmlRqx8SNYlT60IVtC575l7saX6+
	ps9aQvy4QXrOsdiAFxaPha/HaV7mFz7QrsRSnJFoqMVcVJwIAMby607CAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO6Wq2aBBifOSVlc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjK4T55kKZnFWrG26x9zA
	+Ii9i5GTQ0LAROLYok9MELaYxIV769m6GLk4hAQWMUrcn/oaypnNJLHw4yNGkCo2ATWJL18O
	A3VzcIgI6Eu0tWiA1DAL9DJKnOndDTZVSMBW4mr3KmYQm1PATmL541ksILawgIfEvL7XrCA2
	i4CqxLX/N8Bm8gLVr7o0hw3CFpT4MfkeWD2zgJbE+p3HmSBseYnNa94yg+yVEFCXePRXF+IE
	I4nfx3UgKkQk9r14xziBUWgWkkGzkAyahWTQLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXr
	JefnbmIEx+0z6R2MqxosDjEKcDAq8fBOUDELFGJNLCuuzD3EKMHBrCTCy3UGKMSbklhZlVqU
	H19UmpNafIgxGejPicxSosn5wJSSVxJvaGxiZmRpZGZhZGJuTpqwkjgv46knAUIC6Yklqdmp
	qQWpRTBbmDg4pRoYswUXMR21SOpnZtK1l5pXaTBz3yff76yms4qOXBOYFbMjLyWh3t5XopTr
	3GS5D+dmr1G6rWa3YKL3ybm52Wf/BJis/WD5b5OLpuxS+5k2U2W2N7Mqe706GfFq7m2bnWFn
	lZdLq/rOve5os/7Mmc8y/zlCYnYEzn3w/4TmQpujfbcToiY1Zc+KVmIpzkg01GIuKk4EABoz
	4SofAwAA
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
 drivers/rtc/rtc-tps65910.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index 8bd8115..12ac2ea 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -276,7 +276,7 @@ static int tps65910_rtc_probe(struct platform_device *pdev)
 	tps_rtc->irq = irq;
 	device_set_wakeup_capable(&pdev->dev, 1);
 
-	tps_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	tps_rtc->rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 		&tps65910_rtc_ops, THIS_MODULE);
 	if (IS_ERR(tps_rtc->rtc)) {
 		ret = PTR_ERR(tps_rtc->rtc);
@@ -295,12 +295,8 @@ static int tps65910_rtc_probe(struct platform_device *pdev)
  */
 static int tps65910_rtc_remove(struct platform_device *pdev)
 {
-	/* leave rtc running, but disable irqs */
-	struct tps65910_rtc *tps_rtc = platform_get_drvdata(pdev);
-
 	tps65910_rtc_alarm_irq_enable(&pdev->dev, 0);
 
-	rtc_device_unregister(tps_rtc->rtc);
 	return 0;
 }
 
-- 
1.7.2.5


