Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbaGWCdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:33:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:44766 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756720AbaGWCdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:33:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="565811825"
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
Subject: [RFC PATCH v1 23/70] mips, loongson, smp: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:58:59 -0400
Message-Id: <1406080786-3938-24-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from loongson/smp.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 arch/mips/loongson/loongson-3/smp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/mips/loongson/loongson-3/smp.c b/arch/mips/loongson/loongson-3/smp.c
index 1e88940..30b91e8 100644
--- a/arch/mips/loongson/loongson-3/smp.c
+++ b/arch/mips/loongson/loongson-3/smp.c
@@ -389,20 +389,17 @@ void play_dead(void)
 	play_dead_at_ckseg1(state_addr);
 }
 
-#define CPU_POST_DEAD_FROZEN	(CPU_POST_DEAD | CPU_TASKS_FROZEN)
 static int loongson3_cpu_callback(struct notifier_block *nfb,
 	unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_POST_DEAD:
-	case CPU_POST_DEAD_FROZEN:
 		pr_info("Disable clock for CPU#%d\n", cpu);
 		LOONGSON_CHIPCFG0 &= ~(1 << (12 + cpu));
 		break;
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		pr_info("Enable clock for CPU#%d\n", cpu);
 		LOONGSON_CHIPCFG0 |= 1 << (12 + cpu);
 		break;
-- 
2.0.0.rc2

