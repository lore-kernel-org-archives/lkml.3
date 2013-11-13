Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab3KMUVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:21:11 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:54840 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab3KMUVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:21:04 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: fix memory leak in error path
Date: Wed, 13 Nov 2013 21:20:39 +0100
Message-Id: <1384374039-18795-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/gpio/gpiolib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 4e10b10..068011c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1341,8 +1341,10 @@ int gpiochip_add_pingroup_range(struct gpio_chip *chip,
 	ret = pinctrl_get_group_pins(pctldev, pin_group,
 					&pin_range->range.pins,
 					&pin_range->range.npins);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(pin_range);
 		return ret;
+	}
 
 	pinctrl_add_gpio_range(pctldev, &pin_range->range);
 
-- 
1.8.4.1

