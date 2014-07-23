Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbaGWCpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:45:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:44421 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078AbaGWCfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:35:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="547516840"
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
Subject: [RFC PATCH v1 38/70] mm, memcontrol: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:14 -0400
Message-Id: <1406080786-3938-39-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from mm/memcontrol.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2c7bcb..871667d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2540,7 +2540,7 @@ static int memcg_cpu_hotplug_callback(struct notifier_block *nb,
 	if (action == CPU_ONLINE)
 		return NOTIFY_OK;
 
-	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
+	if ((action & ~CPU_TASKS_FROZEN) != CPU_DEAD)
 		return NOTIFY_OK;
 
 	for_each_mem_cgroup(iter)
-- 
2.0.0.rc2

