Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaHOHTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 03:19:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:36866 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbaHOHTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 03:19:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,868,1400050800"; 
   d="scan'208";a="469012716"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: peterz@infradead.org, luto@amacapital.net, daniel.lezcano@linaro.org,
        rjw@rjwysocki.net, mingo@redhat.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        changcheng.liu@intel.com, xiaoming.wang@intel.com,
        souvik.k.chakravarty@intel.com,
        Chuansheng Liu <chuansheng.liu@intel.com>
Subject: [PATCH 3/3] cpuidle: Using the kick_all_cpus_sync() to wake up all cpus
Date: Fri, 15 Aug 2014 15:01:25 +0800
Message-Id: <1408086085-16691-3-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408086085-16691-1-git-send-email-chuansheng.liu@intel.com>
References: <1408086085-16691-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current latency notify callback has the same function with
kick_all_cpus_sync().

Here use it directly to remove the redundant code.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 drivers/cpuidle/cpuidle.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index ee9df5e..7827375 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -530,11 +530,6 @@ EXPORT_SYMBOL_GPL(cpuidle_register);
 
 #ifdef CONFIG_SMP
 
-static void smp_callback(void *v)
-{
-	/* we already woke the CPU up, nothing more to do */
-}
-
 /*
  * This function gets called when a part of the kernel has a new latency
  * requirement.  This means we need to get all processors out of their C-state,
@@ -544,7 +539,7 @@ static void smp_callback(void *v)
 static int cpuidle_latency_notify(struct notifier_block *b,
 		unsigned long l, void *v)
 {
-	smp_call_function(smp_callback, NULL, 1);
+	kick_all_cpus_sync();
 	return NOTIFY_OK;
 }
 
-- 
1.7.9.5

