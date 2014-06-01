Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbaFAMUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:20:43 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34716 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbaFAMUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:20:37 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 26/26] staging: rtl8188eu: Remove function with empty defination()
Date: Sun,  1 Jun 2014 17:46:52 +0530
Message-Id: <1401625013-11208-26-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_br_ext.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_br_ext.c b/drivers/staging/rtl8188eu/core/rtw_br_ext.c
index 3f602bc..70b8f07 100644
--- a/drivers/staging/rtl8188eu/core/rtw_br_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_br_ext.c
@@ -431,10 +431,6 @@ static void __nat25_db_network_insert(struct adapter *priv,
 	spin_unlock_bh(&priv->br_ext_lock);
 }
 
-static void __nat25_db_print(struct adapter *priv)
-{
-}
-
 /*
  *	NAT2.5 interface
  */
@@ -534,7 +530,6 @@ int nat25_db_handle(struct adapter *priv, struct sk_buff *skb, int method)
 			/* record source IP address and , source mac address into db */
 			__nat25_db_network_insert(priv, skb->data+ETH_ALEN, networkAddr);
 
-			__nat25_db_print(priv);
 			return 0;
 		case NAT25_LOOKUP:
 			DEBUG_INFO("NAT25: Lookup IP, SA =%08x, DA =%08x\n", iph->saddr, iph->daddr);
@@ -587,7 +582,6 @@ int nat25_db_handle(struct adapter *priv, struct sk_buff *skb, int method)
 			sender = (unsigned int *)arp_ptr;
 			__nat25_generate_ipv4_network_addr(networkAddr, sender);
 			__nat25_db_network_insert(priv, skb->data+ETH_ALEN, networkAddr);
-			__nat25_db_print(priv);
 			return 0;
 		case NAT25_LOOKUP:
 			DEBUG_INFO("NAT25: Lookup ARP\n");
@@ -707,7 +701,6 @@ int nat25_db_handle(struct adapter *priv, struct sk_buff *skb, int method)
 					__nat25_generate_ipx_network_addr_with_node(networkAddr, &ipx->ipx_source.net, ipx->ipx_source.node);
 				}
 				__nat25_db_network_insert(priv, skb->data+ETH_ALEN, networkAddr);
-				__nat25_db_print(priv);
 				return 0;
 			case NAT25_LOOKUP:
 				if (!memcmp(GET_MY_HWADDR(priv), ipx->ipx_dest.node, ETH_ALEN)) {
@@ -752,7 +745,6 @@ int nat25_db_handle(struct adapter *priv, struct sk_buff *skb, int method)
 
 				__nat25_db_network_insert(priv, skb->data+ETH_ALEN, networkAddr);
 
-				__nat25_db_print(priv);
 				return 0;
 			case NAT25_LOOKUP:
 				DEBUG_INFO("NAT25: Lookup AARP, Source =%d,%d Destination =%d,%d\n",
@@ -786,7 +778,6 @@ int nat25_db_handle(struct adapter *priv, struct sk_buff *skb, int method)
 
 				__nat25_db_network_insert(priv, skb->data+ETH_ALEN, networkAddr);
 
-				__nat25_db_print(priv);
 				return 0;
 			case NAT25_LOOKUP:
 				DEBUG_INFO("NAT25: Lookup DDP, Source =%d,%d Destination =%d,%d\n",
@@ -879,7 +870,6 @@ int nat25_db_handle(struct adapter *priv, struct sk_buff *skb, int method)
 
 				__nat25_db_network_insert(priv, skb->data+ETH_ALEN, networkAddr);
 
-				__nat25_db_print(priv);
 
 				if (!priv->ethBrExtInfo.addPPPoETag &&
 				    priv->pppoe_connection_in_progress &&
@@ -945,7 +935,6 @@ int nat25_db_handle(struct adapter *priv, struct sk_buff *skb, int method)
 					DEBUG_INFO("NAT25: Lookup PPPoE, lookup session packet from %s\n", skb->dev->name);
 					__nat25_generate_pppoe_network_addr(networkAddr, skb->data+ETH_ALEN, &(ph->sid));
 					__nat25_db_network_lookup_and_replace(priv, skb, networkAddr);
-					__nat25_db_print(priv);
 				} else {
 					return -1;
 				}
@@ -1009,7 +998,6 @@ int nat25_db_handle(struct adapter *priv, struct sk_buff *skb, int method)
 			if (memcmp(&iph->saddr, "\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0\x0", 16)) {
 				__nat25_generate_ipv6_network_addr(networkAddr, (__be32 *)&iph->saddr);
 				__nat25_db_network_insert(priv, skb->data+ETH_ALEN, networkAddr);
-				__nat25_db_print(priv);
 
 				if (iph->nexthdr == IPPROTO_ICMPV6 &&
 						skb->len > (ETH_HLEN +  sizeof(*iph) + 4)) {
-- 
1.7.10.4

