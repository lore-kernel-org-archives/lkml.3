Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaF1Mpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 08:45:54 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:16120 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbaF1Mpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 08:45:52 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUHAJ24rlNbsk2v/2dsb2JhbABagw2regUBAQEBAQEFAW0BmQKBCBd1hDEvI4ECGC4JiC4DFQG+PQ2GUheFZIZ7giYdhC0FmF+Bfo1rhhCCAIFEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 1/1] drivers/usb/serial/mos7840.c: remove unnecessary null test before kfree
Date: Sat, 28 Jun 2014 14:44:09 +0200
Message-Id: <1403959449-5986-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/usb/serial/mos7840.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 393be56..3d88eef 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1181,10 +1181,7 @@ static void mos7840_close(struct usb_serial_port *port)
 	/* Freeing Write URBs */
 	for (j = 0; j < NUM_URBS; ++j) {
 		if (mos7840_port->write_urb_pool[j]) {
-			if (mos7840_port->write_urb_pool[j]->transfer_buffer)
-				kfree(mos7840_port->write_urb_pool[j]->
-				      transfer_buffer);
-
+			kfree(mos7840_port->write_urb_pool[j]->transfer_buffer);
 			usb_free_urb(mos7840_port->write_urb_pool[j]);
 		}
 	}
-- 
1.8.4.5

