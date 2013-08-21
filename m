Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab3HUL1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 07:27:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:40434 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab3HUL1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 07:27:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,927,1367996400"; 
   d="scan'208";a="284786621"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/2] acpi-dma: remove ugly conversion
Date: Wed, 21 Aug 2013 14:27:06 +0300
Message-Id: <1377084426-11179-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377084426-11179-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1377084426-11179-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of big endian CPU we have to convert either all fields in the structure
or leave this job to ACPICA. The second choice seems the best.

So, let's remove the ugly conversion that is not fully comprehensive anyway.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/dma/acpi-dma.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/dma/acpi-dma.c b/drivers/dma/acpi-dma.c
index ba7f932..e69b03c 100644
--- a/drivers/dma/acpi-dma.c
+++ b/drivers/dma/acpi-dma.c
@@ -43,7 +43,6 @@ static int acpi_dma_parse_resource_group(const struct acpi_csrt_group *grp,
 	struct list_head resource_list;
 	struct resource_list_entry *rentry;
 	resource_size_t mem = 0, irq = 0;
-	u32 vendor_id;
 	int ret;
 
 	if (grp->shared_info_length != sizeof(struct acpi_csrt_shared_info))
@@ -73,9 +72,8 @@ static int acpi_dma_parse_resource_group(const struct acpi_csrt_group *grp,
 	if (si->mmio_base_low != mem || si->gsi_interrupt != irq)
 		return 0;
 
-	vendor_id = le32_to_cpu((__force __le32)grp->vendor_id);
 	dev_dbg(&adev->dev, "matches with %.4s%04X (rev %u)\n",
-		(char *)&vendor_id, grp->device_id, grp->revision);
+		(char *)&grp->vendor_id, grp->device_id, grp->revision);
 
 	/* Check if the request line range is available */
 	if (si->base_request_line == 0 && si->num_handshake_signals == 0)
-- 
1.8.4.rc2

