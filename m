Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab3CFF2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:28:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28172 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3CFF2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:28:22 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-86-5136d3f5ade3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 04/30] rtc: rtc-da9055: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:28:20 +0900
Message-id: <004601ce1a2b$6a444ce0$3ecce6a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAACPpQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zI92vl80CDQ5s47S4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZh4/vZCy4y17xfO8ipgbGXWxdjJwcEgImEru6D7JA2GISF+6t
	B4pzcQgJLGOUOH3nOlMXIwdY0dNTmhDxRYwSN38uZYZwZjNJHPjYww7SzSagJvHly2F2kAYR
	AX2JthYNkBpmgV5GiTO9u8FqhARsJa52r2IGsTkF7CSWP54FtllYwE1ixoaHrCA2i4CqxNKm
	FrA4L1D9sj0N7BC2oMSPyffA4swCWhLrdx5ngrDlJTavecsMcai6xKO/uiBhEQEjiXf/vrNC
	lIhI7HvxjhHkHgmBRewS+9c/Z4LYJSDxbfIhFoheWYlNB5ghASEpcXDFDZYJjBKzkGyehWTz
	LCSbZyFZsYCRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSGT17WC8ecD6EGMy0PqJzFKi
	yfnAyMwriTc0NjYxMzE1Mbc0NTclTVhJnFf+kkygkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	Bka36H+7+prPzLhXuk+b23RdeTC3dNKbC9qq9UxLr3j9Wyw8P1Vzy/Y5Cov2bVcJ+9Dod631
	l1LIlxMdn6VWvNv/Juj2a6kpZ/MjSyyL9F5p6t+KD5x4gj/ZQOKGzEndZRPWPUm+taPNPnP2
	xatPNX5pzDoeEsPgtnDHvZTMAxerD9e8rJbpFBNSYinOSDTUYi4qTgQAvDrag8ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO7Xy2aBBp+vsVhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjMPHdzIW3GWveL53EVMD
	4y62LkYODgkBE4mnpzS7GDmBTDGJC/fWA4W5OIQEFjFK3Py5lBnCmc0kceBjDztIFZuAmsSX
	L4fZQZpFBPQl2lo0QGqYBXoZJc707garERKwlbjavYoZxOYUsJNY/ngWC4gtLOAmMWPDQ1YQ
	m0VAVWJpUwtYnBeoftmeBnYIW1Dix+R7YHFmAS2J9TuPM0HY8hKb17xlhjhaXeLRX12QsIiA
	kcS7f99ZIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al
	6yXn525iBMftM+kdjKsaLA4xCnAwKvHwTlAxCxRiTSwrrsw9xCjBwawkwst1BijEm5JYWZVa
	lB9fVJqTWnyIMRno0YnMUqLJ+cCUklcSb2hsYmZkaWRmYWRibk6asJI4L+OpJwFCAumJJanZ
	qakFqUUwW5g4OKUaGIU+pd2+M73LYY6hvcWF0MqeaY6MvmbO766WOzsIcRtUan/blXenrWDN
	ZiaNTXVZsp7NSRzTd9/omPByprxHxqV7fRlp+eLf94QezfaP4JUqtuhdyByk4LihrM5vb67c
	/buG7Ftzt78Iv/B/4cY9k3qrDFbwHN5znk9E6ADry9ldJ31NAn7HKrEUZyQaajEXFScCACYv
	r5QfAwAA
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
 drivers/rtc/rtc-da9055.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-da9055.c b/drivers/rtc/rtc-da9055.c
index 8f0dcfe..24d7012 100644
--- a/drivers/rtc/rtc-da9055.c
+++ b/drivers/rtc/rtc-da9055.c
@@ -294,7 +294,7 @@ static int da9055_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 					&da9055_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		ret = PTR_ERR(rtc->rtc);
@@ -317,9 +317,6 @@ err_rtc:
 
 static int da9055_rtc_remove(struct platform_device *pdev)
 {
-	struct da9055_rtc *rtc = pdev->dev.platform_data;
-
-	rtc_device_unregister(rtc->rtc);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


