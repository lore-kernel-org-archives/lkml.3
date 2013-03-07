Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3CGIqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:46:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:30932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794Ab3CGIqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:46:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,800,1355126400"; 
   d="scan'208";a="295574046"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] gpio/gpio-ich: make ichx_gpio_check_available() return a pure boolean value
Date: Thu,  7 Mar 2013 10:48:19 +0200
Message-Id: <1362646099-3506-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is more readable for humans to use double-bang (!!) to convert the value
to pure boolean before it is returned.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpio-ich.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-ich.c b/drivers/gpio/gpio-ich.c
index f9dbd50..22ea0be 100644
--- a/drivers/gpio/gpio-ich.c
+++ b/drivers/gpio/gpio-ich.c
@@ -130,7 +130,7 @@ static int ichx_read_bit(int reg, unsigned nr)
 
 static bool ichx_gpio_check_available(struct gpio_chip *gpio, unsigned nr)
 {
-	return ichx_priv.use_gpio & (1 << (nr / 32));
+	return !!(ichx_priv.use_gpio & (1 << (nr / 32)));
 }
 
 static int ichx_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
-- 
1.7.10.4

