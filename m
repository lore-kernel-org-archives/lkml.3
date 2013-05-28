Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab3E1D4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52657 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758930Ab3E1DyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:19 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Herbert Xu" <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Cong Wang" <amwang@redhat.com>,
        "Steffen Klassert" <steffen.klassert@secunet.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.834500955@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [90/94] xfrm6: release dev before returning error
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

[ Upstream commit 84c4a9dfbf430861e7588d95ae3ff61535dca351 ]

We forget to call dev_put() on error path in xfrm6_fill_dst(),
its caller doesn't handle this.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/xfrm6_policy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index d879f7e..db78e7d 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -96,8 +96,10 @@ static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 	dev_hold(dev);
 
 	xdst->u.rt6.rt6i_idev = in6_dev_get(dev);
-	if (!xdst->u.rt6.rt6i_idev)
+	if (!xdst->u.rt6.rt6i_idev) {
+		dev_put(dev);
 		return -ENODEV;
+	}
 
 	xdst->u.rt6.rt6i_peer = rt->rt6i_peer;
 	if (rt->rt6i_peer)

