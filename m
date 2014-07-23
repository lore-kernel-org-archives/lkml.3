Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbaGWCfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:35:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:54690 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbaGWCfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:35:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="565812270"
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
Subject: [RFC PATCH v1 35/70] mm, slab: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:11 -0400
Message-Id: <1406080786-3938-36-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from mm/slab.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 mm/slab.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 3070b92..5490528 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1325,20 +1325,17 @@ static int cpuup_callback(struct notifier_block *nfb,
 	long cpu = (long)hcpu;
 	int err = 0;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&slab_mutex);
 		err = cpuup_prepare(cpu);
 		mutex_unlock(&slab_mutex);
 		break;
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		start_cpu_timer(cpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
   	case CPU_DOWN_PREPARE:
-  	case CPU_DOWN_PREPARE_FROZEN:
 		/*
 		 * Shutdown cache reaper. Note that the slab_mutex is
 		 * held so that if cache_reap() is invoked it cannot do
@@ -1350,11 +1347,9 @@ static int cpuup_callback(struct notifier_block *nfb,
 		per_cpu(slab_reap_work, cpu).work.func = NULL;
   		break;
   	case CPU_DOWN_FAILED:
-  	case CPU_DOWN_FAILED_FROZEN:
 		start_cpu_timer(cpu);
   		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		/*
 		 * Even if all the cpus of a node are down, we don't free the
 		 * kmem_cache_node of any cache. This to avoid a race between
@@ -1366,7 +1361,6 @@ static int cpuup_callback(struct notifier_block *nfb,
 		/* fall through */
 #endif
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 		mutex_lock(&slab_mutex);
 		cpuup_canceled(cpu);
 		mutex_unlock(&slab_mutex);
-- 
2.0.0.rc2

