Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaKKLJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:09:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaKKLJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.16.y-ckt stable] Linux 3.16.7-ckt1 stable review
Date: Tue, 11 Nov 2014 11:05:59 +0000
Message-Id: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
X-Extended-Stable: 3.16
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.16.7-ckt1 stable kernel.

This version contains 170 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.16.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.16.y-review

The review period for version 3.16.7-ckt1 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.16.y-ckt extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 arch/arc/boot/dts/nsimosci.dts                    |   2 +-
 arch/arc/include/asm/arcregs.h                    |   8 -
 arch/arc/include/asm/kgdb.h                       |  32 ++--
 arch/arc/include/asm/processor.h                  |   9 +
 arch/mips/include/asm/ftrace.h                    |   4 +-
 arch/mips/loongson/lemote-2f/clock.c              |   5 +-
 arch/mips/math-emu/cp1emu.c                       |   4 +-
 arch/mips/mm/tlbex.c                              |   6 +-
 arch/sh/kernel/cpu/sh3/setup-sh770x.c             |   6 +-
 arch/x86/ia32/ia32entry.S                         |  18 +-
 arch/x86/include/asm/kvm_host.h                   |  16 +-
 arch/x86/include/uapi/asm/vmx.h                   |   2 +
 arch/x86/kernel/apic/apic.c                       |   4 +-
 arch/x86/kernel/cpu/common.c                      |   2 +-
 arch/x86/kernel/tsc.c                             |   5 +-
 arch/x86/kvm/emulate.c                            | 219 ++++++++++++++++------
 arch/x86/kvm/i8254.c                              |   2 +
 arch/x86/kvm/svm.c                                |   8 +-
 arch/x86/kvm/vmx.c                                |  24 ++-
 arch/x86/kvm/x86.c                                |  38 +++-
 arch/x86/mm/pageattr.c                            |   2 +-
 arch/x86/net/bpf_jit_comp.c                       |  25 ++-
 block/scsi_ioctl.c                                |   3 +-
 drivers/acpi/ec.c                                 |  25 ++-
 drivers/base/power/clock_ops.c                    |  19 +-
 drivers/base/power/main.c                         |   2 +
 drivers/char/hw_random/virtio-rng.c               |   7 +
 drivers/char/random.c                             |  10 +-
 drivers/cpufreq/cpufreq.c                         |  23 ++-
 drivers/cpufreq/intel_pstate.c                    | 111 ++++++++---
 drivers/edac/cpc925_edac.c                        |   2 +-
 drivers/edac/e7xxx_edac.c                         |   2 +-
 drivers/edac/i3200_edac.c                         |   4 +-
 drivers/edac/i82860_edac.c                        |   2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c               |   2 +
 drivers/gpu/drm/i915/intel_display.c              |   3 +
 drivers/gpu/drm/i915/intel_dp.c                   |   7 +
 drivers/gpu/drm/qxl/qxl_display.c                 |  16 +-
 drivers/gpu/drm/radeon/cik_sdma.c                 |  21 ++-
 drivers/gpu/drm/radeon/dce3_1_afmt.c              |   4 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                |   6 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c           |   6 +-
 drivers/gpu/drm/radeon/kv_dpm.c                   |  20 +-
 drivers/gpu/drm/radeon/r600_dma.c                 |  21 ++-
 drivers/gpu/drm/radeon/radeon.h                   |   3 +
 drivers/gpu/drm/radeon/radeon_cs.c                |   2 +-
 drivers/gpu/drm/radeon/radeon_drv.c               |   4 +
 drivers/gpu/drm/radeon/radeon_ring.c              |   4 +-
 drivers/gpu/drm/radeon/radeon_vm.c                |   4 +-
 drivers/gpu/drm/radeon/si_dpm.c                   |   2 +-
 drivers/gpu/drm/radeon/trinity_dpm.c              |  24 ++-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c               |  60 +++++-
 drivers/iio/common/st_sensors/st_sensors_buffer.c |   2 +-
 drivers/infiniband/ulp/isert/ib_isert.c           |   4 +-
 drivers/input/serio/i8042-x86ia64io.h             |  16 ++
 drivers/mtd/chips/cfi_cmdset_0001.c               |   2 +
 drivers/mtd/devices/m25p80.c                      |  72 ++++++-
 drivers/mtd/spi-nor/fsl-quadspi.c                 |   7 +-
 drivers/mtd/spi-nor/spi-nor.c                     |  42 +----
 drivers/net/Kconfig                               |   2 +
 drivers/net/can/at91_can.c                        |   8 +-
 drivers/net/can/flexcan.c                         |  41 +++-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c        |   7 +-
 drivers/net/hyperv/netvsc_drv.c                   |   1 +
 drivers/net/macvlan.c                             |  10 +-
 drivers/net/macvtap.c                             |  16 +-
 drivers/net/tun.c                                 |  25 ++-
 drivers/net/usb/ax88179_178a.c                    |   7 +-
 drivers/net/virtio_net.c                          |  24 ++-
 drivers/net/vxlan.c                               |  15 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c       |  24 +--
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h   |  35 +++-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h         |   1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c             |   9 +
 drivers/net/wireless/iwlwifi/mvm/ops.c            |   1 +
 drivers/net/wireless/iwlwifi/mvm/tx.c             |   8 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c         |  16 +-
 drivers/net/wireless/rt2x00/rt2800.h              |   4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c           |   6 +
 drivers/net/wireless/rt2x00/rt2800usb.c           |   5 +
 drivers/pci/pci-sysfs.c                           |   8 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                |  11 +-
 drivers/spi/spi-pl022.c                           |   2 +-
 drivers/staging/comedi/comedi_fops.c              |  18 +-
 drivers/staging/iio/adc/mxs-lradc.c               |  12 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c   |  15 +-
 drivers/target/target_core_device.c               |   3 +-
 drivers/target/target_core_pr.c                   |   6 +-
 drivers/target/target_core_pr.h                   |   2 +-
 drivers/target/target_core_tpg.c                  |   8 +
 drivers/target/target_core_transport.c            |   3 +-
 drivers/usb/chipidea/core.c                       |   1 -
 drivers/usb/dwc3/dwc3-omap.c                      |  15 +-
 drivers/usb/dwc3/ep0.c                            |   4 +-
 drivers/usb/dwc3/gadget.c                         |  17 +-
 drivers/usb/dwc3/gadget.h                         |   2 +-
 drivers/usb/gadget/f_acm.c                        |   7 +-
 drivers/usb/gadget/f_fs.c                         |  42 ++++-
 drivers/usb/gadget/udc-core.c                     |   5 +
 drivers/usb/musb/musb_cppi41.c                    |   3 +-
 drivers/usb/musb/musb_dsps.c                      |   4 +-
 drivers/usb/phy/phy.c                             |   3 +
 drivers/usb/serial/cp210x.c                       |   1 +
 drivers/usb/serial/ftdi_sio.c                     |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                 |  12 +-
 drivers/usb/serial/option.c                       |  10 +
 fs/buffer.c                                       |   3 +
 fs/direct-io.c                                    |   2 +-
 fs/ext3/super.c                                   |   7 -
 fs/ext4/balloc.c                                  |  12 +-
 fs/ext4/bitmap.c                                  |  12 +-
 fs/ext4/ext4.h                                    |  13 +-
 fs/ext4/extents.c                                 |   6 +-
 fs/ext4/file.c                                    |   2 +-
 fs/ext4/ialloc.c                                  |   7 +-
 fs/ext4/inline.c                                  |   3 +-
 fs/ext4/inode.c                                   |  46 +++--
 fs/ext4/ioctl.c                                   |  13 +-
 fs/ext4/mmp.c                                     |   6 +-
 fs/ext4/namei.c                                   |  94 +++++-----
 fs/ext4/resize.c                                  |   5 +-
 fs/ext4/super.c                                   |  32 ++--
 fs/ext4/xattr.c                                   |  38 ++--
 fs/fuse/file.c                                    |   5 +-
 fs/jbd2/recovery.c                                |   1 +
 fs/namei.c                                        |  18 +-
 fs/namespace.c                                    |   3 +
 fs/nfs/client.c                                   |  95 ++++++----
 fs/nfs/inode.c                                    |   3 +-
 fs/nfs/internal.h                                 |   9 +
 fs/nfs/netns.h                                    |   3 +
 fs/nfsd/nfs4proc.c                                |   7 +-
 fs/pstore/inode.c                                 |   4 +-
 fs/quota/dquot.c                                  |   2 +-
 include/drm/drm_pciids.h                          |   1 -
 include/linux/blkdev.h                            |   3 +-
 include/linux/khugepaged.h                        |  17 +-
 include/linux/mm.h                                |   1 +
 include/linux/mtd/spi-nor.h                       |  21 +--
 include/linux/oom.h                               |   3 +
 include/linux/string.h                            |   5 +-
 include/linux/uio.h                               |   2 +-
 include/net/ipv6.h                                |   2 +
 include/net/sctp/sctp.h                           |   5 +
 include/net/sctp/sm.h                             |   6 +-
 init/Kconfig                                      |   1 +
 kernel/freezer.c                                  |   3 +
 kernel/futex.c                                    |  22 +--
 kernel/posix-timers.c                             |   1 +
 kernel/power/hibernate.c                          |   8 +-
 kernel/power/process.c                            |  40 +++-
 kernel/trace/trace_syscalls.c                     |   8 +-
 lib/bitmap.c                                      |   8 +-
 lib/string.c                                      |  16 ++
 mm/huge_memory.c                                  |  15 +-
 mm/iov_iter.c                                     |  13 +-
 mm/memory.c                                       |   1 +
 mm/mmap.c                                         |   8 +-
 mm/oom_kill.c                                     |  17 ++
 mm/page_alloc.c                                   |  15 +-
 mm/page_cgroup.c                                  |   1 +
 mm/truncate.c                                     |  56 ++++++
 net/core/tso.c                                    |   3 +-
 net/ipv4/fib_semantics.c                          |   2 +-
 net/ipv4/gre_offload.c                            |   2 +-
 net/ipv4/ip_output.c                              |  12 +-
 net/ipv4/ip_tunnel_core.c                         |   3 +-
 net/ipv4/route.c                                  |   1 +
 net/ipv4/tcp.c                                    |  59 ++----
 net/ipv6/output_core.c                            |  34 ++++
 net/mac80211/rate.c                               |   2 +-
 net/sctp/associola.c                              |   2 +
 net/sctp/inqueue.c                                |  33 +---
 net/sctp/sm_make_chunk.c                          |  99 +++++-----
 net/sctp/sm_statefuns.c                           |  21 +--
 scripts/package/builddeb                          |  22 +--
 security/integrity/evm/evm_main.c                 |   9 +-
 security/integrity/ima/ima_appraise.c             |   2 +
 security/integrity/integrity.h                    |   1 +
 sound/core/pcm_compat.c                           |   2 +
 sound/firewire/bebob/bebob_focusrite.c            |  62 ++++--
 sound/firewire/bebob/bebob_stream.c               |  18 +-
 sound/soc/codecs/adau1761.c                       |   4 +
 sound/soc/intel/sst-haswell-pcm.c                 |   4 +-
 virt/kvm/iommu.c                                  |   8 +-
 186 files changed, 1801 insertions(+), 843 deletions(-)

Aaro Koskinen (1):
      MIPS: loongson2_cpufreq: Fix CPU clock rate setting mismerge

Al Viro (2):
      switch iov_iter_get_pages() to passing maximal number of pages
      be careful with nd->inode in path_init() and follow_dotdot_rcu()

Alex Deucher (6):
      drm/radeon: fix speaker allocation setup
      drm/radeon: use gart memory for DMA ring tests
      drm/radeon/dpm: disable ulv support on SI
      drm/radeon: add bapm module parameter
      drm/radeon: dpm fixes for asrock systems
      drm/radeon: remove invalid pci id

Alexei Starovoitov (1):
      x86: bpf_jit: fix two bugs in eBPF JIT compiler

Amos Kong (2):
      virtio-rng: fix stuck of hot-unplugging busy device
      virtio-rng: skip reading when we start to remove the device

Andriy Skulysh (1):
      sh: fix sh770x SCIF memory regions

Andy Honig (2):
      KVM: x86: Prevent host from panicking on shared MSR writes.
      KVM: x86: Improve thread safety in pit

Andy Lutomirski (3):
      x86, apic: Handle a bad TSC more gracefully
      x86_64, entry: Filter RFLAGS.NT on entry from userspace
      x86_64, entry: Fix out of bounds read on sysenter

Anton Kolesov (1):
      ARC: Update order of registers in KGDB to match GDB 7.5

Arjun Sreedharan (1):
      usb: phy: return -ENODEV on failure of try_module_get

Ben Hutchings (5):
      drivers/net: Disable UFO through virtio
      drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets
      drivers/net: macvtap and tun depend on INET
      mtd: spi-nor: make spi_nor_scan() take a chip type name, not spi_device_id
      mtd: m25p80,spi-nor: Fix module aliases for m25p80

Brian Silverman (1):
      futex: Fix a race condition between REQUEUE_PI and task death

Canek Peláez Valdés (1):
      rt2x00: support Ralink 5362.

Christian Vogel (1):
      ALSA: bebob: Uninitialized id returned by saffirepro_both_clk_src_get

Christoph Hellwig (1):
      Revert "block: all blk-mq requests are tagged"

Cong Wang (1):
      freezer: Do not freeze tasks killed by OOM killer

Cyril Brulebois (1):
      wireless: rt2x00: add new rt2800usb device

Dan Williams (1):
      USB: option: add Haier CE81B CDMA modem

Daniel Borkmann (4):
      random: add and use memzero_explicit() for clearing data
      net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks
      net: sctp: fix panic on duplicate ASCONF chunks
      net: sctp: fix remote memory pressure from excessive queueing

Daniele Palmas (1):
      usb: option: add support for Telit LE910

Darrick J. Wong (4):
      ext4: check EA value offset when loading
      jbd2: free bh when descriptor block checksum fails
      ext4: check s_chksum_driver when looking for bg csum presence
      ext4: enable journal checksum when metadata checksum feature enabled

David Cohen (1):
      usb: ffs: fix regression when quirk_ep_out_aligned_size flag is set

David Daney (1):
      MIPS: tlbex: Properly fix HUGE TLB Refill exception handler

David Dueck (1):
      can: at91_can: add missing prepare and unprepare of the clock

David Jander (2):
      can: flexcan: correctly initialize mailboxes
      can: flexcan: implement workaround for errata ERR005829

David Rientjes (1):
      mm, thp: fix collapsing of hugepages on madvise

Dexuan Cui (1):
      x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE

Dirk Brandewie (4):
      cpufreq: expose scaling_cur_freq sysfs file for set_policy() drivers
      intel_pstate: Don't lose sysfs settings during cpu offline
      intel_pstate: Fix BYT frequency reporting
      intel_pstate: Correct BYT VID values.

Dmitry Eremin-Solenikov (1):
      mtd: cfi_cmdset_0001.c: fix resume for LH28F640BF chips

Dmitry Kasatkin (2):
      ima: check xattr value length and type in the ima_inode_setxattr()
      evm: check xattr value length and type in evm_inode_setxattr()

Dmitry Monakhov (4):
      ext4: grab missed write_count for EXT4_IOC_SWAP_BOOT
      ext4: Replace open coded mdata csum feature to helper function
      ext4: move error report out of atomic context in ext4_init_block_bitmap()
      ext4: prevent bugon on race between write/fcntl

Emmanuel Grumbach (3):
      iwlwifi: configure the LTR
      iwlwifi: dvm: drop non VO frames when flushing
      Revert "iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate"

Eric Dumazet (2):
      tcp: md5: do not use alloc_percpu()
      macvlan: fix a race on port dismantle and possible skb leaks

Eric Rannaud (1):
      fs: allow open(dir, O_TMPFILE|..., 0) with mode 0

Eric Sandeen (1):
      ext4: fix reservation overflow in ext4_da_write_begin

Eric W. Biederman (2):
      NFS: Fix /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes
      mnt: Prevent pivot_root from creating a loop in the mount tree

Ezequiel Garcia (1):
      drm/tilcdc: Fix the error path in tilcdc_load()

Fabian Frederick (1):
      nfs: fix duplicate proc entries

Fabio Estevam (1):
      iio: adc: mxs-lradc: Disable the clock on probe failure

Felipe Balbi (3):
      usb: dwc3: gadget: fix set_halt() bug with pending transfers
      usb: gadget: function: acm: make f_acm pass USB20CV Chapter9
      usb: gadget: udc: core: fix kernel oops with soft-connect

Frans Klaver (1):
      usb: serial: ftdi_sio: add Awinda Station and Dongle products

Gabriele Mazzotta (1):
      cpufreq: intel_pstate: Reflect current no_turbo state correctly

Geert Uytterhoeven (1):
      PM / clk: Fix crash in clocks management code if !CONFIG_PM_RUNTIME

Greg Kroah-Hartman (1):
      PCI: Rename sysfs 'enabled' file back to 'enable'

Haiyang Zhang (1):
      hyperv: Fix the total_data_buflen in send path

Hans de Goede (1):
      Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544

Ian Abbott (2):
      staging: comedi: (regression) channel list must be set for COMEDI_CMD ioctl
      staging: comedi: fix memory leak / bad pointer freeing for chanlist

Ian Morgan (1):
      ax88179_178a: fix bonding failure

Imre Deak (2):
      PM / Sleep: fix async suspend_late/freeze_late error handling
      PM / Sleep: fix recovery during resuming from hibernation

J. Bruce Fields (2):
      nfsd4: fix response size estimation for OP_SEQUENCE
      nfsd4: fix crash on unknown operation number

Jack Pham (1):
      usb: dwc3: gadget: Properly initialize LINK TRB

Jan Kara (11):
      ext4: don't check quota format when there are no quota files
      vfs: fix data corruption when blocksize < pagesize for mmaped data
      ext4: fix mmap data corruption when blocksize < pagesize
      ext3: Don't check quota format when there are no quota files
      quota: Properly return errors from dquot_writeback_dquots()
      scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
      lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()
      ext4: fix overflow when updating superblock backups after resize
      ext4: fix oops when loading block bitmap failed
      ext4: bail out from make_indexed_dir() on first error
      mm: Remove false WARN_ON from pagecache_isize_extended()

Jason Baron (4):
      i3200_edac: Report CE events properly
      i82860_edac: Report CE events properly
      cpc925_edac: Report UE events properly
      e7xxx_edac: Report CE events properly

Jiri Pirko (1):
      ipv4: fix nexthop attlen check in fib_nh_match

Joern Engel (1):
      qla_target: don't delete changed nacls

Johannes Weiner (1):
      mm: page_alloc: fix zone allocation fairness on UP

Josh Triplett (1):
      init/Kconfig: Hide printk log config if CONFIG_PRINTK=n

Karl Beldan (2):
      net: tso: fix unaligned access to crafted TCP header in helper API
      mac80211: fix typo in starting baserate for rts_cts_rate_idx

Lars-Peter Clausen (3):
      staging:iio:ad5933: Fix NULL pointer deref when enabling buffer
      staging:iio:ad5933: Drop "raw" from channel names
      ASoC: adau1761: Fix input PGA volume

Li RongQing (4):
      vxlan: fix a use after free in vxlan_encap_bypass
      vxlan: using pskb_may_pull as early as possible
      vxlan: fix a free after use
      ipv4: fix a potential use after free in ip_tunnel_core.c

Liam Girdwood (1):
      ASoC: Intel: HSW/BDW only support S16 and S24 formats.

Lv Zheng (1):
      ACPI / EC: Fix regression due to conflicting firmware behavior between Samsung and Acer.

Marc Kleine-Budde (2):
      can: flexcan: mark TX mailbox as TX_INACTIVE
      can: flexcan: put TX mailbox into TX_INACTIVE mode after tx-complete

Marc-André Lureau (1):
      qxl: don't create too large primary surface

Markos Chandras (2):
      MIPS: cp1emu: Fix ISA restrictions for cop1x_op instructions
      MIPS: ftrace: Fix a microMIPS build problem

Mathias Krause (1):
      posix-timers: Fix stack info leak in timer_create()

Michael S. Tsirkin (1):
      kvm: x86: don't kill guest on unknown exit reason

Michal Hocko (1):
      OOM, PM: OOM killed task shouldn't escape PM suspend

Michal Marek (1):
      builddeb: put the dbg files into the correct directory

Michel Dänzer (1):
      drm/radeon: Use drm_malloc_ab instead of kmalloc_array

Miklos Szeredi (1):
      fuse: honour max_read and max_write in direct_io mode

Nadav Amit (5):
      KVM: x86: Check non-canonical addresses upon WRMSR
      KVM: x86: Fix wrong masking on relative jump/call
      KVM: x86: Emulator fixes for eip canonical checks on near branches
      KVM: x86: Handle errors when RIP is set during far jumps
      KVM: x86: Fix far-jump to non-canonical check

Nathaniel Ting (1):
      USB: serial: cp210x: add Silicon Labs 358x VID and PID

Nicholas Bellinger (2):
      target: Fix APTPL metadata handling for dynamic MappedLUNs
      iser-target: Disable TX completion interrupt coalescing

Nicolas Cavallari (1):
      ipv4: Do not cache routing failures due to disabled forwarding.

Olaf Hering (1):
      drm/cirrus: bind also to qemu-xen-traditional

Or Gerlitz (1):
      net/mlx4_en: Don't attempt to TX offload the outer UDP checksum for VXLAN

Pali Rohár (1):
      cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy

Perry Hung (1):
      usb: serial: ftdi_sio: add "bricked" FTDI device PID

Petr Matousek (1):
      kvm: vmx: handle invvpid vm exit gracefully

Quentin Casasnovas (1):
      kvm: fix excessive pages un-pinning in kvm_iommu_map error path.

Quinn Tran (1):
      target: Fix queue full status NULL pointer for SCF_TRANSPORT_TASK_SENSE

Rabin Vincent (1):
      tracing/syscalls: Ignore numbers outside NR_syscalls' range

Rafał Miłecki (2):
      mtd: move support for struct flash_platform_data into m25p80
      mtd: m25p80: get rid of spi_get_device_id

Ray Jui (1):
      spi: pl022: Fix incorrect dma_unmap_sg

Robert Baldyga (1):
      usb: gadget: f_fs: remove redundant ffs_data_get()

Robin van der Gracht (1):
      iio: st_sensors: Fix buffer copy

Roger Quadros (1):
      Revert "usb: dwc3: dwc3-omap: Disable/Enable only wrapper interrupts in prepare/complete"

Sebastian Andrzej Siewior (1):
      usb: musb: dsps: start OTG timer on resume again

Takashi Iwai (1):
      ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat mode

Theodore Ts'o (3):
      ext4: don't orphan or truncate the boot loader inode
      ext4: add ext4_iget_normal() which is to be used for dir tree lookups
      ext4: convert do_split() to use the ERR_PTR convention

Thomas Gleixner (1):
      usb: musb: cppi41: restart hrtimer only if not yet done

Tom Herbert (1):
      gre: Use inner mac length when computing tunnel length

Torsten Fleischer (1):
      usb: chipidea: Fix oops when removing the ci_hdrc module

Valdis Kletnieks (1):
      pstore: Fix duplicate {console,ftrace}-efi entries

Vasily Averin (1):
      ipv4: dst_entry leak in ip_send_unicast_reply()

Ville Syrjälä (1):
      drm/i915: Do a dummy DPCD read before the actual read

Vineet Gupta (2):
      ARC: [nsimosci] Allow "headless" models to boot
      ARC: unbork FPU save/restore

Wang Nan (1):
      cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.

Will Deacon (1):
      zap_pte_range: update addr when forcing flush after TLB batching faiure

Xose Vazquez Perez (1):
      wireless: rt2x00: add new rt2800usb devices

Yu Zhao (1):
      mm: free compound page with correct order

jens stein (1):
      drm/i915: Ignore VBT backlight check on Macbook 2, 1
