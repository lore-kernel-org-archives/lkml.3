Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbaESFYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:24:07 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62354 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaESFYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:24:04 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        shawn.guo@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: cpufreq-cpu0: remove dependency on thermal
Date: Mon, 19 May 2014 10:53:56 +0530
Message-Id: <b32b56dc1244be862065aff604023e8401a6438f.1400476917.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq-cpu0 uses thermal framework to register a cooling device, but doesn't
depend on it as there are dummy calls provided by thermal layer when
CONFIG_THERMAL=n. So, we don't really need to mention thermal as a dependency
for cpufreq-cpu0 in Kconfig.

Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 1fbe11f..4310997 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -185,7 +185,7 @@ config CPU_FREQ_GOV_CONSERVATIVE
 
 config GENERIC_CPUFREQ_CPU0
 	tristate "Generic CPU0 cpufreq driver"
-	depends on HAVE_CLK && REGULATOR && OF && THERMAL && CPU_THERMAL
+	depends on HAVE_CLK && REGULATOR && OF
 	select PM_OPP
 	help
 	  This adds a generic cpufreq driver for CPU0 frequency management.
-- 
2.0.0.rc2

