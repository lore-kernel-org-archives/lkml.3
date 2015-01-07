Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbbAGHdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:33:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:61533 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbbAGH3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:29:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="665633593"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Patch v2 03/16] iommu/vt-d: Convert allocations to GFP_KERNEL
Date: Wed,  7 Jan 2015 15:31:30 +0800
Message-Id: <1420615903-28253-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

No reason anymore to do GFP_ATOMIC allocations which are not harmful
in the normal bootup case, but matter in the physical hotplug
scenario.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Borislav Petkov <bp@alien8.de>
Acked-by: Joerg Roedel <joro@8bytes.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20141205084147.472428339@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel_irq_remapping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 2360cb6a8896..1e7e09327753 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -481,11 +481,11 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 	if (iommu->ir_table)
 		return 0;
 
-	ir_table = kzalloc(sizeof(struct ir_table), GFP_ATOMIC);
+	ir_table = kzalloc(sizeof(struct ir_table), GFP_KERNEL);
 	if (!ir_table)
 		return -ENOMEM;
 
-	pages = alloc_pages_node(iommu->node, GFP_ATOMIC | __GFP_ZERO,
+	pages = alloc_pages_node(iommu->node, GFP_KERNEL | __GFP_ZERO,
 				 INTR_REMAP_PAGE_ORDER);
 
 	if (!pages) {
-- 
1.7.10.4

