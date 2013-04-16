Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3DPHA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 03:00:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46776 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3DPHA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 03:00:26 -0400
Date: Tue, 16 Apr 2013 17:00:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bastian Hecht <hechtb@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: linux-next: manual merge of the arm-soc tree with the input tree
Message-Id: <20130416170010.9c2bf713b12fa89e663aea2d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Apr_2013_17_00_10_+1000_=ZTUyzRljqvyc4LN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Apr_2013_17_00_10_+1000_=ZTUyzRljqvyc4LN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/board-armadillo800eva.c between commit
cbaf7f808081 ("ARM - shmobile: Armadillo800EVA: Move st1232 reset pin
handling") from the input tree and commits ead10fed8b4b ("ARM: shmobile:
armadillo: Replace GPIO_PORTx enum with GPIO port numbers") and
0b7d78202260 ("ARM: shmobile: r8a7740: Migrate from INTC to GIC") from
the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/board-armadillo800eva.c
index 881e5c0,81db74a..0000000
--- a/arch/arm/mach-shmobile/board-armadillo800eva.c
+++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
@@@ -890,8 -1000,7 +1009,8 @@@ static struct st1232_pdata st1232_i2c0_
  static struct i2c_board_info i2c0_devices[] =3D {
  	{
  		I2C_BOARD_INFO("st1232-ts", 0x55),
- 		.irq =3D evt2irq(0x0340),
+ 		.irq =3D irq_pin(10),
 +		.platform_data =3D &st1232_i2c0_pdata,
  	},
  	{
  		I2C_BOARD_INFO("wm8978", 0x1a),

--Signature=_Tue__16_Apr_2013_17_00_10_+1000_=ZTUyzRljqvyc4LN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRbPb6AAoJEECxmPOUX5FEB44P/0h9GXU0l4dLlUawrWDu5oNS
L+ohlZEdK3PgRphHsLSOj3CNabmOIQNQM9StvRfU834E5z6XPW5UqrflM8rf4GWl
bFH+flufJIj73YVLD46LDlYzpf6bg6B6oI8MRFuO/X+iNE7DBQy3dkExBD716Afb
FC4i1CeIvCx9cakxM7U/3nJK3tkgsy+nxcftvSXJ6Q8hV72yyWm2EH6kYfLCjs3b
c/pbUr0tj4RUUVUJ2dK75GOR0+S0XanTcsm8XI4BRdLDFZEVFTQ2QBLHQiliuL3t
OCAffEctxyiP3nGiNJUfTkkkpm2/IaAi2KsHLTweUYsct+osiqRl8UZlfXcfed2m
LT0Dui9qN+8/B29nn1J1RloDsntOR2U4PI8VtiAp8omOrydYUYdmt/7OE2CBCty5
Wq58C3tM70m4x0+AW2t/rloQZe4AUoay6AICGYEtlMLJwlR7HQ4LHtRvE9LBV9oT
A1m4Jv8oqwwgU9U7sv+LKwf5IA+OkjmOpAOGNnXUcJY4REuCrC9GyZoROLVUp+RH
vbaEJW4ONAbssGhxs4j7Ax32WVnJbV/IuWOK9jJXEa2fCro7OWAW2C+kAQw/4QbI
d4GwPd5+3FzNztDTr/H5+xsUKmqcszsY+gjv5M0qFFF+j2O5JDQsCpM5E1GSOq9f
KAEwir9Q5RiJvZEXoR0j
=4MBm
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Apr_2013_17_00_10_+1000_=ZTUyzRljqvyc4LN--
