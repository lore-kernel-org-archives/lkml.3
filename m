Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaKKSUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:20:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59922 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaKKSUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:20:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.13.y.z extended stable] Linux 3.13.11.11
Date: Tue, 11 Nov 2014 10:20:40 -0800
Message-Id: <1415730041-23804-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.13.11.11 kernel.

The updated 3.13.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.13.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.13.y;a=shortlog

The diff from v3.13.11.10 is posted as a follow-up to this email.

 *** Note:  Starting with the next release after this, the version
 *** number scheme for this extended stable series will be changed to
 *** "3.13.11-ckt{N}" (-ckt indicates that the series is maintained by
 *** the Canonical Kernel Team).  The next release will be version
 *** "3.13.11-ckt12".

For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                                           |   2 +-
 arch/arc/boot/dts/nsimosci.dts                     |   2 +-
 arch/arc/include/asm/kgdb.h                        |  32 +-
 arch/arm64/include/asm/compat.h                    |   4 +-
 arch/mips/include/asm/ftrace.h                     |   4 +-
 arch/mips/mm/tlbex.c                               |   6 +-
 arch/sparc/Kconfig                                 |   1 +
 arch/sparc/include/asm/hypervisor.h                |  11 +
 arch/sparc/include/asm/irq_64.h                    |   9 +-
 arch/sparc/include/asm/ldc.h                       |   5 +-
 arch/sparc/include/asm/oplib_64.h                  |   3 +-
 arch/sparc/include/asm/page_64.h                   |  33 +-
 arch/sparc/include/asm/pgalloc_64.h                |  28 +-
 arch/sparc/include/asm/pgtable_64.h                | 100 ++--
 arch/sparc/include/asm/setup.h                     |   4 +
 arch/sparc/include/asm/spitfire.h                  |   2 +
 arch/sparc/include/asm/thread_info_64.h            |   4 +-
 arch/sparc/include/asm/tsb.h                       |  87 +++-
 arch/sparc/include/asm/visasm.h                    |   8 +
 arch/sparc/kernel/cpu.c                            |  12 +
 arch/sparc/kernel/cpumap.c                         |   2 +
 arch/sparc/kernel/ds.c                             |   4 +-
 arch/sparc/kernel/dtlb_prot.S                      |   6 +-
 arch/sparc/kernel/entry.h                          |   3 -
 arch/sparc/kernel/head_64.S                        |  52 +-
 arch/sparc/kernel/hvapi.c                          |   1 +
 arch/sparc/kernel/hvcalls.S                        |  16 +
 arch/sparc/kernel/hvtramp.S                        |   1 -
 arch/sparc/kernel/ioport.c                         |   5 +-
 arch/sparc/kernel/irq_64.c                         | 507 ++++++++++++-------
 arch/sparc/kernel/ktlb.S                           | 125 +----
 arch/sparc/kernel/ldc.c                            |  41 +-
 arch/sparc/kernel/nmi.c                            |   1 -
 arch/sparc/kernel/pcr.c                            |  47 +-
 arch/sparc/kernel/perf_event.c                     |  10 +-
 arch/sparc/kernel/process_64.c                     |   3 +
 arch/sparc/kernel/setup_64.c                       |  36 +-
 arch/sparc/kernel/smp_64.c                         |   8 +-
 arch/sparc/kernel/sun4v_tlb_miss.S                 |  35 +-
 arch/sparc/kernel/trampoline_64.S                  |  12 +-
 arch/sparc/kernel/traps_64.c                       |  15 +-
 arch/sparc/kernel/tsb.S                            |   6 +-
 arch/sparc/kernel/viohs.c                          |   4 +-
 arch/sparc/kernel/vmlinux.lds.S                    |  10 +-
 arch/sparc/lib/NG4memcpy.S                         |  14 +-
 arch/sparc/lib/memset.S                            |  18 +-
 arch/sparc/mm/fault_64.c                           |   3 +
 arch/sparc/mm/gup.c                                |  30 ++
 arch/sparc/mm/init_64.c                            | 554 +++++++++++----------
 arch/sparc/mm/init_64.h                            |  18 -
 arch/sparc/power/hibernate_asm.S                   |   4 +-
 arch/sparc/prom/bootstr_64.c                       |   5 +-
 arch/sparc/prom/cif.S                              |   5 +-
 arch/sparc/prom/init_64.c                          |   6 +-
 arch/sparc/prom/p1275.c                            |   9 +-
 arch/x86/ia32/ia32entry.S                          |   2 +-
 arch/x86/include/asm/kvm_host.h                    |  16 +-
 arch/x86/include/uapi/asm/vmx.h                    |   2 +
 arch/x86/kernel/apic/apic.c                        |   4 +-
 arch/x86/kernel/tsc.c                              |   5 +-
 arch/x86/kvm/emulate.c                             | 250 +++++++---
 arch/x86/kvm/i8254.c                               |   2 +
 arch/x86/kvm/svm.c                                 |   8 +-
 arch/x86/kvm/vmx.c                                 |  24 +-
 arch/x86/kvm/x86.c                                 |  38 +-
 arch/x86/mm/pageattr.c                             |   2 +-
 block/scsi_ioctl.c                                 |   3 +-
 drivers/acpi/ec.c                                  |  28 +-
 drivers/char/random.c                              |  10 +-
 drivers/cpufreq/cpufreq.c                          |  23 +-
 drivers/cpufreq/intel_pstate.c                     | 112 ++++-
 drivers/edac/cpc925_edac.c                         |   2 +-
 drivers/edac/e7xxx_edac.c                          |   2 +-
 drivers/edac/i3200_edac.c                          |   4 +-
 drivers/edac/i82860_edac.c                         |   2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c                |   2 +
 drivers/gpu/drm/qxl/qxl_display.c                  |  16 +-
 drivers/gpu/drm/radeon/cik_sdma.c                  |  21 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                 |   6 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |   6 +-
 drivers/gpu/drm/radeon/kv_dpm.c                    |  19 +-
 drivers/gpu/drm/radeon/r600_dma.c                  |  21 +-
 drivers/gpu/drm/radeon/radeon.h                    |   2 +
 drivers/gpu/drm/radeon/si_dpm.c                    |   2 +-
 drivers/iio/common/st_sensors/st_sensors_buffer.c  |   2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   4 +-
 drivers/input/serio/i8042-x86ia64io.h              |  16 +
 drivers/net/bonding/bond_main.c                    |  17 +-
 drivers/net/ethernet/broadcom/tg3.c                |  23 +-
 drivers/net/ethernet/cadence/macb.c                |  11 -
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |  88 ++--
 drivers/net/hyperv/netvsc_drv.c                    |   3 +-
 drivers/net/macvlan.c                              |   1 +
 drivers/net/macvtap.c                              |  18 +-
 drivers/net/team/team.c                            |   4 +-
 drivers/net/vxlan.c                                |   8 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |   3 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   3 +-
 drivers/net/wireless/ath/ath9k/main.c              |   3 +-
 drivers/net/wireless/ath/carl9170/main.c           |   4 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   3 +-
 drivers/net/wireless/cw1200/sta.c                  |   3 +-
 drivers/net/wireless/cw1200/sta.h                  |   3 +-
 drivers/net/wireless/iwlegacy/common.c             |   3 +-
 drivers/net/wireless/iwlegacy/common.h             |   3 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  27 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h           |   2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h    |  35 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h          |   1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c              |   9 +
 drivers/net/wireless/iwlwifi/mvm/ops.c             |   1 +
 drivers/net/wireless/iwlwifi/mvm/tx.c              |   8 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  16 +-
 drivers/net/wireless/mac80211_hwsim.c              |   4 +-
 drivers/net/wireless/p54/main.c                    |   3 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |   1 +
 drivers/net/wireless/rt2x00/rt2x00.h               |   3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   3 +-
 drivers/net/wireless/rtlwifi/core.c                |   3 +-
 drivers/net/wireless/ti/wlcore/main.c              |   3 +-
 drivers/pci/pci-sysfs.c                            |   8 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |  11 +-
 drivers/spi/spi-pl022.c                            |   2 +-
 drivers/staging/iio/adc/mxs-lradc.c                |  12 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |  15 +-
 drivers/target/target_core_device.c                |   3 +-
 drivers/target/target_core_pr.c                    |   6 +-
 drivers/target/target_core_pr.h                    |   2 +-
 drivers/target/target_core_tpg.c                   |   8 +
 drivers/target/target_core_transport.c             |   3 +-
 drivers/usb/dwc3/ep0.c                             |   4 +-
 drivers/usb/dwc3/gadget.c                          |  17 +-
 drivers/usb/dwc3/gadget.h                          |   2 +-
 drivers/usb/gadget/f_acm.c                         |   7 +-
 drivers/usb/gadget/udc-core.c                      |   5 +
 drivers/usb/musb/musb_cppi41.c                     |   3 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  12 +-
 drivers/usb/serial/option.c                        |  10 +
 fs/buffer.c                                        |   3 +
 fs/ext3/super.c                                    |   7 -
 fs/ext4/balloc.c                                   |  13 +-
 fs/ext4/bitmap.c                                   |  12 +-
 fs/ext4/ext4.h                                     |  17 +-
 fs/ext4/extents.c                                  |   6 +-
 fs/ext4/ialloc.c                                   |   7 +-
 fs/ext4/inline.c                                   |   3 +-
 fs/ext4/inode.c                                    |  46 +-
 fs/ext4/ioctl.c                                    |  13 +-
 fs/ext4/mmp.c                                      |   6 +-
 fs/ext4/namei.c                                    |  73 ++-
 fs/ext4/resize.c                                   |   5 +-
 fs/ext4/super.c                                    |  32 +-
 fs/ext4/xattr.c                                    |  38 +-
 fs/jbd2/recovery.c                                 |   1 +
 fs/namei.c                                         |   3 +-
 fs/nfsd/nfs4proc.c                                 |   3 +-
 fs/quota/dquot.c                                   |   2 +-
 include/drm/drm_pciids.h                           |   1 -
 include/linux/compiler-gcc.h                       |   3 +
 include/linux/compiler-intel.h                     |   7 +
 include/linux/compiler.h                           |   4 +
 include/linux/khugepaged.h                         |  17 +-
 include/linux/mm.h                                 |   1 +
 include/linux/oom.h                                |   3 +
 include/linux/string.h                             |   5 +-
 include/net/dst.h                                  |  16 +-
 include/net/inet_connection_sock.h                 |   1 +
 include/net/mac80211.h                             |   4 +-
 include/net/sctp/command.h                         |   2 +-
 include/net/sctp/sctp.h                            |   5 +
 include/net/sctp/sm.h                              |   6 +-
 include/net/sock.h                                 |   1 -
 include/net/tcp.h                                  |   5 +-
 kernel/freezer.c                                   |   3 +
 kernel/futex.c                                     |  22 +-
 kernel/posix-timers.c                              |   1 +
 kernel/power/hibernate.c                           |   8 +-
 kernel/power/process.c                             |  40 +-
 kernel/trace/trace_syscalls.c                      |   8 +-
 lib/bitmap.c                                       |   8 +-
 lib/string.c                                       |  16 +
 mm/huge_memory.c                                   |  15 +-
 mm/mmap.c                                          |   8 +-
 mm/oom_kill.c                                      |  17 +
 mm/page_alloc.c                                    |   8 +
 mm/page_cgroup.c                                   |   1 +
 mm/truncate.c                                      |  57 +++
 net/bridge/br_private.h                            |   3 +
 net/bridge/br_vlan.c                               |  13 +-
 net/core/rtnetlink.c                               |   3 +-
 net/core/skbuff.c                                  |   3 +
 net/ipv4/route.c                                   |   6 +-
 net/ipv4/tcp.c                                     |  14 +-
 net/ipv4/tcp_input.c                               |   8 +-
 net/ipv4/tcp_ipv4.c                                |   5 +-
 net/ipv4/tcp_output.c                              |  11 +-
 net/ipv6/ip6_gre.c                                 |   4 +-
 net/ipv6/ip6_output.c                              |   4 +-
 net/ipv6/sit.c                                     |   6 +-
 net/ipv6/tcp_ipv6.c                                |   3 +-
 net/l2tp/l2tp_ppp.c                                |   3 +-
 net/mac80211/driver-ops.h                          |   8 +-
 net/mac80211/rate.c                                |   2 +-
 net/mac80211/util.c                                |   2 +-
 net/netlink/af_netlink.c                           |   2 +-
 net/openvswitch/actions.c                          |   5 +
 net/packet/af_packet.c                             |  17 +
 net/packet/internal.h                              |   1 +
 net/sctp/associola.c                               |   2 +
 net/sctp/inqueue.c                                 |  33 +-
 net/sctp/sm_make_chunk.c                           |  99 ++--
 net/sctp/sm_statefuns.c                            |  40 +-
 net/xfrm/xfrm_policy.c                             |  48 +-
 security/integrity/evm/evm_main.c                  |   9 +-
 security/integrity/ima/ima_appraise.c              |   3 +
 security/integrity/integrity.h                     |   1 +
 sound/core/pcm_compat.c                            |   2 +
 sound/core/pcm_native.c                            |   2 +-
 sound/pci/hda/patch_hdmi.c                         |  15 +-
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/usb/quirks-table.h                           |  30 ++
 virt/kvm/iommu.c                                   |   8 +-
 224 files changed, 2621 insertions(+), 1463 deletions(-)

Alex Deucher (5):
      drm/radeon: fix speaker allocation setup
      drm/radeon: use gart memory for DMA ring tests
      drm/radeon/dpm: disable ulv support on SI
      drm/radeon: dpm fixes for asrock systems
      drm/radeon: remove invalid pci id

Allen Pais (3):
      sparc64: correctly recognise M6 and M7 cpu type
      sparc64: support M6 and M7 for building CPU distribution map
      sparc64: cpu hardware caps support for sparc M6 and M7

Anatol Pomozov (1):
      ALSA: pcm: use the same dma mmap codepath both for arm and arm64

Andreas Larsson (1):
      sparc: Let memset return the address argument

Andrey Vagin (1):
      tcp: don't use timestamp from repaired skb-s to calculate RTT (v2)

Andy Honig (2):
      KVM: x86: Prevent host from panicking on shared MSR writes.
      KVM: x86: Improve thread safety in pit

Andy Lutomirski (2):
      x86, apic: Handle a bad TSC more gracefully
      x86_64, entry: Fix out of bounds read on sysenter

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix missing ELD change event on plug/unplug

Anton Kolesov (1):
      ARC: Update order of registers in KGDB to match GDB 7.5

Brian Silverman (1):
      futex: Fix a race condition between REQUEUE_PI and task death

Cesar Eduardo Barros (1):
      compiler: define OPTIMIZER_HIDE_VAR() macro

Cong Wang (1):
      freezer: Do not freeze tasks killed by OOM killer

Cyril Brulebois (1):
      wireless: rt2x00: add new rt2800usb device

Dan Williams (1):
      USB: option: add Haier CE81B CDMA modem

Daniel Borkmann (5):
      netlink: reset network header before passing to taps
      random: add and use memzero_explicit() for clearing data
      net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks
      net: sctp: fix panic on duplicate ASCONF chunks
      net: sctp: fix remote memory pressure from excessive queueing

Daniel Hellstrom (1):
      sparc32: dma_alloc_coherent must honour gfp flags

Daniele Palmas (1):
      usb: option: add support for Telit LE910

Darrick J. Wong (4):
      ext4: check EA value offset when loading
      jbd2: free bh when descriptor block checksum fails
      ext4: check s_chksum_driver when looking for bg csum presence
      ext4: enable journal checksum when metadata checksum feature enabled

Dave Kleikamp (1):
      sparc64: Increase size of boot string to 1024 bytes

David Daney (1):
      MIPS: tlbex: Properly fix HUGE TLB Refill exception handler

David Rientjes (1):
      mm, thp: fix collapsing of hugepages on madvise

David S. Miller (18):
      sparc64: Do not disable interrupts in nmi_cpu_busy()
      sparc64: Fix pcr_ops initialization and usage bugs.
      sparc64: Fix corrupted thread fault code.
      sparc64: Fix reversed start/end in flush_tlb_kernel_range()
      sparc64: Fix lockdep warnings on reboot on Ultra-5
      sparc64: Fix FPU register corruption with AES crypto offload.
      sparc64: Do not define thread fpregs save area as zero-length array.
      sparc64: Fix hibernation code refrence to PAGE_OFFSET.
      sparc64: Switch to 4-level page tables.
      sparc64: Define VA hole at run time, rather than at compile time.
      sparc64: Adjust KTSB assembler to support larger physical addresses.
      sparc64: Fix physical memory management regressions with large max_phys_bits.
      sparc64: Use kernel page tables for vmemmap.
      sparc64: Increase MAX_PHYS_ADDRESS_BITS to 53.
      sparc64: Adjust vmalloc region size based upon available virtual address bits.
      sparc64: Kill unnecessary tables and increase MAX_BANKS.
      sparc64: Fix register corruption in top-most kernel stack frame during boot.
      sparc64: Implement __get_user_pages_fast().

Dexuan Cui (1):
      x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE

Dirk Brandewie (4):
      cpufreq: expose scaling_cur_freq sysfs file for set_policy() drivers
      intel_pstate: Don't lose sysfs settings during cpu offline
      intel_pstate: Fix BYT frequency reporting
      intel_pstate: Correct BYT VID values.

Dmitry Kasatkin (2):
      ima: check xattr value length and type in the ima_inode_setxattr()
      evm: check xattr value length and type in evm_inode_setxattr()

Dmitry Monakhov (3):
      ext4: grab missed write_count for EXT4_IOC_SWAP_BOOT
      ext4: Replace open coded mdata csum feature to helper function
      ext4: move error report out of atomic context in ext4_init_block_bitmap()

Emmanuel Grumbach (4):
      iwlwifi: configure the LTR
      mac80211: add vif to flush call
      iwlwifi: dvm: drop non VO frames when flushing
      Revert "iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate"

Eric Dumazet (2):
      packet: handle too big packets for PACKET_V3
      gro: fix aggregation for skb using frag_list

Eric Rannaud (1):
      fs: allow open(dir, O_TMPFILE|..., 0) with mode 0

Eric Sandeen (1):
      ext4: fix reservation overflow in ext4_da_write_begin

Fabio Estevam (2):
      iio: mxs-lradc: Propagate the real error code on platform_get_irq() failure
      iio: adc: mxs-lradc: Disable the clock on probe failure

Felipe Balbi (3):
      usb: dwc3: gadget: fix set_halt() bug with pending transfers
      usb: gadget: function: acm: make f_acm pass USB20CV Chapter9
      usb: gadget: udc: core: fix kernel oops with soft-connect

Francesco Ruggeri (1):
      net: allow macvlans to move to net namespace

Frans Klaver (1):
      usb: serial: ftdi_sio: add Awinda Station and Dongle products

Gabriele Mazzotta (1):
      cpufreq: intel_pstate: Reflect current no_turbo state correctly

Gerhard Stenzel (1):
      vxlan: fix incorrect initializer in union vxlan_addr

Greg Kroah-Hartman (1):
      PCI: Rename sysfs 'enabled' file back to 'enable'

Guillaume Nault (1):
      l2tp: fix race while getting PMTU on PPP pseudo-wire

Hans de Goede (1):
      Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544

Harsha Priya (1):
      ALSA: ALC283 codec - Avoid pop noise on headphones during suspend/resume

Imre Deak (1):
      PM / Sleep: fix recovery during resuming from hibernation

J. Bruce Fields (1):
      nfsd4: fix crash on unknown operation number

Jack Pham (1):
      usb: dwc3: gadget: Properly initialize LINK TRB

Jan Kara (10):
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

Jason Baron (4):
      i3200_edac: Report CE events properly
      i82860_edac: Report CE events properly
      cpc925_edac: Report UE events properly
      e7xxx_edac: Report CE events properly

Jiri Benc (2):
      rtnetlink: fix VF info size
      openvswitch: fix panic with multiple vlan headers

Joe Lawrence (1):
      team: avoid race condition in scheduling delayed work

Joern Engel (1):
      qla_target: don't delete changed nacls

KY Srinivasan (1):
      hyperv: Fix a bug in netvsc_start_xmit()

Kamal Mostafa (1):
      Linux 3.13.11.11

Karl Beldan (1):
      mac80211: fix typo in starting baserate for rts_cts_rate_idx

Lars-Peter Clausen (2):
      staging:iio:ad5933: Fix NULL pointer deref when enabling buffer
      staging:iio:ad5933: Drop "raw" from channel names

Lv Zheng (2):
      ACPI / EC: Add support to disallow QR_EC to be issued when SCI_EVT isn't set
      ACPI / EC: Fix regression due to conflicting firmware behavior between Samsung and Acer.

Marc-André Lureau (1):
      qxl: don't create too large primary surface

Markos Chandras (1):
      MIPS: ftrace: Fix a microMIPS build problem

Mathias Krause (1):
      posix-timers: Fix stack info leak in timer_create()

Michael S. Tsirkin (1):
      kvm: x86: don't kill guest on unknown exit reason

Michal Hocko (1):
      OOM, PM: OOM killed task shouldn't escape PM suspend

Nadav Amit (5):
      KVM: x86: Check non-canonical addresses upon WRMSR
      KVM: x86: Fix wrong masking on relative jump/call
      KVM: x86: Emulator fixes for eip canonical checks on near branches
      KVM: x86: Handle errors when RIP is set during far jumps
      KVM: x86: Fix far-jump to non-canonical check

Nathaniel Ting (1):
      USB: serial: cp210x: add Silicon Labs 358x VID and PID

Neal Cardwell (2):
      tcp: fix tcp_release_cb() to dispatch via address family for mtu_reduced()
      tcp: fix ssthresh and undo for consecutive short FRTO episodes

Nicholas Bellinger (2):
      target: Fix APTPL metadata handling for dynamic MappedLUNs
      iser-target: Disable TX completion interrupt coalescing

Nicolas Dichtel (1):
      ip6_gre: fix flowi6_proto value in xmit path

Nikolay Aleksandrov (1):
      bonding: fix div by zero while enslaving and transmitting

Olaf Hering (1):
      drm/cirrus: bind also to qemu-xen-traditional

Pali Rohár (1):
      cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy

Paolo Bonzini (1):
      KVM: x86: use new CS.RPL as CPL during task switch

Per Hurtig (1):
      tcp: fixing TLP's FIN recovery

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

Ray Jui (1):
      spi: pl022: Fix incorrect dma_unmap_sg

Robin van der Gracht (1):
      iio: st_sensors: Fix buffer copy

Shmulik Ladkani (1):
      sit: Fix ipip6_tunnel_lookup device matching criteria

Soren Brinkmann (1):
      Revert "net/macb: add pinctrl consumer support"

Sowmini Varadhan (1):
      sparc64: Move request_irq() from ldc_bind() to ldc_alloc()

Stanislaw Gruszka (1):
      myri10ge: check for DMA mapping errors

Steffen Klassert (2):
      xfrm: Generate blackhole routes only from route lookup functions
      xfrm: Generate queueing routes only from route lookup functions

Takashi Iwai (1):
      ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat mode

Theodore Ts'o (2):
      ext4: don't orphan or truncate the boot loader inode
      ext4: add ext4_iget_normal() which is to be used for dir tree lookups

Thomas Gleixner (1):
      usb: musb: cppi41: restart hrtimer only if not yet done

Victor Kamensky (1):
      arm64: compat: fix compat types affecting struct compat_elf_prpsinfo

Vineet Gupta (1):
      ARC: [nsimosci] Allow "headless" models to boot

Vlad Catoi (1):
      ALSA: usb-audio: Add support for Steinberg UR22 USB interface

Vlad Yasevich (6):
      bridge: Check if vlan filtering is enabled only once.
      bridge: Fix br_should_learn to check vlan_enabled
      tg3: Work around HW/FW limitations with vlan encapsulated frames
      tg3: Allow for recieve of full-size 8021AD frames
      macvtap: Fix race between device delete and open.
      sctp: handle association restarts when the socket is closed.

Wang Nan (1):
      cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.

Yu Zhao (1):
      mm: free compound page with correct order

bob picco (4):
      sparc64: sun4v TLB error power off events
      sparc64: find_node adjustment
      sparc64: T5 PMU
      sparc64: sparse irq

