Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbaGWCfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:35:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:54758 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960AbaGWCfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:35:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="573975817"
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
Subject: [RFC PATCH v1 39/70] mm, page_alloc: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:15 -0400
Message-Id: <1406080786-3938-40-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from mm/page_alloc.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0ea758b..c52c2a8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5537,7 +5537,7 @@ static int page_alloc_cpu_notify(struct notifier_block *self,
 {
 	int cpu = (unsigned long)hcpu;
 
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+	if ((action & ~CPU_TASKS_FROZEN) == CPU_DEAD) {
 		lru_add_drain_cpu(cpu);
 		drain_pages(cpu);
 
-- 
2.0.0.rc2

