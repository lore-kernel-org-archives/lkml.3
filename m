Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaIGXkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 19:40:24 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:43973 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaIGXkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 19:40:22 -0400
MIME-Version: 1.0
Date: Sun, 7 Sep 2014 16:40:21 -0700
X-Google-Sender-Auth: Lf7PJgW46t9mPkH353fJYhtrYRg
Message-ID: <CA+55aFzM2XR8VouQ+kwNNq6UTch3UY8X_bnyOydGfuwmeYr6Ag@mail.gmail.com>
Subject: Linus 3.17-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a short while there, this week was really nice and calm, but that
was mostly because the "linux-foundation.org" entry fell off the DNS
universe, and my mailbox got very quiet for a few hours.  The rest of
the week looked pretty normal.

"Pretty normal" isn't bad, though, and I'm not complaining. There is
nothing particularly big or scary going on - we had a quick scare
about a stupid compat layer bug, but it seems to have been just a
false positive and resulted in some added commentary rather than any
real code changes.

The diffstat is pretty reasonable, and it's fairly spread out. We have
the usual arch and driver updates, but there's actually more changes
under fs/ than under either of those. That's largely due to just a
late f2fs update, which I decided I couldn't be bothered to get too
upset about, most of it being pretty clear-cut fixes, with just a few
cleanups mixed in.

And really, if the f2fs changes look biggish, it's mostly because the
rest is pretty small.

Let's hope it all stays calm. I do note that neither Greg nor Davem
ended up sending me anything for rc4, which is probably the _real_
reason why it's pretty calm and small.

             Linus

---

Al Viro (2):
      get rid of propagate_umount() mistakenly treating slaves as busy.
      fix EBUSY on umount() from MNT_SHRINKABLE

Alexandre Belloni (2):
      ARM: at91: rm9200: fix clock registration
      ARM: at91/dt: rm9200: fix usb clock definition

Alexandre Courbot (1):
      Documentation: gpio: documentation for optional getters functions

Alexey Khoroshilov (1):
      ufs: fix deadlocks introduced by sb mutex merge

Andreas Färber (2):
      regulator: tps65090: Fix tps65090 typos in example
      ASoC: axi: Fix ADI AXI SPDIF specification

Anton Altaparmakov (1):
      Export sync_filesystem() for modular ->remount_fs() use

Bard Liao (1):
      ASoC: rt5677: correct mismatch widget name

Ben Skeggs (1):
      drm/nouveau/core: don't leak oclass type bits to user

Benjamin Tissoires (1):
      platform/x86: toshiba: re-enable acpi hotkeys after suspend to disk

Boris BREZILLON (1):
      mtd: nand: fix DocBook warnings on nand_sdr_timings doc

Brian Foster (2):
      xfs: don't log inode unless extent shift makes extent modifications
      xfs: trim eofblocks before collapse range

Brian Norris (1):
      mtd: cfi_cmdset_0002: check return code for get_chip()

Catalin Marinas (1):
      arm64: Add brackets around user_stack_pointer()

Chao Yu (4):
      f2fs: fix incorrect calculation with total/free inode num
      f2fs: introduce need_do_checkpoint for readability
      f2fs: use macro for code readability
      f2fs: reposition unlock_new_inode to prevent accessing invalid inode

Chen-Yu Tsai (1):
      i2c: mv64xxx: continue probe when clock-frequency is missing

Chris Mason (1):
      xfs: don't zero partial page cache pages during O_DIRECT writes

Christian Borntraeger (4):
      KVM: s390: Fix user triggerable bug in dead code
      KVM: s390/mm: try a cow on read only pages for key ops
      KVM: s390/mm: Fix storage key corruption during swapping
      KVM: s390/mm: Fix guest storage key corruption in ptep_set_access_flags

Christoffer Dall (1):
      arm/arm64: KVM: Complete WFI/WFE instructions

Colin Ian King (1):
      arm64/crypto: remove redundant update of data

Dan Carpenter (2):
      f2fs: simplify by using a literal
      toshiba_acpi: fix and cleanup toshiba_kbd_bl_mode_store()

Darren Hart (1):
      MAINTAINERS: Update platform-drivers-x86 maintainer and tree

Dave Airlie (1):
      drm/i915: handle G45/GM45 pulse detection connected state.

Dave Chinner (4):
      xfs: don't dirty buffers beyond EOF
      xfs: don't zero partial page cache pages during O_DIRECT writes
      xfs: use ranged writeback and invalidation for direct IO
      xfs: xfs_file_collapse_range is delalloc challenged

David Howells (3):
      KEYS: Fix public_key asymmetric key subtype name
      KEYS: Fix use-after-free in assoc_array_gc()
      PEFILE: Relax the check on the length of the PKCS#7 cert

Dmitry Torokhov (2):
      Input: fix used slots detection breakage
      Input: ALPS - suppress message about 'Unknown touchpad'

Felipe Balbi (1):
      ARM: dts: am4372: fix USB regs size

Frederic Weisbecker (1):
      nohz: Restore NMI safe local irq work for local nohz kick

Gabriele Mazzotta (1):
      cpufreq: intel_pstate: Remove unneeded variable

Gaël PORTAY (1):
      ARM: at91/dt: sam9g20: set at91sam9g20 pllb driver

Geert Uytterhoeven (4):
      regulator: Proofread documentation
      m68k: Wire up getrandom
      m68k: Wire up memfd_create
      PM / domains: Make generic_pm_domain.name const

Geoff Levand (1):
      arm64: Remove unused variable in head.S

Gu Zheng (1):
      aio: block exit_aio() until all context requests are completed

Hans de Goede (4):
      Revert "ideapad-laptop: Disable touchpad interface on Yoga models"
      ACPI / video: Fix use_native_backlight selection logic
      ACPI / video: Add a disable_native_backlight quirk
      ACPI / video: Disable native_backlight on HP ENVY 15 Notebook PC

Jacob Pan (1):
      powercap / RAPL: change domain detection message

Jaegeuk Kim (22):
      f2fs: should convert inline_data during the mkwrite
      f2fs: make clear on test condition and return types
      f2fs: fix the initial inode page for recovery
      f2fs: clear FI_INC_LINK during the recovery
      f2fs: should clear the inline_xattr flag
      f2fs: fix to recover inline_xattr/data and blocks
      f2fs: avoid bug_on when error is occurred
      f2fs: don't skip checkpoint if there is no dirty node pages
      f2fs: trigger release_dirty_inode in f2fs_put_super
      f2fs: give a chance to mount again when encountering errors
      f2fs: introduce f2fs_cp_error for readability
      f2fs: unlock_page when node page is redirtied out
      f2fs: check s_dirty under cp_mutex
      f2fs: handle EIO not to break fs consistency
      f2fs: add WARN_ON in f2fs_bug_on
      f2fs: prevent checkpoint during roll-forward
      f2fs: avoid double lock in truncate_blocks
      f2fs: remove rewrite_node_page
      f2fs: skip if inline_data was converted already
      f2fs: remove rename and use rename2
      f2fs: truncate stale block for inline_data
      f2fs: fix wrong casting for dentry name

Jarkko Nikula (1):
      ASoC: rt5640: Do not allow regmap to use bulk read-write operations

Jason Baron (1):
      powercap / RAPL: add support for CPU model 0x3f

Jeff Moyer (1):
      aio: add missing smp_rmb() in read_events_ring

Jiri Kosina (2):
      Revert "leds: convert blink timer to workqueue"
      ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock

Johannes Weiner (1):
      mm: memcontrol: revert use of root_mem_cgroup res_counter

Jose Manuel Alarcon Roldan (1):
      Documentation: i2c: rename variable "register" to "reg"

Lan Tianyu (1):
      ACPI / EC: Add msi quirk for Clevo W350etq

Lars-Peter Clausen (3):
      ASoC: Use dev_set_name() instead of init_name
      ASoC: rcar: Use && instead of & for boolean expressions
      regmap: Fix regcache debugfs initialization

Laurent Dufour (1):
      powerpc/kvm/cma: Fix panic introduces by signed shift operation

Leo Yan (1):
      arm64: fix bug for reloading FPSIMD state after cpu power off

Linus Torvalds (1):
      Linux 3.17-rc4

Linus Walleij (2):
      gpio: move varargs hack outside #ifdef GPIOLIB
      ARM: ux500: disable msp2 node on Snowball

Lokesh Vutla (1):
      ARM: dts: dra7-evm: Add vtt regulator support

Marek Roszko (1):
      i2c: at91: add bound checking on SMBus block length bytes

Mark Brown (2):
      regmap: Fix handling of volatile registers for format_write() chips
      regmap: Don't attempt block writes when syncing cache on single_rw devices

Masanari Iida (1):
      Documentation: misc-devices: Rename freefall.c from hpfall.c in lis2lv02d

Mathias Krause (2):
      drm/i915: Remove bogus __init annotation from DMI callbacks
      ideapad-laptop: Constify DMI table for real!

Michael Auchter (1):
      gpio: bt8xx: fix release of managed resources

Mika Westerberg (1):
      ACPICA: ACPI 5.1: Add support for runtime validation of _DSD package.

Nick Dyer (1):
      Input: atmel_mxt_ts - improve description of gpio-keymap property

Nishanth Menon (2):
      ARM: dts: am437x-gp: switch i2c0 to 100KHz
      ARM: dts: dra7-evm: Fix spi1 mux documentation

Noam Camus (1):
      ARC: [mm] Fix compilation breakage

Paul Bolle (1):
      Documentation: NFS/RDMA: Document separate Kconfig symbols

Paul Handrigan (2):
      ASoC: cs4265: Fix clock rates in clock map table
      ASoC: cs4265: Fix setting of functional mode and clock divider

Paulo Zanoni (1):
      drm/i915: fix plane/cursor handling when runtime suspended

Pawel Moll (1):
      bus: arm-ccn: Move event cleanup routine

Peter Ujfalusi (2):
      ARM: edma: Fix configuration parsing for SoCs with multiple eDMA3 CC
      ASoC: omap-twl4030: Fix typo in 2nd dai link's platform_name

Pranavkumar Sawargaonkar (1):
      ARM/ARM64: KVM: Nuke Hyp-mode tlbs before enabling MMU

Pranith Kumar (1):
      rcu: Make nocb leader kthreads process pending callbacks after spawning

Rafael J. Wysocki (1):
      PM / sleep: Fix test_suspend= command line option

Randy Dunlap (1):
      regulator: fix kernel-doc warnings in header files

Rasmus Villemoes (2):
      ASoC: da732x: Fix typo in include guard
      ASoC: tegra: Fix typo in include guard

Rob Jones (1):
      Documentation: seq_file: Document seq_open_private(),
seq_release_private()

Robert Coulson (1):
      hwmon: (ds1621) Update zbits after conversion rate change

Roger Quadros (8):
      ARM: dts: dra7-evm: Fix i2c3 pinmux and frequency
      ARM: dts: dra7-evm: Fix 8th NAND partition's name
      ARM: dts: am43x-epos-evm: Use BCH16 ECC scheme instead of BCH8
      ARM: dts: am437x-gp-evm: Use BCH16 ECC scheme instead of BCH8
      ARM: dts: am437x-gp-evm: Don't use read/write wait monitoring
      ARM: dts: am43xx-epos-evm: Don't use read/write wait monitoring
      ARM: OMAP2+: gpmc: Don't complain if wait pin is used without
r/w monitoring
      ARM: dts: am43x-epos-evm: Disable QSPI to prevent conflict with GPMC-NAND

Sachin Kamat (1):
      PCI: spear: Remove module option

Scot Doyle (2):
      drm/i915: Ignore VBT backlight presence check on Acer C720 (4005U)
      drm/i915: don't warn if backlight unexpectedly enabled

Sergei Shtylyov (2):
      i2c: rcar: fix MNR interrupt handling
      Revert "i2c: rcar: remove spinlock"

Simon Lindgren (1):
      i2c: at91: Fix a race condition during signal handling in
at91_do_twi_xfer.

Stefan Herbrechtsmeier (1):
      ARM: dts: set 'ti,set-rate-parent' for dpll4_m5x2 clock

Steve Dickson (1):
      KEYS: Increase root_maxkeys and root_maxbytes sizes

Subhransu S. Prusty (1):
      ASoC: core: fix .info for SND_SOC_BYTES_TLV

Sudip Mukherjee (1):
      Documentation: new page link in SubmittingPatches

Takashi Iwai (2):
      ALSA: hda - Fix digital mic on Acer Aspire 3830TG
      ALSA: hda - Fix COEF setups for ALC1150 codec

Takashi Sakamoto (2):
      ALSA: dice: fix wrong channel mappping at higher sampling rate
      ALSA: firewire-lib/dice: add arrangements of PCM pointer and
interrupts for Dice quirk

Thomas Gleixner (2):
      compat: nanosleep: Clarify error handling
      timekeeping: Update timekeeper before updating vsyscall and pvclock

Thomas Hellstrom (2):
      drm/vmwgfx: Fix an incorrect OOM return value
      drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle

Ulrik De Bie (2):
      Input: elantech - reset the device when elantech probe fails
      Input: elantech - add support for trackpoint found on some v3 models

Ville Syrjälä (2):
      drm/i915: Move intel_ddi_set_vc_payload_alloc(false) to
haswell_crtc_disable()
      drm/i915: Fix lock dropping in intel_tv_detect()

Vincent Stehlé (2):
      Input: sparc - i8042-sparcio.h: fix unused kbd_res warning
      irq: Export handle_fasteoi_irq

Will Deacon (5):
      arm64: ptrace: fix compat hardware watchpoint reporting
      arm64: ptrace: fix compat reg getter/setter return values
      arm64: perf: don't rely on layout of pt_regs when grabbing sp or pc
      arm64: report correct stack pointer in KSTK_ESP for compat tasks
      Revert "arm64: cpuinfo: print info for all CPUs"

Xiubo Li (1):
      ASoC: simple-card: Fix bug of wrong decrement DT node's refcount

Yasuaki Ishimatsu (1):
      ACPI / scan: not cache _SUN value in struct acpi_device_pnp

addy ke (1):
      i2c: rk3x: fix bug that cause transfer fails in master receive mode

arter97 (1):
      f2fs: fix typo
