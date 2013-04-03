Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab3DCAWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 20:22:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39247 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab3DCAWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 20:22:44 -0400
Date: Wed, 3 Apr 2013 11:22:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20130403112235.0ec96e6e03389a791ad6b959@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Apr_2013_11_22_35_+1100_lIhM_06fs=_WQOMw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Apr_2013_11_22_35_+1100_lIhM_06fs=_WQOMw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from arch/powerpc/oprofile/../../../drivers/oprofile/timer=
_int.c:14:0:
include/linux/profile.h: In function 'create_prof_cpu_mask':
include/linux/profile.h:34:1: error: empty declaration [-Werror]
include/linux/profile.h:41:12: error: storage class specified for parameter=
 'prof_on'
include/linux/profile.h:41:12: error: section attribute not allowed for 'pr=
of_on'
include/linux/profile.h:57:1: error: expected '=3D', ',', ';', 'asm' or '__=
attribute__' before '{' token
include/linux/profile.h:65:1: error: empty declaration [-Werror]
include/linux/profile.h:66:1: error: empty declaration [-Werror]
include/linux/profile.h:85:1: error: empty declaration [-Werror]

And many, many more.

Caused by commit 1f4fbcb8700c ("create_proc_cpu_mask() doesn't need an
argument...").  Please build test this stuff *before* publishing it.  :-(

I have used the vfs tree from next-20130328 again fro today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Apr_2013_11_22_35_+1100_lIhM_06fs=_WQOMw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRW3ZLAAoJEECxmPOUX5FESf8P+wSCMgrQ5p3gZq8VwqtKdGMx
oKKLZrwR7Lm05rNU92bK+hGtT/v78eMmrRHMLb6HXiLOz+Z4zwmn/GilQGD3/R92
Tp8QjAA4MTND/PIz2/H/Kw89uoYmIOCGKUZxxg8N3yWcp13rqa4/KWXIUrZX0eMP
eGydBxWlvM7b2gXkansru7+WeETmA0Lv62Q45JuOwgj7PQq4VLB93PH1bDqCvih+
cwk0OCZggK5Qnz1AUcuoFUh3YNshtnxyrDFUh4nv/u20c1t1Kw+vYJ1OGHaj+yCf
vOcJ0xfq8hkv6CWqltfAhXFysI1cYkNy/8XuRG4HD/7VRsazIyvD0OMOhhCiE8Ju
WqZ8Sg44pnXoQsTvf6TRcoihXWT8nir03RdYFtBZXUeuXUUHOMzMvC3Hrs+S1xmb
InsEbZCM7X2DQP/q8VVqgOrsMJQDAFpNVpJYfRscpHyjdCHnId+ow27CZxX3QDIy
M5fjmddv1vQggXaI2ShVSQPLFdXge2t5yVR3TOKsZ8P42bxaTqvDh8OcALRfdBg/
i10V9p66sDpWx5B+k/Z3kMlvSXFbN9nIowZyjMiPD26EqfPcXZGgoFfHTt+ySIco
JzxZ7jTOIFuKYN5tZazhhnVuHhPbv/Kr0kEzAa21kB9m6+vLEOzX4OTqxNCoGIhH
A4TMao+Qt2E/6KsG9fVB
=yY4F
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Apr_2013_11_22_35_+1100_lIhM_06fs=_WQOMw--
