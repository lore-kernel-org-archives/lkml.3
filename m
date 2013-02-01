Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3BAGkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 01:40:35 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44335 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3BAGkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 01:40:10 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        spear-devel@list.st.com
Subject: [PATCH 2/3] cpufreq: Set all cpus in policy->cpus for single cluster SoCs
Date: Fri,  1 Feb 2013 12:10:01 +0530
Message-Id: <e76624720ca471d11ecd45628464d97e9eb513c9.1359700706.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <1bf82454ab1f16b13212548d7c9605067c8b7a0d.1359700705.git.viresh.kumar@linaro.org>
References: <1bf82454ab1f16b13212548d7c9605067c8b7a0d.1359700705.git.viresh.kumar@linaro.org>
In-Reply-To: <1bf82454ab1f16b13212548d7c9605067c8b7a0d.1359700705.git.viresh.kumar@linaro.org>
References: <1bf82454ab1f16b13212548d7c9605067c8b7a0d.1359700705.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 01 Feb 2013 06:40:07.0405 (UTC) FILETIME=[F98189D0:01CE0046]
X-MC-Unique: 113020106400809401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r116eoUm024433

With following patch, we need to set policy->cpus with mask of all possible cpus
and policy->related_cpus would be filled automatically by the core.

commit 4948b355e90080cd5ec1e91189f65a01e4186ef2
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Jan 29 14:39:08 2013 +0000

cpufreq: Simplify cpufreq_add_dev()

Lets fix it for all single cluster SoCs.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: spear-devel@list.st.com
---
 drivers/cpufreq/db8500-cpufreq.c | 2 +-
 drivers/cpufreq/maple-cpufreq.c  | 2 +-
 drivers/cpufreq/spear-cpufreq.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/db8500-cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
index 4f154bc..e12dff6 100644
--- a/drivers/cpufreq/db8500-cpufreq.c
+++ b/drivers/cpufreq/db8500-cpufreq.c
@@ -128,7 +128,7 @@ static int __cpuinit db8500_cpufreq_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 20 * 1000; /* in ns */
 
 	/* policy sharing between dual CPUs */
-	cpumask_copy(policy->cpus, cpu_present_mask);
+	cpumask_setall(policy->cpus);
 
 	policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
 
diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index 89b178a..d4c4989 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -181,7 +181,7 @@ static int maple_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	/* secondary CPUs are tied to the primary one by the
 	 * cpufreq core if in the secondary policy we tell it that
 	 * it actually must be one policy together with all others. */
-	cpumask_copy(policy->cpus, cpu_online_mask);
+	cpumask_setall(policy->cpus);
 	cpufreq_frequency_table_get_attr(maple_cpu_freqs, policy->cpu);
 
 	return cpufreq_frequency_table_cpuinfo(policy,
diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index fc714a6..8126084 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -188,7 +188,7 @@ static int spear_cpufreq_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = spear_cpufreq.transition_latency;
 	policy->cur = spear_cpufreq_get(0);
 
-	cpumask_copy(policy->cpus, topology_core_cpumask(policy->cpu));
+	cpumask_setall(policy->cpus);
 
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e


