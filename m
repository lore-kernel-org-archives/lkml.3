Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbbA0FZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 00:25:05 -0500
Received: from ozlabs.org ([103.22.144.67]:50396 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbbA0FZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 00:25:03 -0500
Date: Tue, 27 Jan 2015 16:24:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: linux-next: manual merge of the clockevents tree with the arm tree
Message-ID: <20150127162454.4138ecd8@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/qnI+bpDSe4yC=hkFhWdFYP3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qnI+bpDSe4yC=hkFhWdFYP3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

Today's linux-next merge of the clockevents tree got a conflict in
drivers/clocksource/Kconfig between commit e074ff86e8b4 ("ARM: 8251/1:
clocksource: enable pxa_timer for SA-1100 platform") from the arm tree
and commit e4940cd76934 ("ARM: clocksource: add asm9260_timer driver")
from the clockevents tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clocksource/Kconfig
index 6b6f1e4950df,4f2240c9c145..000000000000
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@@ -232,11 -236,13 +239,20 @@@ config CLKSRC_MIPS_GI
  	depends on MIPS_GIC
  	select CLKSRC_OF
 =20
 +config CLKSRC_PXA
 +	def_bool y if ARCH_PXA || ARCH_SA1100
 +	select CLKSRC_OF if USE_OF
 +	help
 +	  This enables OST0 support available on PXA and SA-11x0
 +	  platforms.
 +
+ config ASM9260_TIMER
+ 	bool "Alphascale ASM9260 timer driver"
+ 	select CLKSRC_MMIO
+ 	select CLKSRC_OF
+ 	default y if MACH_ASM9260
+ 	help
+ 	  This enables build of a clocksource and clockevent driver for
+ 	  the 32-bit System Timer hardware available on a Alphascale ASM9260.
+=20
  endmenu

--Sig_/qnI+bpDSe4yC=hkFhWdFYP3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUxyErAAoJEMDTa8Ir7ZwVKiwP/23qVpZJLYCDSkhtvh8KrJMY
Gmmc6Nqq5GTejIf5co7iDWSlYsK6I15tSGWv8wAo3KBf664aGmYXZvXuliyj9Cae
7PhhvNcBxONure0gh+a0HUyYC4pVw2prVezCJTmFUTTA+iXLUj5zF1J7pvjjSL4u
8doj+B2edjytovsP0bCxmSAbhtWrSqLPi3mXKz+octJCkppcdrGP3bAhwBWbG1rw
sIsoRXiY6IkfXTYYFG1dSdM1VY4IIXDNRPZisDRjAu/GhnnCAeiFn91oUxhtlilX
fskkBhZYhdlRiXl9kDBv1o3nATVzLwskzxQLwB1gHBYDQi0+plnHiUC8z0G/SWGt
ke0tpDQWwdVzvSrlPsAhPTSOHBUHNzptH1V3LdbAt1eCKBPj2nnfD4tdIlU3QXao
rs5ywekvumnrPjR3yG3FFowTHIgOZ8tTa/vMYiMhWYu1sVn40yDhcTjDZnx6rB4j
OFuzBqFay9U03MoFiJfRO4fbpZ/6638QFwQM/nkWFWxYyFo9y/iVxGEfviTAdrPn
CfquRTIgCxdsHKWjSTD83WIvxH5C7pQFDYnVRnUNe6EvzIAR/aPSAzEmxFLss5PQ
jX9ez0NEfyFWUuQxl+NZcgOMJF+MJuiPeWPCD9wps+iKJTsfyNOfuup5nwUSWigx
e8mTqhzAycxuVPeF6Jd6
=7jsQ
-----END PGP SIGNATURE-----

--Sig_/qnI+bpDSe4yC=hkFhWdFYP3--
