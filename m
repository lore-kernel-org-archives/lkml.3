Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaDAQzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:55:52 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:50968 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaDAQzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:55:33 -0400
Message-ID: <d1fd86bea365da71b62b082545b0ddd9@mwinf5d45.me-wanadoo.net>
From: Thomas Vegas <thomas_75@safe-mail.net>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Date: Tue, 1 Apr 2014 18:29:37 +0200
Subject: [PATCH v4 3/3] staging: serqt_usb2: Clean up initializations of variables
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more common kernel coding style.

Signed-off-by: Thomas Vegas <thomas_75@safe-mail.net>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index f329cb4..998c384 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -990,16 +990,10 @@ static void qt_block_until_empty(struct tty_struct *tty,
 static void qt_close(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
-	struct quatech_port *qt_port;
-	struct quatech_port *port0;
-	struct tty_struct *tty;
-	unsigned int index;
-
-	tty = tty_port_tty_get(&port->port);
-	index = port->port_number;
-
-	qt_port = qt_get_port_private(port);
-	port0 = qt_get_port_private(serial->port[0]);
+	struct tty_struct *tty = tty_port_tty_get(&port->port);
+	unsigned int index = port->port_number;
+	struct quatech_port *qt_port = qt_get_port_private(port);
+	struct quatech_port *port0 = qt_get_port_private(serial->port[0]);
 
 	/* shutdown any bulk reads that might be going on */
 	if (serial->num_bulk_out)
-- 
1.7.2.5

