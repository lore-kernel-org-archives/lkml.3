Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbaFZNhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:37:21 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:45397 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbaFZNhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:37:20 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: gpio-vr41xx.c:  Cleaning up values that are never used
Date: Thu, 26 Jun 2014 15:38:29 +0200
Message-Id: <1403789909-11252-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove variable that are never used

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpio/gpio-vr41xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index 66cbcc1..ce0bb24 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -515,7 +515,7 @@ static int giu_probe(struct platform_device *pdev)
 	struct resource *res;
 	unsigned int trigger, i, pin;
 	struct irq_chip *chip;
-	int irq, retval;
+	int irq;
 
 	switch (pdev->id) {
 	case GPIO_50PINS_PULLUPDOWN:
@@ -544,7 +544,7 @@ static int giu_probe(struct platform_device *pdev)
 
 	vr41xx_gpio_chip.dev = &pdev->dev;
 
-	retval = gpiochip_add(&vr41xx_gpio_chip);
+	gpiochip_add(&vr41xx_gpio_chip);
 
 	giu_write(GIUINTENL, 0);
 	giu_write(GIUINTENH, 0);
-- 
1.7.10.4

