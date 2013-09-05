Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935539Ab3IEJDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:03:51 -0400
Received: from sauhun.de ([89.238.76.85]:38156 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674Ab3IEJDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:03:48 -0400
Date: Thu, 5 Sep 2013 11:03:41 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.12
Message-ID: <20130905090322.GA3429@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

please pull the changes from the I2C subsystem for the 3.12 release. Highli=
ghts:

* OF and ACPI helpers are now included in the core, and not in external fil=
es anymore.
  This removes dependency problems for modules and is cleaner, in general.
* mv64xxx-driver gains fifo usage to support mv78230
* imx-driver overhaul to support VF610
* various cleanups, most notably related to devm_* and CONFIG_PM usage
* driver bugfixes and smaller feature additions

Thanks,

   Wolfram


The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-next

for you to fetch changes up to b720423a2627f045133bec39a31fe2bc0dab86f3:

  i2c: rcar: add rcar-H2 support (2013-09-04 11:49:16 +0100)

----------------------------------------------------------------
Andy Lutomirski (1):
      i2c: Improve logging on failure to probe for ->class devices

Chew, Chiau Ee (1):
      i2c: designware: Manually set RESTART bit between messages

Fabio Estevam (2):
      i2c: i2c-mxs: Use DMA mode even for small transfers
      i2c: mxs: Check the return value from stmp_reset_block()

Gerhard Sittig (1):
      i2c: mpc: cleanup clock API use

Gregory CLEMENT (2):
      i2c: mv64xxx: Add I2C Transaction Generator support
      i2c: mv64xxx: Fix timing issue on Armada XP (errata FE-8471889)

Grygorii Strashko (1):
      i2c: omap: query STP always when NACK is received

Guenter Roeck (1):
      i2c: mpc: Define unique I2C adapter names

Jingchang Lu (9):
      i2c: imx: use struct representing i2c clk{div, val} pair
      i2c: imx: enable clk before write to registers
      i2c: imx: don't change platform device id_entry directly
      i2c: imx: wrap registers read/write to inline function
      i2c: imx: change register offset representation
      i2c: imx: add INT flag and IEN bit operatation codes
      i2c: imx: add struct to hold more configurable quirks
      i2c: imx: Add Vybrid VF610 I2C controller support
      i2c: imx: use exact SoC revision to document binding

Jingoo Han (8):
      i2c: i2c-mpc: add CONFIG_PM_SLEEP to suspend/resume functions
      i2c: designware: add CONFIG_PM_SLEEP to suspend/resume functions
      i2c: ocores: add CONFIG_PM_SLEEP to suspend/resume functions
      i2c: stu300: add CONFIG_PM_SLEEP to suspend/resume functions
      i2c: pnx: add CONFIG_PM_SLEEP to suspend/resume functions
      i2c: puv3: add CONFIG_PM_SLEEP to suspend function
      i2c: i2c-bfin-twi: add CONFIG_PM_SLEEP to suspend/resume functions
      i2c: use dev_get_platdata()

Julia Lawall (1):
      drivers/i2c/busses/i2c-ocores.c: simplify use of devm_ioremap_resource

Jussi Kivilinna (1):
      i2c: tiny-usb: do not use stack as URB transfer_buffer

Leilei Shang (1):
      i2c: pxa: enable high speed mode for i2c bus

Lothar Wa=DFmann (1):
      i2c: mxs: fix broken timing calculation

Maxime Ripard (1):
      i2c: mv64xxx: Document the newly introduced allwinner compatible

Michael Brunner (1):
      i2c: Fix Kontron PLD prescaler calculation

Mika Westerberg (3):
      i2c: move ACPI helpers into the core
      i2c: designware: make HCNT/LCNT values configurable
      i2c: designware: get SDA hold time, HCNT and LCNT configuration from =
ACPI

Nguyen Viet Dung (1):
      i2c: rcar: add rcar-H2 support

Phil Carmody (1):
      i2c: reduce parent checking to a NOOP in non-I2C_MUX case

Rudolf Marek (1):
      i2c: piix4: Add support for secondary SMBus on AMD SB800 and AMD FCH =
chipsets

Sachin Kamat (1):
      Documentation: i2c: Fix example in instantiating-devices

Santosh Shilimkar (2):
      i2c: davinci: remove useless mach/hardware include
      i2c: davinci: Allow i2c driver available for keystone platforms

Sebastian Hesselbarth (1):
      i2c: add sanity check to i2c_put_adapter

Wei Yongjun (1):
      i2c: pnx: fix error return code in i2c_pnx_probe()

Wolfram Sang (6):
      drivers/i2c/busses: don't use devm_pinctrl_get_select_default() in pr=
obe
      drivers/i2c/busses: don't check resource with devm_ioremap_resource
      i2c: powermac: fix return path on error
      i2c: move OF helpers into the core
      i2c: mv64xxx: fix typo in binding documentation
      i2c: ismt: add error return code in probe()

Zhiwu Song (5):
      i2c: sirf: reset i2c controller early after we get a noack
      i2c: sirf: we need to wait I2C_RESET status in resume
      i2c: sirf: fix the typo for setting bitrate to less than 100k
      i2c: sirf: support reverse direction of address
      i2c: sirf: retry 3 times as sometimes we get random noack and timeout

 Documentation/acpi/enumeration.txt                 |   16 +-
 Documentation/devicetree/bindings/i2c/i2c-imx.txt  |    5 +-
 .../devicetree/bindings/i2c/i2c-mv64xxx.txt        |   12 +-
 Documentation/i2c/busses/i2c-piix4                 |    7 +-
 Documentation/i2c/instantiating-devices            |    2 +-
 arch/powerpc/platforms/44x/warp.c                  |    1 -
 drivers/acpi/Kconfig                               |    6 -
 drivers/acpi/Makefile                              |    1 -
 drivers/acpi/acpi_i2c.c                            |  103 ---------
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              |    1 -
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c             |    1 -
 drivers/gpu/host1x/drm/output.c                    |    2 +-
 drivers/i2c/busses/Kconfig                         |    2 +-
 drivers/i2c/busses/i2c-at91.c                      |    3 -
 drivers/i2c/busses/i2c-bfin-twi.c                  |   16 +-
 drivers/i2c/busses/i2c-cbus-gpio.c                 |    5 +-
 drivers/i2c/busses/i2c-cpm.c                       |    6 -
 drivers/i2c/busses/i2c-davinci.c                   |    6 +-
 drivers/i2c/busses/i2c-designware-core.c           |   25 +++
 drivers/i2c/busses/i2c-designware-core.h           |   12 ++
 drivers/i2c/busses/i2c-designware-platdrv.c        |   46 +++-
 drivers/i2c/busses/i2c-gpio.c                      |    9 +-
 drivers/i2c/busses/i2c-i801.c                      |    2 -
 drivers/i2c/busses/i2c-ibm_iic.c                   |    4 -
 drivers/i2c/busses/i2c-imx.c                       |  228 +++++++++++++++-=
----
 drivers/i2c/busses/i2c-ismt.c                      |    1 +
 drivers/i2c/busses/i2c-kempld.c                    |    4 +-
 drivers/i2c/busses/i2c-mpc.c                       |   44 +++-
 drivers/i2c/busses/i2c-mv64xxx.c                   |  207 ++++++++++++++++=
--
 drivers/i2c/busses/i2c-mxs.c                       |  118 +++++++---
 drivers/i2c/busses/i2c-nomadik.c                   |    5 +-
 drivers/i2c/busses/i2c-nuc900.c                    |    2 +-
 drivers/i2c/busses/i2c-ocores.c                    |   12 +-
 drivers/i2c/busses/i2c-octeon.c                    |    3 -
 drivers/i2c/busses/i2c-omap.c                      |   27 +--
 drivers/i2c/busses/i2c-pca-platform.c              |    2 +-
 drivers/i2c/busses/i2c-piix4.c                     |   41 +++-
 drivers/i2c/busses/i2c-pnx.c                       |    8 +-
 drivers/i2c/busses/i2c-powermac.c                  |   14 +-
 drivers/i2c/busses/i2c-puv3.c                      |    2 +-
 drivers/i2c/busses/i2c-pxa.c                       |   70 +++++-
 drivers/i2c/busses/i2c-rcar.c                      |   37 +++-
 drivers/i2c/busses/i2c-s3c2410.c                   |    4 +-
 drivers/i2c/busses/i2c-s6000.c                     |    5 +-
 drivers/i2c/busses/i2c-sh7760.c                    |    2 +-
 drivers/i2c/busses/i2c-sh_mobile.c                 |    4 +-
 drivers/i2c/busses/i2c-sirf.c                      |   39 ++--
 drivers/i2c/busses/i2c-stu300.c                    |    7 +-
 drivers/i2c/busses/i2c-tegra.c                     |    3 -
 drivers/i2c/busses/i2c-tiny-usb.c                  |   49 +++--
 drivers/i2c/busses/i2c-versatile.c                 |    2 -
 drivers/i2c/busses/i2c-wmt.c                       |    3 -
 drivers/i2c/busses/i2c-xiic.c                      |    5 +-
 drivers/i2c/i2c-core.c                             |  206 ++++++++++++++++=
+-
 drivers/i2c/i2c-mux.c                              |    3 -
 drivers/i2c/i2c-smbus.c                            |    2 +-
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c         |    3 +-
 drivers/i2c/muxes/i2c-mux-gpio.c                   |    9 +-
 drivers/i2c/muxes/i2c-mux-pca9541.c                |    2 +-
 drivers/i2c/muxes/i2c-mux-pca954x.c                |    2 +-
 drivers/i2c/muxes/i2c-mux-pinctrl.c                |    3 +-
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |    4 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |    2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |    1 -
 drivers/of/Kconfig                                 |    6 -
 drivers/of/Makefile                                |    1 -
 drivers/of/of_i2c.c                                |  114 ----------
 drivers/staging/imx-drm/imx-tve.c                  |    2 +-
 include/linux/i2c.h                                |   24 ++-
 include/linux/i2c/pxa-i2c.h                        |    3 +
 include/linux/of_i2c.h                             |   46 ----
 sound/soc/fsl/imx-sgtl5000.c                       |    2 +-
 sound/soc/fsl/imx-wm8962.c                         |    2 +-
 73 files changed, 1064 insertions(+), 614 deletions(-)
 delete mode 100644 drivers/acpi/acpi_i2c.c
 delete mode 100644 drivers/of/of_i2c.c
 delete mode 100644 include/linux/of_i2c.h

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSKEjaAAoJEBQN5MwUoCm2yQ0QAImVdC+8pRNBRlj5iL5aJske
9bodzWs+7mgpmsbr9xpW6ZLT+jlFTyIUfQ1beWgv5tmlfl2JAqW5tzppUW3plzdu
Hmjte1vurtTtberLIa0rFyb4O+rOJZpS9zKK1LcW4UHuVHw+UWP+LqNqEfw9CuLN
7aoP18E/dn6LCL7loTjnUI6QkIJHHH6twYWIcWCDgAnfyLh55kC3XhHOp2J52bxf
uACXDszhOgWF8sPR3UrL//Z29rQUSGUwRyMXofFI7QKtOODR8Y4JLiWZHOrM753o
Hxnopih0R/OB0i0WN95bO5Cypp0GowP54ipPem8PHjcGrqK1O+qdU43zsrMCO46u
pf3DN3vuL+ZAnuH2ieEpZAb7vmbUAiW9fUrGorPk852apwnfeE3UJxq7ZDJ9TIHF
FWeThs0U3/jMJTXiogA22hdpMvbi4+OE1PorJeEW9scUZzVUyVKUIYj0AQapMnE0
RlKdk1D5hqbg1R/yZsewdVp1zGZhbmRsmTyQ0OVNd4EZqxZcWuJKtG9sm1oqChmU
axO443oM20Rylh5cP5p5oRtSNE5o4MabH8C4QIUlw4aPRGJRdWSVASFzTlNyxpjM
K/YrIRz0SD5ZdaZ2RTzst1O05ZRfznFdJ/oLaxEoO8Rpr833L+XaShSatw0scQw8
aRn1JnN9Xff00UYeE/qh
=j4S3
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
