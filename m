Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaGZT2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:28:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaGZTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Haggai Eran <haggaie@mellanox.com>, Eli Cohen <eli@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.15 103/109] IB/mlx5: Enable "block multicast loopback" for kernel consumers
Date: Sat, 26 Jul 2014 12:03:05 -0700
Message-Id: <20140726190226.952306163@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

commit 652c1a05171695d21b84dd3a723606b50eeb80fd upstream.

In commit f360d88a2efd, we advertise blocking multicast loopback to both
kernel and userspace consumers, but don't allow kernel consumers (e.g IPoIB)
to use it with their UD QPs.  Fix that.

Fixes: f360d88a2efd ("IB/mlx5: Add block multicast loopback support")
Reported-by: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/qp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -671,7 +671,7 @@ static int create_kernel_qp(struct mlx5_
 	int err;
 
 	uuari = &dev->mdev.priv.uuari;
-	if (init_attr->create_flags & ~IB_QP_CREATE_SIGNATURE_EN)
+	if (init_attr->create_flags & ~(IB_QP_CREATE_SIGNATURE_EN | IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK))
 		return -EINVAL;
 
 	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR)


