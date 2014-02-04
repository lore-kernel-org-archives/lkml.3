Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935524AbaBDWEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:04:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934144AbaBDVJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:09:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.12 073/133] pinctrl: sunxi: Honor GPIO output initial vaules
Date: Tue,  4 Feb 2014 13:07:54 -0800
Message-Id: <20140204210739.095424795@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -469,12 +469,6 @@ static int sunxi_pinctrl_gpio_get(struct
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
@@ -498,6 +492,13 @@ static void sunxi_pinctrl_gpio_set(struc
 	spin_unlock_irqrestore(&pctl->lock, flags);
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


