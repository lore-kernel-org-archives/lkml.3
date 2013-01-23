Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3AWT0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 14:26:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20911 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab3AWT0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 14:26:17 -0500
Date: Wed, 23 Jan 2013 22:26:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] NTB: fix pointer math issues
Message-ID: <20130123192605.GA11121@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->remote_rx_info and ->rx_info are struct ntb_rx_info pointers.  If we
add sizeof(struct ntb_rx_info) then it goes too far.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---

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
