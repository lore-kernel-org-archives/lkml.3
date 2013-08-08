Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965575Ab3HHNvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:51:31 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37084 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965497Ab3HHNv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:51:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 21/35] cpufreq: omap: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:23 +0530
Message-Id: <0cc200b71d5c1584c80845a1384aef1919fd779b.1375964117.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/omap-cpufreq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index f31fcfc..b68ce4e 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -191,12 +191,10 @@ static int omap_cpu_init(struct cpufreq_policy *policy)
 
 	atomic_inc_return(&freq_table_users);
 
-	result = cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	result = cpufreq_table_validate_and_show(policy, freq_table);
 	if (result)
 		goto fail_table;
 
-	cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
-
 	policy->cur = omap_getspeed(policy->cpu);
 
 	/*
-- 
1.7.12.rc2.18.g61b472e

