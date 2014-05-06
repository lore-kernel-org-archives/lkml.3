Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbaEFBII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:08:08 -0400
Received: from ozlabs.org ([103.22.144.67]:41506 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933395AbaEFBIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:08:05 -0400
Date: Tue, 6 May 2014 11:07:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: linux-next: manual merge of the mvebu tree with the arm-soc tree
Message-Id: <20140506110758.9ddcae1a0fa3b9548e37bc58@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_May_2014_11_07_58_+1000_e83j0lTiyfYoKEBU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_May_2014_11_07_58_+1000_e83j0lTiyfYoKEBU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
arch/arm/mach-mvebu/Kconfig between commit 55400f3a1f89 ("ARM: mvebu:
clean-up unneeded kconfig selects") from the arm-soc tree and commit
8e6ac2033822 ("ARM: mvebu: enable the ARM SCU on Armada 375 and Armada
38x") from the mvebu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mvebu/Kconfig
index bfc5af18e483,d6b0a772a6dd..000000000000
--- a/arch/arm/mach-mvebu/Kconfig
+++ b/arch/arm/mach-mvebu/Kconfig
@@@ -3,8 -3,10 +3,9 @@@ config ARCH_MVEB
  	select ARCH_SUPPORTS_BIG_ENDIAN
  	select CLKSRC_MMIO
  	select GENERIC_IRQ_CHIP
 -	select IRQ_DOMAIN
  	select PINCTRL
  	select PLAT_ORION
+ 	select SOC_BUS
  	select MVEBU_MBUS
  	select ZONE_DMA if ARM_LPAE
  	select ARCH_REQUIRE_GPIOLIB
@@@ -36,6 -39,10 +37,9 @@@ config MACH_ARMADA_37
  	select ARM_ERRATA_753970
  	select ARM_GIC
  	select ARMADA_375_CLK
 -	select CPU_V7
+ 	select HAVE_ARM_SCU
+ 	select HAVE_ARM_TWD if SMP
+ 	select HAVE_SMP
  	select MACH_MVEBU_V7
  	select PINCTRL_ARMADA_375
  	help
@@@ -48,6 -55,10 +52,9 @@@ config MACH_ARMADA_38
  	select ARM_ERRATA_753970
  	select ARM_GIC
  	select ARMADA_38X_CLK
 -	select CPU_V7
+ 	select HAVE_ARM_SCU
+ 	select HAVE_ARM_TWD if SMP
+ 	select HAVE_SMP
  	select MACH_MVEBU_V7
  	select PINCTRL_ARMADA_38X
  	help

--Signature=_Tue__6_May_2014_11_07_58_+1000_e83j0lTiyfYoKEBU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTaDXyAAoJEMDTa8Ir7ZwVsKIP/ih+ol8xH1ooPM1GVYw5ZBEQ
i/ZI88ssw2/qLBGaSRcNWN1bRvCDO2/kfxwLtbO5a5kxjpUuRM2n9Qr3BqdGdq0h
16M7QlGed2ZswogR1fUgUOjz7PZuuU5sBwKa1128T1ZSqrP6jVytuvSaAIAqZQ4k
YWyByjnaOCrrnFpOf2n5aEusVtSkrC42HYTi9sd0oqMNpGrKYL3Geg7rStoDNFuI
JsvG5AeGVjLC5rtM/90HRZ2J7wSXLCly2y4JkNt6jH7wA5EgzObJfdvVi3H/1+rZ
nnvOC9oW+hdRGnjBlvnFjYGq3ueixXzgxi6Hq8iWQgWkRYgIUiAvMfIVPzMTvuzU
+9pVrnMs1cF64z4m5r2HNusm8oRIykN6Ml9cGxU13lurEG9r/CG6oXDlyl1atsrJ
eh/uYfJq222vz6YPvtcxYCHaASe3IUd4pAJzV/fOahovaH1rLmZdy7x5VcUi8iFd
BoxOphucrDPsg3DMY4L9GoTNeSEhwSKOdk8Fi14LN1V0NV1/ra2kZCwBo6+rSOeJ
KRLkQs8M1SM1ALUIicricax5iPTixEq+BQ3e+QS7+E6LZJOsUUkGWAPhAJWqnHAU
VvMsgTj+xfxm8nE/vKg1+bJDDx/b1T3P4N61+2Cnbk8OdRj38do/gl1bo+JkD+iI
wvT/kAhFPJ6RlufhtZ3n
=lffa
-----END PGP SIGNATURE-----

--Signature=_Tue__6_May_2014_11_07_58_+1000_e83j0lTiyfYoKEBU--
