Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbaGWCeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:34:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:44238 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbaGWCe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:34:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="547516402"
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
Subject: [RFC PATCH v1 28/70] kernel, profile: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:04 -0400
Message-Id: <1406080786-3938-29-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from kernel/profile.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 kernel/profile.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 54bf5ba..22bca4b 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -333,9 +333,8 @@ static int profile_cpu_callback(struct notifier_block *info,
 	int node, cpu = (unsigned long)__cpu;
 	struct page *page;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		node = cpu_to_mem(cpu);
 		per_cpu(cpu_profile_flip, cpu) = 0;
 		if (!per_cpu(cpu_profile_hits, cpu)[1]) {
@@ -361,14 +360,11 @@ out_free:
 		__free_page(page);
 		return notifier_from_errno(-ENOMEM);
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		if (prof_cpu_mask != NULL)
 			cpumask_set_cpu(cpu, prof_cpu_mask);
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		if (prof_cpu_mask != NULL)
 			cpumask_clear_cpu(cpu, prof_cpu_mask);
 		if (per_cpu(cpu_profile_hits, cpu)[0]) {
-- 
2.0.0.rc2

