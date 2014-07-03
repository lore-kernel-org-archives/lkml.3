Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030973AbaGCKCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:02:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51852 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576AbaGCJWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 077/198] RDMA/cxgb4: Fix four byte info leak in c4iw_create_cq()
Date: Thu,  3 Jul 2014 10:18:40 +0100
Message-Id: <1404379241-8590-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit e24a72a3302a638d4c6e77f0b40c45cc61c3f089 upstream.

There is a four byte hole at the end of the "uresp" struct after the
->qid_mask member.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
[ luis: 3.11.y prereq for:
  b6f04d3d2145 "RDMA/cxgb4: Add missing padding at end of struct c4iw_create_cq_resp" ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/hw/cxgb4/cq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 0f1607c8325a..da9364ea03dd 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -833,6 +833,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 		if (!mm2)
 			goto err4;
 
+		memset(&uresp, 0, sizeof(uresp));
 		uresp.qid_mask = rhp->rdev.cqmask;
 		uresp.cqid = chp->cq.cqid;
 		uresp.size = chp->cq.size;
-- 
1.9.1

