Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaDGKNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 06:13:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:50060 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaDGKNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 06:13:24 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: jamie@jamieiles.com
Cc: atull@altera.com, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinguyen@altera.com,
        linus.walleij@linaro.org, sebastian.hesselbarth@gmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/5] gpio: dwapb: use irq_linear_revmap() for the faster lookup
Date: Mon,  7 Apr 2014 12:13:06 +0200
Message-Id: <1396865589-9972-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396865589-9972-1-git-send-email-bigeasy@linutronix.de>
References: <1396865589-9972-1-git-send-email-bigeasy@linutronix.de>
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

