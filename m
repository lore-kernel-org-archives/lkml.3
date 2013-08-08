Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965734Ab3HHNwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:52:46 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49206 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965720Ab3HHNwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:52:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH 31/35] cpufreq: sh: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:33 +0530
Message-Id: <59aad752560cd39629fa415382ba0fb0e4541ac6.1375964117.git.viresh.kumar@linaro.org>
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

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sh-cpufreq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/sh-cpufreq.c b/drivers/cpufreq/sh-cpufreq.c
index ffc6d24..1362e88 100644
--- a/drivers/cpufreq/sh-cpufreq.c
+++ b/drivers/cpufreq/sh-cpufreq.c
@@ -120,9 +120,9 @@ static int sh_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (freq_table) {
 		int result;
 
-		result = cpufreq_frequency_table_cpuinfo(policy, freq_table);
-		if (!result)
-			cpufreq_frequency_table_get_attr(freq_table, cpu);
+		result = cpufreq_table_validate_and_show(policy, freq_table);
+		if (result)
+			return result;
 	} else {
 		dev_notice(dev, "no frequency table found, falling back "
 			   "to rate rounding.\n");
-- 
1.7.12.rc2.18.g61b472e

