Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3EVKUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:20:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:29389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab3EVKUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:20:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,718,1363158000"; 
   d="scan'208";a="338133162"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 5/5] gpio-langwell: drop away explicit casting
Date: Wed, 22 May 2013 13:20:14 +0300
Message-Id: <1369218014-28990-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the type of the reg_base member is void __iomem * we don't need to have
explicit casting in gpio_reg() and gpio_reg_2bit().

Update year in the copyright notice as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-langwell.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 313d190..fec85ca 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -1,7 +1,7 @@
 /*
  * Moorestown platform Langwell chip GPIO driver
  *
- * Copyright (c) 2008 - 2009,  Intel Corporation.
+ * Copyright (c) 2008, 2009, 2013, Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -74,15 +74,13 @@ struct lnw_gpio {
 #define to_lnw_priv(chip)	container_of(chip, struct lnw_gpio, chip)
 
 static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
-			enum GPIO_REG reg_type)
+			      enum GPIO_REG reg_type)
 {
 	struct lnw_gpio *lnw = to_lnw_priv(chip);
 	unsigned nreg = chip->ngpio / 32;
 	u8 reg = offset / 32;
-	void __iomem *ptr;
 
-	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
-	return ptr;
+	return lnw->reg_base + reg_type * nreg * 4 + reg * 4;
 }
 
 static void __iomem *gpio_reg_2bit(struct gpio_chip *chip, unsigned offset,
@@ -91,10 +89,8 @@ static void __iomem *gpio_reg_2bit(struct gpio_chip *chip, unsigned offset,
 	struct lnw_gpio *lnw = to_lnw_priv(chip);
 	unsigned nreg = chip->ngpio / 32;
 	u8 reg = offset / 16;
-	void __iomem *ptr;
 
-	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
-	return ptr;
+	return lnw->reg_base + reg_type * nreg * 4 + reg * 4;
 }
 
 static int lnw_gpio_request(struct gpio_chip *chip, unsigned offset)
-- 
1.8.2.rc0.22.gb3600c3

