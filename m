Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaAQNvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:51:04 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55268 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751056AbaAQNu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:50:59 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
Subject: ACPI and PM queue for 3.14-rc1
Date: Fri, 17 Jan 2014 15:05 +0100
Message-ID: <9611657.SoJ0jfOqMZ@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Everybody,

Below is the log of changes I have queued up for the first ACPI and power
management pull request for 3.14-rc1.

If you have posted something in the last minute in the hope it will make
it to that list, I have to disappoint you: It won't.  If that is a fix,
it may be pushed in the second half of the merge window if there's enough
time for that or later during the cycle.  If that is not a fix, I'm afraid
it will have to wait for the 3.15 merge window.

Please let me know if there's anything I have missed or anything I should
drop or revert.

Kind regards,
Rafael


---------------

Al Stone (3):
      ACPI: remove trailing whitespace
      ACPI: correct minor typos
      ACPI / processor: initialize a variable to silence compiler warning

Anson Huang (1):
      cpufreq: imx6q: correct VDDSOC/PU voltage scaling when cpufreq is changed

Bartlomiej Zolnierkiewicz (7):
      ARM: EXYNOS: cpuidle: fix AFTR mode check
      POWERPC: pseries: cpuidle: remove superfluous dev->state_count initialization
      POWERPC: pseries: cpuidle: use the common cpuidle_[un]register() routines
      ACPI / cpuidle: fix max idle state handling with hotplug CPU support
      ACPI / cpuidle: remove dev->state_count setting
      intel_idle: do C1E promotion disable quirk for hotplugged CPUs
      intel_idle: remove superfluous dev->state_count initialization

Ben Dooks (3):
      PM / clock_ops: fix up clk prepare/unprepare count
      PM / clock_ops: check return of clk_enable() in pm_clk_resume()
      PM / clock_ops: report clock errors from clk_enable()

Betty Dall (1):
      ACPICA: Add helper macros to extract bus/segment numbers from HEST table.

Bin Shi (1):
      apm-emulation: add hibernation APM events to support suspend2disk

Bjørn Mork (1):
      PM / hibernate: Call platform_leave() in suspend path too

Bob Moore (14):
      ACPICA: Debug output: Fix a couple of small output issues.
      ACPICA: Disassembler: Improve pathname support for emitted External() statements.
      ACPICA: Add option to favor 32-bit FADT addresses.
      ACPICA: Tables: Add full support for the DBG2 table.
      ACPICA: Tables: Add full support for the PCCT table, update table definition.
      ACPICA: Improve exception handling for GPE block installation.
      ACPICA: Update several debug statements - no functional change.
      ACPICA: Enhance ACPI warning for memory/IO address conflicts.
      ACPICA: Parser: Updates/fixes for debug output.
      ACPICA: Conditionally define a local variable that is used for debug only.
      ACPICA: Add an error message if the Debugger fails initialization.
      ACPICA: Update ACPI example code to make it an actual working program.
      ACPICA: Interpreter: Add additional debug info for an error case.
      ACPICA: Update version to 20131218.

Dirk Brandewie (3):
      intel_pstate: Add setting voltage value for baytrail P states.
      intel_pstate: Remove periodic P state boost
      intel_pstate: Add trace point to report internal state.

Dmitry Torokhov (2):
      PNPACPI: check return value of pnp_add_device()
      PNPBIOS: check return value of pnp_add_device()

Emil Goode (1):
      ACPI / thermal: remove const from thermal_zone_device_ops declaration

Hanjun Guo (3):
      ACPI / table: Replace '1' with specific error return values
      ACPI / dock: Drop redundant acpi_disabled check
      ACPI / sleep: Drop redundant acpi_disabled check

Jane Li (1):
      cpufreq: Fix timer/workqueue corruption by protecting reading governor_enabled

Jiang Liu (13):
      ACPI: introduce helper interfaces for _DSM method
      PCI / pci-label: release allocated ACPI object on error recovery path
      ACPI / PCI: replace open-coded _DSM code with helper functions
      PCI / pci-label: treat PCI label with index 0 as valid label
      ACPI / TPM: match node name instead of full path when searching for TPM device
      ACPI / TPM: replace open-coded _DSM code with helper functions
      ACPI / TPM: detect PPI features by checking availability of _DSM functions
      ACPI / i2c-hid: replace open-coded _DSM code with helper functions
      ACPI / i915: replace open-coded _DSM code with helper functions
      nouveau / ACPI: fix memory leak in ACPI _DSM related code
      ACPI / nouveau: replace open-coded _DSM code with helper functions
      ACPI / extlog: replace open-coded _DSM code with helper functions
      ACPI / scan: bail out early if failed to parse APIC ID for CPU

John Tobias (1):
      cpufreq: imx6q: add of_init_opp_table

Lan Tianyu (3):
      ACPI / processor: use ACPI_COMPANION() to get ACPI device
      ACPI / Button: Fix enabling button GPEs twice
      ACPI / EC: disable GPE before removing GPE handler

Lee, Chun-Yi (1):
      ACPI / init: Run acpi_early_init() before timekeeping_init()

Leonardo Potenza (1):
      PM / hibernate: export hibernation_set_ops

Levente Kurusa (1):
      PNP / card: add missing put_device() call

Lukasz Majewski (8):
      cpufreq: exynos: Convert exynos-cpufreq to platform driver
      cpufreq: Add boost frequency support in core
      acpi-cpufreq: Adjust the code to use the common boost attribute
      cpufreq / boost: Kconfig: Support for software-managed BOOST
      cpufreq: exynos: Extend Exynos cpufreq driver to support boost
      Documentation: cpufreq / boost: Update BOOST documentation
      cpufreq: exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ
      thermal: exynos: boost: Automatic enable/disable of BOOST feature (at Exynos4412)

Lv Zheng (14):
      ACPI: Clean up inclusions of ACPI header files
      ACPI: Clean up incorrect inclusion of an ACPICA header
      SFI / ACPI: Fix warnings reported during builds with W=1
      ACPI / i915: Fix incorrect <acpi/acpi.h> inclusions via <linux/acpi_io.h>
      ACPI / IBFT: Fix incorrect <acpi/acpi.h> inclusion in iSCSI boot firmware module
      ACPICA: Remove unused ACPI_FREE_BUFFER macro. No functional change.
      ACPICA: Linux Header: Remove unused OSL prototypes.
      ACPICA: Back port and refine validation of the XSDT root table.
      ACPICA: Cleanup the option of forcing the use of the RSDT.
      ACPICA: Linuxize: Cleanup spaces after special macro invocations.
      ACPICA: Utilities: Cleanup declarations of the acpi_gbl_debug_file global.
      ACPICA: acpidump: Cleanup tools/power/acpi makefiles.
      ACPICA: acpidump: Enable tools Makefile to include acpi tools.
      ACPICA: acpidump: Update MAINTAINERS file to include tools folder for ACPI/ACPICA.

Mark Brown (2):
      cpufreq: Make ARM big.LITTLE switcher depend on ARM
      cpufreq: Select PM_OPP rather than depending on it

Masanari Iida (1):
      ACPI / video: Fix typo in video_detect.c

Mikulas Patocka (3):
      powernow-k6: disable cache when changing frequency
      powernow-k6: correctly initialize default parameters
      powernow-k6: reorder frequencies

Oliver Neukum (1):
      ACPI / sleep: remove panic in case hardware has changed after S4

One Thousand Gnomes (1):
      cpupower: Fix sscanf robustness in cpufreq-set

Paul Bolle (1):
      cpufreq: speedstep: remove unused speedstep_get_state

Paul Walmsley (2):
      cpufreq: cpufreq-cpu0: clk_round_rate() can return a zero upon error
      cpufreq: SPEAr: clk_round_rate() can return a zero upon error

Prarit Bhargava (1):
      ACPI / memhotplug: add parameter to disable memory hotplug

Rafael J. Wysocki (19):
      ACPI / scan: Define non-empty device removal handler
      ACPI / scan: Add acpi_device objects for all device nodes in the namespace
      ACPI / hotplug: Do not fail bus and device checks for disabled hotplug
      ACPI / hotplug: Introduce common hotplug function acpi_device_hotplug()
      ACPI / hotplug: Make ACPI PCI root hotplug use common hotplug code
      ACPI / hotplug: Move container-specific code out of the core
      ACPI / hotplug: Rework generic code to handle suprise removals
      ACPI / hotplug: Drop unfinished global notification handling routines
      ACPI: Introduce acpi_set_device_status()
      ACPI / scan: Use direct recurrence for device hierarchy walks
      ACPI / bind: Simplify child device lookups
      PCI / ACPI: Use acpi_find_child_device() for child devices lookup
      ACPI / bind: Redefine acpi_get_child()
      ACPI / bind: Redefine acpi_preset_companion()
      ACPI / bind: Rework struct acpi_bus_type
      ACPI / bind: Pass struct acpi_device pointer to acpi_bind_one()
      ACPI / bind: Move acpi_get_child() to drivers/ide/ide-acpi.c
      ACPI / hotplug: Add demand_offline hotplug profile flag
      ACPI / hotplug / driver core: Handle containers in a special way

Ramkumar Ramachandra (2):
      Documentation / cpufreq: add intel-pstate.txt
      Documentation: add ABI entry for intel_pstate

Rashika Kheria (9):
      ACPI / OSL: Mark the function acpi_table_checksum() as static
      ACPI / NVS: Include appropriate header file in nvs.c
      ACPI / EC: Mark the function acpi_ec_add_debugfs() as static in ec_sys.c
      ACPI / PCI: Include appropriate header file in pci_slot.c
      ACPI / PCI: Include appropriate header file in pci_link.c
      ACPI / dock: Include appropriate header file in dock.c
      ACPI / EC: Remove unused functions and add prototype declaration in internal.h
      ACPI / proc: Include appropriate header file in proc.c
      PNP: Mark the function pnp_build_option() as static in resource.c

Sachin Kamat (4):
      cpufreq: s3c2440: Remove hardware.h inclusion
      cpufreq: s3c2440: Staticize local variables
      cpufreq: s3c24xx: Staticize local variable
      cpufreq: exynos5250: Set APLL rate using CCF API

Shawn Guo (1):
      cpufreq: imx6q-cpufreq driver is reused on i.MX6 series SoCs

Srinivas Pandruvada (1):
      ACPI / scan: ACPI device object sysfs attribute for _STA evaluation

Tang Chen (2):
      ACPI / tables: Check if id is NULL in acpi_table_parse()
      ACPI / tables: Return proper error codes from acpi_table_parse() and fix comment.

Takashi Iwai (1):
      ACPI: Blacklist Win8 OSI for some HP laptop 2013 models

Todd E Brandt (1):
      PM / tools: new tool for suspend/resume performance optimization

Ulf Hansson (3):
      PM / Sleep: Add macro to define common late/early system PM callbacks
      PM / Runtime: Add second macro for definition of runtime PM callbacks
      PM / Runtime: Implement the pm_generic_runtime functions for CONFIG_PM

Viresh Kumar (11):
      cpufreq: arm-big-little: Make driver dependent on CONFIG_BIG_LITTLE
      cpufreq: Introduce cpufreq_notify_post_transition()
      cpufreq: send new set of notification for transition failures
      cpufreq: Mark ARM drivers with CPUFREQ_NEED_INITIAL_FREQ_CHECK flag
      cpufreq: Make sure CPU is running on a freq from freq-table
      cpufreq: stats: handle cpufreq_unregister_driver() and suspend/resume properly
      cpufreq: stats: remove hotplug notifiers
      cpufreq: stats: free table and remove sysfs entry in a single routine
      cpufreq: stats: create sysfs entries when cpufreq_stats is a module
      ARM: SA1100: Create dummy clk_get_rate() to avoid build failures
      cpufreq: introduce cpufreq_generic_get() routine

Zhang Rui (4):
      ACPI: fix create_modalias() return value handling
      ACPI: add module autoloading support for ACPI enumerated devices
      ACPI: fix module autoloading for ACPI enumerated devices
      platform: introduce OF style 'modalias' support for platform bus

---------------

 Documentation/ABI/testing/sysfs-devices-system-cpu |   24 +
 Documentation/acpi/namespace.txt                   |    9 +-
 Documentation/cpu-freq/boost.txt                   |   26 +-
 Documentation/cpu-freq/intel-pstate.txt            |   40 +
 Documentation/kernel-parameters.txt                |    3 +
 MAINTAINERS                                        |    2 +
 arch/arm/mach-exynos/common.c                      |    5 +
 arch/arm/mach-exynos/common.h                      |    1 +
 arch/arm/mach-exynos/cpuidle.c                     |    8 +-
 arch/arm/mach-exynos/mach-exynos4-dt.c             |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    1 +
 arch/arm/mach-sa1100/clock.c                       |    7 +
 arch/ia64/hp/common/aml_nfw.c                      |    3 +-
 arch/ia64/kernel/acpi.c                            |    1 -
 arch/powerpc/platforms/pseries/processor_idle.c    |   59 +-
 arch/x86/kernel/acpi/boot.c                        |    3 +-
 arch/x86/kernel/apic/apic_flat_64.c                |    4 +-
 arch/x86/kernel/apic/io_apic.c                     |    3 -
 arch/x86/pci/mmconfig-shared.c                     |    1 -
 arch/x86/pci/mmconfig_32.c                         |    1 -
 arch/x86/platform/olpc/olpc-xo15-sci.c             |    3 +-
 drivers/acpi/ac.c                                  |    3 +-
 drivers/acpi/acpi_extlog.c                         |   62 +-
 drivers/acpi/acpi_memhotplug.c                     |   27 +-
 drivers/acpi/acpi_pad.c                            |    3 +-
 drivers/acpi/acpi_processor.c                      |   26 +-
 drivers/acpi/acpica/acdebug.h                      |    1 -
 drivers/acpi/acpica/acevents.h                     |    9 +-
 drivers/acpi/acpica/acglobal.h                     |   30 +
 drivers/acpi/acpica/aclocal.h                      |    9 +-
 drivers/acpi/acpica/dsfield.c                      |    2 +-
 drivers/acpi/acpica/dsutils.c                      |   19 +-
 drivers/acpi/acpica/dswload.c                      |    4 +-
 drivers/acpi/acpica/evgpeblk.c                     |    8 +-
 drivers/acpi/acpica/evgpeutil.c                    |   24 +-
 drivers/acpi/acpica/exresnte.c                     |    3 +-
 drivers/acpi/acpica/nsxfeval.c                     |   23 +-
 drivers/acpi/acpica/psopinfo.c                     |   51 +-
 drivers/acpi/acpica/tbfadt.c                       |  335 +++--
 drivers/acpi/acpica/tbutils.c                      |  214 +--
 drivers/acpi/acpica/utaddress.c                    |   19 +-
 drivers/acpi/acpica/utalloc.c                      |   10 +-
 drivers/acpi/acpica/utcache.c                      |   12 +-
 drivers/acpi/acpica/utdebug.c                      |    4 +-
 drivers/acpi/acpica/utglobal.c                     |    4 -
 drivers/acpi/acpica/utxfinit.c                     |   12 +-
 drivers/acpi/apei/apei-base.c                      |    1 -
 drivers/acpi/apei/apei-internal.h                  |    1 -
 drivers/acpi/apei/einj.c                           |    1 -
 drivers/acpi/apei/ghes.c                           |    1 -
 drivers/acpi/battery.c                             |    3 +-
 drivers/acpi/blacklist.c                           |   51 +-
 drivers/acpi/bus.c                                 |   77 +-
 drivers/acpi/button.c                              |   21 +-
 drivers/acpi/container.c                           |   55 +-
 drivers/acpi/custom_method.c                       |    2 +-
 drivers/acpi/debugfs.c                             |    2 +-
 drivers/acpi/device_pm.c                           |   22 +-
 drivers/acpi/dock.c                                |   16 +-
 drivers/acpi/ec.c                                  |   32 +-
 drivers/acpi/ec_sys.c                              |    2 +-
 drivers/acpi/event.c                               |    2 +-
 drivers/acpi/fan.c                                 |    3 +-
 drivers/acpi/glue.c                                |  165 +--
 drivers/acpi/hed.c                                 |    2 -
 drivers/acpi/internal.h                            |   19 +-
 drivers/acpi/numa.c                                |    1 -
 drivers/acpi/nvs.c                                 |    3 +-
 drivers/acpi/osl.c                                 |   14 +-
 drivers/acpi/pci_irq.c                             |    2 -
 drivers/acpi/pci_link.c                            |    4 +-
 drivers/acpi/pci_root.c                            |  126 +-
 drivers/acpi/pci_slot.c                            |    1 +
 drivers/acpi/power.c                               |    3 +-
 drivers/acpi/proc.c                                |    5 +-
 drivers/acpi/processor_core.c                      |    3 +-
 drivers/acpi/processor_driver.c                    |    8 +-
 drivers/acpi/processor_idle.c                      |   37 +-
 drivers/acpi/processor_perflib.c                   |    7 +-
 drivers/acpi/processor_thermal.c                   |   11 +-
 drivers/acpi/processor_throttling.c                |    7 +-
 drivers/acpi/sbshc.c                               |    3 +-
 drivers/acpi/scan.c                                |  620 +++++----
 drivers/acpi/sleep.c                               |   14 +-
 drivers/acpi/sysfs.c                               |    2 +-
 drivers/acpi/tables.c                              |   11 +-
 drivers/acpi/thermal.c                             |    7 +-
 drivers/acpi/utils.c                               |   99 +-
 drivers/acpi/video.c                               |    5 +-
 drivers/acpi/video_detect.c                        |    2 +-
 drivers/acpi/wakeup.c                              |    1 -
 drivers/ata/libata-acpi.c                          |   28 +-
 drivers/ata/pata_acpi.c                            |    5 +-
 drivers/base/Makefile                              |    2 +-
 drivers/base/base.h                                |    1 +
 drivers/base/container.c                           |   44 +
 drivers/base/init.c                                |    1 +
 drivers/base/platform.c                            |   16 +-
 drivers/base/power/clock_ops.c                     |   30 +-
 drivers/base/power/generic_ops.c                   |    4 +-
 drivers/char/apm-emulation.c                       |   11 +-
 drivers/char/hpet.c                                |    7 +-
 drivers/char/tpm/tpm_acpi.c                        |    2 +-
 drivers/char/tpm/tpm_ppi.c                         |  406 ++----
 drivers/cpufreq/Kconfig                            |    7 +-
 drivers/cpufreq/Kconfig.arm                        |   27 +-
 drivers/cpufreq/acpi-cpufreq.c                     |   86 +-
 drivers/cpufreq/arm_big_little.c                   |    3 +-
 drivers/cpufreq/at32ap-cpufreq.c                   |   17 +-
 drivers/cpufreq/cpufreq-cpu0.c                     |   10 +-
 drivers/cpufreq/cpufreq.c                          |  218 ++-
 drivers/cpufreq/cpufreq_governor.c                 |    6 +-
 drivers/cpufreq/cpufreq_governor.h                 |    2 +
 drivers/cpufreq/cpufreq_stats.c                    |  109 +-
 drivers/cpufreq/davinci-cpufreq.c                  |   16 +-
 drivers/cpufreq/dbx500-cpufreq.c                   |   22 +-
 drivers/cpufreq/exynos-cpufreq.c                   |   28 +-
 drivers/cpufreq/exynos4x12-cpufreq.c               |    2 +-
 drivers/cpufreq/exynos5250-cpufreq.c               |   74 +-
 drivers/cpufreq/exynos5440-cpufreq.c               |   36 +-
 drivers/cpufreq/freq_table.c                       |   78 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |  134 +-
 drivers/cpufreq/integrator-cpufreq.c               |    1 +
 drivers/cpufreq/intel_pstate.c                     |   89 +-
 drivers/cpufreq/kirkwood-cpufreq.c                 |    1 +
 drivers/cpufreq/loongson2_cpufreq.c                |   15 +-
 drivers/cpufreq/omap-cpufreq.c                     |   34 +-
 drivers/cpufreq/pcc-cpufreq.c                      |   18 +-
 drivers/cpufreq/powernow-k6.c                      |  147 +-
 drivers/cpufreq/powernow-k8.c                      |    7 +-
 drivers/cpufreq/ppc-corenet-cpufreq.c              |   17 +-
 drivers/cpufreq/pxa2xx-cpufreq.c                   |    1 +
 drivers/cpufreq/pxa3xx-cpufreq.c                   |    1 +
 drivers/cpufreq/s3c2416-cpufreq.c                  |    2 +-
 drivers/cpufreq/s3c2440-cpufreq.c                  |    6 +-
 drivers/cpufreq/s3c24xx-cpufreq.c                  |   14 +-
 drivers/cpufreq/s3c64xx-cpufreq.c                  |   35 +-
 drivers/cpufreq/s5pv210-cpufreq.c                  |   23 +-
 drivers/cpufreq/sa1100-cpufreq.c                   |    2 +-
 drivers/cpufreq/sa1110-cpufreq.c                   |    2 +-
 drivers/cpufreq/spear-cpufreq.c                    |   12 +-
 drivers/cpufreq/speedstep-smi.c                    |   32 -
 drivers/cpufreq/tegra-cpufreq.c                    |   49 +-
 drivers/cpufreq/unicore2-cpufreq.c                 |   33 +-
 drivers/firmware/Kconfig                           |    2 +-
 drivers/gpu/drm/gma500/opregion.c                  |    1 -
 drivers/gpu/drm/i915/Makefile                      |    3 +-
 drivers/gpu/drm/i915/i915_drv.h                    |    3 +-
 drivers/gpu/drm/i915/intel_acpi.c                  |  146 +-
 drivers/gpu/drm/i915/intel_opregion.c              |    1 -
 drivers/gpu/drm/nouveau/core/subdev/mxm/base.c     |   48 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |  138 +-
 drivers/gpu/drm/radeon/radeon_acpi.c               |    6 +-
 drivers/hid/i2c-hid/i2c-hid.c                      |   26 +-
 drivers/hv/vmbus_drv.c                             |    2 -
 drivers/hwmon/acpi_power_meter.c                   |    3 +-
 drivers/hwmon/asus_atk0110.c                       |    6 +-
 drivers/i2c/i2c-core.c                             |   11 +
 drivers/ide/ide-acpi.c                             |   12 +-
 drivers/idle/intel_idle.c                          |   32 +-
 drivers/input/misc/atlas_btns.c                    |    2 +-
 drivers/iommu/amd_iommu_init.c                     |    1 -
 drivers/iommu/intel_irq_remapping.c                |    4 +-
 drivers/mmc/core/sdio_bus.c                        |    2 +-
 drivers/of/device.c                                |    3 +
 drivers/pci/hotplug/acpiphp_glue.c                 |    2 +-
 drivers/pci/hotplug/acpiphp_ibm.c                  |    3 +-
 drivers/pci/hotplug/pciehp.h                       |    2 -
 drivers/pci/ioapic.c                               |    1 -
 drivers/pci/pci-acpi.c                             |   17 +-
 drivers/pci/pci-label.c                            |  130 +-
 drivers/platform/x86/acer-wmi.c                    |    2 -
 drivers/platform/x86/asus-laptop.c                 |    3 +-
 drivers/platform/x86/asus-wmi.c                    |    3 +-
 drivers/platform/x86/classmate-laptop.c            |    3 +-
 drivers/platform/x86/dell-wmi-aio.c                |    1 -
 drivers/platform/x86/dell-wmi.c                    |    1 -
 drivers/platform/x86/eeepc-laptop.c                |    3 +-
 drivers/platform/x86/eeepc-wmi.c                   |    2 +-
 drivers/platform/x86/hp_accel.c                    |    2 +-
 drivers/platform/x86/ideapad-laptop.c              |    3 +-
 drivers/platform/x86/intel-rst.c                   |    2 +-
 drivers/platform/x86/intel-smartconnect.c          |    2 +-
 drivers/platform/x86/intel_menlow.c                |    4 +-
 drivers/platform/x86/intel_oaktrail.c              |    3 -
 drivers/platform/x86/mxm-wmi.c                     |    3 +-
 drivers/platform/x86/panasonic-laptop.c            |    4 +-
 drivers/platform/x86/pvpanic.c                     |    3 +-
 drivers/platform/x86/samsung-q10.c                 |    2 +-
 drivers/platform/x86/sony-laptop.c                 |    4 +-
 drivers/platform/x86/tc1100-wmi.c                  |    4 +-
 drivers/platform/x86/thinkpad_acpi.c               |   14 +-
 drivers/platform/x86/toshiba_acpi.c                |    4 +-
 drivers/platform/x86/toshiba_bluetooth.c           |    4 +-
 drivers/platform/x86/wmi.c                         |    2 -
 drivers/platform/x86/xo15-ebook.c                  |    3 +-
 drivers/pnp/card.c                                 |    1 +
 drivers/pnp/pnpacpi/core.c                         |   33 +-
 drivers/pnp/pnpacpi/pnpacpi.h                      |    1 -
 drivers/pnp/pnpbios/core.c                         |   12 +-
 drivers/pnp/resource.c                             |    2 +-
 drivers/sfi/sfi_acpi.c                             |    4 +-
 drivers/spi/spi.c                                  |   10 +
 drivers/staging/quickstart/quickstart.c            |    2 +-
 drivers/thermal/samsung/exynos_tmu_data.c          |   12 +-
 drivers/usb/core/usb-acpi.c                        |   41 +-
 drivers/xen/xen-acpi-cpuhotplug.c                  |   11 +-
 drivers/xen/xen-acpi-memhotplug.c                  |    8 +-
 drivers/xen/xen-acpi-pad.c                         |    5 +-
 drivers/xen/xen-acpi-processor.c                   |    4 +-
 include/acpi/acpi_bus.h                            |   64 +-
 include/acpi/acpi_drivers.h                        |    3 -
 include/{linux => acpi}/acpi_io.h                  |    1 -
 include/acpi/acpixf.h                              |   39 +-
 include/acpi/actbl.h                               |    3 +
 include/acpi/actbl1.h                              |   10 +-
 include/acpi/actbl2.h                              |    5 +
 include/acpi/actbl3.h                              |   15 +-
 include/acpi/actypes.h                             |   12 +-
 include/acpi/platform/acenv.h                      |   20 +-
 include/acpi/platform/aclinux.h                    |    4 -
 include/linux/acpi.h                               |   24 +-
 include/linux/container.h                          |   25 +
 include/linux/cpufreq.h                            |   42 +
 include/linux/ide.h                                |    8 +-
 include/linux/iscsi_ibft.h                         |    2 +-
 include/linux/of_device.h                          |    6 +
 include/linux/pci_hotplug.h                        |    3 +-
 include/linux/pm.h                                 |   21 +
 include/linux/pm_runtime.h                         |   12 +-
 include/linux/sfi_acpi.h                           |    5 +-
 include/linux/tboot.h                              |    2 +-
 include/trace/events/power.h                       |   53 +
 include/uapi/linux/apm_bios.h                      |    2 +
 init/main.c                                        |    2 +-
 kernel/power/hibernate.c                           |    7 +-
 scripts/analyze_suspend.py                         | 1446 ++++++++++++++++++++
 tools/Makefile                                     |   16 +-
 tools/power/acpi/Makefile                          |  149 +-
 tools/power/acpi/{ => man}/acpidump.8              |    0
 tools/power/acpi/{ => tools/acpidump}/acpidump.c   |    0
 .../power/cpupower/debug/kernel/cpufreq-test_tsc.c |    5 +-
 tools/power/cpupower/utils/cpufreq-set.c           |    2 +-
 243 files changed, 4658 insertions(+), 2750 deletions(-)

