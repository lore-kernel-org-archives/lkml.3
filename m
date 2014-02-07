Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbaBGN1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:27:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41369 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbaBGLri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:47:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.11.y.z extended stable] Linux 3.11.10.4 stable review
Date: Fri,  7 Feb 2014 11:43:39 +0000
Message-Id: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.11.10.4 stable kernel.

This version contains 233 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.11.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.11.y-review

The review period for version 3.11.10.4 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.11.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 Documentation/devicetree/bindings/ata/marvell.txt  |   2 +-
 Documentation/filesystems/proc.txt                 |   4 +-
 arch/Kconfig                                       |   3 +
 arch/arm/boot/dts/armada-370-xp.dtsi               |   2 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   2 +
 arch/arm/boot/dts/exynos5250.dtsi                  |   2 +-
 arch/arm/mach-at91/sam9_smc.c                      |   2 +-
 arch/arm/mach-highbank/highbank.c                  |   1 +
 arch/arm/mach-omap2/omap4-common.c                 |   1 +
 arch/arm/mach-shmobile/board-armadillo800eva.c     |   4 +-
 arch/arm/mach-shmobile/board-kzm9g.c               |   2 +-
 arch/arm/mach-shmobile/board-mackerel.c            |   4 +-
 arch/arm/net/bpf_jit_32.c                          |   6 +-
 arch/parisc/include/asm/cacheflush.h               |   2 -
 arch/parisc/include/asm/page.h                     |   3 +-
 arch/parisc/kernel/cache.c                         |  14 ++
 arch/powerpc/include/asm/topology.h                |  10 +-
 arch/powerpc/kernel/cacheinfo.c                    |   3 +
 arch/powerpc/kvm/book3s_hv.c                       |   7 +-
 arch/powerpc/kvm/e500_mmu.c                        |   2 +-
 arch/powerpc/mm/numa.c                             |  70 +++++++++-
 arch/powerpc/net/bpf_jit_comp.c                    |   7 +-
 arch/powerpc/platforms/Kconfig.cputype             |   1 +
 arch/s390/include/uapi/asm/statfs.h                |  10 +-
 arch/s390/kvm/diag.c                               |   2 +-
 arch/s390/net/bpf_jit_comp.c                       |  29 +++--
 arch/sh/kernel/kgdb.c                              |   1 +
 arch/sparc/net/bpf_jit_comp.c                      |  17 ++-
 arch/x86/include/asm/pgtable_types.h               |   3 +-
 arch/x86/include/uapi/asm/msr-index.h              |   1 +
 arch/x86/kernel/cpu/amd.c                          |  10 ++
 arch/x86/kernel/cpu/perf_event_amd_ibs.c           |  53 ++++++--
 arch/x86/kvm/i8254.c                               |  18 +++
 arch/x86/kvm/lapic.c                               |   5 +-
 arch/x86/kvm/x86.c                                 |   3 +
 arch/x86/kvm/x86.h                                 |   2 +
 arch/x86/net/bpf_jit_comp.c                        |  14 +-
 arch/x86/platform/efi/efi.c                        |   2 +-
 arch/x86/xen/platform-pci-unplug.c                 |  74 +++++++++++
 arch/xtensa/platforms/xtfpga/setup.c               |  12 +-
 drivers/acpi/acpi_lpss.c                           |   1 -
 drivers/acpi/bus.c                                 |   9 ++
 drivers/ata/libata-core.c                          |  27 ++++
 drivers/ata/libata-scsi.c                          |  18 ++-
 drivers/ata/sata_mv.c                              |  25 ++++
 drivers/block/xen-blkfront.c                       |   4 +-
 drivers/char/tpm/tpm_i2c_stm_st33.c                |   7 +-
 drivers/char/tpm/tpm_ppi.c                         |   8 +-
 drivers/clk/samsung/clk-exynos4.c                  |   2 +-
 drivers/clk/samsung/clk-exynos5250.c               |   7 +-
 drivers/edac/e752x_edac.c                          |   4 +-
 drivers/eisa/eisa-bus.c                            |  26 ++--
 drivers/gpu/drm/ast/ast_fb.c                       |   2 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c              |   2 +-
 drivers/gpu/drm/cirrus/cirrus_mode.c               |   4 +-
 drivers/gpu/drm/i915/i915_dma.c                    |   1 +
 drivers/gpu/drm/i915/i915_gem_stolen.c             |   2 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  10 +-
 drivers/gpu/drm/i915/intel_ddi.c                   |   8 +-
 drivers/gpu/drm/i915/intel_display.c               |   4 +-
 drivers/gpu/drm/i915/intel_dp.c                    |  40 ++++--
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  12 +-
 drivers/gpu/drm/mgag200/mgag200_cursor.c           |   8 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c               |   2 +-
 drivers/gpu/drm/nouveau/core/engine/falcon.c       |  20 ++-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |   8 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  33 ++---
 drivers/gpu/drm/radeon/atombios_crtc.c             |  25 +++-
 drivers/gpu/drm/radeon/evergreen.c                 |   4 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   5 +-
 drivers/gpu/drm/radeon/ni.c                        |  16 +--
 drivers/gpu/drm/radeon/nid.h                       |   1 +
 drivers/gpu/drm/radeon/r600.c                      |  13 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |   5 +-
 drivers/gpu/drm/radeon/r600d.h                     |   1 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |   4 +
 drivers/gpu/drm/radeon/radeon_i2c.c                |   3 +
 drivers/gpu/drm/radeon/radeon_pm.c                 |   6 +-
 drivers/gpu/drm/radeon/rv770_dpm.c                 |   6 +
 drivers/gpu/drm/radeon/si.c                        |   2 +-
 drivers/gpu/drm/radeon/sid.h                       |   2 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |   1 -
 drivers/gpu/drm/rcar-du/rcar_du_plane.c            |  21 +--
 drivers/hwmon/coretemp.c                           |   2 +-
 drivers/hwmon/k10temp.c                            |   1 +
 drivers/infiniband/hw/qib/qib_ud.c                 |   9 +-
 drivers/input/misc/xen-kbdfront.c                  |   4 +
 drivers/iommu/intel-iommu.c                        |   2 +-
 drivers/md/Kconfig                                 |   4 +
 drivers/md/Makefile                                |   1 +
 drivers/md/bcache/bset.c                           |  26 +++-
 drivers/md/dm-builtin.c                            |  48 +++++++
 drivers/md/dm-sysfs.c                              |   5 +-
 drivers/md/dm-thin-metadata.c                      |  20 +++
 drivers/md/dm-thin-metadata.h                      |   2 +
 drivers/md/dm-thin.c                               | 120 ++++++++++-------
 drivers/md/dm.c                                    |  15 +--
 drivers/md/dm.h                                    |  17 +++
 drivers/md/md.c                                    |  18 ++-
 drivers/md/md.h                                    |   3 +
 drivers/md/persistent-data/dm-space-map-common.c   |   6 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |  28 +++-
 drivers/md/raid10.c                                |  12 +-
 drivers/md/raid5.c                                 |   5 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |   1 +
 drivers/media/dvb-frontends/dib8000.c              |  42 ++++--
 drivers/media/dvb-frontends/m88rs2000.c            | 117 ++++++++++++-----
 drivers/media/dvb-frontends/m88rs2000.h            |   2 +
 drivers/media/dvb-frontends/nxt200x.c              |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  28 +---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   9 --
 drivers/media/usb/dvb-usb-v2/anysee.c              |   3 +-
 drivers/media/usb/dvb-usb-v2/it913x.c              |   3 +
 drivers/mfd/max77686.c                             |   2 +-
 drivers/mmc/card/block.c                           |   7 +-
 drivers/mmc/host/atmel-mci.c                       |  13 +-
 drivers/mmc/host/sdhci-pci.c                       |  12 ++
 drivers/mtd/nand/mxc_nand.c                        |   1 -
 drivers/net/ethernet/arc/emac_main.c               |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  13 +-
 drivers/net/ethernet/intel/e1000e/phy.c            |  10 +-
 drivers/net/ethernet/sfc/efx.c                     |   4 +
 drivers/net/ethernet/sfc/nic.h                     |   2 +
 drivers/net/ethernet/sfc/ptp.c                     |  69 ++++++++--
 drivers/net/ethernet/via/via-rhine.c               |   1 +
 drivers/net/wireless/b43/b43.h                     |   4 +-
 drivers/net/wireless/b43/main.c                    |  27 ++--
 drivers/net/wireless/b43/xmit.c                    |   4 +-
 drivers/net/wireless/b43legacy/main.c              |   1 +
 drivers/net/wireless/iwlwifi/iwl-prph.h            |   4 +
 drivers/net/wireless/iwlwifi/mvm/ops.c             |   1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  22 ++++
 drivers/net/wireless/mwifiex/fw.h                  |   2 +-
 drivers/net/wireless/mwifiex/scan.c                |   4 +-
 drivers/net/wireless/rtlwifi/base.c                |   3 +-
 drivers/net/wireless/rtlwifi/core.c                |  11 ++
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c        |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |  36 ++++++
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h  |  14 ++
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c        |   9 ++
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.h        |   3 +
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |  29 +++--
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |  17 ++-
 drivers/net/wireless/rtlwifi/stats.c               |  14 ++
 drivers/net/wireless/rtlwifi/usb.c                 |   4 +-
 drivers/net/wireless/rtlwifi/wifi.h                |  33 ++---
 drivers/net/xen-netfront.c                         |  90 ++++---------
 drivers/parport/parport_pc.c                       |  10 +-
 drivers/pci/xen-pcifront.c                         |   4 +
 drivers/pinctrl/pinctrl-baytrail.c                 |   1 -
 drivers/pinctrl/pinctrl-sunxi.c                    |  13 +-
 drivers/platform/x86/hp_accel.c                    |   1 +
 drivers/rtc/rtc-max8907.c                          |  11 +-
 drivers/scsi/bfa/bfad.c                            |   6 +-
 drivers/scsi/sd.c                                  |   5 +-
 drivers/scsi/virtio_scsi.c                         |  15 ++-
 drivers/spi/spi-bcm63xx.c                          |   2 -
 drivers/spi/spi-pxa2xx.c                           |   2 +
 drivers/spi/spi.c                                  |   4 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c    |   4 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |   2 +-
 drivers/staging/rtl8712/usb_intf.c                 |   5 +
 drivers/staging/vt6656/baseband.c                  |   3 -
 drivers/staging/vt6656/card.c                      |   2 +-
 drivers/staging/zram/zram_drv.c                    |   4 +-
 drivers/target/iscsi/iscsi_target.c                |  34 +++--
 drivers/tty/serial/8250/8250_core.c                |   4 +
 drivers/tty/serial/8250/8250_pci.c                 |   8 +-
 drivers/tty/serial/amba-pl011.c                    |   6 +
 drivers/tty/serial/atmel_serial.c                  |  20 ++-
 drivers/usb/chipidea/ci.h                          |  26 +++-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  32 ++++-
 drivers/usb/chipidea/core.c                        |   2 +
 drivers/usb/chipidea/host.c                        |   1 +
 drivers/usb/chipidea/udc.c                         |  19 ++-
 drivers/usb/core/config.c                          |   7 -
 drivers/usb/core/hub.c                             |  54 +++-----
 drivers/usb/host/ehci.h                            |  18 ++-
 drivers/usb/host/xhci.c                            |   3 +
 drivers/usb/serial/cypress_m8.h                    |   2 +-
 drivers/usb/serial/ftdi_sio.c                      |  17 ++-
 drivers/usb/serial/option.c                        |  15 +++
 drivers/usb/serial/pl2303.c                        |  33 +++--
 drivers/usb/storage/unusual_devs.h                 |   7 +
 drivers/video/xen-fbfront.c                        |   4 +
 drivers/xen/xenbus/xenbus_probe_frontend.c         |   2 +-
 fs/btrfs/extent-tree.c                             |   2 +-
 fs/btrfs/ioctl.c                                   |   6 +
 fs/dcache.c                                        |   7 +-
 fs/dcookies.c                                      |   2 +-
 fs/exofs/ore.c                                     |  37 ++++--
 fs/ext4/inline.c                                   |   8 +-
 fs/fs-writeback.c                                  |  15 ++-
 fs/fuse/dev.c                                      |  22 +---
 fs/gfs2/inode.c                                    |  16 ++-
 fs/hpfs/alloc.c                                    |  66 +++++++++-
 fs/hpfs/hpfs_fn.h                                  |   2 +-
 fs/hpfs/super.c                                    |  29 ++++-
 fs/mount.h                                         |   2 +-
 fs/nfs/nfs4client.c                                |  18 +--
 fs/nfs/nfs4proc.c                                  |  38 +++++-
 fs/nfs/nfs4xdr.c                                   |  47 ++++---
 fs/nfs/write.c                                     |  11 +-
 fs/nilfs2/segment.c                                |  10 +-
 fs/notify/fanotify/fanotify_user.c                 |   4 +-
 fs/read_write.c                                    |  16 +--
 fs/splice.c                                        |  18 +++
 include/linux/audit.h                              |   2 +-
 include/linux/compat.h                             |  18 +--
 include/linux/hugetlb.h                            |   6 +
 include/linux/libata.h                             |   2 +
 include/linux/mm.h                                 |  13 +-
 include/linux/netdevice.h                          |  13 ++
 include/linux/pipe_fs_i.h                          |   2 +
 include/linux/usb/chipidea.h                       |   1 +
 include/scsi/osd_ore.h                             |   1 +
 include/xen/platform_pci.h                         |  23 ++++
 kernel/audit.c                                     |   5 +-
 kernel/trace/ftrace.c                              | 103 +++++++++++----
 kernel/trace/trace.c                               |   8 ++
 lib/decompress_inflate.c                           |   2 +-
 mm/huge_memory.c                                   |  18 ++-
 mm/hugetlb.c                                       |  17 +++
 mm/memcontrol.c                                    |  53 +++++++-
 mm/memory-failure.c                                |  21 +--
 mm/mempolicy.c                                     |  19 ++-
 mm/oom_kill.c                                      |   2 +-
 mm/page-writeback.c                                |  55 ++++----
 mm/slub.c                                          |   8 +-
 mm/swap.c                                          | 143 ++++++++++++---------
 mm/util.c                                          |   5 +-
 net/bridge/br_private.h                            |  10 ++
 net/bridge/br_stp_bpdu.c                           |   2 +-
 net/compat.c                                       |   9 +-
 net/core/filter.c                                  |  30 +----
 net/core/skbuff.c                                  |  32 +----
 net/ieee802154/nl-phy.c                            |   6 +-
 net/ipv4/fib_frontend.c                            |   2 +
 net/ipv4/gre_offload.c                             |  11 +-
 net/ipv4/inet_diag.c                               |   4 +-
 net/ipv4/ip_input.c                                |   2 +-
 net/ipv4/ip_tunnel.c                               |   1 +
 net/ipv4/ipmr.c                                    |   7 +-
 net/ipv4/tcp_metrics.c                             |  51 +++++---
 net/ipv4/udp.c                                     |   6 +-
 net/ipv4/udp_offload.c                             |  37 +++---
 net/ipv6/ip6_input.c                               |   2 +-
 net/ipv6/ip6_tunnel.c                              |  12 ++
 net/ipv6/ip6mr.c                                   |   7 +-
 net/ipv6/sit.c                                     |  10 ++
 net/netfilter/nf_nat_irc.c                         |  32 ++++-
 net/rds/ib_recv.c                                  |   7 +-
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |   2 -
 net/sunrpc/auth_gss/svcauth_gss.c                  |  33 +----
 net/sunrpc/clnt.c                                  |   8 +-
 net/sunrpc/netns.h                                 |   1 -
 security/selinux/ss/policydb.c                     |  14 +-
 sound/core/init.c                                  |   4 +-
 sound/pci/Kconfig                                  |  12 ++
 sound/pci/hda/hda_generic.c                        |   6 +-
 sound/pci/hda/patch_hdmi.c                         | 100 ++++++++++----
 sound/pci/hda/patch_realtek.c                      |  19 ++-
 sound/pci/rme9652/rme9652.c                        |   2 +-
 sound/soc/codecs/adau1701.c                        |   2 +-
 sound/soc/codecs/wm5110.c                          |  48 +++++++
 .../perf/util/scripting-engines/trace-event-perl.c |   2 +-
 tools/perf/util/session.c                          |   7 +-
 tools/power/x86/turbostat/Makefile                 |   2 +-
 tools/power/x86/turbostat/turbostat.c              |  13 +-
 269 files changed, 2633 insertions(+), 1092 deletions(-)

AKASHI Takahiro (1):
      audit: correct a type mismatch in audit_syscall_exit()

Abhilash Kesavan (2):
      ARM: dts: exynos5250: Fix MDMA0 clock number
      clk: samsung: exynos5250: Add CLK_IGNORE_UNUSED flag for the sysreg clock

Adrian Hunter (2):
      mmc: sdhci-pci: Fix BYT sd card getting stuck in runtime suspend
      mmc: sdhci-pci: Fix possibility of chip->fixes being null

Adrien Vergé (1):
      ALSA: hda - Fix silent output on MacBook Air 1,1

Akash Goel (1):
      drm/i915: Fix the offset issue for the stolen GEM objects

Alan Stern (1):
      USB: fix race between hub_disconnect and recursively_mark_NOTATTACHED

Alex Deucher (8):
      drm/radeon: warn users when hw_i2c is enabled (v2)
      drm/radeon: disable ss on DP for DCE3.x
      drm/radeon/dpm: disable mclk switching on desktop RV770
      drm/radeon: fix surface sync in fence on cayman (v2)
      drm/radeon: set the full cache bit for fences on r7xx+
      drm/radeon: fix DAC interrupt handling on DCE5+
      drm/radeon/DCE4+: clear bios scratch dpms bit (v2)
      drm/radeon/dce8: workaround for atom BlankCrtc table

Alex Williamson (1):
      intel-iommu: fix off-by-one in pagetable freeing

Alexandre Courbot (1):
      lib/decompressors: fix "no limit" output buffer length

Alexandre Rames (1):
      sfc: Stop/re-start PTP when stopping/starting the datapath.

Amitkumar Karwar (1):
      mwifiex: add missing endian conversion for fw_tsf

Andrea Arcangeli (1):
      mm: hugetlbfs: fix hugetlbfs optimization

Andreas Rohner (1):
      nilfs2: fix segctor bug that causes file system corruption

Andreas Schwab (1):
      KVM: PPC: Book3S HV: use xics_wake_cpu only when defined

Andrew Bresticker (1):
      clk: exynos5250: fix sysmmu_mfc{l,r} gate clocks

Andrew Jones (1):
      kvm: x86: fix apic_base enable check

Andrey Vagin (1):
      mm: don't lose the SOFT_DIRTY flag on mprotect

Andy Grover (1):
      target/iscsi: Fix network portal creation race

Aneesh Kumar K.V (1):
      powerpc: thp: Fix crash on mremap

Annie Li (1):
      xen-netfront: fix resource leak in netfront

Anssi Hannula (1):
      ALSA: hda - hdmi: introduce patch_nvhdmi()

Antti Palosaari (1):
      [media] anysee: fix non-working E30 Combo Plus DVB-T

Aristeu Rozanski (1):
      e752x_edac: Fix pci_dev usage count

Arnaldo Carvalho de Melo (1):
      perf scripting perl: Fix build error on Fedora 12

Asias He (1):
      virtio-scsi: Fix hotcpu_notifier use-after-free with virtscsi_freeze

Ben Hutchings (3):
      sfc: Add length checks to efx_xmit_with_hwtstamp() and efx_ptp_is_ptp_tx()
      sfc: Rate-limit log message for PTP packets without a matching timestamp event
      sfc: Maintain current frequency adjustment when applying a time offset

Bernd Schubert (1):
      [SCSI] sd: Reduce buffer size for vpd request

Bing Zhao (1):
      mwifiex: fix wrong 11ac bits setting in fw_cap_info

Bjorn Helgaas (1):
      Revert "EISA: Initialize device before its resources"

Boaz Harrosh (2):
      pnfs: Proper delay for NFS4ERR_RECALLCONFLICT in layout_get_done
      ore: Fix wrong math in allocation of per device BIO

Bob Peterson (1):
      GFS2: Increase i_writecount during gfs2_setattr_chown

Borislav Petkov (1):
      x86, cpu, amd: Add workaround for family 16h, erratum 793

Charles Keepax (1):
      ASoC: wm5110: Extend SYSCLK patch file for rev D

Chen-Yu Tsai (1):
      pinctrl: sunxi: Honor GPIO output initial vaules

Chris Wilson (1):
      drm/i915: Flush outstanding requests before allocating new seqno

Christian Engelmayer (1):
      ieee802154: Fix memory leak in ieee802154_add_iface()

Christoph Paasch (1):
      tcp: metrics: Avoid duplicate entries with the same destination-IP

Colin Leitner (1):
      USB: ftdi_sio: added CS5 quirk for broken smartcard readers

Dan Carpenter (1):
      ALSA: bits vs bytes bug in snd_card_create()

Daniel Borkmann (1):
      netfilter: nf_nat: fix access to uninitialized buffer in IRC NAT helper

Daniel Santos (1):
      spidev: fix hang when transfer_one_message fails

Dave Airlie (2):
      drm/mgag200: fix oops in cursor code.
      drm: ast,cirrus,mgag200: use drm_can_sleep

Dave Young (1):
      x86/efi: Fix off-by-one bug in EFI Boot Services reservation

David Ertman (1):
      e1000e: fix compiler warnings

David Rientjes (2):
      mm, oom: base root bonus on current usage
      mm/mempolicy.c: fix mempolicy printing in numa_maps

David Sterba (1):
      btrfs: restrict snapshotting to own subvolumes

Dongsheng Yang (1):
      perf kvm: Fix kvm report without guestmount.

Duan Jiong (1):
      ip_tunnel: clear IPCB in ip_tunnel_xmit() in case dst_link_failure() is called

Eliad Peller (1):
      iwlwifi: mvm: fix missing cleanup in .start() error path

Emmanuel Grumbach (1):
      iwlwifi: pcie: enable oscillator for L1 exit

Eric Dumazet (2):
      arc_emac: fix potential use after free
      bpf: do not use reciprocal divide

Eric W. Biederman (2):
      vfs: In d_path don't call d_dname on a mount point
      vfs: Is mounted should be testing mnt_ns for NULL or error.

Geert Uytterhoeven (1):
      mm: Make {,set}page_address() static inline if WANT_PAGE_VIRTUAL

Gerald Schaefer (1):
      net: rds: fix per-cpu helper usage

H Hartley Sweeten (2):
      staging: comedi: adl_pci9111: fix incorrect irq passed to request_irq()
      staging: comedi: addi_apci_1032: fix subdevice type/flags bug

Hannes Frederic Sowa (1):
      net: avoid reference counter overflows on fib_rules in multicast forwarding

Heiko Carstens (6):
      KVM: s390: fix diagnose code extraction
      s390/uapi: fix struct statfs64 definition
      compat: fix sys_fanotify_mark
      fs/compat: fix parameter handling for compat readv/writev syscalls
      fs/compat: fix lookup_dcookie() parameter handling
      s390/bpf,jit: fix 32 bit divisions, use unsigned divide instructions

Helge Deller (1):
      parisc: fix cache-flushing

Holger Eitzenberger (1):
      net: Fix memory leak if TPROXY used with TCP early demux

Hugh Dickins (1):
      thp: fix copy_page_rep GPF by testing is_huge_zero_pmd once only

Ilia Mirkin (2):
      drm/nouveau/falcon: use vmalloc to create firwmare copies
      drm/nouveau/bios: fix offset calculation for BMPv1 bioses

Ira Weiny (1):
      IB/qib: Fix QP check when looping back to/from QP1

Jack Pham (1):
      usb: xhci: Check for XHCI_PLAT in xhci_cleanup_msix()

Jan Kara (1):
      writeback: Fix data corruption on NFS

Jean Delvare (1):
      hwmon: (coretemp) Fix truncated name of alarm attributes

Jean-Jacques Hiblot (1):
      ARM: at91: smc: bug fix in sam9_smc_cs_read()

Jeff Layton (1):
      sunrpc: don't wait for write before allowing reads from use-gss-proxy file

Jiri Pirko (1):
      br: fix use of ->rx_handler_data in code executed on non-rx_handler path

Joe Thornber (5):
      dm thin: always fallback the pool mode if commit fails
      dm thin: fix discard support to a previously shared block
      dm space map common: make sure new space is used during extend
      dm space map metadata: fix extending the space map
      dm space map metadata: fix bug in resizing of thin metadata

Johan Hovold (2):
      USB: cypress_m8: fix ring-indicator detection and reporting
      USB: pl2303: fix data corruption on termios updates

Johannes Weiner (2):
      mm: memcg: fix race condition between memcg teardown and swapin
      mm/page-writeback.c: fix dirty_balance_reserve subtraction from dirtyable memory

Jon Medhurst (1):
      serial: amba-pl011: use port lock to guard control register access

Jonas Gorski (1):
      spi/bcm63xx: don't substract prepend length from total length

Jonathan Woithe (1):
      serial: 8250: Fix initialisation of Quatech cards with the AMCC PCI chip

Josh Triplett (2):
      turbostat: Don't put unprocessed uapi headers in the include path
      turbostat: Use GCC's CPUID functions to support PIC

Kent Overstreet (1):
      bcache: Data corruption fix

Konrad Rzeszutek Wilk (1):
      xen/pvhvm: If xen_platform_pci=0 is set don't blow up (v4).

Krzysztof Kozlowski (1):
      mfd: max77686: Fix regmap resource leak on driver remove

Larry Finger (17):
      rtlwifi: rtl8192c: Prevent reconnect attempts if not connected
      rtlwifi: rtl8192cu: Add new firmware
      rtlwifi: Redo register save locations
      rtlwifi: Set the link state
      rtlwifi: rtl8192c: Add new definitions in the dm_common header
      rtlwifi: Increase the RX queue length for USB drivers
      rtlwifi: Update beacon statistics for USB driver
      rtlwifi: rtl8192c: Add routines to save/restore power index registers
      rtlwifi: rtl8192cu: Update the power index registers
      rtlwifi: rtl8192cu: Fix some code in RF handling
      rtlwifi: Add missing code to PWDB statics routine
      rtlwifi: rtl8188ee: Fix typo in code
      staging: r8712u: Set device type to wlan
      rtlwifi: rtl8192cu: Add new device ID
      b43: Fix lockdep splat
      b43: Fix unload oops if firmware is not available
      b43legacy: Fix unload oops if firmware is not available

Lars-Peter Clausen (1):
      ASoC: adau1701: Fix ADAU1701_SEROCTL_WORD_LEN_16 constant

Laurence Evans (1):
      sfc: PTP: Moderate log message on event queue overflow

Laurent Pinchart (4):
      ARM: shmobile: kzm9g: Fix coherent DMA mask
      ARM: shmobile: armadillo: Fix coherent DMA mask
      ARM: shmobile: mackerel: Fix coherent DMA mask
      drm/rcar-du: Update plane pitch in .mode_set_base() operation

Li Zefan (1):
      slub: Fix calculation of cpu slabs

Lior Amsalem (1):
      ata: sata_mv: fix disk hotplug for Armada 370/XP SoCs

Ludovic Desroches (2):
      ARM: at91: at91sam9g45: set default mmc pinctrl-names
      mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA

Maarten Lankhorst (1):
      drm/nouveau: fix m2mf copy to tiled gart

Malcolm Priestley (5):
      staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity on bScanning
      [media] it913x: Add support for Avermedia H335 id 0x0335
      [media] m88rs2000: add m88rs2000_set_carrieroffset
      [media] m88rs2000: set symbol rate accurately
      staging: vt6656: CARDqGetNextTBTT correct uLowNextTBTT

Marcelo Tosatti (1):
      KVM: x86: limit PIT timer frequency

Marek Olšák (1):
      drm/radeon: skip colorbuffer checking if COLOR_INFO.FORMAT is set to INVALID

Marek Roszko (1):
      tty/serial: at91: Handle shutdown more safely

Marek Szyprowski (1):
      [media] media: s5p_mfc: remove s5p_mfc_get_node_type() function

Mark Brown (1):
      ACPI / init: Flag use of ACPI and ACPI idioms for power supplies to regulator API

Mauro Carvalho Chehab (2):
      [media] dib8000: make 32 bits read atomic
      [media] nxt200x: increase write buffer size

Max Filippov (1):
      xtensa: xtfpga: fix definitions of platform devices

Mel Gorman (1):
      mm: numa: initialise numa balancing after jump label initialisation

Michael Grzeschik (1):
      mtd: mxc_nand: remove duplicated ecc_stats counting

Michal Hocko (1):
      memcg: fix endless loop caused by mem_cgroup_iter

Michal Schmidt (1):
      bnx2x: fix DMA unmapping of TSO split BDs

Michel Dänzer (1):
      radeon/pm: Guard access to rdev->pm.power_state array

Mihai Caraman (1):
      KVM: PPC: e500: Fix bad address type in deliver_tlb_misss()

Mika Westerberg (1):
      spi/pxa2xx: initialize DMA channels to -1 to prevent inadvertent match

Mike Snitzer (3):
      dm thin: switch to read-only mode if metadata space is exhausted
      dm thin: initialize dm_thin_new_mapping returned by get_next_mapping
      dm thin: fix set_pool_mode exposed pool operation races

Mikhail Zolotaryov (1):
      USB: Nokia 502 is an unusual device

Miklos Szeredi (1):
      fuse: fix pipe_buf_operations

Mikulas Patocka (5):
      mm: fix crash when using XFS on loopback
      dm: wait until embedded kobject is released before destroying a device
      dm: remove pointless kobject comparison in dm_get_from_kobject
      dm sysfs: fix a module unload race
      hpfs: remember free space

Minchan Kim (1):
      zram: fix race between reset and flushing pending work

Naoya Horiguchi (1):
      mm/memory-failure.c: shift page lock from head page to tail page after thp split

Neal Cardwell (1):
      inet_diag: fix inet_diag_dump_icsk() timewait socket state logic

NeilBrown (5):
      md/raid5: Fix possible confusion when multiple write errors occur.
      md/raid10: fix two bugs in handling of known-bad-blocks.
      md/raid10: fix bug when raid10 recovery fails to recover a block.
      md: fix problem when adding device to read-only array with bitmap.
      md/raid5: fix long-standing problem with bitmap handling on write failure.

Nicolas Dichtel (3):
      sit: fix double free of fb_tunnel_dev on exit
      Revert "ip6tnl: fix use after free of fb_tnl_dev"
      ip6tnl: fix double free of fb_tnl_dev on exit

Oliver Hartkopp (1):
      fib_frontend: fix possible NULL pointer dereference

Olivier Grenie (1):
      [media] dib8000: fix regression with dib807x

PaX Team (1):
      x86, x32: Correct invalid use of user timespec in the kernel

Paul Mackerras (1):
      powerpc: Make sure "cache" directory is removed when offlining cpu

Paulo Zanoni (1):
      drm/i915: fix DDI PLLs HW state readout code

Peter Chen (4):
      usb: ehci: add freescale imx28 special write register method
      usb: chipidea: add freescale imx28 special write register method
      usb: chipidea: imx: set CI_HDRC_IMX28_WRITE_FIX for imx28
      usb: chipidea: udc: using MultO at TD as real mult value for ISO-TX

Peter Huewe (2):
      tpm/tpm_ppi: Do not compare strcmp(a,b) == -1
      tpm/tpm_i2c_stm_st33: Check return code of get_burstcount

Phil Pokorny (1):
      hwmon: (k10temp) Add support for Kaveri CPUs

Rafael J. Wysocki (1):
      Revert "ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs"

Rahul Bedarkar (1):
      USB: serial: add support for iBall 3.5G connect usb modem

Ray Jui (1):
      mmc: fix host release issue after discard operation

Richard Guy Briggs (1):
      audit: reset audit backlog wait time after error recovery

Richard Weinberger (1):
      net,via-rhine: Fix tx_timeout handling

Robert Richter (1):
      perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

Scott Mayhew (1):
      nfs: always make sure page is up-to-date before extending a write to cover the entire page

Sebastian Andrzej Siewior (1):
      parport: parport_pc: remove double PCI ID for NetMos

Seung-Woo Kim (1):
      clk: samsung: exynos4: Correct SRC_MFC register

Simon Guinot (2):
      ata: sata_mv: introduce compatible string "marvell, armada-370-sata"
      ARM: mvebu: update the SATA compatible string for Armada 370/XP

Srivatsa S. Bhat (1):
      powerpc: Fix the setup of CPU-to-Node mappings during CPU online

Stanislaw Gruszka (1):
      i915: remove pm_qos request on error

Stephen Warren (3):
      serial: 8250: enable UART_BUG_NOMSR for Tegra
      rtc: max8907: weekday encoding fixes
      ALSA: hda/hdmi - allow PIN_OUT to be dynamically enabled

Steven Rostedt (Red Hat) (4):
      ftrace: Fix synchronization location disabling and freeing ftrace_ops
      tracing: Have trace buffer point back to trace_array
      tracing: Check if tracing is enabled in trace_puts()
      ftrace: Have function graph only trace based on global_ops filters

Takashi Iwai (5):
      ALSA: rme9652: fix a missing comma in channel_map_9636_ds[]
      ALSA: hda - Don't create duplicated ctls for loopback paths
      ALSA: Enable CONFIG_ZONE_DMA for smaller PCI DMA masks
      hp_accel: Add a new PnP ID HPQ6007 for new HP laptops
      drm/cirrus: correct register values for 16bpp

Taras Kondratiuk (1):
      ARM: 7938/1: OMAP4/highbank: Flush L2 cache before disabling

Tejun Heo (1):
      libata: disable LPM for some WD SATA-I devices

Tetsuo Handa (1):
      SELinux: Fix memory leak upon loading policy

Theodore Ts'o (1):
      ext4: avoid clearing beyond i_blocks when truncating an inline data file

Thomas Pugliese (1):
      usb: core: get config and string descriptors for unauthorized devices

Todd Previte (1):
      drm/i915: VLV2 - Fix hotplug detect bits

Trond Myklebust (2):
      NFSv4: OPEN must handle the NFS4ERR_IO return code correctly
      NFSv4.1: Handle errors correctly in nfs41_walk_client_list

Vijaya Mohan Guvva (1):
      [SCSI] bfa: Chinook quad port 16G FC HBA claim issue

Ville Syrjälä (1):
      drm/i915: Don't grab crtc mutexes in intel_modeset_gem_init()

Wang Shilong (1):
      Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()

Wanlong Gao (1):
      arch/sh/kernel/kgdb.c: add missing #include <linux/sched.h>

Wei-Chun Chao (1):
      ipv4: fix tunneled VM traffic over hw VXLAN/GRE GSO NIC

Weston Andros Adamson (3):
      sunrpc: Fix infinite loop in RPC state machine
      nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME
      nfs4: fix discover_server_trunking use after free

Yegor Yefremov (1):
      serial: add support for 200 v3 series Titan card

ZHAO Gang (1):
      b43: fix the wrong assignment of status.freq in b43_rx()

张君 (1):
      usb: option: add new zte 3g modem pids to option driver
