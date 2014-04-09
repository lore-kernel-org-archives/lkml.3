Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441AbaDIJzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:55:41 -0400
Received: from sauhun.de ([89.238.76.85]:36605 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185AbaDIJzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:55:38 -0400
Date: Wed, 9 Apr 2014 11:55:35 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.15
Message-ID: <20140409095530.GA6003@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

here is the pull request from the i2c subsystem. It got a little delayed
because I needed to wait for a dependency to be included (b424080a9e08
reset: Add optional resets and stubs). Plus, I had some email problems.
All done now, the highlights are:

* drivers can now deprecate their use of i2c classes. That shouldn't be
  used on embedded platforms anyhow and was often blindly copy&pasted.
  This mechanism gives users time to switch away and ultimately boot
  faster once the use of classes for those drivers is gone for good.

* new drivers for QUP, Cadence, efm32

* tracepoint support for I2C and SMBus

* bigger cleanups for the mv64xxx, nomadik, and designware drivers

And the usual bugfixes, cleanups, feature additions. Most stuff has been
in linux-next for a while. Just some hot fixes and new drivers were
added a bit more recently. Please pull.

Thanks,

   Wolfram


The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-next

for you to fetch changes up to 1fbeab0b8fd5e655ffef8a793b869eb7dffe0337:

  i2c: cadence: fix Kconfig dependency (2014-04-06 21:03:07 +0200)

----------------------------------------------------------------
Ben Dooks (1):
      i2c: gpio: OF gpio code does not handle defered probe case

Bjorn Andersson (1):
      i2c: qup: New bus driver for the Qualcomm QUP I2C controller

Chew, Chiau Ee (2):
      i2c: designware-pci: add 10-bit addressing mode functionality for BYT=
 I2C
      i2c: designware-pci: set ideal HCNT, LCNT and SDA hold time value

Chew, Kean ho (1):
      i2c: i801: enable Intel BayTrail SMBUS

Dan Carpenter (1):
      i2c: qup: off by ones in qup_i2c_probe()

David Howells (2):
      i2c: Add message transfer tracepoints for I2C
      i2c: Add message transfer tracepoints for SMBUS [ver #2]

Geert Uytterhoeven (1):
      i2c: Spelling s/than/that/

Ivan T. Ivanov (1):
      i2c: qup: Add device tree bindings information

Jingoo Han (5):
      i2c: bcm2835: Use devm_ioremap_resource()
      i2c: mxs: Use devm_ioremap_resource()
      i2c: remove DEFINE_PCI_DEVICE_TABLE macro
      i2c: exynos5: add CONFIG_PM_SLEEP to suspend/resume functions
      i2c: exynos5: remove unnecessary cast of void pointer

Linus Walleij (1):
      i2c: nomadik: factor platform data into state container

Marek Roszko (1):
      i2c: at91: Add device tree property to set clock-frequency

Maxime COQUELIN (1):
      i2c: st: Fix return in case of arbitration lost

Maxime Ripard (3):
      i2c: mv64xxx: Add reset deassert call
      i2c: mv64xxx: Add support for the Allwinner A31 I2C driver
      i2c: mv64xxx: Fix reset controller handling

Mika Westerberg (2):
      i2c: designware-pci: Cleanup driver power management
      i2c: designware-pci: Add Baytrail PCI IDs

Nishanth Menon (1):
      i2c: omap: fix usage of IS_ERR_VALUE with pm_runtime_get_sync

Romain Baeriswyl (1):
      i2c: designware: make SCL and SDA falling time configurable

Sachin Kamat (1):
      i2c: s3c2410: Trivial cleanup in header file

Simon Glass (1):
      i2c: s3c2410: Leave the bus disabled unless it is in use

Sonic Zhang (2):
      i2c: bfin-twi: move bits macros and structs in header from arch inclu=
de to generic include
      i2c: bfin-twi: remove unnecessary Blackfin SSYNC from the driver

Soren Brinkmann (2):
      i2c: cadence: Document device tree bindings
      i2c: Add driver for Cadence I2C controller

Ulf Hansson (5):
      i2c: nomadik: Convert to devm functions
      i2c: nomadik: Remove redundant call to pm_runtime_disable
      i2c: nomadik: Fixup deployment of runtime PM
      i2c: nomadik: Convert to late and early system PM callbacks
      i2c: nomadik: Remove busy check for transfers at suspend late

Uwe Kleine-K=F6nig (2):
      i2c: efm32: new bus driver
      i2c: efm32: fix binding doc

Wolfram Sang (25):
      i2c: rcar: add compatible entry for r8a7791
      i2c: add deprecation warning for class based instantiation
      i2c: i2c-omap: deprecate class based instantiation
      i2c: i2c-at91: deprecate class based instantiation
      i2c: i2c-bfin-twi: deprecate class based instantiation
      i2c: i2c-nomadik: deprecate class based instantiation
      i2c: i2c-ocores: deprecate class based instantiation
      i2c: i2c-stu300: deprecate class based instantiation
      i2c: i2c-tegra: deprecate class based instantiation
      i2c: i2c-rcar: deprecate class based instantiation
      i2c: mv64xxx: fix circular Kconfig dependency
      i2c: mv64xxx: refactor send_start
      i2c: mv64xxx: directly call send_start when initializing transfer
      i2c: mv64xxx: refactor initialization for new msgs
      i2c: i2c-s3c2410: deprecate class based instantiation
      i2c: i2c-bcm2835: deprecate class based instantiation
      i2c: i2c-davinci: deprecate class based instantiation
      i2c: i2c-designware-platdrv: deprecate class based instantiation
      i2c: i2c-mv64xxx: deprecate class based instantiation
      i2c: i2c-sirf: deprecate class based instantiation
      i2c: i2c-xiic: deprecate class based instantiation
      MAINTAINERS: update I2C web resources
      i2c: qup: use proper type fro clk_freq
      Documentation: i2c: improve section about flags mangling the protocol
      i2c: cadence: fix Kconfig dependency

 Documentation/devicetree/bindings/i2c/i2c-at91.txt |   2 +
 .../devicetree/bindings/i2c/i2c-cadence.txt        |  24 +
 .../devicetree/bindings/i2c/i2c-designware.txt     |   8 +
 .../devicetree/bindings/i2c/i2c-efm32.txt          |  34 +
 .../devicetree/bindings/i2c/i2c-mv64xxx.txt        |  20 +-
 Documentation/devicetree/bindings/i2c/i2c-rcar.txt |  14 +-
 .../devicetree/bindings/i2c/qcom,i2c-qup.txt       |  40 +
 Documentation/i2c/busses/i2c-i801                  |   1 +
 Documentation/i2c/functionality                    |   2 +-
 Documentation/i2c/i2c-protocol                     |  35 +-
 MAINTAINERS                                        |   4 +-
 arch/blackfin/include/asm/bfin_twi.h               | 143 +---
 arch/blackfin/kernel/debug-mmrs.c                  |   1 +
 drivers/i2c/busses/Kconfig                         |  27 +-
 drivers/i2c/busses/Makefile                        |   3 +
 drivers/i2c/busses/i2c-ali1535.c                   |   2 +-
 drivers/i2c/busses/i2c-ali1563.c                   |   2 +-
 drivers/i2c/busses/i2c-ali15x3.c                   |   2 +-
 drivers/i2c/busses/i2c-amd756.c                    |   2 +-
 drivers/i2c/busses/i2c-amd8111.c                   |   2 +-
 drivers/i2c/busses/i2c-at91.c                      |  12 +-
 drivers/i2c/busses/i2c-bcm2835.c                   |  26 +-
 drivers/i2c/busses/i2c-bfin-twi.c                  |  20 +-
 drivers/i2c/busses/i2c-cadence.c                   | 905 +++++++++++++++++=
++++
 drivers/i2c/busses/i2c-davinci.c                   |   2 +-
 drivers/i2c/busses/i2c-designware-core.c           |  27 +-
 drivers/i2c/busses/i2c-designware-core.h           |   2 +
 drivers/i2c/busses/i2c-designware-pcidrv.c         | 125 +--
 drivers/i2c/busses/i2c-designware-platdrv.c        |   9 +-
 drivers/i2c/busses/i2c-efm32.c                     | 481 +++++++++++
 drivers/i2c/busses/i2c-eg20t.c                     |   2 +-
 drivers/i2c/busses/i2c-exynos5.c                   |   4 +-
 drivers/i2c/busses/i2c-gpio.c                      |   3 +
 drivers/i2c/busses/i2c-hydra.c                     |   2 +-
 drivers/i2c/busses/i2c-i801.c                      |   5 +-
 drivers/i2c/busses/i2c-ismt.c                      |   2 +-
 drivers/i2c/busses/i2c-mv64xxx.c                   |  83 +-
 drivers/i2c/busses/i2c-mxs.c                       |  18 +-
 drivers/i2c/busses/i2c-nforce2.c                   |   2 +-
 drivers/i2c/busses/i2c-nomadik.c                   | 253 +++---
 drivers/i2c/busses/i2c-ocores.c                    |   2 +-
 drivers/i2c/busses/i2c-omap.c                      |   8 +-
 drivers/i2c/busses/i2c-pasemi.c                    |   2 +-
 drivers/i2c/busses/i2c-piix4.c                     |   2 +-
 drivers/i2c/busses/i2c-pxa-pci.c                   |   2 +-
 drivers/i2c/busses/i2c-qup.c                       | 768 +++++++++++++++++
 drivers/i2c/busses/i2c-rcar.c                      |   3 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |  39 +-
 drivers/i2c/busses/i2c-sirf.c                      |   2 +-
 drivers/i2c/busses/i2c-sis5595.c                   |   2 +-
 drivers/i2c/busses/i2c-sis630.c                    |   2 +-
 drivers/i2c/busses/i2c-sis96x.c                    |   2 +-
 drivers/i2c/busses/i2c-st.c                        |   2 +-
 drivers/i2c/busses/i2c-stu300.c                    |   2 +-
 drivers/i2c/busses/i2c-tegra.c                     |   2 +-
 drivers/i2c/busses/i2c-via.c                       |   2 +-
 drivers/i2c/busses/i2c-viapro.c                    |   2 +-
 drivers/i2c/busses/i2c-xiic.c                      |   2 +-
 drivers/i2c/busses/scx200_acb.c                    |   2 +-
 drivers/i2c/i2c-core.c                             |  67 +-
 include/linux/i2c.h                                |   1 +
 include/linux/i2c/bfin_twi.h                       | 145 ++++
 include/linux/platform_data/i2c-s3c2410.h          |   9 +-
 include/trace/events/i2c.h                         | 372 +++++++++
 64 files changed, 3292 insertions(+), 501 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cadence.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-efm32.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/qcom,i2c-qup.txt
 create mode 100644 drivers/i2c/busses/i2c-cadence.c
 create mode 100644 drivers/i2c/busses/i2c-efm32.c
 create mode 100644 drivers/i2c/busses/i2c-qup.c
 create mode 100644 include/linux/i2c/bfin_twi.h
 create mode 100644 include/trace/events/i2c.h

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTRRkSAAoJEBQN5MwUoCm2X38P/0Uznu5UNc+CetHrz3HGfmE9
krjoA+sCl7uxwxHRhVspT0WOa1Ng1QMKmussKDU8JSAzxE6UW4Jrk6HRs9DceDlt
5Od24xa7zomYZkutmHFCtH8QMddeBTwQ9S+Z4hOzAVN6B7xiuROrdaLsGVwCKwRf
W8krB0aHbcYzn6VccjiyeQf/XRBtYsDM2U9VaVLnvT+oylzhmRGeBe7PUX/1kCG+
2FHKg9/6qOthmZC6BeYBt5FfDQ1m5EHjpg0VmEbrIySUBx+lBzXEG0UvlFrQH2Hl
+j8hi9rRp4HVF0xwdeOI+P0liUgWOZYn/l/MVJZiJXAtpqTLIwv/bKYGFlrdiUzj
GSKT0eNZXQiplZDl2JAjKRNxppcqKsEd1U92cOE8CxtzKxJrRoMQasQUS+BQih3C
7W00LK5i8N2mfFS3eWXDPcrVaSJ9rZRD083E3Djnc5zpgmf0zEDR57FGy7FrNs+F
FVGTsFQy4A1BZfhLAy8nsG1GtIYzIXbDnkfR/N7/bfomurnEZ1uloIac6ODTun++
R9s1ag/phxzZ5zVyKS6fDlpToVZ+wzzfm2HxLq3OQM3ZLeQmwBjnoPy6Pq+iHqlU
N9d6Mv3C39VNluYBjg3RMZvb302pbWhGiFJIsu+NPcVQP6/REctZpGMpFAu4KlyH
DKhmUU6c3UoaBZuzc3rq
=LnGC
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
