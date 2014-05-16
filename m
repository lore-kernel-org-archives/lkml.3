Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbaEPMVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:21:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44798 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250AbaEPMSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:18:16 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH v3 06/13] ARM: edma: Remove num_cc member from struct edma
Date: Fri, 16 May 2014 15:17:13 +0300
Message-ID: <1400242640-9902-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct edma is allocated per CC bases so the member num_cc does not make
any sense. One CC is one CC, it does not have sub CCs.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 0bc5ed6fc249..929a03e4749c 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -233,7 +233,6 @@ struct edma {
 	unsigned	num_region;
 	unsigned	num_slots;
 	unsigned	num_tc;
-	unsigned	num_cc;
 	enum dma_event_q 	default_queue;
 
 	/* list of channels with no even trigger; terminated by "-1" */
@@ -1481,7 +1480,6 @@ static int edma_of_parse_dt(struct device *dev,
 		return ret;
 	pdata->n_slot = value;
 
-	pdata->n_cc = 1;
 	pdata->n_tc = 3;
 
 	rsv_info = devm_kzalloc(dev, sizeof(struct edma_rsv_info), GFP_KERNEL);
@@ -1627,8 +1625,6 @@ static int edma_probe(struct platform_device *pdev)
 							EDMA_MAX_DMACH);
 		edma_cc[j]->num_slots = min_t(unsigned, info[j]->n_slot,
 							EDMA_MAX_PARAMENTRY);
-		edma_cc[j]->num_cc = min_t(unsigned, info[j]->n_cc,
-							EDMA_MAX_CC);
 		edma_cc[j]->num_tc = info[j]->n_tc;
 
 		edma_cc[j]->default_queue = info[j]->default_queue;
-- 
1.9.3

