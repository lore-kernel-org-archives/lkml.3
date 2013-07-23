Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab3GWLvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:51:10 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:46779 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab3GWLvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:51:08 -0400
Message-ID: <1374580262.19434.4.camel@desktop>
Subject: Re: [PATCH] Staging: bcm: Qos: Fix some coding style issues
From: Lilis Iskandar <veeableful@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 19:51:02 +0800
In-Reply-To: <20130723101838.GN5585@mwanda>
References: <1374571229.15906.3.camel@desktop>
	 <20130723095416.GM5585@mwanda> <1374574241.17286.8.camel@desktop>
	 <20130723101838.GN5585@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed spacing/tabs issues that were found using checkpatch.

Signed-off-by: Lilis Iskandar <veeableful@gmail.com>
---
 drivers/staging/bcm/Qos.c | 538 +++++++++++++++++++++++-----------------------
 1 file changed, 269 insertions(+), 269 deletions(-)

diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index 8d142a5..2d4a77c 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -4,11 +4,11 @@ This file contains the routines related to Quality of Service.
 */
 #include "headers.h"
 
-static void EThCSGetPktInfo(struct bcm_mini_adapter *Adapter,PVOID pvEthPayload, struct bcm_eth_packet_info *pstEthCsPktInfo);
-static BOOLEAN EThCSClassifyPkt(struct bcm_mini_adapter *Adapter,struct sk_buff* skb, struct bcm_eth_packet_info *pstEthCsPktInfo,struct bcm_classifier_rule *pstClassifierRule, B_UINT8 EthCSCupport);
+static void EThCSGetPktInfo(struct bcm_mini_adapter *Adapter, PVOID pvEthPayload, struct bcm_eth_packet_info *pstEthCsPktInfo);
+static BOOLEAN EThCSClassifyPkt(struct bcm_mini_adapter *Adapter, struct sk_buff* skb, struct bcm_eth_packet_info *pstEthCsPktInfo, struct bcm_classifier_rule *pstClassifierRule, B_UINT8 EthCSCupport);
 
 static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter, struct iphdr *iphd,
-			   struct bcm_classifier_rule *pstClassifierRule );
+			   struct bcm_classifier_rule *pstClassifierRule);
 
 static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex);
 
@@ -20,30 +20,30 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex);
 *				matches with that of Queue.
 *
 * Parameters  - pstClassifierRule: Pointer to the packet info structure.
-* 			  - ulSrcIP	    : Source IP address from the packet.
+*		- ulSrcIP	    : Source IP address from the packet.
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
-       		return TRUE;
-       	}
-    }
-    BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Ip Address Not Matched");
-   	return FALSE;
+	UCHAR ucLoopIndex = 0;
+
+	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
+
+	ulSrcIP = ntohl(ulSrcIP);
+	if (0 == pstClassifierRule->ucIPSourceAddressLength)
+		return TRUE;
+	for (ucLoopIndex = 0; ucLoopIndex < (pstClassifierRule->ucIPSourceAddressLength); ucLoopIndex++)
+	{
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Ip Address Mask:0x%x PacketIp:0x%x and Classification:0x%x", (UINT)pstClassifierRule->stSrcIpAddress.ulIpv4Mask[ucLoopIndex], (UINT)ulSrcIP, (UINT)pstClassifierRule->stSrcIpAddress.ulIpv6Addr[ucLoopIndex]);
+		if ((pstClassifierRule->stSrcIpAddress.ulIpv4Mask[ucLoopIndex] & ulSrcIP) ==
+				(pstClassifierRule->stSrcIpAddress.ulIpv4Addr[ucLoopIndex] & pstClassifierRule->stSrcIpAddress.ulIpv4Mask[ucLoopIndex]))
+		{
+			return TRUE;
+		}
+	}
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Ip Address Not Matched");
+	return FALSE;
 }
 
 
@@ -54,30 +54,30 @@ BOOLEAN MatchSrcIpAddress(struct bcm_classifier_rule *pstClassifierRule,ULONG ul
 *				matches with that of Queue.
 *
 * Parameters  - pstClassifierRule: Pointer to the packet info structure.
-* 			  - ulDestIP    : Destination IP address from the packet.
+*		- ulDestIP    : Destination IP address from the packet.
 *
 * Returns     - TRUE(If address matches) else FAIL .
 *********************************************************************/
-BOOLEAN MatchDestIpAddress(struct bcm_classifier_rule *pstClassifierRule,ULONG ulDestIP)
+BOOLEAN MatchDestIpAddress(struct bcm_classifier_rule *pstClassifierRule, ULONG ulDestIP)
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
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination Ip Address Not Matched");
-    return FALSE;
+	ulDestIP = ntohl(ulDestIP);
+	if (0 == pstClassifierRule->ucIPDestinationAddressLength)
+		return TRUE;
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination Ip Address 0x%x 0x%x 0x%x  ", (UINT)ulDestIP, (UINT)pstClassifierRule->stDestIpAddress.ulIpv4Mask[ucLoopIndex], (UINT)pstClassifierRule->stDestIpAddress.ulIpv4Addr[ucLoopIndex]);
+
+	for (ucLoopIndex = 0; ucLoopIndex < (pstClassifierRule->ucIPDestinationAddressLength); ucLoopIndex++)
+	{
+		if ((pstClassifierRule->stDestIpAddress.ulIpv4Mask[ucLoopIndex] & ulDestIP) ==
+				(pstClassifierRule->stDestIpAddress.ulIpv4Addr[ucLoopIndex] & pstClassifierRule->stDestIpAddress.ulIpv4Mask[ucLoopIndex]))
+		{
+			return TRUE;
+		}
+	}
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination Ip Address Not Matched");
+	return FALSE;
 }
 
 
@@ -87,23 +87,23 @@ BOOLEAN MatchDestIpAddress(struct bcm_classifier_rule *pstClassifierRule,ULONG u
 * Description - Checks the TOS from the packet matches with that of queue.
 *
 * Parameters  - pstClassifierRule   : Pointer to the packet info structure.
-* 			  - ucTypeOfService: TOS from the packet.
+*		- ucTypeOfService: TOS from the packet.
 *
 * Returns     - TRUE(If address matches) else FAIL.
 **************************************************************************/
-BOOLEAN MatchTos(struct bcm_classifier_rule *pstClassifierRule,UCHAR ucTypeOfService)
+BOOLEAN MatchTos(struct bcm_classifier_rule *pstClassifierRule, UCHAR ucTypeOfService)
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
+	if (3 != pstClassifierRule->ucIPTypeOfServiceLength)
+		return TRUE;
+
+	if (((pstClassifierRule->ucTosMask & ucTypeOfService) <= pstClassifierRule->ucTosHigh) && ((pstClassifierRule->ucTosMask & ucTypeOfService) >= pstClassifierRule->ucTosLow))
+	{
+		return TRUE;
+	}
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Type Of Service Not Matched");
+	return FALSE;
 }
 
 
@@ -113,26 +113,26 @@ BOOLEAN MatchTos(struct bcm_classifier_rule *pstClassifierRule,UCHAR ucTypeOfSer
 * Description - Checks the protocol from the packet matches with that of queue.
 *
 * Parameters  - pstClassifierRule: Pointer to the packet info structure.
-* 			  - ucProtocol	: Protocol from the packet.
+*		- ucProtocol	: Protocol from the packet.
 *
 * Returns     - TRUE(If address matches) else FAIL.
 ****************************************************************************/
-bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule,UCHAR ucProtocol)
+bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule, UCHAR ucProtocol)
 {
-   	UCHAR 	ucLoopIndex=0;
+	UCHAR ucLoopIndex = 0;
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
-   	return FALSE;
+	if (0 == pstClassifierRule->ucProtocolLength)
+		return TRUE;
+	for (ucLoopIndex = 0; ucLoopIndex < pstClassifierRule->ucProtocolLength; ucLoopIndex++)
+	{
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol:0x%X Classification Protocol:0x%X", ucProtocol, pstClassifierRule->ucProtocol[ucLoopIndex]);
+		if (pstClassifierRule->ucProtocol[ucLoopIndex] == ucProtocol)
+		{
+			return TRUE;
+		}
+	}
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol Not Matched");
+	return FALSE;
 }
 
 
@@ -142,29 +142,29 @@ bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule,UCHAR ucProtoco
 * Description - Checks, Source port from the packet matches with that of queue.
 *
 * Parameters  - pstClassifierRule: Pointer to the packet info structure.
-* 			  - ushSrcPort	: Source port from the packet.
+*		- ushSrcPort	: Source port from the packet.
 *
 * Returns     - TRUE(If address matches) else FAIL.
 ***************************************************************************/
-bool MatchSrcPort(struct bcm_classifier_rule *pstClassifierRule,USHORT ushSrcPort)
+bool MatchSrcPort(struct bcm_classifier_rule *pstClassifierRule, USHORT ushSrcPort)
 {
-    	UCHAR 	ucLoopIndex=0;
+	UCHAR ucLoopIndex = 0;
 
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
 
-    	if(0 == pstClassifierRule->ucSrcPortRangeLength)
-        	return TRUE;
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
+	if (0 == pstClassifierRule->ucSrcPortRangeLength)
+		return TRUE;
+	for (ucLoopIndex = 0; ucLoopIndex < pstClassifierRule->ucSrcPortRangeLength; ucLoopIndex++)
+	{
+		if (ushSrcPort <= pstClassifierRule->usSrcPortRangeHi[ucLoopIndex] &&
+			ushSrcPort >= pstClassifierRule->usSrcPortRangeLo[ucLoopIndex])
+		{
+			return TRUE;
+		}
+	}
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Port: %x Not Matched ", ushSrcPort);
+	return FALSE;
 }
 
 
@@ -174,30 +174,30 @@ bool MatchSrcPort(struct bcm_classifier_rule *pstClassifierRule,USHORT ushSrcPor
 * Description - Checks, Destination port from packet matches with that of queue.
 *
 * Parameters  - pstClassifierRule: Pointer to the packet info structure.
-* 			  - ushDestPort	: Destination port from the packet.
+*		- ushDestPort	: Destination port from the packet.
 *
 * Returns     - TRUE(If address matches) else FAIL.
 ***************************************************************************/
-bool MatchDestPort(struct bcm_classifier_rule *pstClassifierRule,USHORT ushDestPort)
+bool MatchDestPort(struct bcm_classifier_rule *pstClassifierRule, USHORT ushDestPort)
 {
-    	UCHAR 	ucLoopIndex=0;
+	UCHAR ucLoopIndex = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-    	if(0 == pstClassifierRule->ucDestPortRangeLength)
-        	return TRUE;
-
-    	for(ucLoopIndex=0;ucLoopIndex<pstClassifierRule->ucDestPortRangeLength;ucLoopIndex++)
-    	{
-        	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Matching Port:0x%X   0x%X  0x%X",ushDestPort,pstClassifierRule->usDestPortRangeLo[ucLoopIndex],pstClassifierRule->usDestPortRangeHi[ucLoopIndex]);
-
- 		if(ushDestPort <= pstClassifierRule->usDestPortRangeHi[ucLoopIndex] &&
-		    ushDestPort >= pstClassifierRule->usDestPortRangeLo[ucLoopIndex])
-	    	{
-		    return TRUE;
-	    	}
-    	}
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Dest Port: %x Not Matched",ushDestPort);
-    	return FALSE;
+	if (0 == pstClassifierRule->ucDestPortRangeLength)
+		return TRUE;
+
+	for (ucLoopIndex = 0; ucLoopIndex < pstClassifierRule->ucDestPortRangeLength; ucLoopIndex++)
+	{
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Matching Port:0x%X   0x%X  0x%X", ushDestPort, pstClassifierRule->usDestPortRangeLo[ucLoopIndex], pstClassifierRule->usDestPortRangeHi[ucLoopIndex]);
+
+		if (ushDestPort <= pstClassifierRule->usDestPortRangeHi[ucLoopIndex] &&
+			ushDestPort >= pstClassifierRule->usDestPortRangeLo[ucLoopIndex])
+		{
+			return TRUE;
+		}
+	}
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Dest Port: %x Not Matched", ushDestPort);
+	return FALSE;
 }
 /**
 @ingroup tx_functions
@@ -209,95 +209,95 @@ static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter,
 			   struct bcm_classifier_rule *pstClassifierRule)
 {
 	struct bcm_transport_header *xprt_hdr = NULL;
-	BOOLEAN	bClassificationSucceed=FALSE;
+	BOOLEAN	bClassificationSucceed = FALSE;
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "========>");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "========>");
 
-	xprt_hdr=(struct bcm_transport_header *)((PUCHAR)iphd + sizeof(struct iphdr));
+	xprt_hdr = (struct bcm_transport_header *)((PUCHAR)iphd + sizeof(struct iphdr));
 
 	do {
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Trying to see Direction = %d %d",
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Trying to see Direction = %d %d",
 			pstClassifierRule->ucDirection,
 			pstClassifierRule->usVCID_Value);
 
 		//Checking classifier validity
-		if(!pstClassifierRule->bUsed || pstClassifierRule->ucDirection == DOWNLINK_DIR)
+		if (!pstClassifierRule->bUsed || pstClassifierRule->ucDirection == DOWNLINK_DIR)
 		{
 			bClassificationSucceed = FALSE;
 			break;
 		}
 
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "is IPv6 check!");
-		if(pstClassifierRule->bIpv6Protocol)
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "is IPv6 check!");
+		if (pstClassifierRule->bIpv6Protocol)
 			break;
 
 		//**************Checking IP header parameter**************************//
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Trying to match Source IP Address");
-		if(FALSE == (bClassificationSucceed =
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Trying to match Source IP Address");
+		if (FALSE == (bClassificationSucceed =
 			MatchSrcIpAddress(pstClassifierRule, iphd->saddr)))
 			break;
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Source IP Address Matched");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Source IP Address Matched");
 
-		if(FALSE == (bClassificationSucceed =
+		if (FALSE == (bClassificationSucceed =
 			MatchDestIpAddress(pstClassifierRule, iphd->daddr)))
 			break;
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination IP Address Matched");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination IP Address Matched");
 
-		if(FALSE == (bClassificationSucceed =
+		if (FALSE == (bClassificationSucceed =
 			MatchTos(pstClassifierRule, iphd->tos)))
 		{
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "TOS Match failed\n");
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "TOS Match failed\n");
 			break;
 		}
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "TOS Matched");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "TOS Matched");
 
-		if(FALSE == (bClassificationSucceed =
-			MatchProtocol(pstClassifierRule,iphd->protocol)))
+		if (FALSE == (bClassificationSucceed =
+			MatchProtocol(pstClassifierRule, iphd->protocol)))
 			break;
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol Matched");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol Matched");
 
 		//if protocol is not TCP or UDP then no need of comparing source port and destination port
-		if(iphd->protocol!=TCP && iphd->protocol!=UDP)
+		if (iphd->protocol != TCP && iphd->protocol != UDP)
 			break;
 		//******************Checking Transport Layer Header field if present *****************//
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Source Port %04x",
-			(iphd->protocol==UDP)?xprt_hdr->uhdr.source:xprt_hdr->thdr.source);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Source Port %04x",
+			(iphd->protocol == UDP) ? xprt_hdr->uhdr.source : xprt_hdr->thdr.source);
 
-		if(FALSE == (bClassificationSucceed =
+		if (FALSE == (bClassificationSucceed =
 			MatchSrcPort(pstClassifierRule,
-				ntohs((iphd->protocol == UDP)?
-				xprt_hdr->uhdr.source:xprt_hdr->thdr.source))))
+				ntohs((iphd->protocol == UDP) ?
+				xprt_hdr->uhdr.source : xprt_hdr->thdr.source))))
 			break;
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Port Matched");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Port Matched");
 
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination Port %04x",
-			(iphd->protocol==UDP)?xprt_hdr->uhdr.dest:
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination Port %04x",
+			(iphd->protocol == UDP) ? xprt_hdr->uhdr.dest :
 			xprt_hdr->thdr.dest);
-		if(FALSE == (bClassificationSucceed =
+		if (FALSE == (bClassificationSucceed =
 			MatchDestPort(pstClassifierRule,
-			ntohs((iphd->protocol == UDP)?
-			xprt_hdr->uhdr.dest:xprt_hdr->thdr.dest))))
+			ntohs((iphd->protocol == UDP) ?
+			xprt_hdr->uhdr.dest : xprt_hdr->thdr.dest))))
 			break;
-	} while(0);
+	} while (0);
 
-	if(TRUE==bClassificationSucceed)
+	if (TRUE == bClassificationSucceed)
 	{
 		INT iMatchedSFQueueIndex = 0;
-		iMatchedSFQueueIndex = SearchSfid(Adapter,pstClassifierRule->ulSFID);
-		if(iMatchedSFQueueIndex >= NO_OF_QUEUES)
+		iMatchedSFQueueIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
+		if (iMatchedSFQueueIndex >= NO_OF_QUEUES)
 		{
 			bClassificationSucceed = FALSE;
 		}
 		else
 		{
-			if(FALSE == Adapter->PackInfo[iMatchedSFQueueIndex].bActive)
+			if (FALSE == Adapter->PackInfo[iMatchedSFQueueIndex].bActive)
 			{
 				bClassificationSucceed = FALSE;
 			}
 		}
 	}
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "IpVersion4 <==========");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "IpVersion4 <==========");
 
 	return bClassificationSucceed;
 }
@@ -306,9 +306,9 @@ VOID PruneQueueAllSF(struct bcm_mini_adapter *Adapter)
 {
 	UINT iIndex = 0;
 
-	for(iIndex = 0; iIndex < HiPriority; iIndex++)
+	for (iIndex = 0; iIndex < HiPriority; iIndex++)
 	{
-		if(!Adapter->PackInfo[iIndex].bValid)
+		if (!Adapter->PackInfo[iIndex].bValid)
 			continue;
 
 		PruneQueue(Adapter, iIndex);
@@ -325,15 +325,15 @@ less than or equal to max queue size for the queue.
 */
 static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 {
-	struct sk_buff* PacketToDrop=NULL;
+	struct sk_buff* PacketToDrop = NULL;
 	struct net_device_stats *netstats;
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "=====> Index %d",iIndex);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "=====> Index %d", iIndex);
 
-   	if(iIndex == HiPriority)
+	if (iIndex == HiPriority)
 		return;
 
-	if(!Adapter || (iIndex < 0) || (iIndex > HiPriority))
+	if (!Adapter || (iIndex < 0) || (iIndex > HiPriority))
 		return;
 
 	/* To Store the netdevice statistic */
@@ -341,26 +341,26 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 
 	spin_lock_bh(&Adapter->PackInfo[iIndex].SFQueueLock);
 
-	while(1)
+	while (1)
 //	while((UINT)Adapter->PackInfo[iIndex].uiCurrentPacketsOnHost >
 //		SF_MAX_ALLOWED_PACKETS_TO_BACKUP)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "uiCurrentBytesOnHost:%x uiMaxBucketSize :%x",
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "uiCurrentBytesOnHost:%x uiMaxBucketSize :%x",
 		Adapter->PackInfo[iIndex].uiCurrentBytesOnHost,
 		Adapter->PackInfo[iIndex].uiMaxBucketSize);
 
 		PacketToDrop = Adapter->PackInfo[iIndex].FirstTxQueue;
 
-		if(PacketToDrop == NULL)
+		if (PacketToDrop == NULL)
 			break;
-		if((Adapter->PackInfo[iIndex].uiCurrentPacketsOnHost < SF_MAX_ALLOWED_PACKETS_TO_BACKUP) &&
+		if ((Adapter->PackInfo[iIndex].uiCurrentPacketsOnHost < SF_MAX_ALLOWED_PACKETS_TO_BACKUP) &&
 			((1000*(jiffies - *((B_UINT32 *)(PacketToDrop->cb)+SKB_CB_LATENCY_OFFSET))/HZ) <= Adapter->PackInfo[iIndex].uiMaxLatency))
 			break;
 
-		if(PacketToDrop)
+		if (PacketToDrop)
 		{
 			if (netif_msg_tx_err(Adapter))
-				pr_info(PFX "%s: tx queue %d overlimit\n", 
+				pr_info(PFX "%s: tx queue %d overlimit\n",
 					Adapter->dev->name, iIndex);
 
 			netstats->tx_dropped++;
@@ -378,7 +378,7 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 
 		}
 
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "Dropped Bytes:%x Dropped Packets:%x",
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "Dropped Bytes:%x Dropped Packets:%x",
 			Adapter->PackInfo[iIndex].uiDroppedCountBytes,
 			Adapter->PackInfo[iIndex].uiDroppedCountPackets);
 
@@ -387,29 +387,29 @@ static VOID PruneQueue(struct bcm_mini_adapter *Adapter, INT iIndex)
 
 	spin_unlock_bh(&Adapter->PackInfo[iIndex].SFQueueLock);
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "TotalPacketCount:%x",
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "TotalPacketCount:%x",
 		atomic_read(&Adapter->TotalPacketCount));
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "<=====");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, PRUNE_QUEUE, DBG_LVL_ALL, "<=====");
 }
 
 VOID flush_all_queues(struct bcm_mini_adapter *Adapter)
 {
 	INT		iQIndex;
 	UINT	uiTotalPacketLength;
-	struct sk_buff*			PacketToDrop=NULL;
+	struct sk_buff*			PacketToDrop = NULL;
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "=====>");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "=====>");
 
 //	down(&Adapter->data_packet_queue_lock);
-	for(iQIndex=LowPriority; iQIndex<HiPriority; iQIndex++)
+	for (iQIndex = LowPriority; iQIndex < HiPriority; iQIndex++)
 	{
 		struct net_device_stats *netstats = &Adapter->dev->stats;
 
 		spin_lock_bh(&Adapter->PackInfo[iQIndex].SFQueueLock);
-		while(Adapter->PackInfo[iQIndex].FirstTxQueue)
+		while (Adapter->PackInfo[iQIndex].FirstTxQueue)
 		{
 			PacketToDrop = Adapter->PackInfo[iQIndex].FirstTxQueue;
-			if(PacketToDrop)
+			if (PacketToDrop)
 			{
 				uiTotalPacketLength = PacketToDrop->len;
 				netstats->tx_dropped++;
@@ -431,7 +431,7 @@ VOID flush_all_queues(struct bcm_mini_adapter *Adapter)
 			Adapter->PackInfo[iQIndex].uiDroppedCountBytes += uiTotalPacketLength;
 			Adapter->PackInfo[iQIndex].uiDroppedCountPackets++;
 
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "Dropped Bytes:%x Dropped Packets:%x",
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "Dropped Bytes:%x Dropped Packets:%x",
 					Adapter->PackInfo[iQIndex].uiDroppedCountBytes,
 					Adapter->PackInfo[iQIndex].uiDroppedCountPackets);
 			atomic_dec(&Adapter->TotalPacketCount);
@@ -439,30 +439,30 @@ VOID flush_all_queues(struct bcm_mini_adapter *Adapter)
 		spin_unlock_bh(&Adapter->PackInfo[iQIndex].SFQueueLock);
 	}
 //	up(&Adapter->data_packet_queue_lock);
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "<=====");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_INFO, DBG_LVL_ALL, "<=====");
 }
 
-USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb)
+USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff* skb)
 {
-	INT			uiLoopIndex=0;
+	INT			uiLoopIndex = 0;
 	struct bcm_classifier_rule *pstClassifierRule = NULL;
 	struct bcm_eth_packet_info stEthCsPktInfo;
 	PVOID pvEThPayload = NULL;
-	struct iphdr 		*pIpHeader = NULL;
-	INT	  uiSfIndex=0;
-	USHORT	usIndex=Adapter->usBestEffortQueueIndex;
-	BOOLEAN	bFragmentedPkt=FALSE,bClassificationSucceed=FALSE;
-	USHORT	usCurrFragment =0;
+	struct iphdr *pIpHeader = NULL;
+	INT	  uiSfIndex = 0;
+	USHORT	usIndex = Adapter->usBestEffortQueueIndex;
+	BOOLEAN	bFragmentedPkt = FALSE, bClassificationSucceed = FALSE;
+	USHORT	usCurrFragment = 0;
 
 	struct bcm_tcp_header *pTcpHeader;
 	UCHAR IpHeaderLength;
 	UCHAR TcpHeaderLength;
 
 	pvEThPayload = skb->data;
-	*((UINT32*) (skb->cb) +SKB_CB_TCPACK_OFFSET ) = 0;
-	EThCSGetPktInfo(Adapter,pvEThPayload,&stEthCsPktInfo);
+	*((UINT32*) (skb->cb) +SKB_CB_TCPACK_OFFSET) = 0;
+	EThCSGetPktInfo(Adapter, pvEThPayload, &stEthCsPktInfo);
 
-	switch(stEthCsPktInfo.eNwpktEthFrameType)
+	switch (stEthCsPktInfo.eNwpktEthFrameType)
 	{
 		case eEth802LLCFrame:
 		{
@@ -497,75 +497,75 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb)
 		}
 	}
 
-	if(stEthCsPktInfo.eNwpktIPFrameType == eIPv4Packet)
+	if (stEthCsPktInfo.eNwpktIPFrameType == eIPv4Packet)
 	{
 		usCurrFragment = (ntohs(pIpHeader->frag_off) & IP_OFFSET);
-		if((ntohs(pIpHeader->frag_off) & IP_MF) || usCurrFragment)
+		if ((ntohs(pIpHeader->frag_off) & IP_MF) || usCurrFragment)
 			bFragmentedPkt = TRUE;
 
-		if(bFragmentedPkt)
+		if (bFragmentedPkt)
 		{
 				//Fragmented  Packet. Get Frag Classifier Entry.
-			pstClassifierRule = GetFragIPClsEntry(Adapter,pIpHeader->id, pIpHeader->saddr);
-			if(pstClassifierRule)
+			pstClassifierRule = GetFragIPClsEntry(Adapter, pIpHeader->id, pIpHeader->saddr);
+			if (pstClassifierRule)
 			{
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,"It is next Fragmented pkt");
-					bClassificationSucceed=TRUE;
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "It is next Fragmented pkt");
+					bClassificationSucceed = TRUE;
 			}
-			if(!(ntohs(pIpHeader->frag_off) & IP_MF))
+			if (!(ntohs(pIpHeader->frag_off) & IP_MF))
 			{
 				//Fragmented Last packet . Remove Frag Classifier Entry
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,"This is the last fragmented Pkt");
-				DelFragIPClsEntry(Adapter,pIpHeader->id, pIpHeader->saddr);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "This is the last fragmented Pkt");
+				DelFragIPClsEntry(Adapter, pIpHeader->id, pIpHeader->saddr);
 			}
 		}
 	}
 
-	for(uiLoopIndex = MAX_CLASSIFIERS - 1; uiLoopIndex >= 0; uiLoopIndex--)
+	for (uiLoopIndex = MAX_CLASSIFIERS - 1; uiLoopIndex >= 0; uiLoopIndex--)
 	{
-		if(bClassificationSucceed)
+		if (bClassificationSucceed)
 			break;
 		//Iterate through all classifiers which are already in order of priority
 		//to classify the packet until match found
 		do
 		{
-			if(FALSE==Adapter->astClassifierTable[uiLoopIndex].bUsed)
+			if (FALSE == Adapter->astClassifierTable[uiLoopIndex].bUsed)
 			{
-				bClassificationSucceed=FALSE;
+				bClassificationSucceed = FALSE;
 				break;
 			}
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Adapter->PackInfo[%d].bvalid=True\n",uiLoopIndex);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Adapter->PackInfo[%d].bvalid=True\n", uiLoopIndex);
 
-			if(0 == Adapter->astClassifierTable[uiLoopIndex].ucDirection)
+			if (0 == Adapter->astClassifierTable[uiLoopIndex].ucDirection)
 			{
-				bClassificationSucceed=FALSE;//cannot be processed for classification.
+				bClassificationSucceed = FALSE;//cannot be processed for classification.
 				break;						// it is a down link connection
 			}
 
 			pstClassifierRule = &Adapter->astClassifierTable[uiLoopIndex];
 
-			uiSfIndex = SearchSfid(Adapter,pstClassifierRule->ulSFID);
+			uiSfIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
 			if (uiSfIndex >= NO_OF_QUEUES) {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Queue Not Valid. SearchSfid for this classifier Failed\n");
 				break;
 			}
 
-			if(Adapter->PackInfo[uiSfIndex].bEthCSSupport)
+			if (Adapter->PackInfo[uiSfIndex].bEthCSSupport)
 			{
 
-				if(eEthUnsupportedFrame==stEthCsPktInfo.eNwpktEthFrameType)
+				if (eEthUnsupportedFrame == stEthCsPktInfo.eNwpktEthFrameType)
 				{
-					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  " ClassifyPacket : Packet Not a Valid Supported Ethernet Frame \n");
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, " ClassifyPacket : Packet Not a Valid Supported Ethernet Frame\n");
 					bClassificationSucceed = FALSE;
 					break;
 				}
 
 
 
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Performing ETH CS Classification on Classifier Rule ID : %x Service Flow ID : %lx\n",pstClassifierRule->uiClassifierRuleIndex,Adapter->PackInfo[uiSfIndex].ulSFID);
-				bClassificationSucceed = EThCSClassifyPkt(Adapter,skb,&stEthCsPktInfo,pstClassifierRule, Adapter->PackInfo[uiSfIndex].bEthCSSupport);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Performing ETH CS Classification on Classifier Rule ID : %x Service Flow ID : %lx\n", pstClassifierRule->uiClassifierRuleIndex, Adapter->PackInfo[uiSfIndex].ulSFID);
+				bClassificationSucceed = EThCSClassifyPkt(Adapter, skb, &stEthCsPktInfo, pstClassifierRule, Adapter->PackInfo[uiSfIndex].bEthCSSupport);
 
-				if(!bClassificationSucceed)
+				if (!bClassificationSucceed)
 				{
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ClassifyPacket : Ethernet CS Classification Failed\n");
 					break;
@@ -574,9 +574,9 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb)
 
 			else // No ETH Supported on this SF
 			{
-				if(eEthOtherFrame != stEthCsPktInfo.eNwpktEthFrameType)
+				if (eEthOtherFrame != stEthCsPktInfo.eNwpktEthFrameType)
 				{
-					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  " ClassifyPacket : Packet Not a 802.3 Ethernet Frame... hence not allowed over non-ETH CS SF \n");
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, " ClassifyPacket : Packet Not a 802.3 Ethernet Frame... hence not allowed over non-ETH CS SF\n");
 					bClassificationSucceed = FALSE;
 					break;
 				}
@@ -584,51 +584,51 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb)
 
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Proceeding to IP CS Clasification");
 
-			if(Adapter->PackInfo[uiSfIndex].bIPCSSupport)
+			if (Adapter->PackInfo[uiSfIndex].bIPCSSupport)
 			{
 
-				if(stEthCsPktInfo.eNwpktIPFrameType == eNonIPPacket)
+				if (stEthCsPktInfo.eNwpktIPFrameType == eNonIPPacket)
 				{
-					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  " ClassifyPacket : Packet is Not an IP Packet \n");
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, " ClassifyPacket : Packet is Not an IP Packet\n");
 					bClassificationSucceed = FALSE;
 					break;
 				}
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "Dump IP Header : \n");
-				DumpFullPacket((PUCHAR)pIpHeader,20);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Dump IP Header :\n");
+				DumpFullPacket((PUCHAR)pIpHeader, 20);
 
-				if(stEthCsPktInfo.eNwpktIPFrameType == eIPv4Packet)
-					bClassificationSucceed = IpVersion4(Adapter,pIpHeader,pstClassifierRule);
-				else if(stEthCsPktInfo.eNwpktIPFrameType == eIPv6Packet)
-					bClassificationSucceed = IpVersion6(Adapter,pIpHeader,pstClassifierRule);
+				if (stEthCsPktInfo.eNwpktIPFrameType == eIPv4Packet)
+					bClassificationSucceed = IpVersion4(Adapter, pIpHeader, pstClassifierRule);
+				else if (stEthCsPktInfo.eNwpktIPFrameType == eIPv6Packet)
+					bClassificationSucceed = IpVersion6(Adapter, pIpHeader, pstClassifierRule);
 			}
 
-		}while(0);
+		} while (0);
 	}
 
-	if(bClassificationSucceed == TRUE)
+	if (bClassificationSucceed == TRUE)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "CF id : %d, SF ID is =%lu",pstClassifierRule->uiClassifierRuleIndex, pstClassifierRule->ulSFID);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "CF id : %d, SF ID is =%lu", pstClassifierRule->uiClassifierRuleIndex, pstClassifierRule->ulSFID);
 
 		//Store The matched Classifier in SKB
 		*((UINT32*)(skb->cb)+SKB_CB_CLASSIFICATION_OFFSET) = pstClassifierRule->uiClassifierRuleIndex;
-		if((TCP == pIpHeader->protocol ) && !bFragmentedPkt && (ETH_AND_IP_HEADER_LEN + TCP_HEADER_LEN <= skb->len) )
+		if ((TCP == pIpHeader->protocol) && !bFragmentedPkt && (ETH_AND_IP_HEADER_LEN + TCP_HEADER_LEN <= skb->len))
 		{
 			 IpHeaderLength   = pIpHeader->ihl;
 			 pTcpHeader = (struct bcm_tcp_header *)(((PUCHAR)pIpHeader)+(IpHeaderLength*4));
 			 TcpHeaderLength  = GET_TCP_HEADER_LEN(pTcpHeader->HeaderLength);
 
-			if((pTcpHeader->ucFlags & TCP_ACK) &&
+			if ((pTcpHeader->ucFlags & TCP_ACK) &&
 			   (ntohs(pIpHeader->tot_len) == (IpHeaderLength*4)+(TcpHeaderLength*4)))
 			{
-    			*((UINT32*) (skb->cb) +SKB_CB_TCPACK_OFFSET ) = TCP_ACK;
+				*((UINT32*) (skb->cb) + SKB_CB_TCPACK_OFFSET) = TCP_ACK;
 			}
 		}
 
 		usIndex = SearchSfid(Adapter, pstClassifierRule->ulSFID);
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "index is	=%d", usIndex);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "index is	=%d", usIndex);
 
 		//If this is the first fragment of a Fragmented pkt, add this CF. Only This CF should be used for all other fragment of this Pkt.
-		if(bFragmentedPkt && (usCurrFragment == 0))
+		if (bFragmentedPkt && (usCurrFragment == 0))
 		{
 			//First Fragment of Fragmented Packet. Create Frag CLS Entry
 			struct bcm_fragmented_packet_info stFragPktInfo;
@@ -637,77 +637,77 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb)
 			stFragPktInfo.usIpIdentification = pIpHeader->id;
 			stFragPktInfo.pstMatchedClassifierEntry = pstClassifierRule;
 			stFragPktInfo.bOutOfOrderFragment = FALSE;
-			AddFragIPClsEntry(Adapter,&stFragPktInfo);
+			AddFragIPClsEntry(Adapter, &stFragPktInfo);
 		}
 
 
 	}
 
-	if(bClassificationSucceed)
+	if (bClassificationSucceed)
 		return usIndex;
 	else
 		return INVALID_QUEUE_INDEX;
 }
 
-static BOOLEAN EthCSMatchSrcMACAddress(struct bcm_classifier_rule *pstClassifierRule,PUCHAR Mac)
+static BOOLEAN EthCSMatchSrcMACAddress(struct bcm_classifier_rule *pstClassifierRule, PUCHAR Mac)
 {
-	UINT i=0;
+	UINT i = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	if(pstClassifierRule->ucEthCSSrcMACLen==0)
+	if (pstClassifierRule->ucEthCSSrcMACLen == 0)
 		return TRUE;
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s \n",__FUNCTION__);
-	for(i=0;i<MAC_ADDRESS_SIZE;i++)
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s\n", __FUNCTION__);
+	for (i = 0; i < MAC_ADDRESS_SIZE; i++)
 	{
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "SRC MAC[%x] = %x ClassifierRuleSrcMAC = %x Mask : %x\n",i,Mac[i],pstClassifierRule->au8EThCSSrcMAC[i],pstClassifierRule->au8EThCSSrcMACMask[i]);
-		if((pstClassifierRule->au8EThCSSrcMAC[i] & pstClassifierRule->au8EThCSSrcMACMask[i])!=
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "SRC MAC[%x] = %x ClassifierRuleSrcMAC = %x Mask : %x\n", i, Mac[i], pstClassifierRule->au8EThCSSrcMAC[i], pstClassifierRule->au8EThCSSrcMACMask[i]);
+		if ((pstClassifierRule->au8EThCSSrcMAC[i] & pstClassifierRule->au8EThCSSrcMACMask[i]) !=
 			(Mac[i] & pstClassifierRule->au8EThCSSrcMACMask[i]))
 			return FALSE;
 	}
 	return TRUE;
 }
 
-static BOOLEAN EthCSMatchDestMACAddress(struct bcm_classifier_rule *pstClassifierRule,PUCHAR Mac)
+static BOOLEAN EthCSMatchDestMACAddress(struct bcm_classifier_rule *pstClassifierRule, PUCHAR Mac)
 {
-	UINT i=0;
+	UINT i = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	if(pstClassifierRule->ucEthCSDestMACLen==0)
+	if (pstClassifierRule->ucEthCSDestMACLen == 0)
 		return TRUE;
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s \n",__FUNCTION__);
-	for(i=0;i<MAC_ADDRESS_SIZE;i++)
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "%s\n", __FUNCTION__);
+	for (i = 0; i < MAC_ADDRESS_SIZE; i++)
 	{
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "SRC MAC[%x] = %x ClassifierRuleSrcMAC = %x Mask : %x\n",i,Mac[i],pstClassifierRule->au8EThCSDestMAC[i],pstClassifierRule->au8EThCSDestMACMask[i]);
-		if((pstClassifierRule->au8EThCSDestMAC[i] & pstClassifierRule->au8EThCSDestMACMask[i])!=
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "SRC MAC[%x] = %x ClassifierRuleSrcMAC = %x Mask : %x\n", i, Mac[i], pstClassifierRule->au8EThCSDestMAC[i], pstClassifierRule->au8EThCSDestMACMask[i]);
+		if ((pstClassifierRule->au8EThCSDestMAC[i] & pstClassifierRule->au8EThCSDestMACMask[i]) !=
 			(Mac[i] & pstClassifierRule->au8EThCSDestMACMask[i]))
 			return FALSE;
 	}
 	return TRUE;
 }
 
-static BOOLEAN EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifierRule,struct sk_buff* skb, struct bcm_eth_packet_info *pstEthCsPktInfo)
+static BOOLEAN EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifierRule, struct sk_buff* skb, struct bcm_eth_packet_info *pstEthCsPktInfo)
 {
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
-	if((pstClassifierRule->ucEtherTypeLen==0)||
+	if ((pstClassifierRule->ucEtherTypeLen == 0) ||
 		(pstClassifierRule->au8EthCSEtherType[0] == 0))
 		return TRUE;
 
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s SrcEtherType:%x CLS EtherType[0]:%x\n",__FUNCTION__,pstEthCsPktInfo->usEtherType,pstClassifierRule->au8EthCSEtherType[0]);
-	if(pstClassifierRule->au8EthCSEtherType[0] == 1)
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s SrcEtherType:%x CLS EtherType[0]:%x\n", __FUNCTION__, pstEthCsPktInfo->usEtherType, pstClassifierRule->au8EthCSEtherType[0]);
+	if (pstClassifierRule->au8EthCSEtherType[0] == 1)
 	{
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS EtherType[1]:%x EtherType[2]:%x\n",__FUNCTION__,pstClassifierRule->au8EthCSEtherType[1],pstClassifierRule->au8EthCSEtherType[2]);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS EtherType[1]:%x EtherType[2]:%x\n", __FUNCTION__, pstClassifierRule->au8EthCSEtherType[1], pstClassifierRule->au8EthCSEtherType[2]);
 
-		if(memcmp(&pstEthCsPktInfo->usEtherType,&pstClassifierRule->au8EthCSEtherType[1],2)==0)
+		if (memcmp(&pstEthCsPktInfo->usEtherType, &pstClassifierRule->au8EthCSEtherType[1], 2) == 0)
 			return TRUE;
 		else
 			return FALSE;
 	}
 
-	if(pstClassifierRule->au8EthCSEtherType[0] == 2)
+	if (pstClassifierRule->au8EthCSEtherType[0] == 2)
 	{
-		if(eEth802LLCFrame != pstEthCsPktInfo->eNwpktEthFrameType)
+		if (eEth802LLCFrame != pstEthCsPktInfo->eNwpktEthFrameType)
 			return FALSE;
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  EthCS DSAP:%x EtherType[2]:%x\n",__FUNCTION__,pstEthCsPktInfo->ucDSAP,pstClassifierRule->au8EthCSEtherType[2]);
-		if(pstEthCsPktInfo->ucDSAP == pstClassifierRule->au8EthCSEtherType[2])
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  EthCS DSAP:%x EtherType[2]:%x\n", __FUNCTION__, pstEthCsPktInfo->ucDSAP, pstClassifierRule->au8EthCSEtherType[2]);
+		if (pstEthCsPktInfo->ucDSAP == pstClassifierRule->au8EthCSEtherType[2])
 			return TRUE;
 		else
 			return FALSE;
@@ -718,27 +718,27 @@ static BOOLEAN EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifierRul
 
 }
 
-static BOOLEAN EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule,struct sk_buff* skb, struct bcm_eth_packet_info *pstEthCsPktInfo)
+static BOOLEAN EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule, struct sk_buff* skb, struct bcm_eth_packet_info *pstEthCsPktInfo)
 {
 	BOOLEAN bClassificationSucceed = FALSE;
 	USHORT usVLANID;
 	B_UINT8 uPriority = 0;
 	struct bcm_mini_adapter *Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS UserPrio:%x CLS VLANID:%x\n",__FUNCTION__,ntohs(*((USHORT *)pstClassifierRule->usUserPriority)),pstClassifierRule->usVLANID);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS UserPrio:%x CLS VLANID:%x\n", __FUNCTION__, ntohs(*((USHORT *)pstClassifierRule->usUserPriority)), pstClassifierRule->usVLANID);
 
 	/* In case FW didn't receive the TLV, the priority field should be ignored */
-	if(pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_USER_PRIORITY_VALID))
+	if (pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_USER_PRIORITY_VALID))
 	{
-		if(pstEthCsPktInfo->eNwpktEthFrameType!=eEth802QVLANFrame)
+		if (pstEthCsPktInfo->eNwpktEthFrameType != eEth802QVLANFrame)
 				return FALSE;
 
 		uPriority = (ntohs(*(USHORT *)(skb->data + sizeof(struct bcm_eth_header))) & 0xF000) >> 13;
 
-		if((uPriority >= pstClassifierRule->usUserPriority[0]) && (uPriority <= pstClassifierRule->usUserPriority[1]))
+		if ((uPriority >= pstClassifierRule->usUserPriority[0]) && (uPriority <= pstClassifierRule->usUserPriority[1]))
 				bClassificationSucceed = TRUE;
 
-		if(!bClassificationSucceed)
+		if (!bClassificationSucceed)
 			return FALSE;
 	}
 
@@ -746,19 +746,19 @@ static BOOLEAN EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule
 
 	bClassificationSucceed = FALSE;
 
-	if(pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_VLANID_VALID))
+	if (pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_VLANID_VALID))
 	{
-		if(pstEthCsPktInfo->eNwpktEthFrameType!=eEth802QVLANFrame)
+		if (pstEthCsPktInfo->eNwpktEthFrameType != eEth802QVLANFrame)
 				return FALSE;
 
 		usVLANID = ntohs(*(USHORT *)(skb->data + sizeof(struct bcm_eth_header))) & 0xFFF;
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  Pkt VLANID %x Priority: %d\n",__FUNCTION__,usVLANID, uPriority);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  Pkt VLANID %x Priority: %d\n", __FUNCTION__, usVLANID, uPriority);
 
-		if(usVLANID == ((pstClassifierRule->usVLANID & 0xFFF0) >> 4))
+		if (usVLANID == ((pstClassifierRule->usVLANID & 0xFFF0) >> 4))
 			bClassificationSucceed = TRUE;
 
-		if(!bClassificationSucceed)
+		if (!bClassificationSucceed)
 			return FALSE;
 	}
 
@@ -768,50 +768,50 @@ static BOOLEAN EthCSMatchVLANRules(struct bcm_classifier_rule *pstClassifierRule
 }
 
 
-static BOOLEAN EThCSClassifyPkt(struct bcm_mini_adapter *Adapter,struct sk_buff* skb,
+static BOOLEAN EThCSClassifyPkt(struct bcm_mini_adapter *Adapter, struct sk_buff* skb,
 				struct bcm_eth_packet_info *pstEthCsPktInfo,
 				struct bcm_classifier_rule *pstClassifierRule,
 				B_UINT8 EthCSCupport)
 {
 	BOOLEAN bClassificationSucceed = FALSE;
-	bClassificationSucceed = EthCSMatchSrcMACAddress(pstClassifierRule,((struct bcm_eth_header *)(skb->data))->au8SourceAddress);
-	if(!bClassificationSucceed)
+	bClassificationSucceed = EthCSMatchSrcMACAddress(pstClassifierRule, ((struct bcm_eth_header *)(skb->data))->au8SourceAddress);
+	if (!bClassificationSucceed)
 		return FALSE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ETH CS SrcMAC Matched\n");
 
-	bClassificationSucceed = EthCSMatchDestMACAddress(pstClassifierRule,((struct bcm_eth_header *)(skb->data))->au8DestinationAddress);
-	if(!bClassificationSucceed)
+	bClassificationSucceed = EthCSMatchDestMACAddress(pstClassifierRule, ((struct bcm_eth_header *)(skb->data))->au8DestinationAddress);
+	if (!bClassificationSucceed)
 		return FALSE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ETH CS DestMAC Matched\n");
 
 	//classify on ETHType/802.2SAP TLV
-	bClassificationSucceed = EthCSMatchEThTypeSAP(pstClassifierRule,skb,pstEthCsPktInfo);
-	if(!bClassificationSucceed)
+	bClassificationSucceed = EthCSMatchEThTypeSAP(pstClassifierRule, skb, pstEthCsPktInfo);
+	if (!bClassificationSucceed)
 		return FALSE;
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ETH CS EthType/802.2SAP Matched\n");
 
 	//classify on 802.1VLAN Header Parameters
 
-	bClassificationSucceed = EthCSMatchVLANRules(pstClassifierRule,skb,pstEthCsPktInfo);
-	if(!bClassificationSucceed)
+	bClassificationSucceed = EthCSMatchVLANRules(pstClassifierRule, skb, pstEthCsPktInfo);
+	if (!bClassificationSucceed)
 		return FALSE;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "ETH CS 802.1 VLAN Rules Matched\n");
 
 	return bClassificationSucceed;
 }
 
-static void EThCSGetPktInfo(struct bcm_mini_adapter *Adapter,PVOID pvEthPayload,
+static void EThCSGetPktInfo(struct bcm_mini_adapter *Adapter, PVOID pvEthPayload,
 			    struct bcm_eth_packet_info *pstEthCsPktInfo)
 {
 	USHORT u16Etype = ntohs(((struct bcm_eth_header *)pvEthPayload)->u16Etype);
 
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCSGetPktInfo : Eth Hdr Type : %X\n",u16Etype);
-	if(u16Etype > 0x5dc)
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCSGetPktInfo : Eth Hdr Type : %X\n", u16Etype);
+	if (u16Etype > 0x5dc)
 	{
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "EthCSGetPktInfo : ETH2 Frame \n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "EthCSGetPktInfo : ETH2 Frame\n");
 		//ETH2 Frame
-		if(u16Etype == ETHERNET_FRAMETYPE_802QVLAN)
+		if (u16Etype == ETHERNET_FRAMETYPE_802QVLAN)
 		{
 			//802.1Q VLAN Header
 			pstEthCsPktInfo->eNwpktEthFrameType = eEth802QVLANFrame;
@@ -828,27 +828,27 @@ static void EThCSGetPktInfo(struct bcm_mini_adapter *Adapter,PVOID pvEthPayload,
 	else
 	{
 		//802.2 LLC
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "802.2 LLC Frame \n");
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "802.2 LLC Frame\n");
 		pstEthCsPktInfo->eNwpktEthFrameType = eEth802LLCFrame;
 		pstEthCsPktInfo->ucDSAP = ((struct bcm_eth_llc_frame *)pvEthPayload)->DSAP;
-		if(pstEthCsPktInfo->ucDSAP == 0xAA && ((struct bcm_eth_llc_frame *)pvEthPayload)->SSAP == 0xAA)
+		if (pstEthCsPktInfo->ucDSAP == 0xAA && ((struct bcm_eth_llc_frame *)pvEthPayload)->SSAP == 0xAA)
 		{
 			//SNAP Frame
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
 
 
-- 
1.8.3.3

