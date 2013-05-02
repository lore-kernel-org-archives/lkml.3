Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3EBIbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:31:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51066 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3EBIbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:31:34 -0400
Date: Thu, 02 May 2013 04:31:32 -0400 (EDT)
Message-Id: <20130502.043132.2103406228463666807.davem@davemloft.net>
To: kaber@trash.net
Cc: torvalds@linux-foundation.org, hayeswang@realtek.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: Restore NETIF_F_* bit ordering.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130502.041625.412316202038784117.davem@davemloft.net>
References: <20130502.024552.1513488878160820332.davem@davemloft.net>
	<20130502070256.GA29502@macbook.localnet>
	<20130502.041625.412316202038784117.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 02 May 2013 01:31:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 8ad227ff89a7e6f05d07cd0acfd95ed3a24450ca ("net: vlan: add
802.1ad support") added some new NETIF_F_* features bits, but it
added them in the middle of existing values.

Userland depends upon the flag bits via the per-netdevice 'flags'
sysfs file.

So restore the previous ordering by adding the new flags at the
end.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---

Linus, just apply this to your tree directly if it works for you.

It obviously should since this is essentially what you tested already.

Thanks.

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index cbaa027..09906b7 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -25,9 +25,6 @@ enum {
 	NETIF_F_HW_VLAN_CTAG_TX_BIT,	/* Transmit VLAN CTAG HW acceleration */
 	NETIF_F_HW_VLAN_CTAG_RX_BIT,	/* Receive VLAN CTAG HW acceleration */
 	NETIF_F_HW_VLAN_CTAG_FILTER_BIT,/* Receive filtering on VLAN CTAGs */
-	NETIF_F_HW_VLAN_STAG_TX_BIT,	/* Transmit VLAN STAG HW acceleration */
-	NETIF_F_HW_VLAN_STAG_RX_BIT,	/* Receive VLAN STAG HW acceleration */
-	NETIF_F_HW_VLAN_STAG_FILTER_BIT,/* Receive filtering on VLAN STAGs */
 	NETIF_F_VLAN_CHALLENGED_BIT,	/* Device cannot handle VLAN packets */
 	NETIF_F_GSO_BIT,		/* Enable software GSO. */
 	NETIF_F_LLTX_BIT,		/* LockLess TX - deprecated. Please */
@@ -59,6 +56,9 @@ enum {
 	NETIF_F_LOOPBACK_BIT,		/* Enable loopback */
 	NETIF_F_RXFCS_BIT,		/* Append FCS to skb pkt data */
 	NETIF_F_RXALL_BIT,		/* Receive errored frames too */
+	NETIF_F_HW_VLAN_STAG_TX_BIT,	/* Transmit VLAN STAG HW acceleration */
+	NETIF_F_HW_VLAN_STAG_RX_BIT,	/* Receive VLAN STAG HW acceleration */
+	NETIF_F_HW_VLAN_STAG_FILTER_BIT,/* Receive filtering on VLAN STAGs */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -86,9 +86,6 @@ enum {
 #define NETIF_F_HW_VLAN_CTAG_FILTER __NETIF_F(HW_VLAN_CTAG_FILTER)
 #define NETIF_F_HW_VLAN_CTAG_RX	__NETIF_F(HW_VLAN_CTAG_RX)
 #define NETIF_F_HW_VLAN_CTAG_TX	__NETIF_F(HW_VLAN_CTAG_TX)
-#define NETIF_F_HW_VLAN_STAG_FILTER __NETIF_F(HW_VLAN_STAG_FILTER)
-#define NETIF_F_HW_VLAN_STAG_RX	__NETIF_F(HW_VLAN_STAG_RX)
-#define NETIF_F_HW_VLAN_STAG_TX	__NETIF_F(HW_VLAN_STAG_TX)
 #define NETIF_F_IP_CSUM		__NETIF_F(IP_CSUM)
 #define NETIF_F_IPV6_CSUM	__NETIF_F(IPV6_CSUM)
 #define NETIF_F_LLTX		__NETIF_F(LLTX)
@@ -110,6 +107,9 @@ enum {
 #define NETIF_F_RXALL		__NETIF_F(RXALL)
 #define NETIF_F_GSO_GRE		__NETIF_F(GSO_GRE)
 #define NETIF_F_GSO_UDP_TUNNEL	__NETIF_F(GSO_UDP_TUNNEL)
+#define NETIF_F_HW_VLAN_STAG_FILTER __NETIF_F(HW_VLAN_STAG_FILTER)
+#define NETIF_F_HW_VLAN_STAG_RX	__NETIF_F(HW_VLAN_STAG_RX)
+#define NETIF_F_HW_VLAN_STAG_TX	__NETIF_F(HW_VLAN_STAG_TX)
 
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */

