Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaI2Nov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:44:51 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:41023 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856AbaI2Nou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:44:50 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH] pinctrl: st: Fix Sparse error
Date: Mon, 29 Sep 2014 19:18:19 +0530
Message-Id: <1411998499-20300-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes below sparse error,
drivers/pinctrl/pinctrl-st.c:1515:31: error: incompatible types for operation (>)
drivers/pinctrl/pinctrl-st.c:1515:31:    left side has type void [noderef] <asn:2>*irqmux_base
drivers/pinctrl/pinctrl-st.c:1515:31:    right side has type int

The fix is done by removing a check on info->irqmux_base as
info->irqmux_base has already been checked  for error when allocating it.
Hence there is no need to redo the check.

Cc: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
CC: Linus Walleij <linus.walleij@linaro.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/pinctrl/pinctrl-st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 5475374..ddeaeda 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1512,7 +1512,7 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
 					     gpio_irq, st_gpio_irq_handler);
 	}
 
-	if (info->irqmux_base > 0 || gpio_irq > 0) {
+	if (gpio_irq > 0) {
 		err = gpiochip_irqchip_add(&bank->gpio_chip, &st_gpio_irqchip,
 					   0, handle_simple_irq,
 					   IRQ_TYPE_LEVEL_LOW);
-- 
1.7.9.5

