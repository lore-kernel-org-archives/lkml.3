Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbaEPMSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:18:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53617 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038AbaEPMSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:18:08 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH v3 02/13] ARM: edma: Take the number of tc from edma_soc_info (pdata)
Date: Fri, 16 May 2014 15:17:09 +0300
Message-ID: <1400242640-9902-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of saving the for loop length, take the num_tc value from the pdata.
In case of DT boot set the n_tc to 3 as it is hardwired in edma_of_parse_dt()
This is a temporary state since upcoming patch(es) will change how we are
dealing with these parameters.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 01707aae0a2b..d42c84a3432a 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1488,6 +1488,7 @@ static int edma_of_parse_dt(struct device *dev,
 	pdata->n_slot = value;
 
 	pdata->n_cc = 1;
+	pdata->n_tc = 3;
 
 	rsv_info = devm_kzalloc(dev, sizeof(struct edma_rsv_info), GFP_KERNEL);
 	if (!rsv_info)
@@ -1648,6 +1649,7 @@ static int edma_probe(struct platform_device *pdev)
 							EDMA_MAX_PARAMENTRY);
 		edma_cc[j]->num_cc = min_t(unsigned, info[j]->n_cc,
 							EDMA_MAX_CC);
+		edma_cc[j]->num_tc = info[j]->n_tc;
 
 		edma_cc[j]->default_queue = info[j]->default_queue;
 
@@ -1741,9 +1743,6 @@ static int edma_probe(struct platform_device *pdev)
 			map_queue_tc(j, queue_tc_mapping[i][0],
 					queue_tc_mapping[i][1]);
 
-		/* Save the number of TCs */
-		edma_cc[j]->num_tc = i;
-
 		/* Event queue priority mapping */
 		for (i = 0; queue_priority_mapping[i][0] != -1; i++)
 			assign_priority_to_queue(j,
-- 
1.9.3

