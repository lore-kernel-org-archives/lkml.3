Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbaGYUPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:15:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36658 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaGYUPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:15:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.27
Date: Fri, 25 Jul 2014 13:15:37 -0700
Message-Id: <1406319338-14559-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.27 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.26 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                                     |   2 +-
 arch/arm/kernel/stacktrace.c                 |  18 ++--
 arch/arm64/include/asm/Kbuild                |   1 -
 arch/arm64/include/asm/dma-mapping.h         |   2 -
 arch/arm64/include/uapi/asm/posix_types.h    |  10 +++
 arch/arm64/kernel/entry.S                    |   1 -
 arch/arm64/kernel/ptrace.c                   |   4 +
 arch/mips/kernel/irq-msc01.c                 |   2 +-
 arch/mips/lantiq/dts/easy50712.dts           |   1 +
 arch/powerpc/include/asm/systbl.h            |   2 +-
 arch/powerpc/kernel/legacy_serial.c          |  15 ++--
 arch/powerpc/kernel/setup-common.c           |  10 ++-
 arch/powerpc/platforms/pseries/eeh_pseries.c |   1 +
 arch/s390/include/asm/lowcore.h              |  11 +--
 arch/x86/kernel/entry_32.S                   |   5 --
 arch/x86/syscalls/syscall_64.tbl             |   6 +-
 drivers/acpi/bus.c                           |   7 ++
 drivers/acpi/video_detect.c                  |   8 ++
 drivers/ata/ahci.c                           |   4 +
 drivers/base/power/opp.c                     |   4 +-
 drivers/block/mtip32xx/mtip32xx.c            | 124 ++++++++++++++++++++-------
 drivers/bluetooth/hci_ldisc.c                |  24 ++++--
 drivers/bluetooth/hci_uart.h                 |   1 +
 drivers/gpu/drm/radeon/atombios_crtc.c       |  48 ++++++-----
 drivers/gpu/drm/radeon/atombios_dp.c         |  17 +++-
 drivers/gpu/drm/radeon/atombios_encoders.c   |   5 +-
 drivers/gpu/drm/radeon/radeon_connectors.c   |   2 +-
 drivers/hid/hid-core.c                       |  12 ++-
 drivers/iio/adc/at91_adc.c                   |  16 ++--
 drivers/iio/adc/max1363.c                    |  16 ++--
 drivers/infiniband/core/user_mad.c           |  75 +++++++++-------
 drivers/infiniband/hw/cxgb4/cq.c             |   3 +-
 drivers/infiniband/hw/cxgb4/user.h           |   1 +
 drivers/infiniband/hw/ipath/ipath_diag.c     |   4 +
 drivers/infiniband/hw/qib/qib_mad.c          |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c          |   6 ++
 drivers/input/mouse/elantech.c               |  26 ++++--
 drivers/md/dm-thin.c                         |   3 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c       |   6 ++
 drivers/media/usb/uvc/uvc_video.c            |  15 ++--
 drivers/net/ethernet/intel/igb/igb_main.c    |   4 +-
 drivers/net/wireless/b43/xmit.c              |  10 ++-
 drivers/net/wireless/iwlwifi/pcie/trans.c    |  26 +++---
 drivers/net/wireless/rt2x00/rt2500pci.c      |   7 +-
 drivers/net/wireless/rt2x00/rt2x00.h         |   1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c      |  24 +++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c      |   2 +
 drivers/pci/quirks.c                         |   1 +
 drivers/rtc/rtc-at91rm9200.c                 |  16 +++-
 drivers/scsi/hpsa.c                          |  37 ++++++++
 drivers/staging/iio/light/tsl2x7x_core.c     |   8 +-
 drivers/target/iscsi/iscsi_target.c          |   1 +
 drivers/target/iscsi/iscsi_target_auth.c     |  10 +++
 drivers/target/iscsi/iscsi_target_login.c    |  18 ++--
 drivers/target/target_core_device.c          |   1 +
 drivers/uio/uio.c                            |   2 +
 drivers/usb/dwc3/gadget.c                    |   4 +
 drivers/usb/host/pci-quirks.c                |  19 +++-
 drivers/usb/misc/usbtest.c                   |  10 +++
 drivers/usb/serial/qcserial.c                |  21 +++++
 drivers/watchdog/ath79_wdt.c                 |  10 +++
 drivers/watchdog/sp805_wdt.c                 |   4 +-
 fs/attr.c                                    |   8 +-
 fs/btrfs/extent_io.c                         |   1 +
 fs/cifs/cifs_unicode.c                       |   7 +-
 fs/ext4/mballoc.c                            |   2 +-
 fs/ext4/page-io.c                            |  24 +++---
 fs/inode.c                                   |  10 ++-
 fs/namei.c                                   |  11 +--
 fs/nfs/inode.c                               |  26 ++++--
 fs/nfs/super.c                               |   1 +
 fs/nfsd/nfs4state.c                          |   2 +-
 fs/nfsd/nfs4xdr.c                            |   4 +-
 fs/reiserfs/inode.c                          |   8 +-
 fs/ubifs/file.c                              |   3 +-
 fs/ubifs/shrinker.c                          |   1 -
 include/linux/capability.h                   |   2 +-
 include/linux/irqdesc.h                      |   4 +
 include/linux/mmzone.h                       |   6 +-
 include/linux/pageblock-flags.h              |  37 ++++++--
 include/linux/pci_ids.h                      |   1 +
 include/linux/ptrace.h                       |  32 +++++++
 include/sound/core.h                         |   2 +
 include/uapi/sound/compress_offload.h        |   2 +-
 kernel/auditsc.c                             |  27 ++++--
 kernel/capability.c                          |  18 ++--
 kernel/fork.c                                |  10 ++-
 kernel/irq/manage.c                          |   4 +-
 kernel/irq/spurious.c                        | 106 ++++++++++++++++++++++-
 lib/idr.c                                    |   8 +-
 mm/hugetlb.c                                 |  70 +++++++++------
 mm/memcontrol.c                              |   5 +-
 mm/memory-failure.c                          |  25 +++---
 mm/mempolicy.c                               |  44 ++++------
 mm/page_alloc.c                              |  51 ++++++-----
 mm/rmap.c                                    |   8 +-
 mm/vmscan.c                                  |  46 ++++++++--
 net/bluetooth/hci_conn.c                     |  11 ++-
 net/bluetooth/hci_event.c                    |  11 ++-
 net/bluetooth/l2cap_sock.c                   |  10 +--
 net/bluetooth/mgmt.c                         |   7 +-
 net/bluetooth/smp.c                          |   9 +-
 net/mac80211/debugfs_netdev.c                |   6 +-
 net/mac80211/ibss.c                          |   1 +
 net/netfilter/nf_nat_core.c                  |  35 +++++++-
 net/sunrpc/svc_xprt.c                        |   2 +
 scripts/recordmcount.h                       |   4 +-
 security/integrity/evm/evm_main.c            |  12 ++-
 security/integrity/ima/ima_crypto.c          |  32 ++++++-
 sound/core/control.c                         |  78 +++++++++++------
 sound/core/init.c                            |   1 +
 sound/pci/hda/patch_realtek.c                |   1 +
 sound/usb/card.c                             |  13 ++-
 sound/usb/endpoint.c                         |  17 +++-
 sound/usb/endpoint.h                         |   1 +
 115 files changed, 1186 insertions(+), 437 deletions(-)

Alan Stern (1):
      USB: EHCI: avoid BIOS handover on the HASEE E200

Aleksander Morgado (2):
      usb: qcserial: add Netgear AirCard 341U
      usb: qcserial: add additional Sierra Wireless QMI devices

Alex Deucher (4):
      drm/radeon: fix typo in radeon_connector_is_dp12_capable()
      drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices
      drm/radeon/atom: fix dithering on certain panels
      drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi

Alex Smith (1):
      recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in modules

Andreas Schrägle (1):
      ahci: add PCI ID for Marvell 88SE91A0 SATA Controller

Andy Lutomirski (2):
      auditsc: audit_krule mask accesses need bounds checking
      fs,userns: Change inode_capable to capable_wrt_inode_uidgid

Anton Blanchard (1):
      powerpc: 64bit sendfile is capped at 2GB

Arik Nemtsov (1):
      mac80211: don't check netdev state for debugfs read/write

Asai Thambi S P (3):
      mtip32xx: Increase timeout for STANDBY IMMEDIATE command
      mtip32xx: Remove dfs_parent after pci unregister
      mtip32xx: Fix ERO and NoSnoop values in PCIe upstream on AMD systems

Bart Van Assche (3):
      IB/srp: Fix a sporadic crash triggered by cable pulling
      IB/umad: Fix error handling
      IB/umad: Fix use-after-free on close

Benjamin Herrenschmidt (1):
      powerpc/serial: Use saner flags when creating legacy ports

Bin Wang (1):
      uio: fix vma io range check in mmap

Boris BREZILLON (1):
      rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq

Chander Kashyap (1):
      PM / OPP: fix incorrect OPP count handling in of_init_opp_table

ChiaHao (1):
      arm64: Bug fix in stack alignment exception

Chris Mason (1):
      Btrfs: fix double free in find_lock_delalloc_range

Christian Borntraeger (1):
      s390/lowcore: reserve 96 bytes for IRB in lowcore

Christoph Hellwig (1):
      nfsd: getattr for FATTR4_WORD0_FILES_AVAIL needs the statfs buffer

Dan Carpenter (1):
      iio: adc: at91: signedness bug in at91_adc_get_trigger_value_by_name()

Dennis Dalessandro (1):
      IB/ipath: Translate legacy diagpkt into newer extended diagpkt

Dmitry Kasatkin (1):
      ima: introduce ima_kernel_read()

Edward Lin (1):
      ACPI / video: Add Dell Inspiron 5737 to the blacklist

Emmanuel Grumbach (1):
      iwlwifi: pcie: try to get ownership several times

Felipe Balbi (2):
      usb: dwc3: gadget: clear stall when disabling endpoint
      bluetooth: hci_ldisc: fix deadlock condition

Florian Westphal (1):
      netfilter: nf_nat: fix oops on netns removal

Gabor Juhos (1):
      watchdog: ath79_wdt: avoid spurious restarts on AR934x

Gavin Shan (1):
      powerpc/pseries: Fix overwritten PE state

Greg Kroah-Hartman (1):
      Revert "uio: fix vma io range check in mmap"

H. Peter Anvin (1):
      x86-32, espfix: Remove filter for espfix32 due to race

Hans de Goede (2):
      Input: elantech - deal with clickpads reporting right button events
      Input: elantech - don't set bit 1 of reg_10 when the no_hw_res quirk is set

Huang Rui (1):
      usb: usbtest: fix unlink write error with pattern 1

Hugh Dickins (2):
      mm: fix sleeping function warning from __put_anon_vma
      mm: fix crashes from mbind() merging vmas

J. Bruce Fields (1):
      nfsd4: fix FREE_STATEID lockowner leak

Jan Kara (1):
      ext4: fix zeroing of page during writeback

Jeff Mahoney (1):
      reiserfs: call truncate_setsize under tailpack mutex

Joe Handzik (1):
      hpsa: add new Smart Array PCI IDs (May 2014)

Johan Hedberg (6):
      Bluetooth: Fix redundant encryption request for reauthentication
      Bluetooth: Fix check for connection encryption
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM
      Bluetooth: Fix setting correct authentication information for SMP STK
      Bluetooth: Fix indicating discovery state when canceling inquiry
      Bluetooth: Fix locking of hdev when calling into SMP code

Johannes Weiner (1):
      mm: vmscan: clear kswapd's special reclaim powers before exiting

Jonathan Cameron (1):
      iio:adc:max1363 incorrect resolutions for max11604, max11605, max11610 and max11611.

Jukka Taimisto (1):
      Bluetooth: Fix L2CAP deadlock

Jérôme Carretero (1):
      ahci: Add Device ID for HighPoint RocketRaid 642L

Kailang Yang (1):
      ALSA: hda/realtek - Add support of ALC891 codec

Kamal Mostafa (1):
      Linux 3.8.13.27

Kees Cook (1):
      HID: core: fix validation of report id 0

Krzysztof Hałasa (1):
      mac80211: fix IBSS join by initializing last_scan_completed

Lai Jiangshan (1):
      idr: fix overflow bug during maximum ID calculation at maximum height

Lars-Peter Clausen (5):
      ALSA: control: Protect user controls against concurrent access
      ALSA: control: Fix replacing user controls
      ALSA: control: Don't access controls outside of protected regions
      ALSA: control: Handle numid overflow
      ALSA: control: Make sure that id->index does not overflow

Leif Lindholm (1):
      MIPS: DTS: Fix missing device_type="memory" property in memory nodes

Linus Torvalds (1):
      uio: we cannot mmap unaligned page contents

Lukas Czerner (1):
      dm thin: update discard_granularity to reflect the thin-pool blocksize

Lv Zheng (1):
      ACPI: Fix conflict between customized DSDT and DSDT local copy

Marcin Kraglak (1):
      Bluetooth: Allow change security level on ATT_CID in slave role

Mario Schuknecht (1):
      staging: iio: tsl2x7x_core: fix proximity treshold

Markos Chandras (1):
      MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region

Mateusz Guzik (1):
      NFS: populate ->net in mount data when remounting

Matthew Dempsky (1):
      ptrace: fix fork event messages across pid namespaces

Maurizio Lombardi (1):
      ext4: fix wrong assert in ext4_mb_normalize_request()

Mel Gorman (2):
      mm: vmscan: do not throttle based on pfmemalloc reserves if node has no ZONE_NORMAL
      mm: page_alloc: use word-based accesses for get/set pageblock bitmaps

Michael Neuling (1):
      powerpc: Don't setup CPUs with bad status

Michal Hocko (1):
      memcg: do not hang on OOM when killed by userspace OOM access to memory reserves

Mike Frysinger (1):
      x86, x32: Use compat shims for io_{setup,submit}

Mike Marciniszyn (1):
      IB/qib: Fix port in pkey change event

Mike Miller (1):
      [SCSI] hpsa: add HP Smart Array Gen9 PCI ID's

Mikulas Patocka (1):
      iscsi-target: fix iscsit_del_np deadlock on unload

Mimi Zohar (1):
      evm: prohibit userspace writing 'security.evm' HMAC value

Naoya Horiguchi (2):
      hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned entry
      mm: hugetlb: fix copy_hugetlb_page_range()

Nicholas Bellinger (3):
      iscsi-target: Reject mutual authentication with reflected CHAP_C
      target: Fix left-over se_lun->lun_sep pointer OOPs
      iscsi-target: Fix incorrect np->np_thread NULL assignment

Olivier Langlois (1):
      [media] uvcvideo: Fix clock param realtime setting

Rafał Miłecki (1):
      b43: fix frequency reported on G-PHY with /new/ firmware

Russell King (1):
      ARM: stacktrace: avoid listing stacktrace functions in stacktrace

Scott Wood (1):
      powerpc: Don't skip ePAPR spin-table CPUs

Stanislaw Gruszka (2):
      rt2x00: disable TKIP on USB
      rt2x00: fix rfkill regression on rt2500pci

Steve French (1):
      [CIFS] fix mount failure with broken pathnames when smb3 mount with mapchars option

Suravee Suthikulpanit (1):
      arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro

Takashi Iwai (2):
      [media] ivtv: Fix Oops when no firmware is loaded
      ALSA: usb-audio: Fix races at disconnection and PCM closing

Thomas Gleixner (1):
      genirq: Sanitize spurious interrupt detection of threaded irqs

Thomas Jarosch (1):
      PCI: Add new ID for Intel GPU "spurious interrupt" quirk

Todd Fujinaka (1):
      igb: fix stats for i210 rx_fifo_errors

Tony Luck (2):
      mm/memory-failure.c-failure: send right signal code to correct thread
      mm/memory-failure.c: don't let collect_procs() skip over processes for MF_ACTION_REQUIRED

Trond Myklebust (2):
      NFS: Don't declare inode uptodate unless all attributes were checked
      SUNRPC: Fix a module reference leak in svc_handle_xprt

Viresh Kumar (1):
      watchdog: sp805: Set watchdog_device->timeout from ->set_timeout()

Wang, Xiaoming (1):
      ALSA: compress: Cancel the optimization of compiler and fix the size of struct for all platform.

Will Deacon (2):
      arm64: ptrace: change fs when passing kernel pointer to regset code
      arm64: uid16: fix __kernel_old_{gid,uid}_t definitions

Yann Droneaud (1):
      RDMA/cxgb4: Add missing padding at end of struct c4iw_create_cq_resp

hujianyang (2):
      UBIFS: fix an mmap and fsync race condition
      UBIFS: Remove incorrect assertion in shrink_tnc()

