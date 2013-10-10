Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3JJMNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:13:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60446 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3JJMNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:13:42 -0400
Message-ID: <525699EF.6090803@ti.com>
Date: Thu, 10 Oct 2013 15:13:35 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
CC: Marek Belisko <marek@goldelico.com>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1
 LCD.
References: <1381352915-17219-1-git-send-email-marek@goldelico.com> <525662F5.3090600@ti.com> <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com> <52568B40.4040802@ti.com> <04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com>
In-Reply-To: <04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="taGkEPPgMN9Uw9RjrT7KrXWSAAt4tGgdf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--taGkEPPgMN9Uw9RjrT7KrXWSAAt4tGgdf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/10/13 14:52, Dr. H. Nikolaus Schaller wrote:

> Yes, I agree and I am willing to help if someone comes up with such a S=
oC.
> At the moment we have connected it to the OMAP3 only.

True, but even without that kind of SoC, SPI bitbanging should be
handled by an SPI driver, not by the drivers that use the bus.

> I.e. I want not to do a lot of work for others who we just guess about =
that they
> might exist...

Yep. It's fine for me, it's not that much extra code in the panel driver.=


>> The panel hardware has three wires, so the panel driver (if it does
>> handle the bus by bitbanging) can only refer to three gpios.
>=20
> Hm. The panle hardware has 3 but the SoC (OMAP3) the driver
> is running on has 4.

Right, but this panel driver is a driver for the panel hardware. Not for
the SoC, or the SoC+panel combination. So the panel driver must only use
resources as seen by the panel hardware.

>> So either
>> the bus details should be hidden by using the normal spi framework, or=

>> if the driver does the bitbanging, use the gpios as specified in the
>> panel spec. The panel driver cannot contain any board specific stuff.
>=20
> The bitbang driver shown below can handle either 3 or 4 gpios (except
> for initialization).

It's not a bitbang driver, it's a panel driver. And anyway, if I
understood right, your use of 4 gpios was just a hack to try to make it
look like a normal 4-wire SPI bus. What you really have is 3 wires, 3
gpios. I don't see any reason to use 4 gpios, as two of them are the same=
=2E

Hmm, how does it work anyway. Did I understand it right, the panel's
'DIN' pin is connected to two gpios on the SoC, and one of those gpios
is set as output, and the other as input? So the SoC is always pulling
that line up or down, and the panel is also pulling it up or down when
it's sending data. I'm no HW guy but that sounds quite bad =3D).

I've never written or studied a bitbanging driver, but shouldn't there
be just one gpio used on the SoC for DIN, and it would be set to either
output or input mode, depending on if we are reading or writing?

 Tomi



--taGkEPPgMN9Uw9RjrT7KrXWSAAt4tGgdf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSVpnvAAoJEPo9qoy8lh71bSoP/Rt62R1YD0wE3mw0r823mr7F
udUnnwbJ6c+hx6tkugCRaZlCO1rrUulGHOQTPxPqVbLRtN/syECZ0CVFMYid1AXD
lBFFGHsTs8h4mGh7UO5f0eVswLj4Ag3Je0ENy0O2lALw2PnA8AXtpgcBQ95gOzgt
vFMYswh5Rup1LKi2c3x5O/3ymZXAwX8xtULL8onLAWL0Ys39q51aY5tizGiKOYhZ
0GEfAh9UiD/AAZIsy0JRaygSJ4SFdw193/nDmrRxQuvslL2PN539OeAStQjag4wP
BsAO26d4vyFM2hzxsEA1XvjECoB6TVpqs6bmzvwX1LecKMJyS6ZlByqJmA3GrNEB
QBAd+HGxetYwcDsuHtdeTSaJm4SfqctNpqUBz4XLn+rrpjx5BroYYBDPCoFCx8jx
mNoNFFXbg+lXPrwHmaOurO7SAf00roIBG23KD8pPxiVm9EDbSEo4cSw4layuQYKY
NfOpf9idzZD2/mL4ByZ0VWvoHJNR59UlqDkPVlnp/mk/MqbKCNV5ypq45jMtXw/I
eSq8zK2EoZoic+ofiHvrxt8dBHKQ1152WlqeFGpSOaXo5+hW59JLZgdKAETbEjzQ
FlaOJOTNcHcrV7pQE7TlbCxvJ9cA5p6obdW8JiEJIb9cVhAqnGu1gJC34SOpa+eZ
g9Znn4EG6VvvUM7QVQ3F
=ykPE
-----END PGP SIGNATURE-----

--taGkEPPgMN9Uw9RjrT7KrXWSAAt4tGgdf--
