Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaKDFkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 00:40:32 -0500
Received: from ozlabs.org ([103.22.144.67]:37981 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbaKDFk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 00:40:28 -0500
Date: Tue, 4 Nov 2014 16:40:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: linux-next: build failure after merge of the mfd tree
Message-ID: <20141104164005.1a45ad46@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/TWnCtqxca2B7h=6Z0t2nb3/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TWnCtqxca2B7h=6Z0t2nb3/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the mfd tree, today's linux-next build (powerpc allyesconfig)
failed like this:

drivers/regulator/max77686.c:432:13: warning: 'struct max77686_platform_dat=
a' declared inside parameter list
      struct max77686_platform_data *pdata)
             ^
drivers/regulator/max77686.c:432:13: warning: its scope is only this defini=
tion or declaration, which is probably not what you want
drivers/regulator/max77686.c: In function 'max77686_pmic_dt_parse_pdata':
drivers/regulator/max77686.c:447:7: error: dereferencing pointer to incompl=
ete type
  pdata->num_regulators =3D ARRAY_SIZE(regulators);
       ^
drivers/regulator/max77686.c:448:42: error: dereferencing pointer to incomp=
lete type
  rdata =3D devm_kzalloc(&pdev->dev, sizeof(*rdata) *
                                          ^
drivers/regulator/max77686.c:449:14: error: dereferencing pointer to incomp=
lete type
         pdata->num_regulators, GFP_KERNEL);
              ^
drivers/regulator/max77686.c:455:23: error: dereferencing pointer to incomp=
lete type
  for (i =3D 0; i < pdata->num_regulators; i++) {
                       ^
drivers/regulator/max77686.c:460:3: error: invalid use of undefined type 's=
truct max77686_regulator_data'
   rdata[i].initdata =3D rmatch.init_data;
   ^
drivers/regulator/max77686.c:460:8: error: dereferencing pointer to incompl=
ete type
   rdata[i].initdata =3D rmatch.init_data;
        ^
drivers/regulator/max77686.c:461:3: error: invalid use of undefined type 's=
truct max77686_regulator_data'
   rdata[i].of_node =3D rmatch.of_node;
   ^
drivers/regulator/max77686.c:461:8: error: dereferencing pointer to incompl=
ete type
   rdata[i].of_node =3D rmatch.of_node;
        ^
drivers/regulator/max77686.c:464:7: error: dereferencing pointer to incompl=
ete type
  pdata->regulators =3D rdata;
       ^

And so on ...

Caused by commit 9d5f4c2c748e ("mfd: max77686/802: Remove support for
board files") from the mfd tree.

I reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/TWnCtqxca2B7h=6Z0t2nb3/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWGa7AAoJEMDTa8Ir7ZwVcY0P/RXPwiFBeVlgRdBBqSatw85v
PyFkHIRgdo0aI9y7F6xd3UKO2y9F7GNQni9ge8oIZRB5JRjiFUuGzGDMfwaficI6
ri7/I2aK+WHHwRh34nT1Rpa47i9kOES88z0JKfN0gd3BvRqloIXrgpRVc1MYWLkS
MQ92k3CxndswDO5cU5BRlds1vujcv2umNWMtpQa124jMBp/iFYH8BDlwWN60FNiQ
mEy3GLHrTu2rP7NU4V93ZFJL+l+CDbxLPyuyhwEXiSIiZWGoOuJJSpib0l1mNOnc
TcMKAl+vHb8CQlRyBJXIHPA5Uc6JANEavNDR6xRJk0xpKul4vcZg19rlJFTFudcc
ySXRqc8vwuBMBNPyH1dNJqB+b9BtiPwQP6Ax44QuImX0mfcqMbQFPDGlD2jMrgYC
haP6FFl2T40h8duZX5pUHTi3e6a8KKr1i8lWHMYoOG6QFMj/Q5fLQXCduV4+FTkK
QDFddAAA3kfF6/DlHcGU7RytCrm/qN6fLZUesoMA18eaEhhcxnalACQq2CmWMyZr
tvIt3bgiIY6rVL8yPUy4QdEkPugAQQwy1z2oObBXHCeQsLNb72WTJvyksCvGfJls
cECYv0TlEEao7zqXDx3XOwJdLUX2sukVRUJ/0iGHqnbg+JNjQYUSdHMIXiUNYDVZ
jdBB8YThQqTmGtWjuQxX
=JUus
-----END PGP SIGNATURE-----

--Sig_/TWnCtqxca2B7h=6Z0t2nb3/--
