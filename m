Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab3CLFt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:49:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34332 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3CLFt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:49:27 -0400
X-AuditID: cbfee68d-b7f786d000005188-b6-513ec1e63790
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 02/14] backlight: lms501kf03: convert lms501kf03 to dev_pm_ops
Date: Tue, 12 Mar 2013 14:49:26 +0900
Message-id: <003f01ce1ee5$5b09dc40$111d94c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAAAb7Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zY91nB+0CDTYdUrGYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDLOr1/K
	VLBDsGJR4xeWBsYTfF2MnBwSAiYS0zY1skHYYhIX7q0Hsrk4hASWMUo0PljCDFP07e1TFojE
	dEaJKWv3QDm/GCVutv1gBKliE1CT+PLlMHsXIweHiIC+RFuLBkiYWaBUYuuD9ywgtpCArcTd
	9c8ZQUo4BewktvzNAgkLC/hJXH/zixXEZhFQlbj//z3YXl6g8skfbjJB2IISPybfY4EYqSWx
	fudxJghbXmLzmrfMICMlBNQlHv3VBQmLCBhJrFnzFqpERGLfi3eMIBdLCFxilzh2ew8LxC4B
	iW+TD7FA9MpKbDoA9a6kxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFhnrF
	ibnFpXnpesn5uZsYITHZu4Px9gHrQ4zJQOsnMkuJJucDYzqvJN7Q2MzIwtTE1NjI3NKMNGEl
	cV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwnP9SblV4yry8vLWm4sqf1g+y/hTba
	5pM4Em6ui5pyP+qA122RNSlnnhowdBXH8D3/tl22f39gxr2mz+batWbN0mJNjiWVTM+ysrYa
	TWpe/Nvw1V/Z7oc/rz2IlGFYtGhJxvcPsguNDxmlzTe83+Yq7F5/6JrGifSQYJW08uLlSzne
	y/9490GJpTgj0VCLuag4EQADgcWf3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd1nB+0CDb4+lbeYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzzq9fylSwQ7BiUeMXlgbGE3xdjJwcEgImEt/ePmWBsMUkLtxb
	z9bFyMUhJDCdUWLK2j0sEM4vRombbT8YQarYBNQkvnw5zN7FyMEhIqAv0daiARJmFiiV2Prg
	PdggIQFbibvrnzOClHAK2Els+ZsFEhYW8JO4/uYXK4jNIqAqcf//e2YQmxeofPKHm0wQtqDE
	j8n3WCBGakms33mcCcKWl9i85i0zyEgJAXWJR391QcIiAkYSa9a8hSoRkdj34h3jBEahWUgm
	zUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzxz6R3MK5qsDjEKMDB
	qMTDq/DNNlCINbGsuDL3EKMEB7OSCG/GZrtAId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4H
	JqO8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDk+vkjZtrU
	oAWzvYS8Gx9wt4p0Ll2nqKTsK/RM1Hv2q4OsId2X9yXsZgyzzDtr/YrvdMaeLannrroaH1zJ
	zKPo4CZtp/GhaWa70YpX++wL0g/FB1rq/73Huk/x6/EW5orJkV8vHWYKPcaj/muPOJ/+ft17
	13ylbjxN/3MguOOvx8oER4VJL/mVWIozEg21mIuKEwEGcd4hPAMAAA==
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
 drivers/video/backlight/lms501kf03.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/video/backlight/lms501kf03.c b/drivers/video/backlight/lms501kf03.c
index b43882a..cf01b9a 100644
--- a/drivers/video/backlight/lms501kf03.c
+++ b/drivers/video/backlight/lms501kf03.c
@@ -387,13 +387,12 @@ static int lms501kf03_remove(struct spi_device *spi)
 	return 0;
 }
 
-#if defined(CONFIG_PM)
-
-static int lms501kf03_suspend(struct spi_device *spi, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+static int lms501kf03_suspend(struct device *dev)
 {
-	struct lms501kf03 *lcd = spi_get_drvdata(spi);
+	struct lms501kf03 *lcd = dev_get_drvdata(dev);
 
-	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
+	dev_dbg(dev, "lcd->power = %d\n", lcd->power);
 
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
@@ -402,19 +401,19 @@ static int lms501kf03_suspend(struct spi_device *spi, pm_message_t mesg)
 	return lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int lms501kf03_resume(struct spi_device *spi)
+static int lms501kf03_resume(struct device *dev)
 {
-	struct lms501kf03 *lcd = spi_get_drvdata(spi);
+	struct lms501kf03 *lcd = dev_get_drvdata(dev);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
 	return lms501kf03_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define lms501kf03_suspend	NULL
-#define lms501kf03_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(lms501kf03_pm_ops, lms501kf03_suspend,
+			lms501kf03_resume);
+
 static void lms501kf03_shutdown(struct spi_device *spi)
 {
 	struct lms501kf03 *lcd = spi_get_drvdata(spi);
@@ -426,12 +425,11 @@ static struct spi_driver lms501kf03_driver = {
 	.driver = {
 		.name	= "lms501kf03",
 		.owner	= THIS_MODULE,
+		.pm	= &lms501kf03_pm_ops,
 	},
 	.probe		= lms501kf03_probe,
 	.remove		= lms501kf03_remove,
 	.shutdown	= lms501kf03_shutdown,
-	.suspend	= lms501kf03_suspend,
-	.resume		= lms501kf03_resume,
 };
 
 module_spi_driver(lms501kf03_driver);
-- 
1.7.2.5


