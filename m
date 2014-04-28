Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaD1DnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 23:43:13 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:47605 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaD1DnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 23:43:07 -0400
MIME-Version: 1.0
Date: Sun, 27 Apr 2014 20:43:06 -0700
X-Google-Sender-Auth: bGZrSt6DrILb1u14x4QZ_vduUa8
Message-ID: <CA+55aFwqiCA684s0452x9u41+Z6SE77NvWEiEPQn3PybkeCNmA@mail.gmail.com>
Subject: Linux 3.15-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another rc. So far, no big scares, and rc3 is
appropriately smaller than rc2 was, so we're following the right
trajectory here.

The statistics look fairly normal too, with half drivers (input, usb,
gpu, acpi, regulator..) and a third arch updates (much of it again arm
dts files, but other arm and some um updates too). The rest is misc,
but mainly concentrated in filesystem updates (btrfs and ext4).

                    Linus

---

Adam Thomson (1):
      Input: da9055_onkey - remove use of regmap_irq_get_virq()

Alan Stern (1):
      [SCSI] Fix command result state propagation

Alec Berg (1):
      iio: querying buffer scan_mask should return 0/1

Alex Deucher (7):
      drm/radeon: disable dpm on rv770 by default
      drm/radeon/aux: fix hpd assignment for aux bus
      drm/radeon: fix count in cik_sdma_ring_test()
      drm/radeon: properly unregister hwmon interface (v2)
      drm/radeon/pm: don't walk the crtc list before it has been
initialized (v2)
      drm/radeon: fix ATPX detection on non-VGA GPUs
      drm/radeon: don't allow runpm=1 on systems with out ATPX

Alex Elder (1):
      ARM: spear: add __init to spear_clocksource_init()

Alexander Gordeev (3):
      ahci: Ensure "MSI Revert to Single Message" mode is not enforced
      ahci: Use pci_enable_msi_exact() instead of pci_enable_msi_range()
      ahci: Do not receive interrupts sent by dummy ports

Alexander Shiyan (1):
      ARM: 8024/1: Keep DEBUG_UART_{PHYS,VIRT} entries sorted

Alexander Stein (2):
      spi: atmel: Fix scheduling while atomic bug
      Input: ads7846 - fix device usage within attribute show

Alexandre Belloni (5):
      iio: adc: at91_adc: Repair broken platform_data support
      ARM: at91: at91sam9g45: change at91_adc name
      ARM: at91: at91sam9260: change at91_adc name
      iio: adc: at91_adc: correct default shtim value
      iio: adc: mxs-lradc: fix warning when buidling on avr32

Andrea Adami (1):
      ARM: pxa: hx4700.h: include "irqs.h" for PXA_NR_BUILTIN_GPIO

Andrew Lunn (2):
      ARM: Kirkwood: Fix Atmel vendor prefix
      ARM: Kirkwood: DT: Add missing vendor prefix

Andy Lutomirski (1):
      x86, vdso: Make the vdso linker script compatible with Gold

Anton Ivanov (2):
      um: Missing pipe handling
      um: Memory corruption on startup

Arnd Bergmann (1):
      phy: exynos: fix building as a module

Axel Lin (2):
      regulator: pbias: Fix is_enabled callback implementation
      regulator: pbias: Convert to use regmap helper functions

Azat Khuzhin (2):
      ext4: initialize multi-block allocator before checking block descriptors
      ext4: fix ext4_count_free_clusters() with EXT4FS_DEBUG and
bigalloc enabled

Bartlomiej Zolnierkiewicz (3):
      pata_at91: fix ata_host_activate() failure handling
      pata_arasan_cf: fix ata_host_activate() failure handling
      pata_samsung_cf: fix ata_host_activate() failure handling

Beomho Seo (1):
      iio: cm32181: Fix read integration time function

Bjorn Helgaas (1):
      PNP: Work around BIOS defects in Intel MCH area reporting

Bjørn Mork (6):
      usb: qcserial: add Sierra Wireless EM7355
      usb: qcserial: add Sierra Wireless MC73xx
      usb: qcserial: add Sierra Wireless MC7305/MC7355
      usb: option: add Olivetti Olicard 500
      usb: option: add Alcatel L800MA
      usb: option: add and update a number of CMOTech devices

Chanho Min (1):
      arm64: init: Move of_clk_init to time_init

Chao Bi (1):
      usb: gadget: ffs: race between ffs_epfile_io() and ffs_func_eps_disable()

Chen Gang (1):
      ext4: fix 64-bit number truncation warning

Chris Mason (1):
      Btrfs: limit the path size in send to PATH_MAX

Christian Borntraeger (1):
      s390/ccwgroup: Fix memory corruption

Christian König (2):
      drm/radeon: use fixed PPL ref divider if needed
      drm/radeon: improve PLL limit handling in post div calculation

Christoph Hellwig (2):
      [SCSI] don't reference freed command in scsi_init_sgtable
      [SCSI] don't reference freed command in scsi_prep_return

Christoph Jaeger (2):
      btrfs: fix use-after-free in mount_subvol()
      intel_idle: fix IVT idle state table setting

Dan Carpenter (1):
      clk: vexpress: NULL dereference on error path

Dan Williams (1):
      libata/ahci: accommodate tag ordered controllers

Daniel Mack (2):
      usb: musb: dsps: move debugfs_remove_recursive()
      usb: phy: am335x-control: wait 1ms after power-up transitions

David Cohen (1):
      usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM

David Milburn (1):
      ahci: do not request irq for dummy port

David Sterba (1):
      btrfs: replace error code from btrfs_drop_extents

Denis Turischev (1):
      xhci: Switch Intel Lynx Point ports to EHCI on shutdown.

Dmitry Monakhov (2):
      ext4: fix error handling in ext4_ext_shift_extents
      ext4: always check ext4_ext_find_extent result

Domenico Andreoli (1):
      ARM: Tidy up DTB Makefile entries

Doug Anderson (3):
      serial: samsung: Use the passed in "port", fixing kgdb w/ no console
      serial: samsung: don't check config for every character
      serial: samsung: Change barrier() to cpu_relax() in console output

Duan Jiong (1):
      cpufreq: unicore32: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO

Fabio Estevam (4):
      ARM: dts: imx53-qsb-common: Fix memory region description
      ARM: dts: imx53-m53evk: Fix memory region description
      ARM: dts: imx6sl-evk: Add an entry for MX6SL_PAD_ECSPI1_SS0__GPIO4_IO11
      usb: gadget: rndis: Include "u_rndis.h"

Felipe Balbi (3):
      usb: musb: fix PHY power on/off
      usb: musb: omap2430: make sure clocks are enabled when running mailbox
      Revert "usb: gadget: u_ether: move hardware transmit to RX NAPI"

Filipe Manana (2):
      Btrfs: use correct key when repeating search for extent item
      Btrfs: correctly set profile flags on seqlock retry

Geert Uytterhoeven (3):
      ARM: dts: Grammar /is uses/ is used/
      ARM: dts: Grammar /that will/it will/
      cpufreq: ppc: Fix integer overflow in expression

Grygorii Strashko (1):
      phy: core: make NULL a valid phy reference if !CONFIG_GENERIC_PHY

Guenter Roeck (1):
      hwmon: (ltc2945) Don't crash the kernel unnecessarily

H Hartley Sweeten (1):
      staging: comedi: usbdux: bug fix for accessing 'ao_chanlist' in
private data

Hanjun Guo (1):
      ARM64: Remove duplicated Kconfig entry for "kernel/power/Kconfig"

Hannes Reinecke (1):
      [SCSI] Fix USB deadlock caused by SCSI error handling

Hans de Goede (5):
      Input: serio - add firmware_id sysfs attribute
      Input: i8042 - add firmware_id support
      Input: Add INPUT_PROP_TOPBUTTONPAD device property
      Input: synaptics - report INPUT_PROP_TOPBUTTONPAD property
      Input: synaptics - add min/max quirk for ThinkPad T431s, L440,
L540, S1 Yoga and X1

Heiko Stuebner (1):
      ARM: rockchip: fix copy'n'paste error in smp error messages

Heinrich Schuchardt (1):
      arm/mach-vexpress: array accessed out of bounds

Igor Gnatenko (1):
      xhci: extend quirk for Renesas cards

J. Bruce Fields (1):
      Revert "nfsd4: fix nfs4err_resource in 4.1 case"

Jack Pham (1):
      usb: dwc3: gadget: Iterate only over valid endpoints

James Bottomley (2):
      [SCSI] Fix spurious request sense in error handling
      [SCSI] More USB deadlock fixes

Jan Kara (1):
      ext4: fix jbd2 warning under heavy xattr load

Jason Gerecke (4):
      Input: wacom - use full 32-bit HID Usage value in switch statement
      Input: wacom - override 'pressure_max' with value from HID_USAGE_PRESSURE
      Input: wacom - references to 'wacom->data' should use 'unsigned char*'
      Input: wacom - handle 1024 pressure levels in wacom_tpc_pen

Jay Foad (1):
      ARM: 8026/1: Fix emulation of multiply accumulate instructions

Jean Delvare (2):
      ata: fix i.MX AHCI driver dependencies
      phy: restore OMAP_CONTROL_PHY dependencies

Jeff Layton (5):
      locks: allow __break_lease to sleep even when break_time is 0
      locks: allow __break_lease to sleep even when break_time is 0
      nfsd: set timeparms.to_maxval in setup_callback_client
      locks: rename file-private locks to "open file description locks"
      locks: rename FL_FILE_PVT and IS_FILE_PVT to use "*_OFDLCK" instead

Jianyu Zhan (1):
      kernfs: fix a subdir count leak

Jimmy Li (1):
      staging:iio:ad2s1200 fix a missing break

Johan Hovold (3):
      ARM: dts: OMAP2+: remove uses of obsolete gpmc,device-nand
      USB: serial: fix sysfs-attribute removal deadlock
      USB: io_ti: fix firmware download on big-endian machines

Jordan Rife (1):
      Input: elantech - add support for newer elantech touchpads

Julius Werner (1):
      usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb

Kazuya Mio (1):
      ext4: FIBMAP ioctl causes BUG_ON due to handle EXT_MAX_BLOCKS

Kefeng Wang (1):
      cpufreq: highbank: fix ARM_HIGHBANK_CPUFREQ dependency warning

Kishon Vijay Abraham I (1):
      ARM: OMAP2+: Fix config name for USB3 PHY

Krzysztof Kozlowski (2):
      iio: cm36651: Fix i2c client leak and possible NULL pointer dereference
      clocksource: Exynos_mct: Register clock event after request_irq()

Kuninori Morimoto (2):
      ARM: shmobile: lager: fixup SND_SOC_DAIFMT_CBx_CFx flags
      ARM: shmobile: armadillo800eva: fixup SND_SOC_DAIFMT_CBx_CFx flags

Leigh Brown (1):
      ARM: dts: am335x: update USB DT references

Lejun Zhu (1):
      Input: soc_button_array - fix a crash during rmmod

Leo Yan (1):
      arm64: initialize spinlock for init_mm's context

Linus Torvalds (3):
      mm: make fixup_user_fault() check the vma access rights too
      mm: split 'tlb_flush_mmu()' into tlb flushing and memory freeing parts
      Linux 3.15-rc3

Linus Walleij (4):
      ARM: ux500: update defconfig
      ARM: ux500: configure in sensors
      gpio: set data first, then chip and handler
      ARM: ux500: configure for CW1200 WLAN chip

Liu Hua (1):
      ARM: 8030/1: ARM : kdump : add arch_crash_save_vmcoreinfo

Loic Poulain (2):
      8250_core: Fix unwanted TX chars write
      serial: 8250: Fix thread unsafe __dma_tx_complete function

Lothar Waßmann (1):
      ARM: dts: imx53: fix apparent copy/paste error

Lubomir Rintel (1):
      usb: gadget: gadgetfs: Initialize CHIP to NULL before UDC probe

Lucas Stach (9):
      ARM: dts: imx6: add PCIe interrupt mapping properties
      ARM: dts: imx: drop invalid size and address cells properties
      ARM: imx6q-clk: parent lvds_gate from lvds_sel
      ARM: dts: imx6: edmqmx6: Fix usbotg id pin
      ARM: dts: imx6: edmqmx6: USB H1 only supports host mode
      ARM: dts: imx6: edmqmx6: add second STMPE
      ARM: dts: vybrid: drop address and size cells from GIC node
      ARM: shmobile: sh73a0: drop address cells from GIC node
      ARM: shmobile: r8a7740: drop address cells from GIC node

Lukas Czerner (10):
      ext4: remove unnecessary check for APPEND and IMMUTABLE
      fs: prevent doing FALLOC_FL_ZERO_RANGE on append only file
      fs: move falloc collapse range check into the filesystem methods
      fs: disallow all fallocate operation on active swapfile
      ext4: use truncate_pagecache() in collapse range
      ext4: use filemap_write_and_wait_range() correctly in collapse range
      ext4: fix removing status extents in ext4_collapse_range()
      ext4: no need to truncate pagecache twice in collapse range
      ext4: discard preallocations after removing space
      ext4: fix extent merging in ext4_ext_shift_path_extents()

Lv Zheng (1):
      ACPICA: Fix buffer allocation issue for generic_serial_bus
region accesses.

Macpaul Lin (1):
      usb: gadget: f_rndis: reduce NETTX irq caused by free skb header

Magnus Damm (1):
      ARM: shmobile: koelsch: correct renesas,gpios to renesas,groups
in sd[012] pfc

Manfred Schlaegl (1):
      tty: Fix race condition between __tty_buffer_request_room and
flush_to_ldisc

Martin K. Petersen (1):
      libata: Update queued trim blacklist for M5x0 drives

Mathias Krause (1):
      usb: phy: return an error in usb_get_phy() if try_module_get() fails

Matthew Wilcox (1):
      ext4: note the error in ext4_end_bio()

Max Schwarz (1):
      ARM: rockchip: rk3188: enable pull-ups on UART RX pins

Miao Xie (1):
      Btrfs: fix inode caching vs tree log

Mika Westerberg (2):
      gpio / ACPI: Don't crash on NULL chip->dev
      gpio / ACPI: Prevent potential wrap of GPIO value on OpRegion read

Miklos Szeredi (3):
      arm64: __NR_compat_syscalls fix
      arm64: add renameat2 compat syscall
      ARM: add renameat2 syscall

Namjae Jeon (3):
      ext4: fix COLLAPSE_RANGE test failure in data journalling mode
      ext4: fix COLLAPSE_RANGE failure with 1KB block size
      ext4: disable COLLAPSE_RANGE for bigalloc

Nicolas Pitre (1):
      ARM: 8032/1: bL_switcher: fix validation check before its activation

Paul Bolle (1):
      ARM: tegra: remove TEGRA_EMC_SCALING_ENABLE

Pawel Moll (3):
      hwmon: (vexpress) Use legal hwmon device names
      hwmon: (vexpress) Avoid creating non-existing attributes
      power/reset: vexpress: Fix restart/power off operation

Peter Chen (1):
      usb: chipidea: coordinate usb phy initialization for different phy type

Peter Ujfalusi (1):
      ARM: dts: dra7xx-clocks: Correct mcasp2_ahclkx_mux bit-shift

Philipp Zabel (1):
      ARM: i.MX6: ipu_di_sel clocks can set parent rates

Ping Cheng (1):
      Input: wacom - missed the last bit of expresskey for DTU-1031

Punit Agrawal (1):
      ARM: vexpress/TC2: Convert OPP voltage to uV before storing

Qipan Li (3):
      spi: sirf: correct TXFIFO empty interrupt status bit
      spi: sirf: set SPI controller in RISC IO chipselect mode
      spi: sirf: make GPIO chipselect function work well

Qu Wenruo (1):
      btrfs: Change the hole range to a more accurate value.

Rafael J. Wysocki (2):
      PM / suspend: Make cpuidle work in the "freeze" state
      ACPI / notify: Do not block unknown type notifications in root handler

Ritesh Harjani (1):
      arm: dma-mapping: Fix mapping size value

Rob Herring (1):
      ARM: fix missing CLKSRC_OF on multi-platform

Rob Taylor (1):
      ARM: shmobile: lager: correct renesas,gpios to renesas,groups in
sd[02] pfc

Robert Nelson (1):
      ARM: dts: Add support for the BeagleBoard xM A/B

Roger Quadros (4):
      ARM: OMAP3: hwmod data: Correct clock domains for USB modules
      usb: gadget: zero: Fix SuperSpeed enumeration for alternate setting 1
      usb: dwc3: core: Fix gadget for system suspend/resume
      ARM: dts: omap5: Add clocks to USB3 PHY node

Russell King (2):
      ARM: dt: microsom: don't set bit 7 for ethernet mux settings
      ARM: keep arch/arm/Kconfig and arch/arm/mm/Kconfig select entries sorted

Sascha Hauer (2):
      ARM: dts: imx6: edmqmx6: Do not use the OTG switch as VBUS regulator
      ARM: imx6q: clk: Parent DI clocks to video PLL via di_pre_sel

Sebastian Hesselbarth (5):
      ARM: 8038/1: iwmmxt: explicitly check for supported architectures
      ARM: 8039/1: pj4: enable iWMMXt only if CONFIG_IWMMXT is set
      ARM: 8040/1: pj4: properly detect existence of iWMMXt coprocessor
      ARM: 8041/1: pj4: fix cpu_is_pj4 check
      ARM: 8042/1: iwmmxt: allow to build iWMMXt on Marvell PJ4B

Sebastian Reichel (1):
      ARM: OMAP2+: N900: remove omapdss init for DT boot

Sergei Shtylyov (1):
      phy: fix kernel oops in phy_lookup()

Shawn Guo (3):
      ARM: dts: imx53-tx53: add IPU DI ports and endpoints
      ARM: dts: imx6q-gw5xxx: remove dead 'crtcs' property
      ARM: dts: imx: add required #clock-cells for fixed-clock

Simon Horman (2):
      ARM: shmobile: r8a7778: Use clks as MSTP007 parent
      spi: sh-hspi: Do not specifically request shyway_clk clock

Soren Brinkmann (2):
      ARM: zynq: DT: Add 'clock-latency' property
      ARM: zynq: dt: Add I2C nodes to Zynq device tree

Srivatsa S. Bhat (1):
      cpufreq, powernv: Fix build failure on UP

Stefan Agner (1):
      ARM: dts: mx5: fix wrong stmpe-ts bindings

Stephen Warren (3):
      ARM: tegra: remove UART5/UARTE from tegra124.dtsi
      clk: tegra: remove non-existent clocks
      dt: tegra: remove non-existent clock IDs

Steve Capper (1):
      arm64: mm: Add THP TLB entries to general mmu_gather

Steven Miao (1):
      spi: bfin5xx: fix build error

Suman Anna (1):
      ARM: OMAP2+: hwmod: fix missing braces in _init()

Suresh Gupta (2):
      usb : gadget : fsl: fix the fault issue on rmmod
      usb: gadget: fsl driver pullup fix

Tejun Heo (2):
      libata: make AHCI_XGENE depend on PHY_XGENE
      kernfs: add back missing error check in kernfs_fop_mmap()

Tero Kristo (1):
      ARM: OMAP3: PM: remove access to PRM_VOLTCTRL register

Theodore Ts'o (6):
      ext4: update PF_MEMALLOC handling in ext4_write_inode()
      ext4: move ext4_update_i_disksize() into mpage_map_and_submit_extent()
      ext4: use i_size_read in ext4_unaligned_aio()
      ext4: COLLAPSE_RANGE only works on extent-based files
      ext4: remove temporary shim used to merge COLLAPSE_RANGE and ZERO_RANGE
      ext4: use EINVAL if not a regular file in ext4_collapse_range()

Thomas Gleixner (3):
      genirq: Allow forcing cpu affinity of interrupts
      irqchip: Gic: Support forced affinity setting
      clocksource: Exynos_mct: Use irq_force_affinity() in cpu bringup

Thomas Petazzoni (2):
      ARM: mvebu: ensure the mdio node has a clock reference on Armada 370/XP
      ARM: mvebu: ensure the mdio node has a clock reference on Armada 38x

Thomas Pfaff (1):
      serial_core: fix uart PORT_UNKNOWN handling

Thomas Pugliese (3):
      uwb: don't call spin_unlock_irq in a USB completion handler
      usb: wusbcore: convert nested lock to use spin_lock instead of
spin_lock_irq
      usb: wusbcore: fix panic in wusbhc_chid_set

Thomas Renninger (1):
      tools/power/acpi: Minor bugfixes

Tim Kryger (1):
      regulator: core: Return error in get optional stub

Tomi Valkeinen (1):
      ARM: AM43xx: fix dpll init in bypass mode

Tony Lindgren (2):
      ARM: OMAP2+: Fix oops for GPMC free
      ARM: OMAP2+: Fix GPMC remap for devices using an offset

Tristan Schmelcher (1):
      uml: Simplify tempdir logic.

Ulf Hansson (2):
      ARM: ux500: u8500_defconfig: Enable PARTITION_ADVANCED
      ARM: u300: u300_defconfig: Enable PARTITION_ADVANCED

Victor Kamensky (1):
      ARM: 8033/1: fix big endian __pv_phys_pfn_offset size related issue

Wang Shilong (3):
      Btrfs: move btrfs_{set,clear}_and_info() to ctree.h
      Btrfs: avoid triggering bug_on() when we fail to start inode caching task
      Btrfs: fix possible memory leaks in open_ctree()

Will Deacon (2):
      arm64: debug: remove noisy, pointless warning
      word-at-a-time: avoid undefined behaviour in zero_bytemask macro

Wolfram Sang (1):
      ARM: AM335X: EVM: fix pinmux documentation in devicetree

Xiangyu Lu (1):
      ARM: 8027/1: fix do_div() bug in big-endian systems

Younger Liu (1):
      ext4: return ENOMEM rather than EIO when find_###_page() fails

Zheng Liu (1):
      ext4: fix byte order problems introduced by the COLLAPSE_RANGE patches

jon ernst (2):
      ext4: silence sparse check warning for function ext4_trim_extent
      ext4: enforce we are operating on a regular file in ext4_zero_range()

scameron@beardog.cce.hp.com (1):
      [SCSI] hpsa: fix NULL dereference in hpsa_put_ctlr_into_performant_mode()
