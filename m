Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab3GaOWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:22:11 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:53305 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760434Ab3GaOWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:22:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 15/15] cpufreq: Unicore: initialize .owner field with THIS_MODULE
Date: Wed, 31 Jul 2013 19:49:24 +0530
Message-Id: <0b4bbc3d04710cccd9b575ae54255ecf1168a5ec.1375279948.git.viresh.kumar@linaro.org>
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

Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/unicore2-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/unicore2-cpufreq.c b/drivers/cpufreq/unicore2-cpufreq.c
index 12fc904..93519f7 100644
--- a/drivers/cpufreq/unicore2-cpufreq.c
+++ b/drivers/cpufreq/unicore2-cpufreq.c
@@ -81,6 +81,7 @@ static struct cpufreq_driver ucv2_driver = {
 	.target		= ucv2_target,
 	.get		= ucv2_getspeed,
 	.init		= ucv2_cpu_init,
+	.owner		= THIS_MODULE,
 	.name		= "UniCore-II",
 };
 
-- 
1.7.12.rc2.18.g61b472e

