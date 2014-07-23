Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbaGWCb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:31:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:10401 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844AbaGWCbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:31:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="565811228"
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
Subject: [RFC PATCH v1 05/70] ia64, salinfo: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:58:41 -0400
Message-Id: <1406080786-3938-6-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from ia64/salinfo.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 arch/ia64/kernel/salinfo.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
index ee9719e..c454375 100644
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -574,9 +574,8 @@ salinfo_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu
 	unsigned int i, cpu = (unsigned long)hcpu;
 	unsigned long flags;
 	struct salinfo_data *data;
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		spin_lock_irqsave(&data_saved_lock, flags);
 		for (i = 0, data = salinfo_data;
 		     i < ARRAY_SIZE(salinfo_data);
@@ -587,7 +586,6 @@ salinfo_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu
 		spin_unlock_irqrestore(&data_saved_lock, flags);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		spin_lock_irqsave(&data_saved_lock, flags);
 		for (i = 0, data = salinfo_data;
 		     i < ARRAY_SIZE(salinfo_data);
-- 
2.0.0.rc2

