Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965409Ab3HHNuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:50:20 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63736 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965394Ab3HHNuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:50:15 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 11/35] cpufreq: dbx500: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:13 +0530
Message-Id: <e343e827df7be24f11ecdaf849f2874bf1ba4b24.1375964117.git.viresh.kumar@linaro.org>
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

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/dbx500-cpufreq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index 26321cd..ea03b92 100644
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
+	if (res)
 		pr_err("dbx500-cpufreq: Failed to read policy table\n");
 		return res;
 	}
-- 
1.7.12.rc2.18.g61b472e

