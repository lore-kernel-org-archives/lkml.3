Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaLAKFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:05:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36877 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbaLAKFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:05:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.16.y-ckt stable] Linux 3.16.7-ckt2
Date: Mon,  1 Dec 2014 10:05:10 +0000
Message-Id: <1417428311-14686-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
X-Extended-Stable: 3.16
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.16.7-ckt2 kernel.

The updated 3.16.y-ckt tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.16.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.16.y;a=shortlog

The diff from v3.16.7-ckt1 is posted as a follow-up to this email.

The 3.16.y-ckt extended stable tree is maintained by the Canonical Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 .../devicetree/bindings/ata/sata_rcar.txt          |   3 +-
 Makefile                                           |   2 +-
 arch/arm/boot/compressed/head.S                    |  20 ++-
 arch/arm/boot/dts/am335x-evm.dts                   |   2 +-
 arch/arm/mach-mvebu/board-v7.c                     |   2 +-
 arch/arm/mm/Kconfig                                |   1 +
 arch/arm64/kernel/efi-entry.S                      |  27 +++-
 arch/arm64/kernel/insn.c                           |   5 +-
 arch/arm64/lib/clear_user.S                        |   2 +-
 arch/parisc/include/uapi/asm/shmbuf.h              |  25 ++-
 arch/parisc/kernel/syscall_table.S                 |   8 +-
 arch/powerpc/kernel/entry_64.S                     |   6 +
 arch/powerpc/platforms/powernv/opal-lpc.c          |  59 +++++++
 arch/powerpc/platforms/pseries/dlpar.c             |   4 +-
 arch/s390/kernel/topology.c                        |  18 ++-
 arch/sparc/include/asm/atomic_32.h                 |   2 +-
 arch/sparc/include/asm/cmpxchg_32.h                |  12 +-
 arch/sparc/include/asm/vio.h                       |  14 +-
 arch/sparc/kernel/pci_schizo.c                     |   6 +-
 arch/sparc/kernel/smp_64.c                         |   4 +
 arch/sparc/lib/atomic32.c                          |  27 ++++
 arch/um/drivers/ubd_kern.c                         |   5 +-
 arch/x86/boot/compressed/Makefile                  |   4 +-
 arch/x86/boot/compressed/head_32.S                 |   5 +-
 arch/x86/boot/compressed/head_64.S                 |   5 +-
 arch/x86/boot/compressed/misc.c                    |  13 +-
 arch/x86/boot/compressed/mkpiggy.c                 |   9 +-
 arch/x86/include/asm/elf.h                         |   5 +-
 arch/x86/kernel/cpu/intel.c                        |  17 +-
 arch/x86/kernel/cpu/microcode/amd_early.c          |  33 ++--
 arch/x86/kernel/iosf_mbi.c                         |   2 +
 arch/x86/kernel/ptrace.c                           |  11 +-
 arch/x86/kernel/signal.c                           |   5 +
 arch/x86/kernel/xsave.c                            |   7 +-
 arch/x86/kvm/emulate.c                             |   8 +
 arch/x86/kvm/x86.c                                 |   2 +-
 arch/x86/tools/calc_run_size.pl                    |  30 ++++
 arch/xtensa/include/uapi/asm/unistd.h              |   3 +-
 block/blk-mq-tag.c                                 |   4 +-
 block/blk-settings.c                               |   4 +-
 block/ioprio.c                                     |  14 +-
 crypto/algif_skcipher.c                            |   2 +-
 drivers/ata/ahci.c                                 |  19 ++-
 drivers/ata/libata-sff.c                           |  20 ++-
 drivers/ata/pata_serverworks.c                     |  13 +-
 drivers/ata/sata_rcar.c                            |  10 ++
 drivers/base/core.c                                |   4 +-
 drivers/block/drbd/drbd_interval.c                 |   4 +
 drivers/block/rbd.c                                |   9 +-
 drivers/block/sunvdc.c                             | 176 +++++++++++++++------
 drivers/block/xen-blkback/blkback.c                |   1 +
 drivers/block/xen-blkback/xenbus.c                 |   6 +-
 drivers/block/zram/zram_drv.c                      |   3 +-
 drivers/char/hw_random/pseries-rng.c               |  11 +-
 drivers/cpufreq/cpufreq.c                          |   3 +-
 drivers/cpufreq/intel_pstate.c                     |   1 +
 drivers/crypto/caam/caamhash.c                     |  22 ++-
 drivers/crypto/caam/key_gen.c                      |  29 ++--
 drivers/crypto/caam/sg_sw_sec4.h                   |  54 -------
 drivers/firewire/core-cdev.c                       |   3 +-
 drivers/gpu/drm/ast/ast_mode.c                     |   4 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  16 ++
 drivers/gpu/drm/i915/i915_gem_userptr.c            |   7 +-
 drivers/gpu/drm/nouveau/Makefile                   |   2 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv50.c  |  22 +--
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |  14 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |   3 +-
 drivers/gpu/drm/nouveau/core/include/subdev/gpio.h |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |  14 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     |   1 -
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c     |   1 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |   1 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c   |   4 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv92.c    |  74 ---------
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv94.c    |  74 +++++++++
 drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c    |   4 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/priv.h    |   4 +-
 drivers/gpu/drm/nouveau/core/subdev/ltcg/gf100.c   |   4 +-
 drivers/gpu/drm/nouveau/core/subdev/ltcg/gm107.c   |   2 +
 drivers/gpu/drm/nouveau/dispnv04/crtc.c            |   4 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |  23 ++-
 drivers/gpu/drm/nouveau/nouveau_display.h          |   5 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  51 ++----
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            | 111 ++++++++-----
 drivers/gpu/drm/nouveau/nouveau_fbcon.h            |   5 +-
 drivers/gpu/drm/radeon/atom.c                      |  11 +-
 drivers/gpu/drm/radeon/atom.h                      |   2 +
 drivers/gpu/drm/radeon/atombios_dp.c               |   4 +-
 drivers/gpu/drm/radeon/atombios_i2c.c              |   4 +-
 drivers/gpu/drm/radeon/cik.c                       |   7 +-
 drivers/gpu/drm/radeon/cik_sdma.c                  |  21 +--
 drivers/gpu/drm/radeon/dce3_1_afmt.c               |   2 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                 |   2 +-
 drivers/gpu/drm/radeon/evergreen.c                 |   4 +
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |   2 +-
 drivers/gpu/drm/radeon/r100.c                      |   3 +
 drivers/gpu/drm/radeon/r600_dma.c                  |  20 +--
 drivers/gpu/drm/radeon/radeon_device.c             |   1 +
 drivers/gpu/drm/radeon/rs600.c                     |   3 +
 drivers/gpu/drm/radeon/rs690.c                     |   3 +
 drivers/gpu/drm/radeon/rv515.c                     |   3 +
 drivers/gpu/drm/radeon/si.c                        |   3 +
 drivers/gpu/drm/ttm/ttm_bo.c                       |  21 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  16 +-
 drivers/hid/hid-debug.c                            |   6 +
 drivers/hid/hid-ids.h                              |   7 +
 drivers/hid/hid-input.c                            |  12 +-
 drivers/hid/usbhid/hid-core.c                      |  26 ++-
 drivers/hid/usbhid/hid-quirks.c                    |   5 +
 drivers/i2c/busses/i2c-at91.c                      |   2 +-
 drivers/i2c/i2c-core.c                             |   3 +
 drivers/iio/proximity/as3935.c                     |   2 +-
 drivers/infiniband/core/uverbs_cmd.c               |   2 +
 drivers/input/mouse/alps.c                         |  28 +++-
 drivers/input/mouse/synaptics.c                    |  27 +++-
 drivers/input/mouse/synaptics.h                    |   8 +-
 drivers/input/serio/i8042-x86ia64io.h              |   6 +
 drivers/irqchip/irq-armada-370-xp.c                |  23 ++-
 drivers/md/dm-bufio.c                              |  17 +-
 drivers/md/dm-log-userspace-transfer.c             |   2 +-
 drivers/md/dm-raid.c                               |  11 +-
 drivers/md/dm-thin.c                               |  16 +-
 drivers/md/md.c                                    |   4 +
 drivers/md/persistent-data/dm-btree-internal.h     |   6 +
 drivers/md/persistent-data/dm-btree-spine.c        |   2 +-
 drivers/md/persistent-data/dm-btree.c              |  24 ++-
 drivers/media/common/siano/sms-cards.c             |   6 +
 drivers/media/common/siano/sms-cards.h             |   1 +
 drivers/media/dvb-frontends/ds3000.c               |   7 +
 drivers/media/i2c/tda7432.c                        |   2 +-
 drivers/media/tuners/m88ts2022.c                   |   2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  10 +-
 drivers/media/usb/siano/smsusb.c                   |   2 +
 drivers/media/usb/ttusb-dec/ttusbdecfe.c           |   3 +
 drivers/media/usb/uvc/uvc_driver.c                 |   9 ++
 drivers/media/v4l2-core/v4l2-common.c              |   9 +-
 drivers/mfd/rtsx_pcr.c                             |   2 +-
 drivers/mfd/ti_am335x_tscadc.c                     |   5 +-
 drivers/mfd/twl4030-power.c                        |  52 ++++++
 drivers/mmc/core/sdio.c                            |  12 +-
 drivers/mmc/core/sdio_irq.c                        |   4 +-
 drivers/mmc/core/slot-gpio.c                       |   2 -
 drivers/mmc/host/mmc_spi.c                         |   1 +
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |   7 +
 drivers/mmc/host/rtsx_usb_sdmmc.c                  |   7 +
 drivers/mmc/host/sdhci-pci.c                       |  12 ++
 drivers/mmc/host/sdhci-pci.h                       |   1 +
 drivers/mmc/host/sdhci-pxav3.c                     |   3 +-
 drivers/mmc/host/sdhci-s3c.c                       |   4 +-
 drivers/mmc/host/sdhci-sirf.c                      |   1 +
 drivers/mmc/host/tmio_mmc_pio.c                    |   1 +
 drivers/mtd/ubi/fastmap.c                          |   1 +
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  18 ++-
 drivers/net/ethernet/smsc/smsc911x.c               |  46 ++++++
 drivers/net/ethernet/sun/sunvnet.c                 |   4 +-
 drivers/net/macvtap.c                              |   2 +
 drivers/net/ppp/ppp_generic.c                      |   2 +-
 drivers/net/tun.c                                  |  16 +-
 drivers/net/vxlan.c                                |  29 ++--
 drivers/net/wireless/iwlwifi/mvm/fw.c              |  10 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |   1 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h             |   1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c             |  11 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |   4 +-
 drivers/net/wireless/mac80211_hwsim.c              |   4 +-
 drivers/of/base.c                                  |  88 +++--------
 drivers/of/selftest.c                              |  66 +++++++-
 drivers/of/testcase-data/tests-phandle.dtsi        |   2 +
 drivers/phy/phy-omap-usb2.c                        |   6 +-
 drivers/pinctrl/pinctrl-baytrail.c                 |   2 +-
 drivers/platform/x86/acer-wmi.c                    |  11 ++
 drivers/platform/x86/dell-wmi.c                    |  12 +-
 drivers/platform/x86/ideapad-laptop.c              |   7 +
 drivers/platform/x86/samsung-laptop.c              |  10 ++
 drivers/power/bq2415x_charger.c                    |  23 ++-
 drivers/power/charger-manager.c                    | 168 +++++++++++++-------
 drivers/regulator/max77693.c                       |   2 +-
 drivers/scsi/scsi_error.c                          |   4 +-
 drivers/spi/spi-fsl-dspi.c                         |   4 +-
 drivers/spi/spi-pxa2xx.c                           |   7 +-
 drivers/staging/iio/meter/ade7758.h                |   1 -
 drivers/staging/iio/meter/ade7758_core.c           |  57 ++-----
 drivers/staging/iio/meter/ade7758_ring.c           |   5 +-
 drivers/tty/serial/msm_serial.c                    |  22 +--
 drivers/tty/serial/serial_core.c                   |   2 +-
 drivers/tty/tty_io.c                               |  15 +-
 drivers/tty/vt/consolemap.c                        |   7 +
 drivers/usb/class/cdc-acm.c                        |  20 ++-
 drivers/usb/class/cdc-acm.h                        |   2 +
 drivers/usb/core/hcd.c                             |   2 +
 drivers/usb/core/hub.c                             |   3 +
 drivers/usb/core/quirks.c                          |  10 ++
 drivers/usb/host/xhci-pci.c                        |  18 +--
 drivers/usb/serial/kobil_sct.c                     |   5 +-
 drivers/usb/serial/opticon.c                       |   2 +-
 drivers/usb/storage/transport.c                    |  26 +++
 drivers/usb/storage/unusual_uas.h                  |  28 ++++
 drivers/video/console/bitblit.c                    |   3 +-
 drivers/video/console/fbcon_ccw.c                  |   3 +-
 drivers/video/console/fbcon_cw.c                   |   3 +-
 drivers/video/console/fbcon_ud.c                   |   3 +-
 drivers/video/fbdev/core/cfbcopyarea.c             |  13 +-
 drivers/virtio/virtio_pci.c                        |  33 +++-
 fs/btrfs/file-item.c                               |   2 +-
 fs/buffer.c                                        |   5 +
 fs/dcache.c                                        |   5 +
 fs/gfs2/dir.c                                      |   9 +-
 fs/gfs2/dir.h                                      |   1 +
 fs/gfs2/inode.c                                    |   6 +-
 fs/jffs2/jffs2_fs_sb.h                             |   2 -
 fs/jffs2/wbuf.c                                    |  17 +-
 fs/lockd/mon.c                                     |   6 +
 fs/nfs/delegation.c                                |  25 ++-
 fs/nfs/delegation.h                                |   1 +
 fs/nfs/direct.c                                    |   1 +
 fs/nfs/filelayout/filelayout.c                     |   3 -
 fs/nfs/inode.c                                     |   2 +-
 fs/nfs/nfs4proc.c                                  |  76 +++++----
 fs/ocfs2/cluster/tcp.c                             |   2 +-
 fs/super.c                                         |   2 +
 fs/ubifs/commit.c                                  |  10 +-
 fs/ubifs/log.c                                     |  19 ++-
 fs/ubifs/master.c                                  |   7 +-
 fs/ubifs/super.c                                   |   1 -
 fs/ubifs/ubifs.h                                   |   2 -
 include/dt-bindings/pinctrl/dra.h                  |   4 +-
 include/linux/blkdev.h                             |   5 +-
 include/linux/bootmem.h                            |   1 +
 include/linux/clocksource.h                        |   2 +-
 include/linux/crash_dump.h                         |  15 +-
 include/linux/hid.h                                |   1 +
 include/linux/kgdb.h                               |   2 +-
 include/linux/memory.h                             |   2 +-
 include/linux/nfs_xdr.h                            |  11 ++
 include/linux/of.h                                 |  84 ++++++++--
 include/linux/power/charger-manager.h              |   3 -
 include/linux/ring_buffer.h                        |   2 +-
 include/linux/sunrpc/xprt.h                        |   1 +
 include/linux/usb/quirks.h                         |   3 +
 include/uapi/drm/vmwgfx_drm.h                      |   2 +-
 include/uapi/linux/input.h                         |   7 +
 include/uapi/linux/netfilter/xt_bpf.h              |   2 +
 init/main.c                                        |   2 +-
 ipc/ipc_sysctl.c                                   |   3 +-
 kernel/audit.c                                     |   4 +-
 kernel/audit_tree.c                                |   1 +
 kernel/events/core.c                               |  77 ++++++---
 kernel/module.c                                    |   2 +
 kernel/rcu/tree.c                                  |   4 +-
 kernel/sched/core.c                                |  19 ++-
 kernel/trace/ring_buffer.c                         |  81 ++++++----
 kernel/trace/trace.c                               |  23 +--
 mm/bootmem.c                                       |   9 +-
 mm/iov_iter.c                                      |   4 +-
 mm/memory_hotplug.c                                |  26 +++
 mm/nobootmem.c                                     |   8 +-
 mm/percpu.c                                        |   2 -
 net/ceph/crypto.c                                  | 169 +++++++++++++++-----
 net/ceph/messenger.c                               |   6 +-
 net/ipv4/ip_sockglue.c                             |   2 +-
 net/ipv4/tcp_output.c                              |   3 +-
 net/ipv6/ip6_gre.c                                 |   5 +-
 net/ipv6/ip6_tunnel.c                              |  10 +-
 net/ipv6/ip6_vti.c                                 |  11 +-
 net/ipv6/sit.c                                     |  15 +-
 net/mac80211/ibss.c                                |   2 +-
 net/mac80211/ieee80211_i.h                         |   3 +-
 net/mac80211/iface.c                               |   7 +-
 net/mac80211/mesh.c                                |   2 +-
 net/mac80211/mlme.c                                |   5 +-
 net/mac80211/rx.c                                  |  14 +-
 net/mac80211/spectmgmt.c                           |  18 +--
 net/netfilter/ipset/ip_set_core.c                  |   2 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_log.c                      |  31 ++--
 net/netfilter/nft_compat.c                         |   2 +-
 net/netlink/af_netlink.c                           |   7 +-
 net/sctp/auth.c                                    |   2 -
 net/sctp/sm_make_chunk.c                           |   3 +
 net/sunrpc/clnt.c                                  |   3 +
 net/sunrpc/xprtsock.c                              |   4 +
 security/integrity/evm/evm_main.c                  |   7 +
 security/selinux/hooks.c                           |   2 +-
 sound/pci/hda/hda_intel.c                          |   3 +
 sound/pci/hda/patch_conexant.c                     |  31 ++++
 sound/pci/hda/patch_hdmi.c                         |   2 +
 sound/pci/hda/patch_realtek.c                      |   4 +-
 sound/soc/codecs/tlv320aic3x.c                     |  13 ++
 sound/soc/soc-dapm.c                               |  25 +--
 sound/usb/card.c                                   |   9 +-
 sound/usb/mixer_quirks.c                           |   6 +
 292 files changed, 2491 insertions(+), 1220 deletions(-)

Adel Gadllah (4):
      USB: quirks: enable device-qualifier quirk for another Elan touchscreen
      USB: quirks: enable device-qualifier quirk for yet another Elan touchscreen
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 009b
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 016f

Al Viro (4):
      fix breakage in o2net_send_tcp_msg()
      missing data dependency barrier in prepend_name()
      [jffs2] kill wbuf_queued/wbuf_dwork_lock
      fix misuses of f_count() in ppp and netlink

Alan Stern (1):
      usb-storage: handle a skipped data phase

Alex Deucher (4):
      drm/radeon: make sure mode init is complete in bandwidth_update
      drm/radeon: use gart for DMA IB tests
      drm/radeon: add missing crtc unlock when setting up the MC
      drm/radeon: initialize sadb to NULL in the audio code

Alexander Stein (1):
      spi: fsl-dspi: Fix CTAR selection

Alexey Khoroshilov (1):
      dm log userspace: fix memory leak in dm_ulog_tfr_init failure path

Allen Pais (2):
      sunvdc: add cdrom and v1.1 protocol support
      sunvdc: compute vdisk geometry from capacity

Andreas Larsson (1):
      sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks

Andrew Lunn (1):
      ARM: mvebu: armada xp: Generalize use of i2c quirk

Andrey Vagin (1):
      ipc: always handle a new value of auto_msgmni

Andy Lutomirski (1):
      x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit

Anton Blanchard (1):
      powerpc: do_notify_resume can be called with bad thread_info flags argument

Antti Palosaari (1):
      [media] m88ts2022: fix 32bit overflow on filter calc

Artem Bityutskiy (3):
      UBIFS: remove mst_mutex
      UBIFS: fix a race condition
      UBIFS: fix free log space calculation

Arturo Borrero (1):
      netfilter: nft_compat: fix wrong target lookup in nft_target_select_ops()

Axel Lin (1):
      [media] tda7432: Fix setting TDA7432_MUTE bit for TDA7432_RF register

Bartlomiej Zolnierkiewicz (1):
      mmc: sdhci-s3c: fix runtime PM handling on sdhci_add_host() failure

Ben Hutchings (1):
      x86: Reject x32 executables if x32 ABI not supported

Ben Skeggs (10):
      drm/nouveau/kms: take more care when pulling down accelerated fbcon
      drm/nouveau/kms: restore acceleration before fb_set_suspend() resumes
      drm/nouveau: punt fbcon resume out to a workqueue
      drm/nouveau: make sure display hardware is reinitialised on runtime resume
      drm/nouveau/bar: behave better if ioremap failed
      drm/nvc0-/fb/ram: fix use of non-existant ram if partitions aren't uniform
      drm/nouveau/ltc: fix tag base address getting truncated if above 4GiB
      drm/nouveau: ltc/gf100-: fix cbc issues on certain boards
      drm/nv50/disp: fix dpms regression on certain boards
      drm/nouveau/bios: memset dcb struct to zero before parsing

Benjamin Coddington (2):
      lockd: Try to reconnect if statd has moved
      SUNRPC: Don't wake tasks during connection abort

Benjamin Herrenschmidt (2):
      powerpc/powernv: Properly fix LPC debugfs endianness
      drm/ast: Fix HW cursor image

Bjorn Helgaas (4):
      memory-hotplug: Remove "weak" from memory_block_size_bytes() declaration
      vmcore: Remove "weak" from function declarations
      kgdb: Remove "weak" from kgdb_arch_pc() declaration
      clocksource: Remove "weak" from clocksource_default_clock() declaration

Bob Peterson (1):
      GFS2: Make rename not save dirent location

Borislav Petkov (2):
      x86, microcode, AMD: Fix early ucode loading on 32-bit
      x86, microcode, AMD: Fix ucode patch stashing on 32-bit

Bryan O'Donoghue (1):
      x86: Add cpu_detect_cache_sizes to init_intel() add Quark legacy_cache()

Chris Ball (1):
      mfd: rtsx_pcr: Fix MSI enable error handling

Chris Mason (1):
      Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error cleanup

Christoph Hellwig (1):
      scsi: only re-lock door after EH on devices that were reset

Cristian Stoica (2):
      crypto: caam - fix missing dma unmap on error path
      crypto: caam - remove duplicated sg copy functions

Dan Carpenter (2):
      netfilter: ipset: off by one in ip_set_nfnl_get_byindex()
      [media] ttusb-dec: buffer overflow in ioctl

Dan Streetman (1):
      powerpc: use device_online/offline() instead of cpu_up/down()

Daniel Borkmann (2):
      net: sctp: fix NULL pointer dereference in af->from_addr_param on malformed packet
      net: sctp: fix memory leak in auth key management

Daniel Mack (1):
      ASoC: soc-dapm: fix use after free

Daniel Thompson (1):
      param: fix crash on bad kernel arguments

Dave Airlie (1):
      drm/radeon: add locking around atombios scratch space usage

David Cohen (1):
      pinctrl: baytrail: show output gpio state correctly on Intel Baytrail

David E. Box (1):
      x86/platform/intel/iosf: Add Braswell PCI ID

David S. Miller (2):
      sparc64: Fix crashes in schizo_pcierr_intr_other().
      sparc64: Do irq_{enter,exit}() around generic_smp_call_function*().

Derek Browne (1):
      mmc: sdhci-pci: SDIO host controller support for Intel Quark X1000

Devesh Sharma (1):
      IB/core: Clear AH attr variable to prevent garbage data

Dmitry Eremin-Solenikov (1):
      spi: pxa2xx: toggle clocks on suspend if not disabled by runtime PM

Dmitry Kasatkin (1):
      evm: properly handle INTEGRITY_NOXATTRS EVM status

Dmitry Lavnikevich (1):
      ASoC: tlv320aic3x: fix PLL D configuration

Dmitry Torokhov (1):
      Input: synaptics - gate forcepad support by DMI check

Dwight Engen (3):
      sunvdc: limit each sg segment to a page
      vio: fix reuse of vio_dring slot
      sunvdc: don't call VD_OP_GET_VTOC

Emil Velikov (1):
      drm/nouveau/gpio: rename g92 class to g94

Emmanuel Grumbach (1):
      iwlwifi: fix RFkill while calibrating

Enric Balletbo i Serra (1):
      smsc911x: power-up phydev before doing a software reset.

Eric Dumazet (2):
      net: skb_fclone_busy() needs to detect orphaned skb
      ipv6: fix IPV6_PKTINFO with v4 mapped

Florian Westphal (2):
      netfilter: nf_log: account for size of NLMSG_DONE attribute
      netfilter: nfnetlink_log: fix maximum packet length logged to userspace

Frank Schaefer (1):
      [media] em28xx-v4l: give back all active video buffers to the vb2 core properly on streaming stop

Fu Zhonghui (1):
      mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread

Geert Uytterhoeven (1):
      cpufreq: Avoid crash in resume on SMP without OPP

George McCollister (1):
      iio: as3935: allocate correct iio_device size

Grant Likely (1):
      of: Fix overflow bug in string property parsing functions

Greg Kurz (1):
      hwrng: pseries - port to new read API and fix stack corruption

Grzegorz Jaszczyk (2):
      irqchip: armada-370-xp: Fix MSI interrupt handling
      irqchip: armada-370-xp: Fix MPIC interrupt handling

Guenter Roeck (1):
      Revert "percpu: free percpu allocation info for uniprocessor system"

Hans de Goede (8):
      samsung-laptop: Add broken-acpi-video quirk for NC210/NC110
      acer-wmi: Add acpi_backlight=video quirk for the Acer KAV80
      usb: Do not allow usb_alloc_streams on unconfigured devices
      uas: Add US_FL_NO_ATA_1X quirk for 1 more Seagate model
      xhci: Disable streams on Asmedia 1042 xhci controllers
      uas: Add NO_ATA_1X for VIA VL711 devices
      uas: Add US_FL_NO_ATA_1X quirk for 2 more Seagate models
      Input: i8042 - add noloop quirk for Asus X750LN

Heinz Mauelshagen (1):
      dm raid: ensure superblock's size matches device's logical block size

Helge Deller (1):
      parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop syscalls

Herbert Xu (2):
      tun: Fix csum_start with VLAN acceleration
      macvtap: Fix csum_start when VLAN tags are present

Hiroaki SHIMODA (1):
      netlink: Properly unbind in error conditions.

Houcheng Lin (1):
      netfilter: nf_log: release skbuff on nlmsg put failure

Ilya Dryomov (4):
      libceph: ceph-msgr workqueue needs a resque worker
      rbd: avoid format-security warning inside alloc_workqueue()
      rbd: rbd workqueues need a resque worker
      libceph: do not crash on large auth tickets

Imre Deak (1):
      tty/vt: don't set font mappings on vc not supporting this

James Ralston (1):
      ahci: Add Device IDs for Intel Sunrise Point PCH

Jammy Zhou (1):
      drm/radeon: set correct CE ram size for CIK

Jan Kara (3):
      rbd: Fix error recovery in rbd_obj_read_sync()
      block: Fix computation of merged request priority
      nfs: Fix use of uninitialized variable in nfs_getattr()

Jason Gerecke (1):
      HID: input: Fix TransducerSerialNumber implementation

Jens Axboe (1):
      blk-mq: fix potential hang if rolling wakeup depth is too high

Joe Thornber (3):
      dm bufio: update last_accessed when relinking a buffer
      dm thin: grab a virtual cell before looking up the mapping
      dm btree: fix a recursion depth bug in btree walking code

Johan Hovold (9):
      USB: kobil_sct: fix non-atomic allocation in write path
      USB: opticon: fix non-atomic allocation in write path
      USB: cdc-acm: add device id for GW Instek AFG-2225
      USB: core: add device-qualifier quirk
      USB: quirks: enable device-qualifier quirk for Elan Touchscreen
      USB: cdc-acm: only raise DTR on transitions from B0
      USB: cdc-acm: add quirk for control-line state requests
      HID: usbhid: add always-poll quirk
      HID: usbhid: enable always-poll quirk for Elan Touchscreen

Johannes Berg (2):
      mac80211: properly flush delayed scan work on interface removal
      mac80211: fix use-after-free in defragmentation

Josh Boyer (1):
      drm/vmwgfx: Fix drm.h include

Junjie Mao (2):
      x86, kaslr: Prevent .bss from overlaping initrd
      mac80211_hwsim: release driver when ieee80211_register_hw fails

Karl Beldan (1):
      net: mv643xx_eth: reclaim TX skbs only when released by the HW

Kirill Tkhai (2):
      sched: Use dl_bw_of() under RCU read lock
      sched: Use rq->rd in sched_setaffinity() under RCU read lock

Krzysztof Kozlowski (6):
      regulator: max77693: Fix use of uninitialized regulator config
      power: charger-manager: Fix NULL pointer exception with missing cm-fuel-gauge
      power: bq2415x_charger: Properly handle ENODEV from power_supply_get_by_phandle
      power: bq2415x_charger: Fix memory leak on DTS parsing error
      power: charger-manager: Fix accessing invalidated power supply after fuel gauge unbind
      power: charger-manager: Fix accessing invalidated power supply after charger unbind

Kyle McMartin (1):
      arm64: __clear_user: handle exceptions on strb

Lai Jiangshan (1):
      drbd: compute the end before rb_insert_augmented()

Lars-Peter Clausen (3):
      staging:iio:ade7758: Fix NULL pointer deref when enabling buffer
      staging:iio:ade7758: Fix check if channels are enabled in prenable
      staging:iio:ade7758: Remove "raw" from channel name

Laurent Pinchart (1):
      i2c: core: Dispose OF IRQ mapping at client removal time

Libin Yang (2):
      ALSA: hda - add PCI IDs for Intel Braswell
      ALSA: hda - add codec ID for Braswell display audio codec

Luciano Coelho (2):
      mac80211: use secondary channel offset IE also beacons during CSA
      mac80211: schedule the actual switch of the station before CSA count 0

Luis Henriques (1):
      Linux 3.16.7-ckt2

Lukas Bossard (1):
      ALSA: hda - Add ultra dock support for Thinkpad X240.

Maciej Matraszek (1):
      [media] v4l2-common: fix overflow in v4l_bound_align_image()

Marcelo Leitner (1):
      vxlan: Do not reuse sockets for a different address family

Mark Rutland (1):
      arm64: efi: Fix stub cache maintenance

Martin Schwidefsky (1):
      s390/topology: call set_sched_topology early

Mauro Carvalho Chehab (1):
      [media] siano: add support for PCTV 77e

Max Filippov (1):
      xtensa: re-wire umount syscall to sys_oldumount

Michael S. Tsirkin (1):
      virtio_pci: fix virtio spec compliance on restore

Michel Dänzer (1):
      drm/ttm: Don't evict BOs outside of the requested placement range

Mika Westerberg (1):
      cpufreq: intel_pstate: Add CPU ID for Braswell processor

Mike Snitzer (1):
      block: fix alignment_offset math that assumes io_min is a power-of-2

Miklos Szeredi (1):
      audit: keep inode pinned

Mikulas Patocka (5):
      fs: make cont_expand_zero interruptible
      dm bufio: when done scanning return from __scan immediately
      framebuffer: fix screen corruption when copying
      framebuffer: fix border color
      dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks

Nadav Amit (2):
      KVM: x86: Fix uninitialized op->type for some immediate values
      KVM: x86: Don't report guest userspace emulation error to userspace

Nathan Lynch (1):
      ARM: 8198/1: make kuser helpers depend on MMU

NeilBrown (1):
      md: Always set RECOVERY_NEEDED when clearing RECOVERY_FROZEN

Oleg Nesterov (2):
      x86, fpu: __restore_xstate_sig()->math_state_restore() needs preempt_disable()
      x86, fpu: shift drop_init_fpu() from save_xstate_sig() to handle_signal()

Oliver Neukum (3):
      xhci: no switching back on non-ULT Haswell
      HID: usbhid: fix PIXART optical mouse
      HID: usbhid: add another mouse that needs QUIRK_ALWAYS_POLL

Olivier Gay (1):
      HID: add keyboard input assist hid usages

Ondrej Kozina (1):
      crypto: algif - avoid excessive use of socket buffer in skcipher

Ondrej Zary (1):
      libata-sff: Fix controllers with no ctl port

Oussama Ghorbel (1):
      phy: omap-usb2: Enable runtime PM of omap-usb2 phy properly

Pablo Neira (1):
      netfilter: xt_bpf: add mising opaque struct sk_filter definition

Pali Rohár (4):
      Input: alps - ignore potential bare packets when device is out of sync
      Input: alps - allow up to 2 invalid packets without resetting device
      Input: alps - ignore bad data on Dell Latitudes E6440 and E7440
      dell-wmi: Fix access out of memory

Paul Fertser (1):
      [media] media: usb: uvc: add a quirk for Dell XPS M1330 webcam

Paul Mackerras (1):
      Fix thinko in iov_iter_single_seg_count

Pawel Moll (1):
      perf: Handle compat ioctl

Peng Tao (1):
      nfs: fix pnfs direct write memory leak

Peter Griffin (1):
      mmc: sdhci-pxav3: set_uhs_signaling is initialized twice differently

Peter Hurley (3):
      serial: Fix divide-by-zero fault in uart_get_divisor()
      tty: Fix high cpu load if tty is unreleaseable
      tty: Prevent "read/write wait queue active!" log flooding

Peter Zijlstra (1):
      perf: Fix unclone_ctx() vs. locking

Pranith Kumar (1):
      rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads

Prarit Bhargava (1):
      modules, lock around setting of MODULE_STATE_UNFORMED

Rabin Vincent (1):
      tracing: Do not busy wait in buffer splice

Richard Genoud (1):
      UBI: add missing kmem_cache_free() in process_pool_aeb error path

Richard Guy Briggs (2):
      audit: AUDIT_FEATURE_CHANGE message format missing delimiting space
      audit: correct AUDIT_GET_FEATURE return message type

Rodrigo Vivi (1):
      drm/i915: Disable caches for Global GTT.

Roger Pau Monné (1):
      xen-blkback: fix leak on grant map error path

Roger Quadros (2):
      pinctrl: dra: dt-bindings: Fix output pull up/down
      ARM: dts: am335x-evm: Fix 5th NAND partition's name

Roger Tseng (2):
      mmc: rtsx_usb_sdmmc: fix incorrect last byte in R2 response
      mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response

Sabrina Dubroca (1):
      netfilter: nf_tables: check for NULL in nf_tables_newchain pcpu stats allocation

Scott Carter (1):
      pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE Controller

Sebastian Andrzej Siewior (1):
      mfd: ti_am335x_tscadc: Fix TSC resume

Simon Horman (1):
      ata: sata_rcar: Disable DIPM mode for r8a7790 ES1

Sinclair Yeh (1):
      drm/vmwgfx: Filter out modes those cannot be supported by the current VRAM size.

Stefan Richter (1):
      firewire: cdev: prevent kernel stack leaking into ioctl arguments

Steffen Klassert (4):
      ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.
      vti6: Use vti6_dev_init as the ndo_init function.
      sit: Use ipip6_tunnel_init as the ndo_init function.
      gre6: Move the setting of dev->iflink into the ndo_init functions.

Stephan Mueller (1):
      quirk for Lenovo Yoga 3: no rfkill switch

Stephen Boyd (1):
      serial: msm_serial: Fix kgdb continue

Stephen Smalley (1):
      selinux: fix inode security list corruption

Stephen Warren (1):
      mmc: don't request CD IRQ until mmc_start_host()

Takashi Iwai (5):
      ALSA: hda - Add dock support for Thinkpad T440 (17aa:2212)
      ALSA: usb-audio: Fix device_del() sysfs warnings at disconnect
      Input: synaptics - add min/max quirk for Lenovo T440s
      ALSA: usb-audio: Fix memory leak in FTU quirk
      ALSA: hda - Add mute LED control for Lenovo Ideapad Z560

Tang Chen (2):
      mem-hotplug: reset node managed pages when hot-adding a new pgdat
      mem-hotplug: reset node present pages when hot-adding a new pgdat

Tejun Heo (1):
      ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks

Tetsuo Handa (1):
      fs: Fix theoretical division by 0 in super_cache_scan().

Thorsten Knabe (1):
      um: ubd: Fix for processes stuck in D state forever

Tony Lindgren (1):
      mfd: twl4030-power: Fix poweroff with PM configuration enabled

Trond Myklebust (6):
      SUNRPC: Add missing support for RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT
      NFSv4: Ensure that we remove NFSv4.0 delegations when state has expired
      NFSv4.1: nfs41_clear_delegation_stateid shouldn't trust NFS_DELEGATED_STATE
      NFSv4: Fix races between nfs_remove_bad_delegation() and delegation return
      NFSv4: Ensure that we call FREE_STATEID when NFSv4.x stateids are revoked
      NFS: Don't try to reclaim delegation open state if recovery failed

Tvrtko Ursulin (1):
      drm/i915: Do not leak pages when freeing userptr objects

Ulrich Eckhardt (1):
      [media] ds3000: fix LNB supply voltage on Tevii S480 on initialization

Vignesh R (1):
      mfd: ti_am335x_tscadc: Fix TSC operation after ADC continouous mode

Vitaly Kuznetsov (1):
      xen/blkback: unmap all persistent grants when frontend gets disconnected

Wei Yongjun (1):
      rbd: fix error return code in rbd_dev_device_setup()

Weijie Yang (1):
      zram: avoid kunmap_atomic() of a NULL pointer

Will Deacon (1):
      ARM: 8191/1: decompressor: ensure I-side picks up relocated code

William Cohen (1):
      Correct the race condition in aarch64_insn_patch_text_sync()

Wolfram Sang (1):
      i2c: at91: don't account as iowait

Yijing Wang (1):
      sysfs: driver core: Fix glue dir race condition by gdp_mutex

