Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935336AbaH0RRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:17:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:31666 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934932AbaH0RRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:17:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="377743198"
From: Andi Kleen <andi@firstfloor.org>
To: rafael.j.wysocki@intel.com
Cc: dirk.j.brandewie@intel.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] intel_pstate: Turn per cpu printk into pr_debug
Date: Wed, 27 Aug 2014 10:17:08 -0700
Message-Id: <1409159828-16168-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On larger systems intel_pstate currently spams the boot up
log with its "Intel pstate controlling ..." message for each CPU.
It's the only subsystem that prints a message for each
CPU.

Turn the message into a pr_debug.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/cpufreq/intel_pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index c5eac94..17be734 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -688,7 +688,7 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
 
 	add_timer_on(&cpu->timer, cpunum);
 
-	pr_info("Intel pstate controlling: cpu %d\n", cpunum);
+	pr_debug("Intel pstate controlling: cpu %d\n", cpunum);
 
 	return 0;
 }
-- 
1.9.3

