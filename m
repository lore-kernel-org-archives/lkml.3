Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab3FROTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:19:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:16134 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868Ab3FROTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:19:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,889,1363158000"; 
   d="scan'208";a="331537034"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] acpi-dma: fix sparse warning
Date: Tue, 18 Jun 2013 17:19:27 +0300
Message-Id: <1371565167-27700-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes sparse warning:
	drivers/dma/acpi-dma.c:76:21: sparse: cast to restricted __le32

Since everything in all ACPI tables is little-endian, by definition, the used
types in practice are uXX. Thus, we have to enforce __leXX if we want to
convert them to CPU order.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/acpi-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/acpi-dma.c b/drivers/dma/acpi-dma.c
index 5a18f82..ba7f932 100644
--- a/drivers/dma/acpi-dma.c
+++ b/drivers/dma/acpi-dma.c
@@ -73,7 +73,7 @@ static int acpi_dma_parse_resource_group(const struct acpi_csrt_group *grp,
 	if (si->mmio_base_low != mem || si->gsi_interrupt != irq)
 		return 0;
 
-	vendor_id = le32_to_cpu(grp->vendor_id);
+	vendor_id = le32_to_cpu((__force __le32)grp->vendor_id);
 	dev_dbg(&adev->dev, "matches with %.4s%04X (rev %u)\n",
 		(char *)&vendor_id, grp->device_id, grp->revision);
 
-- 
1.8.3.1

