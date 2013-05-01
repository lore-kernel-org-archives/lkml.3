Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3EAFRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 01:17:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35436 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab3EAFRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 01:17:20 -0400
Date: Wed, 1 May 2013 15:17:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <koverstreet@google.com>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20130501151709.9ff4ebb3a76248b175bad9fc@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__1_May_2013_15_17_09_+1000_3RT0RlTspxfkoHy3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_May_2013_15_17_09_+1000_3RT0RlTspxfkoHy3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
include/linux/blk_types.h between commit 713685111774 ("mm: make
snapshotting pages for stable writes a per-bio operation") from the  tree
and commit a38352e0ac02 ("block: Add an explicit bio flag for bios that
own their bvec") from the block tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/blk_types.h
index 22990cf,e8de670..0000000
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@@ -117,7 -116,8 +117,8 @@@ struct bio=20
   * Flags starting here get preserved by bio_reset() - this includes
   * BIO_POOL_IDX()
   */
 -#define BIO_RESET_BITS	12
 -#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
 +#define BIO_RESET_BITS	13
++#define BIO_OWNS_VEC	13	/* bio_free() should free bvec */
 =20
  #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 =20

--Signature=_Wed__1_May_2013_15_17_09_+1000_3RT0RlTspxfkoHy3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRgKVVAAoJEECxmPOUX5FEbB0P/3CIPuRuvwx1cSzxr7m9JKRU
/uQ5npQb+NG/ih1EYdiQkEmhIkzBY4Jf1t3dVipCQ4pIBirRzxlzfXyfdT6060Q+
6D/dpECCY6+ebPX9yWj1IuQsiFuDRmipJ0F4iKlMoukTzfsJLmgN2uT9FSdae7I2
AxjNGICu7PHDJur6VJlVv0M8PINiwoktwXKWhLDoJlHAeyxCRb4SaI3bXnlsc1QZ
AxDX0wpId0DVENydJ5pM2vvS2XqigJaTf+QBxmu9/wrjFFjcQw6IwkkuaOKbOvt0
u+lVUZhPbgzb72478crY5IH6xBndzsaLdQ+l0M6oOvEeAnHlR4R44krNPVnM2s7T
T/c1GAm7qgfy5bl6DWKIwZ0MAhpzMRBziezgWgdh6t3NUJBVEw6lIk5Qq2gfSdnX
tLGSV34rUcscP6k+HtrfztNpg+2HfZqacxiGM9ZNNxeZaTU62o6NKTIZCQE/btIW
sLVNuvanl5qNWVZ+nMzsz0xFrg8kJL+k0IcO3+lptPH2YfMArPe7PhmK+i/zPOF+
2fLWZbnWCcAU1RPQzCZwk/UqCHuHbIIUoNenIHqPthlG7wXDtHGPnAm3vx1biUaM
5MNtpSJ0xYUW+05iuodB1vEDYFtXQbGrNCJdIMCgEs92VG5Kman4SYL93zshM3XW
uA6WN1Xd1oOuoR129GwP
=pkdN
-----END PGP SIGNATURE-----

--Signature=_Wed__1_May_2013_15_17_09_+1000_3RT0RlTspxfkoHy3--
