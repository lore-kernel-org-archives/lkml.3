Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3KHKpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:45:49 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41747 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab3KHKps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:45:48 -0500
Date: Fri, 8 Nov 2013 10:45:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20131108104538.GH2493@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="piopQj3F5GMtthHx"
Content-Disposition: inline
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.69.173
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--piopQj3F5GMtthHx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb:

  Linux 3.12-rc7 (2013-10-27 16:12:03 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.13

for you to fetch changes up to 04bc9ac163a2550c7bc32750ea8dd2e049102be2:

  Merge remote-tracking branch 'regmap/topic/spmi' into regmap-next (2013-10-28 13:01:35 -0700)

----------------------------------------------------------------

regmap: Updates for v3.13

The main thing this time around has been some improvments to async I/O.

 - Cleaned up the async I/O support and extended it to allow single
   register writes more easily.  This is now used where possible for
   internally generated I/O, providing performance improvements for
   devices that can do async I/O.
 - An API for issuing a sequence of register writes as a single
   operation.  Some devices and buses can take advantage of this to
   do the I/O faster.
 - Addition of regmap_field APIs which help drivers for devices with
   repeated IPs or which move registers around between revisions to
   share helpers.
 - Support for SPMI buses.

----------------------------------------------------------------
Anthony Olech (2):
      regmap: Fix regmap_bulk_write single-rw mutex deadlock
      regmap: new API regmap_multi_reg_write() definition

Josh Cartwright (1):
      regmap: add SPMI support

Kuninori Morimoto (2):
      regmap: add regmap_field_update_bits()
      regmap: Add regmap_fields APIs

Laxman Dewangan (1):
      regmap: add helper macro to set min/max range of register

Mark Brown (17):
      regmap: Cache async work structures
      regmap: Don't generate gather writes for single register raw writes
      regmap: Simplify the initiation of async I/O
      regmap: Provide asynchronous write and update bits operations
      regmap: Use async I/O for patch application
      regmap: Use async I/O during cache sync
      Merge remote-tracking branch 'regmap/fix/core' into regmap-async
      regmap: spi: Handle async writes of only one buffer
      regmap: Only send a single buffer for async I/O if writing one register
      Merge remote-tracking branch 'regmap/fix/core' into regmap-linus
      Merge remote-tracking branch 'regmap/topic/async' into regmap-next
      Merge remote-tracking branch 'regmap/topic/core' into regmap-next
      Merge remote-tracking branch 'regmap/topic/field' into regmap-next
      Merge remote-tracking branch 'regmap/topic/irq' into regmap-next
      Merge remote-tracking branch 'regmap/topic/multi' into regmap-next
      Merge remote-tracking branch 'regmap/topic/range' into regmap-next
      Merge remote-tracking branch 'regmap/topic/spmi' into regmap-next

Tero Kristo (1):
      regmap: debugfs: Fix a boot time crash with early regmap init

Yi Zhang (1):
      regmap: irq: clear status when disable irq

 drivers/base/regmap/Kconfig          |   5 +-
 drivers/base/regmap/Makefile         |   1 +
 drivers/base/regmap/internal.h       |   8 +-
 drivers/base/regmap/regcache.c       |  19 +-
 drivers/base/regmap/regmap-debugfs.c |  57 +++++-
 drivers/base/regmap/regmap-irq.c     |  16 ++
 drivers/base/regmap/regmap-spi.c     |   3 +-
 drivers/base/regmap/regmap-spmi.c    |  90 +++++++++
 drivers/base/regmap/regmap.c         | 366 ++++++++++++++++++++++++++++++-----
 include/linux/regmap.h               |  53 +++++
 10 files changed, 560 insertions(+), 58 deletions(-)
 create mode 100644 drivers/base/regmap/regmap-spmi.c

--piopQj3F5GMtthHx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSfMDOAAoJELSic+t+oim9z8cQAJ5+WpGnjhHBm3hX1tFKX/0Z
ScrLiXTdiMw0oKmKcvpLZRkVXk3PalGjpHNRnKae/nB7UZXj5sQoQtpOd6tENHhE
I6DICt4MsZMwbOsAKcaToGNEiUnkfZXvQpq4yJjNc3v1FtuPKxGZB0JEeRs7SaAf
azrfvOeRknZ6KpmVOASYktZ7P8wwjPS2GMhaOs1GUh0xr+9chlxLxvl5AJQYGk6g
ZhksMJA3LWmGtwLszMKiFlbxd98/pQXEgq7I40yeGG7FkkLbfFEia1V5KvKz/eex
c5mVJPjbNhtiNgz6dZO6KJFLg2ClHSrELSWKnq+9bg8Qpf3bKZ4MXxqt6KHobmmp
M97M4eA3pf9vFX2MlY3wUUpepzZ3XVdvR2fC0hQZcPbirBXxovfoqrv1eJtURMbc
BnWRVt0hoJp4fS276D5/pCr6m9RaFo0bEztkY8RSzfi5WV8ttEpirE0obr1EdTDh
G7vcmRlGh5JXlDMk2ojgyf97D0y1e/6moBD4Q6TiNyy/ARXe0unWA05+5FkfnOJU
R+NlC0BmR3eYUHgpJo6Im11gaVFOpTyx9pyli2Xj/51/7B5mSyvb+8xMgj1clUwV
l4g4r/wGjqF5bu/4R6zGedrhrwmFybKSr0oEN0QdcMe5Y5oB6QWvB0KZbYWlA+sV
26mcFn+BaFqekDrwJ3Xu
=MtJw
-----END PGP SIGNATURE-----

--piopQj3F5GMtthHx--
