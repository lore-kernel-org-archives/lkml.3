Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761200Ab3D2UDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:03:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54002 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab3D2UDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:03:41 -0400
Date: Mon, 29 Apr 2013 21:03:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130429200337.GD3270@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P+33d92oIH25kiaB"
Content-Disposition: inline
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.10
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P+33d92oIH25kiaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 41ef2d5678d83af030125550329b6ae8b74618fa:

  Linux 3.9-rc7 (2013-04-14 17:45:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.10

for you to fetch changes up to 38a817965d2d624b0db68f3bf5ae783ad7f2087a:

  Merge remote-tracking branch 'regmap/topic/range' into regmap-next (2013-04-16 16:05:50 +0100)

----------------------------------------------------------------

regmap: Updates for v3.10

In user visible terms just a couple of enhancements here, though there
was a moderate amount of refactoring required in order to support the
register cache sync performance improvements.

- Support for block and asynchronous I/O during register cache syncing;
  this provides a use case dependant performance improvement.
- Additional debugfs information on the memory consuption and register
  set.

----------------------------------------------------------------
Dimitris Papastamos (4):
      regmap: debugfs: Simplify calculation of `c->max_reg'
      regmap: debugfs: Add a registers `range' file
      regmap: rbtree Expose total memory consumption in the rbtree debugfs entry
      regmap: Cut down on the average # of nodes in the rbtree cache

Mark Brown (21):
      regmap: async: Add tracepoints for async I/O
      regmap: rbtree: Don't bother checking for noop updates
      regmap: cache: Pass the map rather than the word size when updating values
      regmap: cache: Use regcache_get_value() to check if we updated
      regmap: core: Split out in place value parsing
      regmap: cache: Store caches in native register format where possible
      regmap: irq: Clarify error message when we fail to request primary IRQ
      regmap: core: Warn on invalid operation combinations
      regmap: core: Make raw write available to regcache
      regmap: cache: Provide a get address of value operation
      regmap: core: Provide regmap_can_raw_write() operation
      regmap: cache: Use raw I/O to sync rbtrees if we can
      regmap: cache: Factor out reg_present support from rbtree cache
      regmap: cache: Factor out block sync
      regmap: cache: Split raw and non-raw syncs
      regmap: cache: Write consecutive registers in a single block write
      Merge tag 'v3.9-rc7' into regmap-cache
      Merge remote-tracking branch 'regmap/topic/async' into regmap-next
      Merge remote-tracking branch 'regmap/topic/cache' into regmap-next
      Merge remote-tracking branch 'regmap/topic/irq' into regmap-next
      Merge remote-tracking branch 'regmap/topic/range' into regmap-next

Sachin Kamat (1):
      regmap: cache: Make regcache_sync_block_raw static

Stephen Warren (1):
      regmap: don't corrupt work buffer in _regmap_raw_write()

Stratos Karafotis (1):
      regmap: cache: Fix format specifier in dev_dbg

 drivers/base/regmap/internal.h        |   40 ++++++-
 drivers/base/regmap/regcache-lzo.c    |    6 +-
 drivers/base/regmap/regcache-rbtree.c |  100 ++++++++---------
 drivers/base/regmap/regcache.c        |  196 ++++++++++++++++++++++++++++++---
 drivers/base/regmap/regmap-debugfs.c  |   94 ++++++++++++++--
 drivers/base/regmap/regmap-irq.c      |    3 +-
 drivers/base/regmap/regmap.c          |   92 +++++++++++-----
 include/linux/regmap.h                |    1 +
 include/trace/events/regmap.h         |   48 ++++++++
 9 files changed, 462 insertions(+), 118 deletions(-)

--P+33d92oIH25kiaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRftIVAAoJELSic+t+oim908QP/ioRFx53y77vbmXZK6p6UO8n
RpCE4GARXXDarUULqioSsu1GZazDxXpBfINEzVtZkzDM6Z/QldlnmY+kYSXVW5qr
fXgydvLJoZszYbsjuZxw9wa9IcM+AV5z97hX2NsUo2rwygbqUw8E1fzMyErmKfRi
VzeSwLNam5bDruZeW7SzB7PRW5AGZ+/rri3y5BybPbquX+0KAr7w4e6nvjbXIdvz
z/2G80dJNcURNnkbKzM2qIfnMrJ1H8p1AqTXqgZ+UT0ELQoJ+CHQdxBphUquEyM0
n6m7mABEYOoeMK/908VFx8PMdEBDwkjWtankNxwK2w2MEQpH/iXnDJjLwE3+h84M
SI/AtHYyvELfGP7HJDPBCkwcfyx0Q+N6xFoFyP8acgIBh4qddix/mGBiocrFVUiX
QaclD8qG65dGqvPc++WY7XVE20vmHf2Mol7cSISvSalFek8Wm6h43zPulUGyIY/k
m1Xus453SunNuSixOxs2DwdzTxZBj1Bx/Giqx3FuXs998Tx/InHtUKC6GifPfr+a
eXckKW3TDC1hWx1WmKQY8zg+WjnIz3DcPFQYZUbzEK7VKoJfOQtRtm7tdrta+bnU
P7ZCU8ctuXchcgwNbuJ5dg+m5tLepaR8NnKfLy27Bb+uGFj/wwuE26tzVl9bu6Jx
wmCwt42ZgFcq68POeAvi
=zviB
-----END PGP SIGNATURE-----

--P+33d92oIH25kiaB--
