Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbaKERPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:15:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41843 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbaKERPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:15:40 -0500
Date: Wed, 5 Nov 2014 09:14:06 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-49e5780b2dd303bc86014934b13842c1a4675d01@git.kernel.org>
Cc: rjw@rjwysocki.net, yinghai@kernel.org, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, prarit@redhat.com, bhelgaas@google.com,
        bp@alien8.de, tony.luck@intel.com, tglx@linutronix.de,
        mingo@kernel.org, jiang.liu@linux.intel.com, hpa@zytor.com,
        rdunlap@infradead.org, joro@8bytes.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com
Reply-To: rdunlap@infradead.org, joro@8bytes.org, konrad.wilk@oracle.com,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        tony.luck@intel.com, tglx@linutronix.de, mingo@kernel.org,
        jiang.liu@linux.intel.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, prarit@redhat.com, bhelgaas@google.com,
        rjw@rjwysocki.net, yinghai@kernel.org
In-Reply-To: <1414397531-28254-7-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-7-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Rename local APIC related functions in io_apic.c as apic_xxx()
Git-Commit-ID: 49e5780b2dd303bc86014934b13842c1a4675d01
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

Commit-ID:  49e5780b2dd303bc86014934b13842c1a4675d01
Gitweb:     http://git.kernel.org/tip/49e5780b2dd303bc86014934b13842c1a4675d01
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:11:57 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 5 Nov 2014 18:10:46 +0100

x86, irq: Rename local APIC related functions in io_apic.c as apic_xxx()

Rename local APIC related functions in io_apic.c as apic_xxx() instead
of ioapic_xxx(), later they will be moved into separate file.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1414397531-28254-7-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hw_irq.h  |  4 ++--
 arch/x86/kernel/apic/io_apic.c | 42 +++++++++++++++++++++---------------------
 arch/x86/platform/uv/uv_irq.c  |  2 +-
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 9e2d08b..e1acbba 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -141,8 +141,8 @@ static inline void send_cleanup_vector(struct irq_cfg *c) { }
 #endif
 
 struct irq_data;
-int __ioapic_set_affinity(struct irq_data *, const struct cpumask *,
-			  unsigned int *dest_id);
+int apic_set_affinity(struct irq_data *, const struct cpumask *,
+		      unsigned int *dest_id);
 #endif	/* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fac6be1..f629c43 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2252,7 +2252,7 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
 	return was_pending;
 }
 
-static int ioapic_retrigger_irq(struct irq_data *data)
+static int apic_retrigger_irq(struct irq_data *data)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	unsigned long flags;
@@ -2407,8 +2407,8 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
  * ->cpu_mask_to_apicid of that in dest_id, or returns -1 and
  * leaves data->affinity untouched.
  */
-int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-			  unsigned int *dest_id)
+int apic_set_affinity(struct irq_data *data, const struct cpumask *mask,
+		      unsigned int *dest_id)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	unsigned int irq = data->irq;
@@ -2449,7 +2449,7 @@ int native_ioapic_set_affinity(struct irq_data *data,
 		return -EPERM;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	ret = __ioapic_set_affinity(data, mask, &dest);
+	ret = apic_set_affinity(data, mask, &dest);
 	if (!ret) {
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
@@ -2460,7 +2460,7 @@ int native_ioapic_set_affinity(struct irq_data *data,
 	return ret;
 }
 
-static void ack_apic_edge(struct irq_data *data)
+static void apic_ack_edge(struct irq_data *data)
 {
 	irq_complete_move(data->chip_data);
 	irq_move_irq(data);
@@ -2549,7 +2549,7 @@ static inline void ioapic_irqd_unmask(struct irq_data *data,
 }
 #endif
 
-static void ack_apic_level(struct irq_data *data)
+static void ack_ioapic_level(struct irq_data *data)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	int i, irq = data->irq;
@@ -2621,10 +2621,10 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_startup		= startup_ioapic_irq,
 	.irq_mask		= mask_ioapic_irq,
 	.irq_unmask		= unmask_ioapic_irq,
-	.irq_ack		= ack_apic_edge,
-	.irq_eoi		= ack_apic_level,
+	.irq_ack		= apic_ack_edge,
+	.irq_eoi		= ack_ioapic_level,
 	.irq_set_affinity	= native_ioapic_set_affinity,
-	.irq_retrigger		= ioapic_retrigger_irq,
+	.irq_retrigger		= apic_retrigger_irq,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -3159,7 +3159,7 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 	unsigned int dest;
 	int ret;
 
-	ret = __ioapic_set_affinity(data, mask, &dest);
+	ret = apic_set_affinity(data, mask, &dest);
 	if (ret)
 		return ret;
 
@@ -3183,9 +3183,9 @@ static struct irq_chip msi_chip = {
 	.name			= "PCI-MSI",
 	.irq_unmask		= unmask_msi_irq,
 	.irq_mask		= mask_msi_irq,
-	.irq_ack		= ack_apic_edge,
+	.irq_ack		= apic_ack_edge,
 	.irq_set_affinity	= msi_set_affinity,
-	.irq_retrigger		= ioapic_retrigger_irq,
+	.irq_retrigger		= apic_retrigger_irq,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -3261,7 +3261,7 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	struct msi_msg msg;
 	int ret;
 
-	ret = __ioapic_set_affinity(data, mask, &dest);
+	ret = apic_set_affinity(data, mask, &dest);
 	if (ret)
 		return ret;
 
@@ -3282,9 +3282,9 @@ static struct irq_chip dmar_msi_type = {
 	.name			= "DMAR_MSI",
 	.irq_unmask		= dmar_msi_unmask,
 	.irq_mask		= dmar_msi_mask,
-	.irq_ack		= ack_apic_edge,
+	.irq_ack		= apic_ack_edge,
 	.irq_set_affinity	= dmar_msi_set_affinity,
-	.irq_retrigger		= ioapic_retrigger_irq,
+	.irq_retrigger		= apic_retrigger_irq,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -3313,7 +3313,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 	unsigned int dest;
 	int ret;
 
-	ret = __ioapic_set_affinity(data, mask, &dest);
+	ret = apic_set_affinity(data, mask, &dest);
 	if (ret)
 		return ret;
 
@@ -3333,9 +3333,9 @@ static struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
 	.irq_unmask = hpet_msi_unmask,
 	.irq_mask = hpet_msi_mask,
-	.irq_ack = ack_apic_edge,
+	.irq_ack = apic_ack_edge,
 	.irq_set_affinity = hpet_msi_set_affinity,
-	.irq_retrigger = ioapic_retrigger_irq,
+	.irq_retrigger = apic_retrigger_irq,
 	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -3385,7 +3385,7 @@ ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 	unsigned int dest;
 	int ret;
 
-	ret = __ioapic_set_affinity(data, mask, &dest);
+	ret = apic_set_affinity(data, mask, &dest);
 	if (ret)
 		return ret;
 
@@ -3397,9 +3397,9 @@ static struct irq_chip ht_irq_chip = {
 	.name			= "PCI-HT",
 	.irq_mask		= mask_ht_irq,
 	.irq_unmask		= unmask_ht_irq,
-	.irq_ack		= ack_apic_edge,
+	.irq_ack		= apic_ack_edge,
 	.irq_set_affinity	= ht_set_affinity,
-	.irq_retrigger		= ioapic_retrigger_irq,
+	.irq_retrigger		= apic_retrigger_irq,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index b233681..3e8fab7 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -204,7 +204,7 @@ uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
 	struct uv_IO_APIC_route_entry *entry;
 	int mmr_pnode;
 
-	if (__ioapic_set_affinity(data, mask, &dest))
+	if (apic_set_affinity(data, mask, &dest))
 		return -1;
 
 	mmr_value = 0;
