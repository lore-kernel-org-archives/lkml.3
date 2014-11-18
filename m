Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbaKRP1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:27:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbaKROJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:25 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Li RongQing <roy.qing.li@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 010/206] vxlan: fix a free after use
Date: Tue, 18 Nov 2014 15:06:05 +0100
Message-Id: <4cb545d54ca5815e9a2d56daef266a39096e6157.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li RongQing <roy.qing.li@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 7a9f526fc3ee49b6034af2f243676ee0a27dcaa8 ]

pskb_may_pull maybe change skb->data and make eth pointer oboslete,
so eth needs to reload

Fixes: 91269e390d062 ("vxlan: using pskb_may_pull as early as possible")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/vxlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index aff1694d2d9e..23969eaf88c1 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1897,6 +1897,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 				    msg->icmph.icmp6_type == NDISC_NEIGHBOUR_SOLICITATION)
 					return neigh_reduce(dev, skb);
 		}
+		eth = eth_hdr(skb);
 #endif
 	}
 
-- 
2.1.3

