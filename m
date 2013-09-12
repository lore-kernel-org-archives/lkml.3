Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3ILF0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:26:54 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:63665 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab3ILF0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:26:51 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, swarren@wwwdotorg.org, srivatsa.bhat@linux.vnet.ibm.com
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/5] cpufreq: don't break string in print statements
Date: Thu, 12 Sep 2013 10:55:45 +0530
Message-Id: <e086b55f2ec5c7a67fa28a21f23c088b67e5191e.1378963070.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1378963070.git.viresh.kumar@linaro.org>
References: <cover.1378963070.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1378963070.git.viresh.kumar@linaro.org>
References: <cover.1378963070.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a rule its better not to break string (quoted inside "") in a print statement
even if it crosses 80 column boundary as that may introduce unwanted bugs and so
this patch rewrites one of the print statements..

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 28477eb..31f7845 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1192,8 +1192,8 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 			unlock_policy_rwsem_write(cpu);
 
 			if (!frozen) {
-				pr_debug("%s: policy Kobject moved to cpu: %d "
-					 "from: %d\n",__func__, new_cpu, cpu);
+				pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
+						__func__, new_cpu, cpu);
 			}
 		}
 	}
-- 
1.7.12.rc2.18.g61b472e

