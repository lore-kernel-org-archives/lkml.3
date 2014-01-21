Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaAUDLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 22:11:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:52840 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbaAUDLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 22:11:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,694,1384329600"; 
   d="scan'208";a="469859920"
From: lizhuangzhi <zhuangzhi.li@intel.com>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Subject: [PATCH] cpufreq: Align all CPUs to the same frequency if using shared clock
Date: Tue, 21 Jan 2014 11:05:43 +0800
Message-Id: <1390273543-18032-1-git-send-email-zhuangzhi.li@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SMP systems want to make all the possible CPUs share the clock,
if the CPUs init frequencies aren't the same, we need to align all the
CPUs to the same frequency while CPUs registing to avoid mismatched
CPU's P-states.

Signed-off-by: lizhuangzhi <zhuangzhi.li@intel.com>
---
 drivers/cpufreq/cpufreq.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 8d19f7c..d00abb5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -991,6 +991,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	 * CPU because it is in the same boat. */
 	policy = cpufreq_cpu_get(cpu);
 	if (unlikely(policy)) {
+		/* according present policy to align all the cpus frequencies */
+		cpufreq_driver->target(policy, policy->cur, CPUFREQ_RELATION_H);
 		cpufreq_cpu_put(policy);
 		return 0;
 	}
-- 
1.7.9.5

