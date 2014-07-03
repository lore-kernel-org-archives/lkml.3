Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbaGCJZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:25:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030528AbaGCJYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 172/198] sba_iommu: fix section mismatch
Date: Thu,  3 Jul 2014 10:20:15 +0100
Message-Id: <1404379241-8590-173-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <jiang.liu@linux.intel.com>

commit f3ffaaa8b727da6c442b5b8cb356c2196b6e2d59 upstream.
To: linux-kernel@vger.kernel.org

Fix the section mismatch warning by remove __init annotate for functions
ioc_iova_init(), ioc_init() and acpi_sba_ioc_add() because they may be called at runtime.

WARNING: vmlinux.o(.data+0x66ee0): Section mismatch in reference from the variable acpi_sba_ioc_handler to the function .init.text:acpi_sba_ioc_add()
The variable acpi_sba_ioc_handler references
the function __init acpi_sba_ioc_add()

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/ia64/hp/common/sba_iommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index d43daf192b21..7dd4889458d7 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -1596,7 +1596,7 @@ static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
 *
 ***************************************************************/
 
-static void __init
+static void
 ioc_iova_init(struct ioc *ioc)
 {
 	int tcnfg;
@@ -1807,7 +1807,7 @@ static struct ioc_iommu ioc_iommu_info[] __initdata = {
 	{ SX2000_IOC_ID, "sx2000", NULL },
 };
 
-static struct ioc * __init
+static struct ioc *
 ioc_init(unsigned long hpa, void *handle)
 {
 	struct ioc *ioc;
@@ -2041,7 +2041,7 @@ sba_map_ioc_to_node(struct ioc *ioc, acpi_handle handle)
 #define sba_map_ioc_to_node(ioc, handle)
 #endif
 
-static int __init
+static int
 acpi_sba_ioc_add(struct acpi_device *device,
 		 const struct acpi_device_id *not_used)
 {
-- 
1.9.1

