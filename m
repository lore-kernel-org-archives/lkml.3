Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbaFIVAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:00:16 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:55375 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754230AbaFIVAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:00:12 -0400
Message-ID: <53962059.6070306@semaphore.gr>
Date: Tue, 10 Jun 2014 00:00:09 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] cpufreq: intel_pstate: Remove duplicate CPU ID check
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We check the CPU ID during driver init. There is no need
to do it again per logical CPU initialization.

So, remove the duplicate check.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/intel_pstate.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index aebd457..4e7f492 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -691,14 +691,8 @@ MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
 
 static int intel_pstate_init_cpu(unsigned int cpunum)
 {
-
-	const struct x86_cpu_id *id;
 	struct cpudata *cpu;
 
-	id = x86_match_cpu(intel_pstate_cpu_ids);
-	if (!id)
-		return -ENODEV;
-
 	all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata), GFP_KERNEL);
 	if (!all_cpu_data[cpunum])
 		return -ENOMEM;
-- 
1.9.3
