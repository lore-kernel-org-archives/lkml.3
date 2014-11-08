Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaKHSQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:16:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:46363 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097AbaKHSQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:16:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413533955"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part3 v3 24/38] iommu/amd: Move struct irq_2_irte into amd_iommu.c
Date: Sun,  9 Nov 2014 02:13:24 +0800
Message-Id: <1415470418-10874-25-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now only amd_iommu.c access irq_2_irte, so move it from hw_irq.h into
amd_iommu.c.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h |   13 -------------
 drivers/iommu/amd_iommu.c     |    5 +++++
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 8dd38c205719..a086893fa710 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -94,14 +94,6 @@ extern void trace_call_function_single_interrupt(void);
 #define trace_kvm_posted_intr_ipi kvm_posted_intr_ipi
 #endif /* CONFIG_TRACING */
 
-#ifdef CONFIG_IRQ_REMAP
-/* AMD specific interrupt remapping information */
-struct irq_2_irte {
-	u16 devid; /* Device ID for IRTE table */
-	u16 index; /* Index into IRTE table*/
-};
-#endif	/* CONFIG_IRQ_REMAP */
-
 struct irq_domain;
 
 #ifdef	CONFIG_X86_LOCAL_APIC
@@ -182,11 +174,6 @@ struct irq_cfg {
 	unsigned int		dest_apicid;
 	u8			vector;
 	u8			move_in_progress : 1;
-#ifdef CONFIG_IRQ_REMAP
-	union {
-		struct irq_2_irte  irq_2_irte;
-	};
-#endif
 	union {
 #ifdef CONFIG_X86_IO_APIC
 		struct {
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 2f76656a88ce..236cc7ee0b85 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3855,6 +3855,11 @@ union irte {
 	} fields;
 };
 
+struct irq_2_irte {
+	u16 devid; /* Device ID for IRTE table */
+	u16 index; /* Index into IRTE table*/
+};
+
 struct amd_ir_data {
 	struct irq_2_irte			irq_2_irte;
 	union irte				irte_entry;
-- 
1.7.10.4

