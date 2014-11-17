Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaKQOcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:32:06 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:44392 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaKQOcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:32:04 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] gpio: Check if base is positive before calling gpio_is_valid()
Date: Mon, 17 Nov 2014 15:31:59 +0100
Message-Id: <1416234719-16310-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make much sense to make some (possible expensive) calls to
gpio_is_valid() first, and to ignore the result if the base number is
negative. Check for a positive base number first.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/gpio/gpiolib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 2e3d66adc6880950..bdf2020e103c7bc0 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -227,8 +227,8 @@ int gpiochip_add(struct gpio_chip *chip)
 	unsigned	id;
 	int		base = chip->base;
 
-	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio - 1))
-			&& base >= 0) {
+	if (base >= 0 &&
+	    (!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio - 1))) {
 		status = -EINVAL;
 		goto fail;
 	}
-- 
1.9.1

