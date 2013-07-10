Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab3GJL5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:57:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:18096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab3GJLzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1035,1363158000"; 
   d="scan'208";a="343302192"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/5] pinctrl-baytrail: remove redundant ptr variable
Date: Wed, 10 Jul 2013 14:55:38 +0300
Message-Id: <1373457340-16666-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have an additional variable in byt_gpio_reg().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/pinctrl/pinctrl-baytrail.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 06ffeee..14a143c 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -135,15 +135,13 @@ static void __iomem *byt_gpio_reg(struct gpio_chip *chip, unsigned offset,
 {
 	struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
 	u32 reg_offset;
-	void __iomem *ptr;
 
 	if (reg == BYT_INT_STAT_REG)
 		reg_offset = (offset / 32) * 4;
 	else
 		reg_offset = vg->range->pins[offset] * 16;
 
-	ptr = (void __iomem *) (vg->reg_base + reg_offset + reg);
-	return ptr;
+	return vg->reg_base + reg_offset + reg;
 }
 
 static int byt_gpio_request(struct gpio_chip *chip, unsigned offset)
-- 
1.8.3.2

