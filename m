Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3LMN7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:59:41 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53575 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab3LMN7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:59:40 -0500
Date: Fri, 13 Dec 2013 13:59:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131213135917.GF11044@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y/IXGmCbwaJEfeoX"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y/IXGmCbwaJEfeoX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 374b105797c3d4f29c685f3be535c35f5689b30e:

  Linux 3.13-rc3 (2013-12-06 09:34:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.13-rc3

for you to fetch changes up to 334a82086d6428ede052c4cd11ee588bcdf2a9e8:

  Merge remote-tracking branch 'regulator/topic/constraints' into regulator-linus (2013-12-13 13:44:57 +0000)

----------------------------------------------------------------

regulator: Fixes for v3.13

A small set of driver fixes plus one larger core change which changes
the way we check to see if we're using DT so that there aren't any races
between deciding we're using DT and the regulator subsystem noticing.
This makes the new support for substituting a dummy regulator and
optional regulators work a lot better on DT systems since it ensures
that we don't trigger probe deferral when we shouldn't which was causing
bugs in clients.

----------------------------------------------------------------
Axel Lin (1):
      regulator: pfuze100: Fix address of FABID

Mark Brown (4):
      regulator: core: Replace checks of have_full_constraints with a function
      regulator: core: Check for DT every time we check full constraints
      Merge remote-tracking branches 'regulator/fix/as3722' and 'regulator/fix/pfuze100' into regulator-linus
      Merge remote-tracking branch 'regulator/topic/constraints' into regulator-linus

Tim Harvey (1):
      regulator: pfuze100: allow misprogrammed ID

Vince Hsu (1):
      regulator: as3722: set the correct current limit

 drivers/regulator/as3722-regulator.c   |  2 +-
 drivers/regulator/core.c               | 11 ++++++++---
 drivers/regulator/pfuze100-regulator.c |  2 +-
 3 files changed, 10 insertions(+), 5 deletions(-)

--Y/IXGmCbwaJEfeoX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqxKxAAoJELSic+t+oim9P1IQAJZ1H3KbqUrjUHhI++MwyNBP
PpxYfP4So3Iu+UjnjrdD2gMHiM4Zls6rN4Vq6kT08GDt9u3kYnsPH60FvJoMrXpw
zs+Z1HHC8ZhYx00C6rSpJy7TvhxgeDSeu0itH5HuNghHAYfiU9nDFc7BVjl+vduq
nyvO3ZiS59oY0odxu37rTqHnEqCh1I+vMMVV0HGIXsJ5wwqBxzVpz1ANZ1eePO2w
OIDtdDf20usioH6YDqQk2NHzOM+1pvD6esVajnOCLYGzSt4k7munV1zS0Fzz5Mnk
Y+YBS9YsZa0S+/tydEcoXTDfTGZSSVEhJ4Pv1wXZWU48sSVfDJ87ImzxLZzyIH/S
eCggnpqaIIvEkQYfiCMTFadmrqeydbpQB2ibHGdewR6IIBM8Fkes01MX6ot6zHMx
tZd7CCAK5t5RrH/xmTy3+m0NLayHKQ4c3cMhYCgDCbpMGEb0fMlmsqqQhKMGwDXM
g34ODB+L5s79fKIqR6F3aB8mkHgSGelw25xJmn7wp7tkvs36nrEo0i9Q7MFjFWfP
puh/SKXRINWbEGRodHj7fkUxLwZoeyY2Omrrl4alLscNaUlTm3BiwibMA3h36EOc
pEw2CEdeLda57H3/C/XEceM2Qc6XosNL1dVZWR9KV49ho53FFD9uXaKaDGcdDsK7
uQlgE/Ic1VYS4pAij1Ks
=G5px
-----END PGP SIGNATURE-----

--Y/IXGmCbwaJEfeoX--
