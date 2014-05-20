Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaETKew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:34:52 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:36809 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaETKeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:34:07 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] staging: ozwpan: Remove useless return variables
Date: Tue, 20 May 2014 12:33:47 +0200
Message-Id: <1400582028-24990-7-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove variables that are initialized with a constant,
are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret = C;
... when != ret
- return ret;
+ return C;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/staging/ozwpan/ozhcd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index b3d401a..7be0058 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1997,7 +1997,6 @@ static void oz_get_hub_descriptor(struct usb_hcd *hcd,
 static int oz_set_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 {
 	struct oz_port *port;
-	int err = 0;
 	u8 port_id = (u8)windex;
 	struct oz_hcd *ozhcd = oz_hcd_private(hcd);
 	unsigned set_bits = 0;
@@ -2064,7 +2063,7 @@ static int oz_set_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 		spin_unlock_bh(&port->port_lock);
 	}
 	oz_dbg(HUB, "Port[%d] status = 0x%x\n", port_id, port->status);
-	return err;
+	return 0;
 }
 
 /*
@@ -2073,7 +2072,6 @@ static int oz_set_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 static int oz_clear_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 {
 	struct oz_port *port;
-	int err = 0;
 	u8 port_id = (u8)windex;
 	struct oz_hcd *ozhcd = oz_hcd_private(hcd);
 	unsigned clear_bits = 0;
@@ -2140,7 +2138,7 @@ static int oz_clear_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 	}
 	oz_dbg(HUB, "Port[%d] status = 0x%x\n",
 	       port_id, ozhcd->ports[port_id-1].status);
-	return err;
+	return 0;
 }
 
 /*

