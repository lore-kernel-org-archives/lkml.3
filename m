Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3CVMKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:10:54 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:48233 "EHLO mailhub2.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab3CVMKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:10:53 -0400
Date: Fri, 22 Mar 2013 13:10:09 +0100
Message-Id: <201303221210.r2MCA99B031543@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, Patrick Vasseur <patrick.vasseur@c-s.fr>
Subject: [PATCH] MAX7301 GPIO: Do not force SPI speed when using OF Platform
X-Antivirus: avast! (VPS 130322-0, 22/03/2013), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bit_per_word can be set in the OF Device tree, so no need to force it as with
the platform_data when using OF Platform

Signed-off-by: Patrick Vasseur <patrick.vasseur@c-s.fr>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

diff -ur linux-3.8.4/drivers/gpio/gpio-max7301.c linux/drivers/gpio/gpio-max7301.c
--- linux-3.8.4/drivers/gpio/gpio-max7301.c	2013-03-20 21:11:19.000000000 +0100
+++ linux/drivers/gpio/gpio-max7301.c	2013-03-16 10:27:30.000000000 +0100
@@ -56,7 +56,8 @@
 	int ret;
 
 	/* bits_per_word cannot be configured in platform data */
-	spi->bits_per_word = 16;
+	if (spi->dev.platform_data)
+		spi->bits_per_word = 16;
 	ret = spi_setup(spi);
 	if (ret < 0)
 		return ret;
