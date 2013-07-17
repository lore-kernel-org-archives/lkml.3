Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3GQN3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:29:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47268 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab3GQN3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:29:30 -0400
From: Alexander Savchenko <oleksandr.savchenko@ti.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ruchika Kharwar <ruchika@ti.com>,
        Alexander Savchenko <oleksandr.savchenko@ti.com>
Subject: [PATCH] serial: omap: Fix IRQ handling return value
Date: Wed, 17 Jul 2013 16:29:13 +0300
Message-ID: <1374067753-29560-1-git-send-email-oleksandr.savchenko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ruchika Kharwar <ruchika@ti.com>

Ensure the Interrupt handling routine return IRQ_HANDLED vs
IRQ_NONE.

Signed-off-by: Ruchika Kharwar <ruchika@ti.com>
Signed-off-by: Alexander Savchenko <oleksandr.savchenko@ti.com>
---
 drivers/tty/serial/omap-serial.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index b6d1728..70feeb3 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -479,7 +479,6 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
 	struct uart_omap_port *up = dev_id;
 	unsigned int iir, lsr;
 	unsigned int type;
-	irqreturn_t ret = IRQ_NONE;
 	int max_count = 256;
 
 	spin_lock(&up->port.lock);
@@ -490,7 +489,6 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
 		if (iir & UART_IIR_NO_INT)
 			break;
 
-		ret = IRQ_HANDLED;
 		lsr = serial_in(up, UART_LSR);
 
 		/* extract IRQ type from IIR register */
@@ -529,7 +527,7 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
 	pm_runtime_put_autosuspend(up->dev);
 	up->port_activity = jiffies;
 
-	return ret;
+	return IRQ_HANDLED;
 }
 
 static unsigned int serial_omap_tx_empty(struct uart_port *port)
-- 
1.7.9.5

