Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbaGCKKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:10:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51685 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402AbaGCJWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 050/198] IB/qib: Fix port in pkey change event
Date: Thu,  3 Jul 2014 10:18:13 +0100
Message-Id: <1404379241-8590-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/hw/qib/qib_mad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index ccb119143d20..1dd9fcbb7c9a 100644
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

