Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab3CLFvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:51:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34661 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3CLFvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:51:19 -0400
X-AuditID: cbfee690-b7f656d0000007e3-e8-513ec25698d1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 07/14] backlight: corgi_lcd: convert corgi_lcd to dev_pm_ops
Date: Tue, 12 Mar 2013 14:51:18 +0900
Message-id: <004401ce1ee5$9da8ea00$d8fabe00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAAEmEw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zfd2wQ3aBBtcPS1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mls6ZbAXbBCo69x5hb2B8wNvFyMkhIWAiMXP2dhYIW0ziwr31
	bF2MXBxCAssYJSZs2cEOU3T5xwZGiMQiRonuZ/fYIZzZTBIPm96yglSxCahJfPlyGCjBwSEi
	oC/R1qIBEmYWKJXY+uA92AYhAVuJu+ufM4KUcArYSWz5mwUSFhbwkbiz8iUTiM0ioCrx8doL
	sL28QOVPWppYIGxBiR+T77FAjNSSWL/zOBOELS+xec1bZpCREgLqEo/+6oKERQSMJDZv2scK
	USIise/FO0aIV5axS3xbHw6xSkDi2+RDLBCtshKbDjBDlEhKHFxxg2UCo8QsJItnIVk8C8ni
	WUg2LGBkWcUomlqQXFCclF5kolecmFtcmpeul5yfu4kRElUTdjDeO2B9iDEZaP1EZinR5Hxg
	VOaVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTFq
	HuOOjW9P9gmc9mCbfnZOStiK1zHM3Pn5WkXPHN/n/op8+niDDFvInp3tK9cKdt3xZzW5l22t
	EWDCItFr7lW7SertNueMvacn1QlxiX+bwqtYoJdf3/1e6bXCTxNh72DVjW4/l5XteLBVNEh+
	0/yDKqbvlyhey/kgUySUlbNy4+/s13X9AUosxRmJhlrMRcWJALt5KLfAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG7YIbtAg3XHRS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRkvnTLaCbQIVnXuPsDcw
	PuDtYuTkkBAwkbj8YwMjhC0mceHeerYuRi4OIYFFjBLdz+6xQzizmSQeNr1lBaliE1CT+PLl
	MFCCg0NEQF+irUUDJMwsUCqx9cF7FhBbSMBW4u7654wgJZwCdhJb/maBhIUFfCTurHzJBGKz
	CKhKfLz2gh3E5gUqf9LSxAJhC0r8mHyPBWKklsT6nceZIGx5ic1r3jKDjJQQUJd49FcXJCwi
	YCSxedM+VogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGMFR+0x6B+OqBotDjAIcjEo8vArfbAOFWBPLiitzDzFKcDArifBmbLYLFOJNSays
	Si3Kjy8qzUktPsSYDPToRGYp0eR8YELJK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJ
	anZqakFqEcwWJg5OqQbGOf+U+A9bbBGovpsb3/3X0j9pS7hojNvzKM9Dn0T+e344FHJzBU/e
	6zrfHdNSm/4In1/z7Hxe6b1dDT4MH25/3jFJw1N1aeFFY8dO6b72hSWKFumxxlxVr58kXU5n
	+XL+8VnzB+2tN5uLJ3fmPHfJkn314MBjxdg9gV++/vV8bCZ7qf4SS8l/JZbijERDLeai4kQA
	/HA1tx4DAAA=
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
 drivers/video/backlight/corgi_lcd.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index aa782f3..c97867a 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -457,10 +457,10 @@ static const struct backlight_ops corgi_bl_ops = {
 	.update_status  = corgi_bl_update_status,
 };
 
-#ifdef CONFIG_PM
-static int corgi_lcd_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int corgi_lcd_suspend(struct device *dev)
 {
-	struct corgi_lcd *lcd = spi_get_drvdata(spi);
+	struct corgi_lcd *lcd = dev_get_drvdata(dev);
 
 	corgibl_flags |= CORGIBL_SUSPENDED;
 	corgi_bl_set_intensity(lcd, 0);
@@ -468,20 +468,19 @@ static int corgi_lcd_suspend(struct spi_device *spi, pm_message_t state)
 	return 0;
 }
 
-static int corgi_lcd_resume(struct spi_device *spi)
+static int corgi_lcd_resume(struct device *dev)
 {
-	struct corgi_lcd *lcd = spi_get_drvdata(spi);
+	struct corgi_lcd *lcd = dev_get_drvdata(dev);
 
 	corgibl_flags &= ~CORGIBL_SUSPENDED;
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_UNBLANK);
 	backlight_update_status(lcd->bl_dev);
 	return 0;
 }
-#else
-#define corgi_lcd_suspend	NULL
-#define corgi_lcd_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(corgi_lcd_pm_ops, corgi_lcd_suspend, corgi_lcd_resume);
+
 static int setup_gpio_backlight(struct corgi_lcd *lcd,
 				struct corgi_lcd_platform_data *pdata)
 {
@@ -611,11 +610,10 @@ static struct spi_driver corgi_lcd_driver = {
 	.driver		= {
 		.name	= "corgi-lcd",
 		.owner	= THIS_MODULE,
+		.pm	= &corgi_lcd_pm_ops,
 	},
 	.probe		= corgi_lcd_probe,
 	.remove		= corgi_lcd_remove,
-	.suspend	= corgi_lcd_suspend,
-	.resume		= corgi_lcd_resume,
 };
 
 module_spi_driver(corgi_lcd_driver);
-- 
1.7.2.5


