Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3GVM6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:58:10 -0400
Received: from etezian.org ([198.101.225.253]:56150 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab3GVM6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:58:08 -0400
From: Andi Shyti <andi@etezian.org>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        davem@davemloft.net
Cc: v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andi@etezian.org
Subject: [PATCH] net: trans_rdma: remove unused function
Date: Mon, 22 Jul 2013 14:59:16 +0200
Message-Id: <1374497956-32104-1-git-send-email-andi@etezian.org>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gets rid of the following warning:

net/9p/trans_rdma.c:594:12: warning: ‘rdma_cancelled’ defined but not used [-Wunused-function]
 static int rdma_cancelled(struct p9_client *client, struct p9_req_t *req)

The rdma_cancelled function is not called anywhere in the kernel

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 net/9p/trans_rdma.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 928f2bb..8f68df5 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -588,17 +588,6 @@ static int rdma_cancel(struct p9_client *client, struct p9_req_t *req)
 	return 1;
 }
 
-/* A request has been fully flushed without a reply.
- * That means we have posted one buffer in excess.
- */
-static int rdma_cancelled(struct p9_client *client, struct p9_req_t *req)
-{
-	struct p9_trans_rdma *rdma = client->trans;
-
-	atomic_inc(&rdma->excess_rc);
-	return 0;
-}
-
 /**
  * trans_create_rdma - Transport method for creating atransport instance
  * @client: client instance
-- 
1.8.3.2

