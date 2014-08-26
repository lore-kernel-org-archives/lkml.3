Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbaHZGPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:15:05 -0400
Received: from ozlabs.org ([103.22.144.67]:43778 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757160AbaHZGPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:15:03 -0400
Date: Tue, 26 Aug 2014 16:14:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>
Subject: linux-next: build warnings after merge of the crypto tree
Message-ID: <20140826161456.7ad100e3@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mScB=.PQ7pmFnaV38igKK39"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mScB=.PQ7pmFnaV38igKK39
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

After merging the crypto tree, today's linux-next build (powerpc
ppc44x_defconfig, i386 defconfig and sparc defconfig) produced these
warnings:

In file included from crypto/testmgr.c:30:0:
include/crypto/drbg.h: In function 'drbg_max_addtl':
include/crypto/drbg.h:157:2: warning: left shift count >=3D width of type
  return (1UL<<35);
  ^
include/crypto/drbg.h: In function 'drbg_max_requests':
include/crypto/drbg.h:163:2: warning: left shift count >=3D width of type
  return (1UL<<48);
  ^

Introduced by commit 05c81ccd9087 ("crypto: drbg - remove configuration
of fixed values").  These are all 32 bit builds.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/mScB=.PQ7pmFnaV38igKK39
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/CXkAAoJEMDTa8Ir7ZwVG50P/0RaeoFZSGZXtzsZ7u4Ke368
ksvyrc0Z0BsOb844XONL94PML3+4B8FifiOoughQkaLhC4wBMTHfbNjGySrIGoRh
V8YgZ0+FfLsF8e5D8xOfzJqJlfPcscoYYPENnxbvmBkHHZDJlpBN9MemFap4lFtN
OuLUwga/1gBxVkkCx6/uSt/a+ZLZFANCwArfHl7Kwszl/1hnPYJjj1aG9P+Fgqab
KLEDjcQfmepttan6OHa/aEtnVZc0dmS+Gp6vXdUz5Ut0gxYBMXy9LNNcdGX3B51f
CfxXpqESAlizNnHSwaRjfjmlBGT2f9TZbqphS+EY9VTYbcTGLi6JWYIvqfH4Wxy0
mf6SpBIbP+MplLgnIHHFM27aZcmHusjhtN1u1sOnXwNX8RPgJN8s2h4iAMB3lVZA
kPo+wEQykoFAbF8F2nPBrmtFdV56V8pQbQmc5hWNOQKPU5+40HpU3pF2MFKDg19P
Sb3gf9Ih1UVXPKWpRC+fmVNXbBkheJwfzY17JWBo2fJzlqVXLb/PIphbwkDfc8bM
Gc7s49p5+1SiWSJ5/P9HjJrkWc+IJq+eJG2vVWgTO6kLwLHG47lMvjTUW1z74y27
cdNPcShTlU2rqeOBjY81DwJmzwRIlOq/GfwZ6ZEm0Xo/tgYqR2CKWdPf5jl18BLa
nEmMgWZAouwpWZc5CZY4
=kJUA
-----END PGP SIGNATURE-----

--Sig_/mScB=.PQ7pmFnaV38igKK39--
