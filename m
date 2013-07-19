Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429Ab3GSNBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:01:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52097 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab3GSNBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:01:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.11-rc2
Date: Fri, 19 Jul 2013 15:11 +0200
Message-ID: <10849265.6UBS59mCp5@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.11-rc2

to receive ACPI and power management fixes for v3.11-rc2 with
top-most commit 5a8d2815593007d4eb59f337ef919c871c2649ab

  Merge branch 'pm-fixes'

on top of commit ad81f0545ef01ea651886dddac4bef6cec930092

  Linux 3.11-rc1

These are fixes collected over the last week, most importnatly two cpufreq
reverts fixing regressions introduced in 3.10, an autoseelp fix preventing
systems using it from crashing during shutdown and two ACPI scan fixes
related to hotplug.

Specifics:

- Two cpufreq commits from the 3.10 cycle introduced regressions.
  The first of them was buggy (it did way much more than it needed
  to do) and the second one attempted to fix an issue introduced by
  the first one.  Fixes from Srivatsa S Bhat revert both.

- If autosleep triggers during system shutdown and the shutdown
  callbacks of some device drivers have been called already, it may
  crash the system.  Fix from Liu Shuo prevents that from happening
  by making try_to_suspend() check system_state.

- The ACPI memory hotplug driver doesn't clear its driver_data on
  errors which may cause a NULL poiter dereference to happen later.
  Fix from Toshi Kani.

- The ACPI namespace scanning code should not try to attach scan
  handlers to device objects that have them already, which may confuse
  things quite a bit, and it should rescan the whole namespace branch
  starting at the given node after receiving a bus check notify event
  even if the device at that particular node has been discovered
  already.  Fixes from yours truly.

- New ACPI video blacklist entry for a system whose initial backlight
  setting from the BIOS doesn't make sense.  From Lan Tianyu.

- Garbage string output avoindance for ACPI PNP from Liu Shuo.

- Two Kconfig fixes for issues introduced recently in the s3c24xx
  cpufreq driver (when moving the driver to drivers/cpufreq) from
  Paul Bolle.

- Trivial comment fix in pm_wakeup.h from Chanwoo Choi.

Thanks!


---------------

Chanwoo Choi (1):
      PM / Sleep: Fix comment typo in pm_wakeup.h

Lan Tianyu (1):
      ACPI / video: ignore BIOS initial backlight value for Fujitsu E753

Liu ShuoX (2):
      PM / Sleep: avoid 'autosleep' in shutdown progress
      PNP / ACPI: avoid garbage in resource name

Paul Bolle (2):
      cpufreq: s3c24xx: rename CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
      cpufreq: s3c24xx: fix "depends on ARM_S3C24XX" in Kconfig

Rafael J. Wysocki (2):
      ACPI / scan: Do not try to attach scan handlers to devices having them
      ACPI / scan: Always call acpi_bus_scan() for bus check notifications

Srivatsa S. Bhat (2):
      cpufreq: Revert commit a66b2e to fix suspend/resume regression
      cpufreq: Revert commit 2f7021a8 to fix CPU hotplug regression

Toshi Kani (1):
      ACPI / memhotplug: Fix a stale pointer in error path

---------------

 arch/arm/mach-s3c24xx/Kconfig      |    2 +-
 drivers/acpi/acpi_memhotplug.c     |    1 +
 drivers/acpi/scan.c                |   13 +++++++++----
 drivers/acpi/video.c               |    8 ++++++++
 drivers/cpufreq/cpufreq.c          |    4 +++-
 drivers/cpufreq/cpufreq_governor.c |    3 ---
 drivers/cpufreq/cpufreq_stats.c    |    6 ++----
 drivers/cpufreq/s3c24xx-cpufreq.c  |    4 ++--
 drivers/pnp/pnpacpi/rsparser.c     |    2 +-
 drivers/pnp/resource.c             |    1 +
 include/linux/pm_wakeup.h          |    4 ++--
 kernel/power/autosleep.c           |    3 ++-
 12 files changed, 32 insertions(+), 19 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
