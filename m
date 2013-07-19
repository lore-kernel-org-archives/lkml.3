Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab3GSDxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 23:53:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41901 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759616Ab3GSDxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 23:53:06 -0400
Date: Fri, 19 Jul 2013 13:52:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (sound-asoc
 tree related)
Message-Id: <20130719135253.2689f6c0e42838f330b60df9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Jul_2013_13_52_53_+1000_ieUgJnBVvj3n1TEg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Jul_2013_13_52_53_+1000_ieUgJnBVvj3n1TEg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

sound/soc/fsl/fsl_ssi.c: In function 'fsl_ssi_isr':
sound/soc/fsl/fsl_ssi.c:181:2: error: implicit declaration of function 'rea=
d_ssi' [-Werror=3Dimplicit-function-declaration]
  sisr =3D read_ssi(&ssi->sisr) & SIER_FLAGS;
  ^
sound/soc/fsl/fsl_ssi.c:296:3: error: implicit declaration of function 'wri=
te_ssi' [-Werror=3Dimplicit-function-declaration]
   write_ssi(sisr2, &ssi->sisr);
   ^
sound/soc/fsl/fsl_ssi.c: In function 'fsl_ssi_startup':
sound/soc/fsl/fsl_ssi.c:331:3: error: implicit declaration of function 'wri=
te_ssi_mask' [-Werror=3Dimplicit-function-declaration]
   write_ssi_mask(&ssi->scr, CCSR_SSI_SCR_SSIEN, 0);
   ^

Caused by commit a1df5c2b310f ("ASoC: imx: Enable COMPILE_TEST builds").

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__19_Jul_2013_13_52_53_+1000_ieUgJnBVvj3n1TEg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR6LgaAAoJEECxmPOUX5FE7T4P/RxSQE22DSRtlcQ+FGLiXwEw
570Tud3KlOvpUw2Uc6vt8wXEzQqUfrX9akUlHLZY3SfCZnsgH2njmVyqW3iprUKl
jMgPvLVRLhs9syTwFNBwclu0HpOwx24TfYEFVzXxlcOqXTXmnPLUOV13fMNbQhBv
jBtuDTtE4ZPe+ja2Qt7MlmbOputs1ZZ1S77cV9zWrIUHnkEQK9HkO4UoEYfwKwDP
LoINr0YkjqxtkbIqKxwNCkBK5bmO/3bzDf3TO+r+Yy5oSBnYhxpzELi/7blE7j6C
12OmehgCqek7OP1ZEZgT6A5HoSZ9f6Z6REeBr2eiBhKFinkp7bEt/EzNnI9rvpsZ
HlgDFjhy9pTUdxQ3lJVS6cfMLvUYMWViUWNBe98v+R5xSH+PNlPdJ18OykDGwZic
dZeWSvIYaNVRc44Fj3GNVnYbeFZIDL+J1DuwgRwDlBROMWvfVZaJnuSFGqn38Jl1
55YkqJi3YgfQgZBKOBs732aFfpJ/12R9qXQrEVTx9i2/C74zfM8UyHT4s56+OX7n
eFsKhfQK6bZX3NlSMOpM4PPgkMMkz2NIaoGi1+h0ugjYbwEsIUhahO34puQMonnW
bdODOcRilgqOvvkwBoPkiG90m/Wg6W8sDDS7CqaLCzD4p4p73Wt8NixZzTgFIGGz
NT4p4imYkn5Uv8sDsBh/
=rieu
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Jul_2013_13_52_53_+1000_ieUgJnBVvj3n1TEg--
