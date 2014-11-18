Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaKROce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:32:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117AbaKROKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:15 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 169/206] USB: opticon: fix non-atomic allocation in write path
Date: Tue, 18 Nov 2014 15:08:44 +0100
Message-Id: <b7b72e586240ab69fc5bc30c65005bebae0f8793.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e681286de221af78fc85db9222b6a203148c005a upstream.

Write may be called from interrupt context so make sure to use
GFP_ATOMIC for all allocations in write.

Fixes: 0d930e51cfe6 ("USB: opticon: Add Opticon OPN2001 write support")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/opticon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index cbe779f578f9..df495ea0d977 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -219,7 +219,7 @@ static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
 
 	/* The conncected devices do not have a bulk write endpoint,
 	 * to transmit data to de barcode device the control endpoint is used */
-	dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
+	dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_ATOMIC);
 	if (!dr) {
 		dev_err(&port->dev, "out of memory\n");
 		count = -ENOMEM;
-- 
2.1.3

