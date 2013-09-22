Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3IVQez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 12:34:55 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56469 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3IVQey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 12:34:54 -0400
From: Avinash kumar <avi.kp.137@gmail.com>
To: sbhatewara@vmware.com
Cc: pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avinash kumar <avi.kp.137@gmail.com>
Subject: [PATCH 3/3] drivers: net: vmxnet3: vmxnet3_int.h: removed checkpatch warnings
Date: Sun, 22 Sep 2013 22:04:37 +0530
Message-Id: <1379867677-3607-1-git-send-email-avi.kp.137@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

removed following checkpatch warnings:
drivers/net/vmxnet3/vmxnet3_int.h:241: WARNING: __aligned(size) is preferred over __attribute__((aligned(size)))
drivers/net/vmxnet3/vmxnet3_int.h:284: WARNING: __aligned(size) is preferred over __attribute__((aligned(size)))
drivers/net/vmxnet3/vmxnet3_int.h:413: WARNING: extern prototypes should be avoided in .h files

Signed-off-by: Avinash Kumar <avi.kp.137@gmail.com>
---
 drivers/net/vmxnet3/vmxnet3_int.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index a03f358..71ae32b 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -238,7 +238,7 @@ struct vmxnet3_tx_queue {
 	int                             num_stop;  /* # of times the queue is
 						    * stopped */
 	int				qid;
-} __attribute__((__aligned__(SMP_CACHE_BYTES)));
+} __aligned(SMP_CACHE_BYTES);
 
 enum vmxnet3_rx_buf_type {
 	VMXNET3_RX_BUF_NONE = 0,
@@ -281,7 +281,7 @@ struct vmxnet3_rx_queue {
 	dma_addr_t                      buf_info_pa;
 	struct Vmxnet3_RxQueueCtrl            *shared;
 	struct vmxnet3_rq_driver_stats  stats;
-} __attribute__((__aligned__(SMP_CACHE_BYTES)));
+} __aligned(SMP_CACHE_BYTES);
 
 #define VMXNET3_DEVICE_MAX_TX_QUEUES 8
 #define VMXNET3_DEVICE_MAX_RX_QUEUES 8   /* Keep this value as a power of 2 */
@@ -410,7 +410,7 @@ int
 vmxnet3_create_queues(struct vmxnet3_adapter *adapter,
 		      u32 tx_ring_size, u32 rx_ring_size, u32 rx_ring2_size);
 
-extern void vmxnet3_set_ethtool_ops(struct net_device *netdev);
+void vmxnet3_set_ethtool_ops(struct net_device *netdev);
 
 extern struct rtnl_link_stats64 *
 vmxnet3_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats);
-- 
1.7.9.5

