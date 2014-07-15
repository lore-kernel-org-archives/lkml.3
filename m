Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167AbaGOVma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:42:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55140 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204AbaGOVje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 061/198] IB/qib: Fix port in pkey change event
Date: Tue, 15 Jul 2014 14:28:51 -0700
Message-Id: <1405459868-15089-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 911eccd284d13d78c92ec4f1f1092c03457d732a upstream.

The code used a literal 1 in dispatching an IB_EVENT_PKEY_CHANGE.

As of the dual port qib QDR card, this is not necessarily correct.

Change to use the port as specified in the call.

Reported-by: Alex Estrin <alex.estrin@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/hw/qib/qib_mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index ccb1191..1dd9fcb 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -1028,7 +1028,7 @@ static int set_pkeys(struct qib_devdata *dd, u8 port, u16 *pkeys)
 
 		event.event = IB_EVENT_PKEY_CHANGE;
 		event.device = &dd->verbs_dev.ibdev;
-		event.element.port_num = 1;
+		event.element.port_num = port;
 		ib_dispatch_event(&event);
 	}
 	return 0;
-- 
1.9.1

