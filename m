Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3GJMSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:18:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36824 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab3GJMSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:18:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] More ACPI and power management updates for v3.11-rc1
Date: Wed, 10 Jul 2013 14:28:37 +0200
Message-ID: <17863900.yRJhKtHykF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.11-rc1-more

to receive additional ACPI and power management updates for v3.11-rc1 with
top-most commit d8851b4b0c1e7cf6cae829d060510437d2d320ee

  Merge branch 'pm-tools'

on top of commit f991fae5c6d42dfc5029150b05a78cf3f6c18cc9

  Merge tag 'pm+acpi-3.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm

These are fixes collected since the 3.10 release (most importantly, a fix
for a recent cpufreq regression), a couple of trivial cleanups and a cpupower
tool update that missed the opening of the merge window by a whisker.

Specifics:

 - Fix for a recent cpufreq regression that caused WARN() to trigger
   overzealously in a couple of places and spam the kernel log with
   useless garbage as a result.  From Viresh Kumar.

 - ACPI dock fix removing a discrepancy between the definition of
   acpi_dock_init(), which says that the function returns int, and
   its header in the header file, which says that it is a void
   function.  The function is now defined as void too.

 - ACPI PM fix for failures to update device power states as needed,
   for example, during resume from system suspend, because the old
   state was deeper than the new one, but the new one is not D0.

 - Fix for two debug messages in the ACPI power resources code that
   don't have a newline at the end and make the kernel log difficult
   to read.  From Mika Westerberg.

 - Two ACPI cleanups from Naresh Bhat and Haicheng Li.

 - cpupower updates from Thomas Renninger, including Intel Haswell
   support improvements and a new idle-set subcommand among other
   things.

Thanks!


---------------

Haicheng Li (1):
      ACPI / scan: remove unused LIST_HEAD(acpi_device_list)

Mika Westerberg (1):
      ACPI / power: add missing newline to debug messages

Naresh Bhat (1):
      ACPI / fan: Initialize acpi_state variable

Rafael J. Wysocki (2):
      ACPI / PM: Fix corner case in acpi_bus_update_power()
      ACPI / dock: Actually define acpi_dock_init() as void

Thomas Renninger (5):
      cpupower: Make idlestate usage unsigned
      cpupower: Implement disabling of cstate interface
      cpupower: Introduce idle-set subcommand and C-state enabling/disabling
      cpupower: Haswell also supports the C-states introduced with SandyBridge
      cpupower: Add Haswell family 0x45 specific idle monitor to show PC8,9,10 states

Viresh Kumar (1):
      cpufreq: Fix serialization of frequency transitions

---------------

 drivers/acpi/device_pm.c                                |   23 ++-
 drivers/acpi/dock.c                                     |    7 +-
 drivers/acpi/fan.c                                      |    2 +-
 drivers/acpi/power.c                                    |    4 +-
 drivers/acpi/scan.c                                     |    1 -
 drivers/cpufreq/cpufreq.c                               |    7 +-
 include/linux/cpufreq.h                                 |    2 +-
 tools/power/cpupower/Makefile                           |    4 +-
 tools/power/cpupower/man/cpupower-monitor.1             |   10 +-
 tools/power/cpupower/utils/builtin.h                    |    1 +
 tools/power/cpupower/utils/cpuidle-info.c               |   24 ++-
 tools/power/cpupower/utils/cpuidle-set.c                |  118 ++++++++++++++
 tools/power/cpupower/utils/cpupower.c                   |   13 +-
 tools/power/cpupower/utils/helpers/sysfs.c              |  118 +++++++++++++-
 tools/power/cpupower/utils/helpers/sysfs.h              |   10 +-
 tools/power/cpupower/utils/idle_monitor/hsw_ext_idle.c  |  196 +++++++++++++++++++++++
 .../power/cpupower/utils/idle_monitor/idle_monitors.def |    1 +
 tools/power/cpupower/utils/idle_monitor/snb_idle.c      |    4 +
 18 files changed, 502 insertions(+), 43 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
