Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaBJWFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:05:19 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:38120 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaBJWFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:05:15 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH] of/gpio: Define OF_GPIO_OPEN_DRAIN flag for Open Drain outputs.
Date: Mon, 10 Feb 2014 14:05:08 -0800
Message-Id: <1392069908-22017-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

When we have a GPIO pin connected to an open-drain network, we want a
standard way of specifying this in the device tree.  So we choose bit
1 of the flag field to indicate open drain.

A typical use case would be something like:

	enum of_gpio_flags f;
	.
	.
	.
	reset_gpio = of_get_named_gpio_flags(node, "reset", 0, &f);
	.
	.
	.
	ret = gpio_request_one(reset_gpio,
		(f & OF_GPIO_OPEN_DRAIN) ? GPIOF_OPEN_DRAIN : 0,
		 "reset");
	.
	.
	.
	gpio_direction_output(reset_gpio, 1);
	gpio_set_value(reset_gpio, 0);
	msleep(20);
	gpio_set_value(reset_gpio, 1);
	.
	.
	.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/linux/of_gpio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index f14123a..0e374774 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -30,6 +30,7 @@ struct device_node;
  */
 enum of_gpio_flags {
 	OF_GPIO_ACTIVE_LOW = 0x1,
+	OF_GPIO_OPEN_DRAIN = 0x2,
 };
 
 #ifdef CONFIG_OF_GPIO
-- 
1.7.11.7

