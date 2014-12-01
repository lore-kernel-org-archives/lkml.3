Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaLAAGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 19:06:20 -0500
Received: from ozlabs.org ([103.22.144.67]:60107 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbaLAAGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 19:06:18 -0500
Date: Mon, 1 Dec 2014 11:06:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Naveen Krishna Ch <naveenkrishna.ch@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: linux-next: manual merge of the samsung tree with the  tree
Message-ID: <20141201110610.2126988c@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vcOAvF9O7BQS_2jmDbhHXQU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vcOAvF9O7BQS_2jmDbhHXQU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm64/Kconfig between commit 419043609689 ("arm64: amd-seattle:
Adding device tree for AMD Seattle platform") from the arm-soc tree and
commit ab93f6ca6394 ("arm64: Enable ARMv8 based exynos7 SoC support")
from the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/Kconfig
index 44cb996e3cd7,7351199f0a42..000000000000
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@@ -142,11 -142,23 +142,28 @@@ source "kernel/Kconfig.freezer
 =20
  menu "Platform selection"
 =20
 +config ARCH_SEATTLE
 +	bool "AMD Seattle SoC Family"
 +	help
 +	  This enables support for AMD Seattle SOC Family
 +
+ config ARCH_EXYNOS
+ 	bool
+ 	help
+ 	  This enables support for Samsung Exynos SoC family
+=20
+ config ARCH_EXYNOS7
+ 	bool "ARMv8 based Samsung Exynos7"
+ 	select ARCH_EXYNOS
+ 	select COMMON_CLK_SAMSUNG
+ 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
+ 	select HAVE_S3C_RTC if RTC_CLASS
+ 	select PINCTRL
+ 	select PINCTRL_EXYNOS
+=20
+ 	help
+ 	  This enables support for Samsung Exynos7 SoC family
+=20
  config ARCH_THUNDER
  	bool "Cavium Inc. Thunder SoC Family"
  	help

--Sig_/vcOAvF9O7BQS_2jmDbhHXQU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUe7D4AAoJEMDTa8Ir7ZwV2MUP/1nAtjr7dLJxIELFEClRi5VS
3Fdmbkydtzt2S0/CB18F6DpgULDBREiHqJivQZF2LiCuvUj/gwwK6hsOgWYIhR1q
9Lu7mF/H8I7FDbTiFrNipNbQI03Eu2rX3cxarWZvtf8h7R2fPDzSY1YcyCDH/BRd
QVEmL1YBwGITk3nsF+3VVNRDsCz3uIkX9gVwC5v33EYIgAPQ8je+T12DydK2J3yQ
ZQpgYVq1rjAbHWe4P1VLbxIoLoTXlM/8BR+rzULsUibI4LO5RDpwRwd9omXAoA1h
vhuvZFXkVfUHwL6SZxmkBThaxdd+ysEgkIqcJt36tLXHHzjlP7c7MYxbWnujWeWK
EI5tWE57zqZ3aOYtCzNluJPWRUR7m8Q0OXFzvzAR2gGHK0k2wVuw0pkNuFd7/GuW
+hzTg2AFj5Obi69tLxTnqlwPptPk+WPNl4Xw0V5Bpt5iOSrRVbkgY3meHLLrcBSX
MvajV9jVgfe6Qq4ZstGVw+CyJtUQm4/2F03GiCBMIxzlykxmtGNo7WfxTroyPd9V
zM0E7pzX+QmeoguPE4v0Gd1G1bUv4grUYQVr6osKa9Y6lJeSEP0u+uVhviwR4k+4
KH311u9ctMl8hKex3IYPNSk3ylBD395mK/lMygdR0mGQDZPF7ECOlmnt+PYWXiqE
Hy0a/MZ7n3wXoRMbA5Z9
=ZigC
-----END PGP SIGNATURE-----

--Sig_/vcOAvF9O7BQS_2jmDbhHXQU--
