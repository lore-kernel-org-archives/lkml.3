Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbaIZO5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:57:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:58972 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbaIZO5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:57:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597292711"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC v1 25/28] x86, irq: Change functions only used in vector.c as static
Date: Fri, 26 Sep 2014 22:57:55 +0800
Message-Id: <1411743478-31435-26-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
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
index 9f8436fb3770..fdf8300dcc29 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -180,13 +180,10 @@ extern struct irq_cfg *irq_cfg(unsigned int irq);
 extern struct irq_cfg *irqd_cfg(struct irq_data *irq_data);
 extern void lock_vector_lock(void);
 extern void unlock_vector_lock(void);
-extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
-extern void clear_irq_vector(int irq, struct irq_cfg *cfg);
 extern void setup_vector_irq(int cpu);
 extern void send_cleanup_vector(struct irq_cfg *);
 extern void irq_complete_move(struct irq_cfg *cfg);
 
-extern int apic_retrigger_irq(struct irq_data *data);
 extern void apic_ack_edge(struct irq_data *data);
 extern int apic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			     unsigned int *dest_id);
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index f21820622edf..ec2b991884f2 100644
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
@@ -435,7 +436,7 @@ void setup_vector_irq(int cpu)
 	__setup_vector_irq(cpu);
 }
 
-int apic_retrigger_irq(struct irq_data *data)
+static int apic_retrigger_irq(struct irq_data *data)
 {
 	struct irq_cfg *cfg = irqd_cfg(data);
 	unsigned long flags;
-- 
1.7.10.4

