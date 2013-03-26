Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab3CZRl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:41:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab3CZRgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:32 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3SHxdRcwr_AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bRlM2HUVV70A:10 a=7ZN4cI0QAAAA:8 a=J1Y8HTJGAAAA:8 a=QV1kzvntk_ETW8ILOOQA:9 a=Vn2gH7L4UmAA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173610.424776284@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Julian Anastasov <ja@ssi.bg>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 66/86] ipv4: Dont update the pmtu on mtu locked routes
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0066-ipv4-Don-t-update-the-pmtu-on-mtu-locked-routes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 4ac7bed1ff5f935525a8c71c347bbc8cdff9e067 ]

Routes with locked mtu should not use learned pmtu informations,
so do not update the pmtu on these routes.

Reported-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/route.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index fba3240..6d0ae55 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -912,6 +912,9 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 	struct dst_entry *dst = &rt->dst;
 	struct fib_result res;
 
+	if (dst_metric_locked(dst, RTAX_MTU))
+		return;
+
 	if (dst->dev->mtu < mtu)
 		return;
 
-- 
1.7.10.4


