Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaACKVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 05:21:48 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:55616 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaACKVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 05:21:46 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: arm-big-little: Make driver dependent on CONFIG_BIG_LITTLE
Date: Fri,  3 Jan 2014 15:51:39 +0530
Message-Id: <a76f7b6a290d9174a24e15b13df21f53e3f5655f.1388736624.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arm_big_little cpufreq driver is only used for ARM bigLITTLE platforms and hence
must be dependent on CONFIG_BIG_LITTLE.

This was highlighted by Russell earlier when he reported this issue:

drivers/built-in.o: In function `bL_cpufreq_set_rate':
powercap_sys.c:(.text+0x5ed9a0): undefined reference to `bL_switch_request_cb'

Reported-by: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/Kconfig.arm | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 456ba5e..3275e9c 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -4,7 +4,7 @@
 
 config ARM_BIG_LITTLE_CPUFREQ
 	tristate "Generic ARM big LITTLE CPUfreq driver"
-	depends on ARM && ARM_CPU_TOPOLOGY && HAVE_CLK
+	depends on ARM && BIG_LITTLE && ARM_CPU_TOPOLOGY && HAVE_CLK
 	select PM_OPP
 	help
 	  This enables the Generic CPUfreq driver for ARM big.LITTLE platforms.
-- 
1.7.12.rc2.18.g61b472e

