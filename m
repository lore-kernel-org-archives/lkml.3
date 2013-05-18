Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab3ERCta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:49:30 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58828 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab3ERCt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:49:29 -0400
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: Jon Mason <jon.mason@intel.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 3.9-stable] NTB: reset tx_index on link toggle
Date: Sat, 18 May 2013 11:47:17 +0900
Message-Id: <1368845237-4114-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Mason <jon.mason@intel.com>

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Jon Mason <jon.mason@intel.com>"

commit 90f9e934647e652a69396e18c779215a493271cf upstream

If the NTB link toggles, the driver could stop receiving due to the
tx_index not being set to 0 on the transmitting size on a link-up event.
This is due to the driver expecting the incoming data to start at the
beginning of the receive buffer and not at a random place.

Cc: <stable@vger.kernel.org> # 3.9.x: ad3e2751: ntb: off by one
Cc: <stable@vger.kernel.org> # 3.9.x: cc0f868d: NTB: fix pointer math
Cc: <stable@vger.kernel.org> # 3.9.x: 113fc505: NTB: Handle 64bit BAR
Cc: <stable@vger.kernel.org> # 3.9.x: b77b2637: NTB: Link toggle memory
Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/ntb/ntb_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index f5a424d..0828124 100644
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
1.8.1.2

