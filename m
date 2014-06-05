Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaFETXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:23:03 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:57522 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbaFETXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:23:01 -0400
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2014 15:23:01 EDT
X-Sasl-enc: Y56AqNsBC1CZet+nf9uj4zWDn9ARa2czmF5WHwzq9UGB 1401995628
From: Andrew Ruder <andrew.ruder@elecsyscorp.com>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gnurou@gmail.com, linus.walleij@linaro.org,
        Andrew Ruder <andrew.ruder@elecsyscorp.com>
Subject: [PATCH] gpio-pxa: gpio0 and gpio1 support on dt
Date: Thu,  5 Jun 2014 14:13:23 -0500
Message-Id: <1401995603-25997-1-git-send-email-andrew.ruder@elecsyscorp.com>
X-Mailer: git-send-email 1.9.0.rc3.12.gbc97e2d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pxa_gpio_probe() has some issues supporting the gpio0 and gpio1
interrupts under device-tree - it never actually sets up the chain
handler to get interrupts on edge detect for GPIO0 and GPIO1.

Signed-off-by: Andrew Ruder <andrew.ruder@elecsyscorp.com>
---
 drivers/gpio/gpio-pxa.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index 42e6e64..19f1a95 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -649,6 +649,11 @@ static int pxa_gpio_probe(struct platform_device *pdev)
 						 handle_edge_irq);
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
+	} else {
+		if (irq0 > 0)
+			irq_set_chained_handler(irq0, pxa_gpio_demux_handler);
+		if (irq1 > 0)
+			irq_set_chained_handler(irq1, pxa_gpio_demux_handler);
 	}
 
 	irq_set_chained_handler(irq_mux, pxa_gpio_demux_handler);
-- 
1.9.0.rc3.12.gbc97e2d

