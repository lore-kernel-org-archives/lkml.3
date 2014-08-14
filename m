Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaHNXwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 19:52:03 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:53691 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbaHNXwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 19:52:01 -0400
MIME-Version: 1.0
Date: Fri, 15 Aug 2014 01:52:00 +0200
X-Google-Sender-Auth: cGLt9cBBnM5IEVXxylDHZFuZG_0
Message-ID: <CAJZ5v0h10BCKbytCh1qtdj-h8M0EY_nH4ANGYROcwwec0vq6dg@mail.gmail.com>
Subject: [GIT PULL] More ACPI and power management updates for 3.17-rc1
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.17-rc1-2

to receive more ACPI and power management updates for v3.17-rc1 with
top-most commit af5b7e84d022fdea373038d831bb4ca2c0e82108

 Merge branch 'pm-tools'

on top of commit 7725131982477bffff8ffdea143434dcc69f5d90

 Merge tag 'pm+acpi-3.17-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/
linux-pm

These are a couple of regression fixes, cpuidle menu governor
optimizations, fixes for ACPI proccessor and battery drivers,
hibernation fix to avoid problems related to the e820 memory map,
fixes for a few cpufreq drivers and a new version of the suspend
profiling tool analyze_suspend.py.

Specifics:

 - Fix for an ACPI-based device hotplug regression introduced in 3.14
   that causes a kernel panic to trigger when memory hot-remove is
   attempted with CONFIG_ACPI_HOTPLUG_MEMORY unset from Tang Chen.

 - Fix for a cpufreq regression introduced in 3.16 that triggers a
   "sleeping function called from invalid context" bug in
   dev_pm_opp_init_cpufreq_table() from Stephen Boyd.

 - ACPI battery driver fix for a warning message added in 3.16 that
   prints silly stuff sometimes from Mariusz Ceier.

 - Hibernation fix for safer handling of mismatches in the 820 memory
   map between the configurations during image creation and during
   the subsequent restore from Chun-Yi Lee.

 - ACPI processor driver fix to handle CPU hotplug notifications
   correctly during system suspend/resume from Lan Tianyu.

 - Series of four cpuidle menu governor cleanups that also should
   speed it up a bit from Mel Gorman.

 - Fixes for the speedstep-smi, integrator, cpu0 and arm_big_little
   cpufreq drivers from Hans Wennborg, Himangi Saraogi, Markus Pargmann
   and Uwe Kleine-König.

 - Version 3.0 of the analyze_suspend.py suspend profiling tool
   from Todd E Brandt.

Thanks!


---------------

Hans Wennborg (1):
      cpufreq: speedstep-smi: fix decimal printf specifiers

Himangi Saraogi (1):
      cpufreq: integrator: Use set_cpus_allowed_ptr

Lan Tianyu (1):
      ACPI / processor: Make acpi_cpu_soft_notify() process CPU FROZEN events

Lee, Chun-Yi (1):
      PM / hibernate: avoid unsafe pages in e820 reserved regions

Mariusz Ceier (1):
      ACPI / battery: Fix warning message in acpi_battery_get_state()

Markus Pargmann (1):
      cpufreq: cpu0: Do not print error message when deferring

Mel Gorman (4):
      cpuidle: menu: Use shifts when calculating averages where possible
      cpuidle: menu: Use ktime_to_us instead of reinventing the wheel
      cpuidle: menu: Call nr_iowait_cpu less times
      cpuidle: menu: Lookup CPU runqueues less

Stephen Boyd (1):
      cpufreq: OPP: Avoid sleeping while atomic

Tang Chen (1):
      ACPI / hotplug: Check scan handlers in acpi_scan_hot_remove()

Todd E Brandt (1):
      PM / tools: analyze_suspend.py: update to v3.0

Uwe Kleine-König (1):
      cpufreq: arm_big_little: fix module license spec

---------------

 drivers/acpi/battery.c               |    2 +-
 drivers/acpi/processor_driver.c      |    1 +
 drivers/acpi/scan.c                  |    3 +-
 drivers/cpufreq/arm_big_little.c     |    5 +
 drivers/cpufreq/arm_big_little_dt.c  |    2 +-
 drivers/cpufreq/cpufreq-cpu0.c       |    2 +-
 drivers/cpufreq/cpufreq_opp.c        |    2 +-
 drivers/cpufreq/integrator-cpufreq.c |   10 +-
 drivers/cpufreq/speedstep-smi.c      |    4 +-
 drivers/cpuidle/governors/menu.c     |   43 +-
 include/linux/sched.h                |    3 +-
 kernel/power/snapshot.c              |   21 +-
 kernel/sched/core.c                  |    7 +
 kernel/sched/proc.c                  |    7 -
 scripts/analyze_suspend.py           | 3817 ++++++++++++++++++++++++++--------
 15 files changed, 3051 insertions(+), 878 deletions(-)
