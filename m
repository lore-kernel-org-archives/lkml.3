Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3JMWww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 18:52:52 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:45058 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3JMWwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 18:52:50 -0400
MIME-Version: 1.0
Date: Sun, 13 Oct 2013 15:52:49 -0700
X-Google-Sender-Auth: Jluj1YaUhv9DkVouIU3yCeZczyo
Message-ID: <CA+55aFxgsfhJd83tjz8yyC2UoAWzeM00R+1Zj8e3703jpJcX_w@mail.gmail.com>
Subject: Linux 3.12-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Things seem to be calming down nicely, and rc5 is smaller than previous rc's.

In fact, the most excitement we had this week wasn't even a kernel
bug, it was a compiler bug wrt "asm goto" that was found because of
code that is pending to be merged in 3.13. But the (happily fairly
straightforward) workaround for the bug was merged early, because we
_do_ use asm goto, and it's unclear whether our existing use might
already trigger the bug, just not enough to be as obviously
noticeable.

Aside from that, most of the changes here are the usual architecture
fixes (tile, arm, x86, s390) and drivers (gpu, hid, sound, i2c,
watchdog). With btrfs and the perf tool updates rounding out the rest.
And the usual random noise.

Go forth and test,

            Linus

---

Aaro Koskinen (1):
      ARM: OMAP2: gpmc-onenand: fix sync mode setup with DT

Alex Deucher (10):
      drm/edid: catch kmalloc failure in drm_edid_to_speaker_allocation
      drm/radeon: use 64-bit math to calculate CTS values for audio (v2)
      drm/radeon: fix N/CTS clock matching for audio
      drm/radeon: use hw generated CTS/N values for audio
      drm/radeon/dpm: disable multiple UVD states
      drm/radeon: fix typo in CP DMA register headers
      drm/radeon: improve soft reset on SI
      drm/radeon: improve soft reset on CIK
      drm/radeon/dpm: disable bapm on TN asics
      drm/radeon: re-enable sw ACR support on pre-DCE4

Anders F. U. Kiær (1):
      HID: add Holtek USB ID 04d9:a081 SHARKOON DarkGlider

Andy Shevchenko (1):
      arch: tile: re-use kbasename() helper

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix channel map switch not taking effect

Arnaldo Carvalho de Melo (2):
      perf tools: Fix libaudit test
      perf tools: Fix installation of libexec components

Axel Lin (1):
      spi: clps711x: Don't call kfree() after
spi_master_put/spi_unregister_master

Ben Skeggs (1):
      drm/nouveau/mc: disable msi support by default, it's busted in
tons of places

Benjamin Herrenschmidt (1):
      powerpc/irq: Don't switch to irq stack from softirq stack

Bharat Bhushan (1):
      kvm: ppc: booke: check range page invalidation progress on page setup

Brian Norris (1):
      mtd: nand: fix memory leak in ONFI extended parameter page

Chen Gang (1):
      tile: include: asm: use 'long long' instead of 'u64' for
atomic64_t and its related functions

Chris Metcalf (2):
      tile: ensure interrupts disabled for preempt_schedule_irq()
      tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT

Chris Wilson (1):
      drm/i915: Only apply DPMS to the encoder if enabled

Christian Borntraeger (1):
      s390/sclp: properly detect line mode console

Dan Carpenter (4):
      drm/radeon: forever loop on error in radeon_do_test_moves()
      drm/radeon/dpm/btc: off by one in btc_set_mc_special_registers()
      drm/radeon/dpm: off by one in si_set_mc_special_registers()
      watchdog: ts72xx_wdt: locking bug in ioctl

Daniel Mack (1):
      ALSA: snd-usb-usx2y: remove bogus frame checks

Dave Airlie (3):
      Revert "drm/fb-helper: don't sleep for screen unblank when an
oops is in progress"
      Revert "drm/i915: Delay disabling of VGA memory until
vgacon->fbcon handoff is done"
      Revert "i915: Update VGA arbiter support for newer devices"

Dave Jones (1):
      ext4: fix memory leak in xattr

David Ahern (1):
      perf tools: Add default handler for mmap2 events

David Henningsson (4):
      ALSA: hda - Fix mono speakers and headset mic on Dell Vostro 5470
      ALSA: hda - Fix microphone for Sony VAIO Pro 13 (Haswell model)
      ALSA: hda - Add a headset mic model for ALC269 and friends
      ALSA: hda - Sony VAIO Pro 13 (haswell) now has a working headset jack

David Herrmann (2):
      HID: uhid: allocate static minor
      HID: wiimote: fix FF deadlock

Elie De Brauwer (1):
      mtd: m25p80: Fix 4 byte addressing mode for Micron devices.

Fengguang Wu (1):
      kobject: show debug info on delayed kobject release

Francisco Jerez (1):
      drm/i915/hsw: Disable L3 caching of atomic memory operations.

Geert Uytterhoeven (1):
      parisc: Export flush_cache_page() (needed by lustre)

Geyslan G. Bem (1):
      dma: edma.c: remove edma_desc leakage

Gleb Natapov (1):
      KVM: nVMX: fix shadow on EPT

Heiko Carstens (1):
      s390/kprobes: add exrl to list of prohibited opcodes

Helge Deller (4):
      parisc: remove unused syscall_ipi() function.
      parisc: mark parisc_terminate() noreturn and cold.
      parisc: fix interruption handler to respect pagefault_disable()
      parisc: let probe_kernel_read() capture access to page zero

Henrik Austad (1):
      tile: change lock initalization in hardwall

Henrik Rydberg (1):
      hwmon: (applesmc) Always read until end of data

Imre Deak (1):
      drm/i915: fix rps.vlv_work initialization

Ingo Molnar (1):
      compiler/gcc4: Add quirk for 'asm goto' miscompilation bug

Ionut Nicu (2):
      i2c: i2c-mux-gpio: don't ignore of_get_named_gpio errors
      i2c: i2c-mux-gpio: use deferred probing

James Hogan (1):
      MIPS: stack protector: Fix per-task canary switch

Jan Kara (1):
      ext4: fix performance regression in writeback of random writes

Jean Delvare (1):
      i2c: Not all adapters have a parent

Jiang Liu (1):
      parisc: kill SMP single function call interrupt

Jingoo Han (1):
      watchdog: kempld_wdt: Fix bit mask definition

John David Anglin (1):
      parisc: optimize variable initialization in do_page_fault

Josef Bacik (2):
      Btrfs: use right root when checking for hash collision
      Btrfs: limit delalloc pages outside of find_delalloc_range

Kent Overstreet (1):
      bcache: Fix a null ptr deref regression

Kuninori Morimoto (1):
      spi/hspi: fixup Runtime PM enable timing

Linus Torvalds (2):
      vfs: allow O_PATH file descriptors for fstatfs()
      Linux 3.12-rc5

Manoj Chourasia (1):
      HID: hidraw: close underlying device at removal of last reader

Mark Brown (1):
      spi/s3c64xx: Ensure runtime PM is enabled prior to registration

Martin Schwidefsky (1):
      s390: fix system call restart after inferior call

Masami Hiramatsu (1):
      perf probe: Fix to find line information for probe list

Maxime Ripard (1):
      watchdog: sunxi: Fix section mismatch

Miao Xie (2):
      Btrfs: insert orphan roots into fs radix tree
      Btrfs: fix oops caused by the space balance and dead roots

Michael Holzheu (1):
      s390: Allow vmalloc target buffers for copy_from_oldmem()

Mika Westerberg (1):
      spi/pxa2xx: check status register as well to determine if the
device is off

Mingarelli, Thomas (1):
      watchdog: hpwdt: Patch to ignore auxilary iLO devices

Namhyung Kim (2):
      perf stat: Set child_pid after perf_evlist__prepare_workload()
      perf session: Fix infinite loop on invalid perf.data file

Nishanth Menon (1):
      ARM: OMAP3: Fix hardware detection for omap3630 when booted with
device tree

Pali Rohár (1):
      ARM: OMAP2: RX-51: Add missing max_current to rx51_lp5523_led_config

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Fix typo in saving DSCR

Peter Zijlstra (2):
      perf: Fix perf_pmu_migrate_context
      perf/x86: Clean up cap_user_time* setting

Rob Clark (1):
      drm/gma500: fix things after get/put page helpers

Robert Richter (1):
      arm, kbuild: make "make install" not depend on vmlinux

Rodrigo Vivi (1):
      drm/i915: Mask LPSP to get PSR working even with Power Well in
use by audio.

Sachin Kamat (1):
      spi: atmel: Fix incorrect error path

Sergei Shtylyov (2):
      rcar-hpbdma: remove shdma_free_irq() calls
      rcar-hpbdma: add parameter to set_slave() method

Simon Barth (1):
      ARM: mach-omap2: board-generic: fix undefined symbol

Stefan Achatz (1):
      HID: roccat: Fix "cannot create duplicate filename" problems

Takashi Iwai (1):
      ALSA: hda - Add fixup for ASUS N56VZ

Taras Kondratiuk (1):
      i2c: omap: Clear ARDY bit twice

Theodore Ts'o (2):
      random: run random_int_secret_init() run after all late_initcalls
      random: allow architectures to optionally define random_get_entropy()

Thomas Petazzoni (1):
      x86, build, pci: Fix PCI_MSI build on !SMP

Tony Lindgren (1):
      ARM: dts: Fix pinctrl mask for omap3

Ville Syrjälä (1):
      x86/reboot: Add reboot quirk for Dell Latitude E5410

Vineet Gupta (1):
      ARC: Ignore ptrace SETREGSET request for synthetic register "stop_pc"

Wei Yongjun (4):
      spi: mpc512x: fix error return code in mpc512x_psc_spi_do_probe()
      spi: fix return value check in dspi_probe()
      spi/clps711x: drop clk_put for devm_clk_get in spi_clps711x_probe()
      s390/3270: fix return value check in tty3270_resize_work()

Wolfram Sang (6):
      i2c: i2c-designware-platdrv: replace platform_driver_probe to
support deferred probing
      i2c: i2c-imx: replace platform_driver_probe to support deferred probing
      i2c: i2c-mxs: replace platform_driver_probe to support deferred probing
      i2c: i2c-stu300: replace platform_driver_probe to support deferred probing
      i2c: i2c-arb-gpio-challenge: use deferred probe when adapter not found
      i2c: i2c-mux-pinctrl: use deferred probe when adapter not found

Yuvaraj Kumar C D (1):
      ARM: exynos: dts: Update 5250 arch timer node with clock frequency

wojciech kapuscinski (1):
      drm/radeon: fix hw contexts for SUMO2 asics
