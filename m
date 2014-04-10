Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaDJVsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 17:48:21 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64906 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaDJVsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 17:48:18 -0400
MIME-Version: 1.0
Date: Thu, 10 Apr 2014 23:48:16 +0200
X-Google-Sender-Auth: gRDJ3J7SGyLvEDggFPQmCUEY4Es
Message-ID: <CAJZ5v0jKf3Bj28t7OSH-B4JjdsiAt6kPXxFKUO3Am8_t-2LZ7A@mail.gmail.com>
Subject: [GIT PULL] More ACPI and power management fixes and updates for v3.15-rc1
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.15-rc1-3

to receive additional ACPI and power management updates and a CPU hotplug
regression fix for v3.15-rc1 with top-most commit 19ce7f3f31103d7a5b0e93

 Merge branch 'acpi-config'

on top of commit 467a9e1633043810259a7f5368fbcc1e84746137

 Merge tag 'cpu-hotplug-3.15-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm

This is PM and ACPI material that has emerged over the last two weeks
and one fix for a CPU hotplug regression introduced by the recent CPU
hotplug notifiers registration series.  Included are intel_idle and
turbostat updates from Len Brown (these have been in linux-next for
quite some time), a new cpufreq driver for powernv (that might spend
some more time in linux-next, but BenH was asking me so nicely to push
it for 3.15 that I couldn't resist), some cpufreq fixes and cleanups
(including fixes for some silly breakage in a couple of cpufreq drivers
introduced during the 3.14 cycle), assorted ACPI cleanups, wakeup
framework documentation fixes, a new sysfs attribute for cpuidle and
a new command line argument for power domains diagnostics.

Specifics:

 - Fix for a recently introduced CPU hotplug regression in ARM KVM
   from Ming Lei.

 - Fixes for breakage in the at32ap, loongson2_cpufreq, and unicore32
   cpufreq drivers introduced during the 3.14 cycle (-stable material)
   from Chen Gang and Viresh Kumar.

 - New powernv cpufreq driver from Vaidyanathan Srinivasan, with bits
   from Gautham R Shenoy and Srivatsa S Bhat.

 - Exynos cpufreq driver fix preventing it from being included into
   multiplatform builds that aren't supported by it from Sachin Kamat.

 - cpufreq cleanups related to the usage of the driver_data field in
   struct cpufreq_frequency_table from Viresh Kumar.

 - cpufreq ppc driver cleanup from Sachin Kamat.

 - Intel BayTrail support for intel_idle and ACPI idle from Len Brown.

 - Intel CPU model 54 (Atom N2000 series) support for intel_idle from
   Jan Kiszka.

 - intel_idle fix for Intel Ivy Town residency targets from Len Brown.

 - turbostat updates (Intel Broadwell support and output cleanups)
   from Len Brown.

 - New cpuidle sysfs attribute for exporting C-states' target residency
   information to user space from Daniel Lezcano.

 - New kernel command line argument to prevent power domains enabled
   by the bootloader from being turned off even if they are not in use
   (for diagnostics purposes) from Tushar Behera.

 - Fixes for wakeup sysfs attributes documentation from Geert Uytterhoeven.

 - New ACPI video blacklist entry for ThinkPad Helix from Stephen Chandler
   Paul.

 - Assorted ACPI cleanups and a Kconfig help update from Jonghwan Choi,
   Zhihui Zhang, Hanjun Guo.

Thanks!


---------------

Chen Gang (1):
      cpufreq: unicore32: fix typo issue for 'clk'

Daniel Lezcano (1):
      cpuidle: sysfs: Export target residency information

Gautham R. Shenoy (2):
      cpufreq: powernv: Use cpufreq_frequency_table.driver_data to
store pstate ids
      cpufreq: powernv: Select CPUFreq related Kconfig options for powernv

Geert Uytterhoeven (1):
      PM / wakeup: Correct presence vs. emptiness of wakeup_* attributes

Hanjun Guo (1):
      ACPI: Update the ACPI spec information in Kconfig

Jan Kiszka (1):
      intel_idle: Add CPU model 54 (Atom N2000 series)

Jonghwan Choi (1):
      ACPI: Clean up memory allocations

Len Brown (6):
      ACPI idle: permit sparse C-state sub-state numbers
      intel_idle: allow sparse sub-state numbering, for Bay Trail
      intel_idle: support Bay Trail
      tools/power turbostat: simplify output, add Avg_MHz
      tools/power turbostat: Run on Broadwell
      intel_idle: fine-tune IVT residency targets

Ming Lei (1):
      arm, kvm: fix double lock on cpu_add_remove_lock

Rafael J. Wysocki (1):
      ACPI / dock: Drop dock_device_ids[] table

Sachin Kamat (2):
      cpufreq: exynos: Disable on multiplatform build
      cpufreq: ppc: Remove duplicate inclusion of fsl_soc.h

Stephen Chandler Paul (1):
      ACPI / video: Favor native backlight interface for ThinkPad Helix

Tushar Behera (1):
      PM / domains: Add pd_ignore_unused to keep power domains enabled

Vaidyanathan Srinivasan (1):
      cpufreq: powernv: cpufreq driver for powernv platform

Viresh Kumar (6):
      cpufreq: loongson2_cpufreq: don't declare local variable as static
      cpufreq: at32ap: don't declare local variable as static
      cpufreq: ia64: don't set .driver_data to index
      cpufreq: don't print value of .driver_data from core
      cpufreq: use kzalloc() to allocate memory for cpufreq_frequency_table
      cpufreq: create another field .flags in cpufreq_frequency_table

Zhihui Zhang (1):
      ACPI / thermal: Fix wrong variable usage in debug statement


---------------

 Documentation/ABI/testing/sysfs-devices-power |  46 ++--
 Documentation/kernel-parameters.txt           |   7 +
 arch/mips/loongson/lemote-2f/clock.c          |  20 +-
 arch/powerpc/configs/pseries_defconfig        |   1 +
 arch/powerpc/configs/pseries_le_defconfig     |   1 +
 arch/powerpc/include/asm/reg.h                |   4 +
 arch/powerpc/platforms/powernv/Kconfig        |   6 +
 arch/x86/kernel/acpi/cstate.c                 |   4 +-
 drivers/acpi/Kconfig                          |   8 +-
 drivers/acpi/dock.c                           |   6 -
 drivers/acpi/osl.c                            |   3 +-
 drivers/acpi/thermal.c                        |   2 +-
 drivers/acpi/utils.c                          |   3 +-
 drivers/acpi/video.c                          |   8 +
 drivers/base/power/domain.c                   |  13 +
 drivers/cpufreq/Kconfig.arm                   |   6 +-
 drivers/cpufreq/Kconfig.powerpc               |   8 +
 drivers/cpufreq/Makefile                      |   1 +
 drivers/cpufreq/acpi-cpufreq.c                |   2 +-
 drivers/cpufreq/at32ap-cpufreq.c              |   2 +-
 drivers/cpufreq/cris-artpec3-cpufreq.c        |   6 +-
 drivers/cpufreq/cris-etraxfs-cpufreq.c        |   6 +-
 drivers/cpufreq/elanfreq.c                    |  18 +-
 drivers/cpufreq/exynos4210-cpufreq.c          |  12 +-
 drivers/cpufreq/exynos4x12-cpufreq.c          |  30 +--
 drivers/cpufreq/exynos5250-cpufreq.c          |  34 +--
 drivers/cpufreq/freq_table.c                  |  11 +-
 drivers/cpufreq/ia64-acpi-cpufreq.c           |   3 +-
 drivers/cpufreq/kirkwood-cpufreq.c            |   6 +-
 drivers/cpufreq/longhaul.c                    |   2 +-
 drivers/cpufreq/loongson2_cpufreq.c           |   2 +-
 drivers/cpufreq/maple-cpufreq.c               |   6 +-
 drivers/cpufreq/p4-clockmod.c                 |  20 +-
 drivers/cpufreq/pasemi-cpufreq.c              |  12 +-
 drivers/cpufreq/pmac32-cpufreq.c              |   6 +-
 drivers/cpufreq/pmac64-cpufreq.c              |   6 +-
 drivers/cpufreq/powernow-k6.c                 |  18 +-
 drivers/cpufreq/powernow-k8.c                 |   5 +-
 drivers/cpufreq/powernv-cpufreq.c             | 341 ++++++++++++++++++++++++++
 drivers/cpufreq/ppc-corenet-cpufreq.c         |   1 -
 drivers/cpufreq/ppc_cbe_cpufreq.c             |  18 +-
 drivers/cpufreq/s3c2416-cpufreq.c             |  20 +-
 drivers/cpufreq/s3c24xx-cpufreq.c             |   4 +-
 drivers/cpufreq/s3c64xx-cpufreq.c             |  26 +-
 drivers/cpufreq/s5pv210-cpufreq.c             |  12 +-
 drivers/cpufreq/sc520_freq.c                  |   6 +-
 drivers/cpufreq/spear-cpufreq.c               |   7 +-
 drivers/cpufreq/speedstep-ich.c               |   6 +-
 drivers/cpufreq/speedstep-smi.c               |   6 +-
 drivers/cpufreq/unicore2-cpufreq.c            |   2 +-
 drivers/cpuidle/sysfs.c                       |   3 +
 drivers/idle/intel_idle.c                     | 204 ++++++++++++++-
 include/linux/cpufreq.h                       |   9 +-
 tools/power/x86/turbostat/turbostat.8         | 127 ++++------
 tools/power/x86/turbostat/turbostat.c         | 240 +++++++++---------
 virt/kvm/arm/arch_timer.c                     |   2 +-
 virt/kvm/arm/vgic.c                           |   2 +-
 57 files changed, 969 insertions(+), 421 deletions(-)
