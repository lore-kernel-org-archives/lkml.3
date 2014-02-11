Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaBKSeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:34:18 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:51554 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaBKSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:34:05 -0500
From: Rob Herring <robherring2@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        cpufreq@vger.kernel.org
Subject: [PATCH v2] cpufreq: cpu0: drop selecting of THERMAL and THERMAL_CPU
Date: Tue, 11 Feb 2014 12:33:52 -0600
Message-Id: <1392143632-15405-1-git-send-email-robherring2@gmail.com>
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

The cpufreq-cpu0 driver does not require thermal zone support to
function as highbank does not need these, so drop selecting of THERMAL
and CPU_THERMAL.

Reported-by: Olof Johansson <olof@lixom.net>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
v2:
- just drop selecting THERMAL and THERMAL_CPU instead of a new kconfig
  option

Dropping REGULATOR doesn't build w/o some empty regulator functions, so
that's 3.15 material.

Rob

 drivers/cpufreq/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 4b029c0..d100926 100644
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
1.8.3.2

