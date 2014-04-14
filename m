Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbaDNVIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:08:45 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54726 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750993AbaDNVIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:08:37 -0400
Message-ID: <534C4E52.2010103@semaphore.gr>
Date: Tue, 15 Apr 2014 00:08:34 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: cpufreq@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/20] cpufreq: arm_big_little: Use cpufreq_for_each_entry
 macro for iteration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq core supports the cpufreq_for_each_entry macro helper
for iteration over the cpufreq_frequency_table, so use it.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/arm_big_little.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index bad2ed3..59c87f8 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -226,22 +226,24 @@ static inline u32 get_table_count(struct cpufreq_frequency_table *table)
 /* get the minimum frequency in the cpufreq_frequency_table */
 static inline u32 get_table_min(struct cpufreq_frequency_table *table)
 {
-	int i;
+	struct cpufreq_frequency_table *pos;
 	uint32_t min_freq = ~0;
-	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++)
-		if (table[i].frequency < min_freq)
-			min_freq = table[i].frequency;
+	cpufreq_for_each_entry(pos, table) {
+		if (pos->frequency < min_freq)
+			min_freq = pos->frequency;
+	}
 	return min_freq;
 }
 
 /* get the maximum frequency in the cpufreq_frequency_table */
 static inline u32 get_table_max(struct cpufreq_frequency_table *table)
 {
-	int i;
+	struct cpufreq_frequency_table *pos;
 	uint32_t max_freq = 0;
-	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++)
-		if (table[i].frequency > max_freq)
-			max_freq = table[i].frequency;
+	cpufreq_for_each_entry(pos, table) {
+		if (pos->frequency > max_freq)
+			max_freq = pos->frequency;
+	}
 	return max_freq;
 }
 
-- 
1.9.0
