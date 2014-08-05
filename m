Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbaHESZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:25:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48320 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbaHESYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:24:47 -0400
Date: Tue, 5 Aug 2014 19:24:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140805182436.GF17528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YAj9hGQEeu6NAWot"
Content-Disposition: inline
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI updates for v3.17
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YAj9hGQEeu6NAWot
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit 19583ca584d6f574384e17fe7613dfaeadcdc4a6:

  Linux 3.16 (2014-08-03 15:25:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3=
=2E17

for you to fetch changes up to fab6a0410d20ef09238ef54b8726d170578da752:

  Merge remote-tracking branches 'spi/topic/sh', 'spi/topic/sh-msiof' and '=
spi/topic/topcliff-pch' into spi-next (2014-08-04 17:21:16 +0100)

----------------------------------------------------------------
spi: Updates for v3.17

A quiet release, more bug fixes than anything else.  A few things do
stand out though:

 - Updates to several drivers to move towards the standard GPIO chip
   select handling in the core.
 - DMA support for the SH MSIOF driver.
 - Support for Rockchip SPI controllers (their first mainline
   submission).

----------------------------------------------------------------
Addy Ke (4):
      spi/rockchip: cleanup some coding issues and uncessary output
      spi/rockchip: call wait_for_idle() for the transfer to complete
      spi/rockchip: master->mode_bits: remove SPI_CS_HIGH bit
      spi/rockchip: add compatible strings for RK3188 and RK3288

Alexander Shiyan (4):
      spi: clps711x: Remove unnecessary platform_set_drvdata()
      spi: falcon: Remove unnecessary platform_set_drvdata()
      spi: omap-100k: Remove unnecessary platform_set_drvdata()
      spi: sh-msiof: Remove unnecessary platform_set_drvdata()

Andy Gross (1):
      spi: qup: Add support for v1.1.1

Andy Shevchenko (1):
      spi: topcliff-pch: don't hardcode PCI slot to get DMA device

Geert Uytterhoeven (16):
      spi: sh-msiof: Add more register documentation
      spi: sh-msiof: Extract sh_msiof_spi_{start,stop}() helpers
      spi: sh-msiof: Improve transfer error handling
      spi: sh-msiof: Refactor sh_msiof_transfer_one()
      spi: sh-msiof: Add DMA support
      spi: rspi: Remove unused variable in rspi_rz_transfer_one()
      spi: rspi: Pass spi_master pointer to rspi_release_dma()
      spi: sh-msiof: SPI_SH_MSIOF should depend on HAS_DMA
      spi: rspi: Relax DMA dependency and increase build coverage
      spi: core: Fix check for dma_map_sg() failures
      spi: core: Pass correct device to dma_map_sg()
      spi: rspi: Handle dmaengine_prep_slave_sg() failures gracefully
      spi: sh-msiof: Handle dmaengine_prep_slave_single() failures graceful=
ly
      spi: sh-msiof: Use correct device for DMA mapping with IOMMU
      spi: topcliff-pch: Update error messages for dmaengine_prep_slave_sg(=
) API
      spi: atmel: Use dmaengine_prep_slave_sg() API

Grygorii Strashko (1):
      spi: davinci: use spi_device.cs_gpio to store gpio cs per spi device

Himangi Saraogi (3):
      spi: omap-uwire: use devm_ functions
      spi: au1550: Fix bug in deallocation of memory
      spi/spi-sh: Use devm_ioremap

Javier Martinez Canillas (1):
      spi: s3c64xx: Revert "spi: s3c64xx: Added provision for dedicated cs =
pin"

Jingoo Han (3):
      spi: cadence: Make of_device_id array const
      spi: fsl-spi: Make of_device_id array const
      spi: sh-hspi: Make of_device_id array const

Lars-Peter Clausen (3):
      spi: xilinx: Use pdev->id instead of pdev->dev.id for the SPI bus num=
ber
      spi: cadence: Make sure that clock polarity changes are applied
      spi: cadence: Configure SPI clock in the prepare_message() callback

Mark A. Greer (1):
      spi: omap2-mcspi: Configure hardware when slave driver changes mode

Mark Brown (15):
      spi: Remove unused variable
      spi: omap-uwire: Ensure devm_ioremap() is prototyped
      Merge remote-tracking branch 'spi/topic/cleanup' into spi-sh-msiof
      spi/rockchip: Add dependencies on relaxed I/O accessors
      Merge tag 'v3.16-rc3' into spi-sh-msiof
      spi/atmel: Fix pointer to int conversion warnings on 64 bit builds
      spi/pl022: Explicitly truncate large bitmask
      Merge remote-tracking branch 'spi/fix/core' into spi-linus
      Merge remote-tracking branches 'spi/fix/au1550', 'spi/fix/cadence', '=
spi/fix/omap2-mcspi' and 'spi/fix/orion' into spi-linus
      Merge remote-tracking branches 'spi/fix/s3c64xx', 'spi/fix/samsung' a=
nd 'spi/fix/xilinx' into spi-linus
      Merge remote-tracking branch 'spi/topic/core' into spi-next
      Merge remote-tracking branches 'spi/topic/adi-v3', 'spi/topic/atmel',=
 'spi/topic/cleanup' and 'spi/topic/davinci' into spi-next
      Merge remote-tracking branches 'spi/topic/dw', 'spi/topic/efm32', 'sp=
i/topic/fsl' and 'spi/topic/omap-uwire' into spi-next
      Merge remote-tracking branches 'spi/topic/orion', 'spi/topic/pl022', =
'spi/topic/qup', 'spi/topic/rockchip' and 'spi/topic/rspi' into spi-next
      Merge remote-tracking branches 'spi/topic/sh', 'spi/topic/sh-msiof' a=
nd 'spi/topic/topcliff-pch' into spi-next

Murali Karicheri (2):
      spi: davinci: fix to support more than 2 chip selects
      spi: davinci: add support to configure gpio cs through dt

Naveen Krishna Chatradhi (3):
      spi: s3c64xx: use the generic SPI "cs-gpios" property
      spi: s3c64xx: Update binding documentation
      ARM: dts: fix the chip select gpios definition in the SPI nodes

Russell King (2):
      spi: spi-orion: check return value from clk_prepare()/clk_enable()
      spi: spi-orion: add runtime PM support

Sachin Kamat (4):
      spi: spi-adi-v3: Remove redundant OOM message
      spi: Remove redundant OOM message in spi.c
      spi: omap-uwire: Fix build error
      spi: samsung: Update binding documentation

Steffen Trumtrar (1):
      spi: dw-mmio: add devicetree support

Thomas Petazzoni (1):
      spi: orion: fix incorrect handling of cell-index DT property

Uwe Kleine-K=F6nig (1):
      spi: efm32: correct namespacing of location property

Wei Yongjun (4):
      spi/rockchip: remove duplicated include from spi-rockchip.c
      spi/rockchip: remove redundant dev_err call in rockchip_spi_probe()
      spi/rockchip: fix error return code in rockchip_spi_probe()
      spi: orion: Fix error return code in orion_spi_probe()

Zhao Qiang (1):
      spi/fsl: deal with a compile warning

addy ke (2):
      spi/rockchip: add rockchip spi DT binding
      spi/rockchip: add driver for Rockchip RK3xxx SoCs integrated SPI

 .../devicetree/bindings/spi/efm32-spi.txt          |  13 +-
 .../devicetree/bindings/spi/qcom,spi-qup.txt       |   6 +-
 .../devicetree/bindings/spi/snps,dw-apb-ssi.txt    |  28 +
 .../devicetree/bindings/spi/spi-davinci.txt        |   9 +-
 .../devicetree/bindings/spi/spi-rockchip.txt       |  37 +
 .../devicetree/bindings/spi/spi-samsung.txt        |  26 +-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |   2 +-
 arch/arm/boot/dts/exynos4412-trats2.dts            |   2 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   2 +-
 drivers/spi/Kconfig                                |  16 +-
 drivers/spi/Makefile                               |   1 +
 drivers/spi/spi-adi-v3.c                           |   5 +-
 drivers/spi/spi-atmel.c                            |  22 +-
 drivers/spi/spi-au1550.c                           |   6 +-
 drivers/spi/spi-cadence.c                          |  37 +-
 drivers/spi/spi-clps711x.c                         |   2 -
 drivers/spi/spi-davinci.c                          |  72 +-
 drivers/spi/spi-dw-mmio.c                          |  19 +-
 drivers/spi/spi-efm32.c                            |   8 +-
 drivers/spi/spi-falcon.c                           |   2 -
 drivers/spi/spi-fsl-lib.c                          |   2 +-
 drivers/spi/spi-fsl-spi.c                          |   2 +-
 drivers/spi/spi-omap-100k.c                        |   2 -
 drivers/spi/spi-omap-uwire.c                       |  11 +-
 drivers/spi/spi-omap2-mcspi.c                      |  14 +
 drivers/spi/spi-orion.c                            |  78 +-
 drivers/spi/spi-pl022.c                            |   2 +-
 drivers/spi/spi-qup.c                              |  36 +-
 drivers/spi/spi-rockchip.c                         | 837 +++++++++++++++++=
++++
 drivers/spi/spi-rspi.c                             |  45 +-
 drivers/spi/spi-s3c64xx.c                          |  54 +-
 drivers/spi/spi-sh-hspi.c                          |   2 +-
 drivers/spi/spi-sh-msiof.c                         | 527 +++++++++++--
 drivers/spi/spi-sh.c                               |  15 +-
 drivers/spi/spi-topcliff-pch.c                     |  12 +-
 drivers/spi/spi-xilinx.c                           |   2 +-
 drivers/spi/spi.c                                  |  12 +-
 include/linux/spi/sh_msiof.h                       |   2 +
 38 files changed, 1725 insertions(+), 245 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/snps,dw-apb-ssi.t=
xt
 create mode 100644 Documentation/devicetree/bindings/spi/spi-rockchip.txt
 create mode 100644 drivers/spi/spi-rockchip.c

--YAj9hGQEeu6NAWot
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4SFhAAoJELSic+t+oim99LUP/14FC5cLK5YWus1ttO8D0Hk7
kOG+W/UG27m5Ic8xZeR04AcuIf1ohxwDfHecCcvCCIAUB0G9Fe48qhrjqmxC+FAo
/j8gtJMs9v87efHdiwKcP3faBWBfymdAVl+UodRcyt+oKhfuQNmOzTyAebdyjKuF
UHPlbMhJWzZJiaeyz56xKZTTZUUNhqKfZM4Xa5w5tjcMf8A72FJjlNivAbTAX4AE
gxm/1M1yATmcYRaAXq/srjXjW9uln+2fLaWxjghve5tXtaFlpX4xQiOLRQF/biKW
kna4VPKMcfKk7DQemFwjNhcW7tG4h0TB4gCdM3sLofr5WaiNY5AYtUzCMG+xQ2Pp
q3d48yitPKIClRISeOfxA74JN0h49H6b8hWkdZkSMW8k2FVVBibjUVN4utgKU+8L
/2ueEJGYQmu5sMrhpV1754n1KOygrkPcVbFpWQ08gPPWx6H5m298L+wo9gvxm8iG
pTerhTZ5Xs63ZrGzOCdjotv1oGMa+3GTt5zf+iwDr+XDZEVcZnnZ9GQPuH5Fn+Pk
FB3VAN21C5ZLAxwmT2O6TqErV3mTtfSoLPHzt+HrtDTP70MOzgjORL5jtR+XYY5V
O6CSazvN2ceZPcUXWhwHWnxIbm0F7pfiQtun4F4LC70p+PRbcasJzOeNMBpSpcmn
KyLo6w/v4XpAI5YV36yC
=JmYj
-----END PGP SIGNATURE-----

--YAj9hGQEeu6NAWot--
