Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935264Ab3BTMRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:17:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34294 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935029Ab3BTMRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:17:12 -0500
Date: Wed, 20 Feb 2013 12:17:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap updates for v3.9
Message-ID: <20130220121708.GC2726@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39:

  Linux 3.8-rc7 (2013-02-09 08:20:39 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-3.9

for you to fetch changes up to a2b37efc4e2aa76a5be29bbde8a2cd1c9c9066bc:

  Merge remote-tracking branch 'regmap/topic/no-bus' into regmap-next (2013-02-14 17:11:09 +0000)

----------------------------------------------------------------

regmap: Updates for v3.9

Several nice new features and performance improvements here, especially
the first:

 - Support for using the cache infrastructure without the physical I/O,
   allowing devices which don't fit the physical model regmap has to
   take advantage of the cache infrastructure, contributed by Andrey
   Smirnov.
 - Several small improvements to the support for wake capable IRQs.
 - Support for asynchronous I/O, allowing us to come much closer to
   saturating fast buses like SPI.
 - Support for simple array caches, giving higher performance for use
   with MMIO devices.
 - Restoration of the use of bulk reads for handling interrupts, giving
   a performance improvement.
 - Support for 24 bit register addresses.
 - More performance improvements for debugfs.

----------------------------------------------------------------
Andrey Smirnov (3):
      regmap: Add provisions to have user-defined read operation
      regmap: Add provisions to have user-defined write operation
      regmap: Add "no-bus" option for regmap API

Axel Lin (1):
      regmap: Export regmap_async_complete_cb

Dimitris Papastamos (4):
      regmap: debugfs: Fix reading in register field units
      regmap: debugfs: Add a `max_reg' member in struct regmap_debugfs_off_cache
      regmap: debugfs: Optimize seeking within blocks of registers
      regmap: debugfs: Factor out debugfs_tot_len calc into a function

Lars-Peter Clausen (1):
      regmap: Add support for 24 bit wide register addresses

Laxman Dewangan (1):
      regmap: irq: enable wake support by default

Mark Brown (18):
      regmap: flat: Add flat cache type
      regmap: irq: Factor register read out of the IRQ parsing loop
      regmap: irq: Use a bulk read for interrupt status where possible
      regmap: irq: Fix sync of wake statuses to hardware
      regmap: irq: Support wake IRQ mask inversion
      mfd: wm5102: Mark wakes as inverted
      mfd: wm5110: Mark wakes as inverted
      regmap: Add asynchronous I/O support
      regmap: spi: Support asynchronous I/O for SPI
      regmap: Export regmap_async_complete()
      regmap: spi: Handle allocation failures gracefully
      Merge remote-tracking branch 'regmap/topic/24bit' into regmap-next
      Merge remote-tracking branch 'regmap/topic/async' into regmap-next
      Merge remote-tracking branch 'regmap/topic/debugfs' into regmap-next
      Merge remote-tracking branch 'regmap/topic/flat' into regmap-next
      Merge remote-tracking branch 'regmap/topic/irq' into regmap-next
      Merge remote-tracking branch 'regmap/topic/mmio' into regmap-next
      Merge remote-tracking branch 'regmap/topic/no-bus' into regmap-next

Philipp Zabel (1):
      regmap: mmio: add register clock support

Russell King (1):
      regmap: regmap: avoid spurious warning in regmap_read_debugfs

Stephen Warren (1):
      regmap: include linux/sched.h to fix build

 drivers/base/regmap/Makefile         |    2 +-
 drivers/base/regmap/internal.h       |   22 +++
 drivers/base/regmap/regcache-flat.c  |   72 +++++++
 drivers/base/regmap/regcache.c       |    1 +
 drivers/base/regmap/regmap-debugfs.c |   50 +++--
 drivers/base/regmap/regmap-irq.c     |  125 +++++++++---
 drivers/base/regmap/regmap-mmio.c    |   79 ++++++--
 drivers/base/regmap/regmap-spi.c     |   54 ++++++
 drivers/base/regmap/regmap.c         |  351 +++++++++++++++++++++++++++++-----
 drivers/mfd/wm5102-tables.c          |    1 +
 drivers/mfd/wm5110-tables.c          |    1 +
 include/linux/regmap.h               |   97 +++++++++-
 12 files changed, 737 insertions(+), 118 deletions(-)
 create mode 100644 drivers/base/regmap/regcache-flat.c

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJL68AAoJELSic+t+oim9ETwP/3sO/c4e8v6Ag9oVqCDf37wW
cPoLIHcdK+ykaLQWBQrqKA8uwidF2yABmNfIktKmKRbDuUVg+38QYAKlpClAMyZl
vdKPCI/mEXHCLfmG58m90rswS5BSOnlIAF4uNnnBZlnqaoGakp/DnNpVkwSg/14j
vO1QYh9HNWVmflCXLAHPloxMPU+8JCLDx1lNqbmYu8/0E6rYymMMSM7bBUCTl/xp
ySOLLk6SEUArZJI+idyqirAl2bqUX6p6D2K0wxfFfnxMqzZU4X3IZrZggVOd8kVC
90cqtmDZBbyQ8kS60+//pGaA+Y+QdxCus0hhXGVmUY5aLkDdCzMVuofxskzOVbyP
mTZmlEPtRduihgxdUGvr69M7YBOa/lnPVVVDEbk/MtWnHevTmEEeV0ffQy3u5iZ+
G1KJaJUjMiycHDbUmjb/nYq9gj7Eq9euXsE9aTieXMNmulRlA0mLp9G0LFDJgefp
wk/0z6dsvyhD1pVOu7lB/Hy/1iNpQ3L6vykeJRiWJ9FLonOMlGj+kkejekeBhbhR
jBhCntgIWk1H/Ga3tOKhiSgbCYhq5ceQUc1yMrmHBooW/ZHOQA4Mz9yEZIP1vOB+
Ynns8u9pWdS+9zhh1Tp3pE1cV4cZMzK95I5S8i79+vQcfZTo9E7idBj0YUuzOM/G
wSV9hef/c4IqEErZSUoX
=6fIM
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
