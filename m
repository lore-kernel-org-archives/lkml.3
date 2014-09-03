Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935341AbaICXIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:08:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48973 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933750AbaICXI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:08:27 -0400
Date: Thu, 4 Sep 2014 00:08:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140903230821.GF29327@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pEX2GA8pip5RjAtK"
Content-Disposition: inline
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap fixes for v3.17
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pEX2GA8pip5RjAtK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.17-rc1

for you to fetch changes up to d3b05339873d42a1820d9215ce3885b61d9a95a1:

  Merge remote-tracking branches 'regmap/fix/cache', 'regmap/fix/debugfs' and 'regmap/fix/volatile' into regmap-linus (2014-08-31 13:23:45 +0100)

----------------------------------------------------------------
regmap: Fixes for v3.17

Several bug fixes for issues that have been lurking for a while:

 - Check that devices haven't set the flag saying they only support
   register at a time operation while we're doing cache syncs, otherwise
   we fail to restore caches.
 - Ensure that we don't mark all registers on devices using format_write()
   as cacheable, avoiding adding a cache of things like reset registers
   which we don't want to rewrite during cache sync.
 - Make sure we create the debugfs files in the correct directory.

----------------------------------------------------------------
Lars-Peter Clausen (1):
      regmap: Fix regcache debugfs initialization

Mark Brown (3):
      regmap: Fix handling of volatile registers for format_write() chips
      regmap: Don't attempt block writes when syncing cache on single_rw devices
      Merge remote-tracking branches 'regmap/fix/cache', 'regmap/fix/debugfs' and 'regmap/fix/volatile' into regmap-linus

 drivers/base/regmap/internal.h        | 3 +++
 drivers/base/regmap/regcache-rbtree.c | 9 +++------
 drivers/base/regmap/regcache.c        | 2 +-
 drivers/base/regmap/regmap-debugfs.c  | 3 +++
 drivers/base/regmap/regmap.c          | 2 +-
 5 files changed, 11 insertions(+), 8 deletions(-)

--pEX2GA8pip5RjAtK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUB59iAAoJELSic+t+oim9gFcP/00qvtDJRaWXZ+ZCDJYVWhRq
GFIEdFjaIks3Go6PsTMs3uL+eJ/wzAGLhCLUzNuwyi6F8Om1CNmACcxUdettI8tl
Fjs43zx9fTrJgKcsGQmut08hs+6owf1BalXZHxY/ln99bErKudfmVwDXZFk2i242
SZaVJBrorjGy11cgRbMXSfyL6IJZZ5f4xFe2vWm7H779DhblHfw/he//0YnVaBP4
NARSSGPVsxkbgZusXAYqYNsi3aTR8EFl8TqBJChLDCAofmCX2pDkATd6DTKaCHi+
8VwrOFEHyaIR+38eARhk2MarQmGWQhjngAiyeba02ZGpWfsju0puMpoMlC7pWZJN
+sb1+tvA42X+8Yur2+v14+SgJr4A6BvLQ83zMWHu4jMO/bSboK3NZL5FcvM3rmaY
JIAND4F+Wc9dBrgLJYgZDJ942TN+Zt+FucC7XuS6DGylvzJVbuWLyS7dey0oMj8W
3+qzhiMURbX1NqyG/ghaTO5IDfQgQk34RAWYVHnOgABHgVQb6rXUtIbwgSSwkpPw
6Agyclx4mKiewsz9Y7mBlYQ357eOcKEF4wd0JiKd4y0mgvT5plbmz62eIu5PKSWF
DBiMp1DgN12JMr4AsX8eJe8Dzw8s+JlgdnToBDUAF7ff6sjsgQlnUwY+g1hQWdWW
IrUgE90V/IHyVRJhUSDR
=Zpoc
-----END PGP SIGNATURE-----

--pEX2GA8pip5RjAtK--
