Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661Ab3D3NS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:18:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50800 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760624Ab3D3NSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:18:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management updates for v3.10-rc1
Date: Tue, 30 Apr 2013 15:26:36 +0200
Message-ID: <1851288.1ADVta7xRy@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.10-rc1

to receive ACPI and power management updates for v3.10 with top-most commit
371deb9500831ad1afbf9ea00e373f650deaed2f

  Merge branch 'pm-cpufreq'

on top of commit 60d509fa6a9c4653a86ad830e4c4b30360b23f0e

  Linux 3.9-rc8

The cpufreq changes are the largest batch this time, mostly due to
the Viresh Kumar's work on the core cleanup.  The feature most likely
to make some headlines is the ARM big.LITTLE cpufreq driver, also from
Viresh.

Next in size is the cpuidle update with the majority of work done by
Daniel Lazcano.  That is code consolidation and some cleanups mostly,
hopefully non-exciting stuff.

In addition to the above we have a usual ACPICA update containing
material from February and March releases, an update of the ACPI core
related to hotplug and a number of assorted fixes and cleanups in
ACPI and PM core.

Highlights:

- ARM big.LITTLE cpufreq driver from Viresh Kumar.

- exynos5440 cpufreq driver from Amit Daniel Kachhap.

- cpufreq core cleanup and code consolidation (several ARM drivers go
  to drivers/cpufreq among other things) from Viresh Kumar and
  Stratos Karafotis.

- cpufreq scalability improvement from Nathan Zimmer.

- AMD "frequency sensitivity feedback" powersave bias for the ondemand
  cpufreq governor from Jacob Shin.

- cpuidle code consolidation and cleanups from Daniel Lezcano.

- ARM OMAP cpuidle fixes from Santosh Shilimkar and Daniel Lezcano.

- ACPICA fixes and other improvements from Bob Moore, Jung-uk Kim,
  Lv Zheng, Yinghai Lu, Tang Chen, Colin Ian King, and Linn Crosetto.

- ACPI core updates related to hotplug from Toshi Kani, Paul Bolle,
  Yasuaki Ishimatsu, and yours truly.

- Intel Lynxpoint LPSS (Low-Power Subsystem) support improvements
  from myself and Andy Shevchenko.

Thanks!


---------------

Aaron Lu (2):
      acpi: video: enhance the quirk detect logic of _BQC
      ACPI: video: correct acpi_video_bus_add error processing

Alexandru Gheorghiu (2):
      ACPI / acpi_pad: Used PTR_RET
      ACPI: Use resource_size() in osl.c

Amit Daniel Kachhap (4):
      cpufreq: exynos: Add cpufreq driver for exynos5440
      cpufreq: exynos: Remove error return even if no soc is found
      arm: exynos: Enable OPP library support for exynos5440
      cpufreq: exynos5440: Protect OPP search calls with RCU lock

Andrei Epure (1):
      ACPI: replace kmalloc+memcpy with kmemdup

Andy Shevchenko (7):
      ACPI: suppress compiler warnings in button.c
      ACPI: suppress compiler warnings in processor_throttling.c
      ACPI: suppress compiler warning in battery.c
      ACPI: suppress compiler warning in container.c
      ACPI / LPSS: make code less confusing for reader
      isapnp: remove debug leftovers
      pnp: use %*phC to dump small buffers

Arnd Bergmann (1):
      cpufreq: pxa2xx: initialize variables

Bob Moore (19):
      ACPICA: Resource Mgr: Prevent infinite loops in resource walks
      ACPICA: Update error/debug messages for fixed events
      ACPICA: Add parens within macros around parameter names
      ACPICA: Update for ACPI 5 hardware-reduced feature
      ACPICA: Regression fix: reinstate safe exit macros
      ACPICA: Add macros to exception code definitions
      ACPICA: Add exception descriptions to exception info table
      ACPICA: Remove trailing comma in enum declarations
      ACPICA: Add mechanism for early object repairs on a per-name basis
      ACPICA: Split object conversion functions to a new file
      ACPICA: Disassembler: Add warnings for unresolved control methods
      ACPICA: Object repair: Allow 0-length packages for variable-length packages
      ACPICA: Update version to 20130214
      ACPICA: Predefine names: Add allowed argument types to master info table
      ACPICA: Improve error message for Index() operator
      ACPICA: Remove FORCE_DELETE option for global reference count mechanism
      ACPICA: Fix a format string for 64-bit generation
      ACPICA: Add a lock to the internal object reference count mechanism
      ACPICA: Update version to 20130328

Chen Gang (1):
      ARM: S5pv210: compiling issue, ARM_S5PV210_CPUFREQ needs CONFIG_CPU_FREQ_TABLE=y

Colin Ian King (4):
      ACPI / fan: avoid null pointer deference error
      ACPI / processor_thermal: avoid null pointer deference error
      ACPICA: Fix a typo in an error message
      ACPICA: Fix a typo in a function header, no functional change

Daniel Lezcano (45):
      cpuidle : handle clockevent notify from the cpuidle framework
      cpuidle / omap4 : use CPUIDLE_FLAG_TIMER_STOP flag
      cpuidle / imx6 : use CPUIDLE_FLAG_TIMER_STOP flag
      cpuidle / ux500 : use CPUIDLE_FLAG_TIMER_STOP flag
      cpuidle / kirkwood: remove redundant Kconfig option
      timer: move enum definition out of ifdef section
      cpuidle: initialize the broadcast timer framework
      cpuidle: ux500: remove timer broadcast initialization
      cpuidle: OMAP4: remove timer broadcast initialization
      cpuidle: imx6: remove timer broadcast initialization
      ARM: shmobile: pm: fix init sections
      ARM: shmobile: cpuidle: remove useless WFI function
      ARM: tegra2: cpuidle: change driver initialization
      ARM: tegra: cpuidle: remove useless initialization
      ARM: davinci: cpuidle: fix wrong enter function
      ARM: omap3: cpuidle: enable time keeping
      POWERPC: pseries: cpuidle: use time keeping flag
      ARM: omap3: cpuidle: enable time keeping
      intel_idle: remove stop/start critical timings
      SH: cpuidle: remove pointless initialization
      SH: cpuidle: remove CPUIDLE_DRIVER_STATE_START usage
      SH: cpuidle: initialize the driver's states directly
      SH: cpuidle: check error code at init
      ARM: shmobile: cpuidle: remove shmobile_enter_wfi function
      ARM: shmobile: cpuidle: remove shmobile_enter_wfi prototype
      ARM: OMAP3: remove cpuidle_wrap_enter
      cpuidle: remove en_core_tk_irqen flag
      ARM: ux500: cpuidle: replace for_each_online_cpu by for_each_possible_cpu
      cpuidle: make a single register function for all
      ARM: ux500: cpuidle: use init/exit common routine
      ARM: at91: cpuidle: use init/exit common routine
      ARM: OMAP3: cpuidle: use init/exit common routine
      ARM: tegra: cpuidle: use init/exit common routine
      ARM: shmobile: cpuidle: use init/exit common routine
      ARM: OMAP4: cpuidle: use init/exit common routine
      ARM: tegra: cpuidle: use init/exit common routine for tegra2
      ARM: tegra: cpuidle: use init/exit common routine for tegra3
      ARM: calxeda: cpuidle: use init/exit common routine
      ARM: kirkwood: cpuidle: use init/exit common routine
      ARM: davinci: cpuidle: use init/exit common routine
      ARM: imx: cpuidle: use init/exit common routine
      cpuidle: fix comment format
      SH: cpuidle: use init/exit common routine
      ARM: s3c64xx: cpuidle: use init/exit common routine
      cpuidle: add maintainer entry

Danny Baumann (3):
      ACPI / video: Fix brightness control initialization for some laptops.
      ACPI / video: Make logic a little easier to understand.
      ACPI / video: Fix applying indexed initial brightness value.

Gustavo Maciel Dias Vieira (1):
      ACPI video: ignore BIOS backlight value for HP dm4

Jacob Shin (2):
      cpufreq: ondemand: allow custom powersave_bias_target handler to be registered
      cpufreq: AMD "frequency sensitivity feedback" powersave bias for ondemand governor

Jung-uk Kim (4):
      ACPICA: Fix a couple warnings detected on FreeBSD build
      ACPICA: Fix a long-standing bug in local cache
      ACPICA: Add macros to access pointer to next object in the descriptor list
      ACPICA: _OSI Support: handle any errors from acpi_os_acquire_mutex()

Linn Crosetto (1):
      ACPICA: FADT: Remove extraneous warning for very large GPE registers

Lv Zheng (5):
      ACPICA: Update RASF table definition
      ACPICA: iASL/Disassembler: Add support for VRTC table
      ACPICA: iASL/Disassembler: Add support for MTMR table
      ACPICA: Return object repair: Add string-to-unicode conversion
      ACPICA: Return object repair: Add resource template repairs

Mats Fagerstrom (1):
      cpufreq: dbx500: Round to closest available freq

Namhyung Kim (2):
      cpufreq: conservative: Break out earlier on the lowest frequency
      cpufreq: conservative: Fix relation when decreasing frequency

Nathan Zimmer (2):
      cpufreq: Convert the cpufreq_driver_lock to a rwlock
      cpufreq: convert cpufreq_driver to using RCU

Nishanth Menon (2):
      PM / OPP: add documentation to RCU head in struct opp
      cpufreq: OMAP: instantiate omap-cpufreq as a platform_driver

Paul Bolle (2):
      acpi: remove reference to ACPI_HOTPLUG_IO
      ACPI: remove "config ACPI_DEBUG_FUNC_TRACE"

Rafael J. Wysocki (13):
      ACPI / scan: Introduce acpi_scan_match_handler()
      ACPI / scan: Introduce common code for ACPI-based device hotplug
      ACPI / container: Use common hotplug code
      ACPI / scan: Introduce acpi_scan_handler_matching()
      ACPI / hotplug: Introduce user space interface for hotplug profiles
      ACPI / container: Use hotplug profile user space interface
      ACPI / scan: Make memory hotplug driver use struct acpi_scan_handler
      ACPI / hotplug: Make acpi_hotplug_profile_ktype static
      ACPI / scan: Add special handler for Intel Lynxpoint LPSS devices
      ACPI / LPSS: Add support for exposing LTR registers to user space
      ACPI / PM: Fix potential problem in acpi_device_get_power()
      ACPI / PM: Expose lists of device wakeup power resources to user space
      cpufreq: Revert incorrect commit 5800043

Santosh Shilimkar (5):
      ARM: OMAP4: CPUidle: Avoid double idle driver registration
      ARM: OMAP: CPUidle: Unregister drivere on device registration failure
      ARM: OMAP4: CPUidle: Make C-state description field more precise
      ARM: OMAP4+: CPUidle: Deprecate use of omap4_mpuss_read_prev_context_state()
      ARM: OMAP4+: CPUidle: Consolidate idle driver for OMAP5 support

Silviu-Mihai Popescu (2):
      cpuidle: kirkwood: fix coccicheck warnings
      cpufreq: kirkwood: fix coccicheck warnings

Srinivas Pandruvada (1):
      cpufreq / intel_pstate: Optimize intel_pstate_set_policy

Stratos Karafotis (4):
      cpufreq: governors: Calculate iowait time only when necessary
      cpufreq: conservative: Fix sampling_down_factor functionality
      cpufreq: conservative: Fix the logic in frequency decrease checking
      cpufreq: conservative: Use an inline function to evaluate freq_target

Tang Chen (1):
      ACPICA: Fix for some comments/headers

Toshi Kani (6):
      ACPI: Remove acpi_pci_bind_root() definition
      ACPI: Remove acpi_device dependency in acpi_device_set_id()
      ACPI: Update PNPID set/free interfaces
      ACPI: Update PNPID match handling for notify
      ACPI: Update _OST handling for notify
      ACPI: Verify device status after eject

Ulf Hansson (3):
      PM / Runtime: Asyncronous idle|suspend devices at system resume
      PM / Runtime: Asyncronous idle|suspend parent devices at removal
      PM / Runtime: Improve prepare handling at system suspend for genpd

Viresh Kumar (36):
      cpufreq: Add per policy governor-init/exit infrastructure
      cpufreq: governor: Implement per policy instances of governors
      cpufreq: governor: Set MIN_LATENCY_MULTIPLIER to 20
      cpufreq: ondemand: Don't update sample_type if we don't evaluate load again
      cpufreq: governors: Avoid unnecessary per cpu timer interrupts
      cpufreq: cpu0: Fix mistake in Documentation example
      cpufreq: Documentation: Fix cpufreq_frequency_table name
      cpufreq: cpufreq-cpu0: No need to check cpu number in init()
      cpufreq: cpufreq-cpu0: Call CPUFREQ_POSTCHANGE notifier for failure cases too
      cpufreq: Notify all policy->cpus in cpufreq_notify_transition()
      cpufreq: Don't check if cpu is online/offline for cpufreq callbacks
      cpufreq: drivers: don't check range of target freq in .target()
      cpufreq: drivers: Remove unnecessary assignments of policy-> members
      cpufreq: ARM big LITTLE: Add generic cpufreq driver and its DT glue
      cpufreq: ARM: Arrange drivers in alphabetical order
      cpufreq: tegra: Move driver to drivers/cpufreq
      cpufreq: davinci: move cpufreq driver to drivers/cpufreq
      cpufreq: pxa3xx: move cpufreq driver to drivers/cpufreq
      cpufreq: pxa2xx: move cpufreq driver to drivers/cpufreq
      cpufreq: integrator: move cpufreq driver to drivers/cpufreq
      cpufreq: sa11x0: move cpufreq driver to drivers/cpufreq
      cpufreq: AVR32: move cpufreq driver to drivers/cpufreq
      cpufreq: blackfin: move cpufreq driver to drivers/cpufreq
      cpufreq: cris: move cpufreq driver to drivers/cpufreq
      cpufreq: ia64: move cpufreq driver to drivers/cpufreq
      cpufreq: mips: move cpufreq driver to drivers/cpufreq
      cpufreq: sh: move cpufreq driver to drivers/cpufreq
      cpufreq: unicore2: move cpufreq driver to drivers/cpufreq
      cpufreq: sparc: move cpufreq driver to drivers/cpufreq
      cpufreq: powerpc/platforms/cell: move cpufreq driver to drivers/cpufreq
      cpufreq: Call __cpufreq_governor() with correct policy->cpus mask
      cpufreq: Don't call __cpufreq_governor() for drivers without target()
      cpufreq: ARM big LITTLE: put DT nodes after using them
      cpufreq: ARM big LITTLE: Adapt to latest cpufreq updates
      cpufreq: cpu0: Put cpu parent node after using it
      cpufreq: MAINTAINERS: Add co-maintainer

Wang YanQing (1):
      ACPI: Fix wrong parameter passed to memblock_reserve

Yasuaki Ishimatsu (2):
      ACPI / memhotplug: set info->enabled for memory present at boot time
      ACPI / memhotplug: Remove info->failed bit

Yinghai Lu (2):
      ACPI: Set length even for TYPE_END_TAG acpi resource
      PCI / ACPI: Don't query OSC support with all possible controls

Zhang Rui (4):
      PM / sleep: add TEST_PLATFORM support for freeze state
      PM / sleep: invalidate TEST_CPUS and TEST_CORE support for freeze state
      ACPI: update comments for acpi_event_status
      ACPI / thermal: do not always return THERMAL_TREND_RAISING for active trip points

jhbird.choi@samsung.com (1):
      cpufreq: Fix unsigned variable being checked for negative value

---------------

 Documentation/ABI/testing/sysfs-devices-lpss_ltr        |   44 +
 .../ABI/testing/sysfs-devices-power_resources_wakeup    |   13 +
 Documentation/ABI/testing/sysfs-firmware-acpi           |   26 +
 Documentation/cpu-freq/cpu-drivers.txt                  |    9 +-
 Documentation/cpu-freq/governors.txt                    |   27 +
 Documentation/cpuidle/driver.txt                        |    6 +
 .../devicetree/bindings/cpufreq/arm_big_little_dt.txt   |   65 ++
 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt        |    2 +-
 .../devicetree/bindings/cpufreq/cpufreq-exynos5440.txt  |   28 +
 MAINTAINERS                                             |   22 +
 arch/arm/Kconfig                                        |   25 -
 arch/arm/configs/kirkwood_defconfig                     |    1 -
 arch/arm/mach-at91/cpuidle.c                            |   18 +-
 arch/arm/mach-davinci/Makefile                          |    1 -
 arch/arm/mach-davinci/cpuidle.c                         |   29 +-
 arch/arm/mach-exynos/Kconfig                            |    2 +
 arch/arm/mach-exynos/cpuidle.c                          |    1 -
 arch/arm/mach-imx/Makefile                              |    2 +-
 arch/arm/mach-imx/cpufreq.c                             |    8 +-
 arch/arm/mach-imx/cpuidle-imx5.c                        |   37 +
 arch/arm/mach-imx/cpuidle-imx6q.c                       |   26 +-
 arch/arm/mach-imx/cpuidle.c                             |   80 --
 arch/arm/mach-imx/cpuidle.h                             |   10 +-
 arch/arm/mach-imx/pm-imx5.c                             |   30 +-
 arch/arm/mach-integrator/Makefile                       |    1 -
 arch/arm/mach-omap2/common.h                            |    5 -
 arch/arm/mach-omap2/cpuidle34xx.c                       |   52 +-
 arch/arm/mach-omap2/cpuidle44xx.c                       |   84 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c               |   14 -
 arch/arm/mach-omap2/pm.c                                |    9 +
 arch/arm/mach-pxa/Makefile                              |    6 -
 arch/arm/mach-pxa/include/mach/generic.h                |    1 +
 arch/arm/mach-s3c24xx/cpufreq.c                         |    8 +-
 arch/arm/mach-s3c64xx/cpuidle.c                         |   15 +-
 arch/arm/mach-sa1100/Kconfig                            |   26 +-
 arch/arm/mach-sa1100/Makefile                           |    3 -
 arch/arm/mach-sa1100/include/mach/generic.h             |    1 +
 arch/arm/mach-shmobile/cpuidle.c                        |   23 +-
 arch/arm/mach-shmobile/include/mach/common.h            |    3 -
 arch/arm/mach-shmobile/pm-sh7372.c                      |    6 +-
 arch/arm/mach-tegra/Makefile                            |    1 -
 arch/arm/mach-tegra/cpuidle-tegra114.c                  |   28 +-
 arch/arm/mach-tegra/cpuidle-tegra20.c                   |   72 +-
 arch/arm/mach-tegra/cpuidle-tegra30.c                   |   29 +-
 arch/arm/mach-ux500/cpuidle.c                           |   58 +-
 arch/avr32/Kconfig                                      |   13 -
 arch/avr32/configs/atngw100_defconfig                   |    2 +-
 arch/avr32/configs/atngw100_evklcd100_defconfig         |    2 +-
 arch/avr32/configs/atngw100_evklcd101_defconfig         |    2 +-
 arch/avr32/configs/atngw100_mrmt_defconfig              |    2 +-
 arch/avr32/configs/atngw100mkii_defconfig               |    2 +-
 arch/avr32/configs/atngw100mkii_evklcd100_defconfig     |    2 +-
 arch/avr32/configs/atngw100mkii_evklcd101_defconfig     |    2 +-
 arch/avr32/configs/atstk1002_defconfig                  |    2 +-
 arch/avr32/configs/atstk1003_defconfig                  |    2 +-
 arch/avr32/configs/atstk1004_defconfig                  |    2 +-
 arch/avr32/configs/atstk1006_defconfig                  |    2 +-
 arch/avr32/configs/favr-32_defconfig                    |    2 +-
 arch/avr32/configs/hammerhead_defconfig                 |    2 +-
 arch/avr32/configs/mimc200_defconfig                    |    2 +-
 arch/avr32/mach-at32ap/Makefile                         |    1 -
 arch/blackfin/mach-common/Makefile                      |    1 -
 arch/cris/arch-v32/mach-a3/Makefile                     |    1 -
 arch/cris/arch-v32/mach-fs/Makefile                     |    1 -
 arch/ia64/Kconfig                                       |    6 +-
 arch/ia64/kernel/Makefile                               |    1 -
 arch/ia64/kernel/cpufreq/Kconfig                        |   29 -
 arch/ia64/kernel/cpufreq/Makefile                       |    2 -
 arch/mips/Kconfig                                       |    9 +-
 arch/mips/kernel/Makefile                               |    2 -
 arch/mips/kernel/cpufreq/Kconfig                        |   41 -
 arch/mips/kernel/cpufreq/Makefile                       |    5 -
 arch/powerpc/platforms/cell/Kconfig                     |   26 +-
 arch/powerpc/platforms/cell/Makefile                    |    3 -
 arch/powerpc/platforms/pasemi/cpufreq.c                 |    5 +-
 arch/powerpc/platforms/powermac/cpufreq_32.c            |   14 +-
 arch/powerpc/platforms/powermac/cpufreq_64.c            |    5 +-
 arch/powerpc/platforms/pseries/processor_idle.c         |   34 +-
 arch/sh/Kconfig                                         |   18 -
 arch/sh/include/asm/suspend.h                           |    4 +-
 arch/sh/kernel/Makefile                                 |    1 -
 arch/sh/kernel/cpu/shmobile/cpuidle.c                   |  101 +-
 arch/sh/kernel/cpu/shmobile/pm.c                        |    3 +-
 arch/sparc/Kconfig                                      |   23 -
 arch/sparc/kernel/Makefile                              |    3 -
 arch/unicore32/kernel/Makefile                          |    1 -
 arch/x86/include/asm/cpufeature.h                       |    1 +
 arch/x86/kernel/apm_32.c                                |    1 -
 arch/x86/kernel/cpu/scattered.c                         |    3 +-
 drivers/acpi/Kconfig                                    |   13 +-
 drivers/acpi/Makefile                                   |    1 +
 drivers/acpi/acpi_lpss.c                                |  292 +++++
 drivers/acpi/acpi_memhotplug.c                          |  328 +-----
 drivers/acpi/acpi_pad.c                                 |    2 +-
 drivers/acpi/acpi_platform.c                            |   40 +-
 drivers/acpi/acpica/Makefile                            |    2 +
 drivers/acpi/acpica/acglobal.h                          |    5 +-
 drivers/acpi/acpica/aclocal.h                           |   29 +-
 drivers/acpi/acpica/acmacros.h                          |    6 +-
 drivers/acpi/acpica/acnamesp.h                          |   29 +-
 drivers/acpi/acpica/acpredef.h                          | 1305 ++++++++++++++++-------
 drivers/acpi/acpica/acutils.h                           |   28 +-
 drivers/acpi/acpica/dsutils.c                           |   10 +-
 drivers/acpi/acpica/dswexec.c                           |    2 +-
 drivers/acpi/acpica/evevent.c                           |   12 +-
 drivers/acpi/acpica/evgpe.c                             |    6 +-
 drivers/acpi/acpica/evsci.c                             |    4 +-
 drivers/acpi/acpica/evxface.c                           |   21 +-
 drivers/acpi/acpica/evxfevnt.c                          |   12 +
 drivers/acpi/acpica/exoparg2.c                          |   11 +-
 drivers/acpi/acpica/exprep.c                            |    4 +-
 drivers/acpi/acpica/exutils.c                           |    4 +-
 drivers/acpi/acpica/hwacpi.c                            |   20 +-
 drivers/acpi/acpica/nsconvert.c                         |  443 ++++++++
 drivers/acpi/acpica/nseval.c                            |   26 +-
 drivers/acpi/acpica/nspredef.c                          |  213 +---
 drivers/acpi/acpica/nsprepkg.c                          |   10 +-
 drivers/acpi/acpica/nsrepair.c                          |  381 +++----
 drivers/acpi/acpica/nsrepair2.c                         |   16 +-
 drivers/acpi/acpica/nsutils.c                           |    8 +-
 drivers/acpi/acpica/psargs.c                            |    2 +-
 drivers/acpi/acpica/rscalc.c                            |    6 +
 drivers/acpi/acpica/rsdump.c                            |    8 +
 drivers/acpi/acpica/rslist.c                            |    8 +
 drivers/acpi/acpica/rsxface.c                           |    8 +-
 drivers/acpi/acpica/tbfadt.c                            |    4 +
 drivers/acpi/acpica/tbxface.c                           |   22 +-
 drivers/acpi/acpica/utaddress.c                         |    4 +-
 drivers/acpi/acpica/utcache.c                           |   18 +-
 drivers/acpi/acpica/utdelete.c                          |   96 +-
 drivers/acpi/acpica/utexcep.c                           |   26 +-
 drivers/acpi/acpica/utglobal.c                          |    2 +
 drivers/acpi/acpica/utmutex.c                           |    9 +-
 drivers/acpi/acpica/utosi.c                             |   26 +-
 drivers/acpi/acpica/utpredef.c                          |  399 +++++++
 drivers/acpi/acpica/utxface.c                           |   17 +-
 drivers/acpi/battery.c                                  |    2 +-
 drivers/acpi/bus.c                                      |    5 +-
 drivers/acpi/button.c                                   |    1 +
 drivers/acpi/container.c                                |  152 +--
 drivers/acpi/device_pm.c                                |   39 +-
 drivers/acpi/fan.c                                      |    8 +-
 drivers/acpi/internal.h                                 |   21 +-
 drivers/acpi/osl.c                                      |    4 +-
 drivers/acpi/pci_link.c                                 |    1 +
 drivers/acpi/pci_root.c                                 |    4 +-
 drivers/acpi/power.c                                    |   60 +-
 drivers/acpi/processor_idle.c                           |    1 -
 drivers/acpi/processor_thermal.c                        |   24 +-
 drivers/acpi/processor_throttling.c                     |    3 +-
 drivers/acpi/scan.c                                     |  531 ++++++---
 drivers/acpi/sysfs.c                                    |   66 ++
 drivers/acpi/thermal.c                                  |   16 +-
 drivers/acpi/video.c                                    |  318 +++---
 drivers/acpi/video_detect.c                             |   25 +-
 drivers/base/power/domain.c                             |    6 +-
 drivers/base/power/generic_ops.c                        |    2 +-
 drivers/base/power/main.c                               |    2 +-
 drivers/base/power/opp.c                                |    1 +
 drivers/base/power/runtime.c                            |    2 +-
 drivers/clk/x86/Makefile                                |    2 +-
 drivers/clk/x86/clk-lpss.c                              |   99 --
 drivers/clk/x86/clk-lpss.h                              |   36 -
 drivers/clk/x86/clk-lpt.c                               |   40 +-
 drivers/cpufreq/Kconfig                                 |   89 ++
 drivers/cpufreq/Kconfig.arm                             |  148 ++-
 drivers/cpufreq/Kconfig.powerpc                         |   18 +
 drivers/cpufreq/Kconfig.x86                             |   17 +
 drivers/cpufreq/Makefile                                |   41 +-
 drivers/cpufreq/acpi-cpufreq.c                          |   11 +-
 drivers/cpufreq/amd_freq_sensitivity.c                  |  148 +++
 drivers/cpufreq/arm_big_little.c                        |  278 +++++
 drivers/cpufreq/arm_big_little.h                        |   40 +
 drivers/cpufreq/arm_big_little_dt.c                     |  107 ++
 .../cpufreq.c => drivers/cpufreq/at32ap-cpufreq.c       |    5 +-
 .../cpufreq.c => drivers/cpufreq/blackfin-cpufreq.c     |   79 +-
 drivers/cpufreq/cpufreq-cpu0.c                          |   32 +-
 drivers/cpufreq/cpufreq-nforce2.c                       |   11 +-
 drivers/cpufreq/cpufreq.c                               |  145 ++-
 drivers/cpufreq/cpufreq_conservative.c                  |  244 +++--
 drivers/cpufreq/cpufreq_governor.c                      |  291 +++--
 drivers/cpufreq/cpufreq_governor.h                      |  128 ++-
 drivers/cpufreq/cpufreq_ondemand.c                      |  363 ++++---
 .../cpufreq.c => drivers/cpufreq/cris-artpec3-cpufreq.c |   20 +-
 .../cpufreq.c => drivers/cpufreq/cris-etraxfs-cpufreq.c |   17 +-
 .../cpufreq.c => drivers/cpufreq/davinci-cpufreq.c      |   35 +-
 drivers/cpufreq/dbx500-cpufreq.c                        |   22 +-
 drivers/cpufreq/e_powersaver.c                          |   11 +-
 drivers/cpufreq/elanfreq.c                              |   10 +-
 drivers/cpufreq/exynos-cpufreq.c                        |    9 +-
 drivers/cpufreq/exynos5440-cpufreq.c                    |  481 +++++++++
 drivers/cpufreq/gx-suspmod.c                            |   11 +-
 .../cpufreq/ia64-acpi-cpufreq.c                         |   23 +-
 drivers/cpufreq/imx6q-cpufreq.c                         |   12 +-
 .../cpu.c => drivers/cpufreq/integrator-cpufreq.c       |    8 +-
 drivers/cpufreq/intel_pstate.c                          |   21 +-
 drivers/cpufreq/kirkwood-cpufreq.c                      |   18 +-
 drivers/cpufreq/longhaul.c                              |   18 +-
 .../mips/kernel => drivers}/cpufreq/loongson2_cpufreq.c |   11 +-
 drivers/cpufreq/maple-cpufreq.c                         |    5 +-
 drivers/cpufreq/omap-cpufreq.c                          |   34 +-
 drivers/cpufreq/p4-clockmod.c                           |   13 +-
 drivers/cpufreq/pcc-cpufreq.c                           |    5 +-
 drivers/cpufreq/powernow-k6.c                           |   12 +-
 drivers/cpufreq/powernow-k7.c                           |   10 +-
 drivers/cpufreq/powernow-k8.c                           |   19 +-
 .../cbe_cpufreq.c => drivers/cpufreq/ppc_cbe_cpufreq.c  |    8 +-
 .../cbe_cpufreq.h => drivers/cpufreq/ppc_cbe_cpufreq.h  |    4 +-
 .../cpufreq/ppc_cbe_cpufreq_pervasive.c                 |    2 +-
 .../cpufreq/ppc_cbe_cpufreq_pmi.c                       |    2 +-
 .../cpufreq/pxa2xx-cpufreq.c                            |   12 +-
 .../cpufreq/pxa3xx-cpufreq.c                            |   10 +-
 drivers/cpufreq/s3c2416-cpufreq.c                       |    5 +-
 drivers/cpufreq/s3c64xx-cpufreq.c                       |    7 +-
 drivers/cpufreq/s5pv210-cpufreq.c                       |    5 +-
 .../cpu-sa1100.c => drivers/cpufreq/sa1100-cpufreq.c    |    8 +-
 .../cpu-sa1110.c => drivers/cpufreq/sa1110-cpufreq.c    |    8 +-
 drivers/cpufreq/sc520_freq.c                            |   10 +-
 .../sh/kernel/cpufreq.c => drivers/cpufreq/sh-cpufreq.c |   22 +-
 .../cpufreq/sparc-us2e-cpufreq.c                        |   19 +-
 .../cpufreq/sparc-us3-cpufreq.c                         |   19 +-
 drivers/cpufreq/spear-cpufreq.c                         |    7 +-
 drivers/cpufreq/speedstep-centrino.c                    |   28 +-
 drivers/cpufreq/speedstep-ich.c                         |   12 +-
 drivers/cpufreq/speedstep-smi.c                         |    5 +-
 .../cpu-tegra.c => drivers/cpufreq/tegra-cpufreq.c      |   17 +-
 .../cpu-ucv2.c => drivers/cpufreq/unicore2-cpufreq.c    |    7 +-
 drivers/cpuidle/Kconfig                                 |    6 -
 drivers/cpuidle/Makefile                                |    2 +-
 drivers/cpuidle/cpuidle-calxeda.c                       |   57 +-
 drivers/cpuidle/cpuidle-kirkwood.c                      |   29 +-
 drivers/cpuidle/cpuidle.c                               |  153 ++-
 drivers/cpuidle/driver.c                                |   31 +-
 drivers/gpu/drm/i915/intel_opregion.c                   |    4 +-
 drivers/idle/intel_idle.c                               |    4 -
 drivers/platform/x86/sony-laptop.c                      |    3 +-
 drivers/pnp/isapnp/core.c                               |   11 -
 drivers/pnp/pnpacpi/rsparser.c                          |    1 +
 drivers/pnp/pnpbios/proc.c                              |    5 +-
 include/acpi/acexcep.h                                  |  461 ++++----
 include/acpi/acoutput.h                                 |   53 +-
 include/acpi/acpi_bus.h                                 |   33 +-
 include/acpi/acpi_drivers.h                             |    1 -
 include/acpi/acpixf.h                                   |    2 +-
 include/acpi/actbl2.h                                   |   47 +
 include/acpi/actbl3.h                                   |   55 +-
 include/acpi/actypes.h                                  |   16 +-
 include/linux/acpi.h                                    |    4 +-
 include/linux/clockchips.h                              |   32 +-
 include/linux/cpufreq.h                                 |   21 +-
 include/linux/cpuidle.h                                 |   23 +-
 include/linux/platform_data/clk-lpss.h                  |   18 +
 kernel/power/suspend.c                                  |   22 +-
 253 files changed, 6938 insertions(+), 4145 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
