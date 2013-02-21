Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab3BURau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:30:50 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:62665 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab3BURar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:30:47 -0500
Date: Thu, 21 Feb 2013 09:31:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core patches for 3.9-rc1
Message-ID: <20130221173114.GA14009@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.9-rc1

for you to fetch changes up to 74fef7a8fd1d2bd94f925d6638bb4c3049e7c381:

  base: memory: fix soft/hard_offline_page permissions (2013-02-18 11:18:13 -0800)

----------------------------------------------------------------
Driver core patches for 3.9-rc1

Here is the big driver core merge for 3.9-rc1

There are two major series here, both of which touch lots of drivers all
over the kernel, and will cause you some merge conflicts:
  - add a new function called devm_ioremap_resource() to properly be
    able to check return values.
  - remove CONFIG_EXPERIMENTAL

If you need me to provide a merged tree to handle these resolutions,
please let me know.

Other than those patches, there's not much here, some minor fixes and
updates.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Bin Wang (1):
      sysfs: Fixed a trailing white space error

Bjorn Helgaas (1):
      Driver core: treat unregistered bus_types as having no devices

Borislav Petkov (1):
      dma_buf: Cleanup dma_buf_fd

Fabio Porcedda (3):
      driver core: add helper macro for platform_driver_probe() boilerplate
      watchdog: convert drivers/watchdog/* to use module_platform_driver_probe
      usb: converto drivers/usb/* to use module_platform_driver_probe()

Felipe Balbi (2):
      debugfs: regset32: make struct debugfs_reg32 pointer const
      base: memory: fix soft/hard_offline_page permissions

Grant Likely (1):
      drivercore: Fix ordering between deferred_probe and exiting initcalls

Greg Kroah-Hartman (7):
      Merge tag 'for-gregkh-3.9' of git://git.kernel.org/.../kees/linux into driver-core-next
      Revert "sysfs: Convert print_symbol to %pSR"
      Revert "drivers: base: Convert print_symbol to %pSR"
      Merge 3.9-rc4 into driver-core-next
      Merge 3.8-rc5 into driver-core-next
      TTY: mark tty_get_device call with the proper const values
      backlight: fix class_find_device() arguments

Jim Cromie (1):
      dynamic_debug: add pr_errs before -EINVALs

Joe Perches (3):
      dynamic_debug: Fix vpr_<foo> logging styles
      sysfs: Convert print_symbol to %pSR
      drivers: base: Convert print_symbol to %pSR

Kees Cook (160):
      make CONFIG_EXPERIMENTAL invisible and default
      Documentation: remove depends on CONFIG_EXPERIMENTAL
      arch/alpha: remove depends on CONFIG_EXPERIMENTAL
      arch/cris/arch-v32/drivers: remove depends on CONFIG_EXPERIMENTAL
      arch/ia64/kvm: remove depends on CONFIG_EXPERIMENTAL
      arch/ia64: remove depends on CONFIG_EXPERIMENTAL
      arch/ia64/xen: remove depends on CONFIG_EXPERIMENTAL
      arch/powerpc/platforms/ps3: remove depends on CONFIG_EXPERIMENTAL
      arch/s390: remove depends on CONFIG_EXPERIMENTAL
      arch/s390/kvm: remove depends on CONFIG_EXPERIMENTAL
      arch/um: remove depends on CONFIG_EXPERIMENTAL
      arch/x86: remove depends on CONFIG_EXPERIMENTAL
      arch/x86/um: remove depends on CONFIG_EXPERIMENTAL
      crypto: remove depends on CONFIG_EXPERIMENTAL
      drivers/cpufreq: remove depends on CONFIG_EXPERIMENTAL
      drivers/gpu/drm/udl: remove depends on CONFIG_EXPERIMENTAL
      drivers/i2c/muxes: remove depends on CONFIG_EXPERIMENTAL
      drivers/ide: remove depends on CONFIG_EXPERIMENTAL
      drivers/lguest: remove depends on CONFIG_EXPERIMENTAL
      drivers/mmc/core: remove depends on CONFIG_EXPERIMENTAL
      drivers/mmc/host: remove depends on CONFIG_EXPERIMENTAL
      drivers/media: remove depends on CONFIG_EXPERIMENTAL
      drivers/media/video/cx25821: remove depends on CONFIG_EXPERIMENTAL
      drivers/media/video/pvrusb2: remove depends on CONFIG_EXPERIMENTAL
      drivers/media/video/s5p-fimc: remove depends on CONFIG_EXPERIMENTAL
      drivers/media/video/s5p-tv: remove depends on CONFIG_EXPERIMENTAL
      drivers/mtd: remove depends on CONFIG_EXPERIMENTAL
      drivers/mtd/chips: remove depends on CONFIG_EXPERIMENTAL
      drivers/mtd/devices: remove depends on CONFIG_EXPERIMENTAL
      drivers/mtd/nand: remove depends on CONFIG_EXPERIMENTAL
      drivers/net: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/8390: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/atheros: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/dec/tulip: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/i825xx: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/intel: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/natsemi: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/packetengines: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/realtek: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/silan: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/ti: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/team: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/wan: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/usb: remove depends on CONFIG_EXPERIMENTAL
      drivers/pcmcia: remove depends on CONFIG_EXPERIMENTAL
      drivers/rpmsg: remove depends on CONFIG_EXPERIMENTAL
      drivers/sbus/char: remove depends on CONFIG_EXPERIMENTAL
      drivers/virtio: remove depends on CONFIG_EXPERIMENTAL
      fs/ceph: remove depends on CONFIG_EXPERIMENTAL
      fs/ecryptfs: remove depends on CONFIG_EXPERIMENTAL
      fs/nilfs2: remove depends on CONFIG_EXPERIMENTAL
      fs/xfs: remove depends on CONFIG_EXPERIMENTAL
      init: remove depends on CONFIG_EXPERIMENTAL
      kernel/gcov: remove depends on CONFIG_EXPERIMENTAL
      net: remove depends on CONFIG_EXPERIMENTAL
      net/9p: remove depends on CONFIG_EXPERIMENTAL
      net/ceph: remove depends on CONFIG_EXPERIMENTAL
      net/dccp/ccids: remove depends on CONFIG_EXPERIMENTAL
      net/dccp: remove depends on CONFIG_EXPERIMENTAL
      net/decnet/netfilter: remove depends on CONFIG_EXPERIMENTAL
      net/decnet: remove depends on CONFIG_EXPERIMENTAL
      net/ieee802154: remove depends on CONFIG_EXPERIMENTAL
      net/ipv4/netfilter: remove depends on CONFIG_EXPERIMENTAL
      net/ipv4: remove depends on CONFIG_EXPERIMENTAL
      net/ipv6: remove depends on CONFIG_EXPERIMENTAL
      net/l2tp: remove depends on CONFIG_EXPERIMENTAL
      net/lapb: remove depends on CONFIG_EXPERIMENTAL
      net/mac80211: remove depends on CONFIG_EXPERIMENTAL
      net/mac802154: remove depends on CONFIG_EXPERIMENTAL
      net/netfilter: remove depends on CONFIG_EXPERIMENTAL
      net/rds: remove depends on CONFIG_EXPERIMENTAL
      net/rxrpc: remove depends on CONFIG_EXPERIMENTAL
      net/sctp: remove depends on CONFIG_EXPERIMENTAL
      net/sunrpc: remove depends on CONFIG_EXPERIMENTAL
      net/tipc: remove depends on CONFIG_EXPERIMENTAL
      net/wanrouter: remove depends on CONFIG_EXPERIMENTAL
      net/x25: remove depends on CONFIG_EXPERIMENTAL
      net/xfrm: remove depends on CONFIG_EXPERIMENTAL
      tools/lguest: remove depends on CONFIG_EXPERIMENTAL
      arch/microblaze/platform: remove depends on CONFIG_EXPERIMENTAL
      arch/tile/kvm: remove depends on CONFIG_EXPERIMENTAL
      drivers/edac: remove depends on CONFIG_EXPERIMENTAL
      drivers/gpu/drm/cirrus: remove depends on CONFIG_EXPERIMENTAL
      drivers/vlynq: remove depends on CONFIG_EXPERIMENTAL
      lib: remove depends on CONFIG_EXPERIMENTAL
      mm: remove depends on CONFIG_EXPERIMENTAL
      fs/9p: remove depends on CONFIG_EXPERIMENTAL
      fs/adfs: remove depends on CONFIG_EXPERIMENTAL
      fs/affs: remove depends on CONFIG_EXPERIMENTAL
      fs/afs: remove depends on CONFIG_EXPERIMENTAL
      fs/befs: remove depends on CONFIG_EXPERIMENTAL
      fs/bfs: remove depends on CONFIG_EXPERIMENTAL
      fs/btrfs: remove depends on CONFIG_EXPERIMENTAL
      fs/cifs: remove depends on CONFIG_EXPERIMENTAL
      fs/efs: remove depends on CONFIG_EXPERIMENTAL
      fs/hfs: remove depends on CONFIG_EXPERIMENTAL
      fs/jffs2: remove depends on CONFIG_EXPERIMENTAL
      fs/logfs: remove depends on CONFIG_EXPERIMENTAL
      fs/nfsd: remove depends on CONFIG_EXPERIMENTAL
      fs/ufs: remove depends on CONFIG_EXPERIMENTAL
      arch/arm: remove depends on CONFIG_EXPERIMENTAL
      arch/arm/mach-s3c24xx: remove depends on CONFIG_EXPERIMENTAL
      arch/blackfin: remove depends on CONFIG_EXPERIMENTAL
      arch/mips/jazz: remove depends on CONFIG_EXPERIMENTAL
      arch/mips: remove depends on CONFIG_EXPERIMENTAL
      arch/mips/sgi-ip27: remove depends on CONFIG_EXPERIMENTAL
      arch/parisc: remove depends on CONFIG_EXPERIMENTAL
      arch/powerpc/kvm: remove depends on CONFIG_EXPERIMENTAL
      arch/powerpc/platforms/85xx: remove depends on CONFIG_EXPERIMENTAL
      arch/powerpc/platforms/cell: remove depends on CONFIG_EXPERIMENTAL
      arch/powerpc: remove depends on CONFIG_EXPERIMENTAL
      arch/sh: remove depends on CONFIG_EXPERIMENTAL
      Documentation/laptops: remove depends on CONFIG_EXPERIMENTAL
      drivers/acpi: remove depends on CONFIG_EXPERIMENTAL
      drivers/ata: remove depends on CONFIG_EXPERIMENTAL
      drivers/block/paride: remove depends on CONFIG_EXPERIMENTAL
      drivers/gpio: remove depends on CONFIG_EXPERIMENTAL
      drivers/gpu/drm/ast: remove depends on CONFIG_EXPERIMENTAL
      drivers/gpu/drm/gma500: remove depends on CONFIG_EXPERIMENTAL
      drivers/gpu/drm/mgag200: remove depends on CONFIG_EXPERIMENTAL
      drivers/i2c: remove depends on CONFIG_EXPERIMENTAL
      drivers/idle: remove depends on CONFIG_EXPERIMENTAL
      drivers/iommu: remove depends on CONFIG_EXPERIMENTAL
      drivers/isdn/hisax: remove depends on CONFIG_EXPERIMENTAL
      drivers/leds: remove depends on CONFIG_EXPERIMENTAL
      drivers/macintosh: remove depends on CONFIG_EXPERIMENTAL
      drivers/media: remove depends on CONFIG_EXPERIMENTAL
      drivers/memstick/host: remove depends on CONFIG_EXPERIMENTAL
      drivers/memstick: remove depends on CONFIG_EXPERIMENTAL
      drivers/platform/x86: remove depends on CONFIG_EXPERIMENTAL
      drivers/remoteproc: remove depends on CONFIG_EXPERIMENTAL
      drivers/scsi: remove depends on CONFIG_EXPERIMENTAL
      drivers/scsi/arm: remove depends on CONFIG_EXPERIMENTAL
      drivers/scsi/device_handler: remove depends on CONFIG_EXPERIMENTAL
      drivers/spi: remove depends on CONFIG_EXPERIMENTAL
      drivers/vhost: remove depends on CONFIG_EXPERIMENTAL
      drivers/video: remove depends on CONFIG_EXPERIMENTAL
      drivers/video/console: remove depends on CONFIG_EXPERIMENTAL
      drivers/video/geode: remove depends on CONFIG_EXPERIMENTAL
      drivers/video/omap: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/icplus: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/microchip: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/racal: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/seeq: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/stmicro/stmmac: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/sun: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/hippi: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/irda: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ppp: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/wireless: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/wireless/ath/ath6kl: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/wireless/ath/carl9170: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/wireless/b43: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/wireless/ipw2x00: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/wireless/p54: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/wireless/rt2x00: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/wireless/rtl818x: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/wireless/zd1211rw: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/wireless/rtlwifi: remove depends on CONFIG_EXPERIMENTAL
      drivers/net/ethernet/fujitsu: remove depends on CONFIG_EXPERIMENTAL

Marko Katic (1):
      Documentation: devres: add PHY get/put functions to list of supported calls

Michał Mirosław (1):
      driver-core: constify data for class_find_device()

Ming Lei (1):
      driver core: fix possible missing of device probe

Peter Senna Tschudin (1):
      drivers/base/core.c: Remove two unused variables and two useless calls to kfree

Sasha Levin (1):
      debugfs: remove redundant initialization of dentry

Stephen Rothwell (1):
      wireless: remove conflicting version of print_hex_dump_bytes

Takashi Iwai (4):
      firmware: Refactoring for splitting user-mode helper code
      firmware: Make user-mode helper optional
      firmware: Reduce ifdef CONFIG_FW_LOADER_USER_HELPER
      firmware: Ignore abort check when no user-helper is used

Thierry Reding (33):
      lib: devres: Introduce devm_ioremap_resource()
      char: Convert to devm_ioremap_resource()
      gpio: Convert to devm_ioremap_resource()
      iio: Convert to devm_ioremap_resource()
      Input: Convert to devm_ioremap_resource()
      memory: Convert to devm_ioremap_resource()
      misc: Convert to devm_ioremap_resource()
      pinctrl: Convert to devm_ioremap_resource()
      pwm: Convert to devm_ioremap_resource()
      rtc: Convert to devm_ioremap_resource()
      staging: Convert to devm_ioremap_resource()
      serial: Convert to devm_ioremap_resource()
      usb: Convert to devm_ioremap_resource()
      video: Convert to devm_ioremap_resource()
      w1: Convert to devm_ioremap_resource()
      ASoC: Convert to devm_ioremap_resource()
      lib: devres: Fix build breakage
      i2c: Convert to devm_ioremap_resource()
      ARM: Convert to devm_ioremap_resource()
      MIPS: Convert to devm_ioremap_resource()
      amba: Convert to devm_ioremap_resource()
      ata: Convert to devm_ioremap_resource()
      dma: Convert to devm_ioremap_resource()
      drm: Convert to devm_ioremap_resource()
      iommu: Convert to devm_ioremap_resource()
      media: Convert to devm_ioremap_resource()
      mfd: Convert to devm_ioremap_resource()
      mmc: Convert to devm_ioremap_resource()
      mtd: Convert to devm_ioremap_resource()
      power: Convert to devm_ioremap_resource()
      spi: Convert to devm_ioremap_resource()
      thermal: Convert to devm_ioremap_resource()
      watchdog: Convert to devm_ioremap_resource()

Vladimir Kondratiev (1):
      dynamic_debug: dynamic hex dump

 Documentation/CodingStyle                          |  10 +-
 Documentation/DocBook/kernel-hacking.tmpl          |   7 -
 Documentation/DocBook/kgdb.tmpl                    |   6 +-
 Documentation/driver-model/devres.txt              |   7 +-
 Documentation/dynamic-debug-howto.txt              |  15 +-
 Documentation/intel_txt.txt                        |   2 +-
 Documentation/laptops/thinkpad-acpi.txt            |   2 +-
 Documentation/zh_CN/CodingStyle                    |   7 -
 arch/alpha/Kconfig                                 |   3 +-
 arch/arm/Kconfig                                   |  19 +-
 arch/arm/Kconfig.debug                             |   2 +-
 arch/arm/mach-omap2/gpmc.c                         |   8 +-
 arch/arm/mach-s3c24xx/Kconfig                      |   4 +-
 arch/arm/mach-tegra/tegra2_emc.c                   |   8 +-
 arch/arm/plat-omap/dmtimer.c                       |   8 +-
 arch/arm/plat-samsung/adc.c                        |   8 +-
 arch/blackfin/Kconfig                              |   6 +-
 arch/cris/arch-v32/drivers/Kconfig                 |   4 +-
 arch/ia64/Kconfig                                  |   8 +-
 arch/ia64/kvm/Kconfig                              |   2 +-
 arch/ia64/xen/Kconfig                              |   2 +-
 arch/microblaze/platform/Kconfig.platform          |   2 +-
 arch/mips/Kconfig                                  |  27 +-
 arch/mips/jazz/Kconfig                             |   6 +-
 arch/mips/lantiq/xway/dma.c                        |   5 +-
 arch/mips/lantiq/xway/gptu.c                       |   8 +-
 arch/mips/pci/pci-lantiq.c                         |  12 +-
 arch/mips/sgi-ip27/Kconfig                         |   1 -
 arch/parisc/Kconfig                                |   8 +-
 arch/powerpc/Kconfig                               |  14 +-
 arch/powerpc/kvm/Kconfig                           |  10 +-
 arch/powerpc/platforms/85xx/Kconfig                |   1 -
 arch/powerpc/platforms/cell/Kconfig                |   2 +-
 arch/powerpc/platforms/ps3/Kconfig                 |   2 +-
 arch/s390/Kconfig                                  |   4 +-
 arch/s390/kvm/Kconfig                              |   2 +-
 arch/sh/Kconfig                                    |  13 +-
 arch/sh/Kconfig.cpu                                |   3 +-
 arch/sh/mm/Kconfig                                 |   4 +-
 arch/tile/kvm/Kconfig                              |   2 +-
 arch/um/Kconfig.net                                |   2 +-
 arch/um/Kconfig.um                                 |   8 +-
 arch/x86/Kconfig                                   |  22 +-
 arch/x86/um/Kconfig                                |   3 +-
 crypto/Kconfig                                     |  15 +-
 drivers/acpi/Kconfig                               |   9 +-
 drivers/amba/tegra-ahb.c                           |   7 +-
 drivers/ata/Kconfig                                |  24 +-
 drivers/ata/pata_ep93xx.c                          |   7 +-
 drivers/base/Kconfig                               |  11 +
 drivers/base/bus.c                                 |   6 +-
 drivers/base/class.c                               |   4 +-
 drivers/base/core.c                                |   8 +-
 drivers/base/dd.c                                  |   2 +
 drivers/base/dma-buf.c                             |   9 +-
 drivers/base/firmware_class.c                      | 550 +++++++++++----------
 drivers/base/memory.c                              |   4 +-
 drivers/block/paride/Kconfig                       |   4 +-
 drivers/char/hw_random/exynos-rng.c                |   9 +-
 drivers/char/hw_random/omap-rng.c                  |   6 +-
 drivers/char/hw_random/tx4939-rng.c                |   7 +-
 drivers/cpufreq/Kconfig.arm                        |   4 +-
 drivers/cpufreq/Kconfig.x86                        |   6 +-
 drivers/dma/dw_dmac.c                              |   7 +-
 drivers/dma/imx-dma.c                              |   7 +-
 drivers/dma/mmp_pdma.c                             |   7 +-
 drivers/dma/mmp_tdma.c                             |   7 +-
 drivers/dma/tegra20-apb-dma.c                      |  10 +-
 drivers/edac/Kconfig                               |   4 +-
 drivers/gpio/Kconfig                               |   2 +-
 drivers/gpio/gpio-mvebu.c                          |  18 +-
 drivers/gpio/gpio-mxs.c                            |   9 +-
 drivers/gpio/gpio-spear-spics.c                    |   8 +-
 drivers/gpio/gpio-stp-xway.c                       |   9 +-
 drivers/gpio/gpio-tegra.c                          |   9 +-
 drivers/gpio/gpiolib.c                             |   2 +-
 drivers/gpu/drm/ast/Kconfig                        |   2 +-
 drivers/gpu/drm/cirrus/Kconfig                     |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_fimc.c           |   8 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |   8 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |   7 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |   8 +-
 drivers/gpu/drm/exynos/exynos_drm_rotator.c        |   8 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   8 +-
 drivers/gpu/drm/gma500/Kconfig                     |   2 +-
 drivers/gpu/drm/mgag200/Kconfig                    |   2 +-
 drivers/gpu/drm/tegra/dc.c                         |   8 +-
 drivers/gpu/drm/tegra/hdmi.c                       |   6 +-
 drivers/gpu/drm/tegra/host1x.c                     |   6 +-
 drivers/gpu/drm/udl/Kconfig                        |   2 +-
 drivers/i2c/Kconfig                                |   2 +-
 drivers/i2c/busses/Kconfig                         |  16 +-
 drivers/i2c/busses/i2c-at91.c                      |   6 +-
 drivers/i2c/busses/i2c-imx.c                       |   6 +-
 drivers/i2c/busses/i2c-ocores.c                    |   7 +-
 drivers/i2c/busses/i2c-omap.c                      |   8 +-
 drivers/i2c/busses/i2c-rcar.c                      |   8 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   7 +-
 drivers/i2c/busses/i2c-sirf.c                      |   7 +-
 drivers/i2c/busses/i2c-stu300.c                    |   6 +-
 drivers/i2c/busses/i2c-tegra.c                     |   8 +-
 drivers/i2c/busses/i2c-xlr.c                       |   9 +-
 drivers/i2c/muxes/Kconfig                          |   2 -
 drivers/ide/Kconfig                                |   8 +-
 drivers/idle/Kconfig                               |   1 -
 drivers/iio/adc/at91_adc.c                         |   6 +-
 drivers/input/keyboard/spear-keyboard.c            |   8 +-
 drivers/input/serio/arc_ps2.c                      |   7 +-
 drivers/iommu/Kconfig                              |   8 +-
 drivers/iommu/tegra-smmu.c                         |   7 +-
 drivers/isdn/hisax/Kconfig                         |  15 +-
 drivers/isdn/mISDN/core.c                          |   4 +-
 drivers/leds/Kconfig                               |   2 +-
 drivers/lguest/Kconfig                             |   2 +-
 drivers/macintosh/Kconfig                          |   2 +-
 drivers/media/Kconfig                              |   7 +-
 drivers/media/pci/cx25821/Kconfig                  |   2 +-
 drivers/media/platform/Kconfig                     |   8 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |   8 +-
 drivers/media/platform/mx2_emmaprp.c               |   6 +-
 drivers/media/platform/s3c-camif/camif-core.c      |   8 +-
 drivers/media/platform/s5p-fimc/Kconfig            |   1 -
 drivers/media/platform/s5p-fimc/fimc-core.c        |   8 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c        |   8 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |   8 +-
 drivers/media/platform/s5p-g2d/g2d.c               |   8 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   8 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   8 +-
 drivers/media/platform/s5p-tv/Kconfig              |   3 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |  12 +-
 drivers/media/usb/dvb-usb-v2/Kconfig               |   2 +-
 drivers/media/usb/pvrusb2/Kconfig                  |   8 +-
 drivers/memory/emif.c                              |   8 +-
 drivers/memory/tegra20-mc.c                        |   7 +-
 drivers/memory/tegra30-mc.c                        |   7 +-
 drivers/memstick/Kconfig                           |   2 +-
 drivers/memstick/host/Kconfig                      |  12 +-
 drivers/mfd/intel_msic.c                           |   9 +-
 drivers/misc/atmel-ssc.c                           |   8 +-
 drivers/mmc/core/Kconfig                           |   3 +-
 drivers/mmc/host/Kconfig                           |  20 +-
 drivers/mmc/host/dw_mmc-pltfm.c                    |   7 +-
 drivers/mmc/host/mxs-mmc.c                         |   6 +-
 drivers/mmc/host/sdhci-s3c.c                       |   7 +-
 drivers/mtd/Kconfig                                |   2 +-
 drivers/mtd/chips/Kconfig                          |   2 +-
 drivers/mtd/devices/Kconfig                        |   4 +-
 drivers/mtd/devices/spear_smi.c                    |   7 +-
 drivers/mtd/maps/autcpu12-nvram.c                  |   9 +-
 drivers/mtd/maps/lantiq-flash.c                    |   8 +-
 drivers/mtd/nand/Kconfig                           |   7 +-
 drivers/mtd/nand/fsmc_nand.c                       |  33 +-
 drivers/mtd/nand/lpc32xx_mlc.c                     |   9 +-
 drivers/mtd/nand/lpc32xx_slc.c                     |   8 +-
 drivers/mtd/nand/mxc_nand.c                        |  12 +-
 drivers/mtd/nand/s3c2410.c                         |   7 +-
 drivers/mtd/nand/txx9ndfmc.c                       |   7 +-
 drivers/net/Kconfig                                |   9 +-
 drivers/net/ethernet/8390/Kconfig                  |  21 +-
 drivers/net/ethernet/atheros/Kconfig               |   8 +-
 drivers/net/ethernet/dec/tulip/Kconfig             |   4 +-
 drivers/net/ethernet/fujitsu/Kconfig               |   2 +-
 drivers/net/ethernet/i825xx/Kconfig                |  12 +-
 drivers/net/ethernet/icplus/Kconfig                |   2 +-
 drivers/net/ethernet/intel/Kconfig                 |   5 -
 drivers/net/ethernet/microchip/Kconfig             |   4 +-
 drivers/net/ethernet/natsemi/Kconfig               |   3 -
 drivers/net/ethernet/packetengines/Kconfig         |   4 +-
 drivers/net/ethernet/racal/Kconfig                 |   4 +-
 drivers/net/ethernet/realtek/Kconfig               |   4 +-
 drivers/net/ethernet/seeq/Kconfig                  |   4 +-
 drivers/net/ethernet/silan/Kconfig                 |   6 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   4 +-
 drivers/net/ethernet/sun/Kconfig                   |   4 +-
 drivers/net/ethernet/ti/Kconfig                    |   4 +-
 drivers/net/hippi/Kconfig                          |   8 +-
 drivers/net/irda/Kconfig                           |  36 +-
 drivers/net/phy/mdio_bus.c                         |   2 +-
 drivers/net/ppp/Kconfig                            |  20 +-
 drivers/net/team/Kconfig                           |   3 +-
 drivers/net/usb/Kconfig                            |  16 +-
 drivers/net/wan/Kconfig                            |   8 +-
 drivers/net/wireless/Kconfig                       |  10 +-
 drivers/net/wireless/ath/ath6kl/Kconfig            |   1 -
 drivers/net/wireless/ath/carl9170/Kconfig          |   2 +-
 drivers/net/wireless/ath/wil6210/dbg_hexdump.h     |  18 +-
 drivers/net/wireless/b43/Kconfig                   |  12 +-
 drivers/net/wireless/ipw2x00/Kconfig               |   2 +-
 drivers/net/wireless/p54/Kconfig                   |   2 +-
 drivers/net/wireless/rt2x00/Kconfig                |   5 -
 drivers/net/wireless/rtl818x/Kconfig               |   2 +-
 drivers/net/wireless/rtlwifi/Kconfig               |   2 +-
 drivers/net/wireless/zd1211rw/Kconfig              |   2 +-
 drivers/pcmcia/Kconfig                             |   4 +-
 drivers/pinctrl/pinctrl-at91.c                     |   7 +-
 drivers/pinctrl/pinctrl-bcm2835.c                  |   6 +-
 drivers/pinctrl/pinctrl-coh901.c                   |   8 +-
 drivers/pinctrl/pinctrl-exynos5440.c               |   8 +-
 drivers/pinctrl/pinctrl-falcon.c                   |  13 +-
 drivers/pinctrl/pinctrl-imx.c                      |   6 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |   6 +-
 drivers/pinctrl/pinctrl-pxa3xx.c                   |   7 +-
 drivers/pinctrl/pinctrl-samsung.c                  |   8 +-
 drivers/pinctrl/pinctrl-u300.c                     |   6 +-
 drivers/pinctrl/pinctrl-xway.c                     |   9 +-
 drivers/pinctrl/spear/pinctrl-plgpio.c             |   8 +-
 drivers/platform/x86/Kconfig                       |   6 +-
 drivers/power/jz4740-battery.c                     |   7 +-
 drivers/power/power_supply_core.c                  |   4 +-
 drivers/pwm/pwm-imx.c                              |   6 +-
 drivers/pwm/pwm-lpc32xx.c                          |   6 +-
 drivers/pwm/pwm-mxs.c                              |   6 +-
 drivers/pwm/pwm-puv3.c                             |   6 +-
 drivers/pwm/pwm-pxa.c                              |   6 +-
 drivers/pwm/pwm-spear.c                            |   6 +-
 drivers/pwm/pwm-tegra.c                            |   6 +-
 drivers/pwm/pwm-tiecap.c                           |   6 +-
 drivers/pwm/pwm-tiehrpwm.c                         |   6 +-
 drivers/pwm/pwm-tipwmss.c                          |   6 +-
 drivers/pwm/pwm-vt8500.c                           |   6 +-
 drivers/remoteproc/Kconfig                         |   5 +-
 drivers/rpmsg/Kconfig                              |   3 +-
 drivers/rtc/interface.c                            |   6 +-
 drivers/rtc/rtc-s3c.c                              |   8 +-
 drivers/rtc/rtc-snvs.c                             |   6 +-
 drivers/rtc/rtc-spear.c                            |   8 +-
 drivers/rtc/rtc-tegra.c                            |   8 +-
 drivers/sbus/char/Kconfig                          |   7 +-
 drivers/scsi/Kconfig                               |  18 +-
 drivers/scsi/arm/Kconfig                           |  10 +-
 drivers/scsi/device_handler/Kconfig                |   4 +-
 drivers/scsi/hosts.c                               |   4 +-
 drivers/scsi/osd/osd_uld.c                         |  26 +-
 drivers/scsi/scsi_transport_iscsi.c                |   4 +-
 drivers/spi/Kconfig                                |  19 +-
 drivers/spi/spi-ep93xx.c                           |   7 +-
 drivers/spi/spi-mxs.c                              |   6 +-
 drivers/spi/spi-omap2-mcspi.c                      |   7 +-
 drivers/spi/spi-s3c64xx.c                          |   7 +-
 drivers/spi/spi-sirf.c                             |   7 +-
 drivers/spi/spi-tegra20-sflash.c                   |   8 +-
 drivers/spi/spi-tegra20-slink.c                    |   8 +-
 drivers/spi/spi.c                                  |   4 +-
 drivers/staging/iio/adc/mxs-lradc.c                |   7 +-
 drivers/staging/nvec/nvec.c                        |   8 +-
 drivers/staging/omap-thermal/omap-bandgap.c        |  11 +-
 drivers/thermal/exynos_thermal.c                   |   8 +-
 drivers/tty/serial/sccnxp.c                        |   8 +-
 drivers/tty/tty_io.c                               |   4 +-
 drivers/usb/chipidea/usbmisc_imx6q.c               |   6 +-
 drivers/usb/gadget/at91_udc.c                      |  12 +-
 drivers/usb/gadget/atmel_usba_udc.c                |  12 +-
 drivers/usb/gadget/bcm63xx_udc.c                   |  13 +-
 drivers/usb/gadget/fusb300_udc.c                   |  13 +-
 drivers/usb/gadget/imx_udc.c                       |  12 +-
 drivers/usb/gadget/lpc32xx_udc.c                   |  12 +-
 drivers/usb/gadget/m66592-udc.c                    |  12 +-
 drivers/usb/gadget/pxa25x_udc.c                    |  15 +-
 drivers/usb/gadget/r8a66597-udc.c                  |  15 +-
 drivers/usb/gadget/s3c-hsotg.c                     |   7 +-
 drivers/usb/gadget/s3c-hsudc.c                     |   7 +-
 drivers/usb/host/ehci-atmel.c                      |   7 +-
 drivers/usb/host/ehci-grlib.c                      |   9 +-
 drivers/usb/host/ehci-mxc.c                        |   7 +-
 drivers/usb/host/ehci-platform.c                   |   7 +-
 drivers/usb/host/ehci-ppc-of.c                     |   8 +-
 drivers/usb/host/ehci-sead3.c                      |   8 +-
 drivers/usb/host/ehci-sh.c                         |   7 +-
 drivers/usb/host/ehci-vt8500.c                     |   8 +-
 drivers/usb/host/ehci-xilinx-of.c                  |   8 +-
 drivers/usb/host/ohci-nxp.c                        |   7 +-
 drivers/usb/host/ohci-platform.c                   |   7 +-
 drivers/usb/host/ohci-s3c2410.c                    |   7 +-
 drivers/usb/musb/musb_dsps.c                       |   7 +-
 drivers/usb/musb/omap2430.c                        |   4 +-
 drivers/usb/otg/gpio_vbus.c                        |  12 +-
 drivers/usb/otg/msm_otg.c                          |  13 +-
 drivers/usb/otg/mxs-phy.c                          |   6 +-
 drivers/usb/phy/mv_u3d_phy.c                       |   8 +-
 drivers/usb/phy/omap-usb2.c                        |   8 +-
 drivers/usb/renesas_usbhs/common.c                 |   9 +-
 drivers/uwb/lc-rc.c                                |  21 +-
 drivers/vhost/Kconfig                              |   4 +-
 drivers/vhost/Kconfig.tcm                          |   4 +-
 drivers/video/Kconfig                              |  26 +-
 drivers/video/backlight/backlight.c                |   2 +-
 drivers/video/console/Kconfig                      |   2 +-
 drivers/video/exynos/exynos_dp_core.c              |   8 +-
 drivers/video/geode/Kconfig                        |  14 +-
 drivers/video/jz4740_fb.c                          |   6 +-
 drivers/video/omap/Kconfig                         |   2 +-
 drivers/video/omap2/dss/hdmi.c                     |   8 +-
 drivers/video/omap2/vrfb.c                         |   9 +-
 drivers/video/s3c-fb.c                             |   7 +-
 drivers/virtio/Kconfig                             |   8 +-
 drivers/vlynq/Kconfig                              |   2 +-
 drivers/w1/masters/omap_hdq.c                      |   8 +-
 drivers/watchdog/ar7_wdt.c                         |   8 +-
 drivers/watchdog/at32ap700x_wdt.c                  |  12 +-
 drivers/watchdog/at91sam9_wdt.c                    |  13 +-
 drivers/watchdog/coh901327_wdt.c                   |  12 +-
 drivers/watchdog/dw_wdt.c                          |   6 +-
 drivers/watchdog/imx2_wdt.c                        |  20 +-
 drivers/watchdog/jz4740_wdt.c                      |   6 +-
 drivers/watchdog/lantiq_wdt.c                      |   8 +-
 drivers/watchdog/max63xx_wdt.c                     |   7 +-
 drivers/watchdog/pnx4008_wdt.c                     |   6 +-
 drivers/watchdog/txx9wdt.c                         |  19 +-
 fs/9p/Kconfig                                      |   3 +-
 fs/adfs/Kconfig                                    |   4 +-
 fs/affs/Kconfig                                    |   4 +-
 fs/afs/Kconfig                                     |   7 +-
 fs/befs/Kconfig                                    |   4 +-
 fs/bfs/Kconfig                                     |   4 +-
 fs/btrfs/Kconfig                                   |   3 +-
 fs/ceph/Kconfig                                    |   4 +-
 fs/cifs/Kconfig                                    |   8 +-
 fs/debugfs/inode.c                                 |   1 -
 fs/ecryptfs/Kconfig                                |   4 +-
 fs/efs/Kconfig                                     |   4 +-
 fs/hfs/Kconfig                                     |   4 +-
 fs/jffs2/Kconfig                                   |  10 +-
 fs/logfs/Kconfig                                   |   4 +-
 fs/nfsd/Kconfig                                    |   4 +-
 fs/nilfs2/Kconfig                                  |   3 +-
 fs/sysfs/mount.c                                   |   2 +-
 fs/ufs/Kconfig                                     |   2 +-
 fs/xfs/Kconfig                                     |   4 +-
 include/linux/debugfs.h                            |   2 +-
 include/linux/device.h                             |   5 +-
 include/linux/dynamic_debug.h                      |  11 +
 include/linux/platform_device.h                    |  18 +
 include/linux/power_supply.h                       |   2 +-
 include/linux/printk.h                             |  17 +
 include/linux/rtc.h                                |   2 +-
 init/Kconfig                                       |  54 +-
 init/do_mounts.c                                   |   4 +-
 kernel/gcov/Kconfig                                |   2 +-
 kernel/power/suspend_test.c                        |  11 +-
 lib/Kconfig                                        |   2 +-
 lib/Kconfig.debug                                  |   2 +-
 lib/Kconfig.kgdb                                   |   2 +-
 lib/devres.c                                       |  58 ++-
 lib/dynamic_debug.c                                | 165 ++++---
 lib/hexdump.c                                      |   4 +-
 mm/Kconfig                                         |   2 +-
 net/9p/Kconfig                                     |   2 +-
 net/Kconfig                                        |   5 +-
 net/ceph/Kconfig                                   |   4 +-
 net/dccp/Kconfig                                   |   4 +-
 net/dccp/ccids/Kconfig                             |   5 +-
 net/decnet/Kconfig                                 |   4 +-
 net/decnet/netfilter/Kconfig                       |   2 +-
 net/ieee802154/Kconfig                             |   3 +-
 net/ieee802154/wpan-class.c                        |   5 +-
 net/ipv4/Kconfig                                   |  11 +-
 net/ipv4/netfilter/Kconfig                         |   4 +-
 net/ipv6/Kconfig                                   |  24 +-
 net/l2tp/Kconfig                                   |   4 +-
 net/lapb/Kconfig                                   |   3 +-
 net/mac80211/Kconfig                               |   2 +-
 net/mac802154/Kconfig                              |   2 +-
 net/netfilter/Kconfig                              |  24 +-
 net/nfc/core.c                                     |   4 +-
 net/rds/Kconfig                                    |   4 +-
 net/rxrpc/Kconfig                                  |   2 +-
 net/sctp/Kconfig                                   |   4 +-
 net/sunrpc/Kconfig                                 |   2 +-
 net/tipc/Kconfig                                   |   4 +-
 net/wanrouter/Kconfig                              |   1 -
 net/x25/Kconfig                                    |   3 +-
 net/xfrm/Kconfig                                   |  16 +-
 scripts/coccinelle/api/devm_ioremap_resource.cocci |  90 ++++
 sound/soc/cirrus/ep93xx-ac97.c                     |   7 +-
 sound/soc/cirrus/ep93xx-i2s.c                      |   6 +-
 sound/soc/codecs/jz4740.c                          |   6 +-
 sound/soc/fsl/imx-audmux.c                         |   6 +-
 sound/soc/fsl/imx-ssi.c                            |   7 +-
 sound/soc/kirkwood/kirkwood-i2s.c                  |   8 +-
 sound/soc/mxs/mxs-saif.c                           |   8 +-
 sound/soc/pxa/mmp-sspa.c                           |   6 +-
 tools/lguest/lguest.txt                            |   8 +-
 382 files changed, 1707 insertions(+), 1903 deletions(-)
 create mode 100644 scripts/coccinelle/api/devm_ioremap_resource.cocci
