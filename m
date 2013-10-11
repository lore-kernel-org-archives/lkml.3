Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3JKKJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:09:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33726 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234Ab3JKKJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:09:37 -0400
Message-ID: <5257CE55.3090902@ti.com>
Date: Fri, 11 Oct 2013 13:09:25 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Lars-Peter Clausen <lars@metafoo.de>
CC: Belisko Marek <marek.belisko@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1
 LCD.
References: <1381352915-17219-1-git-send-email-marek@goldelico.com> <525662F5.3090600@ti.com> <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com> <52568B40.4040802@ti.com> <04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com> <525699EF.6090803@ti.com> <52569CE8.5070201@metafoo.de> <A7739B52-2632-4DD8-924D-B657A6BFE3ED@goldelico.com> <5256F8DF.2020801@metafoo.de> <5257815F.5070803@ti.com> <5257A402.5030806@metafoo.de> <5570E6D7-4F66-40BE-A50C-6CCA8074BD83@goldelico.com> <5257B420.10808@ti.com> <CAAfyv36HSb4FOxaYnqcwBusqSuhtVnT0gEAoGgcW_rBkhWhf0A@mail.gmail.com> <5257BFA3.9090202@metafoo.de> <B8F44C8A-362C-4E78-BE91-D9C0783B998B@goldelico.com>
In-Reply-To: <B8F44C8A-362C-4E78-BE91-D9C0783B998B@goldelico.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="u3ULf2lU2iPNkLxvIBM23uOHliFiIcV4r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--u3ULf2lU2iPNkLxvIBM23uOHliFiIcV4r
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/10/13 12:50, Dr. H. Nikolaus Schaller wrote:

> Hm. Is this a SPI or does it just look like one? Or is it some - otherw=
ise
> unknown - "3 wire serial interface". Or is it a "3(+1) GPIO slave devic=
e"?
> I am still not sure about this.

Lars-Peter said "Back in the OpenMoko days we used the panel in normal
4-wire SPI mode with the GPIO bitbang SPI master."

I don't know much about SPI, so I can't answer to that. If the serial
bus is indeed not any kind of more or less standard SPI version, but
really a custom bus for this controller, then the case is a bit unclear.

> If we really want to do it correctly, we may have to write a driver for=
 that
> special serial protocol as well. If it turns out that we can't mis-use =
and tweak
> it into a standard SPI driver with bit-bang backend.
>=20
> I simply fear that we get dependencies with the SPI subsystem and have
> to test, debug and maintain it. Maintaining the GPIO thing we currently=
 have
> is easy.
>=20
> What would be against taking the GPIO approach first and then upgrade a=
s soon
> as someone raises his/her finger that he/she wants to really interface =
this display
> differently and is not happy with the 3/4 GPIOs? Either they come up wi=
th a patch
> or contact the driver author (=3Dme).

I don't have anything against that as long as we use only platform data.

But DT data is not an in-kernel API, it's an external API. Once we
define that the DT data for this panel is something, that's it, we
should stick to it. Of course, we can build compatibility layers for old
DT data, but I would avoid that if at all possible.

If we now create the DT data with gpios, and the panel as platform
device, it'd be rather nasty change to make it a child of an spi bus. (I
presume, I have never made such a change).

And, as the gpios and platform device approach is clearly wrong way to
describe the hardware, I'm quite against using that description in the
DT data.

That said, one option is to describe the hardware correctly in the DT
data, but have a platform device for the panel, with panel driver doing
the bitbanging. In that case it is possible to update the system to use
SPI framework if needed, without changing the DT data. However, I'm not
sure how easy that would be.

 Tomi



--u3ULf2lU2iPNkLxvIBM23uOHliFiIcV4r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSV85VAAoJEPo9qoy8lh71DgAP/AnqVBWIgsAhDTk+S/3r+ReD
te5oZeuzHKREeVq5aY5MBXgWedUqrAI1bNip/pUox3g7b0v+fHSf2ONR80ijDynF
YaKeA6MvGAOhmVrpKA3BOP4AK5DEfAK0KQk8tTfjT5Jufe9wk0F92XtqMKEzM50r
mCy/WQ01IxIu7eqMuVGqwbs7uss13TlWqUSs1As9ri1Yhq3CufZY036QZppvDoG1
P7Nbp+PovXyyGepUWban7s/z5+h8P0gISGDKMyLrqv3h3CACG4iG9DCcgK8jNiE8
IFt8XTxk/Nhr/cK6t+QI6/wMsYzdz5tHcFjXMuei16fOgnipAmQGJ4AARRG9I1WG
EhwKFty6qcbCsJOq2uN+DV9UrUXaW/a0NOj+Fe9Ai100RvJx0/dvyWukSZiPgGZk
l+cpBGzCC0JkUo3bGXProu72SUZEG+HZnfcyT4rFWQDzJB8Uf0jKwjMw9Z3QOiZB
LbKmHng2TFSqOQ42UkC1yvrMZEY4EWD2h1R4c70bgga3Z9OcPjHKNj7jVZhB4Ebn
krP/V7HrAqnLbcWbY0Y70Tgysrd/NXdbmk1hs0rhJsl1m/XQb4knf2Sd5WYWXFQ6
WeuFQBtuFtUPFKFv+aq8sK/9CZJkKcOO/AvmHAuptsrS8sfecuazplMVLuXAW666
bV9RuamRmCguHoJYsiW2
=a7eW
-----END PGP SIGNATURE-----

--u3ULf2lU2iPNkLxvIBM23uOHliFiIcV4r--
