Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab3HNOUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:20:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41671 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587Ab3HNOUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:20:46 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] gpio-pca953x: Fix read for chips with more than 8 gpios
Date: Wed, 14 Aug 2013 16:20:38 +0200
Message-Id: <1376490038-32382-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pca953x_read_single returns ONLY the value of the 8 inputs of the
same bank.

off can have a value from 0 to 15, therefore we have to find the
offset of that gpio within that bank.

Without this patch gpios 8-15 will always be read as zero.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/gpio-pca953x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 426c51d..1a7ab13 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -308,7 +308,7 @@ static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 		return 0;
 	}
 
-	return (reg_val & (1u << off)) ? 1 : 0;
+	return (reg_val & (1u << (off % BANK_SZ))) ? 1 : 0;
 }
 
 static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
-- 
1.7.10.4

