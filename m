Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab3LQCQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:16:26 -0500
Received: from ozlabs.org ([203.10.76.45]:56445 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab3LQCQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:16:25 -0500
Date: Tue, 17 Dec 2013 13:16:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: linux-next: manual merge of the device-mapper tree with the block
 tree
Message-Id: <20131217131615.ad900aa79aadfdef3509b4ec@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Dec_2013_13_16_15_+1100_Htl/tmtVzlet17+M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Dec_2013_13_16_15_+1100_Htl/tmtVzlet17+M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the device-mapper tree got a conflict in
drivers/md/dm-thin.c between commit 4f024f3797c4 ("block: Abstract out
bvec iterator") from the block tree and commit 1d8b40855c42 ("dm thin:
requeue bios to DM core if may_requeue_bios and in read-only mode") from
the device-mapper tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/md/dm-thin.c
index 357eb272dbd9,dde2b1eddbce..000000000000
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@@ -1262,8 -1260,8 +1266,8 @@@ static void process_bio_read_only(struc
  	r =3D dm_thin_find_block(tc->td, block, 1, &lookup_result);
  	switch (r) {
  	case 0:
 -		if (lookup_result.shared && (rw =3D=3D WRITE) && bio->bi_size)
 +		if (lookup_result.shared && (rw =3D=3D WRITE) && bio->bi_iter.bi_size)
- 			bio_io_error(bio);
+ 			handle_unserviceable_bio(tc->pool, bio);
  		else {
  			inc_all_io_entry(tc->pool, bio);
  			remap_and_issue(tc, bio, lookup_result.block);

--Signature=_Tue__17_Dec_2013_13_16_15_+1100_Htl/tmtVzlet17+M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSr7PzAAoJEMDTa8Ir7ZwV/FIP/j+AlaIUqzIJTPEp7kyKM0uF
Pw/WRRtrY7uwEZQ9Lj29ZY0v7Ee5SDMypEgYZXYeCHOlNceJtqkNhT43d12+yNvU
Vrk3Na2OZRWrmazJ64cgWu6WVTy4qO/u4sVY2zoM9JtVtllZUGqNt+rlkq/cSnjv
6j8SrltOpOIiYnkPn59OAP5Fd/m+tgH2UaTXhdO8G3i0+2nVQTx8FSHtff0fS0tm
AcxkWvlmuzqZcf4Te4w1XxryJpSGcEy3pKP/aF/CjBniPLbLM+YWKRv0MYwBAXPq
TzrfsWUBsVS3rjJZKYriwhCeCVpTAYPrHUD2+GAUEbC28E9cMn6yCZdJw8Q3ZX2C
wBDsxha3ZBwyIlcIaaNw4XB6IwMszsRV4PFkIwL1xbJyyoUWbzF7QktNvJKmiHyt
bsJLWu2/3QrB8SWgX3Xl+T+WxAq9MkPYrojsM2ZXR+cTjVM/ZXG3NxQFsDKy+rHU
yF9+Is6zs9S6KULyD3BD4CxOsNY0VNXNeap3MFLLY1RB1xWtA0pAJK+5Fv8o/Kkq
sKNT3T/6lTjTK5MTMVZPhhsGbV6BBu4R8hPlsyqipvU1l32vh1GwwrB2fQA7t+S4
6OrPKxPhee0o+3j88groh3EDFZWjGabJCrskIItQ7hW+qjk9jgCMKatCwLB8y5DJ
E+ausk6q8Qs9JAZ1W80p
=VXE4
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Dec_2013_13_16_15_+1100_Htl/tmtVzlet17+M--
