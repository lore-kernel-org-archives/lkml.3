Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaKZXVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:21:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59172 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaKZXVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:21:49 -0500
Date: Wed, 26 Nov 2014 15:20:55 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-cd42f95eaeaab2cdbada4731279701f6fd80e195@git.kernel.org>
Cc: jroedel@suse.de, tony.luck@intel.com, gregkh@linuxfoundation.org,
        hpa@zytor.com, konrad.wilk@oracle.com, jiang.liu@linux.intel.com,
        mingo@kernel.org, rdunlap@infradead.org, bhelgaas@google.com,
        joro@8bytes.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, rjw@rjwysocki.net,
        tglx@linutronix.de, bp@alien8.de
Reply-To: mingo@kernel.org, jiang.liu@linux.intel.com, konrad.wilk@oracle.com,
        hpa@zytor.com, gregkh@linuxfoundation.org, tony.luck@intel.com,
        jroedel@suse.de, bp@alien8.de, rjw@rjwysocki.net, tglx@linutronix.de,
        yinghai@kernel.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, joro@8bytes.org, bhelgaas@google.com,
        rdunlap@infradead.org
In-Reply-To: <1416901802-24211-32-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-32-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Change functions only used in vector.c as static
Git-Commit-ID: cd42f95eaeaab2cdbada4731279701f6fd80e195
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

Commit-ID:  cd42f95eaeaab2cdbada4731279701f6fd80e195
Gitweb:     http://git.kernel.org/tip/cd42f95eaeaab2cdbada4731279701f6fd80e195
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:55 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:49 +0100

x86, irq: Change functions only used in vector.c as static

Function {assign|clear}_irq_vector() and apic_retrigger_irq() are only
used in file vector.c, so change them as static.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1416901802-24211-32-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/hw_irq.h | 3 ---
 arch/x86/kernel/apic/vector.c | 7 ++++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index a88f5b3..ea9aebc 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -188,8 +188,6 @@ extern struct irq_cfg *irq_cfg(unsigned int irq);
 extern struct irq_cfg *irqd_cfg(struct irq_data *irq_data);
 extern void lock_vector_lock(void);
 extern void unlock_vector_lock(void);
-extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
-extern void clear_irq_vector(int irq, struct irq_cfg *cfg);
 extern void setup_vector_irq(int cpu);
 #ifdef CONFIG_SMP
 extern void send_cleanup_vector(struct irq_cfg *);
@@ -199,7 +197,6 @@ static inline void send_cleanup_vector(struct irq_cfg *c) { }
 static inline void irq_complete_move(struct irq_cfg *c) { }
 #endif
 
-extern int apic_retrigger_irq(struct irq_data *data);
 extern void apic_ack_edge(struct irq_data *data);
 extern int apic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			     unsigned int *dest_id);
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 8467ca4..fba4958 100644
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
