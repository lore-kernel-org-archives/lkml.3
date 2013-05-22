Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3EVEhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 00:37:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41779 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3EVEhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 00:37:11 -0400
Date: Wed, 22 May 2013 14:37:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vhost tree
Message-Id: <20130522143704.3431658328f8f879f55b0910@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_May_2013_14_37_04_+1000_PBqjhQ6kX08RFmP0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_May_2013_14_37_04_+1000_PBqjhQ6kX08RFmP0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

After merging the vhost tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from arch/powerpc/include/asm/uaccess.h:12:0,
                 from arch/powerpc/lib/checksum_wrappers_64.c:24:
include/asm-generic/uaccess.h: In function 'might_fault':
include/asm-generic/uaccess.h:36:2: error: implicit declaration of function=
 'segment_eq' [-Werror=3Dimplicit-function-declaration]
  if (_might_fault())
  ^
include/asm-generic/uaccess.h:36:2: error: implicit declaration of function=
 'get_fs' [-Werror=3Dimplicit-function-declaration]
include/asm-generic/uaccess.h:29:47: error: 'KERNEL_DS' undeclared (first u=
se in this function)
 #define _might_fault() (!segment_eq(get_fs(), KERNEL_DS) && !in_atomic())
                                               ^
include/asm-generic/uaccess.h:36:6: note: in expansion of macro '_might_fau=
lt'
  if (_might_fault())
      ^

and many, many more.

Caused by commit d198a8acf543 ("kernel: might_fault does not imply
might_sleep").

I have used the version of the vhost tree from next-20130521 for today.

It was unexpected that such patches would turn up in the "vhost" tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__22_May_2013_14_37_04_+1000_PBqjhQ6kX08RFmP0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRnEt0AAoJEECxmPOUX5FEHGkP/RbYjzPhWXdODaEUKhgNl2VR
ZKiW8A3QrFN18dsrhBVEe90f3j3gfyNhSlGR+NfQYXVVOUqiplP2XoKluStcGp7Z
qRliKUTDw2/LFqXzpjzKuTtXgnL9aXA79r/LOt4A8n32v6f3GJikWi/vKWqNoq+/
Sx/GT2Oa4P2vRlhf2s35g6rFGNpzmG3iYYYUQLz+MWJDrS/M/5JgakS97HVrZJED
ZzFjdWRFSb56oXOnrRq3wuzB6npNYMqK2rQ48m+KOVnVRVUxeJXvMkBhvapE1cPX
ztg/55EwyhO8o3IC8/uRtJ6MRMtnv1e0PGyO9UKCSOe9n1M9ATTyKyN5eeIc5HKD
GQrvYtrCdLnWCTTevSuGdDIsmnW21E19as6aHcCDV/Kd1TmJFVu91uhhbjSujUg9
FffTnvSQeWc6W+ln+DkFJ2+Zuhmw55105hf+nf2TJNlBwd7Jt/QVP5sOmWLEmQVk
yiLHGnzxLj9vaA0Ha41gPrNyuSb/+rY+X4XRBKT0HD6yalwnM7o+VsYV4zVXNScn
Bvwjky2Vyf2liLkMRc4uUUqfLEnnVZp6pPayVVGvbTnHqzgGqiuqCuH6IITsK5li
4tcYpSAUFfR8Q2arO4964PZWVEkJZemW73ayjN4rQzM6mzWOQezYlifBEqZmOdiQ
F9SH1epVsijE0D1yp9MQ
=FkEs
-----END PGP SIGNATURE-----

--Signature=_Wed__22_May_2013_14_37_04_+1000_PBqjhQ6kX08RFmP0--
