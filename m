Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaESTLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:11:45 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:33274 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaESTLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:11:43 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/5] usb: gadget: net2280: Refactor queues_show
Date: Mon, 19 May 2014 21:11:29 +0200
Message-Id: <1400526693-29776-2-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400526693-29776-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400526693-29776-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a long and ugly expresion with an already available function.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/net2280.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index bd851de..c3205ec 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -1777,15 +1777,7 @@ static ssize_t queues_show(struct device *_dev, struct device_attribute *attr,
 				"\n%s (ep%d%s-%s) max %04x %s fifo %d\n",
 				ep->ep.name, t & USB_ENDPOINT_NUMBER_MASK,
 				(t & USB_DIR_IN) ? "in" : "out",
-				({ char *val;
-				 switch (d->bmAttributes & 0x03) {
-				 case USB_ENDPOINT_XFER_BULK:
-					val = "bulk"; break;
-				 case USB_ENDPOINT_XFER_INT:
-					val = "intr"; break;
-				 default:
-					val = "iso"; break;
-				 } val; }),
+				type_string(d->bmAttributes),
 				usb_endpoint_maxp (d) & 0x1fff,
 				ep->dma ? "dma" : "pio", ep->fifo_size
 				);
-- 
2.0.0.rc2

