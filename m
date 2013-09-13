Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab3IMNFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:05:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:32887 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320Ab3IMNFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:05:16 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 019/228] cpufreq: dbx500: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:25 +0530
Message-Id: <41b3ec3ebb8abdaae0082675814ef46094311ea5.1379063063.git.viresh.kumar@linaro.org>
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

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/dbx500-cpufreq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index 26321cd..8a484e9 100644
--- a/drivers/cpufreq/dbx500-cpufreq.c
+++ b/drivers/cpufreq/dbx500-cpufreq.c
@@ -87,10 +87,8 @@ static int dbx500_cpufreq_init(struct cpufreq_policy *policy)
 	int res;
 
 	/* get policy fields based on the table */
-	res = cpufreq_frequency_table_cpuinfo(policy, freq_table);
-	if (!res)
-		cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
-	else {
+	res = cpufreq_table_validate_and_show(policy, freq_table);
+	if (res) {
 		pr_err("dbx500-cpufreq: Failed to read policy table\n");
 		return res;
 	}
-- 
1.7.12.rc2.18.g61b472e

