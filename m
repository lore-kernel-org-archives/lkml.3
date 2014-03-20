Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbaCTOLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:11:25 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:38737 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaCTOLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:11:16 -0400
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        colin.king@canonical.com, bjking1@us.ibm.com, esa@de.ibm.com,
        haver@linux.vnet.ibm.com
Subject: [PATCH 3/5] GenWQE: Ensure rc is not returning an uninitialized value
Date: Thu, 20 Mar 2014 15:11:04 +0100
Message-Id: <1395324666-27153-3-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1395324666-27153-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1395324666-27153-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032014-3548-0000-0000-00000874BE4B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

rc is not initialized, so genwqe_finish_queue() either returns -EIO or
garbage.  Fortunately the return is not being checked by any callers,
so this has not yet caused any problems. Even so, it makes sense to
fix this small bug in case is is checked in future.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_ddcb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/genwqe/card_ddcb.c
+++ b/drivers/misc/genwqe/card_ddcb.c
@@ -1310,7 +1310,7 @@ static int queue_wake_up_all(struct genw
  */
 int genwqe_finish_queue(struct genwqe_dev *cd)
 {
-	int i, rc, in_flight;
+	int i, rc = 0, in_flight;
 	int waitmax = genwqe_ddcb_software_timeout;
 	struct pci_dev *pci_dev = cd->pci_dev;
 	struct ddcb_queue *queue = &cd->queue;

