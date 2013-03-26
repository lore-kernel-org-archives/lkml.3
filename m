Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab3CZCGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:06:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42563 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab3CZCGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:06:22 -0400
Date: Tue, 26 Mar 2013 13:05:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Brassow <jbrassow@redhat.com>, NeilBrown <neilb@suse.de>,
        Kent Overstreet <koverstreet@google.com>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20130326130553.b405a953bc2da6914313186a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Mar_2013_13_05_53_+1100_E/+0=s3F3eFPntWL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Mar_2013_13_05_53_+1100_E/+0=s3F3eFPntWL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/md/raid5.c between commit e3620a3ad526 ("MD RAID5: Avoid
accessing gendisk or queue structs when not available") from Linus' tree
and commit 2f6db2a70734 ("raid5: use bio_reset()") from the block tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/md/raid5.c
index 24909eb,7bbd285..0000000
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@@ -666,16 -665,11 +665,13 @@@ static void ops_run_io(struct stripe_he
  			bi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
  			bi->bi_io_vec[0].bv_offset =3D 0;
  			bi->bi_size =3D STRIPE_SIZE;
- 			bi->bi_next =3D NULL;
  			if (rrdev)
  				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
 -			trace_block_bio_remap(bdev_get_queue(bi->bi_bdev),
 -					      bi, disk_devt(conf->mddev->gendisk),
 -					      sh->dev[i].sector);
 +
 +			if (conf->mddev->gendisk)
 +				trace_block_bio_remap(bdev_get_queue(bi->bi_bdev),
 +						      bi, disk_devt(conf->mddev->gendisk),
 +						      sh->dev[i].sector);
  			generic_make_request(bi);
  		}
  		if (rrdev) {
@@@ -700,13 -700,9 +702,10 @@@
  			rbi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
  			rbi->bi_io_vec[0].bv_offset =3D 0;
  			rbi->bi_size =3D STRIPE_SIZE;
- 			rbi->bi_next =3D NULL;
 -			trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
 -					      rbi, disk_devt(conf->mddev->gendisk),
 -					      sh->dev[i].sector);
 +			if (conf->mddev->gendisk)
 +				trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
 +						      rbi, disk_devt(conf->mddev->gendisk),
 +						      sh->dev[i].sector);
  			generic_make_request(rbi);
  		}
  		if (!rdev && !rrdev) {

--Signature=_Tue__26_Mar_2013_13_05_53_+1100_E/+0=s3F3eFPntWL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUQKBAAoJEECxmPOUX5FEcBoP/ixFhfdEBW0TpyIKTFB9j51B
8eFJ3kcBcSLj9jQeAUZMyQJEDSDUv0SDJiol+l/O/jlk7YcIBisFL5+ao2HRnBYT
DZijdsdn4NVU2//K+AAJIJXeUkhvz7gjR8m+qrgKqcqrLSO4aN/nJkspe32gudY5
7KwZQQ13C4TTxSF8lIJ/UJzpshNKn0Ry0P3cSLFRugcH+qSfPct5OOL++oB3K5Mf
qllVxduOfxLhnN50qAJKJdrFGZJ1y7h/td4oF3TYJurNG4SGfV93DI/tW+gl+QZS
NlcS0SIKpI+UaOOKPGs9M6btMvLcKoJoWoCekfJEvhFYU8HmJhK07P5PdxcXu4Ha
F6gJP2sP4p+WW3NS68O+NpCtzjz9DPSkZsf+3SsoMkZ6Ae/psiOwgR5z/xAxTthb
MLYpzyx3i36CjwqhJl2siXRbLWKzr7prv3GTdDIrWKvZPHN63++IoCqoy4WZaO9F
KSNtTkIGQfMp5C1EJ7wP69rtyHKxzQqVnxG1Fxtr1Fo9FL6nRtFF6koeoJqeoVZi
qji/WhBz5Ne1lQTDar9uXoKB7jErbE6jYRr1iL/BUEA0yUNlktVl51k2NG1JaBh7
x7NJWcGVojhKxjRJAFF7tpgWH8Ys6oJwDJWnG97pU57LxqE+qXXsHySyj8X7IDVC
qnEZuiGf6fNAZqNkMkio
=Dir5
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Mar_2013_13_05_53_+1100_E/+0=s3F3eFPntWL--
