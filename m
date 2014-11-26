Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaKZXTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:19:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58979 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaKZXT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:19:29 -0500
Date: Wed, 26 Nov 2014 15:18:36 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-f77d545bdd26566a2ecdda216730d6334402ad93@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        tony.luck@intel.com, tglx@linutronix.de, rdunlap@infradead.org,
        konrad.wilk@oracle.com, benh@kernel.crashing.org, mingo@kernel.org,
        rjw@rjwysocki.net, bp@alien8.de, joro@8bytes.org,
        gregkh@linuxfoundation.org, jroedel@suse.de, yinghai@kernel.org,
        bhelgaas@google.com
Reply-To: yinghai@kernel.org, bhelgaas@google.com, gregkh@linuxfoundation.org,
        jroedel@suse.de, bp@alien8.de, rjw@rjwysocki.net, joro@8bytes.org,
        mingo@kernel.org, benh@kernel.crashing.org, konrad.wilk@oracle.com,
        tglx@linutronix.de, rdunlap@infradead.org, tony.luck@intel.com,
        jiang.liu@linux.intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <1416901802-24211-24-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-24-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/vt-d:
  Move struct irq_2_iommu into intel_irq_remapping.c
Git-Commit-ID: f77d545bdd26566a2ecdda216730d6334402ad93
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

Commit-ID:  f77d545bdd26566a2ecdda216730d6334402ad93
Gitweb:     http://git.kernel.org/tip/f77d545bdd26566a2ecdda216730d6334402ad93
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:47 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:48 +0100

iommu/vt-d: Move struct irq_2_iommu into intel_irq_remapping.c

Now only intel_irq_remapping.c access irq_2_iommu, so move it from
hw_irq.h into intel_irq_remapping.c.

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
Link: http://lkml.kernel.org/r/1416901802-24211-24-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/hw_irq.h       | 9 ---------
 drivers/iommu/intel_irq_remapping.c | 7 +++++++
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 88632ea..3520f71 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -95,14 +95,6 @@ extern void trace_call_function_single_interrupt(void);
 #endif /* CONFIG_TRACING */
 
 #ifdef CONFIG_IRQ_REMAP
-/* Intel specific interrupt remapping information */
-struct irq_2_iommu {
-	struct intel_iommu *iommu;
-	u16 irte_index;
-	u16 sub_handle;
-	u8  irte_mask;
-};
-
 /* AMD specific interrupt remapping information */
 struct irq_2_irte {
 	u16 devid; /* Device ID for IRTE table */
@@ -194,7 +186,6 @@ struct irq_cfg {
 	u8			move_in_progress : 1;
 #ifdef CONFIG_IRQ_REMAP
 	union {
-		struct irq_2_iommu irq_2_iommu;
 		struct irq_2_irte  irq_2_irte;
 	};
 #endif
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index a2a4647..acff849 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -32,6 +32,13 @@ struct hpet_scope {
 	unsigned int devfn;
 };
 
+struct irq_2_iommu {
+	struct intel_iommu *iommu;
+	u16 irte_index;
+	u16 sub_handle;
+	u8  irte_mask;
+};
+
 struct intel_ir_data {
 	struct irq_2_iommu			irq_2_iommu;
 	struct irte				irte_entry;
