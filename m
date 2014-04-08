Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbaDHVBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 17:01:34 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64031 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798AbaDHVBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 17:01:32 -0400
From: Luis Ortega <luiorpe1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, daeseok.youn@gmail.com, rashika.kheria@gmail.com,
        dan.carpenter@oracle.com, veeableful@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Luis Ortega <luiorpe1@gmail.com>
Subject: [PATCH] Staging: bcm: Qos: fixed braces' coding style
Date: Wed,  9 Apr 2014 01:01:05 +0200
Message-Id: <1396998065-4448-1-git-send-email-luiorpe1@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed badly placed and unnecessary braces.

PS: Performed as task 10 of the Eudyptula Challenge.

Signed-off-by: Luis Ortega <luiorpe1@gmail.com>
---
 drivers/staging/bcm/Qos.c | 174 +++++++++++++---------------------------------
 1 file changed, 48 insertions(+), 126 deletions(-)

diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index 4f31583..4b9ce26 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -33,14 +33,11 @@ static bool MatchSrcIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULO
 	ulSrcIP = ntohl(ulSrcIP);
 	if (0 == pstClassifierRule->ucIPSourceAddressLength)
 		return TRUE;
-	for (ucLoopIndex = 0; ucLoopIndex < (pstClassifierRule->ucIPSourceAddressLength); ucLoopIndex++)
-	{
+	for (ucLoopIndex = 0; ucLoopIndex < (pstClassifierRule->ucIPSourceAddressLength); ucLoopIndex++) 	{
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Ip Address Mask:0x%x PacketIp:0x%x and Classification:0x%x", (UINT)pstClassifierRule->stSrcIpAddress.ulIpv4Mask[ucLoopIndex], (UINT)ulSrcIP, (UINT)pstClassifierRule->stSrcIpAddress.ulIpv6Addr[ucLoopIndex]);
 		if ((pstClassifierRule->stSrcIpAddress.ulIpv4Mask[ucLoopIndex] & ulSrcIP) ==
 				(pstClassifierRule->stSrcIpAddress.ulIpv4Addr[ucLoopIndex] & pstClassifierRule->stSrcIpAddress.ulIpv4Mask[ucLoopIndex]))
-		{
 			return TRUE;
-		}
 	}
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Ip Address Not Matched");
 	return false;
@@ -68,13 +65,10 @@ static bool MatchDestIpAddress(struct bcm_classifier_rule *pstClassifierRule, UL
 		return TRUE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination Ip Address 0x%x 0x%x 0x%x  ", (UINT)ulDestIP, (UINT)pstClassifierRule->stDestIpAddress.ulIpv4Mask[ucLoopIndex], (UINT)pstClassifierRule->stDestIpAddress.ulIpv4Addr[ucLoopIndex]);

-	for (ucLoopIndex = 0; ucLoopIndex < (pstClassifierRule->ucIPDestinationAddressLength); ucLoopIndex++)
-	{
+	for (ucLoopIndex = 0; ucLoopIndex < (pstClassifierRule->ucIPDestinationAddressLength); ucLoopIndex++) {
 		if ((pstClassifierRule->stDestIpAddress.ulIpv4Mask[ucLoopIndex] & ulDestIP) ==
 				(pstClassifierRule->stDestIpAddress.ulIpv4Addr[ucLoopIndex] & pstClassifierRule->stDestIpAddress.ulIpv4Mask[ucLoopIndex]))
-		{
 			return TRUE;
-		}
 	}
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination Ip Address Not Matched");
 	return false;
@@ -99,9 +93,8 @@ static bool MatchTos(struct bcm_classifier_rule *pstClassifierRule, UCHAR ucType
 		return TRUE;

 	if (((pstClassifierRule->ucTosMask & ucTypeOfService) <= pstClassifierRule->ucTosHigh) && ((pstClassifierRule->ucTosMask & ucTypeOfService) >= pstClassifierRule->ucTosLow))
-	{
 		return TRUE;
-	}
+
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Type Of Service Not Matched");
 	return false;
 }
@@ -123,13 +116,10 @@ bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule, UCHAR ucProtoc
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	if (0 == pstClassifierRule->ucProtocolLength)
 		return TRUE;
-	for (ucLoopIndex = 0; ucLoopIndex < pstClassifierRule->ucProtocolLength; ucLoopIndex++)
-	{
+	for (ucLoopIndex = 0; ucLoopIndex < pstClassifierRule->ucProtocolLength; ucLoopIndex++) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol:0x%X Classification Protocol:0x%X", ucProtocol, pstClassifierRule->ucProtocol[ucLoopIndex]);
 		if (pstClassifierRule->ucProtocol[ucLoopIndex] == ucProtocol)
-		{
 			return TRUE;
-		}
 	}
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol Not Matched");
 	return false;
@@ -155,13 +145,10 @@ bool MatchSrcPort(struct bcm_classifier_rule *pstClassifierRule, USHORT ushSrcPo

 	if (0 == pstClassifierRule->ucSrcPortRangeLength)
 		return TRUE;
-	for (ucLoopIndex = 0; ucLoopIndex < pstClassifierRule->ucSrcPortRangeLength; ucLoopIndex++)
-	{
+	for (ucLoopIndex = 0; ucLoopIndex < pstClassifierRule->ucSrcPortRangeLength; ucLoopIndex++) {
 		if (ushSrcPort <= pstClassifierRule->usSrcPortRangeHi[ucLoopIndex] &&
 			ushSrcPort >= pstClassifierRule->usSrcPortRangeLo[ucLoopIndex])
-		{
 			return TRUE;
-		}
 	}
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Port: %x Not Matched ", ushSrcPort);
 	return false;
@@ -186,15 +173,12 @@ bool MatchDestPort(struct bcm_classifier_rule *pstClassifierRule, USHORT ushDest
 	if (0 == pstClassifierRule->ucDestPortRangeLength)
 		return TRUE;

-	for (ucLoopIndex = 0; ucLoopIndex < pstClassifierRule->ucDestPortRangeLength; ucLoopIndex++)
-	{
+	for (ucLoopIndex = 0; ucLoopIndex < pstClassifierRule->ucDestPortRangeLength; ucLoopIndex++) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Matching Port:0x%X   0x%X  0x%X", ushDestPort, pstClassifierRule->usDestPortRangeLo[ucLoopIndex], pstClassifierRule->usDestPortRangeHi[ucLoopIndex]);

 		if (ushDestPort <= pstClassifierRule->usDestPortRangeHi[ucLoopIndex] &&
 			ushDestPort >= pstClassifierRule->usDestPortRangeLo[ucLoopIndex])
-		{
 			return TRUE;
-		}
 	}
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Dest Port: %x Not Matched", ushDestPort);
 	return false;
@@ -273,21 +257,13 @@ static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter,
 		bClassificationSucceed = TRUE;
 	} while (0);

-	if (TRUE == bClassificationSucceed)
-	{
+	if (TRUE == bClassificationSucceed) {
 		INT iMatchedSFQueueIndex = 0;
 		iMatchedSFQueueIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
 		if (iMatchedSFQueueIndex >= NO_OF_QUEUES)
-		{
 			bClassificationSucceed = false;
-		}
-		else
-		{
-			if (false == Adapter->PackInfo[iMatchedSFQueueIndex].bActive)
-			{
-				bClassificationSucceed = false;
-			}
-		}
+		else if (false == Adapter->PackInfo[iMatchedSFQueueIndex].bActive)
+			bClassificationSucceed = false;
 	}

 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "IpVersion4 <==========");
@@ -299,8 +275,7 @@ VOID PruneQueueAllSF(struct bcm_mini_adapter *Adapter)
 {
 	UINT iIndex = 0;

-	for (iIndex = 0; iIndex < HiPriority; iIndex++)
-	{
+	for (iIndex = 0; iIndex < HiPriority; iIndex++) {
 		if (!Adapter->PackInfo[iIndex].bValid)
 			continue;

@@ -334,10 +309,10 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)

 	spin_lock_bh(&Adapter->PackInfo[iIndex].SFQueueLock);

-	while (1)
+	while (1) {
 //	while((UINT)Adapter->PackInfo[iIndex].uiCurrentPacketsOnHost >
-//		SF_MAX_ALLOWED_PACKETS_TO_BACKUP)
-	{
+//		SF_MAX_ALLOWED_PACKETS_TO_BACKUP) {
+
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "uiCurrentBytesOnHost:%x uiMaxBucketSize :%x",
 		Adapter->PackInfo[iIndex].uiCurrentBytesOnHost,
 		Adapter->PackInfo[iIndex].uiMaxBucketSize);
@@ -350,8 +325,7 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 			((1000*(jiffies - *((B_UINT32 *)(PacketToDrop->cb)+SKB_CB_LATENCY_OFFSET))/HZ) <= Adapter->PackInfo[iIndex].uiMaxLatency))
 			break;

-		if (PacketToDrop)
-		{
+		if (PacketToDrop) {
 			if (netif_msg_tx_err(Adapter))
 				pr_info(PFX "%s: tx queue %d overlimit\n",
 					Adapter->dev->name, iIndex);
@@ -394,20 +368,16 @@ VOID flush_all_queues(struct bcm_mini_adapter *Adapter)
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "=====>");

 //	down(&Adapter->data_packet_queue_lock);
-	for (iQIndex = LowPriority; iQIndex < HiPriority; iQIndex++)
-	{
+	for (iQIndex = LowPriority; iQIndex < HiPriority; iQIndex++) {
 		struct net_device_stats *netstats = &Adapter->dev->stats;

 		spin_lock_bh(&Adapter->PackInfo[iQIndex].SFQueueLock);
-		while (Adapter->PackInfo[iQIndex].FirstTxQueue)
-		{
+		while (Adapter->PackInfo[iQIndex].FirstTxQueue) {
 			PacketToDrop = Adapter->PackInfo[iQIndex].FirstTxQueue;
-			if (PacketToDrop)
-			{
+			if (PacketToDrop) {
 				uiTotalPacketLength = PacketToDrop->len;
 				netstats->tx_dropped++;
-			}
-			else
+			} else
 				uiTotalPacketLength = 0;

 			DEQUEUEPACKET(Adapter->PackInfo[iQIndex].FirstTxQueue,
@@ -455,58 +425,42 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 	*((UINT32*) (skb->cb) +SKB_CB_TCPACK_OFFSET) = 0;
 	EThCSGetPktInfo(Adapter, pvEThPayload, &stEthCsPktInfo);

-	switch (stEthCsPktInfo.eNwpktEthFrameType)
-	{
+	switch (stEthCsPktInfo.eNwpktEthFrameType) {
 		case eEth802LLCFrame:
-		{
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802LLCFrame\n");
 			pIpHeader = pvEThPayload + sizeof(struct bcm_eth_llc_frame);
 			break;
-		}
-
 		case eEth802LLCSNAPFrame:
-		{
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802LLC SNAP Frame\n");
 			pIpHeader = pvEThPayload + sizeof(struct bcm_eth_llc_snap_frame);
 			break;
-		}
 		case eEth802QVLANFrame:
-		{
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802.1Q VLANFrame\n");
 			pIpHeader = pvEThPayload + sizeof(struct bcm_eth_q_frame);
 			break;
-		}
 		case eEthOtherFrame:
-		{
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : ETH Other Frame\n");
 			pIpHeader = pvEThPayload + sizeof(struct bcm_ethernet2_frame);
 			break;
-		}
 		default:
-		{
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : Unrecognized ETH Frame\n");
 			pIpHeader = pvEThPayload + sizeof(struct bcm_ethernet2_frame);
 			break;
-		}
 	}

-	if (stEthCsPktInfo.eNwpktIPFrameType == eIPv4Packet)
-	{
+	if (stEthCsPktInfo.eNwpktIPFrameType == eIPv4Packet) {
 		usCurrFragment = (ntohs(pIpHeader->frag_off) & IP_OFFSET);
 		if ((ntohs(pIpHeader->frag_off) & IP_MF) || usCurrFragment)
 			bFragmentedPkt = TRUE;

-		if (bFragmentedPkt)
-		{
+		if (bFragmentedPkt) {
 				//Fragmented  Packet. Get Frag Classifier Entry.
 			pstClassifierRule = GetFragIPClsEntry(Adapter, pIpHeader->id, pIpHeader->saddr);
-			if (pstClassifierRule)
-			{
+			if (pstClassifierRule) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "It is next Fragmented pkt");
 					bClassificationSucceed = TRUE;
 			}
-			if (!(ntohs(pIpHeader->frag_off) & IP_MF))
-			{
+			if (!(ntohs(pIpHeader->frag_off) & IP_MF)) {
 				//Fragmented Last packet . Remove Frag Classifier Entry
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "This is the last fragmented Pkt");
 				DelFragIPClsEntry(Adapter, pIpHeader->id, pIpHeader->saddr);
@@ -514,23 +468,19 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 		}
 	}

-	for (uiLoopIndex = MAX_CLASSIFIERS - 1; uiLoopIndex >= 0; uiLoopIndex--)
-	{
+	for (uiLoopIndex = MAX_CLASSIFIERS - 1; uiLoopIndex >= 0; uiLoopIndex--) {
 		if (bClassificationSucceed)
 			break;
 		//Iterate through all classifiers which are already in order of priority
 		//to classify the packet until match found
-		do
-		{
-			if (false == Adapter->astClassifierTable[uiLoopIndex].bUsed)
-			{
+		do {
+			if (false == Adapter->astClassifierTable[uiLoopIndex].bUsed) {
 				bClassificationSucceed = false;
 				break;
 			}
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Adapter->PackInfo[%d].bvalid=True\n", uiLoopIndex);

-			if (0 == Adapter->astClassifierTable[uiLoopIndex].ucDirection)
-			{
+			if (0 == Adapter->astClassifierTable[uiLoopIndex].ucDirection) {
 				bClassificationSucceed = false;//cannot be processed for classification.
 				break;						// it is a down link connection
 			}
@@ -543,11 +493,9 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 				break;
 			}

-			if (Adapter->PackInfo[uiSfIndex].bEthCSSupport)
-			{
+			if (Adapter->PackInfo[uiSfIndex].bEthCSSupport) {

-				if (eEthUnsupportedFrame == stEthCsPktInfo.eNwpktEthFrameType)
-				{
+				if (eEthUnsupportedFrame == stEthCsPktInfo.eNwpktEthFrameType) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, " ClassifyPacket : Packet Not a Valid Supported Ethernet Frame\n");
 					bClassificationSucceed = false;
 					break;
@@ -558,17 +506,12 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Performing ETH CS Classification on Classifier Rule ID : %x Service Flow ID : %lx\n", pstClassifierRule->uiClassifierRuleIndex, Adapter->PackInfo[uiSfIndex].ulSFID);
 				bClassificationSucceed = EThCSClassifyPkt(Adapter, skb, &stEthCsPktInfo, pstClassifierRule, Adapter->PackInfo[uiSfIndex].bEthCSSupport);

-				if (!bClassificationSucceed)
-				{
+				if (!bClassificationSucceed) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ClassifyPacket : Ethernet CS Classification Failed\n");
 					break;
 				}
-			}
-
-			else // No ETH Supported on this SF
-			{
-				if (eEthOtherFrame != stEthCsPktInfo.eNwpktEthFrameType)
-				{
+			} else {	// No ETH Supported on this SF
+				if (eEthOtherFrame != stEthCsPktInfo.eNwpktEthFrameType) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, " ClassifyPacket : Packet Not a 802.3 Ethernet Frame... hence not allowed over non-ETH CS SF\n");
 					bClassificationSucceed = false;
 					break;
@@ -577,11 +520,9 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)

 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Proceeding to IP CS Clasification");

-			if (Adapter->PackInfo[uiSfIndex].bIPCSSupport)
-			{
+			if (Adapter->PackInfo[uiSfIndex].bIPCSSupport) {

-				if (stEthCsPktInfo.eNwpktIPFrameType == eNonIPPacket)
-				{
+				if (stEthCsPktInfo.eNwpktIPFrameType == eNonIPPacket) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, " ClassifyPacket : Packet is Not an IP Packet\n");
 					bClassificationSucceed = false;
 					break;
@@ -598,31 +539,26 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 		} while (0);
 	}

-	if (bClassificationSucceed == TRUE)
-	{
+	if (bClassificationSucceed == TRUE) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "CF id : %d, SF ID is =%lu", pstClassifierRule->uiClassifierRuleIndex, pstClassifierRule->ulSFID);

 		//Store The matched Classifier in SKB
 		*((UINT32*)(skb->cb)+SKB_CB_CLASSIFICATION_OFFSET) = pstClassifierRule->uiClassifierRuleIndex;
-		if ((TCP == pIpHeader->protocol) && !bFragmentedPkt && (ETH_AND_IP_HEADER_LEN + TCP_HEADER_LEN <= skb->len))
-		{
+		if ((TCP == pIpHeader->protocol) && !bFragmentedPkt && (ETH_AND_IP_HEADER_LEN + TCP_HEADER_LEN <= skb->len)) {
 			 IpHeaderLength   = pIpHeader->ihl;
 			 pTcpHeader = (struct bcm_tcp_header *)(((PUCHAR)pIpHeader)+(IpHeaderLength*4));
 			 TcpHeaderLength  = GET_TCP_HEADER_LEN(pTcpHeader->HeaderLength);

 			if ((pTcpHeader->ucFlags & TCP_ACK) &&
 			   (ntohs(pIpHeader->tot_len) == (IpHeaderLength*4)+(TcpHeaderLength*4)))
-			{
 				*((UINT32*) (skb->cb) + SKB_CB_TCPACK_OFFSET) = TCP_ACK;
-			}
 		}

 		usIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "index is	=%d", usIndex);

 		//If this is the first fragment of a Fragmented pkt, add this CF. Only This CF should be used for all other fragment of this Pkt.
-		if (bFragmentedPkt && (usCurrFragment == 0))
-		{
+		if (bFragmentedPkt && (usCurrFragment == 0)) {
 			//First Fragment of Fragmented Packet. Create Frag CLS Entry
 			struct bcm_fragmented_packet_info stFragPktInfo;
 			stFragPktInfo.bUsed = TRUE;
@@ -649,8 +585,7 @@ static bool EthCSMatchSrcMACAddress(struct bcm_classifier_rule *pstClassifierRul
 	if (pstClassifierRule->ucEthCSSrcMACLen == 0)
 		return TRUE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s\n", __FUNCTION__);
-	for (i = 0; i < MAC_ADDRESS_SIZE; i++)
-	{
+	for (i = 0; i < MAC_ADDRESS_SIZE; i++) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "SRC MAC[%x] = %x ClassifierRuleSrcMAC = %x Mask : %x\n", i, Mac[i], pstClassifierRule->au8EThCSSrcMAC[i], pstClassifierRule->au8EThCSSrcMACMask[i]);
 		if ((pstClassifierRule->au8EThCSSrcMAC[i] & pstClassifierRule->au8EThCSSrcMACMask[i]) !=
 			(Mac[i] & pstClassifierRule->au8EThCSSrcMACMask[i]))
@@ -666,8 +601,7 @@ static bool EthCSMatchDestMACAddress(struct bcm_classifier_rule *pstClassifierRu
 	if (pstClassifierRule->ucEthCSDestMACLen == 0)
 		return TRUE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "%s\n", __FUNCTION__);
-	for (i = 0; i < MAC_ADDRESS_SIZE; i++)
-	{
+	for (i = 0; i < MAC_ADDRESS_SIZE; i++) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "SRC MAC[%x] = %x ClassifierRuleSrcMAC = %x Mask : %x\n", i, Mac[i], pstClassifierRule->au8EThCSDestMAC[i], pstClassifierRule->au8EThCSDestMACMask[i]);
 		if ((pstClassifierRule->au8EThCSDestMAC[i] & pstClassifierRule->au8EThCSDestMACMask[i]) !=
 			(Mac[i] & pstClassifierRule->au8EThCSDestMACMask[i]))
@@ -684,8 +618,7 @@ static bool EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifierRule,
 		return TRUE;

 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s SrcEtherType:%x CLS EtherType[0]:%x\n", __FUNCTION__, pstEthCsPktInfo->usEtherType, pstClassifierRule->au8EthCSEtherType[0]);
-	if (pstClassifierRule->au8EthCSEtherType[0] == 1)
-	{
+	if (pstClassifierRule->au8EthCSEtherType[0] == 1) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS EtherType[1]:%x EtherType[2]:%x\n", __FUNCTION__, pstClassifierRule->au8EthCSEtherType[1], pstClassifierRule->au8EthCSEtherType[2]);

 		if (memcmp(&pstEthCsPktInfo->usEtherType, &pstClassifierRule->au8EthCSEtherType[1], 2) == 0)
@@ -694,8 +627,7 @@ static bool EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifierRule,
 			return false;
 	}

-	if (pstClassifierRule->au8EthCSEtherType[0] == 2)
-	{
+	if (pstClassifierRule->au8EthCSEtherType[0] == 2) {
 		if (eEth802LLCFrame != pstEthCsPktInfo->eNwpktEthFrameType)
 			return false;

@@ -721,8 +653,7 @@ static bool EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule, s
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS UserPrio:%x CLS VLANID:%x\n", __FUNCTION__, ntohs(*((USHORT *)pstClassifierRule->usUserPriority)), pstClassifierRule->usVLANID);

 	/* In case FW didn't receive the TLV, the priority field should be ignored */
-	if (pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_USER_PRIORITY_VALID))
-	{
+	if (pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_USER_PRIORITY_VALID)) {
 		if (pstEthCsPktInfo->eNwpktEthFrameType != eEth802QVLANFrame)
 				return false;

@@ -739,8 +670,7 @@ static bool EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule, s

 	bClassificationSucceed = false;

-	if (pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_VLANID_VALID))
-	{
+	if (pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_VLANID_VALID)) {
 		if (pstEthCsPktInfo->eNwpktEthFrameType != eEth802QVLANFrame)
 				return false;

@@ -800,32 +730,24 @@ static void EThCSGetPktInfo(struct bcm_mini_adapter *Adapter, PVOID pvEthPayload
 	USHORT u16Etype = ntohs(((struct bcm_eth_header *)pvEthPayload)->u16Etype);

 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCSGetPktInfo : Eth Hdr Type : %X\n", u16Etype);
-	if (u16Etype > 0x5dc)
-	{
+	if (u16Etype > 0x5dc) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "EthCSGetPktInfo : ETH2 Frame\n");
 		//ETH2 Frame
-		if (u16Etype == ETHERNET_FRAMETYPE_802QVLAN)
-		{
+		if (u16Etype == ETHERNET_FRAMETYPE_802QVLAN) {
 			//802.1Q VLAN Header
 			pstEthCsPktInfo->eNwpktEthFrameType = eEth802QVLANFrame;
 			u16Etype = ((struct bcm_eth_q_frame *)pvEthPayload)->EthType;
 			//((ETH_CS_802_Q_FRAME*)pvEthPayload)->UserPriority
-		}
-		else
-		{
+		} else {
 			pstEthCsPktInfo->eNwpktEthFrameType = eEthOtherFrame;
 			u16Etype = ntohs(u16Etype);
 		}
-
-	}
-	else
-	{
+	} else {
 		//802.2 LLC
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "802.2 LLC Frame\n");
 		pstEthCsPktInfo->eNwpktEthFrameType = eEth802LLCFrame;
 		pstEthCsPktInfo->ucDSAP = ((struct bcm_eth_llc_frame *)pvEthPayload)->DSAP;
-		if (pstEthCsPktInfo->ucDSAP == 0xAA && ((struct bcm_eth_llc_frame *)pvEthPayload)->SSAP == 0xAA)
-		{
+		if (pstEthCsPktInfo->ucDSAP == 0xAA && ((struct bcm_eth_llc_frame *)pvEthPayload)->SSAP == 0xAA) {
 			//SNAP Frame
 			pstEthCsPktInfo->eNwpktEthFrameType = eEth802LLCSNAPFrame;
 			u16Etype = ((struct bcm_eth_llc_snap_frame *)pvEthPayload)->usEtherType;
--
1.9.1

