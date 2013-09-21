Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3IUILH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 04:11:07 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:50343 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3IUILE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 04:11:04 -0400
Date: Sat, 21 Sep 2013 04:10:54 -0400
From: Alexey Pelykh <alexey.pelykh@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] OMAP/serial: Fix Mode13 vs Mode16 priority
Message-ID: <20130921081054.GA15775@inertiallabs-linux64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Pelykh <alexey.pelykh@gmail.com>

Make Mode16 more preferred than Mode13, to match TRM baudrates table.

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
index 7d348c8..146e712 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -247,7 +247,7 @@ serial_omap_baud_is_mode16(struct uart_port *port, unsigned int baud)
 	if(baudAbsDiff16 < 0)
 		baudAbsDiff16 = -baudAbsDiff16;
 
-	return (baudAbsDiff13 > baudAbsDiff16);
+	return (baudAbsDiff13 >= baudAbsDiff16);
 }
 
 /*

