Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182AbaBAWuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 17:50:16 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:44865 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaBAWuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 17:50:14 -0500
From: Rob Herring <robherring2@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        cpufreq@vger.kernel.org
Subject: [PATCH] cpufreq: cpu0: make THERMAL_CPU support optional
Date: Sat,  1 Feb 2014 16:50:09 -0600
Message-Id: <1391295009-10844-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

The addition of THERMAL and THERMAL_CPU selections causes a kconfig
warning on highbank platforms:

warning: (ARM_HIGHBANK_CPUFREQ) selects GENERIC_CPUFREQ_CPU0 which has
unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && HAVE_CLK &&
 REGULATOR && OF && THERMAL && CPU_THERMAL)

The cpufreq-cpu0 driver does not require thermal zone support, and it
should be selectable independently. Add a new kconfig option to enable
this feature.

Reported-by: Olof Johansson <olof@lixom.net>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/cpufreq/Kconfig | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 4b029c0..a197a04a 100644
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
@@ -194,6 +194,14 @@ config GENERIC_CPUFREQ_CPU0
 
 	  If in doubt, say N.
 
+config GENERIC_CPUFREQ_CPU0_THERMAL
+	bool "Thermal zone support for Generic CPU0 cpufreq"
+	depends on GENERIC_CPUFREQ_CPU0
+	select THERMAL
+	select THERMAL_CPU
+	help
+	  This adds thermal support to the generic cpufreq driver for CPU0.
+
 menu "x86 CPU frequency scaling drivers"
 depends on X86
 source "drivers/cpufreq/Kconfig.x86"
-- 
1.8.3.2

