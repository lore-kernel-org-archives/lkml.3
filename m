Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3ISMuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:50:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49644 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab3ISMuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:50:15 -0400
Date: Thu, 19 Sep 2013 07:49:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: George Cherian <george.cherian@ti.com>, <balbi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: PCF857x and 16-bit GPIO expanders
Message-ID: <20130919124903.GC26101@radagast>
Reply-To: <balbi@ti.com>
References: <20130917190732.GD15645@radagast>
 <CACRpkdYn8yaTyFJMaC3vK4kGrQsaZpAX=pyn5y33ers7QhQ_pg@mail.gmail.com>
 <2356541.62QktiIBr5@avalon>
 <20130918173636.GT21559@radagast>
 <523AB235.1000808@ti.com>
 <523AE8FF.9020209@ti.com>
 <523AEC0C.6010005@ti.com>
 <523AEFD1.8000109@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Content-Disposition: inline
In-Reply-To: <523AEFD1.8000109@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 19, 2013 at 07:36:33AM -0500, Nishanth Menon wrote:
> On 09/19/2013 07:20 AM, George Cherian wrote:
> > On 9/19/2013 5:37 PM, Nishanth Menon wrote:
> >> On 09/19/2013 03:13 AM, George Cherian wrote:
> >>> On 9/18/2013 11:06 PM, Felipe Balbi wrote:
> >>>> Hi,
> >>>>
> >>>> On Wed, Sep 18, 2013 at 07:18:04PM +0200, Laurent Pinchart wrote:
> >>>>> On Wednesday 18 September 2013 13:16:27 Linus Walleij wrote:
> >>>>>> On Tue, Sep 17, 2013 at 9:07 PM, Felipe Balbi <balbi@ti.com> wrote:
> >>>>>>> has anyone ever successfully using gpio-pcf857x.c driver with 16-=
bit
> >>>>>>> gpio expanders ? We're having some issues here where toggling the=
 last
> >>>>>>> gpio pin (gpio 15) on a PCF8575 device causes platform to hang an=
d I
> >>>>>>> can't come up with any explanation of why would it hang...
> >>>>>> Bouncing the question to George, Laurent and Kuninori...
> >>>>> I've got a board with a PCF8575 chip, but it uses I/Os 8 to 14 only=
 as far as
> >>>>> I know.
> >>>>>
> >>>>> I can try toggling I/O 15, but that will need to wait until next we=
ek as I'm
> >>>>> currently travelling without access to the hardware.
> >>>> alright, that'd help me a lot :-) Just want to make sure if we're ha=
ving
> >>>> a board issue, or PCF8575 is a bit screwy ;-)
> >>> Is it on dra7x-evm if so which pcf device (i2c address)?
> >>> The pins i were interested were only 1 and 2 I never tried pin 15.
> >>>
> >>> Just tried toggling through sysfs and it works for me.
> >> When I look at the data sheet for PCF8575[1] Page 7, Figure 4 Write
> >> mode (output)
> >> I see the data writes are of the order:
> >> I2c 1's byte: address
> >> I2c 2'nd byte:P[7-0]
> >> I2c 3rd byte:P[17-10]
> >=20
> > I read it as an octal numbering.
> >> Note: bits 8,9 are missing not supported.
> >=20
> > In octal there is no 8 and 9
>=20
> Where is octal coming into play here? P8 and 9 does not exist as per
> the data sheet -> look at the pinout on page 1[1] ->P00-P17 this is
> exactly what is described on page 2[1]:
> "The number of data bytes that can be sent successively is not limited
> After every two bytes, the previous data is overwritten. When the
> PCF8575 receives the pairs of data bytes, the first byte is referred
> to as P07 =E2=80=93 P00 and the second byte as P17 =E2=80=93 P10. The thi=
rd byte
> is referred to as P07 =E2=80=93 P00, the fourth byte as P17 =E2=80=93 P10=
, and so
> on"
>=20
> For someone reading schematics and setting up the P15, if the person
> uses gpios =3D <&PCF8575 15 OF_GPIO_HIGH>; this will result in offset =3D
> 15, and as a result 0x80 will be send in byte 3, which from h/w point
> of view is P13 which could be controlling something weird!

you missed one detail only. I said GPIO15, not P15 :-) GPIO15 on that
device is P17 ;-)

--=20
balbi

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOvK/AAoJEIaOsuA1yqREXsYQALNFSbwummgoxKKDL8iFOPhF
Gq9sDOVDlOeteyE050i8cKtY9LpiitlScLOh9Mmq/YIvIEHrgQw5Fzm9ezeQa/bM
h/GF/UIHRAIHDhlvCqqqTmVIA2zjKSdQD8OQwNLOgwyqTVVp4/xvwPWhGF7EdJKx
SUSC9ZT2K26ykuuVKPEXwooh1q9PAFJYFnQtvCEARnJP4abQZgGj1uuVV4qFWfs9
eofGMNgxwBk4dR05mxIBfkZBMOXusdts4dSwm2hj8036Xm6va9kYdwzPuZ1at76c
FKEBstM5HRRmXlm0lgcErDOSpMGcFQT2fCpY/kPdYkUac9M27RdT+D6+1L/RqLVt
H8fVee+0XGpn9/FxI/Kk9p1tf6oG82P3SLZX2xDkVDBt76UmCsEk8gAU/vBYoDZA
1WOdnVEFyRaw+uXTO5UfcRduvXV0hCVj2XIH40OJjMUPnWjrH+IeYmWMMIFHHc/p
6YURPKcW65McYXpR2YkPDYFkF0bm+YmWCvMMBYjN9ynaFOIrO8GQaAb+ziA6oeA8
IZ6rDJHBrDqFXHBGfc1RxP6AwFQEmF5Qo5/BpmS4O8Drxh7bagVbxthz1LAojhmx
sBuEgeijrAmXdS6eihLyV7LCteRBkiz6rrQi6fgBFiB1n8/RbSTiYANPiRACceP3
uWCE+zJziNRlQBFg7VAt
=+JQy
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
