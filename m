Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbaGWCln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:41:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:20984 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402AbaGWCim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:38:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="565812972"
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
Subject: [RFC PATCH v1 61/70] md, raid5: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:37 -0400
Message-Id: <1406080786-3938-62-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from md/raid5.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/md/raid5.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6234b2e..3d76235 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5665,9 +5665,8 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 	long cpu = (long)hcpu;
 	struct raid5_percpu *percpu = per_cpu_ptr(conf->percpu, cpu);
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		if (alloc_scratch_buffer(conf, percpu)) {
 			pr_err("%s: failed memory allocation for cpu%ld\n",
 			       __func__, cpu);
@@ -5675,7 +5674,6 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 		}
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		free_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
 		break;
 	default:
-- 
2.0.0.rc2

