Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaDYAtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:49:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:19601 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaDYAtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:49:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,923,1389772800"; 
   d="scan'208";a="527968089"
From: xiao jin <jin.xiao@intel.com>
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, trivial@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: david.a.cohen@linux.intel.com, xiao jin <jin.xiao@intel.com>
Subject: [PATCH] inetpeer_gc_worker: trivial cleanup
Date: Fri, 25 Apr 2014 08:53:29 +0800
Message-Id: <1398387209-12322-1-git-send-email-jin.xiao@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not initialize list twice.
list_replace_init() already takes care of initializing list.
We don't need to initialize it with LIST_HEAD() beforehand.

Signed-off-by: xiao jin <jin.xiao@intel.com>
Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
---
 net/ipv4/inetpeer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index 48f4244..c98cf14 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -120,7 +120,7 @@ int inet_peer_maxttl __read_mostly = 10 * 60 * HZ;	/* usual time to live: 10 min
 static void inetpeer_gc_worker(struct work_struct *work)
 {
 	struct inet_peer *p, *n, *c;
-	LIST_HEAD(list);
+	struct list_head list;
 
 	spin_lock_bh(&gc_lock);
 	list_replace_init(&gc_list, &list);
-- 
1.7.9.5

