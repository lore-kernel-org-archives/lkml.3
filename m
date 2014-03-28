Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaC1NmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:42:07 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:40630 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaC1NmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:42:03 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, l.majewski@samsung.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 2/4] cpufreq: don't print value of .driver_data from core
Date: Fri, 28 Mar 2014 19:11:45 +0530
Message-Id: <d2fd1c69770fb33ee8b282a1d9e35efe9742d66b.1396013927.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <57f831e4e1d45b7d81bc4cf4a94946db57360366.1396013927.git.viresh.kumar@linaro.org>
References: <57f831e4e1d45b7d81bc4cf4a94946db57360366.1396013927.git.viresh.kumar@linaro.org>
In-Reply-To: <57f831e4e1d45b7d81bc4cf4a94946db57360366.1396013927.git.viresh.kumar@linaro.org>
References: <57f831e4e1d45b7d81bc4cf4a94946db57360366.1396013927.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFreq core doesn't control value of .driver_data and this field is completely
driver specific. This can contain any value and not only indexes. For most of
the drivers, which aren't using this field, its value is zero. So, printing this
from core doesn't make any sense. Don't print it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2: No Change

 drivers/cpufreq/freq_table.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 65a4770..53ff3c2 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -36,8 +36,7 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 		    && table[i].driver_data == CPUFREQ_BOOST_FREQ)
 			continue;
 
-		pr_debug("table entry %u: %u kHz, %u driver_data\n",
-					i, freq, table[i].driver_data);
+		pr_debug("table entry %u: %u kHz\n", i, freq);
 		if (freq < min_freq)
 			min_freq = freq;
 		if (freq > max_freq)
@@ -175,8 +174,8 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 	} else
 		*index = optimal.driver_data;
 
-	pr_debug("target is %u (%u kHz, %u)\n", *index, table[*index].frequency,
-		table[*index].driver_data);
+	pr_debug("target index is %u, freq is:%u kHz\n", *index,
+		 table[*index].frequency);
 
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

