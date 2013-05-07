Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab3EGB4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:56:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:29232 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842Ab3EGB4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:56:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="333594772"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 06/10] NTB: reset tx_index on link toggle
Date: Mon,  6 May 2013 18:55:25 -0700
Message-Id: <1367891729-11738-7-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
References: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the NTB link toggles, the driver could stop receiving due to the
tx_index not being set to 0 on the transmitting size on a link-up event.
This is due to the driver expecting the incoming data to start at the
beginning of the receive buffer and not at a random place.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index be416d6..73a000e 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -505,6 +505,7 @@ static void ntb_transport_setup_qp_mw(struct ntb_transport *nt,
 
 	qp->rx_pkts = 0;
 	qp->tx_pkts = 0;
+	qp->tx_index = 0;
 }
 
 static void ntb_free_mw(struct ntb_transport *nt, int num_mw)
@@ -819,7 +820,6 @@ static void ntb_transport_init_queue(struct ntb_transport *nt,
 	qp->tx_mw = qp->rx_info + 1;
 	qp->tx_max_frame = min(transport_mtu, tx_size);
 	qp->tx_max_entry = tx_size / qp->tx_max_frame;
-	qp->tx_index = 0;
 
 	if (nt->debugfs_dir) {
 		char debugfs_name[4];
-- 
1.7.9.5

