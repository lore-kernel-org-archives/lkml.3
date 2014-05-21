Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaEUTyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:54:00 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:61548 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962AbaEUTx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:53:59 -0400
Message-ID: <1400702036.30334.6.camel@x220>
Subject: [PATCH] cpufreq: s5pv210: remove unused call of pr_err()
From: Paul Bolle <pebolle@tiscali.nl>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 May 2014 21:53:56 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2014 19:53:56.0621 (UTC) FILETIME=[6688A3D0:01CF752E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A call of pr_err() was added in v3.1. It was guarded by a check for
CONFIG_PM_VERBOSE. The Kconfig symbol PM_VERBOSE was removed in v3.0. So
this call of pr_err() has never been used. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/cpufreq/s5pv210-cpufreq.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index ab2c1a40d437..0873729135df 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -175,10 +175,6 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 	mutex_lock(&set_freq_lock);
 
 	if (no_cpufreq_access) {
-#ifdef CONFIG_PM_VERBOSE
-		pr_err("%s:%d denied access to %s as it is disabled"
-				"temporarily\n", __FILE__, __LINE__, __func__);
-#endif
 		ret = -EINVAL;
 		goto exit;
 	}
-- 
1.9.0

