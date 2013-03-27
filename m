Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3C0TcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:32:13 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:51081 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3C0T3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:29:45 -0400
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org,
        Steve Wise <swise@opengridcomputing.com>,
        Tom Tucker <tom@opengridcomputing.com>, linux-rdma@vger.kernel.org
Subject: [PATCH v2 2/6] amso1100: convert to using idr_alloc_cyclic
Date: Wed, 27 Mar 2013 15:29:34 -0400
Message-Id: <1364412578-7462-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364412578-7462-1-git-send-email-jlayton@redhat.com>
References: <1364412578-7462-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Note: compile-tested only)

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Tucker <tom@opengridcomputing.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/amso1100/c2.h    | 1 -
 drivers/infiniband/hw/amso1100/c2_qp.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2.h b/drivers/infiniband/hw/amso1100/c2.h
index ba7a1208..d619d73 100644
--- a/drivers/infiniband/hw/amso1100/c2.h
+++ b/drivers/infiniband/hw/amso1100/c2.h
@@ -265,7 +265,6 @@ struct c2_pd_table {
 struct c2_qp_table {
 	struct idr idr;
 	spinlock_t lock;
-	int last;
 };
 
 struct c2_element {
diff --git a/drivers/infiniband/hw/amso1100/c2_qp.c b/drivers/infiniband/hw/amso1100/c2_qp.c
index 0ab826b..86708de 100644
--- a/drivers/infiniband/hw/amso1100/c2_qp.c
+++ b/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -385,8 +385,7 @@ static int c2_alloc_qpn(struct c2_dev *c2dev, struct c2_qp *qp)
 	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&c2dev->qp_table.lock);
 
-	ret = idr_alloc(&c2dev->qp_table.idr, qp, c2dev->qp_table.last++, 0,
-			GFP_NOWAIT);
+	ret = idr_alloc_cyclic(&c2dev->qp_table.idr, qp, 0, 0, GFP_NOWAIT);
 	if (ret >= 0)
 		qp->qpn = ret;
 
-- 
1.7.11.7

