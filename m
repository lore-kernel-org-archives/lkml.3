Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab3ASJDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 04:03:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:52702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab3ASJDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:03:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,498,1355126400"; 
   d="scan'208";a="274089765"
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 03/21] NTB: correct memory barrier
Date: Sat, 19 Jan 2013 02:02:17 -0700
Message-Id: <1358586155-23322-4-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmiowb is not sufficient to flush the data and is causing data
corruption.  Change to wmb and the data corruption is no more.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 1d17857..e9666bd 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1009,7 +1009,7 @@ static void ntb_tx_copy_task(struct ntb_transport_qp *qp,
 	hdr->ver = qp->tx_pkts;
 
 	/* Ensure that the data is fully copied out before setting the flag */
-	mmiowb();
+	wmb();
 	hdr->flags = entry->flags | DESC_DONE_FLAG;
 
 	ntb_ring_sdb(qp->ndev, qp->qp_num);
-- 
1.7.9.5

