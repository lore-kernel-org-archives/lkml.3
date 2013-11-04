Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3KDDN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:13:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56157 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3KDDN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:13:58 -0500
Date: Mon, 4 Nov 2013 14:13:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20131104141345.b2699b2cc7cdc347c5735c5a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Nov_2013_14_13_45_+1100_ovUmf_5AIKFA31xr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Nov_2013_14_13_45_+1100_ovUmf_5AIKFA31xr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

[I merged the block tree *before* the aio-direct tree today ...]

After merging the block tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/blkdev.h:18:0,
                 from drivers/block/ps3disk.c:22:
drivers/block/ps3disk.c: In function 'ps3disk_scatter_gather':
include/linux/bio.h:239:9: error: incompatible types when assigning to type=
 'struct bio_vec *' from type 'struct bio_vec'
   ((bvl =3D bio_iter_iovec((bio), (iter))), 1);  \
         ^
include/linux/bio.h:243:2: note: in expansion of macro '__bio_for_each_segm=
ent'
  __bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
  ^
include/linux/blkdev.h:748:3: note: in expansion of macro 'bio_for_each_seg=
ment'
   bio_for_each_segment(bvl, _iter.bio, _iter.iter)
   ^
drivers/block/ps3disk.c:102:2: note: in expansion of macro 'rq_for_each_seg=
ment'
  rq_for_each_segment(bvec, req, iter) {
  ^
include/linux/bio.h:239:41: warning: left-hand operand of comma expression =
has no effect [-Wunused-value]
   ((bvl =3D bio_iter_iovec((bio), (iter))), 1);  \
                                         ^
include/linux/bio.h:243:2: note: in expansion of macro '__bio_for_each_segm=
ent'
  __bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
  ^
include/linux/blkdev.h:748:3: note: in expansion of macro 'bio_for_each_seg=
ment'
   bio_for_each_segment(bvl, _iter.bio, _iter.iter)
   ^
drivers/block/ps3disk.c:102:2: note: in expansion of macro 'rq_for_each_seg=
ment'
  rq_for_each_segment(bvec, req, iter) {
  ^
include/linux/bio.h:240:45: error: request for member 'bv_len' in something=
 not a structure or union
       bio_advance_iter((bio), &(iter), (bvl).bv_len))
                                             ^
include/linux/bio.h:243:2: note: in expansion of macro '__bio_for_each_segm=
ent'
  __bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
  ^
include/linux/blkdev.h:748:3: note: in expansion of macro 'bio_for_each_seg=
ment'
   bio_for_each_segment(bvl, _iter.bio, _iter.iter)
   ^
drivers/block/ps3disk.c:102:2: note: in expansion of macro 'rq_for_each_seg=
ment'
  rq_for_each_segment(bvec, req, iter) {
  ^

I am not quite sure which commit caused this (maybe ed2d2f9a8265 ("block:
Abstract out bvec iterator")?).  I have used the block tree from
next-20131031 again for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Nov_2013_14_13_45_+1100_ovUmf_5AIKFA31xr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSdxDuAAoJEMDTa8Ir7ZwVL+QP/2sDT/b4yyta3syAHo7x7VTC
AptFX0cvvO4ztdMe2t+RXRaybTiLPl/Gh9k0uzLwV0dtk/bsyoudSgShcOyZUfPa
OGEaWZPRA/1Z5dxlyy9HKAT2keJDCPxjxL8kaHehfwytrngtMMcQUltO2f3HDjOk
aegUjiZx8+p2vnU9aWabZZ7Vc4pNVxrCHN6uPBm/u8N2rSubA/En4EXCW5hqEYau
MyhFdGcem209ebGP3HoMl9BBRRaYF4LoFLXlhgp/5dH5Qop6UP7n3F8c5rhkmnwM
AcHHasBlKePeoPcgDftg8Yw+NZjiERXDdD5HzdZEBmlIBSCIdESc6V98/eQmWAwF
CPiwjd1rlKkiOllQM9mfDt2zIZtF8BAiX61D10HOZxEXZZM4iuny4VlZ/OcKu2R9
UKN3DRzYzHpdRtvmTAjjXrOmzObXuSv+7+Jq2IdKJAFW49ELdQfBBn0rLDNr98gj
kCxdQdQ9qqtumQCA54k59/Qx/smB09BlGsd1pYP+NXPOmP1KylN6yjvs31UMbF+h
rx3KrvF9Fqkm4Hoh8rVTCpJN6b6gMOKXatrGagm6C6yM+kwW3ps0A2bNF55YrkCu
xhI/m31I+BEUaLuTpkxA7QgZScRempxh1iMwR77zUVPIhnv5IcMgz/A9EAZF3lUo
4MN6fsbOQ40V65jXHa+Y
=K/YD
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Nov_2013_14_13_45_+1100_ovUmf_5AIKFA31xr--
