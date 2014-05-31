Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaEaQWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 12:22:18 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:34209 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaEaQWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 12:22:16 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/11 V2] via-ircc: Remove useless return variables
Date: Sat, 31 May 2014 13:21:59 -0300
Message-Id: <1401553319-11763-1-git-send-email-peter.senna@gmail.com>
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
    when strict
return
- ret
+ C
;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
Changes from V1:
 - Moved comment about return value to near the return value

 drivers/net/irda/via-ircc.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/irda/via-ircc.c b/drivers/net/irda/via-ircc.c
index 2900af0..5a5e17b 100644
--- a/drivers/net/irda/via-ircc.c
+++ b/drivers/net/irda/via-ircc.c
@@ -510,10 +510,8 @@ static void via_hw_init(struct via_ircc_cb *self)
  */
 static int via_ircc_read_dongle_id(int iobase)
 {
-	int dongle_id = 9;	/* Default to IBM */
-
 	IRDA_ERROR("via-ircc: dongle probing not supported, please specify dongle_id module parameter.\n");
-	return dongle_id;
+	return 9;	/* Default to IBM */
 }
 
 /*
@@ -926,7 +924,6 @@ static int via_ircc_dma_xmit(struct via_ircc_cb *self, u16 iobase)
 static int via_ircc_dma_xmit_complete(struct via_ircc_cb *self)
 {
 	int iobase;
-	int ret = TRUE;
 	u8 Tx_status;
 
 	IRDA_DEBUG(3, "%s()\n", __func__);
@@ -983,7 +980,7 @@ F01_E*/
 	// Tell the network layer, that we can accept more frames 
 	netif_wake_queue(self->netdev);
 //F01   }
-	return ret;
+	return TRUE;
 }
 
 /*
