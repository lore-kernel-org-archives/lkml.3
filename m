Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3DMOr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 10:47:29 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:53383 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3DMOr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:47:27 -0400
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 3.8-stable] gpio: fix wrong checking condition for gpio range
Date: Sat, 13 Apr 2013 23:46:09 +0900
Message-Id: <1365864369-10563-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haojian Zhuang <haojian.zhuang@linaro.org>

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Haojian Zhuang <haojian.zhuang@linaro.org>"

commit ad4e1a7caf937ad395ced585ca85a7d14395dc80 upstream

If index++ calculates from 0, the checking condition of "while
(index++)" fails & it doesn't check any more. It doesn't follow
the loop that used at here.

Replace it by endless loop at here. Then it keeps parsing
"gpio-ranges" property until it ends.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/gpio/gpiolib-of.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index d542a14..ea537fa 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -228,7 +228,7 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 	if (!np)
 		return;
 
-	do {
+	for (;; index++) {
 		ret = of_parse_phandle_with_args(np, "gpio-ranges",
 				"#gpio-range-cells", index, &pinspec);
 		if (ret)
@@ -257,8 +257,7 @@ static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 
 		if (ret)
 			break;
-
-	} while (index++);
+	}
 }
 
 #else
-- 
1.7.10.4

