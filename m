Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3GPIYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:24:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:59961 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab3GPIYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:24:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,676,1367996400"; 
   d="scan'208";a="268875846"
From: shuox.liu@intel.com
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: bhelgaas@google.com, rjw@sisk.pl, lenb@kernel.org,
        yanmin_zhang@linux.intel.com
Subject: [PATCH] pnp: avoid inaccurate resource name
Date: Tue, 16 Jul 2013 16:23:44 +0800
Message-Id: <1373963024-5237-1-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu ShuoX <shuox.liu@intel.com>

Set temporary variable as 0 to avoid garbage string output from
/proc/iomem after register resources, and reset to pnp dev name.

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 drivers/pnp/pnpacpi/rsparser.c | 2 +-
 drivers/pnp/resource.c         | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 9847ab1..167f3d0 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -180,7 +180,7 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 	struct pnp_dev *dev = data;
 	struct acpi_resource_dma *dma;
 	struct acpi_resource_vendor_typed *vendor_typed;
-	struct resource r;
+	struct resource r = {0};
 	int i, flags;
 
 	if (acpi_dev_resource_memory(res, &r)
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index 3e6db1c..d95e101 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -515,6 +515,7 @@ struct pnp_resource *pnp_add_resource(struct pnp_dev *dev,
 	}
 
 	pnp_res->res = *res;
+	pnp_res->res.name = dev->name;
 	dev_dbg(&dev->dev, "%pR\n", res);
 	return pnp_res;
 }
-- 
1.8.3

