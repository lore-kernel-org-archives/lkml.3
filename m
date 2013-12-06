Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161043Ab3LFM7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:59:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43509 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab3LFM73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.11.y.z extended stable] Linux 3.11.10.1 stable review
Date: Fri,  6 Dec 2013 12:54:49 +0000
Message-Id: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.11.10.1 stable kernel.

This version contains 272 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.11.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.11.y-review

The review period for version 3.11.10.1 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.11.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 Documentation/sysctl/kernel.txt               |  25 ++--
 arch/arm/boot/dts/bcm2835.dtsi                |   4 +
 arch/arm/boot/dts/cros5250-common.dtsi        |  12 ++
 arch/arm/kernel/entry-armv.S                  |   1 +
 arch/arm/kvm/mmu.c                            |  34 ++++-
 arch/arm/mach-at91/Makefile                   |   2 +-
 arch/arm/mach-at91/at91sam9260.c              |   2 +
 arch/arm/mach-at91/at91sam9261.c              |   2 +
 arch/arm/mach-at91/at91sam9263.c              |   3 +
 arch/arm/mach-at91/at91sam9g45.c              |   3 +
 arch/arm/mach-at91/at91sam9n12.c              |   6 +
 arch/arm/mach-at91/at91sam9rl.c               |   3 +
 arch/arm/mach-at91/at91sam9x5.c               |   6 +
 arch/arm/mach-at91/generic.h                  |   2 +
 arch/arm/mach-at91/include/mach/at91sam9n12.h |   5 +
 arch/arm/mach-at91/include/mach/at91sam9x5.h  |   5 +
 arch/arm/mach-at91/include/mach/sama5d3.h     |   5 +
 arch/arm/mach-at91/sama5d3.c                  |   6 +
 arch/arm/mach-at91/sysirq_mask.c              |  71 +++++++++++
 arch/arm/mach-imx/clk-imx6q.c                 |   2 +-
 arch/arm/mach-integrator/integrator_cp.c      |   3 +-
 arch/arm/mach-omap2/irq.c                     |   2 +-
 arch/arm/mach-omap2/omap_device.c             |  13 +-
 arch/arm/mach-sa1100/assabet.c                |   3 +
 arch/arm/mm/extable.c                         |   7 +-
 arch/arm64/include/asm/pgtable.h              |  31 ++---
 arch/avr32/boot/u-boot/head.S                 |  35 +++++-
 arch/avr32/kernel/entry-avr32b.S              |   3 +-
 arch/avr32/kernel/head.S                      |  20 ---
 arch/cris/include/asm/io.h                    |   1 +
 arch/parisc/include/asm/socket.h              |  11 ++
 arch/parisc/include/uapi/asm/socket.h         |  11 +-
 arch/powerpc/kernel/eeh.c                     |   9 ++
 arch/powerpc/kernel/signal_32.c               |   6 +
 arch/powerpc/kernel/signal_64.c               |   6 +
 arch/powerpc/kernel/time.c                    |   4 +-
 arch/powerpc/kernel/vio.c                     |   4 +-
 arch/powerpc/mm/slice.c                       |   2 +-
 arch/powerpc/platforms/512x/mpc512x_shared.c  |   3 +
 arch/powerpc/platforms/52xx/Kconfig           |   2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c     |  12 +-
 arch/s390/kernel/smp.c                        |   4 +-
 arch/s390/kernel/vtime.c                      |   2 +-
 arch/s390/lib/uaccess_pt.c                    |   3 +
 arch/x86/kernel/ftrace.c                      |  14 ++-
 arch/x86/kernel/microcode_amd.c               |   2 +-
 arch/x86/kvm/emulate.c                        |   5 +-
 block/blk-core.c                              |   5 +-
 block/blk-settings.c                          |   1 +
 block/blk-timeout.c                           |   3 +-
 crypto/asymmetric_keys/x509_public_key.c      |  38 ------
 drivers/acpi/pci_root.c                       |   3 +
 drivers/acpi/scan.c                           |   2 +-
 drivers/ata/ahci.c                            |   6 +
 drivers/ata/libahci.c                         |  16 +++
 drivers/ata/libata-core.c                     |   1 +
 drivers/ata/libata-transport.c                |  16 +--
 drivers/base/dd.c                             |   2 +-
 drivers/block/brd.c                           |   2 +-
 drivers/block/loop.c                          |  21 ++--
 drivers/block/xen-blkback/blkback.c           |   3 +-
 drivers/clk/mvebu/armada-370.c                |  18 +--
 drivers/cpufreq/highbank-cpufreq.c            |   3 +-
 drivers/dma/ioat/dma_v3.c                     |  48 +++----
 drivers/edac/highbank_l2_edac.c               |  18 +--
 drivers/edac/highbank_mc_edac.c               |  18 +--
 drivers/gpio/gpio-msm-v2.c                    |   2 +-
 drivers/gpio/gpio-mvebu.c                     |   2 +-
 drivers/gpio/gpio-pl061.c                     |  10 +-
 drivers/gpio/gpio-rcar.c                      |   2 +-
 drivers/gpio/gpio-twl4030.c                   |   5 +-
 drivers/gpu/drm/i915/intel_ddi.c              |  20 +++
 drivers/gpu/drm/i915/intel_display.c          |   4 +
 drivers/gpu/drm/i915/intel_dvo.c              |  14 ++-
 drivers/gpu/drm/nouveau/nouveau_gem.c         |   3 +-
 drivers/gpu/drm/qxl/qxl_fb.c                  |   2 +-
 drivers/gpu/drm/qxl/qxl_release.c             |   1 +
 drivers/gpu/drm/radeon/atombios_crtc.c        |   2 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c       |   3 +-
 drivers/gpu/drm/radeon/r600_hdmi.c            |  21 ++--
 drivers/gpu/drm/radeon/radeon_asic.c          |   4 +
 drivers/gpu/drm/radeon/radeon_gart.c          |   2 +
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |  28 +++++
 drivers/gpu/drm/radeon/radeon_semaphore.c     |   6 +-
 drivers/gpu/drm/radeon/radeon_trace.h         |  36 ++++++
 drivers/gpu/drm/radeon/radeon_uvd.c           |   4 +-
 drivers/gpu/drm/radeon/sid.h                  |   2 +-
 drivers/gpu/drm/radeon/trinity_dpm.c          |   6 +-
 drivers/gpu/drm/shmobile/Kconfig              |   1 +
 drivers/gpu/drm/ttm/ttm_bo.c                  |  32 +++--
 drivers/gpu/drm/ttm/ttm_bo_util.c             |  30 +++--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c      |  42 ++++++-
 drivers/hid/Kconfig                           |  11 +-
 drivers/hid/hid-apple.c                       |  22 ++++
 drivers/hid/hid-appleir.c                     |   3 +
 drivers/hid/hid-axff.c                        |   3 +-
 drivers/hid/hid-core.c                        |  18 ++-
 drivers/hid/hid-holtek-mouse.c                |   4 +
 drivers/hid/hid-ids.h                         |  16 ++-
 drivers/hid/hid-lg.c                          |  80 ++++++++++++
 drivers/hid/hid-lg2ff.c                       |   2 +-
 drivers/hid/hid-lg4ff.c                       |  40 +++++-
 drivers/hid/hid-multitouch.c                  |  33 ++++-
 drivers/hid/hid-roccat-common.c               |  12 +-
 drivers/hid/hid-roccat-kovaplus.c             |   4 +
 drivers/hid/hid-sensor-hub.c                  |  13 +-
 drivers/hid/hid-wiimote-modules.c             |   4 +-
 drivers/hid/uhid.c                            |   2 +-
 drivers/hid/usbhid/hid-quirks.c               |   2 +
 drivers/hwmon/lm90.c                          |  11 +-
 drivers/i2c/busses/i2c-wmt.c                  |   1 +
 drivers/i2c/muxes/i2c-mux-gpio.c              |   8 +-
 drivers/iio/accel/kxsd9.c                     |   7 +-
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |   7 +-
 drivers/infiniband/hw/qib/qib_iba7322.c       |  11 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |  20 +--
 drivers/input/evdev.c                         |  16 ++-
 drivers/input/mouse/cypress_ps2.c             |  19 +--
 drivers/input/serio/i8042-x86ia64io.h         |   2 +
 drivers/input/touchscreen/usbtouchscreen.c    |   4 +-
 drivers/md/bcache/btree.c                     |  11 +-
 drivers/md/dm-cache-target.c                  |  54 +++++---
 drivers/md/dm-mpath.c                         |  18 ++-
 drivers/md/dm-table.c                         |  18 ++-
 drivers/md/md.c                               |   1 +
 drivers/md/persistent-data/dm-array.c         |   5 +-
 drivers/media/dvb-frontends/af9013.c          |  14 ++-
 drivers/media/dvb-frontends/af9033.c          |  23 +++-
 drivers/media/dvb-frontends/bcm3510.c         |  15 ++-
 drivers/media/dvb-frontends/cxd2820r_core.c   |  21 +++-
 drivers/media/dvb-frontends/itd1000.c         |  13 +-
 drivers/media/dvb-frontends/mt312.c           |  10 +-
 drivers/media/dvb-frontends/nxt200x.c         |  11 +-
 drivers/media/dvb-frontends/rtl2830.c         |  14 ++-
 drivers/media/dvb-frontends/rtl2832.c         |  14 ++-
 drivers/media/dvb-frontends/s5h1420.c         |  11 +-
 drivers/media/dvb-frontends/stb0899_drv.c     |  12 +-
 drivers/media/dvb-frontends/stb6100.c         |  11 +-
 drivers/media/dvb-frontends/stv0367.c         |  13 +-
 drivers/media/dvb-frontends/stv090x.c         |  12 +-
 drivers/media/dvb-frontends/stv6110.c         |  12 +-
 drivers/media/dvb-frontends/stv6110x.c        |  13 +-
 drivers/media/dvb-frontends/tda10071.c        |  25 +++-
 drivers/media/dvb-frontends/tda18271c2dd.c    |  14 ++-
 drivers/media/dvb-frontends/zl10039.c         |  12 +-
 drivers/media/pci/cx18/cx18-driver.c          |  20 +--
 drivers/media/pci/cx23885/cimax2.c            |  13 +-
 drivers/media/pci/cx23885/cx23885-dvb.c       |   4 +
 drivers/media/pci/ttpci/av7110_hw.c           |  19 ++-
 drivers/media/tuners/e4000.c                  |  25 +++-
 drivers/media/tuners/fc2580.c                 |  25 +++-
 drivers/media/tuners/tda18212.c               |  25 +++-
 drivers/media/tuners/tda18218.c               |  23 +++-
 drivers/media/tuners/tuner-xc2028.c           |   8 +-
 drivers/media/usb/dvb-usb-v2/af9015.c         |   3 +-
 drivers/media/usb/dvb-usb-v2/af9035.c         |  29 ++++-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |  10 +-
 drivers/media/usb/dvb-usb/cxusb.c             |  41 +++++-
 drivers/media/usb/dvb-usb/dibusb-common.c     |  10 +-
 drivers/media/usb/dvb-usb/dw2102.c            |  90 ++++++++++++--
 drivers/mfd/lpc_ich.c                         |  13 ++
 drivers/mfd/rts5249.c                         |  48 ++++++-
 drivers/misc/mei/nfc.c                        |  10 +-
 drivers/mmc/host/atmel-mci.c                  |  21 +++-
 drivers/mtd/devices/m25p80.c                  |  20 ++-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c        |   4 +-
 drivers/mtd/nand/nand_base.c                  |  15 ++-
 drivers/net/can/flexcan.c                     |  12 --
 drivers/net/wireless/ath/ath5k/base.c         |   6 +-
 drivers/net/wireless/iwlegacy/3945.c          |  31 +++--
 drivers/net/wireless/iwlegacy/4965-mac.c      |  18 ++-
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   6 +-
 drivers/net/wireless/mwifiex/sdio.c           |   3 +
 drivers/net/wireless/mwifiex/uap_txrx.c       |  29 ++++-
 drivers/net/wireless/prism54/islpci_dev.c     |   7 +-
 drivers/net/wireless/rt2x00/rt2400pci.c       |   2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c       |  12 +-
 drivers/net/wireless/rtlwifi/base.c           |  93 ++++++--------
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c   |   1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c  |   6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c  |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c  |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c   |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c  |   2 +-
 drivers/net/wireless/rtlwifi/wifi.h           |   6 +-
 drivers/pci/pcie/portdrv_pci.c                |   1 -
 drivers/pinctrl/mvebu/pinctrl-dove.c          |   2 +-
 drivers/regulator/ti-abb-regulator.c          |   2 +-
 drivers/s390/net/qeth_core_main.c             |   6 +-
 drivers/staging/media/lirc/lirc_zilog.c       |  12 +-
 drivers/staging/tidspbridge/Kconfig           |   2 +-
 drivers/staging/vt6656/baseband.c             |  11 ++
 drivers/staging/vt6656/rndis.h                |   2 +
 drivers/staging/zram/zram_drv.c               |  19 ++-
 drivers/staging/zsmalloc/zsmalloc-main.c      |  17 ++-
 drivers/target/iscsi/iscsi_target_auth.c      |   5 +-
 drivers/target/iscsi/iscsi_target_configfs.c  |   5 +
 drivers/target/iscsi/iscsi_target_device.c    |   6 +-
 drivers/target/iscsi/iscsi_target_nego.c      |   2 +-
 drivers/target/target_core_transport.c        |   2 +
 drivers/usb/core/driver.c                     |   3 +
 drivers/usb/core/hub.c                        |  39 ++++++
 drivers/usb/core/sysfs.c                      |   6 +-
 drivers/usb/host/xhci-mem.c                   |  10 --
 drivers/usb/host/xhci.c                       | 165 +++---------------------
 drivers/usb/host/xhci.h                       |   1 +
 drivers/usb/musb/davinci.c                    |  11 +-
 drivers/usb/musb/musb_core.c                  |   3 +
 drivers/usb/musb/musb_dsps.c                  |   6 +
 drivers/usb/musb/musb_virthub.c               |  19 ++-
 drivers/usb/wusbcore/wa-rpipe.c               |   5 +-
 drivers/usb/wusbcore/wa-xfer.c                |   5 +-
 drivers/video/backlight/atmel-pwm-bl.c        |  10 +-
 drivers/video/console/sticore.c               | 166 ++++++++++++++----------
 drivers/video/sticore.h                       |  62 +++++++--
 drivers/video/stifb.c                         |  10 +-
 fs/cifs/cifssmb.c                             |   8 +-
 fs/configfs/dir.c                             |  16 ++-
 fs/devpts/inode.c                             |   1 +
 fs/ext4/xattr.c                               |   1 +
 fs/gfs2/inode.c                               |  30 +++--
 fs/namei.c                                    |   1 +
 fs/nfs/nfs4proc.c                             |  36 +++---
 fs/nfsd/export.c                              |  15 ++-
 fs/nfsd/nfs4xdr.c                             |   4 +-
 fs/nfsd/vfs.c                                 | 173 +++++++++++++++-----------
 fs/xfs/xfs_mount.c                            |  13 +-
 include/acpi/acpi_bus.h                       |   1 +
 include/linux/ipc_namespace.h                 |   6 +-
 include/linux/mfd/rtsx_pci.h                  |  53 ++++++++
 include/linux/msg.h                           |   6 +-
 include/linux/mtd/map.h                       |   4 +-
 include/linux/nfs4.h                          |   2 +-
 include/linux/usb.h                           |   4 +-
 include/linux/vm_event_item.h                 |   1 +
 include/net/netfilter/nf_conntrack_extend.h   |   2 +-
 include/sound/compress_driver.h               |   9 ++
 include/trace/ftrace.h                        |   5 +-
 ipc/ipc_sysctl.c                              |  20 +--
 ipc/msgutil.c                                 |  20 +--
 ipc/sem.c                                     |  42 +++++--
 ipc/util.c                                    |  27 +++-
 ipc/util.h                                    |   4 +-
 kernel/audit.c                                |  27 +++-
 kernel/cpuset.c                               |   8 +-
 kernel/irq/manage.c                           |   2 +-
 kernel/power/snapshot.c                       |   6 +-
 kernel/time/alarmtimer.c                      |   4 +-
 kernel/trace/ftrace.c                         |  64 +++++-----
 kernel/workqueue.c                            |  24 +++-
 lib/vsprintf.c                                |  33 ++++-
 mm/mmap.c                                     |  10 +-
 mm/mprotect.c                                 |   7 +-
 mm/slub.c                                     |   4 +-
 mm/vmstat.c                                   |   1 +
 mm/zswap.c                                    |  22 ++--
 net/9p/trans_virtio.c                         |   5 +
 net/sunrpc/clnt.c                             |  29 +++--
 net/sunrpc/xprtsock.c                         |  28 +++--
 net/wireless/scan.c                           |   4 +-
 security/selinux/netlabel.c                   |   6 +-
 sound/core/compress_offload.c                 |  54 +++++++-
 sound/drivers/pcsp/pcsp.c                     |   2 +-
 sound/isa/msnd/msnd_pinnacle.c                |   4 +-
 sound/pci/hda/hda_codec.c                     |   7 +-
 sound/pci/hda/hda_generic.c                   |  83 ++++++++----
 sound/pci/hda/hda_intel.c                     |  14 ++-
 sound/pci/hda/patch_analog.c                  |   6 +-
 sound/pci/hda/patch_conexant.c                |   3 +
 sound/pci/hda/patch_realtek.c                 |  94 +++++++++++++-
 sound/soc/blackfin/bf5xx-i2s.c                |   1 +
 sound/soc/codecs/ak4642.c                     |   2 +-
 sound/soc/codecs/arizona.c                    |   4 +
 sound/soc/codecs/cs42l52.h                    |   2 +-
 sound/soc/codecs/wm5110.c                     |  43 ++++++-
 sound/soc/codecs/wm8962.c                     |   2 +
 sound/soc/codecs/wm_adsp.c                    |   5 +
 sound/soc/fsl/imx-pcm-fiq.c                   |  29 +++--
 sound/usb/6fire/chip.c                        |   2 +-
 tools/perf/ui/hist.c                          |   2 +-
 tools/perf/util/color.c                       |  11 +-
 tools/perf/util/color.h                       |   2 +-
 virt/kvm/iommu.c                              |   4 +
 283 files changed, 3000 insertions(+), 1178 deletions(-)

Aaron Lu (1):
      PM / hibernate: Avoid overflow in hibernate_preallocate_memory()

Akira Takeuchi (1):
      mm: ensure get_unmapped_area() returns higher address than mmap_min_addr

Alex Deucher (8):
      drm/radeon/vm: don't attempt to update ptes if ib allocation fails
      drm/radeon: adjust TN dpm parameters for stability (v2)
      drm/radeon/si: fix define for MC_SEQ_TRAIN_WAKEUP_CNTL
      drm/radeon: don't share PPLLs on DCE4.1
      drm/radeon: use 64-bit math to calculate CTS values for audio (v2)
      drm/radeon: fix N/CTS clock matching for audio
      drm/radeon: use hw generated CTS/N values for audio
      drm/radeon: re-enable sw ACR support on pre-DCE4

Anatolij Gustschin (1):
      powerpc/52xx: fix build breakage for MPC5200 LPBFIFO module

Anders F. U. Kiær (1):
      HID: add support for LEETGION Hellion Gaming Mouse

Andreas Bießmann (2):
      avr32: setup crt for early panic()
      avr32: fix out-of-range jump in large kernels

Anton Blanchard (2):
      powerpc/pseries: Duplicate dtl entries sometimes sent to userspace
      powerpc: ppc64 address space capped at 32TB, mmap randomisation disabled

Avinash Patil (1):
      mwifiex: correct packet length for packets from SDIO interface

Bart Van Assche (2):
      IB/srp: Report receive errors correctly
      IB/srp: Avoid offlining operational SCSI devices

Ben Skeggs (1):
      drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previous fence

Benjamin Tissoires (1):
      HID: appleir: force input to be set

Brian Austin (1):
      ASoC: cs42l52: Correct MIC CTL mask

Brian Norris (2):
      mtd: nand: hack ONFI for non-power-of-2 dimensions
      mtd: m25p80: fix allocation size

Catalin Marinas (1):
      arm64: Move PTE_PROT_NONE higher up

Charles Keepax (1):
      ASoC: wm5110: Add post SYSCLK register patch for rev D chip

Christian König (3):
      drm/radeon: activate UVD clocks before sending the destroy msg
      drm/radeon: fix UVD destroy IB size
      drm/radeon: add semaphore trace point

Christoffer Dall (1):
      arm/arm64: KVM: Fix hyp mappings of vmalloc regions

Christoph Hellwig (2):
      nfsd: split up nfsd_setattr
      nfsd: make sure to balance get/put_write_access

Christoph Lameter (1):
      slub: Handle NULL parameter in kmem_cache_flags

Dan Carpenter (3):
      gpio: mvebu: make mvchip->irqbase signed for error handling
      gpio: msm: make msm_gpio.summary_irq signed for error handling
      gpio: rcar: NULL dereference on error in probe()

Dan Williams (3):
      ioatdma: fix sed pool selection
      ioatdma: fix selection of 16 vs 8 source path
      prism54: set netdev type to "wlan"

Daniel Stone (1):
      Input: evdev - fall back to vmalloc for client event buffer

Daniel Vetter (3):
      drm/i915: flush cursors harder
      drm/i915: Replicate BIOS eDP bpp clamping hack for hsw
      drm/i915/dvo: call ->mode_set callback only when the port is running

Dave Airlie (2):
      drm/qxl: fix memory leak in release list handling
      qxl: avoid an oops in the deferred io code.

Dave Jiang (1):
      ioatdma: Fix bug in selftest after removal of DMA_MEMSET.

David Henningsson (3):
      ALSA: hda - Add headset quirk for Dell Inspiron 3135
      ALSA: hda - Make sure mute LEDs stay on during runtime suspend (Realtek)
      ALSA: hda - Fix Line Out automute on Realtek multifunction jacks

David Herrmann (2):
      HID: uhid: fix leak for 64/32 UHID_CREATE
      HID: wiimote: fix inverted pro-controller axes

David Howells (1):
      X.509: Remove certificate date checks

Davidlohr Bueso (1):
      ipc: update locking scheme comments

Doug Anderson (1):
      ARM: dts: Add max77686 RTC interrupt to cros5250-common

Elias Vanderstuyft (1):
      HID: logitech - lg2ff: Add IDs for Formula Vibration Feedback Wheel

Emmanuel Grumbach (1):
      iwlwifi: don't WARN on host commands sent when firmware is dead

Eric Dumazet (1):
      iwl3945: better skb management in rx path

Eric Sandeen (1):
      xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields

Eric Seppanen (2):
      iscsi-target: fix extract_param to handle buffer length corner case
      iscsi-target: chap auth shouldn't match username with trailing garbage

Felipe Pena (1):
      rtlwifi: rtl8192se: Fix wrong assignment

Felix Fietkau (1):
      ath5k: fix regression in tx status processing

Forest Bond (3):
      HID: don't ignore eGalax/D-Wav/EETI HIDs
      Input: usbtouchscreen: ignore eGalax/D-Wav/EETI HIDs
      HID: hid-multitouch: add support for SiS panels

Frank Zago (1):
      iio:accel:kxsd9 fix missing mutex unlock

Gavin Shan (2):
      powerpc/eeh: Enable PCI_COMMAND_MASTER for PCI bridges
      powerpc/powernv: Add PE to its own PELTV

Gerhard Sittig (1):
      powerpc/mpc512x: silence build warning upon disabled DIU

Greg Edwards (1):
      KVM: IOMMU: hva align mapping page size

Greg Kroah-Hartman (1):
      Staging: tidspbridge: disable driver

Guenter Roeck (1):
      hwmon: (lm90) Fix max6696 alarm handling

Gwendal Grignou (1):
      libata: Fix display of sata speed

Heiko Carstens (1):
      s390/uaccess: add missing page table walk range check

Helge Deller (2):
      parisc: sticon - unbreak on 64bit kernel
      parisc: break out SOCK_NONBLOCK define to own asm header file

Huang Shijie (1):
      mtd: gpmi: fix kernel BUG due to racing DMA operations

Ilija Hadzic (1):
      devpts: plug the memory leak in kill_sb

Ionut Nicu (2):
      i2c: mux: gpio: use reg value for i2c_add_mux_adapter
      i2c: mux: gpio: use gpio_set_value_cansleep()

J. Bruce Fields (3):
      nfsd4: fix xdr decoding of large non-write compounds
      nfsd: return better errors to exportfs
      nfsd4: fix discarded security labels on setattr

Jakob Bornecrantz (1):
      drm/ttm: Handle in-memory region copies

James Ralston (2):
      ahci: Add Device IDs for Intel Wildcat Point-LP
      mfd: lpc_ich: Add Device IDs for Intel Wildcat Point-LP PCH

Jan Kara (1):
      IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_fast()

Jeff Layton (3):
      audit: add child record before the create to handle case where create fails
      audit: log the audit_names record type
      nfs: fix oops when trying to set SELinux label

Jeff Moyer (1):
      block: fix race between request completion and timeout handling

Jerome Glisse (1):
      radeon: workaround pinning failure on low ram gpu

Jiada Wang (1):
      ARM: i.MX6q: fix the wrong parent of can_root clock

Joe Thornber (2):
      dm array: fix bug in growing array
      dm cache: fix a race condition between queuing new migrations and quiescing for a shutdown

Johan Hovold (4):
      ARM: at91: fix hanged boot due to early rtc-interrupt
      ARM: at91: fix hanged boot due to early rtt-interrupt
      backlight: atmel-pwm-bl: fix gpio polarity in remove
      backlight: atmel-pwm-bl: fix reported brightness

Johannes Berg (1):
      cfg80211: fix scheduled scan pointer access

Johannes Koch (1):
      [media] cx23885: Fix TeVii S471 regression since introduction of ts2020

Jonathan Austin (1):
      ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD

Joseph Salisbury (1):
      Input: cypress_ps2 - do not consider data bad if palm is detected

Julius Werner (1):
      usb: hub: Clear Port Reset Change during init/resume

Junxiao Bi (1):
      configfs: fix race between dentry put and lookup

KOSAKI Motohiro (1):
      alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist

KaiChung Cheng (1):
      HID: multicouh: add PID VID to support 1 new Wistron optical touch device

Kailang Yang (3):
      ALSA: hda/realtek - Add support of ALC231 codec
      ALSA: hda/realtek - Set pcbeep amp for ALC668
      ALSA: hda - Add support of ALC255 codecs

Kent Overstreet (1):
      bcache: Fix dirty_data accounting

Kevin Hao (1):
      ftrace/x86: skip over the breakpoint for ftrace caller

Larry Finger (5):
      rtlwifi: rtl8192cu: Fix more pointer arithmetic errors
      rtlwifi: rtl8188ee: Fix smatch warning in rtl8188ee/hw.c
      rtlwifi: rtl8192de: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192se: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192cu: Fix incorrect signal strength for unassociated AP

Laurent Pinchart (1):
      drm: shmobile: Add dependency on BACKLIGHT_CLASS_DEVICE

Linus Walleij (1):
      gpio: pl061: move irqdomain initialization

Ludovic Desroches (1):
      mmc: atmel-mci: abort transfer on timeout error

Luosong (1):
      HID: multitouch: Fix GeneralTouch products and add more PIDs

Malcolm Priestley (1):
      staging: vt6656: [BUG] Fix for TX USB resets from vendors driver.

Manfred Spraul (1):
      ipc/sem.c: synchronize semop and semctl with IPC_RMID

Marc Kleine-Budde (1):
      can: flexcan: fix flexcan_chip_start() on imx6

Marc Zyngier (1):
      ARM: 7876/1: clear Thumb-2 IT state on exception handling

Mark Cave-Ayland (1):
      rtlwifi: Fix endian error in extracting packet type

Mark Langsdorf (1):
      cpufreq: highbank-cpufreq: Enable Midway/ECX-2000

Markus Pargmann (1):
      ARM: OMAP2+: irq, AM33XX add missing register check

Martin Schwidefsky (1):
      s390/vtime: correct idle time calculation

Mathias Krause (4):
      audit: fix info leak in AUDIT_GET requests
      audit: use nlmsg_len() to get message payload length
      ipc, msg: fix message length check for negative values
      ipc, msg: forbid negative values for "msg{max,mnb,mni}"

Mathias Nyman (1):
      xhci: Enable LPM support only for hardwired or BESL devices

Mauro Carvalho Chehab (19):
      [media] mxl111sf: Don't use dynamic static allocation
      [media] af9035: Don't use dynamic static allocation
      [media] af9015: Don't use dynamic static allocation
      [media] dw2102: Don't use dynamic static allocation
      [media] dibusb-common: Don't use dynamic static allocation
      [media] cxusb: Don't use dynamic static allocation
      [media] av7110_hw: Don't use dynamic static allocation
      [media] cimax2: Don't use dynamic static allocation
      [media] cx18: struct i2c_client is too big for stack
      [media] lirc_zilog: Don't use dynamic static allocation
      [media] tuner-xc2028: Don't use dynamic static allocation
      [media] tuners: Don't use dynamic static allocation
      [media] stv090x: Don't use dynamic static allocation
      [media] stv0367: Don't use dynamic static allocation
      [media] stb0899_drv: Don't use dynamic static allocation
      [media] dvb-frontends: Don't use dynamic static allocation
      [media] dvb-frontends: Don't use dynamic static allocation
      [media] s5h1420: Don't use dynamic static allocation
      cris: media platform drivers: fix build

Mel Gorman (1):
      mm: numa: return the number of base pages altered by protection changes

Michael Hudson-Doyle (1):
      perf tools: Remove cast of non-variadic function to variadic

Michael Marineau (1):
      9p: send uevent after adding/removing mount_tag attribute

Michael Neuling (2):
      powerpc/signals: Mark VSX not saved with small contexts
      powerpc/signals: Improved mark VSX not saved with small contexts fix

Michal Kubeček (1):
      netfilter: nf_conntrack: use RCU safe kfree for conntrack extensions

Mike Marciniszyn (1):
      IB/qib: Fix txselect regression

Mike Snitzer (1):
      block: properly stack underlying max_segment_size to DM device

Miklos Szeredi (2):
      GFS2: d_splice_alias() can't return error
      GFS2: fix dentry leaks

Mikulas Patocka (5):
      loop: fix crash if blk_alloc_queue fails
      loop: fix crash when using unassigned loop device
      dm: allocate buffer for messages with small number of arguments using GFP_NOIO
      blk-core: Fix memory corruption if blkcg_init_queue fails
      block: fix a probe argument to blk_register_region

Nanno Langstraat (1):
      HID: apple: option to swap the 'Option' ("Alt") and 'Command' ("Flag") keys.

Nariman Poushin (1):
      ASoC: wm_adsp: Interpret ADSP memory region lengths as 32 bit words

NeilBrown (1):
      md: fix calculation of stacking limits on level change.

Nicholas Bellinger (2):
      iscsi-target: Fix mutex_trylock usage in iscsit_increment_maxcmdsn
      target: Fix delayed Task Aborted Status (TAS) handling bug

Nicolin Chen (1):
      ASoC: wm8962: Turn on regcache_cache_only before disabling regulator

Nishanth Menon (2):
      ARM: OMAP2+: omap_device: maintain sane runtime pm status around suspend/resume
      regulator: ti-abb: Fix operator precedence typo

Olav Haugan (1):
      staging: zsmalloc: Ensure handle is never 0 on success

Oskar Schirmer (1):
      ASoC: fsl: imx-pcm-fiq: omit fiq counter to avoid harm in unbalanced situations

Paolo Bonzini (1):
      KVM: x86: fix emulation of "movzbl %bpl, %eax"

Paul Moore (1):
      selinux: correct locking in selinux_netlbl_socket_connect)

Peter Zijlstra (1):
      cpuset: Fix memory allocator deadlock

Phil Edworthy (1):
      ASoC: ak4642: prevent un-necessary changes to SG_SL1

Prarit Bhargava (1):
      powerpc/vio: use strcpy in modalias_show

Rafael J. Wysocki (1):
      PM / runtime: Use pm_runtime_put_sync() in __device_release_driver()

Rashika Kheria (1):
      Staging: zram: Fix memory leak by refcount mismatch

Richard Fitzgerald (1):
      ASoC: arizona: Set FLL to free-run before disabling

Robert Richter (1):
      edac, highbank: Fix interrupt setup of mem and l2 controller

Rodolfo Giometti (1):
      mmc: atmel-mci: fix oops in atmci_tasklet_func

Roel Kluin (1):
      pinctrl: dove: unset twsi option3 for gconfig as well

Russell King (1):
      ARM: sa11x0/assabet: ensure CS2 is configured appropriately

Ryan Mallon (1):
      vsprintf: check real user/group id for %pK

Sachin Kamat (1):
      clk: armada-370: Fix incorrect placement of __initconst

Samir Benmendil (1):
      ahci: add Marvell 9230 to the AHCI PCI device list

Samuel Li (1):
      drm/radeon: hook up backlight functions for CI and KV family.

Sarah Sharp (3):
      usb: Disable USB 2.0 Link PM before device reset.
      xhci: Set L1 device slot on USB2 LPM enable/disable.
      usb: Don't enable USB 2.0 Link PM by default.

Sebastian Andrzej Siewior (3):
      usb: musb: call musb_start() only once in OTG mode
      usb: musb: dsps: move try_idle to start hook
      usb: musb: core: properly free host / device structs in err path

Sergei Shtylyov (1):
      usb: musb: davinci: fix resources passed to MUSB driver for DM6467

Shan Hai (1):
      drivers/libata: Set max sector to 65535 for Slimtype DVD A DS8A9SH drive

Shiva Krishna Merla (1):
      dm mpath: fix race condition between multipath_dtr and pg_init_done

Simon Guinot (1):
      clk: armada-370: fix tclk frequencies

Simon Wood (3):
      HID:hid-lg4ff: Scale autocentering force properly on Logitech wheel
      HID:hid-lg4ff: Switch autocentering off when strength is set to zero.
      HID: lg: fix ReportDescriptor for Logitech Formula Vibration

Srinivas Pandruvada (1):
      HID: hid-sensor-hub: fix report size

Stanislaw Gruszka (3):
      rt2400pci: fix RSSI read
      iwl4965: better skb management in rx path
      rt2800usb: slow down TX status polling

Stefan Achatz (3):
      HID: roccat: add new device return value
      HID: roccat: fix Coverity CID 141438
      HID: roccat: add missing special driver declarations

Stephen Warren (1):
      ARM: bcm2835: add missing #xxx-cells to I2C nodes

Steve French (1):
      setfacl removes part of ACL when setting POSIX ACLs to Samba

Steven Rostedt (Red Hat) (2):
      tracing: Allow events to have NULL strings
      ftrace: Fix function graph with loading of modules

Takashi Iwai (18):
      ALSA: hda - Fix unbalanced runtime PM notification at resume
      ALSA: hda - Fix the headphone jack detection on Sony VAIO TX
      ALSA: hda - Provide missing pin configs for VAIO with ALC260
      ALSA: hda - Create Headhpone Mic Jack Mode when really needed
      ALSA: hda - Fix hp-mic mode without VREF bits
      ALSA: hda - Check leaf nodes to find aamix amps
      ALSA: hda - Initialize missing bass speaker pin for ASUS AIO ET2700
      ASoC: blackfin: Fix missing break
      ALSA: 6fire: Fix probe of multiple cards
      ALSA: hda - Enable SPDIF for Acer TravelMate 6293
      ALSA: hda - Force buffer alignment for Haswell HDMI controllers
      ALSA: hda - Add support for CX20952
      ALSA: hda - Add pincfg fixup for ASUS W5A
      ALSA: msnd: Avoid duplicated driver name
      ALSA: hda - Check keep_eapd_on before inv_eapd
      ALSA: hda - Don't turn off EAPD for headphone on Lenovo N100
      ALSA: hda - Don't clear the power state at snd_hda_codec_reset()
      ALSA: pcsp: Fix the order of input device unregistration

Tejun Heo (1):
      workqueue: fix ordered workqueues in NUMA setups

Theodore Ts'o (1):
      ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()

Thomas Hellstrom (3):
      drm/ttm: Fix memory type compatibility check
      drm/ttm: Fix ttm_bo_move_memcpy
      drm/vmwgfx: Resource evict fixes

Thomas Pfaff (1):
      genirq: Set the irq thread policy without checking CAP_SYS_NICE

Thomas Pugliese (2):
      usb: wusbcore: set the RPIPE wMaxPacketSize value correctly
      usb: wusbcore: change WA_SEGS_MAX to a legal value

Thomas Renninger (1):
      x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error

Tom Gundersen (1):
      Input: i8042 - add PNP modaliases

Tomas Winkler (1):
      mei: nfc: fix memory leak in error path

Tony Lindgren (1):
      gpio: twl4030: Fix regression for twl gpio output

Toshi Kani (1):
      ACPI / hotplug: Fix conflicted PCI bridge notify handlers

Tristan Rice (1):
      HID: enable Mayflash USB Gamecube Adapter

Trond Myklebust (6):
      NFSv4: Fix a use-after-free situation in _nfs4_proc_getlk()
      NFSv4: Fix state reference counting in _nfs4_opendata_reclaim_to_nfs4_state
      NFS: Fix a missing initialisation when reading the SELinux label
      NFSv4.2: Fix a mismatch between Linux labeled NFS and the NFSv4.2 spec
      SUNRPC: Fix a data corruption issue when retransmitting RPC calls
      SUNRPC: Avoid deep recursion in rpc_release_client

Tyler Hicks (1):
      audit: printk USER_AVC messages when audit isn't enabled

Ujjal Roy (1):
      mwifiex: fix wrong eth_hdr usage for bridged packets in AP mode

Ursula Braun (1):
      qeth: avoid buffer overflow in snmp ioctl

Vegard Nossum (1):
      xen/blkback: fix reference counting

Vinod Koul (2):
      ALSA: compress: fix drain calls blocking other compress functions
      ALSA: compress: fix drain calls blocking other compress functions (v6)

Vu Pham (1):
      IB/srp: Remove target from list before freeing Scsi_Host structure

Wang Haitao (1):
      mtd: map: fixed bug in 64-bit systems

Wei WANG (1):
      mfd: rtsx: Modify rts5249_optimize_phy

Wei Yongjun (1):
      i2c: wmt: add missing clk_disable_unprepare() on error

Weijie Yang (1):
      mm/zswap: bugfix: memory leak when invalidate and reclaim occur concurrently

Weston Andros Adamson (3):
      NFSv4: fix NULL dereference in open recover
      NFSv4: don't fail on missing fattr in open recover
      NFSv4: don't reprocess cached open CLAIM_PREVIOUS

Yinghai Lu (1):
      PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()

xiangliang yu (1):
      ahci: disabled FBS prior to issuing software reset
