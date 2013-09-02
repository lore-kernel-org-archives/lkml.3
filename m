Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362Ab3IBNIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 09:08:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:15371 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110Ab3IBNIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 09:08:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1007,1367996400"; 
   d="scan'208";a="397046009"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH] dmaengine: dma_slave_caps: remove sg entries
Date: Mon,  2 Sep 2013 17:51:59 +0530
Message-Id: <1378124519-13900-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed by Russell in [1], the sg properties are already availble in struct device,
so no need to duplicate here.

[1]: http://marc.info/?l=linux-omap&m=137416733628831

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 include/linux/dmaengine.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5692bc3..4310b89 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -380,11 +380,6 @@ struct dma_slave_config {
  * 	should be checked by controller as well
  * @cmd_pause: true, if pause and thereby resume is supported
  * @cmd_terminate: true, if terminate cmd is supported
- *
- * @max_sg_nr: maximum number of SG segments supported
- * 	0 for no maximum
- * @max_sg_len: maximum length of a SG segment supported
- * 	0 for no maximum
  */
 struct dma_slave_caps {
 	u32 src_addr_widths;
@@ -392,9 +387,6 @@ struct dma_slave_caps {
 	u32 directions;
 	bool cmd_pause;
 	bool cmd_terminate;
-
-	u32 max_sg_nr;
-	u32 max_sg_len;
 };
 
 static inline const char *dma_chan_name(struct dma_chan *chan)
-- 
1.7.0.4

