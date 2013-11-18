Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3KRTiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:38:13 -0500
Received: from sauhun.de ([89.238.76.85]:54383 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab3KRTiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:38:11 -0500
Date: Mon, 18 Nov 2013 20:38:07 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.13
Message-ID: <20131118193802.GA14925@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

here is the pull request from the i2c subsystem for 3.13:

* new drivers for exynos5, bcm kona, and st micro
* bigger overhauls for drivers mxs and rcar
* typical driver bugfixes, cleanups, improvements
* got rid of the superfluous 'driver' member in i2c_client struct
  This touches a few drivers in other subsystems. All acked.

There is one conflict because of the INIT_COMPLETION to
reinit_completion rename. linux-next has a proper fix.

The topmost patch has not been in linux-next, yet it is trivial and a
bugfix which I wanted to have in this request. All the rest has
linux-next coverage.

Please pull.

Thanks,

   Wolfram


The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:

  Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-next

for you to fetch changes up to cfff1f4a9367bfe0d88413e8807f8369e9564729:

  i2c: bcm-kona: fix error return code in bcm_kona_i2c_probe() (2013-11-18 20:26:23 +0100)

----------------------------------------------------------------
Andreas Werner (1):
      i2c: i2c-eg20t: do not print error message in syslog if no ACK received

Dan Carpenter (1):
      i2c: scmi: remove some bogus NULL checks

Guennadi Liakhovetski (5):
      i2c: rcar: (cosmetic) remove superfluous parenthesis
      i2c: rcar: get clock rate only once and simplify calculation
      i2c: rcar: add Device Tree support
      i2c: rcar: fix clk_get() error handling
      i2c: rcar: use per-device clock

Guenter Roeck (1):
      i2c: i2c-dev: Create 'name' attribute automatically

Ionut Nicu (2):
      i2c: mux: gpio: use gpio_set_value_cansleep()
      i2c: mux: gpio: use reg value for i2c_add_mux_adapter

James Ralston (1):
      i2c: i801: Add Device IDs for Intel Wildcat Point-LP PCH

Jingoo Han (2):
      i2c: xiic: Remove casting the return value which is a void pointer
      i2c: bfin-twi: Remove casting the return value which is a void pointer

Juergen Beisert (1):
      i2c: mxs: distinguish i.MX23 and i.MX28 based I2C controller

Kuninori Morimoto (1):
      i2c: rcar: fixup rcar type naming

Lars-Peter Clausen (8):
      media: s5c73m3: Don't use i2c_client->driver
      media: exynos4-is: Don't use i2c_client->driver
      media: core: Don't use i2c_client->driver
      drm: encoder_slave: Don't use i2c_client->driver
      drm: nouveau: Don't use i2c_client->driver
      ALSA: ppc: keywest: Don't use i2c_client->driver
      ASoC: imx-wm8962: Don't use i2c_client->driver
      i2c: Remove redundant 'driver' field from the i2c_client struct

Laurent Pinchart (2):
      i2c: sh_mobile: Convert to clk_prepare/unprepare
      i2c: sh_mobile & rcar: Enable the driver on all ARM platforms

Marek Vasut (2):
      i2c: mxs: Rework the PIO mode operation
      i2c: mxs: Fix PIO mode on i.MX23

Maxime COQUELIN (1):
      i2c: i2c-st: Add ST I2C controller

Mika Westerberg (1):
      i2c: designware: add new ACPI IDs

Naveen Krishna Ch (1):
      i2c: exynos5: add High Speed I2C controller driver

Sachin Kamat (3):
      i2c: remove redundant of_match_ptr
      i2c: Include linux/of.h header
      i2c: exynos5: Remove incorrect clk_disable_unprepare

Tim Kryger (1):
      i2c: bcm-kona: Introduce Broadcom I2C Driver

Tony Lindgren (1):
      i2c: cbus-gpio: Fix device tree binding

Vivien Didelot (1):
      misc: (at24) move header to linux/platform_data/

Wei Yongjun (2):
      i2c: wmt: add missing clk_disable_unprepare() on error
      i2c: bcm-kona: fix error return code in bcm_kona_i2c_probe()

 .../devicetree/bindings/i2c/i2c-bcm-kona.txt       |  35 +
 .../devicetree/bindings/i2c/i2c-exynos5.txt        |  44 +
 Documentation/devicetree/bindings/i2c/i2c-rcar.txt |  23 +
 Documentation/devicetree/bindings/i2c/i2c-st.txt   |  41 +
 Documentation/i2c/busses/i2c-i801                  |   1 +
 MAINTAINERS                                        |   2 +-
 arch/arm/mach-at91/board-sam9260ek.c               |   2 +-
 arch/arm/mach-at91/board-sam9263ek.c               |   2 +-
 arch/arm/mach-davinci/board-da830-evm.c            |   2 +-
 arch/arm/mach-davinci/board-da850-evm.c            |   2 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |   2 +-
 arch/arm/mach-davinci/board-dm644x-evm.c           |   2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c           |   2 +-
 arch/arm/mach-davinci/board-mityomapl138.c         |   2 +-
 arch/arm/mach-davinci/board-sffsdr.c               |   2 +-
 arch/arm/mach-imx/mach-pca100.c                    |   2 +-
 arch/arm/mach-imx/mach-pcm037.c                    |   2 +-
 arch/arm/mach-imx/mach-pcm038.c                    |   2 +-
 arch/arm/mach-imx/mach-pcm043.c                    |   2 +-
 arch/arm/mach-imx/mach-vpr200.c                    |   2 +-
 arch/arm/mach-kirkwood/lacie_v2-common.c           |   2 +-
 arch/arm/mach-omap1/board-osk.c                    |   2 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |   2 +-
 arch/arm/mach-omap2/board-h4.c                     |   2 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |   2 +-
 arch/arm/mach-pxa/stargate2.c                      |   2 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c              |   2 +-
 drivers/gpu/drm/drm_encoder_slave.c                |   8 +-
 drivers/gpu/drm/nouveau/core/subdev/therm/ic.c     |   3 +-
 drivers/i2c/busses/Kconfig                         |  32 +-
 drivers/i2c/busses/Makefile                        |   3 +
 drivers/i2c/busses/i2c-bcm-kona.c                  | 909 +++++++++++++++++++++
 drivers/i2c/busses/i2c-bfin-twi.c                  |   6 +-
 drivers/i2c/busses/i2c-cbus-gpio.c                 |   2 +
 drivers/i2c/busses/i2c-davinci.c                   |   2 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |   2 +
 drivers/i2c/busses/i2c-eg20t.c                     |  26 +-
 drivers/i2c/busses/i2c-exynos5.c                   | 769 +++++++++++++++++
 drivers/i2c/busses/i2c-gpio.c                      |   1 +
 drivers/i2c/busses/i2c-i801.c                      |   3 +
 drivers/i2c/busses/i2c-mv64xxx.c                   |   2 +-
 drivers/i2c/busses/i2c-mxs.c                       | 340 +++++---
 drivers/i2c/busses/i2c-pnx.c                       |   1 +
 drivers/i2c/busses/i2c-rcar.c                      |  65 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   1 +
 drivers/i2c/busses/i2c-scmi.c                      |   6 +-
 drivers/i2c/busses/i2c-sh_mobile.c                 |   8 +-
 drivers/i2c/busses/i2c-st.c                        | 872 ++++++++++++++++++++
 drivers/i2c/busses/i2c-wmt.c                       |   1 +
 drivers/i2c/busses/i2c-xiic.c                      |   3 +-
 drivers/i2c/i2c-core.c                             |  21 +-
 drivers/i2c/i2c-dev.c                              |  19 +-
 drivers/i2c/i2c-smbus.c                            |  10 +-
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c         |   2 +-
 drivers/i2c/muxes/i2c-mux-gpio.c                   |  10 +-
 drivers/i2c/muxes/i2c-mux-pinctrl.c                |   1 +
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   6 +-
 drivers/media/v4l2-core/tuner-core.c               |   6 +-
 drivers/media/v4l2-core/v4l2-common.c              |  10 +-
 drivers/misc/eeprom/at24.c                         |   2 +-
 include/linux/i2c.h                                |   2 -
 include/linux/{i2c => platform_data}/at24.h        |   2 +-
 include/media/v4l2-common.h                        |   2 +-
 sound/ppc/keywest.c                                |   4 +-
 sound/soc/fsl/imx-wm8962.c                         |   2 +-
 66 files changed, 3111 insertions(+), 243 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-bcm-kona.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-rcar.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-st.txt
 create mode 100644 drivers/i2c/busses/i2c-bcm-kona.c
 create mode 100644 drivers/i2c/busses/i2c-exynos5.c
 create mode 100644 drivers/i2c/busses/i2c-st.c
 rename include/linux/{i2c => platform_data}/at24.h (97%)

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSimyaAAoJEBQN5MwUoCm2X7gQAIfByqH59Wdri0cDW/AOfMl8
/m8FHdWkNjFvHRPHQfcSxMrn9KzcdizpMWFf30RdnowkNwUTXn79m1gqHO+grAk7
luTfC7E9Hgwr9NOL4RY3+N+wSolm3pSxeRV1AZktbpcTP8NOZyMW30ZY2gbjkH3r
ZO2tBEbYZyWl+Dh+LQhoKes3hji8G90VYiOPQkqiUgUVlRFYMURKclacQhgGiRxE
uakcoMFun+03pJZn679FXb3eqJU1JsnzlzQ7kCpImzIWgHxupeMNwCaoe5xY5984
y0Q7HAJ79FKyJeNjhgRTMVlTf1Q+GMKZWqZiIigEeO0HkC8vehl+mrRY2L2UN8xG
qOR9Dnk36wb1qVeAsKYyN4gW+mK4MhZamE8oCAY1lbHTXfUVjoCqok6l5k4X8x8v
uH5o3WpKtjn6r+XGFr6peA7Ua7ADmaQnneBC92614d/9iEAQNUAAqj2LuDqsePzR
tRlgUOCw8ypwvdJSQqAXXuwOUaqUJF708qos2hadNFLBM6EQLcCBbfirziecL1hw
kblz+BvEib7aQjyOb8Qw/5DasFRtF+tix4YHruy0y6NFfdCVOy3N/UzoWp2Bvtom
dajUGNmCol7RNUFx3BsCou05Uz6VuaZ5vPfqE+Gr/DkxCbe0I+TjpxaVyIj5SliO
kn1yVFmUrwo3QiXazToJ
=4FPU
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
