Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3HATvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:51:06 -0400
Received: from mail.ispras.ru ([83.149.199.45]:36368 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab3HATvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:51:05 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>, Felipe Balbi <balbi@ti.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] usb: gadget: amd5536udc: unconditionally use GFP_ATOMIC in udc_queue()
Date: Thu,  1 Aug 2013 23:50:47 +0400
Message-Id: <1375386647-32478-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as prep_dma() is called with spinlock held,
we have to pass GFP_ATOMIC regardless of gfp argument.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/gadget/amd5536udc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index f52dcfe..a9a4346 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -1122,7 +1122,7 @@ udc_queue(struct usb_ep *usbep, struct usb_request *usbreq, gfp_t gfp)
 			goto finished;
 		}
 		if (ep->dma) {
-			retval = prep_dma(ep, req, gfp);
+			retval = prep_dma(ep, req, GFP_ATOMIC);
 			if (retval != 0)
 				goto finished;
 			/* write desc pointer to enable DMA */
@@ -1190,7 +1190,7 @@ udc_queue(struct usb_ep *usbep, struct usb_request *usbreq, gfp_t gfp)
 		 * for PPB modes, because of chain creation reasons
 		 */
 		if (ep->in) {
-			retval = prep_dma(ep, req, gfp);
+			retval = prep_dma(ep, req, GFP_ATOMIC);
 			if (retval != 0)
 				goto finished;
 		}
-- 
1.8.1.2

