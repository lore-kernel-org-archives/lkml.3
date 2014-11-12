Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965177AbaKLDmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:42:03 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:41421 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaKLDl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 22:41:59 -0500
MIME-Version: 1.0
In-Reply-To: <1415732980.15957.33.camel@freescale.com>
References: <1413515616-15874-1-git-send-email-B29983@freescale.com>
	<CAKohpokotKSvQ13uU4MnCer+qzBUUbGVTd19y7xswCAEKk3nGQ@mail.gmail.com>
	<6aaa50ef5f234fe2896f1c66eb646dfb@DM2PR03MB574.namprd03.prod.outlook.com>
	<1415732980.15957.33.camel@freescale.com>
Date: Wed, 12 Nov 2014 09:11:58 +0530
Message-ID: <CAKohpomEZXOJBvYwMYvcxxjPnKd4X378Nhh7TNypmL3rvd7SnA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: qoriq: Make the driver usable on all QorIQ platforms
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Yuantian Tang <Yuantian.Tang@freescale.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2014 00:39, Scott Wood <scottwood@freescale.com> wrote:
> What purpose do those "<arch> CPU frequency scaling drivers" submenus
> serve, versus just including the options in the main cpufreq menu?  It's
> not as if more than one arch would be visible at once (and when a
> situation with multiple visible menus popped up, it was considered a
> bug).

Oh, that really looks fine to me. I will send it formally as well:

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 3489f8f..a24d678 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -196,19 +196,19 @@ config CPUFREQ_DT

          If in doubt, say N.

-menu "x86 CPU frequency scaling drivers"
-depends on X86
+if X86
 source "drivers/cpufreq/Kconfig.x86"
-endmenu
+endif

-menu "ARM CPU frequency scaling drivers"
-depends on ARM || ARM64
+if ARM || ARM64
 source "drivers/cpufreq/Kconfig.arm"
-endmenu
+endif

-menu "AVR32 CPU frequency scaling drivers"
-depends on AVR32
+if PPC32 || PPC64
+source "drivers/cpufreq/Kconfig.powerpc"
+endif

+if AVR32
 config AVR32_AT32AP_CPUFREQ
        bool "CPU frequency driver for AT32AP"
        depends on PLATFORM_AT32AP
@@ -216,12 +216,9 @@ config AVR32_AT32AP_CPUFREQ
        help
          This enables the CPU frequency driver for AT32AP processors.
          If in doubt, say N.
+endif

-endmenu
-
-menu "CPUFreq processor drivers"
-depends on IA64
-
+if IA64
 config IA64_ACPI_CPUFREQ
        tristate "ACPI Processor P-States driver"
        depends on ACPI_PROCESSOR
@@ -232,12 +229,9 @@ config IA64_ACPI_CPUFREQ
        For details, take a look at <file:Documentation/cpu-freq/>.

        If in doubt, say N.
+endif

-endmenu
-
-menu "MIPS CPUFreq processor drivers"
-depends on MIPS
-
+if MIPS
 config LOONGSON2_CPUFREQ
        tristate "Loongson2 CPUFreq Driver"
        help
@@ -249,16 +243,9 @@ config LOONGSON2_CPUFREQ
          For details, take a look at <file:Documentation/cpu-freq/>.

          If in doubt, say N.
+endif

-endmenu
-
-menu "PowerPC CPU frequency scaling drivers"
-depends on PPC32 || PPC64
-source "drivers/cpufreq/Kconfig.powerpc"
-endmenu
-
-menu "SPARC CPU frequency scaling drivers"
-depends on SPARC64
+if SPARC64
 config SPARC_US3_CPUFREQ
        tristate "UltraSPARC-III CPU Frequency driver"
        help
@@ -276,10 +263,9 @@ config SPARC_US2E_CPUFREQ
          For details, take a look at <file:Documentation/cpu-freq>.

          If in doubt, say N.
-endmenu
+endif

-menu "SH CPU Frequency scaling"
-depends on SUPERH
+if SUPERH
 config SH_CPU_FREQ
        tristate "SuperH CPU Frequency driver"
        help
@@ -293,7 +279,7 @@ config SH_CPU_FREQ
          For details, take a look at <file:Documentation/cpu-freq>.

          If unsure, say N.
-endmenu
+endif

 endif
 endmenu
