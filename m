Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab3KHCQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:16:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34509 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab3KHCQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 10/91] ip: fix warning in xfrm4_mode_tunnel_input
Date: Thu,  7 Nov 2013 18:14:25 -0800
Message-Id: <1383876946-2396-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

commit 9aac22deb11a3da4df5b868fc3d30b07185b0d71 upstream.

Same problem as IPv6

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/xfrm4_mode_tunnel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index 57dfe2b..175e8b1 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -142,7 +142,8 @@ static int xfrm4_mode_tunnel_input(struct xfrm_state *x, struct sk_buff *skb)
 	for_each_input_rcu(rcv_notify_handlers, handler)
 		handler->handler(skb);
 
-	if (err = skb_unclone(skb, GFP_ATOMIC))
+	err = skb_unclone(skb, GFP_ATOMIC);
+	if (err)
 		goto out;
 
 	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
-- 
1.8.1.2

