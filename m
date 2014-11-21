Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaKUGYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:24:24 -0500
Received: from ozlabs.org ([103.22.144.67]:44910 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbaKUGYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:24:23 -0500
Date: Fri, 21 Nov 2014 17:24:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the char-misc tree with the arm-soc
 tree
Message-ID: <20141121172412.4caf89cc@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/k6uxQZPRmWsK+5vU4GlSPZ_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/k6uxQZPRmWsK+5vU4GlSPZ_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
arch/arm/mach-omap2/Kconfig between commit 9e1e632c4846 ("ARM: OMAP2+:
Drop board file for ti8168evm") from the arm-soc tree and commit
184901a06a36 ("ARM: removing support for etb/etm in
"arch/arm/kernel/"") from the char-misc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/Kconfig
index 27ec8923ddf6,06020fe77e57..000000000000
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@@ -276,14 -282,16 +276,6 @@@ config MACH_SBC353
  	default y
  	select OMAP_PACKAGE_CUS
 =20
- config OMAP3_EMU
- 	bool "OMAP3 debugging peripherals"
- 	depends on ARCH_OMAP3
- 	select ARM_AMBA
- 	select OC_ETM
- 	help
- 	  Say Y here to enable debugging hardware of omap3
 -config MACH_TI8168EVM
 -	bool "TI8168 Evaluation Module"
 -	depends on SOC_TI81XX
 -	default y
 -
 -config MACH_TI8148EVM
 -	bool "TI8148 Evaluation Module"
 -	depends on SOC_TI81XX
 -	default y
--
  config OMAP3_SDRC_AC_TIMING
  	bool "Enable SDRC AC timing register changes"
  	depends on ARCH_OMAP3

--Sig_/k6uxQZPRmWsK+5vU4GlSPZ_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUbtqSAAoJEMDTa8Ir7ZwVI8wP/3ZHFumpR4/oy+3s6J5H/Q0B
96cZ1IFez6MDyH7ItPDjpxI4UUyetcY8FPtzjysvq6NHxYy50rIg+iFDlfYOPmhI
Ni0dKDuiiboZKcEZQknG2KRmwxfTN0wC3/9+caTK1UO2UIBfS4MbY2s3Y2YVSytr
KCNIOUg9M8ER/SKKfiu2jYmB/RplCL+QHbXC5QUvr10+RZzniEH/Vv4nKyRx7pux
pWpydulgY5+JqhhFjjrYcSx6rymrj4WF511GfTs+K7e3shdNTzA4GvPhnyll2655
j9KJsMnpDdvWC2sEA/bHZCJ3GSWvXaksFedccG7Nztgb1gq5iMAQ9GUzcAf5wODk
WbKdGAHuQkPlpNAJlOCDilGSTsJ/slmiZnL/goKKrK9tAyOP+xl4RMdkQTTn9mRh
5TCUozXepE3iGMXJd9WeiWVPE+jTZPD/NbbbTOf4V0Lus1QA/JsqBCy5RU8hzgc7
3u60VV8BrrVMoYYcAEDGl5hwt5IMsbHDa21pr6Ls6iG3ooOh1OaKlAVP0cyKhWS3
CX7aqSAazOXmHd3hR3HYOgDCwBK9VlFJJUL8Gc+1ym40vxhpd/dqbotgbxo6DTBS
FCeQdZNyVhCpwqorGcLtbSeVNQZr9x4CzcwDGLWz0+XvTJmHAgs+jRJK88Qdnr7v
aJ0PFMoGyooo++K9YRPM
=Ops6
-----END PGP SIGNATURE-----

--Sig_/k6uxQZPRmWsK+5vU4GlSPZ_--
