Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab3BAStY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:49:24 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42991 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab3BAStW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:49:22 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 1/6] cpufreq: Retrieve current frequency from scaling drivers with internal governors
Date: Fri,  1 Feb 2013 10:49:05 -0800
Message-Id: <1359744545-18825-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
References: <359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Scaling drivers that implement the cpufreq_driver.setpolicy() versus
the cpufreq_driver.target() interface do not set policy->cur.

Normally policy->cur is set during the call to cpufreq_driver.target()
when the frequnecy request is made by the governor.

If the scaling driver implements cpufreq_driver.setpolicy() and
cpufreq_driver.get() interfaces use cpufreq_driver.get() to retrieve
the current frequency.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/cpufreq.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1f93dbd..1c037f0 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1219,6 +1219,9 @@ unsigned int cpufreq_quick_get(unsigned int cpu)
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
 	unsigned int ret_freq = 0;
 
+	if (cpufreq_driver && cpufreq_driver->setpolicy && cpufreq_driver->get)
+		return cpufreq_driver->get(cpu);
+
 	if (policy) {
 		ret_freq = policy->cur;
 		cpufreq_cpu_put(policy);
-- 
1.7.7.6

