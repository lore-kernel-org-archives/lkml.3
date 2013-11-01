Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab3KAD31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 23:29:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41134 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3KAD3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 23:29:25 -0400
Date: Fri, 1 Nov 2013 14:29:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Chao Yu <chao2.yu@samsung.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: linux-next: manual merge of the block tree with the f2fs tree
Message-Id: <20131101142918.147eb63b910dde9b5bb90aee@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Nov_2013_14_29_18_+1100_k+dz_EyfW.7xiqjc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Nov_2013_14_29_18_+1100_k+dz_EyfW.7xiqjc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/f2fs/segment.c between commit cc7b1bb17367 ("f2fs: avoid allocating
failure in bio_alloc") from the f2fs tree and commit ed2d2f9a8265
("block: Abstract out bvec iterator") from the block tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/f2fs/segment.c
index 3d4d5fc19e6f,9d77ce168676..000000000000
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@@ -675,9 -676,8 +675,9 @@@ retry
  			goto retry;
  		}
 =20
 -		sbi->bio[type] =3D f2fs_bio_alloc(bdev, max_hw_blocks(sbi));
 +		bio_blocks =3D MAX_BIO_BLOCKS(max_hw_blocks(sbi));
 +		sbi->bio[type] =3D f2fs_bio_alloc(bdev, bio_blocks);
- 		sbi->bio[type]->bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
+ 		sbi->bio[type]->bi_iter.bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
  		sbi->bio[type]->bi_private =3D priv;
  		/*
  		 * The end_io will be assigned at the sumbission phase.

--Signature=_Fri__1_Nov_2013_14_29_18_+1100_k+dz_EyfW.7xiqjc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScyATAAoJEMDTa8Ir7ZwVeuYP/Am7Gy17k4bRwOGF+WWGD19I
sBWEdFx/Ay7SQDprzSYl2YIRRUvFheCCK7IwGYdOkw1NuEntmqjVAXos4uLn7ZuW
/YhQN4UFwkvRz4+NDAAocAKh63t9I4tIJ4dRh5rKvHsAyKl1pDFS0bScMlvOWJxf
/Isdxo4+YYcIE5NsrYudThucQGpd10+UreqLaCGEtNLirNu3XxbloTBTcTAjzd/a
LpxUrCe2BMC/SqyHXwNbAdxjtUyhf0lq0QZxqxLnlJSGFDGSwnXDbMl/DDFp7aiS
9OnvcEPkcLMUVQYHSamckmL0fh52qI3CAJzomiqYw2yMI48gnHVVrM43eXGOMdkr
bXXyZUcrEZ45sJEzc2Z+dxVw8HUd68BFr+7v/t7bLdQ+Bj0oINhXfGNGDyVEZTpv
/k1kq2iexnpVYHiFFak32qXjEmVn+lPQrDRizSjtpCDNWbyI3AJRwWZIe5Hkbvqg
p5hhNqHZRgJHcIfPrACUsZt1DwsRtas8rj4MsuFJsXILwljegXAPOZDj229WkWlP
y9OyV2oK7cIaL9Lreujvz+el37M8kBXC6Ltl0WMRCWKKMTSxdhdh56Y4ZR5ydTfK
Bz9GF7nXb/xbDmk2GWX4LEt6QNWRRxm2NKFuSdGx8K4LIO/Fd2HoodAFV6PLzBh9
sHy1rLXxnBsNpNQYhxUd
=5J02
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Nov_2013_14_29_18_+1100_k+dz_EyfW.7xiqjc--
