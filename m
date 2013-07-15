Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab3GOP3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:29:15 -0400
Received: from mail.tpi.com ([74.45.170.26]:2030 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757835Ab3GOP3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:29:13 -0400
X-Greylist: delayed 1885 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2013 11:29:13 EDT
From: Tim Gardner <tim.gardner@canonical.com>
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Eli Cohen <eli@mellanox.com>
Subject: [PATCH 3.11-rc1] mlx5 core: Fix __udivdi3 when compiling for 32 bit arches
Date: Mon, 15 Jul 2013 08:56:45 -0600
Message-Id: <1373900205-69711-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Eli Cohen <eli@mellanox.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 4273c06..9c7194b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -156,7 +156,7 @@ static ssize_t average_read(struct file *filp, char __user *buf, size_t count,
 	stats = filp->private_data;
 	spin_lock(&stats->lock);
 	if (stats->n)
-		field = stats->sum / stats->n;
+		field = div64_u64(stats->sum, stats->n);
 	spin_unlock(&stats->lock);
 	ret = snprintf(tbuf, sizeof(tbuf), "%llu\n", field);
 	if (ret > 0) {
-- 
1.7.9.5

