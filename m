Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbaKZXVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:21:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59164 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaKZXVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:21:43 -0500
Date: Wed, 26 Nov 2014 15:18:51 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-a266cd087cb237c796927ad4399ad29a9250f94a@git.kernel.org>
Cc: bp@alien8.de, jiang.liu@linux.intel.com, konrad.wilk@oracle.com,
        benh@kernel.crashing.org, gregkh@linuxfoundation.org,
        rjw@rjwysocki.net, joro@8bytes.org, bhelgaas@google.com,
        yinghai@kernel.org, jroedel@suse.de, tony.luck@intel.com,
        mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, rdunlap@infradead.org
Reply-To: bhelgaas@google.com, joro@8bytes.org, gregkh@linuxfoundation.org,
        rjw@rjwysocki.net, konrad.wilk@oracle.com, benh@kernel.crashing.org,
        jiang.liu@linux.intel.com, bp@alien8.de, rdunlap@infradead.org,
        mingo@kernel.org, tglx@linutronix.de, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jroedel@suse.de,
        yinghai@kernel.org
In-Reply-To: <1416901802-24211-25-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-25-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/amd: Move struct irq_2_irte into amd_iommu.c
Git-Commit-ID: a266cd087cb237c796927ad4399ad29a9250f94a
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

Commit-ID:  a266cd087cb237c796927ad4399ad29a9250f94a
Gitweb:     http://git.kernel.org/tip/a266cd087cb237c796927ad4399ad29a9250f94a
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:48 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:48 +0100

iommu/amd: Move struct irq_2_irte into amd_iommu.c

Now only amd_iommu.c access irq_2_irte, so move it from hw_irq.h into
amd_iommu.c.

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
Link: http://lkml.kernel.org/r/1416901802-24211-25-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/hw_irq.h | 13 -------------
 drivers/iommu/amd_iommu.c     |  5 +++++
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 3520f71..494d541 100644
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
@@ -184,11 +176,6 @@ struct irq_cfg {
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
index cc4ac40..2e8bbe5 100644
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
