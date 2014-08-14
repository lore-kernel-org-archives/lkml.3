Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaHNA2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:28:03 -0400
Received: from ozlabs.org ([103.22.144.67]:53099 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbaHNA2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:28:01 -0400
Date: Thu, 14 Aug 2014 10:27:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: problem importing the akpm-current tree
Message-ID: <20140814102754.29ecc247@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/WEHDyBpc_iZeNH2ld3PU2BX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WEHDyBpc_iZeNH2ld3PU2BX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

While importing mmotm 2014-08-13-14-29, I get the following:

$ git am --patch-format=3Dmbox ../mmotm/broken-out/drivers-gpu-drm-nouveau-=
fix-build.patch
Applying: drivers/gpu/drm/nouveau: fix build
error: patch failed: drivers/gpu/drm/nouveau/core/include/nvif/unpack.h:1
error: drivers/gpu/drm/nouveau/core/include/nvif/unpack.h: patch does not a=
pply
Patch failed at 0001 drivers/gpu/drm/nouveau: fix build

the problem is that the files altered by that patch are symlinks in the
git tree and the patch tries to turn them into real files with #includes
of the symlink target.

I skipped the patch and I guess your problem arose from applying a git
patch to a non git tree which created real files whose contents were
just the symlink target names.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/WEHDyBpc_iZeNH2ld3PU2BX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT7AKPAAoJEMDTa8Ir7ZwV1BYP/36PI+oLxx1sovXLMivUte09
bmGpQPyttxA8e+OowCdljVaJDZsr/BuzRF9BdULadILB0dg0bUwabPvKqT9DnFcG
W1P6NZ7sw3kicUHli0+UYrc8b/p0zT5zibSkFbwi8DM8+NkYX8SwX/yvBa010moK
1qujR4LA+nGnOqo+W7uHoEArBGkHaBsTBpmqKB8rQ8oaEM+pi4Jrk6awgNsjYQvy
E43hjiycmUsYNsqpznuk1nuu1Fu/LN1I83Rfef0za4UPBoWBrPXhoFqB4C7uJRp2
D8P8F43S3OV5+Frw+RtGqZ4agIAIRtQINT0uSEnLCTisbiXeN8927ZZ/56spTux6
LWxStbbYS61mGJTXZw6UUV1g0MSHPjK8EfBa7VpU8k1brbog1yWgiAxJ5JSiJPna
aFNZ5//w+5WKsR8XX+fIbvBcJ16Ef81d3Pk1xrSkJocHPxXPxGhhN/dT3eyngMVK
uSNffzPVBV0d3a9X8EzTOx9V7M1XNI0VPrr11NOvvNrU/nVVU72mGdQcP5JrsXHb
iipSS22WyGalWavPgY8fd2hC9UJFtoZCZl1+xoBXbRZ1qUaqsokzdJ45X4oUt0V0
uYkLRXmsGhRut5+DMBtGI2U83HV/Q+AAXExMFw8Bt3kIBXWNNrs02RjyVinKytI1
vi5WPlk/7iDqdhhGVA+t
=LGvV
-----END PGP SIGNATURE-----

--Sig_/WEHDyBpc_iZeNH2ld3PU2BX--
