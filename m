Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbaEDQnO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:43:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaEDPlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Roland Dreier <roland@purestorage.com>, infinipath@intel.com,
        cocci@systeme.lip6.fr
Subject: [PATCH 3.14 086/158] IB/qib: add missing braces in do_qib_user_sdma_queue_create()
Date: Sun,  4 May 2014 11:39:55 -0400
Message-Id: <20140504154041.576662788@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/qib/qib_file_ops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1578,7 +1578,7 @@ static int do_qib_user_sdma_queue_create
 	struct qib_ctxtdata *rcd = fd->rcd;
 	struct qib_devdata *dd = rcd->dd;
 
-	if (dd->flags & QIB_HAS_SEND_DMA)
+	if (dd->flags & QIB_HAS_SEND_DMA) {
 
 		fd->pq = qib_user_sdma_queue_create(&dd->pcidev->dev,
 						    dd->unit,
@@ -1586,6 +1586,7 @@ static int do_qib_user_sdma_queue_create
 						    fd->subctxt);
 		if (!fd->pq)
 			return -ENOMEM;
+	}
 
 	return 0;
 }


