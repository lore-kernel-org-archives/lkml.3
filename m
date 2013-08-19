Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750891Ab3HSGYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:24:38 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4862 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3HSGYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:24:36 -0400
From: Maarten ter Huurne <maarten@treewalker.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH] USB: musb: Avoid null pointer dereference in debug logging
Date: Mon, 19 Aug 2013 08:24:08 +0200
Message-Id: <1376893448-27740-1-git-send-email-maarten@treewalker.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <52114574.3060701@cogentembedded.com>
References: <52114574.3060701@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 511f3c53 (usb: gadget: udc-core: fix a regression during
gadget driver unbinding) usb_gadget_remove_driver will pass NULL for
the driver argument.

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
---
 drivers/usb/musb/musb_gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index ba70923..82e5386 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1935,7 +1935,8 @@ static int musb_gadget_stop(struct usb_gadget *g,
 	stop_activity(musb, driver);
 	otg_set_peripheral(musb->xceiv->otg, NULL);
 
-	dev_dbg(musb->controller, "unregistering driver %s\n", driver->function);
+	dev_dbg(musb->controller, "unregistering driver %s\n",
+				  driver ? driver->function : "(removed)");
 
 	musb->is_active = 0;
 	musb->gadget_driver = NULL;
-- 
1.8.1.4

