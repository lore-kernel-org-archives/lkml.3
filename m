Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaBQF5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:57:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:33554 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaBQF5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:57:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,858,1384329600"; 
   d="scan'208";a="456674172"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] IA64, sba_iommu: fix section mismatch
Date: Mon, 17 Feb 2014 13:58:00 +0800
Message-Id: <1392616684-8410-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the section mismatch warning by remove __init annotate for function
acpi_sba_ioc_add() because it may be called at runtime.

WARNING: vmlinux.o(.data+0x66ee0): Section mismatch in reference from the variable acpi_sba_ioc_handler to the function .init.text:acpi_sba_ioc_add()
The variable acpi_sba_ioc_handler references
the function __init acpi_sba_ioc_add()

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/ia64/hp/common/sba_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 8e858b5..c9d6f0b 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -2041,7 +2041,7 @@ sba_map_ioc_to_node(struct ioc *ioc, acpi_handle handle)
 #define sba_map_ioc_to_node(ioc, handle)
 #endif
 
-static int __init
+static int
 acpi_sba_ioc_add(struct acpi_device *device,
 		 const struct acpi_device_id *not_used)
 {
-- 
1.7.10.4

