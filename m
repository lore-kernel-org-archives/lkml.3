Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaBJPHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:07:14 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:40675 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaBJPHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:07:10 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: linux-gpio@vger.kernel.org, richard.genoud@gmail.com,
        linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH] gpio: take in account the active low flag when configuring the gpio as an ouput
Date: Mon, 10 Feb 2014 16:03:34 +0100
Message-Id: <1392044614-6837-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial value of the gpio is passed to gpiod_direction_output. Currently
this value is the raw value of the GPIO line, but it should be the logical
value.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/gpio/gpiolib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 4e10b10..111a1f1 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1751,6 +1751,9 @@ int gpiod_direction_output(struct gpio_desc *desc, int value)
 		return -EINVAL;
 	}
 
+	if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
+		value = !value;
+
 	/* GPIOs used for IRQs shall not be set as output */
 	if (test_bit(FLAG_USED_AS_IRQ, &desc->flags)) {
 		gpiod_err(desc,
-- 
1.8.5.3

