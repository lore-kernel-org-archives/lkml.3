Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaEGU1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:27:03 -0400
Received: from mail.ispras.ru ([83.149.199.45]:38767 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaEGU1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:27:01 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Felipe Balbi <balbi@ti.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Andreas Larsson <andreas@gaisler.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] usb: gadget: gr_udc: unconditionally use GFP_ATOMIC in gr_queue_ext()
Date: Thu,  8 May 2014 00:26:52 +0400
Message-Id: <1399494412-27056-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as gr_queue() is called with spinlock held,
we have to pass GFP_ATOMIC regardless of gfp argument.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/gadget/gr_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
index f984ee75324d..19a1b52c4210 100644
--- a/drivers/usb/gadget/gr_udc.c
+++ b/drivers/usb/gadget/gr_udc.c
@@ -1679,7 +1679,7 @@ static int gr_queue_ext(struct usb_ep *_ep, struct usb_request *_req,
 	if (ep->is_in)
 		gr_dbgprint_request("EXTERN", ep, req);
 
-	ret = gr_queue(ep, req, gfp_flags);
+	ret = gr_queue(ep, req, GFP_ATOMIC);
 
 	spin_unlock(&ep->dev->lock);
 
-- 
1.8.3.2

