Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3LAX60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 18:58:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:11057 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3LAX6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 18:58:22 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-36-529bcd1dad46
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
In-reply-to: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
Subject: [PATCH 8/8] backlight: tosa: use devm_lcd_device_register()
Date: Mon, 02 Dec 2013 08:58:21 +0900
Message-id: <000701ceeef1$36e3a260$a4aae720$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7u8NgcVnqPK6OFQjq+Xy+HsAignwAAFTyg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zI13Zs7ODDGZeN7CYs34Nm8XlhZdY
	LS7vmsPmwOxxYsZvFo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKuP8ysqCRo+LMvLnsDYy3
	2boYOTkkBEwkmvveskPYYhIX7q0HinNxCAksY5R48rSXGaaoYe83VojEdEaJt92X2CGcX4wS
	M79tBxvFJqAm8eXLYaAEB4eIgL5EW4sGiMks4CJxdJoISIWQgK3EhkfnmUBsTgE7iQk3/4DZ
	wkAlb9ZtZgGxWQRUJW68g9jLC1T/9eQ7FghbUOLH5HtgNrOAlsT6nceZIGx5ic1r3jKDrJIQ
	UJd49FcXJCwiYCQxf+VTRogSEYl9L94xglwsIbCPXWLe7GXsELsEJL5NPsQC0SsrsekA1LuS
	EgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525ihERf
	3w7GmwesDzEmA62fyCwlmpwPjN68knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cCodTaif1WGPHfe7atTdm93tTPN5fA5yBAQwnLLoXrahbq4hH6Z
	SamHz8lqF4h5zJhWPNf0QPnXq2vZPU5+/t+flSrzWz7tB9//Oat+WEzxe3RpodqM0v17W6+a
	ynJJRpT/jYhj/xBktdX51roTlvmXZTr+NBg/uPiXceaaiXFmmz/N2lca97dRiaU4I9FQi7mo
	OBEAYkCAotQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQV3Zs7ODDG4u1rWYs34Nm8XlhZdY
	LS7vmsPmwOxxYsZvFo++LasYPT5vkgtgjmpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wB2qSkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7H
	yAANJKxjzLj/MrKgkaPizLy57A2Mt9m6GDk5JARMJBr2fmOFsMUkLtxbDxTn4hASmM4o8bb7
	EjuE84tRYua37WAdbAJqEl++HAZKcHCICOhLtLVogJjMAi4SR6eJgFQICdhKbHh0ngnE5hSw
	k5hw8w+YLQxU8mbdZhYQm0VAVeLGu15mEJsXqP7ryXcsELagxI/J98BsZgEtifU7jzNB2PIS
	m9e8ZQZZJSGgLvHory5IWETASGL+yqeMECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsY
	RVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmP7mfQOxlUNFocYBTgYlXh4L5yYHSTEmlhWXJl7
	iFGCg1lJhNfi66wgId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4Hpp28knhDYxMzI0sjMwsj
	E3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDsXt9S5sAw6wWvvlHhBVb1HWJmzFN2
	zn2yKDNiO/PM4qb57tKh3pV+7MW7fj0rNtuh2MaxRGN5zH4dnaikV72PY6MqX+7NnlT4ve21
	Y2/20nuzk6rf71qvKuukNeer4eoj04QqAi6z8r///ufSVU7Pv3YKCgt/h/McM9vwxzrNYc0+
	429Sc74rsRRnJBpqMRcVJwIASl2qLDEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_lcd_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tosa_lcd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
index be5d636..f08d641 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -206,8 +206,8 @@ static int tosa_lcd_probe(struct spi_device *spi)
 
 	tosa_lcd_tg_on(data);
 
-	data->lcd = lcd_device_register("tosa-lcd", &spi->dev, data,
-			&tosa_lcd_ops);
+	data->lcd = devm_lcd_device_register(&spi->dev, "tosa-lcd", &spi->dev,
+					data, &tosa_lcd_ops);
 
 	if (IS_ERR(data->lcd)) {
 		ret = PTR_ERR(data->lcd);
@@ -226,8 +226,6 @@ static int tosa_lcd_remove(struct spi_device *spi)
 {
 	struct tosa_lcd_data *data = spi_get_drvdata(spi);
 
-	lcd_device_unregister(data->lcd);
-
 	if (data->i2c)
 		i2c_unregister_device(data->i2c);
 
-- 
1.7.10.4


