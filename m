Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141Ab3GaNtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:49:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46866 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495Ab3GaNZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "=?UTF-8?q?Linus=20L=C3=BCssing?=" <linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.485573342@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [01/84] bridge: fix switched interval for MLD Query types
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Lüssing <linus.luessing@web.de>

[ Upstream commit 32de868cbc6bee010d2cee95b5071b25ecbec8c3 ]

General Queries (the one with the Multicast Address field
set to zero / '::') are supposed to have a Maximum Response Delay
of [Query Response Interval], while for Multicast-Address-Specific
Queries it is [Last Listener Query Interval] - not the other way
round. (see RFC2710, section 7.3+7.8)

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bridge/br_multicast.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 5ac1811..b81500c 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -467,8 +467,9 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 	skb_set_transport_header(skb, skb->len);
 	mldq = (struct mld_msg *) icmp6_hdr(skb);
 
-	interval = ipv6_addr_any(group) ? br->multicast_last_member_interval :
-					  br->multicast_query_response_interval;
+	interval = ipv6_addr_any(group) ?
+			br->multicast_query_response_interval :
+			br->multicast_last_member_interval;
 
 	mldq->mld_type = ICMPV6_MGM_QUERY;
 	mldq->mld_code = 0;

