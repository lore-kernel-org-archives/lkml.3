Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab3JKJFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:05:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58802 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab3JKJFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:05:18 -0400
Message-ID: <5257BF24.50606@ti.com>
Date: Fri, 11 Oct 2013 12:04:36 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Belisko Marek <marek.belisko@gmail.com>
CC: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1
 LCD.
References: <1381352915-17219-1-git-send-email-marek@goldelico.com>	<525662F5.3090600@ti.com>	<7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com>	<52568B40.4040802@ti.com>	<04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com>	<525699EF.6090803@ti.com>	<52569CE8.5070201@metafoo.de>	<A7739B52-2632-4DD8-924D-B657A6BFE3ED@goldelico.com>	<5256F8DF.2020801@metafoo.de>	<5257815F.5070803@ti.com>	<5257A402.5030806@metafoo.de>	<5570E6D7-4F66-40BE-A50C-6CCA8074BD83@goldelico.com>	<5257B420.10808@ti.com> <CAAfyv36HSb4FOxaYnqcwBusqSuhtVnT0gEAoGgcW_rBkhWhf0A@mail.gmail.com>
In-Reply-To: <CAAfyv36HSb4FOxaYnqcwBusqSuhtVnT0gEAoGgcW_rBkhWhf0A@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="1utLkpKk5dXUtcc2tG8wN6BA56XJJPb4x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1utLkpKk5dXUtcc2tG8wN6BA56XJJPb4x
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/10/13 11:59, Belisko Marek wrote:

>> That's why I won't allow representing this panel as having 4 gpios in
>> the DT data, because that is not correct. The panel has 3 pins. But
>> then, the panel does allow reading, which could be implemented using 4=

>> gpios as you have done. This data should be in the spi-bitbang data, a=
nd
>> the panel should just use the standard SPI framework.
> I disagree. There are different drivers which pass in platform data
> gpios (encoder-tfp410.c or encoder-tpd12s015.c)
> and those must be covered by DT then. I cannot see problem why to have
> for td028 panel 3 or 4 gpios defined in DT.

Yes, they are plain GPIOs, and defined in the spec for the respective
chip. There's no alternative to how they could be represented.

Here, with the td028, the spec speaks of 3 pins for the serial bus. Not
4. So there cannot be 4 gpios defined in the panel's data, that just
doesn't make sense.

Additionally, what we have here are not "normal" gpios, but pins for a
serial bus, 3-wire SPI. If the panel data specifies the gpios, then it's
not possible to use real SPI hardware with the panel.

 Tomi



--1utLkpKk5dXUtcc2tG8wN6BA56XJJPb4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSV78kAAoJEPo9qoy8lh71HyoQAKjMaJqsyyuQmEBSf7Rb6dQo
QPYrmXftJyWHFo1Dgp9Hq4kkwxTpMZnIi4FMSexrOo1BkNpM/2C1qDAu4T9vjDBE
F0jFJpTYW/WYLvNBW7hQ6qkiAcyBWaV/GHIKSe+ENxjz7w+RJ8SKvs+2YUo0Pply
OU8eGZrJr8+ymFHgnHW0NsR3WK79Xq9auLDhRjkjXc//yormKPbSH6bklHuRf0lA
XFMt5CWV/gh+pJWORzv3f/soWmtMq1kdCXjiO43Osj0SuyQ+Ul0R6Ndv/IMNsbsy
o+RKoxK1o1NR0wN2G1bWDVxz3OH76iiNI4Rrn5t9s5qg4ODtwyykif2ahdaF7vfi
nbY5kW9R036saGHbav0m5XEGXbjn74Xypvqr/Slfiv96IUDdn0UJnhS4JYkfx7UY
Sl+quIhijNNWoMftzO1L6+1Uhrwjr4TrMuXm64eu6WB+JwLO+Fz0E9Oyutm17R1y
+FIHkx/9wTC5owLpHXuUymn4uJxJi/0QdhbUKVBKVSPVAgQzz/7qcbdZbWf/Ugmr
8t9RXjFKZNrB5kRMeDp516d4Euah4VG/dxz42gaFaWhBA5HHfLsObXXBKf3TBXM6
VWWhmu+/OvhN8BmbwUBOkfYhs2VzujpfCb3pP5hyFOcxsVymjnZu7kmj3SLhTGDI
fPVDUKgtf4lzgv3Pz+E/
=Q32H
-----END PGP SIGNATURE-----

--1utLkpKk5dXUtcc2tG8wN6BA56XJJPb4x--
