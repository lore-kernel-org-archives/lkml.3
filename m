Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3IMNDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:03:20 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49279 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab3IMNDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:03:15 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 002/228] cpufreq: don't break string in print statements
Date: Fri, 13 Sep 2013 18:29:08 +0530
Message-Id: <fee167a7c6197dc012dcc239f519745a129f08b6.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a rule its better not to break string (quoted inside "") in a print statement
even if it crosses 80 column boundary as that may introduce unwanted bugs and so
this patch rewrites one of the print statements..

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 3d5e6d6..6a8cae9 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1247,8 +1247,8 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
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

