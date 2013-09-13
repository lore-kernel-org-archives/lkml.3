Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3IMNJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:09:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42417 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab3IMNJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:09:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 054/228] cpufreq: sparc: call cpufreq_frequency_table_put_attr()
Date: Fri, 13 Sep 2013 18:30:00 +0530
Message-Id: <7baecf8302d921d18afa8fc7447e68e41eb434e8.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers which have an exit path must call cpufreq_frequency_table_put_attr() if
they have called cpufreq_frequency_table_get_attr() in their init path.

This driver was missing this part and is fixed with this patch.

Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sparc-us2e-cpufreq.c | 4 +++-
 drivers/cpufreq/sparc-us3-cpufreq.c  | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index e35840d..8db0c18 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -329,8 +329,10 @@ static int __init us2e_freq_cpu_init(struct cpufreq_policy *policy)
 
 static int us2e_freq_cpu_exit(struct cpufreq_policy *policy)
 {
-	if (cpufreq_us2e_driver)
+	if (cpufreq_us2e_driver) {
+		cpufreq_frequency_table_put_attr(policy->cpu);
 		us2e_set_cpu_divider_index(policy, 0);
+	}
 
 	return 0;
 }
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index 23f2d3b..120a2df 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -186,8 +186,10 @@ static int __init us3_freq_cpu_init(struct cpufreq_policy *policy)
 
 static int us3_freq_cpu_exit(struct cpufreq_policy *policy)
 {
-	if (cpufreq_us3_driver)
+	if (cpufreq_us3_driver) {
+		cpufreq_frequency_table_put_attr(policy->cpu);
 		us3_set_cpu_divider_index(policy, 0);
+	}
 
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

