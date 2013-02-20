Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228Ab3BTGLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:11:43 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17152 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529Ab3BTGLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:11:41 -0500
X-AuditID: cbfee690-b7f066d00000169f-e7-5124691ad7ff
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
In-reply-to: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
Subject: [PATCH 05/11] mfd: twl6040: use devm_gpio_request_one() and
 devm_request_threaded_irq()
Date: Wed, 20 Feb 2013 15:11:38 +0900
Message-id: <002a01ce0f31$24e5fef0$6eb1fcd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PMNZl2zNDd+kPTaydPUTuUPUSLQAAEG4A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zI12pTJVAg+XrrS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGqjXrmQs6xCsuPX7J3MD4VaiLkZNDQsBEYv/aHmYIW0ziwr31
	bF2MXBxCAssYJdpX7GOBKdrwbhkrRGIRo8SaW0uYIJzZTBJb7v5iAqliE1CT+PLlMDuILSKg
	JdF97DzQKA4OZgEXiaPTREDCQgK2Et/X/mMFsTkF7CR2PTrPClIiLJAk8a9HHyTMIqAqcejJ
	KXaQMC9QeduzOpAwr4CgxI/J98DOYQYavn7ncSYIW15i85q3zCDlEgLqEo/+6kLsN5L4ff8q
	VImIxL4X7xhBDpYQWMQu8fdoDxPEKgGJb5MPsUD0ykpsOgANBkmJgytusExglJiFZPMsJJtn
	Idk8C8mKBYwsqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzFComrCDsZ7B6wPMSYDrZ/ILCWa
	nA+MyrySeENjYxMzE1MTc0tTc1PShJXEeeUvyQQKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YHQI2qd0xPuH4JdKr4uquXdPJKqzlgXx8hy23VezaPl91xjxMrs9EQI6z+uP/9VYdTzW+FBa
	kUGrx0Lr+27Otptjf7/OnbZCa/+0k8eEZ00L09vWbzebv0NixfeUO21Cr+9q+1+end7cuF1L
	+uSLIu6zEwsKbq3ekb/y365DEr9/623PWqRaclCJpTgj0VCLuag4EQDtaDRVwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgK5UpkqgwfFOM4vLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsWrNeuaCDvGKS49fMjcw
	fhXqYuTkkBAwkdjwbhkrhC0mceHeerYuRi4OIYFFjBJrbi1hgnBmM0lsufuLCaSKTUBN4suX
	w+wgtoiAlkT3sfNAHRwczAIuEkeniYCEhQRsJb6v/Qc2lFPATmLXo/OsICXCAkkS/3r0QcIs
	AqoSh56cYgcJ8wKVtz2rAwnzCghK/Jh8jwXEZgYavn7ncSYIW15i85q3zCDlEgLqEo/+6kLs
	N5L4ff8qVImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0
	veT83E2M4Jh9JrWDcWWDxSFGAQ5GJR5ejfnKgUKsiWXFlbmHGCU4mJVEeJudVAKFeFMSK6tS
	i/Lji0pzUosPMSYD/TmRWUo0OR+YTvJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1
	OzW1ILUIZgsTB6dUA6PsDyGTuI5gz0eqpWc/LmWTbE9nOCbFH7vry87HIluty+rP8O+t1n7H
	rGyzPq/095z5RXtELv2wDVVrdt2THcu9SPT/gw2FaQVWZ8QclbUD9RNO8+WtzRLXrNc1CNRS
	+/cwp76dzb8nl+Otsq1YRVHCnLB3q158KL+p55PieGV10Ca2JS4qSizFGYmGWsxFxYkA0pDW
	sB0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_gpio_request_one() and devm_request_threaded_irq() to make
cleanup paths and  more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/twl6040.c |   26 +++++++-------------------
 1 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index f361bf3..2d38512 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -586,8 +586,8 @@ static int twl6040_probe(struct i2c_client *client,
 		twl6040->audpwron = -EINVAL;
 
 	if (gpio_is_valid(twl6040->audpwron)) {
-		ret = gpio_request_one(twl6040->audpwron, GPIOF_OUT_INIT_LOW,
-				       "audpwron");
+		ret = devm_gpio_request_one(twl6040->dev, twl6040->audpwron,
+					GPIOF_OUT_INIT_LOW, "audpwron");
 		if (ret)
 			goto gpio_err;
 	}
@@ -596,14 +596,14 @@ static int twl6040_probe(struct i2c_client *client,
 			IRQF_ONESHOT, 0, &twl6040_irq_chip,
 			&twl6040->irq_data);
 	if (ret < 0)
-		goto irq_init_err;
+		goto gpio_err;
 
 	twl6040->irq_ready = regmap_irq_get_virq(twl6040->irq_data,
 					       TWL6040_IRQ_READY);
 	twl6040->irq_th = regmap_irq_get_virq(twl6040->irq_data,
 					       TWL6040_IRQ_TH);
 
-	ret = request_threaded_irq(twl6040->irq_ready, NULL,
+	ret = devm_request_threaded_irq(twl6040->dev, twl6040->irq_ready, NULL,
 				   twl6040_readyint_handler, IRQF_ONESHOT,
 				   "twl6040_irq_ready", twl6040);
 	if (ret) {
@@ -611,12 +611,12 @@ static int twl6040_probe(struct i2c_client *client,
 		goto readyirq_err;
 	}
 
-	ret = request_threaded_irq(twl6040->irq_th, NULL,
+	ret = devm_request_threaded_irq(twl6040->dev, twl6040->irq_th, NULL,
 				   twl6040_thint_handler, IRQF_ONESHOT,
 				   "twl6040_irq_th", twl6040);
 	if (ret) {
 		dev_err(twl6040->dev, "Thermal IRQ request failed: %d\n", ret);
-		goto thirq_err;
+		goto readyirq_err;
 	}
 
 	/* dual-access registers controlled by I2C only */
@@ -676,19 +676,12 @@ static int twl6040_probe(struct i2c_client *client,
 	ret = mfd_add_devices(&client->dev, -1, twl6040->cells, children,
 			      NULL, 0, NULL);
 	if (ret)
-		goto mfd_err;
+		goto readyirq_err;
 
 	return 0;
 
-mfd_err:
-	free_irq(twl6040->irq_th, twl6040);
-thirq_err:
-	free_irq(twl6040->irq_ready, twl6040);
 readyirq_err:
 	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
-irq_init_err:
-	if (gpio_is_valid(twl6040->audpwron))
-		gpio_free(twl6040->audpwron);
 gpio_err:
 	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
 power_err:
@@ -706,11 +699,6 @@ static int twl6040_remove(struct i2c_client *client)
 	if (twl6040->power_count)
 		twl6040_power(twl6040, 0);
 
-	if (gpio_is_valid(twl6040->audpwron))
-		gpio_free(twl6040->audpwron);
-
-	free_irq(twl6040->irq_ready, twl6040);
-	free_irq(twl6040->irq_th, twl6040);
 	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
 
 	mfd_remove_devices(&client->dev);
-- 
1.7.2.5


