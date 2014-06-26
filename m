Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbaFZQRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:17:46 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52819 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103AbaFZQRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:17:45 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: gpio-ucb1400.c:  Cleaning up null pointer checks that could never happen
Date: Thu, 26 Jun 2014 18:18:51 +0200
Message-Id: <1403799531-20526-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of null pointer checks that could never happen

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpio/gpio-ucb1400.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-ucb1400.c b/drivers/gpio/gpio-ucb1400.c
index 2445fe7..d520dc9 100644
--- a/drivers/gpio/gpio-ucb1400.c
+++ b/drivers/gpio/gpio-ucb1400.c
@@ -70,7 +70,7 @@ static int ucb1400_gpio_probe(struct platform_device *dev)
 	if (err)
 		goto err;
 
-	if (ucb && ucb->gpio_setup)
+	if (ucb->gpio_setup)
 		err = ucb->gpio_setup(&dev->dev, ucb->gc.ngpio);
 
 err:
-- 
1.7.10.4

