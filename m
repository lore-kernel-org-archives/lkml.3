Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbbA0IMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:12:51 -0500
Received: from ozlabs.org ([103.22.144.67]:54459 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220AbbA0IMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:12:49 -0500
Date: Tue, 27 Jan 2015 19:12:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: linux-next: build warnings after merge of the akpm-current tree
Message-ID: <20150127191243.6fbbf2f6@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/SnQabmRYHWQpMoo/tHcEZa+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SnQabmRYHWQpMoo/tHcEZa+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

In file included from mm/slab_common.c:26:0:
mm/slab_common.c: In function 'kmem_cache_destroy':
mm/slab.h:259:30: warning: right-hand operand of comma expression has no ef=
fect [-Wunused-value]
  for (iter =3D NULL, tmp =3D NULL, (root); 0; )
                              ^
mm/slab_common.c:620:2: note: in expansion of macro 'for_each_memcg_cache_s=
afe'
  for_each_memcg_cache_safe(c, c2, s) {
  ^
mm/slab_common.c: In function 'memcg_accumulate_slabinfo':
mm/slab.h:257:18: warning: right-hand operand of comma expression has no ef=
fect [-Wunused-value]
  for (iter =3D NULL, (root); 0; )
                  ^
mm/slab_common.c:959:2: note: in expansion of macro 'for_each_memcg_cache'
  for_each_memcg_cache(c, s) {
  ^
In file included from mm/slub.c:19:0:
mm/slub.c: In function '__kmem_cache_alias':
mm/slab.h:257:18: warning: right-hand operand of comma expression has no ef=
fect [-Wunused-value]
  for (iter =3D NULL, (root); 0; )
                  ^
mm/slub.c:3652:3: note: in expansion of macro 'for_each_memcg_cache'
   for_each_memcg_cache(c, s) {
   ^

Introduced by commit 3019931a000b ("slab: link memcg caches of the same
kind into a list").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/SnQabmRYHWQpMoo/tHcEZa+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUx0iAAAoJEMDTa8Ir7ZwV+4MP/3MXl5QsTxaEIxt4GPuh4b1T
RcIzG1fQ7sj92q43AUaCj7X33vABblE52ldAXkpsoxoO34r0Bk3VcwRTxSu7daJ5
RWs/UrPf7wltb6t1V7AonwRgyrZs8DNB01Q2Q13UT6StJlEYK3PVYIXHuQAeJrtX
asFfsoM5fR15+CDVVcCoD1KG4Ji31J16XQ+AkOPmqPl5KgvvvyEc5qReTJD9cp9v
rEyqe55rDWge8OXf7ngP5dwGuGIEn79TVlLdv9y5eGUMX7y3dm7J46DRzBq4NPtn
Ste9JGfPO/z+VlHrk+KxjQB0OMlxaD/Zs0vozSQP+dsnZExZhlNt4TJBYn/3cRlR
MvApJWkZBDEHVTBNqCVifAM736zYiQFldjXNFy2r3J7quO4YxktYSlymOnOIP/Bf
lvRGGjWuIk1CoaXLt4rezSyVxZgYw3YU/ocxFj/48OSQZH38GUgCcvZ7nqMIiMvm
U2XYDud+I3nzlHvqVg/T+XE/FO0afIShB6yD827FTpTAUQXzp1o/prlm21zIF1H6
RGxjk5MfSPcm8aNGP0RTAwkPyhOSGfS/oCgvgtsFc4TCmZAS5cVQwOXNSKyri52W
n5vAo0DE1HYATLTKy03o4QoHlHJj8+xLN5OuPuX6ODxphE74fCS5SLYhUHohacaI
rCafsn+O1Rkfeo6Q2Yny
=ewZT
-----END PGP SIGNATURE-----

--Sig_/SnQabmRYHWQpMoo/tHcEZa+--
