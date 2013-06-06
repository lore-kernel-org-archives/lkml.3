Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab3FFLdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:33:25 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49462 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592Ab3FFLdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:33:21 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tobias Winter <tobias@linuxdingsda.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, Johan Hovold <jhovold@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] USB: whiteheat: fix broken port configuration
Date: Thu,  6 Jun 2013 13:32:47 +0200
Message-Id: <1370518367-2631-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <20130606113106.GI2566@localhost>
References: <20130606113106.GI2566@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When configuring the port (e.g. set_termios) the port minor number
rather than the port number was used in the request (and they only
coincide for minor number 0).

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/whiteheat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index b9fca35..347caad 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -649,7 +649,7 @@ static void firm_setup_port(struct tty_struct *tty)
 	struct whiteheat_port_settings port_settings;
 	unsigned int cflag = tty->termios.c_cflag;
 
-	port_settings.port = port->number + 1;
+	port_settings.port = port->number - port->serial->minor + 1;
 
 	/* get the byte size */
 	switch (cflag & CSIZE) {
-- 
1.8.2.1

