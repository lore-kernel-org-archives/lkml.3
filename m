Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaEQWd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 18:33:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53776 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaEQWdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 18:33:55 -0400
From: Colin King <colin.king@canonical.com>
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] IB/mlx4: fix unitialised variable is_mcast
Date: Sat, 17 May 2014 23:33:44 +0100
Message-Id: <1400366024-18781-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Commit 297e0dad7 introduced a bug where is_mcast is now
no longer initiialised on the non-multicast condition and so
it can be any random value from the stack.  This issue was
detected by cppcheck:

[drivers/infiniband/hw/mlx4/ah.c:103]: (error) Uninitialized
  variable: is_mcast

Simple fix is to initialise is_mcast to zero.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/mlx4/ah.c |    2 +-
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
1.7.9.5

