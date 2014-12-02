Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbaLBTUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:20:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbaLBTUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:20:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.13.y-ckt stable] Linux 3.13.11-ckt12 stable review
Date: Tue,  2 Dec 2014 11:17:59 -0800
Message-Id: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.13.11-ckt12 stable kernel.

This version contains 121 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review

The review period for version 3.13.11-ckt12 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.13.y-ckt extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 .../bindings/interrupt-controller/interrupts.txt   |   4 -
 arch/arm/Kconfig.debug                             |   2 +-
 arch/arm/boot/compressed/head.S                    |  20 ++-
 arch/arm/mach-pxa/include/mach/addr-map.h          |   5 +
 arch/arm/mm/Kconfig                                |   1 +
 arch/arm64/lib/clear_user.S                        |   2 +-
 arch/mips/oprofile/backtrace.c                     |   2 +-
 arch/parisc/include/uapi/asm/shmbuf.h              |  25 ++-
 arch/parisc/kernel/syscall_table.S                 |   8 +-
 arch/powerpc/kernel/entry_64.S                     |   6 +
 arch/x86/include/asm/cpufeature.h                  |   1 +
 arch/x86/include/asm/kvm_para.h                    |  10 +-
 arch/x86/include/asm/page_32_types.h               |   1 -
 arch/x86/include/asm/page_64_types.h               |  11 +-
 arch/x86/include/asm/traps.h                       |   1 +
 arch/x86/kernel/cpu/amd.c                          |   7 +
 arch/x86/kernel/cpu/common.c                       |   2 +
 arch/x86/kernel/dumpstack_64.c                     |   1 -
 arch/x86/kernel/entry_64.S                         |  81 +++-------
 arch/x86/kernel/microcode_core.c                   |   8 +
 arch/x86/kernel/traps.c                            |  71 ++++++---
 arch/x86/kvm/emulate.c                             |   8 +
 arch/x86/kvm/x86.c                                 |   2 +-
 arch/x86/mm/init_64.c                              |  11 +-
 arch/xtensa/include/uapi/asm/unistd.h              |   3 +-
 drivers/acpi/device_pm.c                           |   2 +-
 drivers/ata/ahci.c                                 |  19 ++-
 drivers/base/core.c                                |   4 +-
 drivers/base/regmap/regmap.c                       |   6 +-
 drivers/block/rbd.c                                |   2 +-
 drivers/char/hw_random/pseries-rng.c               |  11 +-
 drivers/clocksource/sun4i_timer.c                  |  10 +-
 drivers/crypto/caam/key_gen.c                      |  29 ++--
 drivers/firewire/core-cdev.c                       |   3 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  39 +++--
 drivers/gpu/drm/radeon/cik.c                       |   7 +-
 drivers/gpu/drm/radeon/cik_sdma.c                  |  21 +--
 drivers/gpu/drm/radeon/evergreen.c                 |   4 +
 drivers/gpu/drm/radeon/r100.c                      |   3 +
 drivers/gpu/drm/radeon/r600_dma.c                  |  20 +--
 drivers/gpu/drm/radeon/r600_dpm.c                  |   2 +-
 drivers/gpu/drm/radeon/rs600.c                     |   3 +
 drivers/gpu/drm/radeon/rs690.c                     |   3 +
 drivers/gpu/drm/radeon/rv515.c                     |   3 +
 drivers/gpu/drm/radeon/si.c                        |   3 +
 drivers/i2c/busses/i2c-at91.c                      |   2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  44 ++++--
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   8 +
 drivers/input/mouse/alps.c                         |  28 +++-
 drivers/md/dm-bufio.c                              |  12 +-
 drivers/md/dm-raid.c                               |  11 +-
 drivers/md/dm-thin.c                               |  16 +-
 drivers/md/md.c                                    |   4 +
 drivers/md/persistent-data/dm-btree-internal.h     |   6 +
 drivers/md/persistent-data/dm-btree-spine.c        |   2 +-
 drivers/md/persistent-data/dm-btree.c              |  24 ++-
 drivers/media/dvb-frontends/ds3000.c               |   7 +
 drivers/media/usb/ttusb-dec/ttusbdecfe.c           |   3 +
 drivers/net/can/dev.c                              |   2 +-
 drivers/net/can/usb/esd_usb2.c                     |   1 +
 drivers/net/macvtap.c                              |   2 +
 drivers/net/tun.c                                  |  16 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  13 ++
 drivers/net/wireless/ath/ath9k/hw.c                |  13 --
 drivers/net/wireless/ath/ath9k/reg.h               |  13 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |  50 ++----
 drivers/of/address.c                               |  19 ++-
 drivers/of/base.c                                  |  88 +++--------
 drivers/of/selftest.c                              |  66 +++++++-
 drivers/platform/x86/acer-wmi.c                    |  19 +++
 drivers/platform/x86/samsung-laptop.c              |  10 ++
 drivers/power/charger-manager.c                    |  65 +++++---
 drivers/regulator/max77693.c                       |   2 +-
 drivers/scsi/scsi_error.c                          |   4 +-
 drivers/spi/spi-fsl-dspi.c                         |   4 +-
 drivers/spi/spi-pxa2xx.c                           |   7 +-
 drivers/staging/iio/meter/ade7758.h                |   1 -
 drivers/staging/iio/meter/ade7758_core.c           |  57 ++-----
 drivers/staging/iio/meter/ade7758_ring.c           |   5 +-
 drivers/staging/zram/zram_drv.c                    |   3 +-
 drivers/target/target_core_transport.c             |   2 +-
 drivers/tty/serial/serial_core.c                   |   2 +-
 drivers/tty/tty_io.c                               |  15 +-
 drivers/tty/vt/consolemap.c                        |   8 +
 drivers/usb/class/cdc-acm.c                        |   6 +-
 drivers/usb/core/hcd.c                             |   2 +
 drivers/usb/host/xhci-pci.c                        |  14 +-
 drivers/usb/serial/kobil_sct.c                     |   5 +-
 drivers/usb/serial/opticon.c                       |   2 +-
 drivers/usb/storage/transport.c                    |  26 ++++
 drivers/vhost/scsi.c                               |  24 +++
 fs/btrfs/file-item.c                               |   2 +-
 fs/nfs/delegation.c                                |  25 ++-
 fs/nfs/delegation.h                                |   1 +
 fs/nfs/direct.c                                    |   1 +
 fs/nfs/inode.c                                     |   2 +-
 fs/nfs/nfs4filelayout.c                            |   3 -
 fs/nfs/nfs4proc.c                                  |  76 ++++-----
 fs/nfs/pagelist.c                                  |   2 +-
 fs/nfsd/nfscache.c                                 |  53 ++-----
 include/drm/i915_powerwell.h                       |   5 +-
 include/linux/bitops.h                             |   7 +-
 include/linux/nfs_xdr.h                            |  11 ++
 include/linux/of.h                                 |  84 ++++++++--
 include/linux/power/charger-manager.h              |   1 -
 include/sound/soc-dpcm.h                           |   2 +
 kernel/audit_tree.c                                |   1 +
 kernel/rcu/tree.c                                  |  22 ++-
 net/ceph/crypto.c                                  | 169 ++++++++++++++++-----
 net/mac80211/aes_ccm.c                             |   3 +
 net/mac80211/ibss.c                                |   2 +-
 net/mac80211/ieee80211_i.h                         |   3 +-
 net/mac80211/iface.c                               |   7 +-
 net/mac80211/mesh.c                                |   2 +-
 net/mac80211/mlme.c                                |   5 +-
 net/mac80211/rx.c                                  |  14 +-
 net/mac80211/spectmgmt.c                           |  18 +--
 net/sctp/sm_make_chunk.c                           |   3 +
 sound/pci/hda/hda_i915.c                           |  28 +++-
 sound/pci/hda/hda_i915.h                           |   6 +-
 sound/pci/hda/hda_intel.c                          | 126 ++++++++-------
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/codecs/sgtl5000.c                        |   3 +-
 sound/soc/codecs/sgtl5000.h                        |   2 +-
 sound/soc/codecs/wm_adsp.c                         |   1 +
 sound/soc/sh/fsi.c                                 |   3 +-
 sound/soc/sh/rcar/core.c                           |   3 +-
 sound/soc/soc-pcm.c                                |  72 +++++++--
 sound/usb/card.c                                   |   9 +-
 sound/usb/mixer_quirks.c                           |   6 +
 sound/usb/quirks.c                                 |  14 ++
 131 files changed, 1291 insertions(+), 728 deletions(-)

Aaro Koskinen (1):
      MIPS: oprofile: Fix backtrace on 64-bit kernel

Alan Stern (1):
      usb-storage: handle a skipped data phase

Alex Deucher (4):
      drm/radeon: make sure mode init is complete in bandwidth_update
      drm/radeon: use gart for DMA IB tests
      drm/radeon: add missing crtc unlock when setting up the MC
      drm/radeon: fix endian swapping in vbios fetch for tdp table

Alexander Stein (1):
      spi: fsl-dspi: Fix CTAR selection

Alexey Khoroshilov (1):
      can: esd_usb2: fix memory leak on disconnect

Andy Lutomirski (3):
      x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
      x86_64, traps: Stop using IST for #SS
      x86_64, traps: Rework bad_iret

Anton Blanchard (1):
      powerpc: do_notify_resume can be called with bad thread_info flags argument

Bart Van Assche (1):
      srp-target: Retry when QP creation fails with ENOMEM

Benjamin Herrenschmidt (1):
      of/base: Fix PowerPC address parsing hack

Bjorn Helgaas (1):
      of/irq: Drop obsolete 'interrupts' vs 'interrupts-extended' text

Borislav Petkov (1):
      x86, microcode: Update BSPs microcode on resume

Charles Keepax (1):
      ASoC: wm_adsp: Avoid attempt to free buffers that might still be in use

Chris Mason (1):
      Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error cleanup

Chris Moore (1):
      IB/isert: Adjust CQ size to HW limits

Christoph Hellwig (1):
      scsi: only re-lock door after EH on devices that were reset

Cristian Stoica (1):
      crypto: caam - fix missing dma unmap on error path

Dan Carpenter (1):
      [media] ttusb-dec: buffer overflow in ioctl

Daniel Borkmann (1):
      net: sctp: fix NULL pointer dereference in af->from_addr_param on malformed packet

Daniel Vetter (1):
      drm/i915: drop WaSetupGtModeTdRowDispatch:snb

Dave Hansen (1):
      x86: Require exact match for 'noxsave' command line option

David Henningsson (1):
      ALSA: hda - Add mute LED pin quirk for HP 15 touchsmart

David Jeffery (1):
      nfs: Don't busy-wait on SIGKILL in __nfs_iocounter_wait

Denis Turischev (1):
      xhci: Switch only Intel Lynx Point-LP ports to EHCI on shutdown.

Devin Ryles (1):
      ALSA: hda_intel: Add DeviceIDs for Sunrise Point-LP

Dmitry Eremin-Solenikov (1):
      spi: pxa2xx: toggle clocks on suspend if not disabled by runtime PM

Fabio Estevam (1):
      ASoC: sgtl5000: Fix SMALL_POP bit definition

Grant Likely (1):
      of: Fix overflow bug in string property parsing functions

Greg Kurz (1):
      hwrng: pseries - port to new read API and fix stack corruption

Hans de Goede (4):
      samsung-laptop: Add broken-acpi-video quirk for NC210/NC110
      acer-wmi: Add Aspire 5741 to video_vendor_dmi_table
      acer-wmi: Add acpi_backlight=video quirk for the Acer KAV80
      usb: Do not allow usb_alloc_streams on unconfigured devices

Heinz Mauelshagen (1):
      dm raid: ensure superblock's size matches device's logical block size

Helge Deller (1):
      parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop syscalls

Herbert Xu (2):
      tun: Fix csum_start with VLAN acceleration
      macvtap: Fix csum_start when VLAN tags are present

Ilya Dryomov (1):
      libceph: do not crash on large auth tickets

Imre Deak (1):
      tty/vt: don't set font mappings on vc not supporting this

James Ralston (2):
      ahci: Add Device IDs for Intel Sunrise Point PCH
      ALSA: hda_intel: Add Device IDs for Intel Sunrise Point PCH

Jammy Zhou (1):
      drm/radeon: set correct CE ram size for CIK

Jan Kara (2):
      rbd: Fix error recovery in rbd_obj_read_sync()
      nfs: Fix use of uninitialized variable in nfs_getattr()

Jani Nikula (1):
      drm/i915: provide interface for audio driver to query cdclk

Jeff Layton (2):
      nfsd: don't try to reuse an expired DRC entry off the list
      nfsd: don't halt scanning the DRC LRU list when there's an RC_INPROG entry

Joe Thornber (2):
      dm thin: grab a virtual cell before looking up the mapping
      dm btree: fix a recursion depth bug in btree walking code

Johan Hovold (4):
      USB: kobil_sct: fix non-atomic allocation in write path
      USB: opticon: fix non-atomic allocation in write path
      USB: cdc-acm: add device id for GW Instek AFG-2225
      USB: cdc-acm: only raise DTR on transitions from B0

Johannes Berg (2):
      mac80211: properly flush delayed scan work on interface removal
      mac80211: fix use-after-free in defragmentation

Jurgen Kramer (1):
      ALSA: usb-audio: Add ctrl message delay quirk for Marantz/Denon devices

Kamal Mostafa (1):
      Revert "ALSA: hda - restore BCLK M/N values when resuming HSW/BDW display controller"

Kees Cook (1):
      x86, mm: Set NX across entire PMD at boot

Krzysztof Kozlowski (2):
      regulator: max77693: Fix use of uninitialized regulator config
      power: charger-manager: Fix accessing invalidated power supply after charger unbind

Kuninori Morimoto (2):
      ASoC: fsi: remove unsupported PAUSE flag
      ASoC: rsnd: remove unsupported PAUSE flag

Kyle McMartin (1):
      arm64: __clear_user: handle exceptions on strb

Lars-Peter Clausen (3):
      staging:iio:ade7758: Fix NULL pointer deref when enabling buffer
      staging:iio:ade7758: Fix check if channels are enabled in prenable
      staging:iio:ade7758: Remove "raw" from channel name

Luciano Coelho (2):
      mac80211: use secondary channel offset IE also beacons during CSA
      mac80211: schedule the actual switch of the station before CSA count 0

Max Filippov (1):
      xtensa: re-wire umount syscall to sys_oldumount

Maxime COQUELIN (1):
      bitops: Fix shift overflow in GENMASK macros

Maxime Ripard (1):
      clockevent: sun4i: Fix race condition in the probe code

Mengdong Lin (1):
      ALSA: hda - restore BCLK M/N value as per CDCLK for HSW/BDW display HDA controller

Miaoqing Pan (1):
      ath9k: Fix RTC_DERIVED_CLK usage

Miklos Szeredi (1):
      audit: keep inode pinned

Mikulas Patocka (1):
      dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks

Nadav Amit (2):
      KVM: x86: Don't report guest userspace emulation error to userspace
      KVM: x86: Fix uninitialized op->type for some immediate values

Nathan Lynch (1):
      ARM: 8198/1: make kuser helpers depend on MMU

NeilBrown (1):
      md: Always set RECOVERY_NEEDED when clearing RECOVERY_FROZEN

Nicholas Bellinger (1):
      vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDPOINT

Oliver Neukum (1):
      xhci: no switching back on non-ULT Haswell

Or Gerlitz (1):
      ib_isert: Add max_send_sge=2 minimum for control PDU responses

Pali Rohár (3):
      Input: alps - ignore potential bare packets when device is out of sync
      Input: alps - allow up to 2 invalid packets without resetting device
      Input: alps - ignore bad data on Dell Latitudes E6440 and E7440

Paolo Bonzini (1):
      x86: kvm: use alternatives for VMCALL vs. VMMCALL if kernel text is read-only

Paul E. McKenney (1):
      rcu: Make callers awaken grace-period kthread

Peng Tao (1):
      nfs: fix pnfs direct write memory leak

Peter Hurley (3):
      serial: Fix divide-by-zero fault in uart_get_divisor()
      tty: Fix high cpu load if tty is unreleaseable
      tty: Prevent "read/write wait queue active!" log flooding

Pranith Kumar (1):
      rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads

Quentin Casasnovas (1):
      [3.13-stable only] regmap: fix kernel hang on regmap_bulk_write with zero val_count.

Rafael J. Wysocki (1):
      ACPI / PM: Ignore wakeup setting if the ACPI companion can't wake up

Robert Jarzmik (1):
      ARM: pxa: fix hang on startup with DEBUG_LL

Roland Dreier (1):
      target: Don't call TFO->write_pending if data_length == 0

Ronald Wahl (1):
      mac80211: Fix regression that triggers a kernel BUG with CCMP

Sagi Grimberg (1):
      iser-target: Handle DEVICE_REMOVAL event on network portal listener correctly

Stanislaw Gruszka (1):
      rt2x00: do not align payload on modern H/W

Stefan Richter (1):
      firewire: cdev: prevent kernel stack leaking into ioctl arguments

Sujith Manoharan (1):
      ath9k: Add version/revision macros for QCA9531

Takashi Iwai (4):
      ALSA: usb-audio: Fix device_del() sysfs warnings at disconnect
      drm/i915, HD-audio: Don't continue probing when nomodeset is given
      ALSA: usb-audio: Fix memory leak in FTU quirk
      ASoC: dpcm: Fix race between FE/BE updates and trigger

Tejun Heo (1):
      ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks

Thomas Körper (1):
      can: dev: avoid calling kfree_skb() from interrupt context

Trond Myklebust (5):
      NFSv4: Ensure that we remove NFSv4.0 delegations when state has expired
      NFSv4.1: nfs41_clear_delegation_stateid shouldn't trust NFS_DELEGATED_STATE
      NFSv4: Fix races between nfs_remove_bad_delegation() and delegation return
      NFSv4: Ensure that we call FREE_STATEID when NFSv4.x stateids are revoked
      NFS: Don't try to reclaim delegation open state if recovery failed

Ulrich Eckhardt (1):
      [media] ds3000: fix LNB supply voltage on Tevii S480 on initialization

Weijie Yang (1):
      zram: avoid kunmap_atomic() of a NULL pointer

Will Deacon (1):
      ARM: 8191/1: decompressor: ensure I-side picks up relocated code

Wolfram Sang (1):
      i2c: at91: don't account as iowait

Yijing Wang (1):
      sysfs: driver core: Fix glue dir race condition by gdp_mutex
