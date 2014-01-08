Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbaAHWQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:16:03 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36703 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932351AbaAHWP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:15:57 -0500
From: Matthias Oefelein <ma.oefelein@arcor.de>
To: ma.oefelein@arcor.de
Cc: linux-kernel@rmueck.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] beeceem: Replace C99 comments with C89 ones and remove unneeded comments in InterfaceRx.c
Date: Wed,  8 Jan 2014 23:15:10 +0100
Message-Id: <1389219310-8015-7-git-send-email-ma.oefelein@arcor.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
References: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces C99-style with C89-style comments.
Additionally, code fragments that have been commented out are removed; the same applies to meaningless comments.

Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>
Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>

---
 drivers/staging/bcm/InterfaceRx.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceRx.c b/drivers/staging/bcm/InterfaceRx.c
index b556d73..1fba7d8 100644
--- a/drivers/staging/bcm/InterfaceRx.c
+++ b/drivers/staging/bcm/InterfaceRx.c
@@ -41,7 +41,6 @@ static void read_bulk_callback(struct urb *urb)
 	int QueueIndex = NO_OF_QUEUES + 1;
 	UINT uiIndex = 0;
 	int process_done = 1;
-	//int idleflag = 0 ;
 	struct bcm_usb_rcb *pRcb = (struct bcm_usb_rcb *)urb->context;
 	struct bcm_interface_adapter *psIntfAdapter = pRcb->psIntfAdapter;
 	struct bcm_mini_adapter *Adapter = psIntfAdapter->psAdapter;
@@ -101,7 +100,7 @@ static void read_bulk_callback(struct urb *urb)
 			bHeaderSupressionEnabled & Adapter->bPHSEnabled;
 	}
 
-	skb = dev_alloc_skb(pLeader->PLength + SKB_RESERVE_PHS_BYTES + SKB_RESERVE_ETHERNET_HEADER);//2   //2 for allignment
+	skb = dev_alloc_skb(pLeader->PLength + SKB_RESERVE_PHS_BYTES + SKB_RESERVE_ETHERNET_HEADER);
 	if (!skb) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "NO SKBUFF!!! Dropping the Packet");
 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
@@ -190,7 +189,7 @@ static int ReceiveRcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_us
 		retval = usb_submit_urb(urb, GFP_ATOMIC);
 		if (retval) {
 			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "failed submitting read urb, error %d", retval);
-			//if this return value is because of pipe halt. need to clear this.
+			/* if this return value is because of pipe halt. need to clear this. */
 			if (retval == -EPIPE) {
 				psIntfAdapter->psAdapter->bEndPointHalted = TRUE;
 				wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
@@ -220,15 +219,12 @@ bool InterfaceRx(struct bcm_interface_adapter *psIntfAdapter)
 	USHORT RxDescCount = NUM_RX_DESC - atomic_read(&psIntfAdapter->uNumRcbUsed);
 	struct bcm_usb_rcb *pRcb = NULL;
 
-//	RxDescCount = psIntfAdapter->psAdapter->CurrNumRecvDescs -
-//				psIntfAdapter->psAdapter->PrevNumRecvDescs;
 	while (RxDescCount) {
 		pRcb = GetBulkInRcb(psIntfAdapter);
 		if (pRcb == NULL) {
 			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0, "Unable to get Rcb pointer");
 			return false;
 		}
-		//atomic_inc(&psIntfAdapter->uNumRcbUsed);
 		ReceiveRcb(psIntfAdapter, pRcb);
 		RxDescCount--;
 	}
-- 
1.8.1.2

