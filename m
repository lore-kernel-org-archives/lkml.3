Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3EJMPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:15:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:7459 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab3EJMO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:14:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,647,1363158000"; 
   d="scan'208";a="331927147"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Shani Michaeli <shanim@mellanox.com>,
        Roland Dreier <roland@purestorage.com>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 09/11] net/sunrpc: take msecs_to_jiffies_min into use
Date: Fri, 10 May 2013 15:13:27 +0300
Message-Id: <1368188011-23661-9-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies_min instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 net/sunrpc/xprtrdma/verbs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 93726560..9cac2c8 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -404,7 +404,7 @@ rpcrdma_create_id(struct rpcrdma_xprt *xprt,
 		goto out;
 	}
 	wait_for_completion_interruptible_timeout(&ia->ri_done,
-				msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT) + 1);
+				msecs_to_jiffies_min(RDMA_RESOLVE_TIMEOUT));
 	rc = ia->ri_async_rc;
 	if (rc)
 		goto out;
@@ -417,7 +417,7 @@ rpcrdma_create_id(struct rpcrdma_xprt *xprt,
 		goto out;
 	}
 	wait_for_completion_interruptible_timeout(&ia->ri_done,
-				msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT) + 1);
+				msecs_to_jiffies_min(RDMA_RESOLVE_TIMEOUT));
 	rc = ia->ri_async_rc;
 	if (rc)
 		goto out;
-- 
1.7.10.4

