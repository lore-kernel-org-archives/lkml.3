Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3C1GY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:24:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40718 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab3C1GY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:24:26 -0400
X-AuditID: cbfee68e-b7f946d000001e37-15-5153e219e185
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000201ce2b7c$ac0d1280$04273780$%han@samsung.com>
In-reply-to: <000201ce2b7c$ac0d1280$04273780$%han@samsung.com>
Subject: [PATCH 3/3] backlight: vgg2432a4: convert vgg2432a4_driver to
 dev_pm_ops
Date: Thu, 28 Mar 2013 15:24:24 +0900
Message-id: <000401ce2b7c$e41bcf90$ac536eb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4rfKvKs9cALAZgRNGI8/RGwG6ZcAAAB0Zw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY13JR8GBBl8nMlvMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBlfzt1k
	LzglU3Fk+yO2BsYf4l2MnBwSAiYSa54sZYewxSQu3FvP1sXIxSEksIxR4uCkFcwwRY2NO5kg
	EosYJTb8XwHl/GKUaFp8lQWkik1ATeLLl8NAozg4RAT0JdpaNEDCzAKlElsfvGcBCQsJ2Eqs
	28QDEuYUsJN4vfAqWFhYIFhiXbMzSJhFQFXiwZddYAN5gar3fdvHDGELSvyYfI8FYqKWxPqd
	x5kgbHmJzWveMoOMkRBQl3j0VxckLCJgJLG6aQMrRImIxL4X7xhBDpYQOMcu8fTGdlaIXQIS
	3yYfYoHolZXYdADqW0mJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0ouM9IoT
	c4tL89L1kvNzNzFCIrJvB+PNA9aHGJOB1k9klhJNzgdGdF5JvKGxmZGFqYmpsZG5pRlpwkri
	vGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGK09HKyX3frU8/Peii2/dPdM73PcU+hj
	sfil+Ez1bdrTU5n2GfFP/iy5roTv0uy2NZNbnrJOfbNrwTG7+z+4Gjz1nXoD+XM27KxNV5vB
	YL13+9bWh957grenqr8Xe3im6NnzP8eFmkvLpobOba7Jkc/4lGQt+fAT96Ea2V8etxeoa828
	rlxwS1iJpTgj0VCLuag4EQDKN4VK3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAV2JR8GBBtf7bSzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaML+dusheckqk4sv0RWwPjD/EuRk4OCQETicbGnUwQtpjEhXvr
	2boYuTiEBBYxSmz4v4IJwvnFKNG0+CoLSBWbgJrEly+H2bsYOThEBPQl2lo0QMLMAqUSWx+8
	ZwEJCwnYSqzbxAMS5hSwk3i98CpYWFggWGJdszNImEVAVeLBl11gA3mBqvd928cMYQtK/Jh8
	jwViopbE+p3HmSBseYnNa94yg4yREFCXePRXFyQsImAksbppAytEiYjEvhfvGCcwCs1CMmkW
	kkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgeH8mtYNxZYPFIUYBDkYl
	Ht4KgeBAIdbEsuLK3EOMEhzMSiK8hzqBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTEV5
	JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cB4oHF1/ZO3qxUY
	thr3LcnMKIkyZFmYnTs5N0hM66/7zganhauXT/66ueCN2FrBL7wR8XOT9d7Pqb56LW6Gn1a1
	3HdfDYmfJlt2Ssb3Lc74VX5x31XNsCs+c9juphqrhfWV2gZN/8vifGqF+PTwF0He7QWrj+iK
	1b9bfHiV40yDvqlr3YsuJ/grsRRnJBpqMRcVJwIA5CD+TjsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management. Also, use of
pm_message_t is deprecated. Thus, it is removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ili9320.c   |   24 +++++++++---------------
 drivers/video/backlight/ili9320.h   |    2 +-
 drivers/video/backlight/vgg2432a4.c |   18 ++++++++----------
 3 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index 1235bf9..f5edbbe 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -270,27 +270,21 @@ int ili9320_remove(struct ili9320 *ili)
 }
 EXPORT_SYMBOL_GPL(ili9320_remove);
 
-#ifdef CONFIG_PM
-int ili9320_suspend(struct ili9320 *lcd, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+int ili9320_suspend(struct ili9320 *lcd)
 {
 	int ret;
 
-	dev_dbg(lcd->dev, "%s: event %d\n", __func__, state.event);
+	ret = ili9320_power(lcd, FB_BLANK_POWERDOWN);
 
-	if (state.event == PM_EVENT_SUSPEND) {
-		ret = ili9320_power(lcd, FB_BLANK_POWERDOWN);
-
-		if (lcd->platdata->suspend == ILI9320_SUSPEND_DEEP) {
-			ili9320_write(lcd, ILI9320_POWER1, lcd->power1 |
-				      ILI9320_POWER1_SLP |
-				      ILI9320_POWER1_DSTB);
-			lcd->initialised = 0;
-		}
-
-		return ret;
+	if (lcd->platdata->suspend == ILI9320_SUSPEND_DEEP) {
+		ili9320_write(lcd, ILI9320_POWER1, lcd->power1 |
+			      ILI9320_POWER1_SLP |
+			      ILI9320_POWER1_DSTB);
+		lcd->initialised = 0;
 	}
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(ili9320_suspend);
 
diff --git a/drivers/video/backlight/ili9320.h b/drivers/video/backlight/ili9320.h
index e0db738..42329e7 100644
--- a/drivers/video/backlight/ili9320.h
+++ b/drivers/video/backlight/ili9320.h
@@ -76,5 +76,5 @@ extern void ili9320_shutdown(struct ili9320 *lcd);
 
 /* PM */
 
-extern int ili9320_suspend(struct ili9320 *lcd, pm_message_t state);
+extern int ili9320_suspend(struct ili9320 *lcd);
 extern int ili9320_resume(struct ili9320 *lcd);
diff --git a/drivers/video/backlight/vgg2432a4.c b/drivers/video/backlight/vgg2432a4.c
index 84d582f..d538947 100644
--- a/drivers/video/backlight/vgg2432a4.c
+++ b/drivers/video/backlight/vgg2432a4.c
@@ -205,18 +205,15 @@ static int vgg2432a4_lcd_init(struct ili9320 *lcd,
 	return ret;
 }
 
-#ifdef CONFIG_PM
-static int vgg2432a4_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int vgg2432a4_suspend(struct device *dev)
 {
-	return ili9320_suspend(spi_get_drvdata(spi), state);
+	return ili9320_suspend(dev_get_drvdata(dev));
 }
-static int vgg2432a4_resume(struct spi_device *spi)
+static int vgg2432a4_resume(struct device *dev)
 {
-	return ili9320_resume(spi_get_drvdata(spi));
+	return ili9320_resume(dev_get_drvdata(dev));
 }
-#else
-#define vgg2432a4_suspend	NULL
-#define vgg2432a4_resume	NULL
 #endif
 
 static struct ili9320_client vgg2432a4_client = {
@@ -249,16 +246,17 @@ static void vgg2432a4_shutdown(struct spi_device *spi)
 	ili9320_shutdown(spi_get_drvdata(spi));
 }
 
+static SIMPLE_DEV_PM_OPS(vgg2432a4_pm_ops, vgg2432a4_suspend, vgg2432a4_resume);
+
 static struct spi_driver vgg2432a4_driver = {
 	.driver = {
 		.name		= "VGG2432A4",
 		.owner		= THIS_MODULE,
+		.pm		= &vgg2432a4_pm_ops,
 	},
 	.probe		= vgg2432a4_probe,
 	.remove		= vgg2432a4_remove,
 	.shutdown	= vgg2432a4_shutdown,
-	.suspend	= vgg2432a4_suspend,
-	.resume		= vgg2432a4_resume,
 };
 
 module_spi_driver(vgg2432a4_driver);
-- 
1.7.2.5


