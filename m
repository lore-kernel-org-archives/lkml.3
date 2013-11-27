Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab3K0OWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:22:38 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50636 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752606Ab3K0OWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:22:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.13-rc2
Date: Wed, 27 Nov 2013 15:35:22 +0100
Message-ID: <1656039.n8p00yR1CA@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.13-rc2

to receive ACPI and power management fixes for v3.13-rc2 with
top-most commit b90f7b8af985739facce48d64050a023e7df3858

  Merge branch 'pm-tools'

on top of commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae

  Linux Linux 3.13-rc1

These commits fix one cpufreq bug introduced recently and a few bugs all over
(ACPI mostly) that have been around for quite some time.  They also clean up
a couple of things.

If you don't like the octopus merge, please let me know. :-)

Specifics:

 - Fix for a recent regression in the Tegra cpufreq driver causing
   excess error messages to be printed from Stephen Warren.

 - ACPI-based device hotplug fix to prevent conflicting notify handlers
   from being installed for PCI host bridge objects.  From Toshi Kani.

 - ACPICA update to upstream version 20131115.  This contains bug fixes
   mostly (loop termination fix for the get AML length function, fixes
   related to namespace node removal and debug output).  From Bob Moore,
   Tomasz Nowicki and Lv Zheng.

 - Removal of incorrect inclusions of internal ACPICA header files by
   non-ACPICA code from Lv Zheng.

 - Fixes for the ACPI sysfs interface exposing tables to user space
   from Daisuke Hatayama and Jeremy Compostella.

 - Assorted ACPI and cpufreq cleanups from Sachin Kamat and Al Stone.

 - cpupower tool fix and man page from Thomas Renninger.

Thanks!


---------------

Al Stone (1):
      ACPI / sleep: clean up compiler warning about uninitialized field

Bob Moore (3):
      ACPICA: Debug output: Do not emit function nesting level for kernel build.
      ACPICA: Add support to delete all objects attached to the root namespace node.
      ACPICA: Update version to 20131115.

Daisuke HATAYAMA (1):
      ACPI / sysfs: Set file size for each exposed ACPI table

Jeremy Compostella (1):
      ACPI / sysfs: Fix incorrect ACPI tables walk in acpi_tables_sysfs_init()

Lv Zheng (3):
      ACPICA: Tests: Add CHECKSUM_ABORT protection for test utilities.
      ACPICA: Resources: Fix loop termination for the get AML length function.
      ACPI: Clean up incorrect inclusions of ACPICA headers

Sachin Kamat (1):
      cpufreq: exynos: Remove unwanted EXPORT_SYMBOL

Stephen Warren (1):
      cpufreq: tegra: don't error target() when suspended

Thomas Renninger (2):
      tools: cpupower: Add cpupower-idle-set(1) manpage
      tools: cpupower: fix wrong err msg not supported vs not available

Tomasz Nowicki (1):
      ACPICA: Delete all attached data objects during namespace node deletion.

Toshi Kani (1):
      ACPI / hotplug: Fix conflicted PCI bridge notify handlers

---------------

 drivers/acpi/acpica/acresrc.h                 |    6 +--
 drivers/acpi/acpica/nsalloc.c                 |   18 +++++--
 drivers/acpi/acpica/nsutils.c                 |   18 ++++---
 drivers/acpi/acpica/rscalc.c                  |    9 +++-
 drivers/acpi/acpica/rscreate.c                |   36 ++++++-------
 drivers/acpi/acpica/rsutils.c                 |    2 +-
 drivers/acpi/acpica/utdebug.c                 |   31 ++++++++---
 drivers/acpi/nvs.c                            |    1 -
 drivers/acpi/pci_root.c                       |    3 ++
 drivers/acpi/scan.c                           |    2 +-
 drivers/acpi/sleep.c                          |    2 +-
 drivers/acpi/sysfs.c                          |   54 ++++++++++---------
 drivers/cpufreq/exynos4210-cpufreq.c          |    1 -
 drivers/cpufreq/exynos4x12-cpufreq.c          |    1 -
 drivers/cpufreq/exynos5250-cpufreq.c          |    1 -
 drivers/cpufreq/tegra-cpufreq.c               |    4 +-
 drivers/hwmon/asus_atk0110.c                  |    1 -
 include/acpi/acconfig.h                       |    2 +
 include/acpi/acpi_bus.h                       |    1 +
 include/acpi/acpixf.h                         |    2 +-
 tools/power/cpupower/man/cpupower-idle-info.1 |    3 +-
 tools/power/cpupower/man/cpupower-idle-set.1  |   71 +++++++++++++++++++++++++
 tools/power/cpupower/utils/helpers/sysfs.c    |    4 +-
 23 files changed, 189 insertions(+), 84 deletions(-)

