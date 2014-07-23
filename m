Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbaGWCgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:36:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:45168 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623AbaGWCg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:36:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="565812542"
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
Subject: [RFC PATCH v1 44/70] net, core, flow: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:20 -0400
Message-Id: <1406080786-3938-45-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from net/core/flow.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 net/core/flow.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/core/flow.c b/net/core/flow.c
index a0348fd..3bb5dc0 100644
--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -417,15 +417,13 @@ static int flow_cache_cpu(struct notifier_block *nfb,
 	int res, cpu = (unsigned long) hcpu;
 	struct flow_cache_percpu *fcp = per_cpu_ptr(fc->percpu, cpu);
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		res = flow_cache_cpu_prepare(fc, cpu);
 		if (res)
 			return notifier_from_errno(res);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		__flow_cache_shrink(fc, fcp, 0);
 		break;
 	}
-- 
2.0.0.rc2

