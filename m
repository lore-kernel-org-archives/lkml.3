Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaIDPB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:01:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47058 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIDPBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:01:51 -0400
X-AuditID: cbfee68e-f79536d000000fd1-93-54087edc9b92
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 1/4] mfd: max77693: Initialize haptic register map
Date: Fri, 05 Sep 2014 00:01:28 +0900
Message-id: <1409842891-26549-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1409842891-26549-1-git-send-email-jaewon02.kim@samsung.com>
References: <1409842891-26549-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkSPduHUeIwYW1zBbXvzxntTi86AWj
	xY6GI6wW978eZbS4+ekbq8XlXXPYLE53szqwe+ycdZfd4861PWwe804GevRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGjZ4bzAXThStOzjzC2sD4n7+LkZNDQsBE4tPztywQtpjEhXvr2boY
	uTiEBJYySuxrbmWFKXrSdZcJxBYSmM4o8WO9LkRRG5PEtQUd7CAJNgFtie/rF4M1iAhUSvR3
	v2AFKWIW6GGU+N6+mhkkISzgKtG8+yvYJBYBVYlDtw+DreYV8JB4uaEbaDUH0DYFiTmTbEDC
	nAKeEl0PVrBALPaQWDDlGwvITAmB6ewS+78uhZojIPFt8iEWiF5ZiU0HmCGOlpQ4uOIGywRG
	4QWMDKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxAkP89L9nfTsYbx6wPsQowMGoxMNb8II9
	RIg1say4MvcQoynQhonMUqLJ+cBIyiuJNzQ2M7IwNTE1NjK3NFMS502Q+hksJJCeWJKanZpa
	kFoUX1Sak1p8iJGJg1OqgXGFe+ivM5VHTzosWn0j7dSrvYWutgdu1jy/+Tx6Ma/u/W+uhd85
	D4hrLD6uuWXWK8MXGyfl37RdcKNiqfz51ROTmNL3BfvXcNW7xbU9SuSYJPTz0LyIz/1a2V+e
	ffMtZrf13vDcUHVenu6PGbo3/lnZxHWtLPZeYqQ4zyq8VrlyYaxP5tYbDcJKLMUZiYZazEXF
	iQDW6oLibAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jQd07dRwhBvM3Wlhc//Kc1eLwoheM
	FjsajrBa3P96lNHi5qdvrBaXd81hszjdzerA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM2703GAumC5ccXLmEdYGxv/8
	XYycHBICJhJPuu4yQdhiEhfurWcDsYUEpjNK/Fiv28XIBWS3MUlcW9DBDpJgE9CW+L5+MSuI
	LSJQKdHf/YIVpIhZoIdR4nv7amaQhLCAq0Tz7q9gU1kEVCUO3T7MAmLzCnhIvNzQDbSBA2ib
	gsScSTYgYU4BT4muBytYIBZ7SCyY8o1lAiPvAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5
	mxjBEfRMagfjygaLQ4wCHIxKPLwFL9hDhFgTy4orcw8xSnAwK4nwuudxhAjxpiRWVqUW5ccX
	leakFh9iNAU6aiKzlGhyPjC680riDY1NzIwsjcwNLYyMzZXEeQ+0WgcKCaQnlqRmp6YWpBbB
	9DFxcEo1MO7afbxcRueHI9vSThkeUSsur76jf9aGZc1lkfL1+CTj7vw07/82iw3JMwtT8oy9
	mO4vXyA/b6XBbYmT7/pjzBcdUpwbwWuyqoTpg4nS1pjafbyXeX0XzvkcZZm4PnfPrdalOT67
	WuvCLjl/ZH9W7pjAfzTrkCi//77UVRI3mWfcVLj6elWkmRJLcUaioRZzUXEiAF0WQKi2AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add regmap_haptic initialization to use haptic register map
in haptic device driver.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max77693.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 249c139..fbfed56 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -144,6 +144,12 @@ static const struct regmap_irq_chip max77693_muic_irq_chip = {
 	.num_irqs		= ARRAY_SIZE(max77693_muic_irqs),
 };
 
+static const struct regmap_config max77693_regmap_haptic_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX77693_HAPTIC_REG_END,
+};
+
 static int max77693_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
@@ -193,6 +199,15 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	}
 	i2c_set_clientdata(max77693->haptic, max77693);
 
+	max77693->regmap_haptic = devm_regmap_init_i2c(max77693->haptic,
+					&max77693_regmap_haptic_config);
+	if (IS_ERR(max77693->regmap_haptic)) {
+		ret = PTR_ERR(max77693->regmap_haptic);
+		dev_err(max77693->dev,
+			"failed to initialize haptic register map: %d\n", ret);
+		goto err_regmap;
+	}
+
 	/*
 	 * Initialize register map for MUIC device because use regmap-muic
 	 * instance of MUIC device when irq of max77693 is initialized
@@ -204,7 +219,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 		ret = PTR_ERR(max77693->regmap_muic);
 		dev_err(max77693->dev,
 			"failed to allocate register map: %d\n", ret);
-		goto err_regmap_muic;
+		goto err_regmap;
 	}
 
 	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
@@ -214,7 +229,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 				&max77693->irq_data_led);
 	if (ret) {
 		dev_err(max77693->dev, "failed to add irq chip: %d\n", ret);
-		goto err_regmap_muic;
+		goto err_regmap;
 	}
 
 	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
@@ -265,7 +280,7 @@ err_irq_charger:
 	regmap_del_irq_chip(max77693->irq, max77693->irq_data_topsys);
 err_irq_topsys:
 	regmap_del_irq_chip(max77693->irq, max77693->irq_data_led);
-err_regmap_muic:
+err_regmap:
 	i2c_unregister_device(max77693->haptic);
 err_i2c_haptic:
 	i2c_unregister_device(max77693->muic);
-- 
1.7.9.5

