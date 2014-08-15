Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaHOQTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:19:05 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62858 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHOQTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:19:03 -0400
Date: Fri, 15 Aug 2014 21:48:53 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] media/rc/imon.c: use USB API functions rather than constants
Message-ID: <20140815161853.GA7058@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of the function usb_endpoint_type.

The Coccinelle semantic patch that makes these changes is as follows:

@@ struct usb_endpoint_descriptor *epd; @@

- (epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\))
+ usb_endpoint_type(epd)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/media/rc/imon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 7115e68..b0ed460 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2023,7 +2023,7 @@ static bool imon_find_endpoints(struct imon_context *ictx,
 	for (i = 0; i < num_endpts && !(ir_ep_found && display_ep_found); ++i) {
 		ep = &iface_desc->endpoint[i].desc;
 		ep_dir = ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK;
-		ep_type = ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
+		ep_type = usb_endpoint_type(ep);
 
 		if (!ir_ep_found && ep_dir == USB_DIR_IN &&
 		    ep_type == USB_ENDPOINT_XFER_INT) {
-- 
1.9.1

