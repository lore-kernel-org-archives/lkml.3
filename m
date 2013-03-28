Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab3C1GXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:23:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40577 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab3C1GXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:23:38 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-b7-5153e1e836c7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000201ce2b7c$ac0d1280$04273780$%han@samsung.com>
In-reply-to: <000201ce2b7c$ac0d1280$04273780$%han@samsung.com>
Subject: [PATCH 2/3] backlight: tosa: convert tosa to dev_pm_ops
Date: Thu, 28 Mar 2013 15:23:36 +0900
Message-id: <000301ce2b7c$c7773320$56659960$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4rfKvKs9cALAZgRNGI8/RGwG6ZcAAAAQIQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zI90XD4MDDQ5N1LaYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDJW7/vA
	UjBJqmLN3V2sDYxnRLsYOTgkBEwkjq7X6mLkBDLFJC7cW8/WxcjFISSwjFFi3Z07LBAJE4mb
	T3sYIRLTGSVm39nKAuH8YpT40D6XEaSKTUBN4suXw+wgU0UE9CXaWjRAwswCpRJbH7xnAQkL
	CdhKrNvEAxLmFLCTeL3wKth8YQEHiReHuphBbBYBVYnHx/+CxXmByjv3tjJD2IISPybfY4EY
	qSWxfudxJghbXmLzmrfMEL+oSzz6qwtxgJHEvEk8EBUiEvtevAO7XkLgFLvEuiUrWCBWCUh8
	m3yIBaJVVmLTAWaIbyUlDq64wTKBUWIWksWzkCyehWTxLCQrFjCyrGIUTS1ILihOSi8y1itO
	zC0uzUvXS87P3cQIicf+HYx3D1gfYkwGWj+RWUo0OR8Yz3kl8YbGZkYWpiamxkbmlmakCSuJ
	86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYGzbG+PJsd34cPGJhNkrTTKNdjRuKnbe
	utBJTqtCKdoi62OT9NayL82aHcXn+7OVNIPur2bQXnvlQOq3KicGZtb3zGEJRVsNZi81dns8
	P8mmau2uD+cazM693h2+Tcq/ecM3txVFnn82l/3uO/p379vDkVafRB7NrDmmYiH3ut3g4eLi
	D3OdkpRYijMSDbWYi4oTAfv5e3LdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd0XD4MDDb79ULOYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzVu/7wFIwSapizd1drA2MZ0S7GDk5JARMJG4+7WGEsMUkLtxb
	z9bFyMUhJDCdUWL2na0sEM4vRokP7XPBqtgE1CS+fDnM3sXIwSEioC/R1qIBEmYWKJXY+uA9
	C0hYSMBWYt0mHpAwp4CdxOuFV1lAbGEBB4kXh7qYQWwWAVWJx8f/gsV5gco797YyQ9iCEj8m
	32OBGKklsX7ncSYIW15i85q3zCDjJQTUJR791YU4wEhi3iQeiAoRiX0v3jFOYBSahWTQLCSD
	ZiEZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwfH+TGoH48oGi0OMAhyMSjy8
	FQLBgUKsiWXFlbmHGCU4mJVEeA91AoV4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5iK8kri
	DY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcU/CVFHB9Osu0R/f
	hesG8FcK71zj6qi14/Gf3KBoY9uOmU7/Q1nquldyp+87PnWXthHj2fK+S2lnr8w7N8/BkCNG
	LfQy88ZZ7IYNs0V+T6wUOpoa99lTUaj6+D75MzVHuaOLOSdzF8zk0r7qkXGx7VzFq2dnnyj+
	Yp5z6qBZxG8r9q6uWTsVlFiKMxINtZiLihMBoHlv6TsDAAA=
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


