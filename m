Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbaGXJqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:46:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54523 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaGXJq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.11.y.z extended stable] Linux 3.11.10.14 stable review
Date: Thu, 24 Jul 2014 10:44:09 +0100
Message-Id: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.11.10.14 stable kernel.

This version contains 128 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.11.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.11.y-review

The review period for version 3.11.10.14 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.11.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 Documentation/sysctl/vm.txt                  |   3 +-
 arch/arc/include/uapi/asm/ptrace.h           |   1 +
 arch/arc/kernel/ptrace.c                     |   4 +
 arch/arm/mach-omap2/mux.c                    |   6 +-
 arch/arm64/include/asm/memory.h              |   2 +
 arch/arm64/mm/flush.c                        |   3 +-
 arch/mips/kernel/irq-msc01.c                 |   2 +-
 arch/mips/kvm/kvm_mips.c                     |  13 +-
 arch/powerpc/include/asm/perf_event_server.h |   3 +-
 arch/powerpc/kernel/time.c                   |   2 +-
 arch/powerpc/lib/sstep.c                     |   2 +-
 arch/powerpc/perf/core-book3s.c              |  24 ++-
 arch/powerpc/perf/power8-pmu.c               |   2 +-
 arch/score/Kconfig                           |   3 +
 arch/score/Makefile                          |   4 +-
 arch/score/include/asm/checksum.h            |  93 ++++++------
 arch/score/include/asm/io.h                  |   1 -
 arch/score/include/asm/pgalloc.h             |   2 +-
 arch/score/kernel/entry.S                    |   4 +-
 arch/score/kernel/process.c                  |   4 +-
 arch/x86/crypto/sha512_ssse3_glue.c          |   2 +-
 arch/x86/include/asm/kvm_host.h              |   4 +-
 arch/x86/include/asm/ptrace.h                |  16 ++
 arch/x86/mm/ioremap.c                        |  26 +++-
 block/blk-cgroup.c                           |   7 +-
 block/blk-cgroup.h                           |  17 +--
 drivers/acpi/battery.c                       |  27 +++-
 drivers/acpi/ec.c                            | 128 ++++++++--------
 drivers/block/rbd.c                          |  19 ++-
 drivers/clk/spear/spear3xx_clock.c           |   2 +-
 drivers/cpufreq/Makefile                     |   2 +-
 drivers/cpufreq/intel_pstate.c               |   2 +-
 drivers/firmware/efi/efi-pstore.c            |   2 +-
 drivers/gpu/drm/drm_drv.c                    |   3 +-
 drivers/gpu/drm/radeon/cikd.h                |   2 +-
 drivers/gpu/drm/radeon/cypress_dpm.c         |   2 +-
 drivers/gpu/drm/radeon/evergreen.c           |   8 +-
 drivers/gpu/drm/radeon/ni_dpm.c              |   2 +-
 drivers/gpu/drm/radeon/rv770_dpm.c           |   6 -
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c           |   1 -
 drivers/hv/connection.c                      |   8 +-
 drivers/hwmon/adm1021.c                      |  14 +-
 drivers/hwmon/adm1029.c                      |   3 +
 drivers/hwmon/adm1031.c                      |   8 +-
 drivers/hwmon/amc6821.c                      |   2 +-
 drivers/hwmon/emc2103.c                      |  25 ++--
 drivers/iio/adc/ti_am335x_adc.c              |   2 +-
 drivers/iio/inkern.c                         |   6 +-
 drivers/irqchip/spear-shirq.c                |   2 +-
 drivers/md/dm-io.c                           |  22 +--
 drivers/md/md.c                              |  13 ++
 drivers/misc/mei/hw-me.c                     |  14 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c  |   1 +
 drivers/net/wireless/b43/xmit.c              |  10 +-
 drivers/net/wireless/rt2x00/rt2500pci.c      |   7 +-
 drivers/net/wireless/rt2x00/rt2x00.h         |   1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c      |  24 ++-
 drivers/net/wireless/rt2x00/rt2x00mac.c      |   2 +
 drivers/pci/pci.c                            |   2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c             |  13 +-
 drivers/scsi/scsi_error.c                    |   9 ++
 drivers/scsi/sym53c8xx_2/sym_hipd.c          |   4 +
 drivers/scsi/virtio_scsi.c                   |  26 +++-
 drivers/target/iscsi/iscsi_target.c          |   2 +-
 drivers/target/iscsi/iscsi_target_util.c     |   2 +
 drivers/target/target_core_device.c          |   1 +
 drivers/thermal/thermal_core.c               |  33 +++--
 drivers/usb/chipidea/udc.c                   |   7 +
 drivers/usb/gadget/f_fs.c                    |  12 +-
 drivers/usb/host/xhci-hub.c                  |   5 +-
 drivers/usb/host/xhci-ring.c                 |   2 +-
 drivers/usb/host/xhci.c                      |  10 +-
 drivers/usb/musb/ux500.c                     |   1 -
 drivers/usb/serial/cp210x.c                  |   1 +
 drivers/usb/serial/ftdi_sio.c                |  12 +-
 drivers/usb/serial/ftdi_sio_ids.h            |   9 +-
 drivers/usb/serial/option.c                  |  28 +++-
 fs/btrfs/backref.c                           |  32 ++--
 fs/btrfs/backref.h                           |   4 +-
 fs/btrfs/disk-io.c                           |   5 +
 fs/btrfs/extent_io.c                         |   4 +-
 fs/btrfs/free-space-cache.c                  |   4 +-
 fs/btrfs/scrub.c                             |   5 +-
 fs/btrfs/send.c                              |   4 +
 fs/btrfs/volumes.c                           |  44 ++++--
 fs/cifs/cifs_unicode.c                       |   7 +-
 fs/ext4/ialloc.c                             |  14 +-
 fs/ext4/indirect.c                           |  20 ++-
 fs/ext4/super.c                              |   9 +-
 fs/jbd2/transaction.c                        |   5 +-
 fs/nfsd/nfs4proc.c                           |   9 --
 fs/nfsd/nfs4xdr.c                            |  13 +-
 fs/proc/stat.c                               |  22 +--
 include/linux/ptrace.h                       |   3 +
 include/linux/ring_buffer.h                  |   2 +-
 include/trace/syscall.h                      |  15 ++
 kernel/cpuset.c                              |   8 +-
 kernel/fork.c                                |   2 +
 kernel/rtmutex.c                             | 210 +++++++++++++++++++++++----
 kernel/sysctl.c                              |   3 +-
 kernel/trace/ring_buffer.c                   |   5 +-
 kernel/trace/trace.c                         |  40 +++--
 kernel/trace/trace.h                         |   4 +-
 kernel/workqueue.c                           |   3 +-
 lib/lz4/lz4_decompress.c                     |  12 +-
 mm/hugetlb.c                                 |  70 +++++----
 mm/mempolicy.c                               |  48 +++---
 mm/page_alloc.c                              |  56 +++++--
 mm/vmscan.c                                  |  11 +-
 net/bluetooth/hci_conn.c                     |   2 +-
 net/bluetooth/hci_event.c                    |  11 +-
 net/bluetooth/l2cap_sock.c                   |   5 -
 net/bluetooth/mgmt.c                         |   7 +-
 net/mac80211/ibss.c                          |   1 +
 net/netfilter/ipvs/ip_vs_ctl.c               |   2 +-
 net/netfilter/nf_nat_core.c                  |  35 ++++-
 scripts/recordmcount.h                       |   4 +-
 sound/usb/card.c                             |  13 +-
 sound/usb/endpoint.c                         |  17 ++-
 sound/usb/endpoint.h                         |   1 +
 tools/usb/ffs-test.c                         |   4 +-
 121 files changed, 1081 insertions(+), 513 deletions(-)

Aaron Lu (1):
      thermal: hwmon: Make the check for critical temp valid consistent

Adam Thomson (1):
      iio: of_iio_channel_get_by_name() returns non-null pointers for error legs

Alex Deucher (4):
      drm/radeon/dpm: fix typo in vddci setup for eg/btc
      drm/radeon/dpm: fix vddci setup typo on cayman
      drm/radeon/cik: fix typo in EOP packet
      drm/radeon: fix typo in golden register setup on evergreen

Alex Elder (1):
      rbd: use reference counts for image requests

Alex Smith (1):
      recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in modules

Alexandre Demers (1):
      drm/radeon/dpm: Reenabling SS on Cayman

Andras Kovacs (1):
      USB: cp210x: add support for Corsair usb dongle

Andrzej Zaborowski (1):
      efi-pstore: Fix an overflow on 32-bit builds

Anton Blanchard (1):
      powerpc/perf: Never program book3s PMCs with values >= 0x80000000

Anton Kolesov (1):
      ARC: Implement ptrace(PTRACE_GET_THREAD_AREA)

Axel Lin (3):
      hwmon: (amc6821) Fix permissions for temp2_input
      hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div
      hwmon: (adm1021) Fix cache problem when writing temperature limits

Bernd Wachter (1):
      usb: option: Add ID for Telewell TW-LTE 4G v2

Bert Vermeulen (1):
      USB: ftdi_sio: Add extra PID.

Bjorn Helgaas (1):
      PCI: Fix incorrect vgaarb conditional in WARN_ON()

Bjørn Mork (1):
      usb: option: add/modify Olivetti Olicard modems

Brian King (2):
      ibmvscsi: Abort init sequence during error recovery
      ibmvscsi: Add memory barriers for send / receive

Colin Cross (1):
      arm64: implement TASK_SIZE_OF

David R. Piegdon (1):
      ARM: OMAP2+: Fix parser-bug in platform muxing code

David Rientjes (1):
      mm, pcp: allow restoring percpu_pagelist_fraction default

Deng-Cheng Zhu (1):
      MIPS: KVM: Fix memory leak on VCPU

Eric Sandeen (2):
      btrfs: fix use of uninit "ret" in end_extent_writepage()
      ext4: disable synchronous transaction batching if max_batch_time==0

Filipe Manana (1):
      Btrfs: send, don't error in the presence of subvols/snapshots

Florian Westphal (1):
      netfilter: nf_nat: fix oops on netns removal

Greg Kroah-Hartman (3):
      lz4: ensure length does not wrap
      lz4: fix another possible overrun
      lz4: add overrun checks to lz4_uncompress_unknownoutputsize()

Gu Zheng (1):
      cpuset,mempolicy: fix sleeping function called from invalid context

Guenter Roeck (2):
      hwmon: (adm1031) Fix writes to limit registers
      hwmon: (emc2103) Clamp limits instead of bailing out

Heiko Carstens (1):
      /proc/stat: convert to single_open_size()

Hugh Dickins (1):
      mm: fix crashes from mbind() merging vmas

Ilya Dryomov (1):
      rbd: handle parent_overlap on writes correctly

J. Bruce Fields (1):
      nfsd: fix rare symlink decoding bug

James Bottomley (1):
      [SCSI] Fix spurious request sense in error handling

James Hogan (1):
      MIPS: KVM: Remove redundant NULL checks before kfree()

Jan Kara (2):
      ext4: Fix buffer double free in ext4_alloc_branch()
      ext4: Fix hole punching for files with indirect blocks

Jan Kardell (1):
      iio: ti_am335x_adc: Fix: Use same step id at FIFOs both ends

Joe Thornber (1):
      dm io: fix a race condition in the wake up code for sync_io

Joel Stanley (2):
      powerpc/perf: Add PPMU_ARCH_207S define
      powerpc/perf: Clear MMCR2 when enabling PMU

Johan Hedberg (4):
      Bluetooth: Fix check for connection encryption
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM
      Bluetooth: Fix indicating discovery state when canceling inquiry
      Bluetooth: Fix locking of hdev when calling into SMP code

Johan Hovold (1):
      USB: ftdi_sio: fix null deref at port probe

Julian Anastasov (1):
      ipvs: stop tot_stats estimator only under CONFIG_SYSCTL

Jussi Kivilinna (1):
      crypto: sha512_ssse3 - fix byte count to bit count conversion

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code

Krzysztof Hałasa (1):
      mac80211: fix IBSS join by initializing last_scan_completed

Lan Tianyu (1):
      ACPI / battery: Retry to get battery information if failed during probing

Lennox Wu (3):
      Score: Implement the function csum_ipv6_magic
      Score: The commit is for compiling successfully.
      Score: Modify the Makefile of Score, remove -mlong-calls for compiling

Linus Torvalds (1):
      Don't trigger congestion wait on dirty-but-not-writeout pages

Linus Walleij (1):
      usb: musb: ux500: don't propagate the OF node

Liu Bo (4):
      Btrfs: fix NULL pointer crash of deleting a seed device
      Btrfs: mark mapping with error flag to report errors to userspace
      Btrfs: use right type to get real comparison
      Btrfs: fix scrub_print_warning to handle skinny metadata extents

Lu Baolu (1):
      xhci: clear root port wake on bits if controller isn't wake-up capable

Lv Zheng (4):
      ACPI / EC: Avoid race condition related to advance_transaction()
      ACPI / EC: Add asynchronous command byte write support
      ACPI / EC: Remove duplicated ec_wait_ibf0() waiter
      ACPI / EC: Fix race condition in ec_transaction_completed()

Marcin Kraglak (1):
      Bluetooth: Allow change security level on ATT_CID in slave role

Markos Chandras (1):
      MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region

Mathias Nyman (1):
      xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Maxime Bizon (1):
      workqueue: fix dev_set_uevent_suppress() imbalance

Maxime Ripard (1):
      net: allwinner: emac: Add missing free_irq

Miao Xie (1):
      Btrfs: output warning instead of error when loading free space cache failed

Michal Nazarewicz (3):
      usb: gadget: f_fs: fix NULL pointer dereference when there are no strings
      tools: ffs-test: fix header values endianess
      mm: page_alloc: fix CMA area initialisation when pageblock > MAX_ORDER

Michal Sojka (1):
      USB: serial: ftdi_sio: Add Infineon Triboard

Mikulas Patocka (1):
      sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue

Nadav Amit (1):
      KVM: x86: Increase the number of fixed MTRR regs to 10

Naoya Horiguchi (2):
      hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned entry
      mm: hugetlb: fix copy_hugetlb_page_range()

NeilBrown (1):
      md: flush writes before starting a recovery.

Nicholas Bellinger (3):
      target: Fix left-over se_lun->lun_sep pointer OOPs
      iscsi-target: Explicily clear login response PDU in exception path
      iscsi-target: Avoid rejecting incorrect ITT for Data-Out

Oleg Nesterov (1):
      tracing: Fix syscall_*regfunc() vs copy_process() race

Oliver Neukum (1):
      USB: option: add device ID for SpeedUp SU9800 usb 3g modem

Paolo Bonzini (3):
      KVM: x86: preserve the high 32-bits of the PAT register
      virtio-scsi: avoid cancelling uninitialized work items
      virtio-scsi: fix various bad behavior on aborted requests

Paul Bolle (2):
      powerpc: fix typo 'CONFIG_PPC_CPU'
      powerpc: fix typo 'CONFIG_PMAC'

Peter Chen (1):
      usb: chipidea: udc: delete td from req's td list at ep_dequeue

Prabhakar Lad (1):
      cpufreq: Makefile: fix compilation for davinci platform

Qu Wenruo (1):
      btrfs: Add ctime/mtime update for btrfs device add/remove.

Rafał Miłecki (1):
      b43: fix frequency reported on G-PHY with /new/ firmware

Rickard Strandqvist (1):
      fs: btrfs: volumes.c: Fix for possible null pointer dereference

Roland Dreier (1):
      x86, ioremap: Speed up check for RAM pages

Sachin Kamat (1):
      hwmon: (emc2103) Fix return value

Stanislaw Gruszka (2):
      rt2x00: disable TKIP on USB
      rt2x00: fix rfkill regression on rt2500pci

Steve Capper (1):
      arm64: mm: Make icache synchronisation logic huge page aware

Steve French (1):
      [CIFS] fix mount failure with broken pathnames when smb3 mount with mapchars option

Steven Rostedt (Red Hat) (3):
      tracing: Try again for saved cmdline if failed due to locking
      ring-buffer: Check if buffer exists before polling
      tracing: Remove ftrace_stop/start() from reading the trace file

Takashi Iwai (1):
      ALSA: usb-audio: Fix races at disconnection and PCM closing

Tejun Heo (2):
      blkcg: fix use-after-free in __blkg_release_rcu() by making blkcg_gq refcnt an atomic_t
      ptrace,x86: force IRET path after a ptrace_stop()

Theodore Ts'o (2):
      ext4: fix unjournalled bg descriptor while initializing inode bitmap
      ext4: clarify error count warning messages

Thomas Gleixner (4):
      irqchip: spear_shirq: Fix interrupt offset
      rtmutex: Detect changes in the pi lock chain
      rtmutex: Plug slow unlock race
      clk: spear3xx: Use proper control register offset

Thomas Hellstrom (1):
      drm/vmwgfx: Fix incorrect write to read-only register v2:

Tomas Winkler (1):
      mei: me: fix hw ready reset flow

Vincent Minet (1):
      intel_pstate: Set CPU number before accessing MSRs

Wang Shilong (2):
      Btrfs: make sure there are not any read requests before stopping workers
      Btrfs: set right total device count for seeding support

Wang, Yu (1):
      xhci: Fix runtime suspended xhci from blocking system suspend.

Yasuaki Ishimatsu (1):
      workqueue: zero cpumask of wq_numa_possible_cpumask on init

Zhaowei Yuan (1):
      drm: fix NULL pointer access by wrong ioctl
