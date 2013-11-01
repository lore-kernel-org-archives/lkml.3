Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3KAVs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:48:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab3KAVoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:44:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 18/32] net: dst: provide accessor function to dst->xfrm
Date: Fri,  1 Nov 2013 14:43:29 -0700
Message-Id: <20131101214317.990004865@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101214313.735463599@linuxfoundation.org>
References: <20131101214313.735463599@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

[ Upstream commit e87b3998d795123b4139bc3f25490dd236f68212 ]

dst->xfrm is conditionally defined.  Provide accessor funtion that
is always available.

Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -464,10 +464,22 @@ static inline struct dst_entry *xfrm_loo
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


