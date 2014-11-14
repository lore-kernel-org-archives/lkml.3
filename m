Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162001AbaKNVdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:33:02 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:48816 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbaKNVdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:33:00 -0500
Date: Fri, 14 Nov 2014 13:32:56 -0800
From: Dmitry Torokhov <dtor@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        James Hogan <james.hogan@imgtec.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpio-tz1090: fix error handling of irq_of_parse_and_map
Message-ID: <20141114213256.GA24709@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_of_parse_and_map() returns 0 on error, so testing for negative
result never works.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---

Not tested, found by casual inspection of the code.

 drivers/gpio/gpio-tz1090.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-tz1090.c b/drivers/gpio/gpio-tz1090.c
index 9e90177..e3024bb 100644
--- a/drivers/gpio/gpio-tz1090.c
+++ b/drivers/gpio/gpio-tz1090.c
@@ -446,7 +446,7 @@ static int tz1090_gpio_bank_probe(struct tz1090_gpio_bank_info *info)
 	bank->irq = irq_of_parse_and_map(np, 0);
 
 	/* The interrupt is optional (it may be used by another core on chip) */
-	if (bank->irq < 0) {
+	if (!bank->irq) {
 		dev_info(dev, "IRQ not provided for bank %u, IRQs disabled\n",
 			 info->index);
 		return 0;
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
