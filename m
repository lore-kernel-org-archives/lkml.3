Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaLEX1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:27:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40393 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaLEX1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:27:03 -0500
Date: Fri, 5 Dec 2014 15:26:39 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-326c2bb2c526a203ad01a1c05662278d12e81b04@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, joro@8bytes.org,
        mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        jiang.liu@linux.intel.com
Reply-To: hpa@zytor.com, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de
In-Reply-To: <20141205084147.472428339@linutronix.de>
References: <20141205084147.472428339@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/vt-d: Convert allocations to GFP_KERNEL
Git-Commit-ID: 326c2bb2c526a203ad01a1c05662278d12e81b04
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

Commit-ID:  326c2bb2c526a203ad01a1c05662278d12e81b04
Gitweb:     http://git.kernel.org/tip/326c2bb2c526a203ad01a1c05662278d12e81b04
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 5 Dec 2014 08:48:36 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 6 Dec 2014 00:19:25 +0100

iommu/vt-d: Convert allocations to GFP_KERNEL

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
---
 drivers/iommu/intel_irq_remapping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index a17e411..ff35b03 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -406,11 +406,11 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
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
 		pr_err("IR%d: failed to allocate pages of order %d\n",
