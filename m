Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab3CZRl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:41:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12218 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab3CZRgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:33 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=aM-efU7i_jYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=EnBGGdvio2IA:10 a=7ZN4cI0QAAAA:8 a=J1Y8HTJGAAAA:8 a=gTsZcdP12QjSaUH6-agA:9 a=Vn2gH7L4UmAA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173610.269795593@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 65/86] ipv4: Remove output route check in ipv4_mtu
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0065-ipv4-Remove-output-route-check-in-ipv4_mtu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 34f48df8ec531943ca83ea994eb2561897d8f9f4 ]

The output route check was introduced with git commit 261663b0
(ipv4: Don't use the cached pmtu informations for input routes)
during times when we cached the pmtu informations on the
inetpeer. Now the pmtu informations are back in the routes,
so this check is obsolete. It also had some unwanted side effects,
as reported by Timo Teras and Lukas Tribus.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Timo Teräs <timo.teras@iki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 285a18f..fba3240 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1123,7 +1123,7 @@ static unsigned int ipv4_mtu(const struct dst_entry *dst)
 	if (!mtu)
 		mtu = dst_metric_raw(dst, RTAX_MTU);
 
-	if (mtu && rt_is_output_route(rt))
+	if (mtu)
 		return mtu;
 
 	mtu = dst->dev->mtu;
-- 
1.7.10.4


