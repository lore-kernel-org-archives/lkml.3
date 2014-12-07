Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaLGWJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:09:23 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52012 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaLGWJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:09:21 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Anton Blanchard <anton@samba.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] arch: powerpc: kernel: smp.c:  Remove unused function
Date: Sun,  7 Dec 2014 23:11:59 +0100
Message-Id: <1417990319-19019-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function generic_mach_cpu_die() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/include/asm/smp.h |    1 -
 arch/powerpc/kernel/smp.c      |   14 --------------
 2 files changed, 15 deletions(-)

diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
index 5a6614a..d607df5 100644
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -64,7 +64,6 @@ DECLARE_PER_CPU(unsigned int, cpu_pvr);
 extern void migrate_irqs(void);
 int generic_cpu_disable(void);
 void generic_cpu_die(unsigned int cpu);
-void generic_mach_cpu_die(void);
 void generic_set_cpu_dead(unsigned int cpu);
 void generic_set_cpu_up(unsigned int cpu);
 int generic_check_cpu_restart(unsigned int cpu);
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 71e186d..83d4f3f 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -434,20 +434,6 @@ void generic_cpu_die(unsigned int cpu)
 	printk(KERN_ERR "CPU%d didn't die...\n", cpu);
 }
 
-void generic_mach_cpu_die(void)
-{
-	unsigned int cpu;
-
-	local_irq_disable();
-	idle_task_exit();
-	cpu = smp_processor_id();
-	printk(KERN_DEBUG "CPU%d offline\n", cpu);
-	__get_cpu_var(cpu_state) = CPU_DEAD;
-	smp_wmb();
-	while (__get_cpu_var(cpu_state) != CPU_UP_PREPARE)
-		cpu_relax();
-}
-
 void generic_set_cpu_dead(unsigned int cpu)
 {
 	per_cpu(cpu_state, cpu) = CPU_DEAD;
-- 
1.7.10.4

