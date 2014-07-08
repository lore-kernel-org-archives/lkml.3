Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbaGHKr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:47:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53884 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaGHKrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:47:16 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <vinod.koul@intel.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH 1/3] ARM: edma: Set default queue to lowest priority
Date: Tue, 8 Jul 2014 13:46:36 +0300
Message-ID: <1404816398-12338-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404816398-12338-1-git-send-email-peter.ujfalusi@ti.com>
References: <1404816398-12338-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the lowest priority queue as default for clients.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/common/edma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 485be42519b9..f834aae7720f 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1470,7 +1470,8 @@ static int edma_setup_from_hw(struct device *dev, struct edma_soc_info *pdata,
 	queue_priority_map[i][1] = -1;
 
 	pdata->queue_priority_mapping = queue_priority_map;
-	pdata->default_queue = 0;
+	/* Default queue has the lowest priority */
+	pdata->default_queue = i - 1;
 
 	return 0;
 }
-- 
2.0.0

