Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbbAOAit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 19:38:49 -0500
Received: from ozlabs.org ([103.22.144.67]:46371 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbbAOAis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 19:38:48 -0500
Date: Thu, 15 Jan 2015 11:38:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm+renesas@opensource.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Peter Robinson <pbrobinson@gmail.com>
Subject: linux-next: manual merge of the renesas tree with the arm-soc tree
Message-ID: <20150115113840.71ab0a39@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ujG0E8d1HjHoQzVHeWDX=ej"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ujG0E8d1HjHoQzVHeWDX=ej
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
arch/arm/boot/dts/Makefile between commit cb612390e546 ("ARM: dts: Only
build dtb if associated Arch and/or SoC is enabled") from the arm-soc
tree and commits 9ccba8abd0a7 ("ARM: shmobile: kzm9g: Build DTS for
Multiplatform") and 93c9f0228a3d ("ARM: shmobile: kzm9g-reference:
Remove board C code and DT file") from the renesas tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/Makefile
index 95fed8145ac9,be6e2607da88..000000000000
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@@ -466,10 -411,8 +466,9 @@@ dtb-$(CONFIG_ARCH_SHMOBILE_LEGACY) +=3D=20
  	r8a7778-bockw-reference.dtb \
  	r8a7779-marzen.dtb \
  	sh7372-mackerel.dtb \
- 	sh73a0-kzm9g.dtb \
- 	sh73a0-kzm9g-reference.dtb
+ 	sh73a0-kzm9g.dtb
 -dtb-$(CONFIG_ARCH_SHMOBILE_MULTI) +=3D emev2-kzm9d.dtb \
 +dtb-$(CONFIG_ARCH_SHMOBILE_MULTI) +=3D \
 +	emev2-kzm9d.dtb \
  	r7s72100-genmai.dtb \
  	r8a73a4-ape6evm.dtb \
  	r8a7740-armadillo800eva.dtb \
@@@ -477,9 -420,9 +476,10 @@@
  	r8a7790-lager.dtb \
  	r8a7791-henninger.dtb \
  	r8a7791-koelsch.dtb \
- 	r8a7794-alt.dtb
+ 	r8a7794-alt.dtb \
+ 	sh73a0-kzm9g.dtb
 -dtb-$(CONFIG_ARCH_SOCFPGA) +=3D socfpga_arria5_socdk.dtb \
 +dtb-$(CONFIG_ARCH_SOCFPGA) +=3D \
 +	socfpga_arria5_socdk.dtb \
  	socfpga_arria10_socdk.dtb \
  	socfpga_cyclone5_socdk.dtb \
  	socfpga_cyclone5_sockit.dtb \

--Sig_/ujG0E8d1HjHoQzVHeWDX=ej
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUtwwUAAoJEMDTa8Ir7ZwVWe0P/jut2SVKHuPkakDyZSvnStxU
JxbI2B2UKF71ogfeX7vU4xLWb6Oa1o2iX7Fi+AMxn0CChtc6Pl3Zv+xQc1SuyzeY
TEKE6Q+gNGW54Lpk7jL/9xuNtRu1iRK63+LZzIm8SZUzPzzwT4tJpZR0Okk1DnOT
K4m0qza8bKs5ys4PS3GG+ruIP0o0AMoSbWVRLHo85V3I6dWFWMHhfRKXPTTihwcU
J0IN1yxowoqjAtAC8Xxk9mN/QpVuXEwIci6LKopf6Otrxs00AxXFl91lVmUEupwZ
8BVe83ukndqn91o3o14BbjU/qdCcAO8okDut0E0lX2DnTn0Xb4DiGlIKoxjpwR1R
uaUmLn+2UVRVp3Jl+cHLRnyWS9XTaHT5mvwsLDZMcZtBl+2ptCDKNBKFjkGD6GgM
JApDuLFqnE9ZJ3uHxvglOtKGSgfctM/R0ourooLS4rJ7UN3B9s8LySw9hu2HAoPh
kOihlpOGY9lMwFn0CrWckHi2mUUF6mdAahhuLDO9gmjntpOkZQ+00EdEyDW0hDem
KCHarjDvIdrBIu075+2KzXM186Gn/2duk0UCTou+2IT8XRp7vkH0xYT+Xo6OIQUl
r41Nulh3M03AQ/1H0p7k01NfnLLcmpykyQ5YKS0EknBd956BYaElXI9DAQ0zaYed
gKHxNmezk3CAzAD/EkNw
=x56b
-----END PGP SIGNATURE-----

--Sig_/ujG0E8d1HjHoQzVHeWDX=ej--
