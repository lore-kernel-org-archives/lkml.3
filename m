Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446Ab3FCWRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:17:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14070 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758919Ab3FCWMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:20 -0400
X-Authority-Analysis: v=2.0 cv=Et5QXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=pwvY2L3Br7IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=dBFy2OxvXboA:10 a=d4lxWNCCAAAA:8 a=J1Y8HTJGAAAA:8 a=m5Q0o0PiCI1hxLtGswwA:9 a=1jcDQfjXLUsA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221158.211195848@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>
Subject: [34/65] net: use netdev_features_t in skb_needs_linearize()
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0034-net-use-netdev_features_t-in-skb_needs_linearize.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Patrick McHardy <kaber@trash.net>

[ Upstream commit 6708c9e5cc9bfc7c9a00ce9c0fdd0b1d4952b3d1 ]

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index cefd2c2..9b5e388 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2182,7 +2182,7 @@ EXPORT_SYMBOL(netif_skb_features);
  *	   support DMA from it.
  */
 static inline int skb_needs_linearize(struct sk_buff *skb,
-				      int features)
+				      netdev_features_t features)
 {
 	return skb_is_nonlinear(skb) &&
 			((skb_has_frag_list(skb) &&
-- 
1.7.10.4


