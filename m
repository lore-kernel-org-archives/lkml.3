Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaBKTuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:50:14 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37967 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbaBKTuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:50:08 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v2 1/2] of/gpio: Define OF_GPIO_OPEN_DRAIN and OF_GPIO_OPEN_SOURCE flags.
Date: Tue, 11 Feb 2014 11:49:59 -0800
Message-Id: <1392148200-5393-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1392148200-5393-1-git-send-email-ddaney.cavm@gmail.com>
References: <1392148200-5393-1-git-send-email-ddaney.cavm@gmail.com>
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

Since the same arguments hold for open-source configurations, add a
definition for OF_GPIO_OPEN_SOURCE as well.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/linux/of_gpio.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index f14123a..cfacf5875 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -30,6 +30,8 @@ struct device_node;
  */
 enum of_gpio_flags {
 	OF_GPIO_ACTIVE_LOW = 0x1,
+	OF_GPIO_OPEN_DRAIN = 0x2,
+	OF_GPIO_OPEN_SOURCE = 0x4,
 };
 
 #ifdef CONFIG_OF_GPIO
-- 
1.7.11.7

