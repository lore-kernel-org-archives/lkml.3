Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab3JJPsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:48:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab3JJPsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:48:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 031/104] cpqarray: fix info leak in ida_locked_ioctl()
Date: Thu, 10 Oct 2013 08:41:19 -0700
Message-Id: <1381419752-29733-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 627aad1c01da6f881e7f98d71fd928ca0c316b1a upstream.

The pciinfo struct has a two byte hole after ->dev_fn so stack
information could be leaked to the user.

This was assigned CVE-2013-2147.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/cpqarray.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 3f08713..3997d04 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -1195,6 +1195,7 @@ out_passthru:
 		ida_pci_info_struct pciinfo;
 
 		if (!arg) return -EINVAL;
+		memset(&pciinfo, 0, sizeof(pciinfo));
 		pciinfo.bus = host->pci_dev->bus->number;
 		pciinfo.dev_fn = host->pci_dev->devfn;
 		pciinfo.board_id = host->board_id;
-- 
1.8.1.2

