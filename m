Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3AWGeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 01:34:07 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57357 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3AWGeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 01:34:06 -0500
Date: Wed, 23 Jan 2013 17:33:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>
Subject: linux-next: build warning after merge of the akpm tree
Message-Id: <20130123173358.64b7d2cd01fde200225d46ec@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_17_33_58_+1100_lQzobP1nFOWa3=tM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_17_33_58_+1100_lQzobP1nFOWa3=tM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (arm defconfig)
produced this warning:

mm/page_alloc.c:4477:23: warning: 'sanitize_zone_movable_limit' defined but=
 not used [-Wunused-function]

Introduced by commit "page_alloc: introduce zone_movable_limit[] to keep
movable limit for nodes" from the akpm tree.  It is defined both when
CONFIG_HAVE_MEMBLOCK_NODE_MAP is defined and not, but only used if it is
defined.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_Jan_2013_17_33_58_+1100_lQzobP1nFOWa3=tM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/4RWAAoJEECxmPOUX5FEEAQP/iqhCuY53SNXSx+xmtV8NPAR
BIOuN33TEhlKkmfJmQimAjJTCbJb+uyXIq5Z8Q+ziZQ1SewDbpS7OMFq8H88WZaY
/zaZ1F4MZL3J4gkca/bEHt/VBtXVQ1NDfOcVo15FqkvrEo8oxmI9gn6oy0+xJCBw
bB3GcvnMaXO8gQILcCOBm3FUP10xTHQtb/rnbpawlEdux/NdOgx7vodUK2G1T0Ko
97mMoaKYmc1jyJFliFN2ddTmDECkJ3hFB1JEW7VZ48zBniLIvAzXadOK+y+F37p3
u41T3Efws5GOJZmtGwNfmyYepjt8u0Z5oNkMUX90bZQLpP2jeWGk/fZFLg9Rbcqz
1Lm3XPd3AevuryLvB1PUsmj5b6XYxBIP9qH7YhOGBqyJTYoKKKKSnLXJhfx6w2jq
JWmg6dQFGSEujtQvS/v9so8xVevb1bNYncQSrrWMyXNW6qg1VzIcTAHlz8zBWaJc
XzZAgJIiIR5io0kpNShs4c1UprVVZJ0EJGChsNvHQMkHV9pbYNxBvran5AJDmYEa
v+w3WiLt1P226rGeHdDkesJrah/K1ZmJq2lgR0UAAhPieYEZPkY2XSuwjka5LGpb
YZj+nHEy1rcnwqHpGOqJ8R0zoprsJAZ0OXjHU+8t6wx20TAzfkiRKyM1R7kj+jlZ
ffo6LI2z87TegjNBkBp0
=LCPH
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_17_33_58_+1100_lQzobP1nFOWa3=tM--
