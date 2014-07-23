Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbaGWCcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:32:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:10519 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451AbaGWCcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:32:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="363778008"
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
Subject: [RFC PATCH v1 11/70] x86, vsyscall_64: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:58:47 -0400
Message-Id: <1406080786-3938-12-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from x86/vsyscall_64.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 arch/x86/kernel/vsyscall_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index ea5b570..72a1576 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -320,7 +320,7 @@ cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 {
 	long cpu = (long)arg;
 
-	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
+	if ((action & ~CPU_TASKS_FROZEN) == CPU_ONLINE)
 		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 1);
 
 	return NOTIFY_DONE;
-- 
2.0.0.rc2

