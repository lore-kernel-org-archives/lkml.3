Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaDNVJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:09:18 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54739 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754666AbaDNVJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:09:14 -0400
Message-ID: <534C4E76.6000905@semaphore.gr>
Date: Tue, 15 Apr 2014 00:09:10 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/20] cpufreq: exynos: Use cpufreq_for_each_entry macro for
 iteration
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
 drivers/cpufreq/exynos-cpufreq.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index f99cfe2..0e19bce 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -28,18 +28,18 @@ static unsigned int locking_frequency;
 
 static int exynos_cpufreq_get_index(unsigned int freq)
 {
-	struct cpufreq_frequency_table *freq_table = exynos_info->freq_table;
-	int index;
+	struct cpufreq_frequency_table *pos, *freq_table;
 
-	for (index = 0;
-		freq_table[index].frequency != CPUFREQ_TABLE_END; index++)
-		if (freq_table[index].frequency == freq)
+	freq_table = exynos_info->freq_table;
+	cpufreq_for_each_entry(pos, freq_table) {
+		if (pos->frequency == freq)
 			break;
+	}
 
-	if (freq_table[index].frequency == CPUFREQ_TABLE_END)
+	if (pos->frequency == CPUFREQ_TABLE_END)
 		return -EINVAL;
 
-	return index;
+	return pos - freq_table;
 }
 
 static int exynos_cpufreq_scale(unsigned int target_freq)
-- 
1.9.0
