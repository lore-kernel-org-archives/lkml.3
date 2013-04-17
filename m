Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3DQBEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:04:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13325 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab3DQBEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:04:32 -0400
X-AuditID: cbfee68d-b7f786d000005188-2f-516df51e6f68
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002d01ce3b07$4d838d80$e88aa880$%han@samsung.com>
In-reply-to: <002d01ce3b07$4d838d80$e88aa880$%han@samsung.com>
Subject: [PATCH RESEND 2/3] backlight: tosa: convert tosa to dev_pm_ops
Date: Wed, 17 Apr 2013 10:04:30 +0900
Message-id: <002e01ce3b07$83e11820$8ba34860$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac47B00Xwwr4eF6YRha9Jkf5kKWYlAAACnwg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zQ125r7mBBi3zTS3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErozV+z6w
	FEySqlhzdxdrA+MZ0S5GTg4JAROJW/uvMELYYhIX7q1n62Lk4hASWMYoMXH9QkaYovMXXzFD
	JBYxSlybt54RwvnFKLHz4HY2kCo2ATWJL18Os3cxcnCICOhLtLVogISZBUoltj54zwJiCwnY
	Sjw9/o4ZxOYUsJPY/us2mC0s4C7xbelssDEsAqoSfyacBVvMC1S//XALO4QtKPFj8j0WiJla
	Eut3HmeCsOUlNq95ywyyVkJAXeLRX12QsIiAkcSK5dOhykUk9r14B3ayhMA5dok3M6YxQuwS
	kPg2+RALRK+sxKYDzBD/SkocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSo
	V5yYW1yal66XnJ+7iRESlb07GG8fsD7EmAy0fiKzlGhyPjCq80riDY3NjCxMTUyNjcwtzUgT
	VhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAmLigyjLu6EUT/QJf2UU3N5SzbjYy
	jDzDHL+I3yh2s/L0C1XXPXwW5Frze5o1TXtmWV3N2v7OyPzjxf3nhCr/S/g17Pd6XfhlxYFP
	rAetKpsO70uy8F5i9eOS+KddnxQuVbrtSZQ++of1d5tx7fG6P1cVJ2jwp0irf+PKid/IZXY7
	4/UkrRluSizFGYmGWsxFxYkAxpolp+ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAV25r7mBBm96DC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaM1fs+sBRMkqpYc3cXawPjGdEuRk4OCQETifMXXzFD2GISF+6t
	Z+ti5OIQEljEKHFt3npGCOcXo8TOg9vZQKrYBNQkvnw5zN7FyMEhIqAv0daiARJmFiiV2Prg
	PQuILSRgK/H0+DuwoZwCdhLbf90Gs4UF3CW+LZ0NNoZFQFXiz4SzjCA2L1D99sMt7BC2oMSP
	yfdYIGZqSazfeZwJwpaX2LzmLTPIWgkBdYlHf3VBwiICRhIrlk+HKheR2PfiHeMERqFZSCbN
	QjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHPPPpHcwrmqwOMQowMGo
	xMN7oSA3UIg1say4MvcQowQHs5IIr+IqoBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnA9NR
	Xkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUweoauD1nxw9fQ
	u3CuKPeM7JgivaWqhQtWzb1hmcd39sXt+SH5p6oZOQ/tsikvLtPyPyh5acmep61pTQ/eubpZ
	dzC+vpR/+6b41itnFJfyH6v/zjTl49TrV4TtZbk1Jf78jmnmVWOcb+uZK1UkMv/Vw2MnPgYb
	f34/4073xGuJG7N+Vlc/nxYor8RSnJFoqMVcVJwIANRllOA9AwAA
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
 drivers/video/backlight/tosa_bl.c  |   18 ++++++++----------
 drivers/video/backlight/tosa_lcd.c |   18 ++++++++----------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index 2326fa8..9df66ac 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -134,28 +134,27 @@ static int tosa_bl_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int tosa_bl_suspend(struct i2c_client *client, pm_message_t pm)
+#ifdef CONFIG_PM_SLEEP
+static int tosa_bl_suspend(struct device *dev)
 {
-	struct tosa_bl_data *data = i2c_get_clientdata(client);
+	struct tosa_bl_data *data = dev_get_drvdata(dev);
 
 	tosa_bl_set_backlight(data, 0);
 
 	return 0;
 }
 
-static int tosa_bl_resume(struct i2c_client *client)
+static int tosa_bl_resume(struct device *dev)
 {
-	struct tosa_bl_data *data = i2c_get_clientdata(client);
+	struct tosa_bl_data *data = dev_get_drvdata(dev);
 
 	backlight_update_status(data->bl);
 	return 0;
 }
-#else
-#define tosa_bl_suspend NULL
-#define tosa_bl_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(tosa_bl_pm_ops, tosa_bl_suspend, tosa_bl_resume);
+
 static const struct i2c_device_id tosa_bl_id[] = {
 	{ "tosa-bl", 0 },
 	{ },
@@ -165,11 +164,10 @@ static struct i2c_driver tosa_bl_driver = {
 	.driver = {
 		.name		= "tosa-bl",
 		.owner		= THIS_MODULE,
+		.pm		= &tosa_bl_pm_ops,
 	},
 	.probe		= tosa_bl_probe,
 	.remove		= tosa_bl_remove,
-	.suspend	= tosa_bl_suspend,
-	.resume		= tosa_bl_resume,
 	.id_table	= tosa_bl_id,
 };
 
diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
index 666fe25..bf08157 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -240,19 +240,19 @@ static int tosa_lcd_remove(struct spi_device *spi)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int tosa_lcd_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int tosa_lcd_suspend(struct device *dev)
 {
-	struct tosa_lcd_data *data = spi_get_drvdata(spi);
+	struct tosa_lcd_data *data = dev_get_drvdata(dev);
 
 	tosa_lcd_tg_off(data);
 
 	return 0;
 }
 
-static int tosa_lcd_resume(struct spi_device *spi)
+static int tosa_lcd_resume(struct device *dev)
 {
-	struct tosa_lcd_data *data = spi_get_drvdata(spi);
+	struct tosa_lcd_data *data = dev_get_drvdata(dev);
 
 	tosa_lcd_tg_init(data);
 	if (POWER_IS_ON(data->lcd_power))
@@ -262,20 +262,18 @@ static int tosa_lcd_resume(struct spi_device *spi)
 
 	return 0;
 }
-#else
-#define tosa_lcd_suspend	NULL
-#define tosa_lcd_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(tosa_lcd_pm_ops, tosa_lcd_suspend, tosa_lcd_resume);
+
 static struct spi_driver tosa_lcd_driver = {
 	.driver = {
 		.name		= "tosa-lcd",
 		.owner		= THIS_MODULE,
+		.pm		= &tosa_lcd_pm_ops,
 	},
 	.probe		= tosa_lcd_probe,
 	.remove		= tosa_lcd_remove,
-	.suspend	= tosa_lcd_suspend,
-	.resume		= tosa_lcd_resume,
 };
 
 module_spi_driver(tosa_lcd_driver);
-- 
1.7.2.5


