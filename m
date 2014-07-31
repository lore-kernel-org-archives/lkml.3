Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaGaMID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:08:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37429 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaGaMIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:08:00 -0400
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Thu, 31 Jul 2014 13:07:48 +0100
Message-Id: <1406808468-12559-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.0.1
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] gpiolib: Don't allow drivers to specify a base with DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

DT based systems should have no reason to use fixed GPIO numbers but some
drivers that work on both DT and non-DT platforms specify them anyway. In
order to improve robustness in cases where drivers use gpio_is_valid() to
check for a valid GPIO on data initialized to zero as a default and avoid
bugs due to assuptions about fixed numbers creeping in ignore any specified
base when DT is in use.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 768f0831db18..11d3cf1cbca7 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -234,7 +234,7 @@ int gpiochip_add(struct gpio_chip *chip)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (base < 0) {
+	if (base < 0 || of_have_populated_dt()) {
 		base = gpiochip_find_base(chip->ngpio);
 		if (base < 0) {
 			status = base;
-- 
2.0.1

