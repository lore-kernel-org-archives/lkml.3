Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaLACwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 21:52:50 -0500
Received: from ozlabs.org ([103.22.144.67]:32948 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbaLACwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 21:52:49 -0500
Date: Mon, 1 Dec 2014 13:52:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>, Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the v4l-dvb tree with the arm-soc tree
Message-ID: <20141201135241.435ecb37@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UU+c4Ww2.eAE=OEG+gqaQSV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UU+c4Ww2.eAE=OEG+gqaQSV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
arch/arm/mach-omap2/board-rx51-peripherals.c between commit
e639cd5bfc03 ("ARM: OMAP2+: Prepare to move GPMC to drivers by platform
data header") from the arm-soc tree and commit 68a3c0433077 ("[media]
ARM: OMAP2: RX-51: update si4713 platform data") from the v4l-dvb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-rx51-peripherals.c
index e2ad48b5d9c0,ec2e4101988b..000000000000
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@@ -23,7 -23,7 +23,8 @@@
  #include <linux/regulator/machine.h>
  #include <linux/gpio.h>
  #include <linux/gpio_keys.h>
+ #include <linux/gpio/machine.h>
 +#include <linux/omap-gpmc.h>
  #include <linux/mmc/host.h>
  #include <linux/power/isp1704_charger.h>
  #include <linux/platform_data/spi-omap2-mcspi.h>

--Sig_/UU+c4Ww2.eAE=OEG+gqaQSV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUe9f+AAoJEMDTa8Ir7ZwV0TsP/RkjeAWxRk5NZYhAeikseo4l
LtsYTU9HlBkJvfQ+dJZpwwnieXEu2VtWBL6BoG16eJnEyowCZQUh7xvk2wzjkhiH
0Z/axKaKLcW5buTra6FYeOwrqHvd2BQHAak3T5CqUWPy8GLXt3BZ9XYmJY4WU4m/
vQllAULjFbDvz+41NU+Ij7i6lz3BI9vLtxuJP+YbOaq8DC7Jbh+n0fENGqISQW1T
QznI8nZfWFrd9y1ELWXzOMdlYEuzzzOx8ddVSPmLjP0R4qfwaYhL3X4NlSPs3+fA
JsHUDA6QwqN3nJ+q80s1AABMVg4lAF5fd/WmMHfO/ct+9VJudoSB4yjd+KbdtsBQ
kxHH3gwS4gHReVrtwCTTQ3Wii1UloOIjNeiCMly98im7f9izmp47AIp0EJcSSQXV
5SMdQJOVraLmb7cgwY5dXHiZbjAy5T/j6ofXRcWJagTC72qnA93jez2J5qYeIYLp
fju3k0hpkzY2kgG1rZSQf+0vv/ZA4zAcPaVAkNbNu1hCSaU41qrU2WXTL7SIs+2j
o7APpur7v0xMPiWbqzeu59S6L4OfomHMGg3bFh6kKfaIq6Y3yNPaAGNxs+Zrupj2
oN2vquOM2UfksgBhFCXushNLdzH+RD+0I/zWPBZ5RmGl9Hnnv6pr6y/GzzlwuxzJ
e0KncSsXSRKoL+MuziW9
=jb+I
-----END PGP SIGNATURE-----

--Sig_/UU+c4Ww2.eAE=OEG+gqaQSV--
