Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbaELC06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:26:58 -0400
Received: from 1wt.eu ([62.212.114.60]:34351 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbaELBlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:31 -0400
Message-Id: <20140512003202.093305438@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 035/143] net: dst: provide accessor function to dst->xfrm
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

[ Upstream commit e87b3998d795123b4139bc3f25490dd236f68212 ]

dst->xfrm is conditionally defined.  Provide accessor funtion that
is always available.

Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/net/dst.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/net/dst.h b/include/net/dst.h
index 5a900dd..49f443b 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -286,11 +286,22 @@ static inline int __xfrm_lookup(struct net *net, struct dst_entry **dst_p,
 {
 	return 0;
 }
+static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
+{
+	return NULL;
+}
+
 #else
 extern int xfrm_lookup(struct net *net, struct dst_entry **dst_p,
 		       struct flowi *fl, struct sock *sk, int flags);
 extern int __xfrm_lookup(struct net *net, struct dst_entry **dst_p,
 			 struct flowi *fl, struct sock *sk, int flags);
+
+/* skb attached with this dst needs transformation if dst->xfrm is valid */
+static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
+{
+	return dst->xfrm;
+}
 #endif
 #endif
 
-- 
1.7.12.2.21.g234cd45.dirty



