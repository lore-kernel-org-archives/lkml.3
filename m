Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaLNWg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:36:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaLNWgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:36:17 -0500
Date: Sun, 14 Dec 2014 14:36:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core patches for 3.19-rc1
Message-ID: <20141214223616.GA3901@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.19-rc1

for you to fetch changes up to f1c488a78d9f1a22cdb15648c15e70fd82ed229a:

  Revert "ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file entries" (2014-12-06 07:37:11 -0800)

----------------------------------------------------------------
Driver core patches for 3.19-rc1

Here's the set of driver core patches for 3.19-rc1.

They are dominated by the removal of the .owner field in platform
drivers.  They touch a lot of files, but they are "simple" changes, just
removing a line in a structure.

Other than that, a few minor driver core and debugfs changes.  There are
some ath9k patches coming in through this tree that have been acked by
the wireless maintainers as they relied on the debugfs changes.

Everything has been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alex Williamson (1):
      driver core: Fix unbalanced device reference in drivers_probe

Arend van Spriel (4):
      debugfs: add helper function to create device related seq_file
      ath: use seq_file api for ath9k debugfs files
      ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file entries
      fs: debugfs: add forward declaration for struct device type

Greg Kroah-Hartman (2):
      Merge branch 'platform/remove_owner' of git://git.kernel.org/.../wsa/linux into driver-core-next
      Revert "ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file entries"

Joe Perches (1):
      device: Add dev_<level>_once variants

Johannes Berg (1):
      devcoredump: provide a one-way disable function

Kweh, Hock Leong (1):
      firmware loader: fix hung task warning dump

Markus Elfring (1):
      firmware class: Deletion of an unnecessary check before the function call "vunmap"

NeilBrown (2):
      sysfs/kernfs: allow attributes to request write buffer be pre-allocated.
      sysfs/kernfs: make read requests on pre-alloc files use the buffer.

Pankaj Dubey (1):
      kobject: fix NULL pointer derefernce in kobj_child_ns_ops

Sergey Klyaus (1):
      driver core: fix race with userland in device_add()

Sudeep Holla (5):
      cpumask: factor out show_cpumap into separate helper function
      topology: replace custom attribute macros with standard DEVICE_ATTR*
      drivers: base: add cpu_device_create to support per-cpu devices
      drivers: base: support cpu cache information interface to userspace via sysfs
      drivers/base: cacheinfo: remove noisy error boot message

Vladimir Zapolskiy (1):
      fs: sysfs: return EGBIG on write if offset is larger than file size

Wolfram Sang (304):
      ARM: common: drop owner assignment from platform_drivers
      ARM: mach-davinci: drop owner assignment from platform_drivers
      ARM: mach-imx: drop owner assignment from platform_drivers
      ARM: mach-msm: drop owner assignment from platform_drivers
      ARM: mach-omap2: drop owner assignment from platform_drivers
      ARM: mach-prima2: drop owner assignment from platform_drivers
      ARM: mach-pxa: drop owner assignment from platform_drivers
      ARM: mach-s3c24xx: drop owner assignment from platform_drivers
      ARM: mach-sa1100: drop owner assignment from platform_drivers
      ARM: mach-u300: drop owner assignment from platform_drivers
      ARM: plat-pxa: drop owner assignment from platform_drivers
      ARM: plat-samsung: drop owner assignment from platform_drivers
      mips: lantiq: xway: drop owner assignment from platform_drivers
      mips: mti-sead3: drop owner assignment from platform_drivers
      mips: pci: drop owner assignment from platform_drivers
      mips: ralink: drop owner assignment from platform_drivers
      mips: txx9: rbtx4939: drop owner assignment from platform_drivers
      powerpc: kernel: drop owner assignment from platform_drivers
      powerpc: platforms: 52xx: drop owner assignment from platform_drivers
      powerpc: platforms: 82xx: drop owner assignment from platform_drivers
      powerpc: platforms: 83xx: drop owner assignment from platform_drivers
      powerpc: platforms: 85xx: drop owner assignment from platform_drivers
      powerpc: platforms: cell: drop owner assignment from platform_drivers
      powerpc: platforms: pasemi: drop owner assignment from platform_drivers
      powerpc: sysdev: drop owner assignment from platform_drivers
      powerpc: sysdev: qe_lib: drop owner assignment from platform_drivers
      s390: appldata: drop owner assignment from platform_drivers
      sparc: include: asm: drop owner assignment from platform_drivers
      sparc: kernel: drop owner assignment from platform_drivers
      x86: platform: iris: drop owner assignment from platform_drivers
      x86: platform: olpc: drop owner assignment from platform_drivers
      acpi: apei: drop owner assignment from platform_drivers
      amba: drop owner assignment from platform_drivers
      ata: drop owner assignment from platform_drivers
      atm: drop owner assignment from platform_drivers
      block: drop owner assignment from platform_drivers
      bluetooth: drop owner assignment from platform_drivers
      bus: drop owner assignment from platform_drivers
      char: drop owner assignment from platform_drivers
      char: hw_random: drop owner assignment from platform_drivers
      char: ipmi: drop owner assignment from platform_drivers
      char: tpm: drop owner assignment from platform_drivers
      char: xillybus: drop owner assignment from platform_drivers
      clk: drop owner assignment from platform_drivers
      clk: qcom: drop owner assignment from platform_drivers
      clk: samsung: drop owner assignment from platform_drivers
      clk: ux500: drop owner assignment from platform_drivers
      clk: x86: drop owner assignment from platform_drivers
      cpufreq: drop owner assignment from platform_drivers
      cpuidle: drop owner assignment from platform_drivers
      crypto: drop owner assignment from platform_drivers
      crypto: amcc: drop owner assignment from platform_drivers
      crypto: caam: drop owner assignment from platform_drivers
      crypto: ccp: drop owner assignment from platform_drivers
      crypto: qce: drop owner assignment from platform_drivers
      crypto: ux500: cryp: drop owner assignment from platform_drivers
      crypto: ux500: hash: drop owner assignment from platform_drivers
      devfreq: exynos: drop owner assignment from platform_drivers
      dma: drop owner assignment from platform_drivers
      dma: bestcomm: drop owner assignment from platform_drivers
      dma: ipu: drop owner assignment from platform_drivers
      dma: ppc4xx: drop owner assignment from platform_drivers
      dma: sh: drop owner assignment from platform_drivers
      edac: drop owner assignment from platform_drivers
      extcon: drop owner assignment from platform_drivers
      firmware: drop owner assignment from platform_drivers
      gpio: drop owner assignment from platform_drivers
      gpu: drm: armada: drop owner assignment from platform_drivers
      gpu: drm: exynos: drop owner assignment from platform_drivers
      gpu: drm: msm: drop owner assignment from platform_drivers
      gpu: drm: omapdrm: drop owner assignment from platform_drivers
      gpu: drm: panel: drop owner assignment from platform_drivers
      gpu: drm: rcar-du: drop owner assignment from platform_drivers
      gpu: drm: shmobile: drop owner assignment from platform_drivers
      gpu: drm: sti: drop owner assignment from platform_drivers
      gpu: drm: tilcdc: drop owner assignment from platform_drivers
      hsi: controllers: drop owner assignment from platform_drivers
      hwmon: drop owner assignment from platform_drivers
      hwspinlock: drop owner assignment from platform_drivers
      i2c: busses: drop owner assignment from platform_drivers
      i2c: muxes: drop owner assignment from platform_drivers
      ide: drop owner assignment from platform_drivers
      iio: adc: drop owner assignment from platform_drivers
      input: keyboard: drop owner assignment from platform_drivers
      input: misc: drop owner assignment from platform_drivers
      input: mouse: drop owner assignment from platform_drivers
      input: serio: drop owner assignment from platform_drivers
      input: touchscreen: drop owner assignment from platform_drivers
      iommu: drop owner assignment from platform_drivers
      irqchip: drop owner assignment from platform_drivers
      leds: drop owner assignment from platform_drivers
      macintosh: drop owner assignment from platform_drivers
      mailbox: drop owner assignment from platform_drivers
      media: platform: drop owner assignment from platform_drivers
      media: platform: blackfin: drop owner assignment from platform_drivers
      media: platform: coda: drop owner assignment from platform_drivers
      media: platform: davinci: drop owner assignment from platform_drivers
      media: platform: exynos4-is: drop owner assignment from platform_drivers
      media: platform: exynos-gsc: drop owner assignment from platform_drivers
      media: platform: marvell-ccic: drop owner assignment from platform_drivers
      media: platform: omap3isp: drop owner assignment from platform_drivers
      media: platform: s3c-camif: drop owner assignment from platform_drivers
      media: platform: s5p-g2d: drop owner assignment from platform_drivers
      media: platform: s5p-jpeg: drop owner assignment from platform_drivers
      media: platform: s5p-mfc: drop owner assignment from platform_drivers
      media: platform: s5p-tv: drop owner assignment from platform_drivers
      media: platform: soc_camera: drop owner assignment from platform_drivers
      media: platform: ti-vpe: drop owner assignment from platform_drivers
      media: platform: vsp1: drop owner assignment from platform_drivers
      media: radio: drop owner assignment from platform_drivers
      media: radio: si4713: drop owner assignment from platform_drivers
      media: rc: drop owner assignment from platform_drivers
      media: rc: img-ir: drop owner assignment from platform_drivers
      memory: drop owner assignment from platform_drivers
      memstick: host: drop owner assignment from platform_drivers
      mfd: drop owner assignment from platform_drivers
      misc: drop owner assignment from platform_drivers
      misc: carma: drop owner assignment from platform_drivers
      misc: eeprom: drop owner assignment from platform_drivers
      misc: mic: card: drop owner assignment from platform_drivers
      misc: ti-st: drop owner assignment from platform_drivers
      mmc: host: drop owner assignment from platform_drivers
      mtd: devices: drop owner assignment from platform_drivers
      mtd: maps: drop owner assignment from platform_drivers
      mtd: nand: drop owner assignment from platform_drivers
      mtd: nand: bcm47xxnflash: drop owner assignment from platform_drivers
      mtd: onenand: drop owner assignment from platform_drivers
      mtd: spi-nor: drop owner assignment from platform_drivers
      net: can: drop owner assignment from platform_drivers
      net: can: cc770: drop owner assignment from platform_drivers
      net: can: c_can: drop owner assignment from platform_drivers
      net: can: mscan: drop owner assignment from platform_drivers
      net: can: sja1000: drop owner assignment from platform_drivers
      net: can: softing: drop owner assignment from platform_drivers
      net: ethernet: drop owner assignment from platform_drivers
      net: ethernet: 8390: drop owner assignment from platform_drivers
      net: ethernet: adi: drop owner assignment from platform_drivers
      net: ethernet: aeroflex: drop owner assignment from platform_drivers
      net: ethernet: altera: drop owner assignment from platform_drivers
      net: ethernet: amd: drop owner assignment from platform_drivers
      net: ethernet: apple: drop owner assignment from platform_drivers
      net: ethernet: broadcom: drop owner assignment from platform_drivers
      net: ethernet: broadcom: genet: drop owner assignment from platform_drivers
      net: ethernet: cadence: drop owner assignment from platform_drivers
      net: ethernet: cirrus: drop owner assignment from platform_drivers
      net: ethernet: davicom: drop owner assignment from platform_drivers
      net: ethernet: faraday: drop owner assignment from platform_drivers
      net: ethernet: freescale: drop owner assignment from platform_drivers
      net: ethernet: freescale: fs_enet: drop owner assignment from platform_drivers
      net: ethernet: i825xx: drop owner assignment from platform_drivers
      net: ethernet: ibm: emac: drop owner assignment from platform_drivers
      net: ethernet: marvell: drop owner assignment from platform_drivers
      net: ethernet: micrel: drop owner assignment from platform_drivers
      net: ethernet: moxa: drop owner assignment from platform_drivers
      net: ethernet: natsemi: drop owner assignment from platform_drivers
      net: ethernet: nuvoton: drop owner assignment from platform_drivers
      net: ethernet: octeon: drop owner assignment from platform_drivers
      net: ethernet: samsung: sxgbe: drop owner assignment from platform_drivers
      net: ethernet: seeq: drop owner assignment from platform_drivers
      net: ethernet: sgi: drop owner assignment from platform_drivers
      net: ethernet: smsc: drop owner assignment from platform_drivers
      net: ethernet: sun: drop owner assignment from platform_drivers
      net: ethernet: tundra: drop owner assignment from platform_drivers
      net: ethernet: via: drop owner assignment from platform_drivers
      net: ethernet: wiznet: drop owner assignment from platform_drivers
      net: ieee802154: drop owner assignment from platform_drivers
      net: irda: drop owner assignment from platform_drivers
      net: phy: drop owner assignment from platform_drivers
      net: wireless: drop owner assignment from platform_drivers
      net: wireless: ath: ath9k: drop owner assignment from platform_drivers
      net: wireless: ath: wcn36xx: drop owner assignment from platform_drivers
      net: wireless: brcm80211: brcmfmac: drop owner assignment from platform_drivers
      net: wireless: rt2x00: drop owner assignment from platform_drivers
      net: wireless: ti: wl12xx: drop owner assignment from platform_drivers
      net: wireless: ti: wl18xx: drop owner assignment from platform_drivers
      nfc: drop owner assignment from platform_drivers
      parport: drop owner assignment from platform_drivers
      pci: host: drop owner assignment from platform_drivers
      pcmcia: drop owner assignment from platform_drivers
      pinctrl: drop owner assignment from platform_drivers
      pinctrl: berlin: drop owner assignment from platform_drivers
      pinctrl: freescale: drop owner assignment from platform_drivers
      pinctrl: mvebu: drop owner assignment from platform_drivers
      pinctrl: nomadik: drop owner assignment from platform_drivers
      pinctrl: qcom: drop owner assignment from platform_drivers
      pinctrl: samsung: drop owner assignment from platform_drivers
      pinctrl: sh-pfc: drop owner assignment from platform_drivers
      pinctrl: sirf: drop owner assignment from platform_drivers
      pinctrl: spear: drop owner assignment from platform_drivers
      pinctrl: sunxi: drop owner assignment from platform_drivers
      pinctrl: vt8500: drop owner assignment from platform_drivers
      platform: chrome: drop owner assignment from platform_drivers
      platform: x86: drop owner assignment from platform_drivers
      power: drop owner assignment from platform_drivers
      power: reset: drop owner assignment from platform_drivers
      pps: clients: drop owner assignment from platform_drivers
      pwm: drop owner assignment from platform_drivers
      regulator: drop owner assignment from platform_drivers
      remoteproc: drop owner assignment from platform_drivers
      reset: drop owner assignment from platform_drivers
      reset: sti: drop owner assignment from platform_drivers
      rtc: drop owner assignment from platform_drivers
      s390: block: drop owner assignment from platform_drivers
      s390: char: drop owner assignment from platform_drivers
      sbus: char: drop owner assignment from platform_drivers
      scsi: drop owner assignment from platform_drivers
      scsi: ufs: drop owner assignment from platform_drivers
      soc: qcom: drop owner assignment from platform_drivers
      soc: tegra: fuse: drop owner assignment from platform_drivers
      soc: ti: drop owner assignment from platform_drivers
      spi: drop owner assignment from platform_drivers
      spmi: drop owner assignment from platform_drivers
      staging: android: drop owner assignment from platform_drivers
      staging: emxx_udc: drop owner assignment from platform_drivers
      staging: iio: adc: drop owner assignment from platform_drivers
      staging: iio: trigger: drop owner assignment from platform_drivers
      staging: imx-drm: drop owner assignment from platform_drivers
      staging: media: davinci_vpfe: drop owner assignment from platform_drivers
      staging: media: lirc: drop owner assignment from platform_drivers
      staging: media: omap24xx: drop owner assignment from platform_drivers
      staging: media: omap4iss: drop owner assignment from platform_drivers
      staging: netlogic: drop owner assignment from platform_drivers
      staging: nvec: drop owner assignment from platform_drivers
      staging: octeon: drop owner assignment from platform_drivers
      staging: octeon-usb: drop owner assignment from platform_drivers
      staging: ozwpan: drop owner assignment from platform_drivers
      thermal: drop owner assignment from platform_drivers
      thermal: samsung: drop owner assignment from platform_drivers
      thermal: st: drop owner assignment from platform_drivers
      tty: drop owner assignment from platform_drivers
      tty: hvc: drop owner assignment from platform_drivers
      tty: serial: drop owner assignment from platform_drivers
      tty: serial: 8250: drop owner assignment from platform_drivers
      tty: serial: cpm_uart: drop owner assignment from platform_drivers
      uio: drop owner assignment from platform_drivers
      usb: c67x00: drop owner assignment from platform_drivers
      usb: chipidea: drop owner assignment from platform_drivers
      usb: dwc2: drop owner assignment from platform_drivers
      usb: gadget: legacy: drop owner assignment from platform_drivers
      usb: gadget: udc: drop owner assignment from platform_drivers
      usb: host: drop owner assignment from platform_drivers
      usb: misc: drop owner assignment from platform_drivers
      usb: musb: drop owner assignment from platform_drivers
      usb: phy: drop owner assignment from platform_drivers
      usb: usbip: drop owner assignment from platform_drivers
      video: fbdev: drop owner assignment from platform_drivers
      video: fbdev: exynos: drop owner assignment from platform_drivers
      video: fbdev: mb862xx: drop owner assignment from platform_drivers
      video: fbdev: mmp: fb: drop owner assignment from platform_drivers
      video: fbdev: mmp: hw: drop owner assignment from platform_drivers
      video: fbdev: omap: drop owner assignment from platform_drivers
      video: fbdev: omap2: displays-new: drop owner assignment from platform_drivers
      video: fbdev: omap2: dss: drop owner assignment from platform_drivers
      video: fbdev: omap2: omapfb: drop owner assignment from platform_drivers
      virtio: drop owner assignment from platform_drivers
      w1: masters: drop owner assignment from platform_drivers
      watchdog: drop owner assignment from platform_drivers
      zorro: drop owner assignment from platform_drivers
      pstore: drop owner assignment from platform_drivers
      net: dsa: drop owner assignment from platform_drivers
      net: rfkill: drop owner assignment from platform_drivers
      ALSA: arm: drop owner assignment from platform_drivers
      ALSA: atmel: drop owner assignment from platform_drivers
      ALSA: drivers: drop owner assignment from platform_drivers
      ALSA: drivers: mpu401: drop owner assignment from platform_drivers
      ALSA: drivers: pcsp: drop owner assignment from platform_drivers
      ALSA: mips: drop owner assignment from platform_drivers
      OSS: dmasound: drop owner assignment from platform_drivers
      ALSA: ppc: drop owner assignment from platform_drivers
      ALSA: sh: drop owner assignment from platform_drivers
      ASoC: : drop owner assignment from platform_drivers
      ASoC: adi: drop owner assignment from platform_drivers
      ASoC: atmel: drop owner assignment from platform_drivers
      ASoC: au1x: drop owner assignment from platform_drivers
      ASoC: bcm: drop owner assignment from platform_drivers
      ASoC: blackfin: drop owner assignment from platform_drivers
      ASoC: cirrus: drop owner assignment from platform_drivers
      ASoC: codecs: drop owner assignment from platform_drivers
      ASoC: davinci: drop owner assignment from platform_drivers
      ASoC: dwc: drop owner assignment from platform_drivers
      ASoC: fsl: drop owner assignment from platform_drivers
      ASoC: generic: drop owner assignment from platform_drivers
      ASoC: intel: drop owner assignment from platform_drivers
      ASoC: jz4740: drop owner assignment from platform_drivers
      ASoC: kirkwood: drop owner assignment from platform_drivers
      ASoC: mxs: drop owner assignment from platform_drivers
      ASoC: nuc900: drop owner assignment from platform_drivers
      ASoC: omap: drop owner assignment from platform_drivers
      ASoC: pxa: drop owner assignment from platform_drivers
      ASoC: rockchip: drop owner assignment from platform_drivers
      ASoC: s6000: drop owner assignment from platform_drivers
      ASoC: samsung: drop owner assignment from platform_drivers
      ASoC: sh: drop owner assignment from platform_drivers
      ASoC: sirf: drop owner assignment from platform_drivers
      ASoC: spear: drop owner assignment from platform_drivers
      ASoC: tegra: drop owner assignment from platform_drivers
      ASoC: txx9: drop owner assignment from platform_drivers
      ASoC: ux500: drop owner assignment from platform_drivers
      ALSA: sparc: drop owner assignment from platform_drivers
      core: platform: add warning if driver has no owner
      core: platform: let platform_driver_probe initialize module owner
      core: platform: let platform_create_bundle initialize module owner
      coccinelle: api: add spatch to prevent unnecessary .owner
      Revert "core: platform: add warning if driver has no owner"

 Documentation/ABI/testing/sysfs-devices-system-cpu |  47 ++
 arch/arm/common/sa1111.c                           |   1 -
 arch/arm/mach-davinci/cpuidle.c                    |   1 -
 arch/arm/mach-davinci/pm.c                         |   1 -
 arch/arm/mach-imx/mmdc.c                           |   1 -
 arch/arm/mach-msm/clock-pcom.c                     |   1 -
 arch/arm/mach-msm/smd.c                            |   1 -
 arch/arm/mach-omap2/gpmc.c                         |   1 -
 arch/arm/mach-prima2/pm.c                          |   1 -
 arch/arm/mach-prima2/rstc.c                        |   1 -
 arch/arm/mach-prima2/rtciobrg.c                    |   1 -
 arch/arm/mach-pxa/pxa3xx-ulpi.c                    |   1 -
 arch/arm/mach-pxa/tosa-bt.c                        |   1 -
 arch/arm/mach-s3c24xx/mach-osiris-dvs.c            |   1 -
 arch/arm/mach-sa1100/neponset.c                    |   1 -
 arch/arm/mach-u300/regulator.c                     |   1 -
 arch/arm/plat-pxa/ssp.c                            |   1 -
 arch/arm/plat-samsung/adc.c                        |   1 -
 arch/mips/lantiq/xway/dcdc.c                       |   1 -
 arch/mips/lantiq/xway/dma.c                        |   1 -
 arch/mips/lantiq/xway/gptu.c                       |   1 -
 arch/mips/lantiq/xway/xrx200_phy_fw.c              |   1 -
 arch/mips/mti-sead3/leds-sead3.c                   |   1 -
 arch/mips/mti-sead3/sead3-i2c-drv.c                |   1 -
 arch/mips/pci/pci-alchemy.c                        |   1 -
 arch/mips/pci/pci-ar71xx.c                         |   1 -
 arch/mips/pci/pci-ar724x.c                         |   1 -
 arch/mips/pci/pci-lantiq.c                         |   1 -
 arch/mips/pci/pci-rt3883.c                         |   1 -
 arch/mips/ralink/timer.c                           |   1 -
 arch/mips/txx9/rbtx4939/setup.c                    |   1 -
 arch/powerpc/kernel/of_platform.c                  |   1 -
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c          |   1 -
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |   1 -
 arch/powerpc/platforms/82xx/ep8248e.c              |   1 -
 arch/powerpc/platforms/83xx/suspend.c              |   1 -
 arch/powerpc/platforms/85xx/sgy_cts1000.c          |   1 -
 arch/powerpc/platforms/cell/axon_msi.c             |   1 -
 arch/powerpc/platforms/pasemi/gpio_mdio.c          |   1 -
 arch/powerpc/sysdev/axonram.c                      |   1 -
 arch/powerpc/sysdev/fsl_85xx_l2ctlr.c              |   1 -
 arch/powerpc/sysdev/fsl_msi.c                      |   1 -
 arch/powerpc/sysdev/fsl_pmc.c                      |   1 -
 arch/powerpc/sysdev/fsl_rio.c                      |   1 -
 arch/powerpc/sysdev/mpic_msgr.c                    |   1 -
 arch/powerpc/sysdev/pmi.c                          |   1 -
 arch/powerpc/sysdev/ppc4xx_hsta_msi.c              |   1 -
 arch/powerpc/sysdev/ppc4xx_msi.c                   |   1 -
 arch/powerpc/sysdev/qe_lib/qe.c                    |   1 -
 arch/s390/appldata/appldata_base.c                 |   1 -
 arch/sparc/include/asm/parport.h                   |   1 -
 arch/sparc/kernel/apc.c                            |   1 -
 arch/sparc/kernel/auxio_64.c                       |   1 -
 arch/sparc/kernel/central.c                        |   2 -
 arch/sparc/kernel/chmc.c                           |   1 -
 arch/sparc/kernel/leon_pci_grpci1.c                |   1 -
 arch/sparc/kernel/leon_pci_grpci2.c                |   1 -
 arch/sparc/kernel/pci_fire.c                       |   1 -
 arch/sparc/kernel/pci_psycho.c                     |   1 -
 arch/sparc/kernel/pci_sabre.c                      |   1 -
 arch/sparc/kernel/pci_schizo.c                     |   1 -
 arch/sparc/kernel/pci_sun4v.c                      |   1 -
 arch/sparc/kernel/pmc.c                            |   1 -
 arch/sparc/kernel/power.c                          |   1 -
 arch/sparc/kernel/time_32.c                        |   1 -
 arch/sparc/kernel/time_64.c                        |   3 -
 arch/x86/kernel/cpu/perf_event_amd_iommu.c         |   5 +-
 arch/x86/kernel/cpu/perf_event_amd_uncore.c        |   6 +-
 arch/x86/kernel/cpu/perf_event_intel_rapl.c        |   6 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |   6 +-
 arch/x86/platform/iris/iris.c                      |   1 -
 arch/x86/platform/olpc/olpc-xo1-pm.c               |   2 -
 drivers/acpi/acpi_pad.c                            |   8 +-
 drivers/acpi/apei/ghes.c                           |   1 -
 drivers/amba/tegra-ahb.c                           |   1 -
 drivers/ata/ahci_da850.c                           |   1 -
 drivers/ata/ahci_imx.c                             |   1 -
 drivers/ata/ahci_mvebu.c                           |   1 -
 drivers/ata/ahci_platform.c                        |   1 -
 drivers/ata/ahci_st.c                              |   1 -
 drivers/ata/ahci_sunxi.c                           |   1 -
 drivers/ata/ahci_xgene.c                           |   1 -
 drivers/ata/pata_arasan_cf.c                       |   1 -
 drivers/ata/pata_at32.c                            |   1 -
 drivers/ata/pata_at91.c                            |   1 -
 drivers/ata/pata_bf54x.c                           |   1 -
 drivers/ata/pata_ep93xx.c                          |   1 -
 drivers/ata/pata_imx.c                             |   1 -
 drivers/ata/pata_ixp4xx_cf.c                       |   1 -
 drivers/ata/pata_mpc52xx.c                         |   1 -
 drivers/ata/pata_octeon_cf.c                       |   1 -
 drivers/ata/pata_of_platform.c                     |   1 -
 drivers/ata/pata_palmld.c                          |   1 -
 drivers/ata/pata_platform.c                        |   1 -
 drivers/ata/pata_pxa.c                             |   1 -
 drivers/ata/pata_rb532_cf.c                        |   1 -
 drivers/ata/pata_samsung_cf.c                      |   1 -
 drivers/ata/sata_dwc_460ex.c                       |   1 -
 drivers/ata/sata_fsl.c                             |   1 -
 drivers/ata/sata_highbank.c                        |   1 -
 drivers/ata/sata_mv.c                              |   1 -
 drivers/ata/sata_rcar.c                            |   1 -
 drivers/atm/fore200e.c                             |   1 -
 drivers/base/Makefile                              |   2 +-
 drivers/base/bus.c                                 |   8 +-
 drivers/base/cacheinfo.c                           | 539 +++++++++++++++++++++
 drivers/base/core.c                                |  38 +-
 drivers/base/cpu.c                                 |  59 ++-
 drivers/base/devcoredump.c                         |  56 ++-
 drivers/base/firmware_class.c                      |   7 +-
 drivers/base/node.c                                |  14 +-
 drivers/base/platform.c                            |  22 +-
 drivers/base/topology.c                            |  71 +--
 drivers/block/amiflop.c                            |   1 -
 drivers/block/mg_disk.c                            |   1 -
 drivers/block/swim.c                               |   1 -
 drivers/bluetooth/btwilink.c                       |   1 -
 drivers/bus/brcmstb_gisb.c                         |   1 -
 drivers/bus/imx-weim.c                             |   1 -
 drivers/bus/omap-ocp2scp.c                         |   1 -
 drivers/bus/omap_l3_noc.c                          |   1 -
 drivers/char/hw_random/atmel-rng.c                 |   1 -
 drivers/char/hw_random/bcm2835-rng.c               |   1 -
 drivers/char/hw_random/bcm63xx-rng.c               |   1 -
 drivers/char/hw_random/exynos-rng.c                |   1 -
 drivers/char/hw_random/msm-rng.c                   |   1 -
 drivers/char/hw_random/mxc-rnga.c                  |   1 -
 drivers/char/hw_random/n2-drv.c                    |   1 -
 drivers/char/hw_random/octeon-rng.c                |   1 -
 drivers/char/hw_random/omap-rng.c                  |   1 -
 drivers/char/hw_random/omap3-rom-rng.c             |   1 -
 drivers/char/hw_random/pasemi-rng.c                |   1 -
 drivers/char/hw_random/ppc4xx-rng.c                |   1 -
 drivers/char/hw_random/timeriomem-rng.c            |   1 -
 drivers/char/hw_random/tx4939-rng.c                |   1 -
 drivers/char/ipmi/ipmi_si_intf.c                   |   1 -
 drivers/char/sonypi.c                              |   1 -
 drivers/char/tb0219.c                              |   1 -
 drivers/char/tpm/tpm_atmel.c                       |   1 -
 drivers/char/tpm/tpm_nsc.c                         |   1 -
 drivers/char/tpm/tpm_tis.c                         |   1 -
 drivers/char/xillybus/xillybus_of.c                |   1 -
 drivers/clk/clk-axm5516.c                          |   1 -
 drivers/clk/clk-ppc-corenet.c                      |   1 -
 drivers/clk/clk-s2mps11.c                          |   1 -
 drivers/clk/qcom/gcc-apq8084.c                     |   1 -
 drivers/clk/qcom/gcc-ipq806x.c                     |   1 -
 drivers/clk/qcom/gcc-msm8660.c                     |   1 -
 drivers/clk/qcom/gcc-msm8960.c                     |   1 -
 drivers/clk/qcom/gcc-msm8974.c                     |   1 -
 drivers/clk/samsung/clk-exynos-audss.c             |   1 -
 drivers/clk/samsung/clk-s5pv210-audss.c            |   1 -
 drivers/clk/ux500/abx500-clk.c                     |   1 -
 drivers/clk/x86/clk-lpt.c                          |   1 -
 drivers/cpufreq/arm_big_little_dt.c                |   1 -
 drivers/cpufreq/cpufreq-dt.c                       |   1 -
 drivers/cpufreq/davinci-cpufreq.c                  |   1 -
 drivers/cpufreq/dbx500-cpufreq.c                   |   1 -
 drivers/cpufreq/exynos-cpufreq.c                   |   1 -
 drivers/cpufreq/exynos5440-cpufreq.c               |   1 -
 drivers/cpufreq/imx6q-cpufreq.c                    |   1 -
 drivers/cpufreq/integrator-cpufreq.c               |   1 -
 drivers/cpufreq/kirkwood-cpufreq.c                 |   1 -
 drivers/cpufreq/loongson2_cpufreq.c                |   1 -
 drivers/cpufreq/omap-cpufreq.c                     |   1 -
 drivers/cpufreq/s5pv210-cpufreq.c                  |   1 -
 drivers/cpufreq/spear-cpufreq.c                    |   1 -
 drivers/cpufreq/vexpress-spc-cpufreq.c             |   1 -
 drivers/cpuidle/cpuidle-at91.c                     |   1 -
 drivers/cpuidle/cpuidle-calxeda.c                  |   1 -
 drivers/cpuidle/cpuidle-clps711x.c                 |   1 -
 drivers/cpuidle/cpuidle-exynos.c                   |   1 -
 drivers/cpuidle/cpuidle-kirkwood.c                 |   1 -
 drivers/cpuidle/cpuidle-mvebu-v7.c                 |   3 -
 drivers/cpuidle/cpuidle-ux500.c                    |   1 -
 drivers/cpuidle/cpuidle-zynq.c                     |   1 -
 drivers/crypto/amcc/crypto4xx_core.c               |   1 -
 drivers/crypto/atmel-aes.c                         |   1 -
 drivers/crypto/atmel-sha.c                         |   1 -
 drivers/crypto/atmel-tdes.c                        |   1 -
 drivers/crypto/bfin_crc.c                          |   1 -
 drivers/crypto/caam/ctrl.c                         |   1 -
 drivers/crypto/caam/jr.c                           |   1 -
 drivers/crypto/ccp/ccp-platform.c                  |   1 -
 drivers/crypto/mv_cesa.c                           |   1 -
 drivers/crypto/mxs-dcp.c                           |   1 -
 drivers/crypto/n2_core.c                           |   2 -
 drivers/crypto/omap-aes.c                          |   1 -
 drivers/crypto/omap-des.c                          |   1 -
 drivers/crypto/omap-sham.c                         |   1 -
 drivers/crypto/qce/core.c                          |   1 -
 drivers/crypto/s5p-sss.c                           |   1 -
 drivers/crypto/sahara.c                            |   1 -
 drivers/crypto/talitos.c                           |   1 -
 drivers/crypto/ux500/cryp/cryp_core.c              |   1 -
 drivers/crypto/ux500/hash/hash_core.c              |   1 -
 drivers/devfreq/exynos/exynos4_bus.c               |   1 -
 drivers/devfreq/exynos/exynos5_bus.c               |   1 -
 drivers/dma/bcm2835-dma.c                          |   1 -
 drivers/dma/bestcomm/bestcomm.c                    |   1 -
 drivers/dma/cppi41.c                               |   1 -
 drivers/dma/dma-jz4740.c                           |   1 -
 drivers/dma/edma.c                                 |   1 -
 drivers/dma/fsl-edma.c                             |   1 -
 drivers/dma/fsldma.c                               |   1 -
 drivers/dma/imx-dma.c                              |   1 -
 drivers/dma/iop-adma.c                             |   1 -
 drivers/dma/ipu/ipu_idmac.c                        |   1 -
 drivers/dma/k3dma.c                                |   1 -
 drivers/dma/mmp_pdma.c                             |   1 -
 drivers/dma/mmp_tdma.c                             |   1 -
 drivers/dma/moxart-dma.c                           |   1 -
 drivers/dma/mpc512x_dma.c                          |   1 -
 drivers/dma/mv_xor.c                               |   1 -
 drivers/dma/nbpfaxi.c                              |   1 -
 drivers/dma/omap-dma.c                             |   1 -
 drivers/dma/ppc4xx/adma.c                          |   1 -
 drivers/dma/qcom_bam_dma.c                         |   1 -
 drivers/dma/s3c24xx-dma.c                          |   1 -
 drivers/dma/sa11x0-dma.c                           |   1 -
 drivers/dma/sh/rcar-audmapp.c                      |   1 -
 drivers/dma/sh/rcar-hpbdma.c                       |   1 -
 drivers/dma/sh/shdma-of.c                          |   1 -
 drivers/dma/sh/shdmac.c                            |   1 -
 drivers/dma/sh/sudmac.c                            |   1 -
 drivers/dma/sirf-dma.c                             |   1 -
 drivers/dma/ste_dma40.c                            |   1 -
 drivers/dma/tegra20-apb-dma.c                      |   1 -
 drivers/dma/timb_dma.c                             |   1 -
 drivers/edac/cell_edac.c                           |   1 -
 drivers/edac/mpc85xx_edac.c                        |   2 -
 drivers/edac/ppc4xx_edac.c                         |   1 -
 drivers/edac/tile_edac.c                           |   1 -
 drivers/extcon/extcon-adc-jack.c                   |   1 -
 drivers/extcon/extcon-arizona.c                    |   1 -
 drivers/extcon/extcon-gpio.c                       |   1 -
 drivers/extcon/extcon-max14577.c                   |   1 -
 drivers/extcon/extcon-max77693.c                   |   1 -
 drivers/extcon/extcon-max8997.c                    |   1 -
 drivers/extcon/extcon-palmas.c                     |   1 -
 drivers/firmware/dcdbas.c                          |   1 -
 drivers/gpio/gpio-adp5520.c                        |   1 -
 drivers/gpio/gpio-bcm-kona.c                       |   1 -
 drivers/gpio/gpio-clps711x.c                       |   1 -
 drivers/gpio/gpio-crystalcove.c                    |   1 -
 drivers/gpio/gpio-cs5535.c                         |   1 -
 drivers/gpio/gpio-da9052.c                         |   1 -
 drivers/gpio/gpio-da9055.c                         |   1 -
 drivers/gpio/gpio-davinci.c                        |   1 -
 drivers/gpio/gpio-dwapb.c                          |   1 -
 drivers/gpio/gpio-em.c                             |   1 -
 drivers/gpio/gpio-ep93xx.c                         |   1 -
 drivers/gpio/gpio-f7188x.c                         |   1 -
 drivers/gpio/gpio-ge.c                             |   1 -
 drivers/gpio/gpio-grgpio.c                         |   1 -
 drivers/gpio/gpio-ich.c                            |   1 -
 drivers/gpio/gpio-iop.c                            |   1 -
 drivers/gpio/gpio-janz-ttl.c                       |   1 -
 drivers/gpio/gpio-kempld.c                         |   1 -
 drivers/gpio/gpio-lp3943.c                         |   1 -
 drivers/gpio/gpio-lpc32xx.c                        |   1 -
 drivers/gpio/gpio-lynxpoint.c                      |   1 -
 drivers/gpio/gpio-mm-lantiq.c                      |   1 -
 drivers/gpio/gpio-moxart.c                         |   1 -
 drivers/gpio/gpio-mpc5200.c                        |   2 -
 drivers/gpio/gpio-msic.c                           |   1 -
 drivers/gpio/gpio-msm-v1.c                         |   1 -
 drivers/gpio/gpio-msm-v2.c                         |   1 -
 drivers/gpio/gpio-mvebu.c                          |   1 -
 drivers/gpio/gpio-mxc.c                            |   1 -
 drivers/gpio/gpio-mxs.c                            |   1 -
 drivers/gpio/gpio-octeon.c                         |   1 -
 drivers/gpio/gpio-rc5t583.c                        |   1 -
 drivers/gpio/gpio-sch.c                            |   1 -
 drivers/gpio/gpio-spear-spics.c                    |   1 -
 drivers/gpio/gpio-sta2x11.c                        |   1 -
 drivers/gpio/gpio-stp-xway.c                       |   1 -
 drivers/gpio/gpio-syscon.c                         |   1 -
 drivers/gpio/gpio-tb10x.c                          |   1 -
 drivers/gpio/gpio-tegra.c                          |   1 -
 drivers/gpio/gpio-timberdale.c                     |   1 -
 drivers/gpio/gpio-tps65912.c                       |   1 -
 drivers/gpio/gpio-ts5500.c                         |   1 -
 drivers/gpio/gpio-twl4030.c                        |   1 -
 drivers/gpio/gpio-twl6040.c                        |   1 -
 drivers/gpio/gpio-tz1090-pdc.c                     |   1 -
 drivers/gpio/gpio-tz1090.c                         |   1 -
 drivers/gpio/gpio-vr41xx.c                         |   1 -
 drivers/gpio/gpio-vx855.c                          |   1 -
 drivers/gpio/gpio-xgene.c                          |   1 -
 drivers/gpio/gpio-xtensa.c                         |   1 -
 drivers/gpio/gpio-zevio.c                          |   1 -
 drivers/gpu/drm/armada/armada_drv.c                |   1 -
 drivers/gpu/drm/exynos/exynos_drm_drv.c            |   1 -
 drivers/gpu/drm/msm/msm_drv.c                      |   1 -
 drivers/gpu/drm/omapdrm/omap_drv.c                 |   1 -
 drivers/gpu/drm/panel/panel-simple.c               |   1 -
 drivers/gpu/drm/rcar-du/rcar_du_drv.c              |   1 -
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |   1 -
 drivers/gpu/drm/sti/sti_compositor.c               |   1 -
 drivers/gpu/drm/sti/sti_drm_drv.c                  |   2 -
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |   1 -
 drivers/hsi/controllers/omap_ssi.c                 |   1 -
 drivers/hsi/controllers/omap_ssi_port.c            |   1 -
 drivers/hwmon/abituguru.c                          |   1 -
 drivers/hwmon/abituguru3.c                         |   1 -
 drivers/hwmon/abx500.c                             |   1 -
 drivers/hwmon/applesmc.c                           |   1 -
 drivers/hwmon/coretemp.c                           |   1 -
 drivers/hwmon/da9052-hwmon.c                       |   1 -
 drivers/hwmon/da9055-hwmon.c                       |   1 -
 drivers/hwmon/dme1737.c                            |   1 -
 drivers/hwmon/f71805f.c                            |   1 -
 drivers/hwmon/f71882fg.c                           |   1 -
 drivers/hwmon/i5k_amb.c                            |   1 -
 drivers/hwmon/ibmpowernv.c                         |   1 -
 drivers/hwmon/iio_hwmon.c                          |   1 -
 drivers/hwmon/it87.c                               |   1 -
 drivers/hwmon/jz4740-hwmon.c                       |   1 -
 drivers/hwmon/lm78.c                               |   1 -
 drivers/hwmon/max197.c                             |   1 -
 drivers/hwmon/mc13783-adc.c                        |   1 -
 drivers/hwmon/menf21bmc_hwmon.c                    |   1 -
 drivers/hwmon/nct6683.c                            |   1 -
 drivers/hwmon/nct6775.c                            |   1 -
 drivers/hwmon/ntc_thermistor.c                     |   1 -
 drivers/hwmon/pc87360.c                            |   1 -
 drivers/hwmon/pc87427.c                            |   1 -
 drivers/hwmon/s3c-hwmon.c                          |   1 -
 drivers/hwmon/sch5627.c                            |   1 -
 drivers/hwmon/sch5636.c                            |   1 -
 drivers/hwmon/sht15.c                              |   1 -
 drivers/hwmon/sis5595.c                            |   1 -
 drivers/hwmon/smsc47b397.c                         |   1 -
 drivers/hwmon/smsc47m1.c                           |   1 -
 drivers/hwmon/twl4030-madc-hwmon.c                 |   1 -
 drivers/hwmon/ultra45_env.c                        |   1 -
 drivers/hwmon/vexpress.c                           |   1 -
 drivers/hwmon/via-cputemp.c                        |   1 -
 drivers/hwmon/via686a.c                            |   1 -
 drivers/hwmon/vt1211.c                             |   1 -
 drivers/hwmon/vt8231.c                             |   1 -
 drivers/hwmon/w83627ehf.c                          |   1 -
 drivers/hwmon/w83627hf.c                           |   1 -
 drivers/hwmon/w83781d.c                            |   1 -
 drivers/hwmon/wm831x-hwmon.c                       |   1 -
 drivers/hwmon/wm8350-hwmon.c                       |   1 -
 drivers/hwspinlock/omap_hwspinlock.c               |   1 -
 drivers/hwspinlock/u8500_hsem.c                    |   1 -
 drivers/i2c/busses/i2c-at91.c                      |   1 -
 drivers/i2c/busses/i2c-au1550.c                    |   1 -
 drivers/i2c/busses/i2c-bcm-kona.c                  |   1 -
 drivers/i2c/busses/i2c-bcm2835.c                   |   1 -
 drivers/i2c/busses/i2c-bfin-twi.c                  |   1 -
 drivers/i2c/busses/i2c-cadence.c                   |   1 -
 drivers/i2c/busses/i2c-cbus-gpio.c                 |   1 -
 drivers/i2c/busses/i2c-cpm.c                       |   1 -
 drivers/i2c/busses/i2c-davinci.c                   |   1 -
 drivers/i2c/busses/i2c-designware-platdrv.c        |   1 -
 drivers/i2c/busses/i2c-efm32.c                     |   1 -
 drivers/i2c/busses/i2c-exynos5.c                   |   1 -
 drivers/i2c/busses/i2c-gpio.c                      |   1 -
 drivers/i2c/busses/i2c-highlander.c                |   1 -
 drivers/i2c/busses/i2c-ibm_iic.c                   |   1 -
 drivers/i2c/busses/i2c-imx.c                       |   1 -
 drivers/i2c/busses/i2c-iop3xx.c                    |   1 -
 drivers/i2c/busses/i2c-isch.c                      |   1 -
 drivers/i2c/busses/i2c-kempld.c                    |   1 -
 drivers/i2c/busses/i2c-mpc.c                       |   1 -
 drivers/i2c/busses/i2c-mv64xxx.c                   |   1 -
 drivers/i2c/busses/i2c-mxs.c                       |   1 -
 drivers/i2c/busses/i2c-ocores.c                    |   1 -
 drivers/i2c/busses/i2c-octeon.c                    |   1 -
 drivers/i2c/busses/i2c-omap.c                      |   1 -
 drivers/i2c/busses/i2c-parport-light.c             |   1 -
 drivers/i2c/busses/i2c-pca-platform.c              |   1 -
 drivers/i2c/busses/i2c-pmcmsp.c                    |   1 -
 drivers/i2c/busses/i2c-pnx.c                       |   1 -
 drivers/i2c/busses/i2c-puv3.c                      |   1 -
 drivers/i2c/busses/i2c-pxa.c                       |   1 -
 drivers/i2c/busses/i2c-qup.c                       |   1 -
 drivers/i2c/busses/i2c-rcar.c                      |   1 -
 drivers/i2c/busses/i2c-riic.c                      |   1 -
 drivers/i2c/busses/i2c-rk3x.c                      |   1 -
 drivers/i2c/busses/i2c-s3c2410.c                   |   1 -
 drivers/i2c/busses/i2c-sh7760.c                    |   1 -
 drivers/i2c/busses/i2c-sh_mobile.c                 |   1 -
 drivers/i2c/busses/i2c-simtec.c                    |   1 -
 drivers/i2c/busses/i2c-sirf.c                      |   1 -
 drivers/i2c/busses/i2c-st.c                        |   1 -
 drivers/i2c/busses/i2c-stu300.c                    |   1 -
 drivers/i2c/busses/i2c-sun6i-p2wi.c                |   1 -
 drivers/i2c/busses/i2c-tegra.c                     |   1 -
 drivers/i2c/busses/i2c-versatile.c                 |   1 -
 drivers/i2c/busses/i2c-wmt.c                       |   1 -
 drivers/i2c/busses/i2c-xiic.c                      |   1 -
 drivers/i2c/busses/i2c-xlr.c                       |   1 -
 drivers/i2c/busses/scx200_acb.c                    |   1 -
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c         |   1 -
 drivers/i2c/muxes/i2c-mux-gpio.c                   |   1 -
 drivers/i2c/muxes/i2c-mux-pinctrl.c                |   1 -
 drivers/ide/au1xxx-ide.c                           |   1 -
 drivers/ide/gayle.c                                |   1 -
 drivers/ide/ide_platform.c                         |   1 -
 drivers/ide/palm_bk3710.c                          |   1 -
 drivers/ide/tx4938ide.c                            |   1 -
 drivers/ide/tx4939ide.c                            |   1 -
 drivers/iio/adc/rockchip_saradc.c                  |   1 -
 drivers/input/keyboard/adp5520-keys.c              |   1 -
 drivers/input/keyboard/amikbd.c                    |   1 -
 drivers/input/keyboard/bf54x-keys.c                |   1 -
 drivers/input/keyboard/clps711x-keypad.c           |   1 -
 drivers/input/keyboard/davinci_keyscan.c           |   1 -
 drivers/input/keyboard/ep93xx_keypad.c             |   1 -
 drivers/input/keyboard/goldfish_events.c           |   1 -
 drivers/input/keyboard/gpio_keys.c                 |   1 -
 drivers/input/keyboard/gpio_keys_polled.c          |   1 -
 drivers/input/keyboard/imx_keypad.c                |   1 -
 drivers/input/keyboard/jornada680_kbd.c            |   1 -
 drivers/input/keyboard/jornada720_kbd.c            |   1 -
 drivers/input/keyboard/lpc32xx-keys.c              |   1 -
 drivers/input/keyboard/matrix_keypad.c             |   1 -
 drivers/input/keyboard/nomadik-ske-keypad.c        |   1 -
 drivers/input/keyboard/nspire-keypad.c             |   1 -
 drivers/input/keyboard/omap-keypad.c               |   1 -
 drivers/input/keyboard/omap4-keypad.c              |   1 -
 drivers/input/keyboard/pmic8xxx-keypad.c           |   1 -
 drivers/input/keyboard/pxa27x_keypad.c             |   1 -
 drivers/input/keyboard/pxa930_rotary.c             |   1 -
 drivers/input/keyboard/samsung-keypad.c            |   1 -
 drivers/input/keyboard/spear-keyboard.c            |   1 -
 drivers/input/keyboard/tc3589x-keypad.c            |   1 -
 drivers/input/keyboard/tegra-kbc.c                 |   1 -
 drivers/input/keyboard/twl4030_keypad.c            |   1 -
 drivers/input/keyboard/w90p910_keypad.c            |   1 -
 drivers/input/misc/88pm80x_onkey.c                 |   1 -
 drivers/input/misc/88pm860x_onkey.c                |   1 -
 drivers/input/misc/ab8500-ponkey.c                 |   1 -
 drivers/input/misc/arizona-haptics.c               |   1 -
 drivers/input/misc/bfin_rotary.c                   |   1 -
 drivers/input/misc/cobalt_btns.c                   |   1 -
 drivers/input/misc/da9052_onkey.c                  |   1 -
 drivers/input/misc/da9055_onkey.c                  |   1 -
 drivers/input/misc/dm355evm_keys.c                 |   1 -
 drivers/input/misc/gpio-beeper.c                   |   1 -
 drivers/input/misc/gpio_tilt_polled.c              |   1 -
 drivers/input/misc/ideapad_slidebar.c              |   1 -
 drivers/input/misc/ixp4xx-beeper.c                 |   1 -
 drivers/input/misc/m68kspkr.c                      |   1 -
 drivers/input/misc/max77693-haptic.c               |   1 -
 drivers/input/misc/max8925_onkey.c                 |   1 -
 drivers/input/misc/max8997_haptic.c                |   1 -
 drivers/input/misc/mc13783-pwrbutton.c             |   1 -
 drivers/input/misc/palmas-pwrbutton.c              |   1 -
 drivers/input/misc/pcap_keys.c                     |   1 -
 drivers/input/misc/pcspkr.c                        |   1 -
 drivers/input/misc/pm8xxx-vibrator.c               |   1 -
 drivers/input/misc/pmic8xxx-pwrkey.c               |   1 -
 drivers/input/misc/pwm-beeper.c                    |   1 -
 drivers/input/misc/rb532_button.c                  |   1 -
 drivers/input/misc/retu-pwrbutton.c                |   1 -
 drivers/input/misc/rotary_encoder.c                |   1 -
 drivers/input/misc/sgi_btns.c                      |   1 -
 drivers/input/misc/sirfsoc-onkey.c                 |   1 -
 drivers/input/misc/soc_button_array.c              |   1 -
 drivers/input/misc/sparcspkr.c                     |   2 -
 drivers/input/misc/twl4030-pwrbutton.c             |   1 -
 drivers/input/misc/twl4030-vibra.c                 |   1 -
 drivers/input/misc/twl6040-vibra.c                 |   1 -
 drivers/input/misc/wistron_btns.c                  |   1 -
 drivers/input/misc/wm831x-on.c                     |   1 -
 drivers/input/mouse/amimouse.c                     |   1 -
 drivers/input/mouse/gpio_mouse.c                   |   1 -
 drivers/input/mouse/navpoint.c                     |   1 -
 drivers/input/serio/altera_ps2.c                   |   1 -
 drivers/input/serio/apbps2.c                       |   1 -
 drivers/input/serio/arc_ps2.c                      |   1 -
 drivers/input/serio/at32psif.c                     |   1 -
 drivers/input/serio/ct82c710.c                     |   1 -
 drivers/input/serio/i8042-sparcio.h                |   1 -
 drivers/input/serio/i8042.c                        |   1 -
 drivers/input/serio/maceps2.c                      |   1 -
 drivers/input/serio/olpc_apsp.c                    |   1 -
 drivers/input/serio/q40kbd.c                       |   1 -
 drivers/input/serio/rpckbd.c                       |   1 -
 drivers/input/serio/xilinx_ps2.c                   |   1 -
 drivers/input/touchscreen/88pm860x-ts.c            |   1 -
 drivers/input/touchscreen/atmel-wm97xx.c           |   1 -
 drivers/input/touchscreen/da9034-ts.c              |   1 -
 drivers/input/touchscreen/da9052_tsi.c             |   1 -
 drivers/input/touchscreen/intel-mid-touch.c        |   1 -
 drivers/input/touchscreen/jornada720_ts.c          |   1 -
 drivers/input/touchscreen/lpc32xx_ts.c             |   1 -
 drivers/input/touchscreen/mc13783_ts.c             |   1 -
 drivers/input/touchscreen/pcap_ts.c                |   1 -
 drivers/input/touchscreen/s3c2410_ts.c             |   1 -
 drivers/input/touchscreen/stmpe-ts.c               |   1 -
 drivers/input/touchscreen/sun4i-ts.c               |   1 -
 drivers/input/touchscreen/ti_am335x_tsc.c          |   1 -
 drivers/input/touchscreen/tps6507x-ts.c            |   1 -
 drivers/input/touchscreen/ucb1400_ts.c             |   1 -
 drivers/input/touchscreen/w90p910_ts.c             |   1 -
 drivers/input/touchscreen/wm831x-ts.c              |   1 -
 drivers/iommu/arm-smmu.c                           |   1 -
 drivers/iommu/exynos-iommu.c                       |   1 -
 drivers/iommu/fsl_pamu.c                           |   1 -
 drivers/iommu/ipmmu-vmsa.c                         |   1 -
 drivers/iommu/shmobile-ipmmu.c                     |   1 -
 drivers/iommu/tegra-gart.c                         |   1 -
 drivers/iommu/tegra-smmu.c                         |   1 -
 drivers/irqchip/irq-keystone.c                     |   1 -
 drivers/irqchip/irq-renesas-intc-irqpin.c          |   1 -
 drivers/irqchip/irq-renesas-irqc.c                 |   1 -
 drivers/leds/leds-88pm860x.c                       |   1 -
 drivers/leds/leds-adp5520.c                        |   1 -
 drivers/leds/leds-asic3.c                          |   1 -
 drivers/leds/leds-clevo-mail.c                     |   1 -
 drivers/leds/leds-cobalt-qube.c                    |   1 -
 drivers/leds/leds-cobalt-raq.c                     |   1 -
 drivers/leds/leds-da903x.c                         |   1 -
 drivers/leds/leds-da9052.c                         |   1 -
 drivers/leds/leds-gpio.c                           |   1 -
 drivers/leds/leds-hp6xx.c                          |   1 -
 drivers/leds/leds-lm3533.c                         |   1 -
 drivers/leds/leds-lp8788.c                         |   1 -
 drivers/leds/leds-lt3593.c                         |   1 -
 drivers/leds/leds-max8997.c                        |   1 -
 drivers/leds/leds-mc13783.c                        |   1 -
 drivers/leds/leds-menf21bmc.c                      |   1 -
 drivers/leds/leds-net48xx.c                        |   1 -
 drivers/leds/leds-netxbig.c                        |   1 -
 drivers/leds/leds-ns2.c                            |   1 -
 drivers/leds/leds-ot200.c                          |   1 -
 drivers/leds/leds-pwm.c                            |   1 -
 drivers/leds/leds-rb532.c                          |   1 -
 drivers/leds/leds-regulator.c                      |   1 -
 drivers/leds/leds-s3c24xx.c                        |   1 -
 drivers/leds/leds-sunfire.c                        |   2 -
 drivers/leds/leds-wm831x-status.c                  |   1 -
 drivers/leds/leds-wm8350.c                         |   1 -
 drivers/leds/leds-wrap.c                           |   1 -
 drivers/macintosh/smu.c                            |   1 -
 drivers/macintosh/therm_pm72.c                     |   1 -
 drivers/macintosh/therm_windtunnel.c               |   1 -
 drivers/macintosh/windfarm_pm81.c                  |   1 -
 drivers/macintosh/windfarm_pm91.c                  |   1 -
 drivers/mailbox/omap-mailbox.c                     |   1 -
 drivers/media/platform/blackfin/bfin_capture.c     |   1 -
 drivers/media/platform/coda/coda-common.c          |   1 -
 drivers/media/platform/davinci/dm355_ccdc.c        |   1 -
 drivers/media/platform/davinci/dm644x_ccdc.c       |   1 -
 drivers/media/platform/davinci/isif.c              |   1 -
 drivers/media/platform/davinci/vpbe.c              |   1 -
 drivers/media/platform/davinci/vpbe_display.c      |   1 -
 drivers/media/platform/davinci/vpbe_osd.c          |   1 -
 drivers/media/platform/davinci/vpbe_venc.c         |   1 -
 drivers/media/platform/davinci/vpfe_capture.c      |   1 -
 drivers/media/platform/davinci/vpif.c              |   1 -
 drivers/media/platform/davinci/vpif_capture.c      |   1 -
 drivers/media/platform/davinci/vpif_display.c      |   1 -
 drivers/media/platform/davinci/vpss.c              |   1 -
 drivers/media/platform/exynos-gsc/gsc-core.c       |   1 -
 drivers/media/platform/exynos4-is/fimc-core.c      |   1 -
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |   1 -
 drivers/media/platform/exynos4-is/fimc-is.c        |   1 -
 drivers/media/platform/exynos4-is/fimc-lite.c      |   1 -
 drivers/media/platform/exynos4-is/media-dev.c      |   1 -
 drivers/media/platform/exynos4-is/mipi-csis.c      |   1 -
 drivers/media/platform/fsl-viu.c                   |   1 -
 drivers/media/platform/m2m-deinterlace.c           |   1 -
 drivers/media/platform/marvell-ccic/mmp-driver.c   |   1 -
 drivers/media/platform/mem2mem_testdev.c           |   1 -
 drivers/media/platform/mx2_emmaprp.c               |   1 -
 drivers/media/platform/omap3isp/isp.c              |   1 -
 drivers/media/platform/s3c-camif/camif-core.c      |   1 -
 drivers/media/platform/s5p-g2d/g2d.c               |   1 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   1 -
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   1 -
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   1 -
 drivers/media/platform/s5p-tv/mixer_drv.c          |   1 -
 drivers/media/platform/s5p-tv/sdo_drv.c            |   1 -
 drivers/media/platform/sh_veu.c                    |   1 -
 drivers/media/platform/sh_vou.c                    |   1 -
 drivers/media/platform/soc_camera/atmel-isi.c      |   1 -
 drivers/media/platform/soc_camera/mx3_camera.c     |   1 -
 drivers/media/platform/soc_camera/rcar_vin.c       |   1 -
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   1 -
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |   1 -
 drivers/media/platform/soc_camera/soc_camera.c     |   1 -
 .../platform/soc_camera/soc_camera_platform.c      |   1 -
 drivers/media/platform/ti-vpe/vpe.c                |   1 -
 drivers/media/platform/timblogiw.c                 |   1 -
 drivers/media/platform/vsp1/vsp1_drv.c             |   1 -
 drivers/media/radio/radio-si476x.c                 |   1 -
 drivers/media/radio/radio-timb.c                   |   1 -
 drivers/media/radio/radio-wl1273.c                 |   1 -
 drivers/media/radio/si4713/radio-platform-si4713.c |   1 -
 drivers/media/rc/gpio-ir-recv.c                    |   1 -
 drivers/media/rc/img-ir/img-ir-core.c              |   1 -
 drivers/media/rc/sunxi-cir.c                       |   1 -
 drivers/memory/atmel-sdramc.c                      |   1 -
 drivers/memory/fsl-corenet-cf.c                    |   1 -
 drivers/memory/mvebu-devbus.c                      |   1 -
 drivers/memory/tegra20-mc.c                        |   1 -
 drivers/memory/tegra30-mc.c                        |   1 -
 drivers/memory/ti-aemif.c                          |   1 -
 drivers/memstick/host/rtsx_pci_ms.c                |   1 -
 drivers/memstick/host/rtsx_usb_ms.c                |   1 -
 drivers/mfd/ab3100-otp.c                           |   1 -
 drivers/mfd/ab8500-core.c                          |   1 -
 drivers/mfd/ab8500-debugfs.c                       |   1 -
 drivers/mfd/ab8500-gpadc.c                         |   1 -
 drivers/mfd/ab8500-sysctrl.c                       |   1 -
 drivers/mfd/davinci_voicecodec.c                   |   1 -
 drivers/mfd/db8500-prcmu.c                         |   1 -
 drivers/mfd/intel_msic.c                           |   1 -
 drivers/mfd/jz4740-adc.c                           |   1 -
 drivers/mfd/kempld-core.c                          |   1 -
 drivers/mfd/mcp-sa11x0.c                           |   1 -
 drivers/mfd/omap-usb-host.c                        |   1 -
 drivers/mfd/omap-usb-tll.c                         |   1 -
 drivers/mfd/pm8921-core.c                          |   1 -
 drivers/mfd/sm501.c                                |   1 -
 drivers/mfd/ssbi.c                                 |   1 -
 drivers/mfd/sta2x11-mfd.c                          |   4 -
 drivers/mfd/sun6i-prcm.c                           |   1 -
 drivers/mfd/syscon.c                               |   1 -
 drivers/mfd/t7l66xb.c                              |   1 -
 drivers/mfd/tc6393xb.c                             |   1 -
 drivers/mfd/ti_am335x_tscadc.c                     |   1 -
 drivers/mfd/tps65911-comparator.c                  |   1 -
 drivers/mfd/twl4030-audio.c                        |   1 -
 drivers/mfd/twl4030-power.c                        |   1 -
 drivers/misc/arm-charlcd.c                         |   1 -
 drivers/misc/atmel-ssc.c                           |   1 -
 drivers/misc/carma/carma-fpga-program.c            |   1 -
 drivers/misc/carma/carma-fpga.c                    |   1 -
 drivers/misc/cs5535-mfgpt.c                        |   1 -
 drivers/misc/eeprom/sunxi_sid.c                    |   1 -
 drivers/misc/mic/card/mic_x100.c                   |   1 -
 drivers/misc/ti-st/st_kim.c                        |   1 -
 drivers/mmc/host/au1xmmc.c                         |   1 -
 drivers/mmc/host/davinci_mmc.c                     |   1 -
 drivers/mmc/host/sdhci-acpi.c                      |   1 -
 drivers/mmc/host/tmio_mmc.c                        |   1 -
 drivers/mmc/host/usdhi6rol0.c                      |   1 -
 drivers/mmc/host/wbsd.c                            |   1 -
 drivers/mmc/host/wmt-sdmmc.c                       |   1 -
 drivers/mtd/devices/bcm47xxsflash.c                |   1 -
 drivers/mtd/devices/docg3.c                        |   1 -
 drivers/mtd/devices/spear_smi.c                    |   1 -
 drivers/mtd/devices/st_spi_fsm.c                   |   1 -
 drivers/mtd/maps/ixp4xx.c                          |   1 -
 drivers/mtd/maps/lantiq-flash.c                    |   1 -
 drivers/mtd/maps/physmap.c                         |   1 -
 drivers/mtd/maps/physmap_of.c                      |   1 -
 drivers/mtd/maps/plat-ram.c                        |   1 -
 drivers/mtd/maps/pxa2xx-flash.c                    |   1 -
 drivers/mtd/maps/rbtx4939-flash.c                  |   1 -
 drivers/mtd/maps/sa1100-flash.c                    |   1 -
 drivers/mtd/maps/sun_uflash.c                      |   1 -
 drivers/mtd/nand/ams-delta.c                       |   1 -
 drivers/mtd/nand/atmel_nand.c                      |   2 -
 drivers/mtd/nand/au1550nd.c                        |   1 -
 drivers/mtd/nand/bcm47xxnflash/main.c              |   1 -
 drivers/mtd/nand/bf5xx_nand.c                      |   1 -
 drivers/mtd/nand/davinci_nand.c                    |   1 -
 drivers/mtd/nand/denali_dt.c                       |   1 -
 drivers/mtd/nand/docg4.c                           |   1 -
 drivers/mtd/nand/fsl_elbc_nand.c                   |   1 -
 drivers/mtd/nand/fsl_ifc_nand.c                    |   1 -
 drivers/mtd/nand/fsl_upm.c                         |   1 -
 drivers/mtd/nand/fsmc_nand.c                       |   1 -
 drivers/mtd/nand/gpio.c                            |   1 -
 drivers/mtd/nand/jz4740_nand.c                     |   1 -
 drivers/mtd/nand/lpc32xx_mlc.c                     |   1 -
 drivers/mtd/nand/lpc32xx_slc.c                     |   1 -
 drivers/mtd/nand/mpc5121_nfc.c                     |   1 -
 drivers/mtd/nand/mxc_nand.c                        |   1 -
 drivers/mtd/nand/ndfc.c                            |   1 -
 drivers/mtd/nand/nuc900_nand.c                     |   1 -
 drivers/mtd/nand/omap2.c                           |   1 -
 drivers/mtd/nand/omap_elm.c                        |   1 -
 drivers/mtd/nand/orion_nand.c                      |   1 -
 drivers/mtd/nand/pasemi_nand.c                     |   1 -
 drivers/mtd/nand/plat_nand.c                       |   1 -
 drivers/mtd/nand/s3c2410.c                         |   1 -
 drivers/mtd/nand/sh_flctl.c                        |   1 -
 drivers/mtd/nand/sharpsl.c                         |   1 -
 drivers/mtd/nand/socrates_nand.c                   |   1 -
 drivers/mtd/nand/txx9ndfmc.c                       |   1 -
 drivers/mtd/onenand/generic.c                      |   1 -
 drivers/mtd/onenand/omap2.c                        |   1 -
 drivers/mtd/spi-nor/fsl-quadspi.c                  |   1 -
 drivers/net/can/at91_can.c                         |   1 -
 drivers/net/can/bfin_can.c                         |   1 -
 drivers/net/can/c_can/c_can_platform.c             |   1 -
 drivers/net/can/cc770/cc770_isa.c                  |   1 -
 drivers/net/can/cc770/cc770_platform.c             |   1 -
 drivers/net/can/flexcan.c                          |   1 -
 drivers/net/can/grcan.c                            |   1 -
 drivers/net/can/janz-ican3.c                       |   1 -
 drivers/net/can/mscan/mpc5xxx_can.c                |   1 -
 drivers/net/can/rcar_can.c                         |   1 -
 drivers/net/can/sja1000/sja1000_isa.c              |   1 -
 drivers/net/can/sja1000/sja1000_platform.c         |   1 -
 drivers/net/can/softing/softing_main.c             |   1 -
 drivers/net/can/ti_hecc.c                          |   1 -
 drivers/net/can/xilinx_can.c                       |   1 -
 drivers/net/ethernet/8390/ax88796.c                |   1 -
 drivers/net/ethernet/8390/mcf8390.c                |   1 -
 drivers/net/ethernet/8390/ne.c                     |   1 -
 drivers/net/ethernet/adi/bfin_mac.c                |   2 -
 drivers/net/ethernet/aeroflex/greth.c              |   1 -
 drivers/net/ethernet/altera/altera_tse_main.c      |   1 -
 drivers/net/ethernet/amd/au1000_eth.c              |   1 -
 drivers/net/ethernet/amd/sunlance.c                |   1 -
 drivers/net/ethernet/apple/macmace.c               |   1 -
 drivers/net/ethernet/broadcom/bcmsysport.c         |   1 -
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   1 -
 drivers/net/ethernet/broadcom/sb1250-mac.c         |   1 -
 drivers/net/ethernet/cadence/at91_ether.c          |   1 -
 drivers/net/ethernet/cadence/macb.c                |   1 -
 drivers/net/ethernet/cirrus/cs89x0.c               |   1 -
 drivers/net/ethernet/cirrus/ep93xx_eth.c           |   1 -
 drivers/net/ethernet/davicom/dm9000.c              |   1 -
 drivers/net/ethernet/ethoc.c                       |   1 -
 drivers/net/ethernet/faraday/ftgmac100.c           |   1 -
 drivers/net/ethernet/faraday/ftmac100.c            |   1 -
 drivers/net/ethernet/freescale/fec_main.c          |   1 -
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |   1 -
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |   1 -
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |   1 -
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c   |   1 -
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |   1 -
 drivers/net/ethernet/freescale/gianfar.c           |   1 -
 drivers/net/ethernet/freescale/gianfar_ptp.c       |   1 -
 drivers/net/ethernet/freescale/ucc_geth.c          |   1 -
 drivers/net/ethernet/i825xx/sni_82596.c            |   1 -
 drivers/net/ethernet/ibm/emac/core.c               |   1 -
 drivers/net/ethernet/ibm/emac/mal.c                |   1 -
 drivers/net/ethernet/ibm/emac/rgmii.c              |   1 -
 drivers/net/ethernet/ibm/emac/tah.c                |   1 -
 drivers/net/ethernet/ibm/emac/zmii.c               |   1 -
 drivers/net/ethernet/lantiq_etop.c                 |   1 -
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   2 -
 drivers/net/ethernet/micrel/ks8695net.c            |   1 -
 drivers/net/ethernet/micrel/ks8842.c               |   1 -
 drivers/net/ethernet/micrel/ks8851_mll.c           |   1 -
 drivers/net/ethernet/moxa/moxart_ether.c           |   1 -
 drivers/net/ethernet/natsemi/jazzsonic.c           |   1 -
 drivers/net/ethernet/natsemi/macsonic.c            |   1 -
 drivers/net/ethernet/netx-eth.c                    |   1 -
 drivers/net/ethernet/nuvoton/w90p910_ether.c       |   1 -
 drivers/net/ethernet/octeon/octeon_mgmt.c          |   1 -
 drivers/net/ethernet/s6gmac.c                      |   1 -
 .../net/ethernet/samsung/sxgbe/sxgbe_platform.c    |   1 -
 drivers/net/ethernet/seeq/sgiseeq.c                |   1 -
 drivers/net/ethernet/sgi/meth.c                    |   1 -
 drivers/net/ethernet/smsc/smc911x.c                |   1 -
 drivers/net/ethernet/smsc/smc91x.c                 |   1 -
 drivers/net/ethernet/smsc/smsc911x.c               |   1 -
 drivers/net/ethernet/sun/niu.c                     |   1 -
 drivers/net/ethernet/sun/sunbmac.c                 |   1 -
 drivers/net/ethernet/sun/sunhme.c                  |   1 -
 drivers/net/ethernet/sun/sunqe.c                   |   1 -
 drivers/net/ethernet/tundra/tsi108_eth.c           |   1 -
 drivers/net/ethernet/via/via-rhine.c               |   1 -
 drivers/net/ethernet/via/via-velocity.c            |   1 -
 drivers/net/ethernet/wiznet/w5100.c                |   1 -
 drivers/net/ethernet/wiznet/w5300.c                |   1 -
 drivers/net/ieee802154/fakehard.c                  |   1 -
 drivers/net/ieee802154/fakelb.c                    |   1 -
 drivers/net/irda/ali-ircc.c                        |   1 -
 drivers/net/irda/au1k_ir.c                         |   1 -
 drivers/net/irda/pxaficp_ir.c                      |   1 -
 drivers/net/irda/sa1100_ir.c                       |   1 -
 drivers/net/phy/mdio-bcm-unimac.c                  |   1 -
 drivers/net/phy/mdio-gpio.c                        |   1 -
 drivers/net/phy/mdio-mux-gpio.c                    |   1 -
 drivers/net/phy/mdio-mux-mmioreg.c                 |   1 -
 drivers/net/phy/mdio-octeon.c                      |   1 -
 drivers/net/wireless/ath/ath9k/ahb.c               |   1 -
 drivers/net/wireless/ath/ath9k/debug.c             | 455 +++++++----------
 drivers/net/wireless/ath/ath9k/debug.h             |  11 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   1 -
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   1 -
 drivers/net/wireless/mac80211_hwsim.c              |   1 -
 drivers/net/wireless/rt2x00/rt2800soc.c            |   1 -
 drivers/net/wireless/ti/wl12xx/main.c              |   1 -
 drivers/net/wireless/ti/wl18xx/main.c              |   1 -
 drivers/nfc/nfcwilink.c                            |   1 -
 drivers/parport/parport_amiga.c                    |   1 -
 drivers/parport/parport_ax88796.c                  |   1 -
 drivers/parport/parport_pc.c                       |   1 -
 drivers/parport/parport_sunbpp.c                   |   1 -
 drivers/pci/host/pci-dra7xx.c                      |   1 -
 drivers/pci/host/pci-exynos.c                      |   1 -
 drivers/pci/host/pci-host-generic.c                |   1 -
 drivers/pci/host/pci-imx6.c                        |   1 -
 drivers/pci/host/pci-keystone.c                    |   1 -
 drivers/pci/host/pci-mvebu.c                       |   1 -
 drivers/pci/host/pci-rcar-gen2.c                   |   1 -
 drivers/pci/host/pci-tegra.c                       |   1 -
 drivers/pci/host/pci-xgene.c                       |   1 -
 drivers/pci/host/pcie-rcar.c                       |   1 -
 drivers/pci/host/pcie-spear13xx.c                  |   1 -
 drivers/pci/host/pcie-xilinx.c                     |   1 -
 drivers/pci/pci-sysfs.c                            |  39 +-
 drivers/pcmcia/at91_cf.c                           |   1 -
 drivers/pcmcia/bfin_cf_pcmcia.c                    |   1 -
 drivers/pcmcia/db1xxx_ss.c                         |   1 -
 drivers/pcmcia/electra_cf.c                        |   1 -
 drivers/pcmcia/i82365.c                            |   1 -
 drivers/pcmcia/m32r_cfc.c                          |   1 -
 drivers/pcmcia/m32r_pcc.c                          |   1 -
 drivers/pcmcia/omap_cf.c                           |   1 -
 drivers/pcmcia/pxa2xx_base.c                       |   1 -
 drivers/pcmcia/pxa2xx_viper.c                      |   1 -
 drivers/pcmcia/sa1100_generic.c                    |   1 -
 drivers/pcmcia/tcic.c                              |   1 -
 drivers/pcmcia/vrc4171_card.c                      |   1 -
 drivers/pcmcia/xxs1500_ss.c                        |   1 -
 drivers/pinctrl/berlin/berlin-bg2.c                |   1 -
 drivers/pinctrl/berlin/berlin-bg2cd.c              |   1 -
 drivers/pinctrl/berlin/berlin-bg2q.c               |   1 -
 drivers/pinctrl/freescale/pinctrl-imx1.c           |   1 -
 drivers/pinctrl/freescale/pinctrl-imx21.c          |   1 -
 drivers/pinctrl/freescale/pinctrl-imx23.c          |   1 -
 drivers/pinctrl/freescale/pinctrl-imx25.c          |   1 -
 drivers/pinctrl/freescale/pinctrl-imx27.c          |   1 -
 drivers/pinctrl/freescale/pinctrl-imx28.c          |   1 -
 drivers/pinctrl/freescale/pinctrl-imx35.c          |   1 -
 drivers/pinctrl/freescale/pinctrl-imx50.c          |   1 -
 drivers/pinctrl/freescale/pinctrl-imx51.c          |   1 -
 drivers/pinctrl/freescale/pinctrl-imx53.c          |   1 -
 drivers/pinctrl/freescale/pinctrl-imx6dl.c         |   1 -
 drivers/pinctrl/freescale/pinctrl-imx6q.c          |   1 -
 drivers/pinctrl/freescale/pinctrl-imx6sl.c         |   1 -
 drivers/pinctrl/freescale/pinctrl-imx6sx.c         |   1 -
 drivers/pinctrl/freescale/pinctrl-vf610.c          |   1 -
 drivers/pinctrl/mvebu/pinctrl-armada-370.c         |   1 -
 drivers/pinctrl/mvebu/pinctrl-armada-375.c         |   1 -
 drivers/pinctrl/mvebu/pinctrl-armada-38x.c         |   1 -
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c          |   1 -
 drivers/pinctrl/mvebu/pinctrl-dove.c               |   1 -
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c           |   1 -
 drivers/pinctrl/mvebu/pinctrl-orion.c              |   1 -
 drivers/pinctrl/nomadik/pinctrl-abx500.c           |   1 -
 drivers/pinctrl/nomadik/pinctrl-nomadik.c          |   2 -
 drivers/pinctrl/pinctrl-as3722.c                   |   1 -
 drivers/pinctrl/pinctrl-at91.c                     |   2 -
 drivers/pinctrl/pinctrl-baytrail.c                 |   1 -
 drivers/pinctrl/pinctrl-bcm281xx.c                 |   1 -
 drivers/pinctrl/pinctrl-bcm2835.c                  |   1 -
 drivers/pinctrl/pinctrl-falcon.c                   |   1 -
 drivers/pinctrl/pinctrl-palmas.c                   |   1 -
 drivers/pinctrl/pinctrl-rockchip.c                 |   1 -
 drivers/pinctrl/pinctrl-single.c                   |   1 -
 drivers/pinctrl/pinctrl-st.c                       |   1 -
 drivers/pinctrl/pinctrl-tb10x.c                    |   1 -
 drivers/pinctrl/pinctrl-tegra114.c                 |   1 -
 drivers/pinctrl/pinctrl-tegra124.c                 |   1 -
 drivers/pinctrl/pinctrl-tegra20.c                  |   1 -
 drivers/pinctrl/pinctrl-tegra30.c                  |   1 -
 drivers/pinctrl/pinctrl-tz1090-pdc.c               |   1 -
 drivers/pinctrl/pinctrl-tz1090.c                   |   1 -
 drivers/pinctrl/pinctrl-u300.c                     |   1 -
 drivers/pinctrl/pinctrl-xway.c                     |   1 -
 drivers/pinctrl/qcom/pinctrl-apq8064.c             |   1 -
 drivers/pinctrl/qcom/pinctrl-apq8084.c             |   1 -
 drivers/pinctrl/qcom/pinctrl-ipq8064.c             |   1 -
 drivers/pinctrl/qcom/pinctrl-msm8960.c             |   1 -
 drivers/pinctrl/qcom/pinctrl-msm8x74.c             |   1 -
 drivers/pinctrl/samsung/pinctrl-exynos5440.c       |   1 -
 drivers/pinctrl/samsung/pinctrl-samsung.c          |   1 -
 drivers/pinctrl/sh-pfc/core.c                      |   1 -
 drivers/pinctrl/sirf/pinctrl-sirf.c                |   1 -
 drivers/pinctrl/spear/pinctrl-plgpio.c             |   1 -
 drivers/pinctrl/spear/pinctrl-spear1310.c          |   1 -
 drivers/pinctrl/spear/pinctrl-spear1340.c          |   1 -
 drivers/pinctrl/spear/pinctrl-spear300.c           |   1 -
 drivers/pinctrl/spear/pinctrl-spear310.c           |   1 -
 drivers/pinctrl/spear/pinctrl-spear320.c           |   1 -
 drivers/pinctrl/sunxi/pinctrl-sun4i-a10.c          |   1 -
 drivers/pinctrl/sunxi/pinctrl-sun5i-a10s.c         |   1 -
 drivers/pinctrl/sunxi/pinctrl-sun5i-a13.c          |   1 -
 drivers/pinctrl/sunxi/pinctrl-sun6i-a31-r.c        |   1 -
 drivers/pinctrl/sunxi/pinctrl-sun6i-a31.c          |   1 -
 drivers/pinctrl/sunxi/pinctrl-sun7i-a20.c          |   1 -
 drivers/pinctrl/sunxi/pinctrl-sun8i-a23-r.c        |   1 -
 drivers/pinctrl/sunxi/pinctrl-sun8i-a23.c          |   1 -
 drivers/pinctrl/vt8500/pinctrl-vt8500.c            |   1 -
 drivers/pinctrl/vt8500/pinctrl-wm8505.c            |   1 -
 drivers/pinctrl/vt8500/pinctrl-wm8650.c            |   1 -
 drivers/pinctrl/vt8500/pinctrl-wm8750.c            |   1 -
 drivers/pinctrl/vt8500/pinctrl-wm8850.c            |   1 -
 drivers/platform/chrome/chromeos_laptop.c          |   1 -
 drivers/platform/x86/acer-wmi.c                    |   1 -
 drivers/platform/x86/acerhdf.c                     |   1 -
 drivers/platform/x86/alienware-wmi.c               |   1 -
 drivers/platform/x86/amilo-rfkill.c                |   1 -
 drivers/platform/x86/asus-laptop.c                 |   1 -
 drivers/platform/x86/compal-laptop.c               |   1 -
 drivers/platform/x86/dell-laptop.c                 |   1 -
 drivers/platform/x86/eeepc-laptop.c                |   1 -
 drivers/platform/x86/fujitsu-laptop.c              |   1 -
 drivers/platform/x86/hdaps.c                       |   1 -
 drivers/platform/x86/hp-wmi.c                      |   1 -
 drivers/platform/x86/ideapad-laptop.c              |   1 -
 drivers/platform/x86/intel_mid_powerbtn.c          |   1 -
 drivers/platform/x86/intel_mid_thermal.c           |   1 -
 drivers/platform/x86/intel_oaktrail.c              |   1 -
 drivers/platform/x86/intel_pmic_gpio.c             |   1 -
 drivers/platform/x86/msi-laptop.c                  |   1 -
 drivers/platform/x86/samsung-q10.c                 |   1 -
 drivers/platform/x86/sony-laptop.c                 |   1 -
 drivers/platform/x86/tc1100-wmi.c                  |   1 -
 drivers/platform/x86/thinkpad_acpi.c               |   2 -
 drivers/platform/x86/xo1-rfkill.c                  |   1 -
 drivers/power/88pm860x_battery.c                   |   1 -
 drivers/power/88pm860x_charger.c                   |   1 -
 drivers/power/ab8500_btemp.c                       |   1 -
 drivers/power/ab8500_charger.c                     |   1 -
 drivers/power/ab8500_fg.c                          |   1 -
 drivers/power/abx500_chargalg.c                    |   1 -
 drivers/power/bq27x00_battery.c                    |   1 -
 drivers/power/charger-manager.c                    |   1 -
 drivers/power/da9030_battery.c                     |   1 -
 drivers/power/da9052-battery.c                     |   1 -
 drivers/power/generic-adc-battery.c                |   1 -
 drivers/power/gpio-charger.c                       |   1 -
 drivers/power/intel_mid_battery.c                  |   1 -
 drivers/power/jz4740-battery.c                     |   1 -
 drivers/power/lp8788-charger.c                     |   1 -
 drivers/power/max14577_charger.c                   |   1 -
 drivers/power/max8903_charger.c                    |   1 -
 drivers/power/max8997_charger.c                    |   1 -
 drivers/power/max8998_charger.c                    |   1 -
 drivers/power/olpc_battery.c                       |   1 -
 drivers/power/reset/as3722-poweroff.c              |   1 -
 drivers/power/reset/brcmstb-reboot.c               |   1 -
 drivers/power/reset/gpio-poweroff.c                |   1 -
 drivers/power/reset/gpio-restart.c                 |   1 -
 drivers/power/reset/keystone-reset.c               |   1 -
 drivers/power/reset/ltc2952-poweroff.c             |   1 -
 drivers/power/reset/qnap-poweroff.c                |   1 -
 drivers/power/reset/restart-poweroff.c             |   1 -
 drivers/power/rx51_battery.c                       |   1 -
 drivers/power/tps65090-charger.c                   |   1 -
 drivers/power/twl4030_charger.c                    |   1 -
 drivers/power/wm97xx_battery.c                     |   1 -
 drivers/pps/clients/pps-gpio.c                     |   1 -
 drivers/pwm/pwm-ab8500.c                           |   1 -
 drivers/pwm/pwm-atmel-tcb.c                        |   1 -
 drivers/pwm/pwm-bfin.c                             |   1 -
 drivers/pwm/pwm-clps711x.c                         |   1 -
 drivers/pwm/pwm-imx.c                              |   1 -
 drivers/pwm/pwm-jz4740.c                           |   1 -
 drivers/pwm/pwm-lp3943.c                           |   1 -
 drivers/pwm/pwm-lpc32xx.c                          |   1 -
 drivers/pwm/pwm-mxs.c                              |   1 -
 drivers/pwm/pwm-puv3.c                             |   1 -
 drivers/pwm/pwm-pxa.c                              |   1 -
 drivers/pwm/pwm-renesas-tpu.c                      |   1 -
 drivers/pwm/pwm-samsung.c                          |   1 -
 drivers/pwm/pwm-spear.c                            |   1 -
 drivers/pwm/pwm-tegra.c                            |   1 -
 drivers/pwm/pwm-tiecap.c                           |   1 -
 drivers/pwm/pwm-tiehrpwm.c                         |   1 -
 drivers/pwm/pwm-tipwmss.c                          |   1 -
 drivers/pwm/pwm-vt8500.c                           |   1 -
 drivers/regulator/88pm800.c                        |   1 -
 drivers/regulator/88pm8607.c                       |   1 -
 drivers/regulator/aat2870-regulator.c              |   1 -
 drivers/regulator/ab3100.c                         |   1 -
 drivers/regulator/ab8500-ext.c                     |   1 -
 drivers/regulator/ab8500.c                         |   1 -
 drivers/regulator/anatop-regulator.c               |   1 -
 drivers/regulator/arizona-ldo1.c                   |   1 -
 drivers/regulator/arizona-micsupp.c                |   1 -
 drivers/regulator/as3711-regulator.c               |   1 -
 drivers/regulator/as3722-regulator.c               |   1 -
 drivers/regulator/axp20x-regulator.c               |   1 -
 drivers/regulator/bcm590xx-regulator.c             |   1 -
 drivers/regulator/da903x.c                         |   1 -
 drivers/regulator/da9052-regulator.c               |   1 -
 drivers/regulator/da9055-regulator.c               |   1 -
 drivers/regulator/da9063-regulator.c               |   1 -
 drivers/regulator/db8500-prcmu.c                   |   1 -
 drivers/regulator/dummy.c                          |   1 -
 drivers/regulator/fixed.c                          |   1 -
 drivers/regulator/gpio-regulator.c                 |   1 -
 drivers/regulator/hi6421-regulator.c               |   1 -
 drivers/regulator/lp8788-buck.c                    |   1 -
 drivers/regulator/lp8788-ldo.c                     |   2 -
 drivers/regulator/max14577.c                       |   1 -
 drivers/regulator/max77686.c                       |   1 -
 drivers/regulator/max77693.c                       |   1 -
 drivers/regulator/max77802.c                       |   1 -
 drivers/regulator/max8907-regulator.c              |   1 -
 drivers/regulator/max8925-regulator.c              |   1 -
 drivers/regulator/max8997.c                        |   1 -
 drivers/regulator/max8998.c                        |   1 -
 drivers/regulator/mc13783-regulator.c              |   1 -
 drivers/regulator/mc13892-regulator.c              |   1 -
 drivers/regulator/palmas-regulator.c               |   1 -
 drivers/regulator/pbias-regulator.c                |   1 -
 drivers/regulator/pcap-regulator.c                 |   1 -
 drivers/regulator/pwm-regulator.c                  |   1 -
 drivers/regulator/qcom_rpm-regulator.c             |   1 -
 drivers/regulator/rc5t583-regulator.c              |   1 -
 drivers/regulator/rk808-regulator.c                |   1 -
 drivers/regulator/s2mpa01.c                        |   1 -
 drivers/regulator/s2mps11.c                        |   1 -
 drivers/regulator/s5m8767.c                        |   1 -
 drivers/regulator/stw481x-vmmc.c                   |   1 -
 drivers/regulator/ti-abb-regulator.c               |   1 -
 drivers/regulator/tps6105x-regulator.c             |   1 -
 drivers/regulator/tps6507x-regulator.c             |   1 -
 drivers/regulator/tps65090-regulator.c             |   1 -
 drivers/regulator/tps65218-regulator.c             |   1 -
 drivers/regulator/tps6586x-regulator.c             |   1 -
 drivers/regulator/tps65910-regulator.c             |   1 -
 drivers/regulator/tps65912-regulator.c             |   1 -
 drivers/regulator/tps80031-regulator.c             |   1 -
 drivers/regulator/twl-regulator.c                  |   1 -
 drivers/regulator/vexpress.c                       |   1 -
 drivers/regulator/virtual.c                        |   1 -
 drivers/regulator/wm831x-dcdc.c                    |   4 -
 drivers/regulator/wm831x-isink.c                   |   1 -
 drivers/regulator/wm831x-ldo.c                     |   3 -
 drivers/regulator/wm8994-regulator.c               |   1 -
 drivers/remoteproc/da8xx_remoteproc.c              |   1 -
 drivers/remoteproc/omap_remoteproc.c               |   1 -
 drivers/remoteproc/ste_modem_rproc.c               |   1 -
 drivers/reset/reset-socfpga.c                      |   1 -
 drivers/reset/reset-sunxi.c                        |   1 -
 drivers/reset/sti/reset-stih415.c                  |   1 -
 drivers/reset/sti/reset-stih416.c                  |   1 -
 drivers/rtc/rtc-88pm80x.c                          |   1 -
 drivers/rtc/rtc-88pm860x.c                         |   1 -
 drivers/rtc/rtc-ab3100.c                           |   1 -
 drivers/rtc/rtc-ab8500.c                           |   1 -
 drivers/rtc/rtc-at32ap700x.c                       |   1 -
 drivers/rtc/rtc-at91rm9200.c                       |   1 -
 drivers/rtc/rtc-at91sam9.c                         |   1 -
 drivers/rtc/rtc-au1xxx.c                           |   1 -
 drivers/rtc/rtc-bfin.c                             |   1 -
 drivers/rtc/rtc-bq4802.c                           |   1 -
 drivers/rtc/rtc-coh901331.c                        |   1 -
 drivers/rtc/rtc-da9052.c                           |   1 -
 drivers/rtc/rtc-da9055.c                           |   1 -
 drivers/rtc/rtc-da9063.c                           |   1 -
 drivers/rtc/rtc-davinci.c                          |   1 -
 drivers/rtc/rtc-dm355evm.c                         |   1 -
 drivers/rtc/rtc-ds1216.c                           |   1 -
 drivers/rtc/rtc-ds1286.c                           |   1 -
 drivers/rtc/rtc-ds1302.c                           |   1 -
 drivers/rtc/rtc-ds1511.c                           |   1 -
 drivers/rtc/rtc-ds1553.c                           |   1 -
 drivers/rtc/rtc-ds1742.c                           |   1 -
 drivers/rtc/rtc-ds2404.c                           |   1 -
 drivers/rtc/rtc-efi.c                              |   1 -
 drivers/rtc/rtc-ep93xx.c                           |   1 -
 drivers/rtc/rtc-generic.c                          |   1 -
 drivers/rtc/rtc-hid-sensor-time.c                  |   1 -
 drivers/rtc/rtc-imxdi.c                            |   1 -
 drivers/rtc/rtc-jz4740.c                           |   1 -
 drivers/rtc/rtc-lp8788.c                           |   1 -
 drivers/rtc/rtc-lpc32xx.c                          |   1 -
 drivers/rtc/rtc-ls1x.c                             |   1 -
 drivers/rtc/rtc-m48t35.c                           |   1 -
 drivers/rtc/rtc-m48t59.c                           |   1 -
 drivers/rtc/rtc-m48t86.c                           |   1 -
 drivers/rtc/rtc-max77686.c                         |   1 -
 drivers/rtc/rtc-max77802.c                         |   1 -
 drivers/rtc/rtc-max8907.c                          |   1 -
 drivers/rtc/rtc-max8925.c                          |   1 -
 drivers/rtc/rtc-max8997.c                          |   1 -
 drivers/rtc/rtc-max8998.c                          |   1 -
 drivers/rtc/rtc-mc13xxx.c                          |   1 -
 drivers/rtc/rtc-moxart.c                           |   1 -
 drivers/rtc/rtc-mpc5121.c                          |   1 -
 drivers/rtc/rtc-msm6242.c                          |   1 -
 drivers/rtc/rtc-mv.c                               |   1 -
 drivers/rtc/rtc-mxc.c                              |   1 -
 drivers/rtc/rtc-nuc900.c                           |   1 -
 drivers/rtc/rtc-omap.c                             |   1 -
 drivers/rtc/rtc-palmas.c                           |   1 -
 drivers/rtc/rtc-pcap.c                             |   1 -
 drivers/rtc/rtc-pm8xxx.c                           |   1 -
 drivers/rtc/rtc-ps3.c                              |   1 -
 drivers/rtc/rtc-puv3.c                             |   1 -
 drivers/rtc/rtc-rc5t583.c                          |   1 -
 drivers/rtc/rtc-rp5c01.c                           |   1 -
 drivers/rtc/rtc-rs5c313.c                          |   1 -
 drivers/rtc/rtc-s3c.c                              |   1 -
 drivers/rtc/rtc-s5m.c                              |   1 -
 drivers/rtc/rtc-sh.c                               |   1 -
 drivers/rtc/rtc-sirfsoc.c                          |   1 -
 drivers/rtc/rtc-snvs.c                             |   1 -
 drivers/rtc/rtc-starfire.c                         |   1 -
 drivers/rtc/rtc-stk17ta8.c                         |   1 -
 drivers/rtc/rtc-stmp3xxx.c                         |   1 -
 drivers/rtc/rtc-sun4v.c                            |   1 -
 drivers/rtc/rtc-sunxi.c                            |   1 -
 drivers/rtc/rtc-tegra.c                            |   1 -
 drivers/rtc/rtc-test.c                             |   1 -
 drivers/rtc/rtc-tile.c                             |   1 -
 drivers/rtc/rtc-tps6586x.c                         |   1 -
 drivers/rtc/rtc-tps65910.c                         |   1 -
 drivers/rtc/rtc-tps80031.c                         |   1 -
 drivers/rtc/rtc-twl.c                              |   1 -
 drivers/rtc/rtc-tx4939.c                           |   1 -
 drivers/rtc/rtc-v3020.c                            |   1 -
 drivers/rtc/rtc-vr41xx.c                           |   1 -
 drivers/rtc/rtc-vt8500.c                           |   1 -
 drivers/rtc/rtc-xgene.c                            |   1 -
 drivers/s390/block/dcssblk.c                       |   1 -
 drivers/s390/block/xpram.c                         |   1 -
 drivers/s390/char/monwriter.c                      |   1 -
 drivers/s390/char/sclp.c                           |   1 -
 drivers/sbus/char/bbc_i2c.c                        |   1 -
 drivers/sbus/char/display7seg.c                    |   1 -
 drivers/sbus/char/envctrl.c                        |   1 -
 drivers/sbus/char/flash.c                          |   1 -
 drivers/sbus/char/uctrl.c                          |   1 -
 drivers/scsi/a3000.c                               |   1 -
 drivers/scsi/a4000t.c                              |   1 -
 drivers/scsi/bvme6000_scsi.c                       |   1 -
 drivers/scsi/jazz_esp.c                            |   1 -
 drivers/scsi/mac_esp.c                             |   1 -
 drivers/scsi/mvme16x_scsi.c                        |   1 -
 drivers/scsi/qlogicpti.c                           |   1 -
 drivers/scsi/sgiwd93.c                             |   1 -
 drivers/scsi/sni_53c710.c                          |   1 -
 drivers/scsi/sun3x_esp.c                           |   1 -
 drivers/scsi/sun_esp.c                             |   1 -
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   1 -
 drivers/soc/qcom/qcom_gsbi.c                       |   1 -
 drivers/soc/tegra/fuse/fuse-tegra20.c              |   1 -
 drivers/soc/tegra/fuse/fuse-tegra30.c              |   1 -
 drivers/soc/ti/knav_dma.c                          |   1 -
 drivers/soc/ti/knav_qmss_queue.c                   |   1 -
 drivers/spi/spi-adi-v3.c                           |   1 -
 drivers/spi/spi-altera.c                           |   1 -
 drivers/spi/spi-ath79.c                            |   1 -
 drivers/spi/spi-atmel.c                            |   1 -
 drivers/spi/spi-au1550.c                           |   1 -
 drivers/spi/spi-bcm2835.c                          |   1 -
 drivers/spi/spi-bcm63xx-hsspi.c                    |   1 -
 drivers/spi/spi-bcm63xx.c                          |   1 -
 drivers/spi/spi-bfin-sport.c                       |   1 -
 drivers/spi/spi-bfin5xx.c                          |   1 -
 drivers/spi/spi-clps711x.c                         |   1 -
 drivers/spi/spi-davinci.c                          |   1 -
 drivers/spi/spi-dw-mmio.c                          |   1 -
 drivers/spi/spi-efm32.c                            |   1 -
 drivers/spi/spi-ep93xx.c                           |   1 -
 drivers/spi/spi-falcon.c                           |   1 -
 drivers/spi/spi-fsl-espi.c                         |   1 -
 drivers/spi/spi-fsl-spi.c                          |   2 -
 drivers/spi/spi-gpio.c                             |   1 -
 drivers/spi/spi-imx.c                              |   1 -
 drivers/spi/spi-mpc512x-psc.c                      |   1 -
 drivers/spi/spi-mpc52xx-psc.c                      |   1 -
 drivers/spi/spi-mpc52xx.c                          |   1 -
 drivers/spi/spi-mxs.c                              |   1 -
 drivers/spi/spi-nuc900.c                           |   1 -
 drivers/spi/spi-oc-tiny.c                          |   1 -
 drivers/spi/spi-octeon.c                           |   1 -
 drivers/spi/spi-omap-100k.c                        |   1 -
 drivers/spi/spi-omap-uwire.c                       |   1 -
 drivers/spi/spi-omap2-mcspi.c                      |   1 -
 drivers/spi/spi-orion.c                            |   1 -
 drivers/spi/spi-ppc4xx.c                           |   1 -
 drivers/spi/spi-pxa2xx.c                           |   1 -
 drivers/spi/spi-qup.c                              |   1 -
 drivers/spi/spi-rockchip.c                         |   1 -
 drivers/spi/spi-rspi.c                             |   1 -
 drivers/spi/spi-s3c24xx.c                          |   1 -
 drivers/spi/spi-s3c64xx.c                          |   1 -
 drivers/spi/spi-sh-hspi.c                          |   1 -
 drivers/spi/spi-sh-msiof.c                         |   1 -
 drivers/spi/spi-sh-sci.c                           |   1 -
 drivers/spi/spi-sh.c                               |   1 -
 drivers/spi/spi-sirf.c                             |   1 -
 drivers/spi/spi-sun4i.c                            |   1 -
 drivers/spi/spi-sun6i.c                            |   1 -
 drivers/spi/spi-tegra114.c                         |   1 -
 drivers/spi/spi-tegra20-sflash.c                   |   1 -
 drivers/spi/spi-tegra20-slink.c                    |   1 -
 drivers/spi/spi-ti-qspi.c                          |   1 -
 drivers/spi/spi-topcliff-pch.c                     |   1 -
 drivers/spi/spi-txx9.c                             |   1 -
 drivers/spi/spi-xtensa-xtfpga.c                    |   1 -
 drivers/spmi/spmi-pmic-arb.c                       |   1 -
 drivers/staging/android/timed_gpio.c               |   1 -
 drivers/staging/emxx_udc/emxx_udc.c                |   1 -
 drivers/staging/iio/adc/ad7606_par.c               |   1 -
 drivers/staging/iio/adc/lpc32xx_adc.c              |   1 -
 drivers/staging/iio/adc/mxs-lradc.c                |   1 -
 drivers/staging/iio/adc/spear_adc.c                |   1 -
 drivers/staging/iio/trigger/iio-trig-bfin-timer.c  |   1 -
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |   1 -
 drivers/staging/imx-drm/imx-drm-core.c             |   1 -
 drivers/staging/imx-drm/imx-hdmi.c                 |   1 -
 drivers/staging/imx-drm/imx-ldb.c                  |   1 -
 drivers/staging/imx-drm/imx-tve.c                  |   1 -
 drivers/staging/imx-drm/parallel-display.c         |   1 -
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |   1 -
 drivers/staging/media/lirc/lirc_parallel.c         |   1 -
 drivers/staging/media/lirc/lirc_serial.c           |   1 -
 drivers/staging/media/lirc/lirc_sir.c              |   1 -
 drivers/staging/media/omap24xx/omap24xxcam.c       |   1 -
 drivers/staging/media/omap4iss/iss.c               |   1 -
 drivers/staging/netlogic/xlr_net.c                 |   1 -
 drivers/staging/nvec/nvec.c                        |   1 -
 drivers/staging/nvec/nvec_kbd.c                    |   1 -
 drivers/staging/nvec/nvec_paz00.c                  |   1 -
 drivers/staging/nvec/nvec_power.c                  |   1 -
 drivers/staging/nvec/nvec_ps2.c                    |   1 -
 drivers/staging/octeon-usb/octeon-hcd.c            |   1 -
 drivers/staging/octeon/ethernet.c                  |   1 -
 drivers/staging/ozwpan/ozhcd.c                     |   1 -
 drivers/thermal/armada_thermal.c                   |   1 -
 drivers/thermal/db8500_cpufreq_cooling.c           |   1 -
 drivers/thermal/db8500_thermal.c                   |   1 -
 drivers/thermal/dove_thermal.c                     |   1 -
 drivers/thermal/imx_thermal.c                      |   1 -
 drivers/thermal/kirkwood_thermal.c                 |   1 -
 drivers/thermal/samsung/exynos_tmu.c               |   1 -
 drivers/thermal/spear_thermal.c                    |   1 -
 drivers/thermal/st/st_thermal_memmap.c             |   1 -
 drivers/thermal/st/st_thermal_syscfg.c             |   1 -
 drivers/tty/amiserial.c                            |   1 -
 drivers/tty/ehv_bytechan.c                         |   1 -
 drivers/tty/hvc/hvc_opal.c                         |   1 -
 drivers/tty/hvc/hvc_tile.c                         |   1 -
 drivers/tty/serial/8250/8250_core.c                |   1 -
 drivers/tty/serial/8250/8250_dw.c                  |   1 -
 drivers/tty/serial/8250/8250_em.c                  |   1 -
 drivers/tty/serial/altera_jtaguart.c               |   1 -
 drivers/tty/serial/altera_uart.c                   |   1 -
 drivers/tty/serial/apbuart.c                       |   1 -
 drivers/tty/serial/ar933x_uart.c                   |   1 -
 drivers/tty/serial/arc_uart.c                      |   1 -
 drivers/tty/serial/atmel_serial.c                  |   1 -
 drivers/tty/serial/bcm63xx_uart.c                  |   1 -
 drivers/tty/serial/bfin_uart.c                     |   1 -
 drivers/tty/serial/clps711x.c                      |   1 -
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |   1 -
 drivers/tty/serial/efm32-uart.c                    |   1 -
 drivers/tty/serial/fsl_lpuart.c                    |   1 -
 drivers/tty/serial/imx.c                           |   1 -
 drivers/tty/serial/lantiq.c                        |   1 -
 drivers/tty/serial/lpc32xx_hs.c                    |   1 -
 drivers/tty/serial/mcf.c                           |   1 -
 drivers/tty/serial/meson_uart.c                    |   1 -
 drivers/tty/serial/mpc52xx_uart.c                  |   1 -
 drivers/tty/serial/mpsc.c                          |   1 -
 drivers/tty/serial/msm_serial.c                    |   1 -
 drivers/tty/serial/msm_serial_hs.c                 |   1 -
 drivers/tty/serial/mxs-auart.c                     |   1 -
 drivers/tty/serial/netx-serial.c                   |   1 -
 drivers/tty/serial/of_serial.c                     |   1 -
 drivers/tty/serial/pmac_zilog.c                    |   1 -
 drivers/tty/serial/pnx8xxx_uart.c                  |   1 -
 drivers/tty/serial/pxa.c                           |   1 -
 drivers/tty/serial/sa1100.c                        |   1 -
 drivers/tty/serial/samsung.c                       |   1 -
 drivers/tty/serial/sccnxp.c                        |   1 -
 drivers/tty/serial/serial_txx9.c                   |   1 -
 drivers/tty/serial/sh-sci.c                        |   1 -
 drivers/tty/serial/sirfsoc_uart.c                  |   1 -
 drivers/tty/serial/st-asc.c                        |   1 -
 drivers/tty/serial/sunhv.c                         |   1 -
 drivers/tty/serial/sunsab.c                        |   1 -
 drivers/tty/serial/sunsu.c                         |   1 -
 drivers/tty/serial/sunzilog.c                      |   1 -
 drivers/tty/serial/timbuart.c                      |   1 -
 drivers/tty/serial/ucc_uart.c                      |   1 -
 drivers/tty/serial/vr41xx_siu.c                    |   1 -
 drivers/tty/serial/vt8500_serial.c                 |   1 -
 drivers/uio/uio_dmem_genirq.c                      |   1 -
 drivers/uio/uio_pdrv_genirq.c                      |   1 -
 drivers/uio/uio_pruss.c                            |   1 -
 drivers/usb/c67x00/c67x00-drv.c                    |   1 -
 drivers/usb/chipidea/ci_hdrc_imx.c                 |   1 -
 drivers/usb/chipidea/ci_hdrc_zevio.c               |   1 -
 drivers/usb/chipidea/core.c                        |   1 -
 drivers/usb/chipidea/usbmisc_imx.c                 |   1 -
 drivers/usb/dwc2/gadget.c                          |   1 -
 drivers/usb/gadget/legacy/hid.c                    |   1 -
 drivers/usb/gadget/udc/at91_udc.c                  |   1 -
 drivers/usb/gadget/udc/atmel_usba_udc.c            |   1 -
 drivers/usb/gadget/udc/bcm63xx_udc.c               |   1 -
 drivers/usb/gadget/udc/dummy_hcd.c                 |   2 -
 drivers/usb/gadget/udc/fotg210-udc.c               |   1 -
 drivers/usb/gadget/udc/fsl_qe_udc.c                |   1 -
 drivers/usb/gadget/udc/fsl_udc_core.c              |   1 -
 drivers/usb/gadget/udc/fusb300_udc.c               |   1 -
 drivers/usb/gadget/udc/gr_udc.c                    |   1 -
 drivers/usb/gadget/udc/lpc32xx_udc.c               |   1 -
 drivers/usb/gadget/udc/m66592-udc.c                |   1 -
 drivers/usb/gadget/udc/mv_u3d_core.c               |   1 -
 drivers/usb/gadget/udc/mv_udc_core.c               |   1 -
 drivers/usb/gadget/udc/net2272.c                   |   1 -
 drivers/usb/gadget/udc/omap_udc.c                  |   1 -
 drivers/usb/gadget/udc/pxa25x_udc.c                |   1 -
 drivers/usb/gadget/udc/pxa27x_udc.c                |   1 -
 drivers/usb/gadget/udc/s3c-hsudc.c                 |   1 -
 drivers/usb/gadget/udc/s3c2410_udc.c               |   1 -
 drivers/usb/host/ehci-exynos.c                     |   1 -
 drivers/usb/host/ehci-orion.c                      |   1 -
 drivers/usb/host/ehci-platform.c                   |   1 -
 drivers/usb/host/ehci-w90x900.c                    |   1 -
 drivers/usb/host/fhci-hcd.c                        |   1 -
 drivers/usb/host/fsl-mph-dr-of.c                   |   1 -
 drivers/usb/host/isp116x-hcd.c                     |   1 -
 drivers/usb/host/isp1362-hcd.c                     |   1 -
 drivers/usb/host/isp1760-if.c                      |   1 -
 drivers/usb/host/ohci-at91.c                       |   1 -
 drivers/usb/host/ohci-exynos.c                     |   1 -
 drivers/usb/host/ohci-nxp.c                        |   1 -
 drivers/usb/host/ohci-omap.c                       |   1 -
 drivers/usb/host/ohci-platform.c                   |   1 -
 drivers/usb/host/ohci-pxa27x.c                     |   1 -
 drivers/usb/host/ohci-s3c2410.c                    |   1 -
 drivers/usb/host/ohci-spear.c                      |   1 -
 drivers/usb/host/r8a66597-hcd.c                    |   1 -
 drivers/usb/host/u132-hcd.c                        |   1 -
 drivers/usb/misc/usb3503.c                         |   1 -
 drivers/usb/musb/musb_core.c                       |   1 -
 drivers/usb/phy/phy-ab8500-usb.c                   |   1 -
 drivers/usb/phy/phy-am335x-control.c               |   1 -
 drivers/usb/phy/phy-am335x.c                       |   1 -
 drivers/usb/phy/phy-generic.c                      |   1 -
 drivers/usb/phy/phy-gpio-vbus-usb.c                |   1 -
 drivers/usb/phy/phy-isp1301-omap.c                 |   1 -
 drivers/usb/phy/phy-keystone.c                     |   1 -
 drivers/usb/phy/phy-mv-usb.c                       |   1 -
 drivers/usb/phy/phy-mxs-usb.c                      |   1 -
 drivers/usb/phy/phy-omap-otg.c                     |   1 -
 drivers/usb/phy/phy-tahvo.c                        |   1 -
 drivers/usb/phy/phy-tegra-usb.c                    |   1 -
 drivers/usb/phy/phy-twl6030-usb.c                  |   1 -
 drivers/usb/usbip/vhci_hcd.c                       |   1 -
 drivers/video/fbdev/amifb.c                        |   1 -
 drivers/video/fbdev/atmel_lcdfb.c                  |   1 -
 drivers/video/fbdev/au1100fb.c                     |   1 -
 drivers/video/fbdev/au1200fb.c                     |   1 -
 drivers/video/fbdev/auo_k1900fb.c                  |   1 -
 drivers/video/fbdev/auo_k1901fb.c                  |   1 -
 drivers/video/fbdev/bf537-lq035.c                  |   1 -
 drivers/video/fbdev/bf54x-lq043fb.c                |   1 -
 drivers/video/fbdev/bfin-t350mcqb-fb.c             |   1 -
 drivers/video/fbdev/broadsheetfb.c                 |   1 -
 drivers/video/fbdev/bw2.c                          |   1 -
 drivers/video/fbdev/cg14.c                         |   1 -
 drivers/video/fbdev/cg3.c                          |   1 -
 drivers/video/fbdev/cg6.c                          |   1 -
 drivers/video/fbdev/clps711x-fb.c                  |   1 -
 drivers/video/fbdev/clps711xfb.c                   |   1 -
 drivers/video/fbdev/cobalt_lcdfb.c                 |   1 -
 drivers/video/fbdev/da8xx-fb.c                     |   1 -
 drivers/video/fbdev/efifb.c                        |   1 -
 drivers/video/fbdev/ep93xx-fb.c                    |   1 -
 drivers/video/fbdev/exynos/exynos_mipi_dsi.c       |   1 -
 drivers/video/fbdev/ffb.c                          |   1 -
 drivers/video/fbdev/fsl-diu-fb.c                   |   1 -
 drivers/video/fbdev/grvga.c                        |   1 -
 drivers/video/fbdev/hecubafb.c                     |   1 -
 drivers/video/fbdev/hitfb.c                        |   1 -
 drivers/video/fbdev/imxfb.c                        |   1 -
 drivers/video/fbdev/leo.c                          |   1 -
 drivers/video/fbdev/mb862xx/mb862xxfbdrv.c         |   1 -
 drivers/video/fbdev/metronomefb.c                  |   1 -
 drivers/video/fbdev/mmp/fb/mmpfb.c                 |   1 -
 drivers/video/fbdev/mmp/hw/mmp_ctrl.c              |   1 -
 drivers/video/fbdev/mx3fb.c                        |   1 -
 drivers/video/fbdev/nuc900fb.c                     |   1 -
 drivers/video/fbdev/omap/lcd_ams_delta.c           |   1 -
 drivers/video/fbdev/omap/lcd_h3.c                  |   1 -
 drivers/video/fbdev/omap/lcd_htcherald.c           |   1 -
 drivers/video/fbdev/omap/lcd_inn1510.c             |   1 -
 drivers/video/fbdev/omap/lcd_inn1610.c             |   1 -
 drivers/video/fbdev/omap/lcd_osk.c                 |   1 -
 drivers/video/fbdev/omap/lcd_palmte.c              |   1 -
 drivers/video/fbdev/omap/lcd_palmtt.c              |   1 -
 drivers/video/fbdev/omap/lcd_palmz71.c             |   1 -
 drivers/video/fbdev/omap/omapfb_main.c             |   1 -
 .../fbdev/omap2/displays-new/connector-analog-tv.c |   1 -
 .../video/fbdev/omap2/displays-new/connector-dvi.c |   1 -
 .../fbdev/omap2/displays-new/connector-hdmi.c      |   1 -
 .../fbdev/omap2/displays-new/encoder-tfp410.c      |   1 -
 .../fbdev/omap2/displays-new/encoder-tpd12s015.c   |   1 -
 drivers/video/fbdev/omap2/displays-new/panel-dpi.c |   1 -
 .../video/fbdev/omap2/displays-new/panel-dsi-cm.c  |   1 -
 .../omap2/displays-new/panel-sharp-ls037v7dw01.c   |   1 -
 drivers/video/fbdev/omap2/dss/core.c               |   1 -
 drivers/video/fbdev/omap2/dss/dispc.c              |   1 -
 drivers/video/fbdev/omap2/dss/dpi.c                |   1 -
 drivers/video/fbdev/omap2/dss/dsi.c                |   1 -
 drivers/video/fbdev/omap2/dss/dss.c                |   1 -
 drivers/video/fbdev/omap2/dss/hdmi4.c              |   1 -
 drivers/video/fbdev/omap2/dss/hdmi5.c              |   1 -
 drivers/video/fbdev/omap2/dss/rfbi.c               |   1 -
 drivers/video/fbdev/omap2/dss/sdi.c                |   1 -
 drivers/video/fbdev/omap2/dss/venc.c               |   1 -
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c     |   1 -
 drivers/video/fbdev/p9100.c                        |   1 -
 drivers/video/fbdev/platinumfb.c                   |   1 -
 drivers/video/fbdev/pxa168fb.c                     |   1 -
 drivers/video/fbdev/pxa3xx-gcu.c                   |   1 -
 drivers/video/fbdev/pxafb.c                        |   1 -
 drivers/video/fbdev/s3c-fb.c                       |   1 -
 drivers/video/fbdev/s3c2410fb.c                    |   2 -
 drivers/video/fbdev/sa1100fb.c                     |   1 -
 drivers/video/fbdev/sh7760fb.c                     |   1 -
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |   1 -
 drivers/video/fbdev/sh_mobile_meram.c              |   1 -
 drivers/video/fbdev/simplefb.c                     |   1 -
 drivers/video/fbdev/sm501fb.c                      |   1 -
 drivers/video/fbdev/sunxvr1000.c                   |   1 -
 drivers/video/fbdev/tcx.c                          |   1 -
 drivers/video/fbdev/vesafb.c                       |   1 -
 drivers/video/fbdev/vt8500lcdfb.c                  |   1 -
 drivers/video/fbdev/wm8505fb.c                     |   1 -
 drivers/video/fbdev/wmt_ge_rops.c                  |   1 -
 drivers/video/fbdev/xilinxfb.c                     |   1 -
 drivers/virtio/virtio_mmio.c                       |   1 -
 drivers/w1/masters/mxc_w1.c                        |   1 -
 drivers/w1/masters/w1-gpio.c                       |   1 -
 drivers/watchdog/acquirewdt.c                      |   1 -
 drivers/watchdog/advantechwdt.c                    |   1 -
 drivers/watchdog/ar7_wdt.c                         |   1 -
 drivers/watchdog/at32ap700x_wdt.c                  |   1 -
 drivers/watchdog/at91rm9200_wdt.c                  |   1 -
 drivers/watchdog/at91sam9_wdt.c                    |   1 -
 drivers/watchdog/ath79_wdt.c                       |   1 -
 drivers/watchdog/bcm2835_wdt.c                     |   1 -
 drivers/watchdog/bcm47xx_wdt.c                     |   1 -
 drivers/watchdog/bcm63xx_wdt.c                     |   1 -
 drivers/watchdog/bcm_kona_wdt.c                    |   1 -
 drivers/watchdog/bfin_wdt.c                        |   1 -
 drivers/watchdog/coh901327_wdt.c                   |   1 -
 drivers/watchdog/cpwd.c                            |   1 -
 drivers/watchdog/davinci_wdt.c                     |   1 -
 drivers/watchdog/dw_wdt.c                          |   1 -
 drivers/watchdog/ep93xx_wdt.c                      |   1 -
 drivers/watchdog/gef_wdt.c                         |   1 -
 drivers/watchdog/geodewdt.c                        |   1 -
 drivers/watchdog/gpio_wdt.c                        |   1 -
 drivers/watchdog/iTCO_wdt.c                        |   1 -
 drivers/watchdog/ib700wdt.c                        |   1 -
 drivers/watchdog/ie6xx_wdt.c                       |   1 -
 drivers/watchdog/imx2_wdt.c                        |   1 -
 drivers/watchdog/intel-mid_wdt.c                   |   1 -
 drivers/watchdog/jz4740_wdt.c                      |   1 -
 drivers/watchdog/kempld_wdt.c                      |   1 -
 drivers/watchdog/ks8695_wdt.c                      |   1 -
 drivers/watchdog/lantiq_wdt.c                      |   1 -
 drivers/watchdog/max63xx_wdt.c                     |   1 -
 drivers/watchdog/menf21bmc_wdt.c                   |   1 -
 drivers/watchdog/moxart_wdt.c                      |   1 -
 drivers/watchdog/mpc8xxx_wdt.c                     |   1 -
 drivers/watchdog/mv64x60_wdt.c                     |   1 -
 drivers/watchdog/nuc900_wdt.c                      |   1 -
 drivers/watchdog/nv_tco.c                          |   1 -
 drivers/watchdog/omap_wdt.c                        |   1 -
 drivers/watchdog/orion_wdt.c                       |   1 -
 drivers/watchdog/pnx4008_wdt.c                     |   1 -
 drivers/watchdog/rdc321x_wdt.c                     |   1 -
 drivers/watchdog/riowd.c                           |   1 -
 drivers/watchdog/rt2880_wdt.c                      |   1 -
 drivers/watchdog/s3c2410_wdt.c                     |   1 -
 drivers/watchdog/sch311x_wdt.c                     |   1 -
 drivers/watchdog/shwdt.c                           |   1 -
 drivers/watchdog/sirfsoc_wdt.c                     |   1 -
 drivers/watchdog/sp5100_tco.c                      |   1 -
 drivers/watchdog/sunxi_wdt.c                       |   1 -
 drivers/watchdog/tegra_wdt.c                       |   1 -
 drivers/watchdog/ts72xx_wdt.c                      |   1 -
 drivers/watchdog/twl4030_wdt.c                     |   1 -
 drivers/watchdog/txx9wdt.c                         |   1 -
 drivers/watchdog/ux500_wdt.c                       |   1 -
 drivers/watchdog/xen_wdt.c                         |   1 -
 drivers/zorro/zorro.c                              |   1 -
 fs/debugfs/file.c                                  |  54 +++
 fs/kernfs/file.c                                   |  73 ++-
 fs/pstore/ram.c                                    |   1 -
 fs/sysfs/file.c                                    |  59 ++-
 include/linux/bitmap.h                             |   3 +
 include/linux/cacheinfo.h                          | 100 ++++
 include/linux/cpu.h                                |   4 +
 include/linux/cpumask.h                            |  17 +
 include/linux/debugfs.h                            |  17 +-
 include/linux/device.h                             |  35 ++
 include/linux/kernfs.h                             |   8 +
 include/linux/platform_device.h                    |  12 +-
 include/linux/sysfs.h                              |   9 +
 lib/bitmap.c                                       |  29 ++
 lib/kobject.c                                      |   2 +-
 net/dsa/dsa.c                                      |   1 -
 net/rfkill/rfkill-gpio.c                           |   1 -
 net/rfkill/rfkill-regulator.c                      |   1 -
 scripts/coccinelle/api/platform_no_drv_owner.cocci | 106 ++++
 sound/arm/pxa2xx-ac97.c                            |   1 -
 sound/atmel/abdac.c                                |   1 -
 sound/atmel/ac97c.c                                |   1 -
 sound/drivers/aloop.c                              |   1 -
 sound/drivers/dummy.c                              |   1 -
 sound/drivers/ml403-ac97cr.c                       |   1 -
 sound/drivers/mpu401/mpu401.c                      |   1 -
 sound/drivers/mtpav.c                              |   1 -
 sound/drivers/mts64.c                              |   1 -
 sound/drivers/pcsp/pcsp.c                          |   1 -
 sound/drivers/portman2x4.c                         |   1 -
 sound/drivers/serial-u16550.c                      |   1 -
 sound/drivers/virmidi.c                            |   1 -
 sound/mips/hal2.c                                  |   1 -
 sound/mips/sgio2audio.c                            |   1 -
 sound/oss/dmasound/dmasound_paula.c                |   1 -
 sound/ppc/powermac.c                               |   1 -
 sound/sh/aica.c                                    |   1 -
 sound/sh/sh_dac_audio.c                            |   1 -
 sound/soc/adi/axi-i2s.c                            |   1 -
 sound/soc/adi/axi-spdif.c                          |   1 -
 sound/soc/atmel/atmel_wm8904.c                     |   1 -
 sound/soc/atmel/sam9g20_wm8731.c                   |   1 -
 sound/soc/atmel/sam9x5_wm8731.c                    |   1 -
 sound/soc/au1x/ac97c.c                             |   1 -
 sound/soc/au1x/db1000.c                            |   1 -
 sound/soc/au1x/db1200.c                            |   1 -
 sound/soc/au1x/dbdma2.c                            |   1 -
 sound/soc/au1x/dma.c                               |   1 -
 sound/soc/au1x/i2sc.c                              |   1 -
 sound/soc/au1x/psc-ac97.c                          |   1 -
 sound/soc/au1x/psc-i2s.c                           |   1 -
 sound/soc/bcm/bcm2835-i2s.c                        |   1 -
 sound/soc/blackfin/bf5xx-ac97-pcm.c                |   1 -
 sound/soc/blackfin/bf5xx-ac97.c                    |   1 -
 sound/soc/blackfin/bf5xx-ad1836.c                  |   1 -
 sound/soc/blackfin/bf5xx-i2s-pcm.c                 |   1 -
 sound/soc/blackfin/bf5xx-i2s.c                     |   1 -
 sound/soc/blackfin/bf6xx-i2s.c                     |   1 -
 sound/soc/blackfin/bfin-eval-adau1373.c            |   1 -
 sound/soc/blackfin/bfin-eval-adau1701.c            |   1 -
 sound/soc/blackfin/bfin-eval-adau1x61.c            |   1 -
 sound/soc/blackfin/bfin-eval-adau1x81.c            |   1 -
 sound/soc/blackfin/bfin-eval-adav80x.c             |   1 -
 sound/soc/cirrus/edb93xx.c                         |   1 -
 sound/soc/cirrus/ep93xx-ac97.c                     |   1 -
 sound/soc/cirrus/ep93xx-i2s.c                      |   1 -
 sound/soc/cirrus/simone.c                          |   1 -
 sound/soc/cirrus/snappercl15.c                     |   1 -
 sound/soc/codecs/88pm860x-codec.c                  |   1 -
 sound/soc/codecs/ab8500-codec.c                    |   1 -
 sound/soc/codecs/ac97.c                            |   1 -
 sound/soc/codecs/ad1980.c                          |   1 -
 sound/soc/codecs/ad73311.c                         |   1 -
 sound/soc/codecs/ads117x.c                         |   1 -
 sound/soc/codecs/ak4554.c                          |   1 -
 sound/soc/codecs/ak5386.c                          |   1 -
 sound/soc/codecs/bt-sco.c                          |   1 -
 sound/soc/codecs/cq93vc.c                          |   1 -
 sound/soc/codecs/cx20442.c                         |   1 -
 sound/soc/codecs/dmic.c                            |   1 -
 sound/soc/codecs/hdmi.c                            |   1 -
 sound/soc/codecs/jz4740.c                          |   1 -
 sound/soc/codecs/mc13783.c                         |   1 -
 sound/soc/codecs/pcm3008.c                         |   1 -
 sound/soc/codecs/si476x.c                          |   1 -
 sound/soc/codecs/sirf-audio-codec.c                |   1 -
 sound/soc/codecs/sn95031.c                         |   1 -
 sound/soc/codecs/spdif_receiver.c                  |   1 -
 sound/soc/codecs/spdif_transmitter.c               |   1 -
 sound/soc/codecs/stac9766.c                        |   1 -
 sound/soc/codecs/twl4030.c                         |   1 -
 sound/soc/codecs/twl6040.c                         |   1 -
 sound/soc/codecs/uda134x.c                         |   1 -
 sound/soc/codecs/wl1273.c                          |   1 -
 sound/soc/codecs/wm5102.c                          |   1 -
 sound/soc/codecs/wm5110.c                          |   1 -
 sound/soc/codecs/wm8350.c                          |   1 -
 sound/soc/codecs/wm8400.c                          |   1 -
 sound/soc/codecs/wm8727.c                          |   1 -
 sound/soc/codecs/wm8782.c                          |   1 -
 sound/soc/codecs/wm8994.c                          |   1 -
 sound/soc/codecs/wm8997.c                          |   1 -
 sound/soc/codecs/wm9705.c                          |   1 -
 sound/soc/codecs/wm9712.c                          |   1 -
 sound/soc/codecs/wm9713.c                          |   1 -
 sound/soc/davinci/davinci-evm.c                    |   1 -
 sound/soc/davinci/davinci-i2s.c                    |   1 -
 sound/soc/davinci/davinci-mcasp.c                  |   1 -
 sound/soc/davinci/davinci-vcif.c                   |   1 -
 sound/soc/dwc/designware_i2s.c                     |   1 -
 sound/soc/fsl/eukrea-tlv320.c                      |   1 -
 sound/soc/fsl/fsl_dma.c                            |   1 -
 sound/soc/fsl/fsl_esai.c                           |   1 -
 sound/soc/fsl/fsl_sai.c                            |   1 -
 sound/soc/fsl/fsl_spdif.c                          |   1 -
 sound/soc/fsl/fsl_ssi.c                            |   1 -
 sound/soc/fsl/imx-audmux.c                         |   1 -
 sound/soc/fsl/imx-mc13783.c                        |   1 -
 sound/soc/fsl/imx-sgtl5000.c                       |   1 -
 sound/soc/fsl/imx-spdif.c                          |   1 -
 sound/soc/fsl/imx-ssi.c                            |   1 -
 sound/soc/fsl/imx-wm8962.c                         |   1 -
 sound/soc/fsl/mpc5200_psc_ac97.c                   |   1 -
 sound/soc/fsl/mpc5200_psc_i2s.c                    |   1 -
 sound/soc/fsl/mpc8610_hpcd.c                       |   1 -
 sound/soc/fsl/mx27vis-aic32x4.c                    |   1 -
 sound/soc/fsl/p1022_ds.c                           |   1 -
 sound/soc/fsl/p1022_rdk.c                          |   1 -
 sound/soc/fsl/pcm030-audio-fabric.c                |   1 -
 sound/soc/generic/simple-card.c                    |   1 -
 sound/soc/intel/broadwell.c                        |   1 -
 sound/soc/intel/byt-max98090.c                     |   1 -
 sound/soc/intel/byt-rt5640.c                       |   1 -
 sound/soc/intel/haswell.c                          |   1 -
 sound/soc/intel/mfld_machine.c                     |   1 -
 sound/soc/intel/sst-acpi.c                         |   1 -
 sound/soc/intel/sst-baytrail-pcm.c                 |   1 -
 sound/soc/intel/sst-haswell-pcm.c                  |   1 -
 sound/soc/intel/sst-mfld-platform-pcm.c            |   1 -
 sound/soc/jz4740/jz4740-i2s.c                      |   1 -
 sound/soc/jz4740/qi_lb60.c                         |   1 -
 sound/soc/kirkwood/armada-370-db.c                 |   1 -
 sound/soc/kirkwood/kirkwood-i2s.c                  |   1 -
 sound/soc/mxs/mxs-saif.c                           |   1 -
 sound/soc/mxs/mxs-sgtl5000.c                       |   1 -
 sound/soc/nuc900/nuc900-ac97.c                     |   1 -
 sound/soc/nuc900/nuc900-pcm.c                      |   1 -
 sound/soc/omap/ams-delta.c                         |   1 -
 sound/soc/omap/omap-abe-twl6040.c                  |   1 -
 sound/soc/omap/omap-dmic.c                         |   1 -
 sound/soc/omap/omap-hdmi-card.c                    |   1 -
 sound/soc/omap/omap-hdmi.c                         |   1 -
 sound/soc/omap/omap-mcbsp.c                        |   1 -
 sound/soc/omap/omap-mcpdm.c                        |   1 -
 sound/soc/omap/omap-twl4030.c                      |   1 -
 sound/soc/omap/rx51.c                              |   1 -
 sound/soc/pxa/brownstone.c                         |   1 -
 sound/soc/pxa/corgi.c                              |   1 -
 sound/soc/pxa/e740_wm9705.c                        |   1 -
 sound/soc/pxa/e750_wm9705.c                        |   1 -
 sound/soc/pxa/e800_wm9712.c                        |   1 -
 sound/soc/pxa/hx4700.c                             |   1 -
 sound/soc/pxa/imote2.c                             |   1 -
 sound/soc/pxa/mioa701_wm9713.c                     |   1 -
 sound/soc/pxa/mmp-pcm.c                            |   1 -
 sound/soc/pxa/mmp-sspa.c                           |   1 -
 sound/soc/pxa/palm27x.c                            |   1 -
 sound/soc/pxa/poodle.c                             |   1 -
 sound/soc/pxa/pxa-ssp.c                            |   1 -
 sound/soc/pxa/pxa2xx-ac97.c                        |   1 -
 sound/soc/pxa/pxa2xx-i2s.c                         |   1 -
 sound/soc/pxa/pxa2xx-pcm.c                         |   1 -
 sound/soc/pxa/tosa.c                               |   1 -
 sound/soc/pxa/ttc-dkb.c                            |   1 -
 sound/soc/rockchip/rockchip_i2s.c                  |   1 -
 sound/soc/samsung/ac97.c                           |   1 -
 sound/soc/samsung/bells.c                          |   1 -
 sound/soc/samsung/i2s.c                            |   1 -
 sound/soc/samsung/idma.c                           |   1 -
 sound/soc/samsung/littlemill.c                     |   1 -
 sound/soc/samsung/lowland.c                        |   1 -
 sound/soc/samsung/odroidx2_max98090.c              |   1 -
 sound/soc/samsung/pcm.c                            |   1 -
 sound/soc/samsung/s3c2412-i2s.c                    |   1 -
 sound/soc/samsung/s3c24xx-i2s.c                    |   1 -
 sound/soc/samsung/s3c24xx_simtec_hermes.c          |   1 -
 sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c     |   1 -
 sound/soc/samsung/s3c24xx_uda134x.c                |   1 -
 sound/soc/samsung/smdk_wm8580pcm.c                 |   1 -
 sound/soc/samsung/smdk_wm8994.c                    |   1 -
 sound/soc/samsung/smdk_wm8994pcm.c                 |   1 -
 sound/soc/samsung/snow.c                           |   1 -
 sound/soc/samsung/spdif.c                          |   1 -
 sound/soc/samsung/speyside.c                       |   1 -
 sound/soc/samsung/tobermory.c                      |   1 -
 sound/soc/sh/dma-sh7760.c                          |   1 -
 sound/soc/sh/hac.c                                 |   1 -
 sound/soc/sh/siu_dai.c                             |   1 -
 sound/soc/sh/ssi.c                                 |   1 -
 sound/soc/sirf/sirf-audio-port.c                   |   1 -
 sound/soc/sirf/sirf-audio.c                        |   1 -
 sound/soc/sirf/sirf-usp.c                          |   1 -
 sound/soc/soc-core.c                               |   1 -
 sound/soc/soc-utils.c                              |   1 -
 sound/soc/spear/spdif_in.c                         |   1 -
 sound/soc/spear/spdif_out.c                        |   1 -
 sound/soc/tegra/tegra20_ac97.c                     |   1 -
 sound/soc/tegra/tegra20_das.c                      |   1 -
 sound/soc/tegra/tegra20_i2s.c                      |   1 -
 sound/soc/tegra/tegra20_spdif.c                    |   1 -
 sound/soc/tegra/tegra30_ahub.c                     |   1 -
 sound/soc/tegra/tegra30_i2s.c                      |   1 -
 sound/soc/tegra/tegra_alc5632.c                    |   1 -
 sound/soc/tegra/tegra_max98090.c                   |   1 -
 sound/soc/tegra/tegra_rt5640.c                     |   1 -
 sound/soc/tegra/tegra_wm8753.c                     |   1 -
 sound/soc/tegra/tegra_wm8903.c                     |   1 -
 sound/soc/tegra/tegra_wm9712.c                     |   1 -
 sound/soc/tegra/trimslice.c                        |   1 -
 sound/soc/txx9/txx9aclc-ac97.c                     |   1 -
 sound/soc/txx9/txx9aclc-generic.c                  |   1 -
 sound/soc/txx9/txx9aclc.c                          |   1 -
 sound/soc/ux500/mop500.c                           |   1 -
 sound/soc/ux500/ux500_msp_dai.c                    |   1 -
 sound/sparc/amd7930.c                              |   1 -
 sound/sparc/cs4231.c                               |   1 -
 sound/sparc/dbri.c                                 |   1 -
 1717 files changed, 1455 insertions(+), 2185 deletions(-)
 create mode 100644 drivers/base/cacheinfo.c
 create mode 100644 include/linux/cacheinfo.h
 create mode 100644 scripts/coccinelle/api/platform_no_drv_owner.cocci
