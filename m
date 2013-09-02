Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab3IBVMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 17:12:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47520 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759023Ab3IBVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:12:29 -0400
Date: Mon, 2 Sep 2013 22:12:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130902211225.GX3084@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VIFPKPeEU/ajvd6j"
Content-Disposition: inline
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.12
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VIFPKPeEU/ajvd6j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d8dfad3876e4386666b759da3c833d62fb8b2267:

  Linux 3.11-rc7 (2013-08-25 17:43:22 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.12

for you to fetch changes up to 365c9ee0731de96046cc7749b46a5e7a0b0ceb65:

  Merge remote-tracking branch 'regmap/topic/sparse' into regmap-next (2013-08-31 19:25:16 +0100)

----------------------------------------------------------------

regmap: Updates for v3.12

A quiet release for regmap, some cleanups, fixes and:

 - Improved node coalescing for rbtree, reducing memory usage and
   improving performance during syncs.
 - Support for registering multiple register patches.
 - A quirk for handling interrupts that need to be clear when masked
   in regmap-irq.

----------------------------------------------------------------
Fabio Estevam (1):
      regmap: Provide __acquires/__releases annotations

Ionut Nicu (2):
      regmap: fix regcache_reg_present() for empty cache
      regmap: regcache: allow read-only regs to be cached

Lars-Peter Clausen (5):
      regcache-rbtree: Fix reg_stride != 1
      regmap: debugfs: Fix continued read from registers file
      regmap: rbtree: Simplify adjacent node look-up
      regmap: rbtree: Reduce number of nodes, take 2
      regmap: rbtree: Make cache_present bitmap per node

Mark Brown (8):
      regmap: Allow multiple patches to be registered
      Merge remote-tracking branch 'regmap/topic/cache' into regmap-rbtree
      Merge remote-tracking branch 'regmap/topic/cache' into regmap-next
      Merge remote-tracking branch 'regmap/topic/irq' into regmap-next
      Merge remote-tracking branch 'regmap/topic/patch' into regmap-next
      Merge remote-tracking branch 'regmap/topic/range' into regmap-next
      Merge remote-tracking branch 'regmap/topic/rbtree' into regmap-next
      Merge remote-tracking branch 'regmap/topic/sparse' into regmap-next

Philipp Zabel (4):
      regmap: irq: Allow to acknowledge masked interrupts during initialization
      regmap: irq: make flags bool and put them in a bitfield
      regmap: irq: document mask/wake_invert flags
      regmap: core: allow a virtual range to cover its own data window

 drivers/base/regmap/internal.h        |  14 +--
 drivers/base/regmap/regcache-rbtree.c | 181 ++++++++++++++++++++++++----------
 drivers/base/regmap/regcache.c        |  75 ++++----------
 drivers/base/regmap/regmap-debugfs.c  |   4 +-
 drivers/base/regmap/regmap-irq.c      |  25 +++++
 drivers/base/regmap/regmap.c          |  26 +++--
 include/linux/regmap.h                |  10 +-
 7 files changed, 201 insertions(+), 134 deletions(-)

--VIFPKPeEU/ajvd6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJP82AAoJELSic+t+oim9ZW4P/2N58uRKesHv5hjqhnofrzM0
wcoxI1Vy2bCTqUrmgCKUvu9hU2AS08tN3NDoA9CLfB065xT3bf2yZ+Ncafni5AUp
WTgJuO87UpAL6iZ4FKxDLctmk2NuPKx9UW+Ln8uj7/99Nwk3K5R5dMZwc0HQ1Orp
Q1IKrKdoRWjhfDfaflpe/p4ssD9l3lfSnhTBepVC0XWYc7T1ov/e/8ICs/QQF8e5
KAGZnOUpH77ZGerKguzjpAx95EzrKQwO4OqQ1Kp/ry7WRlAGzUXwBgWwQUpMwBYH
aeHZtsiEmsEGqXpuWQ7xc7CZnaCLmLhhvr1zs3RlwAyVBI0i/r0K9O6b6T3mnrAi
Vdc7pH64b484PIDAF/0B3f+pZWwhiiAb7eRqENJ8vGfUjhaq3H8T3eAj3LS1qWvx
KibBLUii38yGCZqV0OIDz6id59aolynrSEjMhjHmBTytq+Eeh0X5XRd2JUr8cvbl
vrJIF/hGrdKTT6ITvi83UsBT3Is+eSHv6BDvm/IcXVdCZT5HXlIZHACTIQnEe+Ti
u1tfCGq8r2Xq5DeuQ621t+L23Smee7/Zh97byZWLMiswi7/YVOENhVIR7vOy5RyN
CXJkFhS6AVo14jSvuoJHYUdtSdEqFvI5SlZgmYR1aeEyo0JjxCNj+g8K9o98JivD
nf9ErvEtwr5JzUqqAFMp
=YoA/
-----END PGP SIGNATURE-----

--VIFPKPeEU/ajvd6j--
