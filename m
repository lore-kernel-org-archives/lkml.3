Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaHQAba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 20:31:30 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47677 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaHQAb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 20:31:29 -0400
Date: Sun, 17 Aug 2014 06:01:20 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>,
        Karsten Keil <isdn@linux-pingi.de>,
        gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] isdn/bas_gigaset: use USB API functions rather than constants
Message-ID: <20140817003120.GA11815@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of the function usb_endpoint_num.

The Coccinelle semantic patch that makes these changes is as follows:

@@ struct usb_endpoint_descriptor *epd; @@

- (epd->bEndpointAddress & \(USB_ENDPOINT_NUMBER_MASK\|0x0f\))
+ usb_endpoint_num(epd)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/isdn/gigaset/bas-gigaset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index b7ae0a0..aecec6d 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -2365,7 +2365,7 @@ static int gigaset_probe(struct usb_interface *interface,
 	endpoint = &hostif->endpoint[0].desc;
 	usb_fill_int_urb(ucs->urb_int_in, udev,
 			 usb_rcvintpipe(udev,
-					(endpoint->bEndpointAddress) & 0x0f),
+					usb_endpoint_num(endpoint)),
 			 ucs->int_in_buf, IP_MSGSIZE, read_int_callback, cs,
 			 endpoint->bInterval);
 	rc = usb_submit_urb(ucs->urb_int_in, GFP_KERNEL);
-- 
1.9.1

