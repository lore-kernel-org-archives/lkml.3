Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaKZXTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:19:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58964 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaKZXTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:19:13 -0500
Date: Wed, 26 Nov 2014 15:18:22 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-507e02f58f0c889077b74fc748a921f5e4abc82b@git.kernel.org>
Cc: joro@8bytes.org, konrad.wilk@oracle.com, hpa@zytor.com, bp@alien8.de,
        bhelgaas@google.com, rjw@rjwysocki.net, tglx@linutronix.de,
        jiang.liu@linux.intel.com, benh@kernel.crashing.org,
        gregkh@linuxfoundation.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org, mingo@kernel.org,
        yinghai@kernel.org, jroedel@suse.de
Reply-To: gregkh@linuxfoundation.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        yinghai@kernel.org, mingo@kernel.org, jroedel@suse.de,
        konrad.wilk@oracle.com, joro@8bytes.org, hpa@zytor.com, bp@alien8.de,
        rjw@rjwysocki.net, bhelgaas@google.com, tglx@linutronix.de,
        jiang.liu@linux.intel.com, benh@kernel.crashing.org
In-Reply-To: <1416901802-24211-23-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-23-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Kill irq_cfg.irq_remapped
Git-Commit-ID: 507e02f58f0c889077b74fc748a921f5e4abc82b
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

Commit-ID:  507e02f58f0c889077b74fc748a921f5e4abc82b
Gitweb:     http://git.kernel.org/tip/507e02f58f0c889077b74fc748a921f5e4abc82b
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:46 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:48 +0100

x86, irq: Kill irq_cfg.irq_remapped

Now there is no user of irq_cfg.irq_remapped, so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: iommu@lists.linux-foundation.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>
Link: http://lkml.kernel.org/r/1416901802-24211-23-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/hw_irq.h       | 1 -
 drivers/iommu/amd_iommu.c           | 1 -
 drivers/iommu/intel_irq_remapping.c | 2 --
 3 files changed, 4 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index bbf90fe..88632ea 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -193,7 +193,6 @@ struct irq_cfg {
 	u8			vector;
 	u8			move_in_progress : 1;
 #ifdef CONFIG_IRQ_REMAP
-	u8			remapped : 1;
 	union {
 		struct irq_2_iommu irq_2_iommu;
 		struct irq_2_irte  irq_2_irte;
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index e2b56b4..cc4ac40 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4129,7 +4129,6 @@ static void irq_remapping_prepare_irte(struct amd_ir_data *data,
 	struct msi_msg *msg = &data->msi_entry;
 	struct IO_APIC_route_entry *entry;
 
-	irq_cfg->remapped = 1;
 	data->irq_2_irte.devid = devid;
 	data->irq_2_irte.index = index + sub_handle;
 
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 9a887ba..a2a4647 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -66,7 +66,6 @@ static int alloc_irte(struct intel_iommu *iommu, int irq,
 		      struct irq_2_iommu *irq_iommu, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
-	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned int mask = 0;
 	unsigned long flags;
 	int index;
@@ -93,7 +92,6 @@ static int alloc_irte(struct intel_iommu *iommu, int irq,
 	if (index < 0) {
 		pr_warn("IR%d: can't allocate an IRTE\n", iommu->seq_id);
 	} else {
-		cfg->remapped = 1;
 		irq_iommu->iommu = iommu;
 		irq_iommu->irte_index =  index;
 		irq_iommu->sub_handle = 0;
