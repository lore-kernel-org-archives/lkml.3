Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3IPNoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:44:38 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:44885 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab3IPNof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:44:35 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 21/24] Staging: winbond: wb35tx: Replace printk with netdev_err
Date: Mon, 16 Sep 2013 15:43:41 +0200
Message-Id: <1379339024-12157-22-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previously used printk lacked the warning level, now we've got a more accurate way to know the error.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/wb35tx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 8c25cbd..18b28f2 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -32,7 +32,7 @@ static void Wb35Tx_complete(struct urb *pUrb)
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	struct wb35_mds *pMds = &adapter->Mds;
 
-	printk("wb35: tx complete\n");
+	netdev_err(pUrb->dev, "wb35: tx complete\n");
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

