Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3FDXHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:07:09 -0400
Received: from 1wt.eu ([62.212.114.60]:35567 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab3FDWmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:47 -0400
Message-Id: <20130604172136.437067619@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 148/184] bridge: set priority of STP packets
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen@networkplumber.org>

Spanning Tree Protocol packets should have always been marked as
control packets, this causes them to get queued in the high prirority
FIFO. As Radia Perlman mentioned in her LCA talk, STP dies if bridge
gets overloaded and can't communicate. This is a long-standing bug back
to the first versions of Linux bridge.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit 547b4e718115eea74087e28d7fa70aec619200db)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/bridge/br_stp_bpdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index 81ae40b..108215b 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -15,6 +15,7 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/etherdevice.h>
 #include <linux/llc.h>
+#include <linux/pkt_sched.h>
 #include <net/net_namespace.h>
 #include <net/llc.h>
 #include <net/llc_pdu.h>
@@ -39,6 +40,7 @@ static void br_send_bpdu(struct net_bridge_port *p,
 
 	skb->dev = p->dev;
 	skb->protocol = htons(ETH_P_802_2);
+	skb->priority = TC_PRIO_CONTROL;
 
 	skb_reserve(skb, LLC_RESERVE);
 	memcpy(__skb_put(skb, length), data, length);
-- 
1.7.12.2.21.g234cd45.dirty



