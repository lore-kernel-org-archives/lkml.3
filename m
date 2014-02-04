Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936374AbaBDWvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:51:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294AbaBDVCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.10 056/104] pinctrl: sunxi: Honor GPIO output initial vaules
Date: Tue,  4 Feb 2014 13:01:59 -0800
Message-Id: <20140204210224.309568772@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

commit fa8cf57c923e86a693a85aff1df579245a27cbb3 upstream.

Some GPIO users, such as fixed-regulator, request GPIO output with
initial value of 1. This was ignored by sunxi driver.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-sunxi.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -1754,12 +1754,6 @@ static int sunxi_pinctrl_gpio_get(struct
 	return val;
 }
 
-static int sunxi_pinctrl_gpio_direction_output(struct gpio_chip *chip,
-					unsigned offset, int value)
-{
-	return pinctrl_gpio_direction_output(chip->base + offset);
-}
-
 static void sunxi_pinctrl_gpio_set(struct gpio_chip *chip,
 				unsigned offset, int value)
 {
@@ -1770,6 +1764,13 @@ static void sunxi_pinctrl_gpio_set(struc
 	writel((value & DATA_PINS_MASK) << index, pctl->membase + reg);
 }
 
+static int sunxi_pinctrl_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	sunxi_pinctrl_gpio_set(chip, offset, value);
+	return pinctrl_gpio_direction_output(chip->base + offset);
+}
+
 static int sunxi_pinctrl_gpio_of_xlate(struct gpio_chip *gc,
 				const struct of_phandle_args *gpiospec,
 				u32 *flags)


