Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbaDICgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:36:10 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:12860 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbaDICgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:36:07 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <rjw@rjwysocki.net>
CC: <viresh.kumar@linaro.org>, <mark.langsdorf@calxeda.com>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] cpufreq: highbank: fix ARM_HIGHBANK_CPUFREQ dependency warning
Date: Wed, 9 Apr 2014 10:34:33 +0800
Message-ID: <1397010873-11020-1-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.21.224]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When make ARCH=arm multi_v7_defconfig, we get the following warnings:

warning: (ARM_HIGHBANK_CPUFREQ) selects GENERIC_CPUFREQ_CPU0 which has
unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && HAVE_CLK
&& REGULATOR && OF && THERMAL && CPU_THERMAL)

To fix this, make ARM_HIGHBANK_CPUFREQ depend on ARCH_HAS_CPUFREQ and
REGULATOR instead of selecting them, PM_OPP will be selected by ARCH_HAS_CPUFREQ.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/cpufreq/Kconfig.arm | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 1e2b9db..30dfaef 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -92,11 +92,7 @@ config ARM_EXYNOS_CPU_FREQ_BOOST_SW
 
 config ARM_HIGHBANK_CPUFREQ
 	tristate "Calxeda Highbank-based"
-	depends on ARCH_HIGHBANK
-	select GENERIC_CPUFREQ_CPU0
-	select PM_OPP
-	select REGULATOR
-
+	depends on ARCH_HIGHBANK && GENERIC_CPUFREQ_CPU0 && REGULATOR
 	default m
 	help
 	  This adds the CPUFreq driver for Calxeda Highbank SoC
-- 
1.8.2.2


