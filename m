Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab3GLAe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:34:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56982 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab3GLAe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 20:34:27 -0400
Date: Fri, 12 Jul 2013 10:34:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the arm-current tree with Linus' tree
Message-Id: <20130712103423.93102f3d08d1644cf3e59256@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Jul_2013_10_34_23_+1000__Ab8S_+M.gPQ_pBj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jul_2013_10_34_23_+1000__Ab8S_+M.gPQ_pBj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm-current tree got a conflict in
arch/arm/mm/init.c between commit dbe67df4ba78 ("mm: enhance
free_reserved_area() to support poisoning memory with zero") from Linus'
tree and commit 319e0b4f02f7 ("ARM: mm: fix boot on SA1110 Assabet") from
the arm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mm/init.c
index 6833cbe,0ecc43f..0000000
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@@ -597,7 -600,7 +597,7 @@@ void __init mem_init(void
 =20
  #ifdef CONFIG_SA1111
  	/* now that our DMA memory is actually so designated, we can free it */
- 	free_reserved_area(__va(PHYS_PFN_OFFSET), swapper_pg_dir, -1, NULL);
 -	free_reserved_area(__va(PHYS_OFFSET), swapper_pg_dir, 0, NULL);
++	free_reserved_area(__va(PHYS_OFFSET), swapper_pg_dir, -1, NULL);
  #endif
 =20
  	free_highpages();

--Signature=_Fri__12_Jul_2013_10_34_23_+1000__Ab8S_+M.gPQ_pBj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR308PAAoJEECxmPOUX5FEV/IQAI2TCHdsAwOYjImgsCtQMGP+
VRM9p+Q8xwh9V9V5kQt6u82rIO238mNLrbVjayozCHrQL+YaawzFjC07oHE5Gs7j
7hbFBPImDZAqNN91EGuWoMOqtqJOwMZKhfRvimBOCojmUoaY2bZvdlbVRb1uDRoK
T4PesWsa5dQamaHHXbGNCP+ICxEI8xKtbeosUhIEbS0tTIFOmM2TogEGuzQbiODD
bOqM7a4vkOqqLlgNreOV56oTc4stSzDmCP9q9oFEL2fSKjV7XrVyFNjimA/ezKAu
H+ff/lKLc5ZH16wb6de94DxLZgxK/LrchVsBZQXPKRmh5Pw4m9S/Z+VjSN2z+iMr
boVxjCTVdYKAHXGFmvvDf/0yuSox/WKPuhPYZqVGLL2loDkuK7Zb/A9VPr9fV3tj
80FpiCQd8XaHD7healteOf1ijPhXwLOzicRPPWo725WAPDs6GnxLRfH3If8SELsh
XGEUGGTGSkj5JpGJS4IPZ2OK57XyLSZNc+fRanimZgWRWs/vFBkT853zToN4XDjx
ApamPj6NAewq3LRNEyxgEoTMeIsTJVQKBTligNviSh4OSS1pJ3I/rl6XSCWuyvap
TMES/H7J9/Iy0GR9GYMx8CPioT9yeS+aDf+D3eMWQiCdYZNo2X1edGP3iYXccQVM
TD+XWHksEeBexQgtQKpp
=8flk
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jul_2013_10_34_23_+1000__Ab8S_+M.gPQ_pBj--
