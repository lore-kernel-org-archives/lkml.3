Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaLHMF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:05:28 -0500
Received: from ozlabs.org ([103.22.144.67]:53196 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbaLHMF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:05:27 -0500
Date: Mon, 8 Dec 2014 23:05:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: linux-next: build failure after merge of the spi tree
Message-ID: <20141208230517.13ebfe4f@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/EInRbud0xsbbLPnfI7kLexz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/EInRbud0xsbbLPnfI7kLexz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the spi tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/spi/spi-dln2.c: In function 'dln2_spi_copy_from_buf':
drivers/spi/spi-dln2.c:415:4: error: implicit declaration of function 'get_=
unaligned_le32' [-Werror=3Dimplicit-function-declaration]
    *d++ =3D get_unaligned_le32(s++);
    ^

Caused by commit ffb9ad0a47b4 ("spi: add support for DLN-2 USB-SPI adapter"=
).

drivers/spi/spi-st-ssc4.c: In function 'spi_st_remove':
drivers/spi/spi-st-ssc4.c:427:2: error: implicit declaration of function 'p=
inctrl_pm_select_sleep_state' [-Werror=3Dimplicit-function-declaration]
  pinctrl_pm_select_sleep_state(&pdev->dev);
  ^
drivers/spi/spi-st-ssc4.c: In function 'spi_st_runtime_resume':
drivers/spi/spi-st-ssc4.c:453:2: error: implicit declaration of function 'p=
inctrl_pm_select_default_state' [-Werror=3Dimplicit-function-declaration]
  pinctrl_pm_select_default_state(dev);
  ^

Caused by commit cf9e9c98fa8c ("spi: Add new driver for
STMicroelectronics' SPI Controller").

To me COMPILE_TEST means "this builds everywhere, make sure it doesn't
break" ... not "lets set this and see if Stephen finds anything" :-)

I reverted both commits for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/EInRbud0xsbbLPnfI7kLexz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhZQEAAoJEMDTa8Ir7ZwVQmkP/0hxKiWAhcIjKSNO0tfXYllB
7/JIISA0r1jhsCW5Y2TyZWXmZ6t04wv0JwDJ+dqByb8HND3A39XnB2RHgXK/Si5N
gZOORuzz9aKd2sBV8LM7trf+heex1kCsx5UbmuRUOcIZMikg5NzzVuOba0UTO753
f1Mf3yY7u3eKKo9+NArfYCB29CjuwJcClV3X1pouLE0xbARyM7sC278kFcoquoQi
kBzwoE40iLHJ5ujVpG4WzsUQZshd9C8E4kYd17SW3gi+cTp71Og5Ly8UqZ+gnn5o
sndvrG3jlym4PKFh5KU4PLr0+shNmYBGCJ2eu7W0xLqxr1OM0JV0uoxbkbsj0ZBf
ZCJ1pJj7pNKvndigTggayisKPMqC+4m34qvvV9k0ZGsqdlIB0bVkDdbT2RUDgT2z
h6HpvA+9CiNyRF43PvAmFYpXu060A7tBrin+lb3of8KyhLMnVJq7EQREkqkIBfMT
4yTkseepgmX0EusjI8TzU4A0G4pFtKxYs7Jz+8huIY4EWwo7RpEFqxZfjHBXxJgH
BPLzfEe0ogdHUebc0CijJzYGe7Pe/cKG7jun1YtTKVBMeIs60MekGbqgtKlRIYfF
HVeXYvAJGIAwe8p3b/YHSxGMWd5AGbLDiYX8Xmly4MBzGKSl7y/PsLu0++Dhh/+r
TYfT8WyT4PD1LLkYDwxt
=9uXs
-----END PGP SIGNATURE-----

--Sig_/EInRbud0xsbbLPnfI7kLexz--
