Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbaGWClT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:41:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:55272 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757464AbaGWCjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:39:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="573976921"
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
Subject: [RFC PATCH v1 65/70] oprofile, timer_int: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:41 -0400
Message-Id: <1406080786-3938-66-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from oprofile/timer_int.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/oprofile/timer_int.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index 61be1d9..ab5a0a9 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -79,14 +79,12 @@ static int oprofile_cpu_notify(struct notifier_block *self,
 {
 	long cpu = (long) hcpu;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		smp_call_function_single(cpu, __oprofile_hrtimer_start,
 					 NULL, 1);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		__oprofile_hrtimer_stop(cpu);
 		break;
 	}
-- 
2.0.0.rc2

