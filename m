Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbaFSFUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 01:20:24 -0400
Received: from ozlabs.org ([103.22.144.67]:57488 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbaFSFUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 01:20:22 -0400
Date: Thu, 19 Jun 2014 15:20:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Zhu, Lejun" <lejun.zhu@linux.intel.com>,
        "Yang, Bin" <bin.yang@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: build failure after merge of the mfd-lj tree
Message-ID: <20140619152013.7792c616@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UTRm4N=wO27Q2VoL+PXk4z1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UTRm4N=wO27Q2VoL+PXk4z1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Lee,

After merging the mfd-lj tree, today's linux-next build (powerpc
allyesconfig) failed like this:


drivers/gpio/gpio-crystalcove.c: In function 'crystalcove_gpio_dbg_show':
drivers/gpio/gpio-crystalcove.c:286:3: error: implicit declaration of funct=
ion 'seq_printf' [-Werror=3Dimplicit-function-declaration]
   seq_printf(s, " gpio-%-2d %s %s %s %s ctlo=3D%2x,%s %s %s\n",
   ^

Caused by commit 104fb1d5153c ("gpio: Add support for Intel Crystal
Cove PMIC").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/UTRm4N=wO27Q2VoL+PXk4z1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTonMSAAoJEMDTa8Ir7ZwVma4P/R79Yg9lVCw6k6JwbfK6QZsD
2c7SPqddSXRHQfbTrW1g/ZayucxNbu72l0BntJoTBsRF4oeYDwNSNn6VCUOPvGGK
9EfLFSgoYnJqa71XzKSvygBETi8ODmhfdbL2+N2Xn8Try3jqhbxY4r2u21I+KaaB
C0/K47SN2doJ2P25Ke3+183m3z92ctVkmFFDOtqCcSgg8l7bR166ZUhwLZcwP0I5
bOY8FuPBMM1UOGiigcorM5NzI9oBjvfFz6mbuKjJxkU2CUOSm9HWqUQSVStCEy0b
Y8h+SUeTNkhg2NU5T+DTy66lJvsi6EMBOew2NSqo+cjoIknVIp/aqio0ujy9KAd1
i4PNQKjIPBtSccsKtC5Oibc2ZXfJr+GeiwY5oOtJk6sV8ZM8H5cQlnC4JZG1mH8L
2OAxa28CD/6iTXjbPwEyQSH6td9thPPNb0cMnUVaqE5fttnmV3vENCCxGQ4G5G5P
aJToZhErKx0HTNYuO8L0J2NZ5NNl1RrQt9cEM+6wn/tEpTS8uv+Xo9yGYdTye6Tw
HV10yaldLGRbmAS2EyTRS7Evowp73iy2hnLTdCQqRHT7OxRUm3lnAXFocjL0sgEx
ucq7Os41/WuJoQByW65Nr92+mhAxO1nj5ktLz0UaH7q8Bcuv+/EIfJ/9UVxFHfNa
ZPSXUNFY1K2TzRt759FV
=Bvp3
-----END PGP SIGNATURE-----

--Sig_/UTRm4N=wO27Q2VoL+PXk4z1--
