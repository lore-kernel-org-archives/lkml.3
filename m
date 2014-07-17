Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaGQCBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 22:01:14 -0400
Received: from ozlabs.org ([103.22.144.67]:39263 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbaGQCBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 22:01:10 -0400
Date: Thu, 17 Jul 2014 12:01:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-ID: <20140717120101.52a8ce26@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/BYHjb0mCOXgkYBvMQtNAebu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BYHjb0mCOXgkYBvMQtNAebu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/plat-samsung/Kconfig between commit ab275b132a79 ("ARM: s5p:
cut the custom ARCH_NR_GPIOS definition") from the arm-soc tree and
commit 2722091e711f ("ARM: SAMSUNG: Remove remaining legacy code") from
the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-samsung/Kconfig
index 6910c8669742,1091b0a3729a..000000000000
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@@ -65,48 -51,22 +51,6 @@@ config SAMSUNG_ATAG
 =20
  if SAMSUNG_ATAGS
 =20
- # clock options
-=20
- config SAMSUNG_CLOCK
- 	bool
- 	default y if !COMMON_CLK
-=20
- config SAMSUNG_CLKSRC
- 	bool
- 	help
- 	  Select the clock code for the clksrc implementation
- 	  used by newer systems such as the S3C64XX.
-=20
- config S5P_CLOCK
- 	def_bool ARCH_S5PV210
- 	help
- 	  Support common clock part for ARCH_S5P and ARCH_EXYNOS SoCs
-=20
- # options for IRQ support
-=20
- config S5P_IRQ
- 	def_bool ARCH_S5PV210
- 	help
- 	  Support common interrupt part for ARCH_S5P SoCs
-=20
- config S5P_EXT_INT
- 	bool
 -config SAMSUNG_GPIO_EXTRA
 -	int "Number of additional GPIO pins"
 -	default 128 if SAMSUNG_GPIO_EXTRA128
 -	default 64 if SAMSUNG_GPIO_EXTRA64
 -	default 0
--	help
- 	  Use the external interrupts (other than GPIO interrupts.)
 -	  Use additional GPIO space in addition to the GPIO's the SOC
 -	  provides. This allows expanding the GPIO space for use with
 -	  GPIO expanders.
--
- config S5P_GPIO_INT
 -config SAMSUNG_GPIO_EXTRA64
--	bool
- 	help
- 	  Common code for the GPIO interrupts (other than external interrupts.)
-=20
- # options for gpio configuration support
--
- config S5P_GPIO_DRVSTR
 -config SAMSUNG_GPIO_EXTRA128
--	bool
- 	help
- 	  Internal configuration to get and set correct GPIO driver strength
- 	  helper
--
  config S3C_GPIO_SPACE
  	int "Space between gpio banks"
  	default 0

--Sig_/BYHjb0mCOXgkYBvMQtNAebu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxy5hAAoJEMDTa8Ir7ZwVAOYP/A3v2gw5Wnskbdu+l6subxce
7wFvc2/W/ncSOWuQUXdZSvuM1r+bFAiTdCAJwo7Z9+4OZmWfqpt4FtOwQZPdOIXF
iUSLDLXc7osnt2TNlBUGZiVxWCQoP32uDd/3XiUtI6ZmkEfciMixnQS1Nu0nKrFd
B1F5zYko8r5hCppTgXgWLnE+kxU50rzVWUpZ7E2mkE6wvoT6+F9LIZylfAF69uqd
Pp9KrUX55gNib9gF3W+JjU3PY8OLKHaD0NDe7s9voZZ6KmII8iyqiTMrnx/7U2MT
tHnMN0AUUx4tEUS4xWrCRl+SflNvaRW2qmO3OWoXgkZre+/OtTZi71JhE7Gyhk89
AuvjF4LL4fy07pL/DTZ5qstZqKtcLepEoHDPNXwTGr58K+ETmYEdthhxUio3h6d/
0p0F+61xrBxsAD++yd/4T8Ugblq8HWYK5c6VQAsT0/ApfY/1WMNsvxhiQMV6wsUm
koLkX2ld9r6nvAdDMtO/nw7AG/CZpOGxbvfF241vZ87jEbAPOW3TKr5Hour53rkt
td6sk5HFO9L7/dlu10phOxkZLMMseakjIm5d8e+kOhuEuLLWwxDpbgd1S4s8Opef
C+rMNRury9YsfoM7X3RZOeL/q7pd2KHnwrs/4abkMrpNfdLmL8gzxNSDhsGhX5/i
MUKyGQSVUa1i0oG2VB/d
=hKQg
-----END PGP SIGNATURE-----

--Sig_/BYHjb0mCOXgkYBvMQtNAebu--
