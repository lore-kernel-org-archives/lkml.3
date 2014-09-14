Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaINN5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 09:57:22 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:43233 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489AbaINN5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 09:57:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0OAMWdFVRbsGnM/2dsb2JhbABggw2zSAEBAQEBAQUBbwGdfIEEF3iEMS8jgRo3iEIBqG2PGYV8iVEdhDUFnQiMMIkPghuBRTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org
Subject: [PATCH 1/1 linux-next] gpio: use container_of to resolve cs5535_gpio_chip from gpio_chip
Date: Sun, 14 Sep 2014 15:56:55 +0200
Message-Id: <1410703015-24127-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
Compiled but untested.

 drivers/gpio/gpio-cs5535.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-cs5535.c b/drivers/gpio/gpio-cs5535.c
index 92ec58f..668127f 100644
--- a/drivers/gpio/gpio-cs5535.c
+++ b/drivers/gpio/gpio-cs5535.c
@@ -201,7 +201,8 @@ EXPORT_SYMBOL_GPL(cs5535_gpio_setup_event);
 
 static int chip_gpio_request(struct gpio_chip *c, unsigned offset)
 {
-	struct cs5535_gpio_chip *chip = (struct cs5535_gpio_chip *) c;
+	struct cs5535_gpio_chip *chip =
+		container_of(c, struct cs5535_gpio_chip, chip);
 	unsigned long flags;
 
 	spin_lock_irqsave(&chip->lock, flags);
@@ -241,7 +242,8 @@ static void chip_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 
 static int chip_direction_input(struct gpio_chip *c, unsigned offset)
 {
-	struct cs5535_gpio_chip *chip = (struct cs5535_gpio_chip *) c;
+	struct cs5535_gpio_chip *chip =
+		container_of(c, struct cs5535_gpio_chip, chip);
 	unsigned long flags;
 
 	spin_lock_irqsave(&chip->lock, flags);
@@ -254,7 +256,8 @@ static int chip_direction_input(struct gpio_chip *c, unsigned offset)
 
 static int chip_direction_output(struct gpio_chip *c, unsigned offset, int val)
 {
-	struct cs5535_gpio_chip *chip = (struct cs5535_gpio_chip *) c;
+	struct cs5535_gpio_chip *chip =
+		container_of(c, struct cs5535_gpio_chip, chip);
 	unsigned long flags;
 
 	spin_lock_irqsave(&chip->lock, flags);
-- 
1.9.1

