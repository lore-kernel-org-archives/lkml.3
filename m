Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3CaNZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 09:25:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab3CaNZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 09:25:39 -0400
Date: Sun, 31 Mar 2013 10:25:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Mar 28
Message-ID: <20130331102527.76acb553@redhat.com>
In-Reply-To: <20130328162804.0676c97abb26d356ad8e50a6@canb.auug.org.au>
References: <20130328162804.0676c97abb26d356ad8e50a6@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lgqkoJkWPwUtpMNTmEyNEmx"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lgqkoJkWPwUtpMNTmEyNEmx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

Em Thu, 28 Mar 2013 16:28:04 +1100
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi all,
>=20
> The next linux-next release will be on Tuesday April 2.
>=20
> Changes since 20130327:
>=20
> The vl4-dvb tree still had its build failure for which I disabled a
> staging driver.

Sorry for a late fix. Hans was/is on vacations, and didn't noticed about
that breakage, as he was/is without access to his email at work. A proper
fix for it were added on my tree:

commit 9e7664e0827528701074875eef872f2be1dfaab8
Author: Hans Verkuil <hverkuil@xs4all.nl>
Date:   Fri Mar 29 07:20:36 2013 -0300

    [media] solo6x10: The size of the thresholds ioctls was too large
   =20
    On powerpc the maximum size for the ioctl argument is 8191, and it was
    8192. However, the 64x64 array of threshold values is more than is actu=
ally
    needed in practice for PAL and NTSC formats. A 45x45 array will do just=
 fine.
    So change the size accordingly to fix this problem.
   =20
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

So, you should be able to drop the patch that disables solo6x10 compilation
on the next linux-next.

Regards,
Mauro

--Sig_/lgqkoJkWPwUtpMNTmEyNEmx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRWDlHAAoJEGO08Bl/PELnfWMP/3LfZxj+0RTsA+eyqb9JG9NL
wM8EbZC9GA80qJzVMzF5hqNoXj9JtP3ZlrZ7Kj0mYU7Sjj46aGMnLUZyvzCpn3e7
g5aS4dNXBjQJoEX5yq8zkfrOGLEgj5hd2G2uSsCXI9lDiz/8V7kmpJIvcW/Pe7bg
+Rz2x2eFDLaz8KrlNROKJU6mbNC2f45o/aKLpg4AEqDlTjPzS1iUGPs2Wp6ASDdO
nqnCehUz6JleHbbrhdE3Mj+kCgDIXW7Vpznqs/w2Z827eVsUZG+wGcxnoiqsKWx0
FLOe7DMkaaU5Q1uZMITy6eQe4tUXrPOHx4zvF4M+kwVEzpR6PHmJOpsZkZkv9uyG
pBFNWHC0hcTtUMtXqgbxmh4IgNqC1WEgK+ltKNe+fxxqLbP2xS8cu12bTCgmFnnn
DS+d9IKT/FQE/EFfNU7IWYBLKjjctCzP92C26aa1oTVLY6pDPgtazCS95ULe2Isu
qoXwCHUhbWeWvzqyy1f7/ktDdM8zMjyZuOOu4KgijmoPIap+dgJlfe/P/zRRlKQg
msPCqfvljKbtwIj3xSWbAhkyT+p0NkOKl4AvroAuRUKvc1iZ0VNNLtwPSpMe6GOV
sDY0ZzyDYbGUZRZVoznb90Mvo/g3vvqqwHRBnjScl4Q8YGsFChH8Rgv3rJpgSu9k
Ld2dWTd+jw2+FMwBwC4V
=FY9e
-----END PGP SIGNATURE-----

--Sig_/lgqkoJkWPwUtpMNTmEyNEmx--
