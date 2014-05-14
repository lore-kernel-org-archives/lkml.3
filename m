Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaENVnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:43:46 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:55405 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaENVnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:43:45 -0400
From: abdoulaye berthe <berthe.ab@gmail.com>
To: m@bues.ch, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        berthe.ab@gmail.com
Subject: [PATCH] gpio: gpio-bt8xx: fix compilation warning
Date: Wed, 14 May 2014 23:43:36 +0200
Message-Id: <1400103816-26086-1-git-send-email-berthe.ab@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this fixes a compilation warning by checking
the retun value of gpiochip_remove()

Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
---
 drivers/gpio/gpio-bt8xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-bt8xx.c b/drivers/gpio/gpio-bt8xx.c
index ecb3ca2d..5480229 100644
--- a/drivers/gpio/gpio-bt8xx.c
+++ b/drivers/gpio/gpio-bt8xx.c
@@ -240,7 +240,8 @@ static void bt8xxgpio_remove(struct pci_dev *pdev)
 {
 	struct bt8xxgpio *bg = pci_get_drvdata(pdev);
 
-	gpiochip_remove(&bg->gpio);
+	if (gpiochip_remove(&bg->gpio))
+		dev_info(&pdev->dev, "gpiochip_remove() failed.\n");
 
 	bgwrite(0, BT848_INT_MASK);
 	bgwrite(~0x0, BT848_INT_STAT);
-- 
1.8.3.2

