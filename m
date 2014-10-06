Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaJFMHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:07:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36860 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaJFMHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:07:47 -0400
Date: Mon, 6 Oct 2014 12:44:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20141006114446.GK4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lZZ4ablUVnt2XgAh"
Content-Disposition: inline
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.18
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lZZ4ablUVnt2XgAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit fe82dcec644244676d55a1384c958d5f67979adb:

  Linux 3.17-rc7 (2014-09-28 14:29:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.18

for you to fetch changes up to f5b313a2bcd4c436560c044c726d9ad84a3e4bb3:

  Merge remote-tracking branch 'regmap/topic/cache' into regmap-next (2014-09-29 20:49:42 +0100)

----------------------------------------------------------------
regmap: Updates for v3.18

The main update this time around is the addition of a standard DT
binding for specifying the endianness of devices.  This allows drivers
to support any endianness of device register map without any code,
useful for configurable IP blocks.

There's also a few bug fixes that I didn't get round to sending, none of
them terribly severe or new, and a reduction in size for struct regmap.

----------------------------------------------------------------
Geert Uytterhoeven (2):
      regmap: Add explicit dependencies to catch "select" misuse
      regmap: Split regmap_get_endian() in two functions

Jarkko Nikula (1):
      regmap: cache: Do not fail silently from regcache_sync calls

Javier Martinez Canillas (1):
      regmap: Fix DT endianess parsing logic

Mark Brown (6):
      regmap: Restore L: linux-kernel@vger.kernel.org entry
      Merge remote-tracking branch 'regmap/fix/core' into regmap-linus
      Merge remote-tracking branch 'regmap/fix/debugfs' into regmap-linus
      Merge remote-tracking branch 'regmap/topic/core' into regmap-next
      Merge remote-tracking branch 'regmap/topic/dt-endian' into regmap-next
      Merge remote-tracking branch 'regmap/topic/cache' into regmap-next

Markus Pargmann (1):
      regmap: Fix debugfs-file 'registers' mode

Pankaj Dubey (2):
      regmap: fix NULL pointer dereference in regmap_get_val_endian
      regmap: fix NULL pointer dereference in _regmap_write/read

Stephen Warren (1):
      regmap: of_regmap_get_endian() cleanup

Wang, Yalin (1):
      regmap: change struct regmap's internal locks as union

Xiubo Li (4):
      regmap: add DT endianness binding support.
      regmap: Add the DT binding documentation for endianness
      regmap: debugfs: fix possbile NULL pointer dereference
      regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.

 .../devicetree/bindings/regmap/regmap.txt          | 47 ++++++++++++
 MAINTAINERS                                        |  1 +
 drivers/base/regmap/Kconfig                        |  3 +
 drivers/base/regmap/internal.h                     |  6 +-
 drivers/base/regmap/regcache.c                     | 13 +++-
 drivers/base/regmap/regmap-debugfs.c               |  8 +-
 drivers/base/regmap/regmap-i2c.c                   |  2 +
 drivers/base/regmap/regmap-spi.c                   |  2 +
 drivers/base/regmap/regmap.c                       | 86 ++++++++++++++++++----
 9 files changed, 149 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regmap/regmap.txt

--lZZ4ablUVnt2XgAh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUMoCtAAoJECTWi3JdVIfQDZkH/R6Wk+dELUTWK2shpE8kj9tS
xgjFW3Wc4+4sMLR7F14BxTH9K8e998XRffFvu02z38AGQLLX7u4oOi7pbB0NDfeY
hhu8MNMcyfs3Hfmle+AytqYnyRkCzYbvfIUdPsXSypEgNRpqOckfHj5C8r3rT3fQ
JBQW/DLL1cW10JcXZBvv+ouDLvP6v8taVLVh5UMenjFV8YWTowgJSqBdFijPwbA0
G36AO0vcFwAWX9AAm29RbjdMMZkrw3vVZVcJvm56xuwE6cM7rdoMxFDA/vt8L1zO
2CI1bHeRdSH4ziRAQUHG7v2dE8Gfz4DzCPuA8+A77Tx4RXLAdkJKQtvgeL8ES6Q=
=ESNi
-----END PGP SIGNATURE-----

--lZZ4ablUVnt2XgAh--
