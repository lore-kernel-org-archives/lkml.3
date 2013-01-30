Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3A3NhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:37:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52343 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab3A3NhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:37:00 -0500
Date: Thu, 31 Jan 2013 00:36:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Subject: linux-next: manual merge of the arm-soc tree with the pinctrl tree
Message-Id: <20130131003647.daebd2aed733d0304c2c7aa0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_Jan_2013_00_36_47_+1100_JRoLncUhc/Vs+Vyn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Jan_2013_00_36_47_+1100_JRoLncUhc/Vs+Vyn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/pinctrl/pinctrl-nomadik.c between commit e32af8894588
("pinctrl/nomadik: add device tree support") from the pinctrl tree and
commit 6010d40320f8 ("ARM: nomadik: move GPIO and pinctrl to device
tree") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pinctrl/pinctrl-nomadik.c
index 39c1651,ef21a66..0000000
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@@ -2104,7 -1846,11 +2104,11 @@@ static struct pinctrl_desc nmk_pinctrl_
 =20
  static const struct of_device_id nmk_pinctrl_match[] =3D {
  	{
+ 		.compatible =3D "stericsson,nmk-pinctrl-stn8815",
+ 		.data =3D (void *)PINCTRL_NMK_STN8815,
+ 	},
+ 	{
 -		.compatible =3D "stericsson,nmk_pinctrl",
 +		.compatible =3D "stericsson,nmk-pinctrl",
  		.data =3D (void *)PINCTRL_NMK_DB8500,
  	},
  	{},

--Signature=_Thu__31_Jan_2013_00_36_47_+1100_JRoLncUhc/Vs+Vyn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRCSHvAAoJEECxmPOUX5FEhBsQAJUpJpaVhm5GggzZuSmvBBHo
k9OhTqFb/Jf3Aat3+GZU8vpMKjPpO/pjkMw52xspEp15npBzsn5T4RZHW8jLEtc7
S6pRxTVmsfg5XDCH1u6jX1SRz40KfQaIrWLrdWBLiEAivw7TpS1y+Du2xrrc01k0
goII0cznz1AgRuh3SwQ+q2YXL7dYOqicSdIU9ggyTrMukv9nkBJU55Y2a8KcgMVK
K4ZuJ/C+2xYairBreINqpjk3G1xK4y0lKkEl3rYNPQ+cJgvokOYSVVxuoscBUKew
fm3XHk91rNUqq9x4BmmOqtLPxsRKpm8kvFEs9IlXs8LTToM09jTqXm0ciZ+YPcaB
788SQV/dBDS7+tF+72m4xMBOA2/gDSEG/LVLJpf+PosDF9codB/HHVfskBz3DUY2
nykcmoCaARocEoUicxxagWhXVIreqpdq+FIw78htQ8+xjl+6WdSgliNpz5Tng/Mt
ohPmTQ90JPCicSVAZPenj77lmgBEEMrhmmPXF0wM27ySHwmM5se1WFb577PCZxo8
2W4GJ3VKvRBYCwCX/XrT+n5J9iBd5U8cQa23KfHmqALl6cdeDFrP0sWjOrIu4eFy
ZSY7NNyRyzvduvFfW7LL8NzvUIAf3TQ1saXtiOqrQow+13lrjwEcVSt95n27HqG0
kshnQGqad/JW+MSEEA7S
=n65n
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Jan_2013_00_36_47_+1100_JRoLncUhc/Vs+Vyn--
