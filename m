Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab3CEUE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:04:57 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:52613 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab3CEUDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:03:13 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, bfields@fieldses.org,
        jackm@dev.mellanox.co.il, ogerlitz@mellanox.com,
        roland@purestorage.com, dan.magenheimer@oracle.com,
        gregkh@linuxfoundation.org, vjaquez@igalia.com, rene.sapiens@ti.com,
        x0095078@ti.com, omar.ramirez@ti.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] mlx4: remove leftover idr_pre_get() call
Date: Tue,  5 Mar 2013 12:02:49 -0800
Message-Id: <1362513772-15174-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362513772-15174-1-git-send-email-tj@kernel.org>
References: <1362513772-15174-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

6a9200603d ("IB/mlx4: convert to idr_alloc()") forgot to remove
idr_pre_get() call in mlx4_ib_cm_paravirt_init().  It's unnecessary
and idr_pre_get() will soon be deprecated.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Roland Dreier <roland@purestorage.com>
---
 drivers/infiniband/hw/mlx4/cm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index e0d79b2..add98d0 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -362,7 +362,6 @@ void mlx4_ib_cm_paravirt_init(struct mlx4_ib_dev *dev)
 	INIT_LIST_HEAD(&dev->sriov.cm_list);
 	dev->sriov.sl_id_map = RB_ROOT;
 	idr_init(&dev->sriov.pv_id_table);
-	idr_pre_get(&dev->sriov.pv_id_table, GFP_KERNEL);
 }
 
 /* slave = -1 ==> all slaves */
-- 
1.8.1.4

