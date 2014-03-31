Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaCaS0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:26:44 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:51420 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbaCaS0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:26:43 -0400
Message-ID: <fc172535ee81e02ac60a290f9d5f5fd4@mwinf5d64.me-wanadoo.net>
From: Thomas Vegas <thomas_75@safe-mail.net>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Date: Mon, 31 Mar 2014 19:50:22 +0200
Subject: [PATCH v3 2/2] staging: serqt_usb2: Clean up initializations of variables.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more common kernel coding style.

Signed-off-by: Thomas Vegas <thomas_75@safe-mail.net>
---
 drivers/staging/serqt_usb2/serqt_usb2.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index a04cfc3..35d84fd 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -990,18 +990,11 @@ static void qt_block_until_empty(struct tty_struct *tty,
 static void qt_close(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
-	struct quatech_port *qt_port;
-	struct quatech_port *port0;
-	struct tty_struct *tty;
+	struct tty_struct *tty = tty_port_tty_get(&port->port);
+	unsigned int index = port->port_number;
+	struct quatech_port *qt_port = qt_get_port_private(port);
+	struct quatech_port *port0 = qt_get_port_private(serial->port[0]);
 	int status;
-	unsigned int index;
-	status = 0;
-
-	tty = tty_port_tty_get(&port->port);
-	index = port->port_number;
-
-	qt_port = qt_get_port_private(port);
-	port0 = qt_get_port_private(serial->port[0]);
 
 	/* shutdown any bulk reads that might be going on */
 	if (serial->num_bulk_out)
-- 
1.8.3.2

