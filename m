Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaJBHUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:20:25 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56663 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaJBHUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:20:24 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: pch: Build context save/restore only for PM
Date: Thu,  2 Oct 2014 09:20:21 +0200
Message-Id: <1412234421-11065-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The pch_gpio_save_reg_conf() and pch_gpio_restore_reg_conf() functions
are only used in pch_gpio_suspend() and pch_gpio_resume(), respectively.
Since the latter are only built if PM is enabled, make the former build
under the same conditions.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpio/gpio-pch.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index e0ac549dccb5..2d9a950ca2d4 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -171,6 +171,7 @@ static int pch_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 /*
  * Save register configuration and disable interrupts.
  */
@@ -206,6 +207,7 @@ static void pch_gpio_restore_reg_conf(struct pch_gpio *chip)
 		iowrite32(chip->pch_gpio_reg.gpio_use_sel_reg,
 			  &chip->reg->gpio_use_sel);
 }
+#endif
 
 static int pch_gpio_to_irq(struct gpio_chip *gpio, unsigned offset)
 {
-- 
2.1.0

