Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab3IUHnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 03:43:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42370 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3IUHnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 03:43:53 -0400
Date: Sat, 21 Sep 2013 03:43:44 -0400
From: Alexey Pelykh <alexey.pelykh@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] OMAP/serial: Fix division by zero exception on 3M+ baud rates
Message-ID: <20130921074344.GA15524@inertiallabs-linux64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Pelykh <alexey.pelykh@gmail.com>

Fixes issue with division-by-zero exception, that occurred when a baud rate higher than 3Mbaud was requested.

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
index 816d1a2..808a880 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -240,8 +240,8 @@ serial_omap_baud_is_mode16(struct uart_port *port, unsigned int baud)
 {
 	unsigned int n13 = port->uartclk / (13 * baud);
 	unsigned int n16 = port->uartclk / (16 * baud);
-	int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
-	int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
+	int baudAbsDiff13 = n13 ? (baud - (port->uartclk / (13 * n13))) : INT_MAX;
+	int baudAbsDiff16 = n16 ? (baud - (port->uartclk / (16 * n16))) : INT_MAX;
 	if(baudAbsDiff13 < 0)
 		baudAbsDiff13 = -baudAbsDiff13;
 	if(baudAbsDiff16 < 0)

