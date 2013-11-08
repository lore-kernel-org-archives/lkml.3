Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab3KHQE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:04:29 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61318 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756024Ab3KHQEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:04:25 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management updates for v3.13-rc1
Date: Fri, 08 Nov 2013 17:16:45 +0100
Message-ID: <3004374.Ys6UmYU09i@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.13-rc1

to receive ACPI and power management updates for v3.13-rc1 with
top-most commit faddf2f5d278f1656e9444961bdd8d9db4deb5bf

  Merge branch 'pm-cpufreq'

on top of commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb

  Linux 3.12-rc7

This time power management has the majority of commits, with cpufreq
being most actively worked on.  Those commits are mostly fixes and
cleanups, but the arm_big_little cpufreq driver has got a new feature,
which is the in-kernel switching allowing it to switch between the
"big" and the "little" cores as part of performance scaling.  In
addition to that, frequency scaling is now enabled on iMac G5 and
Midway/ECX-2000 and the intel_pstate driver supports Baytrail
processors.

Still, the headline feature of this pull request, in my personal view,
is the introduction of the power capping framework and the Intel
Running Average Power Limit (RAPL) driver using it.  This allows the
power draw of various system components to be limited and measured
which doesn't have to be done as part of thermal management, although
thermal will be a major user of that functionality.

We also have usual updates of the ACPICA code, which now is equivalent
to the upstream version 20130927, and the addition of ACPI power
management support to the I2C and SPI bus types.

The rest is mostly cleanups and fixes all over.

Specifics:

 - New power capping framework and the the Intel Running Average Power
   Limit (RAPL) driver using it from Srinivas Pandruvada and Jacob Pan.

 - Addition of the in-kernel switching feature to the arm_big_little
   cpufreq driver from Viresh Kumar and Nicolas Pitre.

 - cpufreq support for iMac G5 from Aaro Koskinen.

 - Baytrail processors support for intel_pstate from Dirk Brandewie.

 - cpufreq support for Midway/ECX-2000 from Mark Langsdorf.

 - ARM vexpress/TC2 cpufreq support from Sudeep KarkadaNagesha.

 - ACPI power management support for the I2C and SPI bus types from
   Mika Westerberg and Lv Zheng.

 - cpufreq core fixes and cleanups from Viresh Kumar, Srivatsa S Bhat,
   Stratos Karafotis, Xiaoguang Chen, Lan Tianyu.

 - cpufreq drivers updates (mostly fixes and cleanups) from Viresh Kumar,
   Aaro Koskinen, Jungseok Lee, Sudeep KarkadaNagesha, Lukasz Majewski,
   Manish Badarkhe, Hans-Christian Egtvedt, Evgeny Kapaev.

 - intel_pstate updates from Dirk Brandewie and Adrian Huang.

 - ACPICA update to version 20130927 includig fixes and cleanups and
   some reduction of divergences between the ACPICA code in the kernel
   and ACPICA upstream in order to improve the automatic ACPICA patch
   generation process.  From Bob Moore, Lv Zheng, Tomasz Nowicki,
   Naresh Bhat, Bjorn Helgaas, David E Box.

 - ACPI IPMI driver fixes and cleanups from Lv Zheng.

 - ACPI hotplug fixes and cleanups from Bjorn Helgaas, Toshi Kani,
   Zhang Yanfei, Rafael J Wysocki.

 - Conversion of the ACPI AC driver to the platform bus type and
   multiple driver fixes and cleanups related to ACPI from Zhang Rui.

 - ACPI processor driver fixes and cleanups from Hanjun Guo, Jiang Liu,
   Bartlomiej Zolnierkiewicz, Mathieu Rhéaume, Rafael J Wysocki.

 - Fixes and cleanups and new blacklist entries related to the ACPI
   video support from Aaron Lu, Felipe Contreras, Lennart Poettering,
   Kirill Tkhai.

 - cpuidle core cleanups from Viresh Kumar and Lorenzo Pieralisi.

 - cpuidle drivers fixes and cleanups from Daniel Lezcano, Jingoo Han,
   Bartlomiej Zolnierkiewicz, Prarit Bhargava.

 - devfreq updates from Sachin Kamat, Dan Carpenter, Manish Badarkhe.

 - Operation Performance Points (OPP) core updates from Nishanth Menon.

 - Runtime power management core fix from Rafael J Wysocki and update
   from Ulf Hansson.

 - Hibernation fixes from Aaron Lu and Rafael J Wysocki.

 - Device suspend/resume lockup detection mechanism from Benoit Goby.

 - Removal of unused proc directories created for various ACPI drivers
   from Lan Tianyu.

 - ACPI LPSS driver fix and new device IDs for the ACPI platform scan
   handler from Heikki Krogerus and Jarkko Nikula.

 - New ACPI _OSI blacklist entry for Toshiba NB100 from Levente Kurusa.

 - Assorted fixes and cleanups related to ACPI from Andy Shevchenko,
   Al Stone, Bartlomiej Zolnierkiewicz, Colin Ian King, Dan Carpenter,
   Felipe Contreras, Jianguo Wu, Lan Tianyu, Yinghai Lu, Mathias Krause,
   Liu Chuansheng.

 - Assorted PM fixes and cleanups from Andy Shevchenko, Thierry Reding,
   Jean-Christophe Plagniol-Villard.

Thanks!


---------------

Aaro Koskinen (3):
      cpufreq: pmac64: speed up frequency switch
      cpufreq: pmac64: provide cpufreq transition latency for older G5 models
      cpufreq: pmac64: enable cpufreq on iMac G5 (iSight) model

Aaron Lu (8):
      backlight: introduce backlight_device_registered
      ACPI / video: seperate backlight control and event interface
      ACPI / video: Do not register backlight if win8 and native interface exists
      thinkpad-acpi: fix handle locate for video and query of _BCL
      PM / hibernate: Avoid overflow in hibernate_preallocate_memory()
      ACPI / video: Fix initial level validity test
      ACPI / video: Quirk initial backlight level 0
      Revert "ACPI / video: Ignore BIOS initial backlight value for HP 250 G1"

Adrian Huang (1):
      intel_pstate: skip the driver if ACPI has power mgmt option

Al Stone (1):
      ACPI: improve acpi_extract_package() utility

Andy Shevchenko (2):
      ACPI / thermal: convert printk(LEVEL...) to pr_<lvl>
      PM / QoS: simplify pm_qos_power_write()

Bartlomiej Zolnierkiewicz (6):
      ACPI / processor: remove superfluous pr == NULL checks
      intel_idle: shrink states tables
      intel_idle: mark states tables with __initdata tag
      intel_idle: mark some functions with __init tag
      ARM: EXYNOS: convert cpuidle driver to be a platform driver
      x86 / ACPI: fix incorrect placement of __initdata tag

Benoit Goby (1):
      PM / Sleep: Detect device suspend/resume lockup and log event

Bjorn Helgaas (4):
      ACPICA: acpi_read: On error, do not modify the return value target location.
      ACPI / hotplug: Set kobject name via kobject_add(), not kobject_set_name()
      ACPI / hotplug: Don't set kobject parent pointer explicitly
      ACPI / hotplug: Use kobject_init_and_add() instead of _init() and _add()

Bob Moore (17):
      ACPICA: Improve error message for "too many parent prefixes" condition.
      ACPICA: Debug output: small formatting update, no functional change.
      ACPICA: Debugger: Prevent possible command line buffer overflow, kernel behavior is not affected.
      ACPICA: Validate start object for acpi_walk_namespace.
      ACPICA: Debugger: Add new command to display full namespace pathnames.
      ACPICA: SCI Handlers: Update handler interface, eliminate unnecessary argument.
      ACPICA: Update version to 20130823.
      ACPICA: Table print header function: Increase default width for table length.
      ACPICA: Add a check for a null node during namespace walk.
      ACPICA: Add history/line-editing for Unix/Linux systems.
      ACPICA: Fix a macro for the hardware-reduced case
      ACPICA: Add safe versions of common string functions.
      ACPICA: Predefine name macros: Sort list.
      ACPICA: Hardcode access width for the reset register.
      ACPICA: Clarify ACPI_FREE_BUFFER usage.
      ACPICA: Simplify configuration of global ACPI_REDUCED_HARDWARE macro.
      ACPICA: Update version to 20130927.

Colin Ian King (1):
      ACPI: Fix spelling mistake in error messages

Dan Carpenter (2):
      ACPI / osl: remove an unneeded NULL check
      PM / devfreq: create_freezable_workqueue() doesn't return an ERR_PTR

Daniel Lezcano (5):
      ARM: zynq: cpuidle: Remove useless compatibility string
      ARM: zynq: cpuidle: convert to platform driver
      ARM: ux500: cpuidle: fix section mismatch
      ARM: at91: cpuidle: Convert to platform driver
      ARM: at91: cpuidle: Move driver to drivers/cpuidle

David E. Box (1):
      ACPICA: Operation region support: Never free the handler "context" pointer.

Dirk Brandewie (3):
      intel_pstate: Refactor driver to support CPUs with different MSR layouts
      intel_pstate: Add Baytrail support
      cpufreq/intel_pstate: Add static declarations to internal functions

Evgeny Kapaev (1):
      speedstep-centrino: Remove unnecessary braces

Felipe Contreras (4):
      ACP / fan: trivial style cleanup
      ACPI: update win8 OSI blacklist
      ACPI: add missing win8 OSI comment to blacklist
      ACPI / blacklist: fix name of ThinkPad Edge E530

Hanjun Guo (2):
      ACPI / processor: remove unnecessary if (!pr) check
      ACPI / processor: Remove outdated comments

Hans-Christian Egtvedt (1):
      cpufreq: at32ap: add frequency table

Heikki Krogerus (2):
      ACPI / LPSS: fix UART Auto Flow Control
      ACPI / platform: add ACPI ID for a Broadcom GPS chip

Jacob Pan (2):
      x86 / msr: add 64bit _on_cpu access functions
      PowerCap: Introduce Intel RAPL power capping driver

Jarkko Nikula (1):
      ACPI / platform: Add ACPI IDs for Intel SST audio device

Jean-Christophe PLAGNIOL-VILLARD (2):
      ARM: AT91: pm: Factorize standby function
      ARM: AT91: DT: pm: Select ram controller standby based on DT

Jiang Liu (4):
      ACPI / processor: Introduce apic_id in struct processor to save parsed APIC id
      ACPI / processor: use apic_id and remove duplicated _MAT evaluation
      x86 / ACPI: simplify _acpi_map_lsapic()
      ACPI / processor: remove some dead code in acpi_processor_get_info()

Jianguo Wu (1):
      ACPI / mm: use NUMA_NO_NODE

Jingoo Han (2):
      ARM: EXYNOS: Use dev_err() instead of printk() for cpuidle driver
      ARM: EXYNOS: Remove incorrect __init annotation from cpuidle driver

Jungseok Lee (1):
      cpufreq: exynos: Show a list of available frequencies

Kirill Tkhai (1):
      ACPI / video: Ignore BIOS initial backlight value for HP 250 G1

Lan Tianyu (9):
      ACPI / button: Using input_set_capability() to mark device's event capability
      ACPI / EC: Convert all printk() calls to dynamic debug function
      ACPI / sysfs: make GPE sysfs attributes only accept correct values
      ACPI / Battery: Remove battery's proc directory
      ACPI / SBS: Remove SBS's proc directory
      ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c
      ACPI / proc: Remove alarm proc file
      ACPI / AC: Remove AC's proc directory.
      cpufreq / governor: Remove fossil comment

Lennart Poettering (1):
      ACPI / video: Add Lenovo IdeaPad Yoga 13 to acpi video detect blacklist

Levente Kurusa (1):
      ACPI: Add Toshiba NB100 to Vista _OSI blacklist

Liu Chuansheng (1):
      ACPI / osl: implement acpi_os_sleep() with msleep()

Lorenzo Pieralisi (1):
      drivers: cpuidle: rename ARM big.LITTLE driver config and makefile entries

Lukasz Majewski (2):
      cpufreq: exynos4x12: Use the common clock framework to set APLL clock rate
      cpufreq: exynos4210: Use the common clock framework to set APLL clock rate

Lv Zheng (40):
      ACPICA: Add support for host-installed SCI handlers.
      ACPICA: Tables: Cleanup table checksum verification code.
      ACPICA: Tables: Cleanup RSDP signature codes.
      ACPICA: Cleanup exception codes.
      ACPI / IPMI: Fix potential response buffer overflow
      ACPI / IPMI: Fix race caused by the unprotected ACPI IPMI transfers
      ACPI / IPMI: Fix race caused by the timed out ACPI IPMI transfers
      ACPI / IPMI: Fix race caused by the unprotected ACPI IPMI user
      ACPI / IPMI: Use global IPMI operation region handler
      ACPI / IPMI: Add reference counting for ACPI IPMI transfers
      ACPI / IPMI: Cleanup several acpi_ipmi_device members
      ACPI / IPMI: Cleanup some initialization codes
      ACPI / IPMI: Cleanup some inclusion codes
      ACPI / IPMI: Cleanup some Kconfig codes
      ACPI / IPMI: Cleanup coding styles
      i2c: attach/detach I2C client device to the ACPI power domain
      ACPICA: Cleanup memory allocation macros and configurability.
      ACPICA: Fix possible memory leaks in the GPE handling.
      ACPICA: Add EXPORT_ACPI_INTERFACES macro to external interface modules.
      ACPICA: Linuxize: Change indentation of C labels.
      ACPICA: Deploy ACPI_EXPORT_SYMBOL_INIT for main ACPICA initialization interfaces.
      ACPICA: Prevent possible build issues for use of ACPI_PRINTF_LIKE macro
      ACPICA: Fix indentation issues for macro invocations.
      ACPICA: Add support to allow host OS to redefine individual OSL prototypes.
      ACPICA: Update aclinux.h for new OSL override mechanism.
      ACPICA: Update default space handlers.
      ACPICA: Update check for setting the ANOBJ_IS_EXTERNAL flag.
      ACPICA: Update namespace dump code.
      ACPICA: Update RSDP table definitions.
      ACPICA: Update DMAR table definitions.
      ACPICA: Add new statistics interface.
      ACPICA: Fix wrong object length returned by acpi_ut_get_simple_object_size().
      ACPICA: Fix an ACPI_ALLOCATE_ZEROED() reversal.
      ACPICA: Cleanup useless memset invocations.
      ACPICA: Remove dead AOPOBJ_INVALID check.
      ACPICA: Fix cached object deletion code.
      ACPICA: Update compilation environment settings.
      ACPICA: Update acpidump related header file changes.
      ACPICA: Cleanup asmlinkage for ACPICA APIs.
      ACPICA: Add __init for ACPICA initializers/finalizers.

Manish Badarkhe (2):
      PM / devfreq: Remove duplicate include of opp.h
      exynos-cpufreq: fix false return check from "regulator_set_voltage"

Mark Langsdorf (1):
      cpufreq: highbank-cpufreq: Enable Midway/ECX-2000

Mathias Krause (1):
      ACPI / event: remove unneeded NULL pointer check

Mathieu Rhéaume (1):
      ACPI / processor: fixed a brace coding style issue

Mika Westerberg (2):
      ACPI / PM: allow child devices to ignore parent power state
      spi: attach/detach SPI device to the ACPI power domain

Naresh Bhat (1):
      ACPICA: Linux-specific header: enable "aarch64" 64-bit build.

Nicolas Pitre (1):
      cpufreq: arm_big_little: reconfigure switcher behavior at run time

Nishanth Menon (3):
      PM / OPP: rename functions to dev_pm_opp*
      PM / OPP: rename data structures to dev_pm equivalents
      PM / OPP: rename header to linux/pm_opp.h

Prarit Bhargava (1):
      intel_idle: use CPU_TASKS_FROZEN instead of a numeric constant

Rafael J. Wysocki (14):
      MAINTAINERS / ACPICA: Add ACPICA information to MAINTAINERS
      PM / Hibernate: Use bool for boolean fields of struct snapshot_data
      ACPI / processor: Do not request ACPI cpufreq module directly
      ACPI: Remove acpi_pci_slot_init() headers from internal.h
      ACPI / scan: Start matching drivers after trying scan handlers
      ACPI / hotplug: Refuse to hot-remove all objects with disabled hotplug
      ACPI / hotplug: Fix handle_root_bridge_removal()
      ACPI / hotplug: Simplify device ejection routines
      ACPI / hotplug: Make acpi_bus_hot_remove_device() internal
      ACPI / hotplug: Merge device hot-removal routines
      ACPI / hotplug: Carry out PCI root eject directly
      ACPI / hotplug: Do not execute "insert in progress" _OST
      PM / runtime: Use pm_runtime_put_sync() in __device_release_driver()
      ACPI / hotplug: Consolidate deferred execution of ACPI hotplug routines

Sachin Kamat (4):
      PM / devfreq: Fix incorrect usage of IS_ERR_OR_NULL in exynos5_bus.c
      PM / devfreq: Remove redundant platform_set_drvdata() in exynos5_bus.c
      PM / devfreq: Use devm_* APIs in exynos5_bus.c
      PM / devfreq: Remove duplicate header file inclusion in exynos5_bus.c

Srinivas Pandruvada (5):
      PowerCap: Documentation
      PowerCap: Add class driver
      PowerCap: Add to drivers Kconfig and Makefile
      bitops: Introduce BIT_ULL
      PowerCap: Fix build error with option -Werror=format-security

Srivatsa S. Bhat (1):
      cpufreq: Detect spurious invocations of update_policy_cpu()

Stratos Karafotis (1):
      cpufreq: ondemand: Remove redundant return statement

Sudeep KarkadaNagesha (5):
      cpufreq: arm-big-little: use clk_get instead of clk_get_sys
      ARM: vexpress/TC2: add support for CPU DVFS
      ARM: vexpress/TC2: add cpu clock support
      cpufreq: arm_big_little: add vexpress SPC interface driver
      ARM: vexpress/TC2: register vexpress-spc cpufreq device

Thierry Reding (1):
      PowerCap: Convert class code to use dev_groups

Tomasz Nowicki (1):
      ACPICA: Ensure that debug output is immediately disabled on termination.

Toshi Kani (4):
      hotplug / x86: Fix online state in cpu0 debug interface
      hotplug / x86: Add hotplug lock to missing places
      hotplug / x86: Disable ARCH_CPU_PROBE_RELEASE on x86
      hotplug, powerpc, x86: Remove cpu_hotplug_driver_lock()

Ulf Hansson (1):
      PM / Runtime: Respect autosuspend when idle triggers suspend

Viresh Kumar (165):
      cpufreq: Add new helper cpufreq_table_validate_and_show()
      cpufreq: pxa: call cpufreq_frequency_table_get_attr()
      cpufreq: s3cx4xx: call cpufreq_frequency_table_get_attr()
      cpufreq: sparc: call cpufreq_frequency_table_get_attr()
      cpufreq: acpi-cpufreq: use cpufreq_table_validate_and_show()
      cpufreq: arm_big_little: use cpufreq_table_validate_and_show()
      cpufreq: blackfin: use cpufreq_table_validate_and_show()
      cpufreq: cpufreq-cpu0: use cpufreq_table_validate_and_show()
      cpufreq: cris: use cpufreq_table_validate_and_show()
      cpufreq: davinci: use cpufreq_table_validate_and_show()
      cpufreq: dbx500: use cpufreq_table_validate_and_show()
      cpufreq: e_powersaver: use cpufreq_table_validate_and_show()
      cpufreq: elanfreq: use cpufreq_table_validate_and_show()
      cpufreq: exynos: use cpufreq_table_validate_and_show()
      cpufreq: ia64-acpi: use cpufreq_table_validate_and_show()
      cpufreq: imx6q: use cpufreq_table_validate_and_show()
      cpufreq: kirkwood: use cpufreq_table_validate_and_show()
      cpufreq: longhaul: use cpufreq_table_validate_and_show()
      cpufreq: loongson2: use cpufreq_table_validate_and_show()
      cpufreq: maple: use cpufreq_table_validate_and_show()
      cpufreq: omap: use cpufreq_table_validate_and_show()
      cpufreq: p4-clockmod: use cpufreq_table_validate_and_show()
      cpufreq: pasemi: use cpufreq_table_validate_and_show()
      cpufreq: pmac: use cpufreq_table_validate_and_show()
      cpufreq: powernow: use cpufreq_table_validate_and_show()
      cpufreq: ppc: use cpufreq_table_validate_and_show()
      cpufreq: pxa: use cpufreq_table_validate_and_show()
      cpufreq: s3cx4xx: use cpufreq_table_validate_and_show()
      cpufreq: s5pv210: use cpufreq_table_validate_and_show()
      cpufreq: sa11x0: Expose frequency table
      cpufreq: sa11x0: let cpufreq core initialize struct policy fields
      cpufreq: sc520: use cpufreq_table_validate_and_show()
      cpufreq: sh: use cpufreq_table_validate_and_show()
      cpufreq: sparc: use cpufreq_table_validate_and_show()
      cpufreq: spear: use cpufreq_table_validate_and_show()
      cpufreq: speedstep: use cpufreq_table_validate_and_show()
      cpufreq: tegra: use cpufreq_table_validate_and_show()
      cpufreq: tegra: fix implementation of ->exit()
      cpufreq: arm_big_little: call cpufreq_frequency_table_put_attr()
      cpufreq: blackfin: call cpufreq_frequency_table_put_attr()
      cpufreq: exynos: call cpufreq_frequency_table_put_attr()
      cpufreq: loongson2: call cpufreq_frequency_table_put_attr()
      cpufreq: omap: call cpufreq_frequency_table_put_attr()
      cpufreq: make return type of lock_policy_rwsem_{read|write}() as void
      cpufreq: remove invalid comment from __cpufreq_remove_dev()
      cpufreq: Remove extra blank line
      cpufreq: don't break string in print statements
      cpufreq: remove __cpufreq_remove_dev()
      cpufreq: Optimize cpufreq_frequency_table_verify()
      cpufreq: rename __cpufreq_set_policy() as cpufreq_set_policy()
      cpufreq: rewrite cpufreq_driver->flags using shift operator
      cpufreq: use cpufreq_driver->flags to mark CPUFREQ_HAVE_GOVERNOR_PER_POLICY
      cpufreq: add new routine cpufreq_verify_within_cpu_limits()
      cpufreq: define generic .attr, .exit() and .verify() routines
      cpufreq: acpi: Use generic cpufreq routines
      cpufreq: arm_big_little: Use generic cpufreq routines
      cpufreq: at32ap: Use generic cpufreq routines
      cpufreq: blackfin: Use generic cpufreq routines
      cpufreq: cpufreq-cpu0: Use generic cpufreq routines
      cpufreq: cris: Use generic cpufreq routines
      cpufreq: davinci: Use generic cpufreq routines
      cpufreq: dbx500: Use generic cpufreq routines
      cpufreq: e_powersaver: Use generic cpufreq routines
      cpufreq: elanfreq: Use generic cpufreq routines
      cpufreq: exynos: Use generic cpufreq routines
      cpufreq: ia64-acpi: Use generic cpufreq routines
      cpufreq: imx6q: Use generic cpufreq routines
      cpufreq: kirkwood: Use generic cpufreq routines
      cpufreq: longhaul: Use generic cpufreq routines
      cpufreq: loongson2: Use generic cpufreq routines
      cpufreq: maple: Use generic cpufreq routines
      cpufreq: omap: Use generic cpufreq routines
      cpufreq: p4-clockmod: Use generic cpufreq routines
      cpufreq: pasemi: Use generic cpufreq routines
      cpufreq: pmac: Use generic cpufreq routines
      cpufreq: powernow: Use generic cpufreq routines
      cpufreq: ppc-corenet: Use generic cpufreq routines
      cpufreq: ppc_cbe: Use generic cpufreq routines
      cpufreq: pxa: Use generic cpufreq routines
      cpufreq: s3cx4xx: Use generic cpufreq routines
      cpufreq: s5pv210: Use generic cpufreq routines
      cpufreq: sa11x0: Use generic cpufreq routines
      cpufreq: sc520: Use generic cpufreq routines
      cpufreq: sh: Use generic cpufreq routines
      cpufreq: sparc: Use generic cpufreq routines
      cpufreq: spear: Use generic cpufreq routines
      cpufreq: speedstep: Use generic cpufreq routines
      cpufreq: tegra: Use generic cpufreq routines
      cpufreq: call cpufreq_driver->get() after calling ->init()
      cpufreq: acpi-cpufreq: don't initialize part of policy set by core
      cpufreq: arm_big_little: don't initialize part of policy is set by core
      cpufreq: at32ap: don't initialize part of policy set by core
      cpufreq: blackfin: don't initialize part of policy set by core
      cpufreq: cpu0: don't initialize part of policy set by core too
      cpufreq: nforce2: don't initialize part of policy set by core
      cpufreq: cris: don't initialize part of policy set by core
      cpufreq: davinci: don't initialize part of policy set by core
      cpufreq: dbx500: don't initialize part of policy set by core
      cpufreq: e_powersaver: don't initialize part of policy set by core
      cpufreq: elanfreq: don't initialize part of policy set by core
      cpufreq: exynos: don't initialize part of policy set by core
      cpufreq: gx: don't initialize part of policy set by core
      cpufreq: ia64-acpi: don't initialize part of policy set by core
      cpufreq: imx6q: don't initialize part of policy set by core
      cpufreq: integrator: don't initialize part of policy set by core
      cpufreq: kirkwood: don't initialize part of policy set by core
      cpufreq: longhaul: don't initialize part of policy set by core
      cpufreq: loongson2: don't initialize part of policy set by core
      cpufreq: maple: don't initialize part of policy set by core
      cpufreq: omap: don't initialize part of policy set by core
      cpufreq: p4: don't initialize part of policy set by core
      cpufreq: pcc: don't initialize part of policy set by core
      cpufreq: pmac: don't initialize part of policy set by core
      cpufreq: powernow: don't initialize part of policy set by core
      cpufreq: ppc: don't initialize part of policy set by core
      cpufreq: pxa: don't initialize part of policy set by core
      cpufreq: s3c: don't initialize part of policy set by core
      cpufreq: s5pv210: don't initialize part of policy set by core
      cpufreq: sa11x0: don't initialize part of policy set by core
      cpufreq: sc520_freq: don't initialize part of policy set by core
      cpufreq: sh: don't initialize part of policy set by core
      cpufreq: spear: don't initialize part of policy set by core
      cpufreq: speedstep: don't initialize part of policy set by core
      cpufreq: tegra: don't initialize part of policy set by core
      cpufreq: unicore2: don't initialize part of policy set by core
      cpufreq: create cpufreq_generic_init() routine
      cpufreq: remove CONFIG_CPU_FREQ_TABLE
      cpufreq: cpufreq-cpu0: use cpufreq_generic_init()
      cpufreq: cris: use cpufreq_generic_init()
      cpufreq: davinci: use cpufreq_generic_init()
      cpufreq: dbx500: use cpufreq_generic_init()
      cpufreq: exynos: use cpufreq_generic_init()
      cpufreq: imx6q: use cpufreq_generic_init()
      cpufreq: kirkwood: use cpufreq_generic_init()
      cpufreq: loongson2: use cpufreq_generic_init()
      cpufreq: maple: use cpufreq_generic_init()
      cpufreq: omap: use cpufreq_generic_init()
      cpufreq: pasemi: use cpufreq_generic_init()
      cpufreq: pmac32: use cpufreq_generic_init()
      cpufreq: pmac64: use cpufreq_generic_init()
      cpufreq: s3c: use cpufreq_generic_init()
      cpufreq: s5pv210: use cpufreq_generic_init()
      cpufreq: sa11x0: use cpufreq_generic_init()
      cpufreq: spear: use cpufreq_generic_init()
      cpufreq: tegra: use cpufreq_generic_init()
      cpufreq: sa11x0: Fix build breakage after "Expose frequency table"
      acpi-cpufreq: Add comment under ACPI_ADR_SPACE_SYSTEM_IO case
      cpufreq: Implement light weight ->target_index() routine
      cpuidle: fix indentation of cpumask
      cpuidle: Fix comments in cpuidle core
      cpuidle: make __cpuidle_device_init() return void
      cpuidle: make __cpuidle_driver_init() return void
      cpuidle: rearrange code in __cpuidle_driver_init()
      cpuidle: rearrange __cpuidle_register_device() to keep minimal exit points
      cpuidle: merge two if() statements for checking error cases
      cpuidle: reduce code duplication inside cpuidle_idle_call()
      cpuidle: replace multiline statements with single line in cpuidle_idle_call()
      cpuidle: call cpuidle_get_driver() from after taking cpuidle_driver_lock
      cpuidle: use drv instead of cpuidle_driver in show_current_driver()
      cpuidle: don't call poll_idle_init() for every cpu
      cpuidle: remove cpuidle_unregister_governor()
      cpufreq: arm_big_little: add in-kernel switching (IKS) support
      cpufreq: distinguish drivers that do asynchronous notifications
      cpufreq: move freq change notifications to cpufreq core
      cpufreq: create per policy rwsem instead of per CPU cpu_policy_rwsem

Xiaoguang Chen (1):
      cpufreq: conservative: fix requested_freq reduction issue

Yinghai Lu (1):
      ACPI / x86: Increase override tables number limit

Zhang Rui (33):
      olpc_xo15_sci: convert acpi_evaluate_object() to acpi_execute_simple_method()
      gpiolib-acpi: convert acpi_evaluate_object() to acpi_execute_simple_method()
      eeepc-laptop: convert acpi_evaluate_object() to acpi_execute_simple_method()
      fujitsu-laptop: convert acpi_evaluate_object() to acpi_execute_simple_method()
      intel-rst: convert acpi_evaluate_object() to acpi_execute_simple_method()
      intel-smartconnect: convert acpi_evaluate_object() to acpi_execute_simple_method()
      topstar-laptop: convert acpi_evaluate_object() to acpi_execute_simple_method()
      toshiba_acpi: convert acpi_evaluate_object() to acpi_execute_simple_method()
      wmi: convert acpi_evaluate_object() to acpi_execute_simple_method()
      pcc_freq: convert acpi_get_handle() to acpi_has_method()
      i915: intel_acpi: convert acpi_get_handle() to acpi_has_method()
      nouveau_acpi: convert acpi_get_handle() to acpi_has_method()
      acpi_pcihp: convert acpi_get_handle() to acpi_has_method()
      pci-acpi: convert acpi_get_handle() to acpi_has_method()
      fujitsu-laptop: convert acpi_get_handle() to acpi_has_method()
      intel_menlow: convert acpi_get_handle() to acpi_has_method()
      sony-laptop: convert acpi_get_handle() to acpi_has_method()
      toshiba_acpi: convert acpi_get_handle() to acpi_has_method()
      wmi: convert acpi_get_handle() to acpi_has_method()
      pnpacpi: convert acpi_get_handle() to acpi_has_method()
      acpi_processor: convert acpi_evaluate_object() to acpi_evaluate_integer()
      ACPI: dock: convert acpi_evaluate_object() to acpi_evaluate_integer()
      i2c-hid: convert acpi_evaluate_object() to acpi_evaluate_integer()
      fujitsu-laptop: convert acpi_evaluate_object() to acpi_evaluate_integer()
      intel-rst: convert acpi_evaluate_object() to acpi_evaluate_integer()
      intel-smartconnect: convert acpi_evaluate_object() to acpi_evaluate_integer()
      toshiba_acpi: convert acpi_evaluate_object() to acpi_evaluate_integer()
      ACPI / AC: convert ACPI ac driver to platform bus
      ideapad_laptop: introduce #ifdef CONFIG_PM_SLEEP for PM specific code
      ideapad_laptop: introduce struct acpi_device pointer to ideapad_private structure
      ideapad_laptop: convert internal function calls to use ideapad_private as parameter
      ideapad_laptop: remove ideapad_handle and ideapad_priv
      ideapad_laptop: convert ideapad device/driver to platform bus

Zhang Yanfei (1):
      ACPI / memhotplug: Use defined marco METHOD_NAME__STA

---------------

 Documentation/ABI/testing/sysfs-class-powercap     |  152 +++
 Documentation/cpu-freq/cpu-drivers.txt             |   27 +-
 Documentation/cpu-freq/governors.txt               |    4 +-
 Documentation/cpuidle/governor.txt                 |    1 -
 Documentation/power/opp.txt                        |  108 +-
 Documentation/power/powercap/powercap.txt          |  236 ++++
 Documentation/power/runtime_pm.txt                 |   14 +-
 MAINTAINERS                                        |   14 +
 arch/arm/mach-at91/Makefile                        |    1 -
 arch/arm/mach-at91/at91rm9200.c                    |    2 +
 arch/arm/mach-at91/at91sam9260.c                   |    2 +
 arch/arm/mach-at91/at91sam9261.c                   |    2 +
 arch/arm/mach-at91/at91sam9263.c                   |    2 +
 arch/arm/mach-at91/at91sam9g45.c                   |    2 +
 arch/arm/mach-at91/at91sam9rl.c                    |    2 +
 arch/arm/mach-at91/pm.c                            |   27 +-
 arch/arm/mach-at91/pm.h                            |   59 +-
 arch/arm/mach-at91/setup.c                         |   14 +-
 arch/arm/mach-davinci/Kconfig                      |    1 -
 arch/arm/mach-exynos/common.c                      |   11 +
 arch/arm/mach-exynos/common.h                      |    1 +
 arch/arm/mach-exynos/cpuidle.c                     |   18 +-
 arch/arm/mach-exynos/mach-exynos4-dt.c             |    2 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    2 +
 arch/arm/mach-imx/mach-imx6q.c                     |    4 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   10 +-
 arch/arm/mach-omap2/omap-pm.h                      |    2 +-
 arch/arm/mach-omap2/opp.c                          |    6 +-
 arch/arm/mach-omap2/pm.c                           |    8 +-
 arch/arm/mach-pxa/Kconfig                          |    3 -
 arch/arm/mach-sa1100/generic.c                     |   81 +-
 arch/arm/mach-sa1100/generic.h                     |    7 +-
 arch/arm/mach-ux500/Kconfig                        |    1 -
 arch/arm/mach-vexpress/Kconfig                     |   12 +
 arch/arm/mach-vexpress/Makefile                    |    3 +-
 arch/arm/mach-vexpress/spc.c                       |  366 ++++-
 arch/arm/mach-vexpress/spc.h                       |    2 +-
 arch/arm/mach-vexpress/tc2_pm.c                    |    7 +-
 arch/arm/mach-zynq/common.c                        |    6 +
 arch/blackfin/Kconfig                              |    1 -
 arch/cris/Kconfig                                  |    2 -
 arch/ia64/kernel/acpi.c                            |   38 +-
 arch/powerpc/kernel/smp.c                          |   12 -
 arch/powerpc/platforms/pseries/dlpar.c             |   43 +-
 arch/x86/Kconfig                                   |    4 -
 arch/x86/include/asm/acpi.h                        |    1 +
 arch/x86/include/asm/mpspec.h                      |    2 +-
 arch/x86/include/asm/msr.h                         |   22 +
 arch/x86/kernel/acpi/boot.c                        |   90 +-
 arch/x86/kernel/acpi/sleep.c                       |   11 +
 arch/x86/kernel/acpi/sleep.h                       |    2 +
 arch/x86/kernel/acpi/wakeup_32.S                   |    2 +-
 arch/x86/kernel/acpi/wakeup_64.S                   |    2 +-
 arch/x86/kernel/apic/apic.c                        |    8 +-
 arch/x86/kernel/smpboot.c                          |   21 -
 arch/x86/kernel/topology.c                         |   11 +-
 arch/x86/lib/msr-smp.c                             |   62 +
 arch/x86/platform/olpc/olpc-xo15-sci.c             |    9 +-
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/acpi/Kconfig                               |   20 +-
 drivers/acpi/Makefile                              |    1 -
 drivers/acpi/ac.c                                  |  256 +---
 drivers/acpi/acpi_ipmi.c                           |  580 ++++----
 drivers/acpi/acpi_lpss.c                           |   12 +-
 drivers/acpi/acpi_memhotplug.c                     |    7 +-
 drivers/acpi/acpi_platform.c                       |    7 +
 drivers/acpi/acpi_processor.c                      |   28 +-
 drivers/acpi/acpica/acdebug.h                      |    8 +-
 drivers/acpi/acpica/acevents.h                     |    9 +-
 drivers/acpi/acpica/acglobal.h                     |   20 +-
 drivers/acpi/acpica/aclocal.h                      |   11 +-
 drivers/acpi/acpica/acmacros.h                     |   31 -
 drivers/acpi/acpica/acnamesp.h                     |    6 +
 drivers/acpi/acpica/acutils.h                      |   17 +-
 drivers/acpi/acpica/dsargs.c                       |    2 +-
 drivers/acpi/acpica/dsfield.c                      |    2 +-
 drivers/acpi/acpica/dsmethod.c                     |    5 +-
 drivers/acpi/acpica/dsobject.c                     |    2 +-
 drivers/acpi/acpica/dsopcode.c                     |    2 +-
 drivers/acpi/acpica/dsutils.c                      |   10 +-
 drivers/acpi/acpica/dswexec.c                      |    6 +-
 drivers/acpi/acpica/dswload2.c                     |    2 +-
 drivers/acpi/acpica/evglock.c                      |    2 +-
 drivers/acpi/acpica/evgpe.c                        |    3 +-
 drivers/acpi/acpica/evgpeblk.c                     |    6 +-
 drivers/acpi/acpica/evgpeinit.c                    |    2 +-
 drivers/acpi/acpica/evgpeutil.c                    |    4 +-
 drivers/acpi/acpica/evhandler.c                    |    4 +-
 drivers/acpi/acpica/evmisc.c                       |   14 +-
 drivers/acpi/acpica/evregion.c                     |   29 +-
 drivers/acpi/acpica/evsci.c                        |   79 +-
 drivers/acpi/acpica/evxface.c                      |  148 ++-
 drivers/acpi/acpica/evxfevnt.c                     |    3 +-
 drivers/acpi/acpica/evxfgpe.c                      |    9 +-
 drivers/acpi/acpica/evxfregn.c                     |    7 +-
 drivers/acpi/acpica/excreate.c                     |    8 +-
 drivers/acpi/acpica/exfield.c                      |    2 +-
 drivers/acpi/acpica/exfldio.c                      |    8 +-
 drivers/acpi/acpica/exmisc.c                       |    4 +-
 drivers/acpi/acpica/exoparg1.c                     |    8 +-
 drivers/acpi/acpica/exoparg2.c                     |   10 +-
 drivers/acpi/acpica/exoparg3.c                     |    4 +-
 drivers/acpi/acpica/exoparg6.c                     |    2 +-
 drivers/acpi/acpica/exregion.c                     |    1 +
 drivers/acpi/acpica/exresolv.c                     |    2 +-
 drivers/acpi/acpica/exresop.c                      |    2 +-
 drivers/acpi/acpica/hwregs.c                       |    2 +-
 drivers/acpi/acpica/hwtimer.c                      |    3 +-
 drivers/acpi/acpica/hwxface.c                      |   43 +-
 drivers/acpi/acpica/hwxfsleep.c                    |    7 +-
 drivers/acpi/acpica/nsaccess.c                     |    7 +-
 drivers/acpi/acpica/nsdump.c                       |  143 +-
 drivers/acpi/acpica/nsdumpdv.c                     |    7 +-
 drivers/acpi/acpica/nseval.c                       |    4 +-
 drivers/acpi/acpica/nsinit.c                       |    2 +-
 drivers/acpi/acpica/nsload.c                       |    2 +-
 drivers/acpi/acpica/nsparse.c                      |    2 +-
 drivers/acpi/acpica/nspredef.c                     |    2 +-
 drivers/acpi/acpica/nsprepkg.c                     |    4 +-
 drivers/acpi/acpica/nsrepair.c                     |    2 +-
 drivers/acpi/acpica/nsrepair2.c                    |    2 +-
 drivers/acpi/acpica/nssearch.c                     |    3 +-
 drivers/acpi/acpica/nsutils.c                      |    2 +-
 drivers/acpi/acpica/nsxfeval.c                     |   23 +-
 drivers/acpi/acpica/nsxfname.c                     |    7 +-
 drivers/acpi/acpica/nsxfobj.c                      |    7 +-
 drivers/acpi/acpica/psparse.c                      |    2 +-
 drivers/acpi/acpica/psxface.c                      |    6 +-
 drivers/acpi/acpica/rsmisc.c                       |    4 +-
 drivers/acpi/acpica/rsutils.c                      |    2 +-
 drivers/acpi/acpica/rsxface.c                      |    3 +-
 drivers/acpi/acpica/tbinstal.c                     |   18 +-
 drivers/acpi/acpica/tbprint.c                      |   18 +-
 drivers/acpi/acpica/tbutils.c                      |    5 +-
 drivers/acpi/acpica/tbxface.c                      |   16 +-
 drivers/acpi/acpica/tbxfload.c                     |   11 +-
 drivers/acpi/acpica/tbxfroot.c                     |    5 +-
 drivers/acpi/acpica/utalloc.c                      |  117 +-
 drivers/acpi/acpica/utcache.c                      |    2 +-
 drivers/acpi/acpica/utcopy.c                       |    4 +-
 drivers/acpi/acpica/utdebug.c                      |    5 +-
 drivers/acpi/acpica/utdecode.c                     |    1 -
 drivers/acpi/acpica/utdelete.c                     |    2 +-
 drivers/acpi/acpica/uteval.c                       |    2 +-
 drivers/acpi/acpica/utexcep.c                      |    3 +-
 drivers/acpi/acpica/utglobal.c                     |   20 +-
 drivers/acpi/acpica/utids.c                        |    2 +-
 drivers/acpi/acpica/utobject.c                     |   26 +-
 drivers/acpi/acpica/utownerid.c                    |    2 +-
 drivers/acpi/acpica/utresrc.c                      |    4 +-
 drivers/acpi/acpica/utstate.c                      |    1 -
 drivers/acpi/acpica/utstring.c                     |   66 +-
 drivers/acpi/acpica/uttrack.c                      |   31 +-
 drivers/acpi/acpica/utxface.c                      |   45 +-
 drivers/acpi/acpica/utxferror.c                    |    3 +-
 drivers/acpi/acpica/utxfinit.c                     |   18 +-
 drivers/acpi/battery.c                             |  328 +----
 drivers/acpi/blacklist.c                           |   63 +-
 drivers/acpi/button.c                              |    9 +-
 drivers/acpi/cm_sbs.c                              |  105 --
 drivers/acpi/device_pm.c                           |    8 +-
 drivers/acpi/dock.c                                |   31 +-
 drivers/acpi/ec.c                                  |   49 +-
 drivers/acpi/event.c                               |    5 -
 drivers/acpi/fan.c                                 |    2 +-
 drivers/acpi/internal.h                            |   10 +-
 drivers/acpi/numa.c                                |    4 +-
 drivers/acpi/osl.c                                 |  144 +-
 drivers/acpi/pci_root.c                            |   51 +-
 drivers/acpi/proc.c                                |  305 -----
 drivers/acpi/processor_core.c                      |   26 +-
 drivers/acpi/processor_driver.c                    |    4 +-
 drivers/acpi/processor_idle.c                      |   15 +-
 drivers/acpi/processor_perflib.c                   |   22 -
 drivers/acpi/sbs.c                                 |  325 +----
 drivers/acpi/scan.c                                |  176 +--
 drivers/acpi/sysfs.c                               |   18 +-
 drivers/acpi/thermal.c                             |   43 +-
 drivers/acpi/utils.c                               |   21 +-
 drivers/acpi/video.c                               |  461 ++++---
 drivers/acpi/video_detect.c                        |   12 +-
 drivers/base/cpu.c                                 |   39 +-
 drivers/base/dd.c                                  |    2 +-
 drivers/base/power/main.c                          |   73 +
 drivers/base/power/opp.c                           |  115 +-
 drivers/base/power/runtime.c                       |    5 +-
 drivers/cpufreq/Kconfig                            |   11 -
 drivers/cpufreq/Kconfig.arm                        |   19 +-
 drivers/cpufreq/Kconfig.powerpc                    |    6 -
 drivers/cpufreq/Kconfig.x86                        |   13 -
 drivers/cpufreq/Makefile                           |    6 +-
 drivers/cpufreq/acpi-cpufreq.c                     |   52 +-
 drivers/cpufreq/arm_big_little.c                   |  453 ++++++-
 drivers/cpufreq/arm_big_little.h                   |    5 -
 drivers/cpufreq/arm_big_little_dt.c                |    2 +-
 drivers/cpufreq/at32ap-cpufreq.c                   |  106 +-
 drivers/cpufreq/blackfin-cpufreq.c                 |   54 +-
 drivers/cpufreq/cpufreq-cpu0.c                     |  119 +-
 drivers/cpufreq/cpufreq-nforce2.c                  |    5 +-
 drivers/cpufreq/cpufreq.c                          |  322 ++---
 drivers/cpufreq/cpufreq_conservative.c             |    7 +-
 drivers/cpufreq/cpufreq_governor.h                 |    5 +-
 drivers/cpufreq/cpufreq_ondemand.c                 |    1 -
 drivers/cpufreq/cpufreq_userspace.c                |   11 -
 drivers/cpufreq/cris-artpec3-cpufreq.c             |   64 +-
 drivers/cpufreq/cris-etraxfs-cpufreq.c             |   61 +-
 drivers/cpufreq/davinci-cpufreq.c                  |   77 +-
 drivers/cpufreq/dbx500-cpufreq.c                   |   78 +-
 drivers/cpufreq/e_powersaver.c                     |   59 +-
 drivers/cpufreq/elanfreq.c                         |   88 +-
 drivers/cpufreq/exynos-cpufreq.c                   |   85 +-
 drivers/cpufreq/exynos4210-cpufreq.c               |   67 +-
 drivers/cpufreq/exynos4x12-cpufreq.c               |   69 +-
 drivers/cpufreq/exynos5440-cpufreq.c               |   67 +-
 drivers/cpufreq/freq_table.c                       |   59 +-
 drivers/cpufreq/gx-suspmod.c                       |    5 +-
 drivers/cpufreq/highbank-cpufreq.c                 |    3 +-
 drivers/cpufreq/ia64-acpi-cpufreq.c                |   71 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |  117 +-
 drivers/cpufreq/integrator-cpufreq.c               |   14 +-
 drivers/cpufreq/intel_pstate.c                     |  255 +++-
 drivers/cpufreq/kirkwood-cpufreq.c                 |  107 +-
 drivers/cpufreq/longhaul.c                         |   45 +-
 drivers/cpufreq/longrun.c                          |    4 +-
 drivers/cpufreq/loongson2_cpufreq.c                |   57 +-
 drivers/cpufreq/maple-cpufreq.c                    |   56 +-
 drivers/cpufreq/omap-cpufreq.c                     |  143 +-
 drivers/cpufreq/p4-clockmod.c                      |   53 +-
 drivers/cpufreq/pasemi-cpufreq.c                   |   51 +-
 drivers/cpufreq/pcc-cpufreq.c                      |   15 +-
 drivers/cpufreq/pmac32-cpufreq.c                   |   53 +-
 drivers/cpufreq/pmac64-cpufreq.c                   |   70 +-
 drivers/cpufreq/powernow-k6.c                      |   67 +-
 drivers/cpufreq/powernow-k7.c                      |   42 +-
 drivers/cpufreq/powernow-k8.c                      |   52 +-
 drivers/cpufreq/ppc-corenet-cpufreq.c              |   54 +-
 drivers/cpufreq/ppc_cbe_cpufreq.c                  |   50 +-
 drivers/cpufreq/pxa2xx-cpufreq.c                   |   70 +-
 drivers/cpufreq/pxa3xx-cpufreq.c                   |   46 +-
 drivers/cpufreq/s3c2416-cpufreq.c                  |   67 +-
 drivers/cpufreq/s3c24xx-cpufreq.c                  |   27 +-
 drivers/cpufreq/s3c64xx-cpufreq.c                  |   81 +-
 drivers/cpufreq/s5pv210-cpufreq.c                  |   86 +-
 drivers/cpufreq/sa1100-cpufreq.c                   |   49 +-
 drivers/cpufreq/sa1110-cpufreq.c                   |   46 +-
 drivers/cpufreq/sc520_freq.c                       |   64 +-
 drivers/cpufreq/sh-cpufreq.c                       |   22 +-
 drivers/cpufreq/sparc-us2e-cpufreq.c               |   42 +-
 drivers/cpufreq/sparc-us3-cpufreq.c                |   44 +-
 drivers/cpufreq/spear-cpufreq.c                    |   64 +-
 drivers/cpufreq/speedstep-centrino.c               |   84 +-
 drivers/cpufreq/speedstep-ich.c                    |   85 +-
 drivers/cpufreq/speedstep-smi.c                    |   76 +-
 drivers/cpufreq/tegra-cpufreq.c                    |   70 +-
 drivers/cpufreq/unicore2-cpufreq.c                 |    5 +-
 drivers/cpufreq/vexpress-spc-cpufreq.c             |   70 +
 drivers/cpuidle/Kconfig.arm                        |   25 +-
 drivers/cpuidle/Makefile                           |    3 +-
 drivers/cpuidle/coupled.c                          |    2 +-
 .../cpuidle.c => drivers/cpuidle/cpuidle-at91.c    |   29 +-
 drivers/cpuidle/cpuidle-ux500.c                    |    2 +-
 drivers/cpuidle/cpuidle-zynq.c                     |   17 +-
 drivers/cpuidle/cpuidle.c                          |   78 +-
 drivers/cpuidle/driver.c                           |   67 +-
 drivers/cpuidle/governor.c                         |   43 -
 drivers/cpuidle/sysfs.c                            |    7 +-
 drivers/devfreq/devfreq.c                          |   29 +-
 drivers/devfreq/exynos/exynos4_bus.c               |   29 +-
 drivers/devfreq/exynos/exynos5_bus.c               |   57 +-
 drivers/gpio/gpiolib-acpi.c                        |    9 +-
 drivers/gpu/drm/i915/intel_acpi.c                  |    6 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |    7 +-
 drivers/hid/i2c-hid/i2c-hid.c                      |   18 +-
 drivers/i2c/i2c-core.c                             |    5 +
 drivers/idle/intel_idle.c                          |   18 +-
 drivers/iommu/dmar.c                               |    4 +-
 drivers/iommu/intel_irq_remapping.c                |    8 +-
 drivers/pci/hotplug/acpi_pcihp.c                   |    7 +-
 drivers/pci/hotplug/acpiphp_glue.c                 |   18 +-
 drivers/pci/pci-acpi.c                             |    3 +-
 drivers/platform/x86/eeepc-laptop.c                |    8 +-
 drivers/platform/x86/fujitsu-laptop.c              |   44 +-
 drivers/platform/x86/ideapad-laptop.c              |  344 ++---
 drivers/platform/x86/intel-rst.c                   |   48 +-
 drivers/platform/x86/intel-smartconnect.c          |   27 +-
 drivers/platform/x86/intel_menlow.c                |    8 +-
 drivers/platform/x86/sony-laptop.c                 |   28 +-
 drivers/platform/x86/thinkpad_acpi.c               |   31 +-
 drivers/platform/x86/topstar-laptop.c              |    8 +-
 drivers/platform/x86/toshiba_acpi.c                |   44 +-
 drivers/platform/x86/wmi.c                         |   30 +-
 drivers/pnp/pnpacpi/core.c                         |   11 +-
 drivers/powercap/Kconfig                           |   32 +
 drivers/powercap/Makefile                          |    2 +
 drivers/powercap/intel_rapl.c                      | 1395 ++++++++++++++++++++
 drivers/powercap/powercap_sys.c                    |  685 ++++++++++
 drivers/spi/spi.c                                  |   18 +-
 drivers/thermal/Kconfig                            |    1 -
 drivers/video/backlight/backlight.c                |   31 +
 include/acpi/acconfig.h                            |    2 +
 include/acpi/acexcep.h                             |    8 +-
 include/acpi/acnames.h                             |   26 +-
 include/acpi/acpi_bus.h                            |   21 +-
 include/acpi/acpiosxf.h                            |  155 ++-
 include/acpi/acpixf.h                              |   93 +-
 include/acpi/actbl.h                               |   19 +-
 include/acpi/actbl2.h                              |    4 +-
 include/acpi/actypes.h                             |   77 +-
 include/acpi/platform/acenv.h                      |    8 +-
 include/acpi/platform/aclinux.h                    |  131 +-
 include/acpi/processor.h                           |    4 +-
 include/linux/acpi.h                               |    2 +-
 include/linux/backlight.h                          |    4 +
 include/linux/bitops.h                             |    3 +
 include/linux/cpu.h                                |   13 -
 include/linux/cpufreq.h                            |   75 +-
 include/linux/cpuidle.h                            |    8 +-
 include/linux/devfreq.h                            |    6 +-
 include/linux/opp.h                                |  134 --
 include/linux/pm_opp.h                             |  139 ++
 include/linux/powercap.h                           |  325 +++++
 kernel/power/Kconfig                               |   16 +
 kernel/power/qos.c                                 |   26 +-
 kernel/power/snapshot.c                            |    6 +-
 kernel/power/user.c                                |   20 +-
 326 files changed, 8393 insertions(+), 6833 deletions(-)

