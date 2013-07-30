Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405Ab3G3JSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:18:18 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:5929 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab3G3JSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:18:16 -0400
Message-ID: <51F7844F.60904@huawei.com>
Date: Tue, 30 Jul 2013 17:15:59 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <ericvh@gmail.com>, <rminnich@sandia.gov>, <lucho@ionkov.net>,
        <davem@davemloft.net>, <v9fs-developer@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: fix build warning in trans_rdma.c
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building v3.11-rc3, I get the following warning:
...
net/9p/trans_rdma.c:594: warning: ‘rdma_cancelled’ defined but not used
...
As the function is not be used, so remove it.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 net/9p/trans_rdma.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

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
1.7.1

