Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723Ab3BNJCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:02:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:46799 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab3BNJAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:00:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,662,1355126400"; 
   d="scan'208";a="202264295"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/6] dma: of-dma: protect list write operation by spin_lock
Date: Thu, 14 Feb 2013 11:00:15 +0200
Message-Id: <1360832420-6349-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360832420-6349-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1360832420-6349-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible to have an inconsistency in the list due to unprotected operation
on it. The patch adds a proper locking on the list operation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/of-dma.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 59631b2..1ae6120 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -117,7 +117,9 @@ int of_dma_controller_register(struct device_node *np,
 	ofdma->use_count = 0;
 
 	/* Now queue of_dma controller structure in list */
+	spin_lock(&of_dma_lock);
 	list_add_tail(&ofdma->of_dma_controllers, &of_dma_list);
+	spin_unlock(&of_dma_lock);
 
 	return 0;
 }
-- 
1.7.10.4

