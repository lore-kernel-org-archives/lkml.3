Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab3HZPwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:52:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42824 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab3HZPwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:52:03 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-00-521b7995077b
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
Subject: [PATCH v8 4/7] cpufreq:boost:Kconfig: Provide support for software
 managed BOOST
Date: Mon, 26 Aug 2013 17:50:40 +0200
Message-id: <1377532243-17076-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1377532243-17076-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1377532243-17076-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jQd2pldJBBtfna1psnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRt8ebhZkaLy7vmsFl87j3CaHG7cQWbRf/C
	XiaLJw/72Cw2fvVw4PdYvOclk8eda3vYPNZNe8vs0bdlFaPHo8UtjB7Hb2xn8vi8SS6APYrL
	JiU1J7MstUjfLoEr49GEqUwF60Qq3jx8zNrA+FKgi5GTQ0LARKLjxTd2CFtM4sK99WwgtpDA
	dEaJzXesuhi5gOwuJokpzx6BFbEJ6El8vvuUCcQWEZjDKHHnqDtIEbPAA2aJxd+/MIIkhAWi
	JXat6QezWQRUJX5fewk2lVfATaLv/WwmiG3yEk/v94HFOQXcJU71vWWG2NzEKNG/XmYCI+8C
	RoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFB+0xqB+PKBotDjAIcjEo8vIEFUkFCrIll
	xZW5hxglOJiVRHg5UqWDhHhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgt
	gskycXBKNTDO8pi6cfEtTbYZJ4V8xWYLFzHJlRxP/6wRO2W/jf/bohSdxsp7tz/tErLdvvXP
	mZ5lm9v9pt743vn9qOXUucdvv1ostdG0+O/nKevdN5Xubn5wvjY1apFM35yj0zewz5TKv642
	ddeLztrVXKd2n/Rb9b8gfvZ0qTuvdqpEFFiWVzCEy//heKc7SYmlOCPRUIu5qDgRAJbMY9pW	AgAA
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

