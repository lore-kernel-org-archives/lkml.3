Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3COMwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:52:21 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:60193 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3COMwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:52:20 -0400
Message-ID: <1363351927.16666.2.camel@phoenix>
Subject: [PATCH] gpio: pl061: Add pl061_gpio_free()
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>, linux-kernel@vger.kernel.org
Date: Fri, 15 Mar 2013 20:52:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 39b70ee051 "gpio: pl061: bind pinctrl by gpio request"
adds pl061_gpio_request() to request pinctrl.
Thus we need to add corresponding pl061_gpio_free() to free the pin.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpio/gpio-pl061.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
index 06ed257..d7008df 100644
--- a/drivers/gpio/gpio-pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -72,6 +72,13 @@ static int pl061_gpio_request(struct gpio_chip *chip, unsigned offset)
 	return pinctrl_request_gpio(gpio);
 }
 
+static void pl061_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	int gpio = chip->base + offset;
+
+	pinctrl_free_gpio(gpio);
+}
+
 static int pl061_direction_input(struct gpio_chip *gc, unsigned offset)
 {
 	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
@@ -287,6 +294,7 @@ static int pl061_probe(struct amba_device *adev, const struct amba_id *id)
 	spin_lock_init(&chip->lock);
 
 	chip->gc.request = pl061_gpio_request;
+	chip->gc.free = pl061_gpio_free;
 	chip->gc.direction_input = pl061_direction_input;
 	chip->gc.direction_output = pl061_direction_output;
 	chip->gc.get = pl061_get_value;
-- 
1.7.9.5



