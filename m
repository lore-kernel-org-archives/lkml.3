Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3J2IAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:00:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54242 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab3J2IAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:00:36 -0400
Date: Tue, 29 Oct 2013 19:00:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: linux-next: manual merge of the arm-soc tree with the pm tree
Message-Id: <20131029190021.bb2dddcbd46e1ddfdfd5e441@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_19_00_21_+1100_pRvMV6tG=ykd4dI9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_19_00_21_+1100_pRvMV6tG=ykd4dI9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap2/opp.c between commit e4db1c7439b3 ("PM / OPP: rename
header to linux/pm_opp.h") from the pm tree and commit 92d51856d740
("ARM: OMAP3+: do not register non-dt OPP tables for device tree boot")
from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/opp.c
index ec21e6eb03e1,82fd8c72f750..000000000000
--- a/arch/arm/mach-omap2/opp.c
+++ b/arch/arm/mach-omap2/opp.c
@@@ -17,7 -17,8 +17,8 @@@
   * GNU General Public License for more details.
   */
  #include <linux/module.h>
+ #include <linux/of.h>
 -#include <linux/opp.h>
 +#include <linux/pm_opp.h>
  #include <linux/cpu.h>
 =20
  #include "omap_device.h"

--Signature=_Tue__29_Oct_2013_19_00_21_+1100_pRvMV6tG=ykd4dI9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSb2sZAAoJEMDTa8Ir7ZwV7g8P/3aBjCDILV7AX+Ssv4R5BNd2
Fq7v4tLW1JU0PMwQTK7fLmdMRaD8nMWg630w+ysgqStg5RIBR35DKO76Dq2sdFfu
/0j1UweHxRLRi087PP7jfy7ju2LG4EOzNjc17wx6CgOoUamjtO5S9U7JLOsi0ffl
M6fKeTrD1SeFW+72GQ7+bcqvnNvG3Nq/jPvp8mpFYIZGrh53Bz1AHAIB4yLnadb3
SNb8LJcmkWeYSKUN0UxU93jInsW4AbmJFS25NqE7m5Bh+P/wgMZPNNmUw9jkAnU5
w2y2niKT+aPRPQwZM67yNbz0hk1SeI6NWWsm7hllEUueiwIai/GbzeNM+1LFBSnX
p32S+axKRP517aGJWqdTxC9ovqUiImmin5wkMOpbIxPnSgaRimjA75B3HAz3N+8r
STlVDqYPaKynLcOvwZgvdCsZwLsbEd1AKg4ZC8Z+jpwzNYOWKrQVuZe030Bomlh4
6E7a3DwipTn4LpzxWCkhT3jB8vmst9Z9VCrefzDS1CUQuzYAdYehfXns4V/5GCqj
l2hQhUscsBD6Zh8ng+rzLPGUmZus3ZOAo8Gflf3pAd5tJ7PbUsV4eTvbs1NhxkKU
a/y9XB8f0D6wZBJbmpsfpx/iNEvjUrZNpA0Oi1UREUuE4gOQX6ba4Bgr7qCBN53L
kRx4FD1aFwdFS3LEanSf
=ep3y
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_19_00_21_+1100_pRvMV6tG=ykd4dI9--
