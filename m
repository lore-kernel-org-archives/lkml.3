Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbaEPMSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:18:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57339 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266AbaEPMSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:18:25 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH v3 07/13] ARM: edma: Save number of regions from pdata to struct edma
Date: Fri, 16 May 2014 15:17:14 +0300
Message-ID: <1400242640-9902-8-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be consistent in the code that we take parameters from edma_cc[j] struct
and not randomly from info[j] as well.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 929a03e4749c..aa9473cb0c23 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1628,6 +1628,7 @@ static int edma_probe(struct platform_device *pdev)
 		edma_cc[j]->num_tc = info[j]->n_tc;
 
 		edma_cc[j]->default_queue = info[j]->default_queue;
+		edma_cc[j]->num_region = info[j]->n_region;
 
 		dev_dbg(&pdev->dev, "DMA REG BASE ADDR=%p\n",
 			edmacc_regs_base[j]);
@@ -1725,7 +1726,7 @@ static int edma_probe(struct platform_device *pdev)
 		if (edma_read(j, EDMA_CCCFG) & CHMAP_EXIST)
 			map_dmach_param(j);
 
-		for (i = 0; i < info[j]->n_region; i++) {
+		for (i = 0; i < edma_cc[j]->num_region; i++) {
 			edma_write_array2(j, EDMA_DRAE, i, 0, 0x0);
 			edma_write_array2(j, EDMA_DRAE, i, 1, 0x0);
 			edma_write_array(j, EDMA_QRAE, i, 0x0);
-- 
1.9.3

