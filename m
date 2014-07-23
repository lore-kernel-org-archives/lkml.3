Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbaGWCe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:34:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:34380 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbaGWCew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:34:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577335691"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RFC PATCH v1 32/70] kernel, smp: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:08 -0400
Message-Id: <1406080786-3938-33-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from kernel/smp.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 kernel/smp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 80c33f8..808ec06 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -37,9 +37,8 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	long cpu = (long)hcpu;
 	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
@@ -52,17 +51,12 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		/* Fall-through to the CPU_DEAD[_FROZEN] case. */
-
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		free_cpumask_var(cfd->cpumask);
 		free_percpu(cfd->csd);
 		break;
 
 	case CPU_DYING:
-	case CPU_DYING_FROZEN:
 		/*
 		 * The IPIs for the smp-call-function callbacks queued by other
 		 * CPUs might arrive late, either due to hardware latencies or
-- 
2.0.0.rc2

