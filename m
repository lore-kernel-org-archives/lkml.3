Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3ERKHf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 06:07:35 -0400
Received: from sauhun.de ([89.238.76.85]:55779 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3ERKHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 06:07:33 -0400
Date: Sat, 18 May 2013 12:09:03 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] devm usage cleanup #1, no resource check needed with
 devm_ioremap_resource()
Message-ID: <20130518100903.GA4292@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Lately, I have been experimenting how to improve the devm interface to make
writing device drivers easier and less error prone while also getting rid of
its subtle issues. I think it has more potential but still needs work and
definately conistency, especiall in its usage.

The first thing I come up with is a low hanging fruit regarding
devm_ioremap_resouce(). This function already checks if the passed resource is
valid and gives an error message if not. So, we can remove similar checks from
the drivers and get rid of a bit of code and a number of inconsistent error
strings.

This series only removes the unneeded check iff devm_ioremap_resource follows
platform_get_resource directly. The previous version tried to shuffle code if
needed, too, what lead to an embarrasing bug. It turned out to me that
shuffling code for all cases found will make the automated script too complex,
so I am unsure if an automated cleanup is the proper tool for this case.
Removing the easy stuff seems worthwhile to me, though.

Despite various architectures and platform dependencies, I managed to compile
test 45 out of 57 modified files locally using heuristics and defconfigs.

Please pull if you think it is not too late for such a kind of cleanup.

Thanks,

   Wolfram


The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git devm_no_resource_check

for you to fetch changes up to 12716cd44da7e6c935e2fb1783417ca31fbbaa97:

  sound/soc/kirkwood: don't check resource with devm_ioremap_resource (2013-05-18 11:59:45 +0200)

----------------------------------------------------------------
Wolfram Sang (33):
      drivers/ata: don't check resource with devm_ioremap_resource
      drivers/char/hw_random: don't check resource with devm_ioremap_resource
      drivers/cpufreq: don't check resource with devm_ioremap_resource
      drivers/dma: don't check resource with devm_ioremap_resource
      drivers/gpio: don't check resource with devm_ioremap_resource
      drivers/gpu/drm/exynos: don't check resource with devm_ioremap_resource
      drivers/gpu/host1x/drm: don't check resource with devm_ioremap_resource
      drivers/i2c/busses: don't check resource with devm_ioremap_resource
      drivers/memory: don't check resource with devm_ioremap_resource
      drivers/mfd: don't check resource with devm_ioremap_resource
      drivers/misc: don't check resource with devm_ioremap_resource
      drivers/mtd/nand: don't check resource with devm_ioremap_resource
      drivers/net/ethernet/renesas: don't check resource with devm_ioremap_resource
      drivers/pinctrl: don't check resource with devm_ioremap_resource
      drivers/pwm: don't check resource with devm_ioremap_resource
      drivers/rtc: don't check resource with devm_ioremap_resource
      drivers/spi: don't check resource with devm_ioremap_resource
      drivers/staging/dwc2: don't check resource with devm_ioremap_resource
      drivers/staging/nvec: don't check resource with devm_ioremap_resource
      drivers/thermal: don't check resource with devm_ioremap_resource
      drivers/usb/chipidea: don't check resource with devm_ioremap_resource
      drivers/usb/gadget: don't check resource with devm_ioremap_resource
      drivers/usb/host: don't check resource with devm_ioremap_resource
      drivers/usb/phy: don't check resource with devm_ioremap_resource
      drivers/video/omap2: don't check resource with devm_ioremap_resource
      drivers/video/omap2/dss: don't check resource with devm_ioremap_resource
      drivers/w1/masters: don't check resource with devm_ioremap_resource
      drivers/watchdog: don't check resource with devm_ioremap_resource
      arch/arm/mach-tegra: don't check resource with devm_ioremap_resource
      arch/arm/plat-samsung: don't check resource with devm_ioremap_resource
      arch/mips/lantiq/xway: don't check resource with devm_ioremap_resource
      sound/soc/fsl: don't check resource with devm_ioremap_resource
      sound/soc/kirkwood: don't check resource with devm_ioremap_resource

 arch/arm/mach-tegra/tegra2_emc.c      |    5 -----
 arch/arm/plat-samsung/adc.c           |    5 -----
 arch/mips/lantiq/xway/gptu.c          |    4 ----
 drivers/ata/pata_ep93xx.c             |    5 -----
 drivers/char/hw_random/mxc-rnga.c     |    6 ------
 drivers/char/hw_random/omap-rng.c     |    5 -----
 drivers/cpufreq/kirkwood-cpufreq.c    |    4 ----
 drivers/dma/tegra20-apb-dma.c         |    5 -----
 drivers/gpio/gpio-mvebu.c             |    5 -----
 drivers/gpio/gpio-tegra.c             |    5 -----
 drivers/gpu/drm/exynos/exynos_hdmi.c  |    5 -----
 drivers/gpu/host1x/drm/dc.c           |    5 -----
 drivers/i2c/busses/i2c-s3c2410.c      |    5 -----
 drivers/i2c/busses/i2c-sirf.c         |    6 ------
 drivers/i2c/busses/i2c-tegra.c        |    5 -----
 drivers/memory/emif.c                 |    6 ------
 drivers/mfd/intel_msic.c              |    5 -----
 drivers/misc/atmel-ssc.c              |    5 -----
 drivers/mtd/nand/lpc32xx_mlc.c        |    5 -----
 drivers/net/ethernet/renesas/sh_eth.c |    5 -----
 drivers/pinctrl/pinctrl-coh901.c      |    5 -----
 drivers/pinctrl/pinctrl-exynos5440.c  |    5 -----
 drivers/pinctrl/pinctrl-samsung.c     |    5 -----
 drivers/pinctrl/pinctrl-xway.c        |    4 ----
 drivers/pwm/pwm-imx.c                 |    5 -----
 drivers/pwm/pwm-puv3.c                |    5 -----
 drivers/pwm/pwm-pxa.c                 |    5 -----
 drivers/pwm/pwm-tegra.c               |    5 -----
 drivers/pwm/pwm-tiecap.c              |    5 -----
 drivers/pwm/pwm-tiehrpwm.c            |    5 -----
 drivers/pwm/pwm-tipwmss.c             |    5 -----
 drivers/pwm/pwm-vt8500.c              |    5 -----
 drivers/rtc/rtc-nuc900.c              |    5 -----
 drivers/rtc/rtc-omap.c                |    5 -----
 drivers/rtc/rtc-s3c.c                 |    5 -----
 drivers/rtc/rtc-tegra.c               |    6 ------
 drivers/spi/spi-tegra20-sflash.c      |    5 -----
 drivers/staging/dwc2/platform.c       |    5 -----
 drivers/staging/nvec/nvec.c           |    5 -----
 drivers/thermal/armada_thermal.c      |   10 ----------
 drivers/thermal/dove_thermal.c        |    4 ----
 drivers/thermal/exynos_thermal.c      |    5 -----
 drivers/usb/chipidea/core.c           |    5 -----
 drivers/usb/gadget/bcm63xx_udc.c      |   10 ----------
 drivers/usb/host/ohci-nxp.c           |    6 ------
 drivers/usb/phy/phy-mv-u3d-usb.c      |    5 -----
 drivers/usb/phy/phy-mxs-usb.c         |    5 -----
 drivers/usb/phy/phy-samsung-usb2.c    |    5 -----
 drivers/usb/phy/phy-samsung-usb3.c    |    5 -----
 drivers/video/omap2/dss/hdmi.c        |    4 ----
 drivers/video/omap2/vrfb.c            |    5 -----
 drivers/w1/masters/omap_hdq.c         |    5 -----
 drivers/watchdog/ath79_wdt.c          |    5 -----
 drivers/watchdog/davinci_wdt.c        |    5 -----
 drivers/watchdog/imx2_wdt.c           |    5 -----
 sound/soc/fsl/imx-ssi.c               |    6 ------
 sound/soc/kirkwood/kirkwood-i2s.c     |    5 -----
 57 files changed, 296 deletions(-)
