Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaGMVeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 17:34:17 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52697 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaGMVeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 17:34:08 -0400
MIME-Version: 1.0
Date: Sun, 13 Jul 2014 14:34:07 -0700
X-Google-Sender-Auth: rGKBP-IZ_ijoEfWamH_9Fo5tQ_Y
Message-ID: <CA+55aFx1q=rnFEaYWDxYu1=drtnuhrmrQO2FqXPMxdn59Whbow@mail.gmail.com>
Subject: Linux 3.16-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Things are looking normal, and as usual, I _wish_ there was a bit less
churn going on since it's getting fairly late in the rc cycle, but
honestly, it's not like there is anything that really raises any
eyebrows here.

The bulk of this is drivers - with acpi and gpu sticking out, if only
by a hair. It's pretty mixed, really (hid, hwmon, iio, thermal, clk
drivers, libata, pinctrl, etc). There's the usual architecture updates
(mostly arm, some powerpc), there's some docbook fixes, and there's a
couple of filesystem fixes (f2fs, kernfs and ext4). With a smattering
of small core fixes (mainly cgroup) too.

Go forth and test,
    Linus

---

Aaron Lu (2):
      thermal: hwmon: Make the check for critical temp valid consistent
      ACPI / i915: ignore firmware requests for backlight change

Abhilash Kesavan (1):
      ARM: EXYNOS: Fix the check for non-smp configuration

Alex Deucher (3):
      drm/radeon/dp: return -EIO for flags not zero case
      drm/radeon: fix typo in golden register setup on evergreen
      drm/radeon: fix typo in ci_stop_dpm()

Alex Williamson (1):
      PCI: Fix unaligned access in AF transaction pending test

Alexandre Demers (1):
      drm/radeon/dpm: Reenabling SS on Cayman

Amit Daniel Kachhap (1):
      clocksource: exynos_mct: Register the timer for stable udelay

Andras Kovacs (1):
      USB: cp210x: add support for Corsair usb dongle

Andy Whitcroft (1):
      ACPI / resources: only reject zero length resources based at address zero

Anson Huang (1):
      Thermal: imx: correct critical trip temperature setting

Anton Blanchard (1):
      powerpc/perf: Never program book3s PMCs with values >= 0x80000000

Arun Kumar K (2):
      clk: exynos5420: Add IDs for clocks used in PD mfc
      ARM: dts: Add clock property for mfc_pd in exynos5420

Axel Lin (3):
      hwmon: (amc6821) Fix permissions for temp2_input
      hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div
      hwmon: (adm1021) Fix cache problem when writing temperature limits

Ben Skeggs (6):
      drm/gk104/ram: bash mpll bit 31 on
      drm/nv50-/kms: pass a non-zero value for head to sor dpms methods
      drm/nouveau/kms: restore fbcon after display has been resumed
      drm/nouveau/dp: fix required link bandwidth calculations
      drm/nouveau/dp: workaround broken display
      drm/nouveau/ram: fix test for gpio presence

Bernd Wachter (1):
      usb: option: Add ID for Telewell TW-LTE 4G v2

Bert Vermeulen (1):
      USB: ftdi_sio: Add extra PID.

Bo Shen (1):
      ARM: at91: at91sam9x5: add clocks for usb device

Chao Yu (5):
      f2fs: remove unused variables in f2fs_sm_info
      f2fs: check lower bound nid value in check_nid_range
      f2fs: fix error path in init_inode_metadata
      f2fs: release new entry page correctly in error path of f2fs_rename
      f2fs: avoid to access NULL pointer in issue_flush_thread

Charles Keepax (1):
      clk: s3c64xx: Hookup SPI clocks correctly

Chen Gang (1):
      HID: sensor-hub: introduce Kconfig dependency on IOMEM

Christian König (1):
      drm/radeon: only print meaningful VM faults

Clint Taylor (1):
      drm/i915/vlv: T12 eDP panel timing enforcement during reboot

Colin Cross (1):
      arm64: implement TASK_SIZE_OF

Colin Ian King (1):
      ACPI / EC: Free saved_ec on error exit path

Cristian Stoica (1):
      crypto: caam - fix memleak in caam_jr module

Dan Carpenter (2):
      clk: ti: apll: not allocating enough data
      pinctrl: berlin: fix an error code in berlin_pinctrl_probe()

Daniel Mack (1):
      dma: cppi41: handle 0-length packets

Daniel Vetter (1):
      drm/i915: Only unbind vgacon, not other console drivers

Dirk Brandewie (3):
      intel_pstate: Fix setting VID
      intel_pstate: don't touch turbo bit if turbo disabled or unavailable.
      intel_pstate: Update documentation of {max,min}_perf_pct sysfs files

Doug Anderson (2):
      clk: exynos5420: Remove aclk66_peric from the clock tree description
      clocksource: exynos_mct: Fix ftrace

Edward Lin (1):
      ACPI / video: Add Dell Inspiron 5737 to the blacklist

Enric Balletbo i Serra (1):
      ARM: dts: Fix TI CPSW Phy mode selection on IGEP COM AQUILA.

Eric Sandeen (1):
      ext4: disable synchronous transaction batching if max_batch_time==0

Fabio Estevam (1):
      MAINTAINERS: Update mx6 PCI driver maintainer's email

Geert Uytterhoeven (3):
      HID: rmi: Protect PM-only functions by #ifdef CONFIG_PM
      m68k: Fix boot regression on machines with RAM at non-zero
      m68k: Export mach_random_get_entropy to modules

Gu Zheng (1):
      cpuset,mempolicy: fix sleeping function called from invalid context

Guenter Roeck (5):
      hwmon: (adm1031) Fix writes to limit registers
      hwmon: (emc2103) Clamp limits instead of bailing out
      hwmon: (adc128d818) Drop write support on inX_input attributes
      i8k: Fix non-SMP operation
      powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64

Guido Martínez (1):
      ARM: OMAP2+: Make GPMC skip disabled devices

Helge Deller (3):
      parisc: add serial ports of C8000/1GHz machine to hardware database
      parisc: fix fanotify_mark() syscall on 32bit compat kernel
      parisc: drop unused defines and header includes

Himangi Saraogi (2):
      clk: sunxi: fix devm_ioremap_resource error detection code
      phy: omap-usb2: fix devm_ioremap_resource error detection code

Horia Geanta (1):
      scripts/kernel-doc: handle object-like macros

Jaegeuk Kim (5):
      f2fs: fix to report newly allocate region as extent
      f2fs: recover fallocated data and its i_size together
      f2fs: fix not to allocate unnecessary blocks during fallocate
      f2fs: do checkpoint for the renamed inode
      f2fs: check bdi->dirty_exceeded when trying to skip data writes

Jaewon Kim (1):
      ARM: dts: fix pwm-cells in pwm node for exynos4

Jan Beulich (2):
      x86-64, vdso: Fix vDSO build breakage due to empty .rela.dyn
      x86-32, vdso: Fix vDSO build error due to missing align_vdso_addr()

Jan Kardell (1):
      iio: ti_am335x_adc: Fix: Use same step id at FIFOs both ends

Jana Saout (1):
      dm crypt, dm zero: update author name following legal name change

Javi Merino (1):
      tools/thermal: tmon: fix compilation errors when building statically

Jiri Kosina (1):
      HID: sensor-hub: make dyn_callback_lock IRQ-safe

Jiri Slaby (1):
      HID: sensor-hub: fix potential memory leak

Joe Thornber (1):
      dm io: fix a race condition in the wake up code for sync_io

Joel Stanley (3):
      powerpc/kvm: Remove redundant save of SIER AND MMCR2
      powerpc/perf: Add PPMU_ARCH_207S define
      powerpc/perf: Clear MMCR2 when enabling PMU

John Sung (1):
      HID: usbhid: quirk for PM1610 and PM1640 Touchscreen.

Jon Medhurst (3):
      ARM: kprobes: Prevent known test failures stopping other tests running
      ARM: kprobes: Disallow instructions with PC and register specified shift
      ARM: kprobes: Fix test code compilation errors for ARMv4 targets

Josef Gajdusek (1):
      ACPI / battery: fix wrong value of capacity_now reported when
fully charged

Julia Lawall (1):
      clk: ti: dra7: return error code in failure case

Jun'ichi Nomura (1):
      dm mpath: fix IO hang due to logic bug in multipath_busy

Jussi Kivilinna (1):
      crypto: sha512_ssse3 - fix byte count to bit count conversion

Jyri Sarha (1):
      ARM: OMAP2+: Remove non working OMAP HDMI audio initialization

K. Y. Srinivasan (2):
      Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code
      Drivers: hv: util: Fix a bug in the KVP code

Kefeng Wang (1):
      ahci: disable ncq feature for hisilicon sata

Kinglong Mee (1):
      nfsd: Fix bad reserving space for encoding rdattr_error

Krzysztof Kozlowski (1):
      clk: s2mps11: Fix double free corruption during driver unbind

Lan Tianyu (2):
      Revert "ACPI / AC: Remove AC's proc directory."
      ACPI / battery: Retry to get battery information if failed during probing

Lee Jones (1):
      MAINTAINERS: Update Eduardo Valentin's email address

Li Zefan (4):
      cgroup: fix broken css_has_online_children()
      cgroup: fix mount failure in a corner case
      kernfs: introduce kernfs_pin_sb()
      cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()

Linus Torvalds (1):
      Linux 3.16-rc5

Linus Walleij (1):
      i2c: mux: pca954x: fix dependencies

Lv Zheng (6):
      ACPI / EC: Avoid race condition related to advance_transaction()
      ACPI / EC: Add asynchronous command byte write support
      ACPI / EC: Remove duplicated ec_wait_ibf0() waiter
      ACPI / EC: Fix race condition in ec_transaction_completed()
      ACPI / EC: Update revision due to recent changes
      ACPI / EC: Add detailed fields debugging support of EC_SC(R).

Mark Salter (1):
      arm64: export __cpu_{clear,copy}_user_page functions

Martin Kepplinger (1):
      ACPI / video: Add Acer TravelMate B113 to native backlight blacklist

Masanari Iida (2):
      DocBook: fix mtdnand typos
      DocBook: fix various typos

Maxime Bizon (1):
      workqueue: fix dev_set_uevent_suppress() imbalance

Maxime Ripard (1):
      phy: sun4i: depend on RESET_CONTROLLER

Michael Ellerman (2):
      powerpc/cell: Fix compilation with CONFIG_COREDUMP=n
      powerpc: Clean up MMU_FTRS_A2 and MMU_FTR_TYPE_3E

Michal Marek (3):
      kbuild: Do not print the build directory with make -s
      kbuild: Fix packaging targets with relative $(srctree)
      firmware: Create directories for external firmware

Michal Sojka (1):
      USB: serial: ftdi_sio: Add Infineon Triboard

Mikko Perttunen (1):
      libahci_platform: Fail when PHY required but PHY support disabled

Mikulas Patocka (1):
      dm: allocate a special workqueue for deferred device removal

Namjae Jeon (1):
      ext4: fix potential null pointer dereference in ext4_free_inode

Naveen Krishna Chatradhi (1):
      hwmon: (ntc_thermistor) Correct information printed during probe

Neil Horman (2):
      tmon: Check log file for common secuirty issues
      tmon: set umask to a reasonable value

Nishanth Menon (1):
      ARM: DRA7/AM43XX: fix header definition for omap44xx_restart

Pali Rohár (1):
      Documenation/laptops: rename and update hpfall.c

Paul Bolle (1):
      Documentation/Changes: clean up mcelog paragraph

Peter Hurley (3):
      serial: Test for no tx data on tx restart
      serial: arc_uart: Use uart_circ_empty() for open-coded comparison
      serial: imx: Fix build breakage

Peter Meerwald (1):
      iio:tcs3472: Check for buffer enabled and locking

Peter Ujfalusi (2):
      ARM: dts: am335x-evm: Enable the McASP FIFO for audio
      ARM: dts: am335x-evmsk: Enable the McASP FIFO for audio

Prabhakar Lad (1):
      cpufreq: Makefile: fix compilation for davinci platform

Prathyush K (1):
      ARM: EXYNOS: Add support for clock handling in power domain

Preeti U Murthy (1):
      powerpc/powernv: Check for IRQHAPPENED before sleeping

Punit Agrawal (1):
      thermal: Bind cooling devices with the correct arguments

Rahul Sharma (1):
      clk/exynos5250: fix bit number for tv sysmmu clock

Rajendra Nayak (1):
      ARM: dts: dra7xx-clocks: Fix the l3 and l4 clock rates

Rickard Strandqvist (1):
      thermal: ti-soc-thermal: ti-bandgap.c: Cleaning up wrong address
is checked

Roger Quadros (7):
      clk: ti: am43x: Fix boot with CONFIG_SOC_AM33XX disabled
      clk: ti: am43x: Fix boot with CONFIG_SOC_AM33XX disabled
      ARM: DRA7: hwmod: Fixup SATA hwmod
      ARM: DRA7: hwmod: Add SYSCONFIG for usb_otg_ss
      ARM: dts: dra7-evm: Make VDDA_1V8_PHY supply always on
      phy: core: Fix error path in phy_create()
      phy: omap-usb2: Balance pm_runtime_enable() on probe failure and remove

Russell King (2):
      ata: ahci_imx: warn when disabling ahci link
      ARM: l2c: fix revision checking

Russell King - ARM Linux (1):
      Update imx-sdma cyclic handling to report residue

Sachin Kamat (9):
      pinctrl: sunxi: Fix potential null pointer dereference
      i2c: sun6i-p2wi: Remove duplicate inclusion of module.h
      iio: hid-sensor-press: Fix return values
      iio: hid-sensor-accel-3d: Fix return values
      iio: hid-sensor-magn-3d: Fix return values
      iio: hid-sensor-als: Fix return values
      iio: hid-sensor-gyro-3d: Fix return values
      iio: hid-sensor-prox: Fix return values
      ARM: EXYNOS: Update secondary boot addr for secure mode

Scot Doyle (3):
      drm/i915: quirk asserts controllable backlight presence, overriding VBT
      drm/i915: Acer C720 and C720P have controllable backlights
      drm/i915: Toshiba CB35 has a controllable backlight

Shawn Guo (2):
      ahci: imx: manage only sata_ref_clk in imx_sata_enable[disable]
      ARM: imx: fix shared gate clock

Shobhit Kumar (2):
      drm/i915/vlv: DPI FIFO empty check is not needed
      drm/i915/vlv: Update the DSI ULPS entry/exit sequence

Simon Horman (2):
      ARM: shmobile: Add DT and defconfigs to MAINTAINERS
      serial: sh-sci: Add device tree support for r8a7{778,740,3a4} and sh73a0

Sjoerd Simons (1):
      drivers: phy: phy-samsung-usb2.c: Add missing MODULE_DEVICE_TABLE

Stephen Boyd (2):
      thermal: Add braces around suspect code
      clk: qcom: HDMI source sel is 3 not 2

Stéphane Marchesin (1):
      drm/nouveau/fb: Prevent inlining of ramfuc_reg

Suman Anna (2):
      ARM: OMAP3: PRM/CM: Add back macros used by TI DSP/Bridge driver
      ARM: OMAP2+: create dsp device only on OMAP3 SoCs

Suman Tripathi (2):
      libahci: export ahci_qc_issue() and ahci_start_fix_rx()
      ahci_xgene: fix the dma state machine lockup for the IDENTIFY
DEVICE PIO mode command.

Tejun Heo (1):
      cpuset: break kernfs active protection in cpuset_write_resmask()

Tero Kristo (1):
      ARM: OMAP2+: clock/dpll: fix _dpll_test_fint arithmetics overflow

Theodore Ts'o (5):
      ext4: fix unjournalled bg descriptor while initializing inode bitmap
      ext4: clarify error count warning messages
      ext4: clarify ext4_error message in ext4_mb_generate_buddy_error()
      ext4: revert commit which was causing fs corruption after journal replays
      ext4: fix a potential deadlock in __ext4_es_shrink()

Thomas Gleixner (2):
      clk: spear3xx: Use proper control register offset
      clk: spear3xx: Set proper clock parent of uart1/2

Tomasz Figa (2):
      clk: samsung: exynos4: Remove SRC_MASK_ISP gates
      ARM: EXYNOS: Register cpuidle device only on exynos4210 and 5250

Tomi Valkeinen (1):
      clk: ti: set CLK_SET_RATE_NO_REPARENT for ti,mux-clock

Tushar Behera (1):
      ARM: dts: Update the parent for Audss clocks in Exynos5420

Vasily Khoruzhick (2):
      clk: samsung: fix several typos to fix boot on s3c2410
      clk: samsung: add more aliases for s3c24xx

Ville Syrjälä (1):
      drm/i915: Don't clobber the GTT when it's within stolen memory

Vincent Minet (1):
      intel_pstate: Set CPU number before accessing MSRs

Wen-chien Jesse Sung (1):
      HID: use multi input quirk for 22b9:2968

Yasuaki Ishimatsu (1):
      workqueue: zero cpumask of wq_numa_possible_cpumask on init

Zhang Rui (1):
      ACPI / PNP: add soc_button_array device ID to PNP IDs list

Zhengyu He (1):
      core: fix typo in percpu read_mostly section
