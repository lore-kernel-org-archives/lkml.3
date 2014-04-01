Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaDANGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:06:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52452 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaDANGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:06:47 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: [PATCH v2 01/14] platform_data: edma: Be precise with the paRAM struct
Date: Tue, 1 Apr 2014 16:06:02 +0300
Message-ID: <1396357575-30585-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The edmacc_param struct should follow the layout of the paRAM area in the
HW. Be explicit on the size of the fields (u32) and also mark the struct
as packed to avoid any padding on non 32bit architectures.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
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
1.9.1

