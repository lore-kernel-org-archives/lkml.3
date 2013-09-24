Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3IXJai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:30:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24782 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab3IXJaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:30:35 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-0c-52415bac012e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007501ceb908$78df7370$6a9e5a50$%han@samsung.com>
In-reply-to: <007501ceb908$78df7370$6a9e5a50$%han@samsung.com>
Subject: [PATCH 3/5] backlight: corgi_lcd: use
 devm_{backlight,lcd}_device_register()
Date: Tue, 24 Sep 2013 18:30:20 +0900
Message-id: <007701ceb908$b03c93c0$10b5bb40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65CHjKuB0v+SsdTFGS6PUVVZI9RwAAB1dA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zA9210Y5BBvPTLeasX8NmcXnhJVaL
	y7vmsFns3vWU1YHF48SM3ywee+b/YPXo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujMf3jrEX
	LBCuuNr+mbmBcb5AFyMnh4SAicTNphfMELaYxIV769m6GLk4hASWMUq8/jibBaZo/szdTBCJ
	6YwSlx4eYQdJCAn8YpRY9MsGxGYTUJP48uUwUJyDQ0RAX6KtRQMkzCyQI3H/ySyocluJl5cf
	gy3jFLCTWLbvIpgtLBAusfT2P7AaFgFViUd3GphAbF6g+s/dr6FsQYkfk++xQMzUkti8rYkV
	wpaX2LzmLTPIWgkBdYlHf3UhLjCSeDrRE6JCRGLfi3eMINdLCJxil3j++wcrxCoBiW+TD7FA
	tMpKbDoADQZJiYMrbrBMYJSYhWTxLCSLZyFZPAvJigWMLKsYRVMLkguKk9KLjPWKE3OLS/PS
	9ZLzczcxQuKxfwfj3QPWhxiTgdZPZJYSTc4HxnNeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaB
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhjXfzzdtZ2p/nVfvG7etPm3tx24rlp1ei+HiLrm
	yl9FR9sWHDY6zfO1d3rrpwkec9bsONS3p97/nvfP+5JMhxauPTlzuseji9q3Q4Rz3y5f/OV0
	5t7WDx+OFnEonjv5n1WWp9zfdqbLdleWJ/oF21ZqXNgXtXRKukuOsY9UUbXY/peRm80DplVr
	KrEUZyQaajEXFScCAAUz53fdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd010Y5BBguarCzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMx/eOsRcsEK642v6ZuYFxvkAXIyeHhICJxPyZu5kgbDGJC/fW
	s3UxcnEICUxnlLj08Ag7SEJI4BejxKJfNiA2m4CaxJcvh4HiHBwiAvoSbS0aIGFmgRyJ+09m
	QZXbSry8/JgZxOYUsJNYtu8imC0sEC6x9PY/sBoWAVWJR3cawPbyAtV/7n4NZQtK/Jh8jwVi
	ppbE5m1NrBC2vMTmNW+ZQdZKCKhLPPqrC3GBkcTTiZ4QFSIS+168Y5zAKDQLyaBZSAbNQjJo
	FpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC4/2Z1A7GlQ0WhxgFOBiVeHh3eDsE
	CbEmlhVX5h5ilOBgVhLhvWHrGCTEm5JYWZValB9fVJqTWnyIMRnoz4nMUqLJ+cBUlFcSb2hs
	YmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjIYCMppWT6a9NbhgF9gQ
	f+yNxtW5qj9Xu/xXna72R6xbz/ftlMPnt4pk2/S7tFje62JS2/1opp/Ljw9sOzaemrP34btt
	ndVqhxzjw5ZK12+bLcya76H6Ynv9b+MmtkfWF1/oNSlkP2g9ZxO02yFD9PPX21tj3vKtWfZt
	ffaSmkel2jVLvryvMFJiKc5INNRiLipOBACdTFxfOwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() and devm_lcd_device_register()
to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/corgi_lcd.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index be56cfe..db8db5f 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -550,8 +550,8 @@ static int corgi_lcd_probe(struct spi_device *spi)
 
 	lcd->spi_dev = spi;
 
-	lcd->lcd_dev = lcd_device_register("corgi_lcd", &spi->dev,
-					lcd, &corgi_lcd_ops);
+	lcd->lcd_dev = devm_lcd_device_register(&spi->dev, "corgi_lcd",
+						&spi->dev, lcd, &corgi_lcd_ops);
 	if (IS_ERR(lcd->lcd_dev))
 		return PTR_ERR(lcd->lcd_dev);
 
@@ -561,18 +561,18 @@ static int corgi_lcd_probe(struct spi_device *spi)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = pdata->max_intensity;
-	lcd->bl_dev = backlight_device_register("corgi_bl", &spi->dev, lcd,
-						&corgi_bl_ops, &props);
-	if (IS_ERR(lcd->bl_dev)) {
-		ret = PTR_ERR(lcd->bl_dev);
-		goto err_unregister_lcd;
-	}
+	lcd->bl_dev = devm_backlight_device_register(&spi->dev, "corgi_bl",
+						&spi->dev, lcd, &corgi_bl_ops,
+						&props);
+	if (IS_ERR(lcd->bl_dev))
+		return PTR_ERR(lcd->bl_dev);
+
 	lcd->bl_dev->props.brightness = pdata->default_intensity;
 	lcd->bl_dev->props.power = FB_BLANK_UNBLANK;
 
 	ret = setup_gpio_backlight(lcd, pdata);
 	if (ret)
-		goto err_unregister_bl;
+		return ret;
 
 	lcd->kick_battery = pdata->kick_battery;
 
@@ -583,12 +583,6 @@ static int corgi_lcd_probe(struct spi_device *spi)
 	lcd->limit_mask = pdata->limit_mask;
 	the_corgi_lcd = lcd;
 	return 0;
-
-err_unregister_bl:
-	backlight_device_unregister(lcd->bl_dev);
-err_unregister_lcd:
-	lcd_device_unregister(lcd->lcd_dev);
-	return ret;
 }
 
 static int corgi_lcd_remove(struct spi_device *spi)
@@ -598,11 +592,7 @@ static int corgi_lcd_remove(struct spi_device *spi)
 	lcd->bl_dev->props.power = FB_BLANK_UNBLANK;
 	lcd->bl_dev->props.brightness = 0;
 	backlight_update_status(lcd->bl_dev);
-	backlight_device_unregister(lcd->bl_dev);
-
 	corgi_lcd_set_power(lcd->lcd_dev, FB_BLANK_POWERDOWN);
-	lcd_device_unregister(lcd->lcd_dev);
-
 	return 0;
 }
 
-- 
1.7.10.4


