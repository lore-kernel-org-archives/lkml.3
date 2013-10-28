Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab3J1Ot6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:49:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51284 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab3J1Ott (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 54/64] net: dst: provide accessor function to dst->xfrm
Date: Mon, 28 Oct 2013 14:48:13 +0000
Message-Id: <1382971703-17393-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

commit e87b3998d795123b4139bc3f25490dd236f68212 upstream.

dst->xfrm is conditionally defined.  Provide accessor funtion that
is always available.

Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/dst.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/net/dst.h b/include/net/dst.h
index 8197ead..1efe71a 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -464,10 +464,22 @@ static inline struct dst_entry *xfrm_lookup(struct net *net,
 {
 	return dst_orig;
 } 
+
+static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
+{
+	return NULL;
+}
+
 #else
 extern struct dst_entry *xfrm_lookup(struct net *net, struct dst_entry *dst_orig,
 				     const struct flowi *fl, struct sock *sk,
 				     int flags);
+
+/* skb attached with this dst needs transformation if dst->xfrm is valid */
+static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
+{
+	return dst->xfrm;
+}
 #endif
 
 #endif /* _NET_DST_H */
-- 
1.8.3.2

