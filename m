Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab3BFTus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:50:48 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:33095 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242Ab3BFTun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:43 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 45/77] IB/ocrdma: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:17 -0800
Message-Id: <1360179649-22465-46-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Roland Dreier <roland@purestorage.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index c4e0131..48928c8 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -51,18 +51,6 @@ static DEFINE_IDR(ocrdma_dev_id);
 
 static union ib_gid ocrdma_zero_sgid;
 
-static int ocrdma_get_instance(void)
-{
-	int instance = 0;
-
-	/* Assign an unused number */
-	if (!idr_pre_get(&ocrdma_dev_id, GFP_KERNEL))
-		return -1;
-	if (idr_get_new(&ocrdma_dev_id, NULL, &instance))
-		return -1;
-	return instance;
-}
-
 void ocrdma_get_guid(struct ocrdma_dev *dev, u8 *guid)
 {
 	u8 mac_addr[6];
@@ -416,7 +404,7 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 		goto idr_err;
 
 	memcpy(&dev->nic_info, dev_info, sizeof(*dev_info));
-	dev->id = ocrdma_get_instance();
+	dev->id = idr_alloc(&ocrdma_dev_id, NULL, 0, 0, GFP_KERNEL);
 	if (dev->id < 0)
 		goto idr_err;
 
-- 
1.8.1

