Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaKPWCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:02:10 -0500
Received: from 1wt.eu ([62.212.114.60]:48010 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbaKPWCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:02:07 -0500
Message-Id: <20141116215329.980290292@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:54:00 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <johan@kernel.org>, Willy Tarreau <w@1wt.eu>
Subject: [ 32/48] USB: kobil_sct: fix non-atomic allocation in write
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 path

From: Johan Hovold <johan@kernel.org>

Write may be called from interrupt context so make sure to use
GFP_ATOMIC for all allocations in write.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
(cherry picked from commit 191252837626fca0de694c18bb2aa64c118eda89)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/serial/kobil_sct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 929ceb1..935f6e31 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -464,7 +464,7 @@ static int kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
 			);
 
 			priv->cur_pos = priv->cur_pos + length;
-			result = usb_submit_urb(port->write_urb, GFP_NOIO);
+			result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
 			dbg("%s - port %d Send write URB returns: %i",
 					__func__, port->number, result);
 			todo = priv->filled - priv->cur_pos;
@@ -488,7 +488,7 @@ static int kobil_write(struct tty_struct *tty, struct usb_serial_port *port,
 			port->interrupt_in_urb->dev = port->serial->dev;
 
 			result = usb_submit_urb(port->interrupt_in_urb,
-								GFP_NOIO);
+								GFP_ATOMIC);
 			dbg("%s - port %d Send read URB returns: %i",
 					__func__, port->number, result);
 		}
-- 
1.7.12.2.21.g234cd45.dirty



