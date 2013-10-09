Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab3JIUwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 16:52:21 -0400
Received: from smtprelay0009.hostedemail.com ([216.40.44.9]:55803 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753551Ab3JIUwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 16:52:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 20,1.5,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:69:355:379:541:857:960:966:973:981:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1593:1594:1730:1747:1777:1792:1801:1981:2194:2196:2198:2199:2200:2201:2393:2559:2562:2743:2828:2897:2899:2901:2904:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:4250:4321:4384:4385:4395:4605:5007:7558:7652:7903:7904:7974:8603:8660:8829:8957:9010:9038:9108:9121:9389:9592:10009:10848:11026:11232:11657:11914:12043:12217:12219:12296:12438:12517:12519:12555:12679:12691:12694:12731:12737:13141:13148:13161:13229:13230:13869:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: part87_8671626937e5c
X-Filterd-Recvd-Size: 289572
Message-ID: <1381351922.2050.22.camel@joe-AO722>
Subject: [Trivial -next PATCH] treewide: devm_kzalloc: Remove unnecessary
 OOM messages
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jiri Kosina <trivial@kernel.org>
Date: Wed, 09 Oct 2013 13:52:02 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have OOM error messages after
devm_kzalloc failures as the call already does a
dump_stack() on OOM.

This removal reduces overall object code size a small
amount and overall code size by ~1000 lines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/plat-omap/dmtimer.c                       |  4 +-
 arch/arm/plat-samsung/adc.c                        |  4 +-
 arch/mips/ralink/timer.c                           |  4 +-
 arch/sparc/kernel/leon_pci_grpci1.c                |  5 +-
 drivers/ata/ahci_imx.c                             |  4 +-
 drivers/ata/ahci_platform.c                        |  4 +-
 drivers/ata/pata_arasan_cf.c                       |  4 +-
 drivers/ata/pata_at91.c                            |  5 +-
 drivers/ata/pata_macio.c                           | 12 ++---
 drivers/ata/pata_mpc52xx.c                         |  1 -
 drivers/ata/pata_samsung_cf.c                      |  4 +-
 drivers/ata/sata_highbank.c                        |  8 +---
 drivers/bluetooth/bcm203x.c                        |  4 +-
 drivers/bluetooth/bfusb.c                          |  4 +-
 drivers/char/hw_random/omap-rng.c                  |  4 +-
 drivers/clk/clk-si5351.c                           |  4 +-
 drivers/clk/ux500/clk-sysctrl.c                    |  4 +-
 drivers/clocksource/em_sti.c                       |  4 +-
 drivers/crypto/omap-aes.c                          |  5 +-
 drivers/crypto/omap-sham.c                         |  1 -
 drivers/crypto/sahara.c                            |  4 +-
 drivers/crypto/tegra-aes.c                         |  8 +---
 drivers/devfreq/exynos/exynos4_bus.c               |  4 +-
 drivers/devfreq/exynos/exynos5_bus.c               |  4 +-
 drivers/dma/edma.c                                 |  4 +-
 drivers/dma/mmp_tdma.c                             |  5 +-
 drivers/dma/mpc512x_dma.c                          |  4 +-
 drivers/dma/pl330.c                                |  4 +-
 drivers/dma/sh/rcar-hpbdma.c                       |  9 +---
 drivers/dma/sh/shdmac.c                            |  9 +---
 drivers/dma/sh/sudmac.c                            |  9 +---
 drivers/dma/sirf-dma.c                             |  4 +-
 drivers/dma/tegra20-apb-dma.c                      |  4 +-
 drivers/extcon/extcon-arizona.c                    |  1 -
 drivers/extcon/extcon-max77693.c                   |  6 +--
 drivers/extcon/extcon-max8997.c                    |  5 +-
 drivers/gpio/gpio-adp5520.c                        |  4 +-
 drivers/gpio/gpio-em.c                             |  1 -
 drivers/gpio/gpio-langwell.c                       |  4 +-
 drivers/gpio/gpio-lynxpoint.c                      |  4 +-
 drivers/gpio/gpio-mvebu.c                          |  4 +-
 drivers/gpio/gpio-omap.c                           |  4 +-
 drivers/gpio/gpio-palmas.c                         |  4 +-
 drivers/gpio/gpio-rc5t583.c                        |  4 +-
 drivers/gpio/gpio-rcar.c                           |  1 -
 drivers/gpio/gpio-spear-spics.c                    |  4 +-
 drivers/gpio/gpio-tegra.c                          |  4 +-
 drivers/gpio/gpio-tps6586x.c                       |  4 +-
 drivers/gpio/gpio-tps65910.c                       |  4 +-
 drivers/gpio/gpio-tz1090-pdc.c                     |  4 +-
 drivers/gpio/gpio-tz1090.c                         |  4 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.c              |  4 +-
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c          |  4 +-
 drivers/gpu/drm/shmobile/shmob_drm_drv.c           |  4 +-
 drivers/hid/hid-a4tech.c                           |  4 +-
 drivers/hid/hid-apple.c                            |  4 +-
 drivers/hid/hid-lenovo-tpkbd.c                     |  9 ++--
 drivers/hid/hid-magicmouse.c                       |  4 +-
 drivers/hid/hid-multitouch.c                       |  9 ++--
 drivers/hid/hid-sensor-hub.c                       | 10 ++--
 drivers/hid/hid-sony.c                             |  4 +-
 drivers/hid/hid-zydacron.c                         |  4 +-
 drivers/hwmon/f71805f.c                            |  4 +-
 drivers/hwmon/lm93.c                               |  5 +-
 drivers/hwmon/max1111.c                            |  4 +-
 drivers/hwmon/max197.c                             |  4 +-
 drivers/hwmon/max6650.c                            |  4 +-
 drivers/hwmon/pc87427.c                            |  4 +-
 drivers/hwmon/s3c-hwmon.c                          |  4 +-
 drivers/hwmon/vt1211.c                             |  4 +-
 drivers/i2c/busses/i2c-bcm2835.c                   |  5 +-
 drivers/i2c/busses/i2c-davinci.c                   |  4 +-
 drivers/i2c/busses/i2c-imx.c                       |  4 +-
 drivers/i2c/busses/i2c-octeon.c                    |  1 -
 drivers/i2c/busses/i2c-omap.c                      |  4 +-
 drivers/i2c/busses/i2c-rcar.c                      |  4 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |  8 +---
 drivers/i2c/busses/i2c-sirf.c                      |  1 -
 drivers/i2c/busses/i2c-stu300.c                    |  4 +-
 drivers/i2c/busses/i2c-tegra.c                     |  4 +-
 drivers/i2c/busses/i2c-wmt.c                       |  4 +-
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c         |  5 +-
 drivers/i2c/muxes/i2c-mux-gpio.c                   | 13 ++---
 drivers/i2c/muxes/i2c-mux-pinctrl.c                | 12 +----
 drivers/iio/adc/at91_adc.c                         |  1 -
 drivers/iio/frequency/adf4350.c                    |  4 +-
 drivers/input/keyboard/imx_keypad.c                |  4 +-
 drivers/input/keyboard/matrix_keypad.c             |  8 +---
 drivers/input/keyboard/nspire-keypad.c             |  4 +-
 drivers/input/keyboard/pxa27x_keypad.c             |  4 +-
 drivers/input/keyboard/samsung-keypad.c            | 14 ++----
 drivers/input/keyboard/spear-keyboard.c            |  4 +-
 drivers/input/keyboard/tegra-kbc.c                 |  4 +-
 drivers/input/matrix-keymap.c                      |  5 +-
 drivers/input/misc/da9055_onkey.c                  |  4 +-
 drivers/input/misc/sirfsoc-onkey.c                 |  4 +-
 drivers/input/misc/twl6040-vibra.c                 |  4 +-
 drivers/input/misc/wm831x-on.c                     |  4 +-
 drivers/input/serio/apbps2.c                       |  4 +-
 drivers/input/serio/arc_ps2.c                      |  4 +-
 drivers/input/touchscreen/auo-pixcir-ts.c          |  4 +-
 drivers/input/touchscreen/egalax_ts.c              |  4 +-
 drivers/input/touchscreen/max11801_ts.c            |  5 +-
 drivers/input/touchscreen/mms114.c                 |  9 ++--
 drivers/iommu/arm-smmu.c                           |  9 ++--
 drivers/iommu/shmobile-ipmmu.c                     |  5 +-
 drivers/iommu/tegra-gart.c                         |  4 +-
 drivers/iommu/tegra-smmu.c                         |  4 +-
 drivers/irqchip/irq-imgpdc.c                       | 10 ++--
 drivers/irqchip/irq-renesas-intc-irqpin.c          |  1 -
 drivers/leds/leds-adp5520.c                        |  4 +-
 drivers/leds/leds-bd2802.c                         |  4 +-
 drivers/leds/leds-da903x.c                         |  4 +-
 drivers/leds/leds-da9052.c                         |  1 -
 drivers/leds/leds-s3c24xx.c                        |  4 +-
 drivers/leds/leds-sunfire.c                        |  4 +-
 drivers/media/i2c/adv7604.c                        |  4 +-
 drivers/media/i2c/adv7842.c                        |  4 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  1 -
 drivers/media/i2c/soc_camera/ov2640.c              |  5 +-
 drivers/media/i2c/soc_camera/ov6650.c              |  5 +-
 drivers/media/i2c/soc_camera/ov9640.c              |  5 +-
 drivers/media/i2c/soc_camera/ov9740.c              |  4 +-
 drivers/media/platform/coda.c                      |  5 +-
 drivers/media/platform/fsl-viu.c                   |  1 -
 drivers/media/platform/omap3isp/isp.c              |  4 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c      |  5 +-
 drivers/media/platform/omap3isp/isph3a_af.c        |  5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           | 14 ++----
 drivers/media/platform/s5p-tv/hdmi_drv.c           |  1 -
 drivers/media/platform/s5p-tv/sdo_drv.c            |  1 -
 drivers/media/platform/s5p-tv/sii9234_drv.c        |  1 -
 drivers/media/platform/soc_camera/mx2_camera.c     |  1 -
 drivers/media/platform/soc_camera/mx3_camera.c     |  4 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |  4 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  4 +-
 drivers/media/radio/radio-si4713.c                 |  1 -
 drivers/media/radio/radio-wl1273.c                 |  1 -
 drivers/memory/emif.c                              | 17 +------
 drivers/mfd/aat2870-core.c                         |  5 +-
 drivers/mfd/ab3100-core.c                          |  4 +-
 drivers/mfd/ab3100-otp.c                           |  5 +-
 drivers/mfd/ab8500-gpadc.c                         |  4 +-
 drivers/mfd/abx500-core.c                          |  5 +-
 drivers/mfd/as3711.c                               |  8 +---
 drivers/mfd/asic3.c                                |  4 +-
 drivers/mfd/davinci_voicecodec.c                   |  5 +-
 drivers/mfd/htc-i2cpld.c                           |  4 +-
 drivers/mfd/janz-cmodio.c                          |  4 +-
 drivers/mfd/jz4740-adc.c                           |  4 +-
 drivers/mfd/max77686.c                             |  4 +-
 drivers/mfd/max8997.c                              |  4 +-
 drivers/mfd/omap-usb-host.c                        |  5 +-
 drivers/mfd/omap-usb-tll.c                         |  5 +-
 drivers/mfd/pm8921-core.c                          |  4 +-
 drivers/mfd/rc5t583.c                              |  4 +-
 drivers/mfd/sec-core.c                             |  4 +-
 drivers/mfd/si476x-i2c.c                           |  6 +--
 drivers/mfd/smsc-ece1099.c                         |  4 +-
 drivers/mfd/ti_am335x_tscadc.c                     |  5 +-
 drivers/mfd/tps65090.c                             |  4 +-
 drivers/mfd/tps6586x.c                             |  8 +---
 drivers/mfd/tps65910.c                             |  4 +-
 drivers/mfd/tps80031.c                             |  4 +-
 drivers/mfd/twl6030-irq.c                          |  4 +-
 drivers/misc/atmel-ssc.c                           |  4 +-
 drivers/misc/lattice-ecp3-config.c                 |  5 +-
 drivers/misc/vmw_vmci/vmci_guest.c                 |  5 +-
 drivers/mmc/host/atmel-mci.c                       |  4 +-
 drivers/mmc/host/davinci_mmc.c                     |  4 +-
 drivers/mmc/host/dw_mmc-exynos.c                   |  4 +-
 drivers/mmc/host/dw_mmc-socfpga.c                  |  4 +-
 drivers/mmc/host/dw_mmc.c                          |  4 +-
 drivers/mmc/host/sdhci-bcm2835.c                   |  5 +-
 drivers/mmc/host/sdhci-dove.c                      |  4 +-
 drivers/mmc/host/sdhci-spear.c                     |  5 +-
 drivers/mmc/host/sdhci-tegra.c                     |  1 -
 drivers/mmc/host/sh_mobile_sdhi.c                  |  4 +-
 drivers/mtd/devices/elm.c                          |  4 +-
 drivers/mtd/devices/spear_smi.c                    |  2 -
 drivers/mtd/nand/atmel_nand.c                      |  4 +-
 drivers/mtd/nand/davinci_nand.c                    |  1 -
 drivers/mtd/nand/fsmc_nand.c                       |  9 ++--
 drivers/mtd/nand/gpio.c                            |  4 +-
 drivers/mtd/nand/lpc32xx_mlc.c                     | 10 +---
 drivers/mtd/nand/lpc32xx_slc.c                     | 10 ++--
 drivers/mtd/nand/mpc5121_nfc.c                     |  4 +-
 drivers/mtd/nand/orion_nand.c                      |  1 -
 drivers/mtd/nand/s3c2410.c                         |  2 -
 drivers/mtd/nand/sh_flctl.c                        |  4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  6 +--
 drivers/net/ethernet/ti/cpsw-phy-sel.c             |  4 +-
 drivers/net/ethernet/ti/cpsw.c                     |  4 +-
 drivers/net/phy/mdio-mux.c                         |  2 -
 drivers/nfc/microread/i2c.c                        |  4 +-
 drivers/nfc/pn544/i2c.c                            |  5 +-
 drivers/pci/host/pci-exynos.c                      |  4 +-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c              | 17 ++-----
 drivers/pinctrl/pinctrl-abx500.c                   |  5 +-
 drivers/pinctrl/pinctrl-adi2.c                     |  8 +---
 drivers/pinctrl/pinctrl-at91.c                     |  4 +-
 drivers/pinctrl/pinctrl-baytrail.c                 |  4 +-
 drivers/pinctrl/pinctrl-exynos.c                   |  8 +---
 drivers/pinctrl/pinctrl-exynos5440.c               | 55 +++++++---------------
 drivers/pinctrl/pinctrl-palmas.c                   |  4 +-
 drivers/pinctrl/pinctrl-rockchip.c                 | 13 ++---
 drivers/pinctrl/pinctrl-s3c64xx.c                  | 15 +++---
 drivers/pinctrl/pinctrl-samsung.c                  | 44 ++++++-----------
 drivers/pinctrl/pinctrl-single.c                   |  5 +-
 drivers/pinctrl/pinctrl-tegra.c                    |  9 ++--
 drivers/pinctrl/pinctrl-tz1090-pdc.c               |  5 +-
 drivers/pinctrl/pinctrl-tz1090.c                   |  5 +-
 drivers/pinctrl/pinctrl-xway.c                     | 10 ++--
 drivers/pinctrl/spear/pinctrl-plgpio.c             |  8 +---
 drivers/pinctrl/spear/pinctrl-spear.c              |  4 +-
 drivers/pinctrl/vt8500/pinctrl-vt8500.c            |  4 +-
 drivers/pinctrl/vt8500/pinctrl-wm8505.c            |  4 +-
 drivers/pinctrl/vt8500/pinctrl-wm8650.c            |  4 +-
 drivers/pinctrl/vt8500/pinctrl-wm8750.c            |  4 +-
 drivers/pinctrl/vt8500/pinctrl-wm8850.c            |  4 +-
 drivers/power/ab8500_btemp.c                       |  4 +-
 drivers/power/ab8500_charger.c                     |  4 +-
 drivers/power/ab8500_fg.c                          |  4 +-
 drivers/power/abx500_chargalg.c                    |  4 +-
 drivers/power/avs/smartreflex.c                    | 10 +---
 drivers/power/bq2415x_charger.c                    |  1 -
 drivers/power/bq24190_charger.c                    |  4 +-
 drivers/power/generic-adc-battery.c                |  4 +-
 drivers/power/gpio-charger.c                       |  4 +-
 drivers/power/jz4740-battery.c                     |  4 +-
 drivers/power/max8903_charger.c                    |  5 +-
 drivers/power/max8925_power.c                      |  2 +
 drivers/power/max8997_charger.c                    |  4 +-
 drivers/power/power_supply_core.c                  |  8 +---
 drivers/power/reset/xgene-reboot.c                 |  4 +-
 drivers/power/tps65090-charger.c                   |  8 +---
 drivers/pwm/pwm-ab8500.c                           |  4 +-
 drivers/pwm/pwm-atmel-tcb.c                        |  1 -
 drivers/pwm/pwm-bfin.c                             |  4 +-
 drivers/pwm/pwm-imx.c                              |  4 +-
 drivers/pwm/pwm-puv3.c                             |  4 +-
 drivers/pwm/pwm-pxa.c                              |  4 +-
 drivers/pwm/pwm-renesas-tpu.c                      |  4 +-
 drivers/pwm/pwm-spear.c                            |  4 +-
 drivers/pwm/pwm-tegra.c                            |  4 +-
 drivers/pwm/pwm-tiecap.c                           |  4 +-
 drivers/pwm/pwm-tiehrpwm.c                         |  4 +-
 drivers/pwm/pwm-tipwmss.c                          |  4 +-
 drivers/pwm/pwm-vt8500.c                           |  4 +-
 drivers/regulator/88pm800.c                        |  4 +-
 drivers/regulator/arizona-ldo1.c                   |  4 +-
 drivers/regulator/arizona-micsupp.c                |  4 +-
 drivers/regulator/as3711-regulator.c               |  4 +-
 drivers/regulator/da9063-regulator.c               |  4 +-
 drivers/regulator/da9210-regulator.c               |  5 +-
 drivers/regulator/fan53555.c                       |  5 +-
 drivers/regulator/fixed.c                          |  1 -
 drivers/regulator/gpio-regulator.c                 |  4 +-
 drivers/regulator/max77686.c                       |  5 +-
 drivers/regulator/max8649.c                        |  4 +-
 drivers/regulator/max8907-regulator.c              |  5 +-
 drivers/regulator/max8952.c                        |  4 +-
 drivers/regulator/max8973-regulator.c              |  4 +-
 drivers/regulator/max8997.c                        |  1 -
 drivers/regulator/rc5t583-regulator.c              |  5 +-
 drivers/regulator/s5m8767.c                        | 10 +---
 drivers/regulator/ti-abb-regulator.c               | 11 ++---
 drivers/regulator/tps51632-regulator.c             |  8 +---
 drivers/regulator/tps62360-regulator.c             |  9 +---
 drivers/regulator/tps6507x-regulator.c             |  8 +---
 drivers/regulator/tps65090-regulator.c             | 12 ++---
 drivers/regulator/tps6524x-regulator.c             |  5 +-
 drivers/regulator/tps6586x-regulator.c             |  8 +---
 drivers/regulator/tps65910-regulator.c             | 21 ++-------
 drivers/regulator/tps80031-regulator.c             |  4 +-
 drivers/regulator/wm831x-dcdc.c                    | 16 ++-----
 drivers/regulator/wm831x-isink.c                   |  4 +-
 drivers/regulator/wm831x-ldo.c                     | 12 ++---
 drivers/regulator/wm8994-regulator.c               |  4 +-
 drivers/rtc/rtc-at32ap700x.c                       |  4 +-
 drivers/rtc/rtc-davinci.c                          |  4 +-
 drivers/rtc/rtc-ds1390.c                           |  5 +-
 drivers/rtc/rtc-lpc32xx.c                          |  5 +-
 drivers/rtc/rtc-moxart.c                           |  4 +-
 drivers/rtc/rtc-nuc900.c                           |  5 +-
 drivers/rtc/rtc-pm8xxx.c                           |  4 +-
 drivers/rtc/rtc-rx8025.c                           |  1 -
 drivers/rtc/rtc-sirfsoc.c                          |  6 +--
 drivers/rtc/rtc-spear.c                            |  4 +-
 drivers/scsi/isci/probe_roms.c                     | 10 +---
 drivers/scsi/ufs/ufshcd.c                          |  5 +-
 drivers/spi/spi-pl022.c                            |  4 +-
 drivers/spi/spi-pxa2xx.c                           |  5 +-
 drivers/spi/spi-s3c64xx.c                          |  4 +-
 drivers/spi/spi-sh-msiof.c                         |  4 +-
 drivers/staging/nvec/nvec.c                        |  5 +-
 drivers/thermal/rcar_thermal.c                     |  5 +-
 drivers/thermal/samsung/exynos_tmu.c               |  5 +-
 drivers/thermal/spear_thermal.c                    |  4 +-
 drivers/thermal/ti-soc-thermal/ti-bandgap.c        |  8 +---
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  5 +-
 drivers/tty/serial/8250/8250_em.c                  |  4 +-
 drivers/tty/serial/clps711x.c                      |  5 +-
 drivers/tty/serial/max310x.c                       |  4 +-
 drivers/tty/serial/sccnxp.c                        |  5 +-
 drivers/tty/serial/serial-tegra.c                  |  4 +-
 drivers/tty/serial/sh-sci.c                        |  4 +-
 drivers/uio/uio_pdrv_genirq.c                      |  9 ++--
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  4 +-
 drivers/usb/chipidea/core.c                        |  4 +-
 drivers/usb/class/usbtmc.c                         |  4 +-
 drivers/usb/dwc3/core.c                            |  9 ++--
 drivers/usb/dwc3/dwc3-exynos.c                     |  4 +-
 drivers/usb/dwc3/dwc3-omap.c                       |  4 +-
 drivers/usb/dwc3/dwc3-pci.c                        |  4 +-
 drivers/usb/gadget/bcm63xx_udc.c                   |  4 +-
 drivers/usb/gadget/mv_udc_core.c                   |  6 +--
 drivers/usb/gadget/s3c-hsotg.c                     |  4 +-
 drivers/usb/gadget/s3c-hsudc.c                     |  4 +-
 drivers/usb/host/ehci-mv.c                         |  1 -
 drivers/usb/host/ehci-sh.c                         |  1 -
 drivers/usb/host/ehci-tegra.c                      |  1 -
 drivers/usb/misc/usb3503.c                         |  9 ++--
 drivers/usb/musb/musb_dsps.c                       |  1 -
 drivers/usb/musb/omap2430.c                        | 19 ++------
 drivers/usb/phy/phy-am335x-control.c               |  4 +-
 drivers/usb/phy/phy-mv-usb.c                       |  4 +-
 drivers/usb/phy/phy-mxs-usb.c                      |  4 +-
 drivers/usb/phy/phy-omap-control.c                 |  4 +-
 drivers/usb/phy/phy-omap-usb2.c                    |  8 +---
 drivers/usb/phy/phy-omap-usb3.c                    |  4 +-
 drivers/usb/phy/phy-rcar-usb.c                     |  4 +-
 drivers/usb/phy/phy-tegra-usb.c                    |  9 +---
 drivers/usb/renesas_usbhs/common.c                 |  4 +-
 drivers/video/au1100fb.c                           |  4 +-
 drivers/video/auo_k190x.c                          |  1 -
 drivers/video/backlight/aat2870_bl.c               |  2 -
 drivers/video/backlight/adp8860_bl.c               |  4 +-
 drivers/video/backlight/adp8870_bl.c               |  4 +-
 drivers/video/backlight/corgi_lcd.c                |  4 +-
 drivers/video/backlight/hx8357.c                   |  4 +-
 drivers/video/backlight/ili922x.c                  |  4 +-
 drivers/video/backlight/ili9320.c                  |  4 +-
 drivers/video/backlight/l4f00242t03.c              |  5 +-
 drivers/video/backlight/lm3533_bl.c                |  5 +-
 drivers/video/backlight/lms283gf05.c               |  4 +-
 drivers/video/backlight/platform_lcd.c             |  4 +-
 drivers/video/backlight/pwm_bl.c                   |  1 -
 drivers/video/backlight/tps65217_bl.c              |  5 +-
 drivers/video/bf537-lq035.c                        |  1 -
 drivers/video/bf54x-lq043fb.c                      |  3 --
 drivers/video/exynos/exynos_dp_core.c              | 15 ++----
 drivers/video/exynos/exynos_mipi_dsi.c             |  4 +-
 drivers/video/exynos/s6e8ax0.c                     |  4 +-
 drivers/video/omap2/dss/dispc.c                    |  4 +-
 drivers/video/omap2/dss/dss.c                      |  4 +-
 drivers/video/s3c-fb.c                             |  4 +-
 drivers/video/ssd1307fb.c                          |  1 -
 drivers/video/vt8500lcdfb.c                        |  1 -
 drivers/video/wm8505fb.c                           |  4 +-
 drivers/w1/masters/omap_hdq.c                      |  4 +-
 drivers/watchdog/at32ap700x_wdt.c                  |  4 +-
 drivers/watchdog/bcm2835_wdt.c                     |  5 +-
 drivers/watchdog/da9052_wdt.c                      |  1 -
 drivers/watchdog/da9055_wdt.c                      |  4 +-
 drivers/watchdog/jz4740_wdt.c                      |  4 +-
 drivers/watchdog/sp805_wdt.c                       |  1 -
 drivers/watchdog/ts72xx_wdt.c                      |  4 +-
 drivers/watchdog/wm831x_wdt.c                      |  1 -
 sound/soc/codecs/cs4270.c                          |  4 +-
 sound/soc/codecs/cs42l51.c                         |  4 +-
 sound/soc/codecs/cs42l73.c                         |  4 +-
 sound/soc/codecs/sta529.c                          |  4 +-
 sound/soc/codecs/tlv320aic3x.c                     |  8 +---
 sound/soc/codecs/tpa6130a2.c                       |  4 +-
 sound/soc/codecs/twl4030.c                         | 10 ++--
 sound/soc/codecs/wm1250-ev1.c                      |  1 -
 sound/soc/codecs/wm2000.c                          |  5 +-
 sound/soc/codecs/wm8903.c                          |  4 +-
 sound/soc/codecs/wm8994.c                          |  6 +--
 sound/soc/codecs/wm9090.c                          |  4 +-
 sound/soc/codecs/wm_hubs.c                         |  4 +-
 sound/soc/davinci/davinci-vcif.c                   |  5 +-
 sound/soc/dwc/designware_i2s.c                     |  5 +-
 sound/soc/fsl/fsl_ssi.c                            |  4 +-
 sound/soc/fsl/imx-spdif.c                          |  1 -
 sound/soc/kirkwood/kirkwood-i2s.c                  |  5 +-
 sound/soc/mid-x86/mfld_machine.c                   |  4 +-
 sound/soc/omap/omap-hdmi.c                         |  4 +-
 sound/soc/sh/fsi.c                                 |  4 +-
 sound/soc/sh/rcar/adg.c                            |  4 +-
 sound/soc/sh/rcar/core.c                           |  8 +---
 sound/soc/sh/rcar/gen.c                            |  4 +-
 sound/soc/sh/rcar/scu.c                            |  4 +-
 sound/soc/sh/rcar/ssi.c                            |  4 +-
 sound/soc/soc-compress.c                           |  1 -
 sound/soc/soc-core.c                               |  9 +---
 sound/soc/spear/spdif_in.c                         |  4 +-
 sound/soc/spear/spdif_out.c                        |  4 +-
 sound/soc/tegra/tegra20_ac97.c                     |  1 -
 sound/soc/tegra/tegra20_das.c                      |  1 -
 sound/soc/tegra/tegra20_i2s.c                      |  1 -
 sound/soc/tegra/tegra20_spdif.c                    |  1 -
 sound/soc/tegra/tegra30_ahub.c                     |  1 -
 sound/soc/tegra/tegra30_i2s.c                      |  1 -
 sound/soc/tegra/tegra_alc5632.c                    |  4 +-
 sound/soc/tegra/tegra_rt5640.c                     |  4 +-
 sound/soc/tegra/tegra_wm8753.c                     |  4 +-
 sound/soc/tegra/tegra_wm8903.c                     |  4 +-
 sound/soc/tegra/tegra_wm9712.c                     |  4 +-
 sound/soc/tegra/trimslice.c                        |  4 +-
 411 files changed, 534 insertions(+), 1490 deletions(-)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 869254c..85a356b 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -821,10 +821,8 @@ static int omap_dm_timer_probe(struct platform_device *pdev)
 	}
 
 	timer = devm_kzalloc(dev, sizeof(struct omap_dm_timer), GFP_KERNEL);
-	if (!timer) {
-		dev_err(dev, "%s: memory alloc failed!\n", __func__);
+	if (!timer)
 		return  -ENOMEM;
-	}
 
 	timer->fclk = ERR_PTR(-ENODEV);
 	timer->io_base = devm_ioremap_resource(dev, mem);
diff --git a/arch/arm/plat-samsung/adc.c b/arch/arm/plat-samsung/adc.c
index 79690f2..4e4a6a5 100644
--- a/arch/arm/plat-samsung/adc.c
+++ b/arch/arm/plat-samsung/adc.c
@@ -345,10 +345,8 @@ static int s3c_adc_probe(struct platform_device *pdev)
 	unsigned tmp;
 
 	adc = devm_kzalloc(dev, sizeof(struct adc_device), GFP_KERNEL);
-	if (adc == NULL) {
-		dev_err(dev, "failed to allocate adc_device\n");
+	if (adc == NULL)
 		return -ENOMEM;
-	}
 
 	spin_lock_init(&adc->lock);
 
diff --git a/arch/mips/ralink/timer.c b/arch/mips/ralink/timer.c
index e49241a..d1be13a 100644
--- a/arch/mips/ralink/timer.c
+++ b/arch/mips/ralink/timer.c
@@ -115,10 +115,8 @@ static int rt_timer_probe(struct platform_device *pdev)
 	struct clk *clk;
 
 	rt = devm_kzalloc(&pdev->dev, sizeof(*rt), GFP_KERNEL);
-	if (!rt) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!rt)
 		return -ENOMEM;
-	}
 
 	rt->irq = platform_get_irq(pdev, 0);
 	if (!rt->irq) {
diff --git a/arch/sparc/kernel/leon_pci_grpci1.c b/arch/sparc/kernel/leon_pci_grpci1.c
index 6df26e3..497489d 100644
--- a/arch/sparc/kernel/leon_pci_grpci1.c
+++ b/arch/sparc/kernel/leon_pci_grpci1.c
@@ -527,10 +527,9 @@ static int grpci1_of_probe(struct platform_device *ofdev)
 	}
 
 	priv = devm_kzalloc(&ofdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&ofdev->dev, "memory allocation failed\n");
+	if (!priv)
 		return -ENOMEM;
-	}
+
 	platform_set_drvdata(ofdev, priv);
 	priv->dev = &ofdev->dev;
 
diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
index 58debb0..2faa466 100644
--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -140,10 +140,8 @@ static int imx_ahci_probe(struct platform_device *pdev)
 	int ret;
 
 	imxpriv = devm_kzalloc(dev, sizeof(*imxpriv), GFP_KERNEL);
-	if (!imxpriv) {
-		dev_err(dev, "can't alloc ahci_host_priv\n");
+	if (!imxpriv)
 		return -ENOMEM;
-	}
 
 	ahci_pdev = platform_device_alloc("ahci", -1);
 	if (!ahci_pdev)
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 2daaee0..2d4c9ea 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -117,10 +117,8 @@ static int ahci_probe(struct platform_device *pdev)
 		pi = *pdata->ata_port_info;
 
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
-	if (!hpriv) {
-		dev_err(dev, "can't alloc ahci_host_priv\n");
+	if (!hpriv)
 		return -ENOMEM;
-	}
 
 	hpriv->flags |= (unsigned long)pi.private_data;
 
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 853f610..8f3f23c 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -809,10 +809,8 @@ static int arasan_cf_probe(struct platform_device *pdev)
 	}
 
 	acdev = devm_kzalloc(&pdev->dev, sizeof(*acdev), GFP_KERNEL);
-	if (!acdev) {
-		dev_warn(&pdev->dev, "kzalloc fail\n");
+	if (!acdev)
 		return -ENOMEM;
-	}
 
 	if (pdata)
 		quirk = pdata->quirk;
diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index d63ee8f..0ff2b34 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -360,11 +360,8 @@ static int pata_at91_probe(struct platform_device *pdev)
 	}
 
 	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
-
-	if (!info) {
-		dev_err(dev, "failed to allocate memory for private data\n");
+	if (!info)
 		return -ENOMEM;
-	}
 
 	info->mck = clk_get(NULL, "mck");
 
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index c28d064..cec4b05 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -1133,11 +1133,9 @@ static int pata_macio_attach(struct macio_dev *mdev,
 	/* Allocate and init private data structure */
 	priv = devm_kzalloc(&mdev->ofdev.dev,
 			    sizeof(struct pata_macio_priv), GFP_KERNEL);
-	if (priv == NULL) {
-		dev_err(&mdev->ofdev.dev,
-			"Failed to allocate private memory\n");
+	if (priv == NULL)
 		return -ENOMEM;
-	}
+
 	priv->node = of_node_get(mdev->ofdev.dev.of_node);
 	priv->mdev = mdev;
 	priv->dev = &mdev->ofdev.dev;
@@ -1281,11 +1279,9 @@ static int pata_macio_pci_attach(struct pci_dev *pdev,
 	/* Allocate and init private data structure */
 	priv = devm_kzalloc(&pdev->dev,
 			    sizeof(struct pata_macio_priv), GFP_KERNEL);
-	if (priv == NULL) {
-		dev_err(&pdev->dev,
-			"Failed to allocate private memory\n");
+	if (priv == NULL)
 		return -ENOMEM;
-	}
+
 	priv->node = of_node_get(np);
 	priv->pdev = pdev;
 	priv->dev = &pdev->dev;
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 0024ced..a16d1f6 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -738,7 +738,6 @@ static int mpc52xx_ata_probe(struct platform_device *op)
 	/* Prepare our private structure */
 	priv = devm_kzalloc(&op->dev, sizeof(*priv), GFP_ATOMIC);
 	if (!priv) {
-		dev_err(&op->dev, "error allocating private structure\n");
 		rv = -ENOMEM;
 		goto err1;
 	}
diff --git a/drivers/ata/pata_samsung_cf.c b/drivers/ata/pata_samsung_cf.c
index 898e544..ae16576 100644
--- a/drivers/ata/pata_samsung_cf.c
+++ b/drivers/ata/pata_samsung_cf.c
@@ -487,10 +487,8 @@ static int __init pata_s3c_probe(struct platform_device *pdev)
 	cpu_type = platform_get_device_id(pdev)->driver_data;
 
 	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
-	if (!info) {
-		dev_err(dev, "failed to allocate memory for device data\n");
+	if (!info)
 		return -ENOMEM;
-	}
 
 	info->irq = platform_get_irq(pdev, 0);
 
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index 7f5e5d9..8046e72 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -492,15 +492,11 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	}
 
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
-	if (!hpriv) {
-		dev_err(dev, "can't alloc ahci_host_priv\n");
+	if (!hpriv)
 		return -ENOMEM;
-	}
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "can't alloc ecx_plat_data\n");
+	if (!pdata)
 		return -ENOMEM;
-	}
 
 	hpriv->flags |= (unsigned long)pi.private_data;
 
diff --git a/drivers/bluetooth/bcm203x.c b/drivers/bluetooth/bcm203x.c
index 364f82b..5b0ef7b 100644
--- a/drivers/bluetooth/bcm203x.c
+++ b/drivers/bluetooth/bcm203x.c
@@ -178,10 +178,8 @@ static int bcm203x_probe(struct usb_interface *intf, const struct usb_device_id
 		return -ENODEV;
 
 	data = devm_kzalloc(&intf->dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		BT_ERR("Can't allocate memory for data structure");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	data->udev  = udev;
 	data->state = BCM203X_LOAD_MINIDRV;
diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index 995aee9..815bed5 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -654,10 +654,8 @@ static int bfusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 
 	/* Initialize control structure and load firmware */
 	data = devm_kzalloc(&intf->dev, sizeof(struct bfusb_data), GFP_KERNEL);
-	if (!data) {
-		BT_ERR("Can't allocate memory for control structure");
+	if (!data)
 		goto done;
-	}
 
 	data->udev = udev;
 	data->bulk_in_ep    = bulk_in_ep->desc.bEndpointAddress;
diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 9b89ff4..f66ea25 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -369,10 +369,8 @@ static int omap_rng_probe(struct platform_device *pdev)
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(struct omap_rng_dev), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "could not allocate memory\n");
+	if (!priv)
 		return -ENOMEM;
-	};
 
 	omap_rng_ops.priv = (unsigned long)priv;
 	platform_set_drvdata(pdev, priv);
diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index c50e837..165aa18 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -1324,10 +1324,8 @@ static int si5351_i2c_probe(struct i2c_client *client,
 		return -EINVAL;
 
 	drvdata = devm_kzalloc(&client->dev, sizeof(*drvdata), GFP_KERNEL);
-	if (drvdata == NULL) {
-		dev_err(&client->dev, "unable to allocate driver data\n");
+	if (drvdata == NULL)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(client, drvdata);
 	drvdata->client = client;
diff --git a/drivers/clk/ux500/clk-sysctrl.c b/drivers/clk/ux500/clk-sysctrl.c
index e364c9d..006ae33 100644
--- a/drivers/clk/ux500/clk-sysctrl.c
+++ b/drivers/clk/ux500/clk-sysctrl.c
@@ -140,10 +140,8 @@ static struct clk *clk_reg_sysctrl(struct device *dev,
 	}
 
 	clk = devm_kzalloc(dev, sizeof(struct clk_sysctrl), GFP_KERNEL);
-	if (!clk) {
-		dev_err(dev, "clk_sysctrl: could not allocate clk\n");
+	if (!clk)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	/* set main clock registers */
 	clk->reg_sel[0] = reg_sel[0];
diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
index 3a5909c..523aff7 100644
--- a/drivers/clocksource/em_sti.c
+++ b/drivers/clocksource/em_sti.c
@@ -318,10 +318,8 @@ static int em_sti_probe(struct platform_device *pdev)
 	int irq;
 
 	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
-	if (p == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	if (p == NULL)
 		return -ENOMEM;
-	}
 
 	p->pdev = pdev;
 	platform_set_drvdata(pdev, p);
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index e1e58d0..785e3ac 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1159,10 +1159,9 @@ static int omap_aes_probe(struct platform_device *pdev)
 	u32 reg;
 
 	dd = devm_kzalloc(dev, sizeof(struct omap_aes_dev), GFP_KERNEL);
-	if (dd == NULL) {
-		dev_err(dev, "unable to alloc data struct.\n");
+	if (dd == NULL)
 		goto err_data;
-	}
+
 	dd->dev = dev;
 	platform_set_drvdata(pdev, dd);
 
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 8bdde57..f4c2f08 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1894,7 +1894,6 @@ static int omap_sham_probe(struct platform_device *pdev)
 
 	dd = devm_kzalloc(dev, sizeof(struct omap_sham_dev), GFP_KERNEL);
 	if (dd == NULL) {
-		dev_err(dev, "unable to alloc data struct.\n");
 		err = -ENOMEM;
 		goto data_err;
 	}
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index d7bb8ba..f20b39b 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -875,10 +875,8 @@ static int sahara_probe(struct platform_device *pdev)
 	int i;
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(struct sahara_dev), GFP_KERNEL);
-	if (dev == NULL) {
-		dev_err(&pdev->dev, "unable to alloc data struct.\n");
+	if (dev == NULL)
 		return -ENOMEM;
-	}
 
 	dev->device = &pdev->dev;
 	platform_set_drvdata(pdev, dev);
diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index d8c7a13..2fbe6eb 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -876,20 +876,16 @@ static int tegra_aes_probe(struct platform_device *pdev)
 	int err = -ENOMEM, i = 0, j;
 
 	dd = devm_kzalloc(dev, sizeof(struct tegra_aes_dev), GFP_KERNEL);
-	if (dd == NULL) {
-		dev_err(dev, "unable to alloc data struct.\n");
+	if (dd == NULL)
 		return err;
-	}
 
 	dd->dev = dev;
 	platform_set_drvdata(pdev, dd);
 
 	dd->slots = devm_kzalloc(dev, sizeof(struct tegra_aes_slot) *
 				 AES_NR_KEYSLOTS, GFP_KERNEL);
-	if (dd->slots == NULL) {
-		dev_err(dev, "unable to alloc slot struct.\n");
+	if (dd->slots == NULL)
 		goto out;
-	}
 
 	spin_lock_init(&dd->lock);
 	crypto_init_queue(&dd->queue, TEGRA_AES_QUEUE_LENGTH);
diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index c5f86d8..b07ebe0 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -1025,10 +1025,8 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	int err = 0;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(struct busfreq_data), GFP_KERNEL);
-	if (data == NULL) {
-		dev_err(dev, "Cannot allocate memory.\n");
+	if (data == NULL)
 		return -ENOMEM;
-	}
 
 	data->type = pdev->id_entry->driver_data;
 	data->dmc[0].hw_base = S5P_VA_DMC0;
diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
index 574b16b..ae341bb 100644
--- a/drivers/devfreq/exynos/exynos5_bus.c
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -326,10 +326,8 @@ static int exynos5_busfreq_int_probe(struct platform_device *pdev)
 
 	data = devm_kzalloc(&pdev->dev, sizeof(struct busfreq_data_int),
 				GFP_KERNEL);
-	if (data == NULL) {
-		dev_err(dev, "Cannot allocate memory.\n");
+	if (data == NULL)
 		return -ENOMEM;
-	}
 
 	np = of_find_compatible_node(NULL, NULL, "samsung,exynos5250-ppmu");
 	if (np == NULL) {
diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 098a8da..9d120e7 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -632,10 +632,8 @@ static int edma_probe(struct platform_device *pdev)
 	int ret;
 
 	ecc = devm_kzalloc(&pdev->dev, sizeof(*ecc), GFP_KERNEL);
-	if (!ecc) {
-		dev_err(&pdev->dev, "Can't allocate controller\n");
+	if (!ecc)
 		return -ENOMEM;
-	}
 
 	ecc->ctlr = pdev->id;
 	ecc->dummy_slot = edma_alloc_slot(ecc->ctlr, EDMA_SLOT_ANY);
diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 38cb517..bcd1219 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -493,10 +493,9 @@ static int mmp_tdma_chan_init(struct mmp_tdma_device *tdev,
 
 	/* alloc channel */
 	tdmac = devm_kzalloc(tdev->dev, sizeof(*tdmac), GFP_KERNEL);
-	if (!tdmac) {
-		dev_err(tdev->dev, "no free memory for DMA channels!\n");
+	if (!tdmac)
 		return -ENOMEM;
-	}
+
 	if (irq)
 		tdmac->irq = irq;
 	tdmac->dev	   = tdev->dev;
diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 2fe4353..e11f4df 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -645,10 +645,8 @@ static int mpc_dma_probe(struct platform_device *op)
 	int retval, i;
 
 	mdma = devm_kzalloc(dev, sizeof(struct mpc_dma), GFP_KERNEL);
-	if (!mdma) {
-		dev_err(dev, "Memory exhausted!\n");
+	if (!mdma)
 		return -ENOMEM;
-	}
 
 	mdma->irq = irq_of_parse_and_map(dn, 0);
 	if (mdma->irq == NO_IRQ) {
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 58623dc..32938a7 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2905,10 +2905,8 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 
 	/* Allocate a new DMAC and its Channels */
 	pdmac = devm_kzalloc(&adev->dev, sizeof(*pdmac), GFP_KERNEL);
-	if (!pdmac) {
-		dev_err(&adev->dev, "unable to allocate mem\n");
+	if (!pdmac)
 		return -ENOMEM;
-	}
 
 	pi = &pdmac->pif;
 	pi->dev = &adev->dev;
diff --git a/drivers/dma/sh/rcar-hpbdma.c b/drivers/dma/sh/rcar-hpbdma.c
index 45a5202..48aace3 100644
--- a/drivers/dma/sh/rcar-hpbdma.c
+++ b/drivers/dma/sh/rcar-hpbdma.c
@@ -501,11 +501,8 @@ static int hpb_dmae_chan_probe(struct hpb_dmae_device *hpbdev, int id)
 	/* Alloc channel */
 	new_hpb_chan = devm_kzalloc(&pdev->dev,
 				    sizeof(struct hpb_dmae_chan), GFP_KERNEL);
-	if (!new_hpb_chan) {
-		dev_err(hpbdev->shdma_dev.dma_dev.dev,
-			"No free memory for allocating DMA channels!\n");
+	if (!new_hpb_chan)
 		return -ENOMEM;
-	}
 
 	schan = &new_hpb_chan->shdma_chan;
 	shdma_chan_probe(sdev, schan, id);
@@ -543,10 +540,8 @@ static int hpb_dmae_probe(struct platform_device *pdev)
 
 	hpbdev = devm_kzalloc(&pdev->dev, sizeof(struct hpb_dmae_device),
 			      GFP_KERNEL);
-	if (!hpbdev) {
-		dev_err(&pdev->dev, "Not enough memory\n");
+	if (!hpbdev)
 		return -ENOMEM;
-	}
 
 	hpbdev->chan_reg = devm_ioremap_resource(&pdev->dev, chan);
 	if (IS_ERR(hpbdev->chan_reg))
diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 1069e88..20ca30c 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -530,11 +530,8 @@ static int sh_dmae_chan_probe(struct sh_dmae_device *shdev, int id,
 
 	sh_chan = devm_kzalloc(sdev->dma_dev.dev, sizeof(struct sh_dmae_chan),
 			       GFP_KERNEL);
-	if (!sh_chan) {
-		dev_err(sdev->dma_dev.dev,
-			"No free memory for allocating dma channels!\n");
+	if (!sh_chan)
 		return -ENOMEM;
-	}
 
 	schan = &sh_chan->shdma_chan;
 	schan->max_xfer_len = SH_DMA_TCR_MAX + 1;
@@ -727,10 +724,8 @@ static int sh_dmae_probe(struct platform_device *pdev)
 
 	shdev = devm_kzalloc(&pdev->dev, sizeof(struct sh_dmae_device),
 			     GFP_KERNEL);
-	if (!shdev) {
-		dev_err(&pdev->dev, "Not enough memory\n");
+	if (!shdev)
 		return -ENOMEM;
-	}
 
 	dma_dev = &shdev->shdma_dev.dma_dev;
 
diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index c7e9cdf..31a2dba 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -244,11 +244,8 @@ static int sudmac_chan_probe(struct sudmac_device *su_dev, int id, int irq,
 	int err;
 
 	sc = devm_kzalloc(&pdev->dev, sizeof(struct sudmac_chan), GFP_KERNEL);
-	if (!sc) {
-		dev_err(sdev->dma_dev.dev,
-			"No free memory for allocating dma channels!\n");
+	if (!sc)
 		return -ENOMEM;
-	}
 
 	schan = &sc->shdma_chan;
 	schan->max_xfer_len = 64 * 1024 * 1024 - 1;
@@ -350,10 +347,8 @@ static int sudmac_probe(struct platform_device *pdev)
 	err = -ENOMEM;
 	su_dev = devm_kzalloc(&pdev->dev, sizeof(struct sudmac_device),
 			      GFP_KERNEL);
-	if (!su_dev) {
-		dev_err(&pdev->dev, "Not enough memory\n");
+	if (!su_dev)
 		return err;
-	}
 
 	dma_dev = &su_dev->shdma_dev.dma_dev;
 
diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index 6aec3ad..6fc6427 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -653,10 +653,8 @@ static int sirfsoc_dma_probe(struct platform_device *op)
 	int ret, i;
 
 	sdma = devm_kzalloc(dev, sizeof(*sdma), GFP_KERNEL);
-	if (!sdma) {
-		dev_err(dev, "Memory exhausted!\n");
+	if (!sdma)
 		return -ENOMEM;
-	}
 
 	if (of_device_is_compatible(dn, "sirf,marco-dmac"))
 		sdma->is_marco = true;
diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 67a6752..84f4faf 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1262,10 +1262,8 @@ static int tegra_dma_probe(struct platform_device *pdev)
 
 	tdma = devm_kzalloc(&pdev->dev, sizeof(*tdma) + cdata->nr_channels *
 			sizeof(struct tegra_dma_channel), GFP_KERNEL);
-	if (!tdma) {
-		dev_err(&pdev->dev, "Error: memory allocation failed\n");
+	if (!tdma)
 		return -ENOMEM;
-	}
 
 	tdma->dev = &pdev->dev;
 	tdma->chip_data = cdata;
diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 91a702b..8adf89b 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1094,7 +1094,6 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
-		dev_err(&pdev->dev, "Failed to allocate memory\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 5ee0344..be941e0 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1099,10 +1099,9 @@ static int max77693_muic_probe(struct platform_device *pdev)
 
 	info = devm_kzalloc(&pdev->dev, sizeof(struct max77693_muic_info),
 				   GFP_KERNEL);
-	if (!info) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!info)
 		return -ENOMEM;
-	}
+
 	info->dev = &pdev->dev;
 	info->max77693 = max77693;
 	if (info->max77693->regmap_muic) {
@@ -1178,7 +1177,6 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
 				  GFP_KERNEL);
 	if (!info->edev) {
-		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		ret = -ENOMEM;
 		goto err_irq;
 	}
diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index b9e726d..2520e3d 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -661,10 +661,8 @@ static int max8997_muic_probe(struct platform_device *pdev)
 
 	info = devm_kzalloc(&pdev->dev, sizeof(struct max8997_muic_info),
 			    GFP_KERNEL);
-	if (!info) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!info)
 		return -ENOMEM;
-	}
 
 	info->dev = &pdev->dev;
 	info->muic = max8997->muic;
@@ -702,7 +700,6 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
 				  GFP_KERNEL);
 	if (!info->edev) {
-		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		ret = -ENOMEM;
 		goto err_irq;
 	}
diff --git a/drivers/gpio/gpio-adp5520.c b/drivers/gpio/gpio-adp5520.c
index 084337d..c025b6c 100644
--- a/drivers/gpio/gpio-adp5520.c
+++ b/drivers/gpio/gpio-adp5520.c
@@ -106,10 +106,8 @@ static int adp5520_gpio_probe(struct platform_device *pdev)
 	}
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
-		dev_err(&pdev->dev, "failed to alloc memory\n");
+	if (dev == NULL)
 		return -ENOMEM;
-	}
 
 	dev->master = pdev->dev.parent;
 
diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
index 160d759..5fc4433 100644
--- a/drivers/gpio/gpio-em.c
+++ b/drivers/gpio/gpio-em.c
@@ -263,7 +263,6 @@ static int em_gio_probe(struct platform_device *pdev)
 
 	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
 	if (!p) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		ret = -ENOMEM;
 		goto err0;
 	}
diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index bfa1af1..53456b9 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -337,10 +337,8 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 	pcim_iounmap_regions(pdev, 1 << 1);
 
 	lnw = devm_kzalloc(&pdev->dev, sizeof(*lnw), GFP_KERNEL);
-	if (!lnw) {
-		dev_err(&pdev->dev, "can't allocate chip data\n");
+	if (!lnw)
 		return -ENOMEM;
-	}
 
 	lnw->reg_base = pcim_iomap_table(pdev)[0];
 	lnw->chip.label = dev_name(&pdev->dev);
diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
index 2d9ca60..6915677 100644
--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -352,10 +352,8 @@ static int lp_gpio_probe(struct platform_device *pdev)
 	int ret = -ENODEV;
 
 	lg = devm_kzalloc(dev, sizeof(struct lp_gpio), GFP_KERNEL);
-	if (!lg) {
-		dev_err(dev, "can't allocate lp_gpio chip data\n");
+	if (!lg)
 		return -ENOMEM;
-	}
 
 	lg->pdev = pdev;
 	platform_set_drvdata(pdev, lg);
diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 3c3321f..3902a91 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -567,10 +567,8 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 		soc_variant = MVEBU_GPIO_SOC_VARIANT_ORION;
 
 	mvchip = devm_kzalloc(&pdev->dev, sizeof(struct mvebu_gpio_chip), GFP_KERNEL);
-	if (!mvchip) {
-		dev_err(&pdev->dev, "Cannot allocate memory\n");
+	if (!mvchip)
 		return -ENOMEM;
-	}
 
 	if (of_property_read_u32(pdev->dev.of_node, "ngpios", &ngpios)) {
 		dev_err(&pdev->dev, "Missing ngpios OF property\n");
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 0ff4355..1ab10d5 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1105,10 +1105,8 @@ static int omap_gpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	bank = devm_kzalloc(dev, sizeof(struct gpio_bank), GFP_KERNEL);
-	if (!bank) {
-		dev_err(dev, "Memory alloc failed\n");
+	if (!bank)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (unlikely(!res)) {
diff --git a/drivers/gpio/gpio-palmas.c b/drivers/gpio/gpio-palmas.c
index 11801e98..46a4bc9 100644
--- a/drivers/gpio/gpio-palmas.c
+++ b/drivers/gpio/gpio-palmas.c
@@ -173,10 +173,8 @@ static int palmas_gpio_probe(struct platform_device *pdev)
 
 	palmas_gpio = devm_kzalloc(&pdev->dev,
 				sizeof(*palmas_gpio), GFP_KERNEL);
-	if (!palmas_gpio) {
-		dev_err(&pdev->dev, "Could not allocate palmas_gpio\n");
+	if (!palmas_gpio)
 		return -ENOMEM;
-	}
 
 	palmas_gpio->palmas = palmas;
 	palmas_gpio->gpio_chip.owner = THIS_MODULE;
diff --git a/drivers/gpio/gpio-rc5t583.c b/drivers/gpio/gpio-rc5t583.c
index e63d6a3..a998c61 100644
--- a/drivers/gpio/gpio-rc5t583.c
+++ b/drivers/gpio/gpio-rc5t583.c
@@ -119,10 +119,8 @@ static int rc5t583_gpio_probe(struct platform_device *pdev)
 
 	rc5t583_gpio = devm_kzalloc(&pdev->dev, sizeof(*rc5t583_gpio),
 					GFP_KERNEL);
-	if (!rc5t583_gpio) {
-		dev_warn(&pdev->dev, "Mem allocation for rc5t583_gpio failed");
+	if (!rc5t583_gpio)
 		return -ENOMEM;
-	}
 
 	rc5t583_gpio->gpio_chip.label = "gpio-rc5t583",
 	rc5t583_gpio->gpio_chip.owner = THIS_MODULE,
diff --git a/drivers/gpio/gpio-rcar.c b/drivers/gpio/gpio-rcar.c
index 6038966..22d3739 100644
--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -320,7 +320,6 @@ static int gpio_rcar_probe(struct platform_device *pdev)
 
 	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
 	if (!p) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		ret = -ENOMEM;
 		goto err0;
 	}
diff --git a/drivers/gpio/gpio-spear-spics.c b/drivers/gpio/gpio-spear-spics.c
index e9a0415..51564df 100644
--- a/drivers/gpio/gpio-spear-spics.c
+++ b/drivers/gpio/gpio-spear-spics.c
@@ -129,10 +129,8 @@ static int spics_gpio_probe(struct platform_device *pdev)
 	int ret;
 
 	spics = devm_kzalloc(&pdev->dev, sizeof(*spics), GFP_KERNEL);
-	if (!spics) {
-		dev_err(&pdev->dev, "memory allocation fail\n");
+	if (!spics)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	spics->base = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 9a62672..3777f12 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -439,10 +439,8 @@ static int tegra_gpio_probe(struct platform_device *pdev)
 	tegra_gpio_banks = devm_kzalloc(&pdev->dev,
 			tegra_gpio_bank_count * sizeof(*tegra_gpio_banks),
 			GFP_KERNEL);
-	if (!tegra_gpio_banks) {
-		dev_err(&pdev->dev, "Couldn't allocate bank structure\n");
+	if (!tegra_gpio_banks)
 		return -ENODEV;
-	}
 
 	irq_domain = irq_domain_add_linear(pdev->dev.of_node,
 					   tegra_gpio_chip.ngpio,
diff --git a/drivers/gpio/gpio-tps6586x.c b/drivers/gpio/gpio-tps6586x.c
index 29e8e75..c1a6918 100644
--- a/drivers/gpio/gpio-tps6586x.c
+++ b/drivers/gpio/gpio-tps6586x.c
@@ -97,10 +97,8 @@ static int tps6586x_gpio_probe(struct platform_device *pdev)
 	pdata = dev_get_platdata(pdev->dev.parent);
 	tps6586x_gpio = devm_kzalloc(&pdev->dev,
 				sizeof(*tps6586x_gpio), GFP_KERNEL);
-	if (!tps6586x_gpio) {
-		dev_err(&pdev->dev, "Could not allocate tps6586x_gpio\n");
+	if (!tps6586x_gpio)
 		return -ENOMEM;
-	}
 
 	tps6586x_gpio->parent = pdev->dev.parent;
 
diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
index 0614621..377ada4 100644
--- a/drivers/gpio/gpio-tps65910.c
+++ b/drivers/gpio/gpio-tps65910.c
@@ -123,10 +123,8 @@ static int tps65910_gpio_probe(struct platform_device *pdev)
 
 	tps65910_gpio = devm_kzalloc(&pdev->dev,
 				sizeof(*tps65910_gpio), GFP_KERNEL);
-	if (!tps65910_gpio) {
-		dev_err(&pdev->dev, "Could not allocate tps65910_gpio\n");
+	if (!tps65910_gpio)
 		return -ENOMEM;
-	}
 
 	tps65910_gpio->tps65910 = tps65910;
 
diff --git a/drivers/gpio/gpio-tz1090-pdc.c b/drivers/gpio/gpio-tz1090-pdc.c
index f512da2..10112dd 100644
--- a/drivers/gpio/gpio-tz1090-pdc.c
+++ b/drivers/gpio/gpio-tz1090-pdc.c
@@ -183,10 +183,8 @@ static int tz1090_pdc_gpio_probe(struct platform_device *pdev)
 	}
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "unable to allocate driver data\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	/* Ioremap the registers */
 	priv->reg = devm_ioremap(&pdev->dev, res_regs->start,
diff --git a/drivers/gpio/gpio-tz1090.c b/drivers/gpio/gpio-tz1090.c
index 23e0613..a7ccc47 100644
--- a/drivers/gpio/gpio-tz1090.c
+++ b/drivers/gpio/gpio-tz1090.c
@@ -413,10 +413,8 @@ static int tz1090_gpio_bank_probe(struct tz1090_gpio_bank_info *info)
 	int err;
 
 	bank = devm_kzalloc(dev, sizeof(*bank), GFP_KERNEL);
-	if (!bank) {
-		dev_err(dev, "unable to allocate driver data\n");
+	if (!bank)
 		return -ENOMEM;
-	}
 
 	/* Offset the main registers to the first register in this bank */
 	bank->reg = info->priv->reg + info->index * 4;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index 0023f97..95b634e 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -64,10 +64,8 @@ static int rcar_du_load(struct drm_device *dev, unsigned long flags)
 	}
 
 	rcdu = devm_kzalloc(&pdev->dev, sizeof(*rcdu), GFP_KERNEL);
-	if (rcdu == NULL) {
-		dev_err(dev->dev, "failed to allocate private data\n");
+	if (rcdu == NULL)
 		return -ENOMEM;
-	}
 
 	rcdu->dev = &pdev->dev;
 	rcdu->pdata = pdata;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
index a0f6a17..74b26f5 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
@@ -175,10 +175,8 @@ int rcar_du_lvdsenc_init(struct rcar_du_device *rcdu)
 
 	for (i = 0; i < rcdu->info->num_lvds; ++i) {
 		lvds = devm_kzalloc(&pdev->dev, sizeof(*lvds), GFP_KERNEL);
-		if (lvds == NULL) {
-			dev_err(&pdev->dev, "failed to allocate private data\n");
+		if (lvds == NULL)
 			return -ENOMEM;
-		}
 
 		lvds->dev = rcdu;
 		lvds->index = i;
diff --git a/drivers/gpu/drm/shmobile/shmob_drm_drv.c b/drivers/gpu/drm/shmobile/shmob_drm_drv.c
index 0155518..7296f4e 100644
--- a/drivers/gpu/drm/shmobile/shmob_drm_drv.c
+++ b/drivers/gpu/drm/shmobile/shmob_drm_drv.c
@@ -131,10 +131,8 @@ static int shmob_drm_load(struct drm_device *dev, unsigned long flags)
 	}
 
 	sdev = devm_kzalloc(&pdev->dev, sizeof(*sdev), GFP_KERNEL);
-	if (sdev == NULL) {
-		dev_err(dev->dev, "failed to allocate private data\n");
+	if (sdev == NULL)
 		return -ENOMEM;
-	}
 
 	sdev->dev = &pdev->dev;
 	sdev->pdata = pdata;
diff --git a/drivers/hid/hid-a4tech.c b/drivers/hid/hid-a4tech.c
index 9428ea7..6b583bd 100644
--- a/drivers/hid/hid-a4tech.c
+++ b/drivers/hid/hid-a4tech.c
@@ -91,10 +91,8 @@ static int a4_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	int ret;
 
 	a4 = devm_kzalloc(&hdev->dev, sizeof(*a4), GFP_KERNEL);
-	if (a4 == NULL) {
-		hid_err(hdev, "can't alloc device descriptor\n");
+	if (a4 == NULL)
 		return -ENOMEM;
-	}
 
 	a4->quirks = id->driver_data;
 
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 881cf7b..2700a27 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -350,10 +350,8 @@ static int apple_probe(struct hid_device *hdev,
 	int ret;
 
 	asc = devm_kzalloc(&hdev->dev, sizeof(*asc), GFP_KERNEL);
-	if (asc == NULL) {
-		hid_err(hdev, "can't alloc apple descriptor\n");
+	if (asc == NULL)
 		return -ENOMEM;
-	}
 
 	asc->quirks = quirks;
 
diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
index 2d25b6c..41c146e 100644
--- a/drivers/hid/hid-lenovo-tpkbd.c
+++ b/drivers/hid/hid-lenovo-tpkbd.c
@@ -354,10 +354,8 @@ static int tpkbd_probe_tp(struct hid_device *hdev)
 	data_pointer = devm_kzalloc(&hdev->dev,
 				    sizeof(struct tpkbd_data_pointer),
 				    GFP_KERNEL);
-	if (data_pointer == NULL) {
-		hid_err(hdev, "Could not allocate memory for driver data\n");
+	if (data_pointer == NULL)
 		return -ENOMEM;
-	}
 
 	// set same default values as windows driver
 	data_pointer->sensitivity = 0xa0;
@@ -365,10 +363,9 @@ static int tpkbd_probe_tp(struct hid_device *hdev)
 
 	name_mute = devm_kzalloc(&hdev->dev, name_sz, GFP_KERNEL);
 	name_micmute = devm_kzalloc(&hdev->dev, name_sz, GFP_KERNEL);
-	if (name_mute == NULL || name_micmute == NULL) {
-		hid_err(hdev, "Could not allocate memory for led data\n");
+	if (name_mute == NULL || name_micmute == NULL)
 		return -ENOMEM;
-	}
+
 	snprintf(name_mute, name_sz, "%s:amber:mute", dev_name(dev));
 	snprintf(name_micmute, name_sz, "%s:amber:micmute", dev_name(dev));
 
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 3b43d1c..8fdefed 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -485,10 +485,8 @@ static int magicmouse_probe(struct hid_device *hdev,
 	int ret;
 
 	msc = devm_kzalloc(&hdev->dev, sizeof(*msc), GFP_KERNEL);
-	if (msc == NULL) {
-		hid_err(hdev, "can't alloc magicmouse descriptor\n");
+	if (msc == NULL)
 		return -ENOMEM;
-	}
 
 	msc->scroll_accel = SCROLL_ACCEL_DEFAULT;
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 5e5fe1b..5a4af45 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -966,10 +966,9 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		hdev->quirks |= HID_QUIRK_NO_INIT_INPUT_REPORTS;
 
 	td = devm_kzalloc(&hdev->dev, sizeof(struct mt_device), GFP_KERNEL);
-	if (!td) {
-		dev_err(&hdev->dev, "cannot allocate multitouch data\n");
+	if (!td)
 		return -ENOMEM;
-	}
+
 	td->mtclass = *mtclass;
 	td->inputmode = -1;
 	td->maxcontact_report_id = -1;
@@ -980,10 +979,8 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	td->fields = devm_kzalloc(&hdev->dev, sizeof(struct mt_fields),
 				  GFP_KERNEL);
-	if (!td->fields) {
-		dev_err(&hdev->dev, "cannot allocate multitouch fields data\n");
+	if (!td->fields)
 		return -ENOMEM;
-	}
 
 	if (id->vendor == HID_ANY_ID && id->product == HID_ANY_ID)
 		td->serial_maybe = true;
diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index 10e1581..ebc2ef1 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -478,15 +478,13 @@ static int sensor_hub_probe(struct hid_device *hdev,
 	int dev_cnt;
 
 	sd = devm_kzalloc(&hdev->dev, sizeof(*sd), GFP_KERNEL);
-	if (!sd) {
-		hid_err(hdev, "cannot allocate Sensor data\n");
+	if (!sd)
 		return -ENOMEM;
-	}
+
 	sd->hsdev = devm_kzalloc(&hdev->dev, sizeof(*sd->hsdev), GFP_KERNEL);
-	if (!sd->hsdev) {
-		hid_err(hdev, "cannot allocate hid_sensor_hub_device\n");
+	if (!sd->hsdev)
 		return -ENOMEM;
-	}
+
 	hid_set_drvdata(hdev, sd);
 	sd->hsdev->hdev = hdev;
 	sd->hsdev->vendor_id = hdev->vendor;
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index bc37a18..eb35ad9 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -622,10 +622,8 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 
 	sc = devm_kzalloc(&hdev->dev, sizeof(*sc), GFP_KERNEL);
-	if (sc == NULL) {
-		hid_err(hdev, "can't alloc sony descriptor\n");
+	if (sc == NULL)
 		return -ENOMEM;
-	}
 
 	sc->quirks = quirks;
 	hid_set_drvdata(hdev, sc);
diff --git a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
index 1a660bd..89810ae 100644
--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -170,10 +170,8 @@ static int zc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	struct zc_device *zc;
 
 	zc = devm_kzalloc(&hdev->dev, sizeof(*zc), GFP_KERNEL);
-	if (zc == NULL) {
-		hid_err(hdev, "can't alloc descriptor\n");
+	if (zc == NULL)
 		return -ENOMEM;
-	}
 
 	hid_set_drvdata(hdev, zc);
 
diff --git a/drivers/hwmon/f71805f.c b/drivers/hwmon/f71805f.c
index 15b7f52..952dff2 100644
--- a/drivers/hwmon/f71805f.c
+++ b/drivers/hwmon/f71805f.c
@@ -1387,10 +1387,8 @@ static int f71805f_probe(struct platform_device *pdev)
 
 	data = devm_kzalloc(&pdev->dev, sizeof(struct f71805f_data),
 			    GFP_KERNEL);
-	if (!data) {
-		pr_err("Out of memory\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (!devm_request_region(&pdev->dev, res->start + ADDR_REG_OFFSET, 2,
diff --git a/drivers/hwmon/lm93.c b/drivers/hwmon/lm93.c
index a6f4605..ec6800e 100644
--- a/drivers/hwmon/lm93.c
+++ b/drivers/hwmon/lm93.c
@@ -2747,10 +2747,9 @@ static int lm93_probe(struct i2c_client *client,
 	}
 
 	data = devm_kzalloc(&client->dev, sizeof(struct lm93_data), GFP_KERNEL);
-	if (!data) {
-		dev_dbg(&client->dev, "out of memory!\n");
+	if (!data)
 		return -ENOMEM;
-	}
+
 	i2c_set_clientdata(client, data);
 
 	/* housekeeping */
diff --git a/drivers/hwmon/max1111.c b/drivers/hwmon/max1111.c
index eda077d..f67d71e 100644
--- a/drivers/hwmon/max1111.c
+++ b/drivers/hwmon/max1111.c
@@ -192,10 +192,8 @@ static int max1111_probe(struct spi_device *spi)
 		return err;
 
 	data = devm_kzalloc(&spi->dev, sizeof(struct max1111_data), GFP_KERNEL);
-	if (data == NULL) {
-		dev_err(&spi->dev, "failed to allocate memory\n");
+	if (data == NULL)
 		return -ENOMEM;
-	}
 
 	switch (chip) {
 	case max1110:
diff --git a/drivers/hwmon/max197.c b/drivers/hwmon/max197.c
index 96dccaf..82128ad 100644
--- a/drivers/hwmon/max197.c
+++ b/drivers/hwmon/max197.c
@@ -275,10 +275,8 @@ static int max197_probe(struct platform_device *pdev)
 	}
 
 	data = devm_kzalloc(&pdev->dev, sizeof(struct max197_data), GFP_KERNEL);
-	if (!data) {
-		dev_err(&pdev->dev, "devm_kzalloc failed\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	data->pdata = pdata;
 	mutex_init(&data->lock);
diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
index 3c16cbd..31df4ca 100644
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -547,10 +547,8 @@ static int max6650_probe(struct i2c_client *client,
 
 	data = devm_kzalloc(&client->dev, sizeof(struct max6650_data),
 			    GFP_KERNEL);
-	if (!data) {
-		dev_err(&client->dev, "out of memory.\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(client, data);
 	mutex_init(&data->update_lock);
diff --git a/drivers/hwmon/pc87427.c b/drivers/hwmon/pc87427.c
index 6e6ea44..60e5f60 100644
--- a/drivers/hwmon/pc87427.c
+++ b/drivers/hwmon/pc87427.c
@@ -1081,10 +1081,8 @@ static int pc87427_probe(struct platform_device *pdev)
 
 	data = devm_kzalloc(&pdev->dev, sizeof(struct pc87427_data),
 			    GFP_KERNEL);
-	if (!data) {
-		pr_err("Out of memory\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	data->address[0] = sio_data->address[0];
 	data->address[1] = sio_data->address[1];
diff --git a/drivers/hwmon/s3c-hwmon.c b/drivers/hwmon/s3c-hwmon.c
index 73bd64e..0674c13 100644
--- a/drivers/hwmon/s3c-hwmon.c
+++ b/drivers/hwmon/s3c-hwmon.c
@@ -285,10 +285,8 @@ static int s3c_hwmon_probe(struct platform_device *dev)
 	}
 
 	hwmon = devm_kzalloc(&dev->dev, sizeof(struct s3c_hwmon), GFP_KERNEL);
-	if (hwmon == NULL) {
-		dev_err(&dev->dev, "no memory\n");
+	if (hwmon == NULL)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(dev, hwmon);
 
diff --git a/drivers/hwmon/vt1211.c b/drivers/hwmon/vt1211.c
index 6b2f1a4..344b22e 100644
--- a/drivers/hwmon/vt1211.c
+++ b/drivers/hwmon/vt1211.c
@@ -1152,10 +1152,8 @@ static int vt1211_probe(struct platform_device *pdev)
 	int i, err;
 
 	data = devm_kzalloc(dev, sizeof(struct vt1211_data), GFP_KERNEL);
-	if (!data) {
-		dev_err(dev, "Out of memory\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (!devm_request_region(dev, res->start, resource_size(res),
diff --git a/drivers/i2c/busses/i2c-bcm2835.c b/drivers/i2c/busses/i2c-bcm2835.c
index ea4b08f..e834890 100644
--- a/drivers/i2c/busses/i2c-bcm2835.c
+++ b/drivers/i2c/busses/i2c-bcm2835.c
@@ -225,10 +225,9 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
 	struct i2c_adapter *adap;
 
 	i2c_dev = devm_kzalloc(&pdev->dev, sizeof(*i2c_dev), GFP_KERNEL);
-	if (!i2c_dev) {
-		dev_err(&pdev->dev, "Cannot allocate i2c_dev\n");
+	if (!i2c_dev)
 		return -ENOMEM;
-	}
+
 	platform_set_drvdata(pdev, i2c_dev);
 	i2c_dev->dev = &pdev->dev;
 	init_completion(&i2c_dev->completion);
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 132369f..68c19f9 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -651,10 +651,8 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(struct davinci_i2c_dev),
 			GFP_KERNEL);
-	if (!dev) {
-		dev_err(&pdev->dev, "Memory allocation failed\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	init_completion(&dev->cmd_complete);
 #ifdef CONFIG_CPU_FREQ
diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index ccf4665..7acec52 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -615,10 +615,8 @@ static int __init i2c_imx_probe(struct platform_device *pdev)
 
 	i2c_imx = devm_kzalloc(&pdev->dev, sizeof(struct imx_i2c_struct),
 				GFP_KERNEL);
-	if (!i2c_imx) {
-		dev_err(&pdev->dev, "can't allocate interface\n");
+	if (!i2c_imx)
 		return -ENOMEM;
-	}
 
 	if (of_id)
 		i2c_imx->hwdata = of_id->data;
diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
index b929ba2..837121d 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -522,7 +522,6 @@ static int octeon_i2c_probe(struct platform_device *pdev)
 
 	i2c = devm_kzalloc(&pdev->dev, sizeof(*i2c), GFP_KERNEL);
 	if (!i2c) {
-		dev_err(&pdev->dev, "kzalloc failed\n");
 		result = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 6d8308d..fa2cf0a 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1089,10 +1089,8 @@ omap_i2c_probe(struct platform_device *pdev)
 	}
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(struct omap_i2c_dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&pdev->dev, "Menory allocation failed\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dev->base = devm_ioremap_resource(&pdev->dev, mem);
diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index d2fe11d..f50ff29 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -643,10 +643,8 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(struct rcar_i2c_priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(dev, "no mem for private data\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	bus_speed = 100000; /* default 100 kHz */
 	if (pdata && pdata->bus_speed)
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 3535f3c..60dc2c8 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1040,16 +1040,12 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	}
 
 	i2c = devm_kzalloc(&pdev->dev, sizeof(struct s3c24xx_i2c), GFP_KERNEL);
-	if (!i2c) {
-		dev_err(&pdev->dev, "no memory for state\n");
+	if (!i2c)
 		return -ENOMEM;
-	}
 
 	i2c->pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!i2c->pdata) {
-		dev_err(&pdev->dev, "no memory for platform data\n");
+	if (!i2c->pdata)
 		return -ENOMEM;
-	}
 
 	i2c->quirks = s3c24xx_get_device_quirks(pdev);
 	if (pdata)
diff --git a/drivers/i2c/busses/i2c-sirf.c b/drivers/i2c/busses/i2c-sirf.c
index 6784f7f..02556c0 100644
--- a/drivers/i2c/busses/i2c-sirf.c
+++ b/drivers/i2c/busses/i2c-sirf.c
@@ -307,7 +307,6 @@ static int i2c_sirfsoc_probe(struct platform_device *pdev)
 
 	siic = devm_kzalloc(&pdev->dev, sizeof(*siic), GFP_KERNEL);
 	if (!siic) {
-		dev_err(&pdev->dev, "Can't allocate driver data\n");
 		err = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
index f8f6f2e..4a4983d 100644
--- a/drivers/i2c/busses/i2c-stu300.c
+++ b/drivers/i2c/busses/i2c-stu300.c
@@ -869,10 +869,8 @@ stu300_probe(struct platform_device *pdev)
 	int ret = 0;
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(struct stu300_dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&pdev->dev, "could not allocate device struct\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	bus_nr = pdev->id;
 	dev->clk = devm_clk_get(&pdev->dev, NULL);
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index c457cb4..3fcb78b 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -731,10 +731,8 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	}
 
 	i2c_dev = devm_kzalloc(&pdev->dev, sizeof(*i2c_dev), GFP_KERNEL);
-	if (!i2c_dev) {
-		dev_err(&pdev->dev, "Could not allocate struct tegra_i2c_dev");
+	if (!i2c_dev)
 		return -ENOMEM;
-	}
 
 	i2c_dev->base = base;
 	i2c_dev->div_clk = div_clk;
diff --git a/drivers/i2c/busses/i2c-wmt.c b/drivers/i2c/busses/i2c-wmt.c
index c65da3d..0d80da2 100644
--- a/drivers/i2c/busses/i2c-wmt.c
+++ b/drivers/i2c/busses/i2c-wmt.c
@@ -378,10 +378,8 @@ static int wmt_i2c_probe(struct platform_device *pdev)
 	u32 clk_rate;
 
 	i2c_dev = devm_kzalloc(&pdev->dev, sizeof(*i2c_dev), GFP_KERNEL);
-	if (!i2c_dev) {
-		dev_err(&pdev->dev, "device memory allocation failed\n");
+	if (!i2c_dev)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	i2c_dev->base = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
index 74b41ae..556a9f4 100644
--- a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
+++ b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
@@ -136,10 +136,9 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
 	}
 
 	arb = devm_kzalloc(dev, sizeof(*arb), GFP_KERNEL);
-	if (!arb) {
-		dev_err(dev, "Cannot allocate i2c_arbitrator_data\n");
+	if (!arb)
 		return -ENOMEM;
-	}
+
 	platform_set_drvdata(pdev, arb);
 
 	/* Request GPIOs */
diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index 5d4a99b..62456b4 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -89,10 +89,8 @@ static int i2c_mux_gpio_probe_dt(struct gpiomux *mux,
 	values = devm_kzalloc(&pdev->dev,
 			      sizeof(*mux->data.values) * mux->data.n_values,
 			      GFP_KERNEL);
-	if (!values) {
-		dev_err(&pdev->dev, "Cannot allocate values array");
+	if (!values)
 		return -ENOMEM;
-	}
 
 	for_each_child_of_node(np, child) {
 		of_property_read_u32(child, "reg", values + i);
@@ -111,10 +109,8 @@ static int i2c_mux_gpio_probe_dt(struct gpiomux *mux,
 
 	gpios = devm_kzalloc(&pdev->dev,
 			     sizeof(*mux->data.gpios) * mux->data.n_gpios, GFP_KERNEL);
-	if (!gpios) {
-		dev_err(&pdev->dev, "Cannot allocate gpios array");
+	if (!gpios)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < mux->data.n_gpios; i++)
 		gpios[i] = of_get_named_gpio(np, "mux-gpios", i);
@@ -140,10 +136,8 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 	int i, ret;
 
 	mux = devm_kzalloc(&pdev->dev, sizeof(*mux), GFP_KERNEL);
-	if (!mux) {
-		dev_err(&pdev->dev, "Cannot allocate gpiomux structure");
+	if (!mux)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(pdev, mux);
 
@@ -187,7 +181,6 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 				 sizeof(*mux->adap) * mux->data.n_values,
 				 GFP_KERNEL);
 	if (!mux->adap) {
-		dev_err(&pdev->dev, "Cannot allocate i2c_adapter structure");
 		ret = -ENOMEM;
 		goto alloc_failed;
 	}
diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index 69a9173..04d08d8 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -64,11 +64,8 @@ static int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
 		return 0;
 
 	mux->pdata = devm_kzalloc(&pdev->dev, sizeof(*mux->pdata), GFP_KERNEL);
-	if (!mux->pdata) {
-		dev_err(mux->dev,
-			"Cannot allocate i2c_mux_pinctrl_platform_data\n");
+	if (!mux->pdata)
 		return -ENOMEM;
-	}
 
 	num_names = of_property_count_strings(np, "pinctrl-names");
 	if (num_names < 0) {
@@ -80,10 +77,8 @@ static int i2c_mux_pinctrl_parse_dt(struct i2c_mux_pinctrl *mux,
 	mux->pdata->pinctrl_states = devm_kzalloc(&pdev->dev,
 		sizeof(*mux->pdata->pinctrl_states) * num_names,
 		GFP_KERNEL);
-	if (!mux->pdata->pinctrl_states) {
-		dev_err(mux->dev, "Cannot allocate pinctrl_states\n");
+	if (!mux->pdata->pinctrl_states)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < num_names; i++) {
 		ret = of_property_read_string_index(np, "pinctrl-names", i,
@@ -136,7 +131,6 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 
 	mux = devm_kzalloc(&pdev->dev, sizeof(*mux), GFP_KERNEL);
 	if (!mux) {
-		dev_err(&pdev->dev, "Cannot allocate i2c_mux_pinctrl\n");
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -160,7 +154,6 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 				   sizeof(*mux->states) * mux->pdata->bus_count,
 				   GFP_KERNEL);
 	if (!mux->states) {
-		dev_err(&pdev->dev, "Cannot allocate states\n");
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -169,7 +162,6 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
 				   sizeof(*mux->busses) * mux->pdata->bus_count,
 				   GFP_KERNEL);
 	if (!mux->busses) {
-		dev_err(&pdev->dev, "Cannot allocate busses\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index 7812194..a48037b 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -491,7 +491,6 @@ static int at91_adc_probe_dt(struct at91_adc_state *st,
 					sizeof(struct at91_adc_trigger),
 					GFP_KERNEL);
 	if (!st->trigger_list) {
-		dev_err(&idev->dev, "Could not allocate trigger list memory.\n");
 		ret = -ENOMEM;
 		goto error_ret;
 	}
diff --git a/drivers/iio/frequency/adf4350.c b/drivers/iio/frequency/adf4350.c
index 85152547..5836e06 100644
--- a/drivers/iio/frequency/adf4350.c
+++ b/drivers/iio/frequency/adf4350.c
@@ -387,10 +387,8 @@ static struct adf4350_platform_data *adf4350_parse_dt(struct device *dev)
 	int ret;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "could not allocate memory for platform data\n");
+	if (!pdata)
 		return NULL;
-	}
 
 	strncpy(&pdata->name[0], np->name, SPI_NAME_SIZE - 1);
 
diff --git a/drivers/input/keyboard/imx_keypad.c b/drivers/input/keyboard/imx_keypad.c
index 328cfc1..f17d5a3 100644
--- a/drivers/input/keyboard/imx_keypad.c
+++ b/drivers/input/keyboard/imx_keypad.c
@@ -450,10 +450,8 @@ static int imx_keypad_probe(struct platform_device *pdev)
 
 	keypad = devm_kzalloc(&pdev->dev, sizeof(struct imx_keypad),
 			     GFP_KERNEL);
-	if (!keypad) {
-		dev_err(&pdev->dev, "not enough memory for driver data\n");
+	if (!keypad)
 		return -ENOMEM;
-	}
 
 	keypad->input_dev = input_dev;
 	keypad->irq = irq;
diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 90ff73a..cb9ef49 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -411,10 +411,8 @@ matrix_keypad_parse_dt(struct device *dev)
 	}
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "could not allocate memory for platform data\n");
+	if (!pdata)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	pdata->num_row_gpios = nrow = of_gpio_named_count(np, "row-gpios");
 	pdata->num_col_gpios = ncol = of_gpio_named_count(np, "col-gpios");
@@ -438,10 +436,8 @@ matrix_keypad_parse_dt(struct device *dev)
 			     sizeof(unsigned int) *
 				(pdata->num_row_gpios + pdata->num_col_gpios),
 			     GFP_KERNEL);
-	if (!gpios) {
-		dev_err(dev, "could not allocate memory for gpios\n");
+	if (!gpios)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	for (i = 0; i < pdata->num_row_gpios; i++)
 		gpios[i] = of_get_named_gpio(np, "row-gpios", i);
diff --git a/drivers/input/keyboard/nspire-keypad.c b/drivers/input/keyboard/nspire-keypad.c
index b3e3eda..2f9ed07 100644
--- a/drivers/input/keyboard/nspire-keypad.c
+++ b/drivers/input/keyboard/nspire-keypad.c
@@ -173,10 +173,8 @@ static int nspire_keypad_probe(struct platform_device *pdev)
 
 	keypad = devm_kzalloc(&pdev->dev, sizeof(struct nspire_keypad),
 			      GFP_KERNEL);
-	if (!keypad) {
-		dev_err(&pdev->dev, "failed to allocate keypad memory\n");
+	if (!keypad)
 		return -ENOMEM;
-	}
 
 	keypad->row_shift = get_count_order(KEYPAD_BITMASK_COLS);
 
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index a2e758d..d056164 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -291,10 +291,8 @@ static int pxa27x_keypad_build_keycode_from_dt(struct pxa27x_keypad *keypad)
 	int error;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "failed to allocate memory for pdata\n");
+	if (!pdata)
 		return -ENOMEM;
-	}
 
 	error = pxa27x_keypad_matrix_key_parse_dt(keypad, pdata);
 	if (error) {
diff --git a/drivers/input/keyboard/samsung-keypad.c b/drivers/input/keyboard/samsung-keypad.c
index ac43a48..b648ecd 100644
--- a/drivers/input/keyboard/samsung-keypad.c
+++ b/drivers/input/keyboard/samsung-keypad.c
@@ -254,10 +254,8 @@ static struct samsung_keypad_platdata *samsung_keypad_parse_dt(
 	unsigned int key_count;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "could not allocate memory for platform data\n");
+	if (!pdata)
 		return NULL;
-	}
 
 	of_property_read_u32(np, "samsung,keypad-num-rows", &num_rows);
 	of_property_read_u32(np, "samsung,keypad-num-columns", &num_cols);
@@ -269,19 +267,17 @@ static struct samsung_keypad_platdata *samsung_keypad_parse_dt(
 	pdata->cols = num_cols;
 
 	keymap_data = devm_kzalloc(dev, sizeof(*keymap_data), GFP_KERNEL);
-	if (!keymap_data) {
-		dev_err(dev, "could not allocate memory for keymap data\n");
+	if (!keymap_data)
 		return NULL;
-	}
+
 	pdata->keymap_data = keymap_data;
 
 	key_count = of_get_child_count(np);
 	keymap_data->keymap_size = key_count;
 	keymap = devm_kzalloc(dev, sizeof(uint32_t) * key_count, GFP_KERNEL);
-	if (!keymap) {
-		dev_err(dev, "could not allocate memory for keymap\n");
+	if (!keymap)
 		return NULL;
-	}
+
 	keymap_data->keymap = keymap;
 
 	for_each_child_of_node(np, key_np) {
diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
index 85ff530..9917f67 100644
--- a/drivers/input/keyboard/spear-keyboard.c
+++ b/drivers/input/keyboard/spear-keyboard.c
@@ -198,10 +198,8 @@ static int spear_kbd_probe(struct platform_device *pdev)
 	}
 
 	kbd = devm_kzalloc(&pdev->dev, sizeof(*kbd), GFP_KERNEL);
-	if (!kbd) {
-		dev_err(&pdev->dev, "not enough memory for driver data\n");
+	if (!kbd)
 		return -ENOMEM;
-	}
 
 	input_dev = devm_input_allocate_device(&pdev->dev);
 	if (!input_dev) {
diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index 9cd20e6..b12a225 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -617,10 +617,8 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 	match = of_match_device(of_match_ptr(tegra_kbc_of_match), &pdev->dev);
 
 	kbc = devm_kzalloc(&pdev->dev, sizeof(*kbc), GFP_KERNEL);
-	if (!kbc) {
-		dev_err(&pdev->dev, "failed to alloc memory for kbc\n");
+	if (!kbc)
 		return -ENOMEM;
-	}
 
 	kbc->dev = &pdev->dev;
 	kbc->hw_support = match->data;
diff --git a/drivers/input/matrix-keymap.c b/drivers/input/matrix-keymap.c
index 08b61f5..8775de0 100644
--- a/drivers/input/matrix-keymap.c
+++ b/drivers/input/matrix-keymap.c
@@ -170,11 +170,8 @@ int matrix_keypad_build_keymap(const struct matrix_keymap_data *keymap_data,
 		keymap = devm_kzalloc(input_dev->dev.parent,
 				      max_keys * sizeof(*keymap),
 				      GFP_KERNEL);
-		if (!keymap) {
-			dev_err(input_dev->dev.parent,
-				"Unable to allocate memory for keymap");
+		if (!keymap)
 			return -ENOMEM;
-		}
 	}
 
 	input_dev->keycode = keymap;
diff --git a/drivers/input/misc/da9055_onkey.c b/drivers/input/misc/da9055_onkey.c
index a0af8b2..3831598 100644
--- a/drivers/input/misc/da9055_onkey.c
+++ b/drivers/input/misc/da9055_onkey.c
@@ -88,10 +88,8 @@ static int da9055_onkey_probe(struct platform_device *pdev)
 	}
 
 	onkey = devm_kzalloc(&pdev->dev, sizeof(*onkey), GFP_KERNEL);
-	if (!onkey) {
-		dev_err(&pdev->dev, "Failed to allocate memory\n");
+	if (!onkey)
 		return -ENOMEM;
-	}
 
 	input_dev = input_allocate_device();
 	if (!input_dev) {
diff --git a/drivers/input/misc/sirfsoc-onkey.c b/drivers/input/misc/sirfsoc-onkey.c
index 0621c36..b8ff3144 100644
--- a/drivers/input/misc/sirfsoc-onkey.c
+++ b/drivers/input/misc/sirfsoc-onkey.c
@@ -65,10 +65,8 @@ static int sirfsoc_pwrc_probe(struct platform_device *pdev)
 
 	pwrcdrv = devm_kzalloc(&pdev->dev, sizeof(struct sirfsoc_pwrc_drvdata),
 			       GFP_KERNEL);
-	if (!pwrcdrv) {
-		dev_info(&pdev->dev, "Not enough memory for the device data\n");
+	if (!pwrcdrv)
 		return -ENOMEM;
-	}
 
 	/*
 	 * we can't use of_iomap because pwrc is not mapped in memory,
diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index 7864b0c..c447e08 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -275,10 +275,8 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 	}
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
-	if (!info) {
-		dev_err(&pdev->dev, "couldn't allocate memory\n");
+	if (!info)
 		return -ENOMEM;
-	}
 
 	info->dev = &pdev->dev;
 
diff --git a/drivers/input/misc/wm831x-on.c b/drivers/input/misc/wm831x-on.c
index caa2c406..ac2e3cb 100644
--- a/drivers/input/misc/wm831x-on.c
+++ b/drivers/input/misc/wm831x-on.c
@@ -78,10 +78,8 @@ static int wm831x_on_probe(struct platform_device *pdev)
 
 	wm831x_on = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_on),
 				 GFP_KERNEL);
-	if (!wm831x_on) {
-		dev_err(&pdev->dev, "Can't allocate data\n");
+	if (!wm831x_on)
 		return -ENOMEM;
-	}
 
 	wm831x_on->wm831x = wm831x;
 	INIT_DELAYED_WORK(&wm831x_on->work, wm831x_poll_on);
diff --git a/drivers/input/serio/apbps2.c b/drivers/input/serio/apbps2.c
index 17e01a8..455012d 100644
--- a/drivers/input/serio/apbps2.c
+++ b/drivers/input/serio/apbps2.c
@@ -140,10 +140,8 @@ static int apbps2_of_probe(struct platform_device *ofdev)
 	struct resource *res;
 
 	priv = devm_kzalloc(&ofdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&ofdev->dev, "memory allocation failed\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	/* Find Device Address */
 	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
diff --git a/drivers/input/serio/arc_ps2.c b/drivers/input/serio/arc_ps2.c
index 8024a6d..0bbc24f 100644
--- a/drivers/input/serio/arc_ps2.c
+++ b/drivers/input/serio/arc_ps2.c
@@ -197,10 +197,8 @@ static int arc_ps2_probe(struct platform_device *pdev)
 
 	arc_ps2 = devm_kzalloc(&pdev->dev, sizeof(struct arc_ps2_data),
 				GFP_KERNEL);
-	if (!arc_ps2) {
-		dev_err(&pdev->dev, "out of memory\n");
+	if (!arc_ps2)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	arc_ps2->addr = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/input/touchscreen/auo-pixcir-ts.c b/drivers/input/touchscreen/auo-pixcir-ts.c
index d3f9f6b..4f981c5 100644
--- a/drivers/input/touchscreen/auo-pixcir-ts.c
+++ b/drivers/input/touchscreen/auo-pixcir-ts.c
@@ -494,10 +494,8 @@ static struct auo_pixcir_ts_platdata *auo_pixcir_parse_dt(struct device *dev)
 		return ERR_PTR(-ENOENT);
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "failed to allocate platform data\n");
+	if (!pdata)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	pdata->gpio_int = of_get_gpio(np, 0);
 	if (!gpio_is_valid(pdata->gpio_int)) {
diff --git a/drivers/input/touchscreen/egalax_ts.c b/drivers/input/touchscreen/egalax_ts.c
index ef5fcb0..926b5c7 100644
--- a/drivers/input/touchscreen/egalax_ts.c
+++ b/drivers/input/touchscreen/egalax_ts.c
@@ -173,10 +173,8 @@ static int egalax_ts_probe(struct i2c_client *client,
 	int error;
 
 	ts = devm_kzalloc(&client->dev, sizeof(struct egalax_ts), GFP_KERNEL);
-	if (!ts) {
-		dev_err(&client->dev, "Failed to allocate memory\n");
+	if (!ts)
 		return -ENOMEM;
-	}
 
 	input_dev = devm_input_allocate_device(&client->dev);
 	if (!input_dev) {
diff --git a/drivers/input/touchscreen/max11801_ts.c b/drivers/input/touchscreen/max11801_ts.c
index 9f84fcd..d67a0de 100644
--- a/drivers/input/touchscreen/max11801_ts.c
+++ b/drivers/input/touchscreen/max11801_ts.c
@@ -182,8 +182,11 @@ static int max11801_ts_probe(struct i2c_client *client,
 	int error;
 
 	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	input_dev = devm_input_allocate_device(&client->dev);
-	if (!data || !input_dev) {
+	if (!input_dev) {
 		dev_err(&client->dev, "Failed to allocate memory\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/input/touchscreen/mms114.c b/drivers/input/touchscreen/mms114.c
index 1443532..0bf89dd 100644
--- a/drivers/input/touchscreen/mms114.c
+++ b/drivers/input/touchscreen/mms114.c
@@ -387,10 +387,8 @@ static struct mms114_platform_data *mms114_parse_dt(struct device *dev)
 		return NULL;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "failed to allocate platform data\n");
+	if (!pdata)
 		return NULL;
-	}
 
 	if (of_property_read_u32(np, "x-size", &pdata->x_size)) {
 		dev_err(dev, "failed to get x-size property\n");
@@ -447,8 +445,11 @@ static int mms114_probe(struct i2c_client *client,
 
 	data = devm_kzalloc(&client->dev, sizeof(struct mms114_data),
 			    GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	input_dev = devm_input_allocate_device(&client->dev);
-	if (!data || !input_dev) {
+	if (!input_dev) {
 		dev_err(&client->dev, "Failed to allocate memory\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 181c9ba..3352dfe 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1774,10 +1774,9 @@ static int arm_smmu_device_dt_probe(struct platform_device *pdev)
 	int num_irqs, i, err;
 
 	smmu = devm_kzalloc(dev, sizeof(*smmu), GFP_KERNEL);
-	if (!smmu) {
-		dev_err(dev, "failed to allocate arm_smmu_device\n");
+	if (!smmu)
 		return -ENOMEM;
-	}
+
 	smmu->dev = dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1813,10 +1812,8 @@ static int arm_smmu_device_dt_probe(struct platform_device *pdev)
 
 	smmu->irqs = devm_kzalloc(dev, sizeof(*smmu->irqs) * num_irqs,
 				  GFP_KERNEL);
-	if (!smmu->irqs) {
-		dev_err(dev, "failed to allocate %d irqs\n", num_irqs);
+	if (!smmu->irqs)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < num_irqs; ++i) {
 		int irq = platform_get_irq(pdev, i);
diff --git a/drivers/iommu/shmobile-ipmmu.c b/drivers/iommu/shmobile-ipmmu.c
index 8321f89..20346c2 100644
--- a/drivers/iommu/shmobile-ipmmu.c
+++ b/drivers/iommu/shmobile-ipmmu.c
@@ -100,10 +100,9 @@ static int ipmmu_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 	ipmmu = devm_kzalloc(&pdev->dev, sizeof(*ipmmu), GFP_KERNEL);
-	if (!ipmmu) {
-		dev_err(&pdev->dev, "cannot allocate device data\n");
+	if (!ipmmu)
 		return -ENOMEM;
-	}
+
 	mutex_init(&ipmmu->flush_lock);
 	ipmmu->dev = &pdev->dev;
 	ipmmu->ipmmu_base = devm_ioremap_nocache(&pdev->dev, res->start,
diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index f75483a..04b6edd 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -367,10 +367,8 @@ static int tegra_gart_probe(struct platform_device *pdev)
 	}
 
 	gart = devm_kzalloc(dev, sizeof(*gart), GFP_KERNEL);
-	if (!gart) {
-		dev_err(dev, "failed to allocate gart_device\n");
+	if (!gart)
 		return -ENOMEM;
-	}
 
 	gart_regs = devm_ioremap(dev, res->start, resource_size(res));
 	if (!gart_regs) {
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 34374b3..9a73af6 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -1162,10 +1162,8 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 
 	bytes = sizeof(*smmu) + asids * sizeof(*smmu->as);
 	smmu = devm_kzalloc(dev, bytes, GFP_KERNEL);
-	if (!smmu) {
-		dev_err(dev, "failed to allocate smmu_device\n");
+	if (!smmu)
 		return -ENOMEM;
-	}
 
 	smmu->nregs = pdev->num_resources;
 	smmu->regs = devm_kzalloc(dev, 2 * smmu->nregs * sizeof(*smmu->regs),
diff --git a/drivers/irqchip/irq-imgpdc.c b/drivers/irqchip/irq-imgpdc.c
index 8071c2e..bce51c7 100644
--- a/drivers/irqchip/irq-imgpdc.c
+++ b/drivers/irqchip/irq-imgpdc.c
@@ -314,10 +314,9 @@ static int pdc_intc_probe(struct platform_device *pdev)
 
 	/* Allocate driver data */
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "cannot allocate device data\n");
+	if (!priv)
 		return -ENOMEM;
-	}
+
 	raw_spin_lock_init(&priv->lock);
 	platform_set_drvdata(pdev, priv);
 
@@ -354,10 +353,9 @@ static int pdc_intc_probe(struct platform_device *pdev)
 	/* Get peripheral IRQ numbers */
 	priv->perip_irqs = devm_kzalloc(&pdev->dev, 4 * priv->nr_perips,
 					GFP_KERNEL);
-	if (!priv->perip_irqs) {
-		dev_err(&pdev->dev, "cannot allocate perip IRQ list\n");
+	if (!priv->perip_irqs)
 		return -ENOMEM;
-	}
+
 	for (i = 0; i < priv->nr_perips; ++i) {
 		irq = platform_get_irq(pdev, 1 + i);
 		if (irq < 0) {
diff --git a/drivers/irqchip/irq-renesas-intc-irqpin.c b/drivers/irqchip/irq-renesas-intc-irqpin.c
index 82cec63..5fce90c 100644
--- a/drivers/irqchip/irq-renesas-intc-irqpin.c
+++ b/drivers/irqchip/irq-renesas-intc-irqpin.c
@@ -342,7 +342,6 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 
 	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
 	if (!p) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		ret = -ENOMEM;
 		goto err0;
 	}
diff --git a/drivers/leds/leds-adp5520.c b/drivers/leds/leds-adp5520.c
index 7e311a1..7b5aa9c 100644
--- a/drivers/leds/leds-adp5520.c
+++ b/drivers/leds/leds-adp5520.c
@@ -121,10 +121,8 @@ static int adp5520_led_probe(struct platform_device *pdev)
 
 	led = devm_kzalloc(&pdev->dev, sizeof(*led) * pdata->num_leds,
 				GFP_KERNEL);
-	if (led == NULL) {
-		dev_err(&pdev->dev, "failed to alloc memory\n");
+	if (led == NULL)
 		return -ENOMEM;
-	}
 
 	ret = adp5520_led_prepare(pdev);
 
diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index fb5a347..6078c15 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -678,10 +678,8 @@ static int bd2802_probe(struct i2c_client *client,
 	int ret, i;
 
 	led = devm_kzalloc(&client->dev, sizeof(struct bd2802_led), GFP_KERNEL);
-	if (!led) {
-		dev_err(&client->dev, "failed to allocate driver data\n");
+	if (!led)
 		return -ENOMEM;
-	}
 
 	led->client = client;
 	pdata = led->pdata = dev_get_platdata(&client->dev);
diff --git a/drivers/leds/leds-da903x.c b/drivers/leds/leds-da903x.c
index 2a4b87f..d24c219 100644
--- a/drivers/leds/leds-da903x.c
+++ b/drivers/leds/leds-da903x.c
@@ -109,10 +109,8 @@ static int da903x_led_probe(struct platform_device *pdev)
 	}
 
 	led = devm_kzalloc(&pdev->dev, sizeof(struct da903x_led), GFP_KERNEL);
-	if (led == NULL) {
-		dev_err(&pdev->dev, "failed to alloc memory for LED%d\n", id);
+	if (led == NULL)
 		return -ENOMEM;
-	}
 
 	led->cdev.name = pdata->name;
 	led->cdev.default_trigger = pdata->default_trigger;
diff --git a/drivers/leds/leds-da9052.c b/drivers/leds/leds-da9052.c
index 865d4fa..2a1f101 100644
--- a/drivers/leds/leds-da9052.c
+++ b/drivers/leds/leds-da9052.c
@@ -128,7 +128,6 @@ static int da9052_led_probe(struct platform_device *pdev)
 			   sizeof(struct da9052_led) * pled->num_leds,
 			   GFP_KERNEL);
 	if (led == NULL) {
-		dev_err(&pdev->dev, "Failed to alloc memory\n");
 		error = -ENOMEM;
 		goto err;
 	}
diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index 76483fb..0f71336 100644
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@ -77,10 +77,8 @@ static int s3c24xx_led_probe(struct platform_device *dev)
 
 	led = devm_kzalloc(&dev->dev, sizeof(struct s3c24xx_gpio_led),
 			   GFP_KERNEL);
-	if (led == NULL) {
-		dev_err(&dev->dev, "No memory for device\n");
+	if (led == NULL)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(dev, led);
 
diff --git a/drivers/leds/leds-sunfire.c b/drivers/leds/leds-sunfire.c
index 388632d..0b8cc4a 100644
--- a/drivers/leds/leds-sunfire.c
+++ b/drivers/leds/leds-sunfire.c
@@ -135,10 +135,8 @@ static int sunfire_led_generic_probe(struct platform_device *pdev,
 	}
 
 	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
-	if (!p) {
-		dev_err(&pdev->dev, "Could not allocate struct sunfire_drvdata\n");
+	if (!p)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < NUM_LEDS_PER_BOARD; i++) {
 		struct led_classdev *lp = &p->leds[i].led_cdev;
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index fbfdd2f..ebbee0b 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1977,10 +1977,8 @@ static int adv7604_probe(struct i2c_client *client,
 			client->addr << 1);
 
 	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
-	if (!state) {
-		v4l_err(client, "Could not allocate adv7604_state memory!\n");
+	if (!state)
 		return -ENOMEM;
-	}
 
 	/* initialize variables */
 	state->restart_stdi_once = true;
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index d174890..894929f 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2776,10 +2776,8 @@ static int adv7842_probe(struct i2c_client *client,
 	}
 
 	state = devm_kzalloc(&client->dev, sizeof(struct adv7842_state), GFP_KERNEL);
-	if (!state) {
-		v4l_err(client, "Could not allocate adv7842_state memory!\n");
+	if (!state)
 		return -ENOMEM;
-	}
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7842_ops);
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index ae66d91..f024663 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2472,7 +2472,6 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		sensor->nvm = devm_kzalloc(&client->dev,
 				sensor->platform_data->nvm_size, GFP_KERNEL);
 		if (sensor->nvm == NULL) {
-			dev_err(&client->dev, "nvm buf allocation failed\n");
 			rval = -ENOMEM;
 			goto out_ident_release;
 		}
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 6c6b1c3..61b7ac4 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -1084,11 +1084,8 @@ static int ov2640_probe(struct i2c_client *client,
 	}
 
 	priv = devm_kzalloc(&client->dev, sizeof(struct ov2640_priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&adapter->dev,
-			"Failed to allocate memory for private data!\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index ab01598..151d2bb 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -963,11 +963,8 @@ static int ov6650_probe(struct i2c_client *client,
 	}
 
 	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&client->dev,
-			"Failed to allocate memory for private data!\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov6650_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 13);
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index e968c3f..7f8c524 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -685,11 +685,8 @@ static int ov9640_probe(struct i2c_client *client,
 	}
 
 	priv = devm_kzalloc(&client->dev, sizeof(struct ov9640_priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&client->dev,
-			"Failed to allocate memory for private data!\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9640_subdev_ops);
 
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index ea76863..0fb1feb 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -945,10 +945,8 @@ static int ov9740_probe(struct i2c_client *client,
 	}
 
 	priv = devm_kzalloc(&client->dev, sizeof(struct ov9740_priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&client->dev, "Failed to allocate private data!\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9740_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 13);
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 449d2fe..9da0252 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -3129,11 +3129,8 @@ static int coda_probe(struct platform_device *pdev)
 	int ret, irq;
 
 	dev = devm_kzalloc(&pdev->dev, sizeof *dev, GFP_KERNEL);
-	if (!dev) {
-		dev_err(&pdev->dev, "Not enough memory for %s\n",
-			CODA_NAME);
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	spin_lock_init(&dev->irqlock);
 	INIT_LIST_HEAD(&dev->instances);
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index fe9898c..7c44b1a 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1518,7 +1518,6 @@ static int viu_of_probe(struct platform_device *op)
 	/* Prepare our private structure */
 	viu_dev = devm_kzalloc(&op->dev, sizeof(struct viu_dev), GFP_ATOMIC);
 	if (!viu_dev) {
-		dev_err(&op->dev, "Can't allocate private structure\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index df3a0ec..873b663 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2168,10 +2168,8 @@ static int isp_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	isp = devm_kzalloc(&pdev->dev, sizeof(*isp), GFP_KERNEL);
-	if (!isp) {
-		dev_err(&pdev->dev, "could not allocate memory\n");
+	if (!isp)
 		return -ENOMEM;
-	}
 
 	isp->autoidle = autoidle;
 
diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
index 75fd82b..a350bea 100644
--- a/drivers/media/platform/omap3isp/isph3a_aewb.c
+++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
@@ -314,11 +314,8 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
 	/* Set recover state configuration */
 	aewb_recover_cfg = devm_kzalloc(isp->dev, sizeof(*aewb_recover_cfg),
 					GFP_KERNEL);
-	if (!aewb_recover_cfg) {
-		dev_err(aewb->isp->dev, "AEWB: cannot allocate memory for "
-					"recover configuration.\n");
+	if (!aewb_recover_cfg)
 		return -ENOMEM;
-	}
 
 	aewb_recover_cfg->saturation_limit = OMAP3ISP_AEWB_MAX_SATURATION_LIM;
 	aewb_recover_cfg->win_height = OMAP3ISP_AEWB_MIN_WIN_H;
diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
index a0bf5af..627d331 100644
--- a/drivers/media/platform/omap3isp/isph3a_af.c
+++ b/drivers/media/platform/omap3isp/isph3a_af.c
@@ -377,11 +377,8 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
 	/* Set recover state configuration */
 	af_recover_cfg = devm_kzalloc(isp->dev, sizeof(*af_recover_cfg),
 				      GFP_KERNEL);
-	if (!af_recover_cfg) {
-		dev_err(af->isp->dev, "AF: cannot allocate memory for recover "
-				      "configuration.\n");
+	if (!af_recover_cfg)
 		return -ENOMEM;
-	}
 
 	af_recover_cfg->paxel.h_start = OMAP3ISP_AF_PAXEL_HZSTART_MIN;
 	af_recover_cfg->paxel.width = OMAP3ISP_AF_PAXEL_WIDTH_MIN;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 084263d..6a27c7c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1022,10 +1022,9 @@ static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
 
 	dev->mem_dev_l = devm_kzalloc(&dev->plat_dev->dev,
 			sizeof(struct device), GFP_KERNEL);
-	if (!dev->mem_dev_l) {
-		mfc_err("Not enough memory\n");
+	if (!dev->mem_dev_l)
 		return -ENOMEM;
-	}
+
 	device_initialize(dev->mem_dev_l);
 	of_property_read_u32_array(dev->plat_dev->dev.of_node,
 			"samsung,mfc-l", mem_info, 2);
@@ -1039,10 +1038,9 @@ static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
 
 	dev->mem_dev_r = devm_kzalloc(&dev->plat_dev->dev,
 			sizeof(struct device), GFP_KERNEL);
-	if (!dev->mem_dev_r) {
-		mfc_err("Not enough memory\n");
+	if (!dev->mem_dev_r)
 		return -ENOMEM;
-	}
+
 	device_initialize(dev->mem_dev_r);
 	of_property_read_u32_array(dev->plat_dev->dev.of_node,
 			"samsung,mfc-r", mem_info, 2);
@@ -1066,10 +1064,8 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 
 	pr_debug("%s++\n", __func__);
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_err(&pdev->dev, "Not enough memory for MFC device\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	spin_lock_init(&dev->irqlock);
 	spin_lock_init(&dev->condlock);
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 534722c..b9a4295 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -885,7 +885,6 @@ static int hdmi_probe(struct platform_device *pdev)
 
 	hdmi_dev = devm_kzalloc(&pdev->dev, sizeof(*hdmi_dev), GFP_KERNEL);
 	if (!hdmi_dev) {
-		dev_err(dev, "out of memory\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index 0afa90f..28004aa 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -319,7 +319,6 @@ static int sdo_probe(struct platform_device *pdev)
 	dev_info(dev, "probe start\n");
 	sdev = devm_kzalloc(&pdev->dev, sizeof(*sdev), GFP_KERNEL);
 	if (!sdev) {
-		dev_err(dev, "not enough memory.\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index 3dd762e..1cfdfd0 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -324,7 +324,6 @@ static int sii9234_probe(struct i2c_client *client,
 
 	ctx = devm_kzalloc(&client->dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx) {
-		dev_err(dev, "out of memory\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 45a0276..3988d58 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1506,7 +1506,6 @@ static int mx2_camera_probe(struct platform_device *pdev)
 
 	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
 	if (!pcdev) {
-		dev_err(&pdev->dev, "Could not allocate pcdev\n");
 		err = -ENOMEM;
 		goto exit;
 	}
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 8f9f621..c4ebc91 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -1160,10 +1160,8 @@ static int mx3_camera_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	mx3_cam = devm_kzalloc(&pdev->dev, sizeof(*mx3_cam), GFP_KERNEL);
-	if (!mx3_cam) {
-		dev_err(&pdev->dev, "Could not allocate mx3 camera object\n");
+	if (!mx3_cam)
 		return -ENOMEM;
-	}
 
 	mx3_cam->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(mx3_cam->clk))
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index d4df305..b962627 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1664,10 +1664,8 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
-	if (!pcdev) {
-		dev_err(&pdev->dev, "Could not allocate pcdev\n");
+	if (!pcdev)
 		return -ENOMEM;
-	}
 
 	pcdev->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pcdev->clk))
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 8df22f7..d6feec9 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1734,10 +1734,8 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	}
 
 	pcdev = devm_kzalloc(&pdev->dev, sizeof(*pcdev), GFP_KERNEL);
-	if (!pcdev) {
-		dev_err(&pdev->dev, "Could not allocate pcdev\n");
+	if (!pcdev)
 		return -ENOMEM;
-	}
 
 	INIT_LIST_HEAD(&pcdev->capture);
 	spin_lock_init(&pcdev->lock);
diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index ba4cfc9..2d46ba4 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -165,7 +165,6 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 
 	rsdev = devm_kzalloc(&pdev->dev, sizeof(*rsdev), GFP_KERNEL);
 	if (!rsdev) {
-		dev_err(&pdev->dev, "Failed to alloc video device.\n");
 		rval = -ENOMEM;
 		goto exit;
 	}
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 97c2c18..fb50afd9 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -2016,7 +2016,6 @@ static int wl1273_fm_radio_probe(struct platform_device *pdev)
 	radio->buf_size = rds_buf * RDS_BLOCK_SIZE;
 	radio->buffer = devm_kzalloc(&pdev->dev, radio->buf_size, GFP_KERNEL);
 	if (!radio->buffer) {
-		pr_err("Cannot allocate memory for RDS buffer.\n");
 		r = -ENOMEM;
 		goto pdata_err;
 	}
diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 04644e7..e923e0a 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1357,11 +1357,8 @@ static struct emif_data * __init_or_module of_get_memory_device_details(
 	pd	= devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
 	dev_info = devm_kzalloc(dev, sizeof(*dev_info), GFP_KERNEL);
 
-	if (!emif || !pd || !dev_info) {
-		dev_err(dev, "%s: Out of memory!!\n",
-			__func__);
+	if (!emif || !pd || !dev_info)
 		goto error;
-	}
 
 	emif->plat_data		= pd;
 	pd->device_info		= dev_info;
@@ -1447,11 +1444,8 @@ static struct emif_data *__init_or_module get_device_details(
 	emif	= devm_kzalloc(dev, sizeof(*emif), GFP_KERNEL);
 	temp	= devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
 	dev_info = devm_kzalloc(dev, sizeof(*dev_info), GFP_KERNEL);
-
-	if (!emif || !pd || !dev_info) {
-		dev_err(dev, "%s:%d: allocation error\n", __func__, __LINE__);
+	if (!emif || !pd || !dev_info)
 		goto error;
-	}
 
 	memcpy(temp, pd, sizeof(*pd));
 	pd = temp;
@@ -1490,9 +1484,6 @@ static struct emif_data *__init_or_module get_device_details(
 		temp = devm_kzalloc(dev, sizeof(*cust_cfgs), GFP_KERNEL);
 		if (temp)
 			memcpy(temp, cust_cfgs, sizeof(*cust_cfgs));
-		else
-			dev_warn(dev, "%s:%d: allocation error\n", __func__,
-				__LINE__);
 		pd->custom_configs = temp;
 	}
 
@@ -1507,8 +1498,6 @@ static struct emif_data *__init_or_module get_device_details(
 			memcpy(temp, pd->timings, size);
 			pd->timings = temp;
 		} else {
-			dev_warn(dev, "%s:%d: allocation error\n", __func__,
-				__LINE__);
 			get_default_timings(emif);
 		}
 	} else {
@@ -1521,8 +1510,6 @@ static struct emif_data *__init_or_module get_device_details(
 			memcpy(temp, pd->min_tck, sizeof(*pd->min_tck));
 			pd->min_tck = temp;
 		} else {
-			dev_warn(dev, "%s:%d: allocation error\n", __func__,
-				__LINE__);
 			pd->min_tck = &lpddr2_jedec_min_tck;
 		}
 	} else {
diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index 14d9542..2700660 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -370,11 +370,8 @@ static int aat2870_i2c_probe(struct i2c_client *client,
 
 	aat2870 = devm_kzalloc(&client->dev, sizeof(struct aat2870_data),
 				GFP_KERNEL);
-	if (!aat2870) {
-		dev_err(&client->dev,
-			"Failed to allocate memory for aat2870\n");
+	if (!aat2870)
 		return -ENOMEM;
-	}
 
 	aat2870->dev = &client->dev;
 	dev_set_drvdata(aat2870->dev, aat2870);
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index b348ae5..1b692ac 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -859,10 +859,8 @@ static int ab3100_probe(struct i2c_client *client,
 	int i;
 
 	ab3100 = devm_kzalloc(&client->dev, sizeof(struct ab3100), GFP_KERNEL);
-	if (!ab3100) {
-		dev_err(&client->dev, "could not allocate AB3100 device\n");
+	if (!ab3100)
 		return -ENOMEM;
-	}
 
 	/* Initialize data structure */
 	mutex_init(&ab3100->access_mutex);
diff --git a/drivers/mfd/ab3100-otp.c b/drivers/mfd/ab3100-otp.c
index c9af16c..117ec66 100644
--- a/drivers/mfd/ab3100-otp.c
+++ b/drivers/mfd/ab3100-otp.c
@@ -188,10 +188,9 @@ static int __init ab3100_otp_probe(struct platform_device *pdev)
 	int i;
 
 	otp = devm_kzalloc(&pdev->dev, sizeof(struct ab3100_otp), GFP_KERNEL);
-	if (!otp) {
-		dev_err(&pdev->dev, "could not allocate AB3100 OTP device\n");
+	if (!otp)
 		return -ENOMEM;
-	}
+
 	otp->dev = &pdev->dev;
 
 	/* Replace platform data coming in with a local struct */
diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 36000f9..1b732f3 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -924,10 +924,8 @@ static int ab8500_gpadc_probe(struct platform_device *pdev)
 	struct ab8500_gpadc *gpadc;
 
 	gpadc = devm_kzalloc(&pdev->dev, sizeof(struct ab8500_gpadc), GFP_KERNEL);
-	if (!gpadc) {
-		dev_err(&pdev->dev, "Error: No memory\n");
+	if (!gpadc)
 		return -ENOMEM;
-	}
 
 	gpadc->irq_sw = platform_get_irq_byname(pdev, "SW_CONV_END");
 	if (gpadc->irq_sw < 0)
diff --git a/drivers/mfd/abx500-core.c b/drivers/mfd/abx500-core.c
index f3a15aa..6a41f3c 100644
--- a/drivers/mfd/abx500-core.c
+++ b/drivers/mfd/abx500-core.c
@@ -39,10 +39,9 @@ int abx500_register_ops(struct device *dev, struct abx500_ops *ops)
 	dev_entry = devm_kzalloc(dev,
 				 sizeof(struct abx500_device_entry),
 				 GFP_KERNEL);
-	if (!dev_entry) {
-		dev_err(dev, "register_ops kzalloc failed");
+	if (!dev_entry)
 		return -ENOMEM;
-	}
+
 	dev_entry->dev = dev;
 	memcpy(&dev_entry->ops, ops, sizeof(struct abx500_ops));
 
diff --git a/drivers/mfd/as3711.c b/drivers/mfd/as3711.c
index abd3ab7..79db499 100644
--- a/drivers/mfd/as3711.c
+++ b/drivers/mfd/as3711.c
@@ -135,17 +135,13 @@ static int as3711_i2c_probe(struct i2c_client *client,
 	} else {
 		pdata = devm_kzalloc(&client->dev,
 				     sizeof(*pdata), GFP_KERNEL);
-		if (!pdata) {
-			dev_err(&client->dev, "Failed to allocate pdata\n");
+		if (!pdata)
 			return -ENOMEM;
-		}
 	}
 
 	as3711 = devm_kzalloc(&client->dev, sizeof(struct as3711), GFP_KERNEL);
-	if (!as3711) {
-		dev_err(&client->dev, "Memory allocation failed\n");
+	if (!as3711)
 		return -ENOMEM;
-	}
 
 	as3711->dev = &client->dev;
 	i2c_set_clientdata(client, as3711);
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index fa22154..3185467 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -960,10 +960,8 @@ static int __init asic3_probe(struct platform_device *pdev)
 
 	asic = devm_kzalloc(&pdev->dev,
 			    sizeof(struct asic3), GFP_KERNEL);
-	if (asic == NULL) {
-		printk(KERN_ERR "kzalloc failed\n");
+	if (asic == NULL)
 		return -ENOMEM;
-	}
 
 	spin_lock_init(&asic->lock);
 	platform_set_drvdata(pdev, asic);
diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
index 013ba81..f8c7e76 100644
--- a/drivers/mfd/davinci_voicecodec.c
+++ b/drivers/mfd/davinci_voicecodec.c
@@ -47,11 +47,8 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 
 	davinci_vc = devm_kzalloc(&pdev->dev,
 				  sizeof(struct davinci_vc), GFP_KERNEL);
-	if (!davinci_vc) {
-		dev_dbg(&pdev->dev,
-			    "could not allocate memory for private data\n");
+	if (!davinci_vc)
 		return -ENOMEM;
-	}
 
 	davinci_vc->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(davinci_vc->clk)) {
diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index d7b2a75..9d96f80 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -516,10 +516,8 @@ static int htcpld_setup_chips(struct platform_device *pdev)
 	htcpld->nchips = pdata->num_chip;
 	htcpld->chip = devm_kzalloc(dev, sizeof(struct htcpld_chip) * htcpld->nchips,
 				    GFP_KERNEL);
-	if (!htcpld->chip) {
-		dev_warn(dev, "Unable to allocate memory for chips\n");
+	if (!htcpld->chip)
 		return -ENOMEM;
-	}
 
 	/* Add the chips as best we can */
 	for (i = 0; i < htcpld->nchips; i++) {
diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index fcbb2e9..6334e26 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -184,10 +184,8 @@ static int cmodio_pci_probe(struct pci_dev *dev,
 	int ret;
 
 	priv = devm_kzalloc(&dev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&dev->dev, "unable to allocate private data\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	pci_set_drvdata(dev, priv);
 	priv->pdev = dev;
diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 3c0e8cf..8fdd084 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -212,10 +212,8 @@ static int jz4740_adc_probe(struct platform_device *pdev)
 	int irq_base;
 
 	adc = devm_kzalloc(&pdev->dev, sizeof(*adc), GFP_KERNEL);
-	if (!adc) {
-		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
+	if (!adc)
 		return -ENOMEM;
-	}
 
 	adc->irq = platform_get_irq(pdev, 0);
 	if (adc->irq < 0) {
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 522be67..d7e5270 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -57,10 +57,8 @@ static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
 	struct max77686_platform_data *pd;
 
 	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		dev_err(dev, "could not allocate memory for pdata\n");
+	if (!pd)
 		return NULL;
-	}
 
 	dev->platform_data = pd;
 	return pd;
diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index cee098c..18ec4f5 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -148,10 +148,8 @@ static struct max8997_platform_data *max8997_i2c_parse_dt_pdata(
 	struct max8997_platform_data *pd;
 
 	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		dev_err(dev, "could not allocate memory for pdata\n");
+	if (!pd)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	pd->ono = irq_of_parse_and_map(dev->of_node, 1);
 
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 29ee54d..c5a07ff 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -603,10 +603,8 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	}
 
 	omap = devm_kzalloc(dev, sizeof(*omap), GFP_KERNEL);
-	if (!omap) {
-		dev_err(dev, "Memory allocation failed\n");
+	if (!omap)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	omap->uhh_base = devm_ioremap_resource(dev, res);
@@ -660,7 +658,6 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	omap->hsic60m_clk = devm_kzalloc(dev, i, GFP_KERNEL);
 
 	if (!omap->utmi_clk || !omap->hsic480m_clk || !omap->hsic60m_clk) {
-		dev_err(dev, "Memory allocation failed\n");
 		ret = -ENOMEM;
 		goto err_mem;
 	}
diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index e59ac4c..26f46cd 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -220,10 +220,8 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 	dev_dbg(dev, "starting TI HSUSB TLL Controller\n");
 
 	tll = devm_kzalloc(dev, sizeof(struct usbtll_omap), GFP_KERNEL);
-	if (!tll) {
-		dev_err(dev, "Memory allocation failed\n");
+	if (!tll)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	tll->base = devm_ioremap_resource(dev, res);
@@ -256,7 +254,6 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 						GFP_KERNEL);
 	if (!tll->ch_clk) {
 		ret = -ENOMEM;
-		dev_err(dev, "Couldn't allocate memory for channel clocks\n");
 		goto err_clk_alloc;
 	}
 
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index a6841f7..598cff2 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -119,10 +119,8 @@ static int pm8921_probe(struct platform_device *pdev)
 	}
 
 	pmic = devm_kzalloc(&pdev->dev, sizeof(struct pm8921), GFP_KERNEL);
-	if (!pmic) {
-		pr_err("Cannot alloc pm8921 struct\n");
+	if (!pmic)
 		return -ENOMEM;
-	}
 
 	/* Read PMIC chip revision */
 	rc = ssbi_read(pdev->dev.parent, REG_HWREV, &val, sizeof(val));
diff --git a/drivers/mfd/rc5t583.c b/drivers/mfd/rc5t583.c
index 3463301..d01d49f 100644
--- a/drivers/mfd/rc5t583.c
+++ b/drivers/mfd/rc5t583.c
@@ -260,10 +260,8 @@ static int rc5t583_i2c_probe(struct i2c_client *i2c,
 	}
 
 	rc5t583 = devm_kzalloc(&i2c->dev, sizeof(struct rc5t583), GFP_KERNEL);
-	if (!rc5t583) {
-		dev_err(&i2c->dev, "Memory allocation failed\n");
+	if (!rc5t583)
 		return -ENOMEM;
-	}
 
 	rc5t583->dev = &i2c->dev;
 	i2c_set_clientdata(i2c, rc5t583);
diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index f530e4b..6276ac0 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -181,10 +181,8 @@ static struct sec_platform_data *sec_pmic_i2c_parse_dt_pdata(
 	struct sec_platform_data *pd;
 
 	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		dev_err(dev, "could not allocate memory for pdata\n");
+	if (!pd)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	/*
 	 * ToDo: the 'wakeup' member in the platform data is more of a linux
diff --git a/drivers/mfd/si476x-i2c.c b/drivers/mfd/si476x-i2c.c
index 0e4a76d..60a06fa 100644
--- a/drivers/mfd/si476x-i2c.c
+++ b/drivers/mfd/si476x-i2c.c
@@ -697,11 +697,9 @@ static int si476x_core_probe(struct i2c_client *client,
 	int              cell_num;
 
 	core = devm_kzalloc(&client->dev, sizeof(*core), GFP_KERNEL);
-	if (!core) {
-		dev_err(&client->dev,
-			"failed to allocate 'struct si476x_core'\n");
+	if (!core)
 		return -ENOMEM;
-	}
+
 	core->client = client;
 
 	core->regmap = devm_regmap_init_si476x(core);
diff --git a/drivers/mfd/smsc-ece1099.c b/drivers/mfd/smsc-ece1099.c
index 24ae3d8..d207b39 100644
--- a/drivers/mfd/smsc-ece1099.c
+++ b/drivers/mfd/smsc-ece1099.c
@@ -41,10 +41,8 @@ static int smsc_i2c_probe(struct i2c_client *i2c,
 
 	smsc = devm_kzalloc(&i2c->dev, sizeof(struct smsc),
 				GFP_KERNEL);
-	if (!smsc) {
-		dev_err(&i2c->dev, "smsc mfd driver memory allocation failed\n");
+	if (!smsc)
 		return -ENOMEM;
-	}
 
 	smsc->regmap = devm_regmap_init_i2c(i2c, &smsc_regmap_config);
 	if (IS_ERR(smsc->regmap)) {
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index a3685d6..da766cd 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -141,10 +141,9 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	/* Allocate memory for device */
 	tscadc = devm_kzalloc(&pdev->dev,
 			sizeof(struct ti_tscadc_dev), GFP_KERNEL);
-	if (!tscadc) {
-		dev_err(&pdev->dev, "failed to allocate memory.\n");
+	if (!tscadc)
 		return -ENOMEM;
-	}
+
 	tscadc->dev = &pdev->dev;
 
 	err = platform_get_irq(pdev, 0);
diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index e6f03a7..8c95f3d 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -187,10 +187,8 @@ static int tps65090_i2c_probe(struct i2c_client *client,
 		irq_base = pdata->irq_base;
 
 	tps65090 = devm_kzalloc(&client->dev, sizeof(*tps65090), GFP_KERNEL);
-	if (!tps65090) {
-		dev_err(&client->dev, "mem alloc for tps65090 failed\n");
+	if (!tps65090)
 		return -ENOMEM;
-	}
 
 	tps65090->dev = &client->dev;
 	i2c_set_clientdata(client, tps65090);
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 68906b1..4f121ad 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -420,10 +420,8 @@ static struct tps6586x_platform_data *tps6586x_parse_dt(struct i2c_client *clien
 	struct tps6586x_platform_data *pdata;
 
 	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(&client->dev, "Memory allocation failed\n");
+	if (!pdata)
 		return NULL;
-	}
 
 	pdata->num_subdevs = 0;
 	pdata->subdevs = NULL;
@@ -495,10 +493,8 @@ static int tps6586x_i2c_probe(struct i2c_client *client,
 	dev_info(&client->dev, "VERSIONCRC is %02x\n", ret);
 
 	tps6586x = devm_kzalloc(&client->dev, sizeof(*tps6586x), GFP_KERNEL);
-	if (tps6586x == NULL) {
-		dev_err(&client->dev, "memory for tps6586x alloc failed\n");
+	if (tps6586x == NULL)
 		return -ENOMEM;
-	}
 
 	tps6586x->client = client;
 	tps6586x->dev = &client->dev;
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index d792772..be0c8cb 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -402,10 +402,8 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
 
 	board_info = devm_kzalloc(&client->dev, sizeof(*board_info),
 			GFP_KERNEL);
-	if (!board_info) {
-		dev_err(&client->dev, "Failed to allocate pdata\n");
+	if (!board_info)
 		return NULL;
-	}
 
 	ret = of_property_read_u32(np, "ti,vmbch-threshold", &prop);
 	if (!ret)
diff --git a/drivers/mfd/tps80031.c b/drivers/mfd/tps80031.c
index f15ee6d..338b4d1 100644
--- a/drivers/mfd/tps80031.c
+++ b/drivers/mfd/tps80031.c
@@ -431,10 +431,8 @@ static int tps80031_probe(struct i2c_client *client,
 	}
 
 	tps80031 = devm_kzalloc(&client->dev, sizeof(*tps80031), GFP_KERNEL);
-	if (!tps80031) {
-		dev_err(&client->dev, "Malloc failed for tps80031\n");
+	if (!tps80031)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < TPS80031_NUM_SLAVES; i++) {
 		if (tps80031_slave_address[i] == client->addr)
diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index 517eda8..7e3cf82 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -402,10 +402,8 @@ int twl6030_init_irq(struct device *dev, int irq_num)
 	nr_irqs = TWL6030_NR_IRQS;
 
 	twl6030_irq = devm_kzalloc(dev, sizeof(*twl6030_irq), GFP_KERNEL);
-	if (!twl6030_irq) {
-		dev_err(dev, "twl6030_irq: Memory allocation failed\n");
+	if (!twl6030_irq)
 		return -ENOMEM;
-	}
 
 	mask[0] = 0xFF;
 	mask[1] = 0xFF;
diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index 5be80840..ef21a57 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -138,10 +138,8 @@ static int ssc_probe(struct platform_device *pdev)
 	const struct atmel_ssc_platform_data *plat_dat;
 
 	ssc = devm_kzalloc(&pdev->dev, sizeof(struct ssc_device), GFP_KERNEL);
-	if (!ssc) {
-		dev_dbg(&pdev->dev, "out of memory\n");
+	if (!ssc)
 		return -ENOMEM;
-	}
 
 	ssc->pdev = pdev;
 
diff --git a/drivers/misc/lattice-ecp3-config.c b/drivers/misc/lattice-ecp3-config.c
index 61fbe6a..ef1a79d 100644
--- a/drivers/misc/lattice-ecp3-config.c
+++ b/drivers/misc/lattice-ecp3-config.c
@@ -190,10 +190,9 @@ static int lattice_ecp3_probe(struct spi_device *spi)
 	int err;
 
 	data = devm_kzalloc(&spi->dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_err(&spi->dev, "Memory allocation for fpga_data failed\n");
+	if (!data)
 		return -ENOMEM;
-	}
+
 	spi_set_drvdata(spi, data);
 
 	init_completion(&data->fw_loaded);
diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index c98b03b..0794b60 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -484,11 +484,8 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 		 (unsigned long)iobase, pdev->irq);
 
 	vmci_dev = devm_kzalloc(&pdev->dev, sizeof(*vmci_dev), GFP_KERNEL);
-	if (!vmci_dev) {
-		dev_err(&pdev->dev,
-			"Can't allocate memory for VMCI device\n");
+	if (!vmci_dev)
 		return -ENOMEM;
-	}
 
 	vmci_dev->dev = &pdev->dev;
 	vmci_dev->intr_type = VMCI_INTR_TYPE_INTX;
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 92c1877..e98aee5 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -531,10 +531,8 @@ atmci_of_init(struct platform_device *pdev)
 	}
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(&pdev->dev, "could not allocate memory for pdata\n");
+	if (!pdata)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	for_each_child_of_node(np, cnp) {
 		if (of_property_read_u32(cnp, "reg", &slot_id)) {
diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index e9fa87d..276a57a 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1201,10 +1201,8 @@ static struct davinci_mmc_config
 		return pdata;
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(&pdev->dev, "Failed to allocate memory for struct davinci_mmc_config\n");
+	if (!pdata)
 		goto nodata;
-	}
 
 	if (match)
 		pdev->id_entry = match->data;
diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index d42e664..de6b92a 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -227,10 +227,8 @@ static int dw_mci_exynos_parse_dt(struct dw_mci *host)
 	int ret;
 
 	priv = devm_kzalloc(host->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(host->dev, "mem alloc failed for private data\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	for (idx = 0; idx < ARRAY_SIZE(exynos_compat); idx++) {
 		if (of_device_is_compatible(np, exynos_compat[idx].compatible))
diff --git a/drivers/mmc/host/dw_mmc-socfpga.c b/drivers/mmc/host/dw_mmc-socfpga.c
index 3e8e53a..8c6c910 100644
--- a/drivers/mmc/host/dw_mmc-socfpga.c
+++ b/drivers/mmc/host/dw_mmc-socfpga.c
@@ -71,10 +71,8 @@ static int dw_mci_socfpga_parse_dt(struct dw_mci *host)
 	int ret;
 
 	priv = devm_kzalloc(host->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(host->dev, "mem alloc failed for private data\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	priv->sysreg = syscon_regmap_lookup_by_compatible("altr,sys-mgr");
 	if (IS_ERR(priv->sysreg)) {
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 0a6a512..b370ae2 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2341,10 +2341,8 @@ static struct dw_mci_board *dw_mci_parse_dt(struct dw_mci *host)
 	u32 clock_frequency;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "could not allocate memory for pdata\n");
+	if (!pdata)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	/* find out number of slots supported */
 	if (of_property_read_u32(dev->of_node, "num-slots",
diff --git a/drivers/mmc/host/sdhci-bcm2835.c b/drivers/mmc/host/sdhci-bcm2835.c
index f6d8d67..1db5219 100644
--- a/drivers/mmc/host/sdhci-bcm2835.c
+++ b/drivers/mmc/host/sdhci-bcm2835.c
@@ -154,11 +154,8 @@ static int bcm2835_sdhci_probe(struct platform_device *pdev)
 
 	bcm2835_host = devm_kzalloc(&pdev->dev, sizeof(*bcm2835_host),
 					GFP_KERNEL);
-	if (!bcm2835_host) {
-		dev_err(mmc_dev(host->mmc),
-			"failed to allocate bcm2835_sdhci\n");
+	if (!bcm2835_host)
 		return -ENOMEM;
-	}
 
 	pltfm_host = sdhci_priv(host);
 	pltfm_host->priv = bcm2835_host;
diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
index 8424839..b375486 100644
--- a/drivers/mmc/host/sdhci-dove.c
+++ b/drivers/mmc/host/sdhci-dove.c
@@ -106,10 +106,8 @@ static int sdhci_dove_probe(struct platform_device *pdev)
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(struct sdhci_dove_priv),
 			    GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "unable to allocate private data");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
 
diff --git a/drivers/mmc/host/sdhci-spear.c b/drivers/mmc/host/sdhci-spear.c
index 2dba9f8..2264a9c 100644
--- a/drivers/mmc/host/sdhci-spear.c
+++ b/drivers/mmc/host/sdhci-spear.c
@@ -84,10 +84,8 @@ static struct sdhci_plat_data *sdhci_probe_config_dt(struct platform_device *pde
 	/* If pdata is required */
 	if (cd_gpio != -1) {
 		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-		if (!pdata) {
-			dev_err(&pdev->dev, "DT: kzalloc failed\n");
+		if (!pdata)
 			return ERR_PTR(-ENOMEM);
-		}
 	}
 
 	pdata->card_int_gpio = cd_gpio;
@@ -126,7 +124,6 @@ static int sdhci_probe(struct platform_device *pdev)
 	sdhci = devm_kzalloc(&pdev->dev, sizeof(*sdhci), GFP_KERNEL);
 	if (!sdhci) {
 		ret = -ENOMEM;
-		dev_dbg(&pdev->dev, "cannot allocate memory for sdhci\n");
 		goto err;
 	}
 
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 5b7b2eb..e51887f 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -238,7 +238,6 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
 
 	tegra_host = devm_kzalloc(&pdev->dev, sizeof(*tegra_host), GFP_KERNEL);
 	if (!tegra_host) {
-		dev_err(mmc_dev(host->mmc), "failed to allocate tegra_host\n");
 		rc = -ENOMEM;
 		goto err_alloc_tegra_host;
 	}
diff --git a/drivers/mmc/host/sh_mobile_sdhi.c b/drivers/mmc/host/sh_mobile_sdhi.c
index f344659..0235e97 100644
--- a/drivers/mmc/host/sh_mobile_sdhi.c
+++ b/drivers/mmc/host/sh_mobile_sdhi.c
@@ -138,10 +138,8 @@ static int sh_mobile_sdhi_probe(struct platform_device *pdev)
 	struct tmio_mmc_dma *dma_priv;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(struct sh_mobile_sdhi), GFP_KERNEL);
-	if (priv == NULL) {
-		dev_err(&pdev->dev, "kzalloc failed\n");
+	if (priv == NULL)
 		return -ENOMEM;
-	}
 
 	mmc_data = &priv->mmc_data;
 	dma_priv = &priv->dma_priv;
diff --git a/drivers/mtd/devices/elm.c b/drivers/mtd/devices/elm.c
index d1dd6a3..437ed3a 100644
--- a/drivers/mtd/devices/elm.c
+++ b/drivers/mtd/devices/elm.c
@@ -354,10 +354,8 @@ static int elm_probe(struct platform_device *pdev)
 	struct elm_info *info;
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
-	if (!info) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!info)
 		return -ENOMEM;
-	}
 
 	info->dev = &pdev->dev;
 
diff --git a/drivers/mtd/devices/spear_smi.c b/drivers/mtd/devices/spear_smi.c
index 4238214..363da96 100644
--- a/drivers/mtd/devices/spear_smi.c
+++ b/drivers/mtd/devices/spear_smi.c
@@ -913,7 +913,6 @@ static int spear_smi_probe(struct platform_device *pdev)
 	if (np) {
 		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 		if (!pdata) {
-			pr_err("%s: ERROR: no memory", __func__);
 			ret = -ENOMEM;
 			goto err;
 		}
@@ -943,7 +942,6 @@ static int spear_smi_probe(struct platform_device *pdev)
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_ATOMIC);
 	if (!dev) {
 		ret = -ENOMEM;
-		dev_err(&pdev->dev, "mem alloc fail\n");
 		goto err;
 	}
 
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 2dbd913..edfcc32 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -1962,10 +1962,8 @@ static int atmel_nand_probe(struct platform_device *pdev)
 
 	/* Allocate memory for the device structure (and zero it) */
 	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
-	if (!host) {
-		printk(KERN_ERR "atmel_nand: failed to allocate device structure.\n");
+	if (!host)
 		return -ENOMEM;
-	}
 
 	res = platform_driver_register(&atmel_nand_nfc_driver);
 	if (res)
diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index b77a01e..34aa69f 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -608,7 +608,6 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
-		dev_err(&pdev->dev, "unable to allocate memory\n");
 		ret = -ENOMEM;
 		goto err_nomem;
 	}
diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 3dc1a75..a22c5b4 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -891,10 +891,9 @@ static int fsmc_nand_probe_config_dt(struct platform_device *pdev,
 
 	pdata->nand_timings = devm_kzalloc(&pdev->dev,
 				sizeof(*pdata->nand_timings), GFP_KERNEL);
-	if (!pdata->nand_timings) {
-		dev_err(&pdev->dev, "no memory for nand_timing\n");
+	if (!pdata->nand_timings)
 		return -ENOMEM;
-	}
+
 	of_property_read_u8_array(np, "timings", (u8 *)pdata->nand_timings,
 						sizeof(*pdata->nand_timings));
 
@@ -952,10 +951,8 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
 
 	/* Allocate memory for the device structure (and zero it) */
 	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
-	if (!host) {
-		dev_err(&pdev->dev, "failed to allocate device structure\n");
+	if (!host)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nand_data");
 	host->data_va = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/mtd/nand/gpio.c b/drivers/mtd/nand/gpio.c
index e826f89..8dfdbb6 100644
--- a/drivers/mtd/nand/gpio.c
+++ b/drivers/mtd/nand/gpio.c
@@ -211,10 +211,8 @@ static int gpio_nand_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	gpiomtd = devm_kzalloc(&pdev->dev, sizeof(*gpiomtd), GFP_KERNEL);
-	if (!gpiomtd) {
-		dev_err(&pdev->dev, "failed to create NAND MTD\n");
+	if (!gpiomtd)
 		return -ENOMEM;
-	}
 
 	chip = &gpiomtd->nand_chip;
 
diff --git a/drivers/mtd/nand/lpc32xx_mlc.c b/drivers/mtd/nand/lpc32xx_mlc.c
index f4dd2a8..9dd58e0 100644
--- a/drivers/mtd/nand/lpc32xx_mlc.c
+++ b/drivers/mtd/nand/lpc32xx_mlc.c
@@ -627,10 +627,8 @@ static struct lpc32xx_nand_cfg_mlc *lpc32xx_parse_dt(struct device *dev)
 	struct device_node *np = dev->of_node;
 
 	ncfg = devm_kzalloc(dev, sizeof(*ncfg), GFP_KERNEL);
-	if (!ncfg) {
-		dev_err(dev, "could not allocate memory for platform data\n");
+	if (!ncfg)
 		return NULL;
-	}
 
 	of_property_read_u32(np, "nxp,tcea-delay", &ncfg->tcea_delay);
 	of_property_read_u32(np, "nxp,busy-delay", &ncfg->busy_delay);
@@ -666,10 +664,8 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 
 	/* Allocate memory for the device structure (and zero it) */
 	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
-	if (!host) {
-		dev_err(&pdev->dev, "failed to allocate device structure.\n");
+	if (!host)
 		return -ENOMEM;
-	}
 
 	rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	host->io_base = devm_ioremap_resource(&pdev->dev, rc);
@@ -764,14 +760,12 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 
 	host->dma_buf = devm_kzalloc(&pdev->dev, mtd->writesize, GFP_KERNEL);
 	if (!host->dma_buf) {
-		dev_err(&pdev->dev, "Error allocating dma_buf memory\n");
 		res = -ENOMEM;
 		goto err_exit3;
 	}
 
 	host->dummy_buf = devm_kzalloc(&pdev->dev, mtd->writesize, GFP_KERNEL);
 	if (!host->dummy_buf) {
-		dev_err(&pdev->dev, "Error allocating dummy_buf memory\n");
 		res = -ENOMEM;
 		goto err_exit3;
 	}
diff --git a/drivers/mtd/nand/lpc32xx_slc.c b/drivers/mtd/nand/lpc32xx_slc.c
index 6d5f8c5..a780532 100644
--- a/drivers/mtd/nand/lpc32xx_slc.c
+++ b/drivers/mtd/nand/lpc32xx_slc.c
@@ -725,10 +725,8 @@ static struct lpc32xx_nand_cfg_slc *lpc32xx_parse_dt(struct device *dev)
 	struct device_node *np = dev->of_node;
 
 	ncfg = devm_kzalloc(dev, sizeof(*ncfg), GFP_KERNEL);
-	if (!ncfg) {
-		dev_err(dev, "could not allocate memory for NAND config\n");
+	if (!ncfg)
 		return NULL;
-	}
 
 	of_property_read_u32(np, "nxp,wdr-clks", &ncfg->wdr_clks);
 	of_property_read_u32(np, "nxp,wwidth", &ncfg->wwidth);
@@ -772,10 +770,9 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 
 	/* Allocate memory for the device structure (and zero it) */
 	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
-	if (!host) {
-		dev_err(&pdev->dev, "failed to allocate device structure\n");
+	if (!host)
 		return -ENOMEM;
-	}
+
 	host->io_base_dma = rc->start;
 
 	host->io_base = devm_ioremap_resource(&pdev->dev, rc);
@@ -858,7 +855,6 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	host->data_buf = devm_kzalloc(&pdev->dev, host->dma_buf_len,
 				      GFP_KERNEL);
 	if (host->data_buf == NULL) {
-		dev_err(&pdev->dev, "Error allocating memory\n");
 		res = -ENOMEM;
 		goto err_exit2;
 	}
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index 3c60a00..b23d508 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -651,10 +651,8 @@ static int mpc5121_nfc_probe(struct platform_device *op)
 	}
 
 	prv = devm_kzalloc(dev, sizeof(*prv), GFP_KERNEL);
-	if (!prv) {
-		dev_err(dev, "Memory exhausted!\n");
+	if (!prv)
 		return -ENOMEM;
-	}
 
 	mtd = &prv->mtd;
 	chip = &prv->chip;
diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index a393a5b..d6af006 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -110,7 +110,6 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 		board = devm_kzalloc(&pdev->dev, sizeof(struct orion_nand_data),
 					GFP_KERNEL);
 		if (!board) {
-			printk(KERN_ERR "orion_nand: failed to allocate board structure.\n");
 			ret = -ENOMEM;
 			goto no_res;
 		}
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index d65cbe9..47fbd9a 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -919,7 +919,6 @@ static int s3c24xx_nand_probe(struct platform_device *pdev)
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (info == NULL) {
-		dev_err(&pdev->dev, "no memory for flash info\n");
 		err = -ENOMEM;
 		goto exit_error;
 	}
@@ -974,7 +973,6 @@ static int s3c24xx_nand_probe(struct platform_device *pdev)
 	size = nr_sets * sizeof(*info->mtds);
 	info->mtds = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
 	if (info->mtds == NULL) {
-		dev_err(&pdev->dev, "failed to allocate mtd storage\n");
 		err = -ENOMEM;
 		goto exit_error;
 	}
diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
index a3c84eb..4fff62b 100644
--- a/drivers/mtd/nand/sh_flctl.c
+++ b/drivers/mtd/nand/sh_flctl.c
@@ -1059,10 +1059,8 @@ static struct sh_flctl_platform_data *flctl_parse_dt(struct device *dev)
 
 	pdata = devm_kzalloc(dev, sizeof(struct sh_flctl_platform_data),
 								GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "%s: failed to allocate config data\n", __func__);
+	if (!pdata)
 		return NULL;
-	}
 
 	/* set SoC specific options */
 	pdata->flcmncr_val = config->flcmncr_val;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 51c9069..0bc7654 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -128,10 +128,8 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
 			plat_dat = devm_kzalloc(&pdev->dev,
 					sizeof(struct plat_stmmacenet_data),
 					GFP_KERNEL);
-		if (!plat_dat) {
-			pr_err("%s: ERROR: no memory", __func__);
-			return  -ENOMEM;
-		}
+		if (!plat_dat)
+			return -ENOMEM;
 
 		ret = stmmac_probe_config_dt(pdev, plat_dat, &mac);
 		if (ret) {
diff --git a/drivers/net/ethernet/ti/cpsw-phy-sel.c b/drivers/net/ethernet/ti/cpsw-phy-sel.c
index e092ede..20948ee 100644
--- a/drivers/net/ethernet/ti/cpsw-phy-sel.c
+++ b/drivers/net/ethernet/ti/cpsw-phy-sel.c
@@ -127,10 +127,8 @@ static int cpsw_phy_sel_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "unable to alloc memory for cpsw phy sel\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	priv->cpsw_phy_sel = of_id->data;
 
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 5efb37b..4ac1ea4 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1924,10 +1924,8 @@ static int cpsw_probe(struct platform_device *pdev)
 	priv->rx_packet_max = max(rx_packet_max, 128);
 	priv->cpts = devm_kzalloc(&pdev->dev, sizeof(struct cpts), GFP_KERNEL);
 	priv->irq_enabled = true;
-	if (!priv->cpts) {
-		pr_err("error allocating cpts\n");
+	if (!priv->cpts)
 		goto clean_ndev_ret;
-	}
 
 	/*
 	 * This may be required here for child devices.
diff --git a/drivers/net/phy/mdio-mux.c b/drivers/net/phy/mdio-mux.c
index 4d4d25e..73f38da 100644
--- a/drivers/net/phy/mdio-mux.c
+++ b/drivers/net/phy/mdio-mux.c
@@ -141,8 +141,6 @@ int mdio_mux_init(struct device *dev,
 
 		cb = devm_kzalloc(dev, sizeof(*cb), GFP_KERNEL);
 		if (cb == NULL) {
-			dev_err(dev,
-				"Error: Failed to allocate memory for child\n");
 			ret_val = -ENOMEM;
 			break;
 		}
diff --git a/drivers/nfc/microread/i2c.c b/drivers/nfc/microread/i2c.c
index 1010894..54c9a18 100644
--- a/drivers/nfc/microread/i2c.c
+++ b/drivers/nfc/microread/i2c.c
@@ -273,10 +273,8 @@ static int microread_i2c_probe(struct i2c_client *client,
 
 	phy = devm_kzalloc(&client->dev, sizeof(struct microread_i2c_phy),
 			   GFP_KERNEL);
-	if (!phy) {
-		dev_err(&client->dev, "Can't allocate microread phy");
+	if (!phy)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(client, phy);
 	phy->i2c_dev = client;
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 01e27d4..dab22ea 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -700,11 +700,8 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 
 	phy = devm_kzalloc(&client->dev, sizeof(struct pn544_i2c_phy),
 			   GFP_KERNEL);
-	if (!phy) {
-		dev_err(&client->dev,
-			"Cannot allocate memory for pn544 i2c phy.\n");
+	if (!phy)
 		return -ENOMEM;
-	}
 
 	INIT_WORK(&phy->fw_work, pn544_hci_i2c_fw_work);
 	phy->fw_work_state = FW_WORK_STATE_IDLE;
diff --git a/drivers/pci/host/pci-exynos.c b/drivers/pci/host/pci-exynos.c
index 94e096b..9650fdd 100644
--- a/drivers/pci/host/pci-exynos.c
+++ b/drivers/pci/host/pci-exynos.c
@@ -455,10 +455,8 @@ static int __init exynos_pcie_probe(struct platform_device *pdev)
 
 	exynos_pcie = devm_kzalloc(&pdev->dev, sizeof(*exynos_pcie),
 				GFP_KERNEL);
-	if (!exynos_pcie) {
-		dev_err(&pdev->dev, "no memory for exynos pcie\n");
+	if (!exynos_pcie)
 		return -ENOMEM;
-	}
 
 	pp = &exynos_pcie->pp;
 
diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index 0fd1ad3..c57a5db 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -612,10 +612,8 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 
 	pctl = devm_kzalloc(&pdev->dev, sizeof(struct mvebu_pinctrl),
 			GFP_KERNEL);
-	if (!pctl) {
-		dev_err(&pdev->dev, "unable to alloc driver\n");
+	if (!pctl)
 		return -ENOMEM;
-	}
 
 	pctl->desc.name = dev_name(&pdev->dev);
 	pctl->desc.owner = THIS_MODULE;
@@ -652,10 +650,9 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 
 		/* generic mvebu register control */
 		names = devm_kzalloc(&pdev->dev, ctrl->npins * 8, GFP_KERNEL);
-		if (!names) {
-			dev_err(&pdev->dev, "failed to alloc mpp names\n");
+		if (!names)
 			return -ENOMEM;
-		}
+
 		for (k = 0; k < ctrl->npins; k++)
 			sprintf(names + 8*k, "mpp%d", ctrl->pid+k);
 		ctrl->name = names;
@@ -664,10 +661,8 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 
 	pdesc = devm_kzalloc(&pdev->dev, pctl->desc.npins *
 			     sizeof(struct pinctrl_pin_desc), GFP_KERNEL);
-	if (!pdesc) {
-		dev_err(&pdev->dev, "failed to alloc pinctrl pins\n");
+	if (!pdesc)
 		return -ENOMEM;
-	}
 
 	for (n = 0; n < pctl->desc.npins; n++)
 		pdesc[n].number = n;
@@ -675,10 +670,8 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 
 	pctl->groups = devm_kzalloc(&pdev->dev, pctl->num_groups *
 			     sizeof(struct mvebu_pinctrl_group), GFP_KERNEL);
-	if (!pctl->groups) {
-		dev_err(&pdev->dev, "failed to alloc pinctrl groups\n");
+	if (!pctl->groups)
 		return -ENOMEM;
-	}
 
 	/* assign mpp controls to groups */
 	gid = 0;
diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 4780959..3e1c722 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -1238,11 +1238,8 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 
 	pct = devm_kzalloc(&pdev->dev, sizeof(struct abx500_pinctrl),
 				   GFP_KERNEL);
-	if (pct == NULL) {
-		dev_err(&pdev->dev,
-			"failed to allocate memory for pct\n");
+	if (pct == NULL)
 		return -ENOMEM;
-	}
 
 	pct->dev = &pdev->dev;
 	pct->parent = dev_get_drvdata(pdev->dev.parent);
diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index 7a24e59..43cb8ea 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -849,10 +849,8 @@ static int adi_gpio_pint_probe(struct platform_device *pdev)
 	struct gpio_pint *pint;
 
 	pint = devm_kzalloc(dev, sizeof(struct gpio_pint), GFP_KERNEL);
-	if (!pint) {
-		dev_err(dev, "Memory alloc failed\n");
+	if (!pint)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
@@ -978,10 +976,8 @@ static int adi_gpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	port = devm_kzalloc(dev, sizeof(struct gpio_port), GFP_KERNEL);
-	if (!port) {
-		dev_err(dev, "Memory alloc failed\n");
+	if (!port)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index f350fd2..77eaabe 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -837,10 +837,8 @@ static int at91_pinctrl_mux_mask(struct at91_pinctrl *info,
 	info->nmux = size / info->nbanks;
 
 	info->mux_mask = devm_kzalloc(info->dev, sizeof(u32) * size, GFP_KERNEL);
-	if (!info->mux_mask) {
-		dev_err(info->dev, "could not alloc mux_mask\n");
+	if (!info->mux_mask)
 		return -ENOMEM;
-	}
 
 	ret = of_property_read_u32_array(np, "atmel,mux-mask",
 					  info->mux_mask, size);
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 2832576..46a5666 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -424,10 +424,8 @@ static int byt_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	vg = devm_kzalloc(dev, sizeof(struct byt_gpio), GFP_KERNEL);
-	if (!vg) {
-		dev_err(&pdev->dev, "can't allocate byt_gpio chip data\n");
+	if (!vg)
 		return -ENOMEM;
-	}
 
 	for (range = byt_ranges; range->name; range++) {
 		if (!strcmp(acpi_dev->pnp.unique_id, range->name)) {
diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index 2689f8d..a54fd32 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -543,10 +543,8 @@ static int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d)
 
 		weint_data = devm_kzalloc(dev, bank->nr_pins
 					* sizeof(*weint_data), GFP_KERNEL);
-		if (!weint_data) {
-			dev_err(dev, "could not allocate memory for weint_data\n");
+		if (!weint_data)
 			return -ENOMEM;
-		}
 
 		for (idx = 0; idx < bank->nr_pins; ++idx) {
 			irq = irq_of_parse_and_map(bank->of_node, idx);
@@ -573,10 +571,8 @@ static int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d)
 
 	muxed_data = devm_kzalloc(dev, sizeof(*muxed_data)
 		+ muxed_banks*sizeof(struct samsung_pin_bank *), GFP_KERNEL);
-	if (!muxed_data) {
-		dev_err(dev, "could not allocate memory for muxed_data\n");
+	if (!muxed_data)
 		return -ENOMEM;
-	}
 
 	irq_set_chained_handler(irq, exynos_irq_demux_eint16_31);
 	irq_set_handler_data(irq, muxed_data);
diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
index 544d469..d79721b 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/pinctrl-exynos5440.c
@@ -658,10 +658,8 @@ static int exynos5440_pinctrl_parse_dt_pins(struct platform_device *pdev,
 	}
 
 	*pin_list = devm_kzalloc(dev, *npins * sizeof(**pin_list), GFP_KERNEL);
-	if (!*pin_list) {
-		dev_err(dev, "failed to allocate memory for pin list\n");
+	if (!*pin_list)
 		return -ENOMEM;
-	}
 
 	return of_property_read_u32_array(cfg_np, "samsung,exynos5440-pins",
 			*pin_list, *npins);
@@ -689,17 +687,15 @@ static int exynos5440_pinctrl_parse_dt(struct platform_device *pdev,
 		return -EINVAL;
 
 	groups = devm_kzalloc(dev, grp_cnt * sizeof(*groups), GFP_KERNEL);
-	if (!groups) {
-		dev_err(dev, "failed allocate memory for ping group list\n");
+	if (!groups)
 		return -EINVAL;
-	}
+
 	grp = groups;
 
 	functions = devm_kzalloc(dev, grp_cnt * sizeof(*functions), GFP_KERNEL);
-	if (!functions) {
-		dev_err(dev, "failed to allocate memory for function list\n");
+	if (!functions)
 		return -EINVAL;
-	}
+
 	func = functions;
 
 	/*
@@ -719,10 +715,9 @@ static int exynos5440_pinctrl_parse_dt(struct platform_device *pdev,
 		/* derive pin group name from the node name */
 		gname = devm_kzalloc(dev, strlen(cfg_np->name) + GSUFFIX_LEN,
 					GFP_KERNEL);
-		if (!gname) {
-			dev_err(dev, "failed to alloc memory for group name\n");
+		if (!gname)
 			return -ENOMEM;
-		}
+
 		snprintf(gname, strlen(cfg_np->name) + 4, "%s%s", cfg_np->name,
 			 GROUP_SUFFIX);
 
@@ -740,20 +735,17 @@ skip_to_pin_function:
 		/* derive function name from the node name */
 		fname = devm_kzalloc(dev, strlen(cfg_np->name) + FSUFFIX_LEN,
 					GFP_KERNEL);
-		if (!fname) {
-			dev_err(dev, "failed to alloc memory for func name\n");
+		if (!fname)
 			return -ENOMEM;
-		}
+
 		snprintf(fname, strlen(cfg_np->name) + 4, "%s%s", cfg_np->name,
 			 FUNCTION_SUFFIX);
 
 		func->name = fname;
 		func->groups = devm_kzalloc(dev, sizeof(char *), GFP_KERNEL);
-		if (!func->groups) {
-			dev_err(dev, "failed to alloc memory for group list "
-					"in pin function");
+		if (!func->groups)
 			return -ENOMEM;
-		}
+
 		func->groups[0] = gname;
 		func->num_groups = gname ? 1 : 0;
 		func->function = function;
@@ -781,10 +773,8 @@ static int exynos5440_pinctrl_register(struct platform_device *pdev,
 	int pin, ret;
 
 	ctrldesc = devm_kzalloc(dev, sizeof(*ctrldesc), GFP_KERNEL);
-	if (!ctrldesc) {
-		dev_err(dev, "could not allocate memory for pinctrl desc\n");
+	if (!ctrldesc)
 		return -ENOMEM;
-	}
 
 	ctrldesc->name = "exynos5440-pinctrl";
 	ctrldesc->owner = THIS_MODULE;
@@ -794,10 +784,9 @@ static int exynos5440_pinctrl_register(struct platform_device *pdev,
 
 	pindesc = devm_kzalloc(&pdev->dev, sizeof(*pindesc) *
 				EXYNOS5440_MAX_PINS, GFP_KERNEL);
-	if (!pindesc) {
-		dev_err(&pdev->dev, "mem alloc for pin descriptors failed\n");
+	if (!pindesc)
 		return -ENOMEM;
-	}
+
 	ctrldesc->pins = pindesc;
 	ctrldesc->npins = EXYNOS5440_MAX_PINS;
 
@@ -811,10 +800,8 @@ static int exynos5440_pinctrl_register(struct platform_device *pdev,
 	 */
 	pin_names = devm_kzalloc(&pdev->dev, sizeof(char) * PIN_NAME_LENGTH *
 					ctrldesc->npins, GFP_KERNEL);
-	if (!pin_names) {
-		dev_err(&pdev->dev, "mem alloc for pin names failed\n");
+	if (!pin_names)
 		return -ENOMEM;
-	}
 
 	/* for each pin, set the name of the pin */
 	for (pin = 0; pin < ctrldesc->npins; pin++) {
@@ -851,10 +838,8 @@ static int exynos5440_gpiolib_register(struct platform_device *pdev,
 	int ret;
 
 	gc = devm_kzalloc(&pdev->dev, sizeof(*gc), GFP_KERNEL);
-	if (!gc) {
-		dev_err(&pdev->dev, "mem alloc for gpio_chip failed\n");
+	if (!gc)
 		return -ENOMEM;
-	}
 
 	priv->gc = gc;
 	gc->base = 0;
@@ -960,10 +945,8 @@ static int exynos5440_gpio_irq_init(struct platform_device *pdev,
 
 	intd = devm_kzalloc(dev, sizeof(*intd) * EXYNOS5440_MAX_GPIO_INT,
 					GFP_KERNEL);
-	if (!intd) {
-		dev_err(dev, "failed to allocate memory for gpio intr data\n");
+	if (!intd)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < EXYNOS5440_MAX_GPIO_INT; i++) {
 		irq = irq_of_parse_and_map(dev->of_node, i);
@@ -1006,10 +989,8 @@ static int exynos5440_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(dev, "could not allocate memory for private data\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->reg_base = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/pinctrl/pinctrl-palmas.c b/drivers/pinctrl/pinctrl-palmas.c
index 82638fa..e25e508 100644
--- a/drivers/pinctrl/pinctrl-palmas.c
+++ b/drivers/pinctrl/pinctrl-palmas.c
@@ -1032,10 +1032,8 @@ static int palmas_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	pci = devm_kzalloc(&pdev->dev, sizeof(*pci), GFP_KERNEL);
-	if (!pci) {
-		dev_err(&pdev->dev, "Malloc for pci failed\n");
+	if (!pci)
 		return -ENOMEM;
-	}
 
 	pci->dev = &pdev->dev;
 	pci->palmas = dev_get_drvdata(pdev->dev.parent);
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index e0718b7..46fbed2 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -791,18 +791,14 @@ static int rockchip_pinctrl_parse_dt(struct platform_device *pdev,
 	info->functions = devm_kzalloc(dev, info->nfunctions *
 					      sizeof(struct rockchip_pmx_func),
 					      GFP_KERNEL);
-	if (!info->functions) {
-		dev_err(dev, "failed to allocate memory for function list\n");
+	if (!info->functions)
 		return -EINVAL;
-	}
 
 	info->groups = devm_kzalloc(dev, info->ngroups *
 					    sizeof(struct rockchip_pin_group),
 					    GFP_KERNEL);
-	if (!info->groups) {
-		dev_err(dev, "failed allocate memory for ping group list\n");
+	if (!info->groups)
 		return -EINVAL;
-	}
 
 	i = 0;
 
@@ -836,10 +832,9 @@ static int rockchip_pinctrl_register(struct platform_device *pdev,
 
 	pindesc = devm_kzalloc(&pdev->dev, sizeof(*pindesc) *
 			info->ctrl->nr_pins, GFP_KERNEL);
-	if (!pindesc) {
-		dev_err(&pdev->dev, "mem alloc for pin descriptors failed\n");
+	if (!pindesc)
 		return -ENOMEM;
-	}
+
 	ctrldesc->pins = pindesc;
 	ctrldesc->npins = info->ctrl->nr_pins;
 
diff --git a/drivers/pinctrl/pinctrl-s3c64xx.c b/drivers/pinctrl/pinctrl-s3c64xx.c
index 89143c9..2b12eb6 100644
--- a/drivers/pinctrl/pinctrl-s3c64xx.c
+++ b/drivers/pinctrl/pinctrl-s3c64xx.c
@@ -491,10 +491,9 @@ static int s3c64xx_eint_gpio_init(struct samsung_pinctrl_drv_data *d)
 
 	data = devm_kzalloc(dev, sizeof(*data)
 			+ nr_domains * sizeof(*data->domains), GFP_KERNEL);
-	if (!data) {
-		dev_err(dev, "failed to allocate handler data\n");
+	if (!data)
 		return -ENOMEM;
-	}
+
 	data->drvdata = d;
 
 	bank = d->ctrl->pin_banks;
@@ -716,10 +715,9 @@ static int s3c64xx_eint_eint0_init(struct samsung_pinctrl_drv_data *d)
 		return -ENODEV;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_err(dev, "could not allocate memory for wkup eint data\n");
+	if (!data)
 		return -ENOMEM;
-	}
+
 	data->drvdata = d;
 
 	for (i = 0; i < NUM_EINT0_IRQ; ++i) {
@@ -751,10 +749,9 @@ static int s3c64xx_eint_eint0_init(struct samsung_pinctrl_drv_data *d)
 
 		ddata = devm_kzalloc(dev,
 				sizeof(*ddata) + nr_eints, GFP_KERNEL);
-		if (!ddata) {
-			dev_err(dev, "failed to allocate domain data\n");
+		if (!ddata)
 			return -ENOMEM;
-		}
+
 		ddata->bank = bank;
 
 		bank->irq_domain = irq_domain_add_linear(bank->of_node,
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 92a9d6c..1ee9a6d 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -601,10 +601,8 @@ static int samsung_pinctrl_parse_dt_pins(struct platform_device *pdev,
 	}
 
 	*pin_list = devm_kzalloc(dev, *npins * sizeof(**pin_list), GFP_KERNEL);
-	if (!*pin_list) {
-		dev_err(dev, "failed to allocate memory for pin list\n");
+	if (!*pin_list)
 		return -ENOMEM;
-	}
 
 	of_property_for_each_string(cfg_np, "samsung,pins", prop, pin_name) {
 		for (cnt = 0; cnt < pctl->npins; cnt++) {
@@ -649,17 +647,15 @@ static int samsung_pinctrl_parse_dt(struct platform_device *pdev,
 		return -EINVAL;
 
 	groups = devm_kzalloc(dev, grp_cnt * sizeof(*groups), GFP_KERNEL);
-	if (!groups) {
-		dev_err(dev, "failed allocate memory for ping group list\n");
+	if (!groups)
 		return -EINVAL;
-	}
+
 	grp = groups;
 
 	functions = devm_kzalloc(dev, grp_cnt * sizeof(*functions), GFP_KERNEL);
-	if (!functions) {
-		dev_err(dev, "failed to allocate memory for function list\n");
+	if (!functions)
 		return -EINVAL;
-	}
+
 	func = functions;
 
 	/*
@@ -679,10 +675,9 @@ static int samsung_pinctrl_parse_dt(struct platform_device *pdev,
 		/* derive pin group name from the node name */
 		gname = devm_kzalloc(dev, strlen(cfg_np->name) + GSUFFIX_LEN,
 					GFP_KERNEL);
-		if (!gname) {
-			dev_err(dev, "failed to alloc memory for group name\n");
+		if (!gname)
 			return -ENOMEM;
-		}
+
 		sprintf(gname, "%s%s", cfg_np->name, GROUP_SUFFIX);
 
 		grp->name = gname;
@@ -698,19 +693,16 @@ static int samsung_pinctrl_parse_dt(struct platform_device *pdev,
 		/* derive function name from the node name */
 		fname = devm_kzalloc(dev, strlen(cfg_np->name) + FSUFFIX_LEN,
 					GFP_KERNEL);
-		if (!fname) {
-			dev_err(dev, "failed to alloc memory for func name\n");
+		if (!fname)
 			return -ENOMEM;
-		}
+
 		sprintf(fname, "%s%s", cfg_np->name, FUNCTION_SUFFIX);
 
 		func->name = fname;
 		func->groups = devm_kzalloc(dev, sizeof(char *), GFP_KERNEL);
-		if (!func->groups) {
-			dev_err(dev, "failed to alloc memory for group list "
-					"in pin function");
+		if (!func->groups)
 			return -ENOMEM;
-		}
+
 		func->groups[0] = gname;
 		func->num_groups = 1;
 		func++;
@@ -743,10 +735,9 @@ static int samsung_pinctrl_register(struct platform_device *pdev,
 
 	pindesc = devm_kzalloc(&pdev->dev, sizeof(*pindesc) *
 			drvdata->ctrl->nr_pins, GFP_KERNEL);
-	if (!pindesc) {
-		dev_err(&pdev->dev, "mem alloc for pin descriptors failed\n");
+	if (!pindesc)
 		return -ENOMEM;
-	}
+
 	ctrldesc->pins = pindesc;
 	ctrldesc->npins = drvdata->ctrl->nr_pins;
 
@@ -760,10 +751,8 @@ static int samsung_pinctrl_register(struct platform_device *pdev,
 	 */
 	pin_names = devm_kzalloc(&pdev->dev, sizeof(char) * PIN_NAME_LENGTH *
 					drvdata->ctrl->nr_pins, GFP_KERNEL);
-	if (!pin_names) {
-		dev_err(&pdev->dev, "mem alloc for pin names failed\n");
+	if (!pin_names)
 		return -ENOMEM;
-	}
 
 	/* for each pin, the name of the pin is pin-bank name + pin number */
 	for (bank = 0; bank < drvdata->ctrl->nr_banks; bank++) {
@@ -928,11 +917,8 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata) {
-		dev_err(dev, "failed to allocate memory for driver's "
-				"private data\n");
+	if (!drvdata)
 		return -ENOMEM;
-	}
 
 	ctrl = samsung_pinctrl_get_soc_data(drvdata, pdev);
 	if (!ctrl) {
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index a82ace4..bcad278 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1532,10 +1532,9 @@ static int pcs_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	pcs = devm_kzalloc(&pdev->dev, sizeof(*pcs), GFP_KERNEL);
-	if (!pcs) {
-		dev_err(&pdev->dev, "could not allocate\n");
+	if (!pcs)
 		return -ENOMEM;
-	}
+
 	pcs->dev = &pdev->dev;
 	mutex_init(&pcs->mutex);
 	INIT_LIST_HEAD(&pcs->pingroups);
diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index a2e93a2..92d9332 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -622,10 +622,9 @@ int tegra_pinctrl_probe(struct platform_device *pdev,
 	int i;
 
 	pmx = devm_kzalloc(&pdev->dev, sizeof(*pmx), GFP_KERNEL);
-	if (!pmx) {
-		dev_err(&pdev->dev, "Can't alloc tegra_pmx\n");
+	if (!pmx)
 		return -ENOMEM;
-	}
+
 	pmx->dev = &pdev->dev;
 	pmx->soc = soc_data;
 
@@ -643,10 +642,8 @@ int tegra_pinctrl_probe(struct platform_device *pdev,
 
 	pmx->regs = devm_kzalloc(&pdev->dev, pmx->nbanks * sizeof(*pmx->regs),
 				 GFP_KERNEL);
-	if (!pmx->regs) {
-		dev_err(&pdev->dev, "Can't alloc regs pointer\n");
+	if (!pmx->regs)
 		return -ENODEV;
-	}
 
 	for (i = 0; i < pmx->nbanks; i++) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
diff --git a/drivers/pinctrl/pinctrl-tz1090-pdc.c b/drivers/pinctrl/pinctrl-tz1090-pdc.c
index 5bf01c2..5a5bbd5 100644
--- a/drivers/pinctrl/pinctrl-tz1090-pdc.c
+++ b/drivers/pinctrl/pinctrl-tz1090-pdc.c
@@ -958,10 +958,9 @@ static int tz1090_pdc_pinctrl_probe(struct platform_device *pdev)
 	struct resource *res;
 
 	pmx = devm_kzalloc(&pdev->dev, sizeof(*pmx), GFP_KERNEL);
-	if (!pmx) {
-		dev_err(&pdev->dev, "Can't alloc tz1090_pdc_pmx\n");
+	if (!pmx)
 		return -ENOMEM;
-	}
+
 	pmx->dev = &pdev->dev;
 	spin_lock_init(&pmx->lock);
 
diff --git a/drivers/pinctrl/pinctrl-tz1090.c b/drivers/pinctrl/pinctrl-tz1090.c
index bc9cd7a..b9de6cd 100644
--- a/drivers/pinctrl/pinctrl-tz1090.c
+++ b/drivers/pinctrl/pinctrl-tz1090.c
@@ -2004,10 +2004,9 @@ static int tz1090_pinctrl_probe(struct platform_device *pdev)
 	struct resource *res;
 
 	pmx = devm_kzalloc(&pdev->dev, sizeof(*pmx), GFP_KERNEL);
-	if (!pmx) {
-		dev_err(&pdev->dev, "Can't alloc tz1090_pmx\n");
+	if (!pmx)
 		return -ENOMEM;
-	}
+
 	pmx->dev = &pdev->dev;
 	spin_lock_init(&pmx->lock);
 
diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index ed2d1ba..fe697d6 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -778,18 +778,16 @@ static int pinmux_xway_probe(struct platform_device *pdev)
 	xway_info.pads = devm_kzalloc(&pdev->dev,
 			sizeof(struct pinctrl_pin_desc) * xway_chip.ngpio,
 			GFP_KERNEL);
-	if (!xway_info.pads) {
-		dev_err(&pdev->dev, "Failed to allocate pads\n");
+	if (!xway_info.pads)
 		return -ENOMEM;
-	}
+
 	for (i = 0; i < xway_chip.ngpio; i++) {
 		/* strlen("ioXY") + 1 = 5 */
 		char *name = devm_kzalloc(&pdev->dev, 5, GFP_KERNEL);
 
-		if (!name) {
-			dev_err(&pdev->dev, "Failed to allocate pad name\n");
+		if (!name)
 			return -ENOMEM;
-		}
+
 		snprintf(name, 5, "io%d", i);
 		xway_info.pads[i].number = GPIO0 + i;
 		xway_info.pads[i].name = name;
diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
index 0a7f0bdb..0cff284 100644
--- a/drivers/pinctrl/spear/pinctrl-plgpio.c
+++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
@@ -529,10 +529,8 @@ static int plgpio_probe(struct platform_device *pdev)
 	int ret, irq, i;
 
 	plgpio = devm_kzalloc(&pdev->dev, sizeof(*plgpio), GFP_KERNEL);
-	if (!plgpio) {
-		dev_err(&pdev->dev, "memory allocation fail\n");
+	if (!plgpio)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	plgpio->base = devm_ioremap_resource(&pdev->dev, res);
@@ -554,10 +552,8 @@ static int plgpio_probe(struct platform_device *pdev)
 			sizeof(*plgpio->csave_regs) *
 			DIV_ROUND_UP(plgpio->chip.ngpio, MAX_GPIO_PER_REG),
 			GFP_KERNEL);
-	if (!plgpio->csave_regs) {
-		dev_err(&pdev->dev, "csave registers memory allocation fail\n");
+	if (!plgpio->csave_regs)
 		return -ENOMEM;
-	}
 #endif
 
 	platform_set_drvdata(pdev, plgpio);
diff --git a/drivers/pinctrl/spear/pinctrl-spear.c b/drivers/pinctrl/spear/pinctrl-spear.c
index 58bf686..d7b51b3 100644
--- a/drivers/pinctrl/spear/pinctrl-spear.c
+++ b/drivers/pinctrl/spear/pinctrl-spear.c
@@ -368,10 +368,8 @@ int spear_pinctrl_probe(struct platform_device *pdev,
 		return -ENODEV;
 
 	pmx = devm_kzalloc(&pdev->dev, sizeof(*pmx), GFP_KERNEL);
-	if (!pmx) {
-		dev_err(&pdev->dev, "Can't alloc spear_pmx\n");
+	if (!pmx)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	pmx->vbase = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/pinctrl/vt8500/pinctrl-vt8500.c b/drivers/pinctrl/vt8500/pinctrl-vt8500.c
index f2fe9f8..ca12884 100644
--- a/drivers/pinctrl/vt8500/pinctrl-vt8500.c
+++ b/drivers/pinctrl/vt8500/pinctrl-vt8500.c
@@ -458,10 +458,8 @@ static int vt8500_pinctrl_probe(struct platform_device *pdev)
 	struct wmt_pinctrl_data *data;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_err(&pdev->dev, "failed to allocate data\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	data->banks = vt8500_banks;
 	data->nbanks = ARRAY_SIZE(vt8500_banks);
diff --git a/drivers/pinctrl/vt8500/pinctrl-wm8505.c b/drivers/pinctrl/vt8500/pinctrl-wm8505.c
index 483ba73..f4c87fa 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wm8505.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wm8505.c
@@ -489,10 +489,8 @@ static int wm8505_pinctrl_probe(struct platform_device *pdev)
 	struct wmt_pinctrl_data *data;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_err(&pdev->dev, "failed to allocate data\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	data->banks = wm8505_banks;
 	data->nbanks = ARRAY_SIZE(wm8505_banks);
diff --git a/drivers/pinctrl/vt8500/pinctrl-wm8650.c b/drivers/pinctrl/vt8500/pinctrl-wm8650.c
index 7de57f0..4622849 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wm8650.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wm8650.c
@@ -327,10 +327,8 @@ static int wm8650_pinctrl_probe(struct platform_device *pdev)
 	struct wmt_pinctrl_data *data;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_err(&pdev->dev, "failed to allocate data\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	data->banks = wm8650_banks;
 	data->nbanks = ARRAY_SIZE(wm8650_banks);
diff --git a/drivers/pinctrl/vt8500/pinctrl-wm8750.c b/drivers/pinctrl/vt8500/pinctrl-wm8750.c
index de43262..734e9e2 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wm8750.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wm8750.c
@@ -366,10 +366,8 @@ static int wm8750_pinctrl_probe(struct platform_device *pdev)
 	struct wmt_pinctrl_data *data;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_err(&pdev->dev, "failed to allocate data\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	data->banks = wm8750_banks;
 	data->nbanks = ARRAY_SIZE(wm8750_banks);
diff --git a/drivers/pinctrl/vt8500/pinctrl-wm8850.c b/drivers/pinctrl/vt8500/pinctrl-wm8850.c
index ecadce9c..29f1fb3 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wm8850.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wm8850.c
@@ -345,10 +345,8 @@ static int wm8850_pinctrl_probe(struct platform_device *pdev)
 	struct wmt_pinctrl_data *data;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_err(&pdev->dev, "failed to allocate data\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	data->banks = wm8850_banks;
 	data->nbanks = ARRAY_SIZE(wm8850_banks);
diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 7f9a454..182481e 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -1063,10 +1063,8 @@ static int ab8500_btemp_probe(struct platform_device *pdev)
 	u8 val;
 
 	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
-	if (!di) {
-		dev_err(&pdev->dev, "%s no mem for ab8500_btemp\n", __func__);
+	if (!di)
 		return -ENOMEM;
-	}
 
 	if (!plat) {
 		dev_err(&pdev->dev, "no battery management data supplied\n");
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index a4c4a10..442067a 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -3443,10 +3443,8 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	int irq, i, charger_status, ret = 0, ch_stat;
 
 	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
-	if (!di) {
-		dev_err(&pdev->dev, "%s no mem for ab8500_charger\n", __func__);
+	if (!di)
 		return -ENOMEM;
-	}
 
 	if (!plat) {
 		dev_err(&pdev->dev, "no battery management data supplied\n");
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 7549707..67049db 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -3096,10 +3096,8 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	int ret = 0;
 
 	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
-	if (!di) {
-		dev_err(&pdev->dev, "%s no mem for ab8500_fg\n", __func__);
+	if (!di)
 		return -ENOMEM;
-	}
 
 	if (!plat) {
 		dev_err(&pdev->dev, "no battery management data supplied\n");
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 6d27236..2649b0ed 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -2051,10 +2051,8 @@ static int abx500_chargalg_probe(struct platform_device *pdev)
 	int ret = 0;
 
 	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
-	if (!di) {
-		dev_err(&pdev->dev, "%s no mem for ab8500_chargalg\n", __func__);
+	if (!di)
 		return -ENOMEM;
-	}
 
 	if (!plat) {
 		dev_err(&pdev->dev, "no battery management data supplied\n");
diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index db9973b..86ac41c 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -848,19 +848,13 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 	int i, ret = 0;
 
 	sr_info = devm_kzalloc(&pdev->dev, sizeof(struct omap_sr), GFP_KERNEL);
-	if (!sr_info) {
-		dev_err(&pdev->dev, "%s: unable to allocate sr_info\n",
-			__func__);
+	if (!sr_info)
 		return -ENOMEM;
-	}
 
 	sr_info->name = devm_kzalloc(&pdev->dev,
 				     SMARTREFLEX_NAME_LEN, GFP_KERNEL);
-	if (!sr_info->name) {
-		dev_err(&pdev->dev, "%s: unable to allocate SR instance name\n",
-			__func__);
+	if (!sr_info->name)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(pdev, sr_info);
 
diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 0727f92..aec61ac 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1530,7 +1530,6 @@ static int bq2415x_probe(struct i2c_client *client,
 
 	bq = devm_kzalloc(&client->dev, sizeof(*bq), GFP_KERNEL);
 	if (!bq) {
-		dev_err(&client->dev, "failed to allocate device data\n");
 		ret = -ENOMEM;
 		goto error_2;
 	}
diff --git a/drivers/power/bq24190_charger.c b/drivers/power/bq24190_charger.c
index ad3ff8f..aa08525 100644
--- a/drivers/power/bq24190_charger.c
+++ b/drivers/power/bq24190_charger.c
@@ -1371,10 +1371,8 @@ static int bq24190_probe(struct i2c_client *client,
 	}
 
 	bdi = devm_kzalloc(dev, sizeof(*bdi), GFP_KERNEL);
-	if (!bdi) {
-		dev_err(dev, "Can't alloc bdi struct\n");
+	if (!bdi)
 		return -ENOMEM;
-	}
 
 	bdi->client = client;
 	bdi->dev = dev;
diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
index 59a1421..f1ab81e 100644
--- a/drivers/power/generic-adc-battery.c
+++ b/drivers/power/generic-adc-battery.c
@@ -247,10 +247,8 @@ static int gab_probe(struct platform_device *pdev)
 	int index = 0;
 
 	adc_bat = devm_kzalloc(&pdev->dev, sizeof(*adc_bat), GFP_KERNEL);
-	if (!adc_bat) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!adc_bat)
 		return -ENOMEM;
-	}
 
 	psy = &adc_bat->psy;
 	psy->name = pdata->battery_info.name;
diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 4e858a2..f5c9e60 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -88,10 +88,8 @@ static int gpio_charger_probe(struct platform_device *pdev)
 
 	gpio_charger = devm_kzalloc(&pdev->dev, sizeof(*gpio_charger),
 					GFP_KERNEL);
-	if (!gpio_charger) {
-		dev_err(&pdev->dev, "Failed to alloc driver structure\n");
+	if (!gpio_charger)
 		return -ENOMEM;
-	}
 
 	charger = &gpio_charger->charger;
 
diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index d9686aa..9155779 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -252,10 +252,8 @@ static int jz_battery_probe(struct platform_device *pdev)
 	}
 
 	jz_battery = devm_kzalloc(&pdev->dev, sizeof(*jz_battery), GFP_KERNEL);
-	if (!jz_battery) {
-		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
+	if (!jz_battery)
 		return -ENOMEM;
-	}
 
 	jz_battery->cell = mfd_get_cell(pdev);
 
diff --git a/drivers/power/max8903_charger.c b/drivers/power/max8903_charger.c
index 08f0d79..87b70cd 100644
--- a/drivers/power/max8903_charger.c
+++ b/drivers/power/max8903_charger.c
@@ -190,10 +190,9 @@ static int max8903_probe(struct platform_device *pdev)
 	int usb_in = 0;
 
 	data = devm_kzalloc(dev, sizeof(struct max8903_data), GFP_KERNEL);
-	if (data == NULL) {
-		dev_err(dev, "Cannot allocate memory.\n");
+	if (data == NULL)
 		return -ENOMEM;
-	}
+
 	memcpy(&data->pdata, pdata, sizeof(struct max8903_pdata));
 	data->dev = dev;
 	platform_set_drvdata(pdev, data);
diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index b4513f2..d6a100e 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -452,6 +452,8 @@ max8925_power_dt_init(struct platform_device *pdev)
 	pdata = devm_kzalloc(&pdev->dev,
 			sizeof(struct max8925_power_pdata),
 			GFP_KERNEL);
+	if (!pdata)
+		return NULL;
 
 	of_property_read_u32(np, "topoff-threshold", &topoff_threshold);
 	of_property_read_u32(np, "batt-detect", &batt_detect);
diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
index 4bdedfe..4833be3 100644
--- a/drivers/power/max8997_charger.c
+++ b/drivers/power/max8997_charger.c
@@ -140,10 +140,8 @@ static int max8997_battery_probe(struct platform_device *pdev)
 
 	charger = devm_kzalloc(&pdev->dev, sizeof(struct charger_data),
 				GFP_KERNEL);
-	if (charger == NULL) {
-		dev_err(&pdev->dev, "Cannot allocate memory.\n");
+	if (charger == NULL)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(pdev, charger);
 
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 00e6672..78062b8 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -223,17 +223,13 @@ static int power_supply_check_supplies(struct power_supply *psy)
 	/* All supplies found, allocate char ** array for filling */
 	psy->supplied_from = devm_kzalloc(psy->dev, sizeof(psy->supplied_from),
 					  GFP_KERNEL);
-	if (!psy->supplied_from) {
-		dev_err(psy->dev, "Couldn't allocate memory for supply list\n");
+	if (!psy->supplied_from)
 		return -ENOMEM;
-	}
 
 	*psy->supplied_from = devm_kzalloc(psy->dev, sizeof(char *) * cnt,
 					   GFP_KERNEL);
-	if (!*psy->supplied_from) {
-		dev_err(psy->dev, "Couldn't allocate memory for supply list\n");
+	if (!*psy->supplied_from)
 		return -ENOMEM;
-	}
 
 	return power_supply_populate_supplied_from(psy);
 }
diff --git a/drivers/power/reset/xgene-reboot.c b/drivers/power/reset/xgene-reboot.c
index ecd55f8..641f53f 100644
--- a/drivers/power/reset/xgene-reboot.c
+++ b/drivers/power/reset/xgene-reboot.c
@@ -61,10 +61,8 @@ static int xgene_reboot_probe(struct platform_device *pdev)
 	struct xgene_reboot_context *ctx;
 
 	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
-	if (!ctx) {
-		dev_err(&pdev->dev, "out of memory for context\n");
+	if (!ctx)
 		return -ENODEV;
-	}
 
 	ctx->csr = of_iomap(pdev->dev.of_node, 0);
 	if (!ctx->csr) {
diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
index bdd7b9b..b5fe8b0 100644
--- a/drivers/power/tps65090-charger.c
+++ b/drivers/power/tps65090-charger.c
@@ -197,10 +197,8 @@ static struct tps65090_platform_data *
 	unsigned int prop;
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(&pdev->dev, "Memory alloc for tps65090_pdata failed\n");
+	if (!pdata)
 		return NULL;
-	}
 
 	prop = of_property_read_bool(np, "ti,enable-low-current-chrg");
 	pdata->enable_low_current_chrg = prop;
@@ -238,10 +236,8 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 	}
 
 	cdata = devm_kzalloc(&pdev->dev, sizeof(*cdata), GFP_KERNEL);
-	if (!cdata) {
-		dev_err(&pdev->dev, "failed to allocate memory status\n");
+	if (!cdata)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(pdev, cdata);
 
diff --git a/drivers/pwm/pwm-ab8500.c b/drivers/pwm/pwm-ab8500.c
index 1d07a6f..9d53e8e 100644
--- a/drivers/pwm/pwm-ab8500.c
+++ b/drivers/pwm/pwm-ab8500.c
@@ -101,10 +101,8 @@ static int ab8500_pwm_probe(struct platform_device *pdev)
 	 * device which is required for ab8500 read and write
 	 */
 	ab8500 = devm_kzalloc(&pdev->dev, sizeof(*ab8500), GFP_KERNEL);
-	if (ab8500 == NULL) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (ab8500 == NULL)
 		return -ENOMEM;
-	}
 
 	ab8500->chip.dev = &pdev->dev;
 	ab8500->chip.ops = &ab8500_pwm_ops;
diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index f3dcd02..53dd9d9 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -388,7 +388,6 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 	tcbpwm = devm_kzalloc(&pdev->dev, sizeof(*tcbpwm), GFP_KERNEL);
 	if (tcbpwm == NULL) {
 		atmel_tc_free(tc);
-		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/pwm/pwm-bfin.c b/drivers/pwm/pwm-bfin.c
index 9985d83..4e03ca9 100644
--- a/drivers/pwm/pwm-bfin.c
+++ b/drivers/pwm/pwm-bfin.c
@@ -118,10 +118,8 @@ static int bfin_pwm_probe(struct platform_device *pdev)
 	int ret;
 
 	pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
-	if (!pwm) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!pwm)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(pdev, pwm);
 
diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 2b7c4f8..8a92a38 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -240,10 +240,8 @@ static int imx_pwm_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	imx = devm_kzalloc(&pdev->dev, sizeof(*imx), GFP_KERNEL);
-	if (imx == NULL) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (imx == NULL)
 		return -ENOMEM;
-	}
 
 	imx->clk_per = devm_clk_get(&pdev->dev, "per");
 	if (IS_ERR(imx->clk_per)) {
diff --git a/drivers/pwm/pwm-puv3.c b/drivers/pwm/pwm-puv3.c
index a9a2808..3142914 100644
--- a/drivers/pwm/pwm-puv3.c
+++ b/drivers/pwm/pwm-puv3.c
@@ -107,10 +107,8 @@ static int pwm_probe(struct platform_device *pdev)
 	int ret;
 
 	puv3 = devm_kzalloc(&pdev->dev, sizeof(*puv3), GFP_KERNEL);
-	if (puv3 == NULL) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (puv3 == NULL)
 		return -ENOMEM;
-	}
 
 	puv3->clk = devm_clk_get(&pdev->dev, "OST_CLK");
 	if (IS_ERR(puv3->clk))
diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index a4d2164..2fc3307 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -132,10 +132,8 @@ static int pwm_probe(struct platform_device *pdev)
 	int ret = 0;
 
 	pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
-	if (pwm == NULL) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (pwm == NULL)
 		return -ENOMEM;
-	}
 
 	pwm->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pwm->clk))
diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index aff6ba9..cc13ff4 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -405,10 +405,8 @@ static int tpu_probe(struct platform_device *pdev)
 	int ret;
 
 	tpu = devm_kzalloc(&pdev->dev, sizeof(*tpu), GFP_KERNEL);
-	if (tpu == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	if (tpu == NULL)
 		return -ENOMEM;
-	}
 
 	spin_lock_init(&tpu->lock);
 	tpu->pdev = pdev;
diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index 8ad26b8..b4f6d0d 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -179,10 +179,8 @@ static int spear_pwm_probe(struct platform_device *pdev)
 	u32 val;
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
-	if (!pc) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!pc)
 		return -ENOMEM;
-	}
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	pc->mmio_base = devm_ioremap_resource(&pdev->dev, r);
diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index 74298c5..61d86b9 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -173,10 +173,8 @@ static int tegra_pwm_probe(struct platform_device *pdev)
 	int ret;
 
 	pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
-	if (!pwm) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!pwm)
 		return -ENOMEM;
-	}
 
 	pwm->dev = &pdev->dev;
 
diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index c2e2e58..7148022 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -215,10 +215,8 @@ static int ecap_pwm_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "unable to select pin group\n");
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
-	if (!pc) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!pc)
 		return -ENOMEM;
-	}
 
 	clk = devm_clk_get(&pdev->dev, "fck");
 	if (IS_ERR(clk)) {
diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 084f552..f676d65 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -446,10 +446,8 @@ static int ehrpwm_pwm_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "unable to select pin group\n");
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
-	if (!pc) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!pc)
 		return -ENOMEM;
-	}
 
 	clk = devm_clk_get(&pdev->dev, "fck");
 	if (IS_ERR(clk)) {
diff --git a/drivers/pwm/pwm-tipwmss.c b/drivers/pwm/pwm-tipwmss.c
index 3b119bc..67481dc 100644
--- a/drivers/pwm/pwm-tipwmss.c
+++ b/drivers/pwm/pwm-tipwmss.c
@@ -62,10 +62,8 @@ static int pwmss_probe(struct platform_device *pdev)
 	struct device_node *node = pdev->dev.of_node;
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
-	if (!info) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!info)
 		return -ENOMEM;
-	}
 
 	mutex_init(&info->pwmss_lock);
 
diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
index 323125a..652e6b5 100644
--- a/drivers/pwm/pwm-vt8500.c
+++ b/drivers/pwm/pwm-vt8500.c
@@ -211,10 +211,8 @@ static int vt8500_pwm_probe(struct platform_device *pdev)
 	}
 
 	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
-	if (chip == NULL) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (chip == NULL)
 		return -ENOMEM;
-	}
 
 	chip->chip.dev = &pdev->dev;
 	chip->chip.ops = &vt8500_pwm_ops;
diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
index 3459f60..66ac534 100644
--- a/drivers/regulator/88pm800.c
+++ b/drivers/regulator/88pm800.c
@@ -314,10 +314,8 @@ static int pm800_regulator_probe(struct platform_device *pdev)
 
 	pm800_data = devm_kzalloc(&pdev->dev, sizeof(*pm800_data),
 					GFP_KERNEL);
-	if (!pm800_data) {
-		dev_err(&pdev->dev, "Failed to allocate pm800_regualtors");
+	if (!pm800_data)
 		return -ENOMEM;
-	}
 
 	pm800_data->map = chip->subchip->regmap_power;
 	pm800_data->chip = chip;
diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 4f6c205..087ce19 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -189,10 +189,8 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 	int ret;
 
 	ldo1 = devm_kzalloc(&pdev->dev, sizeof(*ldo1), GFP_KERNEL);
-	if (ldo1 == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (ldo1 == NULL)
 		return -ENOMEM;
-	}
 
 	ldo1->arizona = arizona;
 
diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index 724706a..b04b911 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -194,10 +194,8 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 	int ret;
 
 	micsupp = devm_kzalloc(&pdev->dev, sizeof(*micsupp), GFP_KERNEL);
-	if (micsupp == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (micsupp == NULL)
 		return -ENOMEM;
-	}
 
 	micsupp->arizona = arizona;
 	INIT_WORK(&micsupp->check_cp_work, arizona_micsupp_check_cp);
diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index fb27e6c..73a86b3 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -253,10 +253,8 @@ static int as3711_regulator_probe(struct platform_device *pdev)
 
 	regs = devm_kzalloc(&pdev->dev, AS3711_REGULATOR_NUM *
 			sizeof(struct as3711_regulator), GFP_KERNEL);
-	if (!regs) {
-		dev_err(&pdev->dev, "Memory allocation failed exiting..\n");
+	if (!regs)
 		return -ENOMEM;
-	}
 
 	for (id = 0, ri = as3711_reg_info; id < AS3711_REGULATOR_NUM; ++id, ri++) {
 		reg_data = pdata->init_data[id];
diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 3d910f4..2dba614 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -773,10 +773,8 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 	size = sizeof(struct da9063_regulators) +
 		n_regulators * sizeof(struct da9063_regulator);
 	regulators = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
-	if (!regulators) {
-		dev_err(&pdev->dev, "No memory for regulators\n");
+	if (!regulators)
 		return -ENOMEM;
-	}
 
 	regulators->n_regulators = n_regulators;
 	platform_set_drvdata(pdev, regulators);
diff --git a/drivers/regulator/da9210-regulator.c b/drivers/regulator/da9210-regulator.c
index f0fe54b..7add0a9 100644
--- a/drivers/regulator/da9210-regulator.c
+++ b/drivers/regulator/da9210-regulator.c
@@ -132,11 +132,8 @@ static int da9210_i2c_probe(struct i2c_client *i2c,
 	int error;
 
 	chip = devm_kzalloc(&i2c->dev, sizeof(struct da9210), GFP_KERNEL);
-	if (NULL == chip) {
-		dev_err(&i2c->dev,
-			"Cannot kzalloc memory for regulator structure\n");
+	if (NULL == chip)
 		return -ENOMEM;
-	}
 
 	chip->regmap = devm_regmap_init_i2c(i2c, &da9210_regmap_config);
 	if (IS_ERR(chip->regmap)) {
diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 7ca3d9e..5200a56 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -244,10 +244,9 @@ static int fan53555_regulator_probe(struct i2c_client *client,
 
 	di = devm_kzalloc(&client->dev, sizeof(struct fan53555_device_info),
 					GFP_KERNEL);
-	if (!di) {
-		dev_err(&client->dev, "Failed to allocate device info data!\n");
+	if (!di)
 		return -ENOMEM;
-	}
+
 	di->regmap = devm_regmap_init_i2c(client, &fan53555_regmap_config);
 	if (IS_ERR(di->regmap)) {
 		dev_err(&client->dev, "Failed to allocate regmap!\n");
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index de811f3..0b639ab 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -131,7 +131,6 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct fixed_voltage_data),
 			       GFP_KERNEL);
 	if (drvdata == NULL) {
-		dev_err(&pdev->dev, "Failed to allocate device data\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 98a98ff..fa970bd 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -233,10 +233,8 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct gpio_regulator_data),
 			       GFP_KERNEL);
-	if (drvdata == NULL) {
-		dev_err(&pdev->dev, "Failed to allocate device data\n");
+	if (drvdata == NULL)
 		return -ENOMEM;
-	}
 
 	drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
 	if (drvdata->desc.name == NULL) {
diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index ae001cc..c8fdb74 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -409,11 +409,8 @@ static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
 	pdata->num_regulators = ARRAY_SIZE(regulators);
 	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
 			     pdata->num_regulators, GFP_KERNEL);
-	if (!rdata) {
-		dev_err(&pdev->dev,
-			"could not allocate memory for regulator data\n");
+	if (!rdata)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < pdata->num_regulators; i++) {
 		rmatch.name = regulators[i].name;
diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 7f049c9..490140e 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -161,10 +161,8 @@ static int max8649_regulator_probe(struct i2c_client *client,
 
 	info = devm_kzalloc(&client->dev, sizeof(struct max8649_regulator_info),
 			    GFP_KERNEL);
-	if (!info) {
-		dev_err(&client->dev, "No enough memory\n");
+	if (!info)
 		return -ENOMEM;
-	}
 
 	info->regmap = devm_regmap_init_i2c(client, &max8649_regmap_config);
 	if (IS_ERR(info->regmap)) {
diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index 0c5fe6c..85065f0 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -292,10 +292,9 @@ static int max8907_regulator_probe(struct platform_device *pdev)
 		return ret;
 
 	pmic = devm_kzalloc(&pdev->dev, sizeof(*pmic), GFP_KERNEL);
-	if (!pmic) {
-		dev_err(&pdev->dev, "Failed to alloc pmic\n");
+	if (!pmic)
 		return -ENOMEM;
-	}
+
 	platform_set_drvdata(pdev, pmic);
 
 	memcpy(pmic->desc, max8907_regulators, sizeof(pmic->desc));
diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 788e5ae..66e7779 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -144,10 +144,8 @@ static struct max8952_platform_data *max8952_parse_dt(struct device *dev)
 	int i;
 
 	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		dev_err(dev, "Failed to allocate platform data\n");
+	if (!pd)
 		return NULL;
-	}
 
 	pd->gpio_vid0 = of_get_named_gpio(np, "max8952,vid-gpios", 0);
 	pd->gpio_vid1 = of_get_named_gpio(np, "max8952,vid-gpios", 1);
diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index 892aa1e..79f57fe 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -379,10 +379,8 @@ static int max8973_probe(struct i2c_client *client,
 	}
 
 	max = devm_kzalloc(&client->dev, sizeof(*max), GFP_KERNEL);
-	if (!max) {
-		dev_err(&client->dev, "Memory allocation for max failed\n");
+	if (!max)
 		return -ENOMEM;
-	}
 
 	max->regmap = devm_regmap_init_i2c(client, &max8973_regmap_config);
 	if (IS_ERR(max->regmap)) {
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index bcd2488..271e841 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -936,7 +936,6 @@ static int max8997_pmic_dt_parse_pdata(struct platform_device *pdev,
 				pdata->num_regulators, GFP_KERNEL);
 	if (!rdata) {
 		of_node_put(regulators_np);
-		dev_err(&pdev->dev, "could not allocate memory for regulator data\n");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index b58affb..9811b21 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -135,11 +135,8 @@ static int rc5t583_regulator_probe(struct platform_device *pdev)
 
 	regs = devm_kzalloc(&pdev->dev, RC5T583_REGULATOR_MAX *
 			sizeof(struct rc5t583_regulator), GFP_KERNEL);
-	if (!regs) {
-		dev_err(&pdev->dev, "Memory allocation failed exiting..\n");
+	if (!regs)
 		return -ENOMEM;
-	}
-
 
 	for (id = 0; id < RC5T583_REGULATOR_MAX; ++id) {
 		reg_data = pdata->reg_init_data[id];
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 2297fdf..48abe00 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -541,19 +541,13 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 
 	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
 				pdata->num_regulators, GFP_KERNEL);
-	if (!rdata) {
-		dev_err(iodev->dev,
-			"could not allocate memory for regulator data\n");
+	if (!rdata)
 		return -ENOMEM;
-	}
 
 	rmode = devm_kzalloc(&pdev->dev, sizeof(*rmode) *
 				pdata->num_regulators, GFP_KERNEL);
-	if (!rmode) {
-		dev_err(iodev->dev,
-			"could not allocate memory for regulator mode\n");
+	if (!rmode)
 		return -ENOMEM;
-	}
 
 	pdata->regulators = rdata;
 	pdata->opmode = rmode;
diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index 8c2a819..a41fa9e 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -530,20 +530,15 @@ static int ti_abb_init_table(struct device *dev, struct ti_abb *abb,
 	num_entries /= num_values;
 
 	info = devm_kzalloc(dev, sizeof(*info) * num_entries, GFP_KERNEL);
-	if (!info) {
-		dev_err(dev, "Can't allocate info table for '%s' property\n",
-			pname);
+	if (!info)
 		return -ENOMEM;
-	}
+
 	abb->info = info;
 
 	volt_table = devm_kzalloc(dev, sizeof(unsigned int) * num_entries,
 				  GFP_KERNEL);
-	if (!volt_table) {
-		dev_err(dev, "Can't allocate voltage table for '%s' property\n",
-			pname);
+	if (!volt_table)
 		return -ENOMEM;
-	}
 
 	abb->rdesc.n_voltages = num_entries;
 	abb->rdesc.volt_table = volt_table;
diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index b0a3f09..fd69aaf 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -227,10 +227,8 @@ static struct tps51632_regulator_platform_data *
 	struct device_node *np = dev->of_node;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "Memory alloc failed for platform data\n");
+	if (!pdata)
 		return NULL;
-	}
 
 	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node);
 	if (!pdata->reg_init_data) {
@@ -299,10 +297,8 @@ static int tps51632_probe(struct i2c_client *client,
 	}
 
 	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
-	if (!tps) {
-		dev_err(&client->dev, "Memory allocation failed\n");
+	if (!tps)
 		return -ENOMEM;
-	}
 
 	tps->dev = &client->dev;
 	tps->desc.name = id->name;
diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index c2c0185..6eb591e 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -299,10 +299,8 @@ static struct tps62360_regulator_platform_data *
 	struct device_node *np = dev->of_node;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "Memory alloc failed for platform data\n");
+	if (!pdata)
 		return NULL;
-	}
 
 	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node);
 	if (!pdata->reg_init_data) {
@@ -377,11 +375,8 @@ static int tps62360_probe(struct i2c_client *client,
 	}
 
 	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
-	if (!tps) {
-		dev_err(&client->dev, "%s(): Memory allocation failed\n",
-						__func__);
+	if (!tps)
 		return -ENOMEM;
-	}
 
 	tps->en_discharge = pdata->en_discharge;
 	tps->en_internal_pulldn = pdata->en_internal_pulldn;
diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 162a0fa..0e5338c 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -381,10 +381,8 @@ static struct tps6507x_board *tps6507x_parse_dt_reg_data(
 
 	tps_board = devm_kzalloc(&pdev->dev, sizeof(*tps_board),
 					GFP_KERNEL);
-	if (!tps_board) {
-		dev_err(&pdev->dev, "Failure to alloc pdata for regulators.\n");
+	if (!tps_board)
 		return NULL;
-	}
 
 	regulators = of_find_node_by_name(np, "regulators");
 	if (!regulators) {
@@ -406,10 +404,8 @@ static struct tps6507x_board *tps6507x_parse_dt_reg_data(
 
 	reg_data = devm_kzalloc(&pdev->dev, (sizeof(struct regulator_init_data)
 					* TPS6507X_NUM_REGULATOR), GFP_KERNEL);
-	if (!reg_data) {
-		dev_err(&pdev->dev, "Failure to alloc init data for regulators.\n");
+	if (!reg_data)
 		return NULL;
-	}
 
 	tps_board->tps6507x_pmic_init_data = reg_data;
 
diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index bd611cdf..938653a 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -168,17 +168,13 @@ static struct tps65090_platform_data *tps65090_parse_dt_reg_data(
 
 	tps65090_pdata = devm_kzalloc(&pdev->dev, sizeof(*tps65090_pdata),
 				GFP_KERNEL);
-	if (!tps65090_pdata) {
-		dev_err(&pdev->dev, "Memory alloc for tps65090_pdata failed\n");
+	if (!tps65090_pdata)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	reg_pdata = devm_kzalloc(&pdev->dev, TPS65090_REGULATOR_MAX *
 				sizeof(*reg_pdata), GFP_KERNEL);
-	if (!reg_pdata) {
-		dev_err(&pdev->dev, "Memory alloc for reg_pdata failed\n");
+	if (!reg_pdata)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	regulators = of_find_node_by_name(np, "regulators");
 	if (!regulators) {
@@ -252,10 +248,8 @@ static int tps65090_regulator_probe(struct platform_device *pdev)
 
 	pmic = devm_kzalloc(&pdev->dev, TPS65090_REGULATOR_MAX * sizeof(*pmic),
 			GFP_KERNEL);
-	if (!pmic) {
-		dev_err(&pdev->dev, "mem alloc for pmic failed\n");
+	if (!pmic)
 		return -ENOMEM;
-	}
 
 	for (num = 0; num < TPS65090_REGULATOR_MAX; num++) {
 		tps_pdata = tps65090_pdata->reg_pdata[num];
diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 8b9ee39..2b990b6 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -607,10 +607,9 @@ static int pmic_probe(struct spi_device *spi)
 	}
 
 	hw = devm_kzalloc(&spi->dev, sizeof(struct tps6524x), GFP_KERNEL);
-	if (!hw) {
-		dev_err(dev, "cannot allocate regulator private data\n");
+	if (!hw)
 		return -ENOMEM;
-	}
+
 	spi_set_drvdata(spi, hw);
 
 	memset(hw, 0, sizeof(struct tps6524x));
diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 45e5d68..cab9cb3 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -312,10 +312,8 @@ static struct tps6586x_platform_data *tps6586x_parse_regulator_dt(
 	}
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(&pdev->dev, "Memory alloction failed\n");
+	if (!pdata)
 		return NULL;
-	}
 
 	for (i = 0; i < num; i++) {
 		int id;
@@ -368,10 +366,8 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 
 	rdev = devm_kzalloc(&pdev->dev, TPS6586X_ID_MAX_REGULATOR *
 				sizeof(*rdev), GFP_KERNEL);
-	if (!rdev) {
-		dev_err(&pdev->dev, "Mmemory alloc failed\n");
+	if (!rdev)
 		return -ENOMEM;
-	}
 
 	for (id = 0; id < TPS6586X_ID_MAX_REGULATOR; ++id) {
 		reg_data = pdata->reg_init_data[id];
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index b8167df..34b104f 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -975,11 +975,8 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 
 	pmic_plat_data = devm_kzalloc(&pdev->dev, sizeof(*pmic_plat_data),
 					GFP_KERNEL);
-
-	if (!pmic_plat_data) {
-		dev_err(&pdev->dev, "Failure to alloc pdata for regulators.\n");
+	if (!pmic_plat_data)
 		return NULL;
-	}
 
 	np = of_node_get(pdev->dev.parent->of_node);
 	regulators = of_find_node_by_name(np, "regulators");
@@ -1062,10 +1059,8 @@ static int tps65910_probe(struct platform_device *pdev)
 	}
 
 	pmic = devm_kzalloc(&pdev->dev, sizeof(*pmic), GFP_KERNEL);
-	if (!pmic) {
-		dev_err(&pdev->dev, "Memory allocation failed for pmic\n");
+	if (!pmic)
 		return -ENOMEM;
-	}
 
 	pmic->mfd = tps65910;
 	platform_set_drvdata(pdev, pmic);
@@ -1094,24 +1089,18 @@ static int tps65910_probe(struct platform_device *pdev)
 
 	pmic->desc = devm_kzalloc(&pdev->dev, pmic->num_regulators *
 			sizeof(struct regulator_desc), GFP_KERNEL);
-	if (!pmic->desc) {
-		dev_err(&pdev->dev, "Memory alloc fails for desc\n");
+	if (!pmic->desc)
 		return -ENOMEM;
-	}
 
 	pmic->info = devm_kzalloc(&pdev->dev, pmic->num_regulators *
 			sizeof(struct tps_info *), GFP_KERNEL);
-	if (!pmic->info) {
-		dev_err(&pdev->dev, "Memory alloc fails for info\n");
+	if (!pmic->info)
 		return -ENOMEM;
-	}
 
 	pmic->rdev = devm_kzalloc(&pdev->dev, pmic->num_regulators *
 			sizeof(struct regulator_dev *), GFP_KERNEL);
-	if (!pmic->rdev) {
-		dev_err(&pdev->dev, "Memory alloc fails for rdev\n");
+	if (!pmic->rdev)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < pmic->num_regulators && i < TPS65910_NUM_REGS;
 			i++, info++) {
diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
index 71f457a..ac88c98 100644
--- a/drivers/regulator/tps80031-regulator.c
+++ b/drivers/regulator/tps80031-regulator.c
@@ -693,10 +693,8 @@ static int tps80031_regulator_probe(struct platform_device *pdev)
 
 	pmic = devm_kzalloc(&pdev->dev,
 			TPS80031_REGULATOR_MAX * sizeof(*pmic), GFP_KERNEL);
-	if (!pmic) {
-		dev_err(&pdev->dev, "mem alloc for pmic failed\n");
+	if (!pmic)
 		return -ENOMEM;
-	}
 
 	for (num = 0; num < TPS80031_REGULATOR_MAX; ++num) {
 		tps_pdata = pdata->regulator_pdata[num];
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 6823e6f..b782843 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -469,10 +469,8 @@ static int wm831x_buckv_probe(struct platform_device *pdev)
 
 	dcdc = devm_kzalloc(&pdev->dev,  sizeof(struct wm831x_dcdc),
 			    GFP_KERNEL);
-	if (dcdc == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (dcdc == NULL)
 		return -ENOMEM;
-	}
 
 	dcdc->wm831x = wm831x;
 
@@ -622,10 +620,8 @@ static int wm831x_buckp_probe(struct platform_device *pdev)
 
 	dcdc = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_dcdc),
 			    GFP_KERNEL);
-	if (dcdc == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (dcdc == NULL)
 		return -ENOMEM;
-	}
 
 	dcdc->wm831x = wm831x;
 
@@ -752,10 +748,8 @@ static int wm831x_boostp_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	dcdc = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_dcdc), GFP_KERNEL);
-	if (dcdc == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (dcdc == NULL)
 		return -ENOMEM;
-	}
 
 	dcdc->wm831x = wm831x;
 
@@ -846,10 +840,8 @@ static int wm831x_epe_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Probing EPE%d\n", id + 1);
 
 	dcdc = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_dcdc), GFP_KERNEL);
-	if (dcdc == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (dcdc == NULL)
 		return -ENOMEM;
-	}
 
 	dcdc->wm831x = wm831x;
 
diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 0339b88..f5811e4 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -165,10 +165,8 @@ static int wm831x_isink_probe(struct platform_device *pdev)
 
 	isink = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_isink),
 			     GFP_KERNEL);
-	if (isink == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (isink == NULL)
 		return -ENOMEM;
-	}
 
 	isink->wm831x = wm831x;
 
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 482ebe8..b3acf9e 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -237,10 +237,8 @@ static int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
 	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_ldo), GFP_KERNEL);
-	if (ldo == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (ldo == NULL)
 		return -ENOMEM;
-	}
 
 	ldo->wm831x = wm831x;
 
@@ -451,10 +449,8 @@ static int wm831x_aldo_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
 	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_ldo), GFP_KERNEL);
-	if (ldo == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (ldo == NULL)
 		return -ENOMEM;
-	}
 
 	ldo->wm831x = wm831x;
 
@@ -598,10 +594,8 @@ static int wm831x_alive_ldo_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
 	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_ldo), GFP_KERNEL);
-	if (ldo == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (ldo == NULL)
 		return -ENOMEM;
-	}
 
 	ldo->wm831x = wm831x;
 
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 71c5911..7d63e19 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -134,10 +134,8 @@ static int wm8994_ldo_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
 	ldo = devm_kzalloc(&pdev->dev, sizeof(struct wm8994_ldo), GFP_KERNEL);
-	if (ldo == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate private data\n");
+	if (ldo == NULL)
 		return -ENOMEM;
-	}
 
 	ldo->wm8994 = wm8994;
 	ldo->supply = wm8994_ldo_consumer[id];
diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index 3161ab5..aee3387 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -204,10 +204,8 @@ static int __init at32_rtc_probe(struct platform_device *pdev)
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(struct rtc_at32ap700x),
 			   GFP_KERNEL);
-	if (!rtc) {
-		dev_dbg(&pdev->dev, "out of memory\n");
+	if (!rtc)
 		return -ENOMEM;
-	}
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs) {
diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 24677ef8..1f3495e 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -486,10 +486,8 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 	int ret = 0;
 
 	davinci_rtc = devm_kzalloc(&pdev->dev, sizeof(struct davinci_rtc), GFP_KERNEL);
-	if (!davinci_rtc) {
-		dev_dbg(dev, "could not allocate memory for private data\n");
+	if (!davinci_rtc)
 		return -ENOMEM;
-	}
 
 	davinci_rtc->irq = platform_get_irq(pdev, 0);
 	if (davinci_rtc->irq < 0) {
diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index be9d8c0..e67bfcb 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -132,10 +132,9 @@ static int ds1390_probe(struct spi_device *spi)
 	spi_setup(spi);
 
 	chip = devm_kzalloc(&spi->dev, sizeof(*chip), GFP_KERNEL);
-	if (!chip) {
-		dev_err(&spi->dev, "unable to allocate device memory\n");
+	if (!chip)
 		return -ENOMEM;
-	}
+
 	spi_set_drvdata(spi, chip);
 
 	res = ds1390_get_reg(&spi->dev, DS1390_REG_SECONDS, &tmp);
diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
index bfdbcb8..f130c08 100644
--- a/drivers/rtc/rtc-lpc32xx.c
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -211,10 +211,9 @@ static int lpc32xx_rtc_probe(struct platform_device *pdev)
 	}
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
-	if (unlikely(!rtc)) {
-		dev_err(&pdev->dev, "Can't allocate memory\n");
+	if (unlikely(!rtc))
 		return -ENOMEM;
-	}
+
 	rtc->irq = rtcirq;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/drivers/rtc/rtc-moxart.c b/drivers/rtc/rtc-moxart.c
index c29dee0..c318462 100644
--- a/drivers/rtc/rtc-moxart.c
+++ b/drivers/rtc/rtc-moxart.c
@@ -247,10 +247,8 @@ static int moxart_rtc_probe(struct platform_device *pdev)
 	int ret = 0;
 
 	moxart_rtc = devm_kzalloc(&pdev->dev, sizeof(*moxart_rtc), GFP_KERNEL);
-	if (!moxart_rtc) {
-		dev_err(&pdev->dev, "devm_kzalloc failed\n");
+	if (!moxart_rtc)
 		return -ENOMEM;
-	}
 
 	moxart_rtc->gpio_data = of_get_named_gpio(pdev->dev.of_node,
 						  "gpio-rtc-data", 0);
diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index 248653c..a53da09 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -229,10 +229,9 @@ static int __init nuc900_rtc_probe(struct platform_device *pdev)
 
 	nuc900_rtc = devm_kzalloc(&pdev->dev, sizeof(struct nuc900_rtc),
 				GFP_KERNEL);
-	if (!nuc900_rtc) {
-		dev_err(&pdev->dev, "kzalloc nuc900_rtc failed\n");
+	if (!nuc900_rtc)
 		return -ENOMEM;
-	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	nuc900_rtc->rtc_reg = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(nuc900_rtc->rtc_reg))
diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 03f8f75..bd76ffe 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -396,10 +396,8 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 		rtc_write_enable = pdata->rtc_write_enable;
 
 	rtc_dd = devm_kzalloc(&pdev->dev, sizeof(*rtc_dd), GFP_KERNEL);
-	if (rtc_dd == NULL) {
-		dev_err(&pdev->dev, "Unable to allocate memory!\n");
+	if (rtc_dd == NULL)
 		return -ENOMEM;
-	}
 
 	/* Initialise spinlock to protect RTC control register */
 	spin_lock_init(&rtc_dd->ctrl_reg_lock);
diff --git a/drivers/rtc/rtc-rx8025.c b/drivers/rtc/rtc-rx8025.c
index 8fa23ea..e6298e0 100644
--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -551,7 +551,6 @@ static int rx8025_probe(struct i2c_client *client,
 
 	rx8025 = devm_kzalloc(&client->dev, sizeof(*rx8025), GFP_KERNEL);
 	if (!rx8025) {
-		dev_err(&adapter->dev, "failed to alloc memory\n");
 		err = -ENOMEM;
 		goto errout;
 	}
diff --git a/drivers/rtc/rtc-sirfsoc.c b/drivers/rtc/rtc-sirfsoc.c
index de132b4..d5057e3 100644
--- a/drivers/rtc/rtc-sirfsoc.c
+++ b/drivers/rtc/rtc-sirfsoc.c
@@ -264,12 +264,8 @@ static int sirfsoc_rtc_probe(struct platform_device *pdev)
 
 	rtcdrv = devm_kzalloc(&pdev->dev,
 		sizeof(struct sirfsoc_rtc_drv), GFP_KERNEL);
-	if (rtcdrv == NULL) {
-		dev_err(&pdev->dev,
-			"%s: can't alloc mem for drv struct\n",
-			pdev->name);
+	if (rtcdrv == NULL)
 		return -ENOMEM;
-	}
 
 	err = of_property_read_u32(np, "reg", &rtcdrv->rtc_base);
 	if (err) {
diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index c492cf0..d2cdb98 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -365,10 +365,8 @@ static int spear_rtc_probe(struct platform_device *pdev)
 	}
 
 	config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
-	if (!config) {
-		dev_err(&pdev->dev, "out of memory\n");
+	if (!config)
 		return -ENOMEM;
-	}
 
 	/* alarm irqs */
 	irq = platform_get_irq(pdev, 0);
diff --git a/drivers/scsi/isci/probe_roms.c b/drivers/scsi/isci/probe_roms.c
index 8ac646e..2f4ecd4 100644
--- a/drivers/scsi/isci/probe_roms.c
+++ b/drivers/scsi/isci/probe_roms.c
@@ -53,11 +53,8 @@ struct isci_orom *isci_request_oprom(struct pci_dev *pdev)
 
 	len = pci_biosrom_size(pdev);
 	rom = devm_kzalloc(&pdev->dev, sizeof(*rom), GFP_KERNEL);
-	if (!rom) {
-		dev_warn(&pdev->dev,
-			 "Unable to allocate memory for orom\n");
+	if (!rom)
 		return NULL;
-	}
 
 	for (i = 0; i < len && rom; i += ISCI_OEM_SIG_SIZE) {
 		memcpy_fromio(oem_sig, oprom + i, ISCI_OEM_SIG_SIZE);
@@ -176,11 +173,8 @@ struct isci_orom *isci_get_efi_var(struct pci_dev *pdev)
 
 	data_len = 1024;
 	efi_data = devm_kzalloc(&pdev->dev, data_len, GFP_KERNEL);
-	if (!efi_data) {
-		dev_warn(&pdev->dev,
-			 "Unable to allocate memory for EFI data\n");
+	if (!efi_data)
 		return NULL;
-	}
 
 	rom = (struct isci_orom *)(efi_data + sizeof(struct isci_oem_hdr));
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 04884d6..9790c83 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1303,10 +1303,9 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	hba->lrb = devm_kzalloc(hba->dev,
 				hba->nutrs * sizeof(struct ufshcd_lrb),
 				GFP_KERNEL);
-	if (!hba->lrb) {
-		dev_err(hba->dev, "LRB Memory allocation failed\n");
+	if (!hba->lrb)
 		goto out;
-	}
+
 	return 0;
 out:
 	return -ENOMEM;
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index c13d523..6f35aa7 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2051,10 +2051,8 @@ pl022_platform_data_dt_get(struct device *dev)
 	}
 
 	pd = devm_kzalloc(dev, sizeof(struct pl022_ssp_controller), GFP_KERNEL);
-	if (!pd) {
-		dev_err(dev, "cannot allocate platform data memory\n");
+	if (!pd)
 		return NULL;
-	}
 
 	pd->bus_id = -1;
 	pd->enable_dma = 1;
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index c1a5067..46618c2 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1042,11 +1042,8 @@ pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
 		return NULL;
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(&pdev->dev,
-			"failed to allocate memory for platform data\n");
+	if (!pdata)
 		return NULL;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 84cc6ac..a555d48 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1225,10 +1225,8 @@ static struct s3c64xx_spi_info *s3c64xx_spi_parse_dt(struct device *dev)
 	u32 temp;
 
 	sci = devm_kzalloc(dev, sizeof(*sci), GFP_KERNEL);
-	if (!sci) {
-		dev_err(dev, "memory allocation for spi_info failed\n");
+	if (!sci)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	if (of_property_read_u32(dev->of_node, "samsung,spi-src-clk", &temp)) {
 		dev_warn(dev, "spi bus clock parent not specified, using clock at index 0 as parent\n");
diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 2a95435..d2e3732 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -601,10 +601,8 @@ static struct sh_msiof_spi_info *sh_msiof_spi_parse_dt(struct device *dev)
 	u32 num_cs = 0;
 
 	info = devm_kzalloc(dev, sizeof(struct sh_msiof_spi_info), GFP_KERNEL);
-	if (!info) {
-		dev_err(dev, "failed to allocate setup data\n");
+	if (!info)
 		return NULL;
-	}
 
 	/* Parse the MSIOF properties */
 	of_property_read_u32(np, "num-cs", &num_cs);
diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 5a5c639..bdd2ca7 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -808,10 +808,9 @@ static int tegra_nvec_probe(struct platform_device *pdev)
 	}
 
 	nvec = devm_kzalloc(&pdev->dev, sizeof(struct nvec_chip), GFP_KERNEL);
-	if (nvec == NULL) {
-		dev_err(&pdev->dev, "failed to reserve memory\n");
+	if (nvec == NULL)
 		return -ENOMEM;
-	}
+
 	platform_set_drvdata(pdev, nvec);
 	nvec->dev = &pdev->dev;
 
diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index 88f92e1..2ce697f 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -369,10 +369,8 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 	int idle = IDLE_INTERVAL;
 
 	common = devm_kzalloc(dev, sizeof(*common), GFP_KERNEL);
-	if (!common) {
-		dev_err(dev, "Could not allocate common\n");
+	if (!common)
 		return -ENOMEM;
-	}
 
 	INIT_LIST_HEAD(&common->head);
 	spin_lock_init(&common->lock);
@@ -418,7 +416,6 @@ static int rcar_thermal_probe(struct platform_device *pdev)
 
 		priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 		if (!priv) {
-			dev_err(dev, "Could not allocate priv\n");
 			ret = -ENOMEM;
 			goto error_unregister;
 		}
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index b43afda..a2ff3f0 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -603,10 +603,8 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 
 	data = devm_kzalloc(&pdev->dev, sizeof(struct exynos_tmu_data),
 					GFP_KERNEL);
-	if (!data) {
-		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(pdev, data);
 	mutex_init(&data->lock);
@@ -651,7 +649,6 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	sensor_conf = devm_kzalloc(&pdev->dev,
 				sizeof(struct thermal_sensor_conf), GFP_KERNEL);
 	if (!sensor_conf) {
-		dev_err(&pdev->dev, "Failed to allocate registration struct\n");
 		ret = -ENOMEM;
 		goto err_clk;
 	}
diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
index ab79ea4..1e2193f 100644
--- a/drivers/thermal/spear_thermal.c
+++ b/drivers/thermal/spear_thermal.c
@@ -113,10 +113,8 @@ static int spear_thermal_probe(struct platform_device *pdev)
 	}
 
 	stdev = devm_kzalloc(&pdev->dev, sizeof(*stdev), GFP_KERNEL);
-	if (!stdev) {
-		dev_err(&pdev->dev, "kzalloc fail\n");
+	if (!stdev)
 		return -ENOMEM;
-	}
 
 	/* Enable thermal sensor */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 74c0e34..9f9869f 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -1143,10 +1143,8 @@ static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 	}
 
 	bgp = devm_kzalloc(&pdev->dev, sizeof(*bgp), GFP_KERNEL);
-	if (!bgp) {
-		dev_err(&pdev->dev, "Unable to allocate mem for driver ref\n");
+	if (!bgp)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	of_id = of_match_device(of_ti_bandgap_match, &pdev->dev);
 	if (of_id)
@@ -1155,10 +1153,8 @@ static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 	/* register shadow for context save and restore */
 	bgp->regval = devm_kzalloc(&pdev->dev, sizeof(*bgp->regval) *
 				   bgp->conf->sensor_count, GFP_KERNEL);
-	if (!bgp) {
-		dev_err(&pdev->dev, "Unable to allocate mem for driver ref\n");
+	if (!bgp)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	i = 0;
 	do {
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 4f8b9af..7f31caf 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -280,10 +280,9 @@ static struct ti_thermal_data
 	struct ti_thermal_data *data;
 
 	data = devm_kzalloc(bgp->dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_err(bgp->dev, "kzalloc fail\n");
+	if (!data)
 		return NULL;
-	}
+
 	data->sensor_id = id;
 	data->bgp = bgp;
 	data->mode = THERMAL_DEVICE_ENABLED;
diff --git a/drivers/tty/serial/8250/8250_em.c b/drivers/tty/serial/8250/8250_em.c
index 5f3bba1..fa896f8 100644
--- a/drivers/tty/serial/8250/8250_em.c
+++ b/drivers/tty/serial/8250/8250_em.c
@@ -103,10 +103,8 @@ static int serial8250_em_probe(struct platform_device *pdev)
 	}
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "unable to allocate private data\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	priv->sclk = devm_clk_get(&pdev->dev, "sclk");
 	if (IS_ERR(priv->sclk)) {
diff --git a/drivers/tty/serial/clps711x.c b/drivers/tty/serial/clps711x.c
index 8d0b994..f0620f8 100644
--- a/drivers/tty/serial/clps711x.c
+++ b/drivers/tty/serial/clps711x.c
@@ -429,10 +429,9 @@ static int uart_clps711x_probe(struct platform_device *pdev)
 	int ret, i;
 
 	s = devm_kzalloc(&pdev->dev, sizeof(struct clps711x_port), GFP_KERNEL);
-	if (!s) {
-		dev_err(&pdev->dev, "Error allocating port structure\n");
+	if (!s)
 		return -ENOMEM;
-	}
+
 	platform_set_drvdata(pdev, s);
 
 	s->uart_clk = devm_clk_get(&pdev->dev, "uart");
diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index b2e707a..679d9b6 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1084,10 +1084,8 @@ static int max310x_probe(struct device *dev, int is_spi,
 	/* Alloc port structure */
 	s = devm_kzalloc(dev, sizeof(*s) +
 			 sizeof(struct max310x_one) * devtype->nr, GFP_KERNEL);
-	if (!s) {
-		dev_err(dev, "Error allocating port structure\n");
+	if (!s)
 		return -ENOMEM;
-	}
 
 	/* Check input frequency */
 	if ((pdata->driver_flags & MAX310X_EXT_CLK) &&
diff --git a/drivers/tty/serial/sccnxp.c b/drivers/tty/serial/sccnxp.c
index a447f71..829219d 100644
--- a/drivers/tty/serial/sccnxp.c
+++ b/drivers/tty/serial/sccnxp.c
@@ -867,10 +867,9 @@ static int sccnxp_probe(struct platform_device *pdev)
 		return PTR_ERR(membase);
 
 	s = devm_kzalloc(&pdev->dev, sizeof(struct sccnxp_port), GFP_KERNEL);
-	if (!s) {
-		dev_err(&pdev->dev, "Error allocating port structure\n");
+	if (!s)
 		return -ENOMEM;
-	}
+
 	platform_set_drvdata(pdev, s);
 
 	spin_lock_init(&s->lock);
diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 0489a2b..706b69d 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1286,10 +1286,8 @@ static int tegra_uart_probe(struct platform_device *pdev)
 	cdata = match->data;
 
 	tup = devm_kzalloc(&pdev->dev, sizeof(*tup), GFP_KERNEL);
-	if (!tup) {
-		dev_err(&pdev->dev, "Failed to allocate memory for tup\n");
+	if (!tup)
 		return -ENOMEM;
-	}
 
 	ret = tegra_uart_parse_dt(pdev, tup);
 	if (ret < 0)
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index d262c1f..d8bc0ba 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2471,10 +2471,8 @@ static struct plat_sci_port *sci_parse_dt(struct platform_device *pdev,
 	}
 
 	p = devm_kzalloc(&pdev->dev, sizeof(struct plat_sci_port), GFP_KERNEL);
-	if (!p) {
-		dev_err(&pdev->dev, "failed to allocate DT config data\n");
+	if (!p)
 		return NULL;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 7666931..34d46cf 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -114,10 +114,9 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 		/* alloc uioinfo for one device */
 		uioinfo = devm_kzalloc(&pdev->dev, sizeof(*uioinfo),
 				       GFP_KERNEL);
-		if (!uioinfo) {
-			dev_err(&pdev->dev, "unable to kmalloc\n");
+		if (!uioinfo)
 			return -ENOMEM;
-		}
+
 		uioinfo->name = pdev->dev.of_node->name;
 		uioinfo->version = "devicetree";
 		/* Multiple IRQs are not supported */
@@ -135,10 +134,8 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	}
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "unable to kmalloc\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	priv->uioinfo = uioinfo;
 	spin_lock_init(&priv->lock);
diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index be822a2..40a9929 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -84,10 +84,8 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 	int ret;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_err(&pdev->dev, "Failed to allocate ci_hdrc-imx data!\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	data->usbmisc_data = usbmisc_get_init_data(&pdev->dev);
 	if (IS_ERR(data->usbmisc_data))
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index c47a6b4..757a896 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -494,10 +494,8 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 
 	ci = devm_kzalloc(dev, sizeof(*ci), GFP_KERNEL);
-	if (!ci) {
-		dev_err(dev, "can't allocate device\n");
+	if (!ci)
 		return -ENOMEM;
-	}
 
 	ci->dev = dev;
 	ci->platdata = dev->platform_data;
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 09de131..2e52140 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1101,10 +1101,8 @@ static int usbtmc_probe(struct usb_interface *intf,
 	dev_dbg(&intf->dev, "%s called\n", __func__);
 
 	data = devm_kzalloc(&intf->dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_err(&intf->dev, "Unable to allocate kernel memory\n");
+	if (!data)
 		return -ENOMEM;
-	}
 
 	data->intf = intf;
 	data->id = id;
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 474162e..aefdb6f 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -174,10 +174,8 @@ static int dwc3_alloc_event_buffers(struct dwc3 *dwc, unsigned length)
 
 	dwc->ev_buffs = devm_kzalloc(dwc->dev, sizeof(*dwc->ev_buffs) * num,
 			GFP_KERNEL);
-	if (!dwc->ev_buffs) {
-		dev_err(dwc->dev, "can't allocate event buffers array\n");
+	if (!dwc->ev_buffs)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < num; i++) {
 		struct dwc3_event_buffer	*evt;
@@ -361,10 +359,9 @@ static int dwc3_probe(struct platform_device *pdev)
 	void			*mem;
 
 	mem = devm_kzalloc(dev, sizeof(*dwc) + DWC3_ALIGN_MASK, GFP_KERNEL);
-	if (!mem) {
-		dev_err(dev, "not enough memory\n");
+	if (!mem)
 		return -ENOMEM;
-	}
+
 	dwc = PTR_ALIGN(mem, DWC3_ALIGN_MASK + 1);
 	dwc->mem = mem;
 
diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 2f2e88a..05b0854 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -109,10 +109,8 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 	int			ret = -ENOMEM;
 
 	exynos = devm_kzalloc(dev, sizeof(*exynos), GFP_KERNEL);
-	if (!exynos) {
-		dev_err(dev, "not enough memory\n");
+	if (!exynos)
 		goto err1;
-	}
 
 	/*
 	 * Right now device-tree probed devices don't get dma_mask set.
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 7f7ea62..10b992d 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -418,10 +418,8 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	}
 
 	omap = devm_kzalloc(dev, sizeof(*omap), GFP_KERNEL);
-	if (!omap) {
-		dev_err(dev, "not enough memory\n");
+	if (!omap)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(pdev, omap);
 
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 31443ae..d02f0da 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -102,10 +102,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 	struct device		*dev = &pci->dev;
 
 	glue = devm_kzalloc(dev, sizeof(*glue), GFP_KERNEL);
-	if (!glue) {
-		dev_err(dev, "not enough memory\n");
+	if (!glue)
 		return -ENOMEM;
-	}
 
 	glue->dev = dev;
 
diff --git a/drivers/usb/gadget/bcm63xx_udc.c b/drivers/usb/gadget/bcm63xx_udc.c
index c58fcf1..491ccf2 100644
--- a/drivers/usb/gadget/bcm63xx_udc.c
+++ b/drivers/usb/gadget/bcm63xx_udc.c
@@ -2319,10 +2319,8 @@ static int bcm63xx_udc_probe(struct platform_device *pdev)
 	int rc = -ENOMEM, i, irq;
 
 	udc = devm_kzalloc(dev, sizeof(*udc), GFP_KERNEL);
-	if (!udc) {
-		dev_err(dev, "cannot allocate memory\n");
+	if (!udc)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(pdev, udc);
 	udc->dev = dev;
diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index 104cdbe..ebb3904 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -2112,10 +2112,8 @@ static int mv_udc_probe(struct platform_device *pdev)
 	}
 
 	udc = devm_kzalloc(&pdev->dev, sizeof(*udc), GFP_KERNEL);
-	if (udc == NULL) {
-		dev_err(&pdev->dev, "failed to allocate memory for udc\n");
+	if (udc == NULL)
 		return -ENOMEM;
-	}
 
 	udc->done = &release_done;
 	udc->pdata = dev_get_platdata(&pdev->dev);
@@ -2212,7 +2210,6 @@ static int mv_udc_probe(struct platform_device *pdev)
 	size = udc->max_eps * sizeof(struct mv_ep) *2;
 	udc->eps = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
 	if (udc->eps == NULL) {
-		dev_err(&pdev->dev, "allocate ep memory failed\n");
 		retval = -ENOMEM;
 		goto err_destroy_dma;
 	}
@@ -2221,7 +2218,6 @@ static int mv_udc_probe(struct platform_device *pdev)
 	udc->status_req = devm_kzalloc(&pdev->dev, sizeof(struct mv_req),
 					GFP_KERNEL);
 	if (!udc->status_req) {
-		dev_err(&pdev->dev, "allocate status_req memory failed\n");
 		retval = -ENOMEM;
 		goto err_destroy_dma;
 	}
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 6bddf1a..2c83fe4 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -3457,10 +3457,8 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	int i;
 
 	hsotg = devm_kzalloc(&pdev->dev, sizeof(struct s3c_hsotg), GFP_KERNEL);
-	if (!hsotg) {
-		dev_err(dev, "cannot get memory\n");
+	if (!hsotg)
 		return -ENOMEM;
-	}
 
 	phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
 	if (IS_ERR(phy)) {
diff --git a/drivers/usb/gadget/s3c-hsudc.c b/drivers/usb/gadget/s3c-hsudc.c
index 1a1a414..6070c78 100644
--- a/drivers/usb/gadget/s3c-hsudc.c
+++ b/drivers/usb/gadget/s3c-hsudc.c
@@ -1268,10 +1268,8 @@ static int s3c_hsudc_probe(struct platform_device *pdev)
 	hsudc = devm_kzalloc(&pdev->dev, sizeof(struct s3c_hsudc) +
 			sizeof(struct s3c_hsudc_ep) * pd->epnum,
 			GFP_KERNEL);
-	if (!hsudc) {
-		dev_err(dev, "cannot allocate memory\n");
+	if (!hsudc)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(pdev, dev);
 	hsudc->dev = dev;
diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
index 417c10d..d7880a7 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -153,7 +153,6 @@ static int mv_ehci_probe(struct platform_device *pdev)
 
 	ehci_mv = devm_kzalloc(&pdev->dev, sizeof(*ehci_mv), GFP_KERNEL);
 	if (ehci_mv == NULL) {
-		dev_err(&pdev->dev, "cannot allocate ehci_hcd_mv\n");
 		retval = -ENOMEM;
 		goto err_put_hcd;
 	}
diff --git a/drivers/usb/host/ehci-sh.c b/drivers/usb/host/ehci-sh.c
index dc899eb..bc914c7 100644
--- a/drivers/usb/host/ehci-sh.c
+++ b/drivers/usb/host/ehci-sh.c
@@ -126,7 +126,6 @@ static int ehci_hcd_sh_probe(struct platform_device *pdev)
 	priv = devm_kzalloc(&pdev->dev, sizeof(struct ehci_sh_priv),
 			    GFP_KERNEL);
 	if (!priv) {
-		dev_dbg(&pdev->dev, "error allocating priv data\n");
 		ret = -ENOMEM;
 		goto fail_request_resource;
 	}
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 78fa76d..3790770 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -430,7 +430,6 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	u_phy->otg = devm_kzalloc(&pdev->dev, sizeof(struct usb_otg),
 			     GFP_KERNEL);
 	if (!u_phy->otg) {
-		dev_err(&pdev->dev, "Failed to alloc memory for otg\n");
 		err = -ENOMEM;
 		goto cleanup_phy;
 	}
diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index a31641e..52c6296 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -260,10 +260,8 @@ static int usb3503_i2c_probe(struct i2c_client *i2c,
 	int err;
 
 	hub = devm_kzalloc(&i2c->dev, sizeof(struct usb3503), GFP_KERNEL);
-	if (!hub) {
-		dev_err(&i2c->dev, "private data alloc fail\n");
+	if (!hub)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(i2c, hub);
 	hub->regmap = devm_regmap_init_i2c(i2c, &usb3503_regmap_config);
@@ -282,10 +280,9 @@ static int usb3503_platform_probe(struct platform_device *pdev)
 	struct usb3503 *hub;
 
 	hub = devm_kzalloc(&pdev->dev, sizeof(struct usb3503), GFP_KERNEL);
-	if (!hub) {
-		dev_err(&pdev->dev, "private data alloc fail\n");
+	if (!hub)
 		return -ENOMEM;
-	}
+
 	hub->dev = &pdev->dev;
 
 	return usb3503_probe(hub);
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 4047cbb..1926091 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -496,7 +496,6 @@ static int dsps_create_musb_pdev(struct dsps_glue *glue,
 
 	config = devm_kzalloc(&parent->dev, sizeof(*config), GFP_KERNEL);
 	if (!config) {
-		dev_err(dev, "failed to allocate musb hdrc config\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 59d2245..9a36c75 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -491,10 +491,8 @@ static int omap2430_probe(struct platform_device *pdev)
 	int				ret = -ENOMEM;
 
 	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
-	if (!glue) {
-		dev_err(&pdev->dev, "failed to allocate glue context\n");
+	if (!glue)
 		goto err0;
-	}
 
 	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
 	if (!musb) {
@@ -512,25 +510,16 @@ static int omap2430_probe(struct platform_device *pdev)
 
 	if (np) {
 		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-		if (!pdata) {
-			dev_err(&pdev->dev,
-				"failed to allocate musb platform data\n");
+		if (!pdata)
 			goto err2;
-		}
 
 		data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-		if (!data) {
-			dev_err(&pdev->dev,
-				"failed to allocate musb board data\n");
+		if (!data)
 			goto err2;
-		}
 
 		config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
-		if (!config) {
-			dev_err(&pdev->dev,
-				"failed to allocate musb hdrc config\n");
+		if (!config)
 			goto err2;
-		}
 
 		of_property_read_u32(np, "mode", (u32 *)&pdata->mode);
 		of_property_read_u32(np, "interface-type",
diff --git a/drivers/usb/phy/phy-am335x-control.c b/drivers/usb/phy/phy-am335x-control.c
index 22cf07d..d57e1aa 100644
--- a/drivers/usb/phy/phy-am335x-control.c
+++ b/drivers/usb/phy/phy-am335x-control.c
@@ -106,10 +106,8 @@ static int am335x_control_usb_probe(struct platform_device *pdev)
 	phy_ctrl = of_id->data;
 
 	ctrl_usb = devm_kzalloc(&pdev->dev, sizeof(*ctrl_usb), GFP_KERNEL);
-	if (!ctrl_usb) {
-		dev_err(&pdev->dev, "unable to alloc memory for control usb\n");
+	if (!ctrl_usb)
 		return -ENOMEM;
-	}
 
 	ctrl_usb->dev = &pdev->dev;
 
diff --git a/drivers/usb/phy/phy-mv-usb.c b/drivers/usb/phy/phy-mv-usb.c
index 98f6ac6a..c085eea 100644
--- a/drivers/usb/phy/phy-mv-usb.c
+++ b/drivers/usb/phy/phy-mv-usb.c
@@ -685,10 +685,8 @@ static int mv_otg_probe(struct platform_device *pdev)
 	}
 
 	mvotg = devm_kzalloc(&pdev->dev, sizeof(*mvotg), GFP_KERNEL);
-	if (!mvotg) {
-		dev_err(&pdev->dev, "failed to allocate memory!\n");
+	if (!mvotg)
 		return -ENOMEM;
-	}
 
 	otg = devm_kzalloc(&pdev->dev, sizeof(*otg), GFP_KERNEL);
 	if (!otg)
diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
index fdd33b4..fc991e6 100644
--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@ -145,10 +145,8 @@ static int mxs_phy_probe(struct platform_device *pdev)
 	}
 
 	mxs_phy = devm_kzalloc(&pdev->dev, sizeof(*mxs_phy), GFP_KERNEL);
-	if (!mxs_phy) {
-		dev_err(&pdev->dev, "Failed to allocate USB PHY structure!\n");
+	if (!mxs_phy)
 		return -ENOMEM;
-	}
 
 	mxs_phy->phy.io_priv		= base;
 	mxs_phy->phy.dev		= &pdev->dev;
diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/usb/phy/phy-omap-control.c
index a4dda8e..baa0927 100644
--- a/drivers/usb/phy/phy-omap-control.c
+++ b/drivers/usb/phy/phy-omap-control.c
@@ -202,10 +202,8 @@ static int omap_control_usb_probe(struct platform_device *pdev)
 
 	control_usb = devm_kzalloc(&pdev->dev, sizeof(*control_usb),
 		GFP_KERNEL);
-	if (!control_usb) {
-		dev_err(&pdev->dev, "unable to alloc memory for control usb\n");
+	if (!control_usb)
 		return -ENOMEM;
-	}
 
 	if (np) {
 		of_property_read_u32(np, "ti,type", &control_usb->type);
diff --git a/drivers/usb/phy/phy-omap-usb2.c b/drivers/usb/phy/phy-omap-usb2.c
index d266861..45afaad 100644
--- a/drivers/usb/phy/phy-omap-usb2.c
+++ b/drivers/usb/phy/phy-omap-usb2.c
@@ -124,16 +124,12 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	struct usb_otg			*otg;
 
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
-	if (!phy) {
-		dev_err(&pdev->dev, "unable to allocate memory for USB2 PHY\n");
+	if (!phy)
 		return -ENOMEM;
-	}
 
 	otg = devm_kzalloc(&pdev->dev, sizeof(*otg), GFP_KERNEL);
-	if (!otg) {
-		dev_err(&pdev->dev, "unable to allocate memory for USB OTG\n");
+	if (!otg)
 		return -ENOMEM;
-	}
 
 	phy->dev		= &pdev->dev;
 
diff --git a/drivers/usb/phy/phy-omap-usb3.c b/drivers/usb/phy/phy-omap-usb3.c
index 4e8a040..cd0c1b0 100644
--- a/drivers/usb/phy/phy-omap-usb3.c
+++ b/drivers/usb/phy/phy-omap-usb3.c
@@ -200,10 +200,8 @@ static int omap_usb3_probe(struct platform_device *pdev)
 	struct resource			*res;
 
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
-	if (!phy) {
-		dev_err(&pdev->dev, "unable to alloc mem for OMAP USB3 PHY\n");
+	if (!phy)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "pll_ctrl");
 	phy->pll_ctrl_base = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/usb/phy/phy-rcar-usb.c b/drivers/usb/phy/phy-rcar-usb.c
index 33265a5..4879596 100644
--- a/drivers/usb/phy/phy-rcar-usb.c
+++ b/drivers/usb/phy/phy-rcar-usb.c
@@ -202,10 +202,8 @@ static int rcar_usb_phy_probe(struct platform_device *pdev)
 	}
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(dev, "priv data allocation error\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	priv->reg0		= reg0;
 	priv->reg1		= reg1;
diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index e9cb1cb..77eab4b 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -883,11 +883,8 @@ static int utmi_phy_probe(struct tegra_usb_phy *tegra_phy,
 
 	tegra_phy->config = devm_kzalloc(&pdev->dev,
 		sizeof(*tegra_phy->config), GFP_KERNEL);
-	if (!tegra_phy->config) {
-		dev_err(&pdev->dev,
-			"unable to allocate memory for USB UTMIP config\n");
+	if (!tegra_phy->config)
 		return -ENOMEM;
-	}
 
 	config = tegra_phy->config;
 
@@ -982,10 +979,8 @@ static int tegra_usb_phy_probe(struct platform_device *pdev)
 	int err;
 
 	tegra_phy = devm_kzalloc(&pdev->dev, sizeof(*tegra_phy), GFP_KERNEL);
-	if (!tegra_phy) {
-		dev_err(&pdev->dev, "unable to allocate memory for USB2 PHY\n");
+	if (!tegra_phy)
 		return -ENOMEM;
-	}
 
 	match = of_match_device(tegra_usb_phy_id_table, &pdev->dev);
 	if (!match) {
diff --git a/drivers/usb/renesas_usbhs/common.c b/drivers/usb/renesas_usbhs/common.c
index 17267b0..a98227f 100644
--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -439,10 +439,8 @@ static int usbhs_probe(struct platform_device *pdev)
 
 	/* usb private data */
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "Could not allocate priv\n");
+	if (!priv)
 		return -ENOMEM;
-	}
 
 	priv->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->base))
diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
index 248abd5..73a4d3b 100644
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -463,10 +463,8 @@ static int au1100fb_drv_probe(struct platform_device *dev)
 	/* Allocate new device private */
 	fbdev = devm_kzalloc(&dev->dev, sizeof(struct au1100fb_device),
 			     GFP_KERNEL);
-	if (!fbdev) {
-		print_err("fail to allocate device private record");
+	if (!fbdev)
 		return -ENOMEM;
-	}
 
 	if (au1100fb_setup(fbdev))
 		goto failed;
diff --git a/drivers/video/auo_k190x.c b/drivers/video/auo_k190x.c
index 8d2499d..d72b6de 100644
--- a/drivers/video/auo_k190x.c
+++ b/drivers/video/auo_k190x.c
@@ -1083,7 +1083,6 @@ int auok190x_common_probe(struct platform_device *pdev,
 				     sizeof(struct fb_deferred_io),
 				     GFP_KERNEL);
 	if (!info->fbdefio) {
-		dev_err(info->device, "Failed to allocate memory\n");
 		ret = -ENOMEM;
 		goto err_defio;
 	}
diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
index ee0c0a9..ec5350f 100644
--- a/drivers/video/backlight/aat2870_bl.c
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -149,8 +149,6 @@ static int aat2870_bl_probe(struct platform_device *pdev)
 				  sizeof(struct aat2870_bl_driver_data),
 				  GFP_KERNEL);
 	if (!aat2870_bl) {
-		dev_err(&pdev->dev,
-			"Failed to allocate memory for aat2870 backlight\n");
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 9d65671..be8d83d 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -224,10 +224,8 @@ static int adp8860_led_probe(struct i2c_client *client)
 
 	led = devm_kzalloc(&client->dev, sizeof(*led) * pdata->num_leds,
 				GFP_KERNEL);
-	if (led == NULL) {
-		dev_err(&client->dev, "failed to alloc memory\n");
+	if (led == NULL)
 		return -ENOMEM;
-	}
 
 	ret = adp8860_write(client, ADP8860_ISCFR, pdata->led_fade_law);
 	ret = adp8860_write(client, ADP8860_ISCT1,
diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 6370720..251af4d 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -246,10 +246,8 @@ static int adp8870_led_probe(struct i2c_client *client)
 
 	led = devm_kzalloc(&client->dev, pdata->num_leds * sizeof(*led),
 				GFP_KERNEL);
-	if (led == NULL) {
-		dev_err(&client->dev, "failed to alloc memory\n");
+	if (led == NULL)
 		return -ENOMEM;
-	}
 
 	ret = adp8870_write(client, ADP8870_ISCLAW, pdata->led_fade_law);
 	if (ret)
diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index db8db5f..51d18d6 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -543,10 +543,8 @@ static int corgi_lcd_probe(struct spi_device *spi)
 	}
 
 	lcd = devm_kzalloc(&spi->dev, sizeof(struct corgi_lcd), GFP_KERNEL);
-	if (!lcd) {
-		dev_err(&spi->dev, "failed to allocate memory\n");
+	if (!lcd)
 		return -ENOMEM;
-	}
 
 	lcd->spi_dev = spi;
 
diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/hx8357.c
index 0d252e7..7843b81 100644
--- a/drivers/video/backlight/hx8357.c
+++ b/drivers/video/backlight/hx8357.c
@@ -587,10 +587,8 @@ static int hx8357_probe(struct spi_device *spi)
 	int i, ret;
 
 	lcd = devm_kzalloc(&spi->dev, sizeof(*lcd), GFP_KERNEL);
-	if (!lcd) {
-		dev_err(&spi->dev, "Couldn't allocate lcd internal structure!\n");
+	if (!lcd)
 		return -ENOMEM;
-	}
 
 	ret = spi_setup(spi);
 	if (ret < 0) {
diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
index 73464e4..ea67fe1 100644
--- a/drivers/video/backlight/ili922x.c
+++ b/drivers/video/backlight/ili922x.c
@@ -482,10 +482,8 @@ static int ili922x_probe(struct spi_device *spi)
 	u16 reg = 0;
 
 	ili = devm_kzalloc(&spi->dev, sizeof(*ili), GFP_KERNEL);
-	if (!ili) {
-		dev_err(&spi->dev, "cannot alloc priv data\n");
+	if (!ili)
 		return -ENOMEM;
-	}
 
 	ili->spi = spi;
 	spi_set_drvdata(spi, ili);
diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index e2b8b40..2cf39e6 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -219,10 +219,8 @@ int ili9320_probe_spi(struct spi_device *spi,
 	/* allocate and initialse our state */
 
 	ili = devm_kzalloc(&spi->dev, sizeof(struct ili9320), GFP_KERNEL);
-	if (ili == NULL) {
-		dev_err(dev, "no memory for device\n");
+	if (ili == NULL)
 		return -ENOMEM;
-	}
 
 	ili->access.spi.id = ILI9320_SPI_IDCODE | ILI9320_SPI_ID(1);
 
diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index b5fc13b..3c96391 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -181,11 +181,8 @@ static int l4f00242t03_probe(struct spi_device *spi)
 
 	priv = devm_kzalloc(&spi->dev, sizeof(struct l4f00242t03_priv),
 				GFP_KERNEL);
-
-	if (priv == NULL) {
-		dev_err(&spi->dev, "No memory for this device.\n");
+	if (priv == NULL)
 		return -ENOMEM;
-	}
 
 	spi_set_drvdata(spi, priv);
 	spi->bits_per_word = 9;
diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
index 187d1c2..cff1fbe 100644
--- a/drivers/video/backlight/lm3533_bl.c
+++ b/drivers/video/backlight/lm3533_bl.c
@@ -296,11 +296,8 @@ static int lm3533_bl_probe(struct platform_device *pdev)
 	}
 
 	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
-	if (!bl) {
-		dev_err(&pdev->dev,
-				"failed to allocate memory for backlight\n");
+	if (!bl)
 		return -ENOMEM;
-	}
 
 	bl->lm3533 = lm3533;
 	bl->id = pdev->id;
diff --git a/drivers/video/backlight/lms283gf05.c b/drivers/video/backlight/lms283gf05.c
index de88325..14590c5 100644
--- a/drivers/video/backlight/lms283gf05.c
+++ b/drivers/video/backlight/lms283gf05.c
@@ -168,10 +168,8 @@ static int lms283gf05_probe(struct spi_device *spi)
 
 	st = devm_kzalloc(&spi->dev, sizeof(struct lms283gf05_state),
 				GFP_KERNEL);
-	if (st == NULL) {
-		dev_err(&spi->dev, "No memory for device state\n");
+	if (st == NULL)
 		return -ENOMEM;
-	}
 
 	ld = devm_lcd_device_register(&spi->dev, "lms283gf05", &spi->dev, st,
 					&lms_ops);
diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index d01884d..c3d2e20 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -94,10 +94,8 @@ static int platform_lcd_probe(struct platform_device *pdev)
 
 	plcd = devm_kzalloc(&pdev->dev, sizeof(struct platform_lcd),
 			    GFP_KERNEL);
-	if (!plcd) {
-		dev_err(dev, "no memory for state\n");
+	if (!plcd)
 		return -ENOMEM;
-	}
 
 	plcd->us = dev;
 	plcd->pdata = pdata;
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 36db5d9..9cb0ac6 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -189,7 +189,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 
 	pb = devm_kzalloc(&pdev->dev, sizeof(*pb), GFP_KERNEL);
 	if (!pb) {
-		dev_err(&pdev->dev, "no memory for state\n");
 		ret = -ENOMEM;
 		goto err_alloc;
 	}
diff --git a/drivers/video/backlight/tps65217_bl.c b/drivers/video/backlight/tps65217_bl.c
index cbba37e..595dcf5 100644
--- a/drivers/video/backlight/tps65217_bl.c
+++ b/drivers/video/backlight/tps65217_bl.c
@@ -200,7 +200,6 @@ tps65217_bl_parse_dt(struct platform_device *pdev)
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata) {
-		dev_err(&pdev->dev, "failed to allocate platform data\n");
 		err = ERR_PTR(-ENOMEM);
 		goto err;
 	}
@@ -296,10 +295,8 @@ static int tps65217_bl_probe(struct platform_device *pdev)
 
 	tps65217_bl = devm_kzalloc(&pdev->dev, sizeof(*tps65217_bl),
 				GFP_KERNEL);
-	if (tps65217_bl == NULL) {
-		dev_err(&pdev->dev, "allocation of struct tps65217_bl failed\n");
+	if (tps65217_bl == NULL)
 		return -ENOMEM;
-	}
 
 	tps65217_bl->tps = tps;
 	tps65217_bl->dev = &pdev->dev;
diff --git a/drivers/video/bf537-lq035.c b/drivers/video/bf537-lq035.c
index a82d257..c05370b 100644
--- a/drivers/video/bf537-lq035.c
+++ b/drivers/video/bf537-lq035.c
@@ -764,7 +764,6 @@ static int bfin_lq035_probe(struct platform_device *pdev)
 						    sizeof(u32) * 16,
 						    GFP_KERNEL);
 	if (bfin_lq035_fb.pseudo_palette == NULL) {
-		pr_err("failed to allocate pseudo_palette\n");
 		ret = -ENOMEM;
 		goto out_table;
 	}
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 87f288b..cb4fec6 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -605,9 +605,6 @@ static int bfin_bf54x_probe(struct platform_device *pdev)
 	fbinfo->pseudo_palette = devm_kzalloc(&pdev->dev, sizeof(u32) * 16,
 					      GFP_KERNEL);
 	if (!fbinfo->pseudo_palette) {
-		printk(KERN_ERR DRIVER_NAME
-		       "Fail to allocate pseudo_palette\n");
-
 		ret = -ENOMEM;
 		goto out4;
 	}
diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index 12bbede..c418114 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -902,17 +902,14 @@ static struct exynos_dp_platdata *exynos_dp_dt_parse_pdata(struct device *dev)
 	struct video_info *dp_video_config;
 
 	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		dev_err(dev, "memory allocation for pdata failed\n");
+	if (!pd)
 		return ERR_PTR(-ENOMEM);
-	}
+
 	dp_video_config = devm_kzalloc(dev,
 				sizeof(*dp_video_config), GFP_KERNEL);
-
-	if (!dp_video_config) {
-		dev_err(dev, "memory allocation for video config failed\n");
+	if (!dp_video_config)
 		return ERR_PTR(-ENOMEM);
-	}
+
 	pd->video_info = dp_video_config;
 
 	dp_video_config->h_sync_polarity =
@@ -1050,10 +1047,8 @@ static int exynos_dp_probe(struct platform_device *pdev)
 
 	dp = devm_kzalloc(&pdev->dev, sizeof(struct exynos_dp_device),
 				GFP_KERNEL);
-	if (!dp) {
-		dev_err(&pdev->dev, "no memory for device data\n");
+	if (!dp)
 		return -ENOMEM;
-	}
 
 	dp->dev = &pdev->dev;
 
diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
index 32e5406..8fcb3a4 100644
--- a/drivers/video/exynos/exynos_mipi_dsi.c
+++ b/drivers/video/exynos/exynos_mipi_dsi.c
@@ -339,10 +339,8 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
 
 	dsim = devm_kzalloc(&pdev->dev, sizeof(struct mipi_dsim_device),
 				GFP_KERNEL);
-	if (!dsim) {
-		dev_err(&pdev->dev, "failed to allocate dsim object.\n");
+	if (!dsim)
 		return -ENOMEM;
-	}
 
 	dsim->pd = to_dsim_plat(pdev);
 	dsim->dev = &pdev->dev;
diff --git a/drivers/video/exynos/s6e8ax0.c b/drivers/video/exynos/s6e8ax0.c
index ca26024..9a67256 100644
--- a/drivers/video/exynos/s6e8ax0.c
+++ b/drivers/video/exynos/s6e8ax0.c
@@ -777,10 +777,8 @@ static int s6e8ax0_probe(struct mipi_dsim_lcd_device *dsim_dev)
 	u8 mtp_id[3] = {0, };
 
 	lcd = devm_kzalloc(&dsim_dev->dev, sizeof(struct s6e8ax0), GFP_KERNEL);
-	if (!lcd) {
-		dev_err(&dsim_dev->dev, "failed to allocate s6e8ax0 structure.\n");
+	if (!lcd)
 		return -ENOMEM;
-	}
 
 	lcd->dsim_dev = dsim_dev;
 	lcd->ddi_pd = (struct lcd_platform_data *)dsim_dev->platform_data;
diff --git a/drivers/video/omap2/dss/dispc.c b/drivers/video/omap2/dss/dispc.c
index 8fbeb29..96ce9e3 100644
--- a/drivers/video/omap2/dss/dispc.c
+++ b/drivers/video/omap2/dss/dispc.c
@@ -3605,10 +3605,8 @@ static int __init dispc_init_features(struct platform_device *pdev)
 	struct dispc_features *dst;
 
 	dst = devm_kzalloc(&pdev->dev, sizeof(*dst), GFP_KERNEL);
-	if (!dst) {
-		dev_err(&pdev->dev, "Failed to allocate DISPC Features\n");
+	if (!dst)
 		return -ENOMEM;
-	}
 
 	switch (omapdss_get_version()) {
 	case OMAPDSS_VER_OMAP24xx:
diff --git a/drivers/video/omap2/dss/dss.c b/drivers/video/omap2/dss/dss.c
index bd01608..91de79f 100644
--- a/drivers/video/omap2/dss/dss.c
+++ b/drivers/video/omap2/dss/dss.c
@@ -801,10 +801,8 @@ static int __init dss_init_features(struct platform_device *pdev)
 	struct dss_features *dst;
 
 	dst = devm_kzalloc(&pdev->dev, sizeof(*dst), GFP_KERNEL);
-	if (!dst) {
-		dev_err(&pdev->dev, "Failed to allocate local DSS Features\n");
+	if (!dst)
 		return -ENOMEM;
-	}
 
 	switch (omapdss_get_version()) {
 	case OMAPDSS_VER_OMAP24xx:
diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index 62acae2..3623f63 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -1385,10 +1385,8 @@ static int s3c_fb_probe(struct platform_device *pdev)
 	}
 
 	sfb = devm_kzalloc(dev, sizeof(struct s3c_fb), GFP_KERNEL);
-	if (!sfb) {
-		dev_err(dev, "no memory for framebuffers\n");
+	if (!sfb)
 		return -ENOMEM;
-	}
 
 	dev_dbg(dev, "allocate new framebuffer %p\n", sfb);
 
diff --git a/drivers/video/ssd1307fb.c b/drivers/video/ssd1307fb.c
index 44967c8..e98fdac 100644
--- a/drivers/video/ssd1307fb.c
+++ b/drivers/video/ssd1307fb.c
@@ -469,7 +469,6 @@ static int ssd1307fb_probe(struct i2c_client *client,
 
 	vmem = devm_kzalloc(&client->dev, vmem_size, GFP_KERNEL);
 	if (!vmem) {
-		dev_err(&client->dev, "Couldn't allocate graphical memory.\n");
 		ret = -ENOMEM;
 		goto fb_alloc_error;
 	}
diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
index 897484903..a6a3f29 100644
--- a/drivers/video/vt8500lcdfb.c
+++ b/drivers/video/vt8500lcdfb.c
@@ -292,7 +292,6 @@ static int vt8500lcd_probe(struct platform_device *pdev)
 	fbi = devm_kzalloc(&pdev->dev, sizeof(struct vt8500lcd_info)
 			+ sizeof(u32) * 16, GFP_KERNEL);
 	if (!fbi) {
-		dev_err(&pdev->dev, "Failed to initialize framebuffer device\n");
 		ret = -ENOMEM;
 		goto failed;
 	}
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 3072f30..571a126 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -276,10 +276,8 @@ static int wm8505fb_probe(struct platform_device *pdev)
 
 	fbi = devm_kzalloc(&pdev->dev, sizeof(struct wm8505fb_info) +
 			sizeof(u32) * 16, GFP_KERNEL);
-	if (!fbi) {
-		dev_err(&pdev->dev, "Failed to initialize framebuffer device\n");
+	if (!fbi)
 		return -ENOMEM;
-	}
 
 	strcpy(fbi->fb.fix.id, DRIVER_NAME);
 
diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 6e94d8dd..2f679b4 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -546,10 +546,8 @@ static int omap_hdq_probe(struct platform_device *pdev)
 	u8 rev;
 
 	hdq_data = devm_kzalloc(dev, sizeof(*hdq_data), GFP_KERNEL);
-	if (!hdq_data) {
-		dev_dbg(&pdev->dev, "unable to allocate memory\n");
+	if (!hdq_data)
 		return -ENOMEM;
-	}
 
 	hdq_data->dev = dev;
 	platform_set_drvdata(pdev, hdq_data);
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index b178e71..a4a01b9 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -323,10 +323,8 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 
 	wdt = devm_kzalloc(&pdev->dev, sizeof(struct wdt_at32ap700x),
 			GFP_KERNEL);
-	if (!wdt) {
-		dev_dbg(&pdev->dev, "no memory for wdt structure\n");
+	if (!wdt)
 		return -ENOMEM;
-	}
 
 	wdt->regs = devm_ioremap(&pdev->dev, regs->start, resource_size(regs));
 	if (!wdt->regs) {
diff --git a/drivers/watchdog/bcm2835_wdt.c b/drivers/watchdog/bcm2835_wdt.c
index 61566fc..1f14bba 100644
--- a/drivers/watchdog/bcm2835_wdt.c
+++ b/drivers/watchdog/bcm2835_wdt.c
@@ -115,10 +115,9 @@ static int bcm2835_wdt_probe(struct platform_device *pdev)
 	int err;
 
 	wdt = devm_kzalloc(dev, sizeof(struct bcm2835_wdt), GFP_KERNEL);
-	if (!wdt) {
-		dev_err(dev, "Failed to allocate memory for watchdog device");
+	if (!wdt)
 		return -ENOMEM;
-	}
+
 	platform_set_drvdata(pdev, wdt);
 
 	spin_lock_init(&wdt->lock);
diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
index f09c54e..2e95896 100644
--- a/drivers/watchdog/da9052_wdt.c
+++ b/drivers/watchdog/da9052_wdt.c
@@ -185,7 +185,6 @@ static int da9052_wdt_probe(struct platform_device *pdev)
 	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
 				   GFP_KERNEL);
 	if (!driver_data) {
-		dev_err(da9052->dev, "Unable to alloacate watchdog device\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/drivers/watchdog/da9055_wdt.c b/drivers/watchdog/da9055_wdt.c
index 575f37a..495089d 100644
--- a/drivers/watchdog/da9055_wdt.c
+++ b/drivers/watchdog/da9055_wdt.c
@@ -151,10 +151,8 @@ static int da9055_wdt_probe(struct platform_device *pdev)
 
 	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
 				   GFP_KERNEL);
-	if (!driver_data) {
-		dev_err(da9055->dev, "Failed to allocate watchdog device\n");
+	if (!driver_data)
 		return -ENOMEM;
-	}
 
 	driver_data->da9055 = da9055;
 
diff --git a/drivers/watchdog/jz4740_wdt.c b/drivers/watchdog/jz4740_wdt.c
index d1afdf6..b7029dc 100644
--- a/drivers/watchdog/jz4740_wdt.c
+++ b/drivers/watchdog/jz4740_wdt.c
@@ -153,10 +153,8 @@ static int jz4740_wdt_probe(struct platform_device *pdev)
 
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct jz4740_wdt_drvdata),
 			       GFP_KERNEL);
-	if (!drvdata) {
-		dev_err(&pdev->dev, "Unable to alloacate watchdog device\n");
+	if (!drvdata)
 		return -ENOMEM;
-	}
 
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index 58df98a..8b4817e 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -218,7 +218,6 @@ sp805_wdt_probe(struct amba_device *adev, const struct amba_id *id)
 
 	wdt = devm_kzalloc(&adev->dev, sizeof(*wdt), GFP_KERNEL);
 	if (!wdt) {
-		dev_warn(&adev->dev, "Kzalloc failed\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index 42913f1..8ceba29 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -397,10 +397,8 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	int error = 0;
 
 	wdt = devm_kzalloc(&pdev->dev, sizeof(struct ts72xx_wdt), GFP_KERNEL);
-	if (!wdt) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	if (!wdt)
 		return -ENOMEM;
-	}
 
 	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	wdt->control_reg = devm_ioremap_resource(&pdev->dev, r1);
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index d4e47ed..0621549 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -204,7 +204,6 @@ static int wm831x_wdt_probe(struct platform_device *pdev)
 	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
 				   GFP_KERNEL);
 	if (!driver_data) {
-		dev_err(wm831x->dev, "Unable to alloacate watchdog device\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/sound/soc/codecs/cs4270.c b/sound/soc/codecs/cs4270.c
index 83c835d..4a910d8 100644
--- a/sound/soc/codecs/cs4270.c
+++ b/sound/soc/codecs/cs4270.c
@@ -673,10 +673,8 @@ static int cs4270_i2c_probe(struct i2c_client *i2c_client,
 
 	cs4270 = devm_kzalloc(&i2c_client->dev, sizeof(struct cs4270_private),
 			      GFP_KERNEL);
-	if (!cs4270) {
-		dev_err(&i2c_client->dev, "could not allocate codec\n");
+	if (!cs4270)
 		return -ENOMEM;
-	}
 
 	/* get the power supply regulators */
 	for (i = 0; i < ARRAY_SIZE(supply_names); i++)
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 1e0fa3b..8480c44 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -578,10 +578,8 @@ static int cs42l51_i2c_probe(struct i2c_client *i2c_client,
 
 	cs42l51 = devm_kzalloc(&i2c_client->dev, sizeof(struct cs42l51_private),
 			       GFP_KERNEL);
-	if (!cs42l51) {
-		dev_err(&i2c_client->dev, "could not allocate codec\n");
+	if (!cs42l51)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(i2c_client, cs42l51);
 	cs42l51->control_type = SND_SOC_I2C;
diff --git a/sound/soc/codecs/cs42l73.c b/sound/soc/codecs/cs42l73.c
index 3b20c86..0ce2a27 100644
--- a/sound/soc/codecs/cs42l73.c
+++ b/sound/soc/codecs/cs42l73.c
@@ -1421,10 +1421,8 @@ static int cs42l73_i2c_probe(struct i2c_client *i2c_client,
 
 	cs42l73 = devm_kzalloc(&i2c_client->dev, sizeof(struct cs42l73_private),
 			       GFP_KERNEL);
-	if (!cs42l73) {
-		dev_err(&i2c_client->dev, "could not allocate codec\n");
+	if (!cs42l73)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(i2c_client, cs42l73);
 
diff --git a/sound/soc/codecs/sta529.c b/sound/soc/codecs/sta529.c
index 40c07be..7810be3 100644
--- a/sound/soc/codecs/sta529.c
+++ b/sound/soc/codecs/sta529.c
@@ -391,10 +391,8 @@ static int sta529_i2c_probe(struct i2c_client *i2c,
 		return -EINVAL;
 
 	sta529 = devm_kzalloc(&i2c->dev, sizeof(struct sta529), GFP_KERNEL);
-	if (sta529 == NULL) {
-		dev_err(&i2c->dev, "Can not allocate memory\n");
+	if (sta529 == NULL)
 		return -ENOMEM;
-	}
 
 	sta529->regmap = devm_regmap_init_i2c(i2c, &sta529_regmap);
 	if (IS_ERR(sta529->regmap)) {
diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index 892c108..fa0cde5 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -1439,10 +1439,8 @@ static int aic3x_i2c_probe(struct i2c_client *i2c,
 	u32 value;
 
 	aic3x = devm_kzalloc(&i2c->dev, sizeof(struct aic3x_priv), GFP_KERNEL);
-	if (aic3x == NULL) {
-		dev_err(&i2c->dev, "failed to create private data\n");
+	if (aic3x == NULL)
 		return -ENOMEM;
-	}
 
 	aic3x->regmap = devm_regmap_init_i2c(i2c, &aic3x_regmap);
 	if (IS_ERR(aic3x->regmap)) {
@@ -1460,10 +1458,8 @@ static int aic3x_i2c_probe(struct i2c_client *i2c,
 	} else if (np) {
 		ai3x_setup = devm_kzalloc(&i2c->dev, sizeof(*ai3x_setup),
 								GFP_KERNEL);
-		if (ai3x_setup == NULL) {
-			dev_err(&i2c->dev, "failed to create private data\n");
+		if (ai3x_setup == NULL)
 			return -ENOMEM;
-		}
 
 		ret = of_get_named_gpio(np, "gpio-reset", 0);
 		if (ret >= 0)
diff --git a/sound/soc/codecs/tpa6130a2.c b/sound/soc/codecs/tpa6130a2.c
index c58bee8..6ad65fb 100644
--- a/sound/soc/codecs/tpa6130a2.c
+++ b/sound/soc/codecs/tpa6130a2.c
@@ -377,10 +377,8 @@ static int tpa6130a2_probe(struct i2c_client *client,
 	}
 
 	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
-	if (data == NULL) {
-		dev_err(dev, "Can not allocate memory\n");
+	if (data == NULL)
 		return -ENOMEM;
-	}
 
 	tpa6130a2_client = client;
 
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 1e3884d..4dcdefd 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -332,10 +332,9 @@ static struct twl4030_codec_data *twl4030_get_pdata(struct snd_soc_codec *codec)
 		pdata = devm_kzalloc(codec->dev,
 				     sizeof(struct twl4030_codec_data),
 				     GFP_KERNEL);
-		if (!pdata) {
-			dev_err(codec->dev, "Can not allocate memory\n");
+		if (!pdata)
 			return NULL;
-		}
+
 		twl4030_setup_pdata_of(pdata, twl4030_codec_node);
 	}
 
@@ -2300,10 +2299,9 @@ static int twl4030_soc_probe(struct snd_soc_codec *codec)
 
 	twl4030 = devm_kzalloc(codec->dev, sizeof(struct twl4030_priv),
 			       GFP_KERNEL);
-	if (twl4030 == NULL) {
-		dev_err(codec->dev, "Can not allocate memory\n");
+	if (twl4030 == NULL)
 		return -ENOMEM;
-	}
+
 	snd_soc_codec_set_drvdata(codec, twl4030);
 	/* Set the defaults, and power up the codec */
 	twl4030->sysclk = twl4030_audio_get_mclk() / 1000;
diff --git a/sound/soc/codecs/wm1250-ev1.c b/sound/soc/codecs/wm1250-ev1.c
index 6e6b93d..8011f75 100644
--- a/sound/soc/codecs/wm1250-ev1.c
+++ b/sound/soc/codecs/wm1250-ev1.c
@@ -164,7 +164,6 @@ static int wm1250_ev1_pdata(struct i2c_client *i2c)
 
 	wm1250 = devm_kzalloc(&i2c->dev, sizeof(*wm1250), GFP_KERNEL);
 	if (!wm1250) {
-		dev_err(&i2c->dev, "Unable to allocate private data\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/sound/soc/codecs/wm2000.c b/sound/soc/codecs/wm2000.c
index 7fefd76..b13ee96 100644
--- a/sound/soc/codecs/wm2000.c
+++ b/sound/soc/codecs/wm2000.c
@@ -823,10 +823,8 @@ static int wm2000_i2c_probe(struct i2c_client *i2c,
 
 	wm2000 = devm_kzalloc(&i2c->dev, sizeof(struct wm2000_priv),
 			      GFP_KERNEL);
-	if (wm2000 == NULL) {
-		dev_err(&i2c->dev, "Unable to allocate private data\n");
+	if (wm2000 == NULL)
 		return -ENOMEM;
-	}
 
 	mutex_init(&wm2000->lock);
 
@@ -899,7 +897,6 @@ static int wm2000_i2c_probe(struct i2c_client *i2c,
 					    wm2000->anc_download_size,
 					    GFP_KERNEL);
 	if (wm2000->anc_download == NULL) {
-		dev_err(&i2c->dev, "Out of memory\n");
 		ret = -ENOMEM;
 		goto err_supplies;
 	}
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index eebcb1d..d965d8b 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -2055,10 +2055,8 @@ static int wm8903_i2c_probe(struct i2c_client *i2c,
 		wm8903->pdata = devm_kzalloc(&i2c->dev,
 					sizeof(struct wm8903_platform_data),
 					GFP_KERNEL);
-		if (wm8903->pdata == NULL) {
-			dev_err(&i2c->dev, "Failed to allocate pdata\n");
+		if (wm8903->pdata == NULL)
 			return -ENOMEM;
-		}
 
 		if (i2c->irq) {
 			ret = wm8903_set_pdata_irq_trigger(i2c, wm8903->pdata);
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 86426a1..809c846 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3283,12 +3283,8 @@ static void wm8994_handle_pdata(struct wm8994_priv *wm8994)
 		/* We need an array of texts for the enum API */
 		wm8994->drc_texts = devm_kzalloc(wm8994->hubs.codec->dev,
 			    sizeof(char *) * pdata->num_drc_cfgs, GFP_KERNEL);
-		if (!wm8994->drc_texts) {
-			dev_err(wm8994->hubs.codec->dev,
-				"Failed to allocate %d DRC config texts\n",
-				pdata->num_drc_cfgs);
+		if (!wm8994->drc_texts)
 			return;
-		}
 
 		for (i = 0; i < pdata->num_drc_cfgs; i++)
 			wm8994->drc_texts[i] = pdata->drc_cfgs[i].name;
diff --git a/sound/soc/codecs/wm9090.c b/sound/soc/codecs/wm9090.c
index a07fe16..a4323e0 100644
--- a/sound/soc/codecs/wm9090.c
+++ b/sound/soc/codecs/wm9090.c
@@ -623,10 +623,8 @@ static int wm9090_i2c_probe(struct i2c_client *i2c,
 	int ret;
 
 	wm9090 = devm_kzalloc(&i2c->dev, sizeof(*wm9090), GFP_KERNEL);
-	if (wm9090 == NULL) {
-		dev_err(&i2c->dev, "Can not allocate memory\n");
+	if (wm9090 == NULL)
 		return -ENOMEM;
-	}
 
 	wm9090->regmap = devm_regmap_init_i2c(i2c, &wm9090_regmap);
 	if (IS_ERR(wm9090->regmap)) {
diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 8b50e59..02e0902 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -183,10 +183,8 @@ static void wm_hubs_dcs_cache_set(struct snd_soc_codec *codec, u16 dcs_cfg)
 		return;
 
 	cache = devm_kzalloc(codec->dev, sizeof(*cache), GFP_KERNEL);
-	if (!cache) {
-		dev_err(codec->dev, "Failed to allocate DCS cache entry\n");
+	if (!cache)
 		return;
-	}
 
 	cache->left = snd_soc_read(codec, WM8993_LEFT_OUTPUT_VOLUME);
 	cache->left &= WM8993_HPOUT1L_VOL_MASK;
diff --git a/sound/soc/davinci/davinci-vcif.c b/sound/soc/davinci/davinci-vcif.c
index 30587c0..3796335 100644
--- a/sound/soc/davinci/davinci-vcif.c
+++ b/sound/soc/davinci/davinci-vcif.c
@@ -217,11 +217,8 @@ static int davinci_vcif_probe(struct platform_device *pdev)
 	davinci_vcif_dev = devm_kzalloc(&pdev->dev,
 					sizeof(struct davinci_vcif_dev),
 					GFP_KERNEL);
-	if (!davinci_vcif_dev) {
-		dev_dbg(&pdev->dev,
-			"could not allocate memory for private data\n");
+	if (!davinci_vcif_dev)
 		return -ENOMEM;
-	}
 
 	/* DMA tx params */
 	davinci_vcif_dev->davinci_vc = davinci_vc;
diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index 25c31f1..e522b58 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -351,10 +351,8 @@ static int dw_i2s_probe(struct platform_device *pdev)
 	}
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		dev_warn(&pdev->dev, "kzalloc fail\n");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	dev->i2s_base = devm_ioremap(&pdev->dev, res->start,
 			resource_size(res));
@@ -390,7 +388,6 @@ static int dw_i2s_probe(struct platform_device *pdev)
 
 	dw_i2s_dai = devm_kzalloc(&pdev->dev, sizeof(*dw_i2s_dai), GFP_KERNEL);
 	if (!dw_i2s_dai) {
-		dev_err(&pdev->dev, "mem allocation failed for dai driver\n");
 		ret = -ENOMEM;
 		goto err_clk_disable;
 	}
diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 35e2773..c159fe2 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -890,10 +890,8 @@ static int fsl_ssi_probe(struct platform_device *pdev)
 	p = strrchr(np->full_name, '/') + 1;
 	ssi_private = devm_kzalloc(&pdev->dev, sizeof(*ssi_private) + strlen(p),
 			      GFP_KERNEL);
-	if (!ssi_private) {
-		dev_err(&pdev->dev, "could not allocate DAI object\n");
+	if (!ssi_private)
 		return -ENOMEM;
-	}
 
 	strcpy(ssi_private->name, p);
 
diff --git a/sound/soc/fsl/imx-spdif.c b/sound/soc/fsl/imx-spdif.c
index 8499d52..980dd1f 100644
--- a/sound/soc/fsl/imx-spdif.c
+++ b/sound/soc/fsl/imx-spdif.c
@@ -35,7 +35,6 @@ static int imx_spdif_audio_probe(struct platform_device *pdev)
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
 		ret = -ENOMEM;
 		goto end;
 	}
diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index 0f3d73d..446b261 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -459,10 +459,9 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 	int err;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "allocation failed\n");
+	if (!priv)
 		return -ENOMEM;
-	}
+
 	dev_set_drvdata(&pdev->dev, priv);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/sound/soc/mid-x86/mfld_machine.c b/sound/soc/mid-x86/mfld_machine.c
index d3d4c32..dca833a 100644
--- a/sound/soc/mid-x86/mfld_machine.c
+++ b/sound/soc/mid-x86/mfld_machine.c
@@ -372,10 +372,8 @@ static int snd_mfld_mc_probe(struct platform_device *pdev)
 	/* audio interrupt base of SRAM location where
 	 * interrupts are stored by System FW */
 	mc_drv_ctx = devm_kzalloc(&pdev->dev, sizeof(*mc_drv_ctx), GFP_ATOMIC);
-	if (!mc_drv_ctx) {
-		pr_err("allocation failed\n");
+	if (!mc_drv_ctx)
 		return -ENOMEM;
-	}
 
 	irq_mem = platform_get_resource_byname(
 				pdev, IORESOURCE_MEM, "IRQ_BASE");
diff --git a/sound/soc/omap/omap-hdmi.c b/sound/soc/omap/omap-hdmi.c
index ced3b88..eed2e0b 100644
--- a/sound/soc/omap/omap-hdmi.c
+++ b/sound/soc/omap/omap-hdmi.c
@@ -272,10 +272,8 @@ static int omap_hdmi_probe(struct platform_device *pdev)
 	bool hdmi_dev_found = false;
 
 	hdmi_data = devm_kzalloc(&pdev->dev, sizeof(*hdmi_data), GFP_KERNEL);
-	if (hdmi_data == NULL) {
-		dev_err(&pdev->dev, "Cannot allocate memory for HDMI data\n");
+	if (hdmi_data == NULL)
 		return -ENOMEM;
-	}
 
 	hdmi_rsrc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!hdmi_rsrc) {
diff --git a/sound/soc/sh/fsi.c b/sound/soc/sh/fsi.c
index b33ca7c..d63cf5b 100644
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -2011,10 +2011,8 @@ static int fsi_probe(struct platform_device *pdev)
 	}
 
 	master = devm_kzalloc(&pdev->dev, sizeof(*master), GFP_KERNEL);
-	if (!master) {
-		dev_err(&pdev->dev, "Could not allocate master\n");
+	if (!master)
 		return -ENOMEM;
-	}
 
 	master->base = devm_ioremap_nocache(&pdev->dev,
 					    res->start, resource_size(res));
diff --git a/sound/soc/sh/rcar/adg.c b/sound/soc/sh/rcar/adg.c
index 9430097..9ddb725 100644
--- a/sound/soc/sh/rcar/adg.c
+++ b/sound/soc/sh/rcar/adg.c
@@ -200,10 +200,8 @@ int rsnd_adg_probe(struct platform_device *pdev,
 	int i;
 
 	adg = devm_kzalloc(dev, sizeof(*adg), GFP_KERNEL);
-	if (!adg) {
-		dev_err(dev, "ADG allocate failed\n");
+	if (!adg)
 		return -ENOMEM;
-	}
 
 	adg->clk[CLKA] = clk_get(NULL, "audio_clk_a");
 	adg->clk[CLKB] = clk_get(NULL, "audio_clk_b");
diff --git a/sound/soc/sh/rcar/core.c b/sound/soc/sh/rcar/core.c
index fc83f0f..338a219 100644
--- a/sound/soc/sh/rcar/core.c
+++ b/sound/soc/sh/rcar/core.c
@@ -558,10 +558,8 @@ static int rsnd_dai_probe(struct platform_device *pdev,
 
 	drv  = devm_kzalloc(dev, sizeof(*drv)  * dai_nr, GFP_KERNEL);
 	rdai = devm_kzalloc(dev, sizeof(*rdai) * dai_nr, GFP_KERNEL);
-	if (!drv || !rdai) {
-		dev_err(dev, "dai allocate failed\n");
+	if (!drv || !rdai)
 		return -ENOMEM;
-	}
 
 	for (i = 0; i < dai_nr; i++) {
 
@@ -722,10 +720,8 @@ static int rsnd_probe(struct platform_device *pdev)
 	 *	init priv data
 	 */
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		dev_err(dev, "priv allocate failed\n");
+	if (!priv)
 		return -ENODEV;
-	}
 
 	priv->dev	= dev;
 	priv->info	= info;
diff --git a/sound/soc/sh/rcar/gen.c b/sound/soc/sh/rcar/gen.c
index 61212ee..943ce7d 100644
--- a/sound/soc/sh/rcar/gen.c
+++ b/sound/soc/sh/rcar/gen.c
@@ -322,10 +322,8 @@ int rsnd_gen_probe(struct platform_device *pdev,
 	struct rsnd_gen *gen;
 
 	gen = devm_kzalloc(dev, sizeof(*gen), GFP_KERNEL);
-	if (!gen) {
-		dev_err(dev, "GEN allocate failed\n");
+	if (!gen)
 		return -ENOMEM;
-	}
 
 	if (rsnd_is_gen1(priv))
 		gen->ops = &rsnd_gen1_ops;
diff --git a/sound/soc/sh/rcar/scu.c b/sound/soc/sh/rcar/scu.c
index 2df2e91..04e8dff 100644
--- a/sound/soc/sh/rcar/scu.c
+++ b/sound/soc/sh/rcar/scu.c
@@ -210,10 +210,8 @@ int rsnd_scu_probe(struct platform_device *pdev,
 	 */
 	nr	= info->scu_info_nr;
 	scu	= devm_kzalloc(dev, sizeof(*scu) * nr, GFP_KERNEL);
-	if (!scu) {
-		dev_err(dev, "SCU allocate failed\n");
+	if (!scu)
 		return -ENOMEM;
-	}
 
 	priv->scu_nr	= nr;
 	priv->scu	= scu;
diff --git a/sound/soc/sh/rcar/ssi.c b/sound/soc/sh/rcar/ssi.c
index fae26d3..63e9406 100644
--- a/sound/soc/sh/rcar/ssi.c
+++ b/sound/soc/sh/rcar/ssi.c
@@ -643,10 +643,8 @@ int rsnd_ssi_probe(struct platform_device *pdev,
 	nr	= info->ssi_info_nr;
 	ssiu	= devm_kzalloc(dev, sizeof(*ssiu) + (sizeof(*ssi) * nr),
 			       GFP_KERNEL);
-	if (!ssiu) {
-		dev_err(dev, "SSI allocate failed\n");
+	if (!ssiu)
 		return -ENOMEM;
-	}
 
 	priv->ssiu	= ssiu;
 	ssiu->ssi	= (struct rsnd_ssi *)(ssiu + 1);
diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index 53c9ecd..f3f2866 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -406,7 +406,6 @@ int soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
 	compr->ops = devm_kzalloc(rtd->card->dev, sizeof(soc_compr_ops),
 				  GFP_KERNEL);
 	if (compr->ops == NULL) {
-		dev_err(rtd->card->dev, "Cannot allocate compressed ops\n");
 		ret = -ENOMEM;
 		goto compr_err;
 	}
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 4280c70..b2584b4 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4080,10 +4080,8 @@ int snd_soc_register_component(struct device *dev,
 	struct snd_soc_component *cmpnt;
 
 	cmpnt = devm_kzalloc(dev, sizeof(*cmpnt), GFP_KERNEL);
-	if (!cmpnt) {
-		dev_err(dev, "ASoC: Failed to allocate memory\n");
+	if (!cmpnt)
 		return -ENOMEM;
-	}
 
 	return __snd_soc_register_component(dev, cmpnt, cmpnt_drv,
 					    dai_drv, num_dai, true);
@@ -4405,11 +4403,8 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 
 	routes = devm_kzalloc(card->dev, num_routes * sizeof(*routes),
 			      GFP_KERNEL);
-	if (!routes) {
-		dev_err(card->dev,
-			"ASoC: Could not allocate DAPM route table\n");
+	if (!routes)
 		return -EINVAL;
-	}
 
 	for (i = 0; i < num_routes; i++) {
 		ret = of_property_read_string_index(np, propname,
diff --git a/sound/soc/spear/spdif_in.c b/sound/soc/spear/spdif_in.c
index 21a8c95..7b97e20 100644
--- a/sound/soc/spear/spdif_in.c
+++ b/sound/soc/spear/spdif_in.c
@@ -215,10 +215,8 @@ static int spdif_in_probe(struct platform_device *pdev)
 	}
 
 	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
-	if (!host) {
-		dev_warn(&pdev->dev, "kzalloc fail\n");
+	if (!host)
 		return -ENOMEM;
-	}
 
 	host->io_base = devm_ioremap(&pdev->dev, res->start,
 				resource_size(res));
diff --git a/sound/soc/spear/spdif_out.c b/sound/soc/spear/spdif_out.c
index b6ef6f7..069028b 100644
--- a/sound/soc/spear/spdif_out.c
+++ b/sound/soc/spear/spdif_out.c
@@ -282,10 +282,8 @@ static int spdif_out_probe(struct platform_device *pdev)
 	struct resource *res;
 
 	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
-	if (!host) {
-		dev_warn(&pdev->dev, "kzalloc fail\n");
+	if (!host)
 		return -ENOMEM;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	host->io_base = devm_ioremap_resource(&pdev->dev, res);
diff --git a/sound/soc/tegra/tegra20_ac97.c b/sound/soc/tegra/tegra20_ac97.c
index ae27bcd..4ec5955 100644
--- a/sound/soc/tegra/tegra20_ac97.c
+++ b/sound/soc/tegra/tegra20_ac97.c
@@ -320,7 +320,6 @@ static int tegra20_ac97_platform_probe(struct platform_device *pdev)
 	ac97 = devm_kzalloc(&pdev->dev, sizeof(struct tegra20_ac97),
 			    GFP_KERNEL);
 	if (!ac97) {
-		dev_err(&pdev->dev, "Can't allocate tegra20_ac97\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/sound/soc/tegra/tegra20_das.c b/sound/soc/tegra/tegra20_das.c
index e723929..21973c6 100644
--- a/sound/soc/tegra/tegra20_das.c
+++ b/sound/soc/tegra/tegra20_das.c
@@ -142,7 +142,6 @@ static int tegra20_das_probe(struct platform_device *pdev)
 
 	das = devm_kzalloc(&pdev->dev, sizeof(struct tegra20_das), GFP_KERNEL);
 	if (!das) {
-		dev_err(&pdev->dev, "Can't allocate tegra20_das\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/sound/soc/tegra/tegra20_i2s.c b/sound/soc/tegra/tegra20_i2s.c
index 52af7f6..d12985e 100644
--- a/sound/soc/tegra/tegra20_i2s.c
+++ b/sound/soc/tegra/tegra20_i2s.c
@@ -347,7 +347,6 @@ static int tegra20_i2s_platform_probe(struct platform_device *pdev)
 
 	i2s = devm_kzalloc(&pdev->dev, sizeof(struct tegra20_i2s), GFP_KERNEL);
 	if (!i2s) {
-		dev_err(&pdev->dev, "Can't allocate tegra20_i2s\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/sound/soc/tegra/tegra20_spdif.c b/sound/soc/tegra/tegra20_spdif.c
index 551b3c9..2fa73b9 100644
--- a/sound/soc/tegra/tegra20_spdif.c
+++ b/sound/soc/tegra/tegra20_spdif.c
@@ -272,7 +272,6 @@ static int tegra20_spdif_platform_probe(struct platform_device *pdev)
 	spdif = devm_kzalloc(&pdev->dev, sizeof(struct tegra20_spdif),
 			     GFP_KERNEL);
 	if (!spdif) {
-		dev_err(&pdev->dev, "Can't allocate tegra20_spdif\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/sound/soc/tegra/tegra30_ahub.c b/sound/soc/tegra/tegra30_ahub.c
index d554d46..a758c64 100644
--- a/sound/soc/tegra/tegra30_ahub.c
+++ b/sound/soc/tegra/tegra30_ahub.c
@@ -491,7 +491,6 @@ static int tegra30_ahub_probe(struct platform_device *pdev)
 	ahub = devm_kzalloc(&pdev->dev, sizeof(struct tegra30_ahub),
 			    GFP_KERNEL);
 	if (!ahub) {
-		dev_err(&pdev->dev, "Can't allocate tegra30_ahub\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/sound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/tegra30_i2s.c
index 47565fd04..b639bb3 100644
--- a/sound/soc/tegra/tegra30_i2s.c
+++ b/sound/soc/tegra/tegra30_i2s.c
@@ -406,7 +406,6 @@ static int tegra30_i2s_platform_probe(struct platform_device *pdev)
 
 	i2s = devm_kzalloc(&pdev->dev, sizeof(struct tegra30_i2s), GFP_KERNEL);
 	if (!i2s) {
-		dev_err(&pdev->dev, "Can't allocate tegra30_i2s\n");
 		ret = -ENOMEM;
 		goto err;
 	}
diff --git a/sound/soc/tegra/tegra_alc5632.c b/sound/soc/tegra/tegra_alc5632.c
index c61ea3a..777028e 100644
--- a/sound/soc/tegra/tegra_alc5632.c
+++ b/sound/soc/tegra/tegra_alc5632.c
@@ -157,10 +157,8 @@ static int tegra_alc5632_probe(struct platform_device *pdev)
 
 	alc5632 = devm_kzalloc(&pdev->dev,
 			sizeof(struct tegra_alc5632), GFP_KERNEL);
-	if (!alc5632) {
-		dev_err(&pdev->dev, "Can't allocate tegra_alc5632\n");
+	if (!alc5632)
 		return -ENOMEM;
-	}
 
 	card->dev = &pdev->dev;
 	platform_set_drvdata(pdev, card);
diff --git a/sound/soc/tegra/tegra_rt5640.c b/sound/soc/tegra/tegra_rt5640.c
index 4511c5a..d8ffb74 100644
--- a/sound/soc/tegra/tegra_rt5640.c
+++ b/sound/soc/tegra/tegra_rt5640.c
@@ -159,10 +159,8 @@ static int tegra_rt5640_probe(struct platform_device *pdev)
 
 	machine = devm_kzalloc(&pdev->dev,
 			sizeof(struct tegra_rt5640), GFP_KERNEL);
-	if (!machine) {
-		dev_err(&pdev->dev, "Can't allocate tegra_rt5640\n");
+	if (!machine)
 		return -ENOMEM;
-	}
 
 	card->dev = &pdev->dev;
 	platform_set_drvdata(pdev, card);
diff --git a/sound/soc/tegra/tegra_wm8753.c b/sound/soc/tegra/tegra_wm8753.c
index 8e774d1..1a0846c 100644
--- a/sound/soc/tegra/tegra_wm8753.c
+++ b/sound/soc/tegra/tegra_wm8753.c
@@ -129,10 +129,8 @@ static int tegra_wm8753_driver_probe(struct platform_device *pdev)
 
 	machine = devm_kzalloc(&pdev->dev, sizeof(struct tegra_wm8753),
 			       GFP_KERNEL);
-	if (!machine) {
-		dev_err(&pdev->dev, "Can't allocate tegra_wm8753 struct\n");
+	if (!machine)
 		return -ENOMEM;
-	}
 
 	card->dev = &pdev->dev;
 	platform_set_drvdata(pdev, card);
diff --git a/sound/soc/tegra/tegra_wm8903.c b/sound/soc/tegra/tegra_wm8903.c
index 4ac7373..759957b 100644
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -247,10 +247,8 @@ static int tegra_wm8903_driver_probe(struct platform_device *pdev)
 
 	machine = devm_kzalloc(&pdev->dev, sizeof(struct tegra_wm8903),
 			       GFP_KERNEL);
-	if (!machine) {
-		dev_err(&pdev->dev, "Can't allocate tegra_wm8903 struct\n");
+	if (!machine)
 		return -ENOMEM;
-	}
 
 	card->dev = &pdev->dev;
 	platform_set_drvdata(pdev, card);
diff --git a/sound/soc/tegra/tegra_wm9712.c b/sound/soc/tegra/tegra_wm9712.c
index 5e11963..e05becb 100644
--- a/sound/soc/tegra/tegra_wm9712.c
+++ b/sound/soc/tegra/tegra_wm9712.c
@@ -81,10 +81,8 @@ static int tegra_wm9712_driver_probe(struct platform_device *pdev)
 
 	machine = devm_kzalloc(&pdev->dev, sizeof(struct tegra_wm9712),
 			       GFP_KERNEL);
-	if (!machine) {
-		dev_err(&pdev->dev, "Can't allocate tegra_wm9712 struct\n");
+	if (!machine)
 		return -ENOMEM;
-	}
 
 	card->dev = &pdev->dev;
 	platform_set_drvdata(pdev, card);
diff --git a/sound/soc/tegra/trimslice.c b/sound/soc/tegra/trimslice.c
index 734bfcd..dfdc881 100644
--- a/sound/soc/tegra/trimslice.c
+++ b/sound/soc/tegra/trimslice.c
@@ -124,10 +124,8 @@ static int tegra_snd_trimslice_probe(struct platform_device *pdev)
 
 	trimslice = devm_kzalloc(&pdev->dev, sizeof(struct tegra_trimslice),
 				 GFP_KERNEL);
-	if (!trimslice) {
-		dev_err(&pdev->dev, "Can't allocate tegra_trimslice\n");
+	if (!trimslice)
 		return -ENOMEM;
-	}
 
 	card->dev = &pdev->dev;
 	platform_set_drvdata(pdev, card);


