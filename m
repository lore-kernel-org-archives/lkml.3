Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966052AbaFTP5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:57:25 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33862 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834AbaFTPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:47:50 -0400
From: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: christian.bay@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lisa@xenapiadmin.com, daeseok.youn@gmail.com, luiorpe1@gmail.com,
        veeableful@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, martin.gumbrecht@googlemail.com
Subject: [PATCH v2 6/7] Staging: bcm: Qos.c: fix checkpatch errors: comments
Date: Fri, 20 Jun 2014 17:38:03 +0200
Message-Id: <1403278684-10891-7-git-send-email-martin.gumbrecht@googlemail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
References: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves coding style in Qos.c
Comments according to the coding guideline

Signed-off-by: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
Signed-off-by: Christian Bay <christian.bay@studium.fau.de>
---
 drivers/staging/bcm/Qos.c | 88 +++++++++++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index 0c742da..f9c57ee 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -1,6 +1,6 @@
 /**
-@file Qos.C
-This file contains the routines related to Quality of Service.
+ * @file Qos.C
+ * This file contains the routines related to Quality of Service.
 */
 #include "headers.h"
 
@@ -191,9 +191,9 @@ bool MatchDestPort(struct bcm_classifier_rule *pstClassifierRule, USHORT ushDest
 	return false;
 }
 /**
-@ingroup tx_functions
-Compares IPV4 Ip address and port number
-@return Queue Index.
+ * @ingroup tx_functions
+ * Compares IPV4 Ip address and port number
+ * @return Queue Index.
 */
 static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter,
 			   struct iphdr *iphd,
@@ -211,7 +211,7 @@ static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter,
 			pstClassifierRule->ucDirection,
 			pstClassifierRule->usVCID_Value);
 
-		//Checking classifier validity
+		/* Checking classifier validity */
 		if (!pstClassifierRule->bUsed || pstClassifierRule->ucDirection == DOWNLINK_DIR)
 			break;
 
@@ -219,7 +219,7 @@ static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter,
 		if (pstClassifierRule->bIpv6Protocol)
 			break;
 
-		//**************Checking IP header parameter**************************//
+		/* Checking IP header parameter */
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Trying to match Source IP Address");
 		if (!MatchSrcIpAddress(pstClassifierRule, iphd->saddr))
 			break;
@@ -239,12 +239,15 @@ static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter,
 			break;
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol Matched");
 
-		//if protocol is not TCP or UDP then no need of comparing source port and destination port
+		/*
+		 * if protocol is not TCP or UDP then no
+		 * need of comparing source port and destination port
+		 */
 		if (iphd->protocol != TCP && iphd->protocol != UDP) {
 			bClassificationSucceed = TRUE;
 			break;
 		}
-		//******************Checking Transport Layer Header field if present *****************//
+		/* Checking Transport Layer Header field if present */
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Source Port %04x",
 			(iphd->protocol == UDP) ? xprt_hdr->uhdr.source : xprt_hdr->thdr.source);
 
@@ -292,12 +295,12 @@ VOID PruneQueueAllSF(struct bcm_mini_adapter *Adapter)
 
 
 /**
-@ingroup tx_functions
-This function checks if the max queue size for a queue
-is less than number of bytes in the queue. If so -
-drops packets from the Head till the number of bytes is
-less than or equal to max queue size for the queue.
-*/
+ * @ingroup tx_functions
+ * This function checks if the max queue size for a queue
+ * is less than number of bytes in the queue. If so -
+ * drops packets from the Head till the number of bytes is
+ * less than or equal to max queue size for the queue.
+ */
 static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 {
 	struct sk_buff* PacketToDrop = NULL;
@@ -341,11 +344,11 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 
 			DEQUEUEPACKET(Adapter->PackInfo[iIndex].FirstTxQueue,
 						Adapter->PackInfo[iIndex].LastTxQueue);
-			/// update current bytes and packets count
+			/* update current bytes and packets count */
 			Adapter->PackInfo[iIndex].uiCurrentBytesOnHost -=
 				PacketToDrop->len;
 			Adapter->PackInfo[iIndex].uiCurrentPacketsOnHost--;
-			/// update dropped bytes and packets counts
+			/* update dropped bytes and packets counts */
 			Adapter->PackInfo[iIndex].uiDroppedCountBytes += PacketToDrop->len;
 			Adapter->PackInfo[iIndex].uiDroppedCountPackets++;
 			dev_kfree_skb(PacketToDrop);
@@ -393,11 +396,11 @@ VOID flush_all_queues(struct bcm_mini_adapter *Adapter)
 			/* Free the skb */
 			dev_kfree_skb(PacketToDrop);
 
-			/// update current bytes and packets count
+			/* update current bytes and packets count */
 			Adapter->PackInfo[iQIndex].uiCurrentBytesOnHost -= uiTotalPacketLength;
 			Adapter->PackInfo[iQIndex].uiCurrentPacketsOnHost--;
 
-			/// update dropped bytes and packets counts
+			/* update dropped bytes and packets counts */
 			Adapter->PackInfo[iQIndex].uiDroppedCountBytes += uiTotalPacketLength;
 			Adapter->PackInfo[iQIndex].uiDroppedCountPackets++;
 
@@ -461,14 +464,14 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 			bFragmentedPkt = TRUE;
 
 		if (bFragmentedPkt) {
-				//Fragmented  Packet. Get Frag Classifier Entry.
+			/* Fragmented  Packet. Get Frag Classifier Entry. */
 			pstClassifierRule = GetFragIPClsEntry(Adapter, pIpHeader->id, pIpHeader->saddr);
 			if (pstClassifierRule) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "It is next Fragmented pkt");
 					bClassificationSucceed = TRUE;
 			}
 			if (!(ntohs(pIpHeader->frag_off) & IP_MF)) {
-				//Fragmented Last packet . Remove Frag Classifier Entry
+				/* Fragmented Last packet . Remove Frag Classifier Entry */
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "This is the last fragmented Pkt");
 				DelFragIPClsEntry(Adapter, pIpHeader->id, pIpHeader->saddr);
 			}
@@ -478,8 +481,10 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 	for (uiLoopIndex = MAX_CLASSIFIERS - 1; uiLoopIndex >= 0; uiLoopIndex--) {
 		if (bClassificationSucceed)
 			break;
-		//Iterate through all classifiers which are already in order of priority
-		//to classify the packet until match found
+		/*
+		 * Iterate through all classifiers which are already in order of priority
+		 * to classify the packet until match found
+		 */
 		do {
 			if (false == Adapter->astClassifierTable[uiLoopIndex].bUsed) {
 				bClassificationSucceed = false;
@@ -488,8 +493,8 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Adapter->PackInfo[%d].bvalid=True\n", uiLoopIndex);
 
 			if (0 == Adapter->astClassifierTable[uiLoopIndex].ucDirection) {
-				bClassificationSucceed = false;//cannot be processed for classification.
-				break;						// it is a down link connection
+				bClassificationSucceed = false; /* cannot be processed for classification. */
+				break;	/* it is a down link connection */
 			}
 
 			pstClassifierRule = &Adapter->astClassifierTable[uiLoopIndex];
@@ -517,7 +522,7 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ClassifyPacket : Ethernet CS Classification Failed\n");
 					break;
 				}
-			} else {	// No ETH Supported on this SF
+			} else { /* No ETH Supported on this SF */
 				if (eEthOtherFrame != stEthCsPktInfo.eNwpktEthFrameType) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, " ClassifyPacket : Packet Not a 802.3 Ethernet Frame... hence not allowed over non-ETH CS SF\n");
 					bClassificationSucceed = false;
@@ -549,7 +554,7 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 	if (bClassificationSucceed == TRUE) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "CF id : %d, SF ID is =%lu", pstClassifierRule->uiClassifierRuleIndex, pstClassifierRule->ulSFID);
 
-		//Store The matched Classifier in SKB
+		/* Store The matched Classifier in SKB */
 		*((UINT32*)(skb->cb)+SKB_CB_CLASSIFICATION_OFFSET) = pstClassifierRule->uiClassifierRuleIndex;
 		if ((TCP == pIpHeader->protocol) && !bFragmentedPkt && (ETH_AND_IP_HEADER_LEN + TCP_HEADER_LEN <= skb->len)) {
 			 IpHeaderLength   = pIpHeader->ihl;
@@ -564,9 +569,16 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 		usIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "index is	=%d", usIndex);
 
-		//If this is the first fragment of a Fragmented pkt, add this CF. Only This CF should be used for all other fragment of this Pkt.
+		/*
+		 * If this is the first fragment of a Fragmented pkt,
+		 * add this CF. Only This CF should be used for all other
+		 * fragment of this Pkt.
+		 */
 		if (bFragmentedPkt && (usCurrFragment == 0)) {
-			//First Fragment of Fragmented Packet. Create Frag CLS Entry
+			/*
+			 * First Fragment of Fragmented Packet.
+			 * Create Frag CLS Entry
+			 */
 			struct bcm_fragmented_packet_info stFragPktInfo;
 			stFragPktInfo.bUsed = TRUE;
 			stFragPktInfo.ulSrcIpAddress = pIpHeader->saddr;
@@ -659,7 +671,10 @@ static bool EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule, s
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS UserPrio:%x CLS VLANID:%x\n", __func__, ntohs(*((USHORT *)pstClassifierRule->usUserPriority)), pstClassifierRule->usVLANID);
 
-	/* In case FW didn't receive the TLV, the priority field should be ignored */
+	/*
+	 * In case FW didn't receive the TLV,
+	 * the priority field should be ignored
+	 */
 	if (pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_USER_PRIORITY_VALID)) {
 		if (pstEthCsPktInfo->eNwpktEthFrameType != eEth802QVLANFrame)
 				return false;
@@ -714,15 +729,14 @@ static bool EThCSClassifyPkt(struct bcm_mini_adapter *Adapter, struct sk_buff* s
 		return false;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ETH CS DestMAC Matched\n");
 
-	//classify on ETHType/802.2SAP TLV
+	/* classify on ETHType/802.2SAP TLV */
 	bClassificationSucceed = EthCSMatchEThTypeSAP(pstClassifierRule, skb, pstEthCsPktInfo);
 	if (!bClassificationSucceed)
 		return false;
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ETH CS EthType/802.2SAP Matched\n");
 
-	//classify on 802.1VLAN Header Parameters
-
+	/* classify on 802.1VLAN Header Parameters */
 	bClassificationSucceed = EthCSMatchVLANRules(pstClassifierRule, skb, pstEthCsPktInfo);
 	if (!bClassificationSucceed)
 		return false;
@@ -739,9 +753,9 @@ static void EThCSGetPktInfo(struct bcm_mini_adapter *Adapter, PVOID pvEthPayload
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCSGetPktInfo : Eth Hdr Type : %X\n", u16Etype);
 	if (u16Etype > 0x5dc) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "EthCSGetPktInfo : ETH2 Frame\n");
-		//ETH2 Frame
+		/* ETH2 Frame */
 		if (u16Etype == ETHERNET_FRAMETYPE_802QVLAN) {
-			//802.1Q VLAN Header
+			/* 802.1Q VLAN Header */
 			pstEthCsPktInfo->eNwpktEthFrameType = eEth802QVLANFrame;
 			u16Etype = ((struct bcm_eth_q_frame *)pvEthPayload)->EthType;
 			//((ETH_CS_802_Q_FRAME*)pvEthPayload)->UserPriority
@@ -750,12 +764,12 @@ static void EThCSGetPktInfo(struct bcm_mini_adapter *Adapter, PVOID pvEthPayload
 			u16Etype = ntohs(u16Etype);
 		}
 	} else {
-		//802.2 LLC
+		/* 802.2 LLC */
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "802.2 LLC Frame\n");
 		pstEthCsPktInfo->eNwpktEthFrameType = eEth802LLCFrame;
 		pstEthCsPktInfo->ucDSAP = ((struct bcm_eth_llc_frame *)pvEthPayload)->DSAP;
 		if (pstEthCsPktInfo->ucDSAP == 0xAA && ((struct bcm_eth_llc_frame *)pvEthPayload)->SSAP == 0xAA) {
-			//SNAP Frame
+			/* SNAP Frame */
 			pstEthCsPktInfo->eNwpktEthFrameType = eEth802LLCSNAPFrame;
 			u16Etype = ((struct bcm_eth_llc_snap_frame *)pvEthPayload)->usEtherType;
 		}
-- 
1.9.1

