Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaCMJTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:19:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51823 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbaCMJTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:19:43 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <nsekhar@ti.com>,
        Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: [PATCH 05/18] arm: common: edma: Save the number of event queues/TCs
Date: Thu, 13 Mar 2014 11:18:27 +0200
Message-ID: <1394702320-21743-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
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
1.9.0

