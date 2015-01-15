Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbbAONDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:03:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbbAONDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:03:52 -0500
Date: Thu, 15 Jan 2015 05:02:42 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-c392f56c946033bd136043079a62b9188888828d@git.kernel.org>
Cc: richard@nod.at, linux-kernel@vger.kernel.org, hpa@linux.intel.com,
        oren@scalemp.com, joro@8bytes.org, yinghai@kernel.org,
        benh@kernel.crashing.org, jiang.liu@linux.intel.com,
        d.hatayama@jp.fujitsu.com, mingo@kernel.org, rientjes@google.com,
        tglx@linutronix.de, JBeulich@suse.com, bp@alien8.de,
        tony.luck@intel.com, jroedel@suse.de, hpa@zytor.com
Reply-To: richard@nod.at, linux-kernel@vger.kernel.org, joro@8bytes.org,
        hpa@linux.intel.com, oren@scalemp.com, yinghai@kernel.org,
        benh@kernel.crashing.org, d.hatayama@jp.fujitsu.com,
        jiang.liu@linux.intel.com, JBeulich@suse.com, mingo@kernel.org,
        rientjes@google.com, tglx@linutronix.de, tony.luck@intel.com,
        hpa@zytor.com, jroedel@suse.de, bp@alien8.de
In-Reply-To: <1420615903-28253-14-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-14-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/irq_remapping:
  Kill function irq_remapping_supported() and related code
Git-Commit-ID: c392f56c946033bd136043079a62b9188888828d
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

Commit-ID:  c392f56c946033bd136043079a62b9188888828d
Gitweb:     http://git.kernel.org/tip/c392f56c946033bd136043079a62b9188888828d
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Wed, 7 Jan 2015 15:31:40 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:23 +0100

iommu/irq_remapping: Kill function irq_remapping_supported() and related code

Simplify irq_remapping code by killing irq_remapping_supported() and
related interfaces.

Joerg posted a similar patch at https://lkml.org/lkml/2014/12/15/490,
so assume an signed-off from Joerg.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Rientjes <rientjes@google.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Oren Twaig <oren@scalemp.com>
Link: http://lkml.kernel.org/r/1420615903-28253-14-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/irq_remapping.h |  2 --
 arch/x86/kernel/apic/apic.c          |  7 +------
 drivers/iommu/amd_iommu.c            |  1 -
 drivers/iommu/amd_iommu_init.c       |  5 -----
 drivers/iommu/amd_iommu_proto.h      |  1 -
 drivers/iommu/intel_irq_remapping.c  |  6 ------
 drivers/iommu/irq_remapping.c        | 12 ++----------
 drivers/iommu/irq_remapping.h        |  3 ---
 8 files changed, 3 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index f1b619e..6224d31 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -33,7 +33,6 @@ struct irq_cfg;
 
 #ifdef CONFIG_IRQ_REMAP
 
-extern int irq_remapping_supported(void);
 extern void set_irq_remapping_broken(void);
 extern int irq_remapping_prepare(void);
 extern int irq_remapping_enable(void);
@@ -59,7 +58,6 @@ void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 
 #else  /* CONFIG_IRQ_REMAP */
 
-static inline int irq_remapping_supported(void) { return 0; }
 static inline void set_irq_remapping_broken(void) { }
 static inline int irq_remapping_prepare(void) { return -ENODEV; }
 static inline int irq_remapping_enable(void) { return -ENODEV; }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2f16116..35e6d09 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1575,12 +1575,7 @@ void enable_x2apic(void)
 
 static int __init try_to_enable_IR(void)
 {
-#ifdef CONFIG_IRQ_REMAP
-	if (!irq_remapping_supported()) {
-		pr_debug("intr-remapping not supported\n");
-		return -1;
-	}
-
+#ifdef CONFIG_X86_IO_APIC
 	if (!x2apic_enabled() && skip_ioapic_setup) {
 		pr_info("Skipped enabling intr-remap because of skipping "
 			"io-apic setup\n");
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 9802485..59de636 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4284,7 +4284,6 @@ static int alloc_hpet_msi(unsigned int irq, unsigned int id)
 }
 
 struct irq_remap_ops amd_iommu_irq_ops = {
-	.supported		= amd_iommu_supported,
 	.prepare		= amd_iommu_prepare,
 	.enable			= amd_iommu_enable,
 	.disable		= amd_iommu_disable,
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 0039f87..970979e 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2129,11 +2129,6 @@ int __init amd_iommu_prepare(void)
 	return iommu_go_to_state(IOMMU_ACPI_FINISHED);
 }
 
-int __init amd_iommu_supported(void)
-{
-	return amd_iommu_irq_remap ? 1 : 0;
-}
-
 int __init amd_iommu_enable(void)
 {
 	int ret;
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index 95ed6de..861af9d 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -33,7 +33,6 @@ extern void amd_iommu_init_notifier(void);
 extern void amd_iommu_init_api(void);
 
 /* Needed for interrupt remapping */
-extern int amd_iommu_supported(void);
 extern int amd_iommu_prepare(void);
 extern int amd_iommu_enable(void);
 extern void amd_iommu_disable(void);
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 9d67c12..fb72bd5 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -567,11 +567,6 @@ static int __init dmar_x2apic_optout(void)
 	return dmar->flags & DMAR_X2APIC_OPT_OUT;
 }
 
-static int __init intel_irq_remapping_supported(void)
-{
-	return 1;
-}
-
 static void __init intel_cleanup_irq_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -1216,7 +1211,6 @@ static int intel_alloc_hpet_msi(unsigned int irq, unsigned int id)
 }
 
 struct irq_remap_ops intel_irq_remap_ops = {
-	.supported		= intel_irq_remapping_supported,
 	.prepare		= intel_prepare_irq_remapping,
 	.enable			= intel_enable_irq_remapping,
 	.disable		= disable_irq_remapping,
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 91d5884d..e7449b4 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -199,19 +199,11 @@ void set_irq_remapping_broken(void)
 	irq_remap_broken = 1;
 }
 
-int irq_remapping_supported(void)
+int __init irq_remapping_prepare(void)
 {
 	if (disable_irq_remap)
-		return 0;
-
-	if (!remap_ops || !remap_ops->supported)
-		return 0;
+		return -ENOSYS;
 
-	return remap_ops->supported();
-}
-
-int __init irq_remapping_prepare(void)
-{
 	remap_ops = &intel_irq_remap_ops;
 
 #ifdef CONFIG_AMD_IOMMU
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index fde250f..a8edfea 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -38,9 +38,6 @@ extern int no_x2apic_optout;
 extern int irq_remapping_enabled;
 
 struct irq_remap_ops {
-	/* Check whether Interrupt Remapping is supported */
-	int (*supported)(void);
-
 	/* Initializes hardware and makes it ready for remapping interrupts */
 	int  (*prepare)(void);
 
