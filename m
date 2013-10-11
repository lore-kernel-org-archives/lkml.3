Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3JKElY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 00:41:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50185 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab3JKElW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 00:41:22 -0400
Message-ID: <5257815F.5070803@ti.com>
Date: Fri, 11 Oct 2013 07:41:03 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
CC: Marek Belisko <marek@goldelico.com>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1
 LCD.
References: <1381352915-17219-1-git-send-email-marek@goldelico.com> <525662F5.3090600@ti.com> <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com> <52568B40.4040802@ti.com> <04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com> <525699EF.6090803@ti.com> <52569CE8.5070201@metafoo.de> <A7739B52-2632-4DD8-924D-B657A6BFE3ED@goldelico.com> <5256F8DF.2020801@metafoo.de>
In-Reply-To: <5256F8DF.2020801@metafoo.de>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="9x9VSX3e6dLJt6dBCVpNX6WPeBqmL5WEh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9x9VSX3e6dLJt6dBCVpNX6WPeBqmL5WEh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/10/13 21:58, Lars-Peter Clausen wrote:

> According to the datasheet the the panel as a dedicated dout pin. Maybe=

> you did not connect it in your design, which means you won't be able to=

> read any data from the panel at all.

I don't see a dedicated dout in the datasheet...
http://dl.wolfgang-draxinger.net/openmoko/doc/TD028TTEC1.pdf

> Also your custom bitbang code looks a bit strange:
>=20
>     gpio_set_value(data->dout_gpio, 1);
>     if (gpio_get_value(data->din_gpio) =3D=3D 0)
>         return 1;
>=20
> You set the state on the dout pin and then read the din pin, if both do=

> not match you abort with an error. This suggest that, for whatever
> reason, you feed the dout pin back into the din pin in your design. Btw=
=2E
> this is also the only place where din is used in your driver.

Yes, he said the single "Serial interface data input/output" pin is
connected to both din and dout on the SoC. I guess the purpose of that
gpio_get_value() is to ensure that the panel is not pulling the line
when the SoC is writing to it. Not that I really understand how that can
work, but I'm not a HW guy =3D).

 Tomi



--9x9VSX3e6dLJt6dBCVpNX6WPeBqmL5WEh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSV4FfAAoJEPo9qoy8lh71FqUP/RWOBdaCtbA8frs7yA4340St
i8H7RNlW4F8BEUZEylYYoT0h6KYy8lDcSGcfNJSQM0D7z/1kcyBVXZ8oUXIaJh6w
fXCYSmrD8v7d3DAxNe4pr+GmpMo+i/exxJterDaFBsLJJ69ubwAf+s358C9NSdvo
Iv2m3rNXr0OXWDooqpvyTNSxO9EKBBunr7hG8LE28OBZkKJ3wKw1T9ivUvu55cXp
ZKxxq4sQIHJq0I4cw3AzSMd52u0JQ3nqaQQ6pyCl8LWZg9lq11Bp+SA1jhBd/pak
2SpsDGEHE2Z/SG5bfXpyVXedQpMgAHkDhCe3TNCpkR8IR0dt2fOAW3jnmULeX2gR
49MYFwifQvwECE5Eu7AULMoM+Hg665piZJ2s+g9tA2MLElW+cFTwTTvMqYDJrCXR
7GK+GKzpqMB105PNB/VAkooiwBWpNmPzQEPgtdwV+HvIVGTWOc9JVpE2n+JgDLxu
pmi67rVGRFT5OO06smfSntd/qnM+CL7IRR8lgVxQk7x75sTcXjVRYAOB5fq6dgzk
bdN0wa03WA2M9KsdEWzEig/LvZOEuiZsSDDuizGH1/EC0w1n/1orKAkmvBK6gu9C
4h0KtalVI4BnunsFu1ITOwl6S9n+QZnib1He/pabgkCLMys+5dIFS4Hslb/aV61g
wI6Vz8UEGXzYs+gYu10x
=Wmnq
-----END PGP SIGNATURE-----

--9x9VSX3e6dLJt6dBCVpNX6WPeBqmL5WEh--
