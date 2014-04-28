Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbaD1TZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:25:37 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38926 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658AbaD1TZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:25:31 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 2/5] cpufreq,
 powernow-k6: Fix incorrect comparison with max_multipler
To: rjw@rjwysocki.net, mroos@linux.ee, viresh.kumar@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Tue, 29 Apr 2014 00:24:27 +0530
Message-ID: <20140428185418.28755.68864.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
References: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042818-2674-0000-0000-00000E035F10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value of 'max_multiplier' is meant to be used for comparison with
clock_ratio[index].driver_data, not the index itself! Fix the code in
powernow_k6_cpu_exit() that has this bug.

Also, while at it, make the for-loop condition look for CPUFREQ_TABLE_END,
instead of hard-coding the loop count to 8.

Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---

 drivers/cpufreq/powernow-k6.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 49f120e..695a68c 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -227,8 +227,9 @@ have_busfreq:
 static int powernow_k6_cpu_exit(struct cpufreq_policy *policy)
 {
 	unsigned int i;
-	for (i = 0; i < 8; i++) {
-		if (i == max_multiplier)
+
+	for (i = 0; (clock_ratio[i].frequency != CPUFREQ_TABLE_END); i++) {
+		if (clock_ratio[i].driver_data == max_multiplier)
 			powernow_k6_target(policy, i);
 	}
 	return 0;

