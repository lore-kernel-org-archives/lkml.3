Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3CLFxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:53:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30994 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3CLFxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:53:21 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-6b-513ec2d08960
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 13/14] backlight: ltv350qv: convert ltv350qv to dev_pm_ops
Date: Tue, 12 Mar 2013 14:53:20 +0900
Message-id: <004a01ce1ee5$e6705a70$b3510f50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAAJP5g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zQ90Lh+wCDWbuk7O4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZO9/cYCo4wVdx+PBX5gbGLp4uRk4OCQETiSn/NrND2GISF+6t
	Z+ti5OIQEljGKHHs9RxmmKLDz1ewQyQWMUqc3zKBCcKZzSSx8PAFsCo2ATWJL18OA1VxcIgI
	6Eu0tWiAhJkFSiW2PnjPAmILCdhK3F3/nBGkhFPATmLL3yyQsLCAl8Tfe3/BjmARUJW4N/cN
	E4jNC1Q+Z8dzVghbUOLH5HssECO1JNbvPM4EYctLbF7zlhlkpISAusSjv7ogYREBI4kHL+5D
	lYtI7HvxjhHkYgmBZewSvfvWsELsEpD4NvkQC0SvrMSmA1DvSkocXHGDZQKjxCwkm2ch2TwL
	yeZZSFYsYGRZxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iRESV/07GO8esD7EmAy0fiKzlGhy
	PjAu80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	2DpF1NklMXjWP8ffiVoG8/xfv9L90Vidcrhn1hbNoxceli3bOP+WLO/LLEfBX087tk3cW7JQ
	varA+ppXg/CxirqGq3+3zns+UVPbYpL0Kt9z6VMDCs2uvqhe8mQ79/Pst3bfkuwWLlVfE3Pa
	cKvcrGPhv3uuCC35kJar5FfsJN07xyXmYVCIrRJLcUaioRZzUXEiAPavEqHBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO6FQ3aBBld2SFlc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjJ1vbjAVnOCrOHz4K3MD
	YxdPFyMnh4SAicTh5yvYIWwxiQv31rN1MXJxCAksYpQ4v2UCE4Qzm0li4eELzCBVbAJqEl++
	HAbq4OAQEdCXaGvRAAkzC5RKbH3wngXEFhKwlbi7/jkjSAmngJ3Elr9ZIGFhAS+Jv/f+gu1i
	EVCVuDf3DROIzQtUPmfHc1YIW1Dix+R7LBAjtSTW7zzOBGHLS2xe85YZZKSEgLrEo7+6IGER
	ASOJBy/uQ5WLSOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECI7aZ9I7GFc1WBxiFOBgVOLhVfhmGyjEmlhWXJl7iFGCg1lJhDdjs12gEG9KYmVV
	alF+fFFpTmrxIcZkoEcnMkuJJucDE0peSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tS
	s1NTC1KLYLYwcXBKNTBaaPxzerF0LS+7uqvVnoWtE+u7D5ed5Ao+Lnq56Wi6yGdhS70ZoolZ
	AokbX/bz689uWTHTwurh89yStZ8n3TQ2vWo7/Vw8T1ah5LcT7/pWyKxdIrexfZ7/zrNJq3NX
	fcpwcPLh82/ODbz5NsXiZ6iYLIu+Xt7Dmc6JSzZsunBgTbaxjsEds4NKLMUZiYZazEXFiQBC
	4Z4SHgMAAA==
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
 drivers/video/backlight/ltv350qv.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
index c0b4b8f..ed1b392 100644
--- a/drivers/video/backlight/ltv350qv.c
+++ b/drivers/video/backlight/ltv350qv.c
@@ -271,25 +271,24 @@ static int ltv350qv_remove(struct spi_device *spi)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int ltv350qv_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int ltv350qv_suspend(struct device *dev)
 {
-	struct ltv350qv *lcd = spi_get_drvdata(spi);
+	struct ltv350qv *lcd = dev_get_drvdata(dev);
 
 	return ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int ltv350qv_resume(struct spi_device *spi)
+static int ltv350qv_resume(struct device *dev)
 {
-	struct ltv350qv *lcd = spi_get_drvdata(spi);
+	struct ltv350qv *lcd = dev_get_drvdata(dev);
 
 	return ltv350qv_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define ltv350qv_suspend	NULL
-#define ltv350qv_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(ltv350qv_pm_ops, ltv350qv_suspend, ltv350qv_resume);
+
 /* Power down all displays on reboot, poweroff or halt */
 static void ltv350qv_shutdown(struct spi_device *spi)
 {
@@ -302,13 +301,12 @@ static struct spi_driver ltv350qv_driver = {
 	.driver = {
 		.name		= "ltv350qv",
 		.owner		= THIS_MODULE,
+		.pm		= &ltv350qv_pm_ops,
 	},
 
 	.probe		= ltv350qv_probe,
 	.remove		= ltv350qv_remove,
 	.shutdown	= ltv350qv_shutdown,
-	.suspend	= ltv350qv_suspend,
-	.resume		= ltv350qv_resume,
 };
 
 module_spi_driver(ltv350qv_driver);
-- 
1.7.2.5


