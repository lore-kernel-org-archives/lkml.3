Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaDANHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:07:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52499 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbaDANHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:07:02 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: [PATCH v2 06/14] arm: common: edma: Save the number of event queues/TCs
Date: Tue, 1 Apr 2014 16:06:07 +0300
Message-ID: <1396357575-30585-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For later use save the number of queues available for the CC.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 19520e2519d9..be267b2080be 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1770,6 +1770,9 @@ static int edma_probe(struct platform_device *pdev)
 			map_queue_tc(j, queue_tc_mapping[i][0],
 					queue_tc_mapping[i][1]);
 
+		/* Save the number of TCs */
+		edma_cc[j]->num_tc = i;
+
 		/* Event queue priority mapping */
 		for (i = 0; queue_priority_mapping[i][0] != -1; i++)
 			assign_priority_to_queue(j,
-- 
1.9.1

