Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3KEG3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:29:13 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52611 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab3KEG3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:29:12 -0500
Date: Tue, 5 Nov 2013 17:29:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: linux-next: manual merge of the akpm-current tree with the block
 tree
Message-Id: <20131105172905.696e2d54c2439d6e50566ea8@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Nov_2013_17_29_05_+1100_MM4/kKplC3SBQCl9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Nov_2013_17_29_05_+1100_MM4/kKplC3SBQCl9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/bounce.c between commit 5d1f127c3e0c ("block: Convert
bio_for_each_segment() to bvec_iter") from the block tree and commit
df5494a36263 ("kthread: make kthread_create() killable") from the
akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/bounce.c
index d5873f21567d,c9f0a4339a7d..000000000000
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@@ -198,14 -201,11 +198,12 @@@ static void __blk_queue_bounce(struct r
  {
  	struct bio *bio;
  	int rw =3D bio_data_dir(*bio_orig);
 -	struct bio_vec *to, *from;
 +	struct bio_vec *to, from;
 +	struct bvec_iter iter;
  	unsigned i;
 =20
- 	if (force)
- 		goto bounce;
 -	bio_for_each_segment(from, *bio_orig, i)
 -		if (page_to_pfn(from->bv_page) > queue_bounce_pfn(q))
 +	bio_for_each_segment(from, *bio_orig, iter)
 +		if (page_to_pfn(from.bv_page) > queue_bounce_pfn(q))
  			goto bounce;
 =20
  	return;

--Signature=_Tue__5_Nov_2013_17_29_05_+1100_MM4/kKplC3SBQCl9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSeJA1AAoJEMDTa8Ir7ZwVwIsP/j/lMy95Ce6Vy6cvceFzTlNK
J6vQSY5IwKCjIW09Ywrg5yt6S6tKnYqJ3+gprucexx86hU4CL3646lHs1y4sveWv
vRx3W9yQMJmYwmjjnvv+7fidjYBxcXsp8A8JGst8uMZNWjtxUhwXeqF22+wS9/EZ
9my7eMDg4FWtMZbSIg86jNRch/yUMc0cVOiRGWte+E5gvsCVDgGtszTjgun4AKKp
h7doE8hd/ftVz5OmQXm11PNSvqrJnnWZTrmP/qWBnfhCpU7/kS6oepIfLUDtBT9a
HV5gVNdKZXlJigWi0yFoQk41CZOM8o+TCkJG7G4Uk40bWDJF5SNQIL//RQ3PzVB2
o9r7S0t6r8s9T2yf14jsnWz2FpgTwRVLHqnCdRgtoTDE/W/f0DlqaIrgeYXFtI8x
IyUd1/DiTHZ34eZ/JyNd0cguK0kuqJ5nNC9R+DY7Y5AbcdkDJW9LsUiRg2714k3/
0vUWvrolopjXWGGpw2Y6pQ+q3dbUIOHG6vfCsixIc0u8f4p8HUn4oCug5jIBg8jF
V9ynS5EgE071YJXsLyZ4juG7aWyUfd8bxd0x0dd6W6lyJZLTKgatc9vzQ8M50CGh
wbjFQAqEbjWxsGyvPwwDmyHd86L/CwsjmPy1TkhMdtDRm/ohoL3r9BczCHoLIV1h
4I4g5AE4+V0VscEgkNBJ
=Wwl1
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Nov_2013_17_29_05_+1100_MM4/kKplC3SBQCl9--
