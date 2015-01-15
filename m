Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbbAOTyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:54:40 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:60988 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbbAOTyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:54:39 -0500
From: Shrikrishna Khare <skhare@vmware.com>
To: sbhatewara@vmware.com, pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Shrikrishna Khare <skhare@vmware.com>, Gao Zhenyu <gzhenyu@vmware.com>
Subject: [PATCH net-next] Driver: Vmxnet3: Fix ethtool -S to return correct rx queue stats
Date: Thu, 15 Jan 2015 11:54:30 -0800
Message-Id: <1421351670-18424-1-git-send-email-skhare@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gao Zhenyu <gzhenyu@vmware.com>
Signed-off-by: Shrikrishna Khare <skhare@vmware.com>
Reviewed-by: Shreyas N Bhatewara <sbhatewara@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c |    2 +-
 drivers/net/vmxnet3/vmxnet3_int.h     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 8a5a90e..4c8a944 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -323,7 +323,7 @@ vmxnet3_get_ethtool_stats(struct net_device *netdev,
 					  vmxnet3_tq_driver_stats[i].offset);
 	}
 
-	for (j = 0; j < adapter->num_tx_queues; j++) {
+	for (j = 0; j < adapter->num_rx_queues; j++) {
 		base = (u8 *)&adapter->rqd_start[j].stats;
 		*buf++ = (u64) j;
 		for (i = 1; i < ARRAY_SIZE(vmxnet3_rq_dev_stats); i++)
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 6297d9f..406144b 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -69,10 +69,10 @@
 /*
  * Version numbers
  */
-#define VMXNET3_DRIVER_VERSION_STRING   "1.3.2.0-k"
+#define VMXNET3_DRIVER_VERSION_STRING   "1.3.3.0-k"
 
 /* a 32-bit int, each byte encode a verion number in VMXNET3_DRIVER_VERSION */
-#define VMXNET3_DRIVER_VERSION_NUM      0x01030200
+#define VMXNET3_DRIVER_VERSION_NUM      0x01030300
 
 #if defined(CONFIG_PCI_MSI)
 	/* RSS only makes sense if MSI-X is supported. */
-- 
1.7.4.1

