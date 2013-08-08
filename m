Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966043Ab3HHRfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:35:39 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48411 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965963Ab3HHRfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:35:36 -0400
Message-ID: <5203D6E4.9080201@gmail.com>
Date: Thu, 08 Aug 2013 18:35:32 +0100
From: Paul McQuade <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: Linux-Devel <devel@driverdev.osuosl.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Review [2/2] Staging: BCM: Removed more whitespace/Errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 9f6231ce16996e35545e20ce1d91abc058f2a6fb Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Thu, 8 Aug 2013 17:49:22 +0100
Subject: [PATCH 2/2] Staging: BCM: Removed more whitespace/Errors

Interface Whitespace/Errors Removed with the help of checkpatch.pl

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
  drivers/staging/bcm/InterfaceMacros.h |    6 +-
  drivers/staging/bcm/InterfaceMisc.h   |   14 +--
  drivers/staging/bcm/InterfaceRx.c     |  166 
++++++++++++++-------------------
  drivers/staging/bcm/InterfaceTx.c     |  135 +++++++++++----------------
  4 files changed, 136 insertions(+), 185 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceMacros.h 
b/drivers/staging/bcm/InterfaceMacros.h
index 7001caf..efa528e 100644
--- a/drivers/staging/bcm/InterfaceMacros.h
+++ b/drivers/staging/bcm/InterfaceMacros.h
@@ -3,14 +3,14 @@

  #define BCM_USB_MAX_READ_LENGTH 2048

-#define MAXIMUM_USB_TCB      128
-#define MAXIMUM_USB_RCB      128
+#define MAXIMUM_USB_TCB            128
+#define MAXIMUM_USB_RCB            128

  #define MAX_BUFFERS_PER_QUEUE   256

  #define MAX_DATA_BUFFER_SIZE    2048

-//Num of Asynchronous reads pending
+/* Num of Asynchronous reads pending */
  #define NUM_RX_DESC 64

  #define SYS_CFG 0x0F000C00
diff --git a/drivers/staging/bcm/InterfaceMisc.h 
b/drivers/staging/bcm/InterfaceMisc.h
index bce6869..cb3e0cc 100644
--- a/drivers/staging/bcm/InterfaceMisc.h
+++ b/drivers/staging/bcm/InterfaceMisc.h
@@ -14,13 +14,13 @@ InterfaceWRM(struct bcm_interface_adapter 
*psIntfAdapter,
              INT len);


-int InterfaceFileDownload( PVOID psIntfAdapter,
-                        struct file *flp,
-                        unsigned int on_chip_loc);
+int InterfaceFileDownload(PVOID psIntfAdapter,
+                        struct file *flp,
+                        unsigned int on_chip_loc);

-int InterfaceFileReadbackFromChip( PVOID psIntfAdapter,
-                        struct file *flp,
-                        unsigned int on_chip_loc);
+int InterfaceFileReadbackFromChip(PVOID psIntfAdapter,
+                        struct file *flp,
+                        unsigned int on_chip_loc);


  int BcmRDM(PVOID arg,
@@ -39,4 +39,4 @@ VOID Bcm_kill_all_URBs(struct bcm_interface_adapter 
*psIntfAdapter);

  #define DISABLE_USB_ZERO_LEN_INT 0x0F011878

-#endif // __INTERFACE_MISC_H
+#endif /* __INTERFACE_MISC_H */
diff --git a/drivers/staging/bcm/InterfaceRx.c 
b/drivers/staging/bcm/InterfaceRx.c
index 26f5bc7..6b155c5 100644
--- a/drivers/staging/bcm/InterfaceRx.c
+++ b/drivers/staging/bcm/InterfaceRx.c
@@ -1,11 +1,11 @@
  #include "headers.h"

-static int SearchVcid(struct bcm_mini_adapter *Adapter,unsigned short 
usVcid)
+static int SearchVcid(struct bcm_mini_adapter *Adapter, unsigned short 
usVcid)
  {
-    int iIndex=0;
+    int iIndex = 0;

-    for(iIndex=(NO_OF_QUEUES-1);iIndex>=0;iIndex--)
-        if(Adapter->PackInfo[iIndex].usVCID_Value == usVcid)
+    for (iIndex = (NO_OF_QUEUES-1); iIndex >= 0; iIndex--)
+        if (Adapter->PackInfo[iIndex].usVCID_Value == usVcid)
              return iIndex;
      return NO_OF_QUEUES+1;

@@ -18,14 +18,13 @@ GetBulkInRcb(struct bcm_interface_adapter 
*psIntfAdapter)
      struct bcm_usb_rcb *pRcb = NULL;
      UINT index = 0;

-    if((atomic_read(&psIntfAdapter->uNumRcbUsed) < MAXIMUM_USB_RCB) &&
-        (psIntfAdapter->psAdapter->StopAllXaction == FALSE))
-    {
+    if ((atomic_read(&psIntfAdapter->uNumRcbUsed) < MAXIMUM_USB_RCB) &&
+        (psIntfAdapter->psAdapter->StopAllXaction == FALSE)) {
          index = atomic_read(&psIntfAdapter->uCurrRcb);
          pRcb = &psIntfAdapter->asUsbRcb[index];
          pRcb->bUsed = TRUE;
-        pRcb->psIntfAdapter= psIntfAdapter;
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DPC, 
DBG_LVL_ALL, "Got Rx desc %d used %d",
+        pRcb->psIntfAdapter = psIntfAdapter;
+        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DPC, 
DBG_LVL_ALL, "Got Rx desc %d used %d",
              index, atomic_read(&psIntfAdapter->uNumRcbUsed));
          index = (index + 1) % MAXIMUM_USB_RCB;
          atomic_set(&psIntfAdapter->uCurrRcb, index);
@@ -40,9 +39,9 @@ static void read_bulk_callback(struct urb *urb)
      struct sk_buff *skb = NULL;
      BOOLEAN bHeaderSupressionEnabled = FALSE;
      int QueueIndex = NO_OF_QUEUES + 1;
-    UINT uiIndex=0;
+    UINT uiIndex = 0;
      int process_done = 1;
-    //int idleflag = 0 ;
+    /*int idleflag = 0; */
      struct bcm_usb_rcb *pRcb = (struct bcm_usb_rcb *)urb->context;
      struct bcm_interface_adapter *psIntfAdapter = pRcb->psIntfAdapter;
      struct bcm_mini_adapter *Adapter = psIntfAdapter->psAdapter;
@@ -52,49 +51,40 @@ static void read_bulk_callback(struct urb *urb)
          pr_info(PFX "%s: rx urb status %d length %d\n",
              Adapter->dev->name, urb->status, urb->actual_length);

-    if((Adapter->device_removed == TRUE)  ||
+    if ((Adapter->device_removed == TRUE)  ||
          (TRUE == Adapter->bEndPointHalted) ||
-        (0 == urb->actual_length)
-        )
-    {
-         pRcb->bUsed = FALSE;
-         atomic_dec(&psIntfAdapter->uNumRcbUsed);
+        (0 == urb->actual_length)) {
+        pRcb->bUsed = FALSE;
+        atomic_dec(&psIntfAdapter->uNumRcbUsed);
          return;
      }

-    if(urb->status != STATUS_SUCCESS)
-    {
-        if(urb->status == -EPIPE)
-        {
+    if (urb->status != STATUS_SUCCESS) {
+        if (urb->status == -EPIPE) {
              Adapter->bEndPointHalted = TRUE ;
              wake_up(&Adapter->tx_packet_wait_queue);
          }
          pRcb->bUsed = FALSE;
-         atomic_dec(&psIntfAdapter->uNumRcbUsed);
+        atomic_dec(&psIntfAdapter->uNumRcbUsed);
          urb->status = STATUS_SUCCESS ;
-        return ;
+        return;
      }

-    if(Adapter->bDoSuspend && (Adapter->bPreparingForLowPowerMode))
-    {
-        BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, 
DBG_LVL_ALL,"device is going in low power mode while PMU option 
selected..hence rx packet should not be process");
-        return ;
+    if (Adapter->bDoSuspend && (Adapter->bPreparingForLowPowerMode)) {
+        BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, 
"device is going in low power mode while PMU option selected..hence rx 
packet should not be process");
+        return;
      }

-    BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Read 
back done len %d\n", pLeader->PLength);
-    if(!pLeader->PLength)
-    {
-        BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, 
"Leader Length 0");
+    BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Read 
back done len %d\n", pLeader->PLength);
+    if (!pLeader->PLength) {
+        BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, 
"Leader Length 0");
          atomic_dec(&psIntfAdapter->uNumRcbUsed);
          return;
      }
-    BCM_DEBUG_PRINT(Adapter,DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader 
Status:0x%hX, Length:0x%hX, VCID:0x%hX", 
pLeader->Status,pLeader->PLength,pLeader->Vcid);
-    if(MAX_CNTL_PKT_SIZE < pLeader->PLength)
-    {
+    BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Leader 
Status:0x%hX, Length:0x%hX, VCID:0x%hX", pLeader->Status, 
pLeader->PLength, pLeader->Vcid);
+    if (MAX_CNTL_PKT_SIZE < pLeader->PLength) {
          if (netif_msg_rx_err(Adapter))
              pr_info(PFX "%s: corrupted leader length...%d\n",
                  Adapter->dev->name, pLeader->PLength);
@@ -103,65 +93,58 @@ static void read_bulk_callback(struct urb *urb)
          return;
      }

-    QueueIndex = SearchVcid( Adapter,pLeader->Vcid);
-    if(QueueIndex < NO_OF_QUEUES)
-    {
+    QueueIndex = SearchVcid(Adapter, pLeader->Vcid);
+    if (QueueIndex < NO_OF_QUEUES) {
          bHeaderSupressionEnabled =
  Adapter->PackInfo[QueueIndex].bHeaderSuppressionEnabled;
          bHeaderSupressionEnabled =
              bHeaderSupressionEnabled & Adapter->bPHSEnabled;
      }

-    skb = dev_alloc_skb (pLeader->PLength + SKB_RESERVE_PHS_BYTES + 
SKB_RESERVE_ETHERNET_HEADER);//2   //2 for allignment
-    if(!skb)
-    {
-        BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "NO SKBUFF!!! 
Dropping the Packet");
+    skb = dev_alloc_skb (pLeader->PLength + SKB_RESERVE_PHS_BYTES + 
SKB_RESERVE_ETHERNET_HEADER);/*2  2 for allignment*/
+    if (!skb) {
+        BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "NO SKBUFF!!! 
Dropping the Packet");
          atomic_dec(&psIntfAdapter->uNumRcbUsed);
          return;
      }
      /* If it is a control Packet, then call handle_bcm_packet ()*/
-    if((ntohs(pLeader->Vcid) == VCID_CONTROL_PACKET) ||
-        (!(pLeader->Status >= 0x20  && pLeader->Status <= 0x3F)))
-    {
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_CTRL, 
DBG_LVL_ALL, "Received control pkt...");
+    if ((ntohs(pLeader->Vcid) == VCID_CONTROL_PACKET) ||
+        (!(pLeader->Status >= 0x20  && pLeader->Status <= 0x3F))) {
+        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_CTRL, 
DBG_LVL_ALL, "Received control pkt...");
          *(PUSHORT)skb->data = pLeader->Status;
-           memcpy(skb->data+sizeof(USHORT), urb->transfer_buffer +
+        memcpy(skb->data + sizeof(USHORT), urb->transfer_buffer +
              (sizeof(struct bcm_leader)), pLeader->PLength);
          skb->len = pLeader->PLength + sizeof(USHORT);

          spin_lock(&Adapter->control_queue_lock);
-  ENQUEUEPACKET(Adapter->RxControlHead,Adapter->RxControlTail,skb);
+        ENQUEUEPACKET(Adapter->RxControlHead, Adapter->RxControlTail, skb);
          spin_unlock(&Adapter->control_queue_lock);

          atomic_inc(&Adapter->cntrlpktCnt);
          wake_up(&Adapter->process_rx_cntrlpkt);

-        /*
-          * Data Packet, Format a proper Ethernet Header
-              * and give it to the stack
-          */
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, 
DBG_LVL_ALL, "Received Data pkt...");
+    /*
+     * Data Packet, Format a proper Ethernet Header
+    * and give it to the stack
+     */
+        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, 
DBG_LVL_ALL, "Received Data pkt...");
          skb_reserve(skb, 2 + SKB_RESERVE_PHS_BYTES);
          memcpy(skb->data+ETH_HLEN, (PUCHAR)urb->transfer_buffer + 
sizeof(struct bcm_leader), pLeader->PLength);
          skb->dev = Adapter->dev;

          /* currently skb->len has extra ETH_HLEN bytes in the beginning */
          skb_put (skb, pLeader->PLength + ETH_HLEN);
-  Adapter->PackInfo[QueueIndex].uiTotalRxBytes+=pLeader->PLength;
-        Adapter->PackInfo[QueueIndex].uiThisPeriodRxBytes+= 
pLeader->PLength;
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DATA, 
DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);
+        Adapter->PackInfo[QueueIndex].uiTotalRxBytes += pLeader->PLength;
+        Adapter->PackInfo[QueueIndex].uiThisPeriodRxBytes += 
pLeader->PLength;
+        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, RX_DATA, 
DBG_LVL_ALL, "Received Data pkt of len :0x%X", pLeader->PLength);

-        if(netif_running(Adapter->dev))
-        {
+        if (netif_running(Adapter->dev)) {
              /* Moving ahead by ETH_HLEN to the data ptr as received 
from FW */
              skb_pull(skb, ETH_HLEN);
              PHSReceive(Adapter, pLeader->Vcid, skb, &skb->len,
-                    NULL,bHeaderSupressionEnabled);
+                    NULL, bHeaderSupressionEnabled);

-            if(!Adapter->PackInfo[QueueIndex].bEthCSSupport)
-            {
+            if (!Adapter->PackInfo[QueueIndex].bEthCSSupport) {
                  skb_push(skb, ETH_HLEN);

                  memcpy(skb->data, skb->dev->dev_addr, 6);
@@ -169,29 +152,25 @@ static void read_bulk_callback(struct urb *urb)
                  (*(skb->data+11))++;
                  *(skb->data+12) = 0x08;
                  *(skb->data+13) = 0x00;
-                pLeader->PLength+=ETH_HLEN;
+                pLeader->PLength += ETH_HLEN;
              }
-
              skb->protocol = eth_type_trans(skb, Adapter->dev);
              process_done = netif_rx(skb);

              dev_kfree_skb(skb);
          }

          ++Adapter->dev->stats.rx_packets;
          Adapter->dev->stats.rx_bytes += pLeader->PLength;

-        for(uiIndex = 0 ; uiIndex < MIBS_MAX_HIST_ENTRIES ; uiIndex++)
-        {
-            if((pLeader->PLength <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1))
+        for (uiIndex = 0 ; uiIndex < MIBS_MAX_HIST_ENTRIES ; uiIndex++) {
+            if ((pLeader->PLength <= MIBS_PKTSIZEHIST_RANGE*(uiIndex+1))
                  && (pLeader->PLength > MIBS_PKTSIZEHIST_RANGE*(uiIndex)))
                  Adapter->aRxPktSizeHist[uiIndex]++;
          }
      }
-     Adapter->PrevNumRecvDescs++;
+    Adapter->PrevNumRecvDescs++;
      pRcb->bUsed = FALSE;
      atomic_dec(&psIntfAdapter->uNumRcbUsed);
  }
@@ -202,21 +181,17 @@ static int ReceiveRcb(struct bcm_interface_adapter 
*psIntfAdapter, struct bcm_us
      int retval = 0;

      usb_fill_bulk_urb(urb, psIntfAdapter->udev, usb_rcvbulkpipe(
-            psIntfAdapter->udev, 
psIntfAdapter->sBulkIn.bulk_in_endpointAddr),
-              urb->transfer_buffer, BCM_USB_MAX_READ_LENGTH, 
read_bulk_callback,
+            psIntfAdapter->udev, 
psIntfAdapter->sBulkIn.bulk_in_endpointAddr), urb->transfer_buffer, 
BCM_USB_MAX_READ_LENGTH, read_bulk_callback,
              pRcb);
-    if(FALSE == psIntfAdapter->psAdapter->device_removed &&
+    if (FALSE == psIntfAdapter->psAdapter->device_removed &&
         FALSE == psIntfAdapter->psAdapter->bEndPointHalted &&
         FALSE == psIntfAdapter->bSuspended &&
-       FALSE == psIntfAdapter->bPreparingForBusSuspend)
-    {
+       FALSE == psIntfAdapter->bPreparingForBusSuspend) {
          retval = usb_submit_urb(urb, GFP_ATOMIC);
-        if (retval)
-        {
-  BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_RX, RX_DPC, 
DBG_LVL_ALL, "failed submitting read urb, error %d", retval);
-            //if this return value is because of pipe halt. need to 
clear this.
-            if(retval == -EPIPE)
-            {
+        if (retval) {
+            BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_RX, 
RX_DPC, DBG_LVL_ALL, "failed submitting read urb, error %d", retval);
+            /* if this return value is because of pipe halt. need to 
clear this.*/
+            if (retval == -EPIPE) {
                  psIntfAdapter->psAdapter->bEndPointHalted = TRUE ;
  wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
              }
@@ -245,17 +220,16 @@ BOOLEAN InterfaceRx (struct bcm_interface_adapter 
*psIntfAdapter)
      USHORT RxDescCount = NUM_RX_DESC - 
atomic_read(&psIntfAdapter->uNumRcbUsed);
      struct bcm_usb_rcb *pRcb = NULL;

-//    RxDescCount = psIntfAdapter->psAdapter->CurrNumRecvDescs -
-//                psIntfAdapter->psAdapter->PrevNumRecvDescs;
-    while(RxDescCount)
-    {
+/*    RxDescCount = psIntfAdapter->psAdapter->CurrNumRecvDescs -
+*                psIntfAdapter->psAdapter->PrevNumRecvDescs;
+*/
+    while (RxDescCount) {
          pRcb = GetBulkInRcb(psIntfAdapter);
-        if(pRcb == NULL)
-        {
-  BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_PRINTK, 0, 0, 
"Unable to get Rcb pointer");
+        if (pRcb == NULL) {
+            BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 
0, 0, "Unable to get Rcb pointer");
              return FALSE;
          }
-        //atomic_inc(&psIntfAdapter->uNumRcbUsed);
+        /*atomic_inc(&psIntfAdapter->uNumRcbUsed);*/
          ReceiveRcb(psIntfAdapter, pRcb);
          RxDescCount--;
      }
diff --git a/drivers/staging/bcm/InterfaceTx.c 
b/drivers/staging/bcm/InterfaceTx.c
index b8c7855..5b6828b 100644
--- a/drivers/staging/bcm/InterfaceTx.c
+++ b/drivers/staging/bcm/InterfaceTx.c
@@ -3,7 +3,7 @@
  /*this is transmit call-back(BULK OUT)*/
  static void write_bulk_callback(struct urb *urb/*, struct pt_regs *regs*/)
  {
-    struct bcm_usb_tcb *pTcb= (struct bcm_usb_tcb *)urb->context;
+    struct bcm_usb_tcb *pTcb = (struct bcm_usb_tcb *)urb->context;
      struct bcm_interface_adapter *psIntfAdapter = pTcb->psIntfAdapter;
      struct bcm_link_request *pControlMsg = (struct bcm_link_request 
*)urb->transfer_buffer;
      struct bcm_mini_adapter *psAdapter = psIntfAdapter->psAdapter ;
@@ -13,16 +13,12 @@ static void write_bulk_callback(struct urb *urb/*, 
struct pt_regs *regs*/)
      if (unlikely(netif_msg_tx_done(Adapter)))
          pr_info(PFX "%s: transmit status %d\n", Adapter->dev->name, 
urb->status);

-    if(urb->status != STATUS_SUCCESS)
-    {
-        if(urb->status == -EPIPE)
-        {
+    if (urb->status != STATUS_SUCCESS) {
+        if (urb->status == -EPIPE) {
              psIntfAdapter->psAdapter->bEndPointHalted = TRUE ;
  wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
          }
      }

@@ -31,69 +27,59 @@ static void write_bulk_callback(struct urb *urb/*, 
struct pt_regs *regs*/)



-    if(TRUE == psAdapter->bPreparingForLowPowerMode)
-    {
-
-        if(((pControlMsg->szData[0] == GO_TO_IDLE_MODE_PAYLOAD) &&
-            (pControlMsg->szData[1] == TARGET_CAN_GO_TO_IDLE_MODE)))
+    if (TRUE == psAdapter->bPreparingForLowPowerMode) {

-        {
+        if (((pControlMsg->szData[0] == GO_TO_IDLE_MODE_PAYLOAD) &&
+            (pControlMsg->szData[1] == TARGET_CAN_GO_TO_IDLE_MODE))) {
              bpowerDownMsg = TRUE ;
-            //This covers the bus err while Idle Request msg sent down.
-            if(urb->status != STATUS_SUCCESS)
-            {
+            /* This covers the bus err while Idle Request msg sent down.*/
+            if (urb->status != STATUS_SUCCESS) {
                  psAdapter->bPreparingForLowPowerMode = FALSE ;
-                BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL,"Idle Mode Request msg failed to reach to Modem");
-                //Signalling the cntrl pkt path in Ioctl
+                BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL, "Idle Mode Request msg failed to reach to Modem");
+                /* Signalling the cntrl pkt path in Ioctl */
  wake_up(&psAdapter->lowpower_mode_wait_queue);
                  StartInterruptUrb(psIntfAdapter);
                  goto err_exit;
              }

-            if(psAdapter->bDoSuspend == FALSE)
-            {
+            if (psAdapter->bDoSuspend == FALSE) {
                  psAdapter->IdleMode = TRUE;
-                //since going in Idle mode completed hence making this 
var false;
+                /* since going in Idle mode completed hence making this 
var false;*/
                  psAdapter->bPreparingForLowPowerMode = FALSE ;

-                BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL, "Host Entered in Idle Mode State...");
-                //Signalling the cntrl pkt path in Ioctl
+                BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL, "Host Entered in Idle Mode State...");
+                /*Signalling the cntrl pkt path in Ioctl */
  wake_up(&psAdapter->lowpower_mode_wait_queue);
              }

              (pControlMsg->szData[0] == LINK_UP_ACK) &&
              (pControlMsg->szData[1] == 
LINK_SHUTDOWN_REQ_FROM_FIRMWARE)  &&
-            (pControlMsg->szData[2] == SHUTDOWN_ACK_FROM_DRIVER))
-        {
-            //This covers the bus err while shutdown Request msg sent down.
-            if(urb->status != STATUS_SUCCESS)
-            {
+            (pControlMsg->szData[2] == SHUTDOWN_ACK_FROM_DRIVER)) {
+            /*This covers the bus err while shutdown Request msg sent 
down.*/
+            if (urb->status != STATUS_SUCCESS) {
                  psAdapter->bPreparingForLowPowerMode = FALSE ;
-                BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL,"Shutdown Request Msg failed to reach to Modem");
-                //Signalling the cntrl pkt path in Ioctl
+                BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL, "Shutdown Request Msg failed to reach to Modem");
+                /*Signalling the cntrl pkt path in Ioctl*/
  wake_up(&psAdapter->lowpower_mode_wait_queue);
                  StartInterruptUrb(psIntfAdapter);
                  goto err_exit;
              }

              bpowerDownMsg = TRUE ;
-            if(psAdapter->bDoSuspend == FALSE)
-            {
+            if (psAdapter->bDoSuspend == FALSE) {
                  psAdapter->bShutStatus = TRUE;
-                //since going in shutdown mode completed hence making 
this var false;
+                /*since going in shutdown mode completed hence making 
this var false;*/
                  psAdapter->bPreparingForLowPowerMode = FALSE ;
-                BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL,"Host Entered in shutdown Mode State...");
-                //Signalling the cntrl pkt path in Ioctl
+                BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL, "Host Entered in shutdown Mode State...");
+                /*Signalling the cntrl pkt path in Ioctl*/
  wake_up(&psAdapter->lowpower_mode_wait_queue);
              }
          }

-        if(psAdapter->bDoSuspend && bpowerDownMsg)
-        {
-            //issuing bus suspend request
-            BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL,"Issuing the Bus suspend request to USB stack");
+        if (psAdapter->bDoSuspend && bpowerDownMsg)    {
+            /*issuing bus suspend request*/
+            BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL, "Issuing the Bus suspend request to USB stack");
              psIntfAdapter->bPreparingForBusSuspend = TRUE;
              schedule_work(&psIntfAdapter->usbSuspendWork);

@@ -101,9 +87,9 @@ static void write_bulk_callback(struct urb *urb/*, 
struct pt_regs *regs*/)

      }

-err_exit :
+err_exit:
      usb_free_coherent(urb->dev, urb->transfer_buffer_length,
-             urb->transfer_buffer, urb->transfer_dma);
+    urb->transfer_buffer, urb->transfer_dma);
  }


@@ -112,15 +98,15 @@ static struct bcm_usb_tcb *GetBulkOutTcb(struct 
bcm_interface_adapter *psIntfAda
      struct bcm_usb_tcb *pTcb = NULL;
      UINT index = 0;

-    if((atomic_read(&psIntfAdapter->uNumTcbUsed) < MAXIMUM_USB_TCB) &&
-        (psIntfAdapter->psAdapter->StopAllXaction ==FALSE))
-    {
+    if ((atomic_read(&psIntfAdapter->uNumTcbUsed) < MAXIMUM_USB_TCB) &&
+        (psIntfAdapter->psAdapter->StopAllXaction == FALSE)) {
          index = atomic_read(&psIntfAdapter->uCurrTcb);
          pTcb = &psIntfAdapter->asUsbTcb[index];
          pTcb->bUsed = TRUE;
-        pTcb->psIntfAdapter= psIntfAdapter;
-        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_TX, 
NEXT_SEND, DBG_LVL_ALL, "Got Tx desc %d used %d",
-            index, atomic_read(&psIntfAdapter->uNumTcbUsed));
+        pTcb->psIntfAdapter = psIntfAdapter;
+    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, NEXT_SEND,
+    DBG_LVL_ALL, "Got Tx desc %d used %d",
+        index, atomic_read(&psIntfAdapter->uNumTcbUsed));
          index = (index + 1) % MAXIMUM_USB_TCB;
          atomic_set(&psIntfAdapter->uCurrTcb, index);
          atomic_inc(&psIntfAdapter->uNumTcbUsed);
@@ -134,44 +120,36 @@ static int TransmitTcb(struct 
bcm_interface_adapter *psIntfAdapter, struct bcm_u
      struct urb *urb = pTcb->urb;
      int retval = 0;

-    urb->transfer_buffer = usb_alloc_coherent(psIntfAdapter->udev, len,
-                         GFP_ATOMIC, &urb->transfer_dma);
-    if (!urb->transfer_buffer)
-    {
-  BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_PRINTK, 0, 0, 
"Error allocating memory\n");
+    urb->transfer_buffer = usb_alloc_coherent(psIntfAdapter->udev, len, 
GFP_ATOMIC, &urb->transfer_dma);
+    if (!urb->transfer_buffer) {
+        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 
0, "Error allocating memory\n");
          return  -ENOMEM;
      }
      memcpy(urb->transfer_buffer, data, len);
      urb->transfer_buffer_length = len;

-    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL, "Sending Bulk out packet\n");
-    //For T3B,INT OUT end point will be used as bulk out end point
-    if((psIntfAdapter->psAdapter->chip_id == T3B) && 
(psIntfAdapter->bHighSpeedDevice == TRUE))
-    {
+    BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL, "Sending Bulk out packet\n");
+    /*For T3B,INT OUT end point will be used as bulk out end point*/
+    if ((psIntfAdapter->psAdapter->chip_id == T3B) && 
(psIntfAdapter->bHighSpeedDevice == TRUE)) {
          usb_fill_int_urb(urb, psIntfAdapter->udev,

      usb_fill_bulk_urb(urb, psIntfAdapter->udev,
            psIntfAdapter->sBulkOut.bulk_out_pipe,
            urb->transfer_buffer, len, write_bulk_callback, pTcb);
      }
      urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP; /* For DMA transfer */

-    if(FALSE == psIntfAdapter->psAdapter->device_removed &&
+    if (FALSE == psIntfAdapter->psAdapter->device_removed &&
         FALSE == psIntfAdapter->psAdapter->bEndPointHalted &&
         FALSE == psIntfAdapter->bSuspended &&
-       FALSE == psIntfAdapter->bPreparingForBusSuspend)
-    {
+       FALSE == psIntfAdapter->bPreparingForBusSuspend) {
          retval = usb_submit_urb(urb, GFP_ATOMIC);
-        if (retval)
-        {
-  BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_TX, NEXT_SEND, 
DBG_LVL_ALL, "failed submitting write urb, error %d", retval);
-            if(retval == -EPIPE)
-            {
+        if (retval)    {
+            BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_TX, 
NEXT_SEND, DBG_LVL_ALL, "failed submitting write urb, error %d", retval);
+            if (retval == -EPIPE) {
                  psIntfAdapter->psAdapter->bEndPointHalted = TRUE ;
  wake_up(&psIntfAdapter->psAdapter->tx_packet_wait_queue);
              }
@@ -182,13 +160,12 @@ static int TransmitTcb(struct 
bcm_interface_adapter *psIntfAdapter, struct bcm_u

  int InterfaceTransmitPacket(PVOID arg, PVOID data, UINT len)
  {
-    struct bcm_usb_tcb *pTcb= NULL;
+    struct bcm_usb_tcb *pTcb = NULL;

      struct bcm_interface_adapter *psIntfAdapter = (struct 
bcm_interface_adapter *)arg;
-    pTcb= GetBulkOutTcb(psIntfAdapter);
-    if(pTcb == NULL)
-    {
-  BCM_DEBUG_PRINT(psIntfAdapter->psAdapter,DBG_TYPE_PRINTK, 0, 0, "No 
URB to transmit packet, dropping packet");
+    pTcb = GetBulkOutTcb(psIntfAdapter);
+    if (pTcb == NULL) {
+        BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 
0, "No URB to transmit packet, dropping packet");
          return -EFAULT;
      }
      return TransmitTcb(psIntfAdapter, pTcb, data, len);
-- 
1.7.10.4

