Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbaC0LCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:02:35 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:45428 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbaC0LCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:02:33 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: ia64: don't set .driver_data to index
Date: Thu, 27 Mar 2014 16:31:46 +0530
Message-Id: <10f85cd0fec235a5631017bb1add02cb33a7c648.1395918090.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/ia64-acpi-cpufreq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index 53c6ac6..f0d447d 100644
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

