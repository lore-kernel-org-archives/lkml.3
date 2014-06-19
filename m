Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbaFSTpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:45:23 -0400
Received: from mail.ispras.ru ([83.149.199.45]:39352 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbaFSTpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:45:22 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Mosberger-Tang <davidm@egauge.net>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] usb: host: max3421-hcd: unconditionally use GFP_ATOMIC in max3421_urb_enqueue()
Date: Thu, 19 Jun 2014 23:44:57 +0400
Message-Id: <1403207097-12124-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as kzalloc() is called with spinlock held,
we have to pass GFP_ATOMIC regardless of mem_flags argument.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/host/max3421-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 858efcfda50b..ed22424dbec7 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1551,7 +1551,7 @@ max3421_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flags)
 	max3421_ep = urb->ep->hcpriv;
 	if (!max3421_ep) {
 		/* gets freed in max3421_endpoint_disable: */
-		max3421_ep = kzalloc(sizeof(struct max3421_ep), mem_flags);
+		max3421_ep = kzalloc(sizeof(struct max3421_ep), GFP_ATOMIC);
 		if (!max3421_ep) {
 			retval = -ENOMEM;
 			goto out;
-- 
1.9.1

