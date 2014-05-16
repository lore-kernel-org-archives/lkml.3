Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbaEPMTC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:19:02 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57343 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399AbaEPMSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:18:39 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH v3 13/13] ARM/platform_data: edma: Remove redundant/unused parameters from edma_soc_info
Date: Fri, 16 May 2014 15:17:20 +0300
Message-ID: <1400242640-9902-14-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following parameters are no longer needed by the edma driver since the
information can be obtained from the IP's CCCFG register:
n_channel, n_region, n_slot and n_tc.
Remove the n_cc as well since in this context it has no meaning. We have
separate edma_soc_info struct/eDMA3_CC instance so this member does not
make any sense (and the driver no longer uses it).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/platform_data/edma.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
index 633e196ebdf2..eb8d5627d080 100644
--- a/include/linux/platform_data/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -158,13 +158,6 @@ struct edma_rsv_info {
 
 /* platform_data for EDMA driver */
 struct edma_soc_info {
-
-	/* how many dma resources of each type */
-	unsigned	n_channel;
-	unsigned	n_region;
-	unsigned	n_slot;
-	unsigned	n_tc;
-	unsigned	n_cc;
 	/*
 	 * Default queue is expected to be a low-priority queue.
 	 * This way, long transfers on the default queue started
-- 
1.9.3

