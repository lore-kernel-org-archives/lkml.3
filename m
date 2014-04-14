Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaDNVJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:09:03 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54734 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754666AbaDNVI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:08:59 -0400
Message-ID: <534C4E69.1000907@semaphore.gr>
Date: Tue, 15 Apr 2014 00:08:57 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/20] cpufreq: elanfreq: Use cpufreq_for_each_entry macro
 for iteration
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
 drivers/cpufreq/elanfreq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index 7f5d2a6..a3f6f26 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -147,7 +147,7 @@ static int elanfreq_target(struct cpufreq_policy *policy,
 static int elanfreq_cpu_init(struct cpufreq_policy *policy)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
-	unsigned int i;
+	struct cpufreq_frequency_table *pos;
 
 	/* capability check */
 	if ((c->x86_vendor != X86_VENDOR_AMD) ||
@@ -159,9 +159,9 @@ static int elanfreq_cpu_init(struct cpufreq_policy *policy)
 		max_freq = elanfreq_get_cpu_frequency(0);
 
 	/* table init */
-	for (i = 0; (elanfreq_table[i].frequency != CPUFREQ_TABLE_END); i++) {
-		if (elanfreq_table[i].frequency > max_freq)
-			elanfreq_table[i].frequency = CPUFREQ_ENTRY_INVALID;
+	cpufreq_for_each_entry(pos, elanfreq_table) {
+		if (pos->frequency > max_freq)
+			pos->frequency = CPUFREQ_ENTRY_INVALID;
 	}
 
 	/* cpuinfo and default policy values */
-- 
1.9.0
