Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbaFIVBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:01:20 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:55403 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932406AbaFIVBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:01:13 -0400
Message-ID: <53962096.1060202@semaphore.gr>
Date: Tue, 10 Jun 2014 00:01:10 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] cpufreq: intel_pstate: Make intel_pstate_kobject local
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we never remove sysfs entry, we can make the intel_pstate_kobject
local.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/intel_pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index fa44f0f..9533fff 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -387,10 +387,10 @@ static struct attribute *intel_pstate_attributes[] = {
 static struct attribute_group intel_pstate_attr_group = {
 	.attrs = intel_pstate_attributes,
 };
-static struct kobject *intel_pstate_kobject;
 
 static void intel_pstate_sysfs_expose_params(void)
 {
+	struct kobject *intel_pstate_kobject;
 	int rc;
 
 	intel_pstate_kobject = kobject_create_and_add("intel_pstate",
-- 
1.9.3
