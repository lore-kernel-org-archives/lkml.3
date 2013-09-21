Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3IUIEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 04:04:48 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:58670 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3IUIEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 04:04:44 -0400
Date: Sat, 21 Sep 2013 04:04:35 -0400
From: Alexey Pelykh <alexey.pelykh@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] OMAP/serial: Fix misnamed variable
Message-ID: <20130921080435.GA15678@inertiallabs-linux64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Pelykh <alexey.pelykh@gmail.com>

Fix misnamed variable to eliminate confusion.

Signed-off-by: Alexey Pelykh <alexey.pelykh@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 808a880..7d348c8 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -258,13 +258,13 @@ serial_omap_baud_is_mode16(struct uart_port *port, unsigned int baud)
 static unsigned int
 serial_omap_get_divisor(struct uart_port *port, unsigned int baud)
 {
-	unsigned int divisor;
+	unsigned int mode;
 
 	if (!serial_omap_baud_is_mode16(port, baud))
-		divisor = 13;
+		mode = 13;
 	else
-		divisor = 16;
-	return port->uartclk/(baud * divisor);
+		mode = 16;
+	return port->uartclk/(mode * baud);
 }
 
 static void serial_omap_enable_ms(struct uart_port *port)

