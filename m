Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3K2KNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:13:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54233 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3K2KNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:13:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.5.y.z extended stable] Linux 3.5.7.26
Date: Fri, 29 Nov 2013 10:13:04 +0000
Message-Id: <1385719985-11391-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.5.7.26 kernel.

The updated 3.5.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.5.y;a=shortlog

The diff from v3.5.7.25 is posted as a follow-up to this email.

The 3.5.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Documentation/sysctl/kernel.txt              |  25 +++++--
 Makefile                                     |   2 +-
 arch/arm/lib/memset.S                        | 100 +++++++++++++--------------
 arch/arm/mach-omap2/irq.c                    |   2 +-
 arch/cris/include/asm/io.h                   |   1 +
 arch/parisc/kernel/head.S                    |   4 ++
 arch/powerpc/kernel/vio.c                    |   4 +-
 arch/powerpc/platforms/powernv/pci-ioda.c    |  12 +++-
 arch/um/kernel/exitcode.c                    |   4 +-
 arch/xtensa/kernel/signal.c                  |   2 +-
 crypto/ansi_cprng.c                          |   4 +-
 drivers/ata/ahci.c                           |   4 ++
 drivers/ata/libahci.c                        |  16 +++++
 drivers/ata/libata-core.c                    |   1 +
 drivers/ata/libata-eh.c                      |   6 +-
 drivers/ata/libata-transport.c               |  16 ++---
 drivers/gpu/drm/drm_drv.c                    |   9 ++-
 drivers/gpu/drm/radeon/atombios_encoders.c   |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c          |  17 +++--
 drivers/md/md.c                              |   5 +-
 drivers/md/raid1.c                           |   1 +
 drivers/md/raid10.c                          |   1 +
 drivers/net/can/c_can/c_can.c                |   6 +-
 drivers/net/ethernet/realtek/8139cp.c        |   1 +
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   6 ++
 drivers/net/wireless/iwlwifi/iwl-cfg.h       |   1 +
 drivers/net/wireless/iwlwifi/iwl-pci.c       |  10 +++
 drivers/net/wireless/rt2x00/rt2400pci.c      |   2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c      |  12 ++--
 drivers/net/wireless/rt2x00/rt2x00mac.c      |   3 +
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |   3 +-
 drivers/net/xen-netback/common.h             |   1 +
 drivers/net/xen-netback/interface.c          |   3 +-
 drivers/net/xen-netback/netback.c            |  10 +--
 drivers/pci/pci-driver.c                     |   4 ++
 drivers/s390/net/qeth_core_main.c            |   6 +-
 drivers/scsi/aacraid/linit.c                 |   2 +
 drivers/staging/bcm/Bcmchar.c                |   1 +
 drivers/staging/ozwpan/ozcdev.c              |   3 +
 drivers/staging/wlags49_h2/wl_priv.c         |   8 ++-
 drivers/target/target_core_pscsi.c           |   8 +--
 drivers/uio/uio.c                            |  16 ++++-
 drivers/usb/core/hub.c                       |  12 ++++
 drivers/usb/serial/ftdi_sio.c                |   1 +
 drivers/usb/serial/ftdi_sio_ids.h            |   6 ++
 drivers/usb/serial/mos7840.c                 |   4 ++
 drivers/usb/serial/option.c                  |  17 +++++
 drivers/usb/wusbcore/wa-rpipe.c              |   5 +-
 drivers/usb/wusbcore/wa-xfer.c               |   5 +-
 drivers/video/au1100fb.c                     |  26 +------
 drivers/video/au1200fb.c                     |  23 +-----
 drivers/video/backlight/atmel-pwm-bl.c       |   7 +-
 fs/devpts/inode.c                            |   1 +
 fs/ecryptfs/keystore.c                       |   3 +-
 fs/jfs/jfs_inode.c                           |   3 +-
 fs/nfs/inode.c                               |   2 +
 fs/nfs/nfs3proc.c                            |   6 +-
 fs/nfs/nfs4filelayout.c                      |   1 -
 fs/nfs/nfs4proc.c                            |  19 +----
 fs/nfs/nfs4state.c                           |  22 ------
 fs/nfs/proc.c                                |  43 ------------
 include/drm/drm_mode.h                       |   2 +
 include/linux/fs.h                           |   2 +
 include/linux/perf_event.h                   |  12 ++--
 kernel/events/ring_buffer.c                  |  31 +++++++--
 kernel/time/alarmtimer.c                     |   4 +-
 kernel/time/clockevents.c                    |  65 +++++++++++++----
 kernel/trace/trace.c                         |   5 +-
 kernel/trace/trace_event_perf.c              |   2 +-
 lib/scatterlist.c                            |   3 +-
 lib/vsprintf.c                               |  33 ++++++++-
 mm/mmap.c                                    |   8 +--
 net/core/flow_dissector.c                    |   2 +-
 net/mac80211/cfg.c                           |   1 +
 net/mac80211/ieee80211_i.h                   |   3 +
 net/mac80211/rx.c                            |   3 +
 net/mac80211/scan.c                          |  19 +++++
 net/mac80211/status.c                        |   3 +
 net/mac80211/tx.c                            |   3 +-
 net/netfilter/nf_conntrack_sip.c             |   2 +-
 net/sunrpc/clnt.c                            |   1 +
 net/wireless/radiotap.c                      |   7 +-
 scripts/kallsyms.c                           |  12 +++-
 scripts/link-vmlinux.sh                      |   2 +
 sound/core/pcm.c                             |   4 ++
 sound/pci/hda/patch_conexant.c               |   3 +
 sound/pci/hda/patch_hdmi.c                   |  22 ++++--
 sound/pci/hda/patch_realtek.c                |   1 +
 sound/soc/codecs/ak4642.c                    |   2 +-
 sound/soc/codecs/wm_hubs.c                   |   1 +
 sound/soc/soc-dapm.c                         |   2 +-
 sound/usb/6fire/chip.c                       |   2 +-
 92 files changed, 508 insertions(+), 304 deletions(-)

Akira Takeuchi (1):
      mm: ensure get_unmapped_area() returns higher address than mmap_min_addr

Alex Deucher (1):
      drm/radeon/atom: workaround vbios bug in transmitter table on rs780

Andy Adamson (1):
      SUNRPC handle EKEYEXPIRED in call_refreshresult

Baruch Siach (1):
      xtensa: don't use alternate signal stack on threads

Bian Yu (1):
      md: avoid deadlock when md_set_badblocks.

Chris Wilson (2):
      drm: Prevent overwriting from userspace underallocating core ioctl structs
      drm: Pad drm_mode_get_connector to 64-bit boundary

Dan Carpenter (5):
      uml: check length in exitcode_proc_write()
      staging: ozwpan: prevent overflow in oz_cdev_write()
      aacraid: missing capable() check in compat ioctl
      staging: wlags49_h2: buffer overflow setting station name
      Staging: bcm: info leak in ioctl

Dave Kleikamp (1):
      jfs: fix error path in ialloc

David Woodhouse (1):
      8139cp: re-enable interrupts after tx timeout

Emmanuel Grumbach (2):
      iwlwifi: pcie: add SKUs for 6000, 6005 and 6235 series
      mac80211: correctly close cancelled scans

Fan Du (1):
      include/linux/fs.h: disable preempt when acquire i_size_seqcount write lock

Felix Fietkau (3):
      mac80211: drop spoofed packets in ad-hoc mode
      mac80211: use sta_info_get_bss() for nl80211 tx and client probing
      mac80211: update sta->last_rx on acked tx frames

Gavin Shan (1):
      powerpc/powernv: Add PE to its own PELTV

Geyslan G. Bem (1):
      ecryptfs: Fix memory leakage in keystore.c

Gwendal Grignou (2):
      libata: make ata_eh_qc_retry() bump scmd->allowed on bogus failures
      libata: Fix display of sata speed

Helge Deller (1):
      parisc: Do not crash 64bit SMP kernels on machines with >= 4GB RAM

Ilija Hadzic (1):
      devpts: plug the memory leak in kill_sb

Ivan Djelic (1):
      ARM: 7668/1: fix memset-related crashes caused by recent GCC (4.7.2) optimizations

James Ralston (1):
      ahci: Add Device IDs for Intel Wildcat Point-LP

Jason Wang (1):
      net: flow_dissector: fail on evil iph->ihl

Jeff Layton (1):
      nfs: don't allow nfs_find_actor to match inodes of the wrong type

Johan Hovold (3):
      USB: mos7840: fix tiocmget error handling
      backlight: atmel-pwm-bl: fix reported brightness
      backlight: atmel-pwm-bl: fix gpio polarity in remove

Johannes Berg (1):
      wireless: radiotap: fix parsing buffer overrun

Julius Werner (1):
      usb: hub: Clear Port Reset Change during init/resume

KOSAKI Motohiro (1):
      alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist

Krzysztof Mazur (1):
      usb: fix cleanup after failure in hub_configure()

Linus Torvalds (1):
      Fix a few incorrectly checked [io_]remap_pfn_range() calls

Luis Henriques (1):
      Linux 3.5.7.26

Lukasz Dorau (1):
      md: Fix skipping recovery for read-only arrays.

Mark Cave-Ayland (1):
      rtlwifi: rtl8192cu: Fix error in pointer arithmetic

Markus Pargmann (2):
      ARM: OMAP2+: irq, AM33XX add missing register check
      can: c_can: Fix RX message handling, handle lost message before EOB

Mauro Carvalho Chehab (1):
      cris: media platform drivers: fix build

Ming Lei (2):
      lib/scatterlist.c: don't flush_kernel_dcache_page on slab page
      scripts/kallsyms: filter symbols not in kernel address space

Neil Horman (1):
      crypto: ansi_cprng - Fix off by one error in non-block size request

Nicolas Pitre (1):
      ARM: 7670/1: fix the memset fix

Patrick McHardy (1):
      netfilter: nf_ct_sip: don't drop packets with offsets pointing outside the packet

Peter Zijlstra (1):
      perf: Fix perf ring buffer memory ordering

Phil Edworthy (1):
      ASoC: ak4642: prevent un-necessary changes to SG_SL1

Prarit Bhargava (1):
      powerpc/vio: use strcpy in modalias_show

Rafael J. Wysocki (1):
      PCI/PM: Clear state_saved during suspend

Rui li (1):
      USB：add new zte 3g-dongle's pid to option.c

Russell King (1):
      ALSA: fix oops in snd_pcm_info() caused by ASoC DPCM

Ryan Mallon (1):
      vsprintf: check real user/group id for %pK

Sarah Sharp (1):
      usb: Disable USB 2.0 Link PM before device reset.

Shan Hai (1):
      drivers/libata: Set max sector to 65535 for Slimtype DVD A DS8A9SH drive

Stanislaw Gruszka (3):
      rt2400pci: fix RSSI read
      rt2x00: check if device is still available on rt2x00mac_flush()
      rt2800usb: slow down TX status polling

Steven Rostedt (2):
      perf/ftrace: Fix paranoid level for enabling function tracer
      tracing: Fix potential out-of-bounds in trace_get_user()

Takashi Iwai (6):
      ASoC: dapm: Fix source list debugfs outputs
      ALSA: hda - Add a fixup for ASUS N76VZ
      ASoC: wm_hubs: Add missing break in hp_supply_event()
      ALSA: hda - Move one-time init codes from generic_hdmi_init()
      ALSA: 6fire: Fix probe of multiple cards
      ALSA: hda - Add support for CX20952

Thomas Gleixner (1):
      clockevents: Sanitize ticks to nsec conversion

Thomas Hellstrom (1):
      drm/vmwgfx: Don't kill clients on VT switch

Thomas Pugliese (2):
      usb: wusbcore: set the RPIPE wMaxPacketSize value correctly
      usb: wusbcore: change WA_SEGS_MAX to a legal value

Trond Myklebust (1):
      NFSv4: Fix a use-after-free situation in _nfs4_proc_getlk()

Ursula Braun (1):
      qeth: avoid buffer overflow in snmp ioctl

Wei Liu (1):
      xen-netback: use jiffies_64 value to calculate credit timeout

Wei Yongjun (1):
      target/pscsi: fix return value check

xiangliang yu (1):
      ahci: disabled FBS prior to issuing software reset

Алексей Крамаренко (1):
      USB: serial: ftdi_sio: add id for Z3X Box device

