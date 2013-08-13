Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3HMKJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:09:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10997 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3HMKJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:09:03 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-9b-520a05bdb64c
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
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH v7 4/7] cpufreq:boost:Kconfig: Provide support for software
 managed BOOST
Date: Tue, 13 Aug 2013 12:08:22 +0200
Message-id: <1376388505-30233-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1376388505-30233-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1376388505-30233-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jAd29rFxBBvMeSlpsnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRt8ebhZkaLy7vmsFl87j3CaHG7cQWbRf/C
	XiaLJw/72Cw2fvVw4PdYvOclk8eda3vYPNZNe8vs0bdlFaPHo8UtjB7Hb2xn8vi8SS6APYrL
	JiU1J7MstUjfLoEro2c5e8FD4YpjXx4yNzCuEuhi5OSQEDCR+HloEjuELSZx4d56ti5GLg4h
	gUWMEl+utkI5XUwSjXdfs4BUsQnoSXy++5QJxBYRmMMoceeoO0gRs8ADZonF378wdjFycAgL
	REs8vWQGUsMioCrx7+ZfZhCbV8BN4sHMh0wQ2+Qlnt7vYwOxOQXcJVb/b4Fa1sQo0XHsMNsE
	Rt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKD9pnUDsaVDRaHGAU4GJV4eAXecwQJ
	sSaWFVfmHmKU4GBWEuGNY+QKEuJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1
	tSC1CCbLxMEp1cAoweBY6vLzhnCxl9snRbYrGT3PzRUZeRMWRuxy/Od599qGrdFzZ0odFAoM
	jTaQSdt/eE9K7TmD5V9/XkkO2139frLOvl05p/qlUm7ErnafKdoekzBnhky37K7kfTsmMEnJ
	t26f/fLMzxetCjH9PdNvH1HeXFYh4ef/VLnuiaGAd0qM1g8+vedKLMUZiYZazEXFiQDKeM/D
	VgIAAA==
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

---
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

