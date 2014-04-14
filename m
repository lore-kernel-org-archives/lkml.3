Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaDNVIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:08:13 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54718 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754552AbaDNVIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:08:09 -0400
Message-ID: <534C4E36.9060208@semaphore.gr>
Date: Tue, 15 Apr 2014 00:08:06 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/20] cpufreq: acpi-cpufreq: Use cpufreq_for_each_entry macro
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
 drivers/cpufreq/acpi-cpufreq.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 000e4e0..12a5750 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -213,7 +213,7 @@ static unsigned extract_io(u32 value, struct acpi_cpufreq_data *data)
 
 static unsigned extract_msr(u32 msr, struct acpi_cpufreq_data *data)
 {
-	int i;
+	struct cpufreq_frequency_table *pos;
 	struct acpi_processor_performance *perf;
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
@@ -223,11 +223,11 @@ static unsigned extract_msr(u32 msr, struct acpi_cpufreq_data *data)
 
 	perf = data->acpi_data;
 
-	for (i = 0; data->freq_table[i].frequency != CPUFREQ_TABLE_END; i++) {
-		if (msr == perf->states[data->freq_table[i].driver_data].status)
-			return data->freq_table[i].frequency;
+	cpufreq_for_each_entry(pos, data->freq_table) {
+		if (msr == perf->states[pos->driver_data].status)
+			return pos->frequency;
 	}
-	return data->freq_table[0].frequency;
+	return data->freq_table->frequency;
 }
 
 static unsigned extract_freq(u32 val, struct acpi_cpufreq_data *data)
-- 
1.9.0

