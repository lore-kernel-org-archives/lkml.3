Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaCCICD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:02:03 -0500
Received: from ozlabs.org ([203.10.76.45]:41047 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbaCCICB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:02:01 -0500
Date: Mon, 3 Mar 2014 19:01:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the akpm-current tree with the arm-soc
 tree
Message-Id: <20140303190152.8b87330c0d83679b10c5ca5a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_19_01_52_+1100_uPQEYNs00PxyQYUP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_19_01_52_+1100_uPQEYNs00PxyQYUP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/arm/mach-vexpress/Kconfig between commit 9352b05b6e4e ("ARM: select
MIGHT_HAVE_CACHE_L2X0 for V6 and V7 multi-platform") from the arm-soc
tree and commit b096b0b50c4b ("Kconfig: rename HAS_IOPORT to
HAS_IOPORT_MAP") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-vexpress/Kconfig
index 80b4be36f10a,02930d69f381..000000000000
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@@ -9,8 -10,12 +9,8 @@@ config ARCH_VEXPRES
  	select HAVE_ARM_SCU if SMP
  	select HAVE_ARM_TWD if SMP
  	select HAVE_PATA_PLATFORM
 -	select HAVE_SMP
  	select ICST
- 	select NO_IOPORT
 -	select MIGHT_HAVE_CACHE_L2X0
+ 	select NO_IOPORT_MAP
  	select PLAT_VERSATILE
  	select PLAT_VERSATILE_CLCD
  	select POWER_RESET

--Signature=_Mon__3_Mar_2014_19_01_52_+1100_uPQEYNs00PxyQYUP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFDb1AAoJEMDTa8Ir7ZwVhx8P/RgFcusiq+UUnWTe+Re/X/gh
R1Itw5hNRF2uysidXcoq0NOTPcEV2VQiGrVh0RPEYy5L4WUJHet43ZZt4kT8puwy
GNSdv/llPT8K2J3ebGeDeD45ia1sHwcfm4HCrDyHLrAMfFRusZxlsq22+1RM9cEv
DkRDEI6CrttX6ykYZCYncjLxqsrwch5KhYlWMxV8DuUPm8fimSzwzdRzi5zbR59O
FcptlRjYg4sfpg+lljRJejT2S+rRhZZfLHTXyceUmpyrbJyu+UsrpBX6w4Y4q26c
2Gu+0ai7VLQeCs8mDvHCXQO9JTpoRlK/aPr3PyzF9911Ny7OOg9emBBcu0IFoDOy
64KndWxISU9etpuCeA6Bn3xYVCXk0urrzLaZVpG0ExkUT+G1glOY1F+9UfNqSyX/
k5c0ubb+90WAOKU1qanfofBn2TQyylWjQnrCbE18yLdX6wt7SMR9a4EDG0ny0Tqu
VMVWWEG1IAxNikRXW3CNNb6TCxxWVVIuc/Lqn+VfLYon/MKoj1/THZ6v6CCqB/HC
z8rxGhAni3S8jX6s4K2Zy/DOGEedcae00zGC9jqlT5zbLHTbLoGdInNCE0pWqdzd
foxBx0gRcv5B92rXTBO2omHo/lshnqGsOcJFpD5JmyK4urcAfRJxHly9GsxF2yps
ZetU+i4ATOIavT+33MM0
=CNyM
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_19_01_52_+1100_uPQEYNs00PxyQYUP--
