Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbaGWCfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:35:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:34424 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756950AbaGWCfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:35:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="547516594"
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
Subject: [RFC PATCH v1 33/70] kernel, timer: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:09 -0400
Message-Id: <1406080786-3938-34-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from kernel/timer.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 kernel/timer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 3bb01a3..cc11324 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1642,16 +1642,14 @@ static int timer_cpu_notify(struct notifier_block *self,
 	long cpu = (long)hcpu;
 	int err;
 
-	switch(action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		err = init_timers_cpu(cpu);
 		if (err < 0)
 			return notifier_from_errno(err);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		migrate_timers(cpu);
 		break;
 #endif
-- 
2.0.0.rc2

