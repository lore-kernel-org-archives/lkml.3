Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab3CLFwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:52:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30723 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3CLFwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:52:02 -0400
X-AuditID: cbfee68d-b7f786d000005188-0f-513ec281e0dc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 09/14] backlight: hp680_bl: convert hp680bl to dev_pm_ops
Date: Tue, 12 Mar 2013 14:52:00 +0900
Message-id: <004601ce1ee5$b7145470$253cfd50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAAGR3A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY93GQ3aBBn8Oslhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mf1uvMBZc56uYNX0DcwPjQp4uRk4OCQETiT/PmpghbDGJC/fW
	s3UxcnEICSxjlPg28yEjTNG9y1egEosYJR4+vsIM4cxmkvj6fAo7SBWbgJrEly+HgWwODhEB
	fYm2Fg2QMLNAqcTWB+9ZQGwhAVuJu+ufM4KUcArYSWz5mwViCgt4Sky6KQlSwSKgKvFt7nWw
	al6g6gfretkgbEGJH5PvsUBM1JJYv/M4E4QtL7F5zVtmkDESAuoSj/7qgoRFBIwk1jR+hioR
	kdj34h0jyMESAovYJf7du8UMsUtA4tvkQywQvbISmw5Ag0FS4uCKGywTGCVmIdk8C8nmWUg2
	z0KyYgEjyypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkKjq3cF4+4D1IcZkoPUTmaVEk/OB
	UZlXEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbl
	U6Z+M3Is4WD/pH75wgxOk9+TsnfuWO7m9c7Ox3XmNI3vHN6uAlm2/0vEFi5e2/qwVqu0ccHD
	FydKfoQsd5puvf6+8+/6TzIM/i8KDvw5fm3uZb8X0kEvrt9W3idqmWaxN/gGm8kJpY0L+Lnm
	fHu9ZNmasD+MojEfRORifmgqr3/ysWvi2+kLlFiKMxINtZiLihMB/l71PcACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgG7jIbtAg+nyFpd3zWFzYPT4vEku
	gDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2io
	kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj39YrjAXX+SpmTd/A3MC4
	kKeLkZNDQsBE4t7lK2wQtpjEhXvrgWwuDiGBRYwSDx9fYYZwZjNJfH0+hR2kik1ATeLLl8NA
	NgeHiIC+RFuLBkiYWaBUYuuD9ywgtpCArcTd9c8ZQUo4BewktvzNAjGFBTwlJt2UBKlgEVCV
	+Db3Olg1L1D1g3W9bBC2oMSPyfdYICZqSazfeZwJwpaX2LzmLTPIGAkBdYlHf3VBwiICRhJr
	Gj9DlYhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P
	3cQIjthn0jsYVzVYHGIU4GBU4uFV+GYbKMSaWFZcmXuIUYKDWUmEN2OzXaAQb0piZVVqUX58
	UWlOavEhxmSgRycyS4km5wOTSV5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1ML
	UotgtjBxcEo1MObYqT9Ia+zv461nVGaREtNyl/6Zt4v7kE3Sq/wS4euxH+9Ol7+28PHBvkKp
	OwVLT/0Xn3T8SvJ+ycjt6kfuL7/XF7Cica3+46fHWr5vWvFs9lsuQZHm4g1rJa0FVS9pljn9
	eWWgdvDBRbkXFV89tsVX8VuIPjP++GHzUaaNh2R23e0Pvzdrv54SS3FGoqEWc1FxIgAgHhW9
	HAMAAA==
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
 drivers/video/backlight/hp680_bl.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight/hp680_bl.c
index 5cefd73..00076ec 100644
--- a/drivers/video/backlight/hp680_bl.c
+++ b/drivers/video/backlight/hp680_bl.c
@@ -64,29 +64,28 @@ static void hp680bl_send_intensity(struct backlight_device *bd)
 }
 
 
-#ifdef CONFIG_PM
-static int hp680bl_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int hp680bl_suspend(struct device *dev)
 {
-	struct backlight_device *bd = platform_get_drvdata(pdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 
 	hp680bl_suspended = 1;
 	hp680bl_send_intensity(bd);
 	return 0;
 }
 
-static int hp680bl_resume(struct platform_device *pdev)
+static int hp680bl_resume(struct device *dev)
 {
-	struct backlight_device *bd = platform_get_drvdata(pdev);
+	struct backlight_device *bd = dev_get_drvdata(dev);
 
 	hp680bl_suspended = 0;
 	hp680bl_send_intensity(bd);
 	return 0;
 }
-#else
-#define hp680bl_suspend	NULL
-#define hp680bl_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(hp680bl_pm_ops, hp680bl_suspend, hp680bl_resume);
+
 static int hp680bl_set_intensity(struct backlight_device *bd)
 {
 	hp680bl_send_intensity(bd);
@@ -140,10 +139,9 @@ static int hp680bl_remove(struct platform_device *pdev)
 static struct platform_driver hp680bl_driver = {
 	.probe		= hp680bl_probe,
 	.remove		= hp680bl_remove,
-	.suspend	= hp680bl_suspend,
-	.resume		= hp680bl_resume,
 	.driver		= {
 		.name	= "hp680-bl",
+		.pm	= &hp680bl_pm_ops,
 	},
 };
 
-- 
1.7.2.5


