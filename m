Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaE0MIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:08:05 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62768 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaE0MIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:08:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        edubezval@gmail.com, pavel@ucw.cz, lgirdwood@gmail.com,
        broonie@kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 2/2] cpufreq: cpufreq-cpu0: remove dependency on THERMAL and REGULATOR
Date: Tue, 27 May 2014 17:37:30 +0530
Message-Id: <9ce16082a5851781b49b0fe5918a55588126b3d9.1401192160.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
In-Reply-To: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
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
cpufreq-cpu0 in Kconfig. Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1-V2: Remove dependency on REGULATORs as well.

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

