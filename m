Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3CEMWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 07:22:20 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:36331 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab3CEMWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 07:22:19 -0500
Message-ID: <1362486116.3660.1.camel@phoenix>
Subject: [PATCH] gpio: viperboard: Remove duplicate code to set
 gpio->gpiob_val
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Lars Poeschel <poeschel@lemonage.de>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 20:21:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set it once is enough, and it's done in vprbrd_gpiob_set() which is called by
vprbrd_gpiob_direction_output().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpio/gpio-viperboard.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpio/gpio-viperboard.c b/drivers/gpio/gpio-viperboard.c
index 59d7239..095ab14 100644
--- a/drivers/gpio/gpio-viperboard.c
+++ b/drivers/gpio/gpio-viperboard.c
@@ -380,10 +380,6 @@ static int vprbrd_gpiob_direction_output(struct gpio_chip *chip,
 	struct vprbrd *vb = gpio->vb;
 
 	gpio->gpiob_out |= (1 << offset);
-	if (value)
-		gpio->gpiob_val |= (1 << offset);
-	else
-		gpio->gpiob_val &= ~(1 << offset);
 
 	mutex_lock(&vb->lock);
 
-- 
1.7.9.5



