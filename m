Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab3HKQxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:53:46 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:4795 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520Ab3HKQwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:52:10 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23717956"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel-janitors@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] drivers/cpufreq/pxa3xx-cpufreq.c: Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Sun, 11 Aug 2013 18:51:53 +0200
Message-Id: <1376239917-15594-13-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
arity of the called function.

The semantic match that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,f;
@@

f(...,
- ARRAY_AND_SIZE(e)
+ e,ARRAY_SIZE(e)
  ,...)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 drivers/cpufreq/pxa3xx-cpufreq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 9c92ef0..d26306f 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -213,10 +213,12 @@ static int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
 	policy->cur = policy->min = policy->max;
 
 	if (cpu_is_pxa300() || cpu_is_pxa310())
-		ret = setup_freqs_table(policy, ARRAY_AND_SIZE(pxa300_freqs));
+		ret = setup_freqs_table(policy, pxa300_freqs,
+					ARRAY_SIZE(pxa300_freqs));
 
 	if (cpu_is_pxa320())
-		ret = setup_freqs_table(policy, ARRAY_AND_SIZE(pxa320_freqs));
+		ret = setup_freqs_table(policy, pxa320_freqs,
+					ARRAY_SIZE(pxa320_freqs));
 
 	if (ret) {
 		pr_err("failed to setup frequency table\n");

