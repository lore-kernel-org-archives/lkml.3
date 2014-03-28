Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaC1Nl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:41:57 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36456 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaC1Nlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:41:55 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, l.majewski@samsung.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 1/4] cpufreq: ia64: don't set .driver_data to index
Date: Fri, 28 Mar 2014 19:11:44 +0530
Message-Id: <57f831e4e1d45b7d81bc4cf4a94946db57360366.1396013927.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.driver_data field is only required to be filled if drivers want to preserve
some data in there which they can use according to the value of .frequency
field. But this driver isn't using this field at all, but just setting it equal
to the index value. Which isn't required. Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2: No Change

Hi Rafael,

To avoid confusion I am sending all related cpufreq patches again.

 drivers/cpufreq/ia64-acpi-cpufreq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index a22b5d1..beb191b 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -275,7 +275,6 @@ acpi_cpufreq_cpu_init (
 	/* table init */
 	for (i = 0; i <= data->acpi_data.state_count; i++)
 	{
-		data->freq_table[i].driver_data = i;
 		if (i < data->acpi_data.state_count) {
 			data->freq_table[i].frequency =
 			      data->acpi_data.states[i].core_frequency * 1000;
-- 
1.7.12.rc2.18.g61b472e

