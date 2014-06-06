Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaFFM1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:27:24 -0400
Received: from sauhun.de ([89.238.76.85]:54121 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbaFFM1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:27:21 -0400
Date: Fri, 6 Jun 2014 14:27:18 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.16
Message-ID: <20140606122713.GA3260@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

I2C has the following updates for 3.16:

* major cleanups to the rcar and sh_mobile drivers
* removal of nuc900 driver which had a compile error for years
* usual bunch of driver updates, bugfixes and cleanups

Please pull.

Thanks,

   Wolfram


The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-next

for you to fetch changes up to 642653d16a0f8e78b7a25d930b62aa771ebc939c:

  i2c: pca954x: Fix compilation without CONFIG_GPIOLIB (2014-06-05 15:09:33 +0200)

----------------------------------------------------------------
Doug Anderson (1):
      i2c: mux: Add more warnings to i2c-arb-gpio-challenge docs

Fugang Duan (2):
      i2c: imx: fix the i2c bus hang issue when do repeat restart
      i2c: imx: update i2c clock divider for each transaction

Jean Delvare (1):
      i2c: eg20t: Fix Kconfig dependencies

Jingoo Han (3):
      i2c: gpio: Use devm_gpio_request()
      i2c: remove unnecessary OOM messages
      i2c: Make of_device_id array const

Kaushal Butala (1):
      i2c: imx: add SMBus block read support

Laurent Pinchart (2):
      i2c: mux: pca954x: Use the descriptor-based GPIO API
      i2c: pca954x: Fix compilation without CONFIG_GPIOLIB

Maxime Ripard (2):
      i2c: mv64xxx: Change i2c compatibles for sunxi
      ARM: sunxi: dt: Convert to the new i2c compatibles

Mika Westerberg (3):
      i2c: designware: Disable device on system suspend
      i2c: designware: Add runtime PM hooks
      i2c: designware-pci: Add Haswell PCI IDs

Naveen Krishna Ch (1):
      i2c: exynos5: add support for HSI2C on Exynos5260 SoC

Richard Leitner (1):
      i2c: ali1563: fix checkpatch.pl issues

Sonic Zhang (1):
      i2c: bfin: turn to Resource-managed API in probe function

Ulf Hansson (1):
      i2c: nomadik: Fixup system suspend

Valentin Longchamp (1):
      i2c: mpc: insert DR read in i2c_fixup()

Wolfram Sang (24):
      i2c: sh_mobile: replace magic hex values with constants
      i2c: sh_mobile: improve error handling
      i2c: sh_mobile: honor DT bus speed settings
      i2c: sh_mobile: add devicetree documentation
      i2c: sh_mobile: devm conversion, low hanging fruits
      i2c: sh_mobile: devm conversion, irq setup
      i2c: sh_mobile: remove superfluous offset parameter
      i2c: sh_mobile: bail out on errors when initializing
      i2c: sh_mobile: check timing parameters for valid range
      i2c: sh_mobile: fix clock calculation for newer SoCs
      i2c: rcar: add compatibles for additional SoC
      i2c: sh_mobile: add compatibles for additional SoC
      i2c: rcar: not everything needs to be a function
      i2c: rcar: no need to store irq number
      i2c: rcar: refactor bus state machine
      i2c: rcar: refactor irq state machine
      i2c: rcar: check bus free before first message
      i2c: rcar: refactor setting up msg
      i2c: rcar: refactor status bit handling
      i2c: rcar: remove spinlock
      i2c: rcar: reuse status bits as enable bits
      i2c: rcar: janitorial cleanup after refactoring
      i2c: rcar: update copyright and license information
      i2c: nuc900: remove driver

 .../bindings/i2c/i2c-arb-gpio-challenge.txt        |   6 +
 .../devicetree/bindings/i2c/i2c-exynos5.txt        |  11 +-
 .../devicetree/bindings/i2c/i2c-mv64xxx.txt        |   2 +-
 Documentation/devicetree/bindings/i2c/i2c-rcar.txt |   3 +
 .../devicetree/bindings/i2c/i2c-sh_mobile.txt      |  26 +
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   6 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |   6 +-
 arch/arm/boot/dts/sun5i-a13.dtsi                   |   6 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  10 +-
 drivers/i2c/busses/Kconfig                         |   9 +-
 drivers/i2c/busses/Makefile                        |   1 -
 drivers/i2c/busses/i2c-ali1563.c                   |  82 +--
 drivers/i2c/busses/i2c-bcm2835.c                   |   4 +-
 drivers/i2c/busses/i2c-bfin-twi.c                  |  44 +-
 drivers/i2c/busses/i2c-designware-pcidrv.c         |  22 +
 drivers/i2c/busses/i2c-designware-platdrv.c        |  13 +-
 drivers/i2c/busses/i2c-diolan-u2c.c                |   1 -
 drivers/i2c/busses/i2c-efm32.c                     |   4 +-
 drivers/i2c/busses/i2c-eg20t.c                     |   4 +-
 drivers/i2c/busses/i2c-exynos5.c                   |  71 ++-
 drivers/i2c/busses/i2c-gpio.c                      |  25 +-
 drivers/i2c/busses/i2c-imx.c                       | 169 +++--
 drivers/i2c/busses/i2c-mpc.c                       |   2 +-
 drivers/i2c/busses/i2c-mv64xxx.c                   |   2 +-
 drivers/i2c/busses/i2c-nomadik.c                   |  14 +-
 drivers/i2c/busses/i2c-nuc900.c                    | 709 ---------------------
 drivers/i2c/busses/i2c-ocores.c                    |   2 +-
 drivers/i2c/busses/i2c-omap.c                      |   4 +-
 drivers/i2c/busses/i2c-pxa.c                       |   2 +-
 drivers/i2c/busses/i2c-rcar.c                      | 259 ++------
 drivers/i2c/busses/i2c-riic.c                      |   2 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   8 +-
 drivers/i2c/busses/i2c-sh_mobile.c                 | 225 ++++---
 drivers/i2c/busses/i2c-simtec.c                    |   4 +-
 drivers/i2c/busses/i2c-sirf.c                      |   1 -
 drivers/i2c/busses/i2c-st.c                        |   2 +-
 drivers/i2c/busses/i2c-stu300.c                    |   4 +-
 drivers/i2c/busses/i2c-tegra.c                     |   4 +-
 drivers/i2c/busses/i2c-wmt.c                       |   6 +-
 drivers/i2c/busses/scx200_acb.c                    |   4 +-
 drivers/i2c/muxes/i2c-mux-pca954x.c                |  24 +-
 41 files changed, 506 insertions(+), 1297 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-sh_mobile.txt
 delete mode 100644 drivers/i2c/busses/i2c-nuc900.c

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTkbOhAAoJEBQN5MwUoCm2qWwP/2YE8mpK6XyXaEXutt9D+K2J
gqSDu6I21vHdN3rfmM+AUa6lUBpuMGqABhV8UfY9R4dmK9ADdQtSqfZ1pM4F6iQI
1N9UB2HynjMyiGGzK7o4nPbEDThfe4spYx0a8iJj1978NUpQpgnSu3nwIMvogKAy
Wkv4sbr/CIoN3fBpPIW28iUFDDNNYcyXzWsNU8jnudpJAqcZMrscCl36kO0Tr2oe
k5WnON/3k5czWd+RvzR7X63gDe0og6fO6vc2ZT2lt6Z9HY1QULTVOndFrTyGtffK
NizYFcbKOkhmIljVbT5E8rT3m7WK2PgQYSKDjkzDfqUdG85zfjM6XtZMRBBYWT9v
1EfltqWZs+rBMHAmhKEaKLYc0lXg1+4XqfUVL9vrjneZCshlT0SWxAmTpiq9DXz9
u0NQtJvtKMdmDuh6A3syU8nDGdLDI9AQJL6qes9VjywFm2l6Sq6JPBO9QR1KT13m
o8k1B7O9F50H3RIFt47CkLqSdhThexBY0MqtQlDVkvpen20FcyuzP9Dcp41z7mIh
4F3q/rUw7L7z2jbzky8dBMIvgtgIAN3mkTwut/8cj6QtYnfeONtrfxd68Rq/tKeV
TF5QVYzyU5F6HVj/9CoEK7U4p6XWEnYtil4FnivLcvHcBqEWhfn0FeagWVx0oJ5S
2lecFt4RBNeI/uoQnLPD
=Uwqx
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
