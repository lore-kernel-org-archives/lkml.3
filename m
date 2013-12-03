Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab3LCOun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:50:43 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:58297 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab3LCOuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:50:40 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/3] mfd: ab8500: delete all GPIO platform data instances
Date: Tue,  3 Dec 2013 15:50:34 +0100
Message-Id: <1386082234-18919-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This deletes all instances where the AB8500 GPIO platform
data is passed around. It is completely unused in the kernel
now, so it does not hurt anyone.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Sam, Lee: requesting an ACK to take this through either the
pinctrl tree or the ARM SoC tree if I build up more of these
pdata removal patches for abx500.
---
 include/linux/mfd/abx500/ab8500-gpio.h | 10 ----------
 include/linux/mfd/abx500/ab8500.h      |  2 --
 2 files changed, 12 deletions(-)

diff --git a/include/linux/mfd/abx500/ab8500-gpio.h b/include/linux/mfd/abx500/ab8500-gpio.h
index 172b2f201ae0..ebef068cbb6f 100644
--- a/include/linux/mfd/abx500/ab8500-gpio.h
+++ b/include/linux/mfd/abx500/ab8500-gpio.h
@@ -8,16 +8,6 @@
 #ifndef _AB8500_GPIO_H
 #define _AB8500_GPIO_H
 
-/*
- * Platform data to register a block: only the initial gpio/irq number.
- * Array sizes are large enough to contain all AB8500 and AB9540 GPIO
- * registers.
- */
-
-struct abx500_gpio_platform_data {
-	int gpio_base;
-};
-
 enum abx500_gpio_pull_updown {
 	ABX500_GPIO_PULL_DOWN = 0x0,
 	ABX500_GPIO_PULL_NONE = 0x1,
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index f4acd898dac9..a86ca1406fb8 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -368,7 +368,6 @@ struct ab8500 {
 };
 
 struct ab8500_regulator_platform_data;
-struct ab8500_gpio_platform_data;
 struct ab8500_codec_platform_data;
 struct ab8500_sysctrl_platform_data;
 
@@ -382,7 +381,6 @@ struct ab8500_platform_data {
 	int irq_base;
 	void (*init) (struct ab8500 *);
 	struct ab8500_regulator_platform_data *regulator;
-	struct abx500_gpio_platform_data *gpio;
 	struct ab8500_codec_platform_data *codec;
 	struct ab8500_sysctrl_platform_data *sysctrl;
 };
-- 
1.8.3.1

