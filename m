Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3GAJ7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:59:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58722 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3GAJ7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:59:02 -0400
Date: Mon, 1 Jul 2013 10:58:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20130701095839.GZ27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61eHsZuYkC5A4zTM"
Content-Disposition: inline
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi updates for v3.11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--61eHsZuYkC5A4zTM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.11

for you to fetch changes up to ed893559c9799df3b32051871c22017151394d82:

  Merge remote-tracking branch 'spi/topic/xilinx' into spi-next (2013-06-26 16:21:06 +0100)

----------------------------------------------------------------

spi: Updates for v3.11

A fairly quiet release for the SPI subsystem, the standout changes
being:

- Core support for implementing bits per word constraints implemented by
  Stephen Warren, factoring some code out of drivers.
- Addition of polling mode support for the s3c64xx driver as some newer
  Exynos systems have taken the unusual step of removing interrupt
  support.
- Use of the in-IP FIFO and generic dmaengine support for the OMAP2
  driver, providing improved performance.
- Conversion of the mpc512x driver to use the core message queue
  infrastructure.

The nicest thing being that all the factoring out into common code leads
to a negative diffstat overall.

----------------------------------------------------------------
Arnd Bergmann (1):
      spi: sirf: avoid uninitialized-use warning

Fabio Estevam (2):
      spi: spi-imx: Let device core handle pinctrl
      spi: spi-mxs: Let device core handle pinctrl

Gerhard Sittig (3):
      spi: mpc512x: minor prep before feature change
      spi: mpc512x: improve throughput in the RX/TX func
      spi: mpc512x: use the SPI subsystem's message queue

Girish K S (3):
      spi: s3c64xx: added support for polling mode
      spi: s3c64xx: Added provision for dedicated cs pin
      spi: s3c64xx: Added support for exynos5440 spi

Illia Smyrnov (2):
      spi: omap2-mcspi: Move bytes per word calculation to the function
      spi: omap2-mcspi: Add FIFO buffer support

Jingoo Han (2):
      spi: remove unnecessary platform_set_drvdata()
      spi: use platform_{get,set}_drvdata()

Laurent Navet (1):
      spi: bmc2835: use devm_ioremap_resource()

Linus Walleij (1):
      spi: pl022: use DMA by default when probing from DT

Mark Brown (28):
      spi/omap2: Let device core handle pinctrl
      spi/sirf: Let device core handle pinctrl
      spi/s3c64xx: Make wait_for_timeout() function name less generic
      spi/s3c64xx: Rely on the compiler eliminating the OF ID table
      Merge remote-tracking branch 'spi/fix/pxa' into spi-linus
      Merge remote-tracking branch 'spi/fix/s3c64xx' into spi-linus
      Merge remote-tracking branch 'spi/fix/xilinx' into spi-linus
      Merge remote-tracking branch 'spi/topic/atmel' into spi-next
      Merge remote-tracking branch 'spi/topic/bcm2835' into spi-next
      Merge remote-tracking branch 'spi/topic/bpw' into spi-next
      Merge remote-tracking branch 'spi/topic/coldfire-qspi' into spi-next
      Merge remote-tracking branch 'spi/topic/core' into spi-next
      Merge remote-tracking branch 'spi/topic/ep93xx' into spi-next
      Merge remote-tracking branch 'spi/topic/fsl' into spi-next
      Merge remote-tracking branch 'spi/topic/imx' into spi-next
      Merge remote-tracking branch 'spi/topic/mpc512x' into spi-next
      Merge remote-tracking branch 'spi/topic/mxs' into spi-next
      Merge remote-tracking branch 'spi/topic/nuc900' into spi-next
      Merge remote-tracking branch 'spi/topic/omap' into spi-next
      Merge remote-tracking branch 'spi/topic/pdata' into spi-next
      Merge remote-tracking branch 'spi/topic/pl022' into spi-next
      Merge remote-tracking branch 'spi/topic/pxa' into spi-next
      Merge remote-tracking branch 'spi/topic/s3c24xx' into spi-next
      Merge remote-tracking branch 'spi/topic/s3c64xx' into spi-next
      Merge remote-tracking branch 'spi/topic/sirf' into spi-next
      Merge remote-tracking branch 'spi/topic/topcliff' into spi-next
      Merge remote-tracking branch 'spi/topic/txx9' into spi-next
      Merge remote-tracking branch 'spi/topic/xilinx' into spi-next

Matt Porter (2):
      spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
      spi: omap2-mcspi: add generic DMA request support to the DT binding

Michal Simek (1):
      spi: spi-xilinx: Add run run-time endian detection

Mika Westerberg (3):
      spi/pxa2xx: fix compile warning in pxa2xx_spi_acpi_get_pdata()
      spi/pxa2xx: convert to dma_request_slave_channel_compat()
      spi/pxa2xx: add Intel BayTrail ACPI ID

Qipan Li (1):
      spi: sirf: fix the issue while transferring more than 256 words

Richard Genoud (1):
      spi: atmel: convert to dma_request_slave_channel_compat()

Sachin Kamat (7):
      spi: spi-imx: Fix compilation error
      spi: spi-s3c24xx: Remove redundant platform_set_drvdata()
      spi: spi-txx9: Remove redundant platform_set_drvdata()
      spi: spi-xilinx: Remove redundant platform_set_drvdata()
      spi: spi-topcliff-pch: Fix sparse warnings
      spi: spi-fsl-lib: Make mpc8xxx_spi_work static
      spi: spi-nuc900: Remove redundant platform_set_drvdata()

Stephen Warren (5):
      spi: introduce macros to set bits_per_word_mask
      spi: convert drivers to use bits_per_word_mask
      spi: fix undefined behaviour in SPI_BPW_RANGE_MASK
      spi: fix incorrect handling of min param in SPI_BPW_RANGE_MASK
      spi: fix build break in spi-fsl-espi.c

Wei Yongjun (2):
      spi: ep93xx: fix error return code in ep93xx_spi_probe()
      spi: coldfire-qspi: fix error return code in mcfqspi_probe()

dan.carpenter@oracle.com (1):
      spi: spi-xilinx: cleanup a check in xilinx_spi_txrx_bufs()

 Documentation/devicetree/bindings/spi/omap-spi.txt |  27 +-
 drivers/mfd/timberdale.c                           |   1 -
 drivers/spi/spi-altera.c                           |  14 -
 drivers/spi/spi-ath79.c                            |   6 +-
 drivers/spi/spi-atmel.c                            |  51 +--
 drivers/spi/spi-au1550.c                           |  14 +-
 drivers/spi/spi-bcm2835.c                          |   7 +-
 drivers/spi/spi-bcm63xx.c                          |  23 +-
 drivers/spi/spi-bfin-sport.c                       |  13 +-
 drivers/spi/spi-bfin5xx.c                          |  24 +-
 drivers/spi/spi-clps711x.c                         |   9 +-
 drivers/spi/spi-coldfire-qspi.c                    |  23 +-
 drivers/spi/spi-davinci.c                          |  12 +-
 drivers/spi/spi-dw-mmio.c                          |   2 -
 drivers/spi/spi-dw.c                               |  26 +-
 drivers/spi/spi-ep93xx.c                           |  14 +-
 drivers/spi/spi-fsl-espi.c                         |   9 +-
 drivers/spi/spi-fsl-lib.c                          |   2 +-
 drivers/spi/spi-fsl-spi.c                          |   2 +-
 drivers/spi/spi-gpio.c                             |   6 +-
 drivers/spi/spi-imx.c                              |  17 +-
 drivers/spi/spi-mpc512x-psc.c                      | 341 +++++++++++----------
 drivers/spi/spi-mpc52xx-psc.c                      |   2 +-
 drivers/spi/spi-mpc52xx.c                          |   4 +-
 drivers/spi/spi-mxs.c                              |  13 +-
 drivers/spi/spi-nuc900.c                           |  15 -
 drivers/spi/spi-oc-tiny.c                          |   2 -
 drivers/spi/spi-omap-100k.c                        |  16 +-
 drivers/spi/spi-omap-uwire.c                       |   4 +-
 drivers/spi/spi-omap2-mcspi.c                      | 254 +++++++++++----
 drivers/spi/spi-orion.c                            |   4 +-
 drivers/spi/spi-pl022.c                            |   1 +
 drivers/spi/spi-ppc4xx.c                           |  19 +-
 drivers/spi/spi-pxa2xx-dma.c                       |  13 +-
 drivers/spi/spi-pxa2xx.c                           |  62 +---
 drivers/spi/spi-rspi.c                             |   4 +-
 drivers/spi/spi-s3c24xx.c                          |   2 -
 drivers/spi/spi-s3c64xx.c                          | 209 +++++++++----
 drivers/spi/spi-sh-hspi.c                          |   4 +-
 drivers/spi/spi-sh.c                               |   4 +-
 drivers/spi/spi-sirf.c                             |  61 +---
 drivers/spi/spi-tegra114.c                         |   4 +-
 drivers/spi/spi-tegra20-sflash.c                   |   4 +-
 drivers/spi/spi-tegra20-slink.c                    |   4 +-
 drivers/spi/spi-ti-ssp.c                           |  16 +-
 drivers/spi/spi-topcliff-pch.c                     |  25 +-
 drivers/spi/spi-txx9.c                             |  10 +-
 drivers/spi/spi-xcomm.c                            |  12 +-
 drivers/spi/spi-xilinx.c                           |  48 ++-
 include/linux/spi/spi.h                            |   3 +
 include/linux/spi/xilinx_spi.h                     |   1 -
 51 files changed, 712 insertions(+), 751 deletions(-)

--61eHsZuYkC5A4zTM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0VLMAAoJELSic+t+oim9XhsP/0slxm/koSdIWQoxcdVW1QtP
STNzmTZhPd9tWeRAmFv8+PploN3yVH/kCrx/HEuZdeX12dDdmOqMFxpfM6JMp0k8
EA1XVLkJGl4GVIOz5/mBuxv1GITaSKVkjhCh2P9+2fPYGulmJfZJTPuiroHlmpxI
jYDSxWhLwmMacENhOEdcH1CiTfy7Y2q0Ox1Y18rgR5zsjJ05Q+L3clFZ626RF62o
cwxKN5fd7PB3gRkDSMY9T+65ff4A8aFi4BjD7agRMkxLt885IYCm3IVgen4PVcEj
JZWB/Uty2CFBRsnJg8Pt5FM4d3XG7ixLnM1mzELfqmXdYMr10aHgF8ktQMac/DdY
tQaJTHcpH/weUz0/XmD7dvbuJVizJXspViGuj7bImedrVL4nNKX/o6818MNZi0Z1
CBQXR35FmfsYTgdgW9n6g+4EanxzpxkdytUuyfWoQ72MxeORWxGNk5uOMC0Ytx9O
Jxb7CNqHvRDUU68PCgCT+pI3FC4Go/+dbEsXmSjYfDkDjfxAgMXwg/9E8gh2iM9o
yetSYv47RtiQXze9KtFiXc5k5yIezwRnGfqvI8EgPusuxZhD+wDiYXFMMSdlg1xR
MDHPfvIQJNCNMdBhYhRH9CkgZmnzZRDNrb12PYz9WbjEqS3YSKTg32LmW6bOeIIQ
Pn8KZIL7JXkWNarOoXJ8
=8nG8
-----END PGP SIGNATURE-----

--61eHsZuYkC5A4zTM--
