Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaB0LLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:11:37 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63557 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaB0LLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:11:14 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, veeableful@gmail.com, josh@joshtriplett.org,
        rashika.kheria@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: bcm: fix checkpatch error 'assignment in if condition'
Date: Thu, 27 Feb 2014 20:11:09 +0900
Message-ID: <6252391.VE6NA7AxT4@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clean up checkpatch errors and bClassificationSucceed is set to "TRUE"
proper location.

If protocal is not TCP or UDP, when it checks protocal, bClassificationSucceed
must be set to TRUE.
Also the end of do-while(0) loop, bClassificationSucceed is set to TRUE.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/bcm/Qos.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index ead57b4..4f31583 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -230,51 +230,47 @@ static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter,
 
 		//**************Checking IP header parameter**************************//
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Trying to match Source IP Address");
-		if (false == (bClassificationSucceed =
-			MatchSrcIpAddress(pstClassifierRule, iphd->saddr)))
+		if (!MatchSrcIpAddress(pstClassifierRule, iphd->saddr))
 			break;
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Source IP Address Matched");
 
-		if (false == (bClassificationSucceed =
-			MatchDestIpAddress(pstClassifierRule, iphd->daddr)))
+		if (!MatchDestIpAddress(pstClassifierRule, iphd->daddr))
 			break;
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination IP Address Matched");
 
-		if (false == (bClassificationSucceed =
-			MatchTos(pstClassifierRule, iphd->tos)))
-		{
+		if (!MatchTos(pstClassifierRule, iphd->tos)) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "TOS Match failed\n");
 			break;
 		}
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "TOS Matched");
 
-		if (false == (bClassificationSucceed =
-			MatchProtocol(pstClassifierRule, iphd->protocol)))
+		if (!MatchProtocol(pstClassifierRule, iphd->protocol))
 			break;
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Protocol Matched");
 
 		//if protocol is not TCP or UDP then no need of comparing source port and destination port
-		if (iphd->protocol != TCP && iphd->protocol != UDP)
+		if (iphd->protocol != TCP && iphd->protocol != UDP) {
+			bClassificationSucceed = TRUE;
 			break;
+		}
 		//******************Checking Transport Layer Header field if present *****************//
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Source Port %04x",
 			(iphd->protocol == UDP) ? xprt_hdr->uhdr.source : xprt_hdr->thdr.source);
 
-		if (false == (bClassificationSucceed =
-			MatchSrcPort(pstClassifierRule,
-				ntohs((iphd->protocol == UDP) ?
-				xprt_hdr->uhdr.source : xprt_hdr->thdr.source))))
+		if (!MatchSrcPort(pstClassifierRule,
+				  ntohs((iphd->protocol == UDP) ?
+				  xprt_hdr->uhdr.source : xprt_hdr->thdr.source)))
 			break;
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Src Port Matched");
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "Destination Port %04x",
 			(iphd->protocol == UDP) ? xprt_hdr->uhdr.dest :
 			xprt_hdr->thdr.dest);
-		if (false == (bClassificationSucceed =
-			MatchDestPort(pstClassifierRule,
-			ntohs((iphd->protocol == UDP) ?
-			xprt_hdr->uhdr.dest : xprt_hdr->thdr.dest))))
+		if (!MatchDestPort(pstClassifierRule,
+				   ntohs((iphd->protocol == UDP) ?
+				   xprt_hdr->uhdr.dest : xprt_hdr->thdr.dest)))
 			break;
+		bClassificationSucceed = TRUE;
 	} while (0);
 
 	if (TRUE == bClassificationSucceed)
-- 
1.7.9.5


