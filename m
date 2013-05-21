Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab3EUB7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 21:59:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3122 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab3EUB7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 21:59:41 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=mDDG2MC21OZcPSyujm4A:9 a=QEXdDO2ut3YA:10 a=Zkab8jXmPRKhEeL-:21 a=2MXT8m77AKNC-DtG:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369101578.6828.128.camel@gandalf.local.home>
Subject: Linux 3.6.11.4
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>
Date: Mon, 20 May 2013 21:59:38 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm announcing the release of the 3.6.11.4 kernel.

The updated 3.6.11.y git tree can be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git v3.6-stable

The patch can be downloaded at:
	https://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.4.xz

thanks,

-- Steve

 Makefile                                      |    2 +-
 arch/arm/configs/at91sam9g45_defconfig        |    1 -
 arch/arm/include/asm/pgtable.h                |    9 +++
 arch/arm/mach-at91/setup.c                    |    2 +-
 arch/arm/mach-omap2/cpuidle34xx.c             |    5 +-
 arch/arm/mach-u300/include/mach/u300-regs.h   |    2 +-
 arch/avr32/configs/favr-32_defconfig          |    1 -
 arch/avr32/configs/merisc_defconfig           |    1 -
 arch/ia64/include/asm/futex.h                 |    5 +-
 arch/ia64/include/asm/mca.h                   |    1 +
 arch/ia64/kernel/irq.c                        |    8 +++
 arch/ia64/kernel/mca.c                        |   37 +++++++----
 arch/ia64/kvm/vtlb.c                          |    2 +-
 arch/powerpc/include/asm/ppc-opcode.h         |    4 ++
 arch/powerpc/kernel/head_64.S                 |    1 +
 arch/powerpc/kernel/traps.c                   |   10 ++-
 arch/powerpc/mm/numa.c                        |    2 +-
 arch/powerpc/platforms/cell/spufs/inode.c     |    1 +
 arch/s390/include/asm/pgtable.h               |    4 ++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c    |   27 +++++++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   17 +++---
 arch/x86/kernel/irq.c                         |    4 --
 arch/x86/kvm/emulate.c                        |    4 ++
 arch/x86/mm/init.c                            |    5 ++
 arch/x86/xen/enlighten.c                      |    5 +-
 arch/x86/xen/smp.c                            |    2 +
 arch/x86/xen/time.c                           |    6 +-
 drivers/acpi/pci_root.c                       |    4 +-
 drivers/ata/libata-acpi.c                     |   45 ++++++++------
 drivers/char/tpm/tpm.c                        |   32 ++++++++--
 drivers/char/tpm/tpm.h                        |    2 +
 drivers/gpu/drm/ast/ast_drv.h                 |    2 +
 drivers/gpu/drm/ast/ast_fb.c                  |   43 ++++++++++++-
 drivers/gpu/drm/ast/ast_ttm.c                 |    2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.h           |    2 +
 drivers/gpu/drm/cirrus/cirrus_fbdev.c         |   38 +++++++++++-
 drivers/gpu/drm/cirrus/cirrus_ttm.c           |    2 +-
 drivers/gpu/drm/drm_gem.c                     |    4 +-
 drivers/gpu/drm/drm_prime.c                   |   76 ++++++++++++-----------
 drivers/gpu/drm/gma500/psb_irq.c              |    2 +-
 drivers/gpu/drm/i915/i915_drv.h               |    2 +
 drivers/gpu/drm/i915/i915_gem.c               |   28 +++++++--
 drivers/gpu/drm/i915/i915_gem_context.c       |    7 +++
 drivers/gpu/drm/i915/i915_gem_stolen.c        |   81 +++++++++++++------------
 drivers/gpu/drm/i915/i915_reg.h               |    1 +
 drivers/gpu/drm/i915/intel_bios.c             |    6 +-
 drivers/gpu/drm/i915/intel_bios.h             |    4 +-
 drivers/gpu/drm/i915/intel_dvo.c              |   13 +++-
 drivers/gpu/drm/i915/intel_lvds.c             |    8 +++
 drivers/gpu/drm/i915/intel_pm.c               |    9 ++-
 drivers/gpu/drm/mgag200/mgag200_drv.h         |    2 +
 drivers/gpu/drm/mgag200/mgag200_fb.c          |   43 ++++++++++++-
 drivers/gpu/drm/mgag200/mgag200_ttm.c         |    4 +-
 drivers/gpu/drm/radeon/atom.c                 |    6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c        |    3 +
 drivers/gpu/drm/radeon/evergreen.c            |   66 +++++++++++++++++---
 drivers/gpu/drm/radeon/ni.c                   |    8 ++-
 drivers/gpu/drm/radeon/nid.h                  |    4 ++
 drivers/gpu/drm/radeon/r100.c                 |   77 +++++++++++++++--------
 drivers/gpu/drm/radeon/r600_hdmi.c            |    4 +-
 drivers/gpu/drm/radeon/radeon_atombios.c      |   21 ++++---
 drivers/gpu/drm/radeon/radeon_kms.c           |    4 ++
 drivers/gpu/drm/radeon/radeon_pm.c            |    6 +-
 drivers/gpu/drm/radeon/rs600.c                |   54 ++++++++++++++---
 drivers/gpu/drm/radeon/si.c                   |    3 +-
 drivers/gpu/drm/radeon/sid.h                  |    2 +
 drivers/i2c/busses/i2c-xiic.c                 |    6 +-
 drivers/md/md.c                               |    9 +--
 drivers/md/raid1.c                            |    7 ++-
 drivers/md/raid10.c                           |    6 ++
 drivers/mfd/adp5520.c                         |    8 ++-
 drivers/mmc/core/mmc.c                        |    2 +-
 drivers/mmc/host/Kconfig                      |   10 ---
 drivers/mmc/host/atmel-mci.c                  |   16 +++--
 drivers/net/ethernet/freescale/gianfar_ptp.c  |    3 +-
 drivers/net/ethernet/ibm/ibmveth.c            |   23 +++----
 drivers/net/ethernet/intel/e1000e/netdev.c    |   78 ++++++------------------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   10 +++
 drivers/net/ethernet/realtek/r8169.c          |    9 +++
 drivers/net/wireless/iwlwifi/dvm/debugfs.c    |   16 ++---
 drivers/net/wireless/iwlwifi/dvm/sta.c        |    5 +-
 drivers/net/wireless/mwifiex/pcie.c           |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c       |   10 ++-
 drivers/pci/pci-driver.c                      |    4 ++
 drivers/pci/pci.c                             |   12 ++--
 drivers/rtc/rtc-cmos.c                        |    4 +-
 drivers/s390/char/sclp_cmd.c                  |    4 +-
 drivers/tty/pty.c                             |    3 +
 drivers/tty/serial/serial_core.c              |    4 ++
 drivers/tty/tty_io.c                          |    4 +-
 drivers/usb/chipidea/udc.c                    |    8 +++
 drivers/usb/chipidea/udc.h                    |    4 +-
 drivers/usb/core/devio.c                      |    2 +
 drivers/usb/host/ehci-hcd.c                   |    3 -
 drivers/usb/host/xhci-ring.c                  |   23 ++++---
 drivers/usb/misc/appledisplay.c               |    1 +
 drivers/usb/serial/ftdi_sio.c                 |   23 ++++---
 drivers/usb/serial/ftdi_sio_ids.h             |    4 +-
 drivers/usb/serial/option.c                   |    8 +++
 drivers/usb/storage/cypress_atacb.c           |   16 ++++-
 fs/autofs4/expire.c                           |    9 ---
 fs/btrfs/delayed-ref.c                        |   24 +++++---
 fs/dcache.c                                   |    4 +-
 fs/exec.c                                     |    7 ++-
 fs/ext4/Kconfig                               |    3 +-
 fs/ext4/ext4_jbd2.h                           |    6 +-
 fs/ext4/fsync.c                               |    3 +-
 fs/ext4/inode.c                               |   11 ++--
 fs/ext4/mballoc.c                             |    8 +--
 fs/ext4/mmp.c                                 |    2 +-
 fs/ext4/resize.c                              |    6 ++
 fs/ext4/super.c                               |    7 ++-
 fs/fscache/stats.c                            |    2 +-
 fs/jbd2/commit.c                              |   50 ++++++++-------
 fs/jbd2/journal.c                             |   31 ++++++++++
 fs/lockd/clntlock.c                           |    3 +
 fs/nfs/nfs4proc.c                             |    6 ++
 fs/nfsd/nfs4proc.c                            |    8 +--
 fs/nfsd/nfs4state.c                           |    8 +--
 fs/nfsd/nfs4xdr.c                             |   19 ++----
 fs/notify/inotify/inotify_user.c              |    6 +-
 fs/sysfs/dir.c                                |   15 +++--
 include/asm-generic/pgtable.h                 |   10 +++
 include/drm/drmP.h                            |    5 +-
 include/drm/drm_pciids.h                      |    5 ++
 include/linux/ipc_namespace.h                 |    2 +-
 include/linux/jbd2.h                          |    2 +
 include/linux/sched.h                         |   18 ++----
 ipc/shm.c                                     |    2 +-
 kernel/audit_tree.c                           |    2 +-
 kernel/cgroup.c                               |    2 +-
 kernel/hrtimer.c                              |    6 ++
 kernel/time/tick-broadcast.c                  |    4 ++
 kernel/time/tick-common.c                     |    1 +
 kernel/trace/ftrace.c                         |    5 +-
 kernel/trace/trace.c                          |   64 +++++++++----------
 kernel/trace/trace_selftest.c                 |    9 +--
 kernel/trace/trace_stack.c                    |   76 ++++++++++++++++++++---
 kernel/trace/trace_stat.c                     |    2 +
 mm/mmap.c                                     |    4 +-
 mm/page_io.c                                  |   17 ++++++
 net/ipv4/netfilter/ipt_rpfilter.c             |    8 ++-
 net/ipv6/netfilter/ip6t_rpfilter.c            |    8 ++-
 net/netfilter/ipset/ip_set_core.c             |    3 +-
 net/netfilter/ipset/ip_set_list_set.c         |   10 ++-
 net/netfilter/ipvs/ip_vs_pe_sip.c             |    6 +-
 net/netfilter/nf_conntrack_helper.c           |    4 +-
 net/netfilter/nf_conntrack_netlink.c          |    3 +
 net/netfilter/nf_conntrack_sip.c              |    2 +-
 net/wireless/reg.c                            |    2 +-
 sound/soc/codecs/max98088.c                   |    2 +-
 sound/usb/card.c                              |    4 +-
 sound/usb/card.h                              |    1 +
 sound/usb/midi.c                              |   69 +++++++++++----------
 sound/usb/pcm.c                               |    2 +-
 sound/usb/quirks.c                            |    1 +
 sound/usb/stream.c                            |    9 +++
 157 files changed, 1247 insertions(+), 598 deletions(-)
---------------------------
Aaron Lu (1):
      acpi: make ata_ap_acpi_handle not block

Adrian Thomasset (2):
      USB: ftdi_sio: correct ST Micro Connect Lite PIDs
      USB: ftdi_sio: enable two UART ports on ST Microconnect Lite

Alex A. Mihaylov (1):
      rt2x00: Fix transmit power troubles on some Ralink RT30xx cards

Alex Deucher (16):
      drm/radeon: don't use get_engine_clock() on APUs
      drm/radeon: use frac fb div on RS780/RS880
      drm/radeon/dce6: add missing display reg for tiling setup
      drm/radeon: update wait_for_vblank for r5xx-r7xx
      drm/radeon: update wait_for_vblank for evergreen+
      drm/radeon: update wait_for_vblank for r1xx-r4xx
      drm/radeon: disable the crtcs in mc_stop (evergreen+) (v2)
      drm/radeon: add some new SI PCI ids
      drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS
      drm/radeon: cleanup properly if mmio mapping fails
      drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
      drm/radeon: fix typo in si_select_se_sh()
      drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
      drm/radeon: fix possible segfault when parsing pm tables
      drm/radeon: add new richland pci ids
      drm/radeon: fix handling of v6 power tables

Anisse Astier (1):
      drm/gma500: fix backlight hotkeys behaviour on netbooks

Anton Blanchard (1):
      powerpc: Emulate non privileged DSCR read and write

Anurup m (1):
      fs/fscache/stats.c: fix memory leak

Ben Jencks (1):
      usb/misc/appledisplay: Add 24" LED Cinema display

Benjamin Herrenschmidt (1):
      net/eth/ibmveth: Fixup retrieval of MAC address

Bjørn Mork (1):
      USB: option: add a D-Link DWM-156 variant

Bryan Schumaker (1):
      nfsd: Decode and send 64bit time values

Calvin Owens (1):
      ALSA: usb: Add quirk for 192KHz recording on E-Mu devices

Catalin Marinas (1):
      arm: set the page table freeing ceiling to TASK_SIZE

Chen Gang (1):
      kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()

Chris Wilson (3):
      drm/i915: Fix detection of base of stolen memory
      drm/i915: Workaround incoherence between fences and LLC across multiple CPUs
      drm/i915: Use MLC (l3$) for context objects

Christian Lamparter (1):
      drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900

Clemens Ladisch (1):
      ALSA: usb-audio: disable autopm for MIDI devices

Daniel Lezcano (1):
      ARM: omap3: cpuidle: enable time keeping

Daniel Mack (1):
      ALSA: snd-usb: try harder to find USB_DT_CS_ENDPOINT

Dave Airlie (4):
      drm/cirrus: deal with bo reserve fail in dirty update path
      drm/mgag200: deal with bo reserve fail in dirty update path
      drm/prime: keep a reference from the handle to exported dma-buf (v6)
      drm/ast: deal with bo reserve fail in dirty update path

David Engraf (1):
      hrtimer: Fix ktime_add_ns() overflow on 32bit architectures

David Jeffery (1):
      autofs - remove autofs dentry mount check

David Müller (ELSOFT AG) (1):
      drm/i915: Fall back to bit banging mode for DVO transmitter detection

Derek Basehore (1):
      drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend

Dmitry Monakhov (3):
      jbd2: fix race between jbd2_journal_remove_checkpoint and ->j_commit_callback
      ext4: fix journal callback list traversal
      ext4: fix big-endian bug in metadata checksum calculations

Duncan Laurie (1):
      TPM: Retry SaveState command in suspend path

Dylan Reid (1):
      ASoC: max98088: Fix logging of hardware revision.

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't send zeroed LQ cmd

Federico Vaga (1):
      serial_core.c: add put_device() after device_find_child()

Filippo Turato (1):
      USB: serial: option: Added support Olivetti Olicard 145

Florian Westphal (3):
      netfilter: nf_ct_helper: don't discard helper if it is actually the same
      netfilter: ctnetlink: don't permit ct creation with random tuple
      netfilter: xt_rpfilter: skip locally generated broadcast/multicast, too

Gleb Natapov (1):
      KVM: X86 emulator: fix source operand decoding for 8bit mov[zs]x instructions

Greg Thelen (1):
      fs/dcache.c: add cond_resched() to shrink_dcache_parent()

Hans Schillstrom (1):
      ipvs: ip_vs_sip_fill_param() BUG: bad check of return value

Hans de Goede (1):
      usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the ctrl ep

Heiko Carstens (1):
      s390/memory hotplug: prevent offline of active memory increments

Hugh Dickins (1):
      mm: allow arch code to control the user page table ceiling

J. Bruce Fields (1):
      nfsd4: don't close read-write opens too soon

Jacob Keller (1):
      ixgbe: fix EICR write in ixgbe_msix_other

Jan-Simon Möller (1):
      perf/x86/intel: Fix unintended variable name reuse

Jerome Marchand (1):
      swap: redirty page if page write fails on swap file

Jerry Hoemann (1):
      x86/mm: account for PGDIR_SIZE alignment

Johan Hovold (1):
      mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload

Johannes Berg (1):
      wireless: regulatory: fix channel disabling race condition

Josef Bacik (1):
      Btrfs: compare relevant parts of delayed tree refs

Jozsef Kadlecsik (2):
      netfilter: ipset: list:set: fix reference counter update
      netfilter: ipset: "Directory not empty" error message

Konrad Rzeszutek Wilk (3):
      xen/time: Fix kasprintf splat when allocating timer%d IRQ line.
      xen/smp: Fix leakage of timer interrupt line for every CPU online/offline.
      xen/smp/spinlock: Fix leakage of the spinlock interrupt line for every CPU online/offline

Konstantin Khlebnikov (1):
      e1000e: fix runtime power management transitions

Lars-Peter Clausen (1):
      mfd: adp5520: Restore mode bits on resume

Li Fei (1):
      x86: Eliminate irq_mis_count counted in arch_irq_stat

Li Zefan (1):
      cgroup: fix an off-by-one bug which may trigger BUG_ON()

Linus Torvalds (2):
      tty: fix up atime/mtime mess, take three
      s390: move dummy io_remap_pfn_range() to asm/pgtable.h

Linus Walleij (1):
      ARM: u300: fix ages old copy/paste bug

Maxime Ripard (1):
      ARM: at91: Fix typo in restart code panic message

Mel Gorman (1):
      mm: swap: mark swap pages writeback before queueing for direct IO

Michael Ellerman (1):
      powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()

Michael Grzeschik (2):
      usb: chipidea: udc: fix memory access of shared memory on armv5 machines
      usb: chipidea: udc: fix memory leak in _ep_nuke

Michael Neuling (1):
      powerpc: Add isync to copy_and_flush

Ming Lei (1):
      sysfs: fix use after free in case of concurrent read/write and readdir

Namhyung Kim (3):
      tracing: Fix off-by-one on allocating stat->pages
      tracing: Check return value of tracing_init_dentry()
      tracing: Reset ftrace_graph_filter_enabled if count is zero

NeilBrown (1):
      md: bad block list should default to disabled.

Oleg Nesterov (1):
      exec: do not abuse ->cred_guard_mutex in threadgroup_lock()

Patrick McHardy (1):
      netfilter: nf_ct_sip: don't drop packets with offsets pointing outside the packet

Paulo Zanoni (1):
      drm/i915: set CPT FDI RX polarity bits based on VBT

Peter Zijlstra (2):
      perf/x86/intel/lbr: Fix LBR filter
      perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL

Philip Rakity (1):
      mmc: core: Fix bit width test failing on old eMMC cards

Prarit Bhargava (1):
      hrtimer: Add expiry time overflow check in hrtimer_interrupt

Rafael J. Wysocki (2):
      PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()
      PCI/PM: Clear state_saved during suspend

Richard Cochran (1):
      gianfar: do not advertise any alarm capability.

Robin Holt (1):
      ipc: sysv shared memory limited to 8TiB

Sarah Sharp (1):
      xhci: Don't warn on empty ring for suspended devices.

Shaohua Li (1):
      MD: ignore discard request for hard disks of hybid raid1/raid10 array

Shengzhou Liu (1):
      usb: remove redundant tdi_reset

Stanislaw Gruszka (1):
      iwlwifi: fix freeing uninitialized pointer

Stefan Bader (1):
      r8169: fix 8168evl frame padding.

Stefani Seibold (1):
      USB: add ftdi_sio USB ID for GDM Boost V1.x

Stephan Schreiber (2):
      Wrong asm register contraints in the futex implementation
      Wrong asm register contraints in the kvm implementation

Steven A. Falco (1):
      i2c: xiic: must always write 16-bit words to TX_FIFO

Steven Rostedt (Red Hat) (5):
      tracing: Use stack of calling function for stack tracer
      tracing: Fix stack tracer with fentry use
      tracing: Remove most or all of stack tracer stack size from stack_max_size
      tracing: Fix ftrace_dump()
      Linux 3.6.11.4

Takashi Iwai (2):
      ALSA: usb-audio: Fix missing autopm for MIDI input
      ALSA: usb-audio: Fix autopm error during probing

Terry Barnaby (1):
      mmc: atmel-mci: pio hang on block errors

Theodore Ts'o (4):
      ext4/jbd2: don't wait (forever) for stale tid caused by wraparound
      ext4: fix online resizing for ext3-compat file systems
      ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG
      ext4: add check for inodes_count overflow in new resize ioctl

Thomas Gleixner (1):
      clockevents: Set dummy handler on CPU_DEAD shutdown

Tony Luck (1):
      Fix initialization of CMCI/CMCP interrupts

Tormod Volden (1):
      usb-storage: CY7C68300A chips do not support Cypress ATACB

Trond Myklebust (2):
      LOCKD: Ensure that nlmclnt_block resets block->b_status after a server reboot
      NFSv4: Handle NFS4ERR_DELAY and NFS4ERR_GRACE in nfs4_open_delegation_recall

Vaidyanathan Srinivasan (1):
      powerpc: fix numa distance for form0 device tree

Vince Weaver (1):
      perf/x86/intel: Add support for IvyBridge model 58 Uncore

Yinghai Lu (1):
      PCI / ACPI: Don't query OSC support with all possible controls

Yogesh Ashok Powar (2):
      mwifiex: Use pci_release_region() instead of a pci_release_regions()
      mwifiex: Call pci_release_region after calling pci_disable_device

Zhao Hongjiang (1):
      inotify: invalid mask should return a error number but not set it

fanchaoting (1):
      nfsd: don't run get_file if nfs4_preprocess_stateid_op return error

----


