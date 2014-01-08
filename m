Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565AbaAHWP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:15:58 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36663 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757364AbaAHWPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:15:53 -0500
From: Matthias Oefelein <ma.oefelein@arcor.de>
To: ma.oefelein@arcor.de
Cc: linux-kernel@rmueck.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] beeceem: Fix missing spaces around operators and unwanted spaces around semicolons in InterfaceRx.c
Date: Wed,  8 Jan 2014 23:15:05 +0100
Message-Id: <1389219310-8015-2-git-send-email-ma.oefelein@arcor.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
References: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch reports missing spaces around operators; this patch introduces spaces where needed.
Spaces before semicolons are prohibited by the official coding style guidelines, those have been fixed as well.

Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>
Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>

---
 drivers/staging/bcm/InterfaceRx.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceRx.c b/drivers/staging/bcm/InterfaceRx.c
index f2973f5..55f7436 100644
--- a/drivers/staging/bcm/InterfaceRx.c
+++ b/drivers/staging/bcm/InterfaceRx.c
@@ -2,9 +2,9 @@
 
 static int SearchVcid(struct bcm_mini_adapter *Adapter,unsigned short usVcid)
 {
-	int iIndex=0;
+	int iIndex = 0;
 
-	for(iIndex=(NO_OF_QUEUES-1);iIndex>=0;iIndex--)
+	for(iIndex = (NO_OF_QUEUES-1); iIndex >= 0; iIndex--)
 		if(Adapter->PackInfo[iIndex].usVCID_Value == usVcid)
 			return iIndex;
 	return NO_OF_QUEUES+1;
@@ -24,7 +24,7 @@ GetBulkInRcb(struct bcm_interface_adapter *psIntfAdapter)
 		index = atomic_read(&psIntfAdapter->uCurrRcb);
 		pRcb = &psIntfAdapter->asUsbRcb[index];
 		pRcb->bUsed = TRUE;
-		pRcb->psIntfAdapter= psIntfAdapter;
+		pRcb->psIntfAdapter = psIntfAdapter;
 		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Got Rx desc %d used %d",
 			index, atomic_read(&psIntfAdapter->uNumRcbUsed));
 		index = (index + 1) % MAXIMUM_USB_RCB;
@@ -40,7 +40,7 @@ static void read_bulk_callback(struct urb *urb)
 	struct sk_buff *skb = NULL;
 	bool bHeaderSupressionEnabled = false;
 	int QueueIndex = NO_OF_QUEUES + 1;
-	UINT uiIndex=0;
+	UINT uiIndex = 0;
 	int process_done = 1;
 	//int idleflag = 0 ;
 	struct bcm_usb_rcb *pRcb = (struct bcm_usb_rcb *)urb->context;
@@ -66,7 +66,7 @@ static void read_bulk_callback(struct urb *urb)
 	{
 		if(urb->status == -EPIPE)
 		{
-			Adapter->bEndPointHalted = TRUE ;
+			Adapter->bEndPointHalted = TRUE;
 			wake_up(&Adapter->tx_packet_wait_queue);
 		}
 		else
@@ -75,14 +75,14 @@ static void read_bulk_callback(struct urb *urb)
 		}
 		pRcb->bUsed = false;
  		atomic_dec(&psIntfAdapter->uNumRcbUsed);
-		urb->status = STATUS_SUCCESS ;
-		return ;
+		urb->status = STATUS_SUCCESS;
+		return;
 	}
 
 	if(Adapter->bDoSuspend && (Adapter->bPreparingForLowPowerMode))
 	{
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL,"device is going in low power mode while PMU option selected..hence rx packet should not be process");
-		return ;
+		return;
 	}
 
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Read back done len %d\n", pLeader->PLength);
@@ -149,8 +149,8 @@ static void read_bulk_callback(struct urb *urb)
 
 		/* currently skb->len has extra ETH_HLEN bytes in the beginning */
 		skb_put (skb, pLeader->PLength + ETH_HLEN);
-		Adapter->PackInfo[QueueIndex].uiTotalRxBytes+=pLeader->PLength;
-		Adapter->PackInfo[QueueIndex].uiThisPeriodRxBytes+= pLeader->PLength;
+		Adapter->PackInfo[QueueIndex].uiTotalRxBytes += pLeader->PLength;
+		Adapter->PackInfo[QueueIndex].uiThisPeriodRxBytes += pLeader->PLength;
         BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);
 
 		if(netif_running(Adapter->dev))
@@ -169,7 +169,7 @@ static void read_bulk_callback(struct urb *urb)
 				(*(skb->data+11))++;
 				*(skb->data+12) = 0x08;
 				*(skb->data+13) = 0x00;
-				pLeader->PLength+=ETH_HLEN;
+				pLeader->PLength += ETH_HLEN;
 			}
 
 			skb->protocol = eth_type_trans(skb, Adapter->dev);
@@ -184,7 +184,7 @@ static void read_bulk_callback(struct urb *urb)
 		++Adapter->dev->stats.rx_packets;
 		Adapter->dev->stats.rx_bytes += pLeader->PLength;
 
-		for(uiIndex = 0 ; uiIndex < MIBS_MAX_HIST_ENTRIES ; uiIndex++)
+		for(uiIndex = 0; uiIndex < MIBS_MAX_HIST_ENTRIES; uiIndex++)
 		{
 			if((pLeader->PLength <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1))
 				&& (pLeader->PLength > MIBS_PKTSIZEHIST_RANGE*(uiIndex)))
@@ -217,7 +217,7 @@ static int ReceiveRcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_us
 			//if this return value is because of pipe halt. need to clear this.
 			if(retval == -EPIPE)
 			{
-				psIntfAdapter->psAdapter->bEndPointHalted = TRUE ;
+				psIntfAdapter->psAdapter->bEndPointHalted = TRUE;
 				wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
 			}
 
-- 
1.8.1.2

