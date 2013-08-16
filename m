Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3HPC2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:28:00 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47257 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3HPC15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:27:57 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 17/34] cpufreq: longhaul: set CPUFREQ_NO_NOTIFICATION flag
Date: Fri, 16 Aug 2013 07:55:14 +0530
Message-Id: <b67c7b6951b63ff38bac847e0b213bff3368e0b7.1376619363.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376619363.git.viresh.kumar@linaro.org>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376619363.git.viresh.kumar@linaro.org>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the drivers do following in their ->target_index() routines:

	struct cpufreq_freqs freqs;
	freqs.old = old freq...
	freqs.new = new freq...

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);

	/* Change rate here */

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);

This is replicated over all cpufreq drivers today and there doesn't exists a
good enough reason why this shouldn't be moved to cpufreq core instead.

Earlier patches have added support in cpufreq core to do cpufreq notification on
frequency change, but this drivers needs to do this notification itself and so
it sets its CPUFREQ_NO_NOTIFICATION flag.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/longhaul.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 45bafdd..7359043 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -909,6 +909,7 @@ static int longhaul_cpu_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver longhaul_driver = {
+	.flags = CPUFREQ_NO_NOTIFICATION,
 	.verify	= cpufreq_generic_frequency_table_verify,
 	.target_index = longhaul_target,
 	.get	= longhaul_get,
-- 
1.7.12.rc2.18.g61b472e

