Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaBKAca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:32:30 -0500
Received: from mout.gmx.net ([212.227.17.22]:63485 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbaBKAbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:31:36 -0500
Date: Tue, 11 Feb 2014 01:24:14 +0100
From: Christian Engelmayer <cengelma@gmx.at>
To: linux-fsdevel@vger.kernel.org
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] fs: ufs: Remove unused ufs_super_block_third pointer
Message-ID: <20140211012414.29e097e6@spike>
In-Reply-To: <20140211012012.6384d52f@spike>
References: <20140211012012.6384d52f@spike>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/X7e.dBQorpl9=9f=fXrE8_A"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:mGTpZtrYWKIBRXC0k+F1WEpTn5xoQKHPGeeXCcv012gV/t+bIPt
 pPEkaKF96oEmVlAF/eZTXHVmC3GiC99klryiRsF+8HqrVhKFYR/uQwfGAVj6UDP7Edc3GL/
 dMt77Cr9S8jBIyILcXB3ZuS3TPr03G7mEfU2Nm+EpeZ+vy/dgIPLLQKhh3tKBOj594zS5rf
 WQwnNP2yQaJMjcqcakS+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/X7e.dBQorpl9=9f=fXrE8_A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Pointer 'usb3' to struct ufs_super_block_third acquired via
ubh_get_usb_third() is never used in function ufs_read_cylinder_structures(=
).
Thus remove it.

Detected by Coverity: CID 139939.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 fs/ufs/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 53ce1af..deae93e 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -524,11 +524,9 @@ static int ufs_read_cylinder_structures(struct super_b=
lock *sb)
 	struct ufs_buffer_head * ubh;
 	unsigned char * base, * space;
 	unsigned size, blks, i;
-	struct ufs_super_block_third *usb3;
=20
 	UFSD("ENTER\n");
=20
-	usb3 =3D ubh_get_usb_third(uspi);
 	/*
 	 * Read cs structures from (usually) first data block
 	 * on the device.=20
--=20
1.8.3.2

--Sig_/X7e.dBQorpl9=9f=fXrE8_A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS+W2uAAoJEKssnEpaPQKE9vsQAMaRaBjqTzLOVbQ1ibOpIocD
x+ATS+/XXiS3F3cNARg5jUd4uqXTD2PyLzhWNN4mk7gU4KhsUczUf3ZC5XRUXdCh
cOdStDtCGMT0+0l0DVGqw7KEaaTW9cYEoJ3fUCMSyU6rXRmoglczRyd+ZkNnmxSW
KiLWFo+wuRGO2RVya/M72h6QrWd16BMcXP09pJFVuSV7H/Eu0Fq26ck4EvgjVozm
CkyOf9QqrP95TJuKFL2k33AC6xdztt+ZTBlhmnBpaqROBbzSceMOK5EPpoBlxyIm
nfQnsjXMc2AtgHbL9119Qu3AIUAt/kyvnRBKLN96qVNZqrhaKDYgecXps4ry86a6
YIMaCpVw3mFnM10iASlr1tINnyr9w28+LciP8q4x3lxA+cCqzRI6ymCo7drtkCSf
yVJpWxNk1/RsR64gsik4eOiSXukV9JMwGXNvh6DV2wECYGcr29+8cLrFf4pIMDdh
5tUISA8RoxM/OghcNSXMEI4vC7ChNkawK40Ra+pYII4apYQU9dZUoDD6NDEJkL1p
Bv+Mvb9cI46qQOWfmfV28PGuAnBbM3RKB4bnAodl3L3wzTzq011OKVhTrzFB3BRe
jaAAJ8wGVnyHjdtkTXUNg1rXmSJ4LqiJLqmmNj5CBfwTU0YeykPKylx/w5VIhI27
kfVq6YHiXbufmGC6E7jx
=LTR0
-----END PGP SIGNATURE-----

--Sig_/X7e.dBQorpl9=9f=fXrE8_A--
