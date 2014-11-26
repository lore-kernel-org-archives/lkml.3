Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaKZHMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 02:12:35 -0500
Received: from ozlabs.org ([103.22.144.67]:37928 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaKZHMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 02:12:34 -0500
Date: Wed, 26 Nov 2014 18:12:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: linux-next: manual merge of the tty tree with the tty.current tree
Message-ID: <20141126181226.55eb1afe@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7LlzsWQ3/cddZm=WyIiaHgA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7LlzsWQ3/cddZm=WyIiaHgA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/of_serial.c between commit a5e9ab291c60 ("Revert
"serial: of-serial: add PM suspend/resume support"") from the
tty.current tree and commit 513e43858102 ("serial: of-serial: fix up PM
ops on no_console_suspend and port type") from the tty tree.

I fixed it up (I assumed the tty tree version is correct and used that)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/of_serial.c
index f2fde9c21e9b,fd00e2521584..000000000000
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@@ -269,7 -342,9 +342,8 @@@ static struct of_device_id of_platform_
  static struct platform_driver of_platform_serial_driver =3D {
  	.driver =3D {
  		.name =3D "of_serial",
 -		.owner =3D THIS_MODULE,
  		.of_match_table =3D of_platform_serial_table,
+ 		.pm =3D &of_serial_pm_ops,
  	},
  	.probe =3D of_platform_serial_probe,
  	.remove =3D of_platform_serial_remove,

--Sig_/7LlzsWQ3/cddZm=WyIiaHgA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdX1fAAoJEMDTa8Ir7ZwVsSQP/i7FNcw6aoFFWvCLa2uD2Vyf
+/8VqQ3pezZUK7tJswRjJ7JzomZUn79QEWSYFydlIxkEytZSQ7lgYLSUkCwc/WRg
mwxek6D3+niw0qe4Ria+lO7F14YvvdFFKzSGSmszKPgk0zT2rx+UL/pdN5UF422W
sZNGy13ouUdaFYPokK2CIrjpMHTSj+IpLCEXu/I1rORIg8vpVufmBXlBbkeysJZT
cA9F0BjctzytUDfiyzGF6nTk8ZAlB1uOnnWzedwoXiz7VeeriF+IrEw9PiJr3AHg
57Of3w3Tf9Ki4KXldGpqMeRt2JmqtPiPiqFCUV+mh/3lZUyIr3KDoc4AOxU5wu5P
EJ65h4HyMj5+1TzEtb1SNvO6e6avAw3/PHdBecCMXNvmwyavodnI/+4NTvNlw6sK
lbweDSThc1av53OS59YvjnmFrBgAImPRsHss1iVYyxXqyusPZCQraLEnmPngEwtI
1SpiC85FscB5OWrOTeTmfaQ80P/5iWeGd0dX0Unltw5ALCbVhA9OaJhtHTdZdOLs
jfLMqg8sTbH0ZOveOrlEDhqgsYZPgcJaE3iAnUVFsM7Tots6JcF3+qPX11zRyNUq
EOx0aUREKyp14D9/m3EFpiFjeocoePx0T0T7FeM9mSj7dOSuQ8+KKdK+d0PsbhGW
ch7zUeobeqFn4lu4qzdh
=9UGd
-----END PGP SIGNATURE-----

--Sig_/7LlzsWQ3/cddZm=WyIiaHgA--
