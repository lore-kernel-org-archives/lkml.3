Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbaDPKpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:45:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51731 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbaDPKcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li RongQing <roy.qing.li@gmail.com>, WANG Cong <amwang@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 26/46] netpoll: fix the skb check in pkt_is_ns
Date: Wed, 16 Apr 2014 11:31:42 +0100
Message-Id: <1397644322-13905-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Not applicable upstream commit, the code here has been removed
  upstream. ]

Neighbor Solicitation is ipv6 protocol, so we should check
skb->protocol with ETH_P_IPV6

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Cc: WANG Cong <amwang@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/netpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 462cdc9..9b40f23 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -740,7 +740,7 @@ static bool pkt_is_ns(struct sk_buff *skb)
 	struct nd_msg *msg;
 	struct ipv6hdr *hdr;
 
-	if (skb->protocol != htons(ETH_P_ARP))
+	if (skb->protocol != htons(ETH_P_IPV6))
 		return false;
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr) + sizeof(struct nd_msg)))
 		return false;
-- 
1.9.1

