Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974Ab3IGGrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 02:47:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49710 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750831Ab3IGGrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 02:47:21 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] x86/xen: remove deprecated IRQF_DISABLED
Date: Sat,  7 Sep 2013 08:46:49 +0200
Message-Id: <1378536409-7023-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from x86/xen
code. It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/x86/xen/smp.c      | 10 +++++-----
 arch/x86/xen/spinlock.c |  2 +-
 arch/x86/xen/time.c     |  3 +--
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 9235842..71177a9 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -149,7 +149,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	rc = bind_ipi_to_irqhandler(XEN_RESCHEDULE_VECTOR,
 				    cpu,
 				    xen_reschedule_interrupt,
-				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    IRQF_PERCPU|IRQF_NOBALANCING,
 				    resched_name,
 				    NULL);
 	if (rc < 0)
@@ -161,7 +161,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_VECTOR,
 				    cpu,
 				    xen_call_function_interrupt,
-				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    IRQF_PERCPU|IRQF_NOBALANCING,
 				    callfunc_name,
 				    NULL);
 	if (rc < 0)
@@ -171,7 +171,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 
 	debug_name = kasprintf(GFP_KERNEL, "debug%d", cpu);
 	rc = bind_virq_to_irqhandler(VIRQ_DEBUG, cpu, xen_debug_interrupt,
-				     IRQF_DISABLED | IRQF_PERCPU | IRQF_NOBALANCING,
+				     IRQF_PERCPU | IRQF_NOBALANCING,
 				     debug_name, NULL);
 	if (rc < 0)
 		goto fail;
@@ -182,7 +182,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
 				    cpu,
 				    xen_call_function_single_interrupt,
-				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    IRQF_PERCPU|IRQF_NOBALANCING,
 				    callfunc_name,
 				    NULL);
 	if (rc < 0)
@@ -201,7 +201,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 	rc = bind_ipi_to_irqhandler(XEN_IRQ_WORK_VECTOR,
 				    cpu,
 				    xen_irq_work_interrupt,
-				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    IRQF_PERCPU|IRQF_NOBALANCING,
 				    callfunc_name,
 				    NULL);
 	if (rc < 0)
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 0438b93..d1a3064 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -255,7 +255,7 @@ void xen_init_lock_cpu(int cpu)
 	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
 				     cpu,
 				     dummy_handler,
-				     IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				     IRQF_PERCPU|IRQF_NOBALANCING,
 				     name,
 				     NULL);
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index ee36589..12a1ca7 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -443,8 +443,7 @@ void xen_setup_timer(int cpu)
 		name = "<timer kasprintf failed>";
 
 	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
-				      IRQF_DISABLED|IRQF_PERCPU|
-				      IRQF_NOBALANCING|IRQF_TIMER|
+				      IRQF_PERCPU|IRQF_NOBALANCING|IRQF_TIMER|
 				      IRQF_FORCE_RESUME,
 				      name, NULL);
 
-- 
1.8.1.2

