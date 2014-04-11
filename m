Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaDKK4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:56:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48630 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaDKK4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:56:17 -0400
Date: Fri, 11 Apr 2014 11:56:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20140411105604.GR6518@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SKuKPt3hQSBflurX"
Content-Disposition: inline
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi fixes for v3.15
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SKuKPt3hQSBflurX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14 (2014-03-30 20:40:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.15-fixes

for you to fetch changes up to 6eadd8463101830d50e381185701d58f4ac3abb9:

  Merge remote-tracking branches 'spi/fix/complete', 'spi/fix/efm32', 'spi/fix/omap2-mcspi' and 'spi/fix/qup' into spi-linus (2014-04-10 23:39:52 +0100)

Same issue as on the regulator pull request with the entire diffstat for
the original pull request for this merge window has appeared - like I
say I will try to fix the scripts as it's annoying and unclear.

----------------------------------------------------------------

spi: Fixes for v3.15

A few driver specific fixes, the main one being the fix for handling of
complete callbacks that are open coded in individual drivers to allow
callers to omit the completion.  As we move things into the core that
sort of issue should become less and less common.

----------------------------------------------------------------
Axel Lin (3):
      spi: Always check complete callback before calling it
      spi: omap2-mcspi: Convert to use devm_kcalloc
      spi: efm32: Update binding document to make "efm32,location" property optional

Mark Brown (2):
      Merge tag 'spi-v3.15' into spi-linus
      Merge remote-tracking branches 'spi/fix/complete', 'spi/fix/efm32', 'spi/fix/omap2-mcspi' and 'spi/fix/qup' into spi-linus

Paul Bolle (1):
      spi: qup: Depend on ARCH_QCOM

 .../devicetree/bindings/spi/efm32-spi.txt          |  14 +-
 .../devicetree/bindings/spi/qcom,spi-qup.txt       |  85 +++
 Documentation/devicetree/bindings/spi/sh-hspi.txt  |  28 +-
 Documentation/devicetree/bindings/spi/sh-msiof.txt |  42 +-
 .../devicetree/bindings/spi/spi-fsl-dspi.txt       |   2 +
 Documentation/devicetree/bindings/spi/spi-rspi.txt |  61 ++
 .../devicetree/bindings/spi/spi-sun4i.txt          |  24 +
 .../devicetree/bindings/spi/spi-sun6i.txt          |  24 +
 .../devicetree/bindings/spi/spi-xtensa-xtfpga.txt  |   9 +
 Documentation/spi/spidev                           |   6 +
 Documentation/spi/spidev_fdx.c                     |   8 +-
 Documentation/spi/spidev_test.c                    |  45 +-
 MAINTAINERS                                        |   6 +
 drivers/base/power/Makefile                        |   3 +-
 drivers/base/power/runtime.c                       | 162 +++-
 drivers/spi/Kconfig                                |  55 +-
 drivers/spi/Makefile                               |   5 +-
 drivers/spi/spi-altera.c                           |   7 +-
 drivers/spi/spi-ath79.c                            |   1 -
 drivers/spi/spi-atmel.c                            |  34 +-
 drivers/spi/spi-au1550.c                           |  30 +-
 drivers/spi/spi-bcm2835.c                          |   1 -
 drivers/spi/spi-bcm63xx-hsspi.c                    |   8 +-
 drivers/spi/spi-bcm63xx.c                          |   6 +-
 drivers/spi/spi-bfin-sport.c                       |   1 -
 drivers/spi/spi-bfin-v3.c                          |   3 +-
 drivers/spi/spi-bfin5xx.c                          |   8 -
 drivers/spi/spi-bitbang.c                          |   5 +-
 drivers/spi/spi-butterfly.c                        |   3 +-
 drivers/spi/spi-clps711x.c                         | 227 +++---
 drivers/spi/spi-coldfire-qspi.c                    | 112 ++-
 drivers/spi/spi-davinci.c                          |  14 +-
 drivers/spi/spi-dw-mmio.c                          |   2 +-
 drivers/spi/spi-dw.c                               |  17 +-
 drivers/spi/spi-efm32.c                            |  46 +-
 drivers/spi/spi-ep93xx.c                           |  21 +-
 drivers/spi/spi-falcon.c                           |   5 -
 drivers/spi/spi-fsl-dspi.c                         |  94 ++-
 drivers/spi/spi-fsl-espi.c                         |   8 +-
 drivers/spi/spi-fsl-lib.c                          |  14 +-
 drivers/spi/spi-fsl-spi.c                          |  33 +-
 drivers/spi/spi-gpio.c                             |   8 +-
 drivers/spi/spi-imx.c                              |   7 +-
 drivers/spi/spi-mpc512x-psc.c                      |  20 +-
 drivers/spi/spi-mpc52xx-psc.c                      |   4 +-
 drivers/spi/spi-mpc52xx.c                          |  23 +-
 drivers/spi/spi-mxs.c                              |   7 +-
 drivers/spi/spi-nuc900.c                           |  28 +-
 drivers/spi/spi-oc-tiny.c                          |   3 -
 drivers/spi/spi-octeon.c                           |  80 +-
 drivers/spi/spi-omap-100k.c                        |  52 +-
 drivers/spi/spi-omap-uwire.c                       |  34 +-
 drivers/spi/spi-omap2-mcspi.c                      |  91 ++-
 drivers/spi/spi-orion.c                            |  80 +-
 drivers/spi/spi-pl022.c                            |  80 +-
 drivers/spi/spi-ppc4xx.c                           |   1 -
 drivers/spi/spi-pxa2xx-dma.c                       |   1 -
 drivers/spi/spi-pxa2xx-pxadma.c                    |   1 -
 drivers/spi/spi-pxa2xx.c                           |   3 +-
 drivers/spi/spi-qup.c                              | 779 +++++++++++++++++++
 drivers/spi/spi-rspi.c                             | 842 ++++++++++++++-------
 drivers/spi/spi-s3c24xx.c                          |  19 +-
 drivers/spi/spi-s3c64xx.c                          | 424 +++--------
 drivers/spi/spi-sc18is602.c                        |  29 +-
 drivers/spi/spi-sh-hspi.c                          |  43 +-
 drivers/spi/spi-sh-msiof.c                         | 385 +++++-----
 drivers/spi/spi-sh-sci.c                           |   8 +-
 drivers/spi/spi-sh.c                               |   6 +-
 drivers/spi/spi-sirf.c                             | 116 +--
 drivers/spi/spi-sun4i.c                            | 478 ++++++++++++
 drivers/spi/spi-sun6i.c                            | 484 ++++++++++++
 drivers/spi/spi-tegra114.c                         |  27 +-
 drivers/spi/spi-tegra20-sflash.c                   |  26 +-
 drivers/spi/spi-tegra20-slink.c                    |  20 +-
 drivers/spi/spi-ti-qspi.c                          |   5 +-
 drivers/spi/spi-ti-ssp.c                           | 378 ---------
 drivers/spi/spi-topcliff-pch.c                     |  47 +-
 drivers/spi/spi-txx9.c                             |  28 +-
 drivers/spi/spi-xcomm.c                            |  13 +-
 drivers/spi/spi-xilinx.c                           |  27 +-
 drivers/spi/spi-xtensa-xtfpga.c                    | 170 +++++
 drivers/spi/spi.c                                  | 247 +++++-
 drivers/spi/spidev.c                               |  23 +-
 include/linux/platform_data/spi-s3c64xx.h          |   9 +-
 include/linux/pm_runtime.h                         |   4 +
 include/linux/spi/spi.h                            |  31 +
 include/linux/spi/spi_bitbang.h                    |   2 +-
 include/uapi/linux/spi/spidev.h                    |  14 +-
 88 files changed, 4162 insertions(+), 2324 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-rspi.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-sun4i.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-sun6i.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-xtensa-xtfpga.txt
 create mode 100644 drivers/spi/spi-qup.c
 create mode 100644 drivers/spi/spi-sun4i.c
 create mode 100644 drivers/spi/spi-sun6i.c
 delete mode 100644 drivers/spi/spi-ti-ssp.c
 create mode 100644 drivers/spi/spi-xtensa-xtfpga.c

--SKuKPt3hQSBflurX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTR8pBAAoJELSic+t+oim9dl0P/j/UT1UfDTwwwylBPxB328SV
ZQG3dJN9wwXeQkrkGh6XuShh7j7Vri+7tHs1u6r5XdpHakjknRsEKRKmblKo8jxi
MR1lqwfKuAnCan4+uDSsRjSuZ7IuFfqcrn/RCVBQNKbONEFYO2lCp/M2fJroVsp3
KomRDNgwZdJBYO1kR5kwmgX/6Hpt7GT7yFU7iw8+MtzVWcXu0n0GR81L5ITBpBq7
IuCaw+rRj4oCMM0x/bqikiFIxfZ8R+SSZugH/tbzCgEyz4DGzrgZncpkSI052VTL
Uy2ZwQ6lWtFpAJjYL1z79beDSi1Ik4t0VAWkkQY7yKoYxGPLsFy8RuDCSyZL3POA
nJJMMap3OEcXQCL0eKKICXKdhA3wXdPs7lfFL6qk/sYTImo4qYsjcFxxAmkx8gtH
QWIs+VgZV9F5q7EuvhMhKnvOG9Eepohax4LQ8EcOHOiejbSpyu3Uthvhddr1R6Vt
8ewsVFdm/IUp+ivkPo5B8kSg6hRS6RmR14tP8Vf0LHyH53FW8vcrrri8bSnSi9l8
7i+HuQkbBM7+lEUu44Kchfz5pp/Uxn5Ahkv9tD2/pBHCH+lf5PtDZ14xWwsE8Iuy
717WFvs2V1/cv2neYDAtcQ+6y6flfA0MV9JIXh8csgGJ0Wclb8/N5ikBKqZ327gb
UMCEuPSBXd1+zXUkm0nX
=5tiy
-----END PGP SIGNATURE-----

--SKuKPt3hQSBflurX--
