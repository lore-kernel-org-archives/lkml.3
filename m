Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964926Ab3DKUhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:37:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5882 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab3DKU0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:03 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=y5mKQqwUkfkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VeTUtvQ8DR4A:10 a=6rqHouBjAAAA:8 a=pGLkceISAAAA:8 a=21nLoJTmAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=TAmEwCHjoHMA:10 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202548.239838675@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Denis V. Lunev" <den@openvz.org>, Tingwei Liu <tingw.liu@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 012/171 ] ipv4: fix definition of FIB_TABLE_HASHSZ
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0012-ipv4-fix-definition-of-FIB_TABLE_HASHSZ.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Denis V. Lunev" <den@openvz.org>

[ Upstream commit 5b9e12dbf92b441b37136ea71dac59f05f2673a9 ]

a long time ago by the commit

  commit 93456b6d7753def8760b423ac6b986eb9d5a4a95
  Author: Denis V. Lunev <den@openvz.org>
  Date:   Thu Jan 10 03:23:38 2008 -0800

    [IPV4]: Unify access to the routing tables.

the defenition of FIB_HASH_TABLE size has obtained wrong dependency:
it should depend upon CONFIG_IP_MULTIPLE_TABLES (as was in the original
code) but it was depended from CONFIG_IP_ROUTE_MULTIPATH

This patch returns the situation to the original state.

The problem was spotted by Tingwei Liu.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Tingwei Liu <tingw.liu@gmail.com>
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/net/ip_fib.h |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 9497be1..e49db91 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -152,18 +152,16 @@ struct fib_result_nl {
 };
 
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
-
 #define FIB_RES_NH(res)		((res).fi->fib_nh[(res).nh_sel])
-
-#define FIB_TABLE_HASHSZ 2
-
 #else /* CONFIG_IP_ROUTE_MULTIPATH */
-
 #define FIB_RES_NH(res)		((res).fi->fib_nh[0])
+#endif /* CONFIG_IP_ROUTE_MULTIPATH */
 
+#ifdef CONFIG_IP_MULTIPLE_TABLES
 #define FIB_TABLE_HASHSZ 256
-
-#endif /* CONFIG_IP_ROUTE_MULTIPATH */
+#else
+#define FIB_TABLE_HASHSZ 2
+#endif
 
 extern __be32 fib_info_update_nh_saddr(struct net *net, struct fib_nh *nh);
 
-- 
1.7.10.4


