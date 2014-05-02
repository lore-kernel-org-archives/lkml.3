Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaEBPms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:42:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43913 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaEBPmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:42:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, infinipath@intel.com,
        Julia Lawall <julia.lawall@lip6.fr>, cocci@systeme.lip6.fr,
        Yann Droneaud <ydroneaud@opteya.com>,
        Roland Dreier <roland@purestorage.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 058/151] IB/qib: add missing braces in do_qib_user_sdma_queue_create()
Date: Fri,  2 May 2014 08:37:26 -0700
Message-Id: <1399045139-4531-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yann Droneaud <ydroneaud@opteya.com>

commit 37a967651caf99dd267017023737bd442f5acb3d upstream.

Commit c804f07248895ff9c moved qib_assign_ctxt() to
do_qib_user_sdma_queue_create() but dropped the braces
around the statements.

This was spotted by coccicheck (coccinelle/spatch):

$ make C=2 CHECK=scripts/coccicheck drivers/infiniband/hw/qib/

  CHECK   drivers/infiniband/hw/qib/qib_file_ops.c
drivers/infiniband/hw/qib/qib_file_ops.c:1583:2-23: code aligned with following code on line 1587

This patch adds braces back.

Link: http://marc.info/?i=cover.1394485254.git.ydroneaud@opteya.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: infinipath@intel.com
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: cocci@systeme.lip6.fr
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Tested-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/hw/qib/qib_file_ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 275f247..2023cd6 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1578,7 +1578,7 @@ static int do_qib_user_sdma_queue_create(struct file *fp)
 	struct qib_ctxtdata *rcd = fd->rcd;
 	struct qib_devdata *dd = rcd->dd;
 
-	if (dd->flags & QIB_HAS_SEND_DMA)
+	if (dd->flags & QIB_HAS_SEND_DMA) {
 
 		fd->pq = qib_user_sdma_queue_create(&dd->pcidev->dev,
 						    dd->unit,
@@ -1586,6 +1586,7 @@ static int do_qib_user_sdma_queue_create(struct file *fp)
 						    fd->subctxt);
 		if (!fd->pq)
 			return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
1.9.1

