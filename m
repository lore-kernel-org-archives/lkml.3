Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3LQFn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 00:43:27 -0500
Received: from ozlabs.org ([203.10.76.45]:42905 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3LQFn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 00:43:26 -0500
Date: Tue, 17 Dec 2013 16:43:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>
Subject: linux-next: build failure after merge of the final tree
 (akpm-current tree related)
Message-Id: <20131217164317.f9ba5505266969cd32706a79@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Dec_2013_16_43_17_+1100_a=xtZj/sut1.KYm3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Dec_2013_16_43_17_+1100_a=xtZj/sut1.KYm3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

arch/powerpc/mm/mem.c: In function 'do_init_bootmem':
arch/powerpc/mm/mem.c:212:49: error: 'memblock_memory' undeclared (first us=
e in this function)
  memblock_set_node(0, (phys_addr_t)ULLONG_MAX, &memblock_memory, 0);
                                                 ^

Caused by commit 3a543893d46a ("memblock: make memblock_set_node()
support different memblock_type") from the apm-current tree.

I added the following fix for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 17 Dec 2013 16:38:21 +1100
Subject: [PATCH] memblock-make-memblock_set_node-support-different-memblock=
_type-fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/mm/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 231b785b726e..8c1dd23652a1 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -209,7 +209,7 @@ void __init do_init_bootmem(void)
 	/* Place all memblock_regions in the same node and merge contiguous
 	 * memblock_regions
 	 */
-	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, &memblock_memory, 0);
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, &memblock.memory, 0);
=20
 	/* Add all physical memory to the bootmem map, mark each area
 	 * present.
--=20
1.8.5.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Dec_2013_16_43_17_+1100_a=xtZj/sut1.KYm3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSr+R7AAoJEMDTa8Ir7ZwVJYsP/0O86UyHhPj+iSHbhUVrX0X8
5kxqcOCZzxiec/R94JzTnMG5yi0zdjiRKygDcSG6LuQCwE5yWwbGG83zBw9V6US1
VpNhp8BAwS9KdMP499iKF40F69E6uf3eKEqPNR3JLAAhnsYp7uhBES7D+M5QAPMz
UJesYzxsGiyqf7lturUcGqypIbjERVRnNFrFNUIAG7GUA9ahlKnlSuPdzorh2CjC
TR04o9xkpKtOOFJfRjCw8TNl6+41NwAt6Q/MJBnoF9x/bUFDbmUICr+uYqCCeN7G
G+ziF3R9LcXbatq5BYTB5C22LE6dvQug0vjtmz9bvUVl8KwtxjhoYvpFW+va+o6w
mYuxVbWsPqTKfMbW5ny8CaB+4lh5F5uztJPWQYcdCApWqYMzOZlOs+NhrqdT0bXn
SKVeCMLYIxEDWZjYM7LEaVX9LSTcJYGu0miIT0NeXYn2RGxFnkaGUFMLnGjEcDlb
6ki3RsaGcuOQvT8BFL6wdH4YrgHQZel2xJPWFzb92GtyO3EAP9wuWUzn86Tpqz6y
5rEXorC3H/IW69bKMg9rfvQ+R8yIzY710Yi9IcBAHMu5RkK8kQBc7YuzDbLCrYcy
BKvukiWlDcQ5pWgWHP27Q6gYUpMvxM4n84fSRNk1jYI/G9haspvY/7VDa50B48uI
qhDrqy/lHFsxLBpbLh7z
=Yv92
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Dec_2013_16_43_17_+1100_a=xtZj/sut1.KYm3--
