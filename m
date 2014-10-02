Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaJBBhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 21:37:51 -0400
Received: from ozlabs.org ([103.22.144.67]:56078 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaJBBht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 21:37:49 -0400
Date: Thu, 2 Oct 2014 11:37:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: linux-next: build failure after merge of the arm-soc tree
Message-ID: <20141002113742.2b521495@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ChhR2Qe+0/rSLYqZaEZBDhR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ChhR2Qe+0/rSLYqZaEZBDhR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the arm-soc tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

arch/arm/boot/dts/exynos5250-snow.dts:13:46: fatal error: dt-bindings/clock=
/maxim,max77686.h: No such file or directory
 #include <dt-bindings/clock/maxim,max77686.h>
                                              ^

Caused by commit c04c92ed5614 ("ARM: dts: Add rtc_src clk for s3c-rtc
on exynos5250-snow").

Presumably there is some dependency on some tree that someone has
forgotten to merge :-(

I reverted that commit for today.

Which then got to:

/scratch/sfr/next/arch/arm/boot/dts/exynos5420-peach-pit.dts:15:46: fatal e=
rror: dt-bindings/clock/maxim,max77802.h: No such file or directory
 #include <dt-bindings/clock/maxim,max77802.h>
                                              ^
compilation terminated.
/scratch/sfr/next/arch/arm/boot/dts/exynos5800-peach-pi.dts:15:46: fatal er=
ror: dt-bindings/clock/maxim,max77802.h: No such file or directory
 #include <dt-bindings/clock/maxim,max77802.h>
                                              ^
compilation terminated.
Error: /scratch/sfr/next/arch/arm/boot/dts/hisi-x5hd2.dtsi:417.21-22 syntax=
 error
FATAL ERROR: Unable to parse input tree

Caused by 8bd43b6e6df7 ("ARM: dts: Add rtc_src clk for s3c-rtc on
exynos Peach boards").

I give up ... please test your trees better ...

I have used the arm-soc tree form next-20141001 for today (which still
needs 5 reverts to get it to build :-().
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ChhR2Qe+0/rSLYqZaEZBDhR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJULKxrAAoJEMDTa8Ir7ZwV4lUP/01egfn0hUE+tqutQrUyqb2r
CYLcJnesfyE0GpUMBLJJFRppEuPi7cYw8dnc9W69g1z0r3D64Op0YPT7B6X59K59
+nVJ4hYAHFr2/4g0KEBokWIKMqvJFdZKwaEr9YfqGkd6eGgQhYX/rpf4wRNoeurb
ryHepYJ9ylC1A6ePL3rxhcwbVkVgdzkbe5py70FNrVEmHW5MuEUKn97bTGkoFxyS
25hwz5exDKTLxxqcESTYaOlP/7uoCBEcrvTOnaQsT1Y8hbaC6TQjAxw8VWZUNI+n
r/DBAT53CojFkaDuqkDf27j1iMKyV86VSNmD0b178g1YFe6zMLkEGfB4jZZabgom
RO84Sn4HVBmvk0+HfxqjjU+b1WzfeF2k0umPHVoJBh95Zqcp3GFUF5EPI1qP265L
KLUsvOujcn/2JaWW12AfMZUN4OF3SsDhBocRPjoYymUlweR4k+dVGmliUmrKLQ2Z
N7jMaIWz/m7EXX1IFX7476rh/NtZpCBGxxMVc0+3grNSs3063a/MGANUQVWtflJY
XxTyE/W9F4n7LcsY6mL7nUNtixsA88kZrv2foxJJ4vA5qmCCsLgUlGyNF/8iwUbt
AHP7A7d1EVGnJXeHLdDd/dR4lOrbdNO5ixaoieT2GbKSliHCJQx8s0LQmS4cVOCG
PdEU+nzVX26lgcJ5UNGm
=dD66
-----END PGP SIGNATURE-----

--Sig_/ChhR2Qe+0/rSLYqZaEZBDhR--
