Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbaFJFJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:09:55 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:52480 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaFJFJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:09:53 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend] cpufreq: cpufreq-cpu0: remove dependency on THERMAL and REGULATOR
Date: Tue, 10 Jun 2014 10:39:46 +0530
Message-Id: <8f87e99e52f1b1e15c71c02fb19b0df18e2ae6d7.1402376803.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq-cpu0 uses thermal framework to register a cooling device, but doesn't
depend on it as there are dummy calls provided by thermal layer when
CONFIG_THERMAL=n. And when these calls fail, the driver is still usable.

Similar explanation is valid for regulators as well. We do have dummy calls
available for regulator APIs and the driver can work even when those calls
fail.

So, we don't really need to mention thermal and regulators as a dependency for
cpufreq-cpu0 in Kconfig as platforms without support for thermal/regulator can
also use this driver. Remove this dependency.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Rafael,

The dependency patches from regulators core are already pushed to Linus's tree
and so this patch can go in now.

 drivers/cpufreq/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 1fbe11f..e473d65 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -185,7 +185,7 @@ config CPU_FREQ_GOV_CONSERVATIVE
 
 config GENERIC_CPUFREQ_CPU0
 	tristate "Generic CPU0 cpufreq driver"
-	depends on HAVE_CLK && REGULATOR && OF && THERMAL && CPU_THERMAL
+	depends on HAVE_CLK && OF
 	select PM_OPP
 	help
 	  This adds a generic cpufreq driver for CPU0 frequency management.
-- 
2.0.0.rc2

