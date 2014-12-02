Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938AbaLBT3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:29:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865AbaLBT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:27:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 022/121] USB: opticon: fix non-atomic allocation in write path
Date: Tue,  2 Dec 2014 11:18:21 -0800
Message-Id: <1417548000-1794-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit e681286de221af78fc85db9222b6a203148c005a upstream.

Write may be called from interrupt context so make sure to use
GFP_ATOMIC for all allocations in write.

Fixes: 0d930e51cfe6 ("USB: opticon: Add Opticon OPN2001 write support")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/opticon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index cbe779f..df495ea 100644
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
1.9.1

