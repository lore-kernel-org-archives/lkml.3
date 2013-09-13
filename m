Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3IMUiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:38:15 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:50432 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3IMUiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:38:13 -0400
From: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
Subject: [PATCH 1/1] =?UTF-8?q?infiniband:=20hw:=20fix=20uninitialized=20?= =?UTF-8?q?=E2=80=98old=5Fqps=E2=80=99?=
Date: Fri, 13 Sep 2013 14:38:25 -0300
Message-Id: <1379093905-5968-1-git-send-email-antonio.alecrim@gmail.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added missing old_qps initialization in order to fix the following
    warnings:
drivers/infiniband/hw/ocrdma/ocrdma_verbs.c: In function
‘_ocrdma_modify_qp’:
drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:1299:31: warning: ‘old_qps’
may be used uninitialized in this function [-Wmaybe-uninitialized]
  status = ocrdma_mbx_modify_qp(dev, qp, attr, attr_mask, old_qps);

Signed-off-by: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 6e982bb..da6c23f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1289,6 +1289,7 @@ int _ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	qp = get_ocrdma_qp(ibqp);
 	dev = qp->dev;
+	old_qps = get_ibqp_state(qp->state);
 	if (attr_mask & IB_QP_STATE)
 		status = ocrdma_qp_state_change(qp, attr->qp_state, &old_qps);
 	/* if new and previous states are same hw doesn't need to
-- 
1.8.3.1

