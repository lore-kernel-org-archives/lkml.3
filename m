Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaBKAbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:31:39 -0500
Received: from mout.gmx.net ([212.227.17.21]:63444 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbaBKAbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:31:35 -0500
Date: Tue, 11 Feb 2014 01:20:12 +0100
From: Christian Engelmayer <cengelma@gmx.at>
To: linux-fsdevel@vger.kernel.org
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] fs: ufs: Remove unused pointer
Message-ID: <20140211012012.6384d52f@spike>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wmW.0hWE/yoa1/bA8bjlhz/"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:9gHsfjZeW+m/bTb8G+MAMV7q4bJveD/vTLzsZUCISb8PNJGBV1S
 7tJe+gFBei2eWbaZPtspLbLCqy+2wHR0w5G8IaN0i586wObO68gNC23LWevf1mzdRvBSSkm
 /KtrQFv7AHyqkLHysoqE+yQWxbLTIfAv9lTNFspg5CWynF5KUVKS+UI0yymtdlM0PPAdTvM
 N04hWRmpime0ZF5K4pWJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wmW.0hWE/yoa1/bA8bjlhz/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This is a cleanup throughout ufs regarding pointers that are set up, but no
longer used in the affected functions. The ubh_get_usb_(first|second|third)
macros found in the changesets all resolve to=20

   static inline void *get_usb_offset(struct ufs_sb_private_info *uspi,
                                      unsigned int offset)
   {
           unsigned int index;

           index =3D offset >> uspi->s_fshift;
           offset &=3D ~uspi->s_fmask;
           return uspi->s_ubh.bh[index]->b_data + offset;
   }

and differ in the passed offset value. get_usb_offset() does not alter the
passed ufs_sb_private_info struct. Those calls can be thus removed safely
where the return value is not further used.

The series applies against v3.14-rc2 and is compile tested.

Christian Engelmayer (3):
  fs: ufs: Remove unused ufs_super_block_first pointer.
  fs: ufs: Remove unused ufs_super_block_second pointer.
  fs: ufs: Remove unused ufs_super_block_third pointer.

 fs/ufs/balloc.c | 12 ------------
 fs/ufs/ialloc.c |  4 ----
 fs/ufs/super.c  |  6 ------
 3 files changed, 22 deletions(-)

--=20
1.8.3.2

--Sig_/wmW.0hWE/yoa1/bA8bjlhz/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS+Wy8AAoJEKssnEpaPQKElkoQALf2w+AqlULhNpPJqxgzgU4d
/zHBkfQXuiSZchtoIT2fc+UtTIzSb+295LMYLdnavZC6GlKHFsSI2y5jyQ0gsgqy
Sx3BZAdz2Xfiu0GQNR2IxKwn9X7ZeDqlNqBohAlAOaMSwGeuYIghHxDWeLTyZHDP
kjbLLCpEciGSMzdMIdll/7EU+p5JaN1lEg2oML+Bw9QeKoZ4hIwgrqKTf5YSRBr5
g9X9LfKauZwNCH5gwIOFOBrVyxvMvVzWGBInnyLWM1ux4CDIAsrSfI3Vm//3rAGI
Ad7oI3y3OGQTz2CoE/3su5ivDIHpfiliR0FnQBX8lzjZeInu5cGTYhRG9Mym4wzr
NQxtpGT6xn8vGFecbJcfvq2Sq8qTXwjdERN2d0OCkS1/QPAZF4UV0kInHfCtqK6w
ObzmP5ej6Jf+Xak3bWFxVN2F5kZM/PCDcrtGKNlXMVCU2j5YWfldbZkjTyVpu/gJ
RfQm+C86lj8eoMlyDv8ddBHKUdlCfCocKU+RVXSUSVaksM4wx1QTCohhUKBNp5FS
V1fPyeEf2gvKolo4LaPRocOJDVTK/RJm3slq2Egf8RRQgi7tSLRZE9rO7t8EW4H2
Ls5vHQd1qauG0hLh9JwWy2VrpzIg8nBJTBl8GmsJOo16Aji7XxAWuvGzjALovPoI
UikIx6rFDyqjPOcq+f9B
=3ZtN
-----END PGP SIGNATURE-----

--Sig_/wmW.0hWE/yoa1/bA8bjlhz/--
