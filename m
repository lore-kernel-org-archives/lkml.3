Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3EPT7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 15:59:25 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52166 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab3EPT7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 15:59:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Power management and ACPI fixes for v3.10-rc2
Date: Thu, 16 May 2013 22:07:58 +0200
Message-ID: <68458966.ga8OpWyZtA@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.10-rc2

to receive power management and ACPI fixes for v3.10-rc2 with top-most
commit 49a9e4315d40e1ba1d3258ea33f3948254038455

  Merge branch 'acpi-fixes'

on top of commit f722406faae2d073cc1d01063d1123c35425939e

  Linux 3.10-rc1

These mostly are fixes that have emerged recently, the majority in cpufreq,
some in ACPI and PM in general as well.

Included are:

- intel_pstate driver fixes and cleanups from Dirk Brandewie and
  Wei Yongjun.

- cpufreq fixes related to ARM big.LITTLE support and the
  cpufreq-cpu0 driver from Viresh Kumar.

- Assorted cpufreq fixes from Srivatsa S. Bhat, Borislav Petkov,
  Wolfram Sang, Alexander Shiyan, and Nishanth Menon.

- Assorted ACPI fixes from Catalin Marinas, Lan Tianyu, Alex Hung,
  Jan-Simon Möller, and yours truly.

- Fix for a kfree() under spinlock in the PM core from Shuah Khan.

- PM documentation updates from Borislav Petkov and Zhang Rui.

---------------

Alex Hung (1):
      ACPI video: ignore BIOS initial backlight value for HP 1000

Alexander Shiyan (1):
      cpufreq: Fix incorrect dependecies for ARM SA11xx drivers

Borislav Petkov (2):
      cpufreq, ondemand: Remove leftover debug line
      PM / hibernate: Correct documentation

Catalin Marinas (1):
      ACPI / scan: Fix memory leak on acpi_scan_init_hotplug() error path

Dirk Brandewie (5):
      cpufreq / intel_pstate: remove idle time and duration from sample and calculations
      cpufreq / intel_pstate: use lowest requested max performance
      cpufreq / intel_pstate: fix ffmpeg regression
      cpufreq / intel_pstate: Remove idle mode PID
      cpufreq / intel_pstate: remove #ifdef MODULE compile fence

Jan-Simon Möller (1):
      ACPI: Fix section to __init. Align with usage in acpixf.h

Lan Tianyu (2):
      ACPI / EC: Restart transaction even when the IBF flag set
      ACPI / AC: Add sleep quirk for Thinkpad e530

Nishanth Menon (1):
      cpufreq: cpufreq-cpu0: defer probe when regulator is not ready

Rafael J. Wysocki (1):
      ACPI / PM: Move processor suspend/resume to syscore_ops

Shuah Khan (1):
      PM: Avoid calling kfree() under spinlock in dev_pm_put_subsys_data()

Srivatsa S. Bhat (1):
      cpufreq: Preserve sysfs files across suspend/resume

Viresh Kumar (9):
      cpufreq: ARM big LITTLE: Select PM_OPP
      cpufreq: ARM big LITTLE DT: Return correct transition latency
      cpufreq: ARM big LITTLE DT: Return CPUFREQ_ETERNAL if clock-latency isn't found
      cpufreq: ARM big LITTLE: Move cpu_to_cluster() to arm_big_little.h
      cpufreq: ARM big LITTLE: Improve print message
      cpufreq: governors: Fix CPUFREQ_GOV_POLICY_{INIT|EXIT} notifiers
      cpufreq: Issue CPUFREQ_GOV_POLICY_EXIT notifier before dropping policy refcount
      cpufreq: cpufreq-cpu0: Free parent node for error cases
      cpufreq: ARM big LITTLE: Fix Kconfig entries

Wei Yongjun (1):
      cpufreq / intel_pstate: use vzalloc() instead of vmalloc()/memset(0)

Wolfram Sang (1):
      cpufreq / kirkwood: don't check resource with devm_ioremap_resource

Zhang Rui (2):
      PM: Documentation update for freeze state
      PM / Documentation: remove inaccurate suspend/hibernate transition lantency statement

---------------

 Documentation/power/devices.txt     |   15 +++---
 Documentation/power/interface.txt   |    4 +-
 Documentation/power/notifiers.txt   |    6 ++-
 Documentation/power/states.txt      |   30 ++++++-----
 drivers/acpi/ac.c                   |   33 ++++++++++++
 drivers/acpi/ec.c                   |    4 +-
 drivers/acpi/processor_driver.c     |    8 +--
 drivers/acpi/processor_idle.c       |   29 ++++++----
 drivers/acpi/scan.c                 |    3 +-
 drivers/acpi/video.c                |    8 +++
 drivers/base/power/common.c         |   12 ++---
 drivers/cpufreq/Kconfig             |    2 +-
 drivers/cpufreq/Kconfig.arm         |   15 +++---
 drivers/cpufreq/arm_big_little.c    |    7 +--
 drivers/cpufreq/arm_big_little.h    |    5 ++
 drivers/cpufreq/arm_big_little_dt.c |    9 ++--
 drivers/cpufreq/cpufreq-cpu0.c      |   27 +++++++---
 drivers/cpufreq/cpufreq.c           |   10 ++--
 drivers/cpufreq/cpufreq_governor.c  |   11 ++--
 drivers/cpufreq/cpufreq_governor.h  |    1 +
 drivers/cpufreq/cpufreq_ondemand.c  |    1 -
 drivers/cpufreq/cpufreq_stats.c     |    7 +--
 drivers/cpufreq/intel_pstate.c      |  122 ++++++++-----------------------------------
 drivers/cpufreq/kirkwood-cpufreq.c  |    4 --
 include/acpi/acpiosxf.h             |    2 +-
 include/acpi/processor.h            |   10 +++-
 26 files changed, 190 insertions(+), 195 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
