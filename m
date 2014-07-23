Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbaGWCdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:33:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:30838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbaGWCdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:33:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577335244"
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
Subject: [RFC PATCH v1 20/70] powerpc, mm, numa: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:58:56 -0400
Message-Id: <1406080786-3938-21-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from powerpc/mm/numa.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 arch/powerpc/mm/numa.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 3b181b2..080ef52 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -598,18 +598,15 @@ static int cpu_numa_callback(struct notifier_block *nfb, unsigned long action,
 	unsigned long lcpu = (unsigned long)hcpu;
 	int ret = NOTIFY_DONE, nid;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		nid = numa_setup_cpu(lcpu);
 		verify_cpu_node_mapping((int)lcpu, nid);
 		ret = NOTIFY_OK;
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 		unmap_cpu_from_node(lcpu);
 		break;
 		ret = NOTIFY_OK;
-- 
2.0.0.rc2

