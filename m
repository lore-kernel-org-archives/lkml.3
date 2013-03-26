Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3CZWnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:43:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab3CZWne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Denis V. Lunev" <den@openvz.org>, Tingwei Liu <tingw.liu@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 11/98] ipv4: fix definition of FIB_TABLE_HASHSZ
Date: Tue, 26 Mar 2013 15:42:00 -0700
Message-Id: <20130326224243.635129189@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip_fib.h |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

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
 


