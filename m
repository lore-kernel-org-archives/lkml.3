Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaAHEPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 23:15:12 -0500
Received: from ozlabs.org ([203.10.76.45]:47902 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbaAHEPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 23:15:07 -0500
Date: Wed, 8 Jan 2014 15:14:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>, Chris Zankel <chris@zankel.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>, Max Filippov <jcmvbkbc@gmail.com>
Subject: linux-next: manual merge of the gpio tree with the xtensa tree
Message-Id: <20140108151459.d4743129d9cae88865774073@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__8_Jan_2014_15_14_59_+1100_kzhUPIu4Kdwt9pGt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jan_2014_15_14_59_+1100_kzhUPIu4Kdwt9pGt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the gpio tree got a conflict in
arch/xtensa/Kconfig between commit dbacef090841 ("xtensa: add SMP
support") from the xtensa tree and commit a1a2bdec4772 ("gpio: xtensa:
depend on HAVE_XTENSA_GPIO32") from the gpio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/xtensa/Kconfig
index 70a160be3464,f8df0cc70cb6..000000000000
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@@ -64,9 -64,9 +64,12 @@@ config MM
  config VARIANT_IRQ_SWITCH
  	def_bool n
 =20
 +config MAY_HAVE_SMP
 +	def_bool n
 +
+ config HAVE_XTENSA_GPIO32
+ 	def_bool n
+=20
  menu "Processor type and features"
 =20
  choice

--Signature=_Wed__8_Jan_2014_15_14_59_+1100_kzhUPIu4Kdwt9pGt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSzNDHAAoJEMDTa8Ir7ZwVYBEP/j5Wchm5FadSkTn+3ke4uda5
EYTIcVL+IucXtF20Q1wKwM7HrVzOgTDPJoZcvBndDaYoSIvxtn6ZcPUXHjyE8QH9
t2oNNYio5hbx/81Scu3q7gJHnWdElAbeyFyqMxrTs7bdCs1MCXwza0IDRIan8POt
WuNY2Z2KF9DSq6K5p6ZdVLrMNM/AbZoqeHqI/ScJ5H89MFiZZuNrA1Wqv3YgEomp
0nhjVYapxb+eeIBH6EF61Fcj89XrPrMyiqcBeUIOB4ZfYGwzjz3hzP5jzNWyI3hB
t0iNb4KHjrAcxcMyPt7FZcw2Qw8HJLw9byinB4kJAdgXOCnq1Ik2q5lQQ6DMfawL
Bs686cPcRoOE8hOofqqqdFwqoONWgqe7mK6Z8DU2VMZAD/UDtaxJY02Gfzb2kxDz
jc2BquW8fSl6vr2iyJmugd/3duZTO+ORFX7ckb9/IXKuuESM1rYHpIeQYic3GqIy
OJT6nyYuioK9xOkhaxttZ2Ym+u16gEO/9L4yEu+9uvb6WZKKpJOIoD9JDSeVzOA4
0VpM7ilEbU88MUJllGJ6kydy47g7KmpM+slEHAdB5Qu/1Y6DkBEcHUCXn977R90a
mGM/CTvfXGn3LdWd/o4TJSCA4X1QZGPCDbdUvg3Lz52hPFswyqZzsQ+rtqldpNiU
Fmqy5aFjKAiF0zBur9Jp
=cmF7
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jan_2014_15_14_59_+1100_kzhUPIu4Kdwt9pGt--
