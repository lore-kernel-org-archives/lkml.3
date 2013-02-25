Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab3BYU1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 15:27:44 -0500
Received: from sauhun.de ([89.238.76.85]:42828 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab3BYU1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:27:42 -0500
Date: Mon, 25 Feb 2013 21:27:35 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.9
Message-ID: <20130225202735.GA1928@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

here are the changes for the i2c subsystem for 3.9. Highlights:

* new drivers for Intel ismt & Broadcom bcm2835
* a number of drivers got support for more variants and mostly got cleaned =
up
  on the way (sis630, i801, at91, tegra, designware)
* i2c got rid of all *_set_drvdata(..., NULL) on remove/probe failure
* removed the i2c_smbus_process_call from the core since there are no
  users
* mxs can now switch between PIO and DMA depending on the message size
  and the bus speed can now be arbitrary

In addition, there is the usual bunch of fixes, cleanups, devm_*
conversions, etc. Please pull.

Thanks,

   Wolfram


The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-next

for you to fetch changes up to 55827f4aa6442ddd1d6a4e1e32f2f457eb113c22:

  i2c: Remove unneeded xxx_set_drvdata(..., NULL) calls (2013-02-22 00:25:5=
0 +0100)

----------------------------------------------------------------
Alexander Stein (1):
      i2c: isch: Add module parameter for backbone clock rate if divider is=
 unset

Amaury Decr=EAme (6):
      i2c: sis630: Add SIS964 support
      i2c: sis630: clear sticky bits
      i2c: sis630: fix behavior after collision
      i2c: sis630: use hex to constants for SMBus commands
      i2c: sis630: display unsigned hex
      i2c: sis630: checkpatch cleanup

Dmitry Torokhov (1):
      i2c: pxa: remove incorrect __exit annotations

Doug Anderson (1):
      i2c: Remove unneeded xxx_set_drvdata(..., NULL) calls

Giridhar Maruthy (1):
      i2c: s3c2410: Add quirk to exclude GPIO config for exynos5440

Guennadi Liakhovetski (4):
      i2c: sh_mobile: cosmetic: trivially simplify 2 functions
      i2c: sh_mobile: fix timeout error handling
      i2c: sh_mobile: eliminate an open-coded "goto" loop
      i2c: sh_mobile: don't send a stop condition by default inside transfe=
rs

James Ralston (1):
      i2c: i801: Add Device IDs for Intel Wellsburg PCH

Jayachandran C (1):
      i2c: ocores: Fix pointer to integer cast warning

Joachim Eastwood (2):
      i2c: at91: add of_device_id entry for at91rm9200
      i2c: at91: fix unsed variable warning when building with !CONFIG_OF

Lars Poeschel (1):
      drivers: misc: at24: mention other supported types in Kconfig

Laurent Navet (1):
      i2c: nforce2: fix coding style issues

Laxman Dewangan (2):
      i2c: tegra: add support for Tegra114 SoC
      i2c: tegra: remove warning dump if timeout happen in transfer

Marek Vasut (2):
      i2c: mxs: Add PIO and mixed-DMA support
      i2c: mxs: Implement arbitrary clock speed derivation algorithm

Mika Westerberg (3):
      i2c-designware: always set the STOP bit after last byte
      i2c-designware: add minimal support for runtime PM
      i2c-designware: add support for Intel Lynxpoint

Neil Horman (2):
      i2c: Adding support for Intel iSMT SMBus 2.0 host controller
      i2c: ismt: Add Seth and Myself as maintainers

Patrice Chotard (1):
      i2c: nomadik: adopt pinctrl support

Randy Dunlap (1):
      i2c: fix i2c-ismt.c printk format warning

Seth Heasley (1):
      i2c: i801: SMBus patch for Intel Avoton DeviceIDs

Stephen Warren (1):
      i2c: add bcm2835 driver

Tushar Behera (5):
      i2c: core: Remove definition of i2c_smbus_process_call
      i2c: s3c2410: Remove unnecessary label err_noclk
      i2c: s3c2410: Convert to use devm_* APIs
      i2c: s3c2410: Move location of clk_prepare_enable() call in probe fun=
ction
      i2c: s3c2410: Remove err_cpufreq label

Wolfram Sang (1):
      i2c: nomadik: drop superfluous variable initialization

 .../devicetree/bindings/i2c/brcm,bcm2835-i2c.txt   |   20 +
 .../devicetree/bindings/i2c/i2c-s3c2410.txt        |    2 +
 Documentation/i2c/busses/i2c-i801                  |    2 +
 Documentation/i2c/busses/i2c-ismt                  |   36 +
 Documentation/i2c/busses/i2c-sis630                |    9 +
 Documentation/i2c/smbus-protocol                   |    4 +-
 Documentation/i2c/writing-clients                  |    4 +-
 MAINTAINERS                                        |    7 +
 drivers/i2c/busses/Kconfig                         |   28 +-
 drivers/i2c/busses/Makefile                        |    2 +
 drivers/i2c/busses/i2c-at91.c                      |   17 +-
 drivers/i2c/busses/i2c-au1550.c                    |    1 -
 drivers/i2c/busses/i2c-bcm2835.c                   |  342 +++++++
 drivers/i2c/busses/i2c-bfin-twi.c                  |    2 -
 drivers/i2c/busses/i2c-cpm.c                       |    2 -
 drivers/i2c/busses/i2c-davinci.c                   |    2 -
 drivers/i2c/busses/i2c-designware-core.c           |   16 +-
 drivers/i2c/busses/i2c-designware-pcidrv.c         |    2 -
 drivers/i2c/busses/i2c-designware-platdrv.c        |   61 +-
 drivers/i2c/busses/i2c-eg20t.c                     |    2 -
 drivers/i2c/busses/i2c-highlander.c                |    4 -
 drivers/i2c/busses/i2c-i801.c                      |   19 +-
 drivers/i2c/busses/i2c-ibm_iic.c                   |    3 -
 drivers/i2c/busses/i2c-imx.c                       |    1 -
 drivers/i2c/busses/i2c-intel-mid.c                 |    2 -
 drivers/i2c/busses/i2c-iop3xx.c                    |    2 -
 drivers/i2c/busses/i2c-isch.c                      |   17 +
 drivers/i2c/busses/i2c-ismt.c                      |  963 ++++++++++++++++=
++++
 drivers/i2c/busses/i2c-mpc.c                       |    2 -
 drivers/i2c/busses/i2c-mxs.c                       |  272 ++++--
 drivers/i2c/busses/i2c-nforce2.c                   |  152 +--
 drivers/i2c/busses/i2c-nomadik.c                   |  100 +-
 drivers/i2c/busses/i2c-ocores.c                    |    3 +-
 drivers/i2c/busses/i2c-octeon.c                    |    5 +-
 drivers/i2c/busses/i2c-omap.c                      |    3 -
 drivers/i2c/busses/i2c-pca-platform.c              |    1 -
 drivers/i2c/busses/i2c-pmcmsp.c                    |    2 -
 drivers/i2c/busses/i2c-pnx.c                       |    2 -
 drivers/i2c/busses/i2c-powermac.c                  |    1 -
 drivers/i2c/busses/i2c-puv3.c                      |    2 -
 drivers/i2c/busses/i2c-pxa-pci.c                   |    2 -
 drivers/i2c/busses/i2c-pxa.c                       |    6 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   61 +-
 drivers/i2c/busses/i2c-s6000.c                     |    1 -
 drivers/i2c/busses/i2c-sh7760.c                    |    1 -
 drivers/i2c/busses/i2c-sh_mobile.c                 |  152 +--
 drivers/i2c/busses/i2c-sis630.c                    |  360 ++++----
 drivers/i2c/busses/i2c-stu300.c                    |    1 -
 drivers/i2c/busses/i2c-taos-evm.c                  |    2 -
 drivers/i2c/busses/i2c-tegra.c                     |   79 +-
 drivers/i2c/busses/i2c-versatile.c                 |    2 -
 drivers/i2c/busses/i2c-xiic.c                      |    2 -
 drivers/i2c/busses/i2c-xlr.c                       |    1 -
 drivers/i2c/busses/scx200_acb.c                    |    1 -
 drivers/i2c/i2c-core.c                             |   23 -
 drivers/i2c/muxes/i2c-mux-gpio.c                   |    1 -
 drivers/misc/eeprom/Kconfig                        |   11 +-
 57 files changed, 2310 insertions(+), 513 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/brcm,bcm2835-i2c.=
txt
 create mode 100644 Documentation/i2c/busses/i2c-ismt
 create mode 100644 drivers/i2c/busses/i2c-bcm2835.c
 create mode 100644 drivers/i2c/busses/i2c-ismt.c

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRK8kyAAoJEBQN5MwUoCm2lvMP/A6yNI2sFKnYGrSX48+jdGOR
RL81drbpze5UBZl+5nD82RHn5U5Afb9y40xrtdwseAJJlrsXOWbGIl+LPZiR5iUy
635NvT637G39dxOw+L1dShzxCzvZrILBoDneX/L8gnUN3SLqRGTKbXrW8FsUVstm
uICzqnQuhK9zMVTEEY3hpbhjfe35xQsJSgBh7pahXCfIIoUY65Q97813MGlomr7f
WEaEUgxFdSGsoZH6/nWdG9nm2A0eysE41hG0tdvANhu9UZ8zj+ywsicJkCEqCZwN
tdgyGgIEQU+DNVExiW6cCM5XPZTQYptyuCirqJ06QLWeK+zyCZMq7tsAWNOe5agF
AEEMwwEmfyjiUMao0My3rkb9Tp5cqx3vbrMoDdHirn78eSQmXUqWbnrPSWyaVxDr
tIbywmnEXKJJT/HbiVWqA5hhBtrQQLiEVt5sCrEIt78WM4VQpXZRBv2cR8zFxvP5
F3KftqI43IP0u1Wzl1eh6gm8aR6yl3fAU0w9m5ZgVxLCLiIo1buk12nSjvF9jmNn
rDLeolX+CfnX85a3DsSpjO5bC7UHR+morhcKGsRxA/eSdWJqmalUTPnvINBGHXl3
0q320eeniEPw+1ZU8QqEmStx+JWvQ/bGGWIjZP1uSpuGNBuTVHwRGVToNmRKZIHP
Tjr3+Mi22yD3FNG/HNLb
=WMRh
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
