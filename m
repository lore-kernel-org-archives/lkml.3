Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab3FNH2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:28:23 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41762 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3FNH2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:28:05 -0400
From: junwei.zhang@6wind.com
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, JunweiZhang <junwei.zhang@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH 2/2] netns: exclude ipvs from struct net when IPVS disabled
Date: Fri, 14 Jun 2013 15:29:54 +0800
Message-Id: <1371194994-6130-2-git-send-email-junwei.zhang@6wind.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371194994-6130-1-git-send-email-junwei.zhang@6wind.com>
References: <1371194994-6130-1-git-send-email-junwei.zhang@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JunweiZhang <junwei.zhang@6wind.com>

no real problem is fixed, just save a few bytes in
net_namespace structure.

Signed-off-by: JunweiZhang <junwei.zhang@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/net/net_namespace.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index b176978..c2bf266 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -115,7 +115,9 @@ struct net {
 #ifdef CONFIG_XFRM
 	struct netns_xfrm	xfrm;
 #endif
+#if IS_ENABLED(CONFIG_IP_VS)
 	struct netns_ipvs	*ipvs;
+#endif
 	struct sock		*diag_nlsk;
 	atomic_t		rt_genid;
 };
-- 
1.8.1.2

