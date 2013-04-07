Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab3DGM23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 08:28:29 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47123 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab3DGM21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 08:28:27 -0400
Message-ID: <1365337700.3916.1.camel@phoenix>
Subject: [PATCH] gpio: lpc32xx: Fix off-by-one valid range checking for bank
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Kevin Wells <kevin.wells@nxp.com>, linux-kernel@vger.kernel.org
Date: Sun, 07 Apr 2013 20:28:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The valid bank should be 0 ... ARRAY_SIZE(lpc32xx_gpiochip) - 1.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpio/gpio-lpc32xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
index 36d7dee..dda6a75 100644
--- a/drivers/gpio/gpio-lpc32xx.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -533,7 +533,7 @@ static int lpc32xx_of_xlate(struct gpio_chip *gc,
 {
 	/* Is this the correct bank? */
 	u32 bank = gpiospec->args[0];
-	if ((bank > ARRAY_SIZE(lpc32xx_gpiochip) ||
+	if ((bank >= ARRAY_SIZE(lpc32xx_gpiochip) ||
 	    (gc != &lpc32xx_gpiochip[bank].chip)))
 		return -EINVAL;
 
-- 
1.7.10.4



