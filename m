Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3H0Oah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:30:37 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35448 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab3H0OaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:30:22 -0400
Message-ID: <1377613817.14731.1.camel@phoenix>
Subject: [PATCH] pinctrl: rockchip: Implement .request() and .free()
 callbacks on the GPIO chips
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        linux-kernel@vger.kernel.org
Date: Tue, 27 Aug 2013 22:30:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement .request() and .free() callbacks on the GPIO chips to inform pinctrl
when a GPIO is requested or freed.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-rockchip.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 64ad0c0..b1337eb 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -872,6 +872,16 @@ static int rockchip_pinctrl_register(struct platform_device *pdev,
  * GPIO handling
  */
 
+static int rockchip_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_request_gpio(chip->base + offset);
+}
+
+static void rockchip_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(chip->base + offset);
+}
+
 static void rockchip_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
 {
 	struct rockchip_pin_bank *bank = gc_to_pin_bank(gc);
@@ -945,6 +955,8 @@ static int rockchip_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 }
 
 static const struct gpio_chip rockchip_gpiolib_chip = {
+	.request = rockchip_gpio_request,
+	.free = rockchip_gpio_free,
 	.set = rockchip_gpio_set,
 	.get = rockchip_gpio_get,
 	.direction_input = rockchip_gpio_direction_input,
-- 
1.8.1.2



