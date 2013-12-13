Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3LMQjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:39:10 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:39188 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3LMQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:39:06 -0500
X-AuditID: cbfee61a-b7f7e6d000005936-f0-52ab38296a26
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
Subject: [PATCH v11 3/7] cpufreq:boost:Kconfig: Provide support for software
 managed BOOST
Date: Fri, 13 Dec 2013 17:38:33 +0100
Message-id: <1386952717-30947-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1386952717-30947-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1386952717-30947-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t9jQV1Ni9VBBv+3iltsnLGe1eJp0w92
	i76fV5gt1uz/yWTRefYJs8WbR9wWbx5uZrS4vGsOm8Xn3iOMFjPO72OyuN24gs3izOlLrBZP
	HvaxWWz86uHA57F4z0smjzvX9rB5rJv2ltljy9V2Fo++LasYPY7f2M7k8XmTXAB7FJdNSmpO
	Zllqkb5dAldG1/HzzAWvRSqeXn3K2sDYLdjFyMkhIWAiseHqM3YIW0ziwr31bF2MXBxCAtMZ
	JRof/meBcLqYJPrPL2YFqWIT0JP4fPcpE0hCRGAJo8TrpgWsIA6zwEZmiZ0z37KBVAkLxEgs
	mvyLBcRmEVCVaPp0B8zmFXCT6Nj7hglin6JE97MJYPWcAu4S0zatYoRY18Qo8fzKfcYJjLwL
	GBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSH7DOpHYwrGywOMQpwMCrx8Hr0rgoSYk0s
	K67MPcQowcGsJMIboro6SIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILU
	IpgsEwenVAPjVomJ6kazz2yb1v8o2PNtZWyhUiLP6lOCOq+fpX+4Jrb5qJRy6C0zd9Wvk5RE
	ec2XrqkqMOPtaU/tmtckYhj8aYnxqWRTJSaFFyvKGDOrrvNdZduhnlPcWT65xaxbab+1f8+S
	wJsxPLy/FiaK6e2fv9z+4aNL2fPdAuO+rIiUKj3uZnx67jklluKMREMt5qLiRABGygQ7VQIA	AA==
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
Changes for v11:
- None

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

