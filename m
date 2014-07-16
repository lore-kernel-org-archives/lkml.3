Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbaGPXLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:11:13 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53692 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaGPXLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:11:11 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] gpio: Add support for GPIOF_ACTIVE_LOW to gpio_request_one
Date: Wed, 16 Jul 2014 16:11:00 -0700
Message-Id: <1405552260-30511-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio include file and the gpio documentation declare and document
GPIOF_ACTIVE_LOW as one of the flags to be passed to gpio_request_one
and related functions. However, the flag is not evaluated or used.

Check the flag in gpio_request_one and set the gpio internal flag
FLAG_ACTIVE_LOW if it is set.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/gpio/gpiolib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 2ebc907..43d9e34 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1842,6 +1842,9 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
 	if (flags & GPIOF_OPEN_SOURCE)
 		set_bit(FLAG_OPEN_SOURCE, &desc->flags);
 
+	if (flags & GPIOF_ACTIVE_LOW)
+		set_bit(FLAG_ACTIVE_LOW, &desc->flags);
+
 	if (flags & GPIOF_DIR_IN)
 		err = gpiod_direction_input(desc);
 	else
-- 
1.9.1

