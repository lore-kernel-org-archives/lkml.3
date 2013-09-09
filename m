Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3IIQJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:09:29 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:50666 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3IIQIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:08:50 -0400
From: Paul Chavent <Paul.Chavent@onera.fr>
To: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH 5/5] USB : serial : pl2303 wake up after dcd status check.
Date: Mon,  9 Sep 2013 18:01:20 +0200
Message-Id: <1378742480-2146-6-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
References: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Mon, 09 Sep 2013 18:08:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems to be done this way in other drivers (ch341, 8250, ...).

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
---
 drivers/usb/serial/pl2303.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 3299f3a..6bb405b 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -853,11 +853,11 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 	spin_unlock_irqrestore(&priv->lock, flags);
 	if (priv->line_status & UART_BREAK_ERROR)
 		usb_serial_handle_break(port);
-	wake_up_interruptible(&port->port.delta_msr_wait);
-
 	if ((priv->line_status ^ prev_line_status) & UART_DCD)
 		usb_serial_handle_dcd_change(port,
 				priv->line_status & UART_DCD);
+
+	wake_up_interruptible(&port->port.delta_msr_wait);
 }
 
 static void pl2303_read_int_callback(struct urb *urb)
-- 
1.7.12.1

