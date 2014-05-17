Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaEQMKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 08:10:50 -0400
Received: from mout.gmx.net ([212.227.17.22]:53613 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361AbaEQMKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 08:10:49 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: linux-rdma@vger.kernel.org
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        monis@mellanox.com, ogerlitz@mellanox.com,
        linux-kernel@vger.kernel.org, Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] IB/mlx4: Fix potentially uninitialized use of 'is_mcast' in create_iboe_ah()
Date: Sat, 17 May 2014 14:09:27 +0200
Message-Id: <1400328567-4430-1-git-send-email-cengelma@gmx.at>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:hC353l6/DTMEAPbo8GZU/6gMtRRQZJlqNkww/anTuDoynkaqwlQ
 zx3b1GBxzxMPftSynwrgu5FuukD7W9zTUycF7Qi0AaqlcdjQPlKm8oH3c5NhuRn+jvgydNl
 9WweMILezhDIpS/t5FFIyAyF7hRipW503+QiWCdW7plIZLT+kZLMl1kXK3lcPxlfKfouTa2
 jKYfNwrMLvQwu9VPwa1+Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before commit 297e0da (IB/mlx4: Handle Ethernet L2 parameters for IP based GID
addressing) local variable 'is_mcast' in function create_iboe_ah() was
guaranteed to be set after calling mlx4_ib_resolve_grh(). Since 297e0da
'is_mcast' is set in case of rdma_is_multicast_addr(), but otherwise left
uninitialized. Thus init 'is_mcast' to 0. Detected by Coverity - CID 1164324

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested. Applies against branch for-next in tree
git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
---
 drivers/infiniband/hw/mlx4/ah.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 170dca6..2d8c339 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -73,7 +73,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 {
 	struct mlx4_ib_dev *ibdev = to_mdev(pd->device);
 	struct mlx4_dev *dev = ibdev->dev;
-	int is_mcast;
+	int is_mcast = 0;
 	struct in6_addr in6;
 	u16 vlan_tag;
 
-- 
1.9.1

