Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3GWEGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 00:06:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34961 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3GWEGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 00:06:36 -0400
Date: Tue, 23 Jul 2013 14:06:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (sound-asoc
 tree related)
Message-Id: <20130723140625.ae4caa1afaf7d3402baa8252@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__23_Jul_2013_14_06_25_+1000_R/BLTdjFldyDDhTA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Jul_2013_14_06_25_+1000_R/BLTdjFldyDDhTA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

sound/soc/mxs/mxs-saif.c: In function 'mxs_saif_mclk_init':
sound/soc/mxs/mxs-saif.c:668:2: error: implicit declaration of function 'cl=
k_register_divider' [-Werror=3Dimplicit-function-declaration]
  clk =3D clk_register_divider(&pdev->dev, "mxs_saif_mclk",
  ^
sound/soc/mxs/mxs-saif.c:669:8: error: implicit declaration of function '__=
clk_get_name' [-Werror=3Dimplicit-function-declaration]
        __clk_get_name(saif->clk), 0,
        ^
sound/soc/mxs/mxs-saif.c:668:6: warning: assignment makes pointer from inte=
ger without a cast [enabled by default]
  clk =3D clk_register_divider(&pdev->dev, "mxs_saif_mclk",
      ^
sound/soc/mxs/mxs-saif.c:681:2: error: implicit declaration of function 'of=
_clk_add_provider' [-Werror=3Dimplicit-function-declaration]
  ret =3D of_clk_add_provider(np, of_clk_src_simple_get, clk);
  ^
sound/soc/mxs/mxs-saif.c:681:32: error: 'of_clk_src_simple_get' undeclared =
(first use in this function)
  ret =3D of_clk_add_provider(np, of_clk_src_simple_get, clk);
                                ^
sound/soc/mxs/mxs-saif.c:681:32: note: each undeclared identifier is report=
ed only once for each function it appears in

Probably caused (or at least exposed) by commit 8ccbc3ebe9a7 ("ASoC: mxs:
Enable COMPILE_TEST builds").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__23_Jul_2013_14_06_25_+1000_R/BLTdjFldyDDhTA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR7gFGAAoJEECxmPOUX5FESYIP/idykaYh9d+ky0mFjPQemwfl
GEJ/Kt5+nr2cryqaLaCAwgv4sMVe4F/3jRDjuhqoqH/ESB9FBASbO6+LJ1lcGJhR
xcFIEeQxH+gawJyvPj2mnnVa8LKdV0b30sD19GB8hKK0bY0uUurvtlwUaaA9h6g5
DfUgYbAUnZir1puvPWHnFai/gH58VwlFbpX4RlNlyNV0CXjizopL1lfBrAijeBZM
IXaOUv+7HLoCBrMDPoNIuGE/nSKAbUILk93M1Crr7JoMGeh/LzdcMcCY02OqQtgX
aHwe+VRzkS9evmbBcAbBAb2TlbDUZCwVDjMJR9qzruBRKzGL7RTI9TMGEWm+GwAd
2Uh7gq2e2HSeR7NpyfqQmp2sxKfr1FvYqXz1mDLR9YkXSoM+fa8shDw9tnstTxIY
PwnCCq8W2+7Jal7dyiYioULbaWWdz2fXH7NAzPH8GiHmg3OhFQBa5aht3S71EBoW
sko1dVMrkb0k7ja7p3lxp8VUIgmZn97h3+fdquGd04WjSYrQu21g377n3D9XwXpJ
5DhQgdix2X8O7+wf12nKT+vlPJeHbMoWKZ+9Gqdpp0dXmGg/YJmZIgzQDW9bx/rC
65pbzHp1qbl8jo76vOOREqMgcHUNmmv8fdVMBOqAqfpo1iAZNy9hERM9AxmmQm+L
g01MdhRx7OwmEJlRBXlE
=Q2Xu
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Jul_2013_14_06_25_+1000_R/BLTdjFldyDDhTA--
