Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3H3Ibd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:31:33 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61733 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3H3Ibb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:31:31 -0400
Message-ID: <1377851485.14643.1.camel@phoenix>
Subject: [PATCH] pinctrl: sunxi: Fix off-by-one for valid offset range
 checking
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 16:31:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The valid offset range should be 0 ... chip->ngpio - 1.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-sunxi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index b20df31..0ffd4c0 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -529,7 +529,7 @@ static int sunxi_pinctrl_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	struct sunxi_pinctrl *pctl = dev_get_drvdata(chip->dev);
 	struct sunxi_desc_function *desc;
 
-	if (offset > chip->ngpio)
+	if (offset >= chip->ngpio)
 		return -ENXIO;
 
 	desc = sunxi_pinctrl_desc_find_function_by_pin(pctl, offset, "irq");
-- 
1.8.1.2



