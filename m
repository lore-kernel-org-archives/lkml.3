Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaCaL1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:27:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49334 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaCaL1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:27:07 -0400
Date: Mon, 31 Mar 2014 12:26:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140331112655.GP2269@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6kpOI20Kt7FNSDww"
Content-Disposition: inline
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.15
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6kpOI20Kt7FNSDww
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit b098d6726bbfb94c06d6e1097466187afddae61f:

  Linux 3.14-rc8 (2014-03-24 19:31:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.15

for you to fetch changes up to 6012b1f3424c4dc36369697845a9ca699887b0c7:

  Merge remote-tracking branches 'regmap/topic/cache', 'regmap/topic/irq', 'regmap/topic/lock', 'regmap/topic/mmio', 'regmap/topic/nodev', 'regmap/topic/parse-val' and 'regmap/topic/patch' into regmap-next (2014-03-28 11:50:43 +0000)

----------------------------------------------------------------

regmap: Updates for v3.15

Quite a busy release for regmap this time around, the standout changes
are:

 - A real implementation of regmap_multi_write() and a bypassed version
   of it for use by drivers doing patch-like things with more open
   coding for surrounding startup sequences.
 - Support fast_io on bulk operations.
 - Support split device binding and map initialisation for use by
   devices required in early init (mainly system controllers).
 - Fixes for some operations on maps with strides set.
 - Export the value parsing operations to help generic code built on top
   of the API.
 - Support for MMIO regmaps with non-32 bit register sizes.

plus a few smaller fixes.

----------------------------------------------------------------
Charles Keepax (5):
      regmap: Check stride of register patch as we register it
      regmap: Mark reg_defaults in regmap_multi_reg_write as const
      regmap: Add bypassed version of regmap_multi_reg_write
      regmap: Base regmap_register_patch on _regmap_multi_reg_write
      mfd: arizona: Use new regmap features for manual register patch

Dylan Reid (3):
      regmap: cache: Handle stride > 1 in sync_block_raw_flush
      regmap: cache: Step by stride in default sync
      regmap: cache: Don't attempt to sync non-writeable registers

Krzysztof Kozlowski (1):
      regmap: irq: Set data pointer only on regmap_add_irq_chip success

Mark Brown (5):
      regmap: irq: Remove domain on exit
      regmap: Ensure regmap_register_patch() is compatible with fast_io
      Merge tag 'regmap-v3.14-rc4' into regmap-linus
      Merge remote-tracking branch 'regmap/topic/core' into regmap-next
      Merge remote-tracking branches 'regmap/topic/cache', 'regmap/topic/irq', 'regmap/topic/lock', 'regmap/topic/mmio', 'regmap/topic/nodev', 'regmap/topic/parse-val' and 'regmap/topic/patch' into regmap-next

Michal Simek (2):
      regmap: Check readable regs in _regmap_read
      regmap: Separate regmap dev initialization

Nenghua Cao (2):
      regmap: fix coccinelle warnings
      regmap: add regmap_parse_val api

Opensource [Anthony Olech] (1):
      regmap: Implementation for regmap_multi_reg_write

Pawel Moll (1):
      regmap: debugfs: "registers" & "access" for single register maps

Takashi Iwai (1):
      regmap: Fix possible sleep-in-atomic in regmap_bulk_write()

Xiubo Li (4):
      regmap: Clean up _regmap_update_bits()
      regmap: mmio: add regmap_mmio_{regsize, count}_check.
      regmap: mmio: Add support for 1/2/8 bytes wide register address.
      regmap: mmio: Add regmap_mmio_regbits_check.

 drivers/base/regmap/internal.h       |   2 +
 drivers/base/regmap/regcache.c       |  13 +-
 drivers/base/regmap/regmap-debugfs.c |   2 +-
 drivers/base/regmap/regmap-irq.c     |   6 +-
 drivers/base/regmap/regmap-mmio.c    |  56 +++++-
 drivers/base/regmap/regmap.c         | 353 +++++++++++++++++++++++++++++------
 drivers/mfd/arizona-core.c           |   4 -
 drivers/mfd/wm5102-tables.c          |  21 +--
 include/linux/regmap.h               |  20 +-
 9 files changed, 377 insertions(+), 100 deletions(-)

--6kpOI20Kt7FNSDww
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOVD7AAoJELSic+t+oim9kKsP/0MKVTipigUkH7hU2dJreaqz
5gYVtXuzaAw6tJLSWtvCcjcoDFVJI+rKjdFuLSbq/Mi3fKPwjPI0lH9tbS3vcywj
3mYcdjSoo+77jFWdT3tweKl6f+YMphrqsLc/mxSq7quRK1SfcrGbb8PMPSUdOT0I
8HFXDFV+JQ/M7yknBA8IGG6foOBjy1M8JgOy/ETocFbdpPDiUci1iMaUG10aHIDM
Gw2/+pfoQF4asVYmSy3D5GfTwSOeVknHTirTAV8G/FppWl3BfNrFhpWwOlqN0zhR
cM0tNp+ymby/g63Sel1HY7vAGG1+ptekfJv+R4L0s+4hhURMCCDtgTgpKZK9UC0z
7MVv8fiStghrNUs77IOlHvGF047JCQ1Lp14Kdvqk+2ZpM5YzMz/omAQI+PyajBQm
/z1OLQAvj9fH21MU4hISNo+boTNtwMqDz73veysaTuD1yJm+rKfYAsAfQKPT2+Pr
uCQPY6D58EgfMIh1LRo+UqLy+xLwhsEWL24gHakH475ht/NYBVfF4pi5x1r6lqJT
pWwKoGZjFp03Sl30MyPTduXTuL85IcK4pZ6dg3k6kOPe3XCpOS65xB2P2umU7JBk
AzB1N1wUhlyu06C4m171Qixw28c0PTM55QV6hH8bcKnWjD30kogddvJnx0A04iXC
JM+yiYSgSaqSfCvGZXCT
=MASw
-----END PGP SIGNATURE-----

--6kpOI20Kt7FNSDww--
