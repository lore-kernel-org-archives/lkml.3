Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab3GPNds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:33:48 -0400
Received: from etezian.org ([198.101.225.253]:57838 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229Ab3GPNdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:33:47 -0400
From: Andi Shyti <andi@etezian.org>
To: eli@mellanox.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, andi@etezian.org
Subject: [PATCH] mlx5: qp: variable may be used uninitialized
Date: Tue, 16 Jul 2013 15:35:01 +0200
Message-Id: <1373981701-15276-1-git-send-email-andi@etezian.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in the sq_overhead() function, if qp_typ is equal to IB_QPT_RC,
size will be used uninitialized.

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 16ac54c..045f8cd 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -199,7 +199,7 @@ static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
 
 static int sq_overhead(enum ib_qp_type qp_type)
 {
-	int size;
+	int size = 0;
 
 	switch (qp_type) {
 	case IB_QPT_XRC_INI:
-- 
1.8.3.2

