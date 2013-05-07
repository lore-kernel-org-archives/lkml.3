Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810Ab3EGB6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:58:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:20011 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932887Ab3EGBz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:55:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="329960321"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 03/10] NTB: fix pointer math issues
Date: Mon,  6 May 2013 18:55:22 -0700
Message-Id: <1367891729-11738-4-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
References: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

->remote_rx_info and ->rx_info are struct ntb_rx_info pointers.  If we
add sizeof(struct ntb_rx_info) then it goes too far.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_transport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 74c5812..00f5e80 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -486,7 +486,7 @@ static void ntb_transport_setup_qp_mw(struct ntb_transport *nt,
 			     (qp_num / NTB_NUM_MW * rx_size);
 	rx_size -= sizeof(struct ntb_rx_info);
 
-	qp->rx_buff = qp->remote_rx_info + sizeof(struct ntb_rx_info);
+	qp->rx_buff = qp->remote_rx_info + 1;
 	qp->rx_max_frame = min(transport_mtu, rx_size);
 	qp->rx_max_entry = rx_size / qp->rx_max_frame;
 	qp->rx_index = 0;
@@ -780,7 +780,7 @@ static void ntb_transport_init_queue(struct ntb_transport *nt,
 		      (qp_num / NTB_NUM_MW * tx_size);
 	tx_size -= sizeof(struct ntb_rx_info);
 
-	qp->tx_mw = qp->rx_info + sizeof(struct ntb_rx_info);
+	qp->tx_mw = qp->rx_info + 1;
 	qp->tx_max_frame = min(transport_mtu, tx_size);
 	qp->tx_max_entry = tx_size / qp->tx_max_frame;
 	qp->tx_index = 0;
-- 
1.7.9.5

