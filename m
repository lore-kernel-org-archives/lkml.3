Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbaGWCdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:33:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:48643 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237AbaGWCdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:33:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="573974300"
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
Subject: [RFC PATCH v1 14/70] x86, microcode, core: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:58:50 -0400
Message-Id: <1406080786-3938-15-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from x86/microcode/core.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 arch/x86/kernel/cpu/microcode/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index dd9d619..27e47be 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -499,6 +499,10 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 		pr_debug("CPU%d removed\n", cpu);
 		break;
 
+	case CPU_UP_CANCELED:
+		/* The CPU refused to come up during a system resume */
+		if (action & CPU_TASKS_FROZEN)
+			microcode_fini_cpu(cpu);
 	/*
 	 * case CPU_DEAD:
 	 *
@@ -509,10 +513,6 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	 */
 	}
 
-	/* The CPU refused to come up during a system resume */
-	if (action == CPU_UP_CANCELED_FROZEN)
-		microcode_fini_cpu(cpu);
-
 	return NOTIFY_OK;
 }
 
-- 
2.0.0.rc2

