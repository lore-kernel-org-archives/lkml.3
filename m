Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbbATFwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:52:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:44348 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbbATFwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:52:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664447570"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Joerg Roedel <joro@8bytes.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part2 v4 14/33] irq_remapping/vt-d: Move struct irq_2_iommu into intel_irq_remapping.c
Date: Tue, 20 Jan 2015 13:51:34 +0800
Message-Id: <1421733113-15704-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 arch/x86/include/asm/hw_irq.h       |    9 ---------
 drivers/iommu/intel_irq_remapping.c |    7 +++++++
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 88632ea75fe0..3520f71f168b 100644
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
index 21fc899e7c49..8a71ef6af93c 100644
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
-- 
1.7.10.4

