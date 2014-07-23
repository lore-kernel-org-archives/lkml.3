Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbaGWCez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:34:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:34330 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbaGWCew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:34:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="565812109"
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
Subject: [RFC PATCH v1 30/70] kernel, hrtimer: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:06 -0400
Message-Id: <1406080786-3938-31-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from kernel/hrtimer.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 kernel/hrtimer.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3ab2899..a37958e 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1756,27 +1756,19 @@ static int hrtimer_cpu_notify(struct notifier_block *self,
 {
 	int scpu = (long)hcpu;
 
-	switch (action) {
-
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		init_hrtimers_cpu(scpu);
 		break;
-
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DYING:
-	case CPU_DYING_FROZEN:
 		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DYING, &scpu);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-	{
 		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
 		migrate_hrtimers(scpu);
 		break;
-	}
 #endif
-
 	default:
 		break;
 	}
-- 
2.0.0.rc2

