Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaCXOlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:41:44 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56399 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaCXOlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:41:42 -0400
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: [PATCH] intel_pstate:  Use del_timer_sync in intel_pstate_cpu_stop
Date: Mon, 24 Mar 2014 07:41:29 -0700
Message-Id: <1395672089-19336-1-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Ensure that no timer callback is running since we are about to free
the timer structure.  We cannot guarantee that the call back is called
on the CPU where the timer is running.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: cpufreq <cpufreq@vger.kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index e9092fd..a4a9ba5 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -780,7 +780,7 @@ static int intel_pstate_cpu_stop(struct cpufreq_policy *policy)
 
 	pr_info("intel_pstate CPU %d exiting\n", cpu_num);
 
-	del_timer(&all_cpu_data[cpu_num]->timer);
+	del_timer_sync(&all_cpu_data[cpu_num]->timer);
 	intel_pstate_set_pstate(cpu, cpu->pstate.min_pstate);
 	kfree(all_cpu_data[cpu_num]);
 	all_cpu_data[cpu_num] = NULL;
-- 
1.8.3.1

