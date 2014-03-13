Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaCMJT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:19:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57395 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbaCMJTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:19:23 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <nsekhar@ti.com>,
        Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: [PATCH 01/18] platform_data: edma: Be precise with the paRAM struct
Date: Thu, 13 Mar 2014 11:18:23 +0200
Message-ID: <1394702320-21743-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
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
1.9.0

