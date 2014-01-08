Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbaAHWRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:17:00 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36686 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932317AbaAHWP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:15:56 -0500
From: Matthias Oefelein <ma.oefelein@arcor.de>
To: ma.oefelein@arcor.de
Cc: linux-kernel@rmueck.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] beeceem: Fix whitespace issues at opening parentheses in InterfaceRx.c
Date: Wed,  8 Jan 2014 23:15:08 +0100
Message-Id: <1389219310-8015-5-git-send-email-ma.oefelein@arcor.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
References: <1389219310-8015-1-git-send-email-ma.oefelein@arcor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most spaces before opening parentheses (where required) are missing here.
This patch adds spaces at the appropriate spots.

Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>
Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>

---
 drivers/staging/bcm/InterfaceRx.c | 64 +++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceRx.c b/drivers/staging/bcm/InterfaceRx.c
index 5ebcf9b..12921a4 100644
--- a/drivers/staging/bcm/InterfaceRx.c
+++ b/drivers/staging/bcm/InterfaceRx.c
@@ -4,8 +4,8 @@ static int SearchVcid(struct bcm_mini_adapter *Adapter, unsigned short usVcid)
 {
 	int iIndex = 0;
 
-	for(iIndex = (NO_OF_QUEUES-1); iIndex >= 0; iIndex--)
-		if(Adapter->PackInfo[iIndex].usVCID_Value == usVcid)
+	for (iIndex = (NO_OF_QUEUES-1); iIndex >= 0; iIndex--)
+		if (Adapter->PackInfo[iIndex].usVCID_Value == usVcid)
 			return iIndex;
 	return NO_OF_QUEUES+1;
 
@@ -18,8 +18,8 @@ GetBulkInRcb(struct bcm_interface_adapter *psIntfAdapter)
 	struct bcm_usb_rcb *pRcb = NULL;
 	UINT index = 0;
 
-	if((atomic_read(&psIntfAdapter->uNumRcbUsed) < MAXIMUM_USB_RCB) &&
-	   (psIntfAdapter->psAdapter->StopAllXaction == false))
+	if ((atomic_read(&psIntfAdapter->uNumRcbUsed) < MAXIMUM_USB_RCB) &&
+	    (psIntfAdapter->psAdapter->StopAllXaction == false))
 	{
 		index = atomic_read(&psIntfAdapter->uCurrRcb);
 		pRcb = &psIntfAdapter->asUsbRcb[index];
@@ -52,18 +52,18 @@ static void read_bulk_callback(struct urb *urb)
 		pr_info(PFX "%s: rx urb status %d length %d\n",
 			Adapter->dev->name, urb->status, urb->actual_length);
 
-	if((Adapter->device_removed == TRUE) ||
-	   (TRUE == Adapter->bEndPointHalted) ||
-	   (0 == urb->actual_length))
+	if ((Adapter->device_removed == TRUE) ||
+	    (TRUE == Adapter->bEndPointHalted) ||
+	    (0 == urb->actual_length))
 	{
 		pRcb->bUsed = false;
 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
 
-	if(urb->status != STATUS_SUCCESS)
+	if (urb->status != STATUS_SUCCESS)
 	{
-		if(urb->status == -EPIPE)
+		if (urb->status == -EPIPE)
 		{
 			Adapter->bEndPointHalted = TRUE;
 			wake_up(&Adapter->tx_packet_wait_queue);
@@ -78,21 +78,21 @@ static void read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	if(Adapter->bDoSuspend && (Adapter->bPreparingForLowPowerMode))
+	if (Adapter->bDoSuspend && (Adapter->bPreparingForLowPowerMode))
 	{
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "device is going in low power mode while PMU option selected..hence rx packet should not be process");
 		return;
 	}
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Read back done len %d\n", pLeader->PLength);
-	if(!pLeader->PLength)
+	if (!pLeader->PLength)
 	{
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader Length 0");
 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader Status:0x%hX, Length:0x%hX, VCID:0x%hX", pLeader->Status, pLeader->PLength, pLeader->Vcid);
-	if(MAX_CNTL_PKT_SIZE < pLeader->PLength)
+	if (MAX_CNTL_PKT_SIZE < pLeader->PLength)
 	{
 		if (netif_msg_rx_err(Adapter))
 			pr_info(PFX "%s: corrupted leader length...%d\n",
@@ -102,8 +102,8 @@ static void read_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	QueueIndex = SearchVcid( Adapter, pLeader->Vcid);
-	if(QueueIndex < NO_OF_QUEUES)
+	QueueIndex = SearchVcid(Adapter, pLeader->Vcid);
+	if (QueueIndex < NO_OF_QUEUES)
 	{
 		bHeaderSupressionEnabled =
 			Adapter->PackInfo[QueueIndex].bHeaderSuppressionEnabled;
@@ -111,16 +111,16 @@ static void read_bulk_callback(struct urb *urb)
 			bHeaderSupressionEnabled & Adapter->bPHSEnabled;
 	}
 
-	skb = dev_alloc_skb (pLeader->PLength + SKB_RESERVE_PHS_BYTES + SKB_RESERVE_ETHERNET_HEADER);//2   //2 for allignment
-	if(!skb)
+	skb = dev_alloc_skb(pLeader->PLength + SKB_RESERVE_PHS_BYTES + SKB_RESERVE_ETHERNET_HEADER);//2   //2 for allignment
+	if (!skb)
 	{
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "NO SKBUFF!!! Dropping the Packet");
 		atomic_dec(&psIntfAdapter->uNumRcbUsed);
 		return;
 	}
 	/* If it is a control Packet, then call handle_bcm_packet ()*/
-	if((ntohs(pLeader->Vcid) == VCID_CONTROL_PACKET) ||
-	   (!(pLeader->Status >= 0x20  &&  pLeader->Status <= 0x3F)))
+	if ((ntohs(pLeader->Vcid) == VCID_CONTROL_PACKET) ||
+	    (!(pLeader->Status >= 0x20  &&  pLeader->Status <= 0x3F)))
 	{
 		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_CTRL, DBG_LVL_ALL, "Received control pkt...");
 		*(PUSHORT)skb->data = pLeader->Status;
@@ -147,19 +147,19 @@ static void read_bulk_callback(struct urb *urb)
 		skb->dev = Adapter->dev;
 
 		/* currently skb->len has extra ETH_HLEN bytes in the beginning */
-		skb_put (skb, pLeader->PLength + ETH_HLEN);
+		skb_put(skb, pLeader->PLength + ETH_HLEN);
 		Adapter->PackInfo[QueueIndex].uiTotalRxBytes += pLeader->PLength;
 		Adapter->PackInfo[QueueIndex].uiThisPeriodRxBytes += pLeader->PLength;
 		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);
 
-		if(netif_running(Adapter->dev))
+		if (netif_running(Adapter->dev))
 		{
 			/* Moving ahead by ETH_HLEN to the data ptr as received from FW */
 			skb_pull(skb, ETH_HLEN);
 			PHSReceive(Adapter, pLeader->Vcid, skb, &skb->len,
 				   NULL, bHeaderSupressionEnabled);
 
-			if(!Adapter->PackInfo[QueueIndex].bEthCSSupport)
+			if (!Adapter->PackInfo[QueueIndex].bEthCSSupport)
 			{
 				skb_push(skb, ETH_HLEN);
 
@@ -183,10 +183,10 @@ static void read_bulk_callback(struct urb *urb)
 		++Adapter->dev->stats.rx_packets;
 		Adapter->dev->stats.rx_bytes += pLeader->PLength;
 
-		for(uiIndex = 0; uiIndex < MIBS_MAX_HIST_ENTRIES; uiIndex++)
+		for (uiIndex = 0; uiIndex < MIBS_MAX_HIST_ENTRIES; uiIndex++)
 		{
-			if((pLeader->PLength <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1)) &&
-			   (pLeader->PLength > MIBS_PKTSIZEHIST_RANGE*(uiIndex)))
+			if ((pLeader->PLength <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1)) &&
+			    (pLeader->PLength > MIBS_PKTSIZEHIST_RANGE*(uiIndex)))
 				Adapter->aRxPktSizeHist[uiIndex]++;
 		}
 	}
@@ -202,17 +202,17 @@ static int ReceiveRcb(struct bcm_interface_adapter *psIntfAdapter, struct bcm_us
 
 	usb_fill_bulk_urb(urb, psIntfAdapter->udev, usb_rcvbulkpipe(psIntfAdapter->udev, psIntfAdapter->sBulkIn.bulk_in_endpointAddr),
 			  urb->transfer_buffer, BCM_USB_MAX_READ_LENGTH, read_bulk_callback, pRcb);
-	if(false == psIntfAdapter->psAdapter->device_removed &&
-	   false == psIntfAdapter->psAdapter->bEndPointHalted &&
-	   false == psIntfAdapter->bSuspended &&
-	   false == psIntfAdapter->bPreparingForBusSuspend)
+	if (false == psIntfAdapter->psAdapter->device_removed &&
+	    false == psIntfAdapter->psAdapter->bEndPointHalted &&
+	    false == psIntfAdapter->bSuspended &&
+	    false == psIntfAdapter->bPreparingForBusSuspend)
 	{
 		retval = usb_submit_urb(urb, GFP_ATOMIC);
 		if (retval)
 		{
 			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "failed submitting read urb, error %d", retval);
 			//if this return value is because of pipe halt. need to clear this.
-			if(retval == -EPIPE)
+			if (retval == -EPIPE)
 			{
 				psIntfAdapter->psAdapter->bEndPointHalted = TRUE;
 				wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
@@ -237,17 +237,17 @@ Return:				TRUE  - If Rx was successful.
 					Other - If an error occurred.
 */
 
-bool InterfaceRx (struct bcm_interface_adapter *psIntfAdapter)
+bool InterfaceRx(struct bcm_interface_adapter *psIntfAdapter)
 {
 	USHORT RxDescCount = NUM_RX_DESC - atomic_read(&psIntfAdapter->uNumRcbUsed);
 	struct bcm_usb_rcb *pRcb = NULL;
 
 //	RxDescCount = psIntfAdapter->psAdapter->CurrNumRecvDescs -
 //				psIntfAdapter->psAdapter->PrevNumRecvDescs;
-	while(RxDescCount)
+	while (RxDescCount)
 	{
 		pRcb = GetBulkInRcb(psIntfAdapter);
-		if(pRcb == NULL)
+		if (pRcb == NULL)
 		{
 			BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0, "Unable to get Rcb pointer");
 			return false;
-- 
1.8.1.2

