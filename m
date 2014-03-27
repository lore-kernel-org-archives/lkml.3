Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbaC0MwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 08:52:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:15414 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbaC0MwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:52:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,742,1389772800"; 
   d="scan'208";a="508175202"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: Linus <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH] gpio-lynxpoint: force gpio_get() to return "1" and "0" only
Date: Thu, 27 Mar 2014 15:02:08 +0200
Message-Id: <1395925328-6056-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't return the IN_LVL_BIT directly, a high gpio line returned
value "1073741824" intestead of "1" because IN_LVL_BIT is BIT(30)

Tested-by: Jerome Blin <jerome.blin@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/gpio/gpio-lynxpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
index 66b1853..803ea3c 100644
--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -188,7 +188,7 @@ static int lp_irq_type(struct irq_data *d, unsigned type)
 static int lp_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	unsigned long reg = lp_gpio_reg(chip, offset, LP_CONFIG1);
-	return inl(reg) & IN_LVL_BIT;
+	return !!(inl(reg) & IN_LVL_BIT);
 }
 
 static void lp_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
-- 
1.8.3.2

