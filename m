Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab3HTIsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:48:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43172 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3HTIr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:47:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.5.y.z extended stable] Linux 3.5.7.19
Date: Tue, 20 Aug 2013 09:47:54 +0100
Message-Id: <1376988475-7943-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.5.7.19 kernel.

The updated 3.5.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.5.y;a=shortlog

The diff from v3.5.7.18 is posted as a follow-up to this email.

The 3.5.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Makefile                                           |   2 +-
 arch/arm/Kconfig                                   |   3 +-
 arch/arm/kernel/entry-armv.S                       | 103 +++++++++++----------
 arch/arm/kernel/fiq.c                              |  19 +++-
 arch/arm/kernel/traps.c                            |  37 +++++---
 arch/arm/kernel/vmlinux.lds.S                      |  17 ++++
 arch/arm/mm/Kconfig                                |  34 +++++++
 arch/arm/mm/mmu.c                                  |  10 +-
 arch/x86/kernel/i387.c                             |   2 +-
 drivers/acpi/battery.c                             |   2 +
 drivers/ata/Kconfig                                |   2 +-
 drivers/ata/sata_inic162x.c                        |  14 +++
 drivers/block/xen-blkback/blkback.c                |  13 ++-
 drivers/block/xen-blkback/common.h                 |   2 +
 drivers/block/xen-blkback/xenbus.c                 |   2 +
 drivers/char/virtio_console.c                      |  47 ++++++----
 drivers/firewire/core-cdev.c                       |   3 +
 drivers/firewire/ohci.c                            |  10 +-
 drivers/gpu/drm/ast/ast_ttm.c                      |   1 +
 drivers/gpu/drm/cirrus/cirrus_ttm.c                |   1 +
 drivers/gpu/drm/i915/i915_drv.h                    |   1 +
 drivers/gpu/drm/i915/intel_display.c               |  16 ++++
 drivers/gpu/drm/i915/intel_lvds.c                  |   3 +-
 drivers/gpu/drm/i915/intel_panel.c                 |  11 +++
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |   1 +
 drivers/gpu/drm/radeon/atom.c                      |   5 +
 drivers/gpu/drm/radeon/evergreen.c                 |   3 +-
 drivers/gpu/drm/radeon/ni.c                        |   3 +-
 drivers/gpu/drm/radeon/r600.c                      |   3 +-
 drivers/gpu/drm/radeon/rv770.c                     |   3 +-
 drivers/gpu/drm/radeon/si.c                        |   3 +-
 drivers/hwmon/adt7470.c                            |   2 +-
 drivers/input/mouse/elantech.c                     |  17 ++--
 drivers/macintosh/windfarm_rm31.c                  |  18 ++--
 drivers/net/arcnet/arcnet.c                        |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c |   3 +-
 drivers/net/ethernet/realtek/8139cp.c              |  48 +++++++++-
 drivers/net/usb/smsc75xx.c                         |  12 +--
 drivers/net/virtio_net.c                           |   5 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   1 +
 drivers/net/wireless/iwlwifi/iwl-mac80211.c        |  19 +++-
 drivers/net/wireless/iwlwifi/iwl-pci.c             |   1 +
 drivers/net/wireless/mwifiex/sdio.c                |   4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |  18 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c          |  20 +++-
 drivers/scsi/nsp32.c                               |   2 +-
 drivers/scsi/scsi.c                                |   3 +
 drivers/staging/zram/zram_drv.c                    |   2 +-
 drivers/tty/serial/mxs-auart.c                     |  38 ++++----
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/serial/ftdi_sio.c                      |  31 ++++++-
 drivers/usb/serial/ftdi_sio_ids.h                  |  34 ++++++-
 drivers/usb/serial/mos7840.c                       |  91 ++++++++++--------
 drivers/virtio/virtio_ring.c                       |  54 ++++++++---
 drivers/xen/evtchn.c                               |  21 +----
 fs/btrfs/extent-tree.c                             |  11 +++
 fs/cifs/cifsencrypt.c                              |   2 +-
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/connect.c                                  |   7 +-
 fs/cifs/sess.c                                     |   6 +-
 fs/debugfs/inode.c                                 |  69 +++++---------
 fs/ext4/ialloc.c                                   |  10 +-
 fs/ext4/super.c                                    |  19 +++-
 fs/super.c                                         |  25 ++---
 include/linux/firewire-cdev.h                      |   4 +-
 include/linux/firewire.h                           |   1 +
 include/linux/ftrace_event.h                       |   4 +-
 include/linux/hugetlb.h                            |  16 ++++
 include/linux/regmap.h                             |   1 +
 include/linux/virtio.h                             |   4 +
 include/xen/interface/io/ring.h                    |   5 +
 kernel/events/core.c                               |  20 +++-
 kernel/futex.c                                     |   3 +-
 kernel/sched/fair.c                                |   2 +-
 kernel/trace/trace.c                               |   1 +
 mm/hugetlb.c                                       |  17 ++++
 net/ipv4/sysctl_net_ipv4.c                         |   6 +-
 net/ipv6/ip6mr.c                                   |   5 +
 net/key/af_key.c                                   |   4 +
 net/mac80211/cfg.c                                 |   2 +
 net/mac80211/rx.c                                  |  10 +-
 net/sched/sch_atm.c                                |   1 +
 net/sched/sch_cbq.c                                |   1 +
 net/wireless/nl80211.c                             |   7 +-
 sound/core/compress_offload.c                      |   2 +-
 sound/usb/6fire/comm.c                             |  41 ++++++--
 sound/usb/6fire/comm.h                             |   2 +-
 sound/usb/endpoint.c                               |  13 ++-
 tools/perf/util/map.c                              |   3 +-
 89 files changed, 799 insertions(+), 353 deletions(-)

Aaro Koskinen (1):
      powerpc/windfarm: Fix noisy slots-fan on Xserve (rm31)

Al Viro (1):
      livelock avoidance in sget()

Alex Deucher (2):
      drm/radeon/atom: initialize more atom interpretor elements to 0
      drm/radeon: always program the MC on startup

Amit Shah (5):
      virtio: console: fix race with port unplug and open/close
      virtio: console: fix race in port_fops_open() and port unplug
      virtio: console: clean up port data immediately at time of unplug
      virtio: console: fix raising SIGIO after port unplug
      virtio: console: return -ENODEV on all read operations after unplug

Andrew Vagin (1):
      tracing: Fix fields of struct trace_iterator that are zeroed by mistake

Arnd Bergmann (1):
      [SCSI] nsp32: use mdelay instead of large udelay constants

Chen Gang (1):
      cifs: extend the buffer length enought for sprintf() using

Clemens Ladisch (2):
      firewire: fix libdc1394/FlyCap2 iso event regression
      ALSA: usb-audio: do not trust too-big wMaxPacketSize values

Curt Brune (1):
      hwmon: (adt7470) Fix incorrect return code check

Dan Carpenter (3):
      arcnet: cleanup sizeof parameter
      af_key: more info leaks in pfkey messages
      net_sched: info leak in atm_tc_dump_class()

Dave Airlie (1):
      drm/ast: invalidate page tables when pinning a BO

David S. Miller (1):
      net_sched: Fix stack info leak in cbq_dump_wrr().

David Vrabel (1):
      xen/evtchn: avoid a deadlock when unbinding an event channel

Egbert Eich (1):
      drm/mgag200: Invalidate page tables when pinning a BO

Emmanuel Grumbach (1):
      iwlwifi: add DELL SKU for 5150 HMC

Eric Dumazet (1):
      usbnet: do not pretend to support SG/TSO

H.J. Lu (1):
      x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz

Hannes Frederic Sowa (1):
      ipv6: take rtnl_lock and mark mrt6 table as freed on namespace cleanup

Jacob Keller (1):
      ixgbe: Fix Tx Hang issue with lldpad on 82598EB

Jan Beulich (1):
      xen/io/ring.h: new macro to detect whether there are too many requests on the ring

Jani Nikula (1):
      drm/i915: do not disable backlight on vgaswitcheroo switch off

Jiri Olsa (1):
      perf: Fix event group context move

Johan Hovold (3):
      USB: mos7840: fix race in register handling
      USB: mos7840: fix device-type detection
      USB: mos7840: fix pointer casts

Johannes Berg (3):
      mac80211: fix ethtool stats for non-station interfaces
      mac80211: fix duplicate retransmission detection
      iwlwifi: mvm: refuse connection to APs with BI < 16

Josef Bacik (1):
      Btrfs: re-add root to dead root list if we stop dropping it

Joshua Zhu (1):
      perf tools: Add anonymous huge page recognition

Julius Werner (1):
      usb: core: don't try to reset_device() a port that got just disconnected

Jussi Kivilinna (1):
      ALSA: 6fire: fix DMA issues with URB transfer_buffer usage

Kamal Mostafa (1):
      drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight

Konrad Rzeszutek Wilk (1):
      xen/blkback: Check for insane amounts of request on the ring (v6).

Lan Tianyu (1):
      ACPI / battery: Fix parsing _BIX return value

Luis Henriques (1):
      Linux 3.5.7.19

Martin K. Petersen (1):
      [SCSI] Don't attempt to send extended INQUIRY command if skip_vpd_pages is set

Mateusz Krawczuk (1):
      regmap: Add missing header for !CONFIG_REGMAP stubs

Matteo Delfino (1):
      Input: elantech - fix for newer hardware versions (v7)

Michael S. Tsirkin (2):
      virtio: support unlocked queue poll
      virtio_net: fix race in RX VQ processing

Michal Kazior (1):
      nl80211: fix mgmt tx status and testmode reporting for netns

Michal Srb (1):
      drm/cirrus: Invalidate page tables when pinning a BO

Michal Tesar (1):
      sysctl net: Keep tcp_syn_retries inside the boundary

Neil Horman (1):
      8139cp: Add dma_mapping_error checking

Oleg Nesterov (1):
      debugfs: debugfs_remove_recursive() must not rely on list_empty(d_subdirs)

Oleksij Rempel (1):
      ath9k_htc: do some initial hardware configuration

Piotr Sarna (1):
      ext4: fix mount/remount error messages for incompatible mount options

Rick Farina (Zero_Chaos) (1):
      USB: serial: ftdi_sio: add more RT Systems ftdi devices

Russell King (6):
      ARM: poison the vectors page
      ARM: poison memory between kuser helpers
      ARM: move vector stubs
      ARM: use linker magic for vectors and vector stubs
      ARM: update FIQ support for relocation of vectors
      ARM: allow kuser helpers to be removed from the vector page

Sachin Kamat (1):
      ALSA: usb/6fire: Fix potential NULL pointer dereference in comm.c

Sergey Senozhatsky (1):
      zram: allow request end to coincide with disksize

Stanislaw Gruszka (1):
      rt2x00: fix stop queue

Sumit.Saxena@lsi.com (1):
      [SCSI] megaraid_sas: megaraid_sas driver init fails in kdump kernel

Tejun Heo (1):
      libata: make it clear that sata_inic162x is experimental

Theodore Ts'o (2):
      ext4: make sure group number is bumped after a inode allocation race
      ext4: allow the mount options nodelalloc and data=journal

Tomasz Moń (1):
      mwifiex: Add missing endian conversion.

Uwe Kleine-König (2):
      serial/mxs-auart: fix race condition in interrupt handler
      serial/mxs-auart: increase time to wait for transmitter to become idle

Vinod Koul (1):
      ALSA: compress: fix the return value for SNDRV_COMPRESS_VERSION

Zhang Yi (1):
      futex: Take hugepages into account when generating futex_key

Zhu Yanhai (1):
      sched: Fix the broken sched_rr_get_interval()

