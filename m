Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbaFSNq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:46:59 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:59591 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbaFSNq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:46:57 -0400
MIME-Version: 1.0
Date: Thu, 19 Jun 2014 15:46:56 +0200
X-Google-Sender-Auth: YyK59DcpVdzm3Gw5mN1fl91hknU
Message-ID: <CAJZ5v0hH13nA1Qq5BYA+N5D0OBGozvNgiEGi4u8_-5i=vdjkPg@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management updates for v3.16-rc2
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.16-rc2

to receive ACPI and power management updates for v3.16-rc2
with top-most commit 2ba87ea132a7364dbeb71126f3d7b8ec8e59d0e9

 Merge branches 'pm-cpufreq' and 'pm-cpuidle'

on top of commit 7171511eaec5bf23fb06078f59784a3a0626b38f

 Linux 3.16-rc1

These are fixes mostly (ia64 regression related to the ACPI
enumeration of devices, cpufreq regressions, fix for I2C
controllers included in Intel SoCs, mvebu cpuidle driver fix
related to sysfs) plus additional kernel command line arguments
from Kees to make it possible to build kernel images with hibernation
and the kernel address space randomization included simultaneously,
a new ACPI battery driver quirk for a system with a broken BIOS and
a couple of ACPI core cleanups.

Specifics:

 - Fix for an ia64 regression introduced during the 3.11 cycle by a
   commit that modified the hardware initialization ordering and made
   device discovery fail on some systems.

 - Fix for a build problem on systems where the cpufreq-cpu0 driver
   is built-in and the cpu-thermal driver is modular from Arnd Bergmann.

 - Fix for a recently introduced computational mistake in the
   intel_pstate driver that leads to excessive rounding errors from
   Doug Smythies.

 - Fix for a failure code path in cpufreq_update_policy() that fails
   to unlock the locks acquired previously from Aaron Plattner.

 - Fix for the cpuidle mvebu driver to use shorter state names which
   will prevent the sysfs interface from returning mangled strings.
   From Gregory Clement.

 - ACPI LPSS driver fix to make sure that the I2C controllers
   included in BayTrail SoCs are not held in the reset state while
   they are being probed from Mika Westerberg.

 - New kernel command line arguments making it possible to build
   kernel images with hibernation and kASLR included at the same
   time and to select which of them will be used via the command
   line (they are still functionally mutually exclusive, though).
   From Kees Cook.

 - ACPI battery driver quirk for Acer Aspire V5-573G that fails
   to send battery status change notifications timely from
   Alexander Mezin.

 - Two ACPI core cleanups from Christoph Jaeger and Fabian Frederick.

Thanks!



---------------

Aaron Plattner (1):
      cpufreq: unlock when failing cpufreq_update_policy()

Alexander Mezin (2):
      ACPI / battery: use callback for setting up quirks
      ACPI / battery: add quirk for Acer Aspire V5-573G

Arnd Bergmann (1):
      cpufreq: cpufreq-cpu0: fix CPU_THERMAL dependency

Christoph Jaeger (1):
      ACPI: use kstrto*() instead of simple_strto*()

Doug Smythies (1):
      intel_pstate: Correct rounding in busy calculation

Fabian Frederick (1):
      ACPI / processor replace __attribute__((packed)) by __packed

Gregory CLEMENT (1):
      cpuidle: mvebu: Fix the name of the states

Kees Cook (2):
      PM / hibernate: introduce "nohibernate" boot parameter
      x86, kaslr: boot-time selectable with hibernation

Mika Westerberg (1):
      ACPI / LPSS: Take I2C host controllers out of reset

Rafael J. Wysocki (1):
      ACPI / ia64 / sba_iommu: Restore the working initialization ordering

---------------

 Documentation/kernel-parameters.txt     | 14 +++++---
 arch/ia64/hp/common/sba_iommu.c         | 64 +++++++++++++++++++--------------
 arch/x86/Kconfig                        |  1 -
 arch/x86/boot/compressed/aslr.c         |  9 ++++-
 drivers/acpi/acpi_lpss.c                | 15 ++++++++
 drivers/acpi/battery.c                  | 39 ++++++++++++++++++--
 drivers/acpi/osl.c                      |  3 +-
 drivers/acpi/tables.c                   |  3 +-
 drivers/cpufreq/Kconfig                 |  2 ++
 drivers/cpufreq/cpufreq.c               | 10 +++---
 drivers/cpufreq/intel_pstate.c          |  5 +--
 drivers/cpuidle/cpuidle-armada-370-xp.c |  4 +--
 include/acpi/processor.h                | 10 +++---
 include/linux/suspend.h                 |  2 ++
 kernel/power/hibernate.c                | 37 ++++++++++++++++++-
 kernel/power/main.c                     |  6 ++--
 kernel/power/user.c                     |  3 ++
 17 files changed, 167 insertions(+), 60 deletions(-)
