Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3KZA4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:56:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33709 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3KZA4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:56:32 -0500
Date: Tue, 26 Nov 2013 11:56:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: linux-next: manual merge of the block tree with the f2fs tree
Message-Id: <20131126115613.55f5f0f544c57677be035582@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Nov_2013_11_56_13_+1100_OzYtznVzW2nEngnp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Nov_2013_11_56_13_+1100_OzYtznVzW2nEngnp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/f2fs/segment.c between commit a79ad49b87f4 ("f2fs: introduce a bio
array for per-page write bios") from the f2fs tree and commit
4f024f3797c4 ("block: Abstract out bvec iterator") from the block tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/f2fs/segment.c
index 1c84b7e15631,36e8afd8e1e4..000000000000
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@@ -908,9 -681,9 +906,9 @@@ retry
  		}
 =20
  		bio_blocks =3D MAX_BIO_BLOCKS(max_hw_blocks(sbi));
 -		sbi->bio[type] =3D f2fs_bio_alloc(bdev, bio_blocks);
 -		sbi->bio[type]->bi_iter.bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
 -		sbi->bio[type]->bi_private =3D priv;
 +		io->bio =3D f2fs_bio_alloc(bdev, bio_blocks);
- 		io->bio->bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
++		io->bio->bi_iter.bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
 +		io->bio->bi_private =3D priv;
  		/*
  		 * The end_io will be assigned at the sumbission phase.
  		 * Until then, let bio_add_page() merge consecutive IOs as much

--Signature=_Tue__26_Nov_2013_11_56_13_+1100_OzYtznVzW2nEngnp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBCAAGBQJSk/G1AAoJEMDTa8Ir7ZwVaegP91Z65vVLzYn0ZEGUFqJnYt1l
L4HQJD+Sy/bYM2sFwjVAzzr88XU9yyJMWeKOhnnPqcbmcLZsc8BdlQndYw/wNdjr
7pFa4tkaqaUNnbGIwTF8HWcvLB09WSM/3uVZqC4vMiZ7FqUz3NZ/++3zobO1krsy
Y7oO8q/WZeoToJeSZ6AVgoykUsSBmVM2dASAoQ565Sau5MBLdcdgI+e8uxy1JaXj
xvosWh253NIpgLEthSS5f9j2UQWQbu2cpuszE+rv8PlSKVN46w6nj3V4f4Ub0yZK
hwx78+fmXAeLWkBX548OKwCOm/yGLvFz19JCdXq4gPK0hA57dFm0PY5xnjJosqFS
FsBQISNdjQlfu7C8ULK+TySoNnqLtiODZ1YiAVytIXRIZ71q9DIg29211nmXDTXY
jckhi7UKYSyVyMjjip9Le7/zKAJnj5Sxj2zpGcrDv8TmmZldxgTxruSA74e0iBmm
Vz4gtB/Wulc4kGBBCx5yB45fMrqff8EFdjMb3gLxPJE8IQPgGqiNnpYRYnwBT585
rsQFufVETyL6Xa0qmlVKmYGO0yebSPMYwWy1PCmC++DAizODCV6w6jjrwlLZdt0d
I2vlnfg69V7pzVmMr/fBiVXzc7QI2fOxxVh9FxucbJAmK6LnSBh3ttAHKLhpnjaf
Ulo6kKVV/4NkhWPpjnQ=
=BqO+
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Nov_2013_11_56_13_+1100_OzYtznVzW2nEngnp--
