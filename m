Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaCVUhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 16:37:40 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:50896 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaCVUhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 16:37:38 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: infinipath@intel.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/infiniband: Use RCU_INIT_POINTER(x, NULL) in hw/qib/qib_keys.c
Date: Sun, 23 Mar 2014 02:06:39 +0530
Message-Id: <1395520599-3411-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/infiniband/hw/qib/qib_keys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 3b9afcc..ad843c7 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -122,10 +122,10 @@ void qib_free_lkey(struct qib_mregion *mr)
 	if (!mr->lkey_published)
 		goto out;
 	if (lkey == 0)
-		rcu_assign_pointer(dev->dma_mr, NULL);
+		RCU_INIT_POINTER(dev->dma_mr, NULL);
 	else {
 		r = lkey >> (32 - ib_qib_lkey_table_size);
-		rcu_assign_pointer(rkt->table[r], NULL);
+		RCU_INIT_POINTER(rkt->table[r], NULL);
 	}
 	qib_put_mr(mr);
 	mr->lkey_published = 0;
-- 
1.7.9.5

