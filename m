Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab3ICLeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 07:34:06 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53903 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733Ab3ICLd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:33:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [GIT PULL] ACPI and power management updates for v3.12-rc1
Date: Tue, 03 Sep 2013 13:44:49 +0200
Message-ID: <2674865.N29rBtXZDk@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.12-rc1

to receive ACPI and power management updates for v3.12 with top-most commit
f41b83126cba53849dd2353476a7715613af648f

  Merge branch 'pm-cpufreq'

on top of commit d8dfad3876e4386666b759da3c833d62fb8b2267

  Linux 3.11-rc7

We have more ACPI commits than power management commits this time, mostly
due to the fact that I put some cpufreq cleanups on hold.

The headline feature of this pull request, in my personal view, is the
addition of Intel Thunderbolt support on systems that use ACPI for
signaling Thunderbolt hotplug events (they don't include Apple, because
Apple seems to have its own kind of secret way of doing this).
To make that work on all of our test machines we had to rework the
entire ACPI-based PCI hotplug (ACPIPHP) code and now it should cover
a few more cases in which it didn't work before.

Also worth mentioning is the change of cpufreq ondemand governor that
makes it choose target frequencies proportional to load.  It simplifies
the code in question quite a bit and promises both to improve
performance and to reduce energy consumption slightly on systems using
that governor.  It's been in linux-next pretty much since 3.11-rc1
and no one has reported any problems with it for that period, but that's
subtle stuff, so testing is obviously welcome.

In addition to that, the old and long deprecated /proc/acpi/event interface
is going away and no one seems to have any problems with that.

The rest is mostly cleanups and fixes all over and, interestingly enough,
we're removing more lines of code total than we're adding.

Specifics:

 1) ACPI-based PCI hotplug (ACPIPHP) subsystem rework and introduction
    of Intel Thunderbolt support on systems that use ACPI for signalling
    Thunderbolt hotplug events.  This also should make ACPIPHP work in
    some cases in which it was known to have problems.  From yours truly,
    Mika Westerberg and Kirill A Shutemov.

 2) ACPI core code cleanups and dock station support cleanups from
    Jiang Liu and me.

 3) Fixes for locking problems related to ACPI device hotplug.

 4) ACPICA update to version 20130725 includig fixes, cleanups, support
    for more than 256 GPEs per GPE block and a change to make the ACPI
    PM Timer optional (we've seen systems without the PM Timer in the
    field already).  One of the fixes, related to the DeRefOf operator,
    is necessary to prevent some Windows 8 oriented AML from causing
    problems to happen.  From Bob Moore, Lv Zheng, and Jung-uk Kim.

 5) Removal of the old and long deprecated /proc/acpi/event interface
    and related driver changes from Thomas Renninger.

 6) ACPI and Xen changes to make the reduced hardware sleep work with
    the latter from Ben Guthro.

 7) ACPI video driver cleanups and a blacklist of systems that should
    not tell the BIOS that they are compatible with Windows 8 (or ACPI
    backlight and possibly other things will not work on them).  From
    Felipe Contreras.

 8) Assorted ACPI fixes and cleanups from Aaron Lu, Hanjun Guo,
    Kuppuswamy Sathyanarayanan, Lan Tianyu, Sachin Kamat, Tang Chen,
    Toshi Kani, and Wei Yongjun.

 9) cpufreq ondemand governor target frequency selection change to
    reduce oscillations between min and max frequencies (essentially,
    it causes the governor to choose target frequencies proportional
    to load) from Stratos Karafotis.

10) cpufreq fixes allowing sysfs attributes file permissions to be
    preserved over suspend/resume cycles Srivatsa S Bhat.

11) Removal of Device Tree parsing for CPU device nodes from multiple
    cpufreq drivers that required some changes related to
    of_get_cpu_node() to be made in a few architectures and in the
    driver core.  From Sudeep KarkadaNagesha.

12) cpufreq core fixes and cleanups related to mutual exclusion and
    driver module references from Viresh Kumar, Lukasz Majewski and
    myself.

13) Assorted cpufreq fixes and cleanups from Amit Daniel Kachhap,
    Bartlomiej Zolnierkiewicz, Hanjun Guo, Jingoo Han, Joseph Lo,
    Julia Lawall, Li Zhong, Mark Brown, Sascha Hauer, Stephen Boyd,
    Stratos Karafotis, and Viresh Kumar.

14) Fixes to prevent race conditions in coupled cpuidle from happening
    from Colin Cross.

15) cpuidle core fixes and cleanups from Daniel Lezcano and
    Tuukka Tikkanen.

16) Assorted cpuidle fixes and cleanups from Daniel Lezcano,
    Geert Uytterhoeven, Jingoo Han, Julia Lawall, Linus Walleij,
    and Sahara.

17) System suspend/hibernation tracing changes from Todd E Brandt and
    Shuah Khan.

18) PNP subsystem conversion to using struct dev_pm_ops for power
    management from Shuah Khan.

Thanks!


---------------

Aaron Lu (2):
      ACPI / PM: Remove redundant power manageable check from acpi_bus_set_power()
      ACPI / PM: Add state information to error message in acpi_device_set_power()

Amit Daniel Kachhap (1):
      cpufreq: exynos5440: Fix to skip when new frequency same as current

Bartlomiej Zolnierkiewicz (1):
      cpufreq: fix EXYNOS drivers selection

Ben Guthro (3):
      ACPI / sleep: Introduce acpi_os_prepare_extended_sleep() for extended sleep path
      xen / ACPI: notify xen when reduced hardware sleep is available
      x86 / tboot / ACPI: Fail extended mode reduced hardware sleep

Bob Moore (13):
      ACPICA: Update comments about behavior when _STA does not exist
      ACPICA: TableManager: Export acpi_tb_scan_memory_for_rsdp()
      ACPICA: Disassembler: Expand maximum output string length to 64K
      ACPICA: Remove restriction of 256 maximum GPEs in any GPE block
      ACPICA: Update version to 20130626
      ACPICA: Export acpi_tb_validate_rsdp().
      ACPICA: Emit all unresolved method externals in a text block
      ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and BufferField refs.
      ACPICA: Fix possible fault for methods that optionally have no return value.
      ACPICA: Make ACPI Power Management Timer (PM Timer) optional.
      ACPICA: Return error if DerefOf resolves to a null package element.
      ACPICA: Update names for walk_namespace callbacks to clarify usage.
      ACPICA: Update version to 20130725.

Brandt, Todd E (1):
      PM / Sleep: increase ftrace coverage in suspend/resume

Colin Cross (3):
      cpuidle: coupled: disable interrupts after entering safe state
      cpuidle: coupled: abort idle if pokes are pending
      cpuidle: coupled: fix race condition between pokes and safe state

Daniel Lezcano (10):
      cpuidle: Make it clear that governors cannot be modules
      cpuidle: Check cpuidle_enable_device() return value
      cpuidle: Fix white space to follow CodingStyle
      cpuidle: Make cpuidle's sysfs directory dynamically allocated
      cpuidle: Add missing forward declarations of structures
      cpuidle: Introduce __cpuidle_unregister_device()
      cpuidle: Introduce __cpuidle_device_init()
      cpuidle: Check if device is already registered
      ARM: davinci: cpuidle: Fix target residency
      ARM: ux500: cpuidle: Move ux500 cpuidle driver to drivers/cpuidle

Felipe Contreras (6):
      ACPI / video: trivial costmetic cleanups
      ACPI / video: trivial style cleanups
      ACPI / video: remove unnecessary type casting
      ACPI / video: drop unused fields from struct acpi_video_brightness_flags
      ACPI: blacklist win8 OSI for ASUS Zenbook Prime UX31A
      ACPI: blacklist win8 OSI for buggy laptops

Geert Uytterhoeven (1):
      SH: cpuidle: Add missing parameter for cpuidle_register()

Hanjun Guo (6):
      ACPI / dock: Fix __init attribute location in find_dock_and_bay()
      ACPI / numa: Fix __init attribute location in slit_valid()
      ACPI / osl: Fix osi_setup_entries[] __initdata attribute location
      cpufreq / gx: Fix gx_detect_chipset() __init attribute location
      cpufreq / pxa2xx: Fix pxa_cpufreq_init_voltages() __init attribute location
      cpufreq / s3c24xx: Fix s3c_cpufreq_initclks() __init attribute location

Jiang Liu (10):
      ACPI / dock: avoid initializing acpi_dock_notifier_list multiple times
      ACPI / dock: drop redundant spin lock in dock station object
      ACPI / dock: mark initialization functions with __init
      ACPI / dock: simplify dock_create_acpi_device()
      ACPI: introduce helper function acpi_has_method()
      ACPI: introduce helper function acpi_execute_simple_method()
      ACPI: introduce two helper functions for _EJ0 and _LCK
      ACPI: Export acpi_(bay)|(dock)_match() from scan.c
      ACPI: simplify dock driver with new helper functions
      ACPI: simplify acpiphp driver with new helper functions

Jingoo Han (3):
      cpuidle: calxeda: Add missing __iomem annotation
      cpuidle: kirkwood: Make kirkwood_cpuidle_remove function static
      cpufreq: unicore2: Staticize local symbol

Joseph Lo (1):
      cpufreq: tegra: fix the wrong clock name

Julia Lawall (2):
      cpuidle-kirkwood.c: simplify use of devm_ioremap_resource()
      pxa3xx-cpufreq.c: Avoid using ARRAY_AND_SIZE(e) as a function argument

Jung-uk Kim (1):
      ACPICA: Fix compiler warnings for casting issues (only some compilers)

Kirill A. Shutemov (2):
      ACPI / hotplug / PCI: Do not check SLOT_ENABLED in enable_device()
      ACPI / hotplug / PCI: Allow slots without new devices to be rescanned

Kuppuswamy Sathyanarayanan (1):
      ACPI / scan: Allow platform device creation without any IO resources

Lan Tianyu (8):
      PCI / ACPI: Use dev_dbg() instead of dev_info() in acpi_pci_set_power_state()
      ACPI / processor: Remove acpi_processor_get_limit_info()
      acpi-cpufreq: Use cpufreq_freq_attr_rw to define the cpb attribute
      ACPI / thermal: Remove the unused lock of struct acpi_thermal
      ACPI / thermal: Remove unused macros in the driver/acpi/thermal.c
      ACPI / thermal: Use THERMAL_TRIPS_NONE macro to replace number
      ACPI / thermal: Add check of "_TZD" availability and evaluating result
      ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT

Li Zhong (1):
      cpufreq: fix bad unlock balance on !CONFIG_SMP

Linus Walleij (2):
      ARM: ux500: cpuidle: Instantiate the driver from platform device
      ARM: ux500: cpuidle: Remove pointless include

Lukasz Majewski (1):
      cpufreq: Store cpufreq policies in a list

Lv Zheng (5):
      ACPICA: Add acpi_update_interfaces() public interface
      ACPI: Add facility to disable all _OSI OS vendor strings
      ACPI: Add facility to remove all _OSI strings
      ACPI: Cleanup sparse warning on acpi_os_initialize1()
      ACPICA: Fix divergences of the commit - ACPICA: Expose OSI version.

Mark Brown (1):
      cpufreq: cpufreq-cpu0: NULL is a valid regulator

Mika Westerberg (5):
      x86 / PCI: prevent re-allocation of already existing bridge and ROM resources
      ACPI / hotplug / PCI: Consolidate slot disabling and ejecting
      ACPI / hotplug / PCI: Get rid of unused constants in acpiphp.h
      ACPI / hotplug / PCI: Sanitize acpiphp_get_(latch)|(adapter)_status()
      ACPI / hotplug / PCI: Get rid of check_sub_bridges()

Rafael J. Wysocki (54):
      ACPI / dock: Drop the hp_lock mutex from struct dock_station
      ACPI / dock: Rework and simplify find_dock_devices()
      ACPI / dock: Walk list in reverse order during removal of devices
      ACPI / dock: Simplify dock_init_hotplug() and dock_release_hotplug()
      ACPI / dock: Rework the handling of notifications
      ACPI: Drop ACPI bus notifier call chain
      ACPI / dock: Do not leak memory on falilures to add a dock station
      ACPI / dock: Do not check CONFIG_ACPI_DOCK_MODULE
      ACPI / dock / PCI: Drop ACPI dock notifier chain
      ACPI / dock: Drop unnecessary local variable from dock_add()
      ACPI / PCI: Make bus registration and unregistration symmetric
      ACPI / hotplug / PCI: Consolidate acpiphp_enumerate_slots()
      ACPI / hotplug / PCI: Always return success after adding a function
      ACPI / hotplug / PCI: Hotplug context objects for bridges and functions
      ACPI / hotplug / PCI: Unified notify handler for hotplug events
      ACPI / hotplug / PCI: Rework acpiphp_handle_to_bridge()
      ACPI / hotplug / PCI: Pass hotplug context objects to event handlers
      ACPI / hotplug / PCI: Merge hotplug event handling functions
      ACPI / hotplug / PCI: Drop func field from struct acpiphp_bridge
      ACPI / hotplug / PCI: Refactor slot allocation code in register_slot()
      ACPI / hotplug / PCI: Register all devices under the given bridge
      ACPI / hotplug / PCI: Drop sun field from struct acpiphp_slot
      ACPI / hotplug / PCI: Drop flags field from struct acpiphp_bridge
      ACPI / hotplug / PCI: Embed function struct into struct acpiphp_context
      ACPI / hotplug / PCI: Drop handle field from struct acpiphp_func
      ACPI / hotplug / PCI: Drop handle field from struct acpiphp_bridge
      ACPI / hotplug / PCI: Store parent in functions and bus in slots
      ACPI / hotplug / PCI: Rework namespace scanning and trimming routines
      ACPI / hotplug / PCI: Drop redundant checks from check_hotplug_bridge()
      ACPI / hotplug / PCI: Do not queue up event handling work items in vain
      ACPI / hotplug / PCI: Do not exectute _PS0 and _PS3 directly
      ACPI / hotplug / PCI: Check for new devices on enabled slots
      ACPI / hotplug / PCI: Redefine enable_device() and disable_device()
      ACPI / hotplug / PCI: Clean up bridge_mutex usage
      ACPI / PM: Only set power states of devices that are power manageable
      ACPI / PM: Make messages in acpi_device_set_power() print device names
      ACPI / PM: Use ACPI_STATE_D3_COLD instead of ACPI_STATE_D3 everywhere
      ACPI: Move acpi_bus_get_device() from bus.c to scan.c
      ACPI / scan: Drop unnecessary label from acpi_create_platform_device()
      cpufreq: Do not hold driver module references for additional policy CPUs
      cpufreq: Avoid double kobject_put() for the same kobject in error code path
      ACPI: Do not fail acpi_bind_one() if device is already bound correctly
      ACPI: Reduce acpi_bind_one()/acpi_unbind_one() code duplication
      ACPI: Create symlinks in acpi_bind_one() under physical_node_lock
      ACPI: acpi_bind_one()/acpi_unbind_one() whitespace cleanups
      ACPI: Use list_for_each_entry() in acpi_unbind_one()
      ACPI: Clean up error code path in acpi_unbind_one()
      ACPI: Drop unnecessary label from acpi_bind_one()
      ACPI: Print diagnostic messages if device links cannot be created
      ACPI / hotplug / PCI: Fix NULL pointer dereference in cleanup_bridge()
      Revert "cpufreq: Use cpufreq_policy_list for iterating over policies"
      ACPI / PM: Hold acpi_scan_lock over system PM transitions
      driver core / ACPI: Avoid device hot remove locking issues
      ACPI / hotplug: Remove containers synchronously

Sachin Kamat (3):
      ACPI / EC: Fix incorrect placement of __initdata
      ACPI / processor: Fix incorrect placement of __initdata
      ACPI / Sleep: Fix incorrect placement of __initdata

Sahara (1):
      cpuidle: Add Kconfig.arm and move calxeda, kirkwood and zynq

Sascha Hauer (1):
      cpufreq: imx6q: Fix clock enable balance

Shuah Khan (2):
      PM / Sleep: new trace event to print device suspend and resume times
      PNP: convert PNP driver bus legacy pm_ops to dev_pm_ops

Srivatsa S. Bhat (7):
      cpufreq: Fix misplaced call to cpufreq_update_policy()
      cpufreq: Add helper to perform alloc/free of policy structure
      cpufreq: Extract non-interface related stuff from cpufreq_add_dev_interface
      cpufreq: Extract the handover of policy cpu to a helper function
      cpufreq: Introduce a flag ('frozen') to separate full vs temporary init/teardown
      cpufreq: Preserve policy structure across suspend/resume
      cpufreq: Perform light-weight init/teardown during suspend/resume

Stephen Boyd (2):
      cpufreq: Fix timer/workqueue corruption due to double queueing
      cpufreq: Don't use smp_processor_id() in preemptible context

Stratos Karafotis (5):
      cpufreq: ondemand: Change the calculation of target frequency
      cpufreq: Remove unused APERF/MPERF support
      cpufreq: Remove unused function __cpufreq_driver_getavg()
      cpufreq: governors: Remove duplicate check of target freq in supported range
      cpufreq: governor: Fix typos in comments

Sudeep KarkadaNagesha (19):
      microblaze: remove undefined of_get_cpu_node declaration
      openrisc: remove undefined of_get_cpu_node declaration
      powerpc: refactor of_get_cpu_node to support other architectures
      of: move of_get_cpu_node implementation to DT core library
      ARM: DT/kernel: define ARM specific arch_match_cpu_phys_id
      driver/core: cpu: initialize of_node in cpu's device struture
      of/device: add helper to get cpu device node from logical cpu index
      ARM: topology: remove hwid/MPIDR dependency from cpu_capacity
      ARM: mvebu: remove device tree parsing for cpu nodes
      drivers/bus: arm-cci: avoid parsing DT for cpu device nodes
      cpufreq: imx6q-cpufreq: remove device tree parsing for cpu nodes
      cpufreq: cpufreq-cpu0: remove device tree parsing for cpu nodes
      cpufreq: highbank-cpufreq: remove device tree parsing for cpu nodes
      cpufreq: spear-cpufreq: remove device tree parsing for cpu nodes
      cpufreq: kirkwood-cpufreq: remove device tree parsing for cpu nodes
      cpufreq: arm_big_little: remove device tree parsing for cpu nodes
      cpufreq: maple-cpufreq: remove device tree parsing for cpu nodes
      cpufreq: pmac64-cpufreq: remove device tree parsing for cpu nodes
      cpufreq: pmac32-cpufreq: remove device tree parsing for cpu nodes

Tang Chen (3):
      ACPI / x86: Print Hot-Pluggable Field in SRAT.
      earlycpio.c: Fix the confusing comment of find_cpio_data().
      ACPI / osl: Kill macro INVALID_TABLE().

Thomas Renninger (2):
      ACPI: Remove the old /proc/acpi/event interface
      platform / thinkpad: Remove deprecated hotkey_report_mode parameter

Toshi Kani (1):
      ACPI / processor: Acquire writer lock to update CPU maps

Tuukka Tikkanen (8):
      cpuidle: Ignore interval prediction result when timer is shorter
      cpuidle: Rearrange code and comments in get_typical_interval()
      cpuidle: Check called function parameter in get_typical_interval()
      cpuidle: CodingStyle: Break up multiple assignments on single line
      cpuidle: Fix menu_device->intervals type
      cpuidle: Fix variable domains in get_typical_interval()
      cpuidle: Add a comment warning about possible overflow
      cpuidle: Change struct menu_device field types

Viresh Kumar (18):
      PM / OPP: Export opp_add()
      cpufreq: Remove extra variables from cpufreq_add_dev_symlink()
      cpufreq: Don't pass CPU to cpufreq_add_dev_{symlink|interface}()
      cpufreq: Pass policy to cpufreq_add_policy_cpu()
      cpufreq: Clean up header files included in the core
      cpufreq: Re-arrange declarations in cpufreq.h
      cpufreq: Give consistent names to cpufreq_policy objects
      cpufreq: Use sizeof(*ptr) convetion for computing sizes
      cpufreq: Use cpufreq_policy_list for iterating over policies
      cpufreq: Fix broken usage of governor->owner's refcount
      cpufreq: Use rwsem for protecting critical sections
      cpufreq: Drop the owner field from struct cpufreq_driver
      cpufreq: improve error checking on return values of __cpufreq_governor()
      cpufreq: Fix white space in __cpufreq_remove_dev()
      cpufreq: remove policy from cpufreq_policy_list during suspend
      cpufreq: remove unnecessary check in __cpufreq_governor()
      cpufreq: remove cpufreq_policy_cpu per-cpu variable
      cpufreq: Use cpufreq_policy_list for iterating over policies

Wei Yongjun (1):
      ACPI / dock: fix error return code in dock_add()

---------------

 Documentation/cpu-freq/cpu-drivers.txt             |    2 -
 Documentation/kernel-parameters.txt                |   55 +-
 Documentation/laptops/asus-laptop.txt              |    8 +-
 Documentation/laptops/sony-laptop.txt              |    8 +-
 Documentation/laptops/thinkpad-acpi.txt            |   73 +-
 arch/arm/kernel/devtree.c                          |    5 +
 arch/arm/kernel/topology.c                         |   61 +-
 arch/arm/mach-davinci/cpuidle.c                    |    2 +-
 arch/arm/mach-imx/mach-imx6q.c                     |    3 +-
 arch/arm/mach-mvebu/platsmp.c                      |   51 +-
 arch/arm/mach-ux500/Makefile                       |    1 -
 arch/microblaze/include/asm/prom.h                 |    3 -
 arch/openrisc/include/asm/prom.h                   |    3 -
 arch/powerpc/include/asm/prom.h                    |    3 -
 arch/powerpc/kernel/prom.c                         |   43 +-
 arch/sh/kernel/cpu/shmobile/cpuidle.c              |    4 +-
 arch/x86/include/asm/processor.h                   |   29 -
 arch/x86/kernel/tboot.c                            |   10 +
 arch/x86/mm/srat.c                                 |   11 +-
 arch/x86/pci/i386.c                                |    4 +
 drivers/acpi/Kconfig                               |   18 -
 drivers/acpi/ac.c                                  |    1 -
 drivers/acpi/acpi_pad.c                            |    1 -
 drivers/acpi/acpi_platform.c                       |   24 +-
 drivers/acpi/acpi_processor.c                      |   21 +-
 drivers/acpi/acpica/acglobal.h                     |    7 +-
 drivers/acpi/acpica/aclocal.h                      |    4 +
 drivers/acpi/acpica/acnamesp.h                     |    4 +-
 drivers/acpi/acpica/actables.h                     |    7 +
 drivers/acpi/acpica/acutils.h                      |    4 +-
 drivers/acpi/acpica/evgpeinit.c                    |   11 -
 drivers/acpi/acpica/exdump.c                       |    6 +-
 drivers/acpi/acpica/exoparg1.c                     |   48 +-
 drivers/acpi/acpica/hwesleep.c                     |    9 +
 drivers/acpi/acpica/hwtimer.c                      |   13 +-
 drivers/acpi/acpica/nspredef.c                     |   16 +-
 drivers/acpi/acpica/nswalk.c                       |   26 +-
 drivers/acpi/acpica/nsxfeval.c                     |   16 +-
 drivers/acpi/acpica/nsxfname.c                     |   11 +-
 drivers/acpi/acpica/tbfadt.c                       |    4 +-
 drivers/acpi/acpica/tbxfroot.c                     |   12 +-
 drivers/acpi/acpica/uteval.c                       |    8 +-
 drivers/acpi/acpica/utglobal.c                     |    1 -
 drivers/acpi/acpica/utosi.c                        |   77 +-
 drivers/acpi/acpica/utstring.c                     |    5 +-
 drivers/acpi/acpica/utxface.c                      |   29 +
 drivers/acpi/battery.c                             |   21 +-
 drivers/acpi/blacklist.c                           |   30 +
 drivers/acpi/bus.c                                 |  142 +--
 drivers/acpi/button.c                              |    2 -
 drivers/acpi/device_pm.c                           |   34 +-
 drivers/acpi/dock.c                                |  400 +++-----
 drivers/acpi/ec.c                                  |   10 +-
 drivers/acpi/event.c                               |  106 --
 drivers/acpi/fan.c                                 |    4 +-
 drivers/acpi/glue.c                                |   91 +-
 drivers/acpi/internal.h                            |    1 +
 drivers/acpi/numa.c                                |    2 +-
 drivers/acpi/osl.c                                 |   86 +-
 drivers/acpi/pci_slot.c                            |   14 +-
 drivers/acpi/power.c                               |    6 +-
 drivers/acpi/processor_core.c                      |    2 +-
 drivers/acpi/processor_driver.c                    |    8 +-
 drivers/acpi/processor_perflib.c                   |   22 +-
 drivers/acpi/processor_thermal.c                   |   12 -
 drivers/acpi/resource.c                            |    4 +-
 drivers/acpi/sbs.c                                 |   15 +-
 drivers/acpi/scan.c                                |  272 ++---
 drivers/acpi/sleep.c                               |   48 +-
 drivers/acpi/thermal.c                             |   49 +-
 drivers/acpi/utils.c                               |   70 ++
 drivers/acpi/video.c                               |  246 ++---
 drivers/acpi/video_detect.c                        |   19 +-
 drivers/ata/libata-acpi.c                          |    4 +-
 drivers/base/core.c                                |   43 +-
 drivers/base/cpu.c                                 |    2 +
 drivers/base/memory.c                              |    4 +-
 drivers/base/power/main.c                          |   77 +-
 drivers/base/power/opp.c                           |    1 +
 drivers/bus/arm-cci.c                              |   28 +-
 drivers/char/sonypi.c                              |    5 -
 drivers/cpufreq/Kconfig.arm                        |   36 +-
 drivers/cpufreq/Makefile                           |    2 +-
 drivers/cpufreq/acpi-cpufreq.c                     |   12 +-
 drivers/cpufreq/arm_big_little_dt.c                |   40 +-
 drivers/cpufreq/at32ap-cpufreq.c                   |    1 -
 drivers/cpufreq/blackfin-cpufreq.c                 |    1 -
 drivers/cpufreq/cpufreq-cpu0.c                     |   32 +-
 drivers/cpufreq/cpufreq-nforce2.c                  |    1 -
 drivers/cpufreq/cpufreq.c                          |  738 +++++++-------
 drivers/cpufreq/cpufreq_conservative.c             |   18 +-
 drivers/cpufreq/cpufreq_governor.c                 |   30 +-
 drivers/cpufreq/cpufreq_governor.h                 |   20 +-
 drivers/cpufreq/cpufreq_ondemand.c                 |   66 +-
 drivers/cpufreq/cpufreq_performance.c              |    3 +-
 drivers/cpufreq/cpufreq_powersave.c                |    3 +-
 drivers/cpufreq/cpufreq_stats.c                    |   31 +-
 drivers/cpufreq/cris-artpec3-cpufreq.c             |    1 -
 drivers/cpufreq/cris-etraxfs-cpufreq.c             |    1 -
 drivers/cpufreq/e_powersaver.c                     |    5 +-
 drivers/cpufreq/elanfreq.c                         |    1 -
 drivers/cpufreq/exynos-cpufreq.c                   |    3 +-
 drivers/cpufreq/exynos-cpufreq.h                   |   21 +
 drivers/cpufreq/exynos5440-cpufreq.c               |    3 +
 drivers/cpufreq/freq_table.c                       |    4 +-
 drivers/cpufreq/gx-suspmod.c                       |    5 +-
 drivers/cpufreq/highbank-cpufreq.c                 |   18 +-
 drivers/cpufreq/ia64-acpi-cpufreq.c                |    5 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |   21 +-
 drivers/cpufreq/intel_pstate.c                     |    1 -
 drivers/cpufreq/kirkwood-cpufreq.c                 |    9 +-
 drivers/cpufreq/longhaul.c                         |    1 -
 drivers/cpufreq/longrun.c                          |    1 -
 drivers/cpufreq/loongson2_cpufreq.c                |    1 -
 drivers/cpufreq/maple-cpufreq.c                    |   24 +-
 drivers/cpufreq/mperf.c                            |   51 -
 drivers/cpufreq/mperf.h                            |    9 -
 drivers/cpufreq/p4-clockmod.c                      |    1 -
 drivers/cpufreq/pasemi-cpufreq.c                   |    1 -
 drivers/cpufreq/pcc-cpufreq.c                      |    1 -
 drivers/cpufreq/pmac32-cpufreq.c                   |    6 +-
 drivers/cpufreq/pmac64-cpufreq.c                   |   53 +-
 drivers/cpufreq/powernow-k6.c                      |    1 -
 drivers/cpufreq/powernow-k7.c                      |   14 +-
 drivers/cpufreq/powernow-k8.c                      |    7 +-
 drivers/cpufreq/ppc-corenet-cpufreq.c              |    1 -
 drivers/cpufreq/ppc_cbe_cpufreq.c                  |    1 -
 drivers/cpufreq/pxa2xx-cpufreq.c                   |    4 +-
 drivers/cpufreq/pxa3xx-cpufreq.c                   |    6 +-
 drivers/cpufreq/s3c2416-cpufreq.c                  |    1 -
 drivers/cpufreq/s3c24xx-cpufreq.c                  |    8 +-
 drivers/cpufreq/s3c64xx-cpufreq.c                  |    1 -
 drivers/cpufreq/sc520_freq.c                       |    1 -
 drivers/cpufreq/sh-cpufreq.c                       |    1 -
 drivers/cpufreq/sparc-us2e-cpufreq.c               |    6 +-
 drivers/cpufreq/sparc-us3-cpufreq.c                |    6 +-
 drivers/cpufreq/spear-cpufreq.c                    |    4 +-
 drivers/cpufreq/speedstep-centrino.c               |    1 -
 drivers/cpufreq/speedstep-ich.c                    |    1 -
 drivers/cpufreq/speedstep-smi.c                    |    1 -
 drivers/cpufreq/tegra-cpufreq.c                    |    4 +-
 drivers/cpufreq/unicore2-cpufreq.c                 |    2 +-
 drivers/cpuidle/Kconfig                            |   20 +-
 drivers/cpuidle/Kconfig.arm                        |   29 +
 drivers/cpuidle/Makefile                           |    9 +-
 drivers/cpuidle/coupled.c                          |  129 ++-
 drivers/cpuidle/cpuidle-calxeda.c                  |    2 +-
 drivers/cpuidle/cpuidle-kirkwood.c                 |    5 +-
 .../cpuidle.c => drivers/cpuidle/cpuidle-ux500.c   |   19 +-
 drivers/cpuidle/cpuidle.c                          |   94 +-
 drivers/cpuidle/governors/ladder.c                 |   12 +-
 drivers/cpuidle/governors/menu.c                   |  108 +-
 drivers/cpuidle/sysfs.c                            |  101 +-
 drivers/ide/ide-acpi.c                             |    5 +-
 drivers/mfd/db8500-prcmu.c                         |    4 +
 drivers/of/base.c                                  |   95 ++
 drivers/pci/hotplug/acpiphp.h                      |   55 +-
 drivers/pci/hotplug/acpiphp_core.c                 |   18 +-
 drivers/pci/hotplug/acpiphp_glue.c                 | 1035 ++++++++------------
 drivers/pci/hotplug/acpiphp_ibm.c                  |    3 +-
 drivers/pci/pci-acpi.c                             |   18 +-
 drivers/platform/x86/asus-laptop.c                 |    1 -
 drivers/platform/x86/eeepc-laptop.c                |    1 -
 drivers/platform/x86/fujitsu-laptop.c              |    4 -
 drivers/platform/x86/panasonic-laptop.c            |    3 -
 drivers/platform/x86/sony-laptop.c                 |    4 -
 drivers/platform/x86/thinkpad_acpi.c               |   40 -
 drivers/pnp/driver.c                               |   21 +-
 drivers/pnp/pnpacpi/core.c                         |    6 +-
 drivers/xen/acpi.c                                 |   41 +-
 include/acpi/acpi_bus.h                            |   28 +-
 include/acpi/acpi_drivers.h                        |   14 +-
 include/acpi/acpixf.h                              |    8 +-
 include/acpi/actypes.h                             |   21 +-
 include/linux/acpi.h                               |    7 +
 include/linux/cpu.h                                |    5 +
 include/linux/cpufreq.h                            |  388 ++++----
 include/linux/cpuidle.h                            |    9 +-
 include/linux/device.h                             |    1 +
 include/linux/of.h                                 |    7 +
 include/linux/of_device.h                          |   15 +
 include/linux/pci-acpi.h                           |   10 +-
 include/trace/events/power.h                       |   37 +
 include/xen/acpi.h                                 |    8 +-
 include/xen/interface/platform.h                   |    7 +-
 kernel/cpu.c                                       |    9 +-
 kernel/power/suspend.c                             |    4 +-
 lib/earlycpio.c                                    |   27 +-
 188 files changed, 2986 insertions(+), 3495 deletions(-)

