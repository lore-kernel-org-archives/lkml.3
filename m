Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaAIEB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 23:01:57 -0500
Received: from ozlabs.org ([203.10.76.45]:58849 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbaAIEBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 23:01:43 -0500
Date: Thu, 9 Jan 2014 15:01:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Valentina Giusti <valentina.giusti@microon.de>
Subject: linux-next: manual merge of the block tree with the btrfs tree
Message-Id: <20140109150133.cfaeb84aeea153c52bcb9828@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_Jan_2014_15_01_33_+1100_2hHAKjWccERnguUq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Jan_2014_15_01_33_+1100_2hHAKjWccERnguUq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/btrfs/extent_io.c between commit 1c94f854cbb6 ("btrfs: remove unused
variables from extent_io.c") from the btrfs tree and commit 2c30c71bd653
("block: Convert various code to bio_for_each_segment()") from the block
tree.

I fixed it up (thanks Chris for the heads up and resolution - see below)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/btrfs/extent_io.c
index fbe501d3bd01,bcb6f1b780d6..000000000000
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@@ -2375,12 -2332,15 +2375,13 @@@ int end_extent_writepage(struct page *p
   */
  static void end_bio_extent_writepage(struct bio *bio, int err)
  {
- 	struct bio_vec *bvec =3D bio->bi_io_vec + bio->bi_vcnt - 1;
+ 	struct bio_vec *bvec;
 -	struct extent_io_tree *tree;
  	u64 start;
  	u64 end;
+ 	int i;
 =20
- 	do {
+ 	bio_for_each_segment_all(bvec, bio, i) {
  		struct page *page =3D bvec->bv_page;
 -		tree =3D &BTRFS_I(page->mapping->host)->io_tree;
 =20
  		/* We always issue full-page reads, but if some block
  		 * in a page fails to read, blk_update_request() will

--Signature=_Thu__9_Jan_2014_15_01_33_+1100_2hHAKjWccERnguUq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSzh8hAAoJEMDTa8Ir7ZwVerQP/005f65PK99DcBgtuUWDK3DS
p5bf3nXwppSyCDcUAQDjaxb7Ur5z39Xo4LcioPU7iHDUz+xhyNNAb39+DcKu/kI+
jd3CugZHHfNIPW4+BWz6Lwjp6vVDnCa3Mm4I89zb3Igzic9PHdDegVaCSH0Uvua5
qVh9U5KkJPOiZAQ2DjOmxHDA3DQ2Pvlq2UF4U/swhDIBlIKS2H+FPLofpxiOuF0b
MVMxfkkp/3Wt84n0qoQOA/9woShr7Bd4G89EoTMuv9C2Z62iFbEtcKekJHoCCEcn
RbBihKEUWRPReANGP7c9VO0MhtCF3rtnMrixnhc2GkcIIlnYfHnjdPlCImOpXW2w
wYw7ixgRNSYxCycNX1GVbM9KsuGEPwCX/0vYi6KZ215+QfLGwsUPQ/QuIFx/JkXb
pQ9JxvFGCpVL3Pw5pyy94YnbvmpWcK/YBny84IvXg7GD6Cj9J1BaHLXZwRCJhmZo
Gd5RuGtf5sPC/aG5HxAF+VA8dFxAEQnuzOS2lFWq+1PTfOQLKfyWCZYysWoXExL4
fe4ZFpOMjY7UCBPukIg/qjlTyMDA2l7x8NLMZf+fxChEa+9atN4tlu/9nlC3Dx8J
CMHXfLjr4WTW7fbc+UzJC7mNf1CdyS6732TSoTnOhqV++50VDHd/gxSBdNq58NeH
PGVYBgfPVFdFgq/L1AX0
=2/zC
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Jan_2014_15_01_33_+1100_2hHAKjWccERnguUq--
