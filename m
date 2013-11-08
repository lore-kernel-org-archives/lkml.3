Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab3KHKuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:50:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45624 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab3KHKuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:50:46 -0500
Date: Fri, 8 Nov 2013 10:50:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20131108105013.GJ2493@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZaBLw/ITdVUrVb8x"
Content-Disposition: inline
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.69.173
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi updates for v3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZaBLw/ITdVUrVb8x
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit 31d141e3a666269a3b6fcccddb0351caf7454240:

  Linux 3.12-rc6 (2013-10-19 12:28:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3=
=2E13

for you to fetch changes up to 82f85cf98f0eb60093e8b3d606711c2d49538478:

  Merge remote-tracking branch 'spi/topic/wr' into spi-next (2013-10-25 09:=
51:41 +0100)

----------------------------------------------------------------

spi: Updates for v3.13

As well as the usual driver updates and cleanups there's a few
improvements to the core here:

 - The start of some improvements to factor out more of the SPI message
   loop into the core.  Right now this is just simplifying the code a
   bit but hopefully next time around we'll also have managed to roll
   out some noticable performance improvements which drivers can take
   advantage of.
 - Support for loading modules for ACPI enumerated SPI devices.
 - Managed registration for SPI controllers.
 - Helper for another common I/O pattern.

----------------------------------------------------------------
Axel Lin (4):
      spi: tegra: Use DIV_ROUND_UP instead of open coded
      spi: bitbang: Let spi_bitbang_start() take a reference to master
      spi: efm32: Don't call kfree() after spi_master_put()
      spi: bitbang: Let spi_bitbang_start() take a reference to master

Dan Carpenter (1):
      spi: spi-topcliff-pch: fix a pci_iomap() check

Greg Kroah-Hartman (1):
      spi: convert bus code to use dev_groups

Hiep Cao Minh (2):
      spi: rcar: add Renesas QSPI support on RSPI
      spi/rspi: Fix 8bit data access, clear buffer

Huang Shijie (1):
      spi: spi-imx: only enable the clocks when we start to transfer a mess=
age

Illia Smyrnov (1):
      spi: omap2-mcspi: Fix FIFO support for transmit-and-receive mode

Jarkko Nikula (3):
      spi: Fix modalias for ACPI enumerated SPI devices
      spi: Add missing newline to dev_ prints in drivers
      spi: Don't break user-visible strings to multiple source lines in dri=
vers

Jingoo Han (37):
      spi: atmel: convert from legacy pm ops to dev_pm_ops
      spi: bfin5xx: convert from legacy pm ops to dev_pm_ops
      spi: bfin-sport: convert from legacy pm ops to dev_pm_ops
      spi: dw-pci: remove unnecessary pci_set_drvdata()
      spi: spidev: remove unnecessary spi_set_drvdata()
      spi: fsl-dspi: add missing __iomem annotation
      spi: pl022: remove unnecessary amba_set_drvdata()
      spi: bcm2835: use devm_spi_register_master()
      spi: bcm63xx: use devm_spi_register_master()
      spi: bfin-v3: use devm_spi_register_master()
      spi: clps711x: use devm_spi_register_master()
      spi: ep93xx: use devm_spi_register_master()
      spi: mpc512x: use devm_spi_register_master()
      spi: mxs: use devm_spi_register_master()
      spi: octeon: use devm_spi_register_master()
      spi: omap-100k: use devm_spi_register_master()
      spi: omap2-mcspi: use devm_spi_register_master()
      spi: orion: use devm_spi_register_master()
      spi: pl022: use devm_spi_register_master()
      spi: pxa2xx: use devm_spi_register_master()
      spi: sh-hspi: use devm_spi_register_master()
      spi: tegra114: use devm_spi_register_master()
      spi: tegra20-sflash: use devm_spi_register_master()
      spi: tegra20-slink: use devm_spi_register_master()
      spi: ti-qspi: use devm_spi_register_master()
      spi: txx9: use devm_spi_register_master()
      spi: pl022: Use dev_info() instead of printk()
      spi: dw-pci: Use dev_info() instead of printk()
      spi: Fix checkpatch issue
      spi: atmel: Fix checkpatch issue
      spi: bitbang: Fix checkpatch issue
      spi: butterfly: Fix checkpatch issue
      spi: orion: Fix checkpatch issue
      spi: sh-hspi: Fix checkpatch issue
      spi: tegra20-slink: Fix checkpatch issue
      spi: txx9: Fix checkpatch issue
      spi: spidev: Fix checkpatch issue

Julia Lawall (1):
      spi: designware: delete premature free_irq

Krzysztof Kozlowski (4):
      spi/s3c64xx: Add missing pm_runtime_set_active() call in probe()
      spi/s3c64xx: Add missing pm_runtime_put on setup fail
      spi/s3c64xx: Do not ignore return value of spi_master_resume/suspend
      spi/s3c64xx: Fix doubled clock disable on suspend

Kuninori Morimoto (1):
      spi/hspi: add device tree support

Lars-Peter Clausen (3):
      spi: Add a spi_w8r16be() helper
      hwmon: (adt7310) Use spi_w8r16be() instead spi_w8r16()
      staging:iio:ade7753/ade7754/ade7759: Use spi_w8r16be() instead of spi=
_w8r16()

Lukasz Czerwinski (1):
      spi: spi-s3c64xx: Use module_platform_driver()

Mark Brown (63):
      spi: core: Add devm_spi_register_master()
      Merge remote-tracking branch 'spi/topic/devm' into spi-s3c64xx
      spi/s3c64xx: Use managed registration
      Merge remote-tracking branch 'spi/fix/clps711x' into spi-devm
      Merge remote-tracking branch 'spi/topic/pl022' into spi-devm
      Merge remote-tracking branch 'spi/fix/s3c64xx' into spi-s3c64xx
      spi/s3c64xx: Flush FIFOs prior to cleaning up transfer
      spi/s3c64xx: Check that clock enables succeed on runtime resume
      spi/s3c64xx: Remove unused gpios field from driver data
      spi/s3c64xx: Use core cs_gpio field
      spi/s3c64xx: Factor transfer start out of enable/disable_cs()
      spi/s3c64xx: Enable GPIO /CS prior to starting hardware
      Merge remote-tracking branch 'spi/fix/clps711x' into spi-clps711x
      Merge remote-tracking branch 'spi/topic/devm' into spi-qspi
      Merge remote-tracking branch 'spi/topic/bitbang' into HEAD
      spi/tegra20-slink: Remove unused is_single_xfer check
      spi: Provide trace points for message processing
      spi/s3c64xx: Factor transfer start out of enable/disable_cs()
      spi/trace: Trace length of SPI messages on completion
      Merge remote-tracking branch 'spi/topic/devm' into spi-bfin
      spi: Provide per-message prepare and unprepare operations
      spi/s3c64xx: Use prepare_message() and unprepare_message()
      spi: Provide common spi_message processing loop
      Merge remote-tracking branch 'spi/topic/s3c64xx' into spi-loop
      spi/s3c64xx: Use core message handling
      Merge remote-tracking branch 'spi/topic/trivial' into spi-atmel
      spi/atmel: Convert to devm_ioremap_resource()
      spi/tegra20-slink: Crude refactoring to use core message parsing
      spi/tegra20-slink: Move first transfer preparation to prepare_message
      Merge remote-tracking branch 'spi/fix/atmel' into spi-linus
      Merge remote-tracking branch 'spi/fix/efm' into spi-linus
      Merge remote-tracking branch 'spi/fix/mcspi' into spi-linus
      Merge remote-tracking branch 'spi/fix/modalias' into spi-linus
      Merge remote-tracking branch 'spi/fix/s3c64xx' into spi-linus
      Merge remote-tracking branch 'spi/topic/atmel' into spi-next
      Merge remote-tracking branch 'spi/topic/bfin' into spi-next
      Merge remote-tracking branch 'spi/topic/bitbang' into spi-next
      Merge remote-tracking branch 'spi/topic/butterfly' into spi-next
      Merge remote-tracking branch 'spi/topic/clps711x' into spi-next
      Merge remote-tracking branch 'spi/topic/core' into spi-next
      Merge remote-tracking branch 'spi/topic/davinci' into spi-next
      Merge remote-tracking branch 'spi/topic/designware' into spi-next
      Merge remote-tracking branch 'spi/topic/dev' into spi-next
      Merge remote-tracking branch 'spi/topic/dspi' into spi-next
      Merge remote-tracking branch 'spi/topic/efm32' into spi-next
      Merge remote-tracking branch 'spi/topic/gpio' into spi-next
      Merge remote-tracking branch 'spi/topic/hspi' into spi-next
      Merge remote-tracking branch 'spi/topic/imx' into spi-next
      Merge remote-tracking branch 'spi/topic/loop' into spi-next
      Merge remote-tracking branch 'spi/topic/mxs' into spi-next
      Merge remote-tracking branch 'spi/topic/orion' into spi-next
      Merge remote-tracking branch 'spi/topic/pl022' into spi-next
      Merge remote-tracking branch 'spi/topic/probe' into spi-next
      Merge remote-tracking branch 'spi/topic/qspi' into spi-next
      Merge remote-tracking branch 'spi/topic/rspi' into spi-next
      Merge remote-tracking branch 'spi/topic/s3c24xx' into spi-next
      Merge remote-tracking branch 'spi/topic/s3c64xx' into spi-next
      Merge remote-tracking branch 'spi/topic/tegra' into spi-next
      Merge remote-tracking branch 'spi/topic/tegra-slink' into spi-next
      Merge remote-tracking branch 'spi/topic/tegra114' into spi-next
      Merge remote-tracking branch 'spi/topic/topcliff' into spi-next
      Merge remote-tracking branch 'spi/topic/txx9' into spi-next
      Merge remote-tracking branch 'spi/topic/wr' into spi-next

Mateusz Krawczuk (2):
      spi: s3c64xx: Add missing compatibles
      spi: s3c64xx: Allow build on all Samsung platforms

Mathias Krause (1):
      spi: simplify call to request_module()

Rhyland Klein (1):
      spi/tegra114: Correct support for cs_change

Sachin Kamat (7):
      spi: atmel: Fix incorrect error path
      spi: atmel: Silence checkpatch errors
      spi: spi-davinci: Fix variable type
      spi: pl022: Remove redundant break
      spi: spi-s3c24xx: Staticize s3c24xx_spi_tryfiq
      spi: clps711x: Remove redundant label
      spi: gpio: Include linux/of.h header

Sebastian Andrzej Siewior (1):
      spi: ti-qspi: one only one interrupt handler

Sourav Poddar (1):
      spi/qspi: Add dual/quad read mode bit.

Trent Piepho (14):
      spi: Use of_property_read_u32
      spi: spi-mxs: Always set LOCK_CS
      spi: spi-mxs: Remove mxs_spi_enable and mxs_spi_disable
      spi: spi-mxs: Always clear INGORE_CRC, to keep CS asserted
      spi: spi-mxs: Change flag arguments in txrx functions to bit flags
      spi: spi-mxs: Fix extra CS pulses and read mode in multi-transfer mes=
sages
      spi: spi-mxs: Fix chip select control bits in DMA mode
      spi: spi-mxs: Remove full duplex check, spi core already does it
      spi: spi-mxs: Remove bogus setting of ssp clk rate field
      spi: spi-mxs: Fix race in setup method
      spi: spi-mxs: Remove check of spi mode bits
      spi: spi-mxs: Clean up setup_transfer function
      spi: spi-mxs: Don't set clock for each xfer
      spi: spi-mxs: Use u32 instead of uint32_t

Uwe Kleine-K=F6nig (4):
      spi: fsl-dspi: several minor improvements and fixes
      spi: efm32: add spi_bitbang_stop to device remove callback
      spi: efm32: add spi_bitbang_stop to device remove callback
      spi: efm32: drop unused struct and fix size check

Wei Yongjun (2):
      spi: fsl-dspi: add missing clk_disable_unprepare() in dspi_remove()
      spi: atmel: fix return value check in atmel_spi_probe()

Wolfram Sang (4):
      spi: spi-au1550: replace platform_driver_probe to support deferred pr=
obing
      spi: spi-bfin5xx: replace platform_driver_probe to support deferred p=
robing
      spi: spi-omap-uwire: replace platform_driver_probe to support deferre=
d probing
      spi: spi-txx9: replace platform_driver_probe to support deferred prob=
ing

 Documentation/devicetree/bindings/spi/sh-hspi.txt |   7 +
 Documentation/driver-model/devres.txt             |   3 +
 drivers/hwmon/adt7310.c                           |   7 +-
 drivers/spi/Kconfig                               |   5 +-
 drivers/spi/spi-altera.c                          |   2 +-
 drivers/spi/spi-ath79.c                           |   2 +-
 drivers/spi/spi-atmel.c                           |  50 ++--
 drivers/spi/spi-au1550.c                          |   5 +-
 drivers/spi/spi-bcm2835.c                         |   4 +-
 drivers/spi/spi-bcm63xx.c                         |   6 +-
 drivers/spi/spi-bfin-sport.c                      |  29 +--
 drivers/spi/spi-bfin-v3.c                         |   3 +-
 drivers/spi/spi-bfin5xx.c                         |  48 ++--
 drivers/spi/spi-bitbang.c                         |  25 +-
 drivers/spi/spi-butterfly.c                       |  15 +-
 drivers/spi/spi-clps711x.c                        |   7 +-
 drivers/spi/spi-davinci.c                         |  13 +-
 drivers/spi/spi-dw-mmio.c                         |   5 +-
 drivers/spi/spi-dw-pci.c                          |   3 +-
 drivers/spi/spi-dw.c                              |   4 +-
 drivers/spi/spi-efm32.c                           |  12 +-
 drivers/spi/spi-ep93xx.c                          |   7 +-
 drivers/spi/spi-fsl-cpm.c                         |   2 +-
 drivers/spi/spi-fsl-dspi.c                        |  10 +-
 drivers/spi/spi-fsl-espi.c                        |   4 +-
 drivers/spi/spi-gpio.c                            |   6 +-
 drivers/spi/spi-imx.c                             |  35 ++-
 drivers/spi/spi-lm70llp.c                         |   2 +-
 drivers/spi/spi-mpc512x-psc.c                     |   4 +-
 drivers/spi/spi-mpc52xx-psc.c                     |   4 +-
 drivers/spi/spi-mxs.c                             | 193 +++++++---------
 drivers/spi/spi-nuc900.c                          |   3 +-
 drivers/spi/spi-oc-tiny.c                         |   2 +-
 drivers/spi/spi-octeon.c                          |   4 +-
 drivers/spi/spi-omap-100k.c                       |   4 +-
 drivers/spi/spi-omap-uwire.c                      |   5 +-
 drivers/spi/spi-omap2-mcspi.c                     |  19 +-
 drivers/spi/spi-orion.c                           |  10 +-
 drivers/spi/spi-pl022.c                           |  10 +-
 drivers/spi/spi-ppc4xx.c                          |   3 +-
 drivers/spi/spi-pxa2xx.c                          |  41 ++--
 drivers/spi/spi-rspi.c                            | 270 ++++++++++++++++++=
----
 drivers/spi/spi-s3c24xx.c                         |   4 +-
 drivers/spi/spi-s3c64xx.c                         | 260 ++++++++++--------=
---
 drivers/spi/spi-sh-hspi.c                         |  13 +-
 drivers/spi/spi-sh-sci.c                          |   2 +-
 drivers/spi/spi-sirf.c                            |   2 +-
 drivers/spi/spi-tegra114.c                        |  90 ++++++--
 drivers/spi/spi-tegra20-sflash.c                  |   5 +-
 drivers/spi/spi-tegra20-slink.c                   | 144 ++++++------
 drivers/spi/spi-ti-qspi.c                         |  46 +---
 drivers/spi/spi-topcliff-pch.c                    |  17 +-
 drivers/spi/spi-txx9.c                            |  11 +-
 drivers/spi/spi-xilinx.c                          |   2 +-
 drivers/spi/spi.c                                 | 244 +++++++++++++++----
 drivers/spi/spidev.c                              |   7 +-
 drivers/staging/iio/meter/ade7753.c               |   3 +-
 drivers/staging/iio/meter/ade7754.c               |   3 +-
 drivers/staging/iio/meter/ade7759.c               |   3 +-
 include/linux/spi/rspi.h                          |   2 +
 include/linux/spi/spi.h                           |  61 ++++-
 include/trace/events/spi.h                        | 156 +++++++++++++
 62 files changed, 1267 insertions(+), 701 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/sh-hspi.txt
 create mode 100644 include/trace/events/spi.h

--ZaBLw/ITdVUrVb8x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSfMHiAAoJELSic+t+oim9QUcP/jkrxyQW3Hswtyj8QttDsvZX
H50tHs6TGghnKdW/me70x1RgHCi2NMqw4V5+86U0ImXMrpiXZmrxcMyTZH3bvH+i
3awcD6qCrpB7CRc8OMwRbr3+peUB9Bxb89eCs7kopSt1Z8lspVRZMGZKCzdCcjH5
kR+CRWEIymhhV8z9IXiETjO0sOaAl+Pz5MSLB5M/BaEnBtPGSNoLnOH6J/Hn83E6
F1nQFUdFEA+vvH/2nKxosaUQvmJeeGtM7WWg3WSqMbUg/KP5M7FlVqmOKSzfx/TL
wHI5/LBQKdfzcCXgQ72tJcH7tBM8uVZuqvn0lNUv+rw64G7lx8DhCtHswDyrVoXt
Ame+mIFuqgYU8NhgCX0qEPJKthmYs7zVMgaYvHWmk/iO5tpD3XBKuAIxkJTZcSjy
TTY69VKJpLQHNCgaqht2G6Lvoiiq5pGZDqZaLTIfRaymOF70gH6SoDI0+PkOb4TM
UHecY25HKPmNqgcH90E4lBel4N4LR9wumjcqfAi3MZ5U8jd5ADt/X03/h+u6k9U5
ccbrZje9AVsS89kknBoFDdlYfw4vL4I0VOTPa+/hmWoApGiH4cfHcnWViA06NED2
MknUKxttz5eoeG7gxms25UtAaJiAm4PTjwNt0hPeX2c4SEEBLmHSx9aF4NCbRobB
r0+cPA8nt/jwx6GziB6F
=sqNt
-----END PGP SIGNATURE-----

--ZaBLw/ITdVUrVb8x--
