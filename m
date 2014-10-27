Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaJ0AR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:17:29 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:50479 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaJ0ARZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:17:25 -0400
MIME-Version: 1.0
Date: Sun, 26 Oct 2014 17:17:24 -0700
X-Google-Sender-Auth: aCL2FmE-WjmKkY_lmbnlfGlEFhs
Message-ID: <CA+55aFz9AB-OOS5T8vs16FPz8-0phuEM2ssSLx+zNWwJ53bs2w@mail.gmail.com>
Subject: Linux 3.18-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another rc - and now the merge window is *definitely* closed.

I had hoped that the rc1 release would mean that a few stragglers
would quickly surface, and then the rest of the rc would be more
normal. But no, I had straggling merge-window pull requests come in
all week, and rc2 is bigger than I'd like.

Oh well. It's not like I'm hugely surprised, but it does mean that I'm
probably going to be unpleasant next week to anybody who tries to get
me to pull things that I think looks like "development" rather than
"fixes".  You've been warned. I effectively gave you a full three
weeks of merge window, now it's time for bugfixes, and not random
other noise. Ok?

And to be honest, we've had bigger rc2's in history. Not recently,
though. Both 3.3 and 3.4 had big -rc2 releases, and 3.15 (which was
the largest release ever, iirc) came reasonably close.

At least _part_ of the size is the very long-delayed overlayfs merge
that I already mentioned in the rc1 release message as being pending.
Let's see how much fallout that all causes, but it's been around for a
long time (partly because it needed various vfs-layer things to
integrate cleanly), and I think it's in good shape. Knock wood.

So at least partially as a result of that overlayfs merge, about a
third of the patch is filesystems. It's not _just_ overlayfs, though,
there was a late ext4 merge request that I think is actually bigger,
at least partly due to some extent handling refactoring.

The rest is the more usual driver updates (thermal, watchdog, scsi
target, ACPI & PM, misc other updates) and architecture updates (arc,
arm, powerpc, mips, x86). Some Documentation and include file updates
rounds out the rest.

Shortlog appended for details, I think it's still well within the
mailing list size constraints.

                   Linus

---

Aaro Koskinen (2):
      MIPS: loongson2_cpufreq: Fix CPU clock rate setting mismerge
      MIPS: ptrace.h: Add a missing include

Aaron Lu (8):
      ACPI / fan: remove unused macro
      ACPI / fan: remove no need check for device pointer
      ACPI / fan: use acpi_device_xxx_power instead of acpi_bus equivelant
      ACPI / fan: convert to platform driver
      ACPI / Fan: add ACPI 4.0 style fan support
      ACPI / Fan: support INT3404 thermal device
      Thermal: move the KELVIN_TO_MILLICELSIUS macro to thermal.h
      Thermal: introduce INT3402 thermal driver

Al Viro (5):
      fix inode leaks on d_splice_alias() failure exits
      overlayfs: don't hold ->i_mutex over opening the real directory
      overlayfs: make ovl_cache_entry->name an array instead of pointer
      overlayfs: embed root into overlay_readdir_data
      overlayfs: embed middle into overlay_readdir_data

Alan Cox (1):
      pwm: lpss: Add ACPI and PCI IDs for Intel Braswell

Alex Bennée (1):
      Documentation/arm64/memory.txt: fix typo

Alex Deucher (6):
      Revert "drm/radeon: drop btc_get_max_clock_from_voltage_dependency_table"
      Revert "drm/radeon/dpm: drop clk/voltage dependency filters for SI"
      drm/radeon: initialize sadb to NULL in the audio code
      drm/radeon: fix speaker allocation setup
      drm/radeon: use gart memory for DMA ring tests
      drm/radeon: fix vm page table block size calculation

Alexandre Belloni (1):
      power: reset: at91-reset: fix power down register

Anatol Pomozov (1):
      ALSA: pcm: use the same dma mmap codepath both for arm and arm64

Andre Müller (1):
      x86/efi: Adding efi_printks on memory allocationa and pci.reads

Andreea-Cristina Bernat (1):
      tcm_fc: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

Andy Grover (8):
      target: core_tpg_post_dellun can return void
      target: Change core_dev_del_lun to take a se_lun instead of unpacked_lun
      target: Remove core_tpg_release_virtual_lun0 function
      target: Remove unneeded check in sbc_parse_cdb
      uio: Export definition of struct uio_device
      target: Add documentation on the target userspace pass-through driver
      target: Add a user-passthrough backstore
      target/user: Recalculate pad size inside is_ring_space_avail()

Andy Honig (2):
      KVM: x86: Prevent host from panicking on shared MSR writes.
      KVM: x86: Improve thread safety in pit

Andy Shevchenko (3):
      pwm: lpss: Properly split driver to parts
      pwm: lpss: pci: Move to use pcim_enable_device()
      pwm: lpss: make it buildable only on X86

Andy Whitcroft (1):
      overlayfs: add statfs support

Anson Huang (1):
      Thermal: imx: add i.mx6sx thermal support

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix missing ELD change event on plug/unplug

Anton Blanchard (5):
      powerpc: Reimplement __get_SP() as a function not a define
      powerpc: Rename __get_SP() to current_stack_pointer()
      powerpc/pseries: Use dump_stack instead of show_stack
      powerpc: Add printk levels to setup_system output
      powerpc: sync pseries_le_defconfig with pseries_defconfig

Anton Kolesov (1):
      ARC: Update order of registers in KGDB to match GDB 7.5

Ard Biesheuvel (2):
      efi: Implement mandatory locking for UEFI Runtime Services
      efi: rtc-efi: Export platform:rtc-efi as module alias

Arun Chandran (1):
      arm64: ASLR: Don't randomise text when randomise_va_space == 0

Ben Skeggs (2):
      drm/gt215/gr: fix initialisation on gddr5 boards
      drm/nouveau: fix regression on agp boards

Beniamino Galvani (1):
      watchdog: add driver for Ricoh RN5T618 watchdog

Bharata B Rao (1):
      powerpc/pseries: Make CPU hotplug path endian safe

Bjorn Helgaas (7):
      audit: Remove "weak" from audit_classify_compat_syscall() declaration
      x86, intel-mid: Remove "weak" from function declarations
      clocksource: Remove "weak" from clocksource_default_clock() declaration
      vmcore: Remove "weak" from function declarations
      kgdb: Remove "weak" from kgdb_arch_pc() declaration
      memory-hotplug: Remove "weak" from memory_block_size_bytes() declaration
      uprobes: Remove "weak" from function declarations

Bo Shen (1):
      MAINTAINERS: add atmel ssc driver maintainer entry

Boaz Harrosh (3):
      MAINTAINERS: Change Boaz Harrosh's email
      Boaz Harrosh - Fix broken email address
      Boaz Harrosh - fix email in Documentation

Bob Moore (4):
      ACPICA: Add string for _DDN method name.
      ACPICA: iASL/Disassembler: Add support for hardware summary mapfiles.
      ACPICA: acpiexec: Do not put STDIN into raw mode unless it is a terminal.
      ACPICA: Update version to 20140926.

Boris Brezillon (1):
      ARM: at91/dt: sam9263: fix PLLB frequencies

Boris Ostrovsky (3):
      xen/balloon: Don't continue ballooning when BP_ECANCELED is encountered
      x86/xen: Fix incorrect per_cpu accessor in xen_clocksource_read()
      xen/pci: Allocate memory for physdev_pci_device_add's optarr

Carlo Caione (4):
      ARM: docs: add documentation binding for meson watchdog
      ARM: meson: add watchdog driver
      ARM: defconfig: update multi_v7_defconfig
      watchdog: meson: remove magic value for reboot

Catalin Marinas (4):
      arm64: Align less than PAGE_SIZE pgds naturally
      arm64: Fix compilation error on UP builds
      arm64: vexpress: Add CLCD support to the ARMv8 model platform
      arm64: Fix memblock current_limit with 64K pages and 48-bit VA

Chen Gang (2):
      pwm: Let PWM_CLPS711X depend on HAS_IOMEM
      watchdog: Let XILINX_WATCHDOG and TEGRA_WATCHDOG depend on HAS_IOMEM

Chen-Yu Tsai (2):
      watchdog: sunxi: support parameterized compatible strings
      watchdog: sunxi: Add A31 watchdog support

Christoffer Dall (1):
      arm64: Allow 48-bits VA space without ARM_SMMU

Cong Wang (2):
      freezer: Do not freeze tasks killed by OOM killer
      freezer: remove obsolete comments in __thaw_task()

Daniel Borkmann (4):
      random: add and use memzero_explicit() for clearing data
      crypto: memzero_explicit - make sure to clear out sensitive data
      net: bpf: arm64: address randomize and write protect JIT code
      net: bpf: arm64: minor fix of type in jited

Darrick J. Wong (7):
      ext4: enable block_validity by default
      jbd2: fix journal checksum feature flag handling
      ext4: validate external journal superblock checksum
      ext4: don't keep using page if inline conversion fails
      ext4: check EA value offset when loading
      jbd2: free bh when descriptor block checksum fails
      ext4: check s_chksum_driver when looking for bg csum presence

Dave Young (6):
      efi: Move noefi early param code out of x86 arch code
      lib: Add a generic cmdline parse function parse_option_str
      efi: Add kernel param efi=noruntime
      arm64/efi: uefi_init error handling fix
      arm64/efi: Do not enter virtual mode if booting with
efi=noruntime or noefi
      x86/efi: Clear EFI_RUNTIME_SERVICES if failing to enter virtual mode

David Daney (2):
      MIPS: tlbex: Properly fix HUGE TLB Refill exception handler
      MIPS: Octeon: Remove special case for simulator command line.

David Henningsson (1):
      ALSA: hda - Add missing terminating entry to SND_HDA_PIN_QUIRK macro

David S. Miller (2):
      sparc64: Fix register corruption in top-most kernel stack frame
during boot.
      sparc64: Implement __get_user_pages_fast().

Dinh Nguyen (4):
      arm: socfpga: fix fetching cpu1start_addr for SMP
      ARM: dts: socfpga: rename gpio nodes
      ARM: dts: socfpga: Fix SD card detect
      ARM: dts: socfpga: Add a 3.3V fixed regulator node

Dirk Brandewie (4):
      cpufreq: expose scaling_cur_freq sysfs file for set_policy() drivers
      intel_pstate: Don't lose sysfs settings during cpu offline
      intel_pstate: Fix BYT frequency reporting
      intel_pstate: Correct BYT VID values.

Dmitry Monakhov (11):
      ext4: use ext4_update_i_disksize instead of opencoded ones
      ext4: use ext4_ext_next_allocated_block instead of mext_next_extent
      ext4: refactor ext4_move_extents code base
      jbd2: jbd2_log_wait_for_space improve error detetcion
      ext4: explicitly inform user about orphan list cleanup
      ext4: fix over-defensive complaint after journal abort
      ext4: get rid of code duplication
      ext4: optimize block allocation on grow indepth
      ext4: grab missed write_count for EXT4_IOC_SWAP_BOOT
      ext4: Replace open coded mdata csum feature to helper function
      ext4: move error report out of atomic context in ext4_init_block_bitmap()

Dominik Dingel (1):
      s390/mm: fixing calls of pte_unmap_unlock

Doug Anderson (1):
      pwm: rockchip: Allow polarity invert on rk3288

Erez Zadok (1):
      overlayfs: implement show_options

Eric Sandeen (1):
      ext4: fix reservation overflow in ext4_da_write_begin

Fabio Estevam (2):
      pwm: fsl-ftm: Select REGMAP_MMIO
      ARM: dts: imx28-evk: Let i2c0 run at 100kHz

Gabriele Mazzotta (1):
      cpufreq: intel_pstate: Reflect current no_turbo state correctly

Gavin Shan (7):
      powerpc/eeh: Fix condition for isolated state
      powerpc/eeh: Rename flag EEH_PE_RESET to EEH_PE_CFG_BLOCKED
      powerpc/powernv: Drop config requests in EEH accessors
      powerpc/pseries: Drop config requests in EEH accessors
      powerpc/eeh: Block PCI config access upon frozen PE
      powerpc/eeh: Don't collect logs on PE with blocked config space
      powerpc/eeh: Block CFG upon frozen Shiner adapter

Geert Uytterhoeven (1):
      pwm: Fix uninitialized warnings in pwm_get()

Gioh Kim (3):
      fs/buffer.c: support buffer cache allocations with gfp modifiers
      ext4: use non-movable memory for the ext4 superblock
      jbd/jbd2: use non-movable memory for the jbd superblock

Greg Kurz (1):
      powerpc/vphn: NUMA node code expects big-endian

Hannes Reinecke (1):
      tcm_loop: Fixup tag handling

Harini Katakam (2):
      watchdog: Add Cadence WDT driver
      devicetree: Add Cadence WDT devicetree bindings documentation

Harsha Priya (1):
      ALSA: ALC283 codec - Avoid pop noise on headphones during suspend/resume

Heikki Krogerus (1):
      ACPI / platform: provide default DMA mask

Heiko Carstens (1):
      s390: wire up bpf syscall

Heiko Stuebner (1):
      watchdog: s3c2410: add restart handler

Himangi Saraogi (1):
      target/configfs: Remove unnecessary null test

Jacek Anaszewski (5):
      leds: Reorder include directives
      leds: make brightness type consistent across whole subsystem
      leds: avoid using DEVICE_ATTR macro for max_brightness attribute
      leds: lp3944: fix sparse warning
      leds: Improve and export led_update_brightness

Jacob Pan (2):
      Thermal: int340x_thermal: expose acpi thermal relationship tables
      Thermal: int3400_thermal: use acpi_thermal_rel parsing APIs

Jan Kara (7):
      jbd2: optimize jbd2_log_do_checkpoint() a bit
      ext4: don't use MAXQUOTAS value
      jbd2: avoid pointless scanning of checkpoint lists
      jbd2: simplify calling convention around
__jbd2_journal_clean_checkpoint_list
      ext4: don't check quota format when there are no quota files
      vfs: fix data corruption when blocksize < pagesize for mmaped data
      ext4: fix mmap data corruption when blocksize < pagesize

Jan Willeke (1):
      s390/uprobes: fix kprobes dependency

Jani Nikula (1):
      drm/i915: fix short vs. long hpd detection

Janusz Uzycki (1):
      stmp3xxx_rtc_wdt: Add suspend/resume PM support

Jassi Brar (3):
      mailbox: Introduce framework for mailbox
      doc: add documentation for mailbox framework
      dt: mailbox: add generic bindings

Jingchang Lu (1):
      watchdog: imx2_wdt: add restart handler support

Jisheng Zhang (2):
      watchdog: dw_wdt: initialise TOP_INIT in dw_wdt_set_top()
      watchdog: dw_wdt: add restart handler support

Joern Engel (20):
      iscsi-target: remove unused debug code
      iscsi-target: remove always-true conditions
      iscsi-target: simplify return statement
      iscsi-target: remove unnecessary check in iscsit_setup_np error path
      iscsi-target: use strlcpy in iscsit_collect_login_stats
      target: Fix possible memory leak in aptpl_metadata parsing
      target: Fix memory leak on error in target_fabric_make_mappedlun
      target: simplify target_fabric_make_lun error path
      target: fix pr_out length in iscsi_parse_pr_out_transport_id
      target: correctly handle match_int errors in FILEIO + PSCSI
      target: fix unused shift in core_scsi3_pri_report_capabilities
      target: simplify core_tmr_release_req()
      target: remove some smp_mb__after_atomic()s
      target: encapsulate smp_mb__after_atomic()
      target: simplify core_tmr_abort_task
      qla_target: remove unused parameter
      qla_target: make some global functions static
      qla_target: improve qlt_unmap_sg()
      qla_target: rearrange struct qla_tgt_prm
      qla_target: don't delete changed nacls

Johannes Thumshirn (1):
      hwmon: (menf21bmc) Include linux/err.h

Josh Boyer (1):
      s390/hmcdrv: Restrict s390 HMC driver to S390 arch

Josh Cartwright (3):
      watchdog: qcom: add support for KPSS WDT
      watchdog: qcom: document device tree bindings
      watchdog: qcom: register a restart notifier

Josh Triplett (1):
      efi-bgrt: Add error handling; inform the user when ignoring the BGRT

Juergen Gross (3):
      x86/xen: avoid writing to freed memory after race in p2m handling
      x86/xen: delay construction of mfn_list_list
      x86/xen: avoid race in p2m handling

Julia Lawall (1):
      pwm: lpss: use c99 initializers in structures

Krystian Garbaciak (1):
      watchdog: Add DA9063 PMIC watchdog driver.

Lan Tianyu (1):
      Thermal: introduce int3403 thermal driver

Laszlo Ersek (5):
      efi: Add macro for EFI_MEMORY_UCE memory attribute
      efi: Introduce efi_md_typeattr_format()
      x86: efi: Format EFI memory type & attrs with efi_md_typeattr_format()
      ia64: efi: Format EFI memory type & attrs with efi_md_typeattr_format()
      arm64: efi: Format EFI memory type & attrs with efi_md_typeattr_format()

Laxman Dewangan (1):
      thermal: add support to disable thermal zone from DTS

Li Xi (1):
      ext4: fix return value of ext4_do_update_inode

Linus Torvalds (1):
      Linux 3.18-rc2

Liu Ying (3):
      pwm: imx: Fix the macro MX3_PWMCR_PRESCALER(x) definition
      pwm: imx: Cleanup indentation for register definitions
      pwm: imx: Avoid sample FIFO overflow for i.MX PWM version2

Lothar Waßmann (1):
      leds: trigger: gpio: fix warning in gpio trigger for gpios whose
accessor function may sleep

Lucas Stach (1):
      PCI / PM: handle failure to enable wakeup on PCIe PME

Lukas Czerner (2):
      ext4: add sysfs entry showing whether the fs contains errors
      ext4: provide separate operations for sysfs feature files

Lukasz Majewski (1):
      thermal: step_wise: fix: Prevent from binary overflow when trend
is dropping

Lv Zheng (11):
      ACPICA: acpidump: Add ACPI 1.0 RSDP support.
      ACPICA: Events: Reduce indent divergences of events files.
      ACPICA: Events: Reduce source code difference in
acpi_install_gpe_handler().
      ACPICA: Events: Update GPE handler removal, match behavior of
handler install.
      ACPICA: Events: Reduce source code difference for the
ACPI_EVENT_FLAG_HANDLE support.
      ACPICA: Events: Reduce source code difference for the
ACPI_EVENT_FLAG_HANDLE renaming.
      ACPI / EC: Add CPU ID to debugging messages.
      ACPI / EC: Enhance the logs to apply to QR_EC transactions.
      ACPI / EC: Add detailed command/query debugging information.
      ACPI / EC: Refine event/query debugging messages.
      ACPI / EC: Cleanup coding style.

Mahesh Salgaonkar (2):
      powerpc/book3s: Don't clear MSR_RI in hmi handler.
      powerpc/powernv: Fallback to old HMI handling behavior for old firmware

Marc-André Lureau (1):
      qxl: don't create too large primary surface

Mark Rustad (1):
      efi: Resolve some shadow warnings

Markos Chandras (7):
      MIPS: cp1emu: Fix ISA restrictions for cop1x_op instructions
      MIPS: Lasat: Add missing CONFIG_PROC_FS dependency to PICVUE_PROC
      MIPS: Sibyte: Include the swarm subdir to the sb1250 LittleSur builds
      MIPS: idle: Remove leftover __pastwait symbol and its references
      MIPS: Kconfig: Add missing MIPS_CPS dependencies to PM and cpuidle
      MIPS: Malta: Do not build the malta-amon.c file if CMP is not enabled
      MIPS: ftrace: Fix a microMIPS build problem

Martin Kelly (1):
      x86/xen: panic on bad Xen-provided memory map

Mathias Krause (4):
      x86/efi: Remove unused efi_call* macros
      x86/efi: Unexport add_efi_memmap variable
      x86/efi: Update comment regarding required phys mapped EFI services
      x86/efi: Mark initialization code as such

Matt Fleming (4):
      efi: Add efi= parameter parsing to the EFI boot stub
      efi: Provide a non-blocking SetVariable() operation
      efi: Delete the in_nmi() conditional runtime locking
      rtc: Disable EFI rtc for x86

Michael Ellerman (3):
      powerpc/msi: Fix the msi bitmap alignment tests
      powerpc/msi: Use WARN_ON() in msi bitmap selftests
      powerpc: Only do dynamic DMA zone limits on platforms that need it

Michael S. Tsirkin (1):
      kvm: x86: don't kill guest on unknown exit reason

Michal Hocko (2):
      OOM, PM: OOM killed task shouldn't escape PM suspend
      PM: convert do_each_thread to for_each_process_thread

Michal Simek (6):
      ARM: zynq: DT: Add missing address for L2 pl310
      ARM: zynq: DT: Add missing reference for ADC
      ARM: zynq: DT: Add missing reference for memory-controller
      ARM: zynq: DT: Add cadence watchdog node
      ARM: zynq: DT: trivial: Fix mc node
      watchdog: xilinx: Remove .owner field for driver

Michel Dänzer (2):
      drm/ttm: Don't skip fpfn check if lpfn is 0 in ttm_bo_mem_compat
      drm/ttm: Don't evict BOs outside of the requested placement range

Michele Curti (1):
      drm/radeon: reduce sparse false positive warnings

Mika Westerberg (1):
      watchdog: ts72xx_wdt: Kill superfluous variable in remove

Miklos Szeredi (11):
      vfs: add i_op->dentry_open()
      vfs: export do_splice_direct() to modules
      vfs: export __inode_permission() to modules
      vfs: introduce clone_private_mount()
      vfs: export check_sticky()
      vfs: add whiteout support
      vfs: add RENAME_WHITEOUT
      ext4: support RENAME_WHITEOUT
      shmem: support RENAME_WHITEOUT
      overlay filesystem
      fs: limit filesystem stacking depth

Nadav Amit (8):
      KVM: x86: Check non-canonical addresses upon WRMSR
      KVM: x86: Fix wrong masking on relative jump/call
      KVM: x86: Emulator fixes for eip canonical checks on near branches
      KVM: x86: Handle errors when RIP is set during far jumps
      KVM: x86: Decoding guest instructions which cross page boundary may fail
      KVM: x86: Emulator does not decode clflush well
      KVM: x86: PREFETCH and HINT_NOP should have SrcMem flag
      KVM: x86: Wrong assertion on paging_tmpl.h

Naveen Krishna Chatradhi (1):
      watchdog: s3c2410_wdt: Add support for Watchdog device on Exynos7

Neil Brown (1):
      overlay: overlay filesystem documentation

Nicholas Bellinger (5):
      iscsi-target: Drop duplicate __iscsi_target_login_thread check
      target/user: Fix up smatch warnings in tcmu_netlink_event
      target: Fix APTPL metadata handling for dynamic MappedLUNs
      target: Add force_pr_aptpl device attribute
      iser-target: Disable TX completion interrupt coalescing

Nikolaus Voss (1):
      pwm: atmel: Fix calculation of prescale value

Nishanth Aravamudan (2):
      powerpc/numa: check error return from proc_create
      powerpc/numa: Add ability to disable and debug topology updates

Olaf Hering (1):
      drm/cirrus: bind also to qemu-xen-traditional

Olof Johansson (2):
      ARM: sunxi_defconfig: enable CONFIG_REGULATOR_FIXED_VOLTAGE
      ARM: multi_v7_defconfig: enable CONFIG_MMC_DW_ROCKCHIP

Pali Rohár (1):
      cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy

Paolo Bonzini (1):
      KVM: emulate: avoid accessing NULL ctxt->memopp

Paul Bolle (2):
      ARC: [arcfpga] Get rid of ARC_BOARD_ANGEL4 and ARC_BOARD_ML509
      ARC: Remove unneeded Kconfig entry NO_DMA

Paul Burton (1):
      MIPS: Prevent compiler warning from cop2_{save,restore}

Paulo Zanoni (1):
      drm/i915: properly reenable gen8 pipe IRQs

Peter Feuerer (1):
      thermal: Added Bang-bang thermal governor

Petr Matousek (1):
      kvm: vmx: handle invvpid vm exit gracefully

Pranith Kumar (1):
      powerpc: booke_wdt: Fix build error as a module

Preeti U. Murthy (1):
      cpuidle: powernv: Populate cpuidle state details by querying the
device-tree

Punit Agrawal (3):
      thermal: trace: Trace temperature changes
      thermal: trace: Trace when a cooling device's state is updated
      thermal: trace: Trace when temperature is above a trip point

Quentin Casasnovas (1):
      kvm: fix excessive pages un-pinning in kvm_iommu_map error path.

Quinn Tran (1):
      target: Fix queue full status NULL pointer for SCF_TRANSPORT_TASK_SENSE

Rafael J. Wysocki (1):
      PM / freezer: Clean up code after recent fixes

Ralf Baechle (2):
      MIPS: SEAD3: Nuke PIC32 I2C driver.
      MIPS: SEAD3: Fix I2C device registration.

Rasmus Villemoes (1):
      target: target_core_ua_h: Add #define of include guard

Romeo Cane (1):
      powerpc: Fix sys_call_table declaration to enable syscall tracing

Sagi Grimberg (1):
      iser-target: Fix smatch warning

Seunghun Lee (1):
      ext4: fix comments about get_blocks

Soren Brinkmann (2):
      ARM: zynq: DT: Fix GEM register area size
      ARM: zynq: DT: Remove 222 MHz OPP

Stefan Hengelein (3):
      MIPS: MSP71xx: Remove compilation error when CONFIG_MIPS_MT is present
      MIPS: ath79: Fix compilation error when CONFIG_PCI is disabled
      MIPS: MSP71xx: Fix build error

Steve Capper (1):
      arm64: mm: Correct fixmap pagetable types

Steve Longerbeam (1):
      ARM: i.MX6: Fix "emi" clock name typo

Suman Anna (1):
      mailbox: rename pl320-ipc specific mailbox.h

Takashi Iwai (2):
      ALSA: hda - Fix inverted LED gpio setup for Lenovo Ideapad
      ALSA: pcm: Fix false lockdep warnings

Theodore Ts'o (30):
      ext4: convert ext4_dx_find_entry() to use the ERR_PTR convention
      ext4: convert ext4_getblk() to use the ERR_PTR convention
      ext4: convert ext4_bread() to use the ERR_PTR convention
      ext4: convert dx_probe() to use the ERR_PTR convention
      ext4: convert do_split() to use the ERR_PTR convention
      ext4: fix ext4_swap_extents() error handling
      ext4: fix ZERO_RANGE bug hidden by flag aliasing
      ext4: fix accidental flag aliasing in ext4_map_blocks flags
      ext4: teach ext4_ext_find_extent() to free path on error
      ext4: collapse ext4_convert_initialized_extents()
      ext4: drop EXT4_EX_NOFREE_ON_ERR in convert_initialized_extent()
      ext4: drop EXT4_EX_NOFREE_ON_ERR from rest of extents handling code
      ext4: call ext4_ext_drop_refs() from ext4_ext_find_extent()
      ext4: allow a NULL argument to ext4_ext_drop_refs()
      ext4: teach ext4_ext_find_extent() to realloc path if necessary
      ext4: reuse path object in ext4_ext_shift_extents()
      ext4: reuse path object in ext4_move_extents()
      ext4: rename ext4_ext_find_extent() to ext4_find_extent()
      jbd2: fold __process_buffer() into jbd2_log_do_checkpoint()
      jbd2: fold __wait_cp_io into jbd2_log_do_checkpoint()
      ext4: pass allocation_request struct to ext4_(alloc,splice)_branch
      ext4: prepare to drop EXT4_STATE_DELALLOC_RESERVED
      ext4: drop the EXT4_STATE_DELALLOC_RESERVED flag
      jbd2: don't call get_bh() before calling
__jbd2_journal_remove_checkpoint()
      ext4: renumber EXT4_EX_* flags to avoid flag aliasing problems
      ext4: fold ext4_sync_fs_nojournal() into ext4_sync_fs()
      ext4: support freezing ext2 (nojournal) file systems
      ext4: fold ext4_nojournal_sops into ext4_sops
      ext4: don't orphan or truncate the boot loader inode
      ext4: add ext4_iget_normal() which is to be used for dir tree lookups

Thierry Reding (1):
      pwm: lpss: Fix build failure on PowerPC

Thomas Petazzoni (3):
      cpufreq: allow driver-specific data
      cpufreq: cpufreq-dt: extend with platform_data
      cpufreq: cpufreq-dt: adjust message related to regulators

Tomeu Vizoso (1):
      PM / QoS: Add PM_QOS_MEMORY_BANDWIDTH class

U. Artie Eoff (2):
      drm/i915: intel_backlight scale() math WA
      drm/i915: Move DIV_ROUND_CLOSEST_ULL macro to header

Uwe Kleine-König (1):
      watchdog: simplify definitions of WATCHDOG_NOWAYOUT(_INIT_STATUS)?

Varka Bhadram (1):
      pci: pci-lantiq: remove duplicate check on resource

Victor Kamensky (1):
      arm64: compat: fix compat types affecting struct compat_elf_prpsinfo

Ville Syrjälä (1):
      drm/i915: Don't trust the DP_DETECT bit for eDP ports on CHV

Vineet Gupta (16):
      ARC: Allow SMP kernel to build/boot on UP-only infrastructure
      ARC: [arcfpga] consolidate machine description, DT
      ARC: [plat*] move code out of .init_machine into common
      ARC: [arcfpga] Remove more dead code
      ARC: [nsimosci] Allow "headless" models to boot
      ARC: rename kconfig option for unaligned emulation
      ARC: Update comments about uncached address space
      ARC: RIP @running_on_hw
      ARC: remove gcc mpy heuristics
      ARC: refactoring: reduce the scope of some local vars
      ARC: BUG() dumps stack after @msg (@msg now same as in generic BUG))
      ARC: remove extraneous __KERNEL__ guards
      ARC: unbork FPU save/restore
      ARC: boot: consolidate cross-checking of h/w and s/w
      ARC: boot: cpu feature print enhancements
      ARC: kgdb: generic kgdb_arch_pc() suffices

Vlad Catoi (1):
      ALSA: usb-audio: Add support for Steinberg UR22 USB interface

Wang Shilong (1):
      ext4: remove a duplicate call in ext4_init_new_dir()

Wanpeng Li (1):
      kvm: vfio: fix unregister kvm_device_ops of vfio

Xiaoguang Wang (1):
      ext4: delete useless comments about ext4_move_extents

Xiubo Li (8):
      pwm: fsl-ftm: Clean up the code
      pwm: fsl-ftm: Convert to direct regmap API usage
      pwm: fsl-ftm: Document 'big-endian' property
      pwm: Fix possible ZERO_SIZE_PTR pointer dereferencing error.
      led: gpio: Sort include headers alphabetically
      led: gpio: Fix possible ZERO_SIZE_PTR pointer dereferencing error.
      leds: gpio: cleanup the leds-gpio driver
      watchdog: imx2_wdt: Convert to use regmap framework's endianness method.

Zach Brown (1):
      target/file: fix inclusive vfs_fsync_range() end

Zhang Rui (8):
      ACPI: introduce ACPI int340x thermal scan handler
      ACPI: make acpi_create_platform_device() an external API
      ACPI: add ACPI_TYPE_LOCAL_REFERENCE support to acpi_extract_package()
      Thermal: introduce int3400 thermal driver
      Thermal: int3400 thermal: add capability to detect supporting UUIDs
      Thermal: int3400 thermal: register to thermal framework
      Thermal: int340x thermal: select ACPI fan driver
      ACPI: invoke acpi_device_wakeup() with correct parameters

Zheng Liu (2):
      ext4: improve extents status tree trace point
      ext4: track extent status tree shrinker delay statictics

Zi Shen Lim (2):
      arm64: bpf: add 'shift by register' instructions
      arm64: bpf: add 'load 64-bit immediate' instruction
