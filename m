Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3C0I6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:58:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:51813 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab3C0I6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:58:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,917,1355126400"; 
   d="scan'208";a="309058126"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/6] dmaengine: call acpi_dma_request_slave_channel as well
Date: Wed, 27 Mar 2013 10:57:58 +0200
Message-Id: <1364374682-8547-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1364374682-8547-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1364374682-8547-1-git-send-email-andriy.shevchenko@linux.intel.com>
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
index 2cbfefe..8bbd6aa 100644
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
@@ -561,6 +563,10 @@ struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name)
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

