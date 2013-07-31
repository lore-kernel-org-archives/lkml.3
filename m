Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445Ab3GaOVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:21:07 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50552 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760413Ab3GaOVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:21:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 11/15] cpufreq: s5pv210: initialize .owner field with THIS_MODULE
Date: Wed, 31 Jul 2013 19:49:20 +0530
Message-Id: <702cbf98ff441665e43b9572c16f2cb71f50c3c1.1375279948.git.viresh.kumar@linaro.org>
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

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s5pv210-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index 5c77570..9ebad24 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -609,6 +609,7 @@ static struct cpufreq_driver s5pv210_driver = {
 	.target		= s5pv210_target,
 	.get		= s5pv210_getspeed,
 	.init		= s5pv210_cpu_init,
+	.owner		= THIS_MODULE,
 	.name		= "s5pv210",
 #ifdef CONFIG_PM
 	.suspend	= s5pv210_cpufreq_suspend,
-- 
1.7.12.rc2.18.g61b472e

