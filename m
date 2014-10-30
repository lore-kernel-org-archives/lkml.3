Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591AbaJ3QpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:45:09 -0400
Received: from down.free-electrons.com ([37.187.137.238]:52321 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758841AbaJ3QpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:45:04 -0400
Date: Thu, 30 Oct 2014 17:41:25 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Roman Byshko <rbyshko@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 2/5] ARM: dtsi: sunxi: add common VBUS regulator
Message-ID: <20141030164125.GO21251@lukather>
References: <cover.1414444953.git.rbyshko@gmail.com>
 <210cc2a03d43e3d65b08f302b3b32663044ad94f.1414444953.git.rbyshko@gmail.com>
 <20141028215137.GG9255@lukather>
 <CAMXmWBmU0j_tf_fseDP5p527SaO=iLB-=fKp1PCvE9J6FQk6dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uGrbifh0UoBBidu/"
Content-Disposition: inline
In-Reply-To: <CAMXmWBmU0j_tf_fseDP5p527SaO=iLB-=fKp1PCvE9J6FQk6dw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uGrbifh0UoBBidu/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 29, 2014 at 09:13:50PM +0100, Roman Byshko wrote:
> Hi Maxime,
>=20
> thank you for the review!
>=20
> On Tue, Oct 28, 2014 at 10:51 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Mon, Oct 27, 2014 at 10:43:02PM +0100, Roman Byshko wrote:
> >> Until now the regulator nodes for powering USB VBUS
> >> existed only for the two host controllers. Now the regulator
> >> is added for USB OTG too.
> >> ---
> >>  arch/arm/boot/dts/sunxi-common-regulators.dtsi | 19 +++++++++++++++++=
++
> >>  1 file changed, 19 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/sunxi-common-regulators.dtsi b/arch/arm=
/boot/dts/sunxi-common-regulators.dtsi
> >> index c9c5b10..f521672 100644
> >> --- a/arch/arm/boot/dts/sunxi-common-regulators.dtsi
> >> +++ b/arch/arm/boot/dts/sunxi-common-regulators.dtsi
> >> @@ -21,6 +21,13 @@
> >>                               allwinner,pull =3D <0>;
> >>                       };
> >>
> >> +                     usb0_vbus_pin_a: usb0_vbus_pin@0 {
> >> +                             allwinner,pins =3D "PB9";
> >> +                             allwinner,function =3D "gpio_out";
> >> +                             allwinner,drive =3D <0>;
> >> +                             allwinner,pull =3D <0>;
> >> +                     };
> >> +
> >>                       usb1_vbus_pin_a: usb1_vbus_pin@0 {
> >>                               allwinner,pins =3D "PH6";
> >>                               allwinner,function =3D "gpio_out";
> >> @@ -49,6 +56,18 @@
> >>               status =3D "disabled";
> >>       };
> >>
> >> +     reg_usb0_vbus: usb0-vbus {
> >> +             compatible =3D "regulator-fixed";
> >> +             pinctrl-names =3D "default";
> >> +             pinctrl-0 =3D <&usb0_vbus_pin_a>;
> >> +             regulator-name =3D "usb0-vbus";
> >> +             regulator-min-microvolt =3D <5000000>;
> >> +             regulator-max-microvolt =3D <5000000>;
> >> +             enable-active-high;
> >> +             gpio =3D <&pio 1 9 0>;
> >> +             status =3D "disabled";
> >> +     };
> >
> > We're using these regulators because a huuuge majority of the boards
> > out there, regardless of their SoC, are using the same GPIO to drive
> > the same regulator. Is this the case here? What board have you looked
> > at?
>=20
> Currently I'm developing and testing for Cubietruck. I also have a few
> other boards (with different SoC), I will add corresponding DT nodes
> for them later.
>=20
> As for GPIO which is used to drive the USB0 VBUS pin.
>=20
> $ git remote show origin
> * remote origin
>   Fetch URL: https://github.com/linux-sunxi/sunxi-boards.git
>   Push  URL: https://github.com/linux-sunxi/sunxi-boards.git
> ...
> $ grep -A7 usbc0 -r . | grep usb_drv_vbus_gpio | grep port | sort |
> cut -d: -f2 | cut -d "<" -f1 | sort | uniq -c
>       1 PA16
>       1 PA17
>      67 PB09
>       4 PB10
>       1 PB9
>       1 PC17
>       1 PD25
>       4 PG11
>      21 PG12
>       1 PG13
>       1 PH17
>       4 power4
>=20
> So PB09 is most often used. PG12 is used on (alsmost always) A13. So
> propose to make PB09 default, then override it in sun5i-a13.dtsi and
> later in board dts file if needed.
>=20
> Cubietruck uses PH17. That is why I override PB09 in its dts file.
>=20
> Sounds good?

It does :)

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--uGrbifh0UoBBidu/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUmo1AAoJEBx+YmzsjxAgPtoQAKADIXEYk73Ie2hr01b7S6Sv
OzUtqeCZ0wq7mvKVlu0Lw7m4MeneN9o5jOvpBYvv2W9PetAFgHaeOMIDTslATmLo
3hnzc7QFd30k0i3rvSqoRT8avFMvib7Ggf8WLLiRigoe5gXZJmnsNJCb0EPszshK
WKgaQOu+2IIK+DyI5+Z7SQIJmYxkGvitZ2cegn6Bch0JLX+92pZJmjSXPlmCT6PU
Bgkt4YNDmM0Y1AkGLrIhDLQblMvJPBpTFuNGWkQmrTzuuLGkoWuTeC/1rWk51aOF
y3x+b0dOCQJDZT+oa/n0yBoaPQKnP8zUCKOST4SO2xQTjZIGL9MmSc0u9bgS2oud
QySBp3Op1sHqnkC2G8IeWfzNM9T+aD9oJTipuPkAjWlWZaRP/6tLLlX3aaLyu8Ew
kwKXXux7o6xzh/EfCMDHBumnHEeS6XCeVCUYXAyxpHLjX3ZXIcz25rUGnz0gdUMF
jdKAolml0HhLgwlhNMoH9krTN3vkQCAyn0t9j0OEUGjWkSzJBVkO7NaObuKOZZjm
Xzpkt0PCiZ5/2Jpx3CCFQBQ2hGQEj4DbNnQGzRHngMJTa82mkSAZLMw69GqQGk/b
Aczp74jfEMnv2AOchdiOxgN3FzZc+xHCoPwe/EI3LYT1jzVRZM+It4R8UxBifxgp
Y4BlOyI3Cta4nn5ekGqP
=PGnK
-----END PGP SIGNATURE-----

--uGrbifh0UoBBidu/--
