Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaDNVLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:11:17 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54805 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752521AbaDNVLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:11:11 -0400
Message-ID: <534C4EEC.8070508@semaphore.gr>
Date: Tue, 15 Apr 2014 00:11:08 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/20] cpufreq: pcc_cbe: Use cpufreq_for_each_entry macro
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

Please note that I was no able to compile test this patch due to 
lack of cross compiler.

 drivers/cpufreq/ppc_cbe_cpufreq.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index 5be8a48..b550d5c 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -67,9 +67,10 @@ static int set_pmode(unsigned int cpu, unsigned int slow_mode)
 
 static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
+	struct cpufreq_frequency_table *pos;
 	const u32 *max_freqp;
 	u32 max_freq;
-	int i, cur_pmode;
+	int cur_pmode;
 	struct device_node *cpu;
 
 	cpu = of_get_cpu_node(policy->cpu, NULL);
@@ -102,9 +103,9 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	pr_debug("initializing frequency table\n");
 
 	/* initialize frequency table */
-	for (i=0; cbe_freqs[i].frequency!=CPUFREQ_TABLE_END; i++) {
-		cbe_freqs[i].frequency = max_freq / cbe_freqs[i].driver_data;
-		pr_debug("%d: %d\n", i, cbe_freqs[i].frequency);
+	cpufreq_for_each_entry(pos, cbe_freqs) {
+		pos->frequency = max_freq / pos->driver_data;
+		pr_debug("%lu: %d\n", pos - cbe_freqs, pos->frequency);
 	}
 
 	/* if DEBUG is enabled set_pmode() measures the latency
-- 
1.9.0
