Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbaJAGHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:07:33 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:58382 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbaJAGHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:07:32 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Michael Buesch <m@bues.ch>,
        netdev@vger.kernel.org
Subject: [PATCH] ssb: gpio: remove use of gpiochip_remove() retval
Date: Wed,  1 Oct 2014 11:41:02 +0530
Message-Id: <1412143862-20866-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of using return value from gpiochip_remove() as it returns
void with a new change in kernel.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Michael Buesch <m@bues.ch>
Cc: netdev@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/ssb/driver_gpio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ssb/driver_gpio.c b/drivers/ssb/driver_gpio.c
index ba350d2..f92e266 100644
--- a/drivers/ssb/driver_gpio.c
+++ b/drivers/ssb/driver_gpio.c
@@ -475,7 +475,8 @@ int ssb_gpio_unregister(struct ssb_bus *bus)
 {
 	if (ssb_chipco_available(&bus->chipco) ||
 	    ssb_extif_available(&bus->extif)) {
-		return gpiochip_remove(&bus->gpio);
+		gpiochip_remove(&bus->gpio);
+		return 0;
 	} else {
 		SSB_WARN_ON(1);
 	}
-- 
1.7.9.5

