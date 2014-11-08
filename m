Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaKHSRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:17:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:57864 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbaKHSRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:17:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413534257"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part3 v3 31/38] x86, irq: Change functions only used in vector.c as static
Date: Sun,  9 Nov 2014 02:13:31 +0800
Message-Id: <1415470418-10874-32-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function {assign|clear}_irq_vector() and apic_retrigger_irq() are only
used in file vector.c, so change them as static.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h |    3 ---
 arch/x86/kernel/apic/vector.c |    7 ++++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 00d6143affe7..dee2069d7c19 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -186,8 +186,6 @@ extern struct irq_cfg *irq_cfg(unsigned int irq);
 extern struct irq_cfg *irqd_cfg(struct irq_data *irq_data);
 extern void lock_vector_lock(void);
 extern void unlock_vector_lock(void);
-extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
-extern void clear_irq_vector(int irq, struct irq_cfg *cfg);
 extern void setup_vector_irq(int cpu);
 #ifdef CONFIG_SMP
 extern void send_cleanup_vector(struct irq_cfg *);
@@ -197,7 +195,6 @@ static inline void send_cleanup_vector(struct irq_cfg *c) { }
 static inline void irq_complete_move(struct irq_cfg *c) { }
 #endif
 
-extern int apic_retrigger_irq(struct irq_data *data);
 extern void apic_ack_edge(struct irq_data *data);
 extern int apic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			     unsigned int *dest_id);
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 6df30d713f67..4fa940aa24c1 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -185,7 +185,8 @@ next:
 	return err;
 }
 
-int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
+static int assign_irq_vector(int irq, struct irq_cfg *cfg,
+			     const struct cpumask *mask)
 {
 	int err;
 	unsigned long flags;
@@ -196,7 +197,7 @@ int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	return err;
 }
 
-void clear_irq_vector(int irq, struct irq_cfg *cfg)
+static void clear_irq_vector(int irq, struct irq_cfg *cfg)
 {
 	int cpu, vector;
 	unsigned long flags;
@@ -441,7 +442,7 @@ void setup_vector_irq(int cpu)
 	__setup_vector_irq(cpu);
 }
 
-int apic_retrigger_irq(struct irq_data *data)
+static int apic_retrigger_irq(struct irq_data *data)
 {
 	struct irq_cfg *cfg = irqd_cfg(data);
 	unsigned long flags;
-- 
1.7.10.4

