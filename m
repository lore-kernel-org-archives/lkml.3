Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaDRJbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:31:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45990 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Li RongQing <roy.qing.li@gmail.com>,
        WANG Cong <amwang@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 54/72] netpoll: fix the skb check in pkt_is_ns
Date: Fri, 18 Apr 2014 11:22:27 +0200
Message-Id: <d40390bf12065bb1c228e4e8becc4ea62c307b48.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li RongQing <roy.qing.li@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Not applicable upstream commit, the code here has been removed
  upstream. ]

Neighbor Solicitation is ipv6 protocol, so we should check
skb->protocol with ETH_P_IPV6

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Cc: WANG Cong <amwang@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/core/netpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 462cdc97fad8..9b40f234b802 100644
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
1.9.2

