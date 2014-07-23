Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbaGWCfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:35:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:34394 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966AbaGWCfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:35:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="573975346"
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
Subject: [RFC PATCH v1 34/70] kernel, softirq: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:10 -0400
Message-Id: <1406080786-3938-35-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from kernel/softirq.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 kernel/softirq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 5918d22..c4d4484 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -726,10 +726,9 @@ static void takeover_tasklets(unsigned int cpu)
 static int cpu_callback(struct notifier_block *nfb, unsigned long action,
 			void *hcpu)
 {
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		takeover_tasklets((unsigned long)hcpu);
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
-- 
2.0.0.rc2

