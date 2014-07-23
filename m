Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbaGWCjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:39:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:16010 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbaGWCji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:39:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="547518345"
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
Subject: [RFC PATCH v1 68/70] lib, radix-tree: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:44 -0400
Message-Id: <1406080786-3938-69-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from lib/radix-tree.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 lib/radix-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 3291a8e..5f7231c 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1465,7 +1465,7 @@ static int radix_tree_callback(struct notifier_block *nfb,
        struct radix_tree_preload *rtp;
 
        /* Free per-cpu pool of perloaded nodes */
-       if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+       if ((action & ~CPU_TASKS_FROZEN) == CPU_DEAD) {
                rtp = &per_cpu(radix_tree_preloads, cpu);
                while (rtp->nr) {
                        kmem_cache_free(radix_tree_node_cachep,
-- 
2.0.0.rc2

