Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbaDNVKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:10:49 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54793 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755775AbaDNVKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:10:45 -0400
Message-ID: <534C4ED1.7080901@semaphore.gr>
Date: Tue, 15 Apr 2014 00:10:41 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/20] davinci: da850: Use cpufreq_for_each_entry macro for
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
 arch/arm/mach-davinci/da850.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 85399c9..45ce065 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -1092,20 +1092,21 @@ int da850_register_cpufreq(char *async_clk)
 
 static int da850_round_armrate(struct clk *clk, unsigned long rate)
 {
-	int i, ret = 0, diff;
+	int ret = 0, diff;
 	unsigned int best = (unsigned int) -1;
 	struct cpufreq_frequency_table *table = cpufreq_info.freq_table;
+	struct cpufreq_frequency_table *pos;
 
 	rate /= 1000; /* convert to kHz */
 
-	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
-		diff = table[i].frequency - rate;
+	cpufreq_for_each_entry(pos, table) {
+		diff = pos->frequency - rate;
 		if (diff < 0)
 			diff = -diff;
 
 		if (diff < best) {
 			best = diff;
-			ret = table[i].frequency;
+			ret = pos->frequency;
 		}
 	}
 
-- 
1.9.0
