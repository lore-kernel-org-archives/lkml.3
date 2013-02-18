Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3BRUit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 15:38:49 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:55638 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753010Ab3BRUis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 15:38:48 -0500
Message-ID: <51229152.8010007@semaphore.gr>
Date: Mon, 18 Feb 2013 22:38:42 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH linux-next] net: ipv6: Fix compiler warning
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compiler warning (also a checkpatch error):

net/ipv6/xfrm6_mode_tunnel.c: In function ‘xfrm6_mode_tunnel_input’:
net/ipv6/xfrm6_mode_tunnel.c:72:2: warning: suggest parentheses around
assignment used as truth value [-Wparentheses]

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 net/ipv6/xfrm6_mode_tunnel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_mode_tunnel.c b/net/ipv6/xfrm6_mode_tunnel.c
index 93c41a8..9bf6a74 100644
--- a/net/ipv6/xfrm6_mode_tunnel.c
+++ b/net/ipv6/xfrm6_mode_tunnel.c
@@ -69,7 +69,8 @@ static int xfrm6_mode_tunnel_input(struct xfrm_state *x, struct sk_buff *skb)
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto out;
 
-	if (err = skb_unclone(skb, GFP_ATOMIC))
+	err = skb_unclone(skb, GFP_ATOMIC);
+	if (err)
 		goto out;
 
 	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
-- 
1.8.1.2

