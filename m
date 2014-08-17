Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaHQUly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 16:41:54 -0400
Received: from ozlabs.org ([103.22.144.67]:36285 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaHQUlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 16:41:53 -0400
Date: Mon, 18 Aug 2014 06:41:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guodong Xu <guodong.xu@linaro.org>
Subject: linux-next: build failure after merge of the regulator tree
Message-ID: <20140818064143.37bd4743@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Ij2SYyJw9Ag=p+pmA+EF9ko"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ij2SYyJw9Ag=p+pmA+EF9ko
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the regulator tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/regulator/mc13892-regulator.c: In function 'mc13892_regulator_probe=
':
drivers/regulator/mc13892-regulator.c:586:3: error: assignment of member 's=
et_mode' in read-only object
   =3D mc13892_vcam_set_mode;
   ^
drivers/regulator/mc13892-regulator.c:588:3: error: assignment of member 'g=
et_mode' in read-only object
   =3D mc13892_vcam_get_mode;
   ^

Caused by commit 272e2315fac3 ("regulator: core: add const qualifier to
ops in struct regulator_desc").

I have used the regulator tree from next-20140815 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Ij2SYyJw9Ag=p+pmA+EF9ko
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT8ROMAAoJEMDTa8Ir7ZwV76gP/3h90zs4R51iGI5ZLxaGRqte
vMgWMM2RbpkoYX5ykrHi9JGq87MNq1j94Exban1n98qiVNJoEeg/16yBlsl2Nuhu
x1L45/hmIugHUCx5Mi2cA3CwElOVQk6oLDy5JjPDUTyNH1C2JjhusxeoFnWY5/t0
AwQoiU+GNVB9lE8DR+wTHlBz1WstaLfsE/SPRyZJixSNEhALkrJUod7ziFBAn1Xy
BjCsIw8sdTffofkLICT/HVMqIN37nbbjQ9VA/DH88MCrBB9gOexlCAmg/o/S2I5q
U8PvlG/444qDIa2LE/lk8cKRCvaAWConVcjzIokQZYv1QgUyK3Bz6SQ2Kk2od9eu
gM75/YPqYJsVrftihYON4d3iH4eaY1D6WNbamPbFgxOQ6DxYjNkexttaxez7unfi
3sglHGEY7oudHHPTkAsRzTRN8/50uSRHnaNEmvwtExuhWC5LyoyDhKpuAsHxZ6NP
gjyepFkQtLearqEWTdnOmQKfDaRvsMsAByUuL4NUNUy+RhfGSzpoB2r6W9Xz2G0S
+dXj8cVwcFWqkYXegGZhRatl5UJuJYlWvywnC+9xwN2ZkScfZrxGHsvkcbuqQxCT
pi8g2+jKpELeV1Dp3LsrzbuJ9DThMG471bQzCgBZjO6KHJBsVdb63kkk2AtfnWMe
JDllRqdOMwt91GwVLby+
=8GQn
-----END PGP SIGNATURE-----

--Sig_/Ij2SYyJw9Ag=p+pmA+EF9ko--
