Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760537Ab3B0AM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:12:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760441Ab3B0AJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 70/86] bridge: set priority of STP packets
Date: Tue, 26 Feb 2013 16:08:18 -0800
Message-Id: <20130226235920.191958688@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 547b4e718115eea74087e28d7fa70aec619200db ]

Spanning Tree Protocol packets should have always been marked as
control packets, this causes them to get queued in the high prirority
FIFO. As Radia Perlman mentioned in her LCA talk, STP dies if bridge
gets overloaded and can't communicate. This is a long-standing bug back
to the first versions of Linux bridge.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_stp_bpdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -16,6 +16,7 @@
 #include <linux/etherdevice.h>
 #include <linux/llc.h>
 #include <linux/slab.h>
+#include <linux/pkt_sched.h>
 #include <net/net_namespace.h>
 #include <net/llc.h>
 #include <net/llc_pdu.h>
@@ -40,6 +41,7 @@ static void br_send_bpdu(struct net_brid
 
 	skb->dev = p->dev;
 	skb->protocol = htons(ETH_P_802_2);
+	skb->priority = TC_PRIO_CONTROL;
 
 	skb_reserve(skb, LLC_RESERVE);
 	memcpy(__skb_put(skb, length), data, length);


