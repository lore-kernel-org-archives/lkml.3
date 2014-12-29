Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaL2Va4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 16:30:56 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:39395 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaL2Vay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 16:30:54 -0500
MIME-Version: 1.0
Date: Mon, 29 Dec 2014 22:30:53 +0100
X-Google-Sender-Auth: w2-ec9Hx8X0nef8F7xXp-h5ivJo
Message-ID: <CAJZ5v0hYnuN-b3rMdc=UCUcVoUSyB39oCuSMoV08ZHAjKjwqcg@mail.gmail.com>
Subject: [GIT PULL] Power management and ACPI material for 3.19-rc3
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.19-rc3

to receive power management and ACPI material for v3.19-rc3 with
top-most commit 651c3293bf333c774f3d4c9876a6552d0ac2f5b9

 Merge branch 'acpi-video'

on top of commit b7392d2247cfe6771f95d256374f1a8e6a6f48d6

 Linux 3.19-rc2

These are fixes (operating performance points library, cpufreq-dt
driver, cpufreq core, ACPI backlight, cpupower tool), cleanups
(cpuidle), new processor IDs for the RAPL (Running Average Power
Limit) power capping driver, and a modification of the generic
power domains framework allowing modular drivers to call one of
its helper functions.

Specifics:

 - Fix for a potential NULL pointer dereference in the cpufreq
   core due to an initialization race condition (Ethan Zhao).

 - Fixes for abuse of the OPP (Operating Performance Points) API
   related to RCU and other minor issues in the OPP library and
   the cpufreq-dt driver (Dmitry Torokhov).

 - cpuidle governors cleanup making them measure idle duration in
   a better way without using the CPUIDLE_FLAG_TIME_INVALID flag
   which allows that flag to be dropped from the ACPI cpuidle driver
   and from the core too (Len Brown).

 - New ACPI backlight blacklist entries for Samsung machines
   without a working native backlight interface that need to
   use the ACPI backlight instead (Aaron Lu).

 - New CPU IDs of future Intel Xeon CPUs for the Intel RAPL power
   capping driver (Jacob Pan).

 - Generic power domains framework modification to export the
   of_genpd_get_from_provider() function to modular drivers that
   will allow future driver modifications to be based on the mainline
   (Amit Daniel Kachhap).

 - Two fixes for the cpupower tool (Michal Privoznik, Prarit Bhargava).

Thanks and Happy New Year!


---------------

Aaron Lu (1):
      ACPI / video: Add some Samsung models to disable_native_backlight list

Amit Daniel Kachhap (1):
      PM / Domains: Export of_genpd_get_from_provider function

Dmitry Torokhov (4):
      PM / OPP: add some lockdep annotations
      PM / OPP: fix warning in of_free_opp_table()
      PM / OPP: take RCU lock in dev_pm_opp_get_opp_count
      cpufreq-dt: defer probing if OPP table is not ready

Ethan Zhao (1):
      cpufreq: fix a NULL pointer dereference in __cpufreq_governor()

Jacob Pan (1):
      powercap / RAPL: add IDs for future Xeon CPUs

Len Brown (3):
      cpuidle: menu: Better idle duration measurement without using
CPUIDLE_FLAG_TIME_INVALID
      cpuidle: ladder: Better idle duration measurement without using
CPUIDLE_FLAG_TIME_INVALID
      cpuidle / ACPI: remove unused CPUIDLE_FLAG_TIME_INVALID

Michal Privoznik (1):
      tools / cpupower: Correctly detect if running as root

Prarit Bhargava (1):
      tools / cpupower: Fix no idle state information return value

---------------

 drivers/acpi/processor_idle.c              |  2 --
 drivers/acpi/video.c                       | 17 +++++++++++++
 drivers/base/power/domain.c                |  3 ++-
 drivers/base/power/opp.c                   | 39 ++++++++++++++++++++++++------
 drivers/cpufreq/cpufreq-dt.c               | 11 +++++++++
 drivers/cpufreq/cpufreq.c                  |  6 +++++
 drivers/cpuidle/governors/ladder.c         |  7 +-----
 drivers/cpuidle/governors/menu.c           | 25 ++++++++-----------
 drivers/powercap/intel_rapl.c              |  1 +
 include/linux/cpuidle.h                    |  3 ---
 include/linux/pm_domain.h                  |  8 ++++++
 tools/power/cpupower/utils/cpupower.c      |  2 +-
 tools/power/cpupower/utils/helpers/sysfs.c |  2 +-
 13 files changed, 89 insertions(+), 37 deletions(-)
