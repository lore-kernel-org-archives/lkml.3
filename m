Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab3FKU3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:29:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab3FKUDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 13/32] USB: whiteheat: fix broken port configuration
Date: Tue, 11 Jun 2013 13:03:12 -0700
Message-Id: <20130611200127.691921994@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611200126.214442788@linuxfoundation.org>
References: <20130611200126.214442788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 9eecf22d2b375b9064a20421c6c307b760b03d46 upstream.

When configuring the port (e.g. set_termios) the port minor number
rather than the port number was used in the request (and they only
coincide for minor number 0).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/whiteheat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -1154,7 +1154,7 @@ static void firm_setup_port(struct tty_s
 	struct whiteheat_port_settings port_settings;
 	unsigned int cflag = tty->termios->c_cflag;
 
-	port_settings.port = port->number + 1;
+	port_settings.port = port->number - port->serial->minor + 1;
 
 	/* get the byte size */
 	switch (cflag & CSIZE) {


