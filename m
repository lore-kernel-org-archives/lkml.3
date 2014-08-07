Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbaHGEkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 00:40:08 -0400
Received: from mail-yh0-f66.google.com ([209.85.213.66]:53551 "EHLO
	mail-yh0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbaHGEkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 00:40:06 -0400
From: Nick Krause <xerofoiify@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-gpio@vger.kernel.org (open list:GPIO SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drivers/gpio: Check return value to silence warning
Date: Thu,  7 Aug 2014 06:40:13 +0200
Message-Id: <1407386413-20111-1-git-send-email-xerofoiify@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for return value to fix the following error

drivers/gpio/gpio-sch311x.c: In function 'sch311x_gpio_probe':
drivers/gpio/gpio-sch311x.c:286:18: warning: ignoring return value of
'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]

in the context we do not need to check but checking makes compiler happy.
With help from kernelnewbies.

Signed-off-by: Nick Krause <xerofoify@gmail.com>
---
 drivers/gpio/gpio-sch311x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-sch311x.c b/drivers/gpio/gpio-sch311x.c
index f942b80..af35e99 100644
--- a/drivers/gpio/gpio-sch311x.c
+++ b/drivers/gpio/gpio-sch311x.c
@@ -283,7 +283,7 @@ exit_err:
 	release_region(pdata->runtime_reg + GP1, 6);
 	/* release already registered chips */
 	for (--i; i >= 0; i--)
-		gpiochip_remove(&priv->blocks[i].chip);
+		WARN_ON(gpiochip_remove(&priv->blocks[i].chip));
 	return err;
 }
 
-- 
2.0.1

