Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbaJUQxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:53:55 -0400
Received: from sauhun.de ([89.238.76.85]:37695 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178AbaJUQxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:53:50 -0400
Date: Tue, 21 Oct 2014 18:54:41 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>
Subject: [PULL REQUEST] remove .owner for most platform_drivers
Message-ID: <20141021165441.GA1619@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

as discussed at ELCE, here is my pull request for cleaning up all unneeded
assignment of .owner for platform drivers. I used the following semantic patch
to check that it only removes it when .owner gets initialized by the call to
register the driver:

---

@match1@
declarer name module_platform_driver;
declarer name module_platform_driver_probe;
identifier __driver;
@@
(
	module_platform_driver(__driver);
|
	module_platform_driver_probe(__driver, ...);
)

@fix1 depends on match1@
identifier match1.__driver;
@@
	static struct platform_driver __driver = {
		.driver = {
-			.owner = THIS_MODULE,
		}
	};

@match2@
identifier __driver;
@@
(
	platform_driver_register(&__driver)
|
	platform_driver_probe(&__driver, ...)
|
	platform_create_bundle(&__driver, ...)
)

@fix2 depends on match2@
identifier match2.__driver;
@@
	static struct platform_driver __driver = {
		.driver = {
-			.owner = THIS_MODULE,
		}
	};

---

@all: The granularity level is per-directory. Greg was okay with that, speak up
if you strongly disagree. I am really going for consistency here, not patch
count (and to avoid patches on per-driver level which I already got a few for
my subsystem). Also, I have not CCed all the mailing lists, since Greg
suggested that he'd pull this series. If people prefer, I can resend this mail
with all lists on CC.

Thanks,

   Wolfram


The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git platform/remove_owner

for you to fetch changes up to 79cd1762933153237731585f0901eec368e54bae:

  ALSA: sparc: drop owner assignment from platform_drivers (2014-10-20 16:22:16 +0200)

----------------------------------------------------------------
Wolfram Sang (299):
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

 arch/arm/common/sa1111.c                                         | 1 -
... removed a lot of lines ...
 sound/sparc/dbri.c                                               | 1 -
 1687 files changed, 1717 deletions(-)

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJURo/RAAoJEBQN5MwUoCm2KK0QAKL78I46hdb8gKJbsL5N4fq4
np3did7hmoxAIgYGQaoNGxerPLYtDu2KI8RBIYtB1CjV3vBk/fin5Y2pnBNH2xGj
BpifIG8l/9AcOPBZrutl8anJ2u9whMYuFIih/SP2UECMNGUnFfyJhzAbFwka4Sg7
y5t5B/PEZtE+c+GVBGuD+q2H6F5NOEVu8D23jyb+m2lPki2vsVYmxnkd/qVNeBhk
4wF4IF1LO3fuRMwK9V2wBcQ0nhLhi8h2EY+DOsqnN//ndBTevbeFlLO8O7WCmi6p
6gDbUpUyG8DDkJ8hgzLU5aigXsLg0bENf/9eaGgoSNJgt+e1S8b6DtIXfINJnlER
nPj0FY5rkyLt1X/3I2v/MA1IA4myObg0lTwr/W7FEcI6XbyWlXDsGzYKR6QLoGrb
sPJspwXuemKZQTE+pwupLUEUnp3T3T1h+Wi0JpWxcU2SORo6k5A+Kp54dvrn8cgQ
1Kl6tH6jQ9PqKhYGK1FSgZ4VFnM9TvhExdjwJtL889uroozg5mYum5f6hQMBwzly
sA4fu5bBnkW/IL+hsd0rrgvNoq8+B3awxtPqoxoj6kqBlW2R/H7zhqZauDyO7aUp
4dLXpREOrsZlPIiVMTcXiCjvPZ+sWZuI1FRBBc+a2ftCvnOtpMRXltN8ECUgjIxJ
UMQhiYMQtIe6bWANvZHj
=htMg
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
