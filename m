Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3HAMkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:40:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52638 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab3HAMj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:39:59 -0400
Message-ID: <51FA56FF.8090308@ti.com>
Date: Thu, 1 Aug 2013 15:39:27 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <hector.palacios@digi.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCHv3 3/3] fb: backlight: HX8357: Add HX8369 support
References: <1375346437-18991-1-git-send-email-maxime.ripard@free-electrons.com> <1375346437-18991-4-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1375346437-18991-4-git-send-email-maxime.ripard@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="2MpgVLSBJJ2CHwp5UT3gBgbKE9GqBat9n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2MpgVLSBJJ2CHwp5UT3gBgbKE9GqBat9n
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 01/08/13 11:40, Maxime Ripard wrote:
> From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>=20
> Add support for the Himax HX8369 controller as it is quite similar to t=
he
> hx8357.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>=

> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/hx8357.c | 219 +++++++++++++++++++++++++++++++=
+++++---
>  1 file changed, 204 insertions(+), 15 deletions(-)

I don't have comments about this patch as such, but hx8357.c in general:

- The commands used look like MIPI DCS commands. We have defined those
in include/video/mipi_display.h.

- The command arrays could be const

- I don't like command arrays. Rather than having array for
"HX8357_SET_COLUMN_ADDRESS, 0x00, 0x00, 0x01, 0x3f,", I'd much more like
a function hx8357_set_column_address(int x1, int x2) or such.

- Looking at the driver makes me think it resembles very much the panel
driver(s) we have for OMAP. If only CDF was ready... ;)

Those said, I don't see a problem with applying this. We could clean up
later those things mentioned above, but maybe it's better to do that
when moving to CDF.

For this and the two other patches:

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

I can apply these to my 3.12-fbdev branch some day soon, if
Jean-Christophe hasn't come back yet (I'd normally rather deal only with
trivial patches, and leave the rest to Jean-Christophe).

 Tomi



--2MpgVLSBJJ2CHwp5UT3gBgbKE9GqBat9n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR+lb/AAoJEPo9qoy8lh71sygQAIq9l45+5Vum/+aPVoxg9xT+
9/nxPTJiqaEfYEz3fQJdxioWyCVo4f5va8nV/iRsR227DuFlFjTOD5b8oZRaIa4u
Ccc8CxVjFpHkEvV1IATlJ6+ruSb4zUcV6MVQE6wQzqOpvH7HPzDUItd7kQCpAKAy
pc9Ftrt1v6vdOJBJ81clqTDKytMdNHe0UesfxpnviHfXTOO14Xo89cTf22JI9N5F
wqVYgozr2Hz4R2U1aowB7mTpZlCEE+jJrr4q0Udc/W5awC2UiCISVPtSSNr1wXUl
2CB5WAQaz6mn71pKhQbEwlCWvfueAP8kazc/far7QJsSxE7GK3PCXzs/HqoVI0SL
sZd1LTmxqTfOYc+TRDcp/hlyfrsPQMKKYlkUb1ndir3G3icBHM7IfMmGImOIdcYx
6/suh2MfZbbGaMQYkJZf31C4s5jGPHG6eQIVy60XDOGzh8+vqNGq5IfJDdqAJQjM
wL0Ia09ZMFD5OWhzLZy55I+RIaLThYJ91u0g2kSUHNxKKv++6i2p1fdXZaRa6W5H
m08g4enD9hZ4VoSlLO8v/QM0NITvmaqYMft4o38QvyLziFuKqJFF7L5pPcMTexRz
YIqtwU44XuL1fIq7poLecIvQLssEYbIdeeqAebGgAkqUpKJXVYORA/YEQ86D8/nS
jNuK3+thOvVQ5XUarXnE
=N1cE
-----END PGP SIGNATURE-----

--2MpgVLSBJJ2CHwp5UT3gBgbKE9GqBat9n--
