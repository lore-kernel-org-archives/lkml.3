Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbaHFTHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:07:37 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:62545 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaHFTHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:07:34 -0400
MIME-Version: 1.0
Date: Wed, 6 Aug 2014 21:07:33 +0200
X-Google-Sender-Auth: fVuNPGqHPyt-R29Lopi8tVDLenE
Message-ID: <CAJZ5v0i9pY59A56hKbsPitOwjsLmyJ5Qr3YQmc3+HF8_4q7s5Q@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management updates for v3.17-rc1
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.17-rc1

to receive ACPI and power management updates for v3.17-rc1 with
top-most commit 7ef97e0e3a0f4b02601dde384127cc85d27e46e2

 Merge branches 'acpi-video', 'acpi-battery', 'acpi-processor' and 'acpi-lpss'

on top of commit 64aa90f26c06e1cb2aacfb98a7d0eccfbd6c1a91

 Linux 3.16-rc7

Again, ACPICA leads the pack (47 commits), followed by cpufreq
(18 commits) and system suspend/hibernation (9 commits).

>From the new code perspective, the ACPICA update brings ACPI 5.1
to the table, including a new device configuration object called
_DSD (Device Specific Data) that will hopefully help us to operate
device properties like Device Trees do (at least to some extent)
and changes related to supporting ACPI on ARM.

Apart from that we have hibernation changes making it use radix
trees to store memory bitmaps which should speed up some operations
carried out by it quite significantly.  We also have some power
management changes related to suspend-to-idle (the "freeze" sleep
state) support and more preliminary changes needed to support ACPI on
ARM (outside of ACPICA).

The rest is fixes and cleanups pretty much everywhere.

Specifics:

 - ACPICA update to upstream version 20140724.  That includes
   ACPI 5.1 material (support for the _CCA and _DSD predefined names,
   changes related to the DMAR and PCCT tables and ARM support among
   other things) and cleanups related to using ACPICA's header files.
   A major part of it is related to acpidump and the core code used
   by that utility.  Changes from Bob Moore, David E Box, Lv Zheng,
   Sascha Wildner, Tomasz Nowicki, Hanjun Guo.

 - Radix trees for memory bitmaps used by the hibernation core from
   Joerg Roedel.

 - Support for waking up the system from suspend-to-idle (also known
   as the "freeze" sleep state) using ACPI-based PCI wakeup signaling
   (Rafael J Wysocki).

 - Fixes for issues related to ACPI button events (Rafael J Wysocki).

 - New device ID for an ACPI-enumerated device included into the
   Wildcat Point PCH from Jie Yang.

 - ACPI video updates related to backlight handling from Hans de Goede
   and Linus Torvalds.

 - Preliminary changes needed to support ACPI on ARM from Hanjun Guo
   and Graeme Gregory.

 - ACPI PNP core cleanups from Arjun Sreedharan and Zhang Rui.

 - Cleanups related to ACPI_COMPANION() and ACPI_HANDLE() macros
   (Rafael J Wysocki).

 - ACPI-based device hotplug cleanups from Wei Yongjun and
   Rafael J Wysocki.

 - Cleanups and improvements related to system suspend from
   Lan Tianyu, Randy Dunlap and Rafael J Wysocki.

 - ACPI battery cleanup from Wei Yongjun.

 - cpufreq core fixes from Viresh Kumar.

 - Elimination of a deadband effect from the cpufreq ondemand
   governor and intel_pstate driver cleanups from Stratos Karafotis.

 - 350MHz CPU support for the powernow-k6 cpufreq driver from
   Mikulas Patocka.

 - Fix for the imx6 cpufreq driver from Anson Huang.

 - cpuidle core and governor cleanups from Daniel Lezcano,
   Sandeep Tripathy and Mohammad Merajul Islam Molla.

 - Build fix for the big_little cpuidle driver from Sachin Kamat.

 - Configuration fix for the Operation Performance Points (OPP)
   framework from Mark Brown.

 - APM cleanup from Jean Delvare.

 - cpupower utility fixes and cleanups from Peter Senna Tschudin,
   Andrey Utkin, Himangi Saraogi, Rickard Strandqvist, Thomas Renninger.

Thanks!


---------------

Andrey Utkin (1):
      PM / tools: cpupower: drop negativity check on unsigned value

Anson Huang (1):
      cpufreq: imx6: remove pu regulator dependency for SOCs with no
PU regulator

Arjun Sreedharan (1):
      ACPI / PNP: Replace faulty is_hex_digit() by isxdigit()

Bob Moore (14):
      ACPICA: utprint/oslibcfs: cleanup - no functional change
      ACPICA: Update version to 20140627
      ACPICA: Fix a regression for deletion of Alias() objects.
      ACPICA: Work around an ancient GCC bug.
      ACPICA: Remove a redundant cast to acpi_size for ACPI_OFFSET() macro.
      ACPICA: Disassembler: Add support for the ToUUID opererator (macro).
      ACPICA: Update for comments/formatting. No functional changes.
      ACPICA: Tables: Update for DMAR table changes.
      ACPICA: acpihelp: Add UUID support, restructure some existing files.
      ACPICA: Debug object: Add current value of Timer() to debug line prefix.
      ACPICA: ACPI 5.1: New notify value for System Affinity Update.
      ACPICA: ACPI 5.1: Support for the _CCA predifined name.
      ACPICA: ACPI 5.1: Update for PCCT table changes.
      ACPICA: Update version to 20140724.

Daniel Lezcano (2):
      cpuidle: Remove manual selection of the multiple driver support
      cpuidle: Remove time measurement in poll state

David E. Box (4):
      ACPICA: Utilities: Fix memory leak in acpi_ut_copy_iobject_to_iobject
      ACPICA: Utilities: Validate full RSDP header
      ACPICA: Namespace: Properly null terminate objects detached from
a namespace node
      ACPICA: ACPI 5.1: Support for the _DSD predefined name.

Graeme Gregory (3):
      ACPI: add config for BIOS table scan
      ACPI: Don't use acpi_lapic in ACPI core code
      ACPICA/ARM: ACPI 5.1: Update for FADT changes.

Hanjun Guo (2):
      ACPI / processor: Introduce ARCH_MIGHT_HAVE_ACPI_PDC
      ACPI / processor: Make it possible to get local x2apic id via _MAT

Hans de Goede (2):
      ACPI: move models with win8 brightness problems from win8
blacklist to use_native_backlight
      ACPI / video: Add use_native_backlight quirk for HP EliteBook 2014 models

Himangi Saraogi (1):
      cpupower: mperf monitor: Correct use of ! and &

Jean Delvare (1):
      x86, apm: Remove unused variable

Jie Yang (1):
      ACPI / LPSS: add LPSS device for Wildcat Point PCH

Joerg Roedel (6):
      PM / Hibernate: Create a Radix-Tree to store memory bitmap
      PM / Hibernate: Add memory_rtree_find_bit function
      PM / Hibernate: Implement position keeping in radix tree
      PM / Hibernate: Iterate over set bits instead of PFNs in swsusp_free()
      PM / Hibernate: Remove the old memory-bitmap implementation
      PM / Hibernate: Touch Soft Lockup Watchdog in rtree_next_node

Lan Tianyu (1):
      ACPI / sleep: Do not save NVS for new machines to accelerate S3

Linus Torvalds (1):
      ACPI / video: Fix backlight taking 2 steps on a brightness
up/down keypress

Lv Zheng (29):
      ACPICA: Restore error table definitions to reduce code
differences between Linux and ACPICA upstream.
      ACPICA: Events: Fix edge-triggered GPE by disabling before
acknowledging it.
      ACPICA: acpidump: Add support for ACPI 1.0 GUID in Linux
      ACPICA: Utilities: Fix an issue with non-native ACPI_IS_PRINT()
      ACPICA: Utilities: Add support to read table from files
      ACPICA: OSL: Update environments to improve portability
      ACPICA: Utilities: Cleanup DEFINE_ACPI_GLOBALS by moving
acpi_ut_init_global() from utglobal.c to utinit.c
      ACPICA: OSL: Clean up acpi_os_printf()/acpi_os_vprintf() stubs
      ACPICA: OSL: Add portable file IO to improve portability
      ACPICA: Utilities: Add formatted printing APIs
      ACPICA: Utilities: Introduce acpi_log_error() to improve portability
      ACPICA: Application: Enhance ACPI_USAGE_xxx/ACPI_OPTION with
acpi_os_printf() to improve portability
      ACPICA: Common: Enhance cm_get_file_size() to improve portability
      ACPICA: Common: Enhance acpi_getopt() to improve portability
      ACPICA: acpidump: Add memory/string OSL usage to improve portability
      ACPICA: acpidump: Remove exit() from generic layer to improve portability
      ACPICA: acpidump: Replace file IOs with new APIs to improve portability
      ACPICA: acpidump: Reduce freopen() invocations to improve portability
      ACPICA: OSL: Update acpidump to reduce source code differences
      ACPICA: Executer: Fix trivial issues in acpi_get_serial_access_bytes()
      ACPICA: Hardware: back port of a recursive locking fix
      ACPICA: Tables: Merge DMAR table structure updates
      ACPICA: Linux: Add stub support for Linux specific variables and
functions.
      ACPICA: Linux: Add stub implementation of ACPICA 64-bit mathematics.
      ACPICA: Linux: Add support to exclude <asm/acenv.h> inclusion.
      ACPICA: Linux: Allow ACPICA inclusion for CONFIG_ACPI=n builds.
      ACPI / SFI: Fix wrong <acpi/acpi.h> inclusion in SFI/ACPI
wrapper - table definitions.
      ACPI: Add support to force header inclusion rules for <acpi/acpi.h>.
      ACPICA: Utilities: Fix local printf issue.

Mark Brown (1):
      PM / OPP: Remove ARCH_HAS_OPP

Mikulas Patocka (1):
      powernow-k6: support 350MHz CPU

Mohammad Merajul Islam Molla (3):
      cpuidle: fix permission for driver name sysfs node
      cpuidle: menu governor - remove unused macro STDDEV_THRESH
      cpuidle: ladder governor - use macro instead of hardcoded value

Peter Senna Tschudin (1):
      cpupower: Remove redundant error check

Rafael J. Wysocki (15):
      ACPI / hotplug / PCI: Eliminate acpiphp_dev_to_bridge()
      ACPI / hotplug: Simplify acpi_set_hp_context()
      PM / sleep: Simplify sleep states sysfs interface code
      PM / sleep: Move platform suspend operations to separate functions
      ACPI / button: Do not propagate wakeup-from-suspend events
      PM: Create PM workqueue if runtime PM is not configured too
      ACPI / PM: Revork the handling of ACPI device wakeup notifications
      ACPI / PM: Always enable wakeup GPEs when enabling device wakeup
      ACPI / PM: Use ACPI_COMPANION() instead of ACPI_HANDLE()
      ACPI / PNP: Use ACPI_COMPANION() instead of ACPI_HANDLE()
      ACPICA: GPEs: Do not allow enable for GPEs that have no handler(s).
      ACPICA: Add new GPE public interface - acpi_mark_gpe_for_wake.
      ACPI / scan: No implicit wake notification for buttons
      ACPI / PCI: Use ACPI_COMPANION() instead of ACPI_HANDLE()
      ACPI / PNP: Fix acpi_pnp_match()

Randy Dunlap (1):
      PM / sleep: fix kernel-doc warnings in drivers/base/power/main.c

Rickard Strandqvist (1):
      cpupower: bench: parse.c: Fix several minor errors

Sachin Kamat (1):
      cpuidle: big_little: Fix build error

Sandeep Tripathy (1):
      cpuidle: move idle traces to cpuidle_enter_state()

Sascha Wildner (1):
      ACPICA: Remove some extraneous printf arguments.

Sebastian Reichel (1):
      MAINTAINERS: power_supply: update maintainership

Stratos Karafotis (13):
      cpufreq: intel_pstate: Make intel_pstate_kobject and debugfs_parent locals
      cpufreq: intel_pstate: Remove unnecessary type casting in div_s64() call
      cpufreq: intel_pstate: Add missing blank lines after declarations
      cpufreq: intel_pstate: Fit code in a single line where possible
      cpufreq: intel_pstate: Cleanup parentheses
      cpufreq: intel_pstate: Remove unnecessary intermediate variable
sample_time
      cpufreq: intel_pstate: Align multiple lines to open parenthesis
      cpufreq: intel_pstate: Disable interrupts during MSRs reading
      cpufreq: intel_pstate: Keep values in aperf/mperf in full precision
      cpufreq: intel_pstate: Simplify P state adjustment logic.
      cpufreq: intel_pstate: Remove core_pct rounding
      cpufreq: Introduce new relation for freq selection
      cpufreq: ondemand: Eliminate the deadband effect

Thomas Renninger (1):
      cpupower: Adjust MAINTAINERS file

Tomasz Nowicki (2):
      ACPICA/ARM: ACPI 5.1: Update for MADT changes.
      ACPICA/ARM: ACPI 5.1: Update for GTDT table changes.

Viresh Kumar (3):
      cpufreq: don't restore policy->cpus on failure to move kobj
      cpufreq: propagate error returned by kobject_move()
      cpufreq: move policy kobj to update_policy_cpu()

Wei Yongjun (2):
      ACPI / hotplug / PCI: Fix sparse non static symbol warning
      ACPI / battery: remove duplicated include from battery.c

Zhang Rui (1):
      ACPI / PNP: do ACPI binding directly

---------------

 Documentation/power/opp.txt                        |    3 -
 MAINTAINERS                                        |    4 +-
 arch/arm/mach-exynos/Kconfig                       |    1 -
 arch/arm/mach-highbank/Kconfig                     |    1 -
 arch/arm/mach-imx/Kconfig                          |    1 -
 arch/arm/mach-omap2/Kconfig                        |    1 -
 arch/arm/mach-shmobile/Kconfig                     |    2 -
 arch/arm/mach-vexpress/Kconfig                     |    1 -
 arch/arm/mach-zynq/Kconfig                         |    1 -
 arch/ia64/Kconfig                                  |    1 +
 arch/ia64/include/asm/acenv.h                      |    4 -
 arch/ia64/include/asm/acpi.h                       |    5 +
 arch/x86/Kconfig                                   |    2 +
 arch/x86/include/asm/acenv.h                       |    4 -
 arch/x86/include/asm/acpi.h                        |    5 +
 drivers/acpi/Kconfig                               |    6 +
 drivers/acpi/Makefile                              |    1 +
 drivers/acpi/acpi_extlog.c                         |   14 +-
 drivers/acpi/acpi_lpss.c                           |   10 +
 drivers/acpi/acpi_pnp.c                            |    8 +-
 drivers/acpi/acpi_processor.c                      |    2 +-
 drivers/acpi/acpica/Makefile                       |   10 +-
 drivers/acpi/acpica/acapps.h                       |    9 +-
 drivers/acpi/acpica/acdebug.h                      |    3 -
 drivers/acpi/acpica/acglobal.h                     |    8 +-
 drivers/acpi/acpica/aclocal.h                      |   18 +-
 drivers/acpi/acpica/acpredef.h                     |   16 +-
 drivers/acpi/acpica/acutils.h                      |   48 +-
 drivers/acpi/acpica/evgpe.c                        |   32 +-
 drivers/acpi/acpica/evxfgpe.c                      |   61 +-
 drivers/acpi/acpica/exdebug.c                      |   11 +-
 drivers/acpi/acpica/exdump.c                       |    6 +-
 drivers/acpi/acpica/exfield.c                      |   26 +-
 drivers/acpi/acpica/hwregs.c                       |    3 +-
 drivers/acpi/acpica/nsobject.c                     |   10 +
 drivers/acpi/acpica/utbuffer.c                     |  128 ++
 drivers/acpi/acpica/utcopy.c                       |    6 +
 drivers/acpi/acpica/utdebug.c                      |   26 +
 drivers/acpi/acpica/utdecode.c                     |   32 +-
 drivers/acpi/acpica/utfileio.c                     |  331 +++++
 drivers/acpi/acpica/utglobal.c                     |  146 ---
 drivers/acpi/acpica/uthex.c                        |  100 ++
 drivers/acpi/acpica/utinit.c                       |  145 +++
 drivers/acpi/acpica/utprint.c                      |  664 ++++++++++
 drivers/acpi/acpica/utuuid.c                       |   96 ++
 drivers/acpi/apei/apei-internal.h                  |   10 +-
 drivers/acpi/apei/ghes.c                           |   32 +-
 drivers/acpi/battery.c                             |    1 -
 drivers/acpi/blacklist.c                           |   68 +-
 drivers/acpi/bus.c                                 |    3 -
 drivers/acpi/button.c                              |   25 +-
 drivers/acpi/device_pm.c                           |  148 ++-
 drivers/acpi/internal.h                            |    7 +-
 drivers/acpi/osl.c                                 |    4 +-
 drivers/acpi/pci_root.c                            |    2 +-
 drivers/acpi/processor_core.c                      |  200 +--
 drivers/acpi/processor_pdc.c                       |  206 +++
 drivers/acpi/scan.c                                |   33 +-
 drivers/acpi/sleep.c                               |    5 +
 drivers/acpi/video.c                               |  121 +-
 drivers/base/power/main.c                          |    5 +
 drivers/cpufreq/cpufreq.c                          |   74 +-
 drivers/cpufreq/cpufreq_ondemand.c                 |   11 +-
 drivers/cpufreq/freq_table.c                       |   12 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |   35 +-
 drivers/cpufreq/intel_pstate.c                     |  131 +-
 drivers/cpufreq/powernow-k6.c                      |    1 +
 drivers/cpuidle/Kconfig                            |    7 +-
 drivers/cpuidle/Kconfig.arm                        |    1 +
 drivers/cpuidle/cpuidle.c                          |    2 +
 drivers/cpuidle/driver.c                           |   11 -
 drivers/cpuidle/governors/ladder.c                 |    4 +-
 drivers/cpuidle/governors/menu.c                   |    1 -
 drivers/cpuidle/sysfs.c                            |    2 +-
 drivers/devfreq/Kconfig                            |    1 -
 drivers/firmware/efi/cper.c                        |   20 +-
 drivers/iommu/dmar.c                               |   28 +-
 drivers/pci/hotplug/acpiphp_glue.c                 |   33 +-
 drivers/pci/pci-acpi.c                             |   76 +-
 drivers/pnp/pnpacpi/core.c                         |   92 +-
 include/acpi/acconfig.h                            |   18 +
 include/acpi/acnames.h                             |    1 +
 include/acpi/acpi_bus.h                            |   42 +-
 include/acpi/acpiosxf.h                            |   31 +
 include/acpi/acpixf.h                              |   54 +-
 include/acpi/actbl.h                               |   12 +-
 include/acpi/actbl1.h                              |   58 +-
 include/acpi/actbl2.h                              |   14 +-
 include/acpi/actbl3.h                              |  118 +-
 include/acpi/actypes.h                             |   19 +-
 include/acpi/ghes.h                                |    2 +-
 include/acpi/platform/acenv.h                      |   53 +-
 include/acpi/platform/aclinux.h                    |   12 +
 include/acpi/platform/aclinuxex.h                  |   22 +
 include/linux/acpi.h                               |    6 +-
 include/linux/cpufreq.h                            |    1 +
 include/linux/pci-acpi.h                           |   13 +-
 include/linux/pm_runtime.h                         |   11 +-
 include/linux/sfi_acpi.h                           |    3 -
 kernel/power/Kconfig                               |    3 -
 kernel/power/main.c                                |   25 +-
 kernel/power/power.h                               |    7 +-
 kernel/power/snapshot.c                            |  494 ++++++--
 kernel/power/suspend.c                             |  152 ++-
 kernel/power/suspend_test.c                        |   12 +-
 kernel/sched/idle.c                                |    4 -
 tools/power/acpi/Makefile                          |    5 +
 tools/power/acpi/common/cmfsize.c                  |   20 +-
 tools/power/acpi/common/getopt.c                   |   14 +-
 .../acpi/os_specific/service_layers/oslibcfs.c     |  214 ++++
 .../acpi/os_specific/service_layers/oslinuxtbl.c   |   48 +-
 .../acpi/os_specific/service_layers/osunixxf.c     | 1311 ++++++++++++++++++++
 tools/power/acpi/tools/acpidump/acpidump.h         |    3 +-
 tools/power/acpi/tools/acpidump/apdump.c           |  108 +-
 tools/power/acpi/tools/acpidump/apfiles.c          |   92 +-
 tools/power/acpi/tools/acpidump/apmain.c           |   96 +-
 tools/power/cpupower/bench/parse.c                 |   39 +-
 tools/power/cpupower/utils/cpufreq-set.c           |   11 +-
 tools/power/cpupower/utils/helpers/sysfs.c         |    2 +-
 .../cpupower/utils/idle_monitor/mperf_monitor.c    |    2 +-
 120 files changed, 5082 insertions(+), 1494 deletions(-)
