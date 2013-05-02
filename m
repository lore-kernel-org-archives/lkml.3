Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319Ab3EBPT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:19:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab3EBPQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH, RFC 02/22] cpufreq: ARM_DT_BL_CPUFREQ needs ARM_CPU_TOPOLOGY
Date: Thu,  2 May 2013 17:16:06 +0200
Message-Id: <1367507786-505303-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:BB3dH1elFwCsFhAXLbpLPFc2KMqdYRTNBmX2i2E75p8
 BtGzkMC4WBwRNGnfZ22OkkLTkYVJwOd4YeALam730rTqHlZEhI
 PyRp8FJRuKngtBLsGveDtDjpTMEW3X5hZjWjJ5pki5SVLZEmgm
 mDsrqVibM6udNUb9nDd0XWguLNp4SM1VaIlupKZuBJ4I3fI+9B
 MzmbycieD/uJqvTOgwixB0qKaUkJcAPiaQdYtI5sb/PHbAypiG
 Upq6H4S0GpulW4LD0PG9YnFrUU/NaD4VyFg1SL4CBPsWjKkriM
 9XwXhMiov7p7oWLzCm6PqFOGN4+80atSg1ntwIDPX5cbATOf5k
 BZnlnZfMgPjZuZSa5YGpXsJQKdLHkuNpDhnouqgdi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The big.LITTLE cpufreq driver uses the CPU topology API, which
needs to be reflected in Kconfig to prevent broken configurations.

warning: (ARM_DT_BL_CPUFREQ) selects ARM_BIG_LITTLE_CPUFREQ which
has unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && ARM && ARM_CPU_TOPOLOGY)

Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/cpufreq/Kconfig.arm | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index f3af18b..3fd6bdf 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -10,6 +10,7 @@ config ARM_DT_BL_CPUFREQ
 	tristate "Generic ARM big LITTLE CPUfreq driver probed via DT"
 	select ARM_BIG_LITTLE_CPUFREQ
 	depends on OF && HAVE_CLK
+	depends on ARM_CPU_TOPOLOGY
 	help
 	  This enables the Generic CPUfreq driver for ARM big.LITTLE platform.
 	  This gets frequency tables from DT.
-- 
1.8.1.2

