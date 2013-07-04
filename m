Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab3GDUcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 16:32:51 -0400
Received: from sauhun.de ([89.238.76.85]:38984 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab3GDUcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 16:32:50 -0400
Date: Thu, 4 Jul 2013 22:32:40 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.11
Message-ID: <20130704203209.GA4196@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

here are the updates for the I2C subsystem for 3.11:

* new drivers: Kontron PLD, Wondermedia VT
* mv64xxx driver gained sun4i support and a bigger cleanup
* duplicate driver 'intel-mid' removed
* added generic device tree binding for sda holding time
  (and designware driver already uses it)
* we tried to allow driver probing with only device tree and no i2c ids,
  but I had to revert it because of side effects. Needs some rethinking.
* driver bugfixes, cleanups...

Sorry, the base should have been "3.10-rc4", but I accidently picked the
wrong commit and didn't want to rebase my public tree, so it is a few
merges after rc4.

Please pull.

Thanks,

   Wolfram


The following changes since commit aa4f608478acb7ed69dfcff4f3c404100b78ac49:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git=
/geert/linux-m68k (2013-06-03 18:09:42 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-next

for you to fetch changes up to 97191d734f6ac028e5e6dcd574378c1544a16c0b:

  i2c-designware: use div_u64 to fix link (2013-07-03 22:07:51 +0200)

----------------------------------------------------------------
Andy Shevchenko (1):
      i2c: intel-mid: remove obsolete driver

Arnaud Patard (1):
      i2c: imx: allow autoloading on dt ids

Christian Ruppert (2):
      i2c: designware: fix race between subsequent xfers
      i2c-designware: make SDA hold time configurable

Daniel Drake (1):
      i2c-pxa: prepare clock before use

Fabio Estevam (2):
      i2c: imx: Let device core handle pinctrl
      i2c: mxs: Let device core handle pinctrl

Gregory CLEMENT (1):
      i2c: mv64xxx: Set bus frequency to 100kHz if clock-frequency is not p=
rovided

Guenter Roeck (1):
      i2c: mv64xxx: Fix transfer error code

Jingoo Han (1):
      i2c: use platform_{get,set}_drvdata()

Kevin Hilman (1):
      i2c: iop3xxx: fix build failure after waitqueue changes

Kevin Strasser (1):
      i2c: Kontron PLD i2c bus driver

Linus Walleij (3):
      i2c: core: make it possible to match a pure device tree driver
      i2c: nomadik: support elder Nomadiks
      i2c: nomadik: allocate adapter number dynamically

Maxime Ripard (3):
      i2c: mv64xxx: Add macros to access parts of registers
      i2c: mv64xxx: make the registers offset configurable
      i2c: mv64xxx: Add Allwinner sun4i compatible

Mika Westerberg (1):
      i2c: designware: prevent signals from aborting I2C transfers

Oleksandr Dmytryshyn (1):
      i2c: omap: correct usage of the interrupt enable register

Russell King (8):
      I2C: mv64xxx: use return value from mv64xxx_i2c_map_regs()
      I2C: mv64xxx: use devm_ioremap_resource()
      I2C: mv64xxx: use devm_clk_get() to avoid missing clk_put()
      I2C: mv64xxx: use devm_kzalloc()
      I2C: mv64xxx: fix error handling for request_irq()
      I2C: mv64xxx: remove I2C_M_NOSTART code
      I2C: mv64xxx: move mv64xxx_i2c_prepare_for_io()
      I2C: mv64xxx: fix race between FSM/interrupt and process context

Seth Heasley (1):
      i2c: i801: SMBus patch for Intel Coleto Creek DeviceIDs

Sonic Zhang (1):
      i2c: bfin-twi: Read and write the FIFO in loop

Tony Prisk (1):
      i2c: vt8500: Add support for I2C bus on Wondermedia SoCs

Vincent Stehl=E9 (1):
      i2c-designware: use div_u64 to fix link

Wolfram Sang (2):
      drivers/i2c/busses: don't check resource with devm_ioremap_resource
      Revert "i2c: core: make it possible to match a pure device tree drive=
r"

 .../devicetree/bindings/i2c/i2c-designware.txt     |   15 +
 .../devicetree/bindings/i2c/i2c-mv64xxx.txt        |    6 +-
 .../devicetree/bindings/i2c/i2c-vt8500.txt         |   24 +
 Documentation/i2c/busses/i2c-i801                  |    1 +
 MAINTAINERS                                        |    1 +
 arch/arc/boot/dts/abilis_tb100_dvk.dts             |   10 +-
 arch/arc/boot/dts/abilis_tb101_dvk.dts             |   10 +-
 drivers/i2c/busses/Kconfig                         |   34 +-
 drivers/i2c/busses/Makefile                        |    3 +-
 drivers/i2c/busses/i2c-bfin-twi.c                  |   47 +-
 drivers/i2c/busses/i2c-cpm.c                       |    4 +-
 drivers/i2c/busses/i2c-davinci.c                   |    8 +-
 drivers/i2c/busses/i2c-designware-core.c           |   30 +-
 drivers/i2c/busses/i2c-designware-core.h           |    1 +
 drivers/i2c/busses/i2c-designware-platdrv.c        |   19 +-
 drivers/i2c/busses/i2c-i801.c                      |    3 +
 drivers/i2c/busses/i2c-ibm_iic.c                   |    4 +-
 drivers/i2c/busses/i2c-imx.c                       |   15 +-
 drivers/i2c/busses/i2c-intel-mid.c                 | 1121 ----------------=
----
 drivers/i2c/busses/i2c-iop3xx.c                    |    2 +-
 drivers/i2c/busses/i2c-kempld.c                    |  410 +++++++
 drivers/i2c/busses/i2c-mpc.c                       |    4 +-
 drivers/i2c/busses/i2c-mv64xxx.c                   |  321 +++---
 drivers/i2c/busses/i2c-mxs.c                       |    6 -
 drivers/i2c/busses/i2c-nomadik.c                   |   52 +-
 drivers/i2c/busses/i2c-omap.c                      |   23 +-
 drivers/i2c/busses/i2c-pxa.c                       |    6 +-
 drivers/i2c/busses/i2c-rcar.c                      |    7 +-
 drivers/i2c/busses/i2c-wmt.c                       |  479 +++++++++
 29 files changed, 1268 insertions(+), 1398 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-vt8500.txt
 delete mode 100644 drivers/i2c/busses/i2c-intel-mid.c
 create mode 100644 drivers/i2c/busses/i2c-kempld.c
 create mode 100644 drivers/i2c/busses/i2c-wmt.c

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1dvJAAoJEBQN5MwUoCm2vz8QAKYgd1fH8jCM4Vdk/Ou4t8QN
9mNJUc2QcJ7t91/asobzt9Jy5cU5gSW3qTRc2WBzN+eKLlJr0bHycMgqRjsDKKBA
9khnDB4INVcRnIb2Wpx/fN5cIhjBhSn8hHr58vNiAR0IU0S6VwEW1BRrcXYj3NK/
uE3jeriL5DBXMOGH/AxtPLupQk1tFE+tL9r1Y7cTQ2BKDZceFG5evpU+sSzaSq89
65ar9HHZISdVTfgYlqkyz3E2hYQp7cVoDOZyEda5Y47RxYanSkrbolrpTfkbK8sp
G32OK0ysSsWwC7s+Bg5mSFndRkecTNozlRWyUK86WBG+Sj1OPKnia3NO8zSuNnwq
IRp99w4G5WrvdlA0DgMIqHi5yRi9XrxrstvGE3/vy9j+XdI+J2G8DEZjFk0gi4OX
hr7FtBvx0IZ7Dc5SGyaRqNL+Qy+MHeZ6Jap337bs7A1dgWxHdmKda7TKJgsWhAjq
UPr42EOQPCK28vrJSae4J5vwX05iioUzPf2mw35m4Bj2fPd+ZCWIf19Qlv5ia1W5
roNgJNONBrJP701J88mcRclT4W4mQ4wtKqP2c2xwmc76ltj8xqTPuVjY82OxbTBZ
u5qZdwfdZ9c1z0cz02qONfXO/jzkrNoILaXrgUNKeJsohOk/TNYcJ4RNbGfxvg6+
I4iYG19rWOYe1W/JTDXe
=DSrh
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
