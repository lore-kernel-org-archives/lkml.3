Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaCaHKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:10:03 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:30546 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaCaHKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:10:00 -0400
Message-ID: <f10faefdec9dffd231e8e020c2b6af38@mwinf5d69.me-wanadoo.net>
From: Thomas Vegas <thomas_75@safe-mail.net>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Date: Mon, 31 Mar 2014 08:51:04 +0200
Subject: [PATCH v2] staging: serqt_usb2: Fix coding style issues.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add blank lines after declarations and cleanup initializations.

Signed-off-by: Thomas Vegas <thomas_75@safe-mail.net>
---
 drivers/staging/serqt_usb2/serqt_usb2.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 0267dd8..10a7240 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -990,18 +990,11 @@ static void qt_block_until_empty(struct tty_struct *tty,
 static void qt_close(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
-	struct quatech_port *qt_port;
-	struct quatech_port *port0;
-	struct tty_struct *tty;
+	struct quatech_port *qt_port = qt_get_port_private(port);
+	struct quatech_port *port0 = qt_get_port_private(serial->port[0]);
+	struct tty_struct *tty = tty_port_tty_get(&port->port);
 	int status;
-	unsigned int index;
-	status = 0;
-
-	tty = tty_port_tty_get(&port->port);
-	index = port->port_number;
-
-	qt_port = qt_get_port_private(port);
-	port0 = qt_get_port_private(serial->port[0]);
+	unsigned int index = port->port_number;
 
 	/* shutdown any bulk reads that might be going on */
 	if (serial->num_bulk_out)
@@ -1030,7 +1023,6 @@ static void qt_close(struct usb_serial_port *port)
 			dev_dbg(&port->dev, "Shutdown interrupt_in_urb\n");
 			usb_kill_urb(serial->port[0]->interrupt_in_urb);
 		}
-
 	}
 
 	if (qt_port->write_urb) {
@@ -1268,9 +1260,9 @@ static void qt_set_termios(struct tty_struct *tty,
 	if (I_IXOFF(tty) || I_IXON(tty)) {
 		unsigned char stop_char = STOP_CHAR(tty);
 		unsigned char start_char = START_CHAR(tty);
-		status =
-		    box_set_sw_flow_ctrl(port->serial, index, stop_char,
-				      start_char);
+
+		status = box_set_sw_flow_ctrl(port->serial, index, stop_char,
+					      start_char);
 		if (status < 0)
 			dev_dbg(&port->dev,
 				"box_set_sw_flow_ctrl (enabled) failed\n");
-- 
1.8.3.2

