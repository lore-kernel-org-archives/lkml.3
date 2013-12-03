Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3LCOu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:50:56 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:65225 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3LCOuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:50:55 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/3] mfd/pinctrl: delete platform data header
Date: Tue,  3 Dec 2013 15:50:49 +0100
Message-Id: <1386082249-18958-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This deletes the special AB8500 GPIO platform data passing
header and merges the few remaining contents down into the
abx500 pinctrl driver which handles the abx500 GPIO device.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Lee, Sam: I'd like an ACK on this one too, for the same
reason as the previous patch.
---
 drivers/pinctrl/pinctrl-abx500.c       |  1 -
 drivers/pinctrl/pinctrl-abx500.h       | 12 ++++++++++++
 include/linux/mfd/abx500/ab8500-gpio.h | 23 -----------------------
 3 files changed, 12 insertions(+), 24 deletions(-)
 delete mode 100644 include/linux/mfd/abx500/ab8500-gpio.h

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 66a06d5194cd..119928061f54 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -24,7 +24,6 @@
 #include <linux/bitops.h>
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500.h>
-#include <linux/mfd/abx500/ab8500-gpio.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/pinctrl/pinmux.h>
diff --git a/drivers/pinctrl/pinctrl-abx500.h b/drivers/pinctrl/pinctrl-abx500.h
index eeca8f973999..2fa003c5cf02 100644
--- a/drivers/pinctrl/pinctrl-abx500.h
+++ b/drivers/pinctrl/pinctrl-abx500.h
@@ -15,6 +15,18 @@ enum abx500_pin_func {
 	ABX500_ALT_C,
 };
 
+enum abx500_gpio_pull_updown {
+	ABX500_GPIO_PULL_DOWN = 0x0,
+	ABX500_GPIO_PULL_NONE = 0x1,
+	ABX500_GPIO_PULL_UP = 0x3,
+};
+
+enum abx500_gpio_vinsel {
+	ABX500_GPIO_VINSEL_VBAT = 0x0,
+	ABX500_GPIO_VINSEL_VIN_1V8 = 0x1,
+	ABX500_GPIO_VINSEL_VDD_BIF = 0x2,
+};
+
 /**
  * struct abx500_function - ABx500 pinctrl mux function
  * @name: The name of the function, exported to pinctrl core.
diff --git a/include/linux/mfd/abx500/ab8500-gpio.h b/include/linux/mfd/abx500/ab8500-gpio.h
deleted file mode 100644
index ebef068cbb6f..000000000000
--- a/include/linux/mfd/abx500/ab8500-gpio.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Copyright ST-Ericsson 2010.
- *
- * Author: Bibek Basu <bibek.basu@stericsson.com>
- * Licensed under GPLv2.
- */
-
-#ifndef _AB8500_GPIO_H
-#define _AB8500_GPIO_H
-
-enum abx500_gpio_pull_updown {
-	ABX500_GPIO_PULL_DOWN = 0x0,
-	ABX500_GPIO_PULL_NONE = 0x1,
-	ABX500_GPIO_PULL_UP = 0x3,
-};
-
-enum abx500_gpio_vinsel {
-	ABX500_GPIO_VINSEL_VBAT = 0x0,
-	ABX500_GPIO_VINSEL_VIN_1V8 = 0x1,
-	ABX500_GPIO_VINSEL_VDD_BIF = 0x2,
-};
-
-#endif /* _AB8500_GPIO_H */
-- 
1.8.3.1

