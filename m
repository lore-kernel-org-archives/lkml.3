Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965477Ab3CZP0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:26:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54206 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965462Ab3CZPYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Denis V. Lunev" <den@openvz.org>, Tingwei Liu <tingw.liu@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 144/150] ipv4: fix definition of FIB_TABLE_HASHSZ
Date: Tue, 26 Mar 2013 15:20:43 +0000
Message-Id: <1364311249-14454-145-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Denis V. Lunev" <den@openvz.org>

commit 5b9e12dbf92b441b37136ea71dac59f05f2673a9 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/ip_fib.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 78df0866..38a005b 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -129,18 +129,16 @@ struct fib_result_nl {
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
1.8.1.2

