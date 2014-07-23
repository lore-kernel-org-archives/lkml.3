Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbaGWCgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:36:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:54848 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623AbaGWCgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:36:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="573976070"
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
Subject: [RFC PATCH v1 43/70] net, iucv: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:19 -0400
Message-Id: <1406080786-3938-44-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from net/iucv.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 net/iucv/iucv.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index da78793..4a44595 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -663,28 +663,22 @@ static int iucv_cpu_notify(struct notifier_block *self,
 	cpumask_t cpumask;
 	long cpu = (long) hcpu;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		if (alloc_iucv_data(cpu))
 			return notifier_from_errno(-ENOMEM);
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		free_iucv_data(cpu);
 		break;
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 		if (!iucv_path_table)
 			break;
 		smp_call_function_single(cpu, iucv_declare_cpu, NULL, 1);
 		break;
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		if (!iucv_path_table)
 			break;
 		cpumask_copy(&cpumask, &iucv_buffer_cpumask);
-- 
2.0.0.rc2

