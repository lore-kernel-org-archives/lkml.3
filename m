Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3HBRgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:36:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:29154 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab3HBRgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="375273199"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] NTB: Comment Fix
Date: Fri,  2 Aug 2013 10:35:42 -0700
Message-Id: <1375464944-27914-14-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "data" ntb_register_db_callback parameter description comment and
correct poor spelling.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c        |    5 +++--
 drivers/ntb/ntb_transport.c |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 8153bea..95603f8 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -145,6 +145,7 @@ void ntb_unregister_event_callback(struct ntb_device *ndev)
  * ntb_register_db_callback() - register a callback for doorbell interrupt
  * @ndev: pointer to ntb_device instance
  * @idx: doorbell index to register callback, zero based
+ * @data: pointer to be returned to caller with every callback
  * @func: callback function to register
  *
  * This function registers a callback function for the doorbell interrupt
@@ -1222,9 +1223,9 @@ static int ntb_create_callbacks(struct ntb_device *ndev)
 {
 	int i;
 
-	/* Checken-egg issue.  We won't know how many callbacks are necessary
+	/* Chicken-egg issue.  We won't know how many callbacks are necessary
 	 * until we see how many MSI-X vectors we get, but these pointers need
-	 * to be passed into the MSI-X register fucntion.  So, we allocate the
+	 * to be passed into the MSI-X register function.  So, we allocate the
 	 * max, knowing that they might not all be used, to work around this.
 	 */
 	ndev->db_cb = kcalloc(ndev->limits.max_db_bits,
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index f206842..3b5941e 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1000,7 +1000,7 @@ static void ntb_rx_copy_callback(void *data)
 	hdr->flags = 0;
 
 	/* If the callbacks come out of order, the writing of the index to the
-	 * last completed will be out of order.  This may result in the the
+	 * last completed will be out of order.  This may result in the
 	 * receive stalling forever.
 	 */
 	iowrite32(entry->index, &qp->rx_info->entry);
@@ -1551,7 +1551,7 @@ EXPORT_SYMBOL_GPL(ntb_transport_rx_enqueue);
  * @len: length of the data buffer
  *
  * Enqueue a new transmit buffer onto the transport queue from which a NTB
- * payload will be transmitted.  This assumes that a lock is behing held to
+ * payload will be transmitted.  This assumes that a lock is being held to
  * serialize access to the qp.
  *
  * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
@@ -1609,7 +1609,7 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_up);
  *
  * Notify NTB transport layer of client's desire to no longer receive data on
  * transport queue specified.  It is the client's responsibility to ensure all
- * entries on queue are purged or otherwise handled appropraitely.
+ * entries on queue are purged or otherwise handled appropriately.
  */
 void ntb_transport_link_down(struct ntb_transport_qp *qp)
 {
-- 
1.7.9.5

