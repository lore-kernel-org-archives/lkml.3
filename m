Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaENHNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:13:18 -0400
Received: from ozlabs.org ([103.22.144.67]:46430 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaENHNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:13:16 -0400
Date: Wed, 14 May 2014 17:13:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: linux-next: build failure after merge of the gpio tree
Message-ID: <20140514171309.64b49a45@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Uq4vHZR_SNk7EjidX3dlKc="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Uq4vHZR_SNk7EjidX3dlKc=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the gpio tree, today's linux-next build (powerpc allyesconfig)
failed like this:

drivers/mfd/stmpe.c: In function 'stmpe_irq_init':
drivers/mfd/stmpe.c:1000:15: error: 'struct stmpe' has no member named 'irq=
_base'
   base =3D stmpe->irq_base;
               ^

Caused by commit 3ba1d516d5fe ("mfd: stmpe: root out static GPIO and
IRQ assignments").

I have reverted that commit for today (and e013a5148882 "gpio: stmpe:
switch to use gpiolib irqchip helpers" that depends on it).

Also, that commit has no Signed-off-by for its committer (Lee).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Uq4vHZR_SNk7EjidX3dlKc=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTcxeKAAoJEMDTa8Ir7ZwVcN4QAJWvs4QxBS5XCTToaFzCsdTz
zvZfn3w4tLtEIkbSJVAcBXvwjESyx7CHXUK9CpXxg4JEWdrwPW1MO1SdmP4O+3Xu
3B3wbGDgmGce/T6OF+eIH1oKTtfC0dgMk42NXXzHOLU3kees48C1jayY4O3k2C0u
AnCdwoTuvPvhfhadO8hKydTRQnicREHV3PW0xsZY1v7w8RjBtOIiHXE4HOd/DYxg
7CG6ZylQvH+Uj0UMOUatHhRawOfZ5ZcnBfk9M9FwMOXU+41MnuKmKh57nKLpIHqT
2bWnbcRNIt2Pl/PbGPkYWRAX6gJZ+pxbNSM1cS0Lpa6tyCMM/4EEtbilYs2h8YdQ
nmWbG1QJMsOlEu2sFh/g4fyvGE83GbZcb9EhXNDlcx0MDivyg2TVjl7gUjUAb/Y4
nWPUUfmYZbceLlaH54n0l2G3jvLzNZnH83XJthZubwHJcnbpImVvUe7KE5Z7guyY
OBA0yZz6coZHggxkEgFWRmMveR4cz7AL4raqPps5BacxQEzdzcY9SsKXEN8MdYmi
tp1Xfz/ADn6sEGdf5dil+FRX1HfszRI3v6pYsVKWp02MyuNQEOlT5JFaoJ8Lpwoy
Z3fvbTKUYlwfifp3PntC+qSmkXd+duSif1P/4SK2+xZhcbxKK53OmQm0JmNrGLb1
gzaTSz11GUd1XEeLywcR
=VMHB
-----END PGP SIGNATURE-----

--Sig_/Uq4vHZR_SNk7EjidX3dlKc=--
