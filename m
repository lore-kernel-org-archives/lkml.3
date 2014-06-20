Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935051AbaFTP46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:56:58 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33870 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754967AbaFTPrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:47:51 -0400
From: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: christian.bay@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lisa@xenapiadmin.com, daeseok.youn@gmail.com, luiorpe1@gmail.com,
        veeableful@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, martin.gumbrecht@googlemail.com
Subject: [PATCH v2 7/7] Staging: bcm: Qos.c: fix checkpatch errors: whitespaces
Date: Fri, 20 Jun 2014 17:38:04 +0200
Message-Id: <1403278684-10891-8-git-send-email-martin.gumbrecht@googlemail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
References: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves coding style in Qos.c
Whitespaces according to the coding guideline

Signed-off-by: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
Signed-off-by: Christian Bay <christian.bay@studium.fau.de>
---
 drivers/staging/bcm/Qos.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index f9c57ee..42c1351 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -303,7 +303,7 @@ VOID PruneQueueAllSF(struct bcm_mini_adapter *Adapter)
  */
 static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 {
-	struct sk_buff* PacketToDrop = NULL;
+	struct sk_buff *PacketToDrop = NULL;
 	struct net_device_stats *netstats;
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "=====> Index %d", iIndex);
@@ -371,9 +371,9 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 
 VOID flush_all_queues(struct bcm_mini_adapter *Adapter)
 {
-	INT		iQIndex;
-	UINT	uiTotalPacketLength;
-	struct sk_buff*			PacketToDrop = NULL;
+	INT	iQIndex;
+	UINT uiTotalPacketLength;
+	struct sk_buff *PacketToDrop = NULL;
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "=====>");
 
@@ -415,24 +415,24 @@ VOID flush_all_queues(struct bcm_mini_adapter *Adapter)
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "<=====");
 }
 
-USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
+USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff *skb)
 {
-	INT			uiLoopIndex = 0;
+	INT uiLoopIndex = 0;
 	struct bcm_classifier_rule *pstClassifierRule = NULL;
 	struct bcm_eth_packet_info stEthCsPktInfo;
 	PVOID pvEThPayload = NULL;
 	struct iphdr *pIpHeader = NULL;
-	INT	  uiSfIndex = 0;
-	USHORT	usIndex = Adapter->usBestEffortQueueIndex;
-	bool	bFragmentedPkt = false, bClassificationSucceed = false;
-	USHORT	usCurrFragment = 0;
+	INT uiSfIndex = 0;
+	USHORT usIndex = Adapter->usBestEffortQueueIndex;
+	bool bFragmentedPkt = false, bClassificationSucceed = false;
+	USHORT usCurrFragment = 0;
 
 	struct bcm_tcp_header *pTcpHeader;
 	UCHAR IpHeaderLength;
 	UCHAR TcpHeaderLength;
 
 	pvEThPayload = skb->data;
-	*((UINT32*) (skb->cb) +SKB_CB_TCPACK_OFFSET) = 0;
+	*((UINT32 *) (skb->cb) + SKB_CB_TCPACK_OFFSET) = 0;
 	EThCSGetPktInfo(Adapter, pvEThPayload, &stEthCsPktInfo);
 
 	switch (stEthCsPktInfo.eNwpktEthFrameType) {
@@ -555,15 +555,15 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "CF id : %d, SF ID is =%lu", pstClassifierRule->uiClassifierRuleIndex, pstClassifierRule->ulSFID);
 
 		/* Store The matched Classifier in SKB */
-		*((UINT32*)(skb->cb)+SKB_CB_CLASSIFICATION_OFFSET) = pstClassifierRule->uiClassifierRuleIndex;
+		*((UINT32 *)(skb->cb)+SKB_CB_CLASSIFICATION_OFFSET) = pstClassifierRule->uiClassifierRuleIndex;
 		if ((TCP == pIpHeader->protocol) && !bFragmentedPkt && (ETH_AND_IP_HEADER_LEN + TCP_HEADER_LEN <= skb->len)) {
-			 IpHeaderLength   = pIpHeader->ihl;
-			 pTcpHeader = (struct bcm_tcp_header *)(((PUCHAR)pIpHeader)+(IpHeaderLength*4));
-			 TcpHeaderLength  = GET_TCP_HEADER_LEN(pTcpHeader->HeaderLength);
+			IpHeaderLength = pIpHeader->ihl;
+			pTcpHeader = (struct bcm_tcp_header *)(((PUCHAR)pIpHeader)+(IpHeaderLength*4));
+			TcpHeaderLength  = GET_TCP_HEADER_LEN(pTcpHeader->HeaderLength);
 
 			if ((pTcpHeader->ucFlags & TCP_ACK) &&
 			   (ntohs(pIpHeader->tot_len) == (IpHeaderLength*4)+(TcpHeaderLength*4)))
-				*((UINT32*) (skb->cb) + SKB_CB_TCPACK_OFFSET) = TCP_ACK;
+				*((UINT32 *) (skb->cb) + SKB_CB_TCPACK_OFFSET) = TCP_ACK;
 		}
 
 		usIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
@@ -629,7 +629,7 @@ static bool EthCSMatchDestMACAddress(struct bcm_classifier_rule *pstClassifierRu
 	return TRUE;
 }
 
-static bool EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifierRule, struct sk_buff* skb, struct bcm_eth_packet_info *pstEthCsPktInfo)
+static bool EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifierRule, struct sk_buff *skb, struct bcm_eth_packet_info *pstEthCsPktInfo)
 {
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	if ((pstClassifierRule->ucEtherTypeLen == 0) ||
@@ -662,7 +662,7 @@ static bool EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifierRule,
 
 }
 
-static bool EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule, struct sk_buff* skb, struct bcm_eth_packet_info *pstEthCsPktInfo)
+static bool EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule, struct sk_buff *skb, struct bcm_eth_packet_info *pstEthCsPktInfo)
 {
 	bool bClassificationSucceed = false;
 	USHORT usVLANID;
@@ -713,7 +713,7 @@ static bool EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule, s
 }
 
 
-static bool EThCSClassifyPkt(struct bcm_mini_adapter *Adapter, struct sk_buff* skb,
+static bool EThCSClassifyPkt(struct bcm_mini_adapter *Adapter, struct sk_buff *skb,
 				struct bcm_eth_packet_info *pstEthCsPktInfo,
 				struct bcm_classifier_rule *pstClassifierRule,
 				B_UINT8 EthCSCupport)
-- 
1.9.1

