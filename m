Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3AUOSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:18:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57539 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3AUOSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:18:36 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: =?UTF-8?q?=5B3=2E5=2Ey=2Ez=20extended=20stable=5D=20Linux=203=2E5=2E7=2E3?=
Date: Mon, 21 Jan 2013 12:18:28 -0200
Message-Id: <1358777909-26850-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 3.5.7.3 tree of stable patches.

This tree picks up the latest 3.5 stable release upstream, and add patches
on top that were later marked for stable but can't be added to 3.5, as
it is not anymore an stable series maintained upstream.

The tree is maintained by the Ubuntu Kernel Team, with the intention
to continue to provide support for the 3.5 series. Anyone is welcomed
on using it or contributing to this effort.

For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

The updated 3.5.y tree can be found at: 

  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y

The diffstat and shortlog with changes since previous v3.5.7.2 release are
shown below.

-Herton

-- 
 Documentation/networking/ip-sysctl.txt             |    5 +
 Documentation/power/runtime_pm.txt                 |    9 +-
 Makefile                                           |   10 +-
 arch/arm/kernel/swp_emulate.c                      |    2 +
 arch/arm/mach-omap2/board-3430sdp.c                |    1 +
 arch/arm/mach-omap2/board-am3517evm.c              |    1 +
 arch/arm/mach-omap2/board-cm-t35.c                 |    1 +
 arch/arm/mach-omap2/board-devkit8000.c             |    1 +
 arch/arm/mach-omap2/board-omap3evm.c               |    1 +
 arch/arm/mach-omap2/board-omap3stalker.c           |    1 +
 arch/arm/mach-realview/include/mach/board-eb.h     |    2 +-
 arch/arm/mm/mmu.c                                  |    2 +-
 arch/cris/include/asm/io.h                         |   39 ++-
 arch/mips/kernel/process.c                         |    4 +-
 arch/powerpc/kernel/head_64.S                      |    2 +-
 arch/powerpc/kernel/time.c                         |    5 -
 arch/powerpc/kvm/e500_tlb.c                        |    2 +-
 arch/powerpc/platforms/40x/ppc40x_simple.c         |    3 +-
 arch/s390/kvm/kvm-s390.c                           |    2 +-
 arch/sparc/include/asm/hugetlb.h                   |   10 +-
 arch/x86/kernel/hpet.c                             |    4 +-
 arch/x86/pci/common.c                              |    3 +-
 drivers/acpi/battery.c                             |   77 +++++
 drivers/acpi/scan.c                                |    9 +-
 drivers/acpi/sleep.c                               |  340 ++++++++++----------
 drivers/acpi/video.c                               |   14 +
 drivers/ata/libata-core.c                          |    1 +
 drivers/ata/libata-eh.c                            |    1 +
 drivers/ata/libata-scsi.c                          |    6 +-
 drivers/ata/sata_promise.c                         |   15 +-
 drivers/atm/solos-pci.c                            |    5 +-
 drivers/base/power/main.c                          |    8 +-
 drivers/base/regmap/regmap-debugfs.c               |    2 +-
 drivers/bcma/driver_mips.c                         |    2 +-
 drivers/block/aoe/aoe.h                            |    2 +-
 drivers/block/aoe/aoeblk.c                         |    5 -
 drivers/bluetooth/btusb.c                          |    2 +
 drivers/firewire/net.c                             |   13 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c         |    5 +
 drivers/gpu/drm/i915/i915_debugfs.c                |    4 +-
 drivers/gpu/drm/i915/i915_drv.h                    |    1 +
 drivers/gpu/drm/i915/i915_gem_dmabuf.c             |    8 +-
 drivers/gpu/drm/i915/i915_irq.c                    |    4 +-
 drivers/gpu/drm/i915/i915_reg.h                    |    6 +
 drivers/gpu/drm/i915/intel_display.c               |  118 ++++---
 drivers/gpu/drm/i915/intel_drv.h                   |    9 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |   30 ++
 drivers/gpu/drm/i915/intel_lvds.c                  |    9 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |    2 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c            |    1 +
 drivers/gpu/drm/radeon/atombios_crtc.c             |    2 +
 drivers/gpu/drm/radeon/atombios_encoders.c         |    2 +-
 drivers/gpu/drm/radeon/evergreen.c                 |   18 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |    1 +
 drivers/gpu/drm/radeon/evergreend.h                |    5 +
 drivers/gpu/drm/radeon/ni.c                        |   16 +-
 drivers/gpu/drm/radeon/nid.h                       |   11 +
 drivers/gpu/drm/radeon/radeon_combios.c            |   51 +++
 drivers/gpu/drm/radeon/radeon_connectors.c         |   10 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   13 +-
 drivers/gpu/drm/radeon/radeon_i2c.c                |   10 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |    5 +-
 drivers/gpu/drm/radeon/radeon_prime.c              |    1 +
 drivers/gpu/drm/radeon/si.c                        |   25 +-
 drivers/gpu/drm/radeon/sid.h                       |   14 +
 drivers/hid/hid-core.c                             |    1 +
 drivers/hwmon/fam15h_power.c                       |    4 +
 drivers/hwmon/lm73.c                               |   16 +-
 drivers/infiniband/hw/nes/nes.h                    |    1 +
 drivers/infiniband/hw/nes/nes_hw.c                 |    9 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |    9 +-
 drivers/input/joystick/walkera0701.c               |    7 +-
 drivers/input/keyboard/gpio_keys.c                 |   16 +-
 drivers/input/mouse/sentelic.c                     |    2 +-
 drivers/input/serio/i8042-x86ia64io.h              |    9 +
 drivers/input/tablet/wacom_wac.c                   |    3 +-
 drivers/iommu/intel-iommu.c                        |   11 +-
 drivers/md/dm-ioctl.c                              |    8 +
 drivers/md/persistent-data/dm-btree-internal.h     |   16 +-
 drivers/md/persistent-data/dm-btree-remove.c       |   50 +--
 drivers/md/persistent-data/dm-btree-spine.c        |    6 +-
 drivers/md/persistent-data/dm-btree.c              |   22 +-
 drivers/mfd/mfd-core.c                             |   15 +-
 drivers/mfd/wm8994-core.c                          |    1 +
 drivers/misc/sgi-xp/xpc_main.c                     |   34 +-
 drivers/mtd/nand/cs553x_nand.c                     |    3 +-
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |    9 +
 drivers/net/bonding/bond_main.c                    |    7 +
 drivers/net/bonding/bond_sysfs.c                   |    2 +
 drivers/net/can/dev.c                              |    3 +-
 drivers/net/ethernet/8390/ne.c                     |    1 +
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |    9 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |   10 +-
 drivers/net/ethernet/realtek/8139cp.c              |   40 ++-
 drivers/net/ethernet/sis/sis900.c                  |    2 +-
 drivers/net/irda/sir_dev.c                         |    2 +-
 drivers/net/usb/cdc_ether.c                        |   15 +
 drivers/net/usb/ipheth.c                           |    5 +
 drivers/net/usb/qmi_wwan.c                         |   14 +
 drivers/net/wimax/i2400m/i2400m-usb.h              |    3 +
 drivers/net/wimax/i2400m/usb.c                     |    6 +
 drivers/net/wireless/ath/ath5k/base.c              |    4 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    2 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  172 +++++-----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |    6 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   12 +-
 drivers/net/wireless/ath/ath9k/calib.c             |    1 +
 drivers/net/wireless/ath/ath9k/calib.h             |    3 +
 drivers/net/wireless/b43/dma.c                     |    7 +-
 drivers/net/wireless/b43/main.c                    |   12 +-
 drivers/net/wireless/b43/pio.c                     |    4 +-
 drivers/net/wireless/b43legacy/b43legacy.h         |    5 +
 drivers/net/wireless/b43legacy/main.c              |   37 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          |   48 ++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c   |   12 +-
 drivers/net/wireless/p54/p54usb.c                  |    4 +
 drivers/net/wireless/rt2x00/rt2800lib.c            |    3 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    7 +-
 drivers/net/wireless/rtlwifi/usb.c                 |    7 +-
 drivers/pci/quirks.c                               |    7 +-
 drivers/pnp/pnpacpi/core.c                         |    5 +-
 drivers/regulator/wm831x-dcdc.c                    |    2 +-
 drivers/rtc/rtc-vt8500.c                           |   11 +-
 drivers/s390/cio/device_pgid.c                     |   10 +-
 drivers/scsi/mvsas/mv_94xx.h                       |   14 +-
 drivers/scsi/mvsas/mv_sas.c                        |    2 +-
 drivers/scsi/mvsas/mv_sas.h                        |    2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |    4 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   21 +-
 drivers/scsi/scsi_sysfs.c                          |   11 +-
 drivers/staging/bcm/InterfaceInit.c                |    3 +-
 drivers/staging/bcm/InterfaceInit.h                |    2 +-
 drivers/staging/comedi/Kconfig                     |    1 +
 drivers/staging/omapdrm/omap_gem_dmabuf.c          |    5 +
 drivers/staging/vt6656/dpc.c                       |    4 +-
 drivers/staging/vt6656/key.c                       |   53 ++-
 drivers/staging/vt6656/key.h                       |    8 +-
 drivers/staging/vt6656/mac.c                       |    6 +-
 drivers/staging/vt6656/rf.c                        |    3 +
 drivers/staging/vt6656/rxtx.c                      |   18 +-
 drivers/staging/vt6656/ttype.h                     |   16 +-
 drivers/staging/vt6656/wcmd.c                      |   20 +-
 drivers/staging/vt6656/wpa2.h                      |    4 +-
 drivers/target/iscsi/iscsi_target.c                |    4 +-
 drivers/target/iscsi/iscsi_target_erl2.c           |    2 +-
 drivers/target/iscsi/iscsi_target_login.c          |    8 +-
 drivers/target/iscsi/iscsi_target_nego.c           |   10 +-
 drivers/target/iscsi/iscsi_target_tmr.c            |    4 +-
 drivers/target/sbp/sbp_target.c                    |   17 +-
 drivers/target/target_core_file.c                  |    9 +-
 drivers/target/tcm_fc/tfc_sess.c                   |    2 +-
 drivers/usb/class/cdc-acm.c                        |   38 +++
 drivers/usb/core/message.c                         |   54 ++--
 drivers/usb/gadget/f_ecm.c                         |    4 +-
 drivers/usb/gadget/f_eem.c                         |    5 +-
 drivers/usb/gadget/f_midi.c                        |    1 +
 drivers/usb/gadget/f_ncm.c                         |    4 +-
 drivers/usb/gadget/f_phonet.c                      |    8 +-
 drivers/usb/gadget/f_rndis.c                       |    4 +-
 drivers/usb/gadget/f_subset.c                      |    4 +-
 drivers/usb/gadget/f_uvc.c                         |   39 +--
 drivers/usb/gadget/tcm_usb_gadget.c                |    1 +
 drivers/usb/host/ehci-pci.c                        |    3 +-
 drivers/usb/host/ohci-q.c                          |   19 ++
 drivers/usb/host/pci-quirks.c                      |    4 +-
 drivers/usb/host/xhci-mem.c                        |    9 +-
 drivers/usb/host/xhci-pci.c                        |    7 +-
 drivers/usb/host/xhci-ring.c                       |   32 +-
 drivers/usb/host/xhci.c                            |    4 +-
 drivers/usb/musb/cppi_dma.c                        |    1 +
 drivers/usb/serial/cp210x.c                        |    1 +
 drivers/usb/serial/ftdi_sio.c                      |    3 +-
 drivers/usb/serial/ftdi_sio_ids.h                  |    6 +
 drivers/usb/serial/option.c                        |   25 ++
 drivers/usb/storage/Kconfig                        |    2 +-
 drivers/video/mxsfb.c                              |    3 +-
 drivers/virtio/virtio_ring.c                       |    7 +
 fs/binfmt_misc.c                                   |    5 +-
 fs/binfmt_script.c                                 |    4 +-
 fs/cifs/readdir.c                                  |   19 +-
 fs/cifs/smb1ops.c                                  |    7 +
 fs/dcache.c                                        |    2 +-
 fs/eventpoll.c                                     |   22 +-
 fs/exec.c                                          |   15 +
 fs/ext4/acl.c                                      |    6 +-
 fs/ext4/extents.c                                  |   22 +-
 fs/ext4/ialloc.c                                   |    2 +-
 fs/ext4/inode.c                                    |    2 +
 fs/ext4/namei.c                                    |    2 +-
 fs/ext4/super.c                                    |   24 +-
 fs/jbd2/transaction.c                              |    3 +-
 fs/jffs2/nodemgmt.c                                |    6 +-
 fs/nfs/client.c                                    |    3 +-
 fs/nfs/dir.c                                       |   11 +-
 fs/nfs/direct.c                                    |    8 -
 fs/nfs/nfs4proc.c                                  |   21 +-
 fs/nfs/read.c                                      |   10 +-
 fs/nfs/super.c                                     |    2 +-
 fs/nfs/write.c                                     |   12 +-
 fs/nfsd/nfs4proc.c                                 |    8 +-
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/nfsd/nfs4xdr.c                                  |   11 +-
 fs/nfsd/nfssvc.c                                   |    2 +-
 fs/nfsd/vfs.c                                      |   10 +-
 fs/proc/array.c                                    |    2 +-
 fs/splice.c                                        |    4 +-
 fs/udf/inode.c                                     |   11 +-
 fs/xfs/xfs_qm.c                                    |   15 +-
 include/asm-generic/tlb.h                          |    9 +
 include/linux/binfmts.h                            |    1 +
 include/linux/cgroup.h                             |    1 -
 include/linux/freezer.h                            |   50 ++-
 include/linux/page-flags.h                         |    8 +-
 include/linux/pci_ids.h                            |    1 +
 include/linux/snmp.h                               |    3 +-
 include/net/inet_connection_sock.h                 |    1 +
 include/net/mac80211.h                             |    5 +
 include/net/tcp.h                                  |    1 +
 include/video/omap-panel-tfp410.h                  |    2 +-
 kernel/cgroup.c                                    |   69 ++--
 kernel/cgroup_freezer.c                            |   13 +-
 kernel/fork.c                                      |    9 +-
 kernel/irq/manage.c                                |   23 +-
 kernel/printk.c                                    |    5 +-
 kernel/rcutree.c                                   |   15 +-
 kernel/signal.c                                    |    1 +
 kernel/trace/ftrace.c                              |    2 +-
 kernel/trace/ring_buffer.c                         |    9 +-
 mm/dmapool.c                                       |   31 +-
 mm/memory.c                                        |    5 +
 mm/mempolicy.c                                     |   64 ++--
 mm/page-writeback.c                                |   25 +-
 net/batman-adv/bat_iv_ogm.c                        |    2 +-
 net/bluetooth/hci_core.c                           |    2 +
 net/bluetooth/rfcomm/sock.c                        |    4 +-
 net/dccp/ipv4.c                                    |    4 +-
 net/dccp/ipv6.c                                    |    3 +-
 net/ipv4/inet_connection_sock.c                    |   16 +
 net/ipv4/inet_diag.c                               |  154 +++++++--
 net/ipv4/ip_fragment.c                             |   19 +-
 net/ipv4/proc.c                                    |    3 +-
 net/ipv4/sysctl_net_ipv4.c                         |    7 +
 net/ipv4/tcp_input.c                               |   93 ++++--
 net/ipv4/tcp_ipv4.c                                |    6 +-
 net/ipv6/tcp_ipv6.c                                |    3 +-
 net/mac80211/status.c                              |    6 +-
 net/sched/sch_htb.c                                |    2 +-
 net/sctp/chunk.c                                   |   20 +-
 net/sctp/socket.c                                  |    4 +-
 net/sunrpc/clnt.c                                  |    2 +-
 net/sunrpc/rpc_pipe.c                              |    7 +-
 net/sunrpc/sched.c                                 |   27 +-
 sound/pci/hda/patch_conexant.c                     |    1 +
 sound/pci/hda/patch_hdmi.c                         |   18 +-
 sound/pci/hda/patch_realtek.c                      |   34 +-
 sound/pci/hda/patch_sigmatel.c                     |    2 +-
 sound/soc/codecs/sigmadsp.c                        |    2 +-
 sound/soc/codecs/wm8994.c                          |   13 +-
 sound/usb/midi.c                                   |   91 ++++--
 tools/perf/builtin-test.c                          |   38 +--
 virt/kvm/kvm_main.c                                |   13 +-
 262 files changed, 2348 insertions(+), 1164 deletions(-)

Aaro Koskinen (1):
      drm/nouveau: fix init with agpgart-uninorth

Aaron Lu (1):
      libata: set dma_mode to 0xff in reset

Akinobu Mita (1):
      batman-adv: fix random jitter calculation

Al Viro (1):
      ARM: missing ->mmap_sem around find_vma() in swp_emulate.c

Alan Cox (2):
      pnpacpi: fix incorrect TEST_ALPHA() test
      ne2000: add the right platform device

Alan Stern (2):
      USB: fix endpoint-disabling for failed config changes
      USB: OHCI: workaround for hardware bug: retired TDs not added to the Done Queue

Alasdair G Kergon (1):
      dm ioctl: prevent unsafe change to dm_ioctl data_size

Alex Deucher (5):
      drm: fix documentation for drm_crtc_set_mode()
      drm/radeon/dce32+: use fractional fb dividers for high clocks
      drm/radeon: fix eDP clk and lane setup for scaled modes
      drm/radeon: add WAIT_UNTIL to evergreen VM safe reg list
      drm/radeon: add connector table for Mac G4 Silver

Alex Williamson (1):
      KVM: Fix user memslot overlap check

Alexander Shiyan (1):
      irda: sir_dev: Fix copy/paste typo

Alexander Stein (1):
      can: Do not call dev_put if restart timer is running upon close

Alexey Khoroshilov (1):
      jffs2: hold erase_completion_lock on exit

Alexis R. Cortes (1):
      usb: host: xhci: Stricter conditional for Z1 system models for Compliance Mode Patch

Andy Lutomirski (1):
      PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz

Anton Blanchard (1):
      powerpc: Fix CONFIG_RELOCATABLE=y CONFIG_CRASH_DUMP=n build

Artem Bityutskiy (1):
      proc: pid/status: show all supplementary groups

Ben Hutchings (1):
      HID: Add Apple wireless keyboard 2011 ANSI to special driver list

Bjørn Mork (1):
      USB: option: blacklist network interface on Huawei E173

Boris Ostrovsky (1):
      x86,AMD: Power driver support for AMD's family 16h processors

Bryan Schumaker (1):
      NFS: Add sequence_priviliged_ops for nfs4_proc_sequence()

Charles Keepax (1):
      mfd: Only unregister platform devices allocated by the mfd core

Chris Boot (1):
      sbp-target: fix error path in sbp_make_tpg()

Chris Verges (1):
      hwmon: (lm73} Detect and report i2c bus errors

Chris Wilson (2):
      drm/i915: Close race between processing unpin task and queueing the flip
      drm/i915: Flush outstanding unpin tasks before pageflipping

Christian Borntraeger (1):
      s390/kvm: dont announce RRBM support

Christian König (1):
      drm/radeon: stop page faults from hanging the system (v2)

Christian Lamparter (1):
      p54usb: add USBIDs for two more p54usb devices

Christoffer Dall (1):
      mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED

Christoph Paasch (1):
      inet: Fix kmemleak in tcp_v4/6_syn_recv_sock and dccp_v4/6_request_recv_sock

Christophe TORDEUX (1):
      Input: sentelic - only report position of first finger as ST coordinates

Corey Minyard (1):
      CRIS: fix I/O macros

Dan Carpenter (1):
      ftrace: Clear bits properly in reset_iter_read()

Dan Williams (3):
      cdc-acm: implement TIOCSSERIAL to avoid blocking close(2)
      i2400m: add Intel 6150 device IDs
      qmi_wwan/cdc_ether: add Dell Wireless 5800 (Novatel E362) USB IDs

Daniel Vetter (3):
      drm/i915: drop buggy write to FDI_RX_CHICKEN register
      drm/i915: disable cpt phase pointer fdi rx workaround
      Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"

Dave Airlie (1):
      drm/i915: fix flags in dma buf exporting

Dave Chinner (1):
      xfs: fix stray dquot unlock when reclaiming dquots

Dave Kleikamp (1):
      sparc: huge_ptep_set_* functions need to call set_huge_pte_at()

David Henningsson (1):
      ALSA: hda - add mute LED for HP Pavilion 17 (Realtek codec)

David Jeffery (1):
      qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.

David S. Miller (1):
      Revert "8139cp: revert "set ring address before enabling receiver""

David Woodhouse (2):
      8139cp: set ring address after enabling C+ mode
      solos-pci: fix double-free of TX skb in DMA mode

Diego Calleja (1):
      Input: wacom - fix touch support for Bamboo Fun CTH-461

Dmitry Torokhov (1):
      Input: gpio_keys - defer probing if GPIO probing is deferred

Ed L. Cashin (1):
      aoe: do not call bdi_init after blk_alloc_queue

Emmanuel Grumbach (2):
      iwlwifi: silently ignore fw flaws in Tx path
      iwlwifi: don't handle masked interrupt

Eric Dumazet (7):
      rcu: Fix batch-limit size problem
      tcp: fix MSG_SENDPAGE_NOTLAST logic
      tcp: implement RFC 5961 3.2
      tcp: implement RFC 5961 4.2
      tcp: refine SYN handling in tcp_validate_incoming
      tcp: tcp_replace_ts_recent() should not be called from tcp_validate_incoming()
      tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation

Eric Sandeen (1):
      ext4: init pagevec in ext4_da_block_invalidatepages

Eric Wong (1):
      epoll: prevent missed events on EPOLL_CTL_MOD

Eugene Shatokhin (1):
      ext4: fix memory leak in ext4_xattr_set_acl()'s error path

Felix Fietkau (4):
      Revert "ath9k_hw: Update AR9003 high_power tx gain table"
      ath9k_hw: Fix signal strength / channel noise reporting
      ath5k: fix tx path skb leaks
      b43: fix tx path skb leaks

Forrest Liu (1):
      ext4: fix extent tree corruption caused by hole punch

Francois Romieu (1):
      sis900: fix sis900_set_mode call parameters.

Gabor Juhos (2):
      ath9k: ar9003: fix OTP register offsets for AR9340
      powerpc: Add missing NULL terminator to avoid boot panic on PPC40x

Gao feng (1):
      cgroup_rm_file: don't delete the uncreated files

Greg KH (1):
      USB: mark uas driver as BROKEN

Guo Chao (1):
      ext4: release buffer in failed path in dx_probe()

Gustavo Padovan (2):
      Bluetooth: Add missing lock nesting notation
      Bluetooth: cancel power_on work when unregistering the device

Herton Ronaldo Krzesinski (1):
      Linux 3.5.7.3

Huacai Chen (1):
      MIPS: Fix poweroff failure when HOTPLUG_CPU configured.

Hugh Dickins (1):
      tmpfs mempolicy: fix /proc/mounts corrupting memory

Ian Abbott (1):
      staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should select COMEDI_FC

J. Bruce Fields (2):
      nfsd: fix v4 reply caching
      nfsd4: fix oops on unusual readlike compound

Jack Morgenstein (1):
      mlx4_core: Fix potential deadlock in mlx4_eq_int()

Jan Beulich (1):
      x86: hpet: Fix masking of MSI interrupts

Jan Kara (2):
      ext4: check dioread_nolock on remount
      jbd2: fix assertion failure in jbd2_journal_flush()

Jaroslav Resler (1):
      Bluetooth: Add support for BCM20702A0 [04ca, 2003]

Jay Purohit (1):
      usb/ipheth: Add iPhone 5 support

Jeff Cook (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17b5]

Jeff Layton (4):
      nfs: don't extend writes to cover entire page if pagecache is invalid
      nfs: don't zero out the rest of the page if we hit the EOF on a DIO READ
      cifs: don't compare uniqueids in cifs_prime_dcache unless server inode numbers are in use
      cifs: adjust sequence number downward after signing NT_CANCEL request

Jerome Glisse (1):
      drm/radeon: fix amd afusion gpu setup aka sumo v2

Jianpeng Ma (1):
      [SCSI] mvsas: Fix oops when ata commond timeout.

Johannes Berg (1):
      ipv4: ip_check_defrag must not modify skb before unsharing

Julius Werner (1):
      xhci: fix null-pointer dereference when destroying half-built segment rings

Jussi Kivilinna (1):
      rtlwifi: fix incorrect use of usb_alloc_coherent with usb_control_msg

Kamil Iskra (1):
      ACPI / battery: Correct battery capacity values on Thinkpads

Kees Cook (1):
      exec: do not leave bprm->interp on stack

Kevin McKinney (1):
      Staging: bcm: Add two products and remove an existing product.

Krzysztof Mazur (1):
      i915: ensure that VGA plane is disabled

Lan Tianyu (1):
      ACPI / PM: Add Sony Vaio VPCEB1S1E to nonvs blacklist.

Larry Finger (1):
      b43legacy: Fix firmware loading when driver is built into the kernel

Lars-Peter Clausen (1):
      ASoC: sigmadsp: Fix endianness conversion issue

Lothar Waßmann (1):
      video: mxsfb: fix crash when unblanking the display

Malcolm Priestley (6):
      staging: vt6656: [BUG] out of bound array reference in RFbSetPower.
      staging: vt6656: 64 bit fixes: use u32 for QWORD definition.
      staging: vt6656: 64 bit fixes : correct all type sizes
      staging: vt6656: 64 bit fixes: fix long warning messages.
      staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32
      staging: vt6656: 64bit fixes: vCommandTimerWait change calculation of timer.

Marek Szyprowski (1):
      mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls

Mark Brown (4):
      regulator: wm831x: Set the new rather than old value for DVS VSEL
      mfd: wm8994: Add support for WM1811 rev E
      ASoC: wm8994: Use the same DCS codes for all WM1811 variants
      regmap: debugfs: Avoid overflows for very small reads

Markus Becker (1):
      USB: cp210x: add Virtenio Preon32 device id

Martin Teichmann (1):
      USB: ftdi_sio: Add support for Newport AGILIS motor drivers

Michael Tokarev (1):
      ext4: do not try to write superblock on ro remount w/o journal

Michal Hocko (1):
      mm: limit mmu_gather batching to fix soft lockups on !CONFIG_PREEMPT

Mikael Pettersson (1):
      sata_promise: fix hardreset lockdep error

Mikulas Patocka (1):
      dm persistent data: rename node to btree_node

Myron Stowe (1):
      PCI: Work around Stratus ftServer broken PCIe hierarchy (fix DMI check)

Namjae Jeon (2):
      udf: fix memory leak while allocating blocks during write
      udf: don't increment lenExtents while writing to a hole

Nathan Williams (1):
      mtd cs553x_nand: Initialise ecc.strength before nand_scan()

Neal Cardwell (4):
      inet_diag: fix oops for IPv4 AF_INET6 TCP SYN-RECV state
      inet_diag: validate byte code to prevent oops in inet_diag_bc_run()
      inet_diag: avoid unsafe and nonsensical prefix matches in inet_diag_bc_run()
      inet_diag: validate port comparison byte code to prevent unsafe reads

Neil Brown (1):
      nfsd: avoid permission checks on EXCLUSIVE_CREATE replay

NeilBrown (2):
      NFS: avoid NULL dereference in nfs_destroy_server
      vfs: d_obtain_alias() needs to use "/" as default name.

Niels Ole Salscheider (1):
      drm/radeon: Properly handle DDC probe for DP bridges

Oleg Nesterov (1):
      signals: sys_ssetmask() uses uninitialized newmask

Ondrej Zary (1):
      x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops

Paulo Zanoni (3):
      drm/i915: make the panel fitter work on pipes B and C on IVB
      drm/i915: add some barriers when changing DIPs
      drm/i915: make sure we write all the DIP data bytes

Pawel Moll (1):
      kbuild: Do not remove vmlinux when cleaning external module

Peter Korsgaard (1):
      usb: ftdi_sio: fixup BeagleBone A5+ quirk

Peter Popovec (1):
      Input: walkera0701 - fix crash on startup

Rafael J. Wysocki (3):
      ACPI / PNP: Do not crash due to stale pointer use during system resume
      ACPI / scan: Do not use dummy HID for system bus ACPI nodes
      PM: Move disabling/enabling runtime PM to late suspend/early resume

Rafał Miłecki (1):
      bcma: mips: fix clearing device IRQ

Rajkumar Manoharan (1):
      ath9k_hw: Enable hw PLL power save for AR9462

Robin Holt (1):
      SGI-XP: handle non-fatal traps

Roland Dreier (3):
      iscsi-target: Always send a response before terminating iSCSI connection
      printk: fix incorrect length from print_time() when seconds > 99999
      iscsi-target: Fix CmdSN comparison (use cmd->cmd_sn instead of cmd->stat_sn)

Russell Webb (1):
      xhci: Add Lynx Point LP to list of Intel switchable hosts

Sarah Sharp (3):
      xhci: Fix conditional check in bandwidth calculation.
      xHCI: Fix TD Size calculation on 1.0 hosts.
      xhci: Extend Fresco Logic MSI quirk.

Sarveshwar Bandi (1):
      bonding: Bonding driver does not consider the gso_max_size/gso_max_segs setting of slave devices.

Sasha Levin (1):
      prevent stack buffer overflow in host_reset

Scott Wood (1):
      KVM: PPC: e500: fix allocation size error on g2h_tlb1_map

Sebastian Andrzej Siewior (6):
      usb: gadget: tcm_usb_gadget: NULL terminate the FS descriptor list
      usb: gadget: network: fix bind() error path
      usb: gadget: midi: free hs descriptors
      usb: gadget: phonet: free requests in pn_bind()'s error path
      usb: gadget: uvc: fix error path in uvc_function_bind()
      target/file: Fix 32-bit highmem breakage for SGL -> iovec mapping

Sebastian Ott (1):
      s390/cio: fix pgid reserved check

Sergei Shtylyov (1):
      usb: musb: cppi_dma: export cppi_interrupt()

Seung-Woo Kim (1):
      drm/prime: drop reference on imported dma-buf come from gem

Shan Hai (1):
      powerpc/vdso: Remove redundant locking in update_vsyscall_tz()

Sonny Rao (1):
      mm: fix calculation of dirtyable memory

Stanislav Kinsbursky (1):
      SUNRPC: continue run over clients list on PipeFS event instead of break

Stanislaw Gruszka (2):
      mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
      Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails"

Stefan Hasko (1):
      net: sched: integer overflow fix

Stephan Gatzka (1):
      firewire: net: Fix handling of fragmented multicast/broadcast packets.

Steve Hodgson (2):
      iscsi-target: Fix bug in handling of ExpStatSN ACK during u32 wrap-around
      qla2xxx: Look up LUN for abort requests

Steven Rostedt (1):
      ring-buffer: Fix NULL pointer if rb_set_head_page() fails

Sujith Manoharan (1):
      ath9k_hw: Fix RX gain initvals for AR9485

Takashi Iwai (6):
      ALSA: usb-audio: Avoid autopm calls after disconnection
      ALSA: usb-audio: Fix missing autopm for MIDI input
      ALSA: hda - Add stereo-dmic fixup for Acer Aspire One 522
      ALSA: hda - Fix pin configuration of HP Pavilion dv7
      ALSA: hda - Always turn on pins for HDMI/DP
      ALSA: hda - Fix the wrong pincaps set in ALC861VD dallas/hp fixup

Tatyana Nikolova (2):
      RDMA/nes: Fix for terminate timer crash
      RDMA/nes: Fix for crash when registering zero length MR for CQ

Tejun Heo (3):
      cgroup: cgroup_subsys->fork() should be called after the task is added to css_set
      freezer: add missing mb's to freezer_count() and freezer_should_skip()
      cgroup: remove incorrect dget/dput() pair in cgroup_create_dir()

Theodore Ts'o (1):
      ext4: fix possible use after free with metadata csum

Thomas Gleixner (1):
      genirq: Always force thread affinity

Tomasz Guszkowski (1):
      p54usb: add USB ID for T-Com Sinus 154 data II

Tomi Valkeinen (1):
      OMAP: board-files: fix i2c_bus for tfp410

Tommi Rantala (2):
      sctp: fix memory leak in sctp_datamsg_from_user() when copy from user space fails
      sctp: fix -ENOMEM result with invalid user space pointer in sendto() syscall

Tony Prisk (2):
      drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield
      drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct rtc_time

Trond Myklebust (4):
      SUNRPC: Fix validity issues with rpc_pipefs sb->s_fs_info
      NFS: Fix calls to drop_nlink()
      SUNRPC: Ensure that we free the rpc_task after cleanups are done
      NFS: Ensure that we free the rpc_task after read and write cleanups are done

Wei Yongjun (1):
      iscsit: use GFP_ATOMIC under spin lock

Will Deacon (3):
      ARM: mm: use pteval_t to represent page protection values
      virtio: force vring descriptors to be allocated from lowmem
      ARM: 7607/1: realview: fix private peripheral memory base for EB rev. B boards

Wolfram Sang (1):
      mtd: nand: gpmi: reset BCH earlier, too, to avoid NAND startup problems

Woodhouse, David (1):
      intel-iommu: Free old page tables before creating superpage

Xi Wang (2):
      mvsas: fix undefined bit shift
      nfs: fix null checking in nfs_get_option_str()

Xiaotian Feng (1):
      fix Null pointer dereference on disk error

Yanchuan Nian (1):
      nfs: fix wrong object type in lockowner_slab

Yi Zou (1):
      target/tcm_fc: fix the lockdep warning due to inconsistent lock state

Zhang Rui (3):
      ACPI: do acpisleep dmi check when CONFIG_ACPI_SLEEP is set
      ACPI / video: ignore BIOS initial backlight value for HP Folio 13-2000
      ACPI : do not use Lid and Sleep button for S5 wakeup

Zheng Liu (1):
      perf test: fix a build error on builtin-test

li.rui27@zte.com.cn (1):
      USB: add new zte 3g-dongle's pid to option.c

nikolay@redhat.com (1):
      bonding: fix race condition in bonding_store_slaves_active

