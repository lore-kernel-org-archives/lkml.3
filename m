Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbaGWChE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:37:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:34662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332AbaGWChA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:37:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="573976309"
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
Subject: [RFC PATCH v1 48/70] block, blk-softirq: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:24 -0400
Message-Id: <1406080786-3938-49-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from block/blk-softirq.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 block/blk-softirq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 53b1737..3ab9c2e 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -85,7 +85,7 @@ static int blk_cpu_notify(struct notifier_block *self, unsigned long action,
 	 * If a CPU goes away, splice its entries to the current CPU
 	 * and trigger a run of the softirq
 	 */
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+	if ((action & ~CPU_TASKS_FROZEN) == CPU_DEAD) {
 		int cpu = (unsigned long) hcpu;
 
 		local_irq_disable();
-- 
2.0.0.rc2

