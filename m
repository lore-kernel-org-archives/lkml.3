Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055AbaFVFWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 01:22:55 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:55550 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaFVFWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 01:22:53 -0400
MIME-Version: 1.0
Date: Sat, 21 Jun 2014 19:22:52 -1000
X-Google-Sender-Auth: ctnqLvQREmh12WaOw-_30nnOqg8
Message-ID: <CA+55aFxdAhp-esuGiY4VEugiiwcMJgg1r6fPiR9Fb+HOz_5tLg@mail.gmail.com>
Subject: Linux 3.16-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a day early, but tomorrow ends up being inconvenient for me due
to being on the road most of the day, so here you are. These days most
people send me their pull requests and patches during the week, so
it's not like I expect that a Sunday release would have made much of a
difference. And it's also not like I didn't have enough changes for
making a rc2 release.

Anyway, enough excuses. 3.16-rc2 is out, and contains the usual
assortment of fixes all over the map. The most unusual part at this
point is how the sparc changes stand out (at almost 40% of the patch
by bulk), but they are basically all just sparse warning cleanups.

Similarly, some Nouveau drm changes standing out size-wise, but again
those are largely due to small firmware fixes resulting in big
generated changes. The actual real changes are fairly small.

Ignoring those two unusually large changes (in lines), everything else
looks fairly normal. There are driver changes, some tooling updates
(particularly perf), and various other arch updates (arm, s390,
unicore32, x86..). And just misc random stuff all over the place -
rtmutex, btrfs, yadda yadda.

The shortlog is not tiny, but small enough to include here, so you can
see the details there if you care.

Please do go test it out,

           Linus

---

Aaron Plattner (1):
      cpufreq: unlock when failing cpufreq_update_policy()

Alan Stern (2):
      USB: EHCI: avoid BIOS handover on the HASEE E200
      USB: usbtest: add a timeout for scatter-gather tests

Alex Deucher (2):
      drm/radeon: update mode_valid testing for DP
      drm/radeon: improve dvi_mode_valid

Alexander Gordeev (3):
      blk-mq: bitmap tag: fix races on shared ::wake_index fields
      blk-mq: bitmap tag: fix race on blk_mq_bitmap_tags::wake_cnt
      blk-mq: bitmap tag: fix races in bt_get() function

Alexander Mezin (2):
      ACPI / battery: use callback for setting up quirks
      ACPI / battery: add quirk for Acer Aspire V5-573G

Alexander Shiyan (1):
      w1: mxc_w1: Fix incorrect "presence" status

Anssi Hannula (1):
      ASoC: fsl_spdif: Fix integer overflow when calculating divisors

Archana Patni (1):
      iio: hid-sensors: Get feature report from sensor hub after
changing power state

Ard Biesheuvel (2):
      arm64/crypto: fix data corruption bug in GHASH algorithm
      arm64/crypto: improve performance of GHASH algorithm

Arnaldo Carvalho de Melo (2):
      perf tools: Emit more precise message for missing glibc static library
      perf tests: Show the inner make output when an error happens

Arnd Bergmann (11):
      ASoC: pxa: add I2C dependencies as needed
      regulator: add regulator_can_change_voltage stub
      ASoC: MMP audio needs sram support
      staging/iio: IIO_SIMPLE_DUMMY_BUFFER neds IIO_BUFFER
      cpufreq: cpufreq-cpu0: fix CPU_THERMAL dependency
      ARM: omap2: fix am43xx dependency on l2x0 cache
      ARM: keystone requires ARM_PATCH_PHYS_VIRT
      bus/arm-cci: add dependency on OF && CPU_V7
      remoteproc: da8xx: don't select CMA on no-MMU
      ARM: samsung: make SAMSUNG_DMADEV optional
      staging: comedi: addi_apci_1564: add addi_watchdog dependency

Axel Lin (1):
      regulator: ltc3589: Use of_get_child_by_name

Ben Skeggs (8):
      drm/gk104/clk: only touch divider for mode we'll be using
      drm/gk104/ibus: increase various random timeouts
      drm/gf100-/gr: report class data to host on fwmthd failure
      drm/gk104/fb/ram: fixups from an earlier search+replace
      drm/nouveau/disp/dp: don't touch link config after success
      drm/nv50/disp: fix a potential oops in supervisor handling
      drm/nouveau/pwr: fix typo in fifo wrap handling
      drm/gf117/i2c: no aux channels on this chipset

Benjamin Herrenschmidt (1):
      Revert "offb: Add palette hack for little endian"

Boris BREZILLON (3):
      i2c: sunxi: add P2WI DT bindings documentation
      i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface) controller support
      i2c: sun6-p2wi: fix call to snprintf

Catalin Marinas (2):
      arm64: defconfig update for LTP
      arm64: Limit the CMA buffer to 32-bit if ZONE_DMA

Chen Gang (17):
      arch/unicore32/kernel/ksyms.c: remove several undefined exported symbols
      arch/unicore32/kernel/module.c: use __vmalloc_node_range()
instead of __vmalloc_area()
      arch/unicore32/kernel/clock.c: add readl() and writel() for 'PM_' macros
      arch/unicore32/mm/alignment.c: include "asm/pgtable.h" to avoid
compiling error
      arch/unicore32/include/asm/ptrace.h: add generic definition for
profile_pc()
      arch/unicore32/include/asm/io.h: add readl_relaxed() generic definition
      drivers/rtc/rtc-puv3.c: use dev_dbg() instead of dev_debug() for
typo issue
      drivers/rtc/rtc-puv3.c: remove "&dev->" for typo issue MIME-Version: 1.0
      arch/unicore32/kernel/ksyms.c: remove 2 export symbols to avoid
compiling failure
      arch: unicore32: kernel: ksyms: remove 'bswapsi2' and 'muldi3'
to avoid compiling failure
      drivers: scsi: mvsas: fix compiling issue by adding 'MVS_' for
"enum pci_interrupt_cause"
      arch/unicore32/kernel/setup.c: add generic 'screen_info' to
avoid compiling failure
      unicore32: include: asm: add missing ')' for PAGE_* macros in pgtable.h
      arch:unicore32:mm: add devmem_is_allowed() to support STRICT_DEVMEM
      arch: unicore32: ksyms: export additional find_first_*() to
avoid compiling failure
      arch: unicore32: ksyms: export 'pm_power_off' to avoid compiling failure.
      arch: unicore32: ksyms: export '__cpuc_coherent_kern_range' to
avoid compiling failure

Chew, Chiau Ee (1):
      spi/pxa2xx: change default supported DMA burst size to 1

ChiaHao (1):
      arm64: Bug fix in stack alignment exception

Chris Mason (1):
      Btrfs: fix deadlocks with trylock on tree nodes

Chris Wilson (3):
      drm/i915: Disable FBC by default also on Haswell and later
      drm/i95: Initialize active ring->pid to -1
      drm/i915: Reorder semaphore deadlock check

Christoph Hellwig (3):
      block: remove elv_abort_queue and blk_abort_flushes
      blk-mq: properly drain stopped queues
      blk-mq: merge blk_mq_drain_queue and __blk_mq_drain_queue

Christoph Jaeger (1):
      ACPI: use kstrto*() instead of simple_strto*()

Dan Carpenter (4):
      i2c: rk3x: add NULL entry to the end of_device_id array
      iio: adc: at91: signedness bug in at91_adc_get_trigger_value_by_name()
      iio: adc: checking for NULL instead of IS_ERR() in probe
      misc: vexpress: fix error handling vexpress_syscfg_regmap_init()

Dan Williams (4):
      usb: fix ->update_hub_device() vs hdev->maxchild
      usb: improve "not suspended yet" message in hub_suspend()
      usb: quiet peer failure warning, disable poweroff
      usb: fix hub-port pm_runtime_enable() vs runtime pm transitions

Daniel Vetter (5):
      vt: Fix replacement console check when unbinding
      vt: Fix up unregistration of vt drivers
      vt: Don't ignore unbind errors in vt_unbind
      drm/i915: Fixup global gtt cleanup
      drm/i915: Kick out vga console

David Vrabel (4):
      x86/xen: fix memory setup for PVH dom0
      Revert "xen/pvh: Update E820 to work with PVH (v2)"
      x86/xen: no need to explicitly register an NMI callback
      xen/grant-table: fix suspend for non-PV guests

Denis Carikli (1):
      imx-drm: parallel-display: Fix DPMS default state.

Dmitry Torokhov (1):
      MAINTAINERS: add entry for VMware Balloon driver

Don Zickus (6):
      perf tools: Update mmap2 interface with protection and flag bits
      Revert "perf: Disable PERF_RECORD_MMAP2 support"
      perf report: Add mem-mode documentation to report command
      perf tools: Add cpumode to struct hist_entry
      perf tools: Add support to dynamically get cacheline size
      perf tools: Add dcacheline sort

Doug Smythies (1):
      intel_pstate: Correct rounding in busy calculation

Ezequiel Garcia (2):
      ARM: dts: Specify the NAND ECC scheme explicitly on Armada 375 DB board
      ARM: dts: Specify the NAND ECC scheme explicitly on Armada 385 DB board

Fabian Frederick (2):
      s390/qdio: replace shift loop by ilog2
      ACPI / processor replace __attribute__((packed)) by __packed

Fathi Boudra (1):
      builddeb: fix missing headers in linux-headers package

Filipe Manana (1):
      Btrfs: remove unused wait queue in struct extent_buffer

Frank Rowand (1):
      OF: fix of_find_node_by_path() assumption that of_allnodes is root

Fredrik Höglund (1):
      drm/radeon: use pixel formats instead of depth/bpp

Greg Kroah-Hartman (1):
      Revert "uio: fix vma io range check in mmap"

Gregory CLEMENT (1):
      cpuidle: mvebu: Fix the name of the states

Guan Xuetao (1):
      UniCore32: Change git tree location information in MAINTAINERS

Guenter Roeck (2):
      ASoC: fsl: Fix build problem
      of/platform: Fix microblaze build failure

Heiko Carstens (1):
      s390: update default configuration

Imre Deak (1):
      drm/i915: fix possible refcount leak when resetting forcewake

James Morris (1):
      security: add Serge Hallyn as a maintainer

Jani Nikula (1):
      drm/i915: set backlight duty cycle after backlight enable for gen4

Jarkko Nikula (1):
      ASoC: dapm: Make sure register value is in sync with DAPM kcontrol state

Jason Cooper (1):
      ARM: mvebu: DT: fix OpenBlocks AX3-4 RAM size

Jeff Layton (2):
      locks: add missing memory barrier in break_deleg
      locks: set fl_owner for leases back to current->files

Jens Axboe (2):
      null_blk: fix softirq completions for queue_mode == 1
      block: blk_max_size_offset() should check ->max_sectors

Jes Sorensen (2):
      staging: rtl8723au: Request correct firmware file for A-cut parts
      staging: rtl8723au: Reference correct firmwarefiles with MODULE_FIRMWARE()

Jiri Olsa (15):
      perf tools: Fix pipe check regression in attr event callback
      perf tools: Prettify the tags/TAGS/cscope targets output
      perf tools: Cache register accesses for unwind processing
      perf tools: Separate dso data related variables
      perf tools: Add data_fd into dso object
      perf tools: Add global list of opened dso objects
      perf tools: Add global count of opened dso objects
      perf tools: Cache dso data file descriptor
      perf tools: Add file size check and factor dso__data_read_offset
      perf tools: Allow to close dso fd in case of open failure
      perf tools: Add dso__data_* interface descriptons
      perf tests: Spawn child for each test
      perf tests: Allow reuse of test_file function
      perf tests: Add test for caching dso file descriptors
      perf tests: Add test for closing dso objects on EMFILE error

Kees Cook (4):
      s390: avoid format strings leaking into names
      of: avoid format string parsing in kobject names
      PM / hibernate: introduce "nohibernate" boot parameter
      x86, kaslr: boot-time selectable with hibernation

Kinglong Mee (1):
      NFSD: fix bug for readdir of pseudofs

Konstantin Khlebnikov (1):
      epoll: fix use-after-free in eventpoll_release_file

Kuninori Morimoto (1):
      ASoC: rsnd: fixup index of src/dst mod when capture

Lars-Peter Clausen (6):
      ASoC: sigmadsp: Split regmap and I2C support into separate modules
      ALSA: control: Protect user controls against concurrent access
      ALSA: control: Fix replacing user controls
      ALSA: control: Don't access controls outside of protected regions
      ALSA: control: Handle numid overflow
      ALSA: control: Make sure that id->index does not overflow

Linus Torvalds (1):
      Linux 3.16-rc2

Linus Walleij (1):
      ARM: integrator: fix section mismatch problem

Maarten Lankhorst (1):
      drm/nouveau/disp: fix oops in destructor with headless cards

Mario Kleiner (3):
      drm/radeon: Bypass hw lut's for > 8 bpc framebuffer scanout.
      drm/nouveau/kms: reference vblank for crtc during pageflip.
      drm/radeon: Use dce5/6 hdmi deep color clock setup also on dce8+

Mario Schuknecht (1):
      staging: iio: tsl2x7x_core: fix proximity treshold

Mark Salter (1):
      arm64: fix build error in sigcontext.h

Martin Peres (1):
      drm/nouveau/doc: update the thermal documentation

Martin Schwidefsky (2):
      s390/uaccess: always load the kernel ASCE after task switch
      s390/compat: correct ucontext layout for high gprs

Masahiro Yamada (1):
      kbuild: fix a typo in a kbuild document

Masami Hiramatsu (5):
      perf probe: Improve error message for unknown member of data structure
      perf probe: Show error code and description in verbose mode
      perf probe: Improve an error message of perf probe --vars mode
      perf probe: Improve error messages in --line option
      x86/kprobes: Fix build errors and blacklist context_track_user

Mathias Nyman (1):
      xhci: Fix sleeping with IRQs disabled in xhci_stop_device()

Matias Bjørling (1):
      block: remove WQ_POWER_EFFICIENT from kblockd

Max Schwarz (1):
      i2c: rk3x: add driver for Rockchip RK3xxx SoC I2C adapter

Miao Xie (5):
      Btrfs: make free space cache write out functions more readable
      Btrfs: fix broken free space cache after the system crashed
      Btrfs: use bio_endio_nodec instead of open code
      Btrfs: fix deadlock when mounting a degraded fs
      Btrfs: fix wrong error handle when the device is missing or is
not writeable

Michael Veigel (1):
      s390/ap_bus: Make modules parameters visible in sysfs

Michal Marek (3):
      deb-pkg: Fix for relative paths
      kbuild: Fix tar-pkg with relative $(objtree)
      Documentation: Fix DocBook build with relative $(srctree)

Michel Dänzer (2):
      Revert "drm/radeon: remove drm_vblank_get|put from pflip handling"
      drm/radeon: Fix radeon_irq_kms_pflip_irq_get/put() imbalance

Mika Westerberg (1):
      ACPI / LPSS: Take I2C host controllers out of reset

Mike Snitzer (1):
      null_blk: fix name and description of 'queue_mode' module parameter

Namhyung Kim (2):
      perf script/python: Print array argument as string
      perf record: Fix to honor user freq/interval properly

NeilBrown (1):
      NFSD: Don't hand out delegations for 30 seconds after recalling them.

Nicolin Chen (1):
      ASoC: fsl_spdif: Fix incorrect usage of regmap_read()

Nishanth Menon (1):
      regulator: palmas: Fix SMPS list for 0V

Olof Johansson (1):
      ARM: exynos: move sysram info to exynos.c

Paul Bolle (1):
      arm64: ftrace: Fix comment typo 'CONFIG_FUNCTION_GRAPH_FP_TEST'

Paul Kocialkowski (1):
      twl4030-madc: Request processed values in twl4030_get_madc_conversion

Peter Hurley (2):
      serial: Fix IGNBRK handling
      tty: Correct INPCK handling

Peter Meerwald (2):
      iio: Fix two mpl3115 issues in measurement conversion
      iio: Fix endianness issue in ak8975_read_axis()

Peter Oberparleiter (1):
      s390/sclp_vt220: Enable ASCII console per default

Peter Zijlstra (1):
      perf: Pass protection and flags bits through mmap2 interface

Philipp Hachtmann (2):
      s390/watchdog: use watchdog API
      s390/watchdog: add support for LPAR operation (diag288)

Pierre Moreau (2):
      drm/nv50/gr: fix overlap while zeroing zcull regions
      drm/nv50/gr: remove an unneeded write while initialising PGRAPH

Qu Wenruo (1):
      btrfs: Skip scrubbing removed chunks to avoid -ENOENT.

Rafael J. Wysocki (1):
      ACPI / ia64 / sba_iommu: Restore the working initialization ordering

Rob Clark (1):
      drm: fix uninitialized acquire_ctx fields (v2)

Rob Herring (3):
      ARM: exynos: cleanup kconfig option display
      ARM: use menuconfig for sub-arch menus
      tty/serial: fix 8250 early console option passing to regular console

Robert Hodaszi (1):
      iio: mxs-lradc: fix divider

Sachin Kamat (2):
      ARM: EXYNOS: Fix compilation warning
      serial: samsung: Fix build error

Sam Ravnborg (67):
      sparc32: rename mm/srmmu.h to mm/mm_32.h
      sparc32: fix sparse warning in fault_32.c
      sparc32: fix sparse warning in init_32.c
      sparc32: fix sparse warnings in srmmu.c
      sparc32: fix sparse "Should it be static?" in mm/
      sparc32: fix sparse warning in traps_32.c
      sparc32: fix sparse warnings in sun4m_irq.c and sun4d_irq.c
      sparc32: fix sparse warnings in sun4d_irq.c
      sparc32: fix sparse warnings in irq_32.c
      sparc32: fix sparse warnings in process_32.h
      sparc32: fix sparse warnings in signal_32.c
      sparc32: fix sparse warnings in ioport.c
      sparc32: fix sparse warnings in setup_32.c
      sparc32: fix sparse warnings in windows.c
      sparc: fix sparse warnings in cpu.c
      sparc32: fix sparse warning in devices.c
      sparc32: fix sparse warnings in tadpole.c
      sparc32: fix sparse warnings in leon_pci_grpci1.c
      sparc32: fix sparse warnings in leon_pci_grpci2.c
      sparc32: fix sparse warnings in auxio_32.c
      sparc32: fix sparse warnings in smp_32.c
      sparc32: fix sparse warning in ptrace_32.c
      sparc32: fix sparse warnings in unaligned_32.c
      sparc: fix sparse warnings in of_device_common.c
      sparc32: fix sparse warnings in leon_kernel.c
      sparc32: fix sparse warnings in leon_pmc.c
      sparc32: fix sparse warnings in sun4m_smp.c
      sparc32: fix sparse warnings in sun4d_smp.c
      sparc32: fix sparse warnings in leon_smp.c
      sparc: move page_to_phys to page.h
      sparc32: replace flip_dword() with swab32()
      sparc32: introduce asm-generic/io.h
      sparc32: clean up io_32.h
      sparc32: fix build breakage
      sparc32: fix sparse warning in iommu.c
      sparc32: fix sparse warning in io-unit.c
      sparc32: fix sparse warnings in pcic.c
      sparc32: fix sparse warning in auxio_32.c
      sparc32: fix sparse warnings in time_32.c
      sparc32: fix sparse warnings in sys_sparc_32.c
      sparc32: remove cast from output constraints in math asm statements
      sparc64: remove cast from output constraints in math asm statements
      sparc: fix sparse warning in math_{32,64}
      sparc32: drop tadpole specific code
      sparc: drop use of extern for prototypes in arch/sparc/include/asm
      sparc: drop use of extern for prototypes in arch/sparc/*
      sparc64: fix sparse warning in traps_64.c
      sparc64: fix sparse warning in process_64.c
      sparc64: fix sparse warnings in sys_sparc_64.c + unaligned_64.c
      sparc64: fix sparse warning in btext.c
      sparc64: fix sparse warning in prom_64.c
      sparc64: fix sparse warnings in smp_64.c
      sparc64: fix sparse warning in pci.c
      sparc64: fix sparse warnings in sys_sparc32.c
      sparc64: fix sparse "Should it be static?" warnings in signal32.c
      sparc64: clean up compat_sigset_t.seta handling
      sparc64: fix sparse warning in tsb.c
      sparc64: fix sparse warnings in kprobes.c
      sparc64: fix sparse warnings in perf_event.c
      sparc: fix sparse warnings in smp_32.c + smp_64.c
      sparc64: fix sparse warnings in aes_glue.c
      sparc64: fix sparse warnings in init_64.c
      sparc64: fix sparse warnings in compat_audit.c
      sparc64: fix sparse warning in kgdb_64.c
      sparc64: fix sparse warning in kprobes.c
      sparc64: fix sparse warning in ftrace.c
      sparc64: fix sparse warnings in int_64.c

Sebastian Ott (6):
      s390/cio: silence lockdep warning
      s390/airq: silence lockdep warning
      s390/cio: set device name as early as possible
      s390/ccwgroup: obtain extra reference for asynchronous processing
      s390/ccwgroup: fix an uninitialized return code
      s390/ccwgroup: use ccwgroup_ungroup wrapper

Stanislav Fomichev (1):
      perf timechart: Reflow documentation

Stefan Raspl (1):
      qdio: Keep device-specific dbf entries

Stephen Boyd (2):
      ARM: Remove ARCH_HAS_CPUFREQ config option
      unicore32: Remove ARCH_HAS_CPUFREQ config option

Stephen Warren (1):
      ARM: multi_v7_defconfig: re-enable SDHCI drivers

Steven Rostedt (2):
      tools lib traceevent: Add options to plugins
      arm/ftrace: fix ftrace_return_addr() to ftrace_return_address()

Steven Rostedt (Red Hat) (3):
      tools lib traceevent: Add flag to not load event plugins
      tools lib traceevent: Add options to function plugin
      tools lib traceevent: Added support for __get_bitmask() macro

Sudeep Holla (2):
      arm64: restore alphabetic order in Kconfig
      arm64: add ARCH_HAS_OPP to allow enabling OPP library

Suravee Suthikulpanit (1):
      arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro

Takashi Iwai (1):
      drm/i915, HD-audio: Don't continue probing when nomodeset is given

Theodore Ts'o (1):
      random: fix nasty entropy accounting bug

Thierry Reding (1):
      regulator: as3722: Make 0 a valid selector

Thomas Gleixner (3):
      rtmutex: Handle deadlock detection smarter
      rtmutex: Detect changes in the pi lock chain
      rtmutex: Plug slow unlock race

Tom O'Rourke (1):
      drm/i915/bdw: remove erroneous chv specific workarounds from bdw code

Victor Kamensky (1):
      arm64: ptrace: fix empty registers set in prstatus of aarch32 process core

Ville Syrjälä (1):
      drm/i915: Avoid div-by-zero when pixel_multiplier is zero

Vinayak Kale (1):
      arm64: dts: Add more serial port nodes in APM X-Gene device tree

Wang Shilong (1):
      Btrfs: fix NULL pointer crash when running balance and scrub concurrently

Will Deacon (3):
      arm64: ptrace: change fs when passing kernel pointer to regset code
      arm64: uid16: fix __kernel_old_{gid,uid}_t definitions
      arm64: mm: remove broken &= operator from pmd_mknotpresent

Wolfram Sang (1):
      i2c: sun6i-p2wi: use proper return value in probe

Yi Zhang (1):
      staging: android: timed_output: fix use after free of dev
