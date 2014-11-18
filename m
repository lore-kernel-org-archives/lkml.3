Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbaKROnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:43:50 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:42735 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041AbaKROnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:43:47 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Matthieu Crapet <mcrapet@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] pinctrl: at91: enhance (debugfs) at91_gpio_dbg_show
Date: Tue, 18 Nov 2014 15:43:45 +0100
Message-ID: <1416321825-17776-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthieu Crapet <mcrapet@gmail.com>

When a pin is configured as GPIO, print also direction (input or output).

Signed-off-by: Matthieu Crapet <mcrapet@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/pinctrl/pinctrl-at91.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 354a81d40925..a6b29ebc3cc3 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1344,7 +1344,6 @@ static void at91_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 	for (i = 0; i < chip->ngpio; i++) {
 		unsigned mask = pin_to_mask(i);
 		const char *gpio_label;
-		u32 pdsr;
 
 		gpio_label = gpiochip_is_requested(chip, i);
 		if (!gpio_label)
@@ -1353,11 +1352,13 @@ static void at91_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 		seq_printf(s, "[%s] GPIO%s%d: ",
 			   gpio_label, chip->label, i);
 		if (mode == AT91_MUX_GPIO) {
-			pdsr = readl_relaxed(pio + PIO_PDSR);
-
-			seq_printf(s, "[gpio] %s\n",
-				   pdsr & mask ?
-				   "set" : "clear");
+			seq_printf(s, "[gpio] ");
+			seq_printf(s, "%s ",
+				      readl_relaxed(pio + PIO_OSR) & mask ?
+				      "output" : "input");
+			seq_printf(s, "%s\n",
+				      readl_relaxed(pio + PIO_PDSR) & mask ?
+				      "set" : "clear");
 		} else {
 			seq_printf(s, "[periph %c]\n",
 				   mode + 'A' - 1);
-- 
2.1.3

