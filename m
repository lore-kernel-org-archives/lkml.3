Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3L2CKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:10:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55358 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500Ab3L2CKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:42 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Felipe Balbi" <balbi@ti.com>,
        "Michael Grzeschik" <m.grzeschik@pengutronix.de>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.913763610@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 092/185] usb: gadget: composite: reset delayed_status
 on reset_config
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 2bac51a1827a18821150ed8c9f9752c02f9c2b02 upstream.

The delayed_status value is used to keep track of status response
packets on ep0. It needs to be reset or the set_config function would
still delay the answer, if the usb device got unplugged while waiting
for setup_continue to be called.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/composite.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -585,6 +585,7 @@ static void reset_config(struct usb_comp
 		bitmap_zero(f->endpoints, 32);
 	}
 	cdev->config = NULL;
+	cdev->delayed_status = 0;
 }
 
 static int set_config(struct usb_composite_dev *cdev,

