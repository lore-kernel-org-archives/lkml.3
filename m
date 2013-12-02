Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3LBMTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:19:53 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37604 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab3LBMTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:19:47 -0500
X-AuditID: cbfee61a-b7f316d000007e34-b0-529c7ae23b0d
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH RESEND v10 3/7] cpufreq:boost:Kconfig: Provide support for
 software managed BOOST
Date: Mon, 02 Dec 2013 13:19:17 +0100
Message-id: <1385986761-17934-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1385986761-17934-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1385986761-17934-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t9jQd1HVXOCDPbs17PYOGM9q8XTph/s
	Fn0/rzBbrNn/k8mi8+wTZos3j7gt3jzczGhxedccNovPvUcYLWac38dkcbtxBZvFmdOXWC2e
	POxjs9j41cOBz2PxnpdMHneu7WHzWDftLbPHlqvtLB59W1Yxehy/sZ3J4/MmuQD2KC6blNSc
	zLLUIn27BK6MI/+msxecF6nYPX0TSwPjD4EuRk4OCQETiQfHTrNC2GISF+6tZ+ti5OIQEpjO
	KPHt/w5WCKeLSaLn8w0mkCo2AT2Jz3efMoEkRASWMEq8bloAVsUssJFZYufMt2wgVcICyRKv
	zjeA2SwCqhJnT25jAbF5Bdwk5s35BrVPXuLp/T6wGk4Bd4m+108YIdY1MUpsXryXaQIj7wJG
	hlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwSH7TGoH48oGi0OMAhyMSjy8F4XnBAmxJpYV
	V+YeYpTgYFYS4X2ZCBTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6DVOlBIID2xJDU7NbUgtQgm
	y8TBKdXAWBFzvfmc3rUA+49bFdOnB7zwnTyXPe3xjNQwziRzFv3z/MyvdtRW7zQ6uCTy9uIG
	5UNGxzVvmnh/ipnRsUR86oZFSbs/Pjqa+6omJ3H+g6cf/BJSk9o44wWk+2zsn1W0M0xluK7x
	2X7d6+tVVbdKQk7nKO6OVgs7H3J8v4qw4IFSo1ve340TlFiKMxINtZiLihMB7f7ZCVUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For safety reasons new flag - CONFIG_CPU_FREQ_BOOST_SW has been added.
Only after selecting "EXYNOS Frequency Overclocking - Software" Kconfig
option the software managed boost is enabled. It also selects thermal
subsystem to be compiled in. Thermal is necessary for disabling boost
and cooling down the device when overheating detected.

Boost _MUST_NOT_ work without thermal subsystem with properly defined
overheating temperatures.

This option doesn't affect x86's ACPI hardware managed boost support
(i.e. Intel, AMD). In this situation boost management is embedded at
hardware.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

---
Changes for v10:
- None

Changes for v9:
- None

Changes for v8:
- None

Changes for v7:
- Remove superfluous "default n" definition
- Generic CPU_FREQ_BOOST_SW depends on THERMAL

Changes for v6:
- CPU_FREQ_BOOST_SW [1] is now defined as "invisible" bool option.
- Platform dependent ARM_EXYNOS_CPU_FREQ_BOOST_SW config option has been
  added. It depends on ARM_EXYNOS_CPUFREQ options and selects
  EXYNOS_THERMAL with the main boost config [1].

Changes for v5:
- New patch

 drivers/cpufreq/Kconfig     |    4 ++++
 drivers/cpufreq/Kconfig.arm |   15 +++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 38093e2..c8818c1 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -20,6 +20,10 @@ if CPU_FREQ
 config CPU_FREQ_GOV_COMMON
 	bool
 
+config CPU_FREQ_BOOST_SW
+	bool
+	depends on THERMAL
+
 config CPU_FREQ_STAT
 	tristate "CPU frequency translation statistics"
 	default y
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index ce52ed9..25599d6 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -64,6 +64,21 @@ config ARM_EXYNOS5440_CPUFREQ
 
 	  If in doubt, say N.
 
+config ARM_EXYNOS_CPU_FREQ_BOOST_SW
+	bool "EXYNOS Frequency Overclocking - Software"
+	depends on ARM_EXYNOS_CPUFREQ
+	select CPU_FREQ_BOOST_SW
+	select EXYNOS_THERMAL
+	help
+	  This driver supports software managed overclocking (BOOST).
+	  It allows usage of special frequencies for Samsung Exynos
+	  processors if thermal conditions are appropriate.
+
+	  It reguires, for safe operation, thermal framework with properly
+	  defined trip points.
+
+	  If in doubt, say N.
+
 config ARM_HIGHBANK_CPUFREQ
 	tristate "Calxeda Highbank-based"
 	depends on ARCH_HIGHBANK
-- 
1.7.10.4

