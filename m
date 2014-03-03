Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaCCIpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:45:46 -0500
Received: from ozlabs.org ([203.10.76.45]:46772 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbaCCIpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:45:45 -0500
Date: Mon, 3 Mar 2014 19:45:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: linux-next: build failure after merge of the final tree (char-misc
 tree related)
Message-Id: <20140303194536.a9ce403f8e86df43160bfc3e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_19_45_36_+1100_kSJdA+mzafEX8hMX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_19_45_36_+1100_kSJdA+mzafEX8hMX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/iio/adc/men_z188_adc.c: In function 'z188_iio_read_raw':
drivers/iio/adc/men_z188_adc.c:61:3: error: implicit declaration of functio=
n 'readw' [-Werror=3Dimplicit-function-declaration]
   tmp =3D readw(adc->base + chan->channel * 4);
   ^
drivers/iio/adc/men_z188_adc.c: In function 'men_z188_config_channels':
drivers/iio/adc/men_z188_adc.c:91:2: error: implicit declaration of functio=
n 'readl' [-Werror=3Dimplicit-function-declaration]
  ctl =3D readl(addr + Z188_CTRL_REG);
  ^
drivers/iio/adc/men_z188_adc.c:93:2: error: implicit declaration of functio=
n 'writel' [-Werror=3Dimplicit-function-declaration]
  writel(ctl, addr + Z188_CTRL_REG);
  ^
drivers/iio/adc/men_z188_adc.c: In function 'men_z188_probe':
drivers/iio/adc/men_z188_adc.c:126:2: error: implicit declaration of functi=
on 'ioremap' [-Werror=3Dimplicit-function-declaration]
  adc->base =3D ioremap(mem->start, resource_size(mem));
  ^
drivers/iio/adc/men_z188_adc.c:126:12: warning: assignment makes pointer fr=
om integer without a cast [enabled by default]
  adc->base =3D ioremap(mem->start, resource_size(mem));
            ^
drivers/iio/adc/men_z188_adc.c: In function 'men_z188_remove':
drivers/iio/adc/men_z188_adc.c:148:2: error: implicit declaration of functi=
on 'iounmap' [-Werror=3Dimplicit-function-declaration]
  iounmap(adc->base);
  ^

Caused by commit 74aeac4da66f ("iio: adc: Add MEN 16z188 ADC driver")
from the char-misc tree.  Need to include linux/io.h, I think.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__3_Mar_2014_19_45_36_+1100_kSJdA+mzafEX8hMX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFEE2AAoJEMDTa8Ir7ZwVCfsP/3w9Kv0Th2GcheyKaAi6mZwo
RuiqVnrgVKjOW+23j1jOB81aTbUaMXpDCsQ+F8FKyuiufuLLWNhXElebKFKTobwB
8dDSL3GTzu8vIqbPEhD3Mwv55dvMMjwanUD4bWKqyRM+mmeh1Z5InHbOMDvDMr15
WH0IaAMRcavnR3PDALvyA3M3xsEn1w5G90mdgaF8AC8zHw5cC65h3ewwyp6cUJxq
mPU4Ak3wng75e0SKs6tZTTLgojPRqT36NDpnLjrEg9pCTo5A2Q7clA5a7aaYOYdS
t7o2FF3QG96XmFtCdSjY+UAI+e/U0BmRMi5cvs33oNPQX53SkwUQ5DzHoKEccc0c
QJU6KolBIxLXLtSmorxj82cx52e41jVJswUf+k9S5j4eWOCb/6ctM1EXJ34zfmNL
l7Qkl2gn8YDZ+IBcxClRze0/h7armwY/wP/dXcajF+Jt4lX0Fl/VQG/3iVnpVX/j
hv6SvBOF18nzLW27F7BhVQxtzDAJIECGC9n1m7NZ6ZNuSY6dLuXsst0MxyezjHjZ
0F7mQRJEX85PMgV3gRC+9tzmMlv4Sm8+AlQzCXFqrBQBMO8+Q8ls1R2HjzsnSvxX
4uetF7pwVtFNjC6rI4guluLc4ZJrVqvFyLKgRai9i7adu8+WXF8uk4uoucYgd9+s
96ZTyuKs5e+ovP5rN3pl
=igmB
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_19_45_36_+1100_kSJdA+mzafEX8hMX--
