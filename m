Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbbAONB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:01:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50046 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbbAONB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:01:26 -0500
Date: Thu, 15 Jan 2015 04:59:01 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-e3a981d61d156c1a9ea0aac253d2d3f33c081906@git.kernel.org>
Cc: joro@8bytes.org, hpa@zytor.com, mingo@kernel.org, yinghai@kernel.org,
        bp@alien8.de, tglx@linutronix.de, benh@kernel.crashing.org,
        tony.luck@intel.com, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, jiang.liu@linux.intel.com,
        tony.luck@intel.com, tglx@linutronix.de, benh@kernel.crashing.org,
        bp@alien8.de, mingo@kernel.org, yinghai@kernel.org, hpa@zytor.com,
        joro@8bytes.org
In-Reply-To: <1420615903-28253-4-git-send-email-jiang.liu@linux.intel.com>
References: <20141205084147.472428339@linutronix.de>
	<1420615903-28253-4-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/vt-d: Convert allocations to GFP_KERNEL
Git-Commit-ID: e3a981d61d156c1a9ea0aac253d2d3f33c081906
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3a981d61d156c1a9ea0aac253d2d3f33c081906
Gitweb:     http://git.kernel.org/tip/e3a981d61d156c1a9ea0aac253d2d3f33c081906
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 Jan 2015 15:31:30 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:22 +0100

iommu/vt-d: Convert allocations to GFP_KERNEL

No reason anymore to do GFP_ATOMIC allocations which are not harmful
in the normal bootup case, but matter in the physical hotplug
scenario.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Borislav Petkov <bp@alien8.de>
Acked-and-tested-by: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20141205084147.472428339@linutronix.de
Link: http://lkml.kernel.org/r/1420615903-28253-4-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/intel_irq_remapping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 2360cb6..1e7e093 100644
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
