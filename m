Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934792Ab3DILGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:06:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:12479 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758245Ab3DILGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:06:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="283609686"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/5] dmaengine: call acpi_dma_request_slave_channel as well
Date: Tue,  9 Apr 2013 14:05:44 +0300
Message-Id: <1365505547-10552-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1365505547-10552-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1365505547-10552-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slave device could be enumerated by ACPI. In that case the
dma_request_slave_channel should use the acpi_dma_request_slave_channel()
helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/dma/dmaengine.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index c121b03..93f7992 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -62,6 +62,8 @@
 #include <linux/rculist.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
+#include <linux/acpi.h>
+#include <linux/acpi_dma.h>
 #include <linux/of_dma.h>
 
 static DEFINE_MUTEX(dma_list_mutex);
@@ -564,6 +566,10 @@ struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name)
 	if (dev->of_node)
 		return of_dma_request_slave_channel(dev->of_node, name);
 
+	/* If device was enumerated by ACPI get slave info from here */
+	if (ACPI_HANDLE(dev))
+		return acpi_dma_request_slave_chan_by_name(dev, name);
+
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(dma_request_slave_channel);
-- 
1.8.2.rc0.22.gb3600c3

