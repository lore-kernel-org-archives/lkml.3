Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3I2W77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 18:59:59 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:56241 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3I2W7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 18:59:55 -0400
MIME-Version: 1.0
Date: Sun, 29 Sep 2013 15:59:53 -0700
X-Google-Sender-Auth: C653asiNyHYpl6w94Usx-o2DmyQ
Message-ID: <CA+55aFx1DeNbT+wtVp-0s2JB1GqFrCk9K=KaXOQJV-tdmor_sw@mail.gmail.com>
Subject: Linux 3.12-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm back to a Sunday release schedule, so here it is, rc3.

Nothing really special stands out. There's a fair amount of churn in
mm, which is unusual at this point, but that's all reverts: during the
merge window Andrew sent some changes that were still being discussed,
and we're reverting them for now.

If you ignore the mm changes, the rest looks very normal: the bulk is
drivers (gpu, dm/bcache, usb, sound..), with the usual sprinkling of
architecture (powerpc, x86, arm, mips) and filesystem (udf, xfs,
reiserfs) changes. And some perf tooling.

And we had some performance-tweaking of the new lockref support for
ARM and s390.

On the whole, nothing really appears very scary. Go forth and test,

                   Linus

---

Adrian Hunter (4):
      perf annotate: Fix objdump line parsing offset validation
      perf tools: Fix buildid cache handling of kallsyms with kcore
      perf tools: Fix compile with libelf without get_phdrnum
      perf machine: Fix path unpopulated in machine__create_modules()

Al Viro (1):
      USB: Fix breakage in ffs_fs_mount()

Alan Stern (4):
      USB: iMX21: accept very late isochronous URBs
      USB: UHCI: accept very late isochronous URBs
      USB: OHCI: accept very late isochronous URBs
      USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd

Alex Deucher (13):
      drm/radeon: avoid UVD corruption on AGP cards using GPU gart
      drm/radeon: additional gcc fixes for radeon_atombios.c
      drm/radeon: fix missed variable sized access
      drm/radeon/dpm: fetch the max clk from voltage dep tables helper
      drm/radeon/dpm/btc: filter clocks based on voltage/clk dep tables
      drm/radeon/dpm/ni: filter clocks based on voltage/clk dep tables
      drm/radeon/dpm/si: filter clocks based on voltage/clk dep tables
      drm/radeon/dpm/ci: filter clocks based on voltage/clk dep tables
      drm/radeon: don't set default clocks for SI when DPM is disabled
      drm/radeon: disable tests/benchmarks if accel is disabled
      drm/radeon: add missing hdmi callbacks for rv6xx
      drm/radeon/cik: fix overflow in vram fetch
      drm/radeon: fix hdmi audio on DCE3.0/3.1 asics

Alex Ivanov (1):
      drm/radeon: Make r100_cp_ring_info() and radeon_ring_gfx() safe (v2)

Alexander Usyskin (1):
      mei: cancel stall timers in mei_reset

Andi Kleen (1):
      perf symbols: Demangle cloned functions

Andrew Morton (8):
      revert "memcg, vmscan: do not fall into reclaim-all pass too quickly"
      revert "memcg: track all children over limit in the root"
      revert "memcg, vmscan: do not attempt soft limit reclaim if it
would not scan anything"
      revert "memcg: track children in soft limit excess to improve soft limit"
      revert "memcg: enhance memcg iterator to support predicates"
      revert "vmscan, memcg: do softlimit reclaim also for targeted reclaim"
      revert "memcg: get rid of soft-limit tree infrastructure"
      revert "memcg, vmscan: integrate soft reclaim tighter with zone
shrinking code"

Andrzej Hajda (1):
      video: of: display_timing: correct display-timings node finding

Ard Biesheuvel (1):
      ARM: 7837/3: fix Thumb-2 bug in AES assembler code

Arnaldo Carvalho de Melo (1):
      perf session: Check for SIGINT in more loops

Ben Whitten (1):
      ALSA: hda - Add fixup for MacBook Air 6,1 and 6,2 with CS4208 codec

Benjamin Herrenschmidt (4):
      powerpc/irq: Run softirqs off the top of the irq stack
      powerpc: Remove ksp_limit on ppc64
      powerpc/zImage: make the "OF" wrapper support ePAPR boot
      powerpc/pseries: Do not start secondaries in Open Firmware

Benson Leung (1):
      driver core : Fix use after free of dev->parent in device_shutdown

Chew, Chiau Ee (1):
      i2c: designware: 10-bit addressing mode enabling if
I2C_DYNAMIC_TAR_UPDATE is set

Chris Wilson (1):
      drm/i915: Use a temporary va_list for two-pass string handling

Christian Daudt (1):
      MAINTAINERS: update mach-bcm related email address

Christian König (1):
      drm/radeon/uvd: lower msg&fb buffer requirements on UVD3

Chuansheng Liu (1):
      kernel/reboot.c: re-enable the function of variable reboot_default

Dan Carpenter (2):
      cpqarray: fix info leak in ida_locked_ioctl()
      cciss: fix info leak in cciss_ioctl32_passthru()

Daniel Vetter (3):
      drm/i915/tv: clear adjusted_mode.flags
      drm/i915: preserve pipe A quirk in i9xx_set_pipeconf
      drm/i915: Fix up usage of SHRINK_STOP

Dave Chinner (4):
      xfs: lock the AIL before removing the buffer item
      xfs: asserting lock not held during freeing not valid
      xfs: fix XFS_IOC_FREE_EOFBLOCKS definition
      xfs: log recovery lsn ordering needs uuid check

Dave Jones (1):
      x86/reboot: Fix apparent cut-n-paste mistake in Dell reboot workaround

David Ahern (2):
      perf trace: Add mmap2 handler
      perf tools: Explicitly add libdl dependency

David Cohen (1):
      usb: dwc3: add support for Merrifield

David Vrabel (2):
      xen/balloon: don't alloc page while non-preemptible
      xen/p2m: check MFN is in range before using the m2p table

Davidlohr Bueso (1):
      ipc: fix race with LSMs

Dinh Nguyen (1):
      dts: Fix misspelling of Synopsys

Eric W. Biederman (2):
      sysfs: Allow mounting without CONFIG_NET
      sysfs: Allow mounting without CONFIG_NET

Fabio Estevam (1):
      staging: imx-drm: Fix probe failure

Florian Wolter (1):
      xhci: Fix race between ep halt and URB cancellation

Frederic Weisbecker (1):
      arm: Fix build error with context tracking calls

Gabor Juhos (1):
      tty: ar933x_uart: move devicetree binding documentation

Gabriel de Perthuis (1):
      bcache: Strip endline when writing the label through sysfs

Geert Uytterhoeven (2):
      bcache: Correct printf()-style format length modifier
      usb: chipidea: USB_CHIPIDEA should depend on HAS_DMA

Goldwyn Rodrigues (1):
      fs/ocfs2/super.c: use a bigger nodestr in ocfs2_dismount_volume

Hanjun Guo (1):
      ACPI / scan: fix typo in comments of acpi_bus_unregister_driver()

Heiko Carstens (3):
      mutex: replace CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX with simple ifdef
      lockref: use arch_mutex_cpu_relax() in CMPXCHG_LOOP()
      s390: enable ARCH_USE_CMPXCHG_LOCKREF

Henrik Rydberg (1):
      hwmon: (applesmc) Check key count before proceeding

Iker Pedrosa (1):
      Staging: rtl8192u: r819xU_cmdpkt: checking NULL value after
doing dev_alloc_skb

Ingo Molnar (5):
      perf tools: Sharpen the libaudit dependencies test
      perf tools: Fill in new definitions for madvise()/mmap() flags
      perf tools: Fix old GCC build error in
trace-event-parse.c:parse_proc_kallsyms()
      perf/x86: Fix PMU detection printout when no PMU is detected
      Revert "perf symbols: Demangle cloned functions"

James Ralston (1):
      i2c: ismt: initialize DMA buffer

Jan Kara (1):
      udf: Fortify LVID loading

Jani Nikula (1):
      drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER

Jason Gunthorpe (2):
      tpm: xen-tpmfront: Fix default durations
      tpm: xen-tpmfront: Remove the locality sysfs attribute

Jayachandran C (1):
      MIPS: mm: Move some checks out of 'for' loop in DMA operations

Jean Delvare (1):
      kernel/params: fix handling of signed integer types

Jean Pihet (1):
      arm: clocksource: mvebu: Use the main timer as clock source from DT

Jeff Mahoney (2):
      reiserfs: remove useless flush_old_journal_lists
      reiserfs: fix race with flush_used_journal_lists and flush_journal_list

Jiri Olsa (1):
      perf kmem: Make it work again on non NUMA machines

Joe Perches (1):
      checkpatch: make extern in .h prototypes quieter

Joerg Roedel (1):
      drm/msm: Remove iommu include from mdp4_kms.c

Johan Hovold (4):
      serial: tegra: fix tty-kref leak
      serial: pch_uart: fix tty-kref leak in rx-error path
      serial: pch_uart: fix tty-kref leak in dma-rx path
      serial: pch_uart: remove unnecessary tty_port_tty_get

Josh Boyer (1):
      x86, efi: Don't map Boot Services on i386

Jun'ichi Nomura (1):
      dm mpath: do not fail path on -ENOSPC

K. Y. Srinivasan (2):
      Drivers: hv: util: Correctly support ws2008R2 and earlier
      Drivers: hv: vmbus: Terminate vmbus version negotiation on timeout

Kailang Yang (2):
      ALSA: hda - Fix Internal Mic boost can't control with ALC283
      ALSA: hda - Enable internal mic on a Thinkpad machine with ALC283

Kent Overstreet (9):
      block: Fix bio_copy_data()
      bcache: Fix a dumb journal discard bug
      bcache: Fix for when no journal entries are found
      bcache: Fix a writeback performance regression
      bcache: Fix a flush/fua performance bug
      bcache: Fix a dumb CPU spinning bug in writeback
      bcache: Fix a shrinker deadlock
      bcache: Fix for handling overlapping extents when reading in a btree node
      bcache: Fix flushes in writeback mode

Kim Phillips (1):
      i2c: s3c2410: fix clk_disable/clk_unprepare WARNings

Konrad Rzeszutek Wilk (2):
      xen: Do not enable spinlocks before jump_label_init() has executed
      xen/spinlock: Document the xen_nopvspin parameter.

Konstantin Khlebnikov (1):
      audit: fix endless wait in audit_log_start()

Kurt Garloff (1):
      usb/core/devio.c: Don't reject control message to endpoint with
wrong direction bit

Larry Finger (1):
      staging: r8188eu: Add new device ID

Liam Girdwood (2):
      ALSA: compress: Fix compress device unregister.
      ALSA: compress: Make sure we trigger STOP before closing the stream.

Lidza Louina (1):
      MAINTAINERS: staging: dgnc and dgap drivers: add maintainer

Linus Torvalds (1):
      Linux 3.12-rc3

Lv Zheng (1):
      ACPI / IPMI: Fix atomic context requirement of ipmi_msg_handler()

Maciej W. Rozycki (1):
      MIPS: cpu-features.h: s/MIPS53/MIPS64/

Magnus Damm (1):
      clocksource: em_sti: Set cpu_possible_mask to fix SMP broadcast

Malcolm Priestley (3):
      staging: vt6656: rxtx.c [BUG] s_vGetFreeContext dead lock on null apTD.
      staging: vt6656: [BUG] main_usb.c oops on device_close move flag earlier.
      staging: vt6656: [BUG] iwctl_siwencodeext return if device not open

Marek Vasut (1):
      video: mxsfb: Add missing break

Mark Brown (1):
      OMAPDSS: Add missing dependency on backlight for DSI-CM panel drier

Mark Tinguely (1):
      xfs: fix node forward in xfs_node_toosmall

Masami Hiramatsu (2):
      perf probe: Fix finder to find lines of given function
      perf probe: Fix probing symbols with optimization suffix

Masoud Sharbiani (1):
      x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically

Mathias Nyman (2):
      xhci: Fix oops happening after address device timeout
      xhci: Ensure a command structure points to the correct trb on
the command ring

Mengdong Lin (1):
      ALSA : hda - not use assigned converters for all unused pins

Michal Hocko (2):
      watchdog: update watchdog attributes atomically
      watchdog: update watchdog_thresh properly

Michel Dänzer (3):
      drm/radeon/cik: Fix printing of client name on VM protection fault
      drm/radeon/cik: Fix encoding of number of banks in tiling
configuration info
      drm/radeon/cik: Add tiling mode index for 1D tiled depth/stencil surfaces

Mikael Pettersson (1):
      update contact information for Mikael Pettersson

Mike Snitzer (5):
      dm mpath: disable WRITE SAME if it fails
      dm thin: do not expose non-zero discard limits if discards disabled
      dm: lower bio-based mempool reservation
      dm: add reserved_rq_based_ios module parameter
      dm: add reserved_bio_based_ios module parameter

Mikulas Patocka (3):
      dm stats: fix possible counter corruption on 32-bit systems
      dm snapshot: workaround for a false positive lockdep warning
      dm-snapshot: fix performance degradation due to small hash size

Nicolas Pitre (1):
      ARM: 7836/1: add __get_user_unaligned/__put_user_unaligned

Paul E. McKenney (1):
      mm: Place preemption point in do_mlockall() loop

Peter Chen (4):
      usb: chipidea: udc: fix the oops after rmmod gadget
      usb: chipidea: Fix memleak for ci->hw_bank.regmap when removal
      usb: chipidea: imx: Add usb_phy_shutdown at probe's error path
      usb: chipidea: udc: free pending TD at removal procedure

Peter Hurley (2):
      n_tty: Fix EOF push index when termios changes
      tty: Fix SIGTTOU not sent with tcflush()

Peter Zijlstra (2):
      perf: Update ABI comment
      perf: Fix capabilities bitfield compatibility in 'struct
perf_event_mmap_page'

Ramneek Mehresh (1):
      fsl/usb: Resolve PHY_CLK_VLD instability issue for ULPI phy

Rob Clark (2):
      drm/msm: deal with mach/iommu.h removal
      drm/msm: use drm_gem_dumb_destroy helper

Rob Herring (2):
      openrisc: clean-up prom.h
      of: clean-up ifdefs in of_irq.h

Russell King (2):
      ARM: only allow kernel mode neon with AEABI
      drm/i2c: tda998x: fix audio muting

Sachin Kamat (1):
      cpufreq: exynos5440: Fix potential NULL pointer dereference

Sarah Sharp (1):
      usb: Fix xHCI host issues on remote wakeup.

Sathya Prakash M R (1):
      OMAPDSS: Return right error during connector probe

Sebastian Hesselbarth (1):
      clocksource: of: Respect device tree node status

Shengzhou Liu (1):
      USB: fsl/ehci: fix failure of checking PHY_CLK_VALID during
reinitialization

Suravee Suthikulpanit (1):
      x86/microcode/AMD: Fix patch level reporting for family 15h

Takashi Iwai (1):
      ALSA: hda - Add documentation for CS4208 fixups

Thierry Reding (2):
      i2c: mv64xxx: Fix some build warnings
      i2c: mv64xxx: Do not use writel_relaxed()

Thomas Meyer (6):
      staging: lustre: Cocci spatch "noderef"
      staging: r8188eu: Add files for new drive: Cocci spatch "noderef"
      staging: octeon-usb: Cocci spatch "noderef"
      staging: r8188eu: Cocci spatch "noderef"
      staging: r8188eu: Add files for new drive: Cocci spatch "noderef"
      drm/msm: Odd PTR_ERR usage

Tobias Polzer (1):
      staging: usbip: Orphan usbip

Tomas Winkler (2):
      mei: make me client counters less error prone
      mei: bus: stop wait for read during cl state transition

Tomasz Figa (1):
      clocksource: exynos_mct: Set IRQ affinity when the CPU goes online

Tomi Valkeinen (1):
      OMAPDSS: DISPC: set irq_safe for runtime PM

Uwe Kleine-König (1):
      video: mmp: drop needless devm cleanup

Vinson Lee (1):
      tools lib lk: Uninclude linux/magic.h in debugfs.c

Viresh Kumar (1):
      cpufreq: check cpufreq driver is valid and cpufreq isn't
disabled in cpufreq_get()

Vladimir Davydov (3):
      sched/balancing: Fix 'local->avg_load > sds->avg_load' case in
calculate_imbalance()
      sched/balancing: Fix 'local->avg_load > busiest->avg_load' case
in fix_small_imbalance()
      sched/balancing: Fix cfs_rq->task_h_load calculation

Wei Yongjun (2):
      s3fb: fix error return code in s3_pci_probe()
      neofb: fix error return code in neofb_probe()

Will Deacon (2):
      ARM: 7839/1: entry: fix tracing of ARM-private syscalls
      lockref: allow relaxed cmpxchg64 variant for lockless updates

Xenia Ragiadakou (1):
      usbcore: check usb device's state before sending a Set SEL
control transfer

Yan, Zheng (2):
      perf/x86/intel/uncore: Don't use smp_processor_id() in validate_group()
      perf/x86/intel: Add model number for Avoton Silvermont

Yinghai Lu (2):
      acpi-cpufreq: skip loading acpi_cpufreq after intel_pstate
      PCI: Workaround missing pci_set_master in pci drivers
