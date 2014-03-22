Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaCVQRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:17:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:55411 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaCVQQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:16:53 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: atull@altera.com
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinguyen@altera.com,
        delicious.quinoa@gmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/7] gpio: dwapb: use irq_linear_revmap() for the faster lookup
Date: Sat, 22 Mar 2014 17:16:41 +0100
Message-Id: <1395505004-22650-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to irq_linear_revmap() comment, it is slightly faster compared
to irq_find_mapping() since we don't use a radix tree but a linear
mapping.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/gpio/gpio-dwapb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 4d25a06b..541b893 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -92,7 +92,7 @@ static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)
 
 	while (irq_status) {
 		int hwirq = fls(irq_status) - 1;
-		int gpio_irq = irq_find_mapping(gpio->domain, hwirq);
+		int gpio_irq = irq_linear_revmap(gpio->domain, hwirq);
 
 		generic_handle_irq(gpio_irq);
 		irq_status &= ~BIT(hwirq);
-- 
1.9.1

