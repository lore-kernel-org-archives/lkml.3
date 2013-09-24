Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3IXJHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:07:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27146 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3IXJHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:07:46 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-51-524156613e0d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 05/22] backlight: adp8870: use devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:07:44 +0900
Message-id: <004b01ceb905$8805f570$9811e050$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAGs1A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zA93EMMcggxP7eS3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErozr3w8x
	FUzgrTh+tpW9gfEnVxcjJ4eEgInExy8zGSFsMYkL99azdTFycQgJLGOUmLSlgwmuaOl2sCIh
	gUWMEvdbWCGKfjFKzHq5lwUkwSagJvHly2H2LkYODhEBfYm2Fg2QMLNAjsT9J7PYIXptJdZ9
	mA1mcwrYSZxaeoYNxBYW8Je4t/oymM0ioCrx4/kJsL28QPXPrzWwQtiCEj8m32OBmKklsXlb
	EyuELS+xec1bZpC1EgLqEo/+6oKERQSMJHZOO8UGUSIise/FO0aQkyUEzrFLvH66iQlil4DE
	t8mHWCB6ZSU2HWCGeFdS4uCKGywTgJ5DsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UUmesWJ
	ucWleel6yfm5mxghMTlhB+O9A9aHGJOB1k9klhJNzgfGdF5JvKGxmZGFqYmpsZG5pRlpwkri
	vOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGAPyJ5+VY3ojuvHnfZfWJfyJz8Obxbik
	G6dN13QqmcdxsC87NOfV72gVtohJEZcNo5YGup8vv7TogNXcie4HeR3mC1c2Fe5/udmksFRa
	ouuYq4t+8AL3y87r/+esP77br1LjYfDWOd+c37yd5ZX295vIYx7mfVpV9Tl/ODOc9Z/t5QvJ
	r3rOoMRSnJFoqMVcVJwIAADSxmXfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd3EMMcgg88POC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaM698PMRVM4K04fraVvYHxJ1cXIyeHhICJxMel2xkhbDGJC/fW
	s4HYQgKLGCXut7B2MXIB2b8YJWa93MsCkmATUJP48uUwexcjB4eIgL5EW4sGSJhZIEfi/pNZ
	7BC9thLrPswGszkF7CROLT0DNlNYwF/i3urLYDaLgKrEj+cnmEBsXqD659caWCFsQYkfk++x
	QMzUkti8rYkVwpaX2LzmLTPIWgkBdYlHf3VBwiICRhI7p51igygRkdj34h3jBEahWUgmzUIy
	aRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzxz6R2MK5ssDjEKMDBqMTD
	u8PbIUiINbGsuDL3EKMEB7OSCO8NW8cgId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4HJqO8
	knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamBkODtTWbd9Rtmv
	S75VucH8p7P3zTo43Y7xjXpCV/en/awlfHUfPsvVy/I6SXrWJpR0K1q+v3028rDR4W3pDxc4
	Sid8kzrX/KggN6V+3SLnquaS1jPVkyLbA65d8+3fYOKSveRM26VzIZHnrh46/eCYzxeZRkXj
	08Gv6kyTvb+v0P3RoqKz00+JpTgj0VCLuag4EQC68JDvPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/adp8870_bl.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 9eee69f..6370720 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -888,8 +888,9 @@ static int adp8870_probe(struct i2c_client *client,
 	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = props.brightness = ADP8870_MAX_BRIGHTNESS;
-	bl = backlight_device_register(dev_driver_string(&client->dev),
-			&client->dev, data, &adp8870_bl_ops, &props);
+	bl = devm_backlight_device_register(&client->dev,
+				dev_driver_string(&client->dev),
+				&client->dev, data, &adp8870_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&client->dev, "failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -902,7 +903,7 @@ static int adp8870_probe(struct i2c_client *client,
 			&adp8870_bl_attr_group);
 		if (ret) {
 			dev_err(&client->dev, "failed to register sysfs\n");
-			goto out1;
+			return ret;
 		}
 	}
 
@@ -925,8 +926,6 @@ out:
 	if (data->pdata->en_ambl_sens)
 		sysfs_remove_group(&data->bl->dev.kobj,
 			&adp8870_bl_attr_group);
-out1:
-	backlight_device_unregister(bl);
 
 	return ret;
 }
@@ -944,8 +943,6 @@ static int adp8870_remove(struct i2c_client *client)
 		sysfs_remove_group(&data->bl->dev.kobj,
 			&adp8870_bl_attr_group);
 
-	backlight_device_unregister(data->bl);
-
 	return 0;
 }
 
-- 
1.7.10.4


