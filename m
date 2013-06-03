Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab3FCWNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:13:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133Ab3FCWMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:43 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=zbFWI4zHAPQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=l6ok46n93WEA:10 a=20KFwNOVAAAA:8 a=FNyBlpCuAAAA:8 a=7ZN4cI0QAAAA:8 a=J1Y8HTJGAAAA:8 a=L1Sk8dguCKY_zwg3XXAA:9 a=jEp0ucaQiEUA:10 a=Vn2gH7L4UmAA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=v1gJnQ6M_Kt5fIEx:21 a=yeaRYc0ENXVxo5mI:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221159.639547122@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, Cong Wang <amwang@redhat.com>
Subject: [43/65] xfrm6: release dev before returning error
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0043-xfrm6-release-dev-before-returning-error.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv6/xfrm6_policy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index bf6912e..a11f96c 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -103,8 +103,10 @@ static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 	dev_hold(dev);
 
 	xdst->u.rt6.rt6i_idev = in6_dev_get(dev);
-	if (!xdst->u.rt6.rt6i_idev)
+	if (!xdst->u.rt6.rt6i_idev) {
+		dev_put(dev);
 		return -ENODEV;
+	}
 
 	rt6_transfer_peer(&xdst->u.rt6, rt);
 
-- 
1.7.10.4


