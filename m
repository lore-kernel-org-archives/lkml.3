Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaEWF7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 01:59:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55287 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbaEWF7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 01:59:08 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>
CC: <gnurou@gmail.com>, <linus.walleij@linaro.org>,
        <kuninori.morimoto.gx@renesas.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 2/2] gpio: pcf857x: Add IRQF_SHARED when request irq
Date: Fri, 23 May 2014 11:27:27 +0530
Message-ID: <1400824647-2525-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400824647-2525-1-git-send-email-george.cherian@ti.com>
References: <1400824647-2525-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's quite possible that multiple pcf857x can be hooked up
to the same interrupt line with the processor. So add IRQF_SHARED
in request irq..

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/gpio/gpio-pcf857x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index 5acffed..27b4675 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -262,7 +262,7 @@ static int pcf857x_irq_domain_init(struct pcf857x *gpio,
 	/* enable real irq */
 	status = devm_request_threaded_irq(&client->dev, client->irq,
 				NULL, pcf857x_irq, IRQF_ONESHOT |
-				IRQF_TRIGGER_FALLING,
+				IRQF_TRIGGER_FALLING | IRQF_SHARED,
 				dev_name(&client->dev), gpio);
 
 	if (status)
-- 
1.8.3.1

