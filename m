Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbaGAT7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:59:01 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:16618 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbaGAT67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:58:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsHAOMRs1NbsGsk/2dsb2JhbABagw2sYwUBbplbgQ8XdYQxLyOBGjeIRgGzCJVfF4VviExkHYQtBZpmi0WIPoNEO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Eli Cohen <eli@mellanox.com>,
        Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH 1/1] IB/mlx5: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Tue,  1 Jul 2014 21:58:44 +0200
Message-Id: <1404244724-24528-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use macro definition

Cc: Eli Cohen <eli@mellanox.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d13ddf1..e9a3250 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2501,7 +2501,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	spin_lock_irqsave(&qp->sq.lock, flags);
 
 	for (nreq = 0; wr; nreq++, wr = wr->next) {
-		if (unlikely(wr->opcode >= sizeof(mlx5_ib_opcode) / sizeof(mlx5_ib_opcode[0]))) {
+		if (unlikely(wr->opcode >= ARRAY_SIZE(mlx5_ib_opcode))) {
 			mlx5_ib_warn(dev, "\n");
 			err = -EINVAL;
 			*bad_wr = wr;
-- 
1.9.1

