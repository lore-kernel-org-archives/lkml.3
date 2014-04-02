Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbaDBT0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:26:49 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:56518 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888AbaDBT0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:26:48 -0400
From: Rabin Vincent <rabin@rab.in>
To: Felipe Balbi <balbi@ti.com>
Cc: Rabin Vincent <rabin@rab.in>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: musb: turn phy on
Date: Wed,  2 Apr 2014 21:26:27 +0200
Message-Id: <1396466787-19093-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

30a70b026b4cde4 ("usb: musb: fix obex in g_nokia.ko causing kernel
panic") broke USB gadget support on Pandaboard because it simply deletes
the call to phy_power_on() and the PHY is therefore never turned on.

Fix it by actually turning the phy on.

Cc: stable@vger.kernel.org
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 drivers/usb/musb/musb_gadget.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index d4aa779..09d5883 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1850,6 +1850,7 @@ static int musb_gadget_start(struct usb_gadget *g,
 	}
 
 	pm_runtime_get_sync(musb->controller);
+	phy_power_on(musb->phy);
 
 	dev_dbg(musb->controller, "registering driver %s\n", driver->function);
 
@@ -1963,6 +1964,7 @@ static int musb_gadget_stop(struct usb_gadget *g,
 	 * that currently misbehaves.
 	 */
 
+	phy_power_off(musb->phy);
 	pm_runtime_put(musb->controller);
 
 	return 0;
-- 
1.9.1

