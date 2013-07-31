Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466Ab3GaOVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:21:15 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39639 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760447Ab3GaOVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:21:11 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 12/15] cpufreq: sa11**: initialize .owner field with THIS_MODULE
Date: Wed, 31 Jul 2013 19:49:21 +0530
Message-Id: <24a297bc16b61b2577266b8a8f4ab2ac7b83f03d.1375279948.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375279948.git.viresh.kumar@linaro.org>
References: <cover.1375279948.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375279948.git.viresh.kumar@linaro.org>
References: <cover.1375279948.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFreq core does following at multiple places:
module_{get|put}(cpufreq_driver->owner)).

This is done to make sure module doesn't get unloaded if it is currently in use.
This will work only if the .owner field of cpufreq driver is initialized with a
valid pointer.

This field wasn't initialized for this driver, lets initialize it with
THIS_MODULE.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sa1100-cpufreq.c | 1 +
 drivers/cpufreq/sa1110-cpufreq.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/cpufreq/sa1100-cpufreq.c b/drivers/cpufreq/sa1100-cpufreq.c
index cff18e8..f41dbd7 100644
--- a/drivers/cpufreq/sa1100-cpufreq.c
+++ b/drivers/cpufreq/sa1100-cpufreq.c
@@ -233,6 +233,7 @@ static struct cpufreq_driver sa1100_driver __refdata = {
 	.target		= sa1100_target,
 	.get		= sa11x0_getspeed,
 	.init		= sa1100_cpu_init,
+	.owner		= THIS_MODULE,
 	.name		= "sa1100",
 };
 
diff --git a/drivers/cpufreq/sa1110-cpufreq.c b/drivers/cpufreq/sa1110-cpufreq.c
index 39c90b6..61627fb 100644
--- a/drivers/cpufreq/sa1110-cpufreq.c
+++ b/drivers/cpufreq/sa1110-cpufreq.c
@@ -349,6 +349,7 @@ static struct cpufreq_driver sa1110_driver __refdata = {
 	.target		= sa1110_target,
 	.get		= sa11x0_getspeed,
 	.init		= sa1110_cpu_init,
+	.owner		= THIS_MODULE,
 	.name		= "sa1110",
 };
 
-- 
1.7.12.rc2.18.g61b472e

