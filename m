Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab3HTG33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:29:29 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:52238 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab3HTG32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:29:28 -0400
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "To"
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "To"
Date: Tue, 20 Aug 2013 08:29:23 +0200
Message-Id: <201308200629.r7K6TNUS010648@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, stigge@antcom.de
Subject: [PATCH] MAX7301 GPIO: Reverting "Do not force SPI speed when using OF Platform"
To: Grant Likely <grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reverts commit 047b93a35961f7a6561e6f5dcb040738f822b892 which breaks
MAX7301 GPIO driver because that commit was dependant on a rejected patch that
was implementing selection of SPI speed from the Device Tree.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

--- linux-3.11-rc6/drivers/gpio/gpio-max7301.c	2013-08-17 21:09:17.000000000 +0200
+++ linux/drivers/gpio/gpio-max7301.c	2013-08-18 06:31:52.000000000 +0200
@@ -56,8 +56,7 @@
 	int ret;
 
 	/* bits_per_word cannot be configured in platform data */
-	if (spi->dev.platform_data)
-		spi->bits_per_word = 16;
+	spi->bits_per_word = 16;
 	ret = spi_setup(spi);
 	if (ret < 0)
 		return ret;
