Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbaEMJge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:36:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60921 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760117AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>, infinipath@intel.com,
        Julia Lawall <julia.lawall@lip6.fr>, cocci@systeme.lip6.fr,
        Roland Dreier <roland@purestorage.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 071/182] IB/qib: add missing braces in do_qib_user_sdma_queue_create()
Date: Tue, 13 May 2014 11:27:03 +0200
Message-Id: <d0ca4bb914a8e7c213edd4881360fb29ea493c42.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yann Droneaud <ydroneaud@opteya.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/hw/qib/qib_file_ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 275f247f9fca..2023cd61b897 100644
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
1.9.3

