Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3IFT6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:58:16 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51177 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab3IFT6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:58:13 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 5/5] cpufreq: Use signed type for 'ret' variable,
 to store negative error values
To: rjw@sisk.pl, sboyd@codeaurora.org, viresh.kumar@linaro.org
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 07 Sep 2013 01:24:06 +0530
Message-ID: <20130906195404.26919.21905.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130906195206.26919.20884.stgit@srivatsabhat.in.ibm.com>
References: <20130906195206.26919.20884.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090619-7164-0000-0000-0000016AF8BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are places where the variable 'ret' is declared as unsigned int
and then used to store negative return values such as -EINVAL. Fix them
by declaring the variable as a signed quantity.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 9909789..9cc5609 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -460,7 +460,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *policy,
 static ssize_t store_##file_name					\
 (struct cpufreq_policy *policy, const char *buf, size_t count)		\
 {									\
-	unsigned int ret;						\
+	int ret;							\
 	struct cpufreq_policy new_policy;				\
 									\
 	ret = cpufreq_get_policy(&new_policy, policy->cpu);		\
@@ -513,7 +513,7 @@ static ssize_t show_scaling_governor(struct cpufreq_policy *policy, char *buf)
 static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
 					const char *buf, size_t count)
 {
-	unsigned int ret;
+	int ret;
 	char	str_governor[16];
 	struct cpufreq_policy new_policy;
 

