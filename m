Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbaIEOlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:41:22 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:52855 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbaIEOlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:41:20 -0400
MIME-Version: 1.0
Date: Fri, 5 Sep 2014 16:41:19 +0200
X-Google-Sender-Auth: bSGThv1T09AOC12TPnXAMIO77ds
Message-ID: <CAJZ5v0i298zi_tQf2XfQo12dQHR3Kn7jBYfyH6RxiAWz_eE0yQ@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for 3.17-rc4
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.17-rc4

to receive ACPI and power management fixes for v3.17-rc4 with
top-most commit 9aa4e2f6ac2e5d0729f5982fd0b070123808381e

 Merge branches 'pm-sleep', 'powercap', 'pm-domains' and 'pm-cpufreq'

on top of commit 69e273c0b0a3c337a521d083374c918dc52c666f

 Linux 3.17-rc3

These are regression fixes (ACPI sysfs, ACPI video, suspend test),
ACPI cpuidle deadlock fix, missing runtime validation of ACPI _DSD
output, a fix and a new CPU ID for the RAPL driver, new blacklist
entry for the ACPI EC driver and a couple of trivial cleanups
(intel_pstate and generic PM domains).

Specifics:

 - Fix for recently broken test_suspend= command line argument
   (Rafael J Wysocki).

 - Fixes for regressions related to the ACPI video driver caused
   by switching the default to native backlight handling in 3.16
   from Hans de Goede.

 - Fix for a sysfs attribute of ACPI device objects that returns
   stale values sometimes due to the fact that they are cached
   instead of executing the appropriate method (_SUN) every time
   (broken in 3.14).  From Yasuaki Ishimatsu.

 - Fix for a deadlock between cpuidle_lock and cpu_hotplug.lock
   in the ACPI processor driver from Jiri Kosina.

 - Runtime output validation for the ACPI _DSD device configuration
   object missing from the support for it that has been introduced
   recently.  From Mika Westerberg.

 - Fix for an unuseful and misleading RAPL (Running Average Power
   Limit) domain detection message in the RAPL driver from Jacob Pan.

 - New Intel Haswell CPU ID for the RAPL driver from Jason Baron.

 - New Clevo W350etq blacklist entry for the ACPI EC driver
   from Lan Tianyu.

 - Cleanups for the intel_pstate driver and the core generic PM
   domains code from Gabriele Mazzotta and Geert Uytterhoeven.

Thanks!


---------------

Gabriele Mazzotta (1):
      cpufreq: intel_pstate: Remove unneeded variable

Geert Uytterhoeven (1):
      PM / domains: Make generic_pm_domain.name const

Hans de Goede (3):
      ACPI / video: Fix use_native_backlight selection logic
      ACPI / video: Add a disable_native_backlight quirk
      ACPI / video: Disable native_backlight on HP ENVY 15 Notebook PC

Jacob Pan (1):
      powercap / RAPL: change domain detection message

Jason Baron (1):
      powercap / RAPL: add support for CPU model 0x3f

Jiri Kosina (1):
      ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock

Lan Tianyu (1):
      ACPI / EC: Add msi quirk for Clevo W350etq

Mika Westerberg (1):
      ACPICA: ACPI 5.1: Add support for runtime validation of _DSD package.

Rafael J. Wysocki (1):
      PM / sleep: Fix test_suspend= command line option

Yasuaki Ishimatsu (1):
      ACPI / scan: not cache _SUN value in struct acpi_device_pnp

---------------

 drivers/acpi/acpica/nsprepkg.c | 39 ++++++++++++++++++++++++++++++++++++
 drivers/acpi/ec.c              |  4 ++++
 drivers/acpi/processor_idle.c  |  4 ++--
 drivers/acpi/scan.c            | 15 +++++++-------
 drivers/acpi/video.c           | 45 ++++++++++++++++++++++++++++++++++++++++--
 drivers/cpufreq/intel_pstate.c |  4 ----
 drivers/powercap/intel_rapl.c  |  8 ++++----
 include/acpi/acpi_bus.h        |  1 -
 include/linux/pm_domain.h      |  2 +-
 kernel/power/power.h           |  1 +
 kernel/power/suspend.c         |  2 +-
 kernel/power/suspend_test.c    | 31 ++++++++++++++++++-----------
 12 files changed, 122 insertions(+), 34 deletions(-)
