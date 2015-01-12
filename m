Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbbALXQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:16:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:19750 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbbALXKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:10:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="511204083"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next v2 05/13] misc: mic: Common MIC header file changes in preparation for SCIF
Date: Mon, 12 Jan 2015 15:09:59 -0800
Message-Id: <cc6e379ede0fcd115a9b5c50ab5527c2e51889a1.1421097390.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1421097390.git.sudeep.dutt@intel.com>
References: <cover.1421097390.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1421097390.git.sudeep.dutt@intel.com>
References: <cover.1421097390.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update mic_bootparam and define the maximum number of DMA channels

Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/common/mic_dev.h |  3 +++
 include/uapi/linux/mic_common.h   | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/misc/mic/common/mic_dev.h b/drivers/misc/mic/common/mic_dev.h
index 92999c2..0b58c46 100644
--- a/drivers/misc/mic/common/mic_dev.h
+++ b/drivers/misc/mic/common/mic_dev.h
@@ -48,4 +48,7 @@ struct mic_mw {
 #define MIC_VIRTIO_PARAM_DEV_REMOVE 0x1
 #define MIC_VIRTIO_PARAM_CONFIG_CHANGED 0x2
 
+/* Maximum number of DMA channels */
+#define MIC_MAX_DMA_CHAN 4
+
 #endif
diff --git a/include/uapi/linux/mic_common.h b/include/uapi/linux/mic_common.h
index 6eb4024..302a2ce 100644
--- a/include/uapi/linux/mic_common.h
+++ b/include/uapi/linux/mic_common.h
@@ -80,6 +80,12 @@ struct mic_device_ctrl {
  * @h2c_config_db: Host to Card Virtio config doorbell set by card
  * @shutdown_status: Card shutdown status set by card
  * @shutdown_card: Set to 1 by the host when a card shutdown is initiated
+ * @tot_nodes: Total number of nodes in the SCIF network
+ * @node_id: Unique id of the node
+ * @h2c_scif_db - Host to card SCIF doorbell set by card
+ * @c2h_scif_db - Card to host SCIF doorbell set by host
+ * @scif_host_dma_addr - SCIF host queue pair DMA address
+ * @scif_card_dma_addr - SCIF card queue pair DMA address
  */
 struct mic_bootparam {
 	__le32 magic;
@@ -88,6 +94,12 @@ struct mic_bootparam {
 	__s8 h2c_config_db;
 	__u8 shutdown_status;
 	__u8 shutdown_card;
+	__u8 tot_nodes;
+	__u8 node_id;
+	__u8 h2c_scif_db;
+	__u8 c2h_scif_db;
+	__u64 scif_host_dma_addr;
+	__u64 scif_card_dma_addr;
 } __attribute__ ((aligned(8)));
 
 /**
-- 
1.8.2.1

