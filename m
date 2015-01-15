Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbbAOWo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:44:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50644 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbbAOWoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:44:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.16.y-ckt stable] Linux 3.16.7-ckt4
Date: Thu, 15 Jan 2015 22:45:15 +0000
Message-Id: <1421361916-4714-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
X-Extended-Stable: 3.16
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.16.7-ckt4 kernel.

The updated 3.16.y-ckt tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.16.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.16.y;a=shortlog

The diff from v3.16.7-ckt3 is posted as a follow-up to this email.

The 3.16.y-ckt extended stable tree is maintained by the Canonical Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 .../devicetree/bindings/i2c/i2c-designware.txt     |   4 +-
 Documentation/ramoops.txt                          |  13 +-
 Makefile                                           |   2 +-
 arch/arc/boot/dts/nsimosci.dts                     |  18 +-
 arch/arm/boot/dts/armada-370.dtsi                  |  10 +-
 arch/arm/include/asm/arch_timer.h                  |   9 +
 arch/arm/mach-mvebu/coherency.c                    |  44 +-
 arch/arm/mach-tegra/reset-handler.S                |   1 +
 arch/arm64/include/asm/arch_timer.h                |   9 +
 arch/arm64/include/asm/hwcap.h                     |   1 +
 arch/arm64/include/asm/suspend.h                   |   1 +
 arch/arm64/kernel/setup.c                          |   3 +-
 arch/arm64/kernel/sleep.S                          |  83 ++-
 arch/arm64/kernel/suspend.c                        |  68 ++-
 arch/parisc/include/asm/ldcw.h                     |  13 +-
 arch/powerpc/include/asm/reg.h                     |   2 +
 arch/powerpc/kernel/idle_power7.S                  |  18 +-
 arch/powerpc/kernel/mce_power.c                    |   4 +-
 arch/powerpc/platforms/cell/spufs/inode.c          |   2 +-
 arch/s390/kernel/compat_linux.c                    |   2 +-
 arch/s390/kvm/gaccess.c                            |  20 +-
 arch/s390/kvm/interrupt.c                          |   2 +-
 arch/s390/kvm/priv.c                               |   4 +-
 arch/x86/include/uapi/asm/ldt.h                    |   7 +
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |  22 +-
 arch/x86/kernel/kvm.c                              |   9 +-
 arch/x86/kernel/kvmclock.c                         |   1 -
 arch/x86/kernel/mcount_64.S                        |  41 ++
 arch/x86/kernel/process_64.c                       | 101 +++-
 arch/x86/kernel/tls.c                              |  39 ++
 arch/x86/kvm/emulate.c                             |   2 +-
 arch/x86/kvm/mmu.c                                 |   2 +-
 arch/x86/kvm/vmx.c                                 |   4 +-
 arch/xtensa/include/asm/highmem.h                  |   2 +-
 block/blk-core.c                                   |   3 +
 block/blk-mq-cpumap.c                              |   2 +-
 block/blk-mq-sysfs.c                               |   9 +-
 block/blk-mq-tag.c                                 |  17 +-
 block/blk-sysfs.c                                  |  11 +-
 block/genhd.c                                      |  11 +-
 crypto/af_alg.c                                    |   3 +
 drivers/base/bus.c                                 |   8 +-
 drivers/block/drbd/drbd_req.c                      |   1 +
 drivers/bluetooth/ath3k.c                          |   2 +
 drivers/bluetooth/btusb.c                          |   1 +
 drivers/clk/samsung/clk-exynos-audss.c             |   4 +
 drivers/clocksource/arm_arch_timer.c               |  17 +-
 drivers/gpu/drm/drm_dp_helper.c                    |   7 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  13 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   1 +
 drivers/gpu/drm/i915/i915_gem_stolen.c             |   6 +-
 drivers/gpu/drm/i915/i915_irq.c                    |   2 +-
 drivers/gpu/drm/i915/i915_reg.h                    |   2 +
 drivers/gpu/drm/i915/i915_suspend.c                |   8 +
 drivers/gpu/drm/i915/intel_dp.c                    |   5 +-
 drivers/gpu/drm/i915/intel_panel.c                 |   8 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   3 +
 drivers/gpu/drm/i915/intel_uncore.c                |   4 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |   2 +-
 drivers/gpu/drm/radeon/cik.c                       |   3 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c               |  26 +-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |  25 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |  17 +-
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/i2c-hid/i2c-hid.c                      |  14 +-
 drivers/hid/usbhid/hid-quirks.c                    |   2 +
 drivers/hv/channel_mgmt.c                          |  11 +-
 drivers/i2c/busses/i2c-mv64xxx.c                   | 328 ++++++-----
 drivers/infiniband/ulp/isert/ib_isert.c            | 640 +++++++++++++--------
 drivers/infiniband/ulp/isert/ib_isert.h            |  15 +-
 drivers/iommu/intel-iommu.c                        |   8 +-
 drivers/md/bitmap.c                                |  16 +-
 drivers/md/dm-bufio.c                              |  20 +-
 drivers/md/dm-cache-target.c                       |  13 +-
 drivers/md/dm-crypt.c                              |   2 +-
 drivers/md/dm-thin.c                               |  30 +-
 drivers/md/dm.c                                    |   2 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   4 +-
 drivers/md/raid5.c                                 |   7 +-
 drivers/media/i2c/smiapp-pll.c                     |   4 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   2 +
 drivers/media/rc/img-ir/img-ir-hw.c                |  28 +-
 drivers/media/rc/img-ir/img-ir-hw.h                |   3 +
 drivers/media/usb/au0828/au0828-cards.c            |   5 +
 drivers/media/usb/dvb-usb/af9005.c                 |   3 +
 drivers/media/usb/uvc/uvc_driver.c                 |   6 +-
 drivers/mfd/tc6393xb.c                             |  13 +-
 drivers/mfd/twl4030-power.c                        |   3 +
 drivers/misc/genwqe/card_utils.c                   |   2 +
 drivers/mmc/card/block.c                           |   2 +-
 drivers/mmc/host/dw_mmc.c                          |   7 +
 drivers/mmc/host/omap_hsmmc.c                      |   4 +-
 drivers/mmc/host/sdhci-pci-o2micro.c               |   2 -
 drivers/mtd/tests/torturetest.c                    |   4 +-
 drivers/mtd/ubi/upd.c                              |  10 +-
 drivers/mtd/ubi/wl.c                               |  10 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  17 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |   3 +-
 drivers/net/vxlan.c                                |   5 +
 drivers/net/wireless/ath/ath5k/qcu.c               |   8 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   4 +-
 drivers/net/wireless/ath/ath9k/mac.c               |   9 +-
 drivers/net/wireless/iwlwifi/Kconfig               |  10 +
 drivers/net/wireless/iwlwifi/dvm/commands.h        |  31 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c             |  47 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c             |   8 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h          |   2 +-
 drivers/pci/probe.c                                |   3 +
 drivers/platform/chrome/chromeos_laptop.c          |  92 ++-
 drivers/platform/x86/hp_accel.c                    |   1 +
 drivers/powercap/intel_rapl.c                      |   1 +
 drivers/regulator/anatop-regulator.c               |   8 +
 drivers/rtc/rtc-omap.c                             |  11 +-
 drivers/rtc/rtc-sirfsoc.c                          |  16 +-
 drivers/s390/char/con3215.c                        |  52 +-
 drivers/scsi/NCR5380.c                             |  12 +-
 drivers/scsi/aha1740.c                             |   2 +-
 drivers/scsi/atari_NCR5380.c                       |   2 +-
 drivers/scsi/esas2r/esas2r_main.c                  |   2 +-
 drivers/scsi/megaraid.c                            |   8 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c           |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   5 +-
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/storvsc_drv.c                         |   7 +-
 drivers/scsi/sun3_NCR5380.c                        |  10 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |   2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   2 +-
 drivers/staging/lustre/lustre/llite/namei.c        |   8 +-
 drivers/target/iscsi/iscsi_target_login.c          |  10 +-
 drivers/target/iscsi/iscsi_target_util.c           |  26 +-
 drivers/target/loopback/tcm_loop.c                 |  66 +--
 drivers/target/loopback/tcm_loop.h                 |   7 +-
 drivers/thermal/intel_powerclamp.c                 |   2 -
 drivers/thermal/thermal_core.c                     |   4 +-
 drivers/tty/n_tty.c                                |   3 +-
 drivers/tty/serial/men_z135_uart.c                 |   1 +
 drivers/tty/serial/samsung.c                       |   4 +
 drivers/usb/class/cdc-acm.c                        |  10 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/gadget/at91_udc.c                      |  44 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             |   3 +
 drivers/usb/serial/qcserial.c                      |  33 ++
 drivers/xen/swiotlb-xen.c                          |  10 +-
 fs/affs/amigaffs.c                                 |   2 +-
 fs/autofs4/expire.c                                |  12 +-
 fs/autofs4/root.c                                  |   2 +-
 fs/btrfs/disk-io.c                                 |  26 +-
 fs/btrfs/extent-tree.c                             |  27 +-
 fs/btrfs/extent_map.c                              |   2 -
 fs/btrfs/ordered-data.c                            |   9 +-
 fs/btrfs/ordered-data.h                            |   8 +-
 fs/btrfs/qgroup.c                                  |  10 +-
 fs/btrfs/transaction.c                             |  33 ++
 fs/btrfs/transaction.h                             |   2 +
 fs/btrfs/tree-log.c                                |   6 +-
 fs/ceph/addr.c                                     |   2 +-
 fs/ceph/dir.c                                      |   8 +-
 fs/ceph/inode.c                                    |   2 +-
 fs/cifs/inode.c                                    |   2 +-
 fs/coda/cache.c                                    |   2 +-
 fs/dcache.c                                        |  88 +--
 fs/debugfs/inode.c                                 |   2 +-
 fs/ecryptfs/crypto.c                               |   1 -
 fs/ecryptfs/file.c                                 |  12 -
 fs/ecryptfs/main.c                                 |  16 +-
 fs/exportfs/expfs.c                                |   2 +-
 fs/fs-writeback.c                                  |  29 +-
 fs/isofs/rock.c                                    |   9 +
 fs/libfs.c                                         |  12 +-
 fs/namespace.c                                     |  13 +-
 fs/ncpfs/dir.c                                     |   2 +-
 fs/ncpfs/ioctl.c                                   |   1 -
 fs/ncpfs/ncplib_kernel.h                           |   4 +-
 fs/nfs/getroot.c                                   |   2 +-
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/nfsd/nfs4state.c                                |  15 +-
 fs/nfsd/nfs4xdr.c                                  |   5 +-
 fs/notify/fsnotify.c                               |   4 +-
 fs/ocfs2/aops.c                                    |  16 +-
 fs/ocfs2/dcache.c                                  |   2 +-
 fs/proc/base.c                                     |  53 ++
 fs/proc/stat.c                                     |   2 +-
 fs/pstore/ram.c                                    |  13 +-
 fs/pstore/ram_core.c                               |  31 +-
 fs/reiserfs/super.c                                |   3 +
 fs/udf/dir.c                                       |   3 +-
 fs/udf/inode.c                                     |  18 +
 fs/udf/namei.c                                     |   3 +-
 fs/udf/symlink.c                                   |  57 +-
 fs/udf/udfdecl.h                                   |   3 +-
 fs/udf/unicode.c                                   |  28 +-
 include/linux/audit.h                              |   4 +
 include/linux/cred.h                               |   1 +
 include/linux/dcache.h                             |   8 +-
 include/linux/kernel_stat.h                        |   1 +
 include/linux/pstore_ram.h                         |   4 +-
 include/linux/user_namespace.h                     |  12 +
 include/trace/events/sched.h                       |   2 +-
 include/uapi/linux/hyperv.h                        |   1 +
 kernel/audit.c                                     |   8 +-
 kernel/auditfilter.c                               |  23 +-
 kernel/events/core.c                               |   4 +-
 kernel/groups.c                                    |  11 +-
 kernel/irq/internals.h                             |   4 +
 kernel/irq/irqdesc.c                               |  52 ++
 kernel/irq/proc.c                                  |  22 +-
 kernel/pid.c                                       |   2 +
 kernel/time/tick-sched.c                           |   2 -
 kernel/trace/trace.c                               |   4 +-
 kernel/trace/trace_events.c                        |   2 +-
 kernel/uid16.c                                     |   2 +-
 kernel/user.c                                      |   1 +
 kernel/user_namespace.c                            | 122 +++-
 net/batman-adv/fragmentation.c                     |   2 +-
 net/bluetooth/hci_conn.c                           |   2 +-
 net/mac80211/key.c                                 |   2 +-
 net/mac80211/rx.c                                  |  11 +-
 net/wireless/chan.c                                |   9 +-
 net/wireless/nl80211.c                             |   2 +-
 net/wireless/reg.c                                 |  12 +-
 security/keys/encrypted-keys/encrypted.c           |   5 +-
 security/keys/gc.c                                 |   4 +-
 security/selinux/selinuxfs.c                       |   6 +-
 sound/pci/hda/patch_analog.c                       |   1 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/codecs/max98090.c                        |   4 +-
 sound/soc/codecs/pcm512x-i2c.c                     |   7 +-
 sound/soc/codecs/sigmadsp.c                        |   7 +
 sound/usb/midi.c                                   |   2 +
 sound/usb/mixer_maps.c                             |  15 +-
 sound/usb/quirks-table.h                           | 166 ++----
 .../selftests/mount/unprivileged-remount-test.c    | 204 +++++--
 235 files changed, 2699 insertions(+), 1304 deletions(-)

Adel Gadllah (1):
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 0103

Al Viro (2):
      move d_rcu from overlapping d_child to overlapping d_alias
      deal with deadlock in d_walk()

Alex Deucher (3):
      drm/radeon: fix typo in CI dpm disable
      drm/radeon: work around a hw bug in MGCG on CIK
      drm/radeon: check the right ring in radeon_evict_flags()

Alex Williamson (1):
      driver core: Fix unbalanced device reference in drivers_probe

Andreas Müller (1):
      mac80211: fix multicast LED blinking and counter

Andy Lutomirski (5):
      x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit
      x86_64, switch_to(): Load TLS descriptors before switching DS and ES
      x86/tls: Validate TLS entries to protect espfix
      x86/tls: Disallow unusual TLS segments
      x86/tls: Don't validate lm in set_thread_area() after all

Arik Nemtsov (1):
      cfg80211: avoid mem leak on driver hint set

Axel Lin (1):
      tty: serial: men_z135_uart: Add terminating entry for men_z135_ids

Bandan Das (1):
      KVM: nVMX: Disable unrestricted mode if ept=0

Bart Van Assche (3):
      blk-mq: Fix a use-after-free
      blk-mq: Avoid that __bt_get_word() wraps multiple times
      blk-mq: Fix a race between bt_clear_tag() and bt_get()

Baruch Siach (1):
      mmc: block: add newline to sysfs display of force_ro

Benjamin Coddington (2):
      nfsd4: fix xdr4 inclusion of escaped char
      nfsd4: fix xdr4 count of server in fs_location4

Benson Leung (1):
      platform/chrome: chromeos_laptop - Add HP Chromebook 14

Brian Norris (1):
      mtd: tests: abort torturetest on erase errors

Catalin Marinas (1):
      arm64: Add COMPAT_HWCAP_LPAE

Chris Wilson (3):
      drm/i915: Only warn the first time we attempt to mmio whilst suspended
      drm/i915: Invalidate media caches on gen7
      drm/i915: Force the CS stall for invalidate flushes

Christian Borntraeger (2):
      KVM: s390: Fix ipte locking
      KVM: s390: flush CPU on load control

Christian Riesch (1):
      n_tty: Fix read_buf race condition, increment read_head after pushing data

Dan Carpenter (2):
      ceph: do_sync is never initialized
      dm space map metadata: fix sm_bootstrap_get_nr_blocks()

Daniel Vetter (1):
      drm/i915: Don't complain about stolen conflicts on gen3

Darrick J. Wong (1):
      dm bufio: fix memleak when using a dm_buffer's inline bio

Dave Airlie (2):
      drm/dp: retry AUX transactions 32 times (v1.1)
      drm/fb_helper: move deferred fb checking into restore mode (v2)

Dmitry Eremin-Solenikov (1):
      mfd: tc6393xb: Fail ohci suspend if full state restore is required

Dmitry Osipenko (1):
      ARM: tegra: Re-add removed SoC id macro to tegra_resume()

Dmitry Tunin (1):
      Bluetooth: ath3k: Add support of MCI 13d3:3408 bt device

Dominique Leuenberger (1):
      hp_accel: Add support for HP ZBook 15

Doug Anderson (1):
      i2c: designware: Fix falling time bindings doc

Dylan Rajaratnam (1):
      [media] img-ir/hw: Always read data to clear buffer

Emmanuel Grumbach (3):
      iwlwifi: dvm: fix flush support for old firmware
      iwlwifi: mvm: update values for Smart Fifo
      cfg80211: don't WARN about two consecutive Country IE hint

Eric W. Biederman (14):
      mnt: Implicitly add MNT_NODEV on remount when it was implicitly added by mount
      mnt: Update unprivileged remount test
      umount: Disallow unprivileged mount force
      groups: Consolidate the setgroups permission checks
      userns: Document what the invariant required for safe unprivileged mappings.
      userns: Don't allow setgroups until a gid mapping has been setablished
      userns: Don't allow unprivileged creation of gid mappings
      userns: Check euid no fsuid when establishing an unprivileged uid mapping
      userns: Only allow the creator of the userns unprivileged mappings
      userns: Rename id_map_mutex to userns_state_mutex
      userns: Add a knob to disable setgroups on a per user namespace basis
      userns: Allow setting gid_maps without privilege when setgroups is disabled
      userns: Unbreak the unprivileged remount tests
      mnt: Fix a memory stomp in umount

Felix Fietkau (3):
      ath9k_hw: fix hardware queue allocation
      ath9k: fix BE/BK queue order
      ath5k: fix hardware queue index assignment

Filipe Manana (1):
      Btrfs: fix fs corruption on transaction abort if device supports discard

Frank Schaefer (1):
      [media] af9005: fix kernel panic on init if compiled without IR

Gene Chen (1):
      platform/chrome: chromeos_laptop - Add Toshiba CB35 Touch

Greg Kroah-Hartman (1):
      USB: cdc-acm: check for valid interfaces

Guo Zeng (1):
      drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in probe

Gwendal Grignou (1):
      HID: i2c-hid: prevent buffer overflow in early IRQ

Hannes Reinecke (2):
      scsi: correct return values for .eh_abort_handler implementations
      tcm_loop: Fix wrong I_T nexus association

Ian Abbott (1):
      misc: genwqe: check for error from get_user_pages_fast()

Imre Deak (1):
      drm/i915: vlv: fix IRQ masking when uninstalling interrupts

James Hogan (2):
      mmc: dw_mmc: avoid write to CDTHRCTL on older versions
      [media] img-ir/hw: Fix potential deadlock stopping timer

Jan Kara (7):
      ncpfs: return proper error from NCP_IOC_SETROOT ioctl
      isofs: Fix infinite looping over CE entries
      isofs: Fix unchecked printing of ER records
      udf: Check path length when reading symlink
      udf: Verify i_size when loading inode
      udf: Verify symlink size before loading it
      udf: Check component length before reading it

Jani Nikula (1):
      drm/i915/dp: only use training pattern 3 on platforms that support it

Jarkko Nikula (1):
      ASoC: max98090: Fix ill-defined sidetone route

Jason Baron (1):
      powercap / RAPL: add support for CPU model 0x3f

Jean-Baptiste Maneyrol (1):
      HID: i2c-hid: fix race condition reading reports

Jens Axboe (2):
      genhd: check for int overflow in disk_expand_part_tbl()
      blk-mq: use 'nr_cpu_ids' as highest CPU ID count for hwq <-> cpu map

Jesse Barnes (1):
      drm/i915: save/restore GMBUS freq across suspend/resume on gen4

Jesse Gross (1):
      udptunnel: Add SKB_GSO_UDP_TUNNEL during gro_complete.

Jiang Liu (1):
      iommu/vt-d: Fix an off-by-one bug in __domain_mapping()

Jiri Jaburek (1):
      ALSA: usb-audio: extend KEF X300A FU 10 tweak to Arcam rPAC

Jiri Olsa (2):
      perf/x86/intel/uncore: Make sure only uncore events are collected
      perf: Fix events installation during moving group

Jiri Slaby (1):
      reiserfs: destroy allocated commit workqueue

Joe Thornber (4):
      dm cache: only use overwrite optimisation for promotion when in writeback mode
      dm cache: dirty flag was mistakenly being cleared when promoting via overwrite
      dm thin: fix inability to discard blocks when in out-of-data-space mode
      dm thin: fix missing out-of-data-space to write mode transition if blocks are released

Johan Hedberg (1):
      Bluetooth: Fix LE connection timeout deadlock

Johan Hovold (2):
      rtc: omap: fix clock-source configuration
      rtc: omap: fix missing wakealarm attribute

Johannes Berg (2):
      mac80211: free management frame keys when removing station
      iwlwifi: make U-APSD default configurable at compile time

John David Anglin (1):
      parisc: fix out-of-register compiler error in ldcw inline assembler function

Josef Bacik (3):
      Btrfs: make sure we wait on logged extents when fsycning two subvols
      Btrfs: make sure logged extents complete in the current transaction V3
      Btrfs: do not move em to modified list when unpinning

Jouni Malinen (1):
      cfg80211: Fix 160 MHz channels with 80+80 and 160 MHz drivers

Junxiao Bi (1):
      ocfs2: fix journal commit deadlock

Kailang Yang (1):
      ALSA: hda/realtek - Add new Dell desktop for ALC3234 headset mode

Kazuya Mizuguchi (1):
      usb: renesas_usbhs: gadget: fix NULL pointer dereference in ep_disable()

Krzysztof Kozlowski (1):
      clk: samsung: Fix double add of syscore ops after driver rebind

Lars Ellenberg (1):
      drbd: merge_bvec_fn: properly remap bvm->bi_bdev

Lars-Peter Clausen (1):
      ASoC: sigmadsp: Refuse to load firmware files with a non-supported version

Laura Abbott (1):
      arm64: Move cpu_resume into the text section

Liu Bo (1):
      Btrfs: fix loop writing of async reclaim

Long Li (1):
      storvsc: ring buffer failures may result in I/O freeze

Lorenzo Pieralisi (3):
      arm64: kernel: add missing __init section marker to cpu_suspend_init
      arm64: kernel: refactor the CPU suspend API for retention states
      arm64: kernel: fix __cpu_suspend mm switch on warm-boot

Luciano Coelho (1):
      nl80211: check matches array length before acessing it

Luis Henriques (2):
      thermal: Fix error path in thermal_init()
      Linux 3.16.7-ckt4

Mahesh Salgaonkar (1):
      powerpc/book3s: Fix partial invalidation of TLBs in MCE code.

Mark Fasheh (1):
      btrfs: don't go readonly on existing qgroup items

Markus Pargmann (1):
      regulator: anatop: Set default voltage selector for vddpu

Martin Hauke (1):
      USB: qcserial: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Martin K. Petersen (1):
      scsi: blacklist RSOC for Microsoft iSCSI target devices

Martin Schwidefsky (2):
      s390/3215: fix hanging console issue
      s390/3215: fix tty output containing tabs

Mauro Carvalho Chehab (2):
      [media] sound: simplify au0828 quirk table
      [media] sound: Update au0828 quirks table

Max Filippov (1):
      xtensa: fix kmap_prot definition

Michael Halcrow (1):
      eCryptfs: Remove buggy and unnecessary write in file name decode routine

Michael Mullin (1):
      platform/chrome: Add support for the acer c720p touchscreen.

Mika Westerberg (1):
      platform/chrome: chromeos_laptop - Add support for Acer C720

Mikulas Patocka (2):
      dcache: fix kmemcheck warning in switch_names
      dm thin: fix a race in thin_dtr

Milan Broz (1):
      dm crypt: use memzero_explicit for on-stack buffer

Mohammed Habibulla (1):
      platform/chrome: chromeos_laptop - Add Dell Chromebook 11 touch

Myron Stowe (1):
      PCI: Restore detection of read-only BARs

Nadav Amit (1):
      KVM: x86: em_ret_far overrides cpl

Nathan Lynch (1):
      clocksource: arm_arch_timer: Change clocksource name if CP15 unavailable

NeilBrown (2):
      md/raid5: fetch_block must fetch all the blocks handle_stripe_dirtying wants.
      md/bitmap: always wait for writes on unplug.

Nicholas Bellinger (1):
      iscsi-target: Fail connection on short sendmsg writes

Oleg Nesterov (1):
      exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting

Oliver Neukum (2):
      HID: yet another buggy ELAN touchscreen
      cdc-acm: memory leak in error case

Paolo Bonzini (1):
      kvm: x86: drop severity of "generation wraparound" message

Paul Mackerras (1):
      powerpc/powernv: Switch off MMU before entering nap/sleep/rvwinkle mode

Paul Moore (1):
      audit: don't attempt to lookup PIDs when changing PID filtering audit rules

Peng Tao (1):
      nfs41: fix nfs4_proc_layoutget error handling

Peter Guo (1):
      mmc: sdhci-pci-o2micro: Fix Dell E5440 issue

Peter Rosin (1):
      ASoC: pcm512x: Trigger auto-increment of register addresses on i2c

Rabin Vincent (1):
      crypto: af_alg - fix backlog handling

Rasmus Villemoes (1):
      fs: nfsd: Fix signedness bug in compare_blob

Richard Guy Briggs (2):
      audit: use supplied gfp_mask from audit_buffer in kauditd_send_multicast_skb
      audit: restore AUDIT_LOGINUID unset ABI

Richard Weinberger (2):
      UBI: Fix double free after do_sync_erase()
      UBI: Fix invalid vfree()

Rob Herring (1):
      pstore-ram: Fix hangs by using write-combine mappings

Robert Baldyga (1):
      serial: samsung: wait for transfer completion before clock disable

Ronald Wahl (1):
      usb: gadget: at91_udc: move prepare clk into process context

Sagi Grimberg (9):
      iscsi,iser-target: Initiate termination only once
      iser-target: Fix flush + disconnect completion handling
      iser-target: Parallelize CM connection establishment
      iser-target: Fix connected_handler + teardown flow race
      iser-target: Handle ADDR_CHANGE event for listener cm_id
      iser-target: Fix implicit termination of connections
      iser-target: Allocate PI contexts dynamically
      iser-target: Fix NULL dereference in SW mode DIF
      iscsi,iser-target: Expose supported protection ops according to t10_pi

Sakari Ailus (2):
      [media] smiapp: Take mutex during PLL update in sensor initialisation
      [media] smiapp-pll: Correct clock debug prints

Sasha Levin (1):
      KEYS: close race between key lookup and freeing

Scot Doyle (1):
      drm/i915: don't warn if backlight unexpectedly enabled

Sonny Rao (1):
      clocksource: arch_timer: Fix code to use physical timers when requested

Sreekanth Reddy (2):
      Revert "[SCSI] mpt2sas: Remove phys on topology change."
      Revert "[SCSI] mpt3sas: Remove phys on topology change"

Stefano Stabellini (4):
      swiotlb-xen: pass dev_addr to xen_dma_unmap_page and xen_dma_sync_single_for_cpu
      swiotlb-xen: remove BUG_ON in xen_bus_to_phys
      swiotlb-xen: call xen_dma_sync_single_for_device when appropriate
      swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single

Stephane Grosjean (2):
      can: peak_usb: fix memset() usage
      can: peak_usb: fix cleanup sequence order in case of error during init

Steven Rostedt (Red Hat) (2):
      ftrace/x86: Add frames pointers to trampoline as necessary
      tracing/sched: Check preempt_count() for current when reading task->state

Sumit.Saxena@avagotech.com (1):
      megaraid_sas: corrected return of wait_event from abort frame path

Sven Eckelmann (1):
      batman-adv: Calculate extra tail size based on queued fragments

Takashi Iwai (6):
      [media] uvcvideo: Fix destruction order in uvc_delete()
      ALSA: hda - Fix built-in mic at resume on Lenovo Ideapad S210
      ALSA: usb-audio: Don't resubmit pending URBs at MIDI error recovery
      KEYS: Fix stale key registration at error path
      ALSA: hda - Add EAPD fixup for ASUS Z99He laptop
      blk-mq: Fix uninitialized kobject at CPU hotplugging

Tejun Heo (1):
      writeback: fix a subtle race condition in I_DIRTY clearing

Tetsuo Handa (1):
      drm/ttm: Avoid memory allocation from shrinker functions.

Thomas Gleixner (2):
      genirq: Prevent proc race against freeing of irq descriptors
      tick/powerclamp: Remove tick_nohz_idle abuse

Thomas Hellstrom (2):
      drm/vmwgfx: Fix error printout on signals pending
      drm/vmwgfx: Fix fence event code

Thomas Huth (1):
      KVM: s390: Fix size of monitor-class number field

Thomas Petazzoni (3):
      ARM: mvebu: disable I/O coherency on non-SMP situations on Armada 370/375/38x/XP
      i2c: mv64xxx: use BIT() macro for register value definitions
      i2c: mv64xxx: rework offload support to fix several problems

Tony Lindgren (2):
      mfd: twl4030-power: Fix regression with missing compatible flag
      pstore-ram: Allow optional mapping with pgprot_noncached

Tyler Hicks (1):
      eCryptfs: Force RO mount when encrypted view is enabled

Ulf Hansson (1):
      mmc: omap_hsmmc: Fix UHS card with DDR50 support

Uwe Kleine-König (1):
      ARM: mvebu: fix ordering in Armada 370 .dtsi

Vineet Gupta (1):
      ARC: [nsimosci] move peripherals to match model to FPGA

Vitaly Kuznetsov (2):
      Drivers: hv: util: make struct hv_do_fcopy match Hyper-V host messages
      Drivers: hv: vmbus: Fix a race condition when unregistering a device

zhendong chen (1):
      dm: fix missed error code if .end_io isn't implemented by target_type

