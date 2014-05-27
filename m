Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaE0IZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:25:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41616 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752074AbaE0IZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:25:05 -0400
Date: Tue, 27 May 2014 10:22:16 +0200
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
Subject: Re: [PATCH 22/22] ARM: sun8i: dt: Add Ippo-q8h v5 support
Message-ID: <20140527082216.GD4730@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-23-git-send-email-wens@csie.org>
 <20140525193955.GB10768@lukather>
 <CAGb2v64EHLsj-cy13yf28K8vkTJUCv95q=x-7c2yiHQ=uBm-sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Content-Disposition: inline
In-Reply-To: <CAGb2v64EHLsj-cy13yf28K8vkTJUCv95q=x-7c2yiHQ=uBm-sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 12:23:09PM +0800, Chen-Yu Tsai wrote:
> On Mon, May 26, 2014 at 3:39 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Fri, May 23, 2014 at 03:51:25PM +0800, Chen-Yu Tsai wrote:
> >> The Ippo-q8h is a tablet circiut board commonly found in cheap Android
> >> tablets with A23 SoCs. There are at least 2 versions of the board, with
> >> different peripherals, such as WiFi chips.
> >>
> >> This patch add supports for v5 of such boards, which has a ESP8089 WiFi
> >> chip (not supported) connected to mmc1.
> >>
> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >> ---
> >>  arch/arm/boot/dts/Makefile                  |  2 ++
> >>  arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts | 51 ++++++++++++++++++++=
+++++++++
> >>  2 files changed, 53 insertions(+)
> >>  create mode 100644 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
> >>
> >> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> >> index 6967393..f809a53 100644
> >> --- a/arch/arm/boot/dts/Makefile
> >> +++ b/arch/arm/boot/dts/Makefile
> >> @@ -354,6 +354,8 @@ dtb-$(CONFIG_MACH_SUN7I) +=3D \
> >>       sun7i-a20-cubietruck.dtb \
> >>       sun7i-a20-i12-tvbox.dtb \
> >>       sun7i-a20-olinuxino-micro.dtb
> >> +dtb-$(CONFIG_MACH_SUN8I) +=3D \
> >> +     sun8i-a23-ippo-q8h-v5.dtb
> >>  dtb-$(CONFIG_ARCH_TEGRA) +=3D tegra20-harmony.dtb \
> >>       tegra20-iris-512.dtb \
> >>       tegra20-medcom-wide.dtb \
> >> diff --git a/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts b/arch/arm/bo=
ot/dts/sun8i-a23-ippo-q8h-v5.dts
> >> new file mode 100644
> >> index 0000000..7d0bd97
> >> --- /dev/null
> >> +++ b/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
> >> @@ -0,0 +1,51 @@
> >> +/*
> >> + * Copyright 2014 Chen-Yu Tsai
> >> + *
> >> + * Chen-Yu Tsai <wens@csie.org>
> >> + *
> >> + * The code contained herein is licensed under the GNU General Public
> >> + * License. You may obtain a copy of the GNU General Public License
> >> + * Version 2 or later at the following locations:
> >> + *
> >> + * http://www.opensource.org/licenses/gpl-license.html
> >> + * http://www.gnu.org/copyleft/gpl.html
> >> + */
> >> +
> >> +/dts-v1/;
> >> +/include/ "sun8i-a23.dtsi"
> >> +
> >> +/ {
> >> +     model =3D "Ippo Q8H Dual Core Tablet (v5)";
> >> +     compatible =3D "ippo,q8h-v5", "allwinner,sun8i-a23";
> >> +
> >> +     chosen {
> >> +             bootargs =3D "earlyprintk console=3DttyS0,115200";
> >> +     };
> >
> > You should probably add the memory node here too.
>=20
> OK.
>=20
> >> +
> >> +     soc@01c00000 {
> >> +             uart0: serial@01c28000 {
> >> +                     pinctrl-names =3D "default";
> >> +                     pinctrl-0 =3D <&uart0_pins_a>;
> >> +                     status =3D "okay";
> >> +             };
> >> +
> >> +             i2c0: i2c@01c2ac00 {
> >> +                     pinctrl-names =3D "default";
> >> +                     pinctrl-0 =3D <&i2c0_pins_a>;
> >> +                     status =3D "okay";
> >> +             };
> >> +
> >> +             i2c1: i2c@01c2b000 {
> >> +                     pinctrl-names =3D "default";
> >> +                     pinctrl-0 =3D <&i2c1_pins_a>;
> >> +                     status =3D "okay";
> >> +             };
> >
> > What are the two i2c busses wired to?
>=20
> i2c0 has the capacitive touch panel controller gsl1680 @ 0x40.
>=20
> i2c1 has something (gsensor maybe) connected @ 0x15.
> The FEX file lists the gsensor on i2c1, but with the address as 0x18.
> I may need to boot back to stock Android to figure it out.
>=20
> i2c2 has the camera sensor (GC0309) control connected to it @ 0x66.
> I didn't list it because I overlooked it, and i2cdetect hangs.
> It seems to need AXP PMIC support to activate the regulators.
>=20
> AFAIK, the kernel doesn't have drivers for these devices,
> so how would we list them?

We don't need to list them yet. We can just wait for the drivers, it
was just out of curiosity.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThEs4AAoJEBx+YmzsjxAgfpYP/R0OjC8+UkOsZ/SuC/cGmS2Z
ocnz0z1qkoRwCv3dNV93lo5OhFBjyDrgioXYHVzQ2dzjZDcxfGkJvKfnvGJAF12J
8WS3g2+D7QOTAKfVWxOQcO4Fd+t0S+hZmQOAU6IVYSQjnKCoJAXVCCxfYKF8WH3W
olYWjR1NxLr5FoAyOZfcngHInKDujT+yyrtHnLhSZ/3CWYYva0YqQUuhgf+niEDc
L3ZyYphq8h05E2VXlTEHtMq+M4S0Iaa1WdRPZkFQsjZSvIvqR12yGDSXURyJIKiz
gMnszdbh6ufMAic/xffOzJtyacSGecPdpjyNxGKq6nQbmnE5evaSuSqqvbMAGrHh
KuixGccvNjklsMb8li8EIPaoZ3X/uVXghirHqsl96gyucXbbAtj12SYlI4OIgVWV
wkKbHR/TefukV3Zcz1Vn8bCXBh6JLosTBwuVWmJeCF8S0b2BiFD78/+HKUb4vSSR
qI3vGCfYqJ9HuvL2/gLM/iBKkeyiMusDBZE4fH/0aUC4bsuvPzWQYO5DP8dgpMhj
PYJR39PnbkAAzLFnaKN2k/6XQ+DCLF7LgWv+zW8zHuVfX1mPBjLFEfRUzJd55Jai
W6IC1uST3g3r1fo8Q7ik5ubYsLV3KDyvFH/psfG9JIx8XSzA5EyJ70ey1HEfBRa+
L+d+2x1Ypu7ZjcoHfMd4
=MJF0
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
