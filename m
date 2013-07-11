Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab3GKOlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:41:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43069 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab3GKO0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 51/98] ipvs: SCTP ports should be writable in ICMP packets
Date: Thu, 11 Jul 2013 15:24:21 +0100
Message-Id: <1373552708-15235-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

commit 06f3d7f973ec04290d86b7dd91b48d38d90433dc upstream.

Make sure that SCTP ports are writable when embedded in ICMP
from client, so that ip_vs_nat_icmp can translate them safely.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index a54b018c..40f9ad8 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1378,7 +1378,8 @@ ip_vs_in_icmp(struct sk_buff *skb, int *related, unsigned int hooknum)
 
 	/* do the statistics and put it back */
 	ip_vs_in_stats(cp, skb);
-	if (IPPROTO_TCP == cih->protocol || IPPROTO_UDP == cih->protocol)
+	if (IPPROTO_TCP == cih->protocol || IPPROTO_UDP == cih->protocol ||
+	    IPPROTO_SCTP == cih->protocol)
 		offset += 2 * sizeof(__u16);
 	verdict = ip_vs_icmp_xmit(skb, cp, pp, offset, hooknum);
 
-- 
1.8.1.2

