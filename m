Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbaGBPbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:31:37 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38334 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbaGBP3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:29:39 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/12] mfd: 88pm860x-core: Repair formatting issues
Date: Wed,  2 Jul 2014 16:28:40 +0100
Message-Id: <1404314924-23564-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch warnings:

    WARNING: please, no space before tabs
    #5: FILE: drivers/mfd/88pm860x-core.c:5:
    + * ^IHaojian Zhuang <haojian.zhuang@marvell.com>$

    WARNING: line over 80 characters
    #143: FILE: drivers/mfd/88pm860x-core.c:143:
    +	{PM8607_IRQ_AUDIO_SHORT, PM8607_IRQ_AUDIO_SHORT, "audio-short", IORESOURCE_IRQ,},

    WARNING: line over 80 characters
    #153: FILE: drivers/mfd/88pm860x-core.c:153:
    +	{PM8607_IRQ_CHG_DONE,  PM8607_IRQ_CHG_DONE,  "charging done",       IORESOURCE_IRQ,},

    WARNING: line over 80 characters
    #154: FILE: drivers/mfd/88pm860x-core.c:154:
    +	{PM8607_IRQ_CHG_FAIL,  PM8607_IRQ_CHG_FAIL,  "charging timeout",    IORESOURCE_IRQ,},

    WARNING: line over 80 characters
    #155: FILE: drivers/mfd/88pm860x-core.c:155:
    +	{PM8607_IRQ_CHG_FAULT, PM8607_IRQ_CHG_FAULT, "charging fault",	    IORESOURCE_IRQ,},

    WARNING: line over 80 characters
    #156: FILE: drivers/mfd/88pm860x-core.c:156:
    +	{PM8607_IRQ_GPADC1,    PM8607_IRQ_GPADC1,    "battery temperature", IORESOURCE_IRQ,},

    WARNING: Avoid unnecessary line continuations
    #571: FILE: drivers/mfd/88pm860x-core.c:571:
    +	struct i2c_client *i2c = (chip->id == CHIP_PM8607) ? chip->client \

    WARNING: line over 80 characters
    #634: FILE: drivers/mfd/88pm860x-core.c:634:
    +	ret = request_threaded_irq(chip->core_irq, NULL, pm860x_irq, flags | IRQF_ONESHOT,

    WARNING: Unnecessary parentheses - maybe == should be = ?
    #874: FILE: drivers/mfd/88pm860x-core.c:874:
    +	if ((pdata == NULL))

    WARNING: quoted string split across lines
    #1001: FILE: drivers/mfd/88pm860x-core.c:1001:
    +		dev_err(chip->dev, "Failed to detect Marvell 88PM8607. "
    +			"Chip ID: %02x\n", ret);

    WARNING: quoted string split across lines
    #1124: FILE: drivers/mfd/88pm860x-core.c:1124:
    +		dev_err(dev, "Not found \"marvell,88pm860x-slave-addr\" "
    +			"property\n");

total: 0 errors, 11 warnings, 1281 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/88pm860x-core.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index bcfc9e8..3a26045 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -2,7 +2,8 @@
  * Base driver for Marvell 88PM8607
  *
  * Copyright (C) 2009 Marvell International Ltd.
- * 	Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ * Author: Haojian Zhuang <haojian.zhuang@marvell.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -140,7 +141,8 @@ static struct resource codec_resources[] = {
 	/* Headset insertion or removal */
 	{PM8607_IRQ_HEADSET, PM8607_IRQ_HEADSET, "headset", IORESOURCE_IRQ,},
 	/* Audio short */
-	{PM8607_IRQ_AUDIO_SHORT, PM8607_IRQ_AUDIO_SHORT, "audio-short", IORESOURCE_IRQ,},
+	{PM8607_IRQ_AUDIO_SHORT, PM8607_IRQ_AUDIO_SHORT, "audio-short",
+	 IORESOURCE_IRQ,},
 };
 
 static struct resource battery_resources[] = {
@@ -150,10 +152,14 @@ static struct resource battery_resources[] = {
 
 static struct resource charger_resources[] = {
 	{PM8607_IRQ_CHG,  PM8607_IRQ_CHG,  "charger detect",  IORESOURCE_IRQ,},
-	{PM8607_IRQ_CHG_DONE,  PM8607_IRQ_CHG_DONE,  "charging done",       IORESOURCE_IRQ,},
-	{PM8607_IRQ_CHG_FAIL,  PM8607_IRQ_CHG_FAIL,  "charging timeout",    IORESOURCE_IRQ,},
-	{PM8607_IRQ_CHG_FAULT, PM8607_IRQ_CHG_FAULT, "charging fault",	    IORESOURCE_IRQ,},
-	{PM8607_IRQ_GPADC1,    PM8607_IRQ_GPADC1,    "battery temperature", IORESOURCE_IRQ,},
+	{PM8607_IRQ_CHG_DONE,  PM8607_IRQ_CHG_DONE,  "charging done",
+	 IORESOURCE_IRQ,},
+	{PM8607_IRQ_CHG_FAIL,  PM8607_IRQ_CHG_FAIL,  "charging timeout",
+	 IORESOURCE_IRQ,},
+	{PM8607_IRQ_CHG_FAULT, PM8607_IRQ_CHG_FAULT, "charging fault",
+	 IORESOURCE_IRQ,},
+	{PM8607_IRQ_GPADC1,    PM8607_IRQ_GPADC1,    "battery temperature",
+	 IORESOURCE_IRQ,},
 	{PM8607_IRQ_VBAT, PM8607_IRQ_VBAT, "battery voltage", IORESOURCE_IRQ,},
 	{PM8607_IRQ_VCHG, PM8607_IRQ_VCHG, "vchg voltage",    IORESOURCE_IRQ,},
 };
@@ -568,8 +574,8 @@ static struct irq_domain_ops pm860x_irq_domain_ops = {
 static int device_irq_init(struct pm860x_chip *chip,
 				     struct pm860x_platform_data *pdata)
 {
-	struct i2c_client *i2c = (chip->id == CHIP_PM8607) ? chip->client \
-				: chip->companion;
+	struct i2c_client *i2c = (chip->id == CHIP_PM8607) ?
+		chip->client : chip->companion;
 	unsigned char status_buf[INT_STATUS_NUM];
 	unsigned long flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
 	int data, mask, ret = -EINVAL;
@@ -631,8 +637,8 @@ static int device_irq_init(struct pm860x_chip *chip,
 	if (!chip->core_irq)
 		goto out;
 
-	ret = request_threaded_irq(chip->core_irq, NULL, pm860x_irq, flags | IRQF_ONESHOT,
-				   "88pm860x", chip);
+	ret = request_threaded_irq(chip->core_irq, NULL, pm860x_irq,
+				   flags | IRQF_ONESHOT, "88pm860x", chip);
 	if (ret) {
 		dev_err(chip->dev, "Failed to request IRQ: %d\n", ret);
 		chip->core_irq = 0;
@@ -871,7 +877,7 @@ static void device_rtc_init(struct pm860x_chip *chip,
 {
 	int ret;
 
-	if ((pdata == NULL))
+	if (!pdata)
 		return;
 
 	rtc_devs[0].platform_data = pdata->rtc;
@@ -997,8 +1003,9 @@ static void device_8607_init(struct pm860x_chip *chip,
 			 ret);
 		break;
 	default:
-		dev_err(chip->dev, "Failed to detect Marvell 88PM8607. "
-			"Chip ID: %02x\n", ret);
+		dev_err(chip->dev,
+			"Failed to detect Marvell 88PM8607. Chip ID: %02x\n",
+			ret);
 		goto out;
 	}
 
@@ -1120,8 +1127,8 @@ static int pm860x_dt_init(struct device_node *np,
 	ret = of_property_read_u32(np, "marvell,88pm860x-slave-addr",
 				   &pdata->companion_addr);
 	if (ret) {
-		dev_err(dev, "Not found \"marvell,88pm860x-slave-addr\" "
-			"property\n");
+		dev_err(dev,
+			"Not found \"marvell,88pm860x-slave-addr\" property\n");
 		pdata->companion_addr = 0;
 	}
 	return 0;
-- 
1.8.3.2

