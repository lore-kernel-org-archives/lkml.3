Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaDNLmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:42:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45679 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbaDNLmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:42:35 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>,
        <joelf@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH v3 01/10] platform_data: edma: Be precise with the paRAM struct
Date: Mon, 14 Apr 2014 14:41:56 +0300
Message-ID: <1397475725-5036-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The edmacc_param struct should follow the layout of the paRAM area in the
HW. Be explicit on the size of the fields (u32) and also mark the struct
as packed to avoid any padding on non 32bit architectures.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Joel Fernandes <joelf@ti.com>
---
 include/linux/platform_data/edma.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
index f50821cb64be..923f8a3e4ce0 100644
--- a/include/linux/platform_data/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -43,15 +43,15 @@
 
 /* PaRAM slots are laid out like this */
 struct edmacc_param {
-	unsigned int opt;
-	unsigned int src;
-	unsigned int a_b_cnt;
-	unsigned int dst;
-	unsigned int src_dst_bidx;
-	unsigned int link_bcntrld;
-	unsigned int src_dst_cidx;
-	unsigned int ccnt;
-};
+	u32 opt;
+	u32 src;
+	u32 a_b_cnt;
+	u32 dst;
+	u32 src_dst_bidx;
+	u32 link_bcntrld;
+	u32 src_dst_cidx;
+	u32 ccnt;
+} __packed;
 
 /* fields in edmacc_param.opt */
 #define SAM		BIT(0)
-- 
1.9.2

