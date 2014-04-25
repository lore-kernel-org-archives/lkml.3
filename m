Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaDYArD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:47:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:2441 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaDYArB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:47:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,923,1389772800"; 
   d="scan'208";a="423597673"
From: xiao jin <jin.xiao@intel.com>
To: davem@davemloft.net, trivial@kernel.org, ebiederm@xmission.com,
        dhowells@redhat.com, viro@zeniv.linux.org.uk,
        serge.hallyn@canonical.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: david.a.cohen@linux.intel.com, xiao jin <jin.xiao@intel.com>
Subject: [PATCH] cleanup_net: trivial cleanup
Date: Fri, 25 Apr 2014 08:50:54 +0800
Message-Id: <1398387054-11172-1-git-send-email-jin.xiao@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not initialize net_kill_list twice.
list_replace_init() already takes care of initializing net_kill_list.
We don't need to initialize it with LIST_HEAD() beforehand.

Signed-off-by: xiao jin <jin.xiao@intel.com>
Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
---
 net/core/net_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 81d3a9a..05e949d 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -273,7 +273,7 @@ static void cleanup_net(struct work_struct *work)
 {
 	const struct pernet_operations *ops;
 	struct net *net, *tmp;
-	LIST_HEAD(net_kill_list);
+	struct list_head net_kill_list;
 	LIST_HEAD(net_exit_list);
 
 	/* Atomically snapshot the list of namespaces to cleanup */
-- 
1.7.9.5

