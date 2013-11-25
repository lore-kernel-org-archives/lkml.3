Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab3KYNxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:53:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58850 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755Ab3KYNxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:33 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Vlad Yasevich" <vyasevich@gmail.com>,
        "Neil Horman" <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.47099807@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 14/87] net: dst: provide accessor function to dst->xfrm
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

[ Upstream commit e87b3998d795123b4139bc3f25490dd236f68212 ]

dst->xfrm is conditionally defined.  Provide accessor funtion that
is always available.

Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/dst.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/net/dst.h b/include/net/dst.h
index 16010d1..86ef78d 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -459,10 +459,22 @@ static inline struct dst_entry *xfrm_lookup(struct net *net,
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

