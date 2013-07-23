Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3GWJUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:20:38 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38924 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab3GWJUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:20:35 -0400
Message-ID: <1374571229.15906.3.camel@desktop>
Subject: [PATCH] Staging: bcm: Qos: Fix some coding style issues
From: Lilis Iskandar <veeableful@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 17:20:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a2f8b299baee0e075d548d2bbf77619373035446 Mon Sep 17 00:00:00 2001
From: Lilis Iskandar <veeableful@gmail.com>
Date: Tue, 23 Jul 2013 17:08:37 +0800
Subject: [PATCH] Staging: bcm: Qos: Fix some coding style issues

Fix some coding style issues.

Signed-off-by: Lilis Iskandar <veeableful@gmail.com>
---
 drivers/staging/bcm/Qos.c | 600 ++++++++++++++++++++++------------------------
 1 file changed, 285 insertions(+), 315 deletions(-)

diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index 8d142a5..a1fc892 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -4,11 +4,15 @@ This file contains the routines related to Quality of Service.
 */
 #include "headers.h"
 
-static void EThCSGetPktInfo(struct bcm_mini_adapter *Adapter,PVOID pvEthPayload, struct bcm_eth_packet_info *pstEthCsPktInfo);
-static BOOLEAN EThCSClassifyPkt(struct bcm_mini_adapter *Adapter,struct sk_buff* skb, struct bcm_eth_packet_info *pstEthCsPktInfo,struct bcm_classifier_rule *pstClassifierRule, B_UINT8 EthCSCupport);
+static void EThCSGetPktInfo(struct bcm_mini_adapter *Adapter, PVOID pvEthPayload,
+				struct bcm_eth_packet_info *pstEthCsPktInfo);
+static BOOLEAN EThCSClassifyPkt(struct bcm_mini_adapter *Adapter, struct sk_buff *skb,
+				struct bcm_eth_packet_info *pstEthCsPktInfo,
+				struct bcm_classifier_rule *pstClassifierRule,
+				B_UINT8 EthCSCupport);
 
 static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter, struct iphdr *iphd,
-			   struct bcm_classifier_rule *pstClassifierRule );
+			   struct bcm_classifier_rule *pstClassifierRule);
 
 static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex);
 
@@ -20,30 +24,31 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex);
 *				matches with that of Queue.
 *
 * Parameters  - pstClassifierRule: Pointer to the packet info structure.
-* 			  - ulSrcIP	    : Source IP address from the packet.
+*			  - ulSrcIP	    : Source IP address from the packet.
 *
 * Returns     - TRUE(If address matches) else FAIL .
 *********************************************************************/
-BOOLEAN MatchSrcIpAddress(struct bcm_classifier_rule *pstClassifierRule,ULONG ulSrcIP)
+BOOLEAN MatchSrcIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulSrcIP)
 {
-    UCHAR 	ucLoopIndex=0;
-
-    struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
-
-    ulSrcIP=ntohl(ulSrcIP);
-    if(0 == pstClassifierRule->ucIPSourceAddressLength)
-       	return TRUE;
-    for(ucLoopIndex=0; ucLoopIndex < (pstClassifierRule->ucIPSourceAddressLength);ucLoopIndex++)
-    {
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Ip Address Mask:0x%x PacketIp:0x%x and Classification:0x%x", (UINT)pstClassifierRule->stSrcIpAddress.ulIpv4Mask[ucLoopIndex], (UINT)ulSrcIP, (UINT)pstClassifierRule->stSrcIpAddress.ulIpv6Addr[ucLoopIndex]);
-		if((pstClassifierRule->stSrcIpAddress.ulIpv4Mask[ucLoopIndex] & ulSrcIP)==
-				(pstClassifierRule->stSrcIpAddress.ulIpv4Addr[ucLoopIndex] & pstClassifierRule->stSrcIpAddress.ulIpv4Mask[ucLoopIndex] ))
-       	{
+	UCHAR ucLoopIndex = 0;
+	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
+
+	ulSrcIP = ntohl(ulSrcIP);
+	if (0 == pstClassifierRule->ucIPSourceAddressLength)
        		return TRUE;
-       	}
-    }
-    BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Ip Address Not Matched");
-   	return FALSE;
+	for (ucLoopIndex = 0; ucLoopIndex < (pstClassifierRule->ucIPSourceAddressLength); ucLoopIndex++) {
+		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,
+				"Src Ip Address Mask:0x%x PacketIp:0x%x and Classification:0x%x",
+				(UINT)pstClassifierRule->stSrcIpAddress.ulIpv4Mask[ucLoopIndex],
+				(UINT)ulSrcIP, (UINT)pstClassifierRule->stSrcIpAddress.ulIpv6Addr[ucLoopIndex]);
+		if ((pstClassifierRule->stSrcIpAddress.ulIpv4Mask[ucLoopIndex] & ulSrcIP) ==
+				(pstClassifierRule->stSrcIpAddress.ulIpv4Addr[ucLoopIndex] & pstClassifierRule->stSrcIpAddress.ulIpv4Mask[ucLoopIndex]))
+		{
+			return TRUE;
+		}
+	}
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Ip Address Not Matched");
+	return FALSE;
 }
 
 
@@ -60,24 +65,26 @@ BOOLEAN MatchSrcIpAddress(struct bcm_classifier_rule *pstClassifierRule,ULONG ul
 *********************************************************************/
 BOOLEAN MatchDestIpAddress(struct bcm_classifier_rule *pstClassifierRule,ULONG ulDestIP)
 {
-	UCHAR 	ucLoopIndex=0;
+	UCHAR ucLoopIndex = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-	ulDestIP=ntohl(ulDestIP);
-    if(0 == pstClassifierRule->ucIPDestinationAddressLength)
-       	return TRUE;
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination Ip Address 0x%x 0x%x 0x%x  ", (UINT)ulDestIP, (UINT)pstClassifierRule->stDestIpAddress.ulIpv4Mask[ucLoopIndex], (UINT)pstClassifierRule->stDestIpAddress.ulIpv4Addr[ucLoopIndex]);
-
-    for(ucLoopIndex=0;ucLoopIndex<(pstClassifierRule->ucIPDestinationAddressLength);ucLoopIndex++)
-    {
-		if((pstClassifierRule->stDestIpAddress.ulIpv4Mask[ucLoopIndex] & ulDestIP)==
-					(pstClassifierRule->stDestIpAddress.ulIpv4Addr[ucLoopIndex] & pstClassifierRule->stDestIpAddress.ulIpv4Mask[ucLoopIndex]))
-       	{
-       		return TRUE;
-       	}
-    }
+	ulDestIP = ntohl(ulDestIP);
+	if (0 == pstClassifierRule->ucIPDestinationAddressLength)
+		return TRUE;
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,
+			"Destination Ip Address 0x%x 0x%x 0x%x  ",
+			(UINT)ulDestIP, (UINT)pstClassifierRule->stDestIpAddress.ulIpv4Mask[ucLoopIndex],
+			(UINT)pstClassifierRule->stDestIpAddress.ulIpv4Addr[ucLoopIndex]);
+
+	for (ucLoopIndex = 0; ucLoopIndex<(pstClassifierRule->ucIPDestinationAddressLength); ucLoopIndex++) {
+		if ((pstClassifierRule->stDestIpAddress.ulIpv4Mask[ucLoopIndex] & ulDestIP) ==
+				(pstClassifierRule->stDestIpAddress.ulIpv4Addr[ucLoopIndex] & pstClassifierRule->stDestIpAddress.ulIpv4Mask[ucLoopIndex]))
+		{
+			return TRUE;
+		}
+	}
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination Ip Address Not Matched");
-    return FALSE;
+	return FALSE;
 }
 
 
@@ -95,15 +102,17 @@ BOOLEAN MatchTos(struct bcm_classifier_rule *pstClassifierRule,UCHAR ucTypeOfSer
 {
 
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
-    if( 3 != pstClassifierRule->ucIPTypeOfServiceLength )
-       	return TRUE;
-
-    if(((pstClassifierRule->ucTosMask & ucTypeOfService)<=pstClassifierRule->ucTosHigh) && ((pstClassifierRule->ucTosMask & ucTypeOfService)>=pstClassifierRule->ucTosLow))
-    {
-       	return TRUE;
-    }
-    BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Type Of Service Not Matched");
-    return FALSE;
+
+	if (3 != pstClassifierRule->ucIPTypeOfServiceLength)
+		return TRUE;
+
+	if (((pstClassifierRule->ucTosMask & ucTypeOfService)<=pstClassifierRule->ucTosHigh) &&
+			((pstClassifierRule->ucTosMask & ucTypeOfService)>=pstClassifierRule->ucTosLow))
+	{
+		return TRUE;
+	}
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Type Of Service Not Matched");
+	return FALSE;
 }
 
 
@@ -121,17 +130,16 @@ bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule,UCHAR ucProtoco
 {
    	UCHAR 	ucLoopIndex=0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	if(0 == pstClassifierRule->ucProtocolLength)
-      	return TRUE;
-	for(ucLoopIndex=0;ucLoopIndex<pstClassifierRule->ucProtocolLength;ucLoopIndex++)
-    {
-       	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol:0x%X Classification Protocol:0x%X",ucProtocol,pstClassifierRule->ucProtocol[ucLoopIndex]);
-       	if(pstClassifierRule->ucProtocol[ucLoopIndex]==ucProtocol)
-       	{
-       		return TRUE;
-       	}
-    }
-    BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol Not Matched");
+
+	if (0 == pstClassifierRule->ucProtocolLength)
+		return TRUE;
+	for (ucLoopIndex = 0; ucLoopIndex<pstClassifierRule->ucProtocolLength; ucLoopIndex++) {
+		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol:0x%X Classification Protocol:0x%X",
+				ucProtocol,pstClassifierRule->ucProtocol[ucLoopIndex]);
+		if (pstClassifierRule->ucProtocol[ucLoopIndex] == ucProtocol)
+			return TRUE;
+	}
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol Not Matched");
    	return FALSE;
 }
 
@@ -148,23 +156,20 @@ bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule,UCHAR ucProtoco
 ***************************************************************************/
 bool MatchSrcPort(struct bcm_classifier_rule *pstClassifierRule,USHORT ushSrcPort)
 {
-    	UCHAR 	ucLoopIndex=0;
-
+    	UCHAR ucLoopIndex = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-
-    	if(0 == pstClassifierRule->ucSrcPortRangeLength)
+    	if (0 == pstClassifierRule->ucSrcPortRangeLength)
         	return TRUE;
-    	for(ucLoopIndex=0;ucLoopIndex<pstClassifierRule->ucSrcPortRangeLength;ucLoopIndex++)
-    	{
-        	if(ushSrcPort <= pstClassifierRule->usSrcPortRangeHi[ucLoopIndex] &&
-		    ushSrcPort >= pstClassifierRule->usSrcPortRangeLo[ucLoopIndex])
-	    	{
-		    	return TRUE;
-	    	}
-    	}
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Port: %x Not Matched ",ushSrcPort);
-    	return FALSE;
+    	for (ucLoopIndex = 0; ucLoopIndex<pstClassifierRule->ucSrcPortRangeLength; ucLoopIndex++) {
+		if(ushSrcPort <= pstClassifierRule->usSrcPortRangeHi[ucLoopIndex] &&
+				ushSrcPort >= pstClassifierRule->usSrcPortRangeLo[ucLoopIndex])
+		{
+			return TRUE;
+		}
+	}
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Port: %x Not Matched ", ushSrcPort);
+	return FALSE;
 }
 
 
@@ -180,24 +185,25 @@ bool MatchSrcPort(struct bcm_classifier_rule *pstClassifierRule,USHORT ushSrcPor
 ***************************************************************************/
 bool MatchDestPort(struct bcm_classifier_rule *pstClassifierRule,USHORT ushDestPort)
 {
-    	UCHAR 	ucLoopIndex=0;
+    	UCHAR ucLoopIndex = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-    	if(0 == pstClassifierRule->ucDestPortRangeLength)
+    	if (0 == pstClassifierRule->ucDestPortRangeLength)
         	return TRUE;
 
-    	for(ucLoopIndex=0;ucLoopIndex<pstClassifierRule->ucDestPortRangeLength;ucLoopIndex++)
-    	{
-        	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Matching Port:0x%X   0x%X  0x%X",ushDestPort,pstClassifierRule->usDestPortRangeLo[ucLoopIndex],pstClassifierRule->usDestPortRangeHi[ucLoopIndex]);
+    	for (ucLoopIndex = 0; ucLoopIndex < pstClassifierRule->ucDestPortRangeLength; ucLoopIndex++) {
+        	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Matching Port:0x%X   0x%X  0x%X",
+				ushDestPort,pstClassifierRule->usDestPortRangeLo[ucLoopIndex],
+				pstClassifierRule->usDestPortRangeHi[ucLoopIndex]);
 
- 		if(ushDestPort <= pstClassifierRule->usDestPortRangeHi[ucLoopIndex] &&
-		    ushDestPort >= pstClassifierRule->usDestPortRangeLo[ucLoopIndex])
-	    	{
-		    return TRUE;
-	    	}
+ 		if (ushDestPort <= pstClassifierRule->usDestPortRangeHi[ucLoopIndex] &&
+				ushDestPort >= pstClassifierRule->usDestPortRangeLo[ucLoopIndex])
+		{
+			return TRUE;
+		}
     	}
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Dest Port: %x Not Matched",ushDestPort);
-    	return FALSE;
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Dest Port: %x Not Matched",ushDestPort);
+	return FALSE;
 }
 /**
 @ingroup tx_functions
@@ -212,8 +218,7 @@ static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter,
 	BOOLEAN	bClassificationSucceed=FALSE;
 
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "========>");
-
-	xprt_hdr=(struct bcm_transport_header *)((PUCHAR)iphd + sizeof(struct iphdr));
+	xprt_hdr = (struct bcm_transport_header *)((PUCHAR)iphd + sizeof(struct iphdr));
 
 	do {
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Trying to see Direction = %d %d",
@@ -221,80 +226,69 @@ static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter,
 			pstClassifierRule->usVCID_Value);
 
 		//Checking classifier validity
-		if(!pstClassifierRule->bUsed || pstClassifierRule->ucDirection == DOWNLINK_DIR)
-		{
+		if (!pstClassifierRule->bUsed || pstClassifierRule->ucDirection == DOWNLINK_DIR) {
 			bClassificationSucceed = FALSE;
 			break;
 		}
 
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "is IPv6 check!");
-		if(pstClassifierRule->bIpv6Protocol)
+		if (pstClassifierRule->bIpv6Protocol)
 			break;
 
 		//**************Checking IP header parameter**************************//
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Trying to match Source IP Address");
-		if(FALSE == (bClassificationSucceed =
-			MatchSrcIpAddress(pstClassifierRule, iphd->saddr)))
+		if (FALSE == (bClassificationSucceed = MatchSrcIpAddress(pstClassifierRule, iphd->saddr)))
 			break;
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Source IP Address Matched");
 
-		if(FALSE == (bClassificationSucceed =
-			MatchDestIpAddress(pstClassifierRule, iphd->daddr)))
+		if (FALSE == (bClassificationSucceed = MatchDestIpAddress(pstClassifierRule, iphd->daddr)))
 			break;
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination IP Address Matched");
 
-		if(FALSE == (bClassificationSucceed =
-			MatchTos(pstClassifierRule, iphd->tos)))
-		{
+		if (FALSE == (bClassificationSucceed = MatchTos(pstClassifierRule, iphd->tos))) {
 			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "TOS Match failed\n");
 			break;
 		}
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "TOS Matched");
 
-		if(FALSE == (bClassificationSucceed =
-			MatchProtocol(pstClassifierRule,iphd->protocol)))
+		if (FALSE == (bClassificationSucceed = MatchProtocol(pstClassifierRule,iphd->protocol)))
 			break;
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol Matched");
 
 		//if protocol is not TCP or UDP then no need of comparing source port and destination port
-		if(iphd->protocol!=TCP && iphd->protocol!=UDP)
+		if (iphd->protocol!=TCP && iphd->protocol!=UDP)
 			break;
 		//******************Checking Transport Layer Header field if present *****************//
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Source Port %04x",
-			(iphd->protocol==UDP)?xprt_hdr->uhdr.source:xprt_hdr->thdr.source);
+				(iphd->protocol==UDP)?xprt_hdr->uhdr.source:xprt_hdr->thdr.source);
 
-		if(FALSE == (bClassificationSucceed =
+		if (FALSE == (bClassificationSucceed =
 			MatchSrcPort(pstClassifierRule,
-				ntohs((iphd->protocol == UDP)?
-				xprt_hdr->uhdr.source:xprt_hdr->thdr.source))))
+			ntohs((iphd->protocol == UDP)?
+			xprt_hdr->uhdr.source : xprt_hdr->thdr.source))))
+		{
 			break;
+		}
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Port Matched");
 
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination Port %04x",
-			(iphd->protocol==UDP)?xprt_hdr->uhdr.dest:
-			xprt_hdr->thdr.dest);
-		if(FALSE == (bClassificationSucceed =
+			(iphd->protocol == UDP) ? xprt_hdr->uhdr.dest: xprt_hdr->thdr.dest);
+		if (FALSE == (bClassificationSucceed =
 			MatchDestPort(pstClassifierRule,
 			ntohs((iphd->protocol == UDP)?
-			xprt_hdr->uhdr.dest:xprt_hdr->thdr.dest))))
+			xprt_hdr->uhdr.dest : xprt_hdr->thdr.dest))))
+		{
 			break;
+		}
 	} while(0);
 
-	if(TRUE==bClassificationSucceed)
-	{
+	if (TRUE == bClassificationSucceed) {
 		INT iMatchedSFQueueIndex = 0;
 		iMatchedSFQueueIndex = SearchSfid(Adapter,pstClassifierRule->ulSFID);
-		if(iMatchedSFQueueIndex >= NO_OF_QUEUES)
-		{
+		if (iMatchedSFQueueIndex >= NO_OF_QUEUES)
+			bClassificationSucceed = FALSE;
+		else if (FALSE == Adapter->PackInfo[iMatchedSFQueueIndex].bActive)
 			bClassificationSucceed = FALSE;
-		}
-		else
-		{
-			if(FALSE == Adapter->PackInfo[iMatchedSFQueueIndex].bActive)
-			{
-				bClassificationSucceed = FALSE;
-			}
-		}
 	}
 
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "IpVersion4 <==========");
@@ -306,11 +300,9 @@ VOID PruneQueueAllSF(struct bcm_mini_adapter *Adapter)
 {
 	UINT iIndex = 0;
 
-	for(iIndex = 0; iIndex < HiPriority; iIndex++)
-	{
-		if(!Adapter->PackInfo[iIndex].bValid)
+	for (iIndex = 0; iIndex < HiPriority; iIndex++) {
+		if (!Adapter->PackInfo[iIndex].bValid)
 			continue;
-
 		PruneQueue(Adapter, iIndex);
 	}
 }
@@ -330,10 +322,10 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "=====> Index %d",iIndex);
 
-   	if(iIndex == HiPriority)
+   	if (iIndex == HiPriority)
 		return;
 
-	if(!Adapter || (iIndex < 0) || (iIndex > HiPriority))
+	if (!Adapter || (iIndex < 0) || (iIndex > HiPriority))
 		return;
 
 	/* To Store the netdevice statistic */
@@ -341,37 +333,38 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 
 	spin_lock_bh(&Adapter->PackInfo[iIndex].SFQueueLock);
 
-	while(1)
-//	while((UINT)Adapter->PackInfo[iIndex].uiCurrentPacketsOnHost >
-//		SF_MAX_ALLOWED_PACKETS_TO_BACKUP)
-	{
+	/*
+	while((UINT)Adapter->PackInfo[iIndex].uiCurrentPacketsOnHost >
+		SF_MAX_ALLOWED_PACKETS_TO_BACKUP)
+	*/
+	while (1) {
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "uiCurrentBytesOnHost:%x uiMaxBucketSize :%x",
 		Adapter->PackInfo[iIndex].uiCurrentBytesOnHost,
 		Adapter->PackInfo[iIndex].uiMaxBucketSize);
 
 		PacketToDrop = Adapter->PackInfo[iIndex].FirstTxQueue;
 
-		if(PacketToDrop == NULL)
+		if (PacketToDrop == NULL)
 			break;
-		if((Adapter->PackInfo[iIndex].uiCurrentPacketsOnHost < SF_MAX_ALLOWED_PACKETS_TO_BACKUP) &&
+		if ((Adapter->PackInfo[iIndex].uiCurrentPacketsOnHost < SF_MAX_ALLOWED_PACKETS_TO_BACKUP) &&
 			((1000*(jiffies - *((B_UINT32 *)(PacketToDrop->cb)+SKB_CB_LATENCY_OFFSET))/HZ) <= Adapter->PackInfo[iIndex].uiMaxLatency))
+		{
 			break;
+		}
 
-		if(PacketToDrop)
-		{
+		if (PacketToDrop) {
 			if (netif_msg_tx_err(Adapter))
-				pr_info(PFX "%s: tx queue %d overlimit\n", 
-					Adapter->dev->name, iIndex);
+				pr_info(PFX "%s: tx queue %d overlimit\n", Adapter->dev->name, iIndex);
 
 			netstats->tx_dropped++;
 
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
@@ -394,28 +387,25 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 
 VOID flush_all_queues(struct bcm_mini_adapter *Adapter)
 {
-	INT		iQIndex;
-	UINT	uiTotalPacketLength;
-	struct sk_buff*			PacketToDrop=NULL;
+	INT iQIndex;
+	UINT uiTotalPacketLength;
+	struct sk_buff* PacketToDrop=NULL;
 
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "=====>");
 
-//	down(&Adapter->data_packet_queue_lock);
-	for(iQIndex=LowPriority; iQIndex<HiPriority; iQIndex++)
-	{
+	/* down(&Adapter->data_packet_queue_lock); */
+	for (iQIndex = LowPriority; iQIndex<HiPriority; iQIndex++) {
 		struct net_device_stats *netstats = &Adapter->dev->stats;
 
 		spin_lock_bh(&Adapter->PackInfo[iQIndex].SFQueueLock);
-		while(Adapter->PackInfo[iQIndex].FirstTxQueue)
-		{
+		while (Adapter->PackInfo[iQIndex].FirstTxQueue) {
 			PacketToDrop = Adapter->PackInfo[iQIndex].FirstTxQueue;
-			if(PacketToDrop)
-			{
+			if (PacketToDrop) {
 				uiTotalPacketLength = PacketToDrop->len;
 				netstats->tx_dropped++;
-			}
-			else
+			} else {
 				uiTotalPacketLength = 0;
+			}
 
 			DEQUEUEPACKET(Adapter->PackInfo[iQIndex].FirstTxQueue,
 						Adapter->PackInfo[iQIndex].LastTxQueue);
@@ -423,7 +413,7 @@ VOID flush_all_queues(struct bcm_mini_adapter *Adapter)
 			/* Free the skb */
 			dev_kfree_skb(PacketToDrop);
 
-			/// update current bytes and packets count
+			/* update current bytes and packets count */
 			Adapter->PackInfo[iQIndex].uiCurrentBytesOnHost -= uiTotalPacketLength;
 			Adapter->PackInfo[iQIndex].uiCurrentPacketsOnHost--;
 
@@ -444,16 +434,15 @@ VOID flush_all_queues(struct bcm_mini_adapter *Adapter)
 
 USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb)
 {
-	INT			uiLoopIndex=0;
+	INT uiLoopIndex=0;
 	struct bcm_classifier_rule *pstClassifierRule = NULL;
 	struct bcm_eth_packet_info stEthCsPktInfo;
 	PVOID pvEThPayload = NULL;
 	struct iphdr 		*pIpHeader = NULL;
-	INT	  uiSfIndex=0;
-	USHORT	usIndex=Adapter->usBestEffortQueueIndex;
+	INT uiSfIndex=0;
+	USHORT usIndex=Adapter->usBestEffortQueueIndex;
 	BOOLEAN	bFragmentedPkt=FALSE,bClassificationSucceed=FALSE;
-	USHORT	usCurrFragment =0;
-
+	USHORT usCurrFragment =0;
 	struct bcm_tcp_header *pTcpHeader;
 	UCHAR IpHeaderLength;
 	UCHAR TcpHeaderLength;
@@ -462,84 +451,66 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb)
 	*((UINT32*) (skb->cb) +SKB_CB_TCPACK_OFFSET ) = 0;
 	EThCSGetPktInfo(Adapter,pvEThPayload,&stEthCsPktInfo);
 
-	switch(stEthCsPktInfo.eNwpktEthFrameType)
-	{
-		case eEth802LLCFrame:
-		{
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802LLCFrame\n");
-			pIpHeader = pvEThPayload + sizeof(struct bcm_eth_llc_frame);
-			break;
-		}
-
-		case eEth802LLCSNAPFrame:
-		{
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802LLC SNAP Frame\n");
-			pIpHeader = pvEThPayload + sizeof(struct bcm_eth_llc_snap_frame);
-			break;
-		}
-		case eEth802QVLANFrame:
-		{
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802.1Q VLANFrame\n");
-			pIpHeader = pvEThPayload + sizeof(struct bcm_eth_q_frame);
-			break;
-		}
-		case eEthOtherFrame:
-		{
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : ETH Other Frame\n");
-			pIpHeader = pvEThPayload + sizeof(struct bcm_ethernet2_frame);
-			break;
-		}
-		default:
-		{
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : Unrecognized ETH Frame\n");
-			pIpHeader = pvEThPayload + sizeof(struct bcm_ethernet2_frame);
-			break;
-		}
+	switch (stEthCsPktInfo.eNwpktEthFrameType) {
+	case eEth802LLCFrame:
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802LLCFrame\n");
+		pIpHeader = pvEThPayload + sizeof(struct bcm_eth_llc_frame);
+		break;
+	case eEth802LLCSNAPFrame:
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802LLC SNAP Frame\n");
+		pIpHeader = pvEThPayload + sizeof(struct bcm_eth_llc_snap_frame);
+		break;
+	case eEth802QVLANFrame:
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : 802.1Q VLANFrame\n");
+		pIpHeader = pvEThPayload + sizeof(struct bcm_eth_q_frame);
+		break;
+	case eEthOtherFrame:
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : ETH Other Frame\n");
+		pIpHeader = pvEThPayload + sizeof(struct bcm_ethernet2_frame);
+		break;
+	default:
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "ClassifyPacket : Unrecognized ETH Frame\n");
+		pIpHeader = pvEThPayload + sizeof(struct bcm_ethernet2_frame);
+		break;
 	}
 
-	if(stEthCsPktInfo.eNwpktIPFrameType == eIPv4Packet)
-	{
+	if (stEthCsPktInfo.eNwpktIPFrameType == eIPv4Packet) {
 		usCurrFragment = (ntohs(pIpHeader->frag_off) & IP_OFFSET);
-		if((ntohs(pIpHeader->frag_off) & IP_MF) || usCurrFragment)
+		if ((ntohs(pIpHeader->frag_off) & IP_MF) || usCurrFragment)
 			bFragmentedPkt = TRUE;
 
-		if(bFragmentedPkt)
-		{
-				//Fragmented  Packet. Get Frag Classifier Entry.
+		if (bFragmentedPkt) {
+			/* Fragmented  Packet. Get Frag Classifier Entry. */
 			pstClassifierRule = GetFragIPClsEntry(Adapter,pIpHeader->id, pIpHeader->saddr);
-			if(pstClassifierRule)
-			{
+			if (pstClassifierRule) {
 					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,"It is next Fragmented pkt");
 					bClassificationSucceed=TRUE;
 			}
-			if(!(ntohs(pIpHeader->frag_off) & IP_MF))
-			{
-				//Fragmented Last packet . Remove Frag Classifier Entry
+			if (!(ntohs(pIpHeader->frag_off) & IP_MF)) {
+				/* Fragmented Last packet . Remove Frag Classifier Entry */
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,"This is the last fragmented Pkt");
 				DelFragIPClsEntry(Adapter,pIpHeader->id, pIpHeader->saddr);
 			}
 		}
 	}
 
-	for(uiLoopIndex = MAX_CLASSIFIERS - 1; uiLoopIndex >= 0; uiLoopIndex--)
-	{
-		if(bClassificationSucceed)
+	for (uiLoopIndex = MAX_CLASSIFIERS - 1; uiLoopIndex >= 0; uiLoopIndex--) {
+		if (bClassificationSucceed)
 			break;
-		//Iterate through all classifiers which are already in order of priority
-		//to classify the packet until match found
-		do
-		{
-			if(FALSE==Adapter->astClassifierTable[uiLoopIndex].bUsed)
-			{
+		/*
+		Iterate through all classifiers which are already in order of priority
+		to classify the packet until match found
+		*/
+		do {
+			if (FALSE == Adapter->astClassifierTable[uiLoopIndex].bUsed) {
 				bClassificationSucceed=FALSE;
 				break;
 			}
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Adapter->PackInfo[%d].bvalid=True\n",uiLoopIndex);
 
-			if(0 == Adapter->astClassifierTable[uiLoopIndex].ucDirection)
-			{
-				bClassificationSucceed=FALSE;//cannot be processed for classification.
-				break;						// it is a down link connection
+			if (0 == Adapter->astClassifierTable[uiLoopIndex].ucDirection) {
+				bClassificationSucceed=FALSE; /* cannot be processed for classification. */
+				break;				/* it is a down link connection */
 			}
 
 			pstClassifierRule = &Adapter->astClassifierTable[uiLoopIndex];
@@ -550,32 +521,23 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb)
 				break;
 			}
 
-			if(Adapter->PackInfo[uiSfIndex].bEthCSSupport)
-			{
+			if (Adapter->PackInfo[uiSfIndex].bEthCSSupport) {
 
-				if(eEthUnsupportedFrame==stEthCsPktInfo.eNwpktEthFrameType)
-				{
+				if (eEthUnsupportedFrame == stEthCsPktInfo.eNwpktEthFrameType) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  " ClassifyPacket : Packet Not a Valid Supported Ethernet Frame \n");
 					bClassificationSucceed = FALSE;
 					break;
 				}
 
-
-
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Performing ETH CS Classification on Classifier Rule ID : %x Service Flow ID : %lx\n",pstClassifierRule->uiClassifierRuleIndex,Adapter->PackInfo[uiSfIndex].ulSFID);
 				bClassificationSucceed = EThCSClassifyPkt(Adapter,skb,&stEthCsPktInfo,pstClassifierRule, Adapter->PackInfo[uiSfIndex].bEthCSSupport);
 
-				if(!bClassificationSucceed)
-				{
+				if (!bClassificationSucceed) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ClassifyPacket : Ethernet CS Classification Failed\n");
 					break;
 				}
-			}
-
-			else // No ETH Supported on this SF
-			{
-				if(eEthOtherFrame != stEthCsPktInfo.eNwpktEthFrameType)
-				{
+			} else { /* No ETH Supported on this SF */
+				if (eEthOtherFrame != stEthCsPktInfo.eNwpktEthFrameType) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  " ClassifyPacket : Packet Not a 802.3 Ethernet Frame... hence not allowed over non-ETH CS SF \n");
 					bClassificationSucceed = FALSE;
 					break;
@@ -584,11 +546,8 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb)
 
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Proceeding to IP CS Clasification");
 
-			if(Adapter->PackInfo[uiSfIndex].bIPCSSupport)
-			{
-
-				if(stEthCsPktInfo.eNwpktIPFrameType == eNonIPPacket)
-				{
+			if (Adapter->PackInfo[uiSfIndex].bIPCSSupport) {
+				if (stEthCsPktInfo.eNwpktIPFrameType == eNonIPPacket) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  " ClassifyPacket : Packet is Not an IP Packet \n");
 					bClassificationSucceed = FALSE;
 					break;
@@ -596,41 +555,38 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb)
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Dump IP Header : \n");
 				DumpFullPacket((PUCHAR)pIpHeader,20);
 
-				if(stEthCsPktInfo.eNwpktIPFrameType == eIPv4Packet)
+				if (stEthCsPktInfo.eNwpktIPFrameType == eIPv4Packet)
 					bClassificationSucceed = IpVersion4(Adapter,pIpHeader,pstClassifierRule);
-				else if(stEthCsPktInfo.eNwpktIPFrameType == eIPv6Packet)
+				else if (stEthCsPktInfo.eNwpktIPFrameType == eIPv6Packet)
 					bClassificationSucceed = IpVersion6(Adapter,pIpHeader,pstClassifierRule);
 			}
 
-		}while(0);
+		} while(0);
 	}
 
-	if(bClassificationSucceed == TRUE)
-	{
+	if (bClassificationSucceed == TRUE) {
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "CF id : %d, SF ID is =%lu",pstClassifierRule->uiClassifierRuleIndex, pstClassifierRule->ulSFID);
 
-		//Store The matched Classifier in SKB
+		/* Store The matched Classifier in SKB */
 		*((UINT32*)(skb->cb)+SKB_CB_CLASSIFICATION_OFFSET) = pstClassifierRule->uiClassifierRuleIndex;
-		if((TCP == pIpHeader->protocol ) && !bFragmentedPkt && (ETH_AND_IP_HEADER_LEN + TCP_HEADER_LEN <= skb->len) )
-		{
-			 IpHeaderLength   = pIpHeader->ihl;
+		if ((TCP == pIpHeader->protocol ) && !bFragmentedPkt && (ETH_AND_IP_HEADER_LEN + TCP_HEADER_LEN <= skb->len)) {
+			 IpHeaderLength = pIpHeader->ihl;
 			 pTcpHeader = (struct bcm_tcp_header *)(((PUCHAR)pIpHeader)+(IpHeaderLength*4));
-			 TcpHeaderLength  = GET_TCP_HEADER_LEN(pTcpHeader->HeaderLength);
+			 TcpHeaderLength = GET_TCP_HEADER_LEN(pTcpHeader->HeaderLength);
 
-			if((pTcpHeader->ucFlags & TCP_ACK) &&
-			   (ntohs(pIpHeader->tot_len) == (IpHeaderLength*4)+(TcpHeaderLength*4)))
+			if ((pTcpHeader->ucFlags & TCP_ACK) &&
+					(ntohs(pIpHeader->tot_len) == (IpHeaderLength*4)+(TcpHeaderLength*4)))
 			{
-    			*((UINT32*) (skb->cb) +SKB_CB_TCPACK_OFFSET ) = TCP_ACK;
+    				*((UINT32*) (skb->cb) +SKB_CB_TCPACK_OFFSET ) = TCP_ACK;
 			}
 		}
 
 		usIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "index is	=%d", usIndex);
 
-		//If this is the first fragment of a Fragmented pkt, add this CF. Only This CF should be used for all other fragment of this Pkt.
-		if(bFragmentedPkt && (usCurrFragment == 0))
-		{
-			//First Fragment of Fragmented Packet. Create Frag CLS Entry
+		/* If this is the first fragment of a Fragmented pkt, add this CF. Only This CF should be used for all other fragment of this Pkt. */
+		if (bFragmentedPkt && (usCurrFragment == 0)) {
+			/* First Fragment of Fragmented Packet. Create Frag CLS Entry */
 			struct bcm_fragmented_packet_info stFragPktInfo;
 			stFragPktInfo.bUsed = TRUE;
 			stFragPktInfo.ulSrcIpAddress = pIpHeader->saddr;
@@ -643,7 +599,7 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb)
 
 	}
 
-	if(bClassificationSucceed)
+	if (bClassificationSucceed)
 		return usIndex;
 	else
 		return INVALID_QUEUE_INDEX;
@@ -651,34 +607,44 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb)
 
 static BOOLEAN EthCSMatchSrcMACAddress(struct bcm_classifier_rule *pstClassifierRule,PUCHAR Mac)
 {
-	UINT i=0;
+	UINT i = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	if(pstClassifierRule->ucEthCSSrcMACLen==0)
+
+	if (pstClassifierRule->ucEthCSSrcMACLen == 0)
 		return TRUE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s \n",__FUNCTION__);
-	for(i=0;i<MAC_ADDRESS_SIZE;i++)
-	{
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "SRC MAC[%x] = %x ClassifierRuleSrcMAC = %x Mask : %x\n",i,Mac[i],pstClassifierRule->au8EThCSSrcMAC[i],pstClassifierRule->au8EThCSSrcMACMask[i]);
-		if((pstClassifierRule->au8EThCSSrcMAC[i] & pstClassifierRule->au8EThCSSrcMACMask[i])!=
-			(Mac[i] & pstClassifierRule->au8EThCSSrcMACMask[i]))
+	for (i = 0; i < MAC_ADDRESS_SIZE; i++) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, 
+				"SRC MAC[%x] = %x ClassifierRuleSrcMAC = %x Mask : %x\n",
+				i, Mac[i],pstClassifierRule->au8EThCSSrcMAC[i],
+				pstClassifierRule->au8EThCSSrcMACMask[i]);
+		if ((pstClassifierRule->au8EThCSSrcMAC[i] & pstClassifierRule->au8EThCSSrcMACMask[i])!=
+				(Mac[i] & pstClassifierRule->au8EThCSSrcMACMask[i]))
+		{
 			return FALSE;
+		}
 	}
 	return TRUE;
 }
 
 static BOOLEAN EthCSMatchDestMACAddress(struct bcm_classifier_rule *pstClassifierRule,PUCHAR Mac)
 {
-	UINT i=0;
+	UINT i = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	if(pstClassifierRule->ucEthCSDestMACLen==0)
+
+	if (pstClassifierRule->ucEthCSDestMACLen == 0)
 		return TRUE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s \n",__FUNCTION__);
-	for(i=0;i<MAC_ADDRESS_SIZE;i++)
-	{
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "SRC MAC[%x] = %x ClassifierRuleSrcMAC = %x Mask : %x\n",i,Mac[i],pstClassifierRule->au8EThCSDestMAC[i],pstClassifierRule->au8EThCSDestMACMask[i]);
-		if((pstClassifierRule->au8EThCSDestMAC[i] & pstClassifierRule->au8EThCSDestMACMask[i])!=
-			(Mac[i] & pstClassifierRule->au8EThCSDestMACMask[i]))
+	for (i = 0;i < MAC_ADDRESS_SIZE; i++) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,
+				"SRC MAC[%x] = %x ClassifierRuleSrcMAC = %x Mask : %x\n",
+				i, Mac[i],pstClassifierRule->au8EThCSDestMAC[i],
+				pstClassifierRule->au8EThCSDestMACMask[i]);
+		if ((pstClassifierRule->au8EThCSDestMAC[i] & pstClassifierRule->au8EThCSDestMACMask[i])!=
+				(Mac[i] & pstClassifierRule->au8EThCSDestMACMask[i]))
+		{
 			return FALSE;
+		}
 	}
 	return TRUE;
 }
@@ -686,28 +652,37 @@ static BOOLEAN EthCSMatchDestMACAddress(struct bcm_classifier_rule *pstClassifie
 static BOOLEAN EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifierRule,struct sk_buff* skb, struct bcm_eth_packet_info *pstEthCsPktInfo)
 {
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	if((pstClassifierRule->ucEtherTypeLen==0)||
-		(pstClassifierRule->au8EthCSEtherType[0] == 0))
-		return TRUE;
 
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s SrcEtherType:%x CLS EtherType[0]:%x\n",__FUNCTION__,pstEthCsPktInfo->usEtherType,pstClassifierRule->au8EthCSEtherType[0]);
-	if(pstClassifierRule->au8EthCSEtherType[0] == 1)
+	if ((pstClassifierRule->ucEtherTypeLen==0)||
+		(pstClassifierRule->au8EthCSEtherType[0] == 0))
 	{
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS EtherType[1]:%x EtherType[2]:%x\n",__FUNCTION__,pstClassifierRule->au8EthCSEtherType[1],pstClassifierRule->au8EthCSEtherType[2]);
+		return TRUE;
+	}
 
-		if(memcmp(&pstEthCsPktInfo->usEtherType,&pstClassifierRule->au8EthCSEtherType[1],2)==0)
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,
+			"%s SrcEtherType:%x CLS EtherType[0]:%x\n",
+			__FUNCTION__, pstEthCsPktInfo->usEtherType,
+			pstClassifierRule->au8EthCSEtherType[0]);
+	if (pstClassifierRule->au8EthCSEtherType[0] == 1) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,
+				"%s  CLS EtherType[1]:%x EtherType[2]:%x\n",
+				__FUNCTION__, pstClassifierRule->au8EthCSEtherType[1],
+				pstClassifierRule->au8EthCSEtherType[2]);
+		if (memcmp(&pstEthCsPktInfo->usEtherType, &pstClassifierRule->au8EthCSEtherType[1], 2) == 0)
 			return TRUE;
 		else
 			return FALSE;
 	}
 
-	if(pstClassifierRule->au8EthCSEtherType[0] == 2)
-	{
-		if(eEth802LLCFrame != pstEthCsPktInfo->eNwpktEthFrameType)
+	if (pstClassifierRule->au8EthCSEtherType[0] == 2) {
+		if (eEth802LLCFrame != pstEthCsPktInfo->eNwpktEthFrameType)
 			return FALSE;
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  EthCS DSAP:%x EtherType[2]:%x\n",__FUNCTION__,pstEthCsPktInfo->ucDSAP,pstClassifierRule->au8EthCSEtherType[2]);
-		if(pstEthCsPktInfo->ucDSAP == pstClassifierRule->au8EthCSEtherType[2])
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,
+				"%s  EthCS DSAP:%x EtherType[2]:%x\n",
+				__FUNCTION__,pstEthCsPktInfo->ucDSAP,
+				pstClassifierRule->au8EthCSEtherType[2]);
+		if (pstEthCsPktInfo->ucDSAP == pstClassifierRule->au8EthCSEtherType[2])
 			return TRUE;
 		else
 			return FALSE;
@@ -725,20 +700,25 @@ static BOOLEAN EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule
 	B_UINT8 uPriority = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS UserPrio:%x CLS VLANID:%x\n",__FUNCTION__,ntohs(*((USHORT *)pstClassifierRule->usUserPriority)),pstClassifierRule->usVLANID);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,
+			"%s  CLS UserPrio:%x CLS VLANID:%x\n",
+			__FUNCTION__, ntohs(*((USHORT *)pstClassifierRule->usUserPriority)),
+			pstClassifierRule->usVLANID);
 
 	/* In case FW didn't receive the TLV, the priority field should be ignored */
-	if(pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_USER_PRIORITY_VALID))
-	{
-		if(pstEthCsPktInfo->eNwpktEthFrameType!=eEth802QVLANFrame)
+	if (pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_USER_PRIORITY_VALID)) {
+		if (pstEthCsPktInfo->eNwpktEthFrameType!=eEth802QVLANFrame)
 				return FALSE;
 
 		uPriority = (ntohs(*(USHORT *)(skb->data + sizeof(struct bcm_eth_header))) & 0xF000) >> 13;
 
-		if((uPriority >= pstClassifierRule->usUserPriority[0]) && (uPriority <= pstClassifierRule->usUserPriority[1]))
+		if ((uPriority >= pstClassifierRule->usUserPriority[0]) &&
+			(uPriority <= pstClassifierRule->usUserPriority[1]))
+		{
 				bClassificationSucceed = TRUE;
+		}
 
-		if(!bClassificationSucceed)
+		if (!bClassificationSucceed)
 			return FALSE;
 	}
 
@@ -746,8 +726,7 @@ static BOOLEAN EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule
 
 	bClassificationSucceed = FALSE;
 
-	if(pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_VLANID_VALID))
-	{
+	if (pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_VLANID_VALID)) {
 		if(pstEthCsPktInfo->eNwpktEthFrameType!=eEth802QVLANFrame)
 				return FALSE;
 
@@ -755,10 +734,10 @@ static BOOLEAN EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  Pkt VLANID %x Priority: %d\n",__FUNCTION__,usVLANID, uPriority);
 
-		if(usVLANID == ((pstClassifierRule->usVLANID & 0xFFF0) >> 4))
+		if (usVLANID == ((pstClassifierRule->usVLANID & 0xFFF0) >> 4))
 			bClassificationSucceed = TRUE;
 
-		if(!bClassificationSucceed)
+		if (!bClassificationSucceed)
 			return FALSE;
 	}
 
@@ -774,27 +753,27 @@ static BOOLEAN EThCSClassifyPkt(struct bcm_mini_adapter *Adapter,struct sk_buff*
 				B_UINT8 EthCSCupport)
 {
 	BOOLEAN bClassificationSucceed = FALSE;
+
 	bClassificationSucceed = EthCSMatchSrcMACAddress(pstClassifierRule,((struct bcm_eth_header *)(skb->data))->au8SourceAddress);
-	if(!bClassificationSucceed)
+	if (!bClassificationSucceed)
 		return FALSE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ETH CS SrcMAC Matched\n");
 
 	bClassificationSucceed = EthCSMatchDestMACAddress(pstClassifierRule,((struct bcm_eth_header *)(skb->data))->au8DestinationAddress);
-	if(!bClassificationSucceed)
+	if (!bClassificationSucceed)
 		return FALSE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ETH CS DestMAC Matched\n");
 
-	//classify on ETHType/802.2SAP TLV
+	/* classify on ETHType/802.2SAP TLV */
 	bClassificationSucceed = EthCSMatchEThTypeSAP(pstClassifierRule,skb,pstEthCsPktInfo);
 	if(!bClassificationSucceed)
 		return FALSE;
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ETH CS EthType/802.2SAP Matched\n");
 
-	//classify on 802.1VLAN Header Parameters
-
+	/* classify on 802.1VLAN Header Parameters */
 	bClassificationSucceed = EthCSMatchVLANRules(pstClassifierRule,skb,pstEthCsPktInfo);
-	if(!bClassificationSucceed)
+	if (!bClassificationSucceed)
 		return FALSE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ETH CS 802.1 VLAN Rules Matched\n");
 
@@ -807,49 +786,40 @@ static void EThCSGetPktInfo(struct bcm_mini_adapter *Adapter,PVOID pvEthPayload,
 	USHORT u16Etype = ntohs(((struct bcm_eth_header *)pvEthPayload)->u16Etype);
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCSGetPktInfo : Eth Hdr Type : %X\n",u16Etype);
-	if(u16Etype > 0x5dc)
-	{
+	if (u16Etype > 0x5dc) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCSGetPktInfo : ETH2 Frame \n");
-		//ETH2 Frame
-		if(u16Etype == ETHERNET_FRAMETYPE_802QVLAN)
-		{
-			//802.1Q VLAN Header
+		/* ETH2 Frame */
+		if (u16Etype == ETHERNET_FRAMETYPE_802QVLAN) {
+			/* 802.1Q VLAN Header */
 			pstEthCsPktInfo->eNwpktEthFrameType = eEth802QVLANFrame;
 			u16Etype = ((struct bcm_eth_q_frame *)pvEthPayload)->EthType;
-			//((ETH_CS_802_Q_FRAME*)pvEthPayload)->UserPriority
-		}
-		else
-		{
+			/* ((ETH_CS_802_Q_FRAME*)pvEthPayload)->UserPriority */
+		} else {
 			pstEthCsPktInfo->eNwpktEthFrameType = eEthOtherFrame;
 			u16Etype = ntohs(u16Etype);
 		}
 
-	}
-	else
-	{
-		//802.2 LLC
+	} else {
+		/* 802.2 LLC */
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "802.2 LLC Frame \n");
 		pstEthCsPktInfo->eNwpktEthFrameType = eEth802LLCFrame;
 		pstEthCsPktInfo->ucDSAP = ((struct bcm_eth_llc_frame *)pvEthPayload)->DSAP;
-		if(pstEthCsPktInfo->ucDSAP == 0xAA && ((struct bcm_eth_llc_frame *)pvEthPayload)->SSAP == 0xAA)
-		{
-			//SNAP Frame
+		if(pstEthCsPktInfo->ucDSAP == 0xAA &&
+				((struct bcm_eth_llc_frame *)pvEthPayload)->SSAP == 0xAA) {
+			/* SNAP Frame */
 			pstEthCsPktInfo->eNwpktEthFrameType = eEth802LLCSNAPFrame;
 			u16Etype = ((struct bcm_eth_llc_snap_frame *)pvEthPayload)->usEtherType;
 		}
 	}
-	if(u16Etype == ETHERNET_FRAMETYPE_IPV4)
+	if (u16Etype == ETHERNET_FRAMETYPE_IPV4)
 		pstEthCsPktInfo->eNwpktIPFrameType = eIPv4Packet;
-	else if(u16Etype == ETHERNET_FRAMETYPE_IPV6)
+	else if (u16Etype == ETHERNET_FRAMETYPE_IPV6)
 		pstEthCsPktInfo->eNwpktIPFrameType = eIPv6Packet;
 	else
 		pstEthCsPktInfo->eNwpktIPFrameType = eNonIPPacket;
 
 	pstEthCsPktInfo->usEtherType = ((struct bcm_eth_header *)pvEthPayload)->u16Etype;
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCsPktInfo->eNwpktIPFrameType : %x\n",pstEthCsPktInfo->eNwpktIPFrameType);
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCsPktInfo->eNwpktEthFrameType : %x\n",pstEthCsPktInfo->eNwpktEthFrameType);
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCsPktInfo->usEtherType : %x\n",pstEthCsPktInfo->usEtherType);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCsPktInfo->eNwpktIPFrameType : %x\n", pstEthCsPktInfo->eNwpktIPFrameType);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCsPktInfo->eNwpktEthFrameType : %x\n", pstEthCsPktInfo->eNwpktEthFrameType);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCsPktInfo->usEtherType : %x\n", pstEthCsPktInfo->usEtherType);
 }
-
-
-
-- 
1.8.3.3



