Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab3A2MID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:08:03 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:45431 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3A2MIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:08:00 -0500
X-Auth-Info: 2zr+VRJPA4fPkkR1Y+BkO3eD+Bd+wPoBLtnbMT14K7M=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] gpio: mpc8xxx: don't set IRQ_TYPE_NONE when creating irq mapping
Date: Tue, 29 Jan 2013 13:07:55 +0100
Message-Id: <1359461275-7059-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exporting gpios throws genirq error messages like

genirq: Setting trigger mode 0 for irq 44 failed
 (mpc512x_irq_set_type+0x0/0x18c)

Do not set IRQ_TYPE_NONE in mapping function. Setting this type here
ends up in returning error code in driver's irq_set_type() function
and this triggers the genirq error message.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/gpio/gpio-mpc8xxx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 9ae29cc..a0b33a2 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -292,7 +292,6 @@ static int mpc8xxx_gpio_irq_map(struct irq_domain *h, unsigned int virq,
 
 	irq_set_chip_data(virq, h->host_data);
 	irq_set_chip_and_handler(virq, &mpc8xxx_irq_chip, handle_level_irq);
-	irq_set_irq_type(virq, IRQ_TYPE_NONE);
 
 	return 0;
 }
-- 
1.7.11.7

