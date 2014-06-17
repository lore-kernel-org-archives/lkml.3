Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbaFQOUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:20:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46616 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932585AbaFQOUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:20:05 -0400
Date: Tue, 17 Jun 2014 16:18:25 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 15/22] pinctrl: sunxi: Add A23 PIO controller support
Message-ID: <20140617141825.GA3665@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-16-git-send-email-wens@csie.org>
 <20140525190827.GV10768@lukather>
 <CAGb2v670r+imY1PPKXOvLGjHOTzgXaaUqP6SstsvrXFhMozAzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <CAGb2v670r+imY1PPKXOvLGjHOTzgXaaUqP6SstsvrXFhMozAzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 17, 2014 at 06:25:14PM +0800, Chen-Yu Tsai wrote:
> Hi,
>=20
> On Mon, May 26, 2014 at 3:08 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Fri, May 23, 2014 at 03:51:18PM +0800, Chen-Yu Tsai wrote:
> >> The A23 uses the same pin controller as previous SoC's from Allwinner.
> >> Add support for the pins controlled by the main PIO controller.
> >>
> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >> ---
> >>  .../bindings/pinctrl/allwinner,sunxi-pinctrl.txt   |   2 +
> >>  drivers/pinctrl/sunxi/Kconfig                      |   4 +
> >>  drivers/pinctrl/sunxi/Makefile                     |   1 +
> >>  drivers/pinctrl/sunxi/pinctrl-sun8i-a23.c          | 562 ++++++++++++=
+++++++++
> >>  4 files changed, 569 insertions(+)
> >>  create mode 100644 drivers/pinctrl/sunxi/pinctrl-sun8i-a23.c
> >>
> >> diff --git a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi=
-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pi=
nctrl.txt
> >> index d8d0656..93ce12e 100644
> >> --- a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctr=
l.txt
> >> +++ b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctr=
l.txt
> >> @@ -13,6 +13,8 @@ Required properties:
> >>    "allwinner,sun6i-a31-pinctrl"
> >>    "allwinner,sun6i-a31-r-pinctrl"
> >>    "allwinner,sun7i-a20-pinctrl"
> >> +  "allwinner,sun8i-a23-pinctrl"
> >> +  "allwinner,sun8i-a23-r-pinctrl"
> >
> > This last line belongs in the R_PIO patch :)
> >
> >>  - reg: Should contain the register physical address and length for the
> >>    pin controller.
> >>
> >> diff --git a/drivers/pinctrl/sunxi/Kconfig b/drivers/pinctrl/sunxi/Kco=
nfig
> >> index da1e830..17a4281 100644
> >> --- a/drivers/pinctrl/sunxi/Kconfig
> >> +++ b/drivers/pinctrl/sunxi/Kconfig
> >> @@ -32,4 +32,8 @@ config PINCTRL_SUN7I_A20
> >>       def_bool PINCTRL_SUNXI || MACH_SUN7I
> >>       select PINCTRL_SUNXI_COMMON
> >>
> >> +config PINCTRL_SUN8I_A23
> >> +       def_bool PINCTRL_SUNXI || MACH_SUN8I
> >> +       select PINCTRL_SUNXI_COMMON
> >
> > Since it's going to be merged in 3.16, you can just depend on MACH_SUN8=
I.
>=20
> Just want to make sure before I send v2 of the whole series, this should =
be
>=20
>         def_bool MACH_SUN8I
>         select PINCTRL_SUNXI_COMMON
>=20
> correct?
>=20
> Or should it be
>=20
>         bool
>         depends on MACH_SUN8I
>         select PINCTRL_SUNXI_COMMON
>=20
> and MACH_SUN8I selects PINCTRL_SUN8I_A23
>=20
> I'm not sure what the transition plan was.

The former.

>=20
> >>  endif
>=20
> [...]
>=20
> v2 will also have EINT support.

Cool :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToE4xAAoJEBx+YmzsjxAgZT0P/0bJcWdX4ZIW+xz/TMpkc7D1
c/TEvhDSBnu/qgj4VtzsYQ6kccb75zxV9vvp8v/lUnuHyeJ538orJoDzSaoDQWB7
A1a4mT5IH/mer5Sc2+Ij/DlKPIyLwsTSmOh6GRzvC7AjqZyu7uHmCR+6FLrN1b18
oYWeCPFstT/0r0vchWLg/y3vO6jmCOjqXpc6EQHfslApZXthTEKSRX+lho4etbp9
b1ZG/zTC80aAzJwqYkzP/WarqSSRyGZLFzRQ7grCERzjU86MxP/7RFrReR+2pLl/
ix9ZlPVlE+opaFD8TVexXf9Lz7ZrwMq+vHelU0KCFdYJUZ4nRxAbLr7F1zYY4kA2
ldrR41RHmuI8x0i2nEyjM0uh/SGh7O8dGp5f5HKmmHzoNanFMlY2HoMHtp/uVxzT
db0u22QwQNITacgvfRX0X7lGhqFzYQJeN3ivyVAnIBsAgcESRMqcN8Oq4oHtdl2+
LlVW/3tF+vu+K7tvC8tkUU8eGTkPL6ixkak/AK35HkvVOqejzEaDYmei5cfSCowW
788KaEZtrG0BxdTN7EERZYIa/ZMG2OkK0kGDrdBKV6WkeDvz2NzA3VfX2g8OXOlR
VCLTymYgjT9CRVCC1E4k/gUOCTujKPzsdeP3PtoVblpljRm8VM5N2q3oX7CexB2d
Kz9Y4kGaxmTQASW87TS4
=p4vj
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
