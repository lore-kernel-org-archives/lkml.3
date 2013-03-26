Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab3CZFL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 01:11:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44640 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab3CZFLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 01:11:25 -0400
Date: Tue, 26 Mar 2013 16:11:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>
Subject: linux-next: manual merge of the akpm tree with the block tree
Message-Id: <20130326161106.a482807476e631ed5422bed8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Mar_2013_16_11_06_+1100_37_Wgr6wg3NPYe5r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Mar_2013_16_11_06_+1100_37_Wgr6wg3NPYe5r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/blk_types.h between commit a38352e0ac02 ("block: Add an
explicit bio flag for bios that own their bvec") from the block tree and
commit "mm: make snapshotting pages for stable writes a per-bio
operation" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/blk_types.h
index e8de670,22990cf..0000000
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@@ -116,8 -117,7 +117,8 @@@ struct bio=20
   * Flags starting here get preserved by bio_reset() - this includes
   * BIO_POOL_IDX()
   */
- #define BIO_RESET_BITS	12
- #define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
+ #define BIO_RESET_BITS	13
++#define BIO_OWNS_VEC	13	/* bio_free() should free bvec */
 =20
  #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 =20

--Signature=_Tue__26_Mar_2013_16_11_06_+1100_37_Wgr6wg3NPYe5r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUS3rAAoJEECxmPOUX5FECQUP/jLwGkEqO70I6nmLSJAXUT+W
hQAnJJVKJqN1NB3Ow3HG6BaErOluNsuXgaS3NynwDth0NU7Iz15jMNk435ADUXB6
NxVkLlXI7Lc/0aP0AXBD8TkSZlpYfepKiYEzqPUtRyoF2LyqVJ0uMPgOm1vcvkDZ
MjRtEI8RB+24sCeog1JpNWI3K2kb82+GnCaNKQXS8KVlNqYcO8yR0akx0jNY5Sbk
1JsWtDjQet4+1CRe+46oWqfC5SmTJYA4UTwz66ramMfB/IqFn2WDs/cw4M9HyZJs
akKKfRH1fA4RMm7Flh2kQ3VAM17Cz1uLXGvoVLRiqwp9kajci7AEJwvoGyppazEk
48Ff5ZPZFysxJyxLmWm6mO4Zy+fKsic7APAo85oFPuj1VsTfY3HCINHwdBixO/Z2
Rg9UKP7Ac58Uf9mv8kh3xGN93KC6WkE0GdxUBSA7Nr4M81zfz3SR33uM6/zHgnur
2psaYaCLPGP4B6pY3j7+L7iCcKAKX6UnLKjp3Aeez4rrYKRG1tdegHWZH2UdCTbt
l4Xn62cx1laS2lbuJrcTOK21Fgy/aFPh3i3wdQzt5bH2x2qihbTeHWz2MhV5zTVj
+ctF2uZXaDmpi6+pitR0SdfxTYB4TDtMKETkJ9uduj4LtYzaqSKvlfbTgwvH5TDA
zHvkZKr62/bMtUSoaKDm
=9XFX
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Mar_2013_16_11_06_+1100_37_Wgr6wg3NPYe5r--
