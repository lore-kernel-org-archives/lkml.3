Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbaLHNRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:17:10 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52040 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbaLHNRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:17:09 -0500
Date: Mon, 8 Dec 2014 13:16:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20141208131653.GY11764@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cou6PmgoyP0+llr2"
Content-Disposition: inline
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.19
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Cou6PmgoyP0+llr2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit fc14f9c1272f62c3e8d01300f52467c0d9af50f9:

  Linux 3.18-rc5 (2014-11-16 16:36:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.19

for you to fetch changes up to a63b87838a592577c7134a3cb89c74e59b9dd9c1:

  Merge remote-tracking branches 'regmap/topic/ac97' and 'regmap/topic/headers' into regmap-next (2014-11-21 11:32:36 +0000)

----------------------------------------------------------------
regmap: Updates for v3.19

A couple of new features this time around, nothing that should have any
impact on most users:

 - Cleanups and optimization of the path for reading back the register
   defaults from the hardware at startup, reducing boot times for
   devices that use this (most don't, either populating on demand or
   providing defaults).
 - A bus implementation for AC'97 devices.

----------------------------------------------------------------
Mark Brown (5):
      Merge branch 'fix/cache' of git://git.kernel.org/.../broonie/regmap into regmap-cache
      regmap: ac97: Add generic AC'97 callbacks
      Merge remote-tracking branch 'regmap/fix/cache' into regmap-linus
      Merge remote-tracking branch 'regmap/topic/cache' into regmap-next
      Merge remote-tracking branches 'regmap/topic/ac97' and 'regmap/topic/headers' into regmap-next

Xiubo Li (7):
      regmap: cache: fix errno in regcache_hw_init()
      regmap: cache: cleanup regcache_hw_init()
      regmap: cache: fix errno in regcache_hw_init()
      regmap: cache: speed regcache_hw_init() up.
      regmap: cache: use kmalloc_array instead of kmalloc
      regmap: cache: Fix possible ZERO_SIZE_PTR pointer dereferencing error.
      regmap: cache: Sort include headers alphabetically

 drivers/base/regmap/Kconfig           |   5 +-
 drivers/base/regmap/Makefile          |   1 +
 drivers/base/regmap/regcache-flat.c   |   2 +-
 drivers/base/regmap/regcache-lzo.c    |   2 +-
 drivers/base/regmap/regcache-rbtree.c |   4 +-
 drivers/base/regmap/regcache.c        |  63 ++++++++++---------
 drivers/base/regmap/regmap-ac97.c     | 114 ++++++++++++++++++++++++++++++++++
 include/linux/regmap.h                |   7 +++
 8 files changed, 164 insertions(+), 34 deletions(-)
 create mode 100644 drivers/base/regmap/regmap-ac97.c

--Cou6PmgoyP0+llr2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhaTFAAoJECTWi3JdVIfQCtAH/1Fo+6YO9dpAthxk0K4RHZKF
6fYb9Hw52NKkKqXmfSrU3ttQ8dvKguvLmnNPxVT45uahMPf3JALoevFV5Gz/MXVu
k4VmODBw0UDR405z/9HCLaQP3YqJ64wXT4shmDH9o/CcGe6RWr9ijAbzw+kh4lAY
E0XoRpkJcjNENYxA9rfVIO5nil49cqh6jfrgchNywemTzLYxydWkCJtfnaf2ixKx
D3ujRIoVgc+XbOhQI9YT38FwZ0DUELpEeLvaxcenvcMg5e+gmCJb5FaTssc1bOiH
/ljL51dC8zCL6gtljIS7wB8NASPrGwhBaYuYZlgSKjCcn/HycBK6SUUkjkiALSU=
=WphS
-----END PGP SIGNATURE-----

--Cou6PmgoyP0+llr2--
