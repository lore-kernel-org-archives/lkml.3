Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaEWPFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:05:09 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:57293 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbaEWPFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:05:05 -0400
Message-ID: <1400857500.31526.52.camel@x220>
Subject: [PATCH v2] cpufreq: s5pv210: drop check for CONFIG_PM_VERBOSE
From: Paul Bolle <pebolle@tiscali.nl>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 23 May 2014 17:05:00 +0200
In-Reply-To: <CAK9yfHzf-Z3AQ4+-sF7xqqUw4dN8aULkCNvLQnmusp_ZiOg+Rw@mail.gmail.com>
References: <1400702036.30334.6.camel@x220>
	 <CAK9yfHz2kdfkf+o7fKMRu=nMXxbcHJ227bjpvA=WXt6ptH3QRA@mail.gmail.com>
	 <1400740894.21254.8.camel@x220>
	 <CAK9yfHzf-Z3AQ4+-sF7xqqUw4dN8aULkCNvLQnmusp_ZiOg+Rw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 May 2014 15:05:01.0411 (UTC) FILETIME=[5EC50330:01CF7698]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pr_err() was added in v3.1. It was guarded by a check for
CONFIG_PM_VERBOSE. The Kconfig symbol PM_VERBOSE was removed in v3.0. So
this pr_err() has never been used. Drop that check and clean up the
message a bit.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
v1 was called "cpufreq: s5pv210: remove unused call of pr_err()". v2
keeps the pr_err() and trims down its arguments, as Sachin requested.

Still untested.

 drivers/cpufreq/s5pv210-cpufreq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index ab2c1a40d437..19a10b89fef7 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -175,10 +175,8 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 	mutex_lock(&set_freq_lock);
 
 	if (no_cpufreq_access) {
-#ifdef CONFIG_PM_VERBOSE
-		pr_err("%s:%d denied access to %s as it is disabled"
-				"temporarily\n", __FILE__, __LINE__, __func__);
-#endif
+		pr_err("Denied access to %s as it is disabled temporarily\n",
+		       __func__);
 		ret = -EINVAL;
 		goto exit;
 	}
-- 
1.9.0

