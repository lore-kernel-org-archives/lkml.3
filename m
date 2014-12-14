Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaLNNi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 08:38:59 -0500
Received: from sauhun.de ([89.238.76.85]:40481 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbaLNNiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 08:38:55 -0500
Date: Sun, 14 Dec 2014 14:38:50 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.19
Message-ID: <20141214133845.GA4604@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

for 3.19, the I2C subsystem has to offer special candy this time. Right
in time for Christmas :)

* I2C slave framework: finally, a generic mechanism for Linux being
  an I2C slave (if the bus driver supports that). Docs are still missing
  but will come later this cycle, the code is good enough to go.
* I2C muxes represent their topology in sysfs much more detailed.
  This will help users to navigate around much easier.
* irq population of i2c clients is now done at probe time, not device
  creation time, to have better support for deferred probing.
* new drivers for Imagination SCB, Amlogic Meson
* DMA support added for Freescale IMX, Renesas SHMobile
* slightly bigger driver updates to OMAP, i801, AT91, and rk3x
  (mostly quirk handling, timing updates, and using better kernel
  interfaces)
* eeprom driver can now write with byte-access (very slow, but OK to
  have)
* and the bunch of smaller fixes, cleanups, ID updates...

Plese pull!

Thanks,

   Wolfram


The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-3.19

for you to fetch changes up to 6cf710d47633be388e831713738626d1911163c8:

  i2c: sh_mobile: remove unneeded DMA mask (2014-12-11 22:28:22 +0100)

----------------------------------------------------------------
Alexander Kochetkov (5):
      i2c: omap: cleanup register definitions
      i2c: omap: implement workaround for handling invalid BB-bit values
      i2c: omap: don't reset controller if Arbitration Lost detected
      i2c: omap: add notes related to i2c multimaster mode
      omap: i2c: don't check bus state IP rev3.3 and earlier

Andrew Bresticker (1):
      i2c: img-scb: Allow building for MIPS

Arnd Bergmann (1):
      i2c: at91: remove legacy DMA support

Beniamino Galvani (1):
      i2c: add support for Amlogic Meson I2C controller

Christian Gmeiner (1):
      eeprom: at24: extend driver to allow writing via i2c_smbus_write_byte_data

Danielle Costantino (1):
      i2c: mpc: report correct I2C error return codes

Devin Ryles (1):
      i2c: i801: Add DeviceIDs for SunrisePoint LP

Doug Anderson (1):
      i2c: designware: Fix falling time bindings doc

Fabio Estevam (1):
      i2c: imx+mxs: Use the preferred form for passing a size of a struct

Geert Uytterhoeven (5):
      i2c: sh_mobile: Document SoC-specific bindings
      i2c: sh_mobile: Add support for r8a73a4 and sh73a0
      i2c: core: Fix probing of i2c slaves without interrupts
      DT: i2c: Add more devices handled by the rtc-rs5c372 driver
      DT: i2c: Add more devices handled by the adxl34x-i2c driver

Gerlando Falauto (1):
      i2c: mux: create "channel-n" symlinks for child segments in the mux device

Grygorii Strashko (1):
      i2c: davinci: switch to use platform_get_irq

James Hogan (2):
      DT: i2c: Add binding document for IMG I2C SCB
      i2c: img-scb: Add Imagination Technologies I2C SCB driver

Jean Delvare (4):
      i2c: i801: Use wait_event_timeout to wait for interrupts
      i2c: i801: Fallback to polling if request_irq() fails
      i2c: i801: Check if interrupts are disabled
      i2c: i801: Drop useless debug message

Lars-Peter Clausen (1):
      Documentation: i2c: Use PM ops instead of legacy suspend/resume

Laurent Pinchart (2):
      of/irq: Export of_irq_get()
      i2c: core: Map OF IRQ at probe time

Ludovic Desroches (1):
      i2c: at91: enable probe deferring on dma channel request

Max Schwarz (2):
      i2c: rk3x: handle dynamic clock rate changes correctly
      i2c: rk3x: add Kconfig dependency on COMMON_CLK

Mike Looijmans (1):
      i2c: davinci: don't use interruptible completion

Pankaj Dubey (1):
      i2c: s3c2410: Handle i2c sys_cfg register in i2c driver

Petr Cvek (1):
      i2c: pxa: add support for SCCB devices

Thomas Gessler (1):
      i2c: xiic: Fix big-endian register access

Wenyou Yang (3):
      i2c: at91: add support for runtime PM
      i2c: at91: add support for system PM
      i2c: at91: adopt pinctrl support

Wolfram Sang (14):
      i2c: exynos5: use proper errno for timeout
      i2c: sh_mobile: sort includes alphabetically
      i2c: sh_mobile: add DMA support
      i2c: sh_mobile: improve success message
      i2c: acpi: remove unneeded variable initialization
      i2c: mux: create symlink to actual mux device
      i2c: imx: simplify i2c_imx_dma_write() a little
      i2c: sh_mobile: use proper device for mapping DMA memory
      i2c: sh_mobile: optimize irq entry
      MAINTAINERS: add I2C dt bindings also to I2C realm
      i2c: core changes for slave support
      i2c: slave-eeprom: add eeprom simulator driver
      i2c: rcar: add slave support
      i2c: sh_mobile: remove unneeded DMA mask

Yao Yuan (2):
      i2c: imx: Sort include headers alphabetically
      i2c: imx: add DMA support for freescale i2c driver

addy ke (1):
      i2c: rk3x: adjust the LOW divison based on characteristics of SCL

 .../devicetree/bindings/i2c/i2c-designware.txt     |    4 +-
 .../devicetree/bindings/i2c/i2c-img-scb.txt        |   26 +
 Documentation/devicetree/bindings/i2c/i2c-imx.txt  |   11 +
 .../devicetree/bindings/i2c/i2c-meson.txt          |   24 +
 .../devicetree/bindings/i2c/i2c-sh_mobile.txt      |   14 +
 .../devicetree/bindings/i2c/trivial-devices.txt    |    8 +
 Documentation/i2c/busses/i2c-i801                  |    1 +
 Documentation/i2c/upgrading-clients                |    6 +-
 Documentation/i2c/writing-clients                  |    8 +-
 MAINTAINERS                                        |    1 +
 drivers/i2c/Kconfig                                |   10 +
 drivers/i2c/Makefile                               |    1 +
 drivers/i2c/busses/Kconfig                         |   20 +-
 drivers/i2c/busses/Makefile                        |    2 +
 drivers/i2c/busses/i2c-at91.c                      |  127 +-
 drivers/i2c/busses/i2c-davinci.c                   |   24 +-
 drivers/i2c/busses/i2c-exynos5.c                   |    4 +-
 drivers/i2c/busses/i2c-i801.c                      |   57 +-
 drivers/i2c/busses/i2c-img-scb.c                   | 1412 ++++++++++++++++++++
 drivers/i2c/busses/i2c-imx.c                       |  354 ++++-
 drivers/i2c/busses/i2c-meson.c                     |  492 +++++++
 drivers/i2c/busses/i2c-mpc.c                       |   18 +-
 drivers/i2c/busses/i2c-mxs.c                       |    2 +-
 drivers/i2c/busses/i2c-omap.c                      |  133 +-
 drivers/i2c/busses/i2c-pxa.c                       |   19 +-
 drivers/i2c/busses/i2c-rcar.c                      |  124 +-
 drivers/i2c/busses/i2c-rk3x.c                      |  251 +++-
 drivers/i2c/busses/i2c-s3c2410.c                   |   29 +
 drivers/i2c/busses/i2c-sh_mobile.c                 |  244 +++-
 drivers/i2c/busses/i2c-xiic.c                      |   58 +-
 drivers/i2c/i2c-core.c                             |   64 +-
 drivers/i2c/i2c-mux.c                              |   12 +
 drivers/i2c/i2c-slave-eeprom.c                     |  170 +++
 drivers/misc/eeprom/at24.c                         |   35 +-
 drivers/of/irq.c                                   |    1 +
 include/linux/i2c.h                                |   29 +
 36 files changed, 3608 insertions(+), 187 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-img-scb.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-meson.txt
 create mode 100644 drivers/i2c/busses/i2c-img-scb.c
 create mode 100644 drivers/i2c/busses/i2c-meson.c
 create mode 100644 drivers/i2c/i2c-slave-eeprom.c

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUjZLlAAoJEBQN5MwUoCm2l6QP/1wXEMBcw1wkzHbZLuvKyenm
Aobz3V6w+At12zC45OnTR4jMBFjLhN8yyiqUEbNWiYqNWSoJ4goWwny6M7YrhHiZ
qJWoo6pK//0byQ5QH4kKV/dDoBRSyPzIPNtyjiO4oecS8Hk5sawALEL/qqzP175S
/Y8tJoicew50YSRp17o+/nUoCneTZvQ2KNSTS/va3fRDiTUddgJ9Z8mdNRQM5QxB
xrm/xuvt3mXWFVpNZHoPCRlgVCmT/p/hKd6Rxjbzyw5iNENAevQe+mKuogbIHvbL
uY8tRSN44P7pMuFDW9N/5DEs3phYbQ2XedcWAWSUTbiZoBo+grHmgP4vSS0qn5Mg
ZLIaZ7FINttAKW16sR1tPOgdA62y1nI3mlhFwhBez5hgEIUigzit/0K/pAOzDYUe
DOh4BeplcdPD/qCOninus2KE/Yjo6r5yQ4gR9eL+L4SDi2JUlH9OVBvABoxR7Yxf
fQ+0jxDJmAPa0JZxdjZp9XwLS8h0uxHCBJkjh4Gb1/7LuJoEq1aJ4aqYDggY6enw
OxSMGZm2zs95O14YpkZbrywf4G2y6rcQZhdDEsO82qFUM6/v5/zmvtolAYa0yWbt
4KQ5Q1wdHwwz8fP2O7+S5/cHVKS62QC1X2GU4+Bb77o2QQ1mNWglpuYhDub3ibwl
vQMHYTfZU6SdiMr3AtaW
=0LMz
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
