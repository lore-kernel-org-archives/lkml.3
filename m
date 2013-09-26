Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3IZKNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:13:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36808 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab3IZKNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:13:41 -0400
Message-ID: <524408BE.40402@ti.com>
Date: Thu, 26 Sep 2013 13:13:18 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Dunn <mikedunn@newsguy.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-pwm@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] pwm-backlight: add support for device tree gpio control
References: <1378236372-15711-1-git-send-email-mikedunn@newsguy.com> <20130910172130.GC22111@ulmo> <523056A6.5060000@newsguy.com>
In-Reply-To: <523056A6.5060000@newsguy.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="NDDlI9o5jwvnxTdFENGHAnXjgNLGIg8Vv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NDDlI9o5jwvnxTdFENGHAnXjgNLGIg8Vv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/09/13 14:40, Mike Dunn wrote:
> On 09/10/2013 10:21 AM, Thierry Reding wrote:

>> Do you have a real setup that actually needs multiple GPIOs? Usually
>> such a setup requires some kind of timing or other additional constrai=
nt
>> which can't be represented by this simple binding.
>>
>> Looking at the Palm Treo code it seems like the reason why multiple
>> GPIOs are needed is because one is to enable the backlight, while the
>> other is in fact used to enable the LCD panel.=20
>=20
>=20
> There are actually four GPIOs involved!  (There is an embarrasingly hor=
rible
> hack in arch/arm/mach-pxa/palmtreo.c that handles the others.)  One is =
almost
> certainly simply backlight power.  The other three are probably LCD rel=
ated.

When you say "power", do you mean the gpio enables a regulator to feed
power to the backlight? If so, wouldn't that be a regulator, not gpio,
from the bl driver's point of view?

Generally speaking, this same problem appears in many places, but for
some reason especially in display. I'm a bit hesitant in adding "free
form" gpio/regulator support for drivers, as, as Thierry pointed out,
there are often timing requirements, or sometimes the gpios are
inverted, or sometimes the gpio is, in fact, a reset gpio, where you'll
assert the gpio for a short moment only.

I haven't seen new versions for the power sequences framework (without
DT support), I think it could help us here a bit by simplifying how we
present the sequences inside the driver. But we still need multiple
drivers or the same driver supporting multiple devices.

And I also think that the model where we have just one driver for, say,
backlight may not be enough. There may be multiple hardware components,
that used together will generate the backlight. And each component
requires specific management.

 Tomi



--NDDlI9o5jwvnxTdFENGHAnXjgNLGIg8Vv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSRAi+AAoJEPo9qoy8lh71yKgP/2Ru08KiKVeLi5TJ2a1T4yqH
6+541TbX0JlvQECfoEJjJ98eZ4eJWGrRwa9Soy3A5WA17CEvM8xk7XXIM/0G8FqE
mMJbSoIX2ccwseuLMwbYTGuPAsWh9yqZLF7hdDZ3nQV2uET02JYcKBili4iK9vzG
g2S3J1mrBQPKAKlj90Vyx8EgCOy/735c/oAaSIEF43PHYmao1E1dwChBXm2U86nr
yFyeDOx6ApVs49jtHQAuXk9lwNccVR/yOP+BLCBQrLm+GD3A0bZApYsn0+YbNoaC
UFsGiUw0IOByLrCqpDtfr7Z9XkZZT1jVgd+SijD4qIrjkHt/JohBGW4OX9KzaocH
F27hKzUOaptGewXEtcv0ICYNUdB6O+6sa67O9ngp0+TfXELrhKoxAvwvSIfMTyhi
WQo5H5BNZ+cW5WSFCfT0/4PXI/PGa+yB0f1U4TWBYz+lYq+cNl+juG7lpzOHRboT
UFOkbIy9sf3vZVuo+/rmkZHM2WffNNxPxsbw4bGDeWxUZVWdGr+xMx4CgltjN2/c
GiePDAH853QSogR/ha8emF2RUzYfTJxSW5rq61iCUxMrIqUE03IzQxaZA47Gm+iU
W6OeKIdaD+osDOEi86RRlBYHX/LA8cPpty8bgWdSX1aVb0hXjW2OvZIahS1LwdOk
ybLKvLfHHU908D4TVB+Q
=OehU
-----END PGP SIGNATURE-----

--NDDlI9o5jwvnxTdFENGHAnXjgNLGIg8Vv--
