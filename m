Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3ITQB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:01:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45232 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3ITQBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:01:53 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-bc-523c71709c8f
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH RESEND v8 4/7] cpufreq:boost:Kconfig: Provide support for
 software managed BOOST
Date: Fri, 20 Sep 2013 18:01:01 +0200
Message-id: <1379692864-4954-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1379692864-4954-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1379692864-4954-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jAd2CQpsgg1MLpS02zljPavG06Qe7
	xbzPshZ9P68wW6zZ/5PJovPsE2aLN4+4Ld483MxocXnXHDaLz71HGC1uN65gs+hf2Mtk8eRh
	H5vFxq8eDnwei/e8ZPK4c20Pm8e6aW+ZPfq2rGL0eLS4hdHj+I3tTB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZTyaMJWpYJ1IxZuHj1kbGF8KdDFyckgImEg0nexlhLDFJC7cW88GYgsJLGKUWPfU
	u4uRC8juYpL4vv8+M0iCTUBP4vPdp0wgtojAHEaJO0fdQWxmgV3MEpcu6YLYwgJJEq1nzrGD
	2CwCqhLHVr4Cs3kFXCUWtBxkhVgmL/H0fh/YMk4BN4nHn+exQCxrZJR4O2sR6wRG3gWMDKsY
	RVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgkP1mfQOxlUNFocYBTgYlXh4H4TYBAmxJpYVV+Ye
	YpTgYFYS4a0tAArxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLg
	lGpgbCxMntdx9tKb1X6ffU1Cl0z5xue2RcJCOW2Z3NUoxhUlDI/U7mb8Zju/2S/S1MryUUnL
	5NKkSZ/+TDzQ4JhXVffRLHbumT+XT+4N3NTPt5vpgQ5n1kGeyUKbgneViO6btZinbnLV3++V
	l2boeIlcDbwzsb/4pcLbzpW8EWvf3fopr5e8b0n4FiWW4oxEQy3mouJEAFDQextRAgAA
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
index 534fcb8..e3cbf72 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -23,6 +23,10 @@ config CPU_FREQ_TABLE
 config CPU_FREQ_GOV_COMMON
 	bool
 
+config CPU_FREQ_BOOST_SW
+	bool
+	depends on THERMAL
+
 config CPU_FREQ_STAT
 	tristate "CPU frequency translation statistics"
 	select CPU_FREQ_TABLE
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 0fa204b..6a6d173 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -67,6 +67,21 @@ config ARM_EXYNOS5440_CPUFREQ
 
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

