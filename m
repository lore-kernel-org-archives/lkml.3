Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab3IYOjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:39:45 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:33225 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3IYOjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:39:44 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz, gregkh@linuxfoundation.org, harsh1kumar@gmail.com,
        ikerpedrosam@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        joe@perches.com
Subject: [PATCH v3 21/24] Staging: winbond: wb35tx: Replace printk with netdev
Date: Wed, 25 Sep 2013 16:39:29 +0200
Message-Id: <1380119969-21267-1-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379339024-12157-22-git-send-email-ikerpedrosam@gmail.com>
References: <1379339024-12157-22-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previously used printk lacked the warning level, now we've got a more accurate way to know the error.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/wb35tx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 8c25cbd..02e77de 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -32,7 +32,7 @@ static void Wb35Tx_complete(struct urb *pUrb)
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	struct wb35_mds *pMds = &adapter->Mds;
 
-	printk("wb35: tx complete\n");
+	netdev_dbg(pUrb->dev, "tx complete\n");
 	/* Variable setting */
 	pWb35Tx->EP4vm_state = VM_COMPLETED;
 	pWb35Tx->EP4VM_status = pUrb->status; /* Store the last result of Irp */
@@ -49,7 +49,7 @@ static void Wb35Tx_complete(struct urb *pUrb)
 
 	/* The URB is completed, check the result */
 	if (pWb35Tx->EP4VM_status != 0) {
-		printk("URB submission failed\n");
+		netdev_err(pUrb->dev, "URB submission failed\n");
 		pWb35Tx->EP4vm_state = VM_STOP;
 		goto error;
 	}
@@ -96,7 +96,7 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 	pWb35Tx->EP4vm_state = VM_RUNNING;
 	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
 	if (retv < 0) {
-		printk("EP4 Tx Irp sending error\n");
+		netdev_err(pUrb->dev, "EP4 Tx Irp sending error\n");
 		goto cleanup;
 	}
 
@@ -218,7 +218,7 @@ static void Wb35Tx_EP2VM_complete(struct urb *pUrb)
 
 	/* The Urb is completed, check the result */
 	if (pWb35Tx->EP2VM_status != 0) {
-		printk("EP2 IoCompleteRoutine return error\n");
+		netdev_err(pUrb->dev, "EP2 IoCompleteRoutine return error\n");
 		pWb35Tx->EP2vm_state = VM_STOP;
 		goto error;
 	}
-- 
1.8.1.2

