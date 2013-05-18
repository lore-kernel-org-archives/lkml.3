Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab3ERClR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:41:17 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62666 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3ERClQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:41:16 -0400
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: Jon Mason <jon.mason@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 3.9-table] NTB: fix pointer math issues
Date: Sat, 18 May 2013 11:39:05 +0900
Message-Id: <1368844745-3908-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Dan Carpenter <dan.carpenter@oracle.com>"

commit cc0f868d8adef7bdc12cda132654870086d766bc upstream

->remote_rx_info and ->rx_info are struct ntb_rx_info pointers.  If we
add sizeof(struct ntb_rx_info) then it goes too far.

Cc: <stable@vger.kernel.org> # 3.9.x: ad3e2751: ntb: off by one
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/ntb/ntb_transport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index e0bdfd7..676ee16 100644
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
1.8.1.2

