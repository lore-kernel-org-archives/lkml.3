Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaJASiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:38:13 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:33948 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752889AbaJASiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:38:12 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org
Subject: [PATCH] gpio: grgpio: remove irq_domain resources on failure
Date: Thu,  2 Oct 2014 00:08:04 +0530
Message-Id: <1412188684-20820-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call irq_domain_remove when gpiochip_add fails to release irq_domain
resources.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/gpio/gpio-grgpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index 66ad3df..38acdce 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -441,6 +441,7 @@ static int grgpio_probe(struct platform_device *ofdev)
 	err = gpiochip_add(gc);
 	if (err) {
 		dev_err(&ofdev->dev, "Could not add gpiochip\n");
+		irq_domain_remove(priv->domain);
 		return err;
 	}
 
-- 
1.8.3.2

