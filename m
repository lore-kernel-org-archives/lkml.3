Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab3IMNIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:08:14 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36135 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab3IMNII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:08:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, spear-devel@list.st.com
Subject: [PATCH 043/228] cpufreq: spear: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:49 +0530
Message-Id: <b34aca10fd1d031fb728dea8c83d4babedcfaf32.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Cc: spear-devel@list.st.com
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/spear-cpufreq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index 19e364fa..b86be6b 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -178,13 +178,12 @@ static int spear_cpufreq_init(struct cpufreq_policy *policy)
 {
 	int ret;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, spear_cpufreq.freq_tbl);
+	ret = cpufreq_table_validate_and_show(policy, spear_cpufreq.freq_tbl);
 	if (ret) {
-		pr_err("cpufreq_frequency_table_cpuinfo() failed");
+		pr_err("cpufreq_table_validate_and_show() failed");
 		return ret;
 	}
 
-	cpufreq_frequency_table_get_attr(spear_cpufreq.freq_tbl, policy->cpu);
 	policy->cpuinfo.transition_latency = spear_cpufreq.transition_latency;
 	policy->cur = spear_cpufreq_get(0);
 
-- 
1.7.12.rc2.18.g61b472e

