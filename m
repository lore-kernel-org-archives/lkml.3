Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaDANHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:07:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35257 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbaDANHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:07:01 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: [PATCH v2 05/14] arm: common: edma: Select event queue 1 as default when booted with DT
Date: Tue, 1 Apr 2014 16:06:06 +0300
Message-ID: <1396357575-30585-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the EVENTQ_1 for default and leave the EVENTQ_0 to be used by high
priority channels, like audio.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 86a8b263278f..19520e2519d9 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1546,7 +1546,8 @@ static int edma_of_parse_dt(struct device *dev,
 
 	pdata->queue_priority_mapping = queue_priority_map;
 
-	pdata->default_queue = 0;
+	/* select queue 1 as default */
+	pdata->default_queue = EVENTQ_1;
 
 	prop = of_find_property(node, "ti,edma-xbar-event-map", &sz);
 	if (prop)
-- 
1.9.1

